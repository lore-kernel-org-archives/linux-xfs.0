Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:49113 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726314AbfGXXYM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jul 2019 19:24:12 -0400
Date: Thu, 25 Jul 2019 09:22:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 7/3] xfs/194: unmount forced v4 fs during cleanup
Message-ID: <20190724232259.GC7777@dread.disaster.area>
References: <156394156831.1850719.2997473679130010771.stgit@magnolia>
 <20190724155656.GH7084@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724155656.GH7084@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: guaneryu@gmail.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Jul 24, 2019 at 08:56:56AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Unmount the V4 filesystem we forcibly created to run this test during
> test cleanup so that the post-test wrapup checks won't try to remount
> the filesystem with different MOUNT_OPTIONS (specifically, the ones
> that get screened out by _force_xfsv4_mount_options) and fail.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/xfs/194 |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tests/xfs/194 b/tests/xfs/194
> index 3e186528..1f46d403 100755
> --- a/tests/xfs/194
> +++ b/tests/xfs/194
> @@ -18,6 +18,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
>  _cleanup()
>  {
>      cd /
> +    _scratch_unmount

Comment as to why this is necessary here so we don't go and remove
it because unmounting in cleanup should generally be unnecessary....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
