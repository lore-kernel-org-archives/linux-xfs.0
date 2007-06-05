Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Jun 2007 00:52:21 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l557qGWt011448
	for <xfs@oss.sgi.com>; Tue, 5 Jun 2007 00:52:18 -0700
Subject: TAKE 964647 - file corruption seen when DMF recalls files with buffered i/o
Message-Id: <20070605075212.B502958C38C1@chook.melbourne.sgi.com>
Date: Tue,  5 Jun 2007 17:52:12 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Map unwritten extents correctly for I/o completion processing

If we have multiple unwritten extents within a single page, we fail
to tell the I/o completion construction handlers we need a new handle
for the second and subsequent blocks in teh page. While we still issue
the I/O correctly, we do not have the correct ranges recorded in the
ioend structures and hence when we go to convert the unwritten extents
we screw it up.

Make sure we start a new ioend every time the mapping changes
so that we convert the correct ranges on I/O completion.

Date:  Tue Jun  5 17:51:26 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28797a
fs/xfs/linux-2.6/xfs_aops.c - 1.146 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_aops.c.diff?r1=text&tr1=1.146&r2=text&tr2=1.145&f=h
	- If the mapping changes between blocks in xfs_page_state_convert, make
	  sure that we also start a new ioend for the new mapping.
