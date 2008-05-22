Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 22 May 2008 09:25:18 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4MGPFsD024231
	for <xfs@oss.sgi.com>; Thu, 22 May 2008 09:25:16 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7531C1713612
	for <xfs@oss.sgi.com>; Thu, 22 May 2008 09:26:05 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id sNjYRsA58GZrf3Pn for <xfs@oss.sgi.com>; Thu, 22 May 2008 09:26:05 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m4MGPwF3011108
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 22 May 2008 18:25:58 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m4MGPwG1011106
	for xfs@oss.sgi.com; Thu, 22 May 2008 18:25:58 +0200
Date: Thu, 22 May 2008 18:25:58 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: xfs_open
Message-ID: <20080522162558.GA11036@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Currently xfs_open is only called for regular files, but the only
non-trivial code in there is for directories.  We probably should wire
up an ->open that does the XFS_FORCED_SHUTDOWN check for directories
anyway, but should we bring back the directory readahead?

Anyone on this list bored enough to benchmark it?
