Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Apr 2008 19:29:12 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m382T0Nr014325
	for <xfs@oss.sgi.com>; Mon, 7 Apr 2008 19:29:03 -0700
Subject: TAKE 979087 - Test 091 fails on sector size != 512 bytes
Message-Id: <20080408022933.170C258C4C0F@chook.melbourne.sgi.com>
Date: Tue,  8 Apr 2008 12:29:32 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Test 091 fails on sector size != 512 bytes

Test 091 assumes a direct I/O alignment of 512 bytes,
a hold over from 2.4 kernels. On 2.6. kernels, direct
I/O needs to be aligned to the sector size the filesystem
was mkfs'd with.

Date:  Tue Apr  8 12:29:00 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/xfs-cmds
Inspected by:  bnaujok

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30760a
xfstests/091 - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/091.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
	- Teach 091 about 2.6 kernels and grab the sector size from the
	  xfs_info output.
