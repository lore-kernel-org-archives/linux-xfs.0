Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8PNfrqw258483 for <xfs@oss.sgi.com>; Sat, 25 Sep 2010 18:41:54 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A58E49E619
	for <xfs@oss.sgi.com>; Sat, 25 Sep 2010 16:42:50 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id lVK7IW5uBCLXcIRa for
	<xfs@oss.sgi.com>; Sat, 25 Sep 2010 16:42:50 -0700 (PDT)
Date: Sat, 25 Sep 2010 19:42:48 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/18] xfs: don't use vfs writeback for pure metadata
	modifications
Message-ID: <20100925234248.GA23975@infradead.org>
References: <1285331476-23015-1-git-send-email-david@fromorbit.com>
	<1285331476-23015-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1285331476-23015-6-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

As mentioned before I think xfs_trans_ichgtime should go into
xfs_trans_inode.c/xfs_trans.h.  Instead of keeping xfs_ichgtime around
for one caller it might be easier to just opencode it similar to
what other filesystems do, e.g. just:

	inode->i_mtime = inode->i_ctime = current_fs_time(inode->i_sb);
	mark_inode_dirty_sync(inode);

there's really no point in doing the check for an actual time change
first as it's a relatively rare operation.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
