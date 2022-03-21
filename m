Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A9DFC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:21:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344397AbiCUFWf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344394AbiCUFWd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:22:33 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D6C3B3FD
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:21:08 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22KJIenL012531;
        Mon, 21 Mar 2022 05:21:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=gCBsOsIC0ZtED6JcaCUQZndABvOJlz0vpFKYLVJqFPE=;
 b=XEQbFNg4J+brKuxhi/VPLfKt1fx2NUufCkhOsUvt6MP2RGt3R6YqtqzPh7wBarPd3mtB
 pJR2TLK0sS1W9nqn0uqWS/2Cezny+CURnfO8BYka/PEHzOVCrfWeMfWpLYqKqQECxi3J
 DhWPib0S//9aG3QlHGFXFw7eK17s5kPFLmL+HfftVemTa+t0QDFmN3NM5rguVZAi1xDH
 C257Dok5XnpTJlQk/llfl93mF2be/9Kk6p3Xf/aNhNbTMsHbCHekWjlrJuirv/7net3Q
 Y24zg/B7B/9xVM5Kv9y4zzTPpvyIxsOkNPHDN+AWHL4lb9izb73q9O8AvX/gH2QEW7Nv PA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew6ss23jg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:21:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5G0ix057967;
        Mon, 21 Mar 2022 05:21:02 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by userp3020.oracle.com with ESMTP id 3exawgevtb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:21:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OdyvHxa3G4FZmBhjI+hYcCwvNTrEIVtdnMFMZSPwdz4sHrF2KC4rEi/9NYBKyXO61bsjXUu74F95J61+UFb4yFxocQUFiuRKPrVAjn5++Q42HSGU5NaA+RPG9VHp22U2z+Fcs5W5+fkE26D34MEJZgzFc8n4qZoJ4vvek46olpw/0h3pZ/lk/20FXtPXf0pUsxDCa0QC9WM5USw/5FTrPYB274XIE8xqJgXJlFGZBJX8LYDqu6hmKnNqdRxOduh8kyIxdHR0LroowyC3JypfpLMPNAt53zDLzRFeVVjCq8A2w6na4UkWNX7mtM0k2Yz3347hqSisu8V61OsjvoGmjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gCBsOsIC0ZtED6JcaCUQZndABvOJlz0vpFKYLVJqFPE=;
 b=FTBa18aTSYpzy2iFB6Ns3IGrD0XGFUXAIyUtQEgNBhdRYVh8n09PLwxCZOrQtlBX0afIx1/mSl4FcmPmVUlkqACtke4m3uJ2Ydj6GLaslr1dfAtwykfJb8FplkBtsRvJH/XB2jGNgkNe/E5DXsD+Ugwr/6eRKiUYAVKZQPjYGvPMlVXnkQqVxTSWuYznKNNr5EWTEg47PU6ihmPpGwD44gcUa4CVyyoi9aa1jOztm8PYvIk54D9k4+xtrxdcTYXGg0EaGy+NOVHBCibaWe9o7LPO9ucKTIUBZUBTNdjnxJaWHCLxkO+mAkxdlgPhFf08ltMeGWb7dbNHdj/w+L/6gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gCBsOsIC0ZtED6JcaCUQZndABvOJlz0vpFKYLVJqFPE=;
 b=sVbBrFukWGoGuFTxc/IXzZpx4Xt/FEbUGS0N/ulLOiV/z2SiL6TQrSwGDbxXcoKVjv8+o2caSvK+XmW2s7XBqy8EEeRclU0xGLSG3xLpGJrUKRj04nx2j9qv9LgKPbOqBnhn1VgasGixiVXnceqhvLEoGu/oF3mGCqrx2Mh1VCM=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5563.namprd10.prod.outlook.com (2603:10b6:510:f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.19; Mon, 21 Mar
 2022 05:21:00 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:21:00 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V7 09/18] xfsprogs: Introduce XFS_FSOP_GEOM_FLAGS_NREXT64
Date:   Mon, 21 Mar 2022 10:50:18 +0530
Message-Id: <20220321052027.407099-10-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321052027.407099-1-chandan.babu@oracle.com>
References: <20220321052027.407099-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0004.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::22) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f51526d1-f0c3-47e3-9b21-08da0afa9613
X-MS-TrafficTypeDiagnostic: PH0PR10MB5563:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5563A71826FE6BC9F6CD6FF7F6169@PH0PR10MB5563.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hnw/waIIGT/cvx5Tm7MD+X0Tx2huEgWuikNewbgNSiFpIfTLBboZOYrmASMlHJSbhaRT/liF2Eh7e1Fd1cPfH1PtXKay+Wg/2abNavikOn3FCa3q0ZhBK6rZvqvZOFD8kfwI+tNR06HFGFyC4+QJyMJuxLcSGAfQFpTUJlGhslHAdc5rcI5/Phke4EXFaCWZhorMbboUjAfIf2vHmqLueoFnzxf5Z6cwrSOfNG1dWbgb0E4epUXE3OAyz0/kf9hzYXIBE8yVILbfYuARe8uYXt8hqvwrTor/YAm6jpH/Q9HYJS7Lm9QtHvZXUxoxKIrNF3k/LaK8AhEoe2PiEKVfTzw+2qAsGWbyC4+60ZvMnP9pde22twOZlCA2i2g/Xg/Hnjsho0YWhTub4c8C8zb9TTyfrgIZS842gDG6tcgKkM7mkMGtsatjpKz5UUuygvnGBa002+MFybWuTRtbGhpq0AvbjLGyJdyp+eM1gqrHrSF73m7aGIxRYEp3xG93sQnfxr/OVN9GPh/HhcMaU3tMgWkbhRS9bznn9hJfpoP8geiRFmr9WZwYFrMQR5QtwRjo1WiizA+zDJ2v4Ubsp03qGWlDMOV5oP6Id92/+8MaJImej6EP5f4upwkb6UHWutyNP5x5P/488Jy2ZQ6LIgcs+RREIWxU82aYS6HeAqxWUAGueisO3OtoUk/biGnJm+FbDINSeUikYL0Nz5sJnAzeGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(6506007)(6512007)(86362001)(52116002)(2906002)(38100700002)(38350700002)(6486002)(6916009)(316002)(5660300002)(8936002)(508600001)(8676002)(4326008)(66946007)(66556008)(66476007)(26005)(2616005)(1076003)(186003)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4BbHzP1m9uToRyyaXYLeRftL0Qnl2lQBwepUv3VkZG7mx30gvL/3pNYJF3CC?=
 =?us-ascii?Q?UE8KBG4Iku6TB35KWrZrtTwGKxTtpmS9KAHKJ4VTYWdGdOcRw1+J45vTPpQB?=
 =?us-ascii?Q?8xD0ddftqWM8Gv9E6IqBGEShvK0LBVEVPMbNS+LH0TBB8jyrEGVAW1N0HImE?=
 =?us-ascii?Q?kmiefKzFyd+F73mvILgSbG+wUqA/u002dzqyiU2UTxhPleJile+BzdfMXXP0?=
 =?us-ascii?Q?znYLFDPEEDgEWzLl9/c/vB+tncOltkSWsaRLPJAhUJ0fPFIpBJBhxnW+ju+f?=
 =?us-ascii?Q?S2NlRxzDu43vKsjI2QlmKXiWnmdDHyZdGWv1r2u4o4C8Qv3HqIhkh0V9eXKJ?=
 =?us-ascii?Q?Mo1gYAxEm+OGLmlcg1vIRfTYU3if/r3xiMS4CViIIhPXBvghtF3k1FFiyoI9?=
 =?us-ascii?Q?WP0BsayQzy5EJHA7vXr2pXOe3qUA9rPCG2af6Le+hsypl5uEWJMfGHUwWy96?=
 =?us-ascii?Q?EEUd0H3HBHqPX52prqRIEk4TLwsm+IM3r7Fjzn7tJTJlnZ4GR4rJHvun7g9K?=
 =?us-ascii?Q?FbjLVp0v6rNWN7AxyO09OpzuwYE228M/6xtdSKz48e+JCRNxMpssWbNyw//q?=
 =?us-ascii?Q?3H8mpka4Yr9PV5HTmS/2kRY4+5SN0qCNYFO4+q0BXEnrXmhmV8HO2V8aaucd?=
 =?us-ascii?Q?Rmli2DlMbGOfSMnHOGcZ17Tq20Eokdmmsg5jv/P48NXY5aVPRg73+NyMolUc?=
 =?us-ascii?Q?O4bwMWVtTuVptXw1y8P5XU3q6G2NFBys/C3Nm98jpVXHaGCktNtsVz551i3b?=
 =?us-ascii?Q?uP3ZAJNJLJGWIDAggAS8NXLZNj/q8T15dWVkufsIgcKXV2Syb9uabggk4NOL?=
 =?us-ascii?Q?kCdIZrGwNoe3KHtRKi1qwpUbA23bxGoGYWJfPEbSLw3ftZGYzLtFLEFYLAvm?=
 =?us-ascii?Q?nooJHa5fjzs+re/x+D8moQ3uelJc8kENjOmi4O0Toh/gLrPOmXR8NMitBHKh?=
 =?us-ascii?Q?0Sd0hmyE29y+WAuEj95VuBmldWUsGg5QcHsL/fh3ATxfxau8F7Zi1yZvxobU?=
 =?us-ascii?Q?TunCdm7RFwZluM2pxW593JVcGWe0HjaQSOkEo+sl+gWMaP2sVbXv6YKrY5hH?=
 =?us-ascii?Q?gA9CPPdTmCqVmHbfFIpmLdVzjqxEMjkKLP8kMiUIUzSzRfdnRmmgc9t6sflo?=
 =?us-ascii?Q?ZKlK1DKQFINBRtX1xBsAYwwwWWG/9pY3TxiwOOhzrTG2+p0zbt1Ujp+WwOP0?=
 =?us-ascii?Q?EJnupMujIEsn7h5BhUP+jjvx/0sf3fFrqURCdW71C0l3cqXhkHAhK4UbYRqD?=
 =?us-ascii?Q?8rUVQFREXco4v6CJaroGcjSIV355ttjSAiUJjVc1OLawMBYCulGcb5hPx2Bk?=
 =?us-ascii?Q?H2hE39PwcUvpmpS26dOraRw65qz1kbTxoByr4/epAljVq7rV5fOjj6m4CleB?=
 =?us-ascii?Q?507mCGZt9oOHTFGCCDTaAt1ZoWAk46410FDqsJl1kMHeVYT1RG7014VjHjgM?=
 =?us-ascii?Q?ruNceeNHKjF2OeFOnAPigd1vpDdTrmu8oArZm67oOY69kzhwl2Sapg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f51526d1-f0c3-47e3-9b21-08da0afa9613
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:21:00.5284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B+lv4F3m1mR2xX76HjdjCt+ivpRjF/EULPXhCFtpSUoC/nUMNSqyUZpMP5fHBIN2vYaNUVmirNbYL6U4glesog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5563
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203210033
X-Proofpoint-ORIG-GUID: 8kojde3or2FpEL2gIJdFXL3iSqVFOEOB
X-Proofpoint-GUID: 8kojde3or2FpEL2gIJdFXL3iSqVFOEOB
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS_FSOP_GEOM_FLAGS_NREXT64 indicates that the current filesystem instance
supports 64-bit per-inode extent counters.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libxfs/xfs_fs.h | 1 +
 libxfs/xfs_sb.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index c43877c8..42bc3950 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -251,6 +251,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_REFLINK	(1 << 20) /* files can share blocks */
 #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
 #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
+#define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* 64-bit extent counter */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 7ab13e07..e2fce42f 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1136,6 +1136,9 @@ xfs_fs_geometry(
 	} else {
 		geo->logsectsize = BBSIZE;
 	}
+	if (xfs_has_large_extent_counts(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_NREXT64;
+
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
-- 
2.30.2

