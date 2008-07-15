Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Jul 2008 21:13:17 -0700 (PDT)
Received: from emu.melbourne.sgi.com (emu.melbourne.sgi.com [134.14.54.11])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6F4CxGN021000
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2008 21:13:01 -0700
Subject: TAKE xfstests/078
Message-Id: <20080715061212.726EC5064F27@emu.melbourne.sgi.com>
Date: Tue, 15 Jul 2008 16:12:12 +1000 (EST)
From: tes@emu.melbourne.sgi.com
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

If test 078 fails and you try to run it again immediately, it
will execute a 'rm -f' on a directory which will fail. This should
be a rmdir....

Signed-off-by: Dave Chinner <dgc@sgi.com>

Date:  Tue Jul 15 14:13:12 AEST 2008
Workarea:  emu.melbourne.sgi.com:/home/tes/isms/xfs-cmds
Inspected by:  dgc@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:31637a
xfstests/078 - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/078.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
	- If test 078 fails and you try to run it again immediately, it
	  will execute a 'rm -f' on a directory which will fail. This should
	  be a rmdir....  Signed-off-by: Dave Chinner <dgc@sgi.com>
