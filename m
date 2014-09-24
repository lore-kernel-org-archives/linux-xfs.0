Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0E58A7F4E
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 11:25:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EEF618F8037
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 09:25:11 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id eTDAwEUgKsy73nIP (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 24 Sep 2014 09:25:10 -0700 (PDT)
Date: Wed, 24 Sep 2014 18:25:07 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/4] Adds ioctl interface support for ext4 project
Message-ID: <20140924162507.GC27000@quack.suse.cz>
References: <1411567470-31799-1-git-send-email-lixi@ddn.com>
	<1411567470-31799-5-git-send-email-lixi@ddn.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1411567470-31799-5-git-send-email-lixi@ddn.com>
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
To: Li Xi <pkuelelixi@gmail.com>
Cc: adilger@dilger.ca, jack@suse.cz, linux-api@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, dmonakhov@openvz.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, tytso@mit.edu, linux-ext4@vger.kernel.org

On Wed 24-09-14 22:04:30, Li Xi wrote:
> This patch adds ioctl interface for setting/getting project of ext4.
  The patch looks good to me. I was just wondering whether it won't be
useful to add an ioctl() which isn't ext4 specific. We could just extend
->setattr() to allow setting of project ID (most filesystems would just
return -EOPNOTSUPP but ext4 and xfs could do the right thing) and then call
->setattr from the generic ioctl. That way userspace won't have to care
about filesystem type when setting project ID... What do others think?

								Honza

> Signed-off-by: Li Xi <lixi@ddn.com>
> ---
>  Documentation/filesystems/ext4.txt |    4 ++
>  fs/ext4/ext4.h                     |    2 +
>  fs/ext4/ioctl.c                    |   85 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 91 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
> index 919a329..9c98e62 100644
> --- a/Documentation/filesystems/ext4.txt
> +++ b/Documentation/filesystems/ext4.txt
> @@ -609,6 +609,10 @@ EXT4_IOC_SWAP_BOOT	      Swap i_blocks and associated attributes
>  			      The data blocks of the previous boot loader
>  			      will be associated with the given inode.
>  
> + EXT4_IOC_GETPROJECT	      Get project ID associated with inode.
> +
> + EXT4_IOC_SETPROJECT	      Set Project ID associated with inode.
> +
>  ..............................................................................
>  
>  References
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index f8be9bf..51946fd 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -617,6 +617,8 @@ enum {
>  #define EXT4_IOC_RESIZE_FS		_IOW('f', 16, __u64)
>  #define EXT4_IOC_SWAP_BOOT		_IO('f', 17)
>  #define EXT4_IOC_PRECACHE_EXTENTS	_IO('f', 18)
> +#define EXT4_IOC_GETPROJECT		_IOR('f', 19, long)
> +#define EXT4_IOC_SETPROJECT		_IOW('f', 20, long)
>  
>  #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
>  /*
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index 0f2252e..93b7ff4 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -14,6 +14,8 @@
>  #include <linux/compat.h>
>  #include <linux/mount.h>
>  #include <linux/file.h>
> +#include <linux/quotaops.h>
> +#include <linux/quota.h>
>  #include <asm/uaccess.h>
>  #include "ext4_jbd2.h"
>  #include "ext4.h"
> @@ -611,6 +613,89 @@ resizefs_out:
>  	case EXT4_IOC_PRECACHE_EXTENTS:
>  		return ext4_ext_precache(inode);
>  
> +	case EXT4_IOC_GETPROJECT:
> +	{
> +		__u32 projid;
> +
> +		projid = (__u32)from_kprojid(&init_user_ns,
> +					     EXT4_I(inode)->i_projid);
> +		return put_user(projid, (__u32 __user *) arg);
> +	}
> +	case EXT4_IOC_SETPROJECT:
> +	{
> +		__u32 projid;
> +		int err;
> +		handle_t *handle;
> +		kprojid_t kprojid;
> +		struct ext4_iloc iloc;
> +		struct ext4_inode *raw_inode;
> +
> +		struct dquot *transfer_to[EXT4_MAXQUOTAS] = { };
> +
> +		/* Make sure caller can change project. */
> +		if (!capable(CAP_SYS_ADMIN))
> +			return -EACCES;
> +
> +		if (get_user(projid, (__u32 __user *) arg))
> +			return -EFAULT;
> +
> +		kprojid = make_kprojid(&init_user_ns, (projid_t)projid);
> +
> +		if (projid_eq(kprojid, EXT4_I(inode)->i_projid))
> +			return 0;
> +
> +		err = mnt_want_write_file(filp);
> +		if (err)
> +			return err;
> +
> +		err = -EPERM;
> +		mutex_lock(&inode->i_mutex);
> +		/* Is it quota file? Do not allow user to mess with it */
> +		if (IS_NOQUOTA(inode))
> +			goto project_out;
> +
> +		dquot_initialize(inode);
> +
> +		handle = ext4_journal_start(inode, EXT4_HT_QUOTA,
> +			EXT4_QUOTA_INIT_BLOCKS(sb) +
> +			EXT4_QUOTA_DEL_BLOCKS(sb) + 3);
> +		if (IS_ERR(handle)) {
> +			err = PTR_ERR(handle);
> +			goto project_out;
> +		}
> +
> +		err = ext4_reserve_inode_write(handle, inode, &iloc);
> +		if (err)
> +			goto project_stop;
> +
> +		raw_inode = ext4_raw_inode(&iloc);
> +		if ((EXT4_INODE_SIZE(inode->i_sb) <=
> +		     EXT4_GOOD_OLD_INODE_SIZE) ||
> +		    (!EXT4_FITS_IN_INODE(raw_inode, ei, i_projid))) {
> +		    	err = -EFBIG;
> +		    	goto project_stop;
> +		}
> +
> +		transfer_to[PRJQUOTA] = dqget(sb, make_kqid_projid(kprojid));
> +		if (!transfer_to[PRJQUOTA])
> +			goto project_set;
> +
> +		err = __dquot_transfer(inode, transfer_to);
> +		dqput(transfer_to[PRJQUOTA]);
> +		if (err)
> +			goto project_stop;
> +
> +project_set:
> +		EXT4_I(inode)->i_projid = kprojid;
> +		inode->i_ctime = ext4_current_time(inode);
> +		err = ext4_mark_iloc_dirty(handle, inode, &iloc);
> +project_stop:
> +		ext4_journal_stop(handle);
> +project_out:
> +		mutex_unlock(&inode->i_mutex);
> +		mnt_drop_write_file(filp);
> +		return err;
> +	}
>  	default:
>  		return -ENOTTY;
>  	}
> -- 
> 1.7.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
