Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 Nov 2007 19:44:56 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAK3ilK1022732
	for <xfs@oss.sgi.com>; Mon, 19 Nov 2007 19:44:51 -0800
Subject: PARTIAL TAKE 971186 - remove BPCSHIFT and friends
Message-Id: <20071120034450.A36FB58C4C0A@chook.melbourne.sgi.com>
Date: Tue, 20 Nov 2007 14:44:50 +1100 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Remove the BPCSHIFT and NB* based macros from XFS.

The BPCSHIFT based macros, btoc*, ctob*, offtoc* and ctooff
are either not used or don't need to be used.
The NDPP, NDPP, NBBY macros don't need to be used but instead
are replaced directly by PAGE_SIZE and PAGE_CACHE_SIZE
where appropriate.
Initial patch and motivation from Nicolas Kaiser.
Bunch of reviews from Dave Chinner and final from Lachlan.

Date:  Tue Nov 20 14:42:18 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs
Inspected by:  lachlan@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30096a
fs/xfs/xfs_log.c - 1.345 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.345&r2=text&tr2=1.344&f=h
	- simplify and use PAGE_SIZE

fs/xfs/xfs_vnodeops.c - 1.726 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.726&r2=text&tr2=1.725&f=h
	- simplify and use PAGE_CACHE_SIZE and reuse ioffset

fs/xfs/xfs_itable.c - 1.159 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_itable.c.diff?r1=text&tr1=1.159&r2=text&tr2=1.158&f=h
	- simplify and use PAGE_SIZE

fs/xfs/xfs_bmap.c - 1.382 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.382&r2=text&tr2=1.381&f=h
	- simplify and use PAGE_CACHE_SIZE

fs/xfs/quota/xfs_qm.h - 1.18 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.h.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h
	- simplify and use PAGE_SIZE

fs/xfs/linux-2.6/xfs_lrw.c - 1.272 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_lrw.c.diff?r1=text&tr1=1.272&r2=text&tr2=1.271&f=h
	- simplify and use PAGE_CACHE_MASK

fs/xfs/linux-2.6/xfs_linux.h - 1.162 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_linux.h.diff?r1=text&tr1=1.162&r2=text&tr2=1.161&f=h
	- The BPCSHIFT based macros, btoc*, ctob*, offtoc* and ctooff
	  are either not used or don't need to be used.
	  The NDPP, NDPP, NBBY macros don't need to be used but instead
	  are replaced directly by PAGE_SIZE and PAGE_CACHE_SIZE
	  where appropriate.
