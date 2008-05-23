Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 23 May 2008 03:22:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4NALufF029103
	for <xfs@oss.sgi.com>; Fri, 23 May 2008 03:21:57 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C1DA5BD2FA0
	for <xfs@oss.sgi.com>; Fri, 23 May 2008 03:22:46 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id doF5NPgRMHuFhrDs for <xfs@oss.sgi.com>; Fri, 23 May 2008 03:22:46 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m4NAMdF3018507
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 23 May 2008 12:22:39 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m4NAMdSa018505
	for xfs@oss.sgi.com; Fri, 23 May 2008 12:22:39 +0200
Date: Fri, 23 May 2008 12:22:39 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: locking in xfs_unmount_flush
Message-ID: <20080523102238.GA18456@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Does anybody have an idea why the ilock on the root inode is held
over flushing and releasing of the rt and quota inodes in
xfs_unmount_flush?  I've looked through all that code and can't find
any reason why we'd want it.
