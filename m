Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:49384 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932183AbeFJFK1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jun 2018 01:10:27 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5A576PG141684
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:26 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2jgecx94pv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:26 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w5A5AQDE004859
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:26 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w5A5AQe5001557
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:26 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v2 27/27] xfsprogs: Clean up old parent pointer definitions
Date: Sat,  9 Jun 2018 22:07:52 -0700
Message-Id: <1528607272-11122-28-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com>
References: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Existing parent pointer stubs and structs are not used in this
implementation.  Remove uneeded definitions.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 include/parent.h   | 10 ----------
 libhandle/handle.c | 26 --------------------------
 libhandle/jdm.c    | 20 --------------------
 3 files changed, 56 deletions(-)

diff --git a/include/parent.h b/include/parent.h
index 33f8d85..5665d64 100644
--- a/include/parent.h
+++ b/include/parent.h
@@ -18,16 +18,6 @@
 #ifndef __PARENT_H__
 #define	__PARENT_H__
 
-typedef struct parent {
-	__u64	p_ino;
-	__u32	p_gen;
-	__u16	p_reclen;
-} parent_t;
-
-typedef struct parent_cursor {
-	__u32	opaque[4];      /* an opaque cookie */
-} parent_cursor_t;
-
 struct path_list;
 
 typedef int (*walk_pptr_fn)(struct xfs_pptr_info *pi, struct xfs_parent_ptr *pptr,
diff --git a/libhandle/handle.c b/libhandle/handle.c
index a70fa32..862b943 100644
--- a/libhandle/handle.c
+++ b/libhandle/handle.c
@@ -20,7 +20,6 @@
 #include "platform_defs.h"
 #include "xfs.h"
 #include "handle.h"
-#include "parent.h"
 
 /* just pick a value we know is more than big enough */
 #define	MAXHANSIZ	64
@@ -422,31 +421,6 @@ attr_list_by_handle(
 }
 
 int
-parents_by_handle(
-	void		*hanp,
-	size_t		hlen,
-	parent_t	*buf,
-	size_t		bufsiz,
-	unsigned int	*count)
-
-{
-	errno = EOPNOTSUPP;
-	return -1;
-}
-
-int
-parentpaths_by_handle(
-	void		*hanp,
-	size_t		hlen,
-	parent_t	*buf,
-	size_t		bufsiz,
-	unsigned int	*count)
-{
-	errno = EOPNOTSUPP;
-	return -1;
-}
-
-int
 fssetdm_by_handle(
 	void		*hanp,
 	size_t		hlen,
diff --git a/libhandle/jdm.c b/libhandle/jdm.c
index 821061b..0c2440b 100644
--- a/libhandle/jdm.c
+++ b/libhandle/jdm.c
@@ -20,7 +20,6 @@
 #include "xfs.h"
 #include "handle.h"
 #include "jdm.h"
-#include "parent.h"
 
 /* internal fshandle - typecast to a void for external use */
 #define FSHANDLE_SZ		8
@@ -178,22 +177,3 @@ jdm_attr_list(	jdm_fshandle_t *fshp,
 	return rval;
 }
 
-int
-jdm_parents( jdm_fshandle_t *fshp,
-		xfs_bstat_t *statp,
-		parent_t *bufp, size_t bufsz,
-		unsigned int *count)
-{
-	errno = EOPNOTSUPP;
-	return -1;
-}
-
-int
-jdm_parentpaths( jdm_fshandle_t *fshp,
-		xfs_bstat_t *statp,
-		parent_t *bufp, size_t bufsz,
-		unsigned int *count)
-{
-	errno = EOPNOTSUPP;
-	return -1;
-}
-- 
2.7.4

