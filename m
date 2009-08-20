Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7KCErW6091054 for <xfs@oss.sgi.com>; Thu, 20 Aug 2009 07:15:04 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 62C901D5D959
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2009 05:15:36 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id MdwXWXYFNNEmAWBf for <xfs@oss.sgi.com>;
	Thu, 20 Aug 2009 05:15:36 -0700 (PDT)
Date: Thu, 20 Aug 2009 14:15:31 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 07/17] vfs: Introduce new helpers for syncing after
	writing to O_SYNC file or IS_SYNC inode
Message-ID: <20090820121531.GC16486@duck.novell.com>
References: <1250697884-22288-1-git-send-email-jack@suse.cz>
	<1250697884-22288-8-git-send-email-jack@suse.cz>
	<20090819162638.GE6150@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090819162638.GE6150@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-ntfs-dev@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>, Joel Becker <joel.becker@oracle.com>, Anton Altaparmakov <aia21@cantab.net>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Evgeniy Polyakov <zbr@ioremap.net>, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

On Wed 19-08-09 12:26:38, Christoph Hellwig wrote:
> Looks good to me.  Eventually we should use those SYNC_ flags also all
> through the fsync codepath, but I'll see if I can incorporate that in my
> planned fsync rewrite.
  Yes, I thought I'll leave that for later. BTW it should be fairly easy to
teach generic_sync_file() to do fdatawait() before calling ->fsync() if the
filesystem sets some flag in inode->i_mapping (or somewhere else) as is
needed for XFS, btrfs, etc.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
