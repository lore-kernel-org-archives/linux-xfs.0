Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Aug 2006 20:15:22 -0700 (PDT)
Received: from imr2.americas.sgi.com (imr2.americas.sgi.com [198.149.16.18])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k793EwDW019988
	for <xfs@oss.sgi.com>; Tue, 8 Aug 2006 20:15:08 -0700
Subject: TAKE 955273 - 
Message-Id: <20060809031419.EC1B71DD718@attica.americas.sgi.com>
Date: Tue,  8 Aug 2006 22:14:19 -0500 (CDT)
From: wkendall@sgi.com (Bill Kendall)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@sgi.com, sgi.bugs.xfs@sgi.com

Remove xfsdump's dependency on libdm by substituting libdm calls
with existing routines in libhandle.


Date:  Tue Aug  8 20:12:52 PDT 2006
Workarea:  attica.americas.sgi.com:/data/lwork/attica2/wkendall/stout/work/pl_root/xfs
Inspected by:  dean.roehrich@sun.com,cattelan@thebarn.com

The following file(s) were checked into:
  bonnie.engr.sgi.com:/isms/xfs-cmds/master


Modid:  master:xfs-cmds:213628a
xfsdump/configure.in - 1.41 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/configure.in.diff?r1=text&tr1=1.41&r2=text&tr2=1.40&f=h
xfsdump/VERSION - 1.83 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/VERSION.diff?r1=text&tr1=1.83&r2=text&tr2=1.82&f=h
xfsdump/doc/CHANGES - 1.95 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/doc/CHANGES.diff?r1=text&tr1=1.95&r2=text&tr2=1.94&f=h
xfsdump/dump/Makefile - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/dump/Makefile.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
xfsdump/build/rpm/xfsdump.spec.in - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/build/rpm/xfsdump.spec.in.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
xfsdump/include/builddefs.in - 1.30 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/include/builddefs.in.diff?r1=text&tr1=1.30&r2=text&tr2=1.29&f=h
xfsdump/restore/Makefile - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/restore/Makefile.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
xfsdump/debian/control - 1.23 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/debian/control.diff?r1=text&tr1=1.23&r2=text&tr2=1.22&f=h
xfsdump/debian/shlibs.local - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/debian/shlibs.local.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
xfsdump/aclocal.m4 - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/aclocal.m4.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
xfsdump/m4/package_dmapidev.m4 - 1.3 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/m4/package_dmapidev.m4.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
xfsdump/m4/Makefile - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/m4/Makefile.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
xfsdump/common/hsmapi.c - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/common/hsmapi.c.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
