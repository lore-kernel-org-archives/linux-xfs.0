Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 11 Oct 2007 23:14:39 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9C6DvJk025589
	for <xfs@oss.sgi.com>; Thu, 11 Oct 2007 23:14:01 -0700
From: donaldd@sgi.com
Subject: PARTIAL TAKE 971186 - fix up out-of-tree xfs builds
Message-Id: <20071012061354.4522F30E6A4C@linuxbuild.melbourne.sgi.com>
Date: Fri, 12 Oct 2007 16:13:54 +1000 (EST)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Fix up xfs out-of-tree builds. (a.k.a. external modules)

Change -I include directives to find headers in the out-of-tree spot.
This allows a directory containing only xfs files to be built as:

  # make -C /path/to/kernel M=`pwd`

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Date:  Fri Oct 12 16:13:18 AEST 2007
Workarea:  linuxbuild.melbourne.sgi.com:/home/donaldd/isms/2.6.x-xfs
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29878a
fs/xfs/Makefile - 1.60 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/Makefile.diff?r1=text&tr1=1.60&r2=text&tr2=1.59&f=h
	- fix up out-of-tree xfs builds.

fs/xfs/quota/Makefile - 1.10 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/Makefile.diff?r1=text&tr1=1.10&r2=text&tr2=1.9&f=h
	- fix up out-of-tree xfs builds.

fs/xfs/dmapi/Makefile - 1.29 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/Makefile.diff?r1=text&tr1=1.29&r2=text&tr2=1.28&f=h
	- fix up out-of-tree xfs builds.
