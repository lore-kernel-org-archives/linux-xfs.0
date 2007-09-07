Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 06 Sep 2007 22:33:36 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l875XV4p018644
	for <xfs@oss.sgi.com>; Thu, 6 Sep 2007 22:33:33 -0700
Subject: TAKE 970180 - Link xfsprogs utils to libpthread when linking to libxfs
Message-Id: <20070907053327.E228258C4C09@chook.melbourne.sgi.com>
Date: Fri,  7 Sep 2007 15:33:27 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Link xfsprogs utils to libpthread when linking to libxfs


Date:  Fri Sep  7 15:32:31 AEST 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  vapier@gentoo.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:29621a
xfsprogs/VERSION - 1.176 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/VERSION.diff?r1=text&tr1=1.176&r2=text&tr2=1.175&f=h
xfsprogs/doc/CHANGES - 1.246 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/doc/CHANGES.diff?r1=text&tr1=1.246&r2=text&tr2=1.245&f=h
	- Bump version number to 2.9.4

xfsprogs/db/Makefile - 1.18 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/Makefile.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h
xfsprogs/mkfs/Makefile - 1.18 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/mkfs/Makefile.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h
xfsprogs/logprint/Makefile - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/logprint/Makefile.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
xfsprogs/growfs/Makefile - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/growfs/Makefile.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
xfsprogs/repair/Makefile - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/Makefile.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
xfsprogs/mdrestore/Makefile - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/mdrestore/Makefile.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
	- Link to libpthread
