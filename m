Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 851337CBF
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 17:26:09 -0500 (CDT)
Date: Wed, 22 May 2013 17:26:08 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 08/11] xfs: don't emit v5 superblock warnings on write
Message-ID: <20130522222608.GR20028@sgi.com>
References: <1369123330-9579-1-git-send-email-david@fromorbit.com>
	<1369123330-9579-9-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1369123330-9579-9-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, May 21, 2013 at 06:02:07PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We write the superblock every 30s or so which results in the
> verifier being called. Right now that results in this output
> every 30s:
> 
> XFS (vda): Version 5 superblock detected. This kernel has EXPERIMENTAL support enabled!
> Use of these features in this kernel is at your own risk!
> 
> And spamming the logs. Stop this output from occurring on superblock
> writes.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_mount.c |   18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index f6bfbd7..e8e310c 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -314,7 +314,8 @@ STATIC int
>  xfs_mount_validate_sb(
>  	xfs_mount_t	*mp,
>  	xfs_sb_t	*sbp,
> -	bool		check_inprogress)
> +	bool		check_inprogress,
> +	bool		check_version)
>  {
>  
>  	/*
> @@ -337,9 +338,10 @@ xfs_mount_validate_sb(
>  
>  	/*
>  	 * Version 5 superblock feature mask validation. Reject combinations the
> -	 * kernel cannot support up front before checking anything else.
> +	 * kernel cannot support up front before checking anything else. For
> +	 * write validation, we don't need to check feature masks.
>  	 */
> -	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) {
> +	if (check_version && XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) {

if (!quiet_version) {
>  		xfs_alert(mp,
>  "Version 5 superblock detected. This kernel has EXPERIMENTAL support enabled!\n"
>  "Use of these features in this kernel is at your own risk!");

}

Since the stated goal of the patch is to be quieter and not to disable useful
tests in the verifier, I suggest you disable the print rather than disable the
test.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
