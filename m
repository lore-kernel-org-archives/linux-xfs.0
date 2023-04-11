Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 286D5C76196
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 03:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjDKDh3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Apr 2023 23:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjDKDh2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2023 23:37:28 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5BE1726
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 20:37:27 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33AJkNua011796;
        Tue, 11 Apr 2023 03:37:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=299byPnRpYwp6Za4WUWdptlgxkgLZNaavxV/WlD6OXg=;
 b=lCT9392YmSe/lEpSkKlJcyqx6YbJminBfuMTuENaT8z4FaGt1JBaFUMmEujaE7fDfzAz
 tk3NnmiRWrzuPgOQrp7PBZsfFXIbSuR32d2P81YA0ZU9RV//npU1SAIYzRdyMqFoX+jc
 67wnImMWsS/hsr/SYHjMM1PlOuR9XCv42wt1LR9AO+w4flKDkfQxG76b+FJna5LiAMAH
 mp692ybPbvF31e87zOKgbWEspXWR7CwX55GrPgSaD08QP4e5uWx8WKcmQhL4EsuiR6Z8
 jZGwEWM3iBKueD1Cve43S3FCXsadOZQI+AgwjK84RKRQdvaVojRFZuSQvCwhluJ8yoEH xw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0b2v9up-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:37:24 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33B3OnA1019926;
        Tue, 11 Apr 2023 03:37:23 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwdn1gr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:37:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E+VqN22kb240ZMscnLsmql4P8Qack9wHfzrsWbyilVahn1pv4agf5ZJ9QO80ofPk3WpclIjlu8SucYEftPoxCkZ2SxVn4tPZY5ZglbUQh/nHqVNcHc1huB7Zua9Ga+UBscKNxFjNlsqjy0vHAtcqux/ehGkTaGX68xOuXPDp+9YMmmTsV8AxcNyiRmULXt35mxy4xXlSNKKWrY0GzLJrhw4VK1dAdS0Cc4n+tH86Z8M9NDJn9g9tp0/kCJp/ZrNZXFCSQ/+/pAj6NmsgNg0GsVotX5DjegHYjgCmY44IfAWRwsIVwD1nvB5aQyI3EXV8TtQT8FeahOX6o7wgU+Ajlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=299byPnRpYwp6Za4WUWdptlgxkgLZNaavxV/WlD6OXg=;
 b=i0qW+QFhcVWsSRRL0TViRpKB5Z8iUDL3Xk0OLHT4iryJWmoF3PBd+g+/Z64TanCn/ahcgolhOhuTIZf3sb0wU9FwElK/0tO7aEl2WinUPsxj2v6oDx0eIfI6COQzMjOh8V6+iepMLmxK/be3ZHg4bmyRjVDtCAdKNxPxfYFa7UAQQneLREUDa4Vr+EEpJs+INRq4XUXMCDNr3/6wECbX73fwzi9NsoiFX4TIEqr1dSnty5cxK6Fuv9gpsfDeVqfDF1eDPxEX8SMiMQrtSIja3VobDiW3PPfj8N7p7fGoJJTUg33o1czTznQa1P5CgLO5Gj7iNl8/XkImLbKimVTVJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=299byPnRpYwp6Za4WUWdptlgxkgLZNaavxV/WlD6OXg=;
 b=hIpm4vMN/EjZExOPZq7QHKLlEapUTeSJWmBVwSxcu91HkSFTexq4ovc0FgZMjZIbBe72HT7cFFX688YakodeQSGmtNaFP5CY778qQnSOb00I/DOwZ4n9DMzaqZM8xpFVCdRvVT5BeD0hJbW2rYxNxygWLxTCLDiZKcchgxdHqt8=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by BY5PR10MB4338.namprd10.prod.outlook.com (2603:10b6:a03:207::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 03:37:21 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 03:37:21 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 15/17] xfs: consider shutdown in bmapbt cursor delete assert
Date:   Tue, 11 Apr 2023 09:05:12 +0530
Message-Id: <20230411033514.58024-16-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230411033514.58024-1-chandan.babu@oracle.com>
References: <20230411033514.58024-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0009.apcprd02.prod.outlook.com
 (2603:1096:4:194::11) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BY5PR10MB4338:EE_
X-MS-Office365-Filtering-Correlation-Id: 65aad476-8ce5-4a9b-cc5d-08db3a3e0ef1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +1CBWZh9zE8EHVup32ZLRjcFdxTgtREYL8nvawXj/WmddxQJkP7g+B3nVzB9cPrnS2ZEU5lk7G/8zO1bpQK3Tgcjf76SIpUdKuB4oY/We2Fglwg1Co7wsHEHzqvFRORfwdm9NuBtPvDO8c5zIDCE/c9ibZ+sdhWjzllPiDgvnDJl57iNZoTP+myr0964Mv+7npXEC+vrHskT3UmdA+xB060lti9qR5n3Pn1dyG5oAwMN4RWuj0/krSH5DYMVd9AAOtyIzwV3cW8XW/8LFBYx/9LUjrsS/egux5OijCXFIa6RXKDsuckp1gQNdTJSaCF3I/8qO7xDBbMaY/L1nOXirLZKryiZMzJx3Sgob8X6pX6q8H+ndAN/gy7+X1mX9reQ2bfrMSgZRddqtokdWGtsSPvwvlGjZ2uWqqqHQ/WDcWail2ro3C9tNoGex47RjL9FprKmN7s6l21hVyaqMTEflil5PqXJ9ihqVennUdGzNd+zY/tZDIqVr1XX+XEcwd/0gOooAZ6+EApuJc+7lFvzRBwnJ0RCpQcIL5FqGeK9QbEuzZc2bbI2GBYl+2Lv4VNQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(376002)(366004)(39860400002)(136003)(451199021)(478600001)(1076003)(6512007)(316002)(26005)(6506007)(186003)(6666004)(6486002)(2906002)(5660300002)(4326008)(66946007)(41300700001)(8676002)(6916009)(66476007)(8936002)(66556008)(38100700002)(86362001)(83380400001)(36756003)(2616005)(66899021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jqmXx61nk5Wsqf66EEVzKtQFaG0p6cNGw1Nbu3s+rOPYvAj7jJvhNPtd8IVv?=
 =?us-ascii?Q?wVOZaxWLEIh6tTSmbhBY/w3dxtu+ophLV/upmJI0l4f9Qwd6UHHGkSkVmPjK?=
 =?us-ascii?Q?CvfH8gLh/8KZOZLiyPMKlxgcBNrYiWZrcMubIB3WrkdF2cXh80HA8+nvfX9+?=
 =?us-ascii?Q?sozEBD89+Pcxuz5TEaMCfZ+cNSSFSS0ahi5BQdYqFpdl3w3PphBhB2pi6jyl?=
 =?us-ascii?Q?K9fXBWrbGZ8rkGRF1txpGzvjH0ZzlCx5sYqORbDVq62IPWoXa47X0Q8qQyIH?=
 =?us-ascii?Q?GMFNJ6cjZHVrpDPoVxm5zTFBaai6fVVW6x8ZQaOLoapqHPkuDNeSmDeldEbf?=
 =?us-ascii?Q?klmapaPTbWKhGTGRdrP3CMZM24SSIFWN9ZmdXUXs5XbwErD89MX9g2mkJj+Q?=
 =?us-ascii?Q?iYtieTCoJiJstbmUYNNWgUgO95RZ45QIUWuz6C+fuBx4zzUfapDEyfK+8CM7?=
 =?us-ascii?Q?FZTy+xoNMlbbEkTG7re7O8RPmknVMLUOjg803tdnBBLX1hIrkV5vXwcoLAxY?=
 =?us-ascii?Q?jlgiCK9P/dIWiIuJFzQfBHxJkONNychCLXm8kxGzKDUONjVxxg85p/GIKRnN?=
 =?us-ascii?Q?YRSg0D82OnZx0ueHrwOEsbZrMmcQtB8Z4EJlr4FVfDkK/umt/LBe0OLpQnzr?=
 =?us-ascii?Q?khLzrHD25H1eb+5eWQVE634ZCYStYaXv6c7Gg8Wi9XBiJBLln6Y0p5wP2H0W?=
 =?us-ascii?Q?Qw6tbvHLszzswRCYbMDJh3TfBClViXWsynSeRYq0xNlUJ1YptF3NE5pElQvK?=
 =?us-ascii?Q?BM1SNbgKqwJqhZJxakLXdOyBFrqdRANuFhPzJ144CuQj5F5asyeJaUlgoJMz?=
 =?us-ascii?Q?DTVkTs6l0JqajwtgRB8c9RqTsuB5U84IFE4GXvIjSB1nIH6XxyHnhRCxsLMH?=
 =?us-ascii?Q?I7twZHGYXSz7z/EVMgolfXcWPKzQgLFJJdX6fw8WexkJpennPyroR8GcKAiy?=
 =?us-ascii?Q?wh2M92xa+7hvyMAqc+CilmAWaoO7hFQEgZa+APMlo9oi0wWy//RdRzPcU5Jw?=
 =?us-ascii?Q?LM0X6l7Z0E8RD8ap6rpLToy1yiF/jec3jiVRX7HHbaPhqLdGc9Rac6ILDCaE?=
 =?us-ascii?Q?GDy6YlObHjSteFbo/L8kY3l5JF5ZKj3YPeIehndQ/5+BAfTVQc5sp1zFxCdB?=
 =?us-ascii?Q?3/Y+fEcSCHqNOnGUm/i1YPFdcKlXcP+rWkyIsYVPf2va7AAMyGj0anDfEPjc?=
 =?us-ascii?Q?g5KxB6a8YQnamxet46Y30ffUnlqw2UuCvd6SAPGWmI0u+7W5Nmwi09s3QltG?=
 =?us-ascii?Q?ASf4FBM0uGcmbWgPgOB7oPO6NtKFcmkvRWgxTjDI4aVZFMJuhD9+vBJS7QCZ?=
 =?us-ascii?Q?KSgrQ8NCTU9k80EHYlvOodIJcZ+FAaD8ExSYwLD1HQ0KKyFQZCvzCi2ftQJZ?=
 =?us-ascii?Q?VeqKnWZrdgJLQiJ20A3G2FwhSczUWfrzXmO30nqQ8gQms4bldMFXE21T8ZRW?=
 =?us-ascii?Q?AsUoldPabQjyZvAzxjLFjmF3Nt/HCKfyUHWeX9LMcdSXUd9Z/jlVgXDL+OW5?=
 =?us-ascii?Q?gMWUu25NYX7gpf2sSywxzZIKtUFXlQZmGBYyKpo8OnoIEhmY04rosdzH/YSF?=
 =?us-ascii?Q?gLn6iM4rXf79M2xK1wPNUBL7iWCfZ1ho7Wl+nFxAAFJVaf5X0nLx1/7Gv/Rj?=
 =?us-ascii?Q?tQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: qXruFFv6cd4KpmN+B0+Jn8zjonjT0zBfl4PiQwNiYuglwk48f9b7rkGPgONnr4FR8ucUl3XuBMRq8k2nAmiAxzj3fY3ROHwCZAzuXhQtUYrbzJB0kWM37ssIfD7EfnVi2KuNrlA8u1eRbZSg9hVMof0FWPVOIARoXPaUNK47bgcp7iXebKsKrOpBFezqhjj7GVTHdaCUl+eeco21EoN/uR/ASl/WPEE8SlRz2xhRgzLuSWQRjYGrsuMp58KzEc+ElOSF812m2C20svaSX2Krj8CtjTg31b/u/Pq6KQrHMBk5Di7h+kaPkwe7cUSBGtnvTYh2QctRnDdalIuttZKe2LDjOdxHwo40nvQDBT699er8Yiu23xmyp7owxfw0OhL4YzO6+/WLquio8kCKAC+7H2sdIFiZ4YVWrSpPwUjX/3MwMISDiHd9DsI8GQZwOSHENNvnaSlfs9ZZiteICT+pvFarB1osa7QANjc5RkJtm9X5iZmH7oR6Ev0OfHx0F4mkMLB3XTOqfCcXwYDvUkmEBdqAKd2GLB7KSZ2ybq7pxvxLSM0499gIZqOJVQaaODwlIgN6J8NKPpB+8DWqLqjk0bKbUISxljxyIfKO3DArwzIHekymUfDlimSuimVptJHCMm9gMs5OP/aFY1wXDYe4qeu6bNDPpJDDgpBeeJTQwjZ7t6/G5wyw7jriiuFk5KfKz8DwzoUsLfQdh7Q1sw6zsx3jqa16/HEUbUEjdfJntSC6jNKjPLNNEr87zKh/s+VE5z/K3Zf9ihpN9U/KS5xKrAb72L+EPjf/VPkKEuy+yE999xP4+n4ErMZ2ZqtwGUEM
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65aad476-8ce5-4a9b-cc5d-08db3a3e0ef1
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 03:37:21.7022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hsae3pPf06sXq4O0tpNUSgcIZ8C5ANPN2neoAcaFr+CDy9URyUhOx9ei0MsOsOCXBBfsNNL6y33r0VyEUDkKdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4338
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-10_18,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304110032
X-Proofpoint-GUID: 1-GybFv4rBg2H7nQ7Ol4g5GIcxuUV969
X-Proofpoint-ORIG-GUID: 1-GybFv4rBg2H7nQ7Ol4g5GIcxuUV969
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit 1cd738b13ae9b29e03d6149f0246c61f76e81fcf upstream.

[ Slightly modify fs/xfs/libxfs/xfs_btree.c to resolve merge conflicts ]

The assert in xfs_btree_del_cursor() checks that the bmapbt block
allocation field has been handled correctly before the cursor is
freed. This field is used for accurate calculation of indirect block
reservation requirements (for delayed allocations), for example.
generic/019 reproduces a scenario where this assert fails because
the filesystem has shutdown while in the middle of a bmbt record
insertion. This occurs after a bmbt block has been allocated via the
cursor but before the higher level bmap function (i.e.
xfs_bmap_add_extent_hole_real()) completes and resets the field.

Update the assert to accommodate the transient state if the
filesystem has shutdown. While here, clean up the indentation and
comments in the function.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.c | 30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 8c43cac15832..121251651fea 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -354,20 +354,17 @@ xfs_btree_free_block(
  */
 void
 xfs_btree_del_cursor(
-	xfs_btree_cur_t	*cur,		/* btree cursor */
-	int		error)		/* del because of error */
+	struct xfs_btree_cur	*cur,		/* btree cursor */
+	int			error)		/* del because of error */
 {
-	int		i;		/* btree level */
+	int			i;		/* btree level */
 
 	/*
-	 * Clear the buffer pointers, and release the buffers.
-	 * If we're doing this in the face of an error, we
-	 * need to make sure to inspect all of the entries
-	 * in the bc_bufs array for buffers to be unlocked.
-	 * This is because some of the btree code works from
-	 * level n down to 0, and if we get an error along
-	 * the way we won't have initialized all the entries
-	 * down to 0.
+	 * Clear the buffer pointers and release the buffers. If we're doing
+	 * this because of an error, inspect all of the entries in the bc_bufs
+	 * array for buffers to be unlocked. This is because some of the btree
+	 * code works from level n down to 0, and if we get an error along the
+	 * way we won't have initialized all the entries down to 0.
 	 */
 	for (i = 0; i < cur->bc_nlevels; i++) {
 		if (cur->bc_bufs[i])
@@ -375,15 +372,10 @@ xfs_btree_del_cursor(
 		else if (!error)
 			break;
 	}
-	/*
-	 * Can't free a bmap cursor without having dealt with the
-	 * allocated indirect blocks' accounting.
-	 */
+
 	ASSERT(cur->bc_btnum != XFS_BTNUM_BMAP ||
-	       cur->bc_private.b.allocated == 0);
-	/*
-	 * Free the cursor.
-	 */
+	       cur->bc_private.b.allocated == 0 ||
+	       XFS_FORCED_SHUTDOWN(cur->bc_mp));
 	kmem_zone_free(xfs_btree_cur_zone, cur);
 }
 
-- 
2.39.1

