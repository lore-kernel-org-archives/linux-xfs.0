Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 709B8C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:46:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CFFD64EB4
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231927AbhBRSqD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:46:03 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40796 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232495AbhBRQrB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:47:01 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGTB38155857
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=OuUEtaU6C+uVckHqV3oAuehatGq61B8GbE/ww1ZJaSQ=;
 b=hO5fREbJxEPilfJarH35Is5wvDybL6fKIXeyq+03ge7YOe9DWwVpcg5G263P4WsNzUf7
 QnfQ1KdKyQWY92tJL2i6HAnrRZ6fY5JvUsxgQvidKvbeAWajTAtws9nuXZFtFODFknDJ
 m8+XT0sY6IcRwckfJybRbbbSAeBa3E3lgL5LenMD5xi9cqEMuikmVLVu1ghIT5C7Cj+b
 eBBmsTr898vEX5j+5SReBXKNdEVRv/WofDP3cgazlSYkeAv0YP3D5XoQ/hbN+GTcE7oD
 oPesPVIvlceNcEdfrqz3eTtN/kRpnnBM1SWyMC9Pz0uuTWAMAoz2RAzDi3uoNGywYfyh Xw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36p66r6m4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUCa8032333
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:37 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by userp3030.oracle.com with ESMTP id 36prq0q51j-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YrsNfT4PYZZyJ7bRDuv7c6Q1XOAmqhBvCF0wj3BbaSDZEI3Jmb13YdvCyVMSV1skts5ZIx9yMRxb5SAuwu6qFD7o+X9KU9aua+1mGYGcpxejmqPomnziPYGjlBSMGaa43L8mg6q1SmzO1DOW9N+1zh0tlBJXM/AaRInOhKuvFfjqrNXjyB78w02iEdENk1InapJsgafmb2idbf579PdW795GUX4OGlnWwm+PWSOZg+puVh6cX0SOGqUZtgtQPl2uhkKgcWjeVqqRwDg8IZ0oIUb9qk9cJzaLgJjgeBwcxG6SXhOpc3OafkbHlAvpKuVNhDwA6xUJir9FTXvVvVRz2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OuUEtaU6C+uVckHqV3oAuehatGq61B8GbE/ww1ZJaSQ=;
 b=GGQS+chq5iseqFihAz2CglnUnCF0cCwf+tCMMNqTR4ZtzrQ7f/9/aAmVc4qp9dMxQ8wm9v5J7tOaC+uXtB7DWcTCjjx/NorzoyyO+FtNp0BLLs72qFE1mf8QUfT2mDb3XNF6nxIdHrXI8sfJnLsE45qb2OiDCj7AfNunI32bdteDaMmQUSdOuX0bE5ymEV9klTPwTPCu+ftdYArYkgMUwO2LX0iGJvlqeMbObjGOfgnzWNjYmsp/85lwFANB+g6O4SU7F2YaN2XUDH7CMJaGEwaYTLkV56TxlOc/wtvgXIOYucXnuY99/p3z5saCgjDHrFGCsaI/681sf429XxKruQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OuUEtaU6C+uVckHqV3oAuehatGq61B8GbE/ww1ZJaSQ=;
 b=JTauZPUqCI3sqWmf7nid01jNzLdmZbCTI6fyfkDULqHt51fRGfll6Y3rvS3FY/wXTjHU5qoCQvFB9c7LZ5FA7Ob3X4Sex+8Brq8ncPDctBCNQFwf5UuIS3/Kx7uUs76Y/j61IwedA9BaCkfmWyzc7vHtWYmzaujIbo6fv2XK7fY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4290.namprd10.prod.outlook.com (2603:10b6:a03:203::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Thu, 18 Feb
 2021 16:45:35 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:45:35 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 10/37] xfsprogs: Check for extent overflow when moving extent from cow to data fork
Date:   Thu, 18 Feb 2021 09:44:45 -0700
Message-Id: <20210218164512.4659-11-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.223.248) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:45:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 638b7250-f3a1-43f0-11ea-08d8d42c9d26
X-MS-TrafficTypeDiagnostic: BY5PR10MB4290:
X-Microsoft-Antispam-PRVS: <BY5PR10MB4290E4EBC6E6F49DE311E16195859@BY5PR10MB4290.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:632;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rh50jZqAOpSW3vvWbTt3KE1+ejnlZT3fy6Rg68bqsZYkYDNBIiqWOLnlBmFI0NNq9TIyQHjZ6SaiTqlDicNiOFFLzD37EPMBLWA2hfskGX8FVjc1rsDhVZmJVR6iyBhoM6/9+h16tZG0NxE/iIry3KYVgTl0aRZUUtlLm6qJF/frBTQCQPyc0zQg6C3miiXF0oNIEjAoCIh3IJYqcqDofSqHFu4mYmMZDKyUpPF0TdNtC8SR/GJ/UIIcT87v91sixBx3IFbLpuLhXcEQwUy0eaFd6ZACbTINzf+R8h2Cmw+8nuWbBymdBOLK4ACR/DSwKujqL0mVhIXoYKLXFXKcrLCH7l/0FjlXwzJk8cVjOGRbmF68/NvHXKBde7yb5kYgJBl3ooumdSEQ3+omp7QbzAymUZ7l3ou8Z1sswRrP2lRoN6aczcO8dbpd4oDxeu8TNktLc8uJnXUL9A41fl1JzIEI/DNcVcZzBX5aTOZVkxcHJJ19FL2VSEolc8s2mk9n29Y+HiLfkJMrUbPa92x6cUJd44O11kbUJ1h6hP1dUXqtDtp/fQ7J+oNSIyfihCe9VNa1i0cKMNsifvapFZ2+bg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(39860400002)(366004)(6512007)(52116002)(6916009)(1076003)(2906002)(316002)(26005)(6666004)(86362001)(8936002)(478600001)(8676002)(44832011)(6506007)(36756003)(66946007)(66476007)(186003)(66556008)(69590400012)(2616005)(5660300002)(956004)(16526019)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?OSuPccGoI4g1JCQz/3eyNLt4CUhs49ix0JQAirDMBWNIwjjakp0f0LvVVO6j?=
 =?us-ascii?Q?pvGK4NvwZNoNpdPLsTrNZc3J+amx+gULFDRSFVazNY1q9YscQmEC44L5OIrc?=
 =?us-ascii?Q?T83rTvsE556Hn+u29kyqXrSbjhXR4Sbdv0MzXkYUIu6cIyO5NGdjczd4Hech?=
 =?us-ascii?Q?RQhgJ7DLQ9tnktHeedg0S57p993Tzr93F+Vfyiy8w+xZUYF6sxSPZV1ebPny?=
 =?us-ascii?Q?63rAMI9P1Twp0HDe7jJmT7OuodlrHTxQo/RyT0dZwi/A2GJLJuCRapG0U+O3?=
 =?us-ascii?Q?x81IrvbfYjq0A/K4kmO3RNBAdKx8sd4byRkwtW7HRiGQzK9pcuJN/l8arM9d?=
 =?us-ascii?Q?l5GN9cwAVvKcMK0FEbxlSGp2eVZv/SAvLPVO85aUhbCVI+nR8lJ8KODO7Ame?=
 =?us-ascii?Q?Rewu+WHIlfafNMm6zaVg1AC3pnYnvudVJRC51ziL0C0ltROLzrdVkpKGTuzE?=
 =?us-ascii?Q?UlfvVLbi760w3p5G19lOR0GWWIWYuf9vNvEjzgjmaz89G54ZVcV392uIyK3e?=
 =?us-ascii?Q?J4B6lwxDTmdo8Aq6Y6NUMzWMQ6AgQ/3qLE9UC82VY7tAWhnY9c2KrI6T95i/?=
 =?us-ascii?Q?tEiQ8qg4EqdCyuAzmlQUCAH+0bDGp0GQHw2dlG8E0jXM9UMAXTBbtB+qsh+9?=
 =?us-ascii?Q?ESciB9WuvdDbfPP9qn6ccBcku4P3GyDIlluGQOJiFa7GI5k5rIFLQYjDfEk8?=
 =?us-ascii?Q?CeJILwsBKIwl4dSmaK8nUPRX4kMVOb40ugo4zVbXz/LNbhLaoKLRZrWtiNvI?=
 =?us-ascii?Q?sG4Oj38/+gpCtn/iHFtpFuQWKAjLebgegslAEMi700pbTVcp2sebDdx+JVJT?=
 =?us-ascii?Q?8rcUmtmJQf4TOEjZOUsY+duSzOfSwH6AgmMeA17jsb4GWI8Ka1A45yE0J+c9?=
 =?us-ascii?Q?QMrtqYEMqnAlcbWrnsHSXCIm2vL8raUrzVmsiOw1uam5Hh/TPCaGwc7WJ/pR?=
 =?us-ascii?Q?Z3M0fRXJva0jeICNkazy6/1sRKmqGNOJyDqRs2FStF7adQhpjIHou8Rb8o4V?=
 =?us-ascii?Q?cNesLsL3TqHYa2iq7WtgtDCqT7jkFwbdg/mVm/ns4iiO5HY6ENjiuZWwlBW7?=
 =?us-ascii?Q?dDgMHXkwNCM2geHJ6GKFrw04W+kUxUdIFR0dO7y6k9BXMrG4CUYjK7cgEayy?=
 =?us-ascii?Q?MoK5uYzQwtTHfgSXIjfWCzMroxPoBY+PjtXA7+SpBqtTo0USyvcR9oVZlroi?=
 =?us-ascii?Q?1AaLHFVsq8bVC2xH3EzhGygW18gHnoFN+cqb7hQuY6bN6qQl8kgkJppwNk0O?=
 =?us-ascii?Q?w8PZl8bjNZLTeLhsH0gZyE2IlgOKpLQFuXS10kRZpqlcMIN2xXhEcTh4lVJq?=
 =?us-ascii?Q?yvXSHueSMpoWlpk4nKuEM8HX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 638b7250-f3a1-43f0-11ea-08d8d42c9d26
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:35.5173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Uat09e4/PZeLFkEToO7xYLlg3hKZc+uMtMvHO1PhwiSuF8L6TCWEPJJ3jSTw3g4MtPGOURbJ5v8M++tVymC2klRb7qVmwDVe9q0AXkKi2U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4290
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Chandan Babu R <chandanrlinux@gmail.com>

Source kernel commit: 5f1d5bbfb2e674052a9fe542f53678978af20770

Moving an extent to data fork can cause a sub-interval of an existing
extent to be unmapped. This will increase extent count by 1. Mapping in
the new extent can increase the extent count by 1 again i.e.
| Old extent | New extent | Old extent |
Hence number of extents increases by 2.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_inode_fork.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index 917e289..c8f279e 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -80,6 +80,15 @@ struct xfs_ifork {
 
 
 /*
+ * Moving an extent to data fork can cause a sub-interval of an existing extent
+ * to be unmapped. This will increase extent count by 1. Mapping in the new
+ * extent can increase the extent count by 1 again i.e.
+ * | Old extent | New extent | Old extent |
+ * Hence number of extents increases by 2.
+ */
+#define XFS_IEXT_REFLINK_END_COW_CNT	(2)
+
+/*
  * Fork handling.
  */
 
-- 
2.7.4

