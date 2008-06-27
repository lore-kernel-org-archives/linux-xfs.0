Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 27 Jun 2008 08:38:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5RFcbxm027811
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 08:38:37 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9C5BF293A56
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 08:39:37 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id LbVCcTEDRgAQC4I7 for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 08:39:37 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m5RFdSNW031445
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 17:39:28 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m5RFdSRK031442
	for xfs@oss.sgi.com; Fri, 27 Jun 2008 17:39:28 +0200
Date: Fri, 27 Jun 2008 17:39:28 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: rfc: kill ino64 mount option
Message-ID: <20080627153928.GA31384@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Does anyone have objections to kill the ino64 mount option?  It's purely
a debug tool to force inode numbers outside of the range representable
in 32bits and is quite invasive for something that could easily be
debugged by just having a large enough filesystem..
