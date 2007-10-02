Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 01 Oct 2007 22:20:08 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l925Jxdw024520
	for <xfs@oss.sgi.com>; Mon, 1 Oct 2007 22:20:02 -0700
Subject: PARTIAL TAKE 971186 - xlog_rec_header/xlog_rec_ext_header endianess annotations
Message-Id: <20071002051955.03B9E58C38F1@chook.melbourne.sgi.com>
Date: Tue,  2 Oct 2007 15:19:54 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

xlog_rec_header/xlog_rec_ext_header endianess annotations

Mostly trivial conversion with one exceptions:  h_num_logops was kept
in native endian previously and only converted to big endian in
xlog_sync, but we always keep it big endian now.  With todays cpus
fast byteswap instructions that's not an issue but the new variant
keeps the code clean and maintainable.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Tue Oct  2 15:19:07 AEST 2007
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-oss
Inspected by:  Signed-off-by: Christoph Hellwig <hch@lst.de>
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29821a
fs/xfs/xfsidbg.c - 1.338 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.338&r2=text&tr2=1.337&f=h
fs/xfs/xfs_log.h - 1.80 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.h.diff?r1=text&tr1=1.80&r2=text&tr2=1.79&f=h
fs/xfs/xfs_log.c - 1.342 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.342&r2=text&tr2=1.341&f=h
fs/xfs/xfs_log_priv.h - 1.125 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_priv.h.diff?r1=text&tr1=1.125&r2=text&tr2=1.124&f=h
fs/xfs/xfs_log_recover.c - 1.329 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.329&r2=text&tr2=1.328&f=h
	- xlog_rec_header/xlog_rec_ext_header endianess annotations
