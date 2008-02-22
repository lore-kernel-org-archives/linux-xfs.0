Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 20:25:51 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1M4PhKs009511
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:25:46 -0800
Subject: PARTIAL TAKE 976035 - don't encode parent in nfs filehandles unless nessecary
Message-Id: <20080222042603.7426C58C4C0F@chook.melbourne.sgi.com>
Date: Fri, 22 Feb 2008 15:26:03 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

don't encode parent in nfs filehandles unless nessecary

As Dave pointed out after the export ops changes we now always encode
the parent into the filehandle for regular files, but it's not actually
needed when the filesystem is export with no_subtree_check.  This
one-liner fixes xfs_fs_encode_fh to skip encoding the parent unless
nessecary.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Fri Feb 22 15:25:17 AEDT 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30535a
fs/xfs/linux-2.6/xfs_export.c - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_export.c.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
	- don't encode parent in nfs filehandles unless nessecary
