Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Oct 2006 00:08:39 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9G78OaG013184
	for <xfs@oss.sgi.com>; Mon, 16 Oct 2006 00:08:28 -0700
Subject: TAKE 956964 - FC6 kernels are oopsing when lockdep & memory debugging are turned on
Message-Id: <20061016070736.6794258F5C17@chook.melbourne.sgi.com>
Date: Mon, 16 Oct 2006 17:07:36 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Keep lockdep happy.
As suggested by Eric Sandeen.
(Build and tested in QA)

--Tim

Date:  Mon Oct 16 17:03:17 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs
Inspected by:  sandeen@sandeen.net,dgc@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:27200a
fs/xfs/xfs_iget.c - 1.222 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.222&r2=text&tr2=1.221&f=h
	- Keep lockdep happy.
