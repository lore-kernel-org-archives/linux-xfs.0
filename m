Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3JDrYWw067622 for <xfs@oss.sgi.com>; Thu, 19 Apr 2012 08:53:35 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CcsfA7OTrIUgc2mh for
	<xfs@oss.sgi.com>; Thu, 19 Apr 2012 06:53:33 -0700 (PDT)
Message-ID: <4F9018D5.4050202@redhat.com>
Date: Thu, 19 Apr 2012 15:53:25 +0200
From: Tom Marek <tmarek@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3 V2] xfstests 198, 240, common.rc: added check for
	aiodio-sparse2
References: <y> <1334654687-25450-1-git-send-email-tmarek@redhat.com>
	<1334654687-25450-2-git-send-email-tmarek@redhat.com>
	<20120418235135.GS6734@dastard>
	<alpine.LFD.2.00.1204191029220.4508@dhcp-27-109.brq.redhat.com>
In-Reply-To: <alpine.LFD.2.00.1204191029220.4508@dhcp-27-109.brq.redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Lukas Czerner <lczerner@redhat.com>
Cc: dchinner@redhat.com, xfs@oss.sgi.com

On 04/19/2012 10:32 AM, Lukas Czerner wrote:
> On Thu, 19 Apr 2012, Dave Chinner wrote:
>
>> On Tue, Apr 17, 2012 at 11:24:46AM +0200, Tom Marek wrote:
>>> Tests number 198 and 240 could fail when aiodio-sparse2 was not build.
>>> _require_aiodio helper was added to common.rc file to fix this.
>>>
>>> Cc: david@fromorbit.com
>>> Signed-off-by: Tom Marek<tmarek@redhat.com>
>>> Reviewed-by: Lukas Czerner<lczerner@redhat.com>
>> .....
>>> @@ -770,6 +770,14 @@ _require_scratch()
>>>       fi
>>>   }
>>>
>>> +# this test needs aio-dio-regress to be built
>>> +#
>>> +_require_aiodio()
>>> +{
>>> +    [ -x $here/src/aio-dio-regress/aiodio_sparse2 ] || \
>>> +        _notrun "This tests requires src/aio-dio-regress/ to be built"
>>> +}
>> This function already exists in common.rc, which is why I pointed it
>> out for use.
>>
>> # this test requires that a (specified) aio-dio executable exists
>> # $1 - command (optional)
>> #
>> _require_aiodio()
>> {
>>      if [ -z "$1" ]
>>      then
>>          AIO_TEST=src/aio-dio-regress/aiodio_sparse2
>>          [ -x $AIO_TEST ] || _notrun "aio-dio utilities required"
>>      else
>>          AIO_TEST=src/aio-dio-regress/$1
>>          [ -x $AIO_TEST ] || _notrun "$AIO_TEST not built"
>>      fi
>> }
>>
>> Cheers,
>>
>> Dave.
> Hi Tom,
>
> did you use the git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
> repository for the xfstests ? The one I've been using (from
> oss.sgi.com) is terribly out of date so it does not have
> _require_aiodio() yet.
>
> Thanks!
> -Lukas
Hi Lukas,

unfortunately I was using that old repository on oos.sgi.com.
Thanks!

T.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
