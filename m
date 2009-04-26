Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3QE79GU233109 for <xfs@oss.sgi.com>; Sun, 26 Apr 2009 09:07:12 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8AE7C23E3E1
	for <xfs@oss.sgi.com>; Sun, 26 Apr 2009 07:07:08 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id EJ1NcFYz5fFQFGKr for
	<xfs@oss.sgi.com>; Sun, 26 Apr 2009 07:07:08 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1Ly50d-0008Gu-Dx
	for xfs@oss.sgi.com; Sun, 26 Apr 2009 14:07:07 +0000
Message-Id: <20090426140305.113371000@bombadil.infradead.org>
Date: Sun, 26 Apr 2009 10:03:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/5] fix sync (test 182, grub)
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

Revisit Dave's prototype to make sync equivalent to freeze, that is make
sure not only we have all data on disk, but also the metadata in the right
place and not requite a log recovery.  That fixes test 182 and should also
help with the frequent grub complaints.

The patches require Jan Kara's sync rewrite on -fsdevel and lkml
(http://lkml.indiana.edu/hypermail/linux/kernel/0904.2/03643.html)
so that sync actually calls into the filesystem in the correct order
for the various parts of sync activity.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
