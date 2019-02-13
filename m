Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33824 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390073AbfBMUuv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Feb 2019 15:50:51 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1DKcrrC133643
        for <linux-xfs@vger.kernel.org>; Wed, 13 Feb 2019 20:50:49 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2qhrekmcrj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Feb 2019 20:50:49 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1DKomN0002289
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Feb 2019 20:50:48 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1DKomat026502
        for <linux-xfs@vger.kernel.org>; Wed, 13 Feb 2019 20:50:48 GMT
Subject: [PATCH 1/3] xfs: don't overflow xattr listent buffer
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 13 Feb 2019 12:50:47 -0800
Message-ID: <155009104740.32028.193157199378698979.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

For VFS listxattr calls, xfs_xattr_put_listent calls
__xfs_xattr_put_listent twice if it sees an attribute
"trusted.SGI_ACL_FILE": once for that name, and again for
"system.posix_acl_access".  Unfortunately, if we happen to run out of
buffer space while emitting the first name, we set count to -1 (so that
we can feed ERANGE to the caller).  The second invocation doesn't check that
the context parameters make sense and overwrites the byte before the
buffer, triggering a KASAN report:

==================================================================
BUG: KASAN: slab-out-of-bounds in strncpy+0xb3/0xd0
Write of size 1 at addr ffff88807fbd317f by task syz/1113

CPU: 3 PID: 1113 Comm: syz Not tainted 5.0.0-rc6-xfsx #rc6
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1 04/01/2014
Call Trace:
 dump_stack+0xcc/0x180
 print_address_description+0x6c/0x23c
 kasan_report.cold.3+0x1c/0x35
 strncpy+0xb3/0xd0
 __xfs_xattr_put_listent+0x1a9/0x2c0 [xfs]
 xfs_attr_list_int_ilocked+0x11af/0x1800 [xfs]
 xfs_attr_list_int+0x20c/0x2e0 [xfs]
 xfs_vn_listxattr+0x225/0x320 [xfs]
 listxattr+0x11f/0x1b0
 path_listxattr+0xbd/0x130
 do_syscall_64+0x139/0x560

While we're at it we add an assert to the other put_listent to avoid
this sort of thing ever happening to the attrlist_by_handle code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_attr_list.c |    1 +
 fs/xfs/xfs_xattr.c     |    3 +++
 2 files changed, 4 insertions(+)


diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index a58034049995..3d213a7394c5 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -555,6 +555,7 @@ xfs_attr_put_listent(
 	attrlist_ent_t *aep;
 	int arraytop;
 
+	ASSERT(!context->seen_enough);
 	ASSERT(!(context->flags & ATTR_KERNOVAL));
 	ASSERT(context->count >= 0);
 	ASSERT(context->count < (ATTR_MAX_VALUELEN/8));
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 63ee1d5bf1d7..9a63016009a1 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -129,6 +129,9 @@ __xfs_xattr_put_listent(
 	char *offset;
 	int arraytop;
 
+	if (context->count < 0 || context->seen_enough)
+		return;
+
 	if (!context->alist)
 		goto compute_size;
 
