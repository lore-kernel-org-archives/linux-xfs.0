Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 15:54:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8PMsfSM024197
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 15:54:42 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7363248509B
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 15:56:14 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id c6T85uGWFSncogMi for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 15:56:14 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m8PMuDIF009841
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 00:56:13 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m8PMuDWu009839
	for xfs@oss.sgi.com; Fri, 26 Sep 2008 00:56:13 +0200
Date: Fri, 26 Sep 2008 00:56:13 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 0/9] CRC support for superblock, ag headers, log and btree blocks
Message-ID: <20080925225613.GA9822@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Here's an updated crc series for various metadata structures.  We're still
looking at the magic number in the log recovery case because getting down
a buffer type for the other structures wasn't quite as easy as for the
btree block.  I'll probably look into that again once we're done with all
data structures.

-- 
