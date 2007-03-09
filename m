Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 08 Mar 2007 20:17:52 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l294Hg6p009325
	for <xfs@oss.sgi.com>; Thu, 8 Mar 2007 20:17:46 -0800
Subject: TAKE 961970 - __u32 test in package m4 macro instead of AC_CHECK_TYPES
Message-Id: <20070309041738.3C36B58F9284@chook.melbourne.sgi.com>
Date: Fri,  9 Mar 2007 15:17:38 +1100 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Need to check for __u32 in our own m4 macro instead of using AC_CHECK_TYPES
which doesn't exist on some older autoconf's.

Date:  Fri Mar  9 15:16:33 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/tes/xfs-cmds
Inspected by:  nscott@aconex.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:28226a
xfsprogs/configure.in - 1.38 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/configure.in.diff?r1=text&tr1=1.38&r2=text&tr2=1.37&f=h
xfsprogs/doc/CHANGES - 1.236 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/doc/CHANGES.diff?r1=text&tr1=1.236&r2=text&tr2=1.235&f=h
xfsprogs/aclocal.m4 - 1.25 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/aclocal.m4.diff?r1=text&tr1=1.25&r2=text&tr2=1.24&f=h
xfsprogs/m4/package_types.m4 - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/m4/package_types.m4.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
	- Need to check for __u32 in our own m4 macro instead of using AC_CHECK_TYPES
	  which doesn't exist on some older autoconf's.
