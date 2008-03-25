Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Mar 2008 21:32:20 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2P4WA4T028704
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2008 21:32:12 -0700
Subject: TAKE 979083 - xfsqa test 166 fails on 64k page machine
Message-Id: <20080325043240.C4C0A58C4C0F@chook.melbourne.sgi.com>
Date: Tue, 25 Mar 2008 15:32:40 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

xfsqa test 166 fails on 64k page machine

test 166 output is dependent on page size (mmap related). Make
the output filter turn the output into something independent of
page size whilst checking that the output is valid.

Date:  Tue Mar 25 15:32:20 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/xfs-cmds
Inspected by:  hch@infradead.org,jeffpc@josefsipek.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30702a
xfstests/166 - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/166.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
	- Make the file size and I/O size large enough that 64k pages are
	  handled correctly.

xfstests/166.out - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/166.out.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
	- Make the golden output page size independent.
