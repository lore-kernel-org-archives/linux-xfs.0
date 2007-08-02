Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Aug 2007 04:14:16 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l72BE9bm028028
	for <xfs@oss.sgi.com>; Thu, 2 Aug 2007 04:14:12 -0700
Subject: PARTIAL TAKE 968563 - split ondisk vs incore versions of xfs_bmbt_rec_t
Message-Id: <20070802111409.027AC58F4B6D@chook.melbourne.sgi.com>
Date: Thu,  2 Aug 2007 21:14:08 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

split ondisk vs incore versions of xfs_bmbt_rec_t

currently xfs_bmbt_rec_t is used both for ondisk extents as well as
host-endian ones.  This patch adds a new xfs_bmbt_rec_host_t for the
native endian ones and cleans up the fallout. There have been various
endianess issues in the tracing / debug printf code that are fixed
by this patch.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Thu Aug  2 21:13:30 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29318a
fs/xfs/xfsidbg.c - 1.319 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.319&r2=text&tr2=1.318&f=h
	- split ondisk vs incore versions of xfs_bmbt_rec_t

fs/xfs/xfs_bmap_btree.h - 1.77 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.h.diff?r1=text&tr1=1.77&r2=text&tr2=1.76&f=h
	- split ondisk vs incore versions of xfs_bmbt_rec_t

fs/xfs/xfs_bmap_btree.c - 1.163 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.163&r2=text&tr2=1.162&f=h
	- split ondisk vs incore versions of xfs_bmbt_rec_t

fs/xfs/xfs_inode.c - 1.468 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.468&r2=text&tr2=1.467&f=h
	- split ondisk vs incore versions of xfs_bmbt_rec_t

fs/xfs/xfs_inode.h - 1.223 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.223&r2=text&tr2=1.222&f=h
	- split ondisk vs incore versions of xfs_bmbt_rec_t

fs/xfs/xfs_bmap.h - 1.100 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.h.diff?r1=text&tr1=1.100&r2=text&tr2=1.99&f=h
	- split ondisk vs incore versions of xfs_bmbt_rec_t

fs/xfs/xfs_bmap.c - 1.374 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.374&r2=text&tr2=1.373&f=h
	- split ondisk vs incore versions of xfs_bmbt_rec_t

fs/xfs/quota/xfs_qm.c - 1.51 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.c.diff?r1=text&tr1=1.51&r2=text&tr2=1.50&f=h
	- split ondisk vs incore versions of xfs_bmbt_rec_t
