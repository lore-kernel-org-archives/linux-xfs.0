Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Mar 2008 21:35:48 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2P4ZbE1029363
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2008 21:35:39 -0700
Subject: TAKE 979085 - xfsqa 141 fails on 64k page size machines
Message-Id: <20080325043607.6F65758C4C0F@chook.melbourne.sgi.com>
Date: Tue, 25 Mar 2008 15:36:07 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Make test 141 work on 64k page size machines

Make the file larger and read 64k from it instead of 16k
so that it pulls in a full page from the middle of the file.


Date:  Tue Mar 25 15:35:35 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/xfs-cmds
Inspected by:  hch@infradead.org,jeffpc@josefsipek.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30703a
xfstests/141 - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/141.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
	- Use a large file and 64k I/O size so the test works on 64k page
	  size machines.
