Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 14 Sep 2008 18:01:49 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8F11kdt026725
	for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 18:01:46 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 21EF4129ABE2
	for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 18:03:17 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id tzJliHnC0MAXKvFe for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 18:03:17 -0700 (PDT)
Date: Mon, 15 Sep 2008 03:03:17 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/4] Add copy_uuid_helper
Message-ID: <20080915010317.GC13062@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-add-copy_uuid-helper
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Dave Chinner <dgc@sgi.com>

Add a helper to copy an uuid from one place to another.  This will ne needed
for various CRC-enabled data structures that grow uuids to check that the
block really belongs to this filesystem.

[hch: split out from another patch]


Signed-off-by: Dave Chinner <dgc@sgi.com>

Index: linux-2.6-xfs/fs/xfs/support/uuid.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/support/uuid.c	2008-09-01 20:49:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/support/uuid.c	2008-09-10 18:45:02.000000000 +0200
@@ -72,6 +72,12 @@ uuid_equal(uuid_t *uuid1, uuid_t *uuid2)
 	return memcmp(uuid1, uuid2, sizeof(uuid_t)) ? 0 : 1;
 }
 
+void
+uuid_copy(uuid_t *dst, uuid_t *src)
+{
+	memcpy(dst, src, sizeof(uuid_t));
+}
+
 /*
  * Given a 128-bit uuid, return a 64-bit value by adding the top and bottom
  * 64-bit words.  NOTE: This function can not be changed EVER.  Although
Index: linux-2.6-xfs/fs/xfs/support/uuid.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/support/uuid.h	2008-09-01 20:49:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/support/uuid.h	2008-09-10 18:45:02.000000000 +0200
@@ -25,6 +25,7 @@ typedef struct {
 extern void uuid_create_nil(uuid_t *uuid);
 extern int uuid_is_nil(uuid_t *uuid);
 extern int uuid_equal(uuid_t *uuid1, uuid_t *uuid2);
+extern void uuid_copy(uuid_t *dst, uuid_t *src);
 extern void uuid_getnodeuniq(uuid_t *uuid, int fsid [2]);
 extern __uint64_t uuid_hash64(uuid_t *uuid);
 extern int uuid_table_insert(uuid_t *uuid);

-- 
