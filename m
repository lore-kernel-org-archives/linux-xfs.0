Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Apr 2008 12:04:30 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3AJ4LTU006951
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 12:04:23 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AD1019A9140
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 12:04:59 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id dDI37RxjDCDe4gy2 for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 12:04:59 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m3AJ4rF3008183
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 21:04:53 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m3AJ4reK008181
	for xfs@oss.sgi.com; Thu, 10 Apr 2008 21:04:53 +0200
Date: Thu, 10 Apr 2008 21:04:53 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: iget behaviour in xlog_recover_process_iunlinks
Message-ID: <20080410190453.GA8083@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

shouldn't we call xfs_iget with the XFS_IGET_CREATE flag here?

the code seems to be perfectly happy with zero-ed out inodes as long as
di_next_unlinked is valid.
