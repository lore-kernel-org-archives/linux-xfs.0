Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8670FC433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Dec 2021 22:43:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237871AbhLFWrJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Dec 2021 17:47:09 -0500
Received: from sandeen.net ([63.231.237.45]:41108 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351120AbhLFWrI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 6 Dec 2021 17:47:08 -0500
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 21F1817DC7;
        Mon,  6 Dec 2021 16:43:32 -0600 (CST)
Message-ID: <76f4c73d-6251-2a66-84d8-5807c9b52c29@sandeen.net>
Date:   Mon, 6 Dec 2021 16:43:37 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <0c94c1ed-0f3f-ad3f-d57a-158ea681ce19@sandeen.net>
 <20211206223301.GJ449541@dread.disaster.area>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: mkfs.xfs ignores data stripe on 4k devices?
In-Reply-To: <20211206223301.GJ449541@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/6/21 4:33 PM, Dave Chinner wrote:
> On Mon, Dec 06, 2021 at 01:16:07PM -0600, Eric Sandeen wrote:
>> This seems odd, and unusual to me, but it's been there so long I'm wondering
>> if it's intentional.
>>
>> We have various incarnations of this in mkfs since 2003:
>>
>>          } else if (lsectorsize > XFS_MIN_SECTORSIZE && !lsu && !lsunit) {
>>                  lsu = blocksize;
>>                  logversion = 2;
>>          }
>>
>> which sets the log stripe unit before we query the device geometry, and so
>> with the log stripe unit already set, we ignore subsequent device geometry
>> that may be discovered:
>>
>> # modprobe scsi_debug dev_size_mb=1024 opt_xferlen_exp=10 physblk_exp=3
>>
>> # mkfs.xfs -f /dev/sdh
>> meta-data=/dev/sdh               isize=512    agcount=8, agsize=32768 blks
>>           =                       sectsz=4096  attr=2, projid32bit=1
>>           =                       crc=1        finobt=1, sparse=1, rmapbt=0
>>           =                       reflink=1    bigtime=0 inobtcount=0
>> data     =                       bsize=4096   blocks=262144, imaxpct=25
>>           =                       sunit=128    swidth=128 blks
>>                                   ^^^^^^^^^
> 
> su = 512kB.
> 
> Max XFS log stripe unit = 256kB.

Ok, but I should have showed you another example with a smaller stripe unit,
sorry.  4k sector device:

# modprobe scsi_debug dev_size_mb=1024 opt_xferlen_exp=8 physblk_exp=3

# mkfs.xfs -f /dev/sdh
meta-data=/dev/sdh               isize=512    agcount=8, agsize=32736 blks
          =                       sectsz=4096  attr=2, projid32bit=1
          =                       crc=1        finobt=1, sparse=1, rmapbt=0
          =                       reflink=1    bigtime=0 inobtcount=0
data     =                       bsize=4096   blocks=261888, imaxpct=25
          =                       sunit=32     swidth=128 blks
                                  ^^^^^^^^
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=1221, version=2
          =                       sectsz=4096  sunit=1 blks, lazy-count=1
                                               ^^^^^^^
realtime =none                   extsz=4096   blocks=0, rtextents=0


512b sector device:

# modprobe scsi_debug dev_size_mb=1024 opt_xferlen_exp=8 physblk_exp=0

# mkfs.xfs -f /dev/sdh
meta-data=/dev/sdh               isize=512    agcount=8, agsize=32736 blks
          =                       sectsz=512   attr=2, projid32bit=1
          =                       crc=1        finobt=1, sparse=1, rmapbt=0
          =                       reflink=1    bigtime=0 inobtcount=0
data     =                       bsize=4096   blocks=261888, imaxpct=25
          =                       sunit=32     swidth=128 blks
                                  ^^^^^^^^
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=2784, version=2
          =                       sectsz=512   sunit=32 blks, lazy-count=1
                                               ^^^^^^^
realtime =none                   extsz=4096   blocks=0, rtextents=0

we're only ignoring the device geometry on 4k devices, for the reason indicated
in my original email.

> It used to emit a warning and set the lsu=32kB, but we decided that
> the error message was harmful for automatically calculated values.
> I wonder who decided to remove that?

That's not my complaint though. I do think that if we auto-reduce, we should
not emit warnings the user can't do anything about.  Hence my change. ;)

> commit 392e896e41fdaffd6fcc51e270a61b91bf9ff2fe
> Author: Eric Sandeen <sandeen@sandeen.net>
> Date:   Wed Oct 29 16:35:02 2014 +1100
> 
>      mkfs: don't warn about log sunit size if it was auto-discovered

<snip>

> 
> :)

:P
  
>> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
>> log      =internal log           bsize=4096   blocks=2560, version=2
>>           =                       sectsz=4096  sunit=1 blks, lazy-count=1
>>                                                ^^^^^^^^^^^^
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>>
>> surely this is unintentional and suboptimal? But please sanity-check me,
>> I don't know how this could have stood since 2003 w/o being noticed...
> 
> As for why we drop back to teh default non-stripe aligned value
> rather than 32kB now?

we actually still do. Just not on 4k drives.

> Well, 32kB was completely arbitrary, and any non-zero log stripe
> unit is known to be detrimental to fsync heavy workloads because all
> the iclog padding consumed all the available disk bandwidth rather
> than actual data or metadata changes. So lsu=32kB is not necessarily
> better than lsu=4kB for storage with large stripe units.
> 
> That's especially true now that we only issue flush/FUA operations for
> start/commit iclog writes and not for all the intermediate iclogs in
> a checkpoint.  Hence iclogs writes will get merged much more often
> and optimised by the block layer for RAID stripes regardless of
> their alignment.
> 
> Whether the change was intentional? Probably not. the stripe unit
> code was spaghettied through the mkfs code, and the commit that
> cleaned this up:
> 
> commit 2f44b1b0e5adc46616b096c7b1e52b60c4461029
> Author: Dave Chinner <dchinner@redhat.com>
> Date:   Wed Dec 6 17:14:27 2017 -0600
> 
>      mkfs: rework stripe calculations
>      
>      The data and log stripe calculations a spaghettied all over the mkfs
>      code. This patch pulls all of the different chunks of code together
>      into calc_stripe_factors() and removes all the redundant/repeated
>      checks and calculations that are made.
>      
>      Signed-Off-By: Dave Chinner <dchinner@redhat.com>
>      Reviewed-by: Eric Sandeen <sandeen@redhat.com>
>      Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> 
> Appears to have changed this specific case as large sector sizes
> now set the default lsunit long before we try to apply the default
> stripe aligned value for a filesystem with no specific lsunit being
> set.
> 
> As much as there may be an unintentional difference here, I'll argue
> that the current behaviour has less potential negative effects on
> performance than the old one of defaulting to 32kB for such
> configurations....

Ok, but surely it should not differ between 512b and 4k devices.
That was my (poorly communicated) concern.

Thanks,
-Eric
