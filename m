Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9ED5C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:21:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344394AbiCUFWg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344390AbiCUFWf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:22:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2789A3B554
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:21:11 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22L3Wgxh031204;
        Mon, 21 Mar 2022 05:21:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=XZlajsqeS8uGemYawuxlLLQb7mYigcZ6jBAe3x8YPCk=;
 b=h0TJjLeGYliamvlVCW3cl39ZUiZZeCH7WMvTQe5pV1drKjMM2Iz88zwbiusZLcyf6i+g
 UNxTDns30+5yMhl5RDzo8VSLJnrp8Y8CY0pqzMTAvYrB3iM3/UvPvF68QFqQliqpSPYV
 ICUh8xfqDu+nVqaz+CM/mGmzCvJ3JI/my8WQtkUfJKuhSWKZsckK1LHmXLnc0uWE/0nX
 fkv7y6+b8z3kju1DTs1OssYxMg1ECAtvCld7fILZqty+fgXg87l69X5Gf98MLmL/HQqY
 f7YD5PMrryWGgpBC0a8F0+nAaDQ7Gi6Tx4uGT+drFLqOvBMdYwk0TD3DunBlgOMlErZ7 fQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80] (may be forged))
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5s0j53v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:21:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5L7Vn096758;
        Mon, 21 Mar 2022 05:21:07 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by userp3030.oracle.com with ESMTP id 3ew49r2h3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:21:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=icHrLMBfox4ciTHPMfFudzCgpOu943AXaLsVJMcDbAdPCkuHwqoxlaFqy98pDC5mxUKOryiUOTcAbPts9+Hce41GEjHeP49yYfJlHCBwAJAra3hKbbC0ghFJhmA+aLvPNWtBTQ9LsEpC4ajiFju5f4VjipXmz65pRkQmpuLdfQHkpE2J3dei8u3djDjGlxO6woF2Mk9UPD+ru/jPeAW+UY9OTm5qNKL6wXk6TuG6wWswY0FsEbsOmlozuqrlrZdLicT/MQjKQUFFbU7RNCDqAqywhB3MDxShordasibKzyXGCFOPgRuSgGue0SyO3liHwaR1jJH6feigtT20Elm9Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XZlajsqeS8uGemYawuxlLLQb7mYigcZ6jBAe3x8YPCk=;
 b=JKHIuvWn+qOQJmPzHm9rb0TQTgeiS3hgj2J+S/qsKbM2ZjqS+fK/cE6d2QPlrKnCOiWJ7W7kmxsBAJqHTeM8loLmK7ok5W0qiL2uiYkzi3YxqnOkJJMTNHcckFPyFCUlrvF1G/KoOoZpOxsU7nr9i1vUtxtjcb6u+lIWoP8HG/9h02hgArfx74E639f59LkiK7E0QXp/4ArgjEGDLHxZFJjViv1eBheTvuSCNIJvDUM4/yfBb+2NHAtzSs9gstvy5RdWEeHNZ2Nhb2Hv4IqynQiwL1VKKg1AseJwcRFtIsE2MdbvLPdSzIE25jrSo7bB6e48Y62Ps21hw2JhTpyhSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XZlajsqeS8uGemYawuxlLLQb7mYigcZ6jBAe3x8YPCk=;
 b=S/trRpDUaxSTcr39Aqwd24pGad6wyu8v0pBPwIo3nt3IWEn4sVWj6B7Xh5IuLpuE6lRKVZNUJI/dWTUzKsEVRlRDfIGrKq5J7U7KSYiXF/yq+2f992xBHcUkeSFoSBbQgqBLMLkkvkrX/NOvU+Cd/dxDUXPdbXEMON4u3vdGWac=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5563.namprd10.prod.outlook.com (2603:10b6:510:f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.19; Mon, 21 Mar
 2022 05:21:05 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:21:04 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V7 11/18] xfsprogs: Use uint64_t to count maximum blocks that can be used by BMBT
Date:   Mon, 21 Mar 2022 10:50:20 +0530
Message-Id: <20220321052027.407099-12-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 82c2e804-19bf-4421-6cfc-08da0afa98af
X-MS-TrafficTypeDiagnostic: PH0PR10MB5563:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB55635A8B078064F9F7650B7BF6169@PH0PR10MB5563.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NyIsUFwgu+lsPQwKMHp2HO6AVfKogT+EMn8Mjl7Z+bDEIqyHz6svootfoQn/OPhwWv+MpydQo58UdZ9TDulofh4+bPDtubXWheKvnguPv4MdDakFi4c8Ml55PYBWqvzSs2QPlkSeKp3Ei7HA2eScaMO6vLNB8r3nTEC1FZp0RPvxxsxNbLJBRmSZwLyS44wuJhZEez274H99OR1k5Ps35AiyR/F3FjdSawoY/jy1U7o/4sLtL2af+1Ee0MlXv+i0oe0MLLXLvknuymKg/Mgd4KreVqGSWQgJ1yUnhczNyxq9ut+cPHseT8UpQxX/uKECCk6GLmEBA/1N5SL5CZGh4MoVFLOm3MHgEdO1zJGgdCRczij4btb4FLXv4a11qSHNqIh9FNPIeZmZjqzYM8N2bSxC260a4/5Uh0MlU9rPKUyo358QAzuvVallw+H0y9fLyyPI2Qpv588XRMvjwD/ItijcJE3dVdx5hgpxmFHp0nqVFKwiCyJvyv150/vgI4unPYWujYgk/5z1QPsjd1BtMCIEkfgK0eA4L78rH6uc741PzWFEJa/QH7vOEdf0Jhy6xzUa5HP43+HZUJxNzftuaqbrUwd4k4J+eeNCd5rg2fJ+d+k6lEozME8e+JL1EAADtXajHftlpaPa9c/yRx13QgY6QF7L1OeNkeS0DwFBQRTvt3Z/HsfFwSr4F1uI5cTz9Ktlg2XZoVfJoA1NmG/gBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(6506007)(6512007)(86362001)(52116002)(2906002)(38100700002)(38350700002)(6486002)(6916009)(316002)(5660300002)(8936002)(508600001)(8676002)(4326008)(66946007)(66556008)(66476007)(26005)(2616005)(1076003)(186003)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PH0ORe4vtgRwdsPbstnuN/Y5IWLv2aldoIFjfFGJbRdBlZWmp9aOdXpcTfLq?=
 =?us-ascii?Q?mFm03goNgFGuwphjaXa/7WlG+/1Idbc+uSo7xATLRZCBL352peRRp6Ib93Qt?=
 =?us-ascii?Q?HEkJJEDcCFYedjPIyNYlHm9Qrobwu4P+wShpN3ojT+f+pEI1C3whMbDVCUPu?=
 =?us-ascii?Q?5ITY2tISJtjR44T5QrmUUw19bst4cmo3777h3VPvK6LCt/9idXM41DOB/3St?=
 =?us-ascii?Q?1WwIDxVsgHkaUYvnmp6Hestyiz8P2eRep8NNZPV+TyjxWBWtYFj+ktV92cRu?=
 =?us-ascii?Q?0A1++S076q5IC9D9AeFzuKtgbD9WJZMx35wi0UbpBExLcqZoJ9j/6dg4yKhO?=
 =?us-ascii?Q?QXK4Hn4aZiaasDSKDXBJdEEzc958ds8xfzS3U+UcLTom/Tmow+sEFc6uas+Y?=
 =?us-ascii?Q?nOuSuINg/wukGO/AfNJTC4odCdo0CkTCkWWgYy9b2wzyx0B14C6ViLLKQsx8?=
 =?us-ascii?Q?z2pkgKETOir49j62zs5PatRPmMj0suU626wuubC4dz+NJPmIl/VAQSkwk3xe?=
 =?us-ascii?Q?27Mk+zR3Ih+YX38U16xgGAuDynecfKLCxNWDzVVOPh9+IU/fM5kSyd+AtRjG?=
 =?us-ascii?Q?RGNny+UgjtE1m+iS6lxlgp59YpnYKSTWweNY7zIKMlZ38l+uuS1sf9SPGo72?=
 =?us-ascii?Q?oQAKxqBbJaCdVngoiMd92yq2sq9ctcr7trUnKHPWqo0GKY2JiluG/fSgTJmC?=
 =?us-ascii?Q?zqONNi/y01a6AGNmt2G5YXVRzS6b5IAAZsoIGVr/J4bY+ZEMwhfCXwo2x32R?=
 =?us-ascii?Q?SVB4mHuaSIAJClijFj/QTXLG9828vCx0tGcfTEwy8wr1ktvMsrik8KFbE9vU?=
 =?us-ascii?Q?1EpZXrmc4YANnmQlbQd7+dGZS8nykI5ndVUB6GIPUh5/yIlZGQdFT/8OX9Hk?=
 =?us-ascii?Q?WuY8puAKhyskymwePWQ+k6g9kW/a1nCvAOgAaY3UUzQ1MfhtKZhg2/U2/XtO?=
 =?us-ascii?Q?5wjoUdjEkRTlDcS1+c5vbWs8rNxKAhg4H9pEGWzREFMvq4LORnHbvJCQ9wcy?=
 =?us-ascii?Q?7K7sq+CB0FeeeyCWJTt+e3dnus0SUNo8tpgwHvAoPwaCJJsF2X6GKe7OEcve?=
 =?us-ascii?Q?U5A9jxPuW4QpEfeRzSTb+Rt41/Pcz+LYYpSQlpBwPAmms0rrwhcqck886DqI?=
 =?us-ascii?Q?a0k/MJXd81qBGz8qsQKrcj3nzvRI1+Nt+AIM+0zm0E8bCkcoMdPb6hQn8NrW?=
 =?us-ascii?Q?hEGg20tN2mJME8vHABsys208fq/mOBWa/r3J63uqKjW6nDIGjYYwFLl8HSeq?=
 =?us-ascii?Q?u2wAq85M1lKJneEE1obncfF7TA0B0b7eDfpYVRxr7CvB7aVxZtjpaTsPiTvd?=
 =?us-ascii?Q?CB/Q57n9dQzjtzhBTcuCh2GWnhQ8x06UKCDKCtf3tKluIvFogbZI1DKXx5o5?=
 =?us-ascii?Q?q6wnqCzyaj57hGcY30/0jD/jUBNlKW27V6b2JvPxtCJ+I6CtGfdgYmzNmtZI?=
 =?us-ascii?Q?h1CCaIuz1vEibXwB6knUDKQ1QLjrrig+zeVaVWplZkGDFL/5kI/g3Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82c2e804-19bf-4421-6cfc-08da0afa98af
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:21:04.9206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ragcGfrVZ6gt3rz7MRQHJ6ysW3facgstVbtv3sChGrfG90Dtkv4VCPS9j0fGooKJnYErYKmKi+NLNb1r6LLJwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5563
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203210034
X-Proofpoint-GUID: FipNeQxXe2ZjBkGHBbPV1EC-UEWaFZuh
X-Proofpoint-ORIG-GUID: FipNeQxXe2ZjBkGHBbPV1EC-UEWaFZuh
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libxfs/xfs_bmap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 1e131c4d..88c0ccc4 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -45,9 +45,9 @@ xfs_bmap_compute_maxlevels(
 	xfs_mount_t	*mp,		/* file system mount structure */
 	int		whichfork)	/* data or attr fork */
 {
-	int		level;		/* btree level */
-	uint		maxblocks;	/* max blocks at this level */
+	uint64_t	maxblocks;	/* max blocks at this level */
 	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
+	int		level;		/* btree level */
 	int		maxrootrecs;	/* max records in root block */
 	int		minleafrecs;	/* min records in leaf block */
 	int		minnoderecs;	/* min records in node block */
@@ -81,7 +81,7 @@ xfs_bmap_compute_maxlevels(
 		if (maxblocks <= maxrootrecs)
 			maxblocks = 1;
 		else
-			maxblocks = (maxblocks + minnoderecs - 1) / minnoderecs;
+			maxblocks = howmany_64(maxblocks, minnoderecs);
 	}
 	mp->m_bm_maxlevels[whichfork] = level;
 	ASSERT(mp->m_bm_maxlevels[whichfork] <= xfs_bmbt_maxlevels_ondisk());
-- 
2.30.2

