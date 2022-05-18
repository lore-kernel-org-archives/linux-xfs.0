Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00F87C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 00:12:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232365AbiERAMp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 May 2022 20:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbiERAMn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 May 2022 20:12:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D82F49CBC
        for <linux-xfs@vger.kernel.org>; Tue, 17 May 2022 17:12:42 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKMoir019081
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=0TGBiYRtId0jc/V7bsvUDbch4ADcYfty7vGiBhEKejg=;
 b=zwCJgfY9l+oQ/BNF56ysf6gDi969aIWydFnvwInOg620Gncsa3PAjpRl3qy3RtWuMRVI
 MoJXywtw7RrqvqP2aEL2sKBZld8TtXMJayxlnyj0rF1pNYe0F4WTqvq5p95+rOLk/Y1c
 QNIFeLDxc18P5c0D+iW9yaiuJlDyDmXmnhCQt11NBRtT5Dpp+uxkCggY33BLya1q8VWp
 rSlmVW7zcC1lXMXZmRY0z2N17SWScpxYYY5Ul4D/Q8KyvsD+895gg+H1q1vGxyKh5oSj
 a3vOgrwwcOiXzm0rcJTozvh/WZmZ0HMXO4RMlMs6yc1EewaVfHZ2SWb7QhDB+syxP898 fg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g2371ywdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:41 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24I0A1OA021321
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:40 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g22v3nd6n-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SelhmhK/SER3y+eSCau5eFC2PTjNb89X8Bl0D/+/TzpeDtaI8eb1CtjGigzsA5HtIn4UtOx7ARD+1/LUhI8a4ElllkNqHZsrnQFrxQgLssojYYwiU2femxMX30AeutiG6kR9kICHMJYvIzmPAbZPnkqGfS05pK5Zvq/d45D4JKNA+MDNPL/Xhs9SG/WdQWIbDFoGw+4HF07hgWspxK+9+HwMZi0O030LcPQ7fgk3JBm/jvjfsiF02dV0LBmvjfOWl4VGjjZRcq7OrKI3RO06o31Z0Ak5WuInB7ntEbAkfxqSK7397EKZZcDOmUCBbJiqli24rnr8Gx6rZNtNFo8PQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0TGBiYRtId0jc/V7bsvUDbch4ADcYfty7vGiBhEKejg=;
 b=SyUxo72AARlvfNcrfneTVLghLy5Zp3fMFd/syRJCZ5oLii2o0MFHpt3tMXD9qwudJUnlHlx0nEVIY1LMgsD5QZoJpYZ4jrKAV4XvbAZHNOR3CEnPM8x1t/dSP4zlqgnKjQQi776QGELlPSx/F5+SydMLrWONYk5TUwCHQKlwYG6Ii6Xvn8EPodUS4VU9z/HffWTV5703bBxawKFHZFdsdJ1y3Dig54Y+9Dh+rSmTQfEVNviK8rWjCvc0mZM1WB3UbSBNO3qjDEg+dA/RGqJ8woSJaHRP1tc62giGL1mVqWwzzZglwszph5mHgboj/ZBTY2XSp3q5vbzHX4gIuMrY5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0TGBiYRtId0jc/V7bsvUDbch4ADcYfty7vGiBhEKejg=;
 b=SZGDA+qq6ZIYZxj7EbXAz5oQ7kPUMA1xI1NDwydRxfB9FoDdmLZC5nrf6BRrmKVgdYyhWckDoG51Czw/ySE9sKJAWiWXzLH3FoSsQcG8mJ6T6MDci+bAy8rz+hfQwkWBK2FhgNEGdWF/nUZ/Nu07/xCKuJxW6eTKxICEyKOw0sM=
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
Subject: [PATCH 05/18] xfsprogs: Fix double unlock in defer capture code
Date:   Tue, 17 May 2022 17:12:14 -0700
Message-Id: <20220518001227.1779324-6-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5e60bb20-b331-403a-e078-08da38631cb5
X-MS-TrafficTypeDiagnostic: CY4PR10MB1528:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB152848D66D16021BC7003F3B95D19@CY4PR10MB1528.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZuVggdQewEboJtsEjYp4psohDNone2Dds7c81m9riYTKCEQBl056hloZBz9nAsOZ4Bese8Li9c0SUmykGZKlu2DWPXi4pBeyf4DNzHgoKcRPg0pSy939gPErPEg3Z8ovMhh4w7uKI9WTrlYy53CLfIvX7HICtFoUzQKX3nxCL5xM8YE7VcdTWWsAOUW5JB6lWw86MEk+MVIfl/NahQyEA+1ogefl/ChR0m99cBi7INiAgw+iHy86jXJby8x178khjYV/dePCzsmtM/DzTDB9iQy5FwlWDiTCdqpkvMjMCmsGs76deM+VuOoKF9roQI1sJ7eh2p2eLZTiQ74HNPOEV8xQTj111p08airwFwku3J3HbqWUSOHoAXFYL1sHm/ijHhVXQ2L2QsC7P51le0qzVy0WT2sZC2x+NJyRdcYJTieoTizSHY1V8rW+8+YjPC0Zz5QhDZq1aMFGqoJv3d2CtUeWIwd5ST1Y8+m+5qc/JZvE+wpCSiZ5YMDP4/o6kcadtiwHw0dTxFhvVGP+pelSZIViQKq2nlgqBAJVGYnvE2mNvgONo/E/qwFTe1Vo98uvrH7ZWF6SbjIbskoaDhtgFqPVDOarp6rC0zfqaOejC5arRdvJiADeT8D1VvUQDPphwZ46643Q45xLPe5Vs6w0GOUAysFyQRU5NNmNxUltWK1+y1c1xVLfn6U8/LcU2qTx8+b0839v7Uz0OuKdR8MXwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(508600001)(38350700002)(38100700002)(6506007)(26005)(6666004)(6916009)(66946007)(44832011)(2616005)(2906002)(5660300002)(52116002)(316002)(66556008)(8676002)(66476007)(6512007)(6486002)(186003)(86362001)(1076003)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4SAWErRROnY3EAy/Vl7dyW1zyACJFKmXW9xHSC5zw1cu6s9fLqOfaOYWGNI6?=
 =?us-ascii?Q?8n9OcpgA1jWRyEsLPZdPkJPDu15FdqmlEqvetlAGx3ldmksO5zqlWbBNM1Zv?=
 =?us-ascii?Q?TJNEFGO5rNn4hYIFsWuEa1E0ZZwtEKTvCwC39+O7D43Oe7iqYgdc47OYAdXN?=
 =?us-ascii?Q?8XNXu4ChS1NycvgGLJEXPftFbnP2uy9NxRZCnKjwjUsFkPNnvAybCqR0JkO4?=
 =?us-ascii?Q?GCUaToOO5cyV496j+XSm0X/0Or70Y2DOEHWqThv7WFW39OLcMy7A3WP+hkSd?=
 =?us-ascii?Q?fVYiun59dzInLyM0UmN4Ggr9RztV0DV743qn2SrP4o4fTs0LWn9sD0lVqvIK?=
 =?us-ascii?Q?iYktKnfXoU3+k3yriYjRs2k6iIzh84XlWPnLdDb63rHb2X3nFfZ9nh1qtCts?=
 =?us-ascii?Q?ie4+lJQ0zBwkSCKAw2b3t1lFcpNpYWn+wsLdRU6ofbGo802AZbYerBFj2yfG?=
 =?us-ascii?Q?zU7yiCl7TLemDo+hLBC3Mvwg3uZVVsI2qw1OSqwB0W5tM9zPV84UoAqNfAol?=
 =?us-ascii?Q?P1mrw1yUxrMyXS4hyoLCoQqF03fxrLgdWYXTHlKIgFhoZ9iuwoKG1wIpFnDA?=
 =?us-ascii?Q?+lO7vCKA+ueWPe/3TgZD4xsfwdEywgVXi6b9FBaUHeFgbtbfl+8h7LUacFlI?=
 =?us-ascii?Q?oqBFP6hGmrmxaXqyajcd/6cLXTNaGwQJAk2ijFDBjZygFcfN731JMnRWCBbF?=
 =?us-ascii?Q?j4MaCtBHdjK0hnChEdXarNUwjxjH1chBNmBlkviuHrZvTzVMtUlFHwfEvRrf?=
 =?us-ascii?Q?mvFFLwWFHN2fw6uJOX6fV25ot+tT0aVaU1ZMM2EB5vrnfzX/XXBGWC8rDqYv?=
 =?us-ascii?Q?U/LYw+1xihssHf5jlFewCOIFJmOdLg7RqKAWgItRFpeAzstTGiJSbMVw/VZC?=
 =?us-ascii?Q?Y8wwTVgjSlS5FEUDpTmPgVvMpGHWEtsaHuw8XQ3prGJTsFuZI9ykq8xvNCYX?=
 =?us-ascii?Q?nL08wkIIfuqNvPA4jXzvomwRc5uMZ09zkIb0ah/jsNpUVKyb4trdVn3ojTqy?=
 =?us-ascii?Q?ozJtRqZxOuylid4sbp1lJ0YLDCYryFXOtq/WZ9U/ZoGLInz+W23UhEV4qBO7?=
 =?us-ascii?Q?I83rIHI7IQtYVV2oI+0ozpzwnocc8WYMyUAnqg/f/PK7s7bN6GQ71UuDgzHf?=
 =?us-ascii?Q?onoYLVJ6Hz+7ttDIMTaKSU0ADTXNrL+EtlxwIxLCLnyPMWLfb9zNgK6WFsVQ?=
 =?us-ascii?Q?cfmjikODffnI9R9pjHRfiB3/eN/VO4fZKz3B0+53z7Ecvp3p12ZdQcBioTWw?=
 =?us-ascii?Q?Q2qNHB0n/06fv0ciKgd3rAYbBEWEwl9+bs0kf3YRRakzq0AgGEtJkLOMnVqA?=
 =?us-ascii?Q?AemJCeaEGwTblJ6ee8u6HKEsAoHE7toudlBSZb6TPUpUEtkP8SfvhoA7P76g?=
 =?us-ascii?Q?2DRHyPYzFWr3rYG+Uj1BkMmsQUOJZttOWclxjjoloJAwg0qSVnkcNXXZK1mT?=
 =?us-ascii?Q?fG9RsVpG7Bdi/aTPl7gZPOzQG5ptqAfihs0v/a2HECptsCk+AWzSqqG/nHiv?=
 =?us-ascii?Q?QZKbsThfFXMXQqLfNKxYkPkwH+rew1PLevxlT2aSuKNokKjLBxsVlEJ3weqW?=
 =?us-ascii?Q?TpakWJjhYB/laEzfrr5Ep6B25zb6cuwY4km4K34B/sOpbX0NuN1ALfIV7piy?=
 =?us-ascii?Q?BqbsrVe2038QXxPHVFwRTDWqyepGO7K+47e0X2VcSj4sMUf3mQp8C+fFuR+/?=
 =?us-ascii?Q?yoTILyXUVpLu4+/IjCpPWPrB4EXqMcOy/vCT1SKIXihIvOG7qDs2ciJMS+ac?=
 =?us-ascii?Q?6RVyDJ0cmrijr6w1l2I7kMG/0Ex1N1k=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e60bb20-b331-403a-e078-08da38631cb5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 00:12:36.2820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: chYbS1kbbLWA0lLAM3lJcv6s2pgwi9XYr0kE2eDlFS/BbqR5YX3difAb5S4YQPP8mNwoWvBu3rA2Z8AESN8RQhWaDDM6vRzrbkZSC6qhRK0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1528
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170143
X-Proofpoint-GUID: 7Kaw3g_Yx6ZLGxadwy5rTuPaHKWqkUSU
X-Proofpoint-ORIG-GUID: 7Kaw3g_Yx6ZLGxadwy5rTuPaHKWqkUSU
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 7b3ec2b20e44f579c022ad62243aa18c04c6addc

The new deferred attr patch set uncovered a double unlock in the
recent port of the defer ops capture and continue code.  During log
recovery, we're allowed to hold buffers to a transaction that's being
used to replay an intent item.  When we capture the resources as part
of scheduling a continuation of an intent chain, we call xfs_buf_hold
to retain our reference to the buffer beyond the transaction commit,
but we do /not/ call xfs_trans_bhold to maintain the buffer lock.
This means that xfs_defer_ops_continue needs to relock the buffers
before xfs_defer_restore_resources joins then tothe new transaction.

Additionally, the buffers should not be passed back via the dres
structure since they need to remain locked unlike the inodes.  So
simply set dr_bufs to zero after populating the dres structure.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_defer.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index d654a7d9af82..3a2576c14ee9 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -776,17 +776,25 @@ xfs_defer_ops_continue(
 	struct xfs_trans		*tp,
 	struct xfs_defer_resources	*dres)
 {
+	unsigned int			i;
+
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
 
-	/* Lock and join the captured inode to the new transaction. */
+	/* Lock the captured resources to the new transaction. */
 	if (dfc->dfc_held.dr_inos == 2)
 		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL,
 				    dfc->dfc_held.dr_ip[1], XFS_ILOCK_EXCL);
 	else if (dfc->dfc_held.dr_inos == 1)
 		xfs_ilock(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL);
+
+	for (i = 0; i < dfc->dfc_held.dr_bufs; i++)
+		pthread_mutex_lock(&dfc->dfc_held.dr_bp[i]->b_lock);
+
+	/* Join the captured resources to the new transaction. */
 	xfs_defer_restore_resources(tp, &dfc->dfc_held);
 	memcpy(dres, &dfc->dfc_held, sizeof(struct xfs_defer_resources));
+	dres->dr_bufs = 0;
 
 	/* Move captured dfops chain and state to the transaction. */
 	list_splice_init(&dfc->dfc_dfops, &tp->t_dfops);
-- 
2.25.1

