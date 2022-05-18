Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C3D5C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 00:12:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbiERAMq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 May 2022 20:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbiERAMn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 May 2022 20:12:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A245049CBF
        for <linux-xfs@vger.kernel.org>; Tue, 17 May 2022 17:12:42 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKQreo023081
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=zifJD990rwJu33QYI4T4PvvdJtkr+k7+218gcEBuu/c=;
 b=Z5NtdAtdW9JLFEMKeZynXxNxnqmRWh2BOpNYl0Aje5EjNLSHWL+VP0HNEhfkBwmc/3TR
 maL74cSXbk+ZluZ20A+fDfVgPcudfAVB3sD5dW2NycI3aheCF1MQImnWY28Ar1aXjnau
 VYttQEMV3hSfN3mjXfTAvWVR9g2YBAk52d2/l8UITt9Sze9w+pn95jsWwPli+0SUReRR
 ckv6XTq18P/kSpYLOI3NoPArIG74WMIb+Tv7Q/vcS5yAo9Ml5ciPSLaeJmQaJEEYcl6U
 3/aQNf4cEkt4eV8g+ntVF1+YlQeNdMm4pCP94G/poMfMKRNtV34OXn0NktZGizby/NtJ eA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g241s7ss1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:41 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24I0A1OB021321
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:40 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g22v3nd6n-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e1Aym5eBH+XmdVSEUzW2jaH8/hwnJp7OEOyDA1VXLETOq0WZMQqm/+T+3fWqsUfBsQrsIZNoYK34j8XhVjg9hUTzZRGPmEDhBQD4Rmh7qsI8Ze5JqAzZJZPe+029PksFONdb4ANoMWwKEOhjpDD1O43FilQQcK8vK49jcX6zHy55pUCkfTHLZKOkrdazc2FZj/+eF3w8TwnocWoESEtvSnNPejvaEGcJ/0BE0t8nPA5MMHrM0G/jBykq2UO0j6CSThO7hbPwdsemevXJW0O8PLHEgyo4gRRWE+L22vnDfiAWvQmyAcE2OOrOf0Ke1yVaMJmqqUw5KQ26+GZ1YDU50w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zifJD990rwJu33QYI4T4PvvdJtkr+k7+218gcEBuu/c=;
 b=ghu73TZLBo1fVwdc2WFBiAuUnSV7Lqp52YvaSM4lFq7tMoUmMeczA10RP8QqyKO2peRd5bgFYjGwrIUE36BM5OdPKgaajePrbF+/0EWOPg5la+k99tCdQt6mAvyZRFAzG6rUzVB+EtiCWXjabtyyEQZADVYS2R1qjRPA9RZEraWGTwbpcZkd2Cisot6xtjaRFXUjnhs63j85YbrI43ZTtxQ4VwmUx8D9VFrYKXOIhK0V1dwuPVFhnXm+0WvDvrX24W30t3DknA0oFKxC+sEhYdsbVrZ1BmszuHRG8zhhcxRmn6aXTPvG0n9GPmnHTRbCl1RvFt8vbiC1pAQXayKevg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zifJD990rwJu33QYI4T4PvvdJtkr+k7+218gcEBuu/c=;
 b=ltSM2uIniYTg7cq4Bv0MFohZeoz0dG6hEKFeIcRhrrtnXG0masrje9NFD+PyASk4A8cY43MZ7ik1s7f7lXP2kO4qev62hZjZ+LpY1K8QQvlJZ+/aklj/bvH3CY1L3TRVxVUgJERMqfGxX1b57WqdwEzg4og135BL/6J+pf1BBu4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CY4PR10MB1528.namprd10.prod.outlook.com (2603:10b6:903:2a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 00:12:36 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 00:12:36 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 06/18] xfsprogs: Return from xfs_attr_set_iter if there are no more rmtblks to process
Date:   Tue, 17 May 2022 17:12:15 -0700
Message-Id: <20220518001227.1779324-7-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220518001227.1779324-1-allison.henderson@oracle.com>
References: <20220518001227.1779324-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0028.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::17) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f868a381-536b-48e6-3cfa-08da38631cf6
X-MS-TrafficTypeDiagnostic: CY4PR10MB1528:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1528D7166332914A44E6B55895D19@CY4PR10MB1528.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fJkTQsaoFieO275NYEphVeqm5t07wYTz80mKjLZR5G+0j1YUIKjsZfc8coiDrIiJ9QHUon//mAe/AXVDoEZpMJYisPEhmAdbUUT22AxG/uAdZFSbUbkLmHN+bK6lJH+aBOHzxWWC2MqewRLAeKIQ5nNMNNK/HAy1dgHKwbNWo0e4S5rvmbolFgbmDwsXIDr1C4Rpq0tXsrkEP+WFloo9pBkQfYDEeu71wL3EmGSwVRFuQRAm9Z2Ee42+JuTclZCuaFUHEaTYtPy7l1ACyf3t3ZrRgBezgDp9Mjp7540TF3G0cK4ewkSKLamX3R/Go0vzT7p6pwKB5ACbA6ieTYcfezEed/2csPb/EA5IUk9XYKhVl1oulEx+GTQRgxHQpW2EWPFAO0k5l/7i/8u0sSen8Ri9pkE+NhF6dOEkRt/iqImaVqVG6ZGxoVU/XrMt842W4YVAOj/aT05QUZ7MtfVnL9qXB8MC1zaC/CyeR42+CjSlBrdViWGDaDxik1DLrMuzsbR9kKwH05TEVg9ErgZ18SlhMfj71wb6JWtK9VRYYCxu0rPgiMzFKU45hfXqz2v29U/UKRNr9qoes/idZ0v4ggC23o18UFhhJkTQsXg0hlFJqugXw5mIPloL8Jg/rHdcox6PcGLlc7EV4IAIE+IquvIHqluYzSlf9EvGDCSq9zftARfCaulB0mYH2dej1dtE/qOVg/4DEZwWpiZMLl8mnkc7DQP5Uvbw4wyQ3ByTgVhSqg5t0gWTczeUvNA67kyxvr7A2BxFCiLEs1nr1fPjoEoK/jclgBiyvtXqJbeGG9A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(508600001)(38350700002)(38100700002)(6506007)(26005)(6666004)(6916009)(66946007)(44832011)(2616005)(2906002)(5660300002)(52116002)(316002)(66556008)(8676002)(66476007)(6512007)(6486002)(186003)(86362001)(1076003)(8936002)(83380400001)(29513003)(40753002)(133343001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a55UgBRryahvRTr0ZM2prEnFNVKMcA+4JAc+iKZIzmq26CObEzqKrt7qBSSn?=
 =?us-ascii?Q?bhWOWHTpkDnQdGxupVCOO7SHwEl5ZcRBeY0exMHMrRTJv+bs342ZkeXyCrfK?=
 =?us-ascii?Q?gjYw/30i5WlJ02pMTAxYT0ezxV7v3Wtm62cEVrIglJM4b1jUHkmJpIcLyGZ8?=
 =?us-ascii?Q?HgqHqVC0Nhq4aPWmHVaxH6gsu9DtoKt52uITlxr12STwIXhzhoHVI1QPw8mn?=
 =?us-ascii?Q?y/nuqM0tPtOAMnu11CtKu9uqmDgT6Bz/6x2fBBsw4uGFrRqDpH/IJxomiKKm?=
 =?us-ascii?Q?5GegtrT9+ct8ONM2DyyEtPocM39yzkOjt9RZYfCm+00W5tR/jm9QfuZoZL9x?=
 =?us-ascii?Q?ZzdXQ+Y9mmUOLmkM1kZTDECvYuLBVnFQ/mzBODKdeFb5Y5F8+ZT7tWJBOvx6?=
 =?us-ascii?Q?n+BdrOmcxobWVLcadDj6hSLsSesTMQsac1ASUphGCAfe+QuFQdb1JlsPoaB/?=
 =?us-ascii?Q?gldSMAGBfSK+S0qMI5nFDFNfQZ8bb4GKpQHZvCsBm/5KnHvpSTZqu+droTIV?=
 =?us-ascii?Q?n2583V/myR4GFVIhQP39WCyOuXXR7TaTprf5+XeZsPcKAWh5Y04KNavDa4u7?=
 =?us-ascii?Q?PTfPFA0zqjke0Ln091dn36Sg4VU+Vwss8MdUknWPkr8nq8RQUE4OHSiH3iIV?=
 =?us-ascii?Q?c+tlwT5hpH9f8FBxHP+y5k5Rtn2QQJNphRpiYnK4kIYsUOiVrbrz8cO10/4Q?=
 =?us-ascii?Q?MmqWNOcQfosCul794GPKpzvnpGCOuXotwIYphZ/ImgDv0c3cJGLkHhrgy6BL?=
 =?us-ascii?Q?86572a3hAR/3a2H03rg/GAqWHC4ISCmIK+WAwXCmWisLhGAQw9Psi+kvEJXY?=
 =?us-ascii?Q?cgBelwHQIVTZigPdbx/OH674Tx3iuR4mEL9HCpMJBqD6qIg+9F0qS7k1lD2i?=
 =?us-ascii?Q?y43LySqSSI2o5xXETM16jp9WkqYV0wNbbvLP5Ul9V2iLAn6rzTud2NhRZ8ka?=
 =?us-ascii?Q?9YkYN57HgVsGMgKglXA2EaEadrnUd47L+RTefzqe3FAWZOSgNxbL1AIO84d4?=
 =?us-ascii?Q?1e12NRSYvHySZnxC/02rGfuTSB0OvJxLKpthKOEfQkHAs/4+Ulos17kH0MAd?=
 =?us-ascii?Q?y7Sm/BNWWRWyuwvpDJ78UIwAs10w44eWly0EKSJ70Ujfh3G9zLSMBxaKZ/U/?=
 =?us-ascii?Q?p5yhVsspA2EQ94s2IHDJFhsHU7j7IubK9NyZzu+tgKteuSUTE2L07wEdCfHQ?=
 =?us-ascii?Q?VGPuRvN8ejpfg3dEczwXJrcBhYQ2eemF0gnxExNE1Kwbtn/5o00PbTzCZ1Lj?=
 =?us-ascii?Q?n/zGWbSxZoJZCi8H2gmNLbo6BHOFq7yPmBJarIqjcYz+uYiJalfwoFD+tnGJ?=
 =?us-ascii?Q?p4e6U4BYSfAKdYMxKsIqUk6ajbej+Trzn8ewE5kJUxK1Iq9PBA/WJISil+cm?=
 =?us-ascii?Q?X+Rpqb19R4zdSUR9rKwM+coAABjNEjNyQz6Z9eDPxZUkpYBVYwWUfUX1V2ZR?=
 =?us-ascii?Q?OZ1WYEro2DtuBrOKk/3CtuBqnWV8DJuaUYjIP6kExSqDqnwUYvFcwDmi4v69?=
 =?us-ascii?Q?jpU5heVHs/yxg7pMKe3YiCE0B4Us/wMjBjLNG4yoieuns7NAUcRmAARwJuUQ?=
 =?us-ascii?Q?P+USG0UkC/0KmueyOWU8yV83epj/Zkegs8ERAj+9TBdiaQ3zgKOyg6FnWy8T?=
 =?us-ascii?Q?HjWLChODI5YBhP31h868J9n/9+/DXZMuKM2LWE034QJL5E0teYgQCok8mRFf?=
 =?us-ascii?Q?VCOBJrBfIN1PTgtCQAQNMDic0tJPFvFjjEzRKNaEaEd90MFEEa69KlkuD6np?=
 =?us-ascii?Q?lNY8gX+Sp/MPPC76wo+KVZxI1bbFMAI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f868a381-536b-48e6-3cfa-08da38631cf6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 00:12:36.6570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hsspnMtsyd3HYry5gEfctRZTJqvhp8Gm8gBrTCuo4wzEoGUI/AxIGe1S3NhFdGaOyEmiPWnw5evcZ9K04MEDrqt20LRcdgWLEslO0WOvhaE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1528
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170143
X-Proofpoint-GUID: t9VzmsHaEXewuizIWJxBSjKtaDtiskpq
X-Proofpoint-ORIG-GUID: t9VzmsHaEXewuizIWJxBSjKtaDtiskpq
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 9a39cdabc172ef2de3f21a34e73cdc1d02338d79

During an attr rename operation, blocks are saved for later removal
as rmtblkno2. The rmtblkno is used in the case of needing to alloc
more blocks if not enough were available.  However, in the case
that no further blocks need to be added or removed, we can return as soon
as xfs_attr_node_addname completes, rather than rolling the transaction
with an -EAGAIN return.  This extra loop does not hurt anything right
now, but it will be a problem later when we get into log items because
we end up with an empty log transaction.  So, add a simple check to
cut out the unneeded iteration.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 9a9da4594d11..b6f6e1c10da8 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -412,6 +412,14 @@ xfs_attr_set_iter(
 			if (error)
 				return error;
 
+			/*
+			 * If addname was successful, and we dont need to alloc
+			 * or remove anymore blks, we're done.
+			 */
+			if (!args->rmtblkno &&
+			    !(args->op_flags & XFS_DA_OP_RENAME))
+				return 0;
+
 			dac->dela_state = XFS_DAS_FOUND_NBLK;
 		}
 		trace_xfs_attr_set_iter_return(dac->dela_state,	args->dp);
-- 
2.25.1

