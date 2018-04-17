Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53698 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752976AbeDQUDd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Apr 2018 16:03:33 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E63F028203
        for <linux-xfs@vger.kernel.org>; Tue, 17 Apr 2018 20:03:32 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B55855FCC6
        for <linux-xfs@vger.kernel.org>; Tue, 17 Apr 2018 20:03:32 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: trace ATTR flags in xattr tracepoints
Message-ID: <67a92fac-3e86-03c1-759e-af192d35e06b@redhat.com>
Date: Tue, 17 Apr 2018 15:03:32 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This will trace i.e. the ATTR_SECURE/ATTR_CREATE/ATTR_REPLACE
flags as well as the OP_FLAGS.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 8955254..b03a0f4 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1750,6 +1750,7 @@
 		__field(int, namelen)
 		__field(int, valuelen)
 		__field(xfs_dahash_t, hashval)
+		__field(int, flags)
 		__field(int, op_flags)
 	),
 	TP_fast_assign(
@@ -1760,10 +1761,11 @@
 		__entry->namelen = args->namelen;
 		__entry->valuelen = args->valuelen;
 		__entry->hashval = args->hashval;
+		__entry->flags = args->flags;
 		__entry->op_flags = args->op_flags;
 	),
 	TP_printk("dev %d:%d ino 0x%llx name %.*s namelen %d valuelen %d "
-		  "hashval 0x%x op_flags %s",
+		  "hashval 0x%x flags %s op_flags %s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->namelen,
@@ -1771,6 +1773,7 @@
 		  __entry->namelen,
 		  __entry->valuelen,
 		  __entry->hashval,
+		  __print_flags(__entry->flags, "|", XFS_ATTR_FLAGS),
 		  __print_flags(__entry->op_flags, "|", XFS_DA_OP_FLAGS))
 )
 

