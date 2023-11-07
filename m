Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 524A3C4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 07:09:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbjKGHJ0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 02:09:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232365AbjKGHJZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 02:09:25 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF29B11C
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 23:09:21 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A72O4CH019476
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:09:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-03-30;
 bh=GtfiDGiHWQhg/lFBykhY49xpmv51EHtbMSF0OyQcM3s=;
 b=sqOwC+RyZFn89xG5KtO7LiO9XIHVEfyYm4Pil0jpylKnqVdt3ayACJQZuqO9uZ4yrhu5
 ETde7GpmksG5rwHz/3p/w4CM/2t3jCfYvDkX7NcnhPHRXJLVgm4e15u/p2wtg2z8FQLN
 W67lkAzQ/43UMrqpKfi6kxMcTCFc0feu5B7mapDIXLpxI+HeHC//RC+ldkQ9zgErb3bC
 wFX2VHtNoNJPe0hzWOT5DAnIfFQbWsNLEgXcNW1aJV1Jsv688GXBeLyyZZjE+ywHZQwg
 wuC0c4txauOvfc6Ypf0OJomHzXjdekgFG5B7LJUjxG5DtGW7i7DTFIRm7BjOEqeLaEkE wg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5cvcda2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:09:21 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A763nu6038284
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:09:19 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2168.outbound.protection.outlook.com [104.47.73.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cdda54r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:09:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l0dMsr4DcEQK31+Ot8ma2MNED98A4gQZEZV+WwCRWVmOryTaerWZ0P/CH4lhEUniduL9XQyWpBWvm/hQGlz1xb26Ytdnlc29mLW3EJOnlE4Bn5ZJoG2+Vv8RPrKVL/0f7QYnd5DLaD3JcAz3a1sPEBETJZp2+U9ag25l97klp9Ye6XqPTmeQ7JZg4JkGUzMjEZbuv7JJYJNao8LjzLdKb9qbr5PyarMaYwIdjUU9J/6eoD6Bap4mLHyAFDOuXxAcmlB0KDBBfE5yoGTomy/c217WfwP+bYnu7XArL0dY+1zSPr07pw4bqaYZiQfYcCcBwWHZtuSdCfljp6L5+Szb2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GtfiDGiHWQhg/lFBykhY49xpmv51EHtbMSF0OyQcM3s=;
 b=Ala8hHWVe9RtFTIj6vzd300Qv0F9JR3c/SwLO8MnDVGuDgxFxrVDn7s2joPkG0MtWRLCLrLjt/xEO/vSav28VY1QO2wgpQMZmHilmLxecvZofKN0HVisbZOQUn08Uucw+I7Jhq4suVMoqqfiZi5iwTY4LUf01u1PI0W+mhQ8+tOzh/gZkHxuI7/DEW1KM9P2DyZvqxNxxk/6bqmEJiCl/xAkFpd8SWxaFhnPIqVi83tteiKD+OwzW7u2bT7U832OaYvcBhSHUuiRyvphpLqkFI+OTMHV707HHaadN7YFBQKFhVUW7LjsLgQt0BJ2JGnRPdkEQKdRGyspXjfxG3ZuSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GtfiDGiHWQhg/lFBykhY49xpmv51EHtbMSF0OyQcM3s=;
 b=iiTLvUfe8I7mtWLPOnFQ5ralib/vfwbZJLnrjkC2XoD5SS2lwuXzP/SYJhj0SoeGaPKxL8WGCWOmUq5h8urx/cTGAXNuFqCqwuZJC1QjNAmI9Qb5dAp6+qwgwbuiXk648mJ52I/1W4jR6tPSTPBm5RwnRHqOWr8Rl8LSMFCFbDw=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by PH0PR10MB4616.namprd10.prod.outlook.com (2603:10b6:510:34::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Tue, 7 Nov
 2023 07:09:17 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Tue, 7 Nov 2023
 07:09:17 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V5 20/21] mdrestore: Define mdrestore ops for v2 format
Date:   Tue,  7 Nov 2023 12:37:21 +0530
Message-Id: <20231107070722.748636-21-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231107070722.748636-1-chandan.babu@oracle.com>
References: <20231107070722.748636-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0037.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::9) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4616:EE_
X-MS-Office365-Filtering-Correlation-Id: f14e2fa9-a5b1-4d75-6de8-08dbdf6074c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UC6LCcpmLWz3InhO2kUwAk4Rukjq/BE6wp2Siejczzg48k1SOQTGRFcQGy6AeNTTj2YeCOGGKxvzRZxA0006edZOQPfuHg9ACQbxJiwK6iQJvHICUkm4Os6zuBMUIO7xDrDN1RNvGrd6cQE88Qkxi+stDR/wQmxvXf6RviKcIvkbSMzoMcy36V6vXKqYV7EChKdW4P11TXMsIK8uzwdmS1oRVWAG0KQTwn99poZIsMkp26MTsZfWutEdNWCCqIqICyBcQ3DzJhL+A+cBgMCHb8C2hQn0UeUFg0VN7TORYnLKXHM2++zGscCA/8QEG+LaVVUI5loPFJeauSXMbMVBafXWeHqP+NkjJvdNks81JDf2LvlTqZqWqwf7kWEmZV+kMxV2MTUL52DE5y3zupkFK0fNcYTjZnmT4MjciPJ8/97J3hb62swvdkYJFtzgJoXpq/ijqQO8RSnhShFLgK/khp7kO3sGM0ThGzdDXV98Ctqsc8hkIiDCzE4qfCKnL2YvMTaDObAQ2SsVujAGL7eCp3caFZS3RtCgaLYr56myu5pAb/8XmA0kBIZx4XnDe8MOvRPcnDaUK21EUl7cglJTNVF7UMUwn6S4ThHFt1aWU1H7820xvhr0VqeNLeWGdF2x
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(366004)(136003)(39860400002)(396003)(230273577357003)(230173577357003)(230922051799003)(1800799009)(64100799003)(186009)(451199024)(2616005)(41300700001)(6512007)(1076003)(8676002)(26005)(478600001)(6486002)(8936002)(5660300002)(36756003)(86362001)(2906002)(66946007)(66556008)(6916009)(316002)(66476007)(6666004)(6506007)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0GqEfq+PiU7sfwCcwHUNFdqnqmTv8mGGTG60Hw0clWeCnYwJqtOsRV8/BeK4?=
 =?us-ascii?Q?a1KNlXguv3t/pXUGb9OWSFt80pQDdTgD5F570dEeqyYFg7vTtFT7qgMFHYVV?=
 =?us-ascii?Q?nHXMLud8hub7Qzp5ouiy+NoR5NlwpfdgmURk9RC7JC5dOQ4Fk6LE5Oj2sOak?=
 =?us-ascii?Q?xv329qZTK098jhz6pBSeZSO4x9VbS059QrgIKs7MRjSB+A6VzL+7dmKPmnIm?=
 =?us-ascii?Q?5N0wNPyhp9Y9nDpaxwAv11n8/eDvuIL8bTMtANytZzrrHTONVmmRkDsiV2Q/?=
 =?us-ascii?Q?PTXX3Gj/Ns9b6bGgbmtmDAf5M+Rs+Fb9dzVodWJ73BOyKvEsRt1uQQ0hvSIm?=
 =?us-ascii?Q?ZQ0F1VlYvEPGD/oDCHLTrVV2Szoc15s5G8uTOH9zPUHebWEsXwxB8nU6NSbe?=
 =?us-ascii?Q?Y6jKGoiyH/JzEPuyvJtmurBeA+q3Xbeur6vP1iZAMHWxuGMGtRIpZazDh5jM?=
 =?us-ascii?Q?woWKKDLHBmd1gWDtomgn0dl5cyfoPiNBeZ77zV0GK/bOhlejFpYykJ8sG+Kh?=
 =?us-ascii?Q?K5EydyJe00mHUZl/bhwL+PWIXX/NjQjBzS4iDo6OPoFA3dxk+PMti/xUsG3o?=
 =?us-ascii?Q?ZVgK9Rxku+72p17+xuGB95/6uEBTAD4w4XWBA5+qsSWgWnkxoOgNxgEI9Usa?=
 =?us-ascii?Q?KPO4+H1KYVsn99r3GFocy2TVDFBbaYS9sZ2hPQII37ovxdWKvlZ6BDNLv9nu?=
 =?us-ascii?Q?kr5E17ohFSWeaKr1bPEaPpgnViQzxX12b1M0NQv2D3xx2CEbNe6U+y6w40I3?=
 =?us-ascii?Q?OykbiAzJjv563Rtepp7dF7/Zjxzb26L9lYCeQFemt9HuB+vot1HdQVtfflOR?=
 =?us-ascii?Q?zqs3jqaJ+Exun66hh1tEMgGoUG2m+cobuI5yDbQ0MZAqCQLmXkqTtphs5wdk?=
 =?us-ascii?Q?T6XRGdFRt4bX/3DXZDS1ImP4WJ01gOWjVpy9hpLgbD8tPqB8HO+cFHh/Hofy?=
 =?us-ascii?Q?RtTis+y+Jahq6URLa5hkvtEf2/1sXvRM9SGVmdYICE+cwJBKXOBq18o/1+ru?=
 =?us-ascii?Q?enSuJzd3tv8Ut84eTs/zF6TMygpdFhUWY6ZHh2Hv8+tkgSaAkIB/dMnZWxSd?=
 =?us-ascii?Q?GJ16H+gmj47lJslXiOfV+1N6I/tsevlxSUIZVMHpVYQSU9QG7S7zn7TvqNOS?=
 =?us-ascii?Q?tU7NWwfRw8oniJN2F7WKAHlnsSo0wx5y/YmeDbKWXZVp1qzzdR/GJCZCHeVs?=
 =?us-ascii?Q?pAqYlpn9IRL/POA0LtSZr4wC4NCQnynvlThs0B8gSsNt5XsvOLH1ks1lFDjZ?=
 =?us-ascii?Q?Pu7UYMoBxytKF9hBRNwCL3G7jNZsM6rjaHTZwM8UMbiWDoldUaaITa+hQWQR?=
 =?us-ascii?Q?ZVvkU26t4QTpW+MuBGHEzlsWG0z4iubzuaPg5jwGGoy1uBgHpVhXEq5gPB/1?=
 =?us-ascii?Q?r/YPx/0RtRxISQtYouuxof5v4yo0kT8lRmlQN0ppQyELw3nKwmHw8cjgwyBA?=
 =?us-ascii?Q?xz+ZwzWR1o5S28JUH02qVn79+J9sJKpGQamarEkxrv80srVVo2iyNt7cRl+h?=
 =?us-ascii?Q?1TVPiQ8pTbc4QdVaI7d+yh7E57HDAQ7KcgbRfQ+VJydWpt136VCSLNADFf+6?=
 =?us-ascii?Q?uHlpG+FTIxyYHe/XJe07Csw8RLKSIK1MfO5QOf4Esyzc07dZdNMlNvURhPmh?=
 =?us-ascii?Q?tw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Qou9m0mSnRQ/vcPT4V56v42pMtGpw5OPdRh+xp1kWHBCMyttKsu1l546VQQl+L850UsSAZ6jIHY4SQs7+YmeKmn7bIa2RXVejKujxq/+38z3bLG8/I15vBKcvEMJHDFAiMIXhE3oifdlvrP/UO7ONw96QQCe3Y5fCYmuxl1HoiAGD1fI38xhrTYOyf8t+ujwWVzJhBm4l0reVaJ+eBEf2HeMePbmI0G75SAhCNTAPx4L7v0/FbXhAju0blq0Hj1mZcV+SU5uRZsud8pgMRfDdvkfAc7BiQ+5w8y3T/3tIfI5kdKIhrBDLHyHR67Kkiih7RvD/rGPgYTBEwrSQnzN8XAqA3zq/cHnNUjX74FSWDhE83HdCuHX7Bokr2lQmbNBr/08GIlC5yELZm4g0sZ+e3TpXQ7KZ8ofXhGSXhx2V+HYHyGLdlZp2c29ZpvBGqYrG+YcJcgiqScMPRQQAZqgWcPpKMW+JuymP8l+jV1vzBOKg4faEePr7/0SOxljil8uztks+8QkvVBkoZghRiSJFgQ3prbR5g8u4Hcc7srlx2jGeC8lVTCxjJXhx5GlWgchgMhm0Uv6GwctT9bbrjLO+Um9j2KG525tyxEoYdByrlpW7FItF+18UGOQMeJp5HLKoYa1EkyQYNKk2JBzaaTpBt+aa/GMd84vD4uQ4nkKNVyrD3XVtXNrUgok2e9eEV3Y/pI6Ma5Gsf+6b0WzhpINJx/HE2Y8yD4Ml/PTYsIpg6o8AUMCxBzfltZOXDfDIsN7QGPXB36QJrtSyuYy5b9Zyw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f14e2fa9-a5b1-4d75-6de8-08dbdf6074c5
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 07:09:17.4757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xi1cuuxS9Azm9C6TM9IHgBOXqgbmPQau9BlBuBIqaYT1IhYWiJTfILZV2u3sa/9CataYnJiXdguoSA7XwrzeUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4616
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_15,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311070058
X-Proofpoint-GUID: IrPfgt-xz9y63P1nOEpQ7aKWZcUki3RK
X-Proofpoint-ORIG-GUID: IrPfgt-xz9y63P1nOEpQ7aKWZcUki3RK
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds functionality to restore metadump stored in v2 format.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 240 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 228 insertions(+), 12 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 0fdbfce7..105a2f9e 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -9,15 +9,17 @@
 #include <libfrog/platform.h>
 
 union mdrestore_headers {
-	__be32			magic;
-	struct xfs_metablock	v1;
+	__be32				magic;
+	struct xfs_metablock		v1;
+	struct xfs_metadump_header	v2;
 };
 
 struct mdrestore_ops {
 	void (*read_header)(union mdrestore_headers *header, FILE *md_fp);
 	void (*show_info)(union mdrestore_headers *header, const char *md_file);
 	void (*restore)(union mdrestore_headers *header, FILE *md_fp,
-			int ddev_fd, bool is_target_file);
+			int ddev_fd, bool is_data_target_file, int logdev_fd,
+			bool is_log_target_file);
 };
 
 static struct mdrestore {
@@ -25,6 +27,7 @@ static struct mdrestore {
 	bool			show_progress;
 	bool			show_info;
 	bool			progress_since_warning;
+	bool			external_log;
 } mdrestore;
 
 static void
@@ -144,7 +147,9 @@ restore_v1(
 	union mdrestore_headers *h,
 	FILE			*md_fp,
 	int			ddev_fd,
-	bool			is_target_file)
+	bool			is_data_target_file,
+	int			logdev_fd,
+	bool			is_log_target_file)
 {
 	struct xfs_metablock	*metablock;	/* header + index + blocks */
 	__be64			*block_index;
@@ -197,7 +202,7 @@ restore_v1(
 
 	((struct xfs_dsb*)block_buffer)->sb_inprogress = 1;
 
-	verify_device_size(ddev_fd, is_target_file, sb.sb_dblocks,
+	verify_device_size(ddev_fd, is_data_target_file, sb.sb_dblocks,
 			sb.sb_blocksize);
 
 	bytes_read = 0;
@@ -258,6 +263,199 @@ static struct mdrestore_ops mdrestore_ops_v1 = {
 	.restore	= restore_v1,
 };
 
+static void
+read_header_v2(
+	union mdrestore_headers		*h,
+	FILE				*md_fp)
+{
+	bool				want_external_log;
+
+	if (fread((uint8_t *)&(h->v2) + sizeof(h->v2.xmh_magic),
+			sizeof(h->v2) - sizeof(h->v2.xmh_magic), 1, md_fp) != 1)
+		fatal("error reading from metadump file\n");
+
+	if (h->v2.xmh_incompat_flags != 0)
+		fatal("Metadump header has unknown incompat flags set");
+
+	if (h->v2.xmh_reserved != 0)
+		fatal("Metadump header's reserved field has a non-zero value");
+
+	want_external_log = !!(be32_to_cpu(h->v2.xmh_incompat_flags) &
+			XFS_MD2_COMPAT_EXTERNALLOG);
+
+	if (want_external_log && !mdrestore.external_log)
+		fatal("External Log device is required\n");
+}
+
+static void
+show_info_v2(
+	union mdrestore_headers	*h,
+	const char		*md_file)
+{
+	uint32_t		compat_flags;
+
+	compat_flags = be32_to_cpu(h->v2.xmh_compat_flags);
+
+	printf("%s: %sobfuscated, %s log, external log contents are %sdumped, %s metadata blocks,\n",
+		md_file,
+		compat_flags & XFS_MD2_COMPAT_OBFUSCATED ? "":"not ",
+		compat_flags & XFS_MD2_COMPAT_DIRTYLOG ? "dirty":"clean",
+		compat_flags & XFS_MD2_COMPAT_EXTERNALLOG ? "":"not ",
+		compat_flags & XFS_MD2_COMPAT_FULLBLOCKS ? "full":"zeroed");
+}
+
+#define MDR_IO_BUF_SIZE (8 * 1024 * 1024)
+
+static void
+restore_meta_extent(
+	FILE		*md_fp,
+	int		dev_fd,
+	char		*device,
+	void		*buf,
+	uint64_t	offset,
+	int		len)
+{
+	int		io_size;
+
+	io_size = min(len, MDR_IO_BUF_SIZE);
+
+	do {
+		if (fread(buf, io_size, 1, md_fp) != 1)
+			fatal("error reading from metadump file\n");
+		if (pwrite(dev_fd, buf, io_size, offset) < 0)
+			fatal("error writing to %s device at offset %llu: %s\n",
+				device, offset, strerror(errno));
+		len -= io_size;
+		offset += io_size;
+
+		io_size = min(len, io_size);
+	} while (len);
+}
+
+static void
+restore_v2(
+	union mdrestore_headers	*h,
+	FILE			*md_fp,
+	int			ddev_fd,
+	bool			is_data_target_file,
+	int			logdev_fd,
+	bool			is_log_target_file)
+{
+	struct xfs_sb		sb;
+	struct xfs_meta_extent	xme;
+	char			*block_buffer;
+	int64_t			bytes_read;
+	uint64_t		offset;
+	int			len;
+
+	block_buffer = malloc(MDR_IO_BUF_SIZE);
+	if (block_buffer == NULL)
+		fatal("Unable to allocate input buffer memory\n");
+
+	if (fread(&xme, sizeof(xme), 1, md_fp) != 1)
+		fatal("error reading from metadump file\n");
+
+	if (xme.xme_addr != 0 || xme.xme_len == 1 ||
+	    (be64_to_cpu(xme.xme_addr) & XME_ADDR_DEVICE_MASK) !=
+			XME_ADDR_DATA_DEVICE)
+		fatal("Invalid superblock disk address/length\n");
+
+	len = BBTOB(be32_to_cpu(xme.xme_len));
+
+	if (fread(block_buffer, len, 1, md_fp) != 1)
+		fatal("error reading from metadump file\n");
+
+	libxfs_sb_from_disk(&sb, (struct xfs_dsb *)block_buffer);
+
+	if (sb.sb_magicnum != XFS_SB_MAGIC)
+		fatal("bad magic number for primary superblock\n");
+
+	((struct xfs_dsb *)block_buffer)->sb_inprogress = 1;
+
+	verify_device_size(ddev_fd, is_data_target_file, sb.sb_dblocks,
+			sb.sb_blocksize);
+
+	if (sb.sb_logstart == 0) {
+		ASSERT(mdrestore.external_log == true);
+		verify_device_size(logdev_fd, is_log_target_file, sb.sb_logblocks,
+				sb.sb_blocksize);
+	}
+
+	if (pwrite(ddev_fd, block_buffer, len, 0) < 0)
+		fatal("error writing primary superblock: %s\n",
+			strerror(errno));
+
+	bytes_read = len;
+
+	do {
+		char *device;
+		int fd;
+
+		if (fread(&xme, sizeof(xme), 1, md_fp) != 1) {
+			if (feof(md_fp))
+				break;
+			fatal("error reading from metadump file\n");
+		}
+
+		offset = BBTOB(be64_to_cpu(xme.xme_addr) & XME_ADDR_DADDR_MASK);
+		switch (be64_to_cpu(xme.xme_addr) & XME_ADDR_DEVICE_MASK) {
+		case XME_ADDR_DATA_DEVICE:
+			device = "data";
+			fd = ddev_fd;
+			break;
+		case XME_ADDR_LOG_DEVICE:
+			device = "log";
+			fd = logdev_fd;
+			break;
+		default:
+			fatal("Invalid device found in metadump\n");
+			break;
+		}
+
+		len = BBTOB(be32_to_cpu(xme.xme_len));
+
+		restore_meta_extent(md_fp, fd, device, block_buffer, offset,
+				len);
+
+		bytes_read += len;
+
+		if (mdrestore.show_progress) {
+			static int64_t mb_read;
+			int64_t mb_now = bytes_read >> 20;
+
+			if (mb_now != mb_read) {
+				print_progress("%lld MB read", mb_now);
+				mb_read = mb_now;
+			}
+		}
+	} while (1);
+
+	if (mdrestore.progress_since_warning)
+		putchar('\n');
+
+	memset(block_buffer, 0, sb.sb_sectsize);
+	sb.sb_inprogress = 0;
+	libxfs_sb_to_disk((struct xfs_dsb *)block_buffer, &sb);
+	if (xfs_sb_version_hascrc(&sb)) {
+		xfs_update_cksum(block_buffer, sb.sb_sectsize,
+				offsetof(struct xfs_sb, sb_crc));
+	}
+
+	if (pwrite(ddev_fd, block_buffer, sb.sb_sectsize, 0) < 0)
+		fatal("error writing primary superblock: %s\n",
+			strerror(errno));
+
+	free(block_buffer);
+
+	return;
+}
+
+static struct mdrestore_ops mdrestore_ops_v2 = {
+	.read_header	= read_header_v2,
+	.show_info	= show_info_v2,
+	.restore	= restore_v2,
+};
+
 static void
 usage(void)
 {
@@ -270,15 +468,19 @@ main(
 	int			argc,
 	char			**argv)
 {
-	union mdrestore_headers headers;
+	union mdrestore_headers	headers;
 	FILE			*src_f;
-	int			dst_fd;
+	char			*logdev = NULL;
+	int			data_dev_fd;
+	int			log_dev_fd;
 	int			c;
-	bool			is_target_file;
+	bool			is_data_dev_file;
+	bool			is_log_dev_file;
 
 	mdrestore.show_progress = false;
 	mdrestore.show_info = false;
 	mdrestore.progress_since_warning = false;
+	mdrestore.external_log = false;
 
 	progname = basename(argv[0]);
 
@@ -328,6 +530,11 @@ main(
 	case XFS_MD_MAGIC_V1:
 		mdrestore.mdrops = &mdrestore_ops_v1;
 		break;
+
+	case XFS_MD_MAGIC_V2:
+		mdrestore.mdrops = &mdrestore_ops_v2;
+		break;
+
 	default:
 		fatal("specified file is not a metadata dump\n");
 		break;
@@ -344,12 +551,21 @@ main(
 
 	optind++;
 
-	/* check and open target */
-	dst_fd = open_device(argv[optind], &is_target_file);
+	/* check and open data device */
+	data_dev_fd = open_device(argv[optind], &is_data_dev_file);
+
+	log_dev_fd = -1;
+	if (mdrestore.external_log)
+		/* check and open log device */
+		log_dev_fd = open_device(logdev, &is_log_dev_file);
+
+	mdrestore.mdrops->restore(&headers, src_f, data_dev_fd,
+			is_data_dev_file, log_dev_fd, is_log_dev_file);
 
-	mdrestore.mdrops->restore(&headers, src_f, dst_fd, is_target_file);
+	close(data_dev_fd);
+	if (mdrestore.external_log)
+		close(log_dev_fd);
 
-	close(dst_fd);
 	if (src_f != stdin)
 		fclose(src_f);
 
-- 
2.39.1

