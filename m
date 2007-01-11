Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 10 Jan 2007 22:24:53 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0B6Ojqw009412
	for <xfs@oss.sgi.com>; Wed, 10 Jan 2007 22:24:46 -0800
Subject: TAKE 960028 - XFS tripping bug in cancel_dirty_pages in 2.6.20-rc3
Message-Id: <20070111062346.7D6AC58CF82A@chook.melbourne.sgi.com>
Date: Thu, 11 Jan 2007 17:23:46 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Unmap pages before removing them from the page cache.

The new cancel_dirty_pages() code found that XFS was removing
page from the page cache that had dirty page table entries.
XFS invalidates page cache pages via internal interfaces which
are implemented via truncate_inode_pages which does not remove
the page mapping first.

Switch to using invalidate_inode_pages2_range() which does almost
the same thing except it also removes page table mappings as
expected by cancel_dirty_pages.

Date:  Thu Jan 11 17:23:10 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@infradead.org,lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:27909a
fs/xfs/linux-2.6/xfs_fs_subr.c - 1.48 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_fs_subr.c.diff?r1=text&tr1=1.48&r2=text&tr2=1.47&f=h
	- Convert truncate_inode_pages to invalidate_inode_pages2_range
	  so that page table mappings are removed before we remove the
	  pages from the page cache.
