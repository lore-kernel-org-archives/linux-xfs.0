Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87AE3C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:09:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F1CD61185
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:09:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236263AbhIPKKr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 06:10:47 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:27626 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236504AbhIPKKq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 06:10:46 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18G9086H028344;
        Thu, 16 Sep 2021 10:09:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=656uHSK4C/7U8ehCqvaPcoXSklRSF2s1EDgijztJR+U=;
 b=Ui2RvNs18JnyWfNcXxkzPBJ+ckCcJqZ1dSjl08JBwbyr4u+15dohFcwK/1/DXZA46V0H
 rXUjV2ZxADe1rMXUzTnNGw3EIttqgVjkizbGal/mj2bvueQrSfF7RJ/RYw6QuGcdmJ0M
 PasBj3E6gM6SiV1o4bXDSWvG47Z/6m4RXueSl8pebPC64CDNz304/yW8Xa8xPJpW8Lbj
 Gg2jegbDwEimfe0f9BRXOvw9ONRIv2oNYrhcwz3KvIzNH+s1rmWjff7g5nvgKLHQQnHw
 9CDcJegxcDjflpSHyR+3udwrcY4z9qwJ8nFBY1bmA6Pg+7D/m3mg9oSnYdfZbVx7dJBG zA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=656uHSK4C/7U8ehCqvaPcoXSklRSF2s1EDgijztJR+U=;
 b=QXJGaeicaR+NyCwFFLKeQ7dyDgb3RmTTz1xVS5P8usYAUUDzpBcwi2+QnkBCWWy+9w35
 ULdMPWZzqDmZ5sYLouukJOOGs6ND0IUgdfHCqjduWcI6rfalpmqgZKGYr8ba0bGI4IQb
 W2vRFekMMwcZ51fmfTLhk75xZKJBd4XrXMRAOGHc0TUe9XgOJ9S8sLl7OKPELHzMT9RC
 dcTAmktZcufM3WuW8MotQYhMfhZaPJjkyxWoj7p1syzDNvIQqUUw3sEM4hjIyFWtLm83
 /Mh/LGmu/+ZeuJqHeGy2rPvQOugZqavRfIa4kkbgjMnnyil7g6PYViedtaastgQzlY5G 2Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3t92hd8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:09:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18GA6dsL160469;
        Thu, 16 Sep 2021 10:09:24 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by aserp3030.oracle.com with ESMTP id 3b0jgfv64w-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:09:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A1STCWOchZxnmcyjg48L0jprTnH0QJADHJYo9f7rUAOetN9a/gbd0wPMAposrNgHlNSSmDzkwbsC0TV+YoP3tSBVImZPOZctd6e8ibE3dnx+MbmyOMbbq6V3o9oZCfDX9meJMIouYGzcytBkRQpbqXnRTyD2y44X1srV68gjmyL6I+B2iTOqwe8bdAVkQriFNq0NXquyoqTUQiRdfA/t8YnpWVA5ATTWxQ5t7AfDhQ869gIW4tpf9K8VfkJW4sgpxXiszbDvc5T6OQTsf0+y4dLOnwwQsCXkduUxO6kmbObvhmxsJvMZ3PnF183iR12d524YlC3KnSt+m3lkZ66Qpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=656uHSK4C/7U8ehCqvaPcoXSklRSF2s1EDgijztJR+U=;
 b=TndUbfkudMqnX9J44KXoSGBL8YnvZa724n/A4zxC3cI2yCwEzbrRtFQPQRxC9MvJoFP0tTnxYOqpG7YFfXvrsQbVKkk8yYDqkMTVGLQW8ZS/Ug7B0HdnIZWM2sSIZPqy3vfJWhDoqScBYH6zMLyUIUwIVdTZ4fCTYb3rMlZlpIyy1hZl0Jts/mzir5m1aHtcHlz/3ze+d/0j8HMdoQNI4l0+fzvQeBhFjVDKHI/4nLpA+IvSMIEXhl7oBFKB3mFv9aK7vEjQ9uLUjQ3BJlsYwo3fA09v7oGr8RbkcS4OS6GhClV/F33WVcyOn3f25htmioXa3StE8L03Q+os4B6kMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=656uHSK4C/7U8ehCqvaPcoXSklRSF2s1EDgijztJR+U=;
 b=GRvotrXqCqZ3b3qi9pe/lj+6vKxXPJco+t1UlxN6nBAXGRia9k6+5z4wJlRzXmS0RrShY2K4yiEWzWoitzRuRYqpiTYTGC8RGsbiCIY2Spden5ZrmMyG9vVwtKYmSGPNC27DIHxJ9f+eJZ2gowl6Bggq7A4kHNQE7horEvM/7z0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4748.namprd10.prod.outlook.com (2603:10b6:806:112::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 16 Sep
 2021 10:09:23 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 10:09:23 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org
Subject: [PATCH V3 15/16] xfsprogs: Add support for upgrading to NREXT64 feature
Date:   Thu, 16 Sep 2021 15:38:21 +0530
Message-Id: <20210916100822.176306-16-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210916100822.176306-1-chandan.babu@oracle.com>
References: <20210916100822.176306-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::28) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.171.167.196) by MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 10:09:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a598260-f22b-4c58-2aaa-08d978fa0e81
X-MS-TrafficTypeDiagnostic: SA2PR10MB4748:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB4748A28C2673776D8D10B48EF6DC9@SA2PR10MB4748.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:628;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rZHu12y3+0aAjYDavWxnp+FAttBgWPxvT/QnZHomthL2suSg/bmD1Y0LHXD1Ldycs/mkSizU0LwQ8XXhcFR3QYlh3KlRh8NwfEGeurzzhfeMrVZQr4T38nxRnJ4+LuXrPimSgkiUrnKtlABCZl0rxNF0iXz2y+8F0tbjsZUPvnGSvYLU09UBbbPZJ/ajYdidYwOGCvNMAjnHAL8a3gkTZSEZq7rDblB7ZoyIStkUaqrNl1mGhwgCsIOjcdCVEB7arH4g03qtZeDzmOCtb0ALC1mCOAHMcmqCPnnNpLHik0ZAgOadUSPb4CD5HufxM49Oj+fzaPbvUpBJwzubOqPMc3Irjr1KudnfrkHzfiZ677hQPQLGJRqSaxraw+V3W3qGyZXkHDh0M7ukj6LiSxKt4y9QRyGWgOrej+JGG10RrAD1JRjYZsKnqa9Wl/rfYHE9yF080mijnxFHt6aJ0BWsGHfxk1P6Zu1p7E/EYlqnGcTsp4Jr3CF8ADt7nHj26UtHx5rJq2Gfdj0VzfCySd/ToJnOm2z897MKOm15wqB8Xh1kygEn7MWJa55HFGuhhOiWf5pOx5jWipifJts4o1hvmU6VPPjI6biOMlz3db05b75u6AA7W0zRwlajxffyZ1KrXay1avtiNW07xSkvU+z39h5Fgibm5eTlFJT7y922mX/0NOKvWI1hCZ+2cBc6MdYt2y6st+comyLS/7V+5hICOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(366004)(136003)(346002)(66476007)(2616005)(66556008)(66946007)(6916009)(2906002)(1076003)(4326008)(956004)(6506007)(83380400001)(316002)(8676002)(36756003)(478600001)(38100700002)(38350700002)(52116002)(6486002)(8936002)(5660300002)(26005)(86362001)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0+S3maN9z9viDAfKov17t4NgnPNRSecsYf7IdY7DX47newTUi3hCgwQ3QiR1?=
 =?us-ascii?Q?k8HdeFY20dwH+TNSsDLHIh+ODLRixiBcSL9jsQsXP/bh6AeQTc6q2uOAu8Nl?=
 =?us-ascii?Q?91pFDZlWh83s0+R7sCaE9VJeT8L8WdU+cyH9HP2FzP2CdKLDcKa40i1nTA2v?=
 =?us-ascii?Q?98V2bffId07gv3nwMErbaC1mVWehBVFMu3FLufKJmFamkdTVgBNjM14NqUrC?=
 =?us-ascii?Q?2HxanopZU9vGwby2uFgf3Ft20i26TTDwm6gDKJtdRumYsYyS3L5WmvwaFKYl?=
 =?us-ascii?Q?VVtEy0CM/dEjDGrelKgCSuVA2DJFsdvK8F/H1aI9OpdqqlUE0l6XX1b5pb18?=
 =?us-ascii?Q?vxvq19qYbTBL2YRbAiqJYmOg1hFUm4wqiiYKJfwf8SdnrA3x3UBvS2FO/7//?=
 =?us-ascii?Q?2pO8a5hrdRMwkt9dsVEjY3L+ty2qJHHuwEfKTczyn6el4NGSJj5AAopxSrFH?=
 =?us-ascii?Q?8CDbXgvdxwqm+dbEFzIRFkXdxNRR6s6bNJ1pYMxFW5VS8SKdw+jjdo6/zQXy?=
 =?us-ascii?Q?e3IaDEHMYFgTzrcKy3mLuKAdlkftu6QACT6GbLTcU8xvCQDB3w9lkQV2TAmj?=
 =?us-ascii?Q?RyfnKqFJH4zun/dEKm7tVi6e7Fu6BZC9QDyhQBGiCZka60ucvwMqBJBXtFtq?=
 =?us-ascii?Q?ORBpMhkzb1eP5bx4L1kiXdKs9zoaR3vtMFKhxVc+jepIoTCyfJiezj6U9ger?=
 =?us-ascii?Q?xjJ814RcolaN5vC+tfd0Sjlo8yQSKbc6FHY8ik+yMB+fnOPEFJJhH/IA9iQZ?=
 =?us-ascii?Q?zvFnYl/Lrnc5dHvMKfMmoZp/RR0LO4LDzLLb9eIHU9+ggGg9iJvuZrlHzJA9?=
 =?us-ascii?Q?eHqy10Isj4ubISTa5ftc6Fsd/cL/Z11YpUQNtA1Rjbb2O+r8ME7ltIXTVu/o?=
 =?us-ascii?Q?qsEX6NFay1QwMw0W4xN3RCnIakeKWEIK4HleiGjqe22dmOK1LYR1ITctl8uK?=
 =?us-ascii?Q?Ed16afKh/G7c7u2RTmQWTezdfrntW1Hw7KpwyMgUkOCXBbJEOkiGZFIq7VqQ?=
 =?us-ascii?Q?WamQkwB5feAYmS/iIJZ1qWhKc9x17Cg2Vx5uFohNuU/4vSPvRXNQESUfWjkx?=
 =?us-ascii?Q?6qHF/DNpwAopI4pWSI6LQjphzbQj5C/tPo2nDlr7dkCaw5lxaQjYhFgHzJf5?=
 =?us-ascii?Q?Mu+fBVJLai9K9U40NRy8l0wnsCuLYNnJutj1RXw7OPWrDsw+HFAXz6+zOjmj?=
 =?us-ascii?Q?7VPhf7GK2eOHNUuvuxr2wYkpnfiPXzuf/uPeV1hZMefK2il+WwQRmInGB3xK?=
 =?us-ascii?Q?yZ7xKzeHrzPfrbvs97CFFs9pgzQDVeRv4EKjiN1SB2MQ1ZrTrxTmx0FJTsxT?=
 =?us-ascii?Q?IhDhDlDIN7IyxcxBFrIr46pc?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a598260-f22b-4c58-2aaa-08d978fa0e81
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 10:09:23.3703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xyEltdtIKpThaSHHy1SixJ+cpO062KDa83cOjLZwVqeHld4Pd3KKgiOMgKDUz82epRztoF+OIwm+sF+Q07Ar4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4748
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109160064
X-Proofpoint-ORIG-GUID: qDNqAv5A8Ou-iAvTO2CUys7Nqs98QhXd
X-Proofpoint-GUID: qDNqAv5A8Ou-iAvTO2CUys7Nqs98QhXd
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 repair/globals.c    |  1 +
 repair/globals.h    |  1 +
 repair/phase2.c     | 34 ++++++++++++++++++++++++++++++++++
 repair/xfs_repair.c | 11 +++++++++++
 4 files changed, 47 insertions(+)

diff --git a/repair/globals.c b/repair/globals.c
index 6e52bac9..ec9d109d 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -54,6 +54,7 @@ bool	add_finobt;		/* add free inode btrees */
 bool	add_reflink;		/* add reference count btrees */
 bool	add_rmapbt;		/* add reverse mapping btrees */
 bool	add_metadir;		/* add metadata directory tree */
+bool	add_nrext64;
 
 /* misc status variables */
 
diff --git a/repair/globals.h b/repair/globals.h
index 6c69413f..12157c52 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -95,6 +95,7 @@ extern bool	add_finobt;		/* add free inode btrees */
 extern bool	add_reflink;		/* add reference count btrees */
 extern bool	add_rmapbt;		/* add reverse mapping btrees */
 extern bool	add_metadir;		/* add metadata directory tree */
+extern bool	add_nrext64;
 
 /* misc status variables */
 
diff --git a/repair/phase2.c b/repair/phase2.c
index cca154d3..d6dd7fcc 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -191,6 +191,7 @@ check_new_v5_geometry(
 	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno;
 	xfs_ino_t		rootino;
+	uint			old_bm_maxlevels[2];
 	int			min_logblocks;
 	int			error;
 
@@ -201,6 +202,12 @@ check_new_v5_geometry(
 	memcpy(&old_sb, &mp->m_sb, sizeof(struct xfs_sb));
 	memcpy(&mp->m_sb, new_sb, sizeof(struct xfs_sb));
 
+	old_bm_maxlevels[0] = mp->m_bm_maxlevels[0];
+	old_bm_maxlevels[1] = mp->m_bm_maxlevels[1];
+
+	xfs_bmap_compute_maxlevels(mp, XFS_DATA_FORK);
+	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
+
 	/* Do we have a big enough log? */
 	min_logblocks = libxfs_log_calc_minimum_size(mp);
 	if (old_sb.sb_logblocks < min_logblocks) {
@@ -288,6 +295,9 @@ check_new_v5_geometry(
 		pag->pagi_init = 0;
 	}
 
+	mp->m_bm_maxlevels[0] = old_bm_maxlevels[0];
+	mp->m_bm_maxlevels[1] = old_bm_maxlevels[1];
+
 	/*
 	 * Put back the old superblock.
 	 */
@@ -429,6 +439,28 @@ set_metadir(
 	return true;
 }
 
+static bool
+set_nrext64(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
+{
+	if (!xfs_has_crc(mp)) {
+		printf(
+	_("Nrext64 only supported on V5 filesystems.\n"));
+		exit(0);
+	}
+
+	if (xfs_has_nrext64(mp)) {
+		printf(_("Filesystem already supports nrext64.\n"));
+		exit(0);
+	}
+
+	printf(_("Adding nrext64 to filesystem.\n"));
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NREXT64;
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+	return true;
+}
+
 /* Perform the user's requested upgrades on filesystem. */
 static void
 upgrade_filesystem(
@@ -453,6 +485,8 @@ upgrade_filesystem(
 		dirty |= set_rmapbt(mp, &new_sb);
 	if (add_metadir)
 		dirty |= set_metadir(mp, &new_sb);
+	if (add_nrext64)
+		dirty |= set_nrext64(mp, &new_sb);
 	if (!dirty)
 		return;
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 95360776..0e6cbd96 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -71,6 +71,7 @@ enum c_opt_nums {
 	CONVERT_REFLINK,
 	CONVERT_RMAPBT,
 	CONVERT_METADIR,
+	CONVERT_NREXT64,
 	C_MAX_OPTS,
 };
 
@@ -82,6 +83,7 @@ static char *c_opts[] = {
 	[CONVERT_REFLINK]	= "reflink",
 	[CONVERT_RMAPBT]	= "rmapbt",
 	[CONVERT_METADIR]	= "metadir",
+	[CONVERT_NREXT64]	= "nrext64",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -368,6 +370,15 @@ process_args(int argc, char **argv)
 		_("-c metadir only supports upgrades\n"));
 					add_metadir = true;
 					break;
+				case CONVERT_NREXT64:
+					if (!val)
+						do_abort(
+		_("-c nrext64 requires a parameter\n"));
+					if (strtol(val, NULL, 0) != 1)
+						do_abort(
+		_("-c nrext64 only supports upgrades\n"));
+					add_nrext64 = true;
+					break;
 				default:
 					unknown('c', val);
 					break;
-- 
2.30.2

