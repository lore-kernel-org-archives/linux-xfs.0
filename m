Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12F54C636D7
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Feb 2023 04:05:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjBMEFe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Feb 2023 23:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjBMEFc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Feb 2023 23:05:32 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12F1EC61
        for <linux-xfs@vger.kernel.org>; Sun, 12 Feb 2023 20:05:31 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D1i72S008818;
        Mon, 13 Feb 2023 04:05:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=OQsMGyw7/jkyklzbYzOfelI134nOYCLGijUmKHg8Shc=;
 b=XAjxd2MiaU5AgPSOvd4KQepKTJHnCxsVaXhR3f8VHCxkJ92sTLNWyLz9FCzA+22a5BfR
 KQagWCR3rY4CfgrTmob+JfDPf3acuSPivIAF3S99ZBwTH6nplOXN9ZFYsahAhEMjZJp3
 aqC5Yn6O4DyPlc48ZhjRWg3R1JS8JDY3cvynb0PBmN5/ZbuIKJ69HJM0683AVqdlybcU
 x+zepdzRIes07CAad6GJ3wt8lAon1/XxXrHsOjUmFR0QLS4D/98yDO1KXpcNPeiSCslE
 2eYxo6WTzydttcu0WS6TJMIjDCd7TixFq4qIlw0pgs4uPzQvdJwsaeuYvUDkNkI65Vrb cQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1xb1wpy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:05:28 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31D3UIc1017975;
        Mon, 13 Feb 2023 04:05:27 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f428nf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:05:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=crt8KPAWUIMaXsRipPOBOlcGpSuywHZACvca0yk7pJSBh9hXM/aasVcEhh43GExHaNSupu0MR0Yq8xtUHtuQl7N65QGMI0d7L8mDQSVcDUgJrtg+3saybra4LXfw9YEId+nIdE5T7ZvPgihTSRKsMw2E/ijs9u2arenHFbDcC+p49Or/tXBSq/9L8I+ziGk7wzWZpVEmiFgrEjaLfKNJ79vGgw9Pb9J/KjA6Q81OzAKhLgHouUiW44hoZ437vKEO/EADgb/QMSSacJL4t2FVVod4TMS7yAdrF58wmnsiiFuR4B1dSRTK05DH85cG65i6cyXJurNuSb9FBc6QXSTP5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OQsMGyw7/jkyklzbYzOfelI134nOYCLGijUmKHg8Shc=;
 b=FwyHc0xS/aJ5jdVCm1cZb5v9MPTxTaI8eiLy0/bglcmRHSbKLt0qt0UohLPmFyD+//QtCzkCfnAbURIZjVWYRDOu1e7OXCeaCBh+OGJL4ADjYqVJC0pA0bFDEaxSf/8Az0EWUpxTn1qIa32Hvb295gzw3p9p96OaTG2Ks60cmpERkwro7bduqoe/9QD7LhXIU7iEqiYrZBLFYKEpApv6sRrn2Gmj3MCRucqnPcP+D/Vdr8nm73VF8LyQzJv7m0bsxayxLQckHDsM1HloEUB4PTLtgPphefcMhRYj85cKuZLeBcyyCoYA2ypjAQCWCEnYXCVuPY1mxioeYg+Yc4XP/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OQsMGyw7/jkyklzbYzOfelI134nOYCLGijUmKHg8Shc=;
 b=dSUCnElY2dU7UjxLd+ky6QXLrKVklS5ydjaRTtbRdnxo8jtpdkREcnIWrA9LWTvyagyrLigYbV5tYzyl5SAk3DhxBVO4Fa6Okm2XyFuh7Bq2j8lpvYsq9H3SxTFPAlo1Rwfm5KKSqwT/3dJl171MHHBgIPfI2awdS4wn+eS0UOM=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SA2PR10MB4492.namprd10.prod.outlook.com (2603:10b6:806:11f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.7; Mon, 13 Feb
 2023 04:05:24 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.009; Mon, 13 Feb 2023
 04:05:24 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 04/25] xfs: factor out a xfs_defer_create_intent helper
Date:   Mon, 13 Feb 2023 09:34:24 +0530
Message-Id: <20230213040445.192946-5-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230213040445.192946-1-chandan.babu@oracle.com>
References: <20230213040445.192946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0032.apcprd02.prod.outlook.com
 (2603:1096:4:195::12) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SA2PR10MB4492:EE_
X-MS-Office365-Filtering-Correlation-Id: 86eae2e4-c379-4a0c-ce94-08db0d778881
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IiukHnPZUbpwEoH7qCCp0cPo2q4ETCbQHOR5xKedOGYB0Rua/Qpz0youm38ts3gqUcBrd3wpCh8TuPDPWyxalrKxYNF9a1SmobiBGFyxvX59yFWaAloqYP6c2JQIqncjcTp0fpWESVr6gwNgmURgtWJndvzQavfDgfyoxUKHJytSfpv3NgLpShRgkp2TKm6JmXAR6Mt0vEoRaB9hCQ141TKrHCbacy/zM5FUr9SnltFEZUNwXmX4k9yPQNfPmiMOaXFPogs0k9j+TxsqNJAEQbJ3yz3IBwlL4J1oSF2GsqiK90kKaWnpmPMIvut32/UaY2MhvD0PFanPpZ17iUd3YYosBbzuZajj8DHIYVC15T3wyGD/y4utytJHlB8wmFos8JBhyJjZC+0JvjBZoGIdC7ZYCAelhYcWygjXj1iblv63tG6BHv03/HHIdhLhWVF1NMtqpySfrYrmDh7KV5wgvofrj3xgteiR0WuRsOjXLJ4hMIOrpxo6IViQF9N/VqcRSCPPw4jk4wsx9lfM9dSI6JGAYf74xOxgyMGw9+TEC20oRigw/TkqG8mdRgW28N53pUHgN5F8yUqlxtjL0JWpKarNNIeL1TSsTY9tOXTTSKjhMyBDJl/P0bx+6tUhyKzFWY/Vq/RcR70RueRmSsyaFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(396003)(366004)(346002)(39860400002)(451199018)(26005)(1076003)(6512007)(5660300002)(8936002)(6506007)(186003)(83380400001)(36756003)(86362001)(38100700002)(2616005)(2906002)(316002)(478600001)(6486002)(6916009)(8676002)(66556008)(66476007)(41300700001)(4326008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0hL7UFIGdsBDqyrUBtge1KSxGnsyyZiHfSxF6Wo0qKCIfdc8W4EpwBURWdJi?=
 =?us-ascii?Q?4ZBE7XbMpN9tjY+TM9qzqw1aMjuDZMDo7ToPh7w6zGI55SHuY0zeCxXDwEt8?=
 =?us-ascii?Q?qBVWPEZmccJPzTi9Bo5GTGp5SH5f86TNjwjXKapxd8mraLNyM0tPhxKB0bzT?=
 =?us-ascii?Q?VKeGCIWDY9jOxYsMfyzLzX8YJDOW2xxG6Q5tMYhPlbe0I2sa7C4wEsmClbsx?=
 =?us-ascii?Q?Obrr8/XoOCAt/29lSEDdzD+T/XPHLXLSlM4zBaW+LnYUcgX+JKRlosSm46lv?=
 =?us-ascii?Q?cnCBtbj6qzKsxLTTsQ6uYOY1+XhzqNPDoeI3/CW2t+IemcRcj2P48DH6rK+g?=
 =?us-ascii?Q?SXD4CJQaZiu2vXGsA6mxPLOLqEgHyXxYXTnW7j7FQxJMrMpYBI42qnBrSWUt?=
 =?us-ascii?Q?P4hfjVq+N0ASj84qMs4XcF/gW8qZfAogtLfARirDP20TThvpMuvxGsteKXqQ?=
 =?us-ascii?Q?JFWMzahNHeFwtuSMOoUiIIYdDbeltC/lizq/h884zu/TLSgcPCEaP5ZDh99U?=
 =?us-ascii?Q?HjCqWI+oaKwpqTed5d3wgYAJCABrwxE2/2H3U+jhCrZ48FTgcu5tgM9f5hGP?=
 =?us-ascii?Q?2i55oLMf9RPpYU88sbU6mDBg4JjftLgHq46tbGlmDLfjasDAxx1HRBHxyO1N?=
 =?us-ascii?Q?11J7EF0kRUuOsB5IoPTriykdkSYI2wc3J6n4zvm8jhaPu2oFi3279kE6MAq1?=
 =?us-ascii?Q?k6npPR7mg1jmTiEp1nxTSFafg16rIIItxrZF/tx4lZrgkPbXLxmPg5shG8bv?=
 =?us-ascii?Q?Qb0ONOumCdqnA01lYkQER0IArm0hGSo8ycUG11z5r1vz+iMA2lSQyRzQqmqz?=
 =?us-ascii?Q?g+ru2r5SW4kbgnEpJhieNTqq0zOoIQ7NFDpMJ6oDgJykfiUaZm1FsPUPZqhv?=
 =?us-ascii?Q?lW2EZ0XOSAdObbST/fDH4kV7iUWlHVpkeADZsyai9YnFRzq02kTaqlCPATQk?=
 =?us-ascii?Q?zU/HWXGC/Byut0XodWYWeUNBKp8zVd134C/UjEngE2QBy2Ld/JSeWE2T6oOA?=
 =?us-ascii?Q?nD1L9gdH+wolwmuNz44cg0pqHJ06urXyj02JfZ5DE06h/1sWGDGvCg1eFxsx?=
 =?us-ascii?Q?/1aXhbnCWoCP2LejaNQtn3thNc0dFk+7UsEgph/HbJVxj3/8F+DXIPp0M6//?=
 =?us-ascii?Q?H8Y4HVOWoKcexyo96hY3KLYvcYrP1uaz2ezbQybE55bJLMder/j2LX9ZnPLX?=
 =?us-ascii?Q?+y9U1WdZalDs5k+bcMPHqGB43E6WQBqznPVdYKZBvJTPX1LssrS/e5mRh/X3?=
 =?us-ascii?Q?esuVw7uZmSa2jJQoqKUkwD5I5mhcKX5FfwkjWWRPRWyt921oyLfYtTRoXe1f?=
 =?us-ascii?Q?Sf+zPyt7gYNZz2jJvLxnixel0x1rsinrqVUKeJatXxdcF2MHuVQX9OcIneIH?=
 =?us-ascii?Q?gHWgXLHvyAiFl3mtsyCjyu9cfik6NXtQIOLkFclLLT6s53NtVmFTioDIOH3Z?=
 =?us-ascii?Q?QRjb9DUaRqWBROCSw0uF0Ndnlgi2NANyUMM1bQrbTAYT+F+DmKGa/hLwDz6N?=
 =?us-ascii?Q?KknlCYcNfcdL8Xglh2r6Ytfpa1A2cPYsh4Xh6PeEdrSwQ06guBdQpGKzFIH6?=
 =?us-ascii?Q?FfsKx/ZjizO9j5t4X+UAnOqhpKzuPOT3cBGYk4nxPFSJ3IJ260jbPYv11z87?=
 =?us-ascii?Q?BA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: xVwT4sc1Nbx2rwfP4AecnxraaocPoJ2C7+EFK5wtvOnlz8Is+gDM6LGpZhn/mbyfaAM5Q3e933TCvbhZ4L8zWk3XSZu4UbiP3Zq+xz/E/a8DRR0maOBr/GQQFIg28NTSdnzJzJzRA7oCCtn+UmvtCVLzJv8vKRgcSj4t/bksJFZkT130WmCYvPbqe1zFXPSGVKC910c3VvVrI31vMfgwV+32WIMN/nL+wIe5YHyjLEpknUy2nbnjZho2lq/6ESzFcyr4EOTnPgOtHTJOYQQfA4CUnzizFgMScgjl5is4P/lCAMeitEV+XnvKIiJh5aweq7Hf2TGk89VKE0au1TzVgm2J+Krndbc65kNrxdqdaXAnNynIc1MRuVBfqLUQF5rkniquCiMIHDscRfY2aJ/l16iVvfY03xvX5rvLF7OgXGjOzBRlj7T2cVXqdEvidNcW8g8YN0WXfgYWg+T07Ko6mo7k/bfPWBFm55+87BZ3o8xX2Kk3Cgj3Cm6xQvQvP8iTyspzaZK20fIQ2orMDw13aFpG7JhZvuz5XROnSR6daVvpUto5svcAHTJlbh7l4vpJvDBGdRFjCYV1iRNtfI9KVtX8ZIul9uuYlyp2NCTAaxgjFXypaAcRJpcs0GItOEU+T6TpuFFurH5WEs6JozWm+f3kBi3DRTTxV5HRq21r4zqsbQ89bTmLmUpJls8JBZiYZDFo8MAGto1PRRb1QCmVNPmEhX+oVS7hTnxZVi0BPgrHQPiu7snjzvjeU4JrQm2HK2mSxqTTvzu2cDibBaxRPdxjNul6/fGUjvCPi6sxJUbQefk+YOHdi6/wptevP1iy
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86eae2e4-c379-4a0c-ce94-08db0d778881
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 04:05:24.8659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YPe09L/A0cd+z5/DldVP4/+wdmMvZZnBpMJxjpMl7Nxwl47KHvXcICje7fDE3l8LkoYi/KTqgmgA3kjvSmHkrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4492
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-13_01,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302130036
X-Proofpoint-ORIG-GUID: v4pgByfswKdXPlhizvHsFgrbbzyy-VJK
X-Proofpoint-GUID: v4pgByfswKdXPlhizvHsFgrbbzyy-VJK
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit e046e949486ec92d83b2ccdf0e7e9144f74ef028 upstream.

Create a helper that encapsulates the whole logic to create a defer
intent.  This reorders some of the work that was done, but none of
that has an affect on the operation as only fields that don't directly
interact are affected.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c | 39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 8cc3faa62404..a799cd61d85e 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -178,6 +178,23 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
 	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
 };
 
+static void
+xfs_defer_create_intent(
+	struct xfs_trans		*tp,
+	struct xfs_defer_pending	*dfp,
+	bool				sort)
+{
+	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
+	struct list_head		*li;
+
+	if (sort)
+		list_sort(tp->t_mountp, &dfp->dfp_work, ops->diff_items);
+
+	dfp->dfp_intent = ops->create_intent(tp, dfp->dfp_count);
+	list_for_each(li, &dfp->dfp_work)
+		ops->log_item(tp, dfp->dfp_intent, li);
+}
+
 /*
  * For each pending item in the intake list, log its intent item and the
  * associated extents, then add the entire intake list to the end of
@@ -187,17 +204,11 @@ STATIC void
 xfs_defer_create_intents(
 	struct xfs_trans		*tp)
 {
-	struct list_head		*li;
 	struct xfs_defer_pending	*dfp;
-	const struct xfs_defer_op_type	*ops;
 
 	list_for_each_entry(dfp, &tp->t_dfops, dfp_list) {
-		ops = defer_op_types[dfp->dfp_type];
-		dfp->dfp_intent = ops->create_intent(tp, dfp->dfp_count);
 		trace_xfs_defer_create_intent(tp->t_mountp, dfp);
-		list_sort(tp->t_mountp, &dfp->dfp_work, ops->diff_items);
-		list_for_each(li, &dfp->dfp_work)
-			ops->log_item(tp, dfp->dfp_intent, li);
+		xfs_defer_create_intent(tp, dfp, true);
 	}
 }
 
@@ -427,17 +438,13 @@ xfs_defer_finish_noroll(
 		}
 		if (error == -EAGAIN) {
 			/*
-			 * Caller wants a fresh transaction, so log a
-			 * new log intent item to replace the old one
-			 * and roll the transaction.  See "Requesting
-			 * a Fresh Transaction while Finishing
-			 * Deferred Work" above.
+			 * Caller wants a fresh transaction, so log a new log
+			 * intent item to replace the old one and roll the
+			 * transaction.  See "Requesting a Fresh Transaction
+			 * while Finishing Deferred Work" above.
 			 */
-			dfp->dfp_intent = ops->create_intent(*tp,
-					dfp->dfp_count);
 			dfp->dfp_done = NULL;
-			list_for_each(li, &dfp->dfp_work)
-				ops->log_item(*tp, dfp->dfp_intent, li);
+			xfs_defer_create_intent(*tp, dfp, false);
 		} else {
 			/* Done with the dfp, free it. */
 			list_del(&dfp->dfp_list);
-- 
2.35.1

