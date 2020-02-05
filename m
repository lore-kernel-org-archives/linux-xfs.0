Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD053C35247
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:46:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A354D21582
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:46:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ESOd+Nie"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbgBEAqX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 19:46:23 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45034 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727494AbgBEAqT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Feb 2020 19:46:19 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0150e3I9124453;
        Wed, 5 Feb 2020 00:46:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=sjcVntsIVL4zGRPl/H2qMytL1Z6cx0T8c1zR/x23MS4=;
 b=ESOd+Niewam4i6vUo+xMuZN4Zthk8a/lqg2t4nBYT2gQQLBZW1Hkf6S0ltJLqTH3AHaQ
 50HAGyx4HN0ynhcwyY4SPdkYWJDGXccl+qMS16X2WkGQ0T0jmSoeWN7uX1fxH4AwQV1F
 YzKNI2D5Iw00Jrj0XIHRoCU2XbK8K0lvGdgNnXWSPFmEY1085lm0Xn+KRpCazlnl55Xw
 nDThUK5eE98SB6d0JmVwy8cwS0uxKZTlDMESVfAcIhrZbaEksQtOKampySzB540csetG
 Ygcd2QJKzvp2sCQtUohfhkprFTOKB+5NREM2weI2jqXn/96hYnwBEM0vp8YQLPM9nrpE Qw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2xykbp00hb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:46:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0150cub4165880;
        Wed, 5 Feb 2020 00:46:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2xykbqgc5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:46:16 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0150kF85010090;
        Wed, 5 Feb 2020 00:46:15 GMT
Received: from localhost (/10.159.250.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 16:46:14 -0800
Subject: [PATCH 1/4] libxfs: re-sort libxfs_api_defs.h defines
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 04 Feb 2020 16:46:13 -0800
Message-ID: <158086357391.2079557.7271114884346251108.stgit@magnolia>
In-Reply-To: <158086356778.2079557.17601708483399404544.stgit@magnolia>
References: <158086356778.2079557.17601708483399404544.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=915
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002050001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=962 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002050001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Re-fix the sorting in this file.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_api_defs.h |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index c7fa1607..6e09685b 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -93,6 +93,7 @@
 #define xfs_dqblk_repair		libxfs_dqblk_repair
 #define xfs_dquot_verify		libxfs_dquot_verify
 
+#define xfs_finobt_calc_reserves	libxfs_finobt_calc_reserves
 #define xfs_free_extent			libxfs_free_extent
 #define xfs_fs_geometry			libxfs_fs_geometry
 #define xfs_highbit32			libxfs_highbit32
@@ -118,13 +119,16 @@
 #define xfs_perag_put			libxfs_perag_put
 #define xfs_prealloc_blocks		libxfs_prealloc_blocks
 
+#define xfs_read_agf			libxfs_read_agf
 #define xfs_refc_block			libxfs_refc_block
+#define xfs_refcountbt_calc_reserves	libxfs_refcountbt_calc_reserves
 #define xfs_refcountbt_init_cursor	libxfs_refcountbt_init_cursor
 #define xfs_refcountbt_maxrecs		libxfs_refcountbt_maxrecs
 #define xfs_refcount_get_rec		libxfs_refcount_get_rec
 #define xfs_refcount_lookup_le		libxfs_refcount_lookup_le
 
 #define xfs_rmap_alloc			libxfs_rmap_alloc
+#define xfs_rmapbt_calc_reserves	libxfs_rmapbt_calc_reserves
 #define xfs_rmapbt_init_cursor		libxfs_rmapbt_init_cursor
 #define xfs_rmapbt_maxrecs		libxfs_rmapbt_maxrecs
 #define xfs_rmap_compare		libxfs_rmap_compare
@@ -176,9 +180,6 @@
 #define xfs_verify_rtbno		libxfs_verify_rtbno
 #define xfs_zero_extent			libxfs_zero_extent
 
-#define xfs_refcountbt_calc_reserves	libxfs_refcountbt_calc_reserves
-#define xfs_finobt_calc_reserves	libxfs_finobt_calc_reserves
-#define xfs_rmapbt_calc_reserves	libxfs_rmapbt_calc_reserves
-#define xfs_read_agf			libxfs_read_agf
+/* Please keep this list alphabetized. */
 
 #endif /* __LIBXFS_API_DEFS_H__ */

