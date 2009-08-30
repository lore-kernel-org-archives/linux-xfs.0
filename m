Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7UGd9Lk036101 for <xfs@oss.sgi.com>; Sun, 30 Aug 2009 11:39:24 -0500
Date: Sun, 30 Aug 2009 18:39:17 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 07/17] vfs: Introduce new helpers for syncing after
	writing to O_SYNC file or IS_SYNC inode
Message-ID: <20090830163917.GA23955@lst.de>
References: <1250875447-15622-1-git-send-email-jack@suse.cz>
	<1250875447-15622-8-git-send-email-jack@suse.cz>
	<20090827173540.GA19115@infradead.org>
	<20090830163551.GA7129@shareable.org>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090830163551.GA7129@shareable.org>
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
To: Jamie Lokier <jamie@shareable.org>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-ntfs-dev@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>, Joel Becker <joel.becker@oracle.com>, Christoph Hellwig <hch@infradead.org>, Anton Altaparmakov <aia21@cantab.net>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-fsdevel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>, xfs@oss.sgi.com, hch@lst.de, ocfs2-devel@oss.oracle.com

On Sun, Aug 30, 2009 at 05:35:51PM +0100, Jamie Lokier wrote:
> I like that.  It looks really clear and self-documenting, if
> vfs_fsync_range does what it sounds like, which is a nice change.
> 
> If I've guessed right what that code does, proper O_RSYNC will be easy:
> 
> int generic_sync_before_read(struct file *file, loff_t pos, loff_t count)
> {
> 	int is_sync = ((file->f_flags & O_SYNC)
> 		       || IS_SYNC(file->f_mapping->host));
> 	int is_dsync = is_sync || (file->f_flags & O_DSYNC);
> 
> 	if (!is_dsync || !(file->f_flags & O_RSYNC))
> 		return 0;
> 	return vfs_fsync_range(file, file->f_ath.denty, pos,
> 			       pos + count - 1, is_sync);
> }

Yes. something like this.

> (By the way, did I mention Irix has range-fsync and range-fdatasync
> system calls too :-) (actually fcntls))

Linux has sync_file_range which currently is a perfect way to lose your
synced' data, but with two more flags and calls to ->fsync we could
turn it into range-fsync/fdatasync.  I'm not sure if that's a good
idea or if we should just add a sys_fdatasync_rage systems call.

I don't quite see the point of a range-fsync, but it could be easily
implemented as a flag.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
