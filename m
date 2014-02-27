Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B3FD929DF7
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 08:17:46 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 65865304066
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 06:17:46 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id URWgpgQAudHsTKZG for <xfs@oss.sgi.com>;
	Thu, 27 Feb 2014 06:17:44 -0800 (PST)
Message-ID: <530F4907.5010808@sandeen.net>
Date: Thu, 27 Feb 2014 08:17:43 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] mkfs: proto file creation does not set ftype correctly
References: <1393494344-30056-1-git-send-email-david@fromorbit.com>
	<1393494344-30056-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1393494344-30056-3-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 2/27/14, 3:45 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Hence running xfs_repair on a ftype enable filesystem that has
> contents created by a proto file will throw warnings on mismatched
> ftype entries and correct them. xfs/031 fails due to this problem.
> 
> Fix it by settin gup the xname structure with the correct type

"setting up"

> fields.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

huh, surprised that hung out there for so long ;)

I guess the root inode is handled by core mkfs code, right?
(around line 544)

And I notice that "r" filetypes aren't documented in the
manpage but that's a different issue.

As long as I'm right about the root inode,

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  mkfs/proto.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/mkfs/proto.c b/mkfs/proto.c
> index 4cc0df6..4d3680d 100644
> --- a/mkfs/proto.c
> +++ b/mkfs/proto.c
> @@ -438,6 +438,7 @@ parseproto(
>  	creds.cr_gid = (int)getnum(pp);
>  	xname.name = (uchar_t *)name;
>  	xname.len = name ? strlen(name) : 0;
> +	xname.type = 0;
>  	tp = libxfs_trans_alloc(mp, 0);
>  	flags = XFS_ILOG_CORE;
>  	xfs_bmap_init(&flist, &first);
> @@ -453,6 +454,7 @@ parseproto(
>  		if (buf)
>  			free(buf);
>  		libxfs_trans_ijoin(tp, pip, 0);
> +		xname.type = XFS_DIR3_FT_REG_FILE;
>  		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist);
>  		libxfs_trans_ihold(tp, pip);
>  		break;
> @@ -469,6 +471,7 @@ parseproto(
>  
>  		libxfs_trans_ijoin(tp, pip, 0);
>  
> +		xname.type = XFS_DIR3_FT_REG_FILE;
>  		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist);
>  		libxfs_trans_ihold(tp, pip);
>  		libxfs_trans_log_inode(tp, ip, flags);
> @@ -490,6 +493,7 @@ parseproto(
>  			fail(_("Inode allocation failed"), error);
>  		}
>  		libxfs_trans_ijoin(tp, pip, 0);
> +		xname.type = XFS_DIR3_FT_BLKDEV;
>  		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist);
>  		libxfs_trans_ihold(tp, pip);
>  		flags |= XFS_ILOG_DEV;
> @@ -504,6 +508,7 @@ parseproto(
>  		if (error)
>  			fail(_("Inode allocation failed"), error);
>  		libxfs_trans_ijoin(tp, pip, 0);
> +		xname.type = XFS_DIR3_FT_CHRDEV;
>  		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist);
>  		libxfs_trans_ihold(tp, pip);
>  		flags |= XFS_ILOG_DEV;
> @@ -516,6 +521,7 @@ parseproto(
>  		if (error)
>  			fail(_("Inode allocation failed"), error);
>  		libxfs_trans_ijoin(tp, pip, 0);
> +		xname.type = XFS_DIR3_FT_FIFO;
>  		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist);
>  		libxfs_trans_ihold(tp, pip);
>  		break;
> @@ -529,6 +535,7 @@ parseproto(
>  			fail(_("Inode allocation failed"), error);
>  		flags |= newfile(tp, ip, &flist, &first, 1, 1, buf, len);
>  		libxfs_trans_ijoin(tp, pip, 0);
> +		xname.type = XFS_DIR3_FT_SYMLINK;
>  		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist);
>  		libxfs_trans_ihold(tp, pip);
>  		break;
> @@ -546,6 +553,7 @@ parseproto(
>  			isroot = 1;
>  		} else {
>  			libxfs_trans_ijoin(tp, pip, 0);
> +			xname.type = XFS_DIR3_FT_DIR;
>  			newdirent(mp, tp, pip, &xname, ip->i_ino,
>  				  &first, &flist);
>  			pip->i_d.di_nlink++;
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
