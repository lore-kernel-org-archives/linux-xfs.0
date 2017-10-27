Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42600 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750790AbdJ0GET (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Oct 2017 02:04:19 -0400
Date: Fri, 27 Oct 2017 14:04:18 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 8/6] xfs/333: fix errors with new inode pointer verifiers
Message-ID: <20171027060418.GV3235@eguan.usersys.redhat.com>
References: <150899709935.18389.17266737014565285073.stgit@magnolia>
 <20171027004401.GF5486@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171027004401.GF5486@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Oct 26, 2017 at 05:44:01PM -0700, Darrick J. Wong wrote:
> Fix test failures with new inode pointer verifiers... and also make sure
> that the running xfs actually supports realtime rmap.  (This should stop
> the current crop of weird test failures since nobody has rtrmap yet
> anyway...)
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/xfs/333     |    4 +++-
>  tests/xfs/333.out |    4 +++-
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/xfs/333 b/tests/xfs/333
> index f7f233d..af52373 100755
> --- a/tests/xfs/333
> +++ b/tests/xfs/333
> @@ -51,6 +51,8 @@ unset SCRATCH_RTDEV
>  
>  echo "Format and mount"
>  _scratch_mkfs > "$seqres.full" 2>&1
> +rrmapino="$(_scratch_xfs_db -c 'sb 0' -c 'p rrmapino' 2>&1)"
> +test "${rrmapino}" = "field rrmapino not found" && _notrun "realtime rmapbt not supported"
>  _scratch_mount
>  
>  echo "Create some files"
> @@ -62,7 +64,7 @@ _scratch_unmount
>  
>  echo "Corrupt fs"
>  _scratch_xfs_db -x -c 'sb 0' -c "write rrmapino $ino" >> $seqres.full
> -_scratch_mount
> +_scratch_mount 2>&1 | _filter_scratch
>  
>  echo "Check files"
>  md5sum $SCRATCH_MNT/f1 2>&1 | _filter_scratch
> diff --git a/tests/xfs/333.out b/tests/xfs/333.out
> index bee9bbc..9f81ba4 100644
> --- a/tests/xfs/333.out
> +++ b/tests/xfs/333.out
> @@ -2,8 +2,10 @@ QA output created by 333
>  Format and mount
>  Create some files
>  Corrupt fs
> +mount: mount SCRATCH_DEV on SCRATCH_MNT failed: Structure needs cleaning

So kernel refuses to mount the corrupted fs now, then all the subsequent
test steps before _repair_scratch_fs seem meaningless now, e.g. check
md5sum of the file, and since SCRATCH_DEV is not mounted, "Trying to
create more files" is actually writing to rootfs. All these don't seem
right and look confusing to me..

Thanks,
Eryu

>  Check files
> -8f27047948255cb84872e2dd7c0bc56d  SCRATCH_MNT/f1
> +md5sum: SCRATCH_MNT/f1: No such file or directory
>  Try to create more files
>  Repair fs
> +umount: SCRATCH_DEV: not mounted
>  Try to create more files (again)
