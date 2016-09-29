Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:36352 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753509AbcI2G2U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 02:28:20 -0400
Date: Thu, 29 Sep 2016 16:27:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs/{207,327}: fsxattr no longer has the reflink flag
Message-ID: <20160929062755.GM9806@dastard>
References: <147511610789.12284.10323409415801065382.stgit@birch.djwong.org>
 <147511612047.12284.3645173774395982911.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147511612047.12284.3645173774395982911.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: eguan@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Sep 28, 2016 at 07:28:40PM -0700, Darrick J. Wong wrote:
> The FS_XFLAG_REFLINK flag was removed from struct fsxattr prior to
> the inclusion of reflink in XFS, so remove it from the test outputs.
> Note that the inode flag still exists; it's simply not presented
> to userspace any more.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Fixes the failures I've seen

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> ---
>  tests/xfs/207.out |    4 ++--
>  tests/xfs/327.out |    6 +++---
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/tests/xfs/207.out b/tests/xfs/207.out
> index 434b8d9..f6dc17d 100644
> --- a/tests/xfs/207.out
> +++ b/tests/xfs/207.out
> @@ -11,8 +11,8 @@ Check extsz and cowextsz settings on 1Mbyte file
>  [0] SCRATCH_MNT/test-207/file2
>  [1048576] SCRATCH_MNT/test-207/file2
>  Set cowextsize and check flag
> -fsxattr.xflags = 0x20000 [----------------C]
> +fsxattr.xflags = 0x10000 [---------------C]
>  [1048576] SCRATCH_MNT/test-207/file3
>  Unset cowextsize and check flag
> -fsxattr.xflags = 0x0 [-----------------]
> +fsxattr.xflags = 0x0 [----------------]
>  [0] SCRATCH_MNT/test-207/file3
> diff --git a/tests/xfs/327.out b/tests/xfs/327.out
> index c88d623..5b3cba2 100644
> --- a/tests/xfs/327.out
> +++ b/tests/xfs/327.out
> @@ -3,11 +3,11 @@ Format filesystem
>  Create files
>  Check files
>  8fa14cdd754f91cc6554c9e71929cce7  SCRATCH_MNT/file.0
> -[reflink] SCRATCH_MNT/file.0 
> +[] SCRATCH_MNT/file.0 
>  8fa14cdd754f91cc6554c9e71929cce7  SCRATCH_MNT/file.64
> -[reflink] SCRATCH_MNT/file.64 
> +[] SCRATCH_MNT/file.64 
>  8fa14cdd754f91cc6554c9e71929cce7  SCRATCH_MNT/file.128
> -[reflink] SCRATCH_MNT/file.128 
> +[] SCRATCH_MNT/file.128 
>  CoW all files
>  Repair filesystem
>  Check files again
> 
> 

-- 
Dave Chinner
david@fromorbit.com
