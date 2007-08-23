Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 12:36:41 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7NJaZ4p002444
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 12:36:38 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l7NJaXA5008373
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 21:36:33 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l7NJaX0t008371
	for xfs@oss.sgi.com; Thu, 23 Aug 2007 21:36:33 +0200
Date: Thu, 23 Aug 2007 21:36:33 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 0/17] vnode/vfs and vnode/vfs operations removal
Message-ID: <20070823193633.GA8050@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

XFS has long carried around some baggage left from IRIX, and the vnodes
and vfs objects aswell as the associated operation vectors re probably
the worst, both in their impact in size aswell as in maintainability of
the code.  This patchset removes all this cruft, and allow at the same
time to do a more clear split between the generic and the linux-specific
parts of the current XFS codebase.

The patchseries allows for some quite nice reduction in size of both
the source an binary code:

 113 files changed, 2114 insertions(+), 4002 deletions(-)

-rw-r--r-- 1 hch hch 9394858 2007-08-23 19:43 xfs.ko.new
-rw-r--r-- 1 hch hch 9660812 2007-08-23 19:13 xfs.ko.old
