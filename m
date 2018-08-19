Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-eopbgr730126.outbound.protection.outlook.com ([40.107.73.126]:34209
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726171AbeHTAUW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 19 Aug 2018 20:20:22 -0400
From: "Xu, Wen" <wen.xu@gatech.edu>
Subject: Re: [PATCH 6/6] xfs: don't crash the vfs on a garbage inline symlink
Date: Sun, 19 Aug 2018 21:07:30 +0000
Message-ID: <356AE60B-A363-4D7B-AC5F-CCC4D73F3068@gatech.edu>
References: <153400169747.27471.4044680761841034489.stgit@magnolia>
 <153400173428.27471.504421086760762828.stgit@magnolia>
In-Reply-To: <153400173428.27471.504421086760762828.stgit@magnolia>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <23751AE38F46604C969C7B3D6DEA2CC6@namprd07.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "Xu, Wen" <wen.xu@gatech.edu>

Hi Darrick,

Could I know what bugzilla bug I reported this patch corresponds to?

Thanks,
Wen

> On Aug 11, 2018, at 11:35 AM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> 
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The VFS routine that calls ->get_link blindly copies whatever's returned
> into the user's buffer.  If we return a NULL pointer, the vfs will
> crash on the null pointer.  Therefore, return -EFSCORRUPTED instead of
> blowing up the kernel.
> 
> Reported-by: wen.xu@gatech.edu
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> fs/xfs/xfs_iops.c |   10 +++++++++-
> 1 file changed, 9 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 0ef5ad7fb851..26007a9db49d 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -471,8 +471,16 @@ xfs_vn_get_link_inline(
> 	struct inode		*inode,
> 	struct delayed_call	*done)
> {
> +	char			*ptr;
> +
> 	ASSERT(XFS_I(inode)->i_df.if_flags & XFS_IFINLINE);
> -	return XFS_I(inode)->i_df.if_u1.if_data;
> +
> +	/*
> +	 * The VFS crashes on a NULL pointer, so return -EFSCORRUPTED if
> +	 * if_data is junk.
> +	 */
> +	ptr = XFS_I(inode)->i_df.if_u1.if_data;
> +	return ptr ? ptr : ERR_PTR(-EFSCORRUPTED);
> }
> 
> STATIC int
> 
