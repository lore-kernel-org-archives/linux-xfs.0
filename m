Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Apr 2007 03:13:41 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3OADZfB026317
	for <xfs@oss.sgi.com>; Tue, 24 Apr 2007 03:13:37 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l3OADVLD029752
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 24 Apr 2007 12:13:31 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l3OADVE8029750
	for xfs@oss.sgi.com; Tue, 24 Apr 2007 12:13:31 +0200
Date: Tue, 24 Apr 2007 12:13:31 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [RFC PATCH 0/3] deleted inode reclaim cleanup
Message-ID: <20070424101331.GA29731@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I've ported forward my old patches related to reclaiming delete
inodes on m_del_inodes.  This hasn't gotten testing with the
current kernel although it completed xfsqa in the version against
a kernel from about a year ago.
