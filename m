Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Jun 2008 23:43:56 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5O6hnpS017271
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2008 23:43:51 -0700
Subject: PARTIAL TAKE 981526 - XFSQA - Add CI test
Message-Id: <20080624064444.9A07E58C4C3F@chook.melbourne.sgi.com>
Date: Tue, 24 Jun 2008 16:44:44 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Add CI stat/create/unlink test for multiple directory forms


Date:  Tue Jun 24 15:46:26 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:31347a
xfstests/src/genhashnames.c - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/src/genhashnames.c
	- Generate filenames with the same hash value

xfstests/src/Makefile - 1.44 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/src/Makefile.diff?r1=text&tr1=1.44&r2=text&tr2=1.43&f=h
	- Add genhashnames target

xfstests/src/nametest.c - 1.8 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/src/nametest.c.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
	- Add case-changing option
