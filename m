Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 070837F6C
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2015 06:17:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C92C68F8033
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2015 04:17:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id JMHF8RTTM0w2j0eA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 15 Jul 2015 04:17:00 -0700 (PDT)
Date: Wed, 15 Jul 2015 07:16:59 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: Remove duplicate jumps to the same label
Message-ID: <20150715111658.GB60463@bfoster.bfoster>
References: <1436950975-5004-1-git-send-email-jack@suse.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1436950975-5004-1-git-send-email-jack@suse.com>
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
To: Jan Kara <jack@suse.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 15, 2015 at 11:02:55AM +0200, Jan Kara wrote:
> xfs_create() and xfs_create_tmpfile() have useless jumps to identical
> labels. Simplify them.
> 
> Signed-off-by: Jan Kara <jack@suse.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_inode.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 3da9f4da4f3d..d22a984d8470 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1175,11 +1175,8 @@ xfs_create(
>  	 */
>  	error = xfs_dir_ialloc(&tp, dp, mode, is_dir ? 2 : 1, rdev,
>  			       prid, resblks > 0, &ip, &committed);
> -	if (error) {
> -		if (error == -ENOSPC)
> -			goto out_trans_cancel;
> +	if (error)
>  		goto out_trans_cancel;
> -	}
>  
>  	/*
>  	 * Now we join the directory inode to the transaction.  We do not do it
> @@ -1318,11 +1315,8 @@ xfs_create_tmpfile(
>  
>  	error = xfs_dir_ialloc(&tp, dp, mode, 1, 0,
>  				prid, resblks > 0, &ip, NULL);
> -	if (error) {
> -		if (error == -ENOSPC)
> -			goto out_trans_cancel;
> +	if (error)
>  		goto out_trans_cancel;
> -	}
>  
>  	if (mp->m_flags & XFS_MOUNT_WSYNC)
>  		xfs_trans_set_sync(tp);
> -- 
> 2.1.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
