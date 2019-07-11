Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47188 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728466AbfGKOhf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jul 2019 10:37:35 -0400
Date: Thu, 11 Jul 2019 07:35:16 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: project quota ineritance flag test
Message-ID: <20190711143516.GG5167@magnolia>
References: <20190619101047.3149-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619101047.3149-1-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed, Jun 19, 2019 at 06:10:47PM +0800, Zorro Lang wrote:
> This case is used to cover xfsprogs bug "b136f48b xfs_quota: fix
> false error reporting of project inheritance flag is not set" at
> first. Then test more behavior when project ineritance flag is
> set or removed.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---

<skipping to the good part>

> diff --git a/tests/xfs/507.out b/tests/xfs/507.out
> new file mode 100644
> index 00000000..c8c09d3f
> --- /dev/null
> +++ b/tests/xfs/507.out
> @@ -0,0 +1,23 @@
> +QA output created by 507
> +== The parent directory has Project inheritance bit by default ==
> +Checking project test (path [SCR_MNT]/dir)...
> +Processed 1 ([PROJECTS_FILE] and cmdline) paths for project test with recursion depth infinite (-1).
> +
> +Write SCRATCH_MNT/dir/foo, expect ENOSPC:
> +pwrite: No space left on device
> +Write SCRATCH_MNT/dir/dir_inherit/foo, expect ENOSPC:
> +pwrite: No space left on device
> +
> +== After removing parent directory has Project inheritance bit ==
> +Checking project test (path [SCR_MNT]/dir)...
> +[SCR_MNT]/dir - project inheritance flag is not set
> +[SCR_MNT]/dir/foo - project identifier is not set (inode=0, tree=10)
> +[SCR_MNT]/dir/dir_uninherit - project identifier is not set (inode=0, tree=10)
> +[SCR_MNT]/dir/dir_uninherit - project inheritance flag is not set
> +[SCR_MNT]/dir/dir_uninherit/foo - project identifier is not set (inode=0, tree=10)
> +Processed 1 ([PROJECTS_FILE] and cmdline) paths for project test with recursion depth infinite (-1).
> +
> +Write SCRATCH_MNT/dir/foo, expect Success:
> +Write SCRATCH_MNT/dir/dir_inherit/foo, expect ENOSPC:
> +pwrite: No space left on device

I keep seeing this test failure:

--- a/xfs/508.out      2019-06-30 08:32:32.216174715 -0700
+++ b/xfs/508.out.bad    2019-07-11 07:32:30.488000000 -0700
@@ -19,5 +19,5 @@
 
 Write SCRATCH_MNT/dir/foo, expect Success:
 Write SCRATCH_MNT/dir/dir_inherit/foo, expect ENOSPC:
-pwrite: No space left on device
+/opt/dir/dir_inherit/foo: Disk quota exceeded
 Write SCRATCH_MNT/dir/dir_uninherit/foo, expect Success:

IIRC EDQUOT is the correct error code for running out of /project/
quota (and I tried with a modern V5 fs and a V4 fs too) both with
setting no quota options at all and turning on every quota type
supported by the fs.

Under what circumstances does xfs_io spit out ENOSPC?

--D

> +Write SCRATCH_MNT/dir/dir_uninherit/foo, expect Success:
> diff --git a/tests/xfs/group b/tests/xfs/group
> index ffe4ae12..46200752 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -504,3 +504,4 @@
>  504 auto quick mkfs label
>  505 auto quick spaceman
>  506 auto quick health
> +507 auto quick quota
> -- 
> 2.17.2
> 
