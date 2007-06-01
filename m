Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 31 May 2007 20:32:46 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l513WdWt014920
	for <xfs@oss.sgi.com>; Thu, 31 May 2007 20:32:41 -0700
Subject: PARTIAL TAKE 965537 - xfsprogs AC_TYPE_U32 broken by defining HAVE___U32_T instead of HAVE___U32
Message-Id: <20070601033233.85DEB591CE8E@chook.melbourne.sgi.com>
Date: Fri,  1 Jun 2007 13:32:33 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

s/HAVE___U32_T/HAVE___U32/g
Thanks to Eric Sandeen for finding this.

Date:  Fri Jun  1 13:31:17 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/tes/xfs-cmds
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:28754a
xfsprogs/doc/CHANGES - 1.240 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/doc/CHANGES.diff?r1=text&tr1=1.240&r2=text&tr2=1.239&f=h
xfsprogs/aclocal.m4 - 1.26 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/aclocal.m4.diff?r1=text&tr1=1.26&r2=text&tr2=1.25&f=h
xfsprogs/m4/package_types.m4 - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/m4/package_types.m4.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
	- s/HAVE___U32_T/HAVE___U32/g
	  Thanks to Eric Sandeen for finding this.
