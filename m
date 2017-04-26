Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44626 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1956143AbdDZGj2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Apr 2017 02:39:28 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3Q6cmbb049960
        for <linux-xfs@vger.kernel.org>; Wed, 26 Apr 2017 02:39:27 -0400
Received: from e12.ny.us.ibm.com (e12.ny.us.ibm.com [129.33.205.202])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2a2ebu1jrt-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Apr 2017 02:39:27 -0400
Received: from localhost
        by e12.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Wed, 26 Apr 2017 02:39:26 -0400
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH] xfs_io: Add statx support for PowerPC architecture
Date: Wed, 26 Apr 2017 12:09:18 +0530
Message-Id: <1493188758-3173-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, sandeen@redhat.com

Linux kernel commit f717629c7f834ab2efa05c7dbf0826f1d7c32ade (powerpc:
Wire up statx() syscall) added support for statx syscall for PowerPC
architecture. This commit enables using 'statx' sub-command of xfs_io to
be used on PowerPC.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
This patch is based on Eric's "xfs_io: fix statx definition for non-x86
architecture" patch.

 io/statx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io/statx.h b/io/statx.h
index eea7944..14361a8 100644
--- a/io/statx.h
+++ b/io/statx.h
@@ -16,7 +16,7 @@
 #endif
 
 #ifndef __NR_statx
-# ifdef __i386__
+# if defined(__i386__) || defined(__powerpc__)
 #  define __NR_statx 383
 # elif defined (__x86_64__)
 #  if defined (__ILP32__)
-- 
2.5.5

