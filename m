Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 May 2008 23:44:27 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4F6iGTS020293
	for <xfs@oss.sgi.com>; Wed, 14 May 2008 23:44:18 -0700
Subject: PARTIAL TAKE 981816 - XFSQA 008 - Takes too long on UML
Message-Id: <20080515064501.449FB58C4C29@chook.melbourne.sgi.com>
Date: Thu, 15 May 2008 16:45:01 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

With the recent change for reliability with 64k page size
made to test 008,the file sizes got much larger. It appears
that randholes actually reads the entire file, so this has
slowed the test down by a factor of ten (all file sizes
were increased by 10x). This means the test is now taking
about 18 minutes to run on a UML session, and all the time
is spent reading the files.

Instead, scale the file size based on the page size. We know
how many holes we are trying to produce and the I/O size
being used to produce them, so the size of the files can be
finely tuned. Assuming a decent random distribution, if the
number of blocks in the file is 4x the page size and the
I/O size is page sized, this means that every I/O should
generate a new hole and we'll only get a small amount of
adjacent extents. This has passed over 10 times on ia64
w/ 64k page and another 15 times on UML with 4k page.

UML runtime is down from ~1000s to 5s, ia64 runtime is down from
~30s to 7s.


Date:  Thu May 15 16:44:20 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/xfs-cmds
Inspected by:  tes@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:31168a
xfstests/008 - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/008.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
xfstests/008.out - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/008.out.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
	- Greatly reduce runtime by reducing filesizes down to sane minimum.
