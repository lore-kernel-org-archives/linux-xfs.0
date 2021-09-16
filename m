Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84539C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:09:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F50761185
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236417AbhIPKKe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 06:10:34 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:37496 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236222AbhIPKKe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 06:10:34 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18G8xk7f012704;
        Thu, 16 Sep 2021 10:09:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=Fkgcmcg3mthCMFPu+6EttrbpdEUYXkY0UlqP/HQQi+g=;
 b=JGWtsPZ7uhecz9QolLO8mUtxH23uCJVrcTr4clfvBp9U4mE1XxN5jzkcLOo3eNyS94iU
 11PZakOPeYPYPMgEAo4b1IMmQVbhJ6UDBODFZrDw8nCXGIy6+XNVS8Znht/TdmlG93ZI
 izV0Gp8/z+rI17+FzgFAIATeoBJoz56idG+TCh97rJWy0J9q2s5/j2yOoW+SgYKUWHoZ
 Pob9vwnjH12XUKwsNzco6I44D3Rw/u7OX+4BEY7o5ug31u5WhB2GVn1SIZ6bvg0CWxWY
 /O7omMg1WFqyfEmqzDCu4auXB3L6oiiIQDyhDHhyVofiF9fCHWJaoWEaM2cmXXi4ZUgo 9w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=Fkgcmcg3mthCMFPu+6EttrbpdEUYXkY0UlqP/HQQi+g=;
 b=d2oNUyOzJsviPcerc5oz3NCUFvVmAmePq6Z5y/WQunPUt/W35aZDM0fXpmsAQn6LjiBq
 /CC4XzrFShy1Kh6l8whewosRsFanmFDNSYRyP3WzQtok7Usqnp3TTVD9Fnng0MCp/C44
 RwJTpE7Z1g60wSA78I8r8WU2C7fNEVz7JsrQRBtjKKgCML8ZYUTIqr+0VVfU9sBPYNeM
 FfYrlvGylkLUNI4TfNaWwWqGTRGMm/VGsuEfGy00BRCyCE5BUmmMV6XzP979FQDB8t+q
 pXJ1Uoeq8YNcOPWWXdtPZqziGyLJ3Pu++J0cs3QrZA5IC7B67orNvwidEMu9bYYWjS6z 6A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3s74hgrq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:09:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18GA6cvF160360;
        Thu, 16 Sep 2021 10:09:11 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by aserp3030.oracle.com with ESMTP id 3b0jgfv5y7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:09:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jyHmthj1QNVDisblWy+scw024KRYFm+vDyk351aCKTTdqwXUT7wO/ltQezNnRBWEcogY7qBv0a0rtOc43l+l5/1lFPwKZ0JVDiChMGLTqv13t4HEJKJMj/gp8Fk+fBQl6ylCLlQ5g3t4hNjeFaoRYfWjhywrIOREVEVoAWT0mUpJcwsv9LWZPTHmy9l1350zqzbbfAzwXM0vbaEVA8JZRP3hPSElhuemXXu1Ux0HJqwEEM73BhBvKlut5P0WUO+zj8rlHXT9orgXcJqT/hzFY1bc4UP+9q8SUJG1uwcn7YkJ18fXTuHjuAiKmBKSxv51yCYRNxWiT9Gu63LZk7d2RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Fkgcmcg3mthCMFPu+6EttrbpdEUYXkY0UlqP/HQQi+g=;
 b=h8WrgT9CCiRityl58lhlrqGpX4tUK6A5WzhRDxzXpVF38p9TgPGOX/YJPY/TnlWM0dduPJi/sAysJ9+ruPff33SUtqwdg3CIhwMWKX/VgxzJY6BTqkA1C1Gtt8VGqui+WUDy+L1CMku3mf+Wpvj8Foz5DoNETD7Y+poHEJmVrVpQgmIyRJgZQX8VFV8Go9ZI0bVdfzmEWSfIm3iaMpWwTYZf3Yu8/TmG9sjgnP4q0ngWxB8rgAM6NNwbLqk0yEKWOle/3ga+RUESmk/0ujnxRlisv2lBU25krHQYw33eZkA2nXMxpl9WKFm4Fz8JZ3X16vsXXU1OS3cRMqCCxuZu/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fkgcmcg3mthCMFPu+6EttrbpdEUYXkY0UlqP/HQQi+g=;
 b=QQUysAF2Ca/zXSTpgE1SbR1vidpT0eCpGCFZajl6qCsVNGi+xSiM4bUyT8EJmR0C1i/D6U7KvPZWrNMTz1l5urjnfSnLxC73ho0tRfTsNXiVXvXfjy09VdL8cJ7Jspm5uyaPyu1cFviWcmr0bJna4G2RQNhjyygaZdVGloc3BmM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4748.namprd10.prod.outlook.com (2603:10b6:806:112::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 16 Sep
 2021 10:09:10 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 10:09:10 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org
Subject: [PATCH V3 09/16] xfsprogs: Promote xfs_extnum_t and xfs_aextnum_t to 64 and 32-bits respectively
Date:   Thu, 16 Sep 2021 15:38:15 +0530
Message-Id: <20210916100822.176306-10-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210916100822.176306-1-chandan.babu@oracle.com>
References: <20210916100822.176306-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::28) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.171.167.196) by MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 10:09:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b174e41-0a2f-42a2-473f-08d978fa0681
X-MS-TrafficTypeDiagnostic: SA2PR10MB4748:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB4748933D7B30BC5BF420EA71F6DC9@SA2PR10MB4748.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:26;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UlxNWvXBHHOfsHzPUttxqOTnhsX4AT7JZVbag8MkmzbNOKjQDG5yXWkTX9PMHImamG/JA+upuBdT3LVzZJwGC5r2Zitxzax4e/JbJUg6/5kTpqlxARyKLZy3hgm8DDrIZjU3xlBsmkqkU92ZAOv8LbWxjHeX45mL0AX1l9svc6HeA3qYjQGkVRqr4QhE3mcdhxl13iRAdkODF1oE+6RdDEKMnwKVGxDTHiBGck4W+Z29STKRYVgMvHecPxrVTsfdgsS7B1KwrYMQRGrcROrb24L+90zGYR5dklkbWzbcFzZCUnpZ53DQ1otjhM0c9AcN9jWda+RTHaGcowxss8KBIboLr2B0OswyDSzqK2DROjpI5sIu0VmqUlK7sSN8YMMzQ+vonGELgQH40hok+4CnhiYZZ11u2EWltkcOxb+vrGwejUQwQSEt6kHiNiXGRUXrthr5rcnasFT+gfhV/ba8BNCzO5cepS2jrAkzKiiDO4M1oKbSbhZldZ3xFqFQzdISKs4eC2UE6KntW7TZR+cpJc2wRWIujMRWw7Oyg9zK22o3j9XGsJua/Wa0BjjAK5DQsQ8MIZQlD//Loc9i+gotiiF7zYJwWGEajApR7UarMNMtHU1qIlzIqDPP7K+ecFb/FGIlhadCefJUkp6GrM1wnHAZCXFOp/MVUPz5ikdjAQ3pdHemZx9DxLruCbA+QUCKGCf1G7Ko3lPiPAFtIfCghQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(366004)(136003)(346002)(66476007)(2616005)(66556008)(66946007)(6916009)(2906002)(1076003)(4326008)(956004)(6506007)(83380400001)(316002)(8676002)(36756003)(478600001)(38100700002)(38350700002)(6666004)(52116002)(6486002)(8936002)(5660300002)(26005)(86362001)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+8ypf4DaGeSVK4+n56wSV30E63+Wf6A7UgvAHErQShcczP8lEO/XRhZK+xdZ?=
 =?us-ascii?Q?mOM6uftavukptkd2/r305VIBy8T1/ReZa/xjlkSa/Kw/czoTvTV11dNJpwoU?=
 =?us-ascii?Q?RYFqsbXxwQZNFQo+Uhi3snLUpTyiv6jBBhWjAy0kNOyYNfeaQaAI9pXUiISC?=
 =?us-ascii?Q?tNC6WDKGD8wPzhebAlAJsUi2UoLG19zadE4jFauxpDij9tNsvTq9cSGL+I3L?=
 =?us-ascii?Q?sWXdJl+5DF+Y5nI8T61HEi5PzxxYsHVw92l++TkUtDM3kVrjZwQ8gLF8ShIu?=
 =?us-ascii?Q?KljOn6r9cLmWaU9pP21H6xiOC9DvRX1PUDY+T+Pc9SzSfayTMvVJb/H7gjES?=
 =?us-ascii?Q?I7ozlvWetOKafowNVSYcOs2x1av/l/alKtbez8EwZSdvKQw1seFOC8BCK5J0?=
 =?us-ascii?Q?h/BZPfAwhs//4w/UwUN6GkswjOle87vFMs5pwFcw4Gdd6jAXRkmx6vpT+yjV?=
 =?us-ascii?Q?FQpdZeiXMx+HaA5qUq02Fg9E5g7mbPZ9+ExiJhWl+sTCVbQXc/HTdNM88vwD?=
 =?us-ascii?Q?D4URBq95xcVp7hOCkU6rp+I71pN1eLhGnKYHyyaHZ8Fggf4spzWU9HA6+XgI?=
 =?us-ascii?Q?EnD5mmXUxbDg+G9OPeHAeTu8dOoTKHVztTUVbpeMVMoVxIfTWqvSHfcBkLXA?=
 =?us-ascii?Q?oFXNY02wGo6cHvfytfTcHwk2iX+79O5lUVbBcgJ+i4sQW4qC8TY3117bIErL?=
 =?us-ascii?Q?CU8RIBuntdSz/7b/eQpRXLQuU1rmgiecZ+iWt5xNV78Rajs2bgdimqGb6oui?=
 =?us-ascii?Q?bP5XyO9t8h96WmEUR9VEBUQHDTILzoDlKftnyT/L0VqtyHqv+Mpuak+jhjAm?=
 =?us-ascii?Q?5+dGPcfUpddEf5ttWfJ0jFp42kqyPVyEUJa2zUg/JGGcLPe4Ybnf2YA8uP4A?=
 =?us-ascii?Q?bXBxB6/WcerCAAeERi/mdc5x984iRcxRpTqgwTl3B1DY3dBriFkEmX2a2PBB?=
 =?us-ascii?Q?CmjiG00KuiL22e+M564ubduC4cR5IV4zJ/oQ6J0kKUc5vNsBecOIOLCzB+F8?=
 =?us-ascii?Q?36XeERnU/pFjkUAqnHDYNUJ9A8fvZQhnSSERE7G+h+zX+ZQxZvVuUt4tG00q?=
 =?us-ascii?Q?XU4XBo5QKKUIBI/bFg2xQozHr9yW/SUaM3Az3dLjluz68LMsZBUaEuln1pC1?=
 =?us-ascii?Q?k08Vq0oV/gC1tSmXaF1jj9JDrDAldDL9twmC7OjOcJPdIIAr5KjmwBzEBWiS?=
 =?us-ascii?Q?oxZLMA8LV8no18SBCciYnZ6XsCpzGgL/fxfQV3ID06XHUZUJQTfbmWMWYi2T?=
 =?us-ascii?Q?GxOvGUePSpHGvKu09FgLmVPkc+VsEwrs6XQNC0I3De1n5l1VedYJF1goQEiT?=
 =?us-ascii?Q?q7C8NJDXoo70Kdat3utK0Gve?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b174e41-0a2f-42a2-473f-08d978fa0681
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 10:09:09.9960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wbVf4ZDQS2JSj6taZVvONYZokxhMSyNutA0TKfMCBECMSRihrnU3IUFh1rDAIIk/edolZWsN+Nc6daBYP6QQKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4748
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109160064
X-Proofpoint-ORIG-GUID: EdjZLzVoCJ_rqDIkl8_RBPV0fQmHT5Su
X-Proofpoint-GUID: EdjZLzVoCJ_rqDIkl8_RBPV0fQmHT5Su
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A future commit will introduce a 64-bit on-disk data extent counter and a
32-bit on-disk attr extent counter. This commit promotes xfs_extnum_t and
xfs_aextnum_t to 64 and 32-bits in order to correctly handle in-core versions
of these quantities.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libxfs/xfs_bmap.c       |  4 ++--
 libxfs/xfs_inode_fork.c |  2 +-
 libxfs/xfs_inode_fork.h |  2 +-
 libxfs/xfs_types.h      |  4 ++--
 repair/dinode.c         | 20 ++++++++++----------
 repair/dinode.h         |  4 ++--
 repair/scan.c           |  6 +++---
 7 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 19db26e6..3c23ea30 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -47,9 +47,9 @@ xfs_bmap_compute_maxlevels(
 	xfs_mount_t	*mp,		/* file system mount structure */
 	int		whichfork)	/* data or attr fork */
 {
+	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
 	int		level;		/* btree level */
 	uint		maxblocks;	/* max blocks at this level */
-	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
 	int		maxrootrecs;	/* max records in root block */
 	int		minleafrecs;	/* min records in leaf block */
 	int		minnoderecs;	/* min records in node block */
@@ -466,7 +466,7 @@ error0:
 	if (bp_release)
 		xfs_trans_brelse(NULL, bp);
 error_norelse:
-	xfs_warn(mp, "%s: BAD after btree leaves for %d extents",
+	xfs_warn(mp, "%s: BAD after btree leaves for %llu extents",
 		__func__, i);
 	xfs_err(mp, "%s: CORRUPTED BTREE OR SOMETHING", __func__);
 	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 6b69d34e..9b25f3be 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -124,7 +124,7 @@ xfs_iformat_extents(
 	 * we just bail out rather than crash in kmem_alloc() or memcpy() below.
 	 */
 	if (unlikely(size < 0 || size > XFS_DFORK_SIZE(dip, mp, whichfork))) {
-		xfs_warn(ip->i_mount, "corrupt inode %Lu ((a)extents = %d).",
+		xfs_warn(ip->i_mount, "corrupt inode %Lu ((a)extents = %llu).",
 			(unsigned long long) ip->i_ino, nex);
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 				"xfs_iformat_extents(1)", dip, sizeof(*dip),
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index e8fe5b47..4b9df10e 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -21,9 +21,9 @@ struct xfs_ifork {
 		void		*if_root;	/* extent tree root */
 		char		*if_data;	/* inline file data */
 	} if_u1;
+	xfs_extnum_t		if_nextents;	/* # of extents in this fork */
 	short			if_broot_bytes;	/* bytes allocated for root */
 	int8_t			if_format;	/* format of this fork */
-	xfs_extnum_t		if_nextents;	/* # of extents in this fork */
 };
 
 /*
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index dbe5bb56..a3af29b7 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -12,8 +12,8 @@ typedef uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
 typedef uint32_t	xfs_agino_t;	/* inode # within allocation grp */
 typedef uint32_t	xfs_extlen_t;	/* extent length in blocks */
 typedef uint32_t	xfs_agnumber_t;	/* allocation group number */
-typedef int32_t		xfs_extnum_t;	/* # of extents in a file */
-typedef int16_t		xfs_aextnum_t;	/* # extents in an attribute fork */
+typedef uint64_t	xfs_extnum_t;	/* # of extents in a file */
+typedef uint32_t	xfs_aextnum_t;	/* # extents in an attribute fork */
 typedef int64_t		xfs_fsize_t;	/* bytes in a file */
 typedef uint64_t	xfs_ufsize_t;	/* unsigned bytes in a file */
 
diff --git a/repair/dinode.c b/repair/dinode.c
index 4e95766e..c995a524 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -357,7 +357,7 @@ static int
 process_bmbt_reclist_int(
 	xfs_mount_t		*mp,
 	xfs_bmbt_rec_t		*rp,
-	int			*numrecs,
+	xfs_extnum_t		*numrecs,
 	int			type,
 	xfs_ino_t		ino,
 	xfs_rfsblock_t		*tot,
@@ -680,7 +680,7 @@ int
 process_bmbt_reclist(
 	xfs_mount_t		*mp,
 	xfs_bmbt_rec_t		*rp,
-	int			*numrecs,
+	xfs_extnum_t		*numrecs,
 	int			type,
 	xfs_ino_t		ino,
 	xfs_rfsblock_t		*tot,
@@ -703,7 +703,7 @@ int
 scan_bmbt_reclist(
 	xfs_mount_t		*mp,
 	xfs_bmbt_rec_t		*rp,
-	int			*numrecs,
+	xfs_extnum_t		*numrecs,
 	int			type,
 	xfs_ino_t		ino,
 	xfs_rfsblock_t		*tot,
@@ -1091,7 +1091,7 @@ _("mismatch between format (%d) and size (%" PRId64 ") in symlink inode %" PRIu6
 	 */
 	if (numrecs > max_symlink_blocks)  {
 		do_warn(
-_("bad number of extents (%d) in symlink %" PRIu64 " data fork\n"),
+_("bad number of extents (%lu) in symlink %" PRIu64 " data fork\n"),
 			numrecs, lino);
 		return(1);
 	}
@@ -1652,7 +1652,7 @@ _("realtime summary inode %" PRIu64 " has bad type 0x%x, "),
 
 		if (mp->m_sb.sb_rblocks == 0 && nextents != 0)  {
 			do_warn(
-_("bad # of extents (%d) for realtime summary inode %" PRIu64 "\n"),
+_("bad # of extents (%lu) for realtime summary inode %" PRIu64 "\n"),
 				nextents, lino);
 			return 1;
 		}
@@ -1677,7 +1677,7 @@ _("realtime bitmap inode %" PRIu64 " has bad type 0x%x, "),
 
 		if (mp->m_sb.sb_rblocks == 0 && nextents != 0)	{
 			do_warn(
-_("bad # of extents (%d) for realtime bitmap inode %" PRIu64 "\n"),
+_("bad # of extents (%lu) for realtime bitmap inode %" PRIu64 "\n"),
 				nextents, lino);
 			return 1;
 		}
@@ -1870,13 +1870,13 @@ _("too many data fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 	if (nextents != dnextents)  {
 		if (!no_modify)  {
 			do_warn(
-_("correcting nextents for inode %" PRIu64 ", was %d - counted %" PRIu64 "\n"),
+_("correcting nextents for inode %" PRIu64 ", was %lu - counted %" PRIu64 "\n"),
 				lino, dnextents, nextents);
 			dino->di_nextents32 = cpu_to_be32(nextents);
 			*dirty = 1;
 		} else  {
 			do_warn(
-_("bad nextents %d for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
+_("bad nextents %lu for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
 				dnextents, lino, nextents);
 		}
 	}
@@ -1894,13 +1894,13 @@ _("too many attr fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 	if (anextents != dnextents)  {
 		if (!no_modify)  {
 			do_warn(
-_("correcting anextents for inode %" PRIu64 ", was %d - counted %" PRIu64 "\n"),
+_("correcting anextents for inode %" PRIu64 ", was %lu - counted %" PRIu64 "\n"),
 				lino, dnextents, anextents);
 			dino->di_nextents16 = cpu_to_be16(anextents);
 			*dirty = 1;
 		} else  {
 			do_warn(
-_("bad anextents %d for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
+_("bad anextents %lu for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
 				dnextents, lino, anextents);
 		}
 	}
diff --git a/repair/dinode.h b/repair/dinode.h
index e190b743..09129e7b 100644
--- a/repair/dinode.h
+++ b/repair/dinode.h
@@ -20,7 +20,7 @@ convert_extent(
 int
 process_bmbt_reclist(xfs_mount_t	*mp,
 		xfs_bmbt_rec_t		*rp,
-		int			*numrecs,
+		xfs_extnum_t		*numrecs,
 		int			type,
 		xfs_ino_t		ino,
 		xfs_rfsblock_t		*tot,
@@ -34,7 +34,7 @@ int
 scan_bmbt_reclist(
 	xfs_mount_t		*mp,
 	xfs_bmbt_rec_t		*rp,
-	int			*numrecs,
+	xfs_extnum_t		*numrecs,
 	int			type,
 	xfs_ino_t		ino,
 	xfs_rfsblock_t		*tot,
diff --git a/repair/scan.c b/repair/scan.c
index 698befd3..bcf523da 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -223,7 +223,7 @@ scan_bmapbt(
 	xfs_fileoff_t		first_key;
 	xfs_fileoff_t		last_key;
 	char			*forkname = get_forkname(whichfork);
-	int			numrecs;
+	xfs_extnum_t		numrecs;
 	xfs_agnumber_t		agno;
 	xfs_agblock_t		agbno;
 	int			state;
@@ -443,7 +443,7 @@ _("couldn't add inode %"PRIu64" bmbt block %"PRIu64" reverse-mapping data."),
 		if (numrecs > mp->m_bmap_dmxr[0] || (isroot == 0 && numrecs <
 							mp->m_bmap_dmnr[0])) {
 				do_warn(
-_("inode %" PRIu64 " bad # of bmap records (%u, min - %u, max - %u)\n"),
+_("inode %" PRIu64 " bad # of bmap records (%lu, min - %u, max - %u)\n"),
 					ino, numrecs, mp->m_bmap_dmnr[0],
 					mp->m_bmap_dmxr[0]);
 			return(1);
@@ -495,7 +495,7 @@ _("out-of-order bmap key (file offset) in inode %" PRIu64 ", %s fork, fsbno %" P
 	if (numrecs > mp->m_bmap_dmxr[1] || (isroot == 0 && numrecs <
 							mp->m_bmap_dmnr[1])) {
 		do_warn(
-_("inode %" PRIu64 " bad # of bmap records (%u, min - %u, max - %u)\n"),
+_("inode %" PRIu64 " bad # of bmap records (%lu, min - %u, max - %u)\n"),
 			ino, numrecs, mp->m_bmap_dmnr[1], mp->m_bmap_dmxr[1]);
 		return(1);
 	}
-- 
2.30.2

