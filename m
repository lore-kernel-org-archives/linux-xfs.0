Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q61NlDCC138286 for <xfs@oss.sgi.com>; Sun, 1 Jul 2012 18:47:13 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	5XPx79RimKQj6UGO for <xfs@oss.sgi.com>;
	Sun, 01 Jul 2012 16:47:11 -0700 (PDT)
Date: Mon, 2 Jul 2012 09:47:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: rename xfs_fs_* to xfs_*
Message-ID: <20120701234707.GL19223@dastard>
References: <1340816243-6177-1-git-send-email-gaowanlong@cn.fujitsu.com>
	<1340993202-5560-1-git-send-email-gaowanlong@cn.fujitsu.com>
	<1340993202-5560-2-git-send-email-gaowanlong@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1340993202-5560-2-git-send-email-gaowanlong@cn.fujitsu.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, XFS <xfs@oss.sgi.com>

On Sat, Jun 30, 2012 at 02:06:42AM +0800, Wanlong Gao wrote:
> s/xfs_fs_/xfs_/
> This too long name is unnecessary.

NACK. Not the right way to approach the problem.

Yes, there are a couple of places where this could be done, but most
of the transformations, IMO, are wrong and remove critical
information from the namespace.

Firstly, we want to get rid of the xfs_fs_subr.c wrappers and
replace them with the native linux functions, not move them around.

Secondly, transformations like xfs_fs_geometry to xfs_geometry are
incorrect - the function is returning the filesystem geometry, so
the name "fs_geometry" is actually correct. Similar for
xfs_fs_writeable, xfs_fs_show_options and so on.

Finally:

>  const struct export_operations xfs_export_operations = {
> -	.encode_fh		= xfs_fs_encode_fh,
> -	.fh_to_dentry		= xfs_fs_fh_to_dentry,
> -	.fh_to_parent		= xfs_fs_fh_to_parent,
> -	.get_parent		= xfs_fs_get_parent,
> -	.commit_metadata	= xfs_fs_nfs_commit_metadata,
> +	.encode_fh		= xfs_encode_fh,
> +	.fh_to_dentry		= xfs_fh_to_dentry,
> +	.fh_to_parent		= xfs_fh_to_parent,
> +	.get_parent		= xfs_get_parent,
> +	.commit_metadata	= xfs_nfs_commit_metadata,

....

>  static const struct super_operations xfs_super_operations = {
> -	.alloc_inode		= xfs_fs_alloc_inode,
> -	.destroy_inode		= xfs_fs_destroy_inode,
> -	.dirty_inode		= xfs_fs_dirty_inode,
> -	.evict_inode		= xfs_fs_evict_inode,
> -	.drop_inode		= xfs_fs_drop_inode,
> -	.put_super		= xfs_fs_put_super,
> -	.sync_fs		= xfs_fs_sync_fs,
> -	.freeze_fs		= xfs_fs_freeze,
> -	.unfreeze_fs		= xfs_fs_unfreeze,
> -	.statfs			= xfs_fs_statfs,
> -	.remount_fs		= xfs_fs_remount,
> -	.show_options		= xfs_fs_show_options,
> -	.nr_cached_objects	= xfs_fs_nr_cached_objects,
> -	.free_cached_objects	= xfs_fs_free_cached_objects,
> +	.alloc_inode		= xfs_alloc_inode,
> +	.destroy_inode		= xfs_destroy_inode,
> +	.dirty_inode		= xfs_dirty_inode,
> +	.evict_inode		= xfs_evict_inode,
> +	.drop_inode		= xfs_drop_inode,
> +	.put_super		= xfs_put_super,
> +	.sync_fs		= xfs_sync_fs,
> +	.freeze_fs		= xfs_freeze,
> +	.unfreeze_fs		= xfs_unfreeze,
> +	.statfs			= xfs_statfs,
> +	.remount_fs		= xfs_remount,
> +	.show_options		= xfs_show_options,
> +	.nr_cached_objects	= xfs_nr_cached_objects,
> +	.free_cached_objects	= xfs_free_cached_objects,
>  };

These should indicate that there is a valid, consistent namespacing
here to indicate layering of the the code. i.e. that xfs_fs_*
functions are typically VFS method functions of some kind. 

> -static struct file_system_type xfs_fs_type = {
> +static struct file_system_type xfs_type = {

And that is a clear demonstration of my second point....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
