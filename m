Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F366BC7EE2F
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 09:28:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237465AbjFFJ2q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 05:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237464AbjFFJ2p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 05:28:45 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD76E7C
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 02:28:42 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3565YZeu017868;
        Tue, 6 Jun 2023 09:28:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=Qx1R60DXnIB3N5o6yMynJzdO/XXQYFPlNasasf4Q6TQ=;
 b=e4WnsrtlsRM5AMCK2Mc8MpMpEHFxxIpzRyS8vo+6ZXUAzFifgGNnFHmfOBKfsNwwKoRI
 F0RrZqwhm74URqVfgj9uZUN67hxjUDp0B4DVQU4CHop7G2Ex+721ALOU2ZrtFLEuyu8f
 kl6lwlldW8w9WfwP+oEpkPHusE3hPBNO9qusMRn2QKssBDdIl5JBZZCXhel/5O4xLWaB
 DhB7q1HdKDHtHVQVG6mjDMDtJgoeCYNWvIJ/EAUW34N9f/ST2mvnojLy6rfYqlIgFpk+
 G9PsoxhMoOeW0TStv3ogy34VVonaDIVcRqEe/iDDFOtNTzkHI9/UShuZ+l9IhazRdkWY 8g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qyx2c5125-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:28:39 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3568FDGh024285;
        Tue, 6 Jun 2023 09:28:38 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2177.outbound.protection.outlook.com [104.47.73.177])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r0tkgvc20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:28:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LZhmaJHVqrtXhICAKZPmDpxbCkcjIIisr6Wjv0BJev3vD1FnDD1bpJXLh99fB0+idFKiV5gS6VTw4G2hSmF/UZvCcxF7kJNjxK7dCZqc0aK9tYfYWoZ1/LcVH/yUn5EzFt/NaP9AdUs4AzUHw7rcMol6PQPvUejYSMFcTB7crYINWLXEgNiZqC2Db6gV3RpaD/rdHIIZeC2rhyvBkeoazWmRIV/P+ZWTSaMFZhNioGlpiseWmnfAnCduJFGUBw712E4AKLAG+ehLC79f6DibTg2Aga/PoOrB3kdcecT1r+njQh0di/BPd3FjBypK7UzZnMBy5OZrRXnEn37Wyzf8uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qx1R60DXnIB3N5o6yMynJzdO/XXQYFPlNasasf4Q6TQ=;
 b=G8fO0Y1fOckZv80QHCwupZ/JWVeNPtPelgJu6Uv6v+T29YCDs4X9mxRo6b8dL4FTOnkCaFK4+jgmvYmsxhV/jzbl/MMDhfnLFYZicxAKFd+jPAuHjbs12+XHJx85sm6EmRGSBjMHy0G7faFDBA6jerOBqXBAhQqvn6TR4CYCaYYJXav5t2oNFwZulvAsVx+BYoE0DqTN2K/w+3mVj0995JRfluRZgj4hbY1PBDw7miyt5foWq1Q4jB9KOd7qiF7+Mu+miv8XwMeqjg63ZOaMdii73nBrmR3roY9pfIO8WSbeUzVt7rrl/JYn72GrBP+zr9LrDp/mnFD12Qgm3BKQAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qx1R60DXnIB3N5o6yMynJzdO/XXQYFPlNasasf4Q6TQ=;
 b=Huau3sc4Dw1IXxXf5phP2tbdHpOe0RAw0B55rSsowrl3u9DdebcUQ/+EpRAV0r1Rg+ravqfguz0T2L53lSW7UO7tC7s5wlRqQMpr69b2H62CYS4y1X4OaTJ+fFX+qvD2uJIroUj5kGKnFClUfSLqsfCP/IhlQ2C8lw7CIhojrkA=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SJ0PR10MB4781.namprd10.prod.outlook.com (2603:10b6:a03:2d0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 09:28:36 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%7]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:28:36 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V2 02/23] mdrestore: Fix logic used to check if target device is large enough
Date:   Tue,  6 Jun 2023 14:57:45 +0530
Message-Id: <20230606092806.1604491-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230606092806.1604491-1-chandan.babu@oracle.com>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0017.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::10) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SJ0PR10MB4781:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b50efc4-1a5d-489b-9dc9-08db667067c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Ub//wEQwqcwpPzsAjM4rFCUMYjD293YkKEWjvODZ2oJ/Ob7NJEYGYV5vxUKCu9tSCYRyIrbpxRAO/uRyJ1Px3xs/5VlcLQa45FvK3NHFP5fNeNKCIKFcLL6C7lHV9p9ozZXeGiTdUNIaOW61vfNsc87MfkkMzJ39AudOF00QPYOb/ZAHBubUjbL/YzGASaC1DmgQF1EduaZD9BSBLpa/nVyEGc5bU2T7wBsB9yEZTaUnQ6u+XwGkbeEyWlizCPLY+iYMXVc1XK/7/gv2jTjTx4Cv4ye561tfFWhGXW+Qu+0jg3XB+BB7cz2Xamt87vyyrnyORcDbCwa9WXW1JUwDvjzwVmc6l0aZor6vOaNnDBc272F4iCgXW/f7VWxS5g7PVhWJAyjO4qjzPuAMXmtwtZK6+sq43xokmDiW14uBTS7VWjhSr9wvnT5XJQp0xaItic7q+7dgleatCgr8UKZQjXxXAndpx17Xh9uOuJAim1fxUyb+nOb9/gSiRaTTehCwHykkIUSvTjMWrbHXiZCWWwYOH7MLyG71GfsvMDOFdxBDzZM3Z/inzFsQMXULrRt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(396003)(39860400002)(376002)(366004)(451199021)(5660300002)(8676002)(8936002)(66556008)(66476007)(66946007)(4326008)(6916009)(316002)(41300700001)(4744005)(2906002)(478600001)(38100700002)(6506007)(1076003)(26005)(6512007)(86362001)(36756003)(6486002)(2616005)(186003)(83380400001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FMVKK+ShkA4hxYbexQfbIZpfXMW7Mvfz0Z4bY8c7vh46HbyVEyXCiPjpwQKf?=
 =?us-ascii?Q?yezVPRn2QVq2+M7jcK46a8GnJ2/K7/6KiAlruzHYoKnRBMe2fBDE1b0Dx2dw?=
 =?us-ascii?Q?jMDYoxHoNuTCXdtQgoVIXnorPkILIFXfZZdEveimckfOqlEtXHPuCsXqwGMC?=
 =?us-ascii?Q?8/SgotfoeQtm8EOvOspKLypS3jlpyzPUw8J92FHkFBGcXBqPBYq+OQf+gfMR?=
 =?us-ascii?Q?X26vk1+tyFllVTVtwx8y5HosHZ/VcsgBhdqUoZxwKLf2XTAZTJ2lLthxUBdu?=
 =?us-ascii?Q?e0yHmqKfckU+DTc0kh/37bg38zV5gx08/2kRJ6sszYiGrxq1mQISOCtZMhgi?=
 =?us-ascii?Q?6VR18DpUE7Gd0X2+CvybAaz2W8FbITN8A4xWE8zjXVhXq1R8ew+3S9u3TtQv?=
 =?us-ascii?Q?tV6+z/7nxV6HUjuwhEBJ8SmqOFYSDZ3muOqZu/Aeux7TDHmXRJNbK/g2A9wf?=
 =?us-ascii?Q?b8xCYGU7+mnAEeA/ObrX1+MwhfjVCq4Vq5hPouBM3KDzsSB+y4zOw2QtNGrB?=
 =?us-ascii?Q?D4rwTnNZii5e5dGvLxDl08quqVvWTnqzNLXDtQfsQs8EfS3OINMKDL51M8CQ?=
 =?us-ascii?Q?sGu4uCZf3KUGk+h5bNROHW+eOkxZkd5EXdnco14wEIJzJ7M2NHuhh2sIqoZY?=
 =?us-ascii?Q?BkqZPPrc7SIquXlkN1mGoaimqrteEII/Zqs9WkkhCCnbQLrH6cCW29hDbEfR?=
 =?us-ascii?Q?UtUNwHdtaSKrcBVsNU40W26iCy/Mix+0HJPNNTUJyRlnNXBimj37SlpPRy64?=
 =?us-ascii?Q?iiulHUWPSmhNLXWWls9ft1JFNAkpoXP7sXTzGCKNzc+8GO/TxfapGXpTLGGZ?=
 =?us-ascii?Q?oFqMXyy0Rm2jT+33sUMa5AsjghCGrdGaTWRX+Lf3CPp2a5a8JfZeYWEpOQ4P?=
 =?us-ascii?Q?jKmQmp+uI6Pd1/39JraajUDttG1o8VibuCuiF4Inn/7x8E5Qir9KrmAhY7o7?=
 =?us-ascii?Q?KeAEUgOy2dy5Avsgz6UXDDiRwfLpYqWN9ATUD0UikCLAwWQOLpgr0NVzjiT4?=
 =?us-ascii?Q?/yzCGkMycLuAMC9TF9cWZ0zR04sf4a6pf5q5CM82+W1072uWtlGWE1Pqx3uc?=
 =?us-ascii?Q?qJK5s5WTKjEmJaE3VSWJfB88c/4jN5ecTWo94DIThIp2Rk0hK+arvriRBE6w?=
 =?us-ascii?Q?jIPijQqDcXsILswi/3XSZgD++dFIHdVVxjHnjgKjcUoabwRV3uVvhxUQAhzG?=
 =?us-ascii?Q?Vqx7KDEZZ6gnB9HrXOZSj2BhiFnq/rjYe6qhzQ7VyBrmBwNEZJaQVwd59IEl?=
 =?us-ascii?Q?6J2TzC7a56c+2pOFnf9ffhgp30aVFT/mV3KJHGVZB6ksRFeTFDnERkfDRMvI?=
 =?us-ascii?Q?POSfv+dK0sfFigkMrUK9C16XD4oX0rRhZCLAx/kxj2T3ne01ggMOjRdicvqq?=
 =?us-ascii?Q?Qqr4FAY0c7rPvbjTUQqtLjDWBD3I263YVRbwHOH2zoaWJOHWClRbZZDMdsxa?=
 =?us-ascii?Q?5VF+YIwJOt+K0eEcJV0ZiHDJ7D93nNepWk7S2HJ4ohzdjjv95cnxVvKTzWdE?=
 =?us-ascii?Q?cIsq0gGqce9F+EXmwdhNB7+JZ80QU92IHeadT0usz2ecxxAD3QUy0l1jdN8H?=
 =?us-ascii?Q?ETbaeyTJjSZ9/IALqv/ZTTL9SFf71oCoH8XqjeM3?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: XkgJRQb5GXsyXb+2K3lI7xs6KAU4vpbXKPsBdd19QNlGWp9xMDbbv2pVkw7MYm8vbc80Bw4iIZbIj4yQgeoWs/xrJcX2lWI+Jd7KqptQ2dDH2KfUWIyuV20BGoECJDbZnyFdzunanUQ0KQo2d+6syvXqACEm6MZQnG1S9qNHTWXojL2G8PepT1guMNlmlQIXsYJYJqT+KS10MULtSf7ZIrywbwWL3RlwAbAeY4l8KiqgcKuoHSfXrjJwBMrhMd1zTgwkhqmFq/eQVvqPAkB0IroNlbyD5yMwq9SYyB59K7KBae57z6fy10rGK98OSypKi4PIrqipLTbe5+SYWUUVDUyqr2IMM560qW8jG/ZBggFtFXI7RsA/cUHPp/ZyujFVL3ftaKmmUgCDq7q4X/yH4iMqSJNcD6CMN12hRDSCXowvVLshnVC30XbJ/n81JjXeY0d70uUeRjV9xZbkhkHePZv8VCMSgX46eBBG8V7txc/Ikpz2ltZ2O8D+nyfHUEq64innGfVZk5lmzaZh2Tv3G6nuveqK0x5eLdoS1aytCPRAEtztn0pONoosn1iMFGruVL6jwcDrcZ+ppbR9iFWVcftCRQe9meaG5ywm1Tf/oED1dc6NmNRfWPT9N0h1vp1d/uwzA0VCNigBL4yWi0o/9lTUx4yFHaU/KJhwnauVhQYciipn2Vq49HZWDzZ1Y+aWivfjWhOj7eEw3O8VNWtd+c/LfvXxfArRVDo8N/iZ290Avnqn/XZsX57xRyv3Q1kF5fxYJRnjCl69uZtz+n489FKyjNllErl9ZQwEIJbSE2s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b50efc4-1a5d-489b-9dc9-08db667067c5
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:28:36.7131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TVfgM4yVddY0b0X5wj+bkdTwhs9mifkFQ3AKTx1dXAC6y0ImHgXetH27TrC+ryOJZQxhDsAOFkXYGfP6MUYwxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4781
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_06,2023-06-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxlogscore=991 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306060080
X-Proofpoint-ORIG-GUID: cY4HfcDKqAHKFDXqhO4VLCNcCmLlatxg
X-Proofpoint-GUID: cY4HfcDKqAHKFDXqhO4VLCNcCmLlatxg
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The device size verification code should be writing XFS_MAX_SECTORSIZE bytes
to the end of the device rather than "sizeof(char *) * XFS_MAX_SECTORSIZE"
bytes.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 7c1a66c4..333282ed 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -115,7 +115,7 @@ perform_restore(
 	} else  {
 		/* ensure device is sufficiently large enough */
 
-		char		*lb[XFS_MAX_SECTORSIZE] = { NULL };
+		char		lb[XFS_MAX_SECTORSIZE] = { 0 };
 		off64_t		off;
 
 		off = sb.sb_dblocks * sb.sb_blocksize - sizeof(lb);
-- 
2.39.1

