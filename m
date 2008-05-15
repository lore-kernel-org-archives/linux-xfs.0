Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 May 2008 00:07:26 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4F7738M024970
	for <xfs@oss.sgi.com>; Thu, 15 May 2008 00:07:06 -0700
Subject: TAKE 981816 - Don't run 167 if killall is not installed
Message-Id: <20080515070741.B63D158C4C29@chook.melbourne.sgi.com>
Date: Thu, 15 May 2008 17:07:41 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Don't run 167 if killall is not installed

Test 167 will leave runaway fsstress processes around in case killall is
not installed and thus make all following tests fail.  This patch checks
for killall beeing installed and error out otherwise.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Thu May 15 17:07:24 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/xfs-cmds
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:31171a
xfstests/167 - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/167.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
	- don't run if killall is not installed.
