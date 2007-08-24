Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 24 Aug 2007 06:24:03 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7ODNv4p029837
	for <xfs@oss.sgi.com>; Fri, 24 Aug 2007 06:24:00 -0700
Subject: TAKE 967795 - fix filestreams on 32-bit boxes
Message-Id: <20070824132351.B1AA158C38F1@chook.melbourne.sgi.com>
Date: Fri, 24 Aug 2007 23:23:51 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

fix filestreams on 32-bit boxes

xfs_filestream_mount() sets up an mru cache with:

        err = xfs_mru_cache_create(&mp->m_filestream, lifetime, grp_count,
                             (xfs_mru_cache_free_func_t)xfs_fstrm_free_func);

but that cast is causing problems...

typedef void (*xfs_mru_cache_free_func_t)(unsigned long, void*);

but:

void xfs_fstrm_free_func( 
        xfs_ino_t       ino,
        fstrm_item_t    *item)

so on a 32-bit box, it's casting (32, 32) args into (64, 32) and I assume 
it's getting garbage for *item, which subsequently causes an explosion.

With this change the filestreams xfsqa tests don't oops on my 32-bit box.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>


Date:  Fri Aug 24 23:23:27 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29510a
fs/xfs/xfs_filestream.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_filestream.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
	- clean up item freeing callback to use correct interface. prevents
	  panics on 32 bit platforms.
