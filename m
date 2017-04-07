Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50574 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933880AbdDGSdT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Apr 2017 14:33:19 -0400
Date: Fri, 7 Apr 2017 11:33:10 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfsprogs: ensure growfs rejects non-existent mount point
Message-ID: <20170407183310.GN4864@birch.djwong.org>
References: <20170407175809.8540-1-billodo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170407175809.8540-1-billodo@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bill O'Donnell <billodo@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Apr 07, 2017 at 12:58:09PM -0500, Bill O'Donnell wrote:
> xfs_growfs manpage clearly states that the filesystem must
> be mounted to be grown. Current behavior allows xfs_growfs
> to proceed if the filesystem /containing/ the path
> of the desired target is mounted. This is not the specified
> behavior. Instead, also check the targeted fs argument against
> the entry found in the fstable lookup. Unless the targeted
> fs is actually mounted, reject the command.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> ---
>  growfs/xfs_growfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
> index a294e14..05630b8 100644
> --- a/growfs/xfs_growfs.c
> +++ b/growfs/xfs_growfs.c
> @@ -203,7 +203,7 @@ main(int argc, char **argv)
>  
>  	fs_table_initialise(0, NULL, 0, NULL);
>  	fs = fs_table_lookup(argv[optind], FS_MOUNT_POINT);
> -	if (!fs) {
> +	if (!fs || (strcmp(argv[optind], fs->fs_dir) != 0)) {

The parentheses around the strcmp comparison aren't necessary.

There's a find_mountpoint() function in xfs_fsr that wants to do
something similar to this.  I wonder if it'd make sense to change it
too?  (Separate patch.)

--D

>  		fprintf(stderr, _("%s: %s is not a mounted XFS filesystem\n"),
>  			progname, argv[optind]);
>  		return 1;
> -- 
> 2.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
