Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43860C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:22:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244548AbiAUFWF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:22:05 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:26072 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236014AbiAUFVR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:21:17 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L04X3G009028;
        Fri, 21 Jan 2022 05:21:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=TI1Sc0fzjDILVtPCouPy3m+Rcq40f6coGWb3Djkpk2M=;
 b=q9+q8ocbcfPv9Eja5o7OUDOLdw4VTJVdt8LqO1vQs7vb+sMBUkxnVkZcOUBbYRHAx7J7
 xAnttr4R6+dSch72v4VKFyXLFwqavKoqs+3JtjH0bgVEXoWGz+ZrNyypkeic0xJynLnY
 DAeHVBMOzReTH4UK4WR4gnAIhg9nynSYBF1kbveDCj201eo58A30wfEUxROwzTwLw0p+
 eZ88TMdkbSGSVgE4A2DuytQmGQKhpyGHMJtupOcp5eMvLPYP31hyKqg5RZqheof/jB4D
 p24v39QbIA2UeqU9RN2f3Ml20+mtHHRJwg0TNvQE/fLXcFdwhnLcVOtnn1PR6b8SPwzF gg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhykrcqr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:21:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5KAU5170257;
        Fri, 21 Jan 2022 05:21:12 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by userp3020.oracle.com with ESMTP id 3dqj0max09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:21:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iueef3T0iGIC6KTAn12+s2/kHxkF4H/UdT3XH+cBUCC34RsCHatqpQLwOEfmz9QiYYFfSk6j4CFzD9jMh6WOuHPPkQCvq1OvnGfJMFMSh915xb7cfPXWa7IgkWMjCfNwD4Wn50SaX30hBFqMqzzg4jiIrC92Oyu5/NuJkpakKKlRWfacYEr3hNH6OLRQlOXNPusPiR58+hJ4a7BxgXtVPFpErqnhGGjMiZsoTV2CtUF1YYlfjGy4XVPPq2P9VA/wt9HIstYTp1xrU/evy3Gscaj77SzP0sr9VCHPXv6v+Mw4sgMPpL7z5qpvEbFV0J2uOKPLjj69fLtRsMB8MYNyGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TI1Sc0fzjDILVtPCouPy3m+Rcq40f6coGWb3Djkpk2M=;
 b=QJEcWz0t0YhpViJibSte5b6uo4qcgYM4Upt8ggPg7OM3K3mnfojRgw2I3GBylKNL2c1A6Esn6OQgK60yNuz9AAiJ0oyXBHUvpsJvJCxND33TgusgIvXg6rH8m1KW/sjHzSbaZJGkm2lEzozuas1csVlDKbSB7aPTy/SHjG2fJw/+7uf4jK4nzpfhXC4jjiXUeesRKKsMeQqoGadS828UNq1X1b++e/hqGV8ACtjC997vEvTPfdDfC7vMzNazqtQYG8Lwbcrc0bbgrvSbyIG/PSq1f6xvcbNE5OFeODGMwp5od6KRmoJJp+Ax9LAEM47HpUiW7Jj+mKo6ExYXwYkI3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TI1Sc0fzjDILVtPCouPy3m+Rcq40f6coGWb3Djkpk2M=;
 b=Huemf0CWihFuvnT8gi76FMpl4/E96hpf8HpTaiHV2V6dvwRDQVnZk1iS1XCX0/MxPqqAqQpwQQO1vRSsRsYdVpTLnuQ+aW0LqpRDtdhCvzjnQBG7PToTUK9X/1CSIwSoFbGXRJlfvn0GKX/pFz5/z7PTg0cwc9Z6FFWGBqgcKI8=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by BYAPR10MB3685.namprd10.prod.outlook.com (2603:10b6:a03:124::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Fri, 21 Jan
 2022 05:21:10 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:21:10 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V5 14/20] xfsprogs: Conditionally upgrade existing inodes to use 64-bit extent counters
Date:   Fri, 21 Jan 2022 10:50:13 +0530
Message-Id: <20220121052019.224605-15-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220121052019.224605-1-chandan.babu@oracle.com>
References: <20220121052019.224605-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0049.apcprd02.prod.outlook.com
 (2603:1096:4:54::13) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c92531e-3d1e-4398-d992-08d9dc9dd5c7
X-MS-TrafficTypeDiagnostic: BYAPR10MB3685:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB36852F05732D4477735E92E3F65B9@BYAPR10MB3685.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:47;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k/HYAoIk7zt2YtiQ9Yz/rDWn3WiyiK6RS3nTcKLVcyiyk/1IRF8DEH+Zecy1N5m/VXG1It6PnKCzxfnw6Kva3oyo6j/UtS9Mf/fTG/hW9zEae+i9TfMgynzPZarvN7FnRTp9cE7rXaYIMDJSLO3CFQkfUu9oTSIpr/ANfrwMmao+ireJbONRqPhLsmM2KHmdrXDvsi9qY6cmz7IBqX9OJVm/6z+iMZPEubtFqvQNTe8AlDSTPbaC8AjcEtmwRurBsjkaJJgePBzmVQqQBsQZSfcF7ON0aqt6v4l9kcYqOY/IEnKv5px5qw/y0p9XRFQ8GbT5wdc3fsarY1FkInGd6fQg1730b8kVjumBV1p7z2G+w8vfqo3nSi6Dh1pSKh50tD67qGxEziD3qCmFNOANI5OYFWMdQOuMSVzjSh4J44IS6tzCfjOBYJSNurQBiEaKxVbuAxdg1PFHzMTaYWuueg8zdpfDVobCVo8J8os3ew23cnHtkZfKuLUkrk+u30q5pIID7R6m6hJMJInpAj07SJTgN/M4K9GCPGGFTd3OD1KavWsE/uaq2vPGHgghsE8/CDf+aNz3GuCX2N4c8Zj2Fb5k5U18rObRfz4Tc0FHDAkIFQ1HZ4liKE3t8U7O4dhHAWzfbD6xNnkPjlOEpYybaiu55G3hjEOiiP/msgNP1YDTI5bPGmjM92vV9GICASYB+4uPvgmNbj74CWfHAXDb8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(186003)(38100700002)(26005)(38350700002)(6512007)(1076003)(36756003)(6506007)(8936002)(86362001)(4326008)(2906002)(52116002)(83380400001)(508600001)(5660300002)(2616005)(316002)(66556008)(6486002)(4744005)(66476007)(66946007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+gnqv+2gDy8cQ1wiAEGpD0uCS/7muM3odY2yw6y/VWVg0jue/KdFXnUbPqTM?=
 =?us-ascii?Q?uDlfeSHwoBIkxx3kR36j5iNwWYJ6c7rU88DTEFyNHBVJIZn5xMZDSMQd0F1I?=
 =?us-ascii?Q?Tqv2xEqB6LoIdxjcETT77HVPUQWOzjKKAOCCoCEJwi2ijfAITzVpCDK+8xTv?=
 =?us-ascii?Q?HNr/Rx6xXna/rvTeXZD0HAWGPLCZ871pCWFahWn/wqCmDgtPdSbAJP9uanLe?=
 =?us-ascii?Q?45Qy3+gt020+UYoZ8eKhJ+BJ9XI15PxQmEzbyZiYR3y8cfgxfdTczhkxA5rl?=
 =?us-ascii?Q?HdnOmAPFvJHcvg/fNm1Mdo/5hVbEjBHMmz04sPD9MHoXaPpYaM3kCucI2i1g?=
 =?us-ascii?Q?DmoTYv+TdMD51dq81aHzntuEFQRcH0BWDRlPWs9EBIwQlyn/KgELnHNiih0l?=
 =?us-ascii?Q?zKPIRcCUSievmx0uTQsP8dSyAUlTns77GcrBBmuGCPQR1DOAiDoXfCFiW0Ko?=
 =?us-ascii?Q?UfM5V/PkLgC8Cieo3e/b4opNwOLE7kGCQy1H5OlosQD4nPMYQyy6DRagYaEr?=
 =?us-ascii?Q?nEpHk02TR6pqfhcEsI4XIxYx9K/CFAa2IsA5g+wpMagVsDBXGi/c9T6S14ov?=
 =?us-ascii?Q?nhOi/lcB1pOTF2bKGAsCBz6AdKnuNpwOBHRU4tllcAdt2UXueBV4SGq+lD0N?=
 =?us-ascii?Q?aRV5GNSZclXIveue77zPzUvhqXKHhdOLNs27iLJxxA9AqCVuvX67pSJKF7Jf?=
 =?us-ascii?Q?CLaPWp8N0JKhn2Tr5OSC7KOpY9Nq1N57yOLJEZRXG/P/YVihkv04anCeJ/z/?=
 =?us-ascii?Q?QdpU4xA45molCv7VPyqIZVO+5AZ4fid5Du3jJAS9whKOO69kO6JBbm8CCkkS?=
 =?us-ascii?Q?C38q3omEgADwVEBYEIVqRmfXtFNS+MYpQJmHEH5PkoeLfyppUQKwSmQwykew?=
 =?us-ascii?Q?5VaKzd+2QmqAlvNyuoxfg/meSmviBDGLAERun0yy79YT0eehcIC/SJZvjBeW?=
 =?us-ascii?Q?hnEaNiyjHmepw76EQVsPU07Im2K7ADfXM02Jzyslj5Oja1K5pz+72RTX8H6N?=
 =?us-ascii?Q?ILM8EEq22aQoamYs2H6vV59hXJThZ/3PEyrmoIPfzxdGxWE/7R6ZhjGIlV8s?=
 =?us-ascii?Q?CZHmMXn+OaMi3dNHPO8afX/33C2bhkQHQvgpOyq7bB1SSaZxqxLjZGpXwgCK?=
 =?us-ascii?Q?vUG+LukvyB5WUsdWwyRihYYMNLacdEn9/boMqouAm+zQ2WJEE00mdz26SbZG?=
 =?us-ascii?Q?Jm4XOFy8MHmazm4mtGzKvUaZhulE66RH76Vbo0UKosQJ0tI6ZN/5I0tOhTW6?=
 =?us-ascii?Q?XZ03kVxQ68CFMb9R1BJAutjqOTe972PfctO5LhbNN6zvM2CgbgTryPzY5n8+?=
 =?us-ascii?Q?SQWT/k96ktZM73FU+baTuoS+rlj9Q7S2OVZcwNDgsVHL4909HoxV3alGMFIm?=
 =?us-ascii?Q?7a7YjrCkHJYA+vZ0xM34SsiJdZ4BPEWJP5aNqDKwHiU0cMHuJ5QQ0mhnfACj?=
 =?us-ascii?Q?C7S6pD9AdoFfg0FHaz1J/aVRtvlf8YtjXpIlvQVMtRa3eyj+0gmex9X71LzK?=
 =?us-ascii?Q?hiUSvQAAhx+Lj/R5ZXvbOboJ6fc5+h5p6xTio2rTVRemHzp0qn6iKHoEIgId?=
 =?us-ascii?Q?kRynwGoodQSXJ527aHWEjCEh1VXutA9jU5VETjQgQztU5Spo4S+U2GEVEMEc?=
 =?us-ascii?Q?t/LnXrp6MWa1HW6gml6U4ME=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c92531e-3d1e-4398-d992-08d9dc9dd5c7
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:21:10.7067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gjW2f2v9EUir4+eabejLGoqZbjlZ7rVIkEEIca0jgqnECd21HXG1p2sNZUfEz+FvQLvW6J6P4jsKiuwEmpVeVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3685
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201210038
X-Proofpoint-ORIG-GUID: 8UoD1nAgmDNzpi_F0w-lIBN7eN6A7lqj
X-Proofpoint-GUID: 8UoD1nAgmDNzpi_F0w-lIBN7eN6A7lqj
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit upgrades inodes to use 64-bit extent counters when they are read
from disk. Inodes are upgraded only when the filesystem instance has
XFS_SB_FEAT_INCOMPAT_NREXT64 incompat flag set.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libxfs/xfs_inode_buf.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 9db63db9..60feee8b 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -250,6 +250,12 @@ xfs_inode_from_disk(
 	}
 	if (xfs_is_reflink_inode(ip))
 		xfs_ifork_init_cow(ip);
+
+	if ((from->di_version == 3) &&
+	     xfs_has_nrext64(ip->i_mount) &&
+	     !xfs_dinode_has_nrext64(from))
+		ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
+
 	return 0;
 
 out_destroy_data_fork:
-- 
2.30.2

