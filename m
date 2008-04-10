Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Apr 2008 12:00:54 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3AJ0atB005979
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 12:00:37 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 83BFF9A04CB
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 12:01:14 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 1YBExU2JRqQaUSYA for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 12:01:14 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m3AIsjF3007684
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 20:54:45 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m3AIsjkj007682
	for xfs@oss.sgi.com; Thu, 10 Apr 2008 20:54:45 +0200
Date: Thu, 10 Apr 2008 20:54:45 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: odd code in xfs_remove
Message-ID: <20080410185445.GA7521@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

unlike xfs_rmdir or xfs_rename xfs_remove always passes 0 instead of the
reserved blocks to xfs_dir_removename which means the latter always
operated in the ENOSPC mode.  This seems rather strange to me, so a
second pair of eyes, especially on a tree with history back to day 0
would be nice.
