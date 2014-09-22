Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 546D07F4E
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2014 12:35:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 430D7304039
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2014 10:35:53 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id gGJ7nc9VopPFOHs6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 22 Sep 2014 10:35:47 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1XW7Wb-0006nd-HA
	for xfs@oss.sgi.com; Mon, 22 Sep 2014 17:35:45 +0000
Date: Mon, 22 Sep 2014 10:35:45 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: beginners project: RENAME_EXCHANGE
Message-ID: <20140922173545.GA20308@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

As people are looking for beginners projects one in a while there's
an easy one at the moment:  implement support for the RENAME_EXCHANGE
flag to the renameat2 system call, which swaps the names for two
existing files.  Documentation here:

http://man7.org/linux/man-pages/man2/rename.2.html

This should mostly be doable by refactoring (or more likely copy &
pasting) the existing rename implementation.  xfstests already has test
case for it, although making sure they covering everything would be a
nice extrea.

(if no one replies to the list I will add it to the wiki after a while)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
