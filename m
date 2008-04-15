Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 Apr 2008 01:08:49 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3F88QcS028136
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2008 01:08:28 -0700
Subject: TAKE 980319 - Remove sysv3 legacy functions
Message-Id: <20080415080900.C64A958C4C15@chook.melbourne.sgi.com>
Date: Tue, 15 Apr 2008 18:09:00 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com


Date:  Tue Apr 15 18:08:38 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xcmds-clean
Inspected by:  nkukard@lbsd.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30883a
xfsprogs/mkfs/proto.c - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/mkfs/proto.c.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
xfsprogs/mkfs/xfs_mkfs.c - 1.89 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/mkfs/xfs_mkfs.c.diff?r1=text&tr1=1.89&r2=text&tr2=1.88&f=h
xfsprogs/rtcp/xfs_rtcp.c - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/rtcp/xfs_rtcp.c.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
xfsprogs/logprint/log_misc.c - 1.23 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/logprint/log_misc.c.diff?r1=text&tr1=1.23&r2=text&tr2=1.22&f=h
xfsprogs/growfs/xfs_growfs.c - 1.29 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/growfs/xfs_growfs.c.diff?r1=text&tr1=1.29&r2=text&tr2=1.28&f=h
xfsprogs/repair/phase6.c - 1.42 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase6.c.diff?r1=text&tr1=1.42&r2=text&tr2=1.41&f=h
xfsprogs/repair/incore_bmc.c - 1.8 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/incore_bmc.c.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
xfsprogs/repair/dir2.c - 1.25 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/dir2.c.diff?r1=text&tr1=1.25&r2=text&tr2=1.24&f=h
xfsprogs/repair/sb.c - 1.21 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/sb.c.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
xfsprogs/repair/dir.c - 1.22 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/dir.c.diff?r1=text&tr1=1.22&r2=text&tr2=1.21&f=h
xfsprogs/repair/phase4.c - 1.25 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase4.c.diff?r1=text&tr1=1.25&r2=text&tr2=1.24&f=h
xfsprogs/repair/dinode.c - 1.29 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/dinode.c.diff?r1=text&tr1=1.29&r2=text&tr2=1.28&f=h
xfsprogs/repair/phase5.c - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase5.c.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
xfsprogs/repair/agheader.c - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/agheader.c.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
xfsprogs/repair/rt.c - 1.10 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/rt.c.diff?r1=text&tr1=1.10&r2=text&tr2=1.9&f=h
xfsprogs/repair/globals.h - 1.22 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/globals.h.diff?r1=text&tr1=1.22&r2=text&tr2=1.21&f=h
xfsprogs/repair/incore.c - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/incore.c.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
xfsprogs/repair/incore_ino.c - 1.18 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/incore_ino.c.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h
xfsprogs/repair/attr_repair.c - 1.21 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/attr_repair.c.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
xfsprogs/libhandle/jdm.c - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libhandle/jdm.c.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
xfsprogs/io/bmap.c - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/io/bmap.c.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
	- Remove sysv3 legacy functions

xfsprogs/copy/xfs_copy.c - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/copy/xfs_copy.c.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
	- nRemove sysv3 legacy functions
