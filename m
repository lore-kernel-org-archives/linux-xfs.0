Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 128237F4E
	for <xfs@oss.sgi.com>; Thu, 12 Sep 2013 09:24:50 -0500 (CDT)
Date: Thu, 12 Sep 2013 09:24:46 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: Make the incore inode di_size to xfs_ufsize_t
Message-ID: <20130912142446.GZ1935@sgi.com>
References: <52269DF4.5040305@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52269DF4.5040305@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hey Jeff,

On Wed, Sep 04, 2013 at 10:41:56AM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Make the incore inode di_size to unsigned, this would be helpful
> to catch the negative sizes of it in many cases, so that we don't
> need to perform additional check for it being less than ZERO or not.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---
>  fs/xfs/xfs_inode_fork.c |    3 +--
>  fs/xfs/xfs_log_format.h |    2 +-
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode_fork.c b/fs/xfs/xfs_inode_fork.c
> index 02f1083..2b60a5a 100644
> --- a/fs/xfs/xfs_inode_fork.c
> +++ b/fs/xfs/xfs_inode_fork.c
> @@ -167,8 +167,7 @@ xfs_iformat_fork(
>  			}
>  
>  			di_size = be64_to_cpu(dip->di_size);
> -			if (unlikely(di_size < 0 ||
> -				     di_size > XFS_DFORK_DSIZE(dip, ip->i_mount))) {
> +			if (unlikely(di_size > XFS_DFORK_DSIZE(dip, ip->i_mount))) {
>  				xfs_warn(ip->i_mount,
>  			"corrupt inode %Lu (bad size %Ld for local inode).",
>  					(unsigned long long) ip->i_ino,
> diff --git a/fs/xfs/xfs_log_format.h b/fs/xfs/xfs_log_format.h
> index a49ab2c..2795fc5 100644
> --- a/fs/xfs/xfs_log_format.h
> +++ b/fs/xfs/xfs_log_format.h
> @@ -547,7 +547,7 @@ typedef struct xfs_icdinode {
>  	xfs_ictimestamp_t di_atime;	/* time last accessed */
>  	xfs_ictimestamp_t di_mtime;	/* time last modified */
>  	xfs_ictimestamp_t di_ctime;	/* time created/inode modified */
> -	xfs_fsize_t	di_size;	/* number of bytes in file */
> +	xfs_ufsize_t	di_size;	/* number of bytes in file */

These two changes by themselves look fairly innocuous, but upon closer
inspection I'm not so sure...

e.g. xfs_fsize_t is still signed, and i_size is loff_t is still signed.
I'm wondering if this doesn't represent a subtle change in the on-disk
format for inodes up in that size range.  This was on my 3.12 queue.  I
think it bears more discussion, so I'll hold off on this one for now.

FWIW I believe we're still ok with just Dan's fix because the maximum
size for local format is half a block or less.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
