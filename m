Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 711AFC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:46:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2998664EB8
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:46:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbhBRSqV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:46:21 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60386 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231754AbhBRQrB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:47:01 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUSJh059524
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=d1cgS9gGRVyt4lzZgTDwwEPzKeAYfXnZ9Hbtx5B/fUg=;
 b=cueS513BdwBsXUbB2wob41XR53o1WJUQcH27CtY6M1NrmKEhP0a7dHAtodZhNIG+009C
 7jP3IFyvZ3JjFFB16lARLW7BkKwvDSiMTE9Yas7kEhp3OVRrNEojgH6OO7uD1q30QYkt
 EecsDf1gfIhzCx6PFsg1CQMXDzy6zwtLgWK4UaEqChMXrglzCKlMCxjopAOlxoCw1v+C
 1msHqEO2seqwMUVOs6jpgip6/uVb+XlTTNA6RXhgkLLeTsHSSnzJBwWp3dYqb1gzwQtG
 9+xSh2p1R6Ryp+KNnWMWXDBi8iUlIHkMJvfgTpO2jGBPmFkR6RVc+thQ0psHaSxuBn0U AA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 36p49bersg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUHT8067740
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:33 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by aserp3020.oracle.com with ESMTP id 36prp1rjuh-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z0BTWKgSt9TqM6XhNL1i852ZdmNtpmC11FpzGq0XDuP3y/IBFE/yGmDmu926YMAt0R8GEdwxX7s69RN05Phk5HpQsru0CNrcQ7x2DCoSAsD3yIs7tQ2jtQQMMueawLfWeAHGi4zzuPmapxZ/C+7OectvbrV01rTqgWvRQMvjJVsB5dCCaNeOaWvc2Yhq5wyr/93ONXbYExWF06L7/zpKvxN92RjYeancorFNKa+J2XeAN4fOSPilnhsYVG03WmeYP3FqCFwRteaf/ArH5UfPDd0HcCUia3WWjXsfPvnik0XLeXrv/P00G6wYCgH9FKa535Dc59ji/O7JkbUDVfDu8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d1cgS9gGRVyt4lzZgTDwwEPzKeAYfXnZ9Hbtx5B/fUg=;
 b=iNCOyrYt8FNDlOlh43WKRHAlrIvR0I9dtJOstnOcaW6iJq0hMFNXvLD4wUFg2Rq4gtJZpIBLstINiWBLrqW2in6WDrEOx78b+fZGfotCBJa6FLCpBE26G9Hgf5eI9XuNrVxQyiugEoAAglOB8n73DYNsPScf5oOjmHzW7U1Hy2WSahlharhncfjJ2JEIYrA0mywBu7fcsUIRGkXbOwvBew0aLbq/dnGhriG7x9CsCui/AooggXrb7Sicc06xNXMytDuPEswJPxj5K5CwA/9QFq3liiMOzngRK71AMDyoysUyKw0tcKDeG9OZ25fkTzPaQC51WCq50E/oQQV1FNOiHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d1cgS9gGRVyt4lzZgTDwwEPzKeAYfXnZ9Hbtx5B/fUg=;
 b=f52VieVvWWesDwsLTyq7zN11VhPz6qk6NA/AUxFJs0FCADaLtbhq73XS+cobegs+vWAGIas+kCAOrvEQac9AKzhgah3Bd9jTgmTl28FtN3Wx0iq+3xfn9yCfLVUxG5a4UWtkAzd0sGRyfnt12lISqmk2x4F5/FnqcQrBehKDIDY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3461.namprd10.prod.outlook.com (2603:10b6:a03:11e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Thu, 18 Feb
 2021 16:45:32 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:45:32 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 05/37] xfsprogs: Check for extent overflow when adding dir entries
Date:   Thu, 18 Feb 2021 09:44:40 -0700
Message-Id: <20210218164512.4659-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218164512.4659-1-allison.henderson@oracle.com>
References: <20210218164512.4659-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR11CA0088.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:45:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f297e62b-7d4d-4a39-c718-08d8d42c9b20
X-MS-TrafficTypeDiagnostic: BYAPR10MB3461:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3461FFE2052EEB4B83592AB195859@BYAPR10MB3461.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:506;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ay+C+AhlZZVlhANX7TZYQlL/LyRNct34D2K7g0zP5VewcZXZPxD7RBkRanYSu0lBiA8RSkLx/jPkENlu76mrv3cpEdIU0FvOmPDJWFDP7hxP7+L+NcfWiCbNNimrqBXpfaZ3iOIzlXuvBTl+xB7HwBMXIQpPVEmpnytYdthyooO5yWj6WYJD80V1Y5pwzD5TtvB/BkO5ij3Pq4CfSywD0KEn0DIYKfxmIQYMB53fb4bVthUaGO6VtLinIM5/s9lq0yu+Jr3gZ31p9u/l20EO86urLzq0jp2yhtXdFKZYhibUcVC9PcMTeG/fhHaigMOp8aD2x6soKR/7XYQzkJMJUENVNZM/rgwnp00VMkaPAUx/OnJom4zxBK+XZcCIdTZHKHONJ0CSHM5h1lDNuXoj9ordCh7h1+j6oq4lgNFhReyzDx7SaxE9ltVvY5SB/ci3PcvEj8hC0r4nlurNuUSz4J6dcBZBHE7LgzNY1oiIp8B3qnkFAZPdXuHFUz9NIOAX0mZeVQRUah5yQaISXYfewoS9dS5ilEe75allbQnk1mRc2BqEFhAB4POZ5HV+An7+RywR3439/7pnwmCnSnSHXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(376002)(136003)(39860400002)(8936002)(66476007)(1076003)(69590400012)(6666004)(66556008)(2906002)(86362001)(316002)(26005)(6486002)(52116002)(16526019)(8676002)(6512007)(186003)(36756003)(5660300002)(83380400001)(956004)(2616005)(6916009)(66946007)(44832011)(6506007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?zAzrq21SA0Ci0hoMxZ9pH18qU47XA8fyshVsrYkHAW4LiOHYK8K9of0rboWW?=
 =?us-ascii?Q?BRQfgIZ+aBcHBrKwp4OpX9DLBI1Eg2LDRX9e/kjhK7SDJwCUZdLURH+p86XS?=
 =?us-ascii?Q?YnfFytFzNZz06YsXBc9M2s9o5WZ1lzaCfP9lSpaN4m4mFklvqLBRmDuABQB0?=
 =?us-ascii?Q?kHt06NfXcstPMgBw5RaPWX1iIsNtc9b/x47ZSlA5G/NtgM6zDYOjOgbj0F+R?=
 =?us-ascii?Q?XV5eV2bMZniatJ1OIIxXiaMBzP8U/Gx6GT2shxWOQKwy+rGDCZAkirpnxVeA?=
 =?us-ascii?Q?opIxluF30fBv3TAbnjRRKKboIcw+yKfOvTBmMnQqgLdGBFbasHDxzAaapW0q?=
 =?us-ascii?Q?o91fJIjrqiKlw1afCbZX8B8FXXp8HzOVzMvVIzfjQtQefG6vfqRhmSCjCyH0?=
 =?us-ascii?Q?7a+A7b0B6h+8xNORA9Z5E6AF8aOM6FHGsjXakfaQof3BgIztRbBEgq5RJ/aH?=
 =?us-ascii?Q?a25Zo89M/IuJIvafg/T1SEWYFFnIO4gHcjpGDGDr4ZhACDEpuGnB0KNzpI8h?=
 =?us-ascii?Q?c3WlFffaFRmrdPtaGKea3rarGvKo0fz7nAeWshp0IPC9o2DTfUV01m1iRmkA?=
 =?us-ascii?Q?2MeHq8wTU+sElNlHgabRX/XegQMrOuYhDcMWAeKC/LegjtivlABxTvq+LxCx?=
 =?us-ascii?Q?+cPPyNLDBsdlkvX2z572z/tpoeUkTgE0JJe0eB8fHO+gJtl2Odi41ia+K+S/?=
 =?us-ascii?Q?V8jYorqFfY2BbowVtZdlw8HHUeL2paRQP20ptVaBHLlh3KIHFmPX9SlliNuE?=
 =?us-ascii?Q?avx0c6iRWDsy6a1xXJGcaVgze1qCrgfkJltmbgiY0ZtCTPHBHBO+kSFqMaE9?=
 =?us-ascii?Q?DW6F8UaXZnJV0yWL4r+e4QEUHDEeEQ8U1dPbb9dmGrsnpCtrneN3cKGFPef5?=
 =?us-ascii?Q?GA0uMxnXVoqYepGbpmmOd/HZiojzeLuPguk7NpDq1T/BY5B7nGqUPy8OEo0P?=
 =?us-ascii?Q?1W2nDmvGxDlM9gO8K4fqhdy/AYifS+O8+RCbORHaOo813YdlWXhc/ZL9XNgs?=
 =?us-ascii?Q?NH6hoAHoGolxiO86j/sgpHwEUpcm4Ck5iaBr+lDYl4eniZGNNBnKgoWpplRC?=
 =?us-ascii?Q?21OXnj1qmZfxx6qAcCjQaoUnmPL7tuTGiLWnMxfsAmztO/PO4aoBA9H/TPiW?=
 =?us-ascii?Q?4K9QNh9y+FB2PCji4HLy/Ahk+Q0D91jl+yQrSY561uGH/ndDXdkfHHTQBuVK?=
 =?us-ascii?Q?BTmEwCEYnLeZDFghnb/p1qOBBmGVwy4Ktez/Ul0c5Y/D51drmHZ/Ud584gIO?=
 =?us-ascii?Q?0yAA1dyQOdadVdt0AQNms9MbbmUVJJHsyiK7lsv22pqt2vFczngJJNjLEKLT?=
 =?us-ascii?Q?7s2wqXZmq4OJd8GVTBASh4lK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f297e62b-7d4d-4a39-c718-08d8d42c9b20
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:32.0495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FyyeDJtZ3n7IcKT2bq1Ui33RI9Nw83C3gjqBdPKdjMh3GS872/TxxVz78Tx8gcsfLuXCvDX+kisvRLaHT70HTRD5aRn2IpylhghMt4J+UlE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3461
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Chandan Babu R <chandanrlinux@gmail.com>

Source kernel commit: f5d92749191402c50e32ac83dd9da3b910f5680f

Directory entry addition can cause the following,
1. Data block can be added/removed.
A new extent can cause extent count to increase by 1.
2. Free disk block can be added/removed.
Same behaviour as described above for Data block.
3. Dabtree blocks.
XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these
can be new extents. Hence extent count can increase by
XFS_DA_NODE_MAXDEPTH.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_inode_fork.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index bcac769..ea1a9dd 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -48,6 +48,19 @@ struct xfs_ifork {
 #define XFS_IEXT_PUNCH_HOLE_CNT		(1)
 
 /*
+ * Directory entry addition can cause the following,
+ * 1. Data block can be added/removed.
+ *    A new extent can cause extent count to increase by 1.
+ * 2. Free disk block can be added/removed.
+ *    Same behaviour as described above for Data block.
+ * 3. Dabtree blocks.
+ *    XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these can be new
+ *    extents. Hence extent count can increase by XFS_DA_NODE_MAXDEPTH.
+ */
+#define XFS_IEXT_DIR_MANIP_CNT(mp) \
+	((XFS_DA_NODE_MAXDEPTH + 1 + 1) * (mp)->m_dir_geo->fsbcount)
+
+/*
  * Fork handling.
  */
 
-- 
2.7.4

