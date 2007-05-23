Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 May 2007 17:59:40 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4N0xZWt007388
	for <xfs@oss.sgi.com>; Tue, 22 May 2007 17:59:37 -0700
Subject: TAKE 965068 - write at EOF fails to update filesize
Message-Id: <20070523005932.226D858CA531@chook.melbourne.sgi.com>
Date: Wed, 23 May 2007 10:59:32 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Write at EOF may not update filesize correctly.

The recent fix for preventing NULL files from being left around
does not update the file size corectly in all cases. The missing
case is a write extending the file that does not need to allocate
a block.

In that case we used a read mapping of the extent which forced
the use of the read I/O completion handler instead of the
write I/O completion handle. Hence the file size was not updated
on I/O completion.

Date:  Wed May 23 10:58:50 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  nscott@aconex.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28657a
fs/xfs/linux-2.6/xfs_aops.c - 1.143 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_aops.c.diff?r1=text&tr1=1.143&r2=text&tr2=1.142&f=h
	- Ensure we use an I/O completion handler that can update the filesize
	  for all types of write regardless of whether we need to do allocation
	  or not.
