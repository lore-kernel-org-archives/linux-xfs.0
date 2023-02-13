Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 503B9C636D7
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Feb 2023 04:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjBMEFw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Feb 2023 23:05:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjBMEFs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Feb 2023 23:05:48 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43237EC58
        for <linux-xfs@vger.kernel.org>; Sun, 12 Feb 2023 20:05:47 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D1iH48018546;
        Mon, 13 Feb 2023 04:05:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=918JEHYjzlNg7G/dzhiM5/gAixijvinBQBAyeBjuQE4=;
 b=fvCLMHJvh9I1L0cghQLriE/45THaKzZF7ZQWy0mUeRa99c7THsrf9/tF2VaRN6bpFWN0
 oFhRbwhWJ36UGYT1thUIyTRCQ1otmtYoWBKx6vT6iUT6jk0hHBp9zj3HyIbZMANip5Tv
 cxSx/HL+3r30o3EQpBVdBmobjEoC/jkS/BglD6h4w8aIge/0gLnH5qErfq6OCvHKwiqT
 fiLvshfjEkJPUA6zlQk7J0xHAJMI/q/DmjirlIlQN4leXBy8cdz2DnjWKsZecF6o/uqL
 059jp9cV+TL1FlqkGKlvQJLC4oFQOHlPsN81TKwdh9IEhlng8EQPsjS2P6rVImysi2Ql oQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np2w9sv3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:05:44 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31D3BIXN028987;
        Mon, 13 Feb 2023 04:05:42 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f3jxdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:05:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MbgUKWoK6HQul+x2Jh6g7l48ooZlDESUpD/XVFcJt+3eV+Kgw/aZzaYUNHcJvCODFiuUwLbeMIln0R7yNFVdBqmQVxlKZ1y/Go58HNPmhR/c2nWL/jlDp+0tIDPT40v1E013YKSWz1OEPs7X2JO8GqekxWVlL1n5sQJRA+I62CFkMVDbG7nOhyajsI4rDF949nPR9+L1aGgk3dM9XscFFEFO/0hYRFmY681spDv8q8JmynLdP6ltr9vi2GX9iy7t8KQQvdhSZCPjybZgSCLZxrQwxnnxLGcS6ZXBg9WXL9utDUoY/BgGl+RH6J0RT9z0j0H4Ge6CxEMjaiBAROSHYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=918JEHYjzlNg7G/dzhiM5/gAixijvinBQBAyeBjuQE4=;
 b=LAM5MlY8VKPQVYEjECEbGJV1b1kbQ5qwH1zPWus0zv1Gj+fKJDWWhdBjH8KpQ6v4KzMYj0iuc8MlCJeheFk9Axo+4czE2OesahzNcQKwDiMfJTbTWdeVXTpcy/gYDl/N1ZVTZrZPwi7IEKV/XZWXfpdWg7+Y64SBXdg5is7D42Xqa2Tq2a387QPIsv2xShXpKNfHAgqAPrzWIY1df9ggKKRV7ynpn5JseUos7rxyjVvgq/Pu0vlBudC4/S6LNestA/gYZCDS9O3X2io2oh6JtPAQ1PX2dnA8ZEfd4mjI4JmR50bkrT8N2JQu7iiONHCDpAU1QTB4xlQ//Tm+K1LWxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=918JEHYjzlNg7G/dzhiM5/gAixijvinBQBAyeBjuQE4=;
 b=E9crCUnRufo5/X4BYq3iKpSCgpni25nmNtqgBeQ19utKfjMEKhiq/BENLwzEU5sP2mcExGlOaNYETLvEI/RLv6pHGh1k6oGFdT2WEWwP6QgM90yQGc9bg+azF2Z7gg9k3dVV8E8UiBaRvTRVZxRgpTCQ1T5WIYuUB6D0cTDXQoM=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH0PR10MB5225.namprd10.prod.outlook.com (2603:10b6:610:c5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10; Mon, 13 Feb
 2023 04:05:40 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.009; Mon, 13 Feb 2023
 04:05:40 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 06/25] xfs: merge the ->diff_items defer op into ->create_intent
Date:   Mon, 13 Feb 2023 09:34:26 +0530
Message-Id: <20230213040445.192946-7-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230213040445.192946-1-chandan.babu@oracle.com>
References: <20230213040445.192946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG3P274CA0012.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::24)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH0PR10MB5225:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d1b0e44-8fb5-4f9d-0e5e-08db0d7791f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Hlls/R8oUmKTJWLOwzW9Vf1X4cTuKblAYWlv5FBHZgFYato7UMKfzRmW+4w+AzRV1TGbpeGJ80oTJk/bsAZHckfPo/KiJAdimOetCv+dXMyfweBvKWmNUTdXqcslB9cuNsYbLB4cfINJVNt00iuNrYwo8JtfmWVTjSMG2C3GcB5sx8Le6RssHOCrxJRRQ6NB0cPkehQX07uAEW+x0sIpjeXI2VMAusUmGEYY8XE50F9en4r0duvrjnsM4FZ6k3HriME+hNrE7ePkm2w+KTkhRffs9I5Tqd5D5vHGfXZcP1thJa7pboYjVBLO+KJrWMoiCoU3CnZsB4seUowGGdhBD6iqWcDwVOqD1yxh88mw99yeIkgV1MUs9s5A8IHnD/CMob+wuZirtEZYybUvgI/EuECBAMwydmgvNkVTL/IScQV9s4q5bZ/MNnCDBkOOvDweqsZv7ui9Rgwe/8d5qbzi7uA61RH9juTHrHjAk1E8+YUY9RCthElQ2uqWTEXDFSb6Tdb3Mn4YamHOUkbr8owbv8LSAMNJCTB6THF0fzL0Ilf5iUbdX4aPEs500hqwudj6UPZBhE94YzZkbkFpifBykKQmW49jvHtoovyBathLHowrK5h3PL5441towCfSr48N3Ej2oVCo+lmUR6XnE6lxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(376002)(39860400002)(136003)(451199018)(2906002)(8936002)(36756003)(5660300002)(86362001)(2616005)(83380400001)(6916009)(4326008)(316002)(38100700002)(66556008)(66946007)(66476007)(41300700001)(8676002)(6486002)(478600001)(6666004)(6512007)(1076003)(6506007)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?upzLLWI+y+bpfAudDX/kAV6VURLS1PjhmsGahBqFPiuEmgbdvJJ9A0anrHG2?=
 =?us-ascii?Q?gPVETv3hfWqivjGVU2vBOTTNQ8eqFzMjFy9pAoTMSPuq9wzs9EUQIAIpfqgu?=
 =?us-ascii?Q?IvoxJAbhxACzsetHReygFLGmUz/2ZgJCTAVEiVR7y1vaG4szHABRiy/Ap6+K?=
 =?us-ascii?Q?D0g96tHBJOyDlSOGabYgqAjqeEHBoL3EKhntaBblo2ia1Xvx+YzotzJBqdYA?=
 =?us-ascii?Q?bP90yyE89ALFPJvpL/oEnTIr0z5TYlSuqiZ3AjOunO4fxY4tHDgPYSjDeIi2?=
 =?us-ascii?Q?Gxtttw4qG0FTi+nBCxSKhPTGwGLXRxWTf6re5PxvmjU1s9JXocPbjYAOfXA7?=
 =?us-ascii?Q?eH1G0hyCrN7/V4gRWVgfVaEHyK8gp8GOwggfNH+tSNQDSyWdLwRHNYKuIWQu?=
 =?us-ascii?Q?/z/BNFOsV5rSxnfoITcfbQeu/64xnH8uaWQXhoiAFZE/LQLUW1B8iHqa7R84?=
 =?us-ascii?Q?Ymku7qaMMsco75trTucBxNWT2NdtinUvksgGrCaUdRSPpIrg5Y2bnlKZH5KN?=
 =?us-ascii?Q?qmYyPBEJNaarq8TRbrCobavkZN2Z1z/fLxMzX/AmKCjoZbROoqFj8CQo7ujy?=
 =?us-ascii?Q?UqIE71V+f2RQNQ1R7nS4im0VHaDqmi2vmEILWUTuY4Axki5hhx3KNWbbsf4c?=
 =?us-ascii?Q?sPLVHWrMlWAvsMpWwQpOgYWq7cJAPE6Dte1j0sQZbgWxsOr0RN8unc3pl04a?=
 =?us-ascii?Q?r7y63jm5qhb3gAaAyiFpcCnrmO3t0HR19R/4raNeo51audPeFwsgQWEgfBzw?=
 =?us-ascii?Q?K4lv9HgwD/fJuQ+ApdpPjfkLrNWXlQfaRtNmDg36VUIaf5GYpTbCfoQ3a7RT?=
 =?us-ascii?Q?X7WtaZSSFTelfYwC55i0fnITCMjLznk7+/X61BTpYs21MhMydDmTqlhwfHSf?=
 =?us-ascii?Q?IEhE528UfvqM7eIktun0UHIKmkZVc55L7/CjfdonfwzhM95G/tw5e8dKDcsi?=
 =?us-ascii?Q?U5xcm6FeuK4wdgUlvFDzqnW1PjDJ/19qU5PXiFGWUgqbiBlnWAjTUYu5EQRF?=
 =?us-ascii?Q?tCrRUNv1e+4PQPMrmGLLcRuwEXxsJrHFVYZL4yfpJJK1xsQWy3/ZlcNc/1iB?=
 =?us-ascii?Q?vyjY8LXOr4tpKCPyZL2jMfraH3cM0bA3PO7forfJ/zVYQuOFPCE4IO+zRaxi?=
 =?us-ascii?Q?x+c/DZlqeqsDHDU56oak7Gpr55DwuEZtgrpYXTuy0TTHKY0CAgMajUV8MLb4?=
 =?us-ascii?Q?9FZKGmDNDinYNDolPdTWFsMk0WUtT3H5elnVYDhAQ2H8d5lzKJ0s3n3hXM+9?=
 =?us-ascii?Q?WTByv3d/g+xkWt3OSHuE2IbBjMWeTb+Pj3UsSsROqzENcLlGV/7dAHOuR2zI?=
 =?us-ascii?Q?d9qbO3POcqQE1wKaRZz9O036fEE8zMQY0Q14NVE7JKSkYYYs6LU5V6tX9zto?=
 =?us-ascii?Q?BHe50Wf0G2J2w1Imu6tc+jcYkUr2h9m5v3lMxnUXUsJzko1sVQzPzIb8ApTn?=
 =?us-ascii?Q?LDIlWVDhILTUc037jm15pAAG9mJx86isQiJQZQvFS+t+9m6/aOiXQpgzPiiN?=
 =?us-ascii?Q?7cdNCahvkea+noMfoYhjEXD1hBbbWGuSjpuNoMwlyX7pWmDTPAS2a2CTmgds?=
 =?us-ascii?Q?VRPaq+r0k4tERy1wv0Fh34pQyYnS0/w+orkwQtFXuxMHc8x1tGOrnBesoCTS?=
 =?us-ascii?Q?yA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: hhSRloTIuQXlIXRCFf0AOQePS0nEDy9F77N5lFFDAzwbKF21JFbEatpsyzu/DyD82pijTtAi8oxBH5kwBL7air/mXw80eo3hxB3neIJQZ15INTozIuxf4AqQ1DwdvAVulCAkcR7Ay8++WCFdcRljPsMfPvnH31q/4PzfU/xM8PgQLAH7u+tDootjx9tckAQ3HDB/NLJNLmeAKX7j51JpiXQHRabKxjdFGQglDRhIg7epjbLT5b+zQJMP4ElsUjZRhzEBgtYU70PcPCZ6stxfCyI7+LWvVDvivgsrVT+jXLXevFDGuwCScbr64Z0FozNlZ6hdeji/3QAuW6KzxGEiJHuLJkH0XjfsOcIGIBasb0VCQ/PC/yLvstXr/FwEqq+BE5xpBYqbpm7YZMGE6jRXNpbb5sGO7043NhQpn8hpqNAnYPuThPXmIBGg7CmdbjwXNM5xn4sDDupWNXB47cRzzQJ/dATD9Gymuoug0J4BAjYRdu32QwqzD9+fOM8bXC0zLWiheZJ02pIOts9nsnR2SlP9NWU/FPg6U74qetc6/2zc1wnZ1XijNIPieR4gQGYZC8ZaBwcVAToepV6E//w6dEOAJMt8hTbX2ioC93S/sj3DUgQNAZwCxSpfe+3DscT+6WDSvPxV7ShpiZJh8Y7diKftR05w0fZEtsoJ98fAvK9W+h0FsBpzvdh4/ZbNOs3CrNikNCWli1kofb4a8r/RaI3lnoNsMGtBnRprwwntqN2lPB5vf1KiLPHoKIRyj86RYu4zZK9ZqEsPT3OrYrluOWiouT6P4lrN38DTI8PF6mRwR38CHS01JBmRC7P4SVDW
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d1b0e44-8fb5-4f9d-0e5e-08db0d7791f6
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 04:05:40.5086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8/jG31BZtsLJ34DZ5uUa/3go/XM8naz24DgG9FVVT7KLAU+Sa3xs8BJasmDmWqvEMQFn0+hLOUCMr1zAPFDdsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5225
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-12_12,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302130036
X-Proofpoint-GUID: 8a_9UnjY0gHYfPTUmq-RxDa68zBFUb5Q
X-Proofpoint-ORIG-GUID: 8a_9UnjY0gHYfPTUmq-RxDa68zBFUb5Q
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit d367a868e46b025a8ced8e00ef2b3a3c2f3bf732 upstream.

This avoids a per-item indirect call, and also simplifies the interface
a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c  | 5 +----
 fs/xfs/libxfs/xfs_defer.h  | 3 +--
 fs/xfs/xfs_bmap_item.c     | 9 ++++++---
 fs/xfs/xfs_extfree_item.c  | 7 ++++---
 fs/xfs/xfs_refcount_item.c | 6 ++++--
 fs/xfs/xfs_rmap_item.c     | 6 ++++--
 6 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 081380daa4b3..f5a3c5262933 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -186,11 +186,8 @@ xfs_defer_create_intent(
 {
 	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
 
-	if (sort)
-		list_sort(tp->t_mountp, &dfp->dfp_work, ops->diff_items);
-
 	dfp->dfp_intent = ops->create_intent(tp, &dfp->dfp_work,
-			dfp->dfp_count);
+			dfp->dfp_count, sort);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index d6a4577c25b0..660f5c3821d6 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -49,9 +49,8 @@ struct xfs_defer_op_type {
 			void **);
 	void (*finish_cleanup)(struct xfs_trans *, void *, int);
 	void (*cancel_item)(struct list_head *);
-	int (*diff_items)(void *, struct list_head *, struct list_head *);
 	void *(*create_intent)(struct xfs_trans *tp, struct list_head *items,
-			unsigned int count);
+			unsigned int count, bool sort);
 	unsigned int		max_items;
 };
 
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index b6f9aa73f000..f1d1fee01198 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -334,14 +334,18 @@ STATIC void *
 xfs_bmap_update_create_intent(
 	struct xfs_trans		*tp,
 	struct list_head		*items,
-	unsigned int			count)
+	unsigned int			count,
+	bool				sort)
 {
-	struct xfs_bui_log_item		*buip = xfs_bui_init(tp->t_mountp);
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_bui_log_item		*buip = xfs_bui_init(mp);
 	struct xfs_bmap_intent		*bmap;
 
 	ASSERT(count == XFS_BUI_MAX_FAST_EXTENTS);
 
 	xfs_trans_add_item(tp, &buip->bui_item);
+	if (sort)
+		list_sort(mp, items, xfs_bmap_update_diff_items);
 	list_for_each_entry(bmap, items, bi_list)
 		xfs_bmap_update_log_item(tp, buip, bmap);
 	return buip;
@@ -408,7 +412,6 @@ xfs_bmap_update_cancel_item(
 
 const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
 	.max_items	= XFS_BUI_MAX_FAST_EXTENTS,
-	.diff_items	= xfs_bmap_update_diff_items,
 	.create_intent	= xfs_bmap_update_create_intent,
 	.abort_intent	= xfs_bmap_update_abort_intent,
 	.create_done	= xfs_bmap_update_create_done,
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 45bc0a88d942..6667344eda9d 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -441,7 +441,8 @@ STATIC void *
 xfs_extent_free_create_intent(
 	struct xfs_trans		*tp,
 	struct list_head		*items,
-	unsigned int			count)
+	unsigned int			count,
+	bool				sort)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_efi_log_item		*efip = xfs_efi_init(mp, count);
@@ -450,6 +451,8 @@ xfs_extent_free_create_intent(
 	ASSERT(count > 0);
 
 	xfs_trans_add_item(tp, &efip->efi_item);
+	if (sort)
+		list_sort(mp, items, xfs_extent_free_diff_items);
 	list_for_each_entry(free, items, xefi_list)
 		xfs_extent_free_log_item(tp, efip, free);
 	return efip;
@@ -506,7 +509,6 @@ xfs_extent_free_cancel_item(
 
 const struct xfs_defer_op_type xfs_extent_free_defer_type = {
 	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
-	.diff_items	= xfs_extent_free_diff_items,
 	.create_intent	= xfs_extent_free_create_intent,
 	.abort_intent	= xfs_extent_free_abort_intent,
 	.create_done	= xfs_extent_free_create_done,
@@ -571,7 +573,6 @@ xfs_agfl_free_finish_item(
 /* sub-type with special handling for AGFL deferred frees */
 const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
 	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
-	.diff_items	= xfs_extent_free_diff_items,
 	.create_intent	= xfs_extent_free_create_intent,
 	.abort_intent	= xfs_extent_free_abort_intent,
 	.create_done	= xfs_extent_free_create_done,
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 254cbb808035..2941b9379843 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -333,7 +333,8 @@ STATIC void *
 xfs_refcount_update_create_intent(
 	struct xfs_trans		*tp,
 	struct list_head		*items,
-	unsigned int			count)
+	unsigned int			count,
+	bool				sort)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_cui_log_item		*cuip = xfs_cui_init(mp, count);
@@ -342,6 +343,8 @@ xfs_refcount_update_create_intent(
 	ASSERT(count > 0);
 
 	xfs_trans_add_item(tp, &cuip->cui_item);
+	if (sort)
+		list_sort(mp, items, xfs_refcount_update_diff_items);
 	list_for_each_entry(refc, items, ri_list)
 		xfs_refcount_update_log_item(tp, cuip, refc);
 	return cuip;
@@ -422,7 +425,6 @@ xfs_refcount_update_cancel_item(
 
 const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 	.max_items	= XFS_CUI_MAX_FAST_EXTENTS,
-	.diff_items	= xfs_refcount_update_diff_items,
 	.create_intent	= xfs_refcount_update_create_intent,
 	.abort_intent	= xfs_refcount_update_abort_intent,
 	.create_done	= xfs_refcount_update_create_done,
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index adcfbe171d11..2867bb6d17be 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -385,7 +385,8 @@ STATIC void *
 xfs_rmap_update_create_intent(
 	struct xfs_trans		*tp,
 	struct list_head		*items,
-	unsigned int			count)
+	unsigned int			count,
+	bool				sort)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_rui_log_item		*ruip = xfs_rui_init(mp, count);
@@ -394,6 +395,8 @@ xfs_rmap_update_create_intent(
 	ASSERT(count > 0);
 
 	xfs_trans_add_item(tp, &ruip->rui_item);
+	if (sort)
+		list_sort(mp, items, xfs_rmap_update_diff_items);
 	list_for_each_entry(rmap, items, ri_list)
 		xfs_rmap_update_log_item(tp, ruip, rmap);
 	return ruip;
@@ -466,7 +469,6 @@ xfs_rmap_update_cancel_item(
 
 const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
 	.max_items	= XFS_RUI_MAX_FAST_EXTENTS,
-	.diff_items	= xfs_rmap_update_diff_items,
 	.create_intent	= xfs_rmap_update_create_intent,
 	.abort_intent	= xfs_rmap_update_abort_intent,
 	.create_done	= xfs_rmap_update_create_done,
-- 
2.35.1

