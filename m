Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Dec 2006 15:34:21 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kBINYDqw029941
	for <linux-xfs@oss.sgi.com>; Mon, 18 Dec 2006 15:34:15 -0800
Date: Tue, 19 Dec 2006 10:17:01 +1100 (AEDT)
From: Allan Randall <allanr@snort.melbourne.sgi.com>
Message-Id: <200612182317.kBINH1FZ66570784@snort.melbourne.sgi.com>
Subject: TAKE 958893 - Integrate existing dmapi qa tests into xfs qa infrastructure
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: asg-qa@melbourne.sgi.com, allanr@melbourne.sgi.com, linux-xfs@oss.sgi.com

Integrate existing dmapi qa tests into xfs qa infrastructure

Date:  Tue Dec 19 10:16:15 AEDT 2006
Workarea:  snort.melbourne.sgi.com:/home/allanr/isms/xfs-cmds-2
Inspected by:  vapo

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:27764a
xfstests/142 - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/142
	- Dmapi get/set_dmattr

xfstests/142.out - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/142.out
	- Dmapi get/set_dmattr golden output

xfstests/143 - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/143
	- Dmapi get/set_eventlist

xfstests/143.out - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/143.out
	- Dmapi get/set_eventlist golden output

xfstests/144 - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/144
	- Dmapi get/set_fileattr, get_bulkattr, get_dirattrs

xfstests/144.out - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/144.out
	- Dmapi get/set_fileattr, get_bulkattr, get_dirattrs golden output

xfstests/145 - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/145
	- Dmapi probe/punch_hole

xfstests/145.out - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/145.out
	- Dmapi probe/punch_hole golden output

xfstests/146 - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/146
	- Dmapi read/write_invis

xfstests/146.out - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/146.out
	- Dmapi read/write_invis golden output

xfstests/147 - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/147
	- Dmapi get/set_region

xfstests/147.out - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/147.out
	- Dmapi get/set_region golden output

xfstests/common.dmapi - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/common.dmapi
	- common dmapi functions

xfstests/common.rc - 1.62 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/common.rc.diff?r1=text&tr1=1.62&r2=text&tr2=1.61&f=h
	- added filter to set dmapi's mtpt to correct mount point in _mount

xfstests/Makefile - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/Makefile.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
	- added dmapi to makefile subdirs

xfstests/group - 1.97 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/group.diff?r1=text&tr1=1.97&r2=text&tr2=1.96&f=h
	- added tests 142-147

xfstests/include/buildmacros - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/include/buildmacros.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
	- added dmapi commands for building dmapi subdir
