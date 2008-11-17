Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP
	id mAH3gcLo020267
	for <xfs@oss.sgi.com>; Sun, 16 Nov 2008 19:42:38 -0800
Subject: TAKE 989743 - bugs in error handling in rmt_open in librmt in dump
Message-Id: <20081117034228.90F7558C52A9@chook.melbourne.sgi.com>
Date: Mon, 17 Nov 2008 14:42:28 +1100 (EST)
From: tes@sgi.com (Tim Shimmin)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Fix up some error handling in _rmt_open for popen, fgets which return pointers
and not integers.

--Tim

Date:  Mon Nov 17 14:41:20 EST 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/xfs-cmds
Inspected by:  donaldd@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:32487a
xfsdump/VERSION - 1.90 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/VERSION.diff?r1=text&tr1=1.90&r2=text&tr2=1.89&f=h
	- bump

xfsdump/doc/CHANGES - 1.104 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/doc/CHANGES.diff?r1=text&tr1=1.104&r2=text&tr2=1.103&f=h
	- add rmt_open fixes

xfsdump/librmt/rmtopen.c - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/librmt/rmtopen.c.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
	- Fix up some error handling in _rmt_open for popen, fgets which return pointers
	  and not integers.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
