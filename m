Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Oct 2007 20:10:50 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9G3AfGS001525
	for <xfs@oss.sgi.com>; Mon, 15 Oct 2007 20:10:44 -0700
Subject: TAKE 971902 - eagerly remove vmap mappings to avoid upsetting Xen
Message-Id: <20071016031038.73E5458C38F1@chook.melbourne.sgi.com>
Date: Tue, 16 Oct 2007 13:10:38 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

eagerly remove vmap mappings to avoid upsetting Xen

XFS leaves stray mappings around when it vmaps memory to make it
virtually contigious.  This upsets Xen if one of those pages is being
recycled into a pagetable, since it finds an extra writable mapping of
the page.

This patch solves the problem in a brute force way, by making XFS
always eagerly unmap its mappings.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>


Date:  Tue Oct 16 13:10:07 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  jeremy@xensource.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29886a
fs/xfs/linux-2.6/xfs_buf.c - 1.246 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.c.diff?r1=text&tr1=1.246&r2=text&tr2=1.245&f=h
	- Always unmap buffers immediately if we are configure to run Xen.
