Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7RHZGuC101594 for <xfs@oss.sgi.com>; Thu, 27 Aug 2009 12:35:34 -0500
Date: Thu, 27 Aug 2009 13:35:40 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/17] vfs: Introduce new helpers for syncing after
	writing to O_SYNC file or IS_SYNC inode
Message-ID: <20090827173540.GA19115@infradead.org>
References: <1250875447-15622-1-git-send-email-jack@suse.cz>
	<1250875447-15622-8-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1250875447-15622-8-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, linux-ntfs-dev@lists.sourceforge.net, Joel Becker <joel.becker@oracle.com>, LKML <linux-kernel@vger.kernel.org>, Anton Altaparmakov <aia21@cantab.net>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-fsdevel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>, xfs@oss.sgi.com, hch@lst.de, ocfs2-devel@oss.oracle.com

> +int generic_write_sync(struct file *file, loff_t pos, loff_t count)
> +{
> +	if (!(file->f_flags & O_SYNC) && !IS_SYNC(file->f_mapping->host))
> +		return 0;
> +	return generic_sync_file(file, file->f_path.dentry, pos,
> +				 pos + count - 1,
> +				 SYNC_SUBMIT_DATA | SYNC_WAIT_DATA);
> +}
> +EXPORT_SYMBOL(generic_write_sync);

>  
> +/* Flags for generic_sync_file */
> +#define SYNC_INODE		1
> +#define SYNC_SUBMIT_DATA	2
> +#define SYNC_WAIT_DATA		4

When I think about this more I really hate the latter two flags.
There's really no reason to just do only either the submit or wait.
I'd say kill the flags for now and just implement generic_write_sync
as:

int generic_write_sync(struct file *file, loff_t pos, loff_t count)
{
	if (!(file->f_flags & O_SYNC) && !IS_SYNC(file->f_mapping->host))
		return 0;
	return vfs_fsync_range(file, file->f_path.dentry, pos,
			       pos + count - 1, 1);
}

and we can look into replacing the datasync flag with something more
meaningfull later through the whole fsync stack.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
