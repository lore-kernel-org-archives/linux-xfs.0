Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 14 Sep 2008 18:01:41 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8F11dlO026682
	for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 18:01:39 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5097B1299FC4
	for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 18:03:09 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id iLafF8oGdo6deelc for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 18:03:09 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m8F139IF013144
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 03:03:09 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m8F139js013142
	for xfs@oss.sgi.com; Mon, 15 Sep 2008 03:03:09 +0200
Date: Mon, 15 Sep 2008 03:03:09 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 0/4] add crcs for btree blocks
Message-ID: <20080915010309.GA13062@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

This patch series adds crcs for btree blocks.  The first three patches
contain some preparatory work, and the final one implements the actual
extended btree blocks with crcs and a uuid / blkno pair to identify out of
place writes.  Note that this is only the start of CRC enabling XFS and it
will be followed by more patches later.

To actually create a CRC enabled filesystem you will need a patched xfsprogsa
.  A quilt series with all required patches against current xfs-cmds CVS HEAD
is here:

	http://verein.lst.de/~hch/xfs/xfs-cmds-crcs.tgz

Please note that the xfs-cmds patch series is not quite in a submittable
shape yet, and will always create CRC enabled filesystems with these
patches applied.

-- 
