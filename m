Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D6C3C636D4
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 08:02:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjBIICC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 03:02:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjBIICA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 03:02:00 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5571313531
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 00:01:56 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3197PjsK011365
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:01:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=Z/gy7ED2uc3DAI5xAdPVy6QP4ZkCdVt2xfjOsudSWUw=;
 b=xyXRzyNyCHw3+Rnz6xgH+ABGv7O/Y8VwANDwb8tsltLFRheq5fTZa3j3Vzs6ZsJsGBb6
 XJdGyovaU0PZC45N95Kyglm70wOqywZ5cTSanz2BZALZPifquqTTVujP3iU8BD499muz
 T4+rF54UWPZlPI5R7vorC2V1ihGyjUC5E4/VJ2OpBqWycAY6oHbjsXaklSLYYp98ybvH
 aT+6q0wFikPbocGliKw8ZA3gZmgBPhZmE4TpOJRBHtUov763y2XtzoTRlE1lgY0DuZjg
 j1BhopHAQYEw275D3+So9ebYbTt6ZrWDkMM6Z12hs0oJifIOJYnW/HKTdYn5ZEwEs7LB rA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhdy1a75j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:01:55 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3196sthE021402
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:01:55 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdt8dusk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:01:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LjfolOVo1YIZYCU4rRcWQedU6Tfz4RtKTsFdMnRFTfLt1oca7IHENVVm66ZGt8LBCSPUOUg+NdtjPAnjRb9VizwVavYvgkU8SkZWvgooSbQSMircQ8KKw00GSP+hekojzlpL9Vh4PDIoSuxu311bSyQlvjD1GyH2bzowv80k9U71SURNiZNsEbxXcgbceR81C3mjTm5zcpbikJVEEPUjtDbTcxdmCTuXL6XnrXxS5zsrPPBJfiJsP03GMQRGuZGOzm4nbkVsBuhq8yb6oeONasDtO8LTmDY14ZRl7T93vPRwn2Xz9Qcsv1jIysiZ93tCfCk5PQS+ZsycKtkBxESW6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z/gy7ED2uc3DAI5xAdPVy6QP4ZkCdVt2xfjOsudSWUw=;
 b=a+2bNzlAqAzCW5L0b3s95GedaM11DC3SLmt7xuZ4NoGii1kFqjWC5cjpgezQVPE0DvIPruKrrllJinrVmqSKS3E7Vn1oB4ZNiLSUrE4PArCQ6m0tMmLmYSCezDWA1PCXvuG0uIUxlPm2NhBc8/SMs4w9cFHaoy0KyRvrA3tq/Q3x/0oCJA/dJ90E0OPF8KShDvn+OX+JIvsI/tOLjat0Bou2TcU5Vnqmf96xvZJ0f5/Eem98sbfQN14XQags3a59cehfJuK43jFN9FIyHsY1bnIvGP2jMuOET80DsTNJd4pE21SZKCL5i3wPS6+sHVbxVWwxLlP2IM/MNx5JQk3DLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z/gy7ED2uc3DAI5xAdPVy6QP4ZkCdVt2xfjOsudSWUw=;
 b=q5Eg/Y3Ot47LiIpMw353Goq28eWMKea6Et7ZGHUbUumVcgyNExtc2bHXuxh331bZO2SyW3IDkbR6IxZtbALt3eA3imkrcpiQh/wwKgf1qkznLRXkuXVIdsv8uSxJy/5FqIO7JkUyU87f1cifEYmu8HjD8of7su9W/BxnijItXh8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB5787.namprd10.prod.outlook.com (2603:10b6:a03:3dd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Thu, 9 Feb
 2023 08:01:53 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6086.011; Thu, 9 Feb 2023
 08:01:53 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 03/28] xfs: Increase XFS_QM_TRANS_MAXDQS to 5
Date:   Thu,  9 Feb 2023 01:01:21 -0700
Message-Id: <20230209080146.378973-4-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209080146.378973-1-allison.henderson@oracle.com>
References: <20230209080146.378973-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0378.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::23) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SJ0PR10MB5787:EE_
X-MS-Office365-Filtering-Correlation-Id: f2c2aad9-ad29-4134-c0f6-08db0a73e810
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b5luzu0N7kIhpktIylJzGXzA4kx3CSNmPvZ9ZmhhkZBQqt0xCtxcuPYKRV4lk2PMDklGmymjJrc43pIJI12Js8Y8BYD3SG0ZOOP7mSXnGRGYZpDrhDE9RP3QIgTee5YxIiEdkeOlT2aPVPsvkx0h1VAdcP0cMyxFSYt9IyknRmJKgZnTBZw7DOnFYw2nuTF8kJpQrGE+hFnMMMs8i2ww2p70OP/gCbwb8pDb/MfcaBoo+FcTk1B794aAiHdcL+IVUwInKqVPP3SDXXX8ZotedrwpTEV9k59+TaM+J1FTevJG2QuuIBW5sAUseMz+c9h3vFL/JeK5N4GD6U7zuftGC2qGIcpGCeTZ83IGoVDkEGNjGHVk4h+z+wqf4M/CguygJpfz8Y9pMqvdvVbc6u7rWag8fqb1EHk0SZyzER5jGGWlyXqCk8NZyBp4atA/YBILd6P5SzDWbMe064yFe1AXdX5+/K8RkyCXfDgfoUAL7Sc0WnmN6NYLzrb0t4GPsCY1QRCa4BtY6RjKyMuwfObNEdKvTkE/NdmR0X4i79Ilm2Z3qIw3ivnNN21/9zZx25TDyzaWJzymfjVUofLJH+V+SKE9JZ1WhZBGv0Oe2iFJq4mkVm3A5vzbBf7SaUPcjN2Cz2FWjOxVESXuwNZBrG3sYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(366004)(136003)(396003)(346002)(451199018)(478600001)(186003)(6512007)(26005)(6666004)(9686003)(6486002)(316002)(83380400001)(2616005)(1076003)(6506007)(66556008)(66946007)(6916009)(41300700001)(5660300002)(38100700002)(8936002)(66476007)(8676002)(86362001)(2906002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S7LXF9EHL676PdjOrrxqE4L6i5+71f8EC6KAtTnra797jvewh+X6Zinzy/8j?=
 =?us-ascii?Q?URbZkzCTMk3vfnZC9No0G1UAaXWX/xhpE9WPpFEPA5f45wwFupIEiIvNTjqg?=
 =?us-ascii?Q?HA/gSJV+0rPduAheYP8qT8mRycFRM15lpjq6ii3dosA3H9EHnXCPVnr/vFRN?=
 =?us-ascii?Q?NSss9TbfwBfeEZiwGjCEdmHWNL+sbFam1h5Ych6jOxjr9eF1YhnytE0AhB6C?=
 =?us-ascii?Q?mmqBodnREJ50wfyZ14E6QaPeToBW8UShBCWWpC8TtxJBI7XiQ3FsjoN/zc0z?=
 =?us-ascii?Q?VqCNTX2N2OERVJpS05YvvCz9fFijwofliuHvprONEAiXUZ2Cn1Pijz2uebos?=
 =?us-ascii?Q?myHnwqzCTUQexCTLHBAlTtNMXV7oo+V18CYr0X1ynH7jo7XInS85D928RT8q?=
 =?us-ascii?Q?AdpB6ZDfT5br6hNp+32J/tc4tnk3ReHJaH/GXDA4/Huzw1ocSwmv4bMUCg05?=
 =?us-ascii?Q?UcM1niypPgZC3tYH8rju83GWWP51DnimFzl3bSuocaNMzCNBM7l8Cc6lI/ae?=
 =?us-ascii?Q?n5sMrL2I4R6rMj2LYqXNKcdOv1V4W8TWgzb0jPFj1Z8mcNhTD+Pv+FRQz3uV?=
 =?us-ascii?Q?g5UVrZCTbrwm+B33rkXWnmr3Bo0pv81IpaAe/elSIgGcF5ox8B/4btwZHRBP?=
 =?us-ascii?Q?8Fjvpq9Nb/kZ4KaTEC07kJAobWeimRYEYQCkggosfRqwaY943+anQRrxzYKG?=
 =?us-ascii?Q?cO/Rhe6uLfYmDst6MBtzjIp4OY8uAuFwrPI6DwOt1+QYdKaHCo5ENGE+Y6OX?=
 =?us-ascii?Q?+YEvRroJPPMpUAvNTj6a+Pob/P2ZRvcybhVGDg7BWUJ/lwL6tF4S2y4gfsGQ?=
 =?us-ascii?Q?HftsVRXPoCIeYqMmM0tbO3snlpEMOUYy4Di5H39vtibXgFnnZE21YIwVLSRo?=
 =?us-ascii?Q?pOJL/PSvjNvrvEkCXVZAfFcEFElvMSwQsZA/INmnfI0xgrrD4Ehfeh5/Mw01?=
 =?us-ascii?Q?wVQOsJZQtY+lLiCb9Hm2wzbX8rdMG09cO3DGB6l2q5rJ1bb6GN2qIK1YnLdS?=
 =?us-ascii?Q?vn/NjpCKoUJ5etxrYmMFI4NB69cQ9LpvuYAX5ykkDZEboSutoGT2VMZ14UAj?=
 =?us-ascii?Q?lf+32HxbMAWabcj/yz/535nJ0OWFYSj9PRyy+XBJ67GIKpkap0Dbg2VFn5ba?=
 =?us-ascii?Q?wfA17LJ8l/pQvkujmwTlXj+DYsHZUVHLox7ZG3ku9hpf3bnt28wArl7AkN1d?=
 =?us-ascii?Q?mFuXE955pVhc87oixLGMTuFJ5N3Zzae67qG8MoYz3Fmkp9wfEijuni4xq7t7?=
 =?us-ascii?Q?P6m8ZH8tPQkZJJzLAuJRdUENYY9w8oBSvan1AejGZgiZSwKC6iBuPAotcM8w?=
 =?us-ascii?Q?mbfqaWC5F1sh/DAnuPzWevKRtAHb8q6HNZe/WAHzf9SAwP3d6ldxMwOzHOsE?=
 =?us-ascii?Q?IcY9N9UPQf0ZqmAyf3XXfQ/t3/0njMlrMZOzVo3ldw5/UXqbDj+EmFFzexAv?=
 =?us-ascii?Q?R3rzDqxcNcNT/vmNZfYTCw8lT1vFocgUuPg1YO0gpjnm3YKrC0tHhYAYfcLQ?=
 =?us-ascii?Q?nvKGbNSZIEObs8cdNgN1D0cpnL4L2HdlwR3EiQlrflFuR/kBj92b2BU7wQ98?=
 =?us-ascii?Q?aS58TIDUHCKgHiOTMpTL9HOtP4gCeca250paDYTbTUPijNSuiTJ4IT3sbZ4X?=
 =?us-ascii?Q?gg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 7R0BlT5+BSK7fbCBh9UAuB5iXKQwir1E5P9q3sia3T0HTpeDMrdTfP/+JELfMhtCdip/weTLoyyJbWMFaXvWbAkgDYDRW5O/gSy8mvFg68uLkfa8l3bAKLrfXS7YQa7hFHzoAvoox/OT/CmuC4RvoqrAigIC/xKw3VwPTCCXmziOzzRbcapHSMzEbiG4z1JMlfwvGATPiPkxMs3zDVSLSVJlFo1Jv1FO8okSkjEYV/lM81B6R9ss5pLFF0w1A16WM0wF+/L2e4wtNArtnTq9uJ+uui0d2wm+T3TTTiyjOG8Kq+rgrfjPJ7X1cu/PsqmEiQbKwEvd/onlkCghty+iU6HLuq6V/Onkac/WT/8YdeHfMaevznGaybnhV6FbbmEwDdhzeuVqZH3PDW7hHZEpp2zLJYFVjKI3PVYaIazm6HHsE6ThNoKSu5pAwZ+lEKgGidXn3rmC0bhl0N8+HORp+Ka5CaHlB/tQQEPanEjgU5DF5sot5h3vCbk0s2BfhtCXnMk737Tc9tVbmi6gdDMafkxrcDdLuPN/2SbZejZnCt59efafylExmKBqZqKdJRjSl2gqXMRLRLao5VxOItZoIVEBnxeubEeC0+0hdgtf/nDmlLdRBa3hWXAx6StV5pE2k8RT3hjQb0LIDrG8ZlYkIZSDkq9HYhJGN9K+dNVIQSewyWz0yjJpstg5/Tr5Kt02G2iO2ge3rmVpV8jHjQgZHlZtDGorLv1esF04jBZcGuPdSO7+d6TOsUf9tXun21QA
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2c2aad9-ad29-4134-c0f6-08db0a73e810
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 08:01:53.6329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LI+SPJMM/3ycVc8Fy09jbUwvTvD+7Uztz7DWk0me1r0zFo8whsay1XJwQkxIjK5U9VoHRWt1x2SGzfIe6dkoe47gKrECxIjvW0m2ND0mRKA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5787
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_05,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090075
X-Proofpoint-GUID: HsaxICTiXpeGxkY5p_9Lp2cJSvCPVmvj
X-Proofpoint-ORIG-GUID: HsaxICTiXpeGxkY5p_9Lp2cJSvCPVmvj
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

With parent pointers enabled, a rename operation can update up to 5
inodes: src_dp, target_dp, src_ip, target_ip and wip.  This causes
their dquots to a be attached to the transaction chain, so we need
to increase XFS_QM_TRANS_MAXDQS.  This patch also add a helper
function xfs_dqlockn to lock an arbitrary number of dquots.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_dquot.c       | 38 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_dquot.h       |  1 +
 fs/xfs/xfs_qm.h          |  2 +-
 fs/xfs/xfs_trans_dquot.c | 15 ++++++++++-----
 4 files changed, 50 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 8fb90da89787..9f311729c4c8 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1333,6 +1333,44 @@ xfs_dqlock2(
 	}
 }
 
+static int
+xfs_dqtrx_cmp(
+	const void		*a,
+	const void		*b)
+{
+	const struct xfs_dqtrx	*qa = a;
+	const struct xfs_dqtrx	*qb = b;
+
+	if (qa->qt_dquot->q_id > qb->qt_dquot->q_id)
+		return 1;
+	if (qa->qt_dquot->q_id < qb->qt_dquot->q_id)
+		return -1;
+	return 0;
+}
+
+void
+xfs_dqlockn(
+	struct xfs_dqtrx	*q)
+{
+	unsigned int		i;
+
+	/* Sort in order of dquot id, do not allow duplicates */
+	for (i = 0; i < XFS_QM_TRANS_MAXDQS && q[i].qt_dquot != NULL; i++) {
+		unsigned int	j;
+
+		for (j = 0; j < i; j++)
+			ASSERT(q[i].qt_dquot != q[j].qt_dquot);
+	}
+	if (i == 0)
+		return;
+
+	sort(q, i, sizeof(struct xfs_dqtrx), xfs_dqtrx_cmp, NULL);
+
+	mutex_lock(&q[0].qt_dquot->q_qlock);
+	for (i = 1; i < XFS_QM_TRANS_MAXDQS && q[i].qt_dquot != NULL; i++)
+		mutex_lock_nested(&q[i].qt_dquot->q_qlock, XFS_QLOCK_NESTED);
+}
+
 int __init
 xfs_qm_init(void)
 {
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 80c8f851a2f3..dc7d0226242b 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -223,6 +223,7 @@ int		xfs_qm_dqget_uncached(struct xfs_mount *mp,
 void		xfs_qm_dqput(struct xfs_dquot *dqp);
 
 void		xfs_dqlock2(struct xfs_dquot *, struct xfs_dquot *);
+void		xfs_dqlockn(struct xfs_dqtrx *q);
 
 void		xfs_dquot_set_prealloc_limits(struct xfs_dquot *);
 
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 9683f0457d19..c6ec88779356 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -120,7 +120,7 @@ enum {
 	XFS_QM_TRANS_PRJ,
 	XFS_QM_TRANS_DQTYPES
 };
-#define XFS_QM_TRANS_MAXDQS		2
+#define XFS_QM_TRANS_MAXDQS		5
 struct xfs_dquot_acct {
 	struct xfs_dqtrx	dqs[XFS_QM_TRANS_DQTYPES][XFS_QM_TRANS_MAXDQS];
 };
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index aa00cf67ad72..8a48175ea3a7 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -268,24 +268,29 @@ xfs_trans_mod_dquot(
 
 /*
  * Given an array of dqtrx structures, lock all the dquots associated and join
- * them to the transaction, provided they have been modified.  We know that the
- * highest number of dquots of one type - usr, grp and prj - involved in a
- * transaction is 3 so we don't need to make this very generic.
+ * them to the transaction, provided they have been modified.
  */
 STATIC void
 xfs_trans_dqlockedjoin(
 	struct xfs_trans	*tp,
 	struct xfs_dqtrx	*q)
 {
+	unsigned int		i;
 	ASSERT(q[0].qt_dquot != NULL);
 	if (q[1].qt_dquot == NULL) {
 		xfs_dqlock(q[0].qt_dquot);
 		xfs_trans_dqjoin(tp, q[0].qt_dquot);
-	} else {
-		ASSERT(XFS_QM_TRANS_MAXDQS == 2);
+	} else if (q[2].qt_dquot == NULL) {
 		xfs_dqlock2(q[0].qt_dquot, q[1].qt_dquot);
 		xfs_trans_dqjoin(tp, q[0].qt_dquot);
 		xfs_trans_dqjoin(tp, q[1].qt_dquot);
+	} else {
+		xfs_dqlockn(q);
+		for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
+			if (q[i].qt_dquot == NULL)
+				break;
+			xfs_trans_dqjoin(tp, q[i].qt_dquot);
+		}
 	}
 }
 
-- 
2.25.1

