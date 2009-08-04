Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n74EHjQN171001 for <xfs@oss.sgi.com>; Tue, 4 Aug 2009 09:17:46 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8C3B51D52157
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2009 07:18:36 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ArmvkV1zPskxNp06 for
	<xfs@oss.sgi.com>; Tue, 04 Aug 2009 07:18:36 -0700 (PDT)
Message-Id: <20090804141554.992235000@bombadil.infradead.org>
Date: Tue, 04 Aug 2009 10:15:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/4] XFS iget fixes
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
Cc: linux-fsdevel@vger.kernel.org

These should fix the fallout from the xfs_inode/VFS inode merge.  The first
patch contains just locking changes to the iget hit patch and is conceptually
unrelated to the rest, but required for them to apply.

The other three patches deal basically with the problem that we really
don't want to delete the inode that won the race and got added to the inode
cache radix tree when we free the inode that lost it.  To do so we need
to change the hooks into inode.c that were exported only for this kind of
use in XFS.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
