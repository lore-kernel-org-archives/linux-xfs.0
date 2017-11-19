Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37754 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750744AbdKSEX2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 18 Nov 2017 23:23:28 -0500
Subject: Re: Illegal value 0 for -l sunit option ?
References: <alpine.DEB.2.10.1711181547110.14549@gozora.sk>
 <20171118215140.GL5858@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <45307a2e-9233-e463-dcad-5b91e5234f4e@sandeen.net>
Date: Sat, 18 Nov 2017 22:23:26 -0600
MIME-Version: 1.0
In-Reply-To: <20171118215140.GL5858@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Vladimir Gozora <c@gozora.sk>
Cc: linux-xfs@vger.kernel.org

On 11/18/17 3:51 PM, Dave Chinner wrote:
> On Sat, Nov 18, 2017 at 04:00:08PM +0100, Vladimir Gozora wrote:
>> Hello XFS team,
>>
>> I'm working on ReaR project (https://github.com/rear/rear) which
>> aims for bare-metal disaster recovery.
>> Lately I’ve run across behavior of mkfs.xfs which I don’t really
>> know if is correct or not.
>> The thing is that when I try to create XFS file system with
>> xfsprogs-4.5.0 following commands runs just fine:
>> mkfs.xfs -f -i size=512 -d agcount=4 -s size=512 -i attr=2 -i
>> projid32bit=1 -m crc=1 -m finobt=1 -b size=4096 -i maxpct=25 -d
>> sunit=0 -d swidth=0 -l version=2 -l sunit=0 -l lazy-count=1 -n
>> size=4096 -n version=2 -r extsize=4096 <destination>
>> when I try same command with xfsprogs-4.10.0, I get following error:
>> Illegal value 0 for -l sunit option. value is too small
> 
> Yup, old mkfs would accept values that were illegal and could do
> completly unpredictable things with them. We tightened up the input
> parsing to only accept valid values xfsprogs in 4.7.0, and in
> particular this commit is relevant:
> 
> commit 2942ff49bdb6df08fb56674215b31c07cfc7c1fd
> Author: Jan Tulak <jtulak@redhat.com>
> Date:   Tue Jun 21 12:52:22 2016 +1000
> 
>     mkfs: fix -l su minval
>     
>     -l su should be in range BBTOB(1) <= L_SU <= XLOG_MAX_RECORD_BSIZE,
>     because the upper limit is imposed by kernel on iclogbuf: stripe
>     unit can't be bigger than the log buffer, but the log buffer can
>     span multiple stripe units. L_SUNIT is changed in the same way.
>     
>     Signed-off-by: Jan Tulak <jtulak@redhat.com>
>     Reviewed-by: Eric Sandeen <sandeen@redhat.com>
>     Signed-off-by: Dave Chinner <david@fromorbit.com>

Honestly, the minimum changed before that - the commit below fixed an
incorrect minval of XLOG_MIN_RECORD_BSIZE (16k) to "1" -
which honestly doesn't make much sense to me.

It was 1974d3f1a6495978419d931020f63c9cac8ba230 which changed
it from accepting min 0 to accepting min XLOG_MIN_RECORD_BSIZE:

                { .index = L_SUNIT,
+                 .minval = BTOBB(XLOG_MIN_RECORD_BSIZE),
+                 .maxval = BTOBB(XLOG_MAX_RECORD_BSIZE),
                  .defaultval = SUBOPT_NEEDS_VAL,
                },

...

                                case L_SUNIT:
-                                       if (!value || *value == '\0')
-                                               reqval('l', subopts, L_SUNIT);
                                        if (lsunit)
                                                respec('l', subopts, L_SUNIT);
-                                       lsunit = getnum(value, 0, 0, false);
-                                       if (lsunit < 0)
-                                               illegal(value, "l sunit");
+                                       lsunit = getnum_checked(value, &lopts,
+                                                                L_SUNIT);
                                        lsunitflag = 1;
                                        break;

Specifying "0" as a value to mean "no stripe" is how I always
interpreted these things.  Not to mention that D_SUNIT accepts 0
without complaint, and  it's further compounded/confusing by xfs_info
reporting a stripe unit of 0 blocks, something it won't accept on a mkfs
commandline?  Makes little sense.

I'm not really convinced that a minval of 1 is correct.  The commitlog
changes the minval but speaks only to the rationale for the maxval, so
it's no help.

-Eric
