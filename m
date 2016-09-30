Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:36435 "EHLO
        mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932413AbcI3J5Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 05:57:25 -0400
Received: by mail-pa0-f67.google.com with SMTP id cd13so2790081pac.3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Sep 2016 02:57:24 -0700 (PDT)
Date: Fri, 30 Sep 2016 17:57:17 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [ANNOUNCE] xfs: for-next branch updated to 2e405cd
Message-ID: <20160930095717.GI2462@eguan.usersys.redhat.com>
References: <20160926004917.GU340@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160926004917.GU340@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: xfs@oss.sgi.com

On Mon, Sep 26, 2016 at 10:49:17AM +1000, Dave Chinner wrote:
> Hi folks,
> 
> The for-next branch of the xfs kernel repository at
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

I tested this update (and the update from last week) through all my
usual tests (except some long-term stress tests). Tests all passed,
results all look good.

BTW, I start testing for-next branch because I find that it's much
easier to do bisection here if there's any regression, than on linus
tree, where all updates merge all together. 

Thanks,
Eryu

> 
> has just been updated. This includes a bunch of log recovery fixes
> for v5 filesystems.
> 
> REMINDER: xfs@oss.sgi.com is going at the end of the month. Please
> change your XFS list subscription to linux-xfs@vger.kernel.org,
> otherwise things will go silent for you....
> 
> -Dave.
> 
> The new head of the for-next branch is commit:
> 
> 2e405cd Merge branch 'xfs-4.9-log-recovery-fixes' into for-next
> 
> New Commits:
> 
> Brian Foster (5):
>       [12818d2] xfs: rework log recovery to submit buffers on LSN boundaries
>       [22db9af] xfs: pass current lsn to log recovery buffer validation
>       [040c52c] xfs: don't warn on buffers not being recovered due to LSN
>       [60a4a22] xfs: update metadata LSN in buffers during log recovery
>       [5cd9cee] xfs: log recovery tracepoints to track current lsn and buffer submission
> 
> Dave Chinner (3):
>       [292378e] xfs: remote attribute blocks aren't really userdata
>       [ddeb14f] xfs: quiesce the filesystem after recovery on readonly mount
>       [2e405cd] Merge branch 'xfs-4.9-log-recovery-fixes' into for-next
> 
> 
> Code Diffstat:
> 
>  fs/xfs/libxfs/xfs_alloc.c |  23 +++---
>  fs/xfs/libxfs/xfs_alloc.h |  17 ++++-
>  fs/xfs/libxfs/xfs_bmap.c  |  41 +++++++----
>  fs/xfs/libxfs/xfs_bmap.h  |   2 +-
>  fs/xfs/xfs_bmap_util.c    |   2 +-
>  fs/xfs/xfs_extent_busy.c  |   2 +-
>  fs/xfs/xfs_filestream.c   |   9 ++-
>  fs/xfs/xfs_log_priv.h     |   3 +-
>  fs/xfs/xfs_log_recover.c  | 191 ++++++++++++++++++++++++++++++++++---------------
>  fs/xfs/xfs_mount.c        |  14 ++++
>  fs/xfs/xfs_super.c        |   2 +-
>  fs/xfs/xfs_super.h        |   1 +
>  fs/xfs/xfs_trace.h        |  39 ++++++++--
>  13 files changed, 248 insertions(+), 98 deletions(-)
> -- 
> Dave Chinner
> david@fromorbit.com



> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

