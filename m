Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8E3F87CA0
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 18:43:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 11D22AC004
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 16:43:10 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id wEsGUtxg18s4HGTF (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 13 Aug 2016 16:43:05 -0700 (PDT)
Received: from [107.17.164.165] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bYia0-0006L1-6V
	for xfs@oss.sgi.com; Sat, 13 Aug 2016 23:43:04 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: first set of iomap fix
Date: Sat, 13 Aug 2016 16:42:54 -0700
Message-Id: <1471131781-14107-1-git-send-email-hch@lst.de>
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

This contains various fixes for the iomap path for 4.8, but it skips
the changes to the delalloc path (which aren't really about the iomap
path itself anyway).

Two fixes to make the iomap buffered write path catch up with changes
to the filemap one.  Then I've cherry picked the FIEMAP_FLAG_SYNC patch
from Dave, and added my version of re-implementing FIEMAP_FLAG_XATTR
as well.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
