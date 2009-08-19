Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7JGPr3T216966 for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 11:26:08 -0500
Date: Wed, 19 Aug 2009 12:26:38 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/17] vfs: Introduce new helpers for syncing after
	writing to O_SYNC file or IS_SYNC inode
Message-ID: <20090819162638.GE6150@infradead.org>
References: <1250697884-22288-1-git-send-email-jack@suse.cz>
	<1250697884-22288-8-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1250697884-22288-8-git-send-email-jack@suse.cz>
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
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, linux-ntfs-dev@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>, Joel Becker <joel.becker@oracle.com>, hch@infradead.org, Anton Altaparmakov <aia21@cantab.net>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Evgeniy Polyakov <zbr@ioremap.net>, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

Looks good to me.  Eventually we should use those SYNC_ flags also all
through the fsync codepath, but I'll see if I can incorporate that in my
planned fsync rewrite.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
