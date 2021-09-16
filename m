Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7839CC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:07:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 626EA61185
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:07:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236237AbhIPKIr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 06:08:47 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:23394 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236175AbhIPKIr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 06:08:47 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18G908dS028356;
        Thu, 16 Sep 2021 10:07:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=rN8yHKrMQX0khLI9Poh/yJpsbdyb0sg88J40atXukcY=;
 b=StSg8bO2j45eWLILmKUnSbmkVVUSOx/iOKEqOuf9rli7KoZoKUBXMHiiNtbggUGGm2pu
 dnw8by72zzzS99K6/Ii6c0FLJZf+pJJO1G/paSJbwHJA3XjKoX7MaOBUh4NKTisCf5vY
 diT8pZC2vewSK6XATus+Xa8IiQClH46vup6llb0Lq3aJoWFn3nWxGkkRzwLrRHwLKDyz
 2dYE/X5yNrUIMyR4fw9DX8d+Dwbzd/7KFIdeq3AX7n7I59K5jfSOcNhQ3uJF+bwULSu4
 S/++Ph+cc6/d4pcrkmgUEmwSVeWSgemzppBzNgol8QW+Ac3HcSIgTBNAQDxNPyEaJo7b nA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=rN8yHKrMQX0khLI9Poh/yJpsbdyb0sg88J40atXukcY=;
 b=hwhVS6/I5ub4gdx6BancnFKdBKOvOVG0fYsayRgFkWnVpDzxZ4Xy0jtIdUk/CbcDfiFl
 iz4h41LlgryXJ0XwrqCQNOzrLAZlwdiY+trZSsneCS+Q+rqi6TomqtsadpEJHbcLoF6y
 MqecRBAhIGEiC7QaLNFOjm7RbCQJmICP0Tmven4ibkm1lQriXVRSz8wCECve3egFcIuL
 pkDS1TbD50kdc/YykCpL8B6pZV4AdHD8FPGtLLy49kNxMDXVCQJ+wN4WwSzjyFXatL/a
 eiHIDRduVncGrQCUT3WmWavH+aWJnIpOuSqOh6klqJo9jr9AUxrPGAkmc1mDnSihn30q vw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3t92hd35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:07:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18GA5G18030712;
        Thu, 16 Sep 2021 10:07:24 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by userp3030.oracle.com with ESMTP id 3b0hjxybnf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:07:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hHFs7FZXNyXlsctw/rCfapbASOq3nCfux4EXziQNph9mnKbWvZ8TSpG0qlBVft8w5Vcg6AKPrvBgQKpaDL/RwvD0ubuLo70ZBYKEJ2S8KFNC5V4g1is/GsjevH31pm9ICez7iPigzV2r6IYKV1xknRnfoSyd7WGTLWiE1/aVpcXuto3ZPiaRof5lRLi+AlUaLu4fDVkzwWvjI7zd1hScppZwFxkMuEitZdc5Jx1iQTFsjHY7EG0oXSLmu97lQpygtTqIRcUT5J7J7G0RthT1wq8BPvHMV7B5jHEPdGhxw/oYsDE9LAqx1NVaS9uGUafSD1VCmwlIMq07cAwkqZVcEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=rN8yHKrMQX0khLI9Poh/yJpsbdyb0sg88J40atXukcY=;
 b=b7hcTHgnEZBjYSmJmYd3hjxzXS4pue3AFYs99kSImEd2c4WyBqDlp4Oca3EHVArKNYdijKBkS8WV+lhYKoBF4YBI/TEVZWhm5Ylf8oXRguK+JT1BCRxi9mgleaBuCf5AHYG3q3WSI5xK5tPC7TsgVlottXuQIa3rezCb41c8MqGZacdhNQZKOBB/jeRXzBqBDja2UukIv1YFaIEzC9L/vvbvVfIINFx2Tr9pMq0RSLfb1Efsfg25ntOO492P5xrd/kOEiMMrNdq56x7VbToo2LI+vfPl7zVOkD6MYFXwMZMC8ZOo9ShrmNoqaE/URL5KVUqiK6mpTzfDtAvP5MHxhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rN8yHKrMQX0khLI9Poh/yJpsbdyb0sg88J40atXukcY=;
 b=FmcBrM3yqrg/ecplQUkkA8WOOBrex/ivHW5MLDkKFk9Rxp6U56pCVzHiMnFFw0W/sWN3YlNI6LezWnRUYjq5zFBOJUWDe5EasoA1VI/jeSws5C4OUjHFocp5tf0/WCbS8FuicGoPG3NZ7be49pbornDFuinHZWz6WO2jrwlzH48=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2878.namprd10.prod.outlook.com (2603:10b6:805:d6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Thu, 16 Sep
 2021 10:07:22 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 10:07:22 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org
Subject: [PATCH V3 04/12] xfs: Use xfs_extnum_t instead of basic data types
Date:   Thu, 16 Sep 2021 15:36:39 +0530
Message-Id: <20210916100647.176018-5-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210916100647.176018-1-chandan.babu@oracle.com>
References: <20210916100647.176018-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0025.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:d::11) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.171.167.196) by MAXPR0101CA0025.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:d::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 10:07:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 330ead13-f75c-4fd7-ea24-08d978f9c66a
X-MS-TrafficTypeDiagnostic: SN6PR10MB2878:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR10MB2878928E081FCA1C834E3EA7F6DC9@SN6PR10MB2878.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:65;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rzMHwXYZwWRgaI2EhXqM+cDivn6TCyQoUzktzXamO0dj6BeMANGIy5JyMh7sMwLRmogj30Z2Q3Q9KXpCqFwKbUVD7AFLm+VkfZaudwk8ppRX0srSdPlsxiiuha12DXZiATfXWBddHENEzdHdEINKIc4MyHjKigmivYm3Z/xtVSBPL1y9KNTUPYQG/z8HoV/waToRd5WqgcMsiQ8JfTreSlaLAAej3LFjvh4mRcxOFgheuoANW8D4TTXK4uCBGksyAr8Mb6Ib+JGkc13U4RLf7HdKOE+M+Brri37zeCb7wyrP8cCCGlPO2qfH4addrAtk4tZFLGR1/VBxIa9v62vfDsmzdXeqOVZStV+STpUZHrt5z+OfdLSqo6X+kfRTTHkJCWDRUFFtRKY+Dasp+GchiW5OlwgwLl2uRPXWEsiA7uLVNvQSt7t4xCkekvKmoTZbpYXPIC93KYjrd8Qf0gXJ2rb941kZZVbJn2K4PuOUmYw2Oxkyu1X2EiNNZiSshUfQ1NN1xAA1TS/JMJOpu1d6MvaeQ0jvAq6vj795OsQiDHIFRZzmu3atmaMk1sH7ceoXqRT8Qv0Nkoj6dKfGzQ7CfqSGILtOO0GhtplJBN+PYQF7+ZI+Fw1p7ZRiPCeHimtbEj/N/lmEpkD4VeclN4yZVFpRoF3zSXTdkeZv7a5PnYU4Ab5DW4lI0gKoLZQ4YYCoTe0340NiFnSeTFUXDOsvjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(366004)(136003)(346002)(478600001)(5660300002)(186003)(66946007)(86362001)(66476007)(66556008)(38100700002)(2616005)(83380400001)(6512007)(8676002)(956004)(4326008)(26005)(6916009)(52116002)(38350700002)(6666004)(6506007)(1076003)(36756003)(8936002)(6486002)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OvQUYABqz6OwljkAVZeSucKDxA8EIMqsK0BNnVbwq9KIloLfoOKXkMhbZ+pk?=
 =?us-ascii?Q?d23tNZy6sctkJJm9FUOJ4bptvm4z9mzPwJ4ubWuWTPrKMZdcQOSIMZIjuQdk?=
 =?us-ascii?Q?u3s4BJcnfgLPgJrI+V+MA5CFHaXkvsPP2TLGoekUY7XHyeE2C2K37VyD5rKw?=
 =?us-ascii?Q?H93sXjxUKRmssThsTyZGFsxVwffQnZdYrMNW3QH3dGQVnCmcSIzyjKjYTRYH?=
 =?us-ascii?Q?SxWPKtiGGymbIOhoKNlZ0K00cH7Z2icL4nbcqzmZ6/WFLYWH0IxGdr61BIUt?=
 =?us-ascii?Q?AebDPtwVFSYw8XYcxG+f4TMi56fhdNJVjC3VLGTxAj7+eBGgLJ9rbUOXunmv?=
 =?us-ascii?Q?kVRcEm1qasdLZ/fwQmerzMzkdwWEBcjTWs2WQLhlwj8OHlpGUcXQRLblJ2zR?=
 =?us-ascii?Q?GyDnXcdhrOWQoMTd7jGFCzfhrBFuDR4dbn7hkbf0NN2YBTNasnI73vwPUb3K?=
 =?us-ascii?Q?BUhLCV2sZ8Wh0b86u3mBVYRjbrvlTqvzb/dCT7D+9oBBHIV87xtRReL3NbXD?=
 =?us-ascii?Q?cdh45aaFdU+rCq0Rb2+CSlUq1CAEJSd9erCxH/t2y4cFitRg3L4T8FycOuRe?=
 =?us-ascii?Q?cVExKbEkUvE4Zn2S33QGoU1J+dbWcGW4lMjkhNVQ5bIVLTNpOLhNTqAnUmGg?=
 =?us-ascii?Q?zksGZNhcxJnlbcJV5v0Y2XMHBnB7Z4nmx+guYNtC4A54g27DPHSvYu28msQ0?=
 =?us-ascii?Q?c8Lk6zqOYmr6KCtTFPc+n/WYtTFYmHxitsibEpyqJowDEvf8nUAlGH0rfWhG?=
 =?us-ascii?Q?8WS6Vz/Zh8osPJZnl/OBvNrFtTnFBcwiZ1/3igKaf2JQ/xTabbNgMySTLD43?=
 =?us-ascii?Q?V77A+7Hy50gXQ/dI9DQ6/PI2TwkavR1XGEcN5eIfvdYcQyUqdb5IiamTy6d1?=
 =?us-ascii?Q?AmWGSqQ/SkSGl3+PURsIuRN1V4FWtvcDVVG/ZXH0EeZDeuFXIvMynNgruHa7?=
 =?us-ascii?Q?JEz+6PAjg+gJj+VWJWN1Kh4nIileJ8yY+XSMFuqT7eiIb6iLaK5gUCINs5xC?=
 =?us-ascii?Q?xAsg7gbdU/E3gdZjYQyedX5CRSXBr+lQCuhfeX8BjDi3LsG+T6goOKCGsAJ8?=
 =?us-ascii?Q?c+ZqbaeaLcoRhV/kh0udbIZ7PlEglgBwv5DfkA/DBcDCQ93duLReABvzGA+v?=
 =?us-ascii?Q?tR9Uc4O3W4c6N65ebrKgnM9t/JTn4iCgP1fkJ3LSKzLO2dD0yufCRiwj8T57?=
 =?us-ascii?Q?WyqhkGqHuEqGHWlgVPwj+kFyl2bhioW+tep41zsfJqSwvVk/ZQ8tCyR4jPb9?=
 =?us-ascii?Q?EsNKf/r87lV1acIZKHk3NrKb6qDyM9bgLixD2U9CLeoUGXayU3/gqwTTnYF8?=
 =?us-ascii?Q?u32o5e25f+A3y1U6JgzQN3R+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 330ead13-f75c-4fd7-ea24-08d978f9c66a
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 10:07:22.4016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jC6reyZhKZrA2Y4IO7v8UZnUajNCskzKdG6Kq7qvTY+SYlUdv6bxtSsXzPd4ZAwarLvB9u3GJL+BWb2M54oEMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2878
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109160064
X-Proofpoint-ORIG-GUID: kH5FAuT4tEduiKqdwf0TNVV9JhHiUy5C
X-Proofpoint-GUID: kH5FAuT4tEduiKqdwf0TNVV9JhHiUy5C
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_extnum_t is the type to use to declare variables which have values
obtained from xfs_dinode->di_[a]nextents. This commit replaces basic
types (e.g. uint32_t) with xfs_extnum_t for such variables.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 2 +-
 fs/xfs/libxfs/xfs_inode_buf.c  | 2 +-
 fs/xfs/libxfs/xfs_inode_fork.c | 2 +-
 fs/xfs/scrub/inode.c           | 2 +-
 fs/xfs/scrub/inode_repair.c    | 2 +-
 fs/xfs/xfs_trace.h             | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 88d4d17821b6..e5485b5c99a0 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -56,7 +56,7 @@ xfs_bmap_compute_maxlevels(
 {
 	int		level;		/* btree level */
 	uint		maxblocks;	/* max blocks at this level */
-	uint		maxleafents;	/* max leaf entries possible */
+	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
 	int		maxrootrecs;	/* max records in root block */
 	int		minleafrecs;	/* min records in leaf block */
 	int		minnoderecs;	/* min records in node block */
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 51d91ad98b50..ea4469b5114e 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -342,7 +342,7 @@ xfs_dinode_verify_fork(
 	struct xfs_mount	*mp,
 	int			whichfork)
 {
-	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
 	xfs_extnum_t		max_extents;
 
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index bc12d85df6e1..e7bb3ba22912 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -107,7 +107,7 @@ xfs_iformat_extents(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	int			state = xfs_bmap_fork_to_state(whichfork);
-	int			nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		nex = XFS_DFORK_NEXTENTS(dip, whichfork);
 	int			size = nex * sizeof(xfs_bmbt_rec_t);
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_rec	*dp;
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index eac15af7b08c..87925761e174 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -232,7 +232,7 @@ xchk_dinode(
 	size_t			fork_recs;
 	unsigned long long	isize;
 	uint64_t		flags2;
-	uint32_t		nextents;
+	xfs_extnum_t		nextents;
 	prid_t			prid;
 	uint16_t		flags;
 	uint16_t		mode;
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index b58820d22304..bebc1fd33667 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -603,7 +603,7 @@ xrep_dinode_bad_extents_fork(
 	struct xfs_bmbt_rec	*dp;
 	bool			isrt;
 	int			i;
-	int			nex;
+	xfs_extnum_t		nex;
 	int			fork_size;
 
 	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index f1fe5156b3b5..fb1033de7003 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2183,7 +2183,7 @@ DECLARE_EVENT_CLASS(xfs_swap_extent_class,
 		__field(int, which)
 		__field(xfs_ino_t, ino)
 		__field(int, format)
-		__field(int, nex)
+		__field(xfs_extnum_t, nex)
 		__field(int, broot_size)
 		__field(int, fork_off)
 	),
-- 
2.30.2

