Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 05 Dec 2007 21:18:04 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lB65Hsqr015425
	for <xfs@oss.sgi.com>; Wed, 5 Dec 2007 21:17:59 -0800
Subject: TAKE 973377 - cleanup to use generic linux filldir causes nfsd hang
Message-Id: <20071206051756.A822558FA1B8@chook.melbourne.sgi.com>
Date: Thu,  6 Dec 2007 16:17:56 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

revert to double-buffering readdir

The current readdir implementation deadlocks on a btree buffers locks
because nfsd calls back into ->lookup from the filldir callback.  The
only short-term fix for this is to revert to the old inefficient
double-buffering scheme.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Thu Dec  6 16:17:12 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30201a
fs/xfs/linux-2.6/xfs_file.c - 1.159 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_file.c.diff?r1=text&tr1=1.159&r2=text&tr2=1.158&f=h
	- revert the readdir code to using double buffering to work around a
	  deadlock with nfsd calling back into the lookup code from filldir.
