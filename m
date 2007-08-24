Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 17:45:04 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7O0ix4p026806
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 17:45:02 -0700
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l7O0iwDO005193
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 20:44:58 -0400
Received: from lacrosse.corp.redhat.com (lacrosse.corp.redhat.com [172.16.52.154])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l7O0iwpv011279
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 20:44:58 -0400
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by lacrosse.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id l7O0itAu018425
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 20:44:57 -0400
Message-ID: <46CE2A07.7080305@sandeen.net>
Date: Thu, 23 Aug 2007 19:44:55 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] fix filestreams on 32-bit boxes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

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

Index: linux-2.6.22.i386/fs/xfs/xfs_filestream.c
===================================================================
--- linux-2.6.22.i386.orig/fs/xfs/xfs_filestream.c
+++ linux-2.6.22.i386/fs/xfs/xfs_filestream.c
@@ -350,7 +350,7 @@ _xfs_filestream_update_ag(
 /* xfs_fstrm_free_func(): callback for freeing cached stream items. */
 void
 xfs_fstrm_free_func(
-	xfs_ino_t	ino,
+	unsigned long	ino,
 	fstrm_item_t	*item)
 {
 	xfs_inode_t	*ip = item->ip;
