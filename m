Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B0AC27CA9
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2016 12:25:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8D4598F8035
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2016 10:25:16 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BE6fW0mEEgPJBCwh (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 25 Jan 2016 10:25:15 -0800 (PST)
Date: Mon, 25 Jan 2016 13:25:13 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 6/8] xfs: move inode generation count to VFS inode
Message-ID: <20160125182513.GB27301@bfoster.bfoster>
References: <1452751765-4420-1-git-send-email-david@fromorbit.com>
	<1452751765-4420-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1452751765-4420-7-git-send-email-david@fromorbit.com>
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

On Thu, Jan 14, 2016 at 05:09:23PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Pull another 4 bytes out of the xfs_icdinode.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.c | 8 ++++----
>  fs/xfs/libxfs/xfs_inode_buf.h | 1 -
>  fs/xfs/xfs_export.c           | 2 +-
>  fs/xfs/xfs_inode.c            | 5 +----
>  fs/xfs/xfs_inode_item.c       | 2 +-
>  fs/xfs/xfs_ioctl.c            | 2 +-
>  fs/xfs/xfs_iops.c             | 1 -
>  fs/xfs/xfs_itable.c           | 2 +-
>  8 files changed, 9 insertions(+), 14 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index c424d4b..397ce85 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1227,7 +1227,6 @@ xfs_setup_inode(
>  		break;
>  	}
>  
> -	inode->i_generation = ip->i_d.di_gen;
>  	i_size_write(inode, ip->i_d.di_size);
>  	xfs_diflags_to_iflags(inode, ip);
>  

Same question here wrt to reclaimable inodes as the previous patch and
nlink..? Seems Ok otherwise.

Brian

> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index cfb6527..6162e65 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -100,11 +100,11 @@ xfs_bulkstat_one_int(
>  	buf->bs_mtime.tv_nsec = inode->i_mtime.tv_nsec;
>  	buf->bs_ctime.tv_sec = inode->i_ctime.tv_sec;
>  	buf->bs_ctime.tv_nsec = inode->i_ctime.tv_nsec;
> +	buf->bs_gen = inode->i_generation;
>  
>  	buf->bs_xflags = xfs_ip2xflags(ip);
>  	buf->bs_extsize = dic->di_extsize << mp->m_sb.sb_blocklog;
>  	buf->bs_extents = dic->di_nextents;
> -	buf->bs_gen = dic->di_gen;
>  	memset(buf->bs_pad, 0, sizeof(buf->bs_pad));
>  	buf->bs_dmevmask = dic->di_dmevmask;
>  	buf->bs_dmstate = dic->di_dmstate;
> -- 
> 2.5.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
