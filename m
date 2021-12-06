Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DCD7C433F5
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Dec 2021 22:33:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350462AbhLFWgf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Dec 2021 17:36:35 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:50232 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1356734AbhLFWgf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Dec 2021 17:36:35 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 290C7607A19;
        Tue,  7 Dec 2021 09:33:02 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1muMXd-00HZUO-5n; Tue, 07 Dec 2021 09:33:01 +1100
Date:   Tue, 7 Dec 2021 09:33:01 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: mkfs.xfs ignores data stripe on 4k devices?
Message-ID: <20211206223301.GJ449541@dread.disaster.area>
References: <0c94c1ed-0f3f-ad3f-d57a-158ea681ce19@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c94c1ed-0f3f-ad3f-d57a-158ea681ce19@sandeen.net>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61ae8fa0
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=kj9zAlcOel0A:10 a=IOMw9HtfNCkA:10 a=5xOlfOR4AAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=VSwQHxeL4RktJmW6iNkA:9 a=CjuIK1q_8ugA:10
        a=SGlsW6VomvECssOqsvzv:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 06, 2021 at 01:16:07PM -0600, Eric Sandeen wrote:
> This seems odd, and unusual to me, but it's been there so long I'm wondering
> if it's intentional.
> 
> We have various incarnations of this in mkfs since 2003:
> 
>         } else if (lsectorsize > XFS_MIN_SECTORSIZE && !lsu && !lsunit) {
>                 lsu = blocksize;
>                 logversion = 2;
>         }
> 
> which sets the log stripe unit before we query the device geometry, and so
> with the log stripe unit already set, we ignore subsequent device geometry
> that may be discovered:
> 
> # modprobe scsi_debug dev_size_mb=1024 opt_xferlen_exp=10 physblk_exp=3
> 
> # mkfs.xfs -f /dev/sdh
> meta-data=/dev/sdh               isize=512    agcount=8, agsize=32768 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=1    bigtime=0 inobtcount=0
> data     =                       bsize=4096   blocks=262144, imaxpct=25
>          =                       sunit=128    swidth=128 blks
>                                  ^^^^^^^^^

su = 512kB.

Max XFS log stripe unit = 256kB.

It used to emit a warning and set the lsu=32kB, but we decided that
the error message was harmful for automatically calculated values.
I wonder who decided to remove that?

commit 392e896e41fdaffd6fcc51e270a61b91bf9ff2fe
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Wed Oct 29 16:35:02 2014 +1100

    mkfs: don't warn about log sunit size if it was auto-discovered

    Today, users doing a bare mkfs on storage with a large default
    stripe size may be surprised to get this warning:

     log stripe unit (%d bytes) is too large (maximum is 256KiB
     log stripe unit adjusted to 32KiB

    through no fault of their own.  The fallback is appropriate
    and harmless, and there's no need to warn about this in the
    defaults case.

    However, we keep the warning if a large log stripe unit was
    specified by the user on the commandline.

    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

:)

> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=2560, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
>                                               ^^^^^^^^^^^^
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> surely this is unintentional and suboptimal? But please sanity-check me,
> I don't know how this could have stood since 2003 w/o being noticed...

As for why we drop back to teh default non-stripe aligned value
rather than 32kB now?

Well, 32kB was completely arbitrary, and any non-zero log stripe
unit is known to be detrimental to fsync heavy workloads because all
the iclog padding consumed all the available disk bandwidth rather
than actual data or metadata changes. So lsu=32kB is not necessarily
better than lsu=4kB for storage with large stripe units.

That's especially true now that we only issue flush/FUA operations for
start/commit iclog writes and not for all the intermediate iclogs in
a checkpoint.  Hence iclogs writes will get merged much more often
and optimised by the block layer for RAID stripes regardless of
their alignment.

Whether the change was intentional? Probably not. the stripe unit
code was spaghettied through the mkfs code, and the commit that
cleaned this up:

commit 2f44b1b0e5adc46616b096c7b1e52b60c4461029
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Dec 6 17:14:27 2017 -0600

    mkfs: rework stripe calculations
    
    The data and log stripe calculations a spaghettied all over the mkfs
    code. This patch pulls all of the different chunks of code together
    into calc_stripe_factors() and removes all the redundant/repeated
    checks and calculations that are made.
    
    Signed-Off-By: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Eric Sandeen <sandeen@redhat.com>
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Appears to have changed this specific case as large sector sizes
now set the default lsunit long before we try to apply the default
stripe aligned value for a filesystem with no specific lsunit being
set.

As much as there may be an unintentional difference here, I'll argue
that the current behaviour has less potential negative effects on
performance than the old one of defaulting to 32kB for such
configurations....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
