Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 May 2008 23:48:43 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4F6mWvJ021095
	for <xfs@oss.sgi.com>; Wed, 14 May 2008 23:48:34 -0700
Subject: PARTIAL TAKE 981816 - Fix pathname filter issue in 166
Message-Id: <20080515064916.D6AFA58C4C29@chook.melbourne.sgi.com>
Date: Thu, 15 May 2008 16:49:16 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix pathname filter issue.

If the path to the file being bmap'd has a [0-9] in it,
the output filter matches it and we get golden output
failure. Be more specific on the match.


Date:  Thu May 15 16:48:30 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/xfs-cmds
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:31170a
xfstests/166 - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/166.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
	- Be more specific when trying to match extent output lines.
