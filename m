Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 30 Jun 2008 23:00:20 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6160DCZ022565
	for <xfs@oss.sgi.com>; Mon, 30 Jun 2008 23:00:15 -0700
Subject: TAKE 983924 - take back out again QUEUE_ORDERED_NONE test in check_barriers
Message-Id: <20080701060111.09C7958C4C29@chook.melbourne.sgi.com>
Date: Tue,  1 Jul 2008 16:01:10 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Disable queue flag test in barrier check.

md raid1 can pass down barriers, but does not set an ordered flag
on the queue, so xfs does not even attempt a barrier write, and
will never use barriers on these block devices.

Remove the flag check and just let the barrier write
test determine barrier support.

A possible risk here is that if something does not set an ordered
flag and also does not properly return an error on a barrier write...
but if it's any consolation jbd/ext3/reiserfs never test the flag,
and don't even do a test write, they just disable barriers the first
time an actual journal barrier write fails.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Date:  Tue Jul  1 15:59:48 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs-quilt
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31377a
fs/xfs/linux-2.6/xfs_super.c - 1.433 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.433&r2=text&tr2=1.432&f=h
	- disable queue flag test in barrier check
