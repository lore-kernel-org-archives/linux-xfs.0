Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Dec 2006 18:02:53 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kB822aaG002542
	for <xfs@oss.sgi.com>; Thu, 7 Dec 2006 18:02:43 -0800
Date: Fri, 8 Dec 2006 13:01:33 +1100 (AEDT)
From: Barry Naujok <bnaujok@snort.melbourne.sgi.com>
Message-Id: <200612080201.kB821XAk56553876@snort.melbourne.sgi.com>
Subject: TAKE 958795 - [PATCH 1/2]segmentation fault in xfs_io mread/mwrite command
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix up xfs_io mread command that read from the wrong offset


Date:  Fri Dec  8 13:00:18 AEDT 2006
Workarea:  snort.melbourne.sgi.com:/home/bnaujok/isms/repair
Inspected by:  utako@tnes.nec.co.jp

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:27661a
xfstests/141 - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/141
xfstests/141.out - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/141.out
	- Added QA test for xfs_io mread command

xfsprogs/doc/CHANGES - 1.230 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/doc/CHANGES.diff?r1=text&tr1=1.230&r2=text&tr2=1.229&f=h
	- Fix up xfs_io mread command that read from the wrong offset

xfstests/group - 1.96 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/group.diff?r1=text&tr1=1.96&r2=text&tr2=1.95&f=h
	- Added QA test for xfs_io mread command

xfsprogs/man/man8/xfs_io.8 - 1.10 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/man/man8/xfs_io.8.diff?r1=text&tr1=1.10&r2=text&tr2=1.9&f=h
	- Updated manpage for some xfs_io commands

xfsprogs/io/mmap.c - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/io/mmap.c.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
	- Fix up xfs_io mread command that read from the wrong offset
