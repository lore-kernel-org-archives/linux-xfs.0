Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Sep 2006 19:01:15 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k8520dDW005141
	for <linux-xfs@oss.sgi.com>; Mon, 4 Sep 2006 19:00:50 -0700
Subject: TAKE 955939 - writing by splice() doesn't work in 2.6.17+
Message-Id: <20060905015949.334BF58CF851@chook.melbourne.sgi.com>
Date: Tue,  5 Sep 2006 11:59:49 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Fix xfs_splice_write() so appended data gets to disk.

xfs_splice_write() failed to update the on disk inode size when
extending the so when the file was closed the range extended by
splice was truncated off. Hence any region of a file written
to by splice would end up as a hole full of zeros.

Date:  Tue Sep  5 11:58:45 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:26920a
fs/xfs/linux-2.6/xfs_lrw.c - 1.251 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_lrw.c.diff?r1=text&tr1=1.251&r2=text&tr2=1.250&f=h
	- Update xfs inode size if xfs_splice_write is writing beyond the
	  end of the current file.
