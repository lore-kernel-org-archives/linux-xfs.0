Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E37A4C77B72
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Apr 2023 22:58:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjDNW6l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Apr 2023 18:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjDNW6k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Apr 2023 18:58:40 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D75C6EBB
        for <linux-xfs@vger.kernel.org>; Fri, 14 Apr 2023 15:58:38 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33EMOhP7006507
        for <linux-xfs@vger.kernel.org>; Fri, 14 Apr 2023 22:58:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=WxwaaVpMn+PblQIofJWqtTuIvlqsXc5KNgGfCG/9Xqk=;
 b=CVWKYMZ7XmNH9zt/P1vxtdK8Jb57shB3FxJfpSb81tas+O/bh6TaCIWefXCfd5AJHheb
 zCU/YNYLVZUfoiD5KMblXJcynNDzT9XpaCyJ3jUa2c03iAF297ojI35kE5xm2U+nSz5D
 8CBj8xvtUEcEqF9haxVW5FRlqRkdbOpTE83nlijFJKCeCuaLUWOWF6sEtP00paWtCn3N
 xPMFBdL3x6CLUSm9E57m6M6Hv1m0gf+MQKQwYAgIkGYMpX5z/u224b/n230o7BQvtAsr
 0e4SjE1kk4JLR4refTkhjfvCTHg00omf35BIVHm9bd8etvWsjJGNphQVgkISL8VolEny Eg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0tty6hc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 14 Apr 2023 22:58:38 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33EK59tP011425
        for <linux-xfs@vger.kernel.org>; Fri, 14 Apr 2023 22:58:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puw96nvp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 14 Apr 2023 22:58:37 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33EMwapw026359
        for <linux-xfs@vger.kernel.org>; Fri, 14 Apr 2023 22:58:37 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-159-159-110.vpn.oracle.com [10.159.159.110])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3puw96nvnq-2;
        Fri, 14 Apr 2023 22:58:36 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     wen.gang.wang@oracle.com
Subject: [PATCH 1/2] xfs: IO time one extent per EFI
Date:   Fri, 14 Apr 2023 15:58:35 -0700
Message-Id: <20230414225836.8952-2-wen.gang.wang@oracle.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122.2)
In-Reply-To: <20230414225836.8952-1-wen.gang.wang@oracle.com>
References: <20230414225836.8952-1-wen.gang.wang@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-14_14,2023-04-14_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304140202
X-Proofpoint-ORIG-GUID: fOPW6eO0tz9UmauNxH5Hdgj91Mf5H_T-
X-Proofpoint-GUID: fOPW6eO0tz9UmauNxH5Hdgj91Mf5H_T-
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

At IO time, make sure an EFI contains only one extent. Transaction rolling in
xfs_defer_finish() would commit the busy blocks for previous EFIs. By that we
avoid holding busy extents (for previously extents in the same EFI) in current
transaction when allocating blocks for AGFL where we could be otherwise stuck
waiting the busy extents held by current transaction to be flushed (thus a
deadlock).

The log changes
1) before change:

    358 rbbn 13 rec_lsn: 1,12 Oper 5: tid: ee327fd2  len: 48 flags: None
    359 EFI  nextents:2 id:ffff9fef708ba940
    360 EFI id=ffff9fef708ba940 (0x21, 7)
    361 EFI id=ffff9fef708ba940 (0x18, 8)
    362 -----------------------------------------------------------------
    363 rbbn 13 rec_lsn: 1,12 Oper 6: tid: ee327fd2  len: 48 flags: None
    364 EFD  nextents:2 id:ffff9fef708ba940
    365 EFD id=ffff9fef708ba940 (0x21, 7)
    366 EFD id=ffff9fef708ba940 (0x18, 8)

2) after change:

    830 rbbn 31 rec_lsn: 1,30 Oper 5: tid: 319f015f  len: 32 flags: None
    831 EFI  nextents:1 id:ffff9fef708b9b80
    832 EFI id=ffff9fef708b9b80 (0x21, 7)
    833 -----------------------------------------------------------------
    834 rbbn 31 rec_lsn: 1,30 Oper 6: tid: 319f015f  len: 32 flags: None
    835 EFI  nextents:1 id:ffff9fef708b9d38
    836 EFI id=ffff9fef708b9d38 (0x18, 8)
    837 -----------------------------------------------------------------
    838 rbbn 31 rec_lsn: 1,30 Oper 7: tid: 319f015f  len: 32 flags: None
    839 EFD  nextents:1 id:ffff9fef708b9b80
    840 EFD id=ffff9fef708b9b80 (0x21, 7)
    841 -----------------------------------------------------------------
    842 rbbn 31 rec_lsn: 1,30 Oper 8: tid: 319f015f  len: 32 flags: None
    843 EFD  nextents:1 id:ffff9fef708b9d38
    844 EFD id=ffff9fef708b9d38 (0x18, 8)

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/xfs/xfs_extfree_item.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index da6a5afa607c..ae84d77eaf30 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -13,8 +13,15 @@ struct kmem_cache;
 
 /*
  * Max number of extents in fast allocation path.
+ *
+ * At IO time, make sure an EFI contains only one extent. Transaction rolling
+ * in xfs_defer_finish() would commit the busy blocks for previous EFIs. By
+ * that we avoid holding busy extents (for previously extents in the same EFI)
+ * in current transaction when allocating blocks for AGFL where we could be
+ * otherwise stuck waiting the busy extents held by current transaction to be
+ * flushed (thus a deadlock).
  */
-#define	XFS_EFI_MAX_FAST_EXTENTS	16
+#define	XFS_EFI_MAX_FAST_EXTENTS	1
 
 /*
  * This is the "extent free intention" log item.  It is used to log the fact
-- 
2.21.0 (Apple Git-122.2)

