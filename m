Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 13 Apr 2008 22:31:01 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3E5UXRN021371
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 22:30:35 -0700
Subject: TAKE 979606 - xfs bug in going from attr2 back to attr1
Message-Id: <20080414053108.3C30758C4C15@chook.melbourne.sgi.com>
Date: Mon, 14 Apr 2008 15:31:08 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Test out bug in xfs_attr_shortform_bytesfit for its use of m_attroffset
instead of di_forkoff.


Date:  Mon Apr 14 15:24:55 AEST 2008
Workarea:  emu.melbourne.sgi.com:/home/tes/isms/xfs-cmds
Inspected by:  dgc@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30863a
xfstests/186 - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/186
xfstests/186.out - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/186.out
	- Test out bug in xfs_attr_shortform_bytesfit for its use of m_attroffset
	  instead of di_forkoff.

xfstests/group - 1.119 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/group.diff?r1=text&tr1=1.119&r2=text&tr2=1.118&f=h
	- Add 186 for attr.
