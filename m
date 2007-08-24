Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 19:03:51 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7O23l4p007020
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 19:03:49 -0700
Message-ID: <46CE3C8B.5090609@sandeen.net>
Date: Thu, 23 Aug 2007 21:03:55 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix filestreams on 32-bit boxes
References: <46CE2A07.7080305@sandeen.net> <20070824014820.GF72985246@sgi.com>
In-Reply-To: <20070824014820.GF72985246@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

David Chinner wrote:

>
> hmmm - probably should make xfs_fstrm_free_func follow the correct prototype
> and convert the item into an opaque void * as well. Then we can remove the
> cast that hid this problem in xfs_filestream_mount()....
>
> Nice catch, though, Eric.
>
> Cheers,
>
> Dave.

Yep, I thought of removing the cast on the way home, as did Christoph, wherever he is :)

---------------------

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
@@ -350,9 +350,10 @@ _xfs_filestream_update_ag(
 /* xfs_fstrm_free_func(): callback for freeing cached stream items. */
 void
 xfs_fstrm_free_func(
-	xfs_ino_t	ino,
-	fstrm_item_t	*item)
+	unsigned long	ino,
+	void		*data)
 {
+	fstrm_item_t	*item  = (fstrm_item_t *)data;
 	xfs_inode_t	*ip = item->ip;
 	int ref;
 
@@ -438,7 +439,7 @@ xfs_filestream_mount(
 	grp_count = 10;
 
 	err = xfs_mru_cache_create(&mp->m_filestream, lifetime, grp_count,
-	                     (xfs_mru_cache_free_func_t)xfs_fstrm_free_func);
+	                     xfs_fstrm_free_func);
 
 	return err;
 }
