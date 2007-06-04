Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Jun 2007 00:18:50 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l547IiWt020789
	for <xfs@oss.sgi.com>; Mon, 4 Jun 2007 00:18:46 -0700
Subject: TAKE 964092 -  synchronous direct I/O write calls are incomplete when returning to user space
Message-Id: <20070604071840.341A958C38C1@chook.melbourne.sgi.com>
Date: Mon,  4 Jun 2007 17:18:40 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Block on unwritten extent conversion during synchronous direct I/O.

Currently we do not wait on extent conversion to occur, and hence we
can return to userspace from a sycnhronous direct I/O write without
having completed all teh actions in the write. Hence a read after
the write may see zeroes (unwritten extent) rather than the data
that was written.

Block the I/O completion by triggering a synchronous workqueue flush
to ensure that the conversion has occurred before we return to
userspace.


Date:  Mon Jun  4 17:18:01 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  tes@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28775a
fs/xfs/linux-2.6/xfs_aops.c - 1.144 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_aops.c.diff?r1=text&tr1=1.144&r2=text&tr2=1.143&f=h
	- Make unwritten extent conversion occur synchronously for synchronous
	  direct I/O to ensure it is completed before we return to userspace.
