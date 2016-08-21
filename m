Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1A3D57CA0
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2016 16:51:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 82468AC003
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2016 14:51:19 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id AX0rdISHwpLRF8D2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 21 Aug 2016 14:51:17 -0700 (PDT)
Received: from [83.175.99.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bbaeB-0002TF-Lw
	for xfs@oss.sgi.com; Sun, 21 Aug 2016 21:51:16 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: iomap write fixes
Date: Sun, 21 Aug 2016 23:51:09 +0200
Message-Id: <1471816273-28940-1-git-send-email-hch@lst.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

These have already been discussed in a lkml thread for a while, so
I wanted to formally send them out.  The problem was that as part of
a AIM7 regression we saw that we spend a lot of time looking up
extent records.  I turns out that the current delayed write path
is horribly inefficient, and we can generall do with a single btree
lookup for the write path.  Also xfs_inode_set_eofblocks_tag turns
out to trash the cache quite bad, so add a trivial flag to avoid
it if we can.

Compared to the git tree under discussion only one changelog has
been updated, and I've added a copyright statement to xfs_iomap.c
now that it has a lot of my code.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
