Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 May 2007 22:35:54 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4B5ZnfB020332
	for <xfs@oss.sgi.com>; Thu, 10 May 2007 22:35:51 -0700
Subject: TAKE 964544 - Barriers need to be dynamically checked and switched off
Message-Id: <20070511053545.54D9758CA530@chook.melbourne.sgi.com>
Date: Fri, 11 May 2007 15:35:45 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Barriers need to be dynamically checked and switched off

If the underlying block device sudden stops supporting barriers,
we need to handle the -EOPNOTSUPP error in a sane manner rather
than shutting downteh filesystem. If we get this error, clear the
barrier flag, reissue the I/O, and tell the world bad things are
occurring.

Date:  Fri May 11 15:35:19 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28568a
fs/xfs/xfs_log.c - 1.330 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.330&r2=text&tr2=1.329&f=h
	- If we have barriers enabled and we see a barrier log write come
	  back without the barrier flag on it, then we need to stop issuing
	  barriers on the log writes. Make noise about it, too.

fs/xfs/linux-2.6/xfs_super.c - 1.380 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.380&r2=text&tr2=1.379&f=h
	- We shouldn't peer down into the backing device to see if barriers
	  are supported or not - the test I/O is sufficient to tell us
	  this.

fs/xfs/linux-2.6/xfs_buf.c - 1.237 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.c.diff?r1=text&tr1=1.237&r2=text&tr2=1.236&f=h
	- If the buffer gets a EOPNOTSUPP I/O error and it is a barrier
	  write, clear the barrier and reissue the I/O.
