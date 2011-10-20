Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9KE9eKC005151 for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 09:09:40 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 016891DF05C
	for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 07:09:36 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	R19YpxrzrFCGY5Sh for <xfs@oss.sgi.com>;
	Thu, 20 Oct 2011 07:09:36 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RGtJP-0006Wm-Es
	for xfs@oss.sgi.com; Thu, 20 Oct 2011 14:09:35 +0000
Message-Id: <20111020140701.547662473@bombadil.infradead.org>
Date: Thu, 20 Oct 2011 10:07:01 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/4] inode diet, part2 - size fields
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This series is a bit more complicated than the previous one, that's
why I'm sending it out separately.

It removes the i_size and i_new_size fields from the xfs_inode, which
is both reduces the size of the xfs_inode and code complexity around
managing the various inodes sizes significantly.  This reduces
complexity of only managing 2 instead of four inode sizes also is
a preparation for the next series which will always log inode size
updates instead of using VFS dirty tracking for it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
