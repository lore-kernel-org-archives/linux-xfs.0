Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Oct 2008 22:28:32 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9A5SVtH003610
	for <xfs@oss.sgi.com>; Thu, 9 Oct 2008 22:28:31 -0700
Subject: TAKE 988149 - fix barrier fail detection
Message-Id: <20081010053009.014F658C52B5@chook.melbourne.sgi.com>
Date: Fri, 10 Oct 2008 16:30:08 +1100 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Fix barrier fail detection

Currently we disable barriers as soon as we get a buffer in xlog_iodone
that has the XBF_ORDERED flag cleared.  But this can be the case not only
for buffers where the barrier failed, but also the first buffer of a
split log write in case of a log wraparound.  Due to the disabled
barriers we can easily get directory corruption on unclean shutdowns.
So instead of using this check add a new buffer flag for failed barrier
writes.

This is a regression vs 2.6.26 caused by patch to use the right macro
to check for the ORDERED flag, as we previously got true returned for
every buffer.

Thanks to Toei Rei for reporting the bug.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Fri Oct 10 16:28:19 EST 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs-quilt
Inspected by:  hch@lst.de,sandeen@sandeen.net,david@fromorbit.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32298a
fs/xfs/xfs_log.c - 1.368 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.368&r2=text&tr2=1.367&f=h
	- fix barrier fail detection

fs/xfs/linux-2.6/xfs_buf.h - 1.128 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.h.diff?r1=text&tr1=1.128&r2=text&tr2=1.127&f=h
	- fix barrier fail detection

fs/xfs/linux-2.6/xfs_buf.c - 1.263 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.c.diff?r1=text&tr1=1.263&r2=text&tr2=1.262&f=h
	- fix barrier fail detection
