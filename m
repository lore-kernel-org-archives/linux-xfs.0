Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 29 Sep 2007 04:09:27 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8TB9M0W021762
	for <xfs@oss.sgi.com>; Sat, 29 Sep 2007 04:09:24 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l8TB9LF3002516
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 29 Sep 2007 13:09:21 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l8TB9L1J002514
	for xfs@oss.sgi.com; Sat, 29 Sep 2007 13:09:21 +0200
Date: Sat, 29 Sep 2007 13:09:21 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: sync_blockdev in xfs_flush_device_work
Message-ID: <20070929110921.GA2466@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

How is the sync_blockdev in the ENOSP path going to help it?  It only
syncs the block device mapping which XFS doesn't use it at all.
