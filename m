Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Dec 2006 16:46:36 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kBM0kSqw006952
	for <xfs@oss.sgi.com>; Thu, 21 Dec 2006 16:46:30 -0800
Subject: TAKE 959485 - xfs_start_page_writeback should use clear_page_dirty_for_io
Message-Id: <20061222004532.5CD4858CA541@chook.melbourne.sgi.com>
Date: Fri, 22 Dec 2006 11:45:32 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Fix XFS after clear_page_dirty() removal

XFS appears to call clear_page_dirty to get the mapping tree dirty tag
set correctly at the same time the page dirty flag is cleared.  I note
that this can be done by set_page_writeback() if we clear the dirty flag
on the page first when we are writing back the entire page.

Hence it seems to me that the XFS call to clear_page_dirty() could
easily be substituted by clear_page_dirty_for_io() followed by a call to
set_page_writeback() to get the mapping tree tags set correctly after
the page has been marked clean.

Date:  Fri Dec 22 11:44:24 AEDT 2006
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  torvalds@osdl.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:27807a
fs/xfs/linux-2.6/xfs_aops.c - 1.138 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_aops.c.diff?r1=text&tr1=1.138&r2=text&tr2=1.137&f=h
	- clear_page_dirty() has been removed from the tree, so use
	  clear_page_dirty_for_io() instead and call set_page_writeback()
	  after modifying the page dirty state to update the mapping tree
	  tags correctly for writeback.
