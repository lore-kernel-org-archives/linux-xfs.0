Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 26 Nov 2007 18:23:00 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAR2MqVu008647
	for <xfs@oss.sgi.com>; Mon, 26 Nov 2007 18:22:54 -0800
Subject: TAKE 971596 - Fixed a few bugs in xfs_buf_associate_memory()
Message-Id: <20071127022257.0CD3458C4C0F@chook.melbourne.sgi.com>
Date: Tue, 27 Nov 2007 13:22:56 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Fixed a few bugs in xfs_buf_associate_memory()

- calculation of 'page_count' was incorrect as it did not
  consider the offset of 'mem' into the first page.  The
  logic to bump 'page_count' didn't work if 'len' was <=
  PAGE_CACHE_SIZE (ie offset = 3k, len = 2k).
- setting b_buffer_length to 'len' is incorrect if
  'offset' is > 0.  Set it to the total length of the
  buffer.
- I suspect that passing a non-aligned address into
  mem_to_page() for the first page may have been causing
  issues - don't know but just tidy up that code anyway.

Date:  Tue Nov 27 13:21:49 AEDT 2007
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-bufmem
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30143a
fs/xfs/linux-2.6/xfs_buf.c - 1.249 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.c.diff?r1=text&tr1=1.249&r2=text&tr2=1.248&f=h
	- Fixed a few bugs in xfs_buf_associate_memory().
