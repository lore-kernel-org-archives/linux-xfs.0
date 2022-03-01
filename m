Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A655C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Mar 2022 10:40:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbiCAKlX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Mar 2022 05:41:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233233AbiCAKlV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Mar 2022 05:41:21 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5E390CE6
        for <linux-xfs@vger.kernel.org>; Tue,  1 Mar 2022 02:40:40 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2218P1Xe018829;
        Tue, 1 Mar 2022 10:40:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=gDFKErtshCd32A1z8BfS41b4mUOBxh6QibF8yl4r3os=;
 b=vwMMsjhDHF7QJHyqoiNhVz2lrdBGFeQIVMZIrDVtAOVmXFL4QB1IMagTGnaaZVo+MNW2
 MMKkqV59s2gipI+NXhWEHl1i2z8GwQxCRnN6mKWjxxZesmXsBCsH3cGpEr3iSDcVNBuT
 xCASRXC2baVKeW70IdEJ0HMWo0w0d6UOrhbEIs6zYyAw2kDNIrLlDHZh0rdlFNQQB8/K
 zm0xEjwNaPsxWn0ZYAaNUPKLE+usPuYolH3s9FIn38D1uENm3k4lMy0dn1bQiAUutMWt
 f+KV4+QzNrweh9BD6w2ZkGyXDw9Sz6JY/nVBNKRN5l58iTs6aje05nxN4WxWZpAktRl7 jA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh15ajame-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 221AZvg5029932;
        Tue, 1 Mar 2022 10:40:36 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by userp3030.oracle.com with ESMTP id 3ef9awys8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IEBtmc4f9hSlfo8WpNVTZ0QddGXBnAmmfhda/1rx3l7H+WlvGD1ICRDvq3mtG0fng86v3NXw+xKct1yvI7Mgli5q3oddcXFP2xUppeOerOt8r5mK/1qKJv8gbxTZ0KnwEmWiZcylWmEE2aEc9VaqcUY6j0+BZ8IaY44OGXA59ERRi+qsqMKv+2ImIuKUupK90E35/iMEYKOgyBhcPl3KmlCTgk8pvJ1aEmRyyaHjbbglm9vvYA5Z8G0cTuQayAcp/4HlWow7K7zRl8s/+uY5AXHMUcBmh9N/6WLpApFAP6WqD34CoVvOseR/qC6gycvbFDcLLpN7bJvXH3ov5fkEWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gDFKErtshCd32A1z8BfS41b4mUOBxh6QibF8yl4r3os=;
 b=nVOsLurohYRGSYGSoFFDJiXHfHoOMf9dEwvXgLVL+xveZDK93CcP9ZutjFKIE8uIiTk6cxzLZIJjlaFmZAsrOzPJ929T4WWHdpEDGmkd162ZWOWn8r3WzvDn3yTnu3kAkAZo/HB6ag/gSZQMsn+iVAYmQ2/E2Pj3uCJjx+e84ZTuKiWo9mlL43+h0fx8qTtNeHoxWP947VGOj+MlR3eU3QiQYYm/iCCPHdpxS+OGTiZE+X+LD5f4RUZ8eN9OO91fMc3gCM2MZdI3zRUE+eSljWD6MInJPsfiutw1kwpU+kQNYQyHG6IfGjf3o34EqSmc0ySF7g+MIW+PBydL5Tb2Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gDFKErtshCd32A1z8BfS41b4mUOBxh6QibF8yl4r3os=;
 b=IwpsyTmOUynGYBt3mvZM6wPJBo+gUcQ7pwZLxBDPby8EMS/30I4kbB0k2yl7xA6HwILxnRIuRsG6wRFUtQgK5EaIdt87qpkXJQimmw1T3YCtD9qt63swwWwR8IKihwI02kjluo4lcxTEMu5jjle0Cjh7yp6ruVdpdd0aLEZ5NRI=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by MN2PR10MB4160.namprd10.prod.outlook.com (2603:10b6:208:1df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Tue, 1 Mar
 2022 10:40:33 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 10:40:33 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V7 13/17] xfs: xfs_growfs_rt_alloc: Unlock inode explicitly rather than through iop_committing()
Date:   Tue,  1 Mar 2022 16:09:34 +0530
Message-Id: <20220301103938.1106808-14-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220301103938.1106808-1-chandan.babu@oracle.com>
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:4:195::23) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f49dad1a-7f34-49c5-44e8-08d9fb6fe9e7
X-MS-TrafficTypeDiagnostic: MN2PR10MB4160:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB416083D00F34814E5B662E67F6029@MN2PR10MB4160.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qnDf0hN3nId2GxJMnkkGQ+oJZXLChIny8yY5ih5lBqRXPNfjFFRjNWu0Fg6u3azZzF0Qcc2Yjh8u6sSrJ7Of3s69JxrywAMFAz4pzrNUiAKpAYyx/BzXca1ENRGH3Jqeb4dpFprxNutRVZ18W8r2Gr5/lerQ7Rw5PPSqC3hb1YZaj5imUnZTc4sDeGeo53f9YzjaGr4/VvXOiYXyMinATMMtMw5gGebltCQTw9YHMGDlAAhdS7a5uw+a79Ub5IiIfNQ35B5k7P+NnAvLEAe/UUR6d6+xyVoN3L/edVwifE8AJS2llIJf28yu8CeOal5h4/1UdxUKm9AA2fUKHCfDM6deVC+3aAHc/p05+zfgOIGWTUJcHqOFXdWqTNDpqs24VivokXHccwZzzjuOG7EWvd8MLocH7w3CDdT4DnVfDNU3fZwPfBUEyFrRHfTkKuenyFIYAhVErn//+Hj/EO6Q3zjMSa/LZifKewxGlzXBPN31SttYdxHW1/1FIQ/erBkPFsYc6d8Zh803d2dAH7+uH/WDGRQC1Q0Qd2qJBNcWo6KINFp8TzOZwgPwlXIEeAMSYf/5wAndSa1z00jLhXJ9F4ENAbrH/aVBvKeNG1E+WiJqhlcSZsvTykGY6H2kjyokpbc5vyqsFmTnw14baX9OZrSUIw8JjVZUGtKqPnLYxDrWrheEotTQR453REZ80OhQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(38100700002)(38350700002)(186003)(83380400001)(1076003)(2616005)(8936002)(36756003)(2906002)(5660300002)(66946007)(6512007)(6486002)(508600001)(6506007)(52116002)(6916009)(316002)(8676002)(4326008)(66476007)(86362001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yKbd5eN4whb1+9WQlXYzM88dSxeOVLuvS/eSkadtUjVaqE54p2JRyvG9Up/I?=
 =?us-ascii?Q?wuKIqExSxdDDP/gVcScco4UWFLeuaqeFl5IaCtQA3r1fO0T9r1WA3kLSwNfN?=
 =?us-ascii?Q?cn3JkW+IOhcL1KolBWacVWusqUQ1QQ8hRtAy9sf8Xsd7E7zFQnrxsMgdWio6?=
 =?us-ascii?Q?mIyWPZEEoTKj5q9dqNvb6ZJoluPq7mTNfRdvA4qkJRHx2IREIJHiJDaA+SLs?=
 =?us-ascii?Q?/t+PwygnGKKJp2hk4HToJGcvTWCxe8nuYfw/R4B2TfoVO+oxX9DJKsNANa1E?=
 =?us-ascii?Q?3DGqNjOZSAEiaz5J/t4mbxyzgYHWLuawe0gEHr21680rnQtpk6x6Oi9eyFxr?=
 =?us-ascii?Q?8tJhUdRS8hsDhp7/pjvIwwH9EWHXsVapwLTThAcZr/RZgyU0wOKxfp9uBo/j?=
 =?us-ascii?Q?YULwS0LU9IWvG0VCcpnLCH+ac+O3SFoqPHxLXBRL8fLCjqnpqooXEwmHpGRT?=
 =?us-ascii?Q?RjxJQLWcJzUirwTfgoH5OOI+5B/71MrpL+f49lVlvaKQkLFmlagqnDX7VJKO?=
 =?us-ascii?Q?1axJIeHhFGq0a2FpcogsLbWbuGbw7gwNq81tgtCsPZ2Nb8vPQGc/XTwJiSxk?=
 =?us-ascii?Q?pYRIMgvBKXVjK3CEGxIEBO2G1FCxynG4q9o5oM8U+ASW30Iw7NYN05r4HHwZ?=
 =?us-ascii?Q?/z8x1+74piiw6LYIKxKRkPFyTg3cWp7Uv41STLZD47lX5nFnUe2ah+nJKb7W?=
 =?us-ascii?Q?VpYhxf0AAtbHm19Ji11oXY0V3rKdc0a7ymd0KabxqeOL6U2JfGlo4mqWJWK3?=
 =?us-ascii?Q?WozAPLF9kFPWt2WJ7h5il929vVhYl2ze/L6ZP2VElDXY5qHAnzyT87RCSlq6?=
 =?us-ascii?Q?pycxuHvRmMKIG/b2CPFJZmIfIys83xFkfnu621a8ZC2pLGJY28c6d0OuX6UI?=
 =?us-ascii?Q?hhWbID8Ir/naFEjG33afo71/tmJCQ+JlZW3f2SKz0qi7khW0oANNf531harg?=
 =?us-ascii?Q?9jDRwevp5UiGmKPLzo0iLCVsTmthoGP5LnGxB1KVphY7TDftoCUWnYqLLFIG?=
 =?us-ascii?Q?4pQBG0Gg9+uKAaq5BJHBOYYfJvwnHS4erS+fxip5khWr9ijThnek0ywS1nME?=
 =?us-ascii?Q?ZSjztixC4OMSRRQYyv+VdzQ0raewsE5Qia5gj+UR9gwsC0+nqxKUEItvbv0I?=
 =?us-ascii?Q?lTO3ZL0ILBdFpM0585R3GQ+cgz83uSGqXRbyAHByofU3bHZG/7qhyz8GL5jd?=
 =?us-ascii?Q?7umqXEEzFkJbpbemX5YqykpBVzwjBfiRV3II109u0DMEPX7G5FU65cQRdMke?=
 =?us-ascii?Q?24hLQenOJiO0mWmgIeIoIgIVNrIH5qVpIjsCT4dosOD+wnPUj60TiJ20/wQM?=
 =?us-ascii?Q?wWq4xJM4UNH5bqTJZKAuClRfeAlaZ/SrlshcSON7S1h/kLIJdTx1YrvWGBmc?=
 =?us-ascii?Q?+rbVh42KNno70Nv5nEPIUiG7P+WDYRnl9WO9zIpmgTThKSYhM6Xzwqg+NVYy?=
 =?us-ascii?Q?JCwum5IGx/e9PoHH1RGCx1PAUuebIDLGB82/5H51bTBz00tfZky7kuXmTGOP?=
 =?us-ascii?Q?Hk/oTTYGeZVjzwuwsG3R0/8hR5Kqk//e40NvsZcYB2sb/S8zFDJs2oEwrNLd?=
 =?us-ascii?Q?H4lKGj5a2x8nt6cVcbePI660Y2coHzahva4VeFSRMRKszKG4+g1KL35ktxwD?=
 =?us-ascii?Q?AWxXdEcbtSshXRGy+9o/88k=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f49dad1a-7f34-49c5-44e8-08d9fb6fe9e7
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 10:40:33.6793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: McDI8g2p/+7ilK/zJwEmiOFxSSSt0d3h/kfzWaBPQgXHgeCfGlMUrerTI6JzB5FfgHgqLRxhR+Zkg7eJYx0l9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4160
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203010056
X-Proofpoint-ORIG-GUID: duAzlztSe8yoIHG8uUCktYURMfooODvv
X-Proofpoint-GUID: duAzlztSe8yoIHG8uUCktYURMfooODvv
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In order to be able to upgrade inodes to XFS_DIFLAG2_NREXT64, a future commit
will perform such an upgrade in a transaction context. This requires the
transaction to be rolled once. Hence inodes which have been added to the
tranasction (via xfs_trans_ijoin()) with non-zero value for lock_flags
argument would cause the inode to be unlocked when the transaction is rolled.

To prevent this from happening in the case of realtime bitmap/summary inodes,
this commit now unlocks the inode explictly rather than through
iop_committing() call back.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_rtalloc.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index b8c79ee791af..a70140b35e8b 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -780,6 +780,7 @@ xfs_growfs_rt_alloc(
 	int			resblks;	/* space reservation */
 	enum xfs_blft		buf_type;
 	struct xfs_trans	*tp;
+	bool			unlock_inode;
 
 	if (ip == mp->m_rsumip)
 		buf_type = XFS_BLFT_RTSUMMARY_BUF;
@@ -802,7 +803,8 @@ xfs_growfs_rt_alloc(
 		 * Lock the inode.
 		 */
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, ip, 0);
+		unlock_inode = true;
 
 		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
 				XFS_IEXT_ADD_NOSPLIT_CNT);
@@ -823,8 +825,11 @@ xfs_growfs_rt_alloc(
 		 * Free any blocks freed up in the transaction, then commit.
 		 */
 		error = xfs_trans_commit(tp);
-		if (error)
+                unlock_inode = false;
+                xfs_iunlock(ip, XFS_ILOCK_EXCL);
+                if (error)
 			return error;
+
 		/*
 		 * Now we need to clear the allocated blocks.
 		 * Do this one block per transaction, to keep it simple.
@@ -874,6 +879,8 @@ xfs_growfs_rt_alloc(
 
 out_trans_cancel:
 	xfs_trans_cancel(tp);
+	if (unlock_inode)
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
 
-- 
2.30.2

