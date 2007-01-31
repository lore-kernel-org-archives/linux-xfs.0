Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 30 Jan 2007 20:13:57 -0800 (PST)
Received: from imr2.americas.sgi.com (imr2.americas.sgi.com [198.149.16.18])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0V4Drqw017450
	for <xfs@oss.sgi.com>; Tue, 30 Jan 2007 20:13:53 -0800
Received: from clink.americas.sgi.com (clink.americas.sgi.com [128.162.236.153])
	by imr2.americas.sgi.com (8.12.9/8.12.10/SGI_generic_relay-1.2) with ESMTP id l0V3gUnc80592736
	for <xfs@oss.sgi.com>; Tue, 30 Jan 2007 19:42:31 -0800 (PST)
Received: (from mvalluri@localhost)
	by clink.americas.sgi.com (SGI-8.12.5/8.12.5/Submit) id l0V4Cusv14683285
	for xfs@oss.sgi.com; Tue, 30 Jan 2007 22:12:56 -0600 (CST)
Date: Tue, 30 Jan 2007 22:12:56 -0600 (CST)
From: Madan Valluri <mvalluri@sgi.com>
Message-Id: <200701310412.l0V4Cusv14683285@clink.americas.sgi.com>
Subject: TAKE 959451 - 
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfs_repair - 031 QA failure with platform that don't use the uuid field in the super block.


Date:  Tue Jan 30 20:11:16 PST 2007
Workarea:  clink.americas.sgi.com:/data/clink/a01/mvalluri/totrepair
Inspected by:  bnaujok@sgi.com

The following file(s) were checked into:
  bonnie.engr.sgi.com:/isms/xfs-cmds/master


Modid:  master:xfs-cmds:220542a
xfsprogs/libxlog/xfs_log_recover.c - 1.31 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxlog/xfs_log_recover.c.diff?r1=text&tr1=1.31&r2=text&tr2=1.30&f=h
	- Do not call xlog_header_check_mount(), if platform does not support uuid in super block.

xfsprogs/libxfs/init.h - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/init.h.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
	- Declared platform_has_uuid.

xfsprogs/libxfs/linux.c - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/linux.c.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
	- Linux has uuid in super block.

xfsprogs/libxfs/darwin.c - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/darwin.c.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
	- Darwin has uuid in super block.

xfsprogs/libxfs/irix.c - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/irix.c.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
	- Irix does not have uuid in super block.

xfsprogs/libxfs/freebsd.c - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/freebsd.c.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
	- Freebsd has uuid in super block.
