Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Sep 2007 01:34:32 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l8Q8YHwv001430
	for <xfs@oss.sgi.com>; Wed, 26 Sep 2007 01:34:19 -0700
Received: from linuxbuild.melbourne.sgi.com (linuxbuild.melbourne.sgi.com [134.14.54.115]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id SAA25283 for <xfs@oss.sgi.com>; Wed, 26 Sep 2007 18:34:16 +1000
From: donaldd@sgi.com
Subject: PARTIAL TAKE 971050 - Remove linux-2.4 build support
Message-Id: <20070926083416.C441A30A90AD@linuxbuild.melbourne.sgi.com>
Date: Wed, 26 Sep 2007 18:34:16 +1000 (EST)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Remove Makefile wrappers in XFS

Makefile (and Kbuild) would include Makefile-linux-26
I doubt XFS will really still compile on 2.4; so drop that. This
moves Makefile-linux-26 into Makefile and drops Kbuild.
Also having wrappers as both Kbuild and Makefile seemed redundant
anyways.

The patch is relatively large because it renames a file, but
no functional changes.

Signed-off-by: Andi Kleen <ak@suse.de>


Date:  Wed Sep 26 14:12:23 AEST 2007
Workarea:  linuxbuild.melbourne.sgi.com:/home/donaldd/isms/2.6.x-xfs
Inspected by:  tes

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29781a
fs/xfs/Makefile - 1.59 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/Makefile.diff?r1=text&tr1=1.59&r2=text&tr2=1.58&f=h
	- Remove Makefile wrappers in XFS.

fs/xfs/Makefile-linux-2.6 - 1.215 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/Makefile-linux-2.6.diff?r1=text&tr1=1.215&r2=text&tr2=1.214&f=h
	- Remove Makefile wrappers in XFS.

fs/xfs/Makefile-linux-2.4 - 1.218 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/Makefile-linux-2.4.diff?r1=text&tr1=1.218&r2=text&tr2=1.217&f=h
	- Remove Makefile wrappers in XFS.

fs/xfs/Kbuild - 1.3 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/Kbuild.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
	- Remove Makefile wrappers in XFS.
