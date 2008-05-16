Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 May 2008 19:26:59 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4G2Arhi001184
	for <xfs@oss.sgi.com>; Thu, 15 May 2008 19:10:56 -0700
Subject: TAKE 981813 - Fix memory corruption with small buffer reads
Message-Id: <20080516021135.46AB658C4C29@chook.melbourne.sgi.com>
Date: Fri, 16 May 2008 12:11:35 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix memory corruption with small buffer reads

When we have multiple buffers in a single page for a blocksize == pagesize
filesystem we might overwrite the page contents if two callers hit it
shortly after each other.  To prevent that we need to keep the page
locked until I/O is completed and the page marked uptodate.

Thanks to Eric Sandeen for triaging this bug and finding a reproducible
testcase and Dave Chinner for additional advice.

This should fix kernel.org bz #10421.


Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Eric Sandeen <sandeen@sandeen.net>

Date:  Fri May 16 12:10:56 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31173a
fs/xfs/linux-2.6/xfs_buf.h - 1.125 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.h.diff?r1=text&tr1=1.125&r2=text&tr2=1.124&f=h
	- Reintroduce page locking for sub-blocksize buffer read synchronisation.

fs/xfs/linux-2.6/xfs_buf.c - 1.256 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.c.diff?r1=text&tr1=1.256&r2=text&tr2=1.255&f=h
	- Reintroduce page locking for sub-blocksize buffer read synchronisation.
