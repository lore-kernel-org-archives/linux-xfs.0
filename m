Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBHKSKiX012724 for <xfs@oss.sgi.com>; Wed, 17 Dec 2008 14:28:20 -0600
Date: Wed, 17 Dec 2008 12:28:15 -0800
From: Mark Fasheh <mfasheh@suse.com>
Subject: Re: [PATCH][RFC] fs: Add new pre-allocation ioctls to vfs for
	compatibility with legacy xfs ioctls
Message-ID: <20081217202815.GE8791@wotan.suse.de>
References: <49460F88.2080408@ankitjain.org>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49460F88.2080408@ankitjain.org>
Reply-To: Mark Fasheh <mfasheh@suse.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ankit Jain <me@ankitjain.org>
Cc: linux-kernel@vger.kernel.org, joel.becker@oracle.com, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

On Mon, Dec 15, 2008 at 01:34:24PM +0530, Ankit Jain wrote:
> This patch adds ioctls to vfs for compatibility with legacy XFS
> pre-allocation ioctls (XFS_IOC_*RESVP*). The implementation
> effectively invokes sys_fallocate for the new ioctls.
> Note: These legacy ioctls are also implemented by OCFS2.
> 
> There are some things that I'm not sure about:
> 1. Should the struct space_resv be exposed to user-space? If not,
> then what would be the right place to put it? And the ioctl
> definitions?

Yes. As far as where to put it, I'm not sure. Maybe falloc.h?


> 2. Should the corresponding ioctls be removed from ocfs2?

Well, a small amount of the code in fs/ocfs2/ioctl.c can certainly go away.
Shouldn't we be talking about doing the same for xfs too?


> Signed-off-by: Ankit Jain <me@ankitjain.org>
> ---
>  fs/ioctl.c             |   37 +++++++++++++++++++++++++++
>  fs/open.c              |   51 ++++++++++++++++++-------------------
>  include/linux/falloc.h |   19 ++++++++++++++
>  include/linux/fs.h     |    2 +
>  4 files changed, 83 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index 43e8b2c..5e565c8 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -15,6 +15,7 @@
>  #include <linux/uaccess.h>
>  #include <linux/writeback.h>
>  #include <linux/buffer_head.h>
> +#include <linux/falloc.h>
>  
>  #include <asm/ioctls.h>
>  
> @@ -346,6 +347,37 @@ EXPORT_SYMBOL(generic_block_fiemap);
>  
>  #endif  /*  CONFIG_BLOCK  */
>  
> +/*
> + * This provides compatibility with legacy XFS pre-allocation ioctls
> + * which predate the fallocate syscall.
> + *
> + * Only the l_start, l_len and l_whence fields of the 'struct space_resv'
> + * are used here, rest are ignored.
> + */
> +static int ioctl_preallocate(struct file *filp, unsigned long arg)
> +{
> +	struct inode *inode = filp->f_path.dentry->d_inode;
> +	struct space_resv sr;
> +
> +	if (copy_from_user(&sr, (struct space_resv __user *) arg, sizeof(sr)))
> +		return -EFAULT;
> +
> +	switch (sr.l_whence) {
> +	case SEEK_SET:
> +		break;
> +	case SEEK_CUR:
> +		sr.l_start += filp->f_pos;
> +		break;
> +	case SEEK_END:
> +		sr.l_start += i_size_read(inode);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return do_fallocate(filp, FALLOC_FL_KEEP_SIZE, sr.l_start, sr.l_len);
> +}
> +
>  static int file_ioctl(struct file *filp, unsigned int cmd,
>  		unsigned long arg)
>  {
> @@ -361,6 +393,11 @@ static int file_ioctl(struct file *filp, unsigned int cmd,
>  		return put_user(inode->i_sb->s_blocksize, p);
>  	case FIONREAD:
>  		return put_user(i_size_read(inode) - filp->f_pos, p);
> +	case F_IOC_RESVSP:
> +	case F_IOC_RESVSP64:
> +	case F_IOC_UNRESVSP:
> +	case F_IOC_UNRESVSP64:
> +		return ioctl_preallocate(filp, arg);

This patch is not implementing proper support for F_IOC_UNRESVSP and
F_IOC_UNRESVSP64, so why are you catching those here? To be more clear,
those are used for freeing space in a file ("puching holes"), which
fallocate is not set up to do right now.
	--Mark

--
Mark Fasheh

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
