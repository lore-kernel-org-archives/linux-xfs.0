Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD5D2CE7B1F
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Sep 2023 09:54:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjI2Jy1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Sep 2023 05:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232746AbjI2JyZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Sep 2023 05:54:25 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87DF0199
        for <linux-xfs@vger.kernel.org>; Fri, 29 Sep 2023 02:54:23 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38SK9aHJ023061;
        Fri, 29 Sep 2023 09:54:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=eWbom9eYL0y9a6rpeLQnOYAW2IGfH7hjIZRS8GZ5zMw=;
 b=TUWsOGT4su9mOoj9WLDHdhzoAD+WN0FuwBrp+w9Ly2Z/l02z0MpS99tcE670ZZDrxH57
 Crg1JQlpA10KgZIz5C9p3ukZJPx6oDm20sgUI6cyHvUtL5+Can7MlmZidZxt3SygBSve
 zYoJQbDS0T41wBmu9zmzBaCLix3o1502xx1CbHHDcze+yARE/sKHMdtZ186jCD6sD7RW
 T0QJnv2PGRjS81kSrCU+V5aeeB0Cf5Qu0hCTfOnlwD2SpyM+ed7+MYPzYCETs+e0azXE
 R03atqxDv8xl5gnxqsRXXYPUoNKKC2jPO3A+WmKF6l/siZbOdg0mC4pYBAjws331XqtP 4A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9pxc6hmq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Sep 2023 09:54:16 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38T7bmIc025296;
        Fri, 29 Sep 2023 09:54:15 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2170.outbound.protection.outlook.com [104.47.73.170])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pfh231p-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Sep 2023 09:54:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iswwhlnqu8NPBw2XeGdvEKsBqd+WMEZm6MLBTh9swpQPyfb/cgl5Z/2phsrVuUzXiNS/mI3lM97s7HAuUxsSZ2U20euh1nYp6nejNQm7mFdecIRsxqHlhL8muQg+z99IuRI4c4kVDtl61uUwNZ4gbdTRyoq6UX5UYz61k/6flrLgUmYJJ7BiUFqUnKt/04kefABzWeWh/6BP+1WxoA92KC7UCDUYeUVhyvXFzIb+UX15fyqPXZzgBlmRIMwpRw2XZzeKP4FoQhUEXsMge5A+r2vVn+sa04E+sXUJ7FdNwW098A1rBXNAke/1u6uYllFTUkRCaixRO2N3hez522+TFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eWbom9eYL0y9a6rpeLQnOYAW2IGfH7hjIZRS8GZ5zMw=;
 b=JnTRpCNWKazdQyZBctjTsxzYzjvmkqpRo7QpFD0T6rJz2EsK9KI0T5rUxkajVcyqIV5Pqt8yX84CLHHBlGh++1nAn8WRvklFO/hvn7OmMmGgxNat1DYmGT3J0qlRbrcrhqTWEWlI1akVwh/JZCQuXT5pVJjva5XW6ycFBPARMSs7RJrFYoOGJmTqvLyjmCZbLNfmXwLrGwKbK3w1H7xWUc8kIDH3JwSIbaT+lyhxwpjP9dmTQr7+yLMZbba1/9tgMJhg1AgpcOGIs628r+CMIVSmrs93uaqrxAAd+ad1Wu0GfkAR+ZUfSQz4MG7pmWtNHM9xKjSq476DRtJX6mqHYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eWbom9eYL0y9a6rpeLQnOYAW2IGfH7hjIZRS8GZ5zMw=;
 b=u/qKddxQL9EP1q8Xnp731LC8PFry+PFG57AfCqXNFe17BF86d0cl3c1UvnwbQ5yqFBRvj1CeNtJ8cWfef3/5XVRPOZ1IONnzE01xkZ3bnoA8trGNqIMk+nmN0H0lcgFX0LzBAO8kNHMLuxomnGINS9lGH9/S4YD3yRGdf9Tgxhw=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB5742.namprd10.prod.outlook.com (2603:10b6:a03:3ed::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.21; Fri, 29 Sep
 2023 09:54:12 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce%7]) with mapi id 15.20.6813.027; Fri, 29 Sep 2023
 09:54:12 +0000
From:   John Garry <john.g.garry@oracle.com>
To:     djwong@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
        chandanbabu@kernel.org, cem@kernel.org
Cc:     martin.petersen@oracle.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH 1/7] xfs: create a new inode flag to require extsize alignment of file data space
Date:   Fri, 29 Sep 2023 09:53:36 +0000
Message-Id: <20230929095342.2976587-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230929095342.2976587-1-john.g.garry@oracle.com>
References: <20230929095342.2976587-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0003.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::16) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB5742:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e142ac3-7b9e-4e58-eb85-08dbc0d20661
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k7AMdGDEsM1+IwALflxQ6DfsRFZxVaeVJOuF6403ktYyCZs4Sc/VgJfzK/hjIme3aXhNmtLn4E9nwB2pl0YDkOxSLBuV6vSRBFrJBHJnKqHj0HOvq4schZM4G+u72h1oHv+WY764fCh6GyQffoccp0pI6jhjlfGQpZ8ZH1tupITSUZInPqCVoZF+DB9kD/8p6/E1C+zzgbW0JLxo9bnCxYmR1Ed8E2KKxu42qvMuJB2yA/fpF81THtdCRS7BKC0fynlxAmajuyFJ7ThMegOp4Or9SezFid8byybrPeLmcXmBGbKXcy/mUFcCFJy+qYG9XBZbthusd90apItUwsD+BdkK8eXrn1k2pHml8F0P+DUi+zuqUvYQ/jaySwoiQz0kvnT1FTrSN4CCGO5P26gfAg0Cu5RRxQxNJFWACh6XwQnPDIKMIhW7qR8CIWrDkmu7xtNG5pT556TQMrXxP/TkUYreBM+06DNiWQGtszer7fmrAfqiF6sMH8xaK98hncv7dPSNIttlz/uyZW0BbWQ1wJ8gOXEDAk/64wmOccMT83GxL+Uyo+cJstkJ+E0jL/a6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(376002)(366004)(39860400002)(346002)(230922051799003)(451199024)(1800799009)(186009)(64100799003)(2616005)(5660300002)(107886003)(4326008)(8936002)(8676002)(6512007)(41300700001)(26005)(6506007)(1076003)(83380400001)(38100700002)(6666004)(478600001)(316002)(66946007)(66556008)(66476007)(36756003)(86362001)(103116003)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KaNgO/icLCc72QhRx7G10ZBt8sQ54XvRI1gQE8HdA5UENRTWTqnjGyYkEOiM?=
 =?us-ascii?Q?mQn9J/AT4/cGSQLrBapTArGSS4LmRkQqD/kvw9JfpEAKGFk7oQGX9diDo8pc?=
 =?us-ascii?Q?0ySZ7DsvaVpGqTdc35qGX+SCrnBfNNCYf3Gt/Bxu4h9qVBNbXgxeU/FyrC+R?=
 =?us-ascii?Q?vAqg+CZg9lDkqgD/SgkJEZQkj3KYQcSOkE3sa2vUujGZtB6n4vMf8a9y48v7?=
 =?us-ascii?Q?/3PrnFckeMMe5mHk5rZGYZODqOoIjnWpklV0XdIHlrXKD45rqFP1ZOb3Gcr3?=
 =?us-ascii?Q?+6LCXvYOA4Z8S+6j8V1c5Zt9mpmpQWVQiENvMELYCMUQ+Nap7y7Blbm708PT?=
 =?us-ascii?Q?Oft7G4DMCPlgAEPjkeyl95L1o1sKjlYWsNGS+Rr04YRB3WRg1x04XTNFECw/?=
 =?us-ascii?Q?4Bo7B+tMAxLhNdIYJof/xhjqZIai1sA1o7b2s7D3lCmap5iKaphQrWUSTyNn?=
 =?us-ascii?Q?aw/2KguJ+pbhJQTB+NLx0R8wiKnjhmytOHFXfIzp1gPMWqHRGfXwkCKj25e3?=
 =?us-ascii?Q?uOpdwSRggzfCt46VeCvc6Z9eEQYZGOt1D8HuGOf35VF4C5Z9U+Y30l7foEEk?=
 =?us-ascii?Q?9UaONTFYnIL9e+qC08pGc1B3AwJWjT4ryBhppwGOKpA2hebzeW241J4lDEfZ?=
 =?us-ascii?Q?1vpJNfpSugkf2cKckS30jdVH2bOI3XMS61t+oKECx4gFYSPO4tDdSgxPuRCS?=
 =?us-ascii?Q?7AygBgJxzg4p1yz+67MeQc8jotrvuTgZGap5FSVnpioHRIAmuuyL6Cd9V6Ek?=
 =?us-ascii?Q?twVCHsSSHbsWAi2nwZb0mQ0FMTdl11cX2i719PG44Ug1/6I8Vv7cwlsXDsF/?=
 =?us-ascii?Q?fwOYbIu3+o0euTw+L5W3RRAwtgJagFiBznwkqaw4BXiy+k4mWtbvzk2/Uve2?=
 =?us-ascii?Q?CbVg5nRKsnxvVChemLXd3rfYFCS6SyTbfawLxUc96HlK9Pld4fd8+B0S8hDM?=
 =?us-ascii?Q?mIIz4NhX2lkuYQ15A7/0mxPOzkGhQAkUOpb7Avc6fmDtWZdhuOPNyDRHl0Rf?=
 =?us-ascii?Q?Ff7PC2RuTzpeuleopsJQJY+Gp/tQQXDB1i6LbvRf7BpQppVCqLYEwK9sbmjb?=
 =?us-ascii?Q?4LXgjCRjaQamsiKoEP8j8WHZlQ8nUaxBgkq1h4W1n5+gz6eTmqoLyy/HZSQJ?=
 =?us-ascii?Q?LXiz0NMzehc1YD5Z7A5jDEkFwZ+PbJ6dLu26a9pHpeLW7qQE+fqaVEuUBL1O?=
 =?us-ascii?Q?4Lhj7rhs6gxJj32x342s2FGy+zaH3YIL9n0qMBaB3r+VMpqmKLq/pQANSK4o?=
 =?us-ascii?Q?W4QaCzFYv0VbDp9xksFanPLCsIHTStDJELdwXvc5emSmHZX5dRMXKrYX7EG3?=
 =?us-ascii?Q?8C9K3oJ7xc6OHDOJFWHTRgOeL/ZAt8jzMGCtdEsGju/kcw+loFFjEvl4KoF5?=
 =?us-ascii?Q?7N+RxOsr4pN86ZSxcCOIVHWOkbHDS5wLvcJw9z+ZPgALh8KwW/qPMneoXh6L?=
 =?us-ascii?Q?vzgXfulX+Q/YT1vvSDbBoi/nIpg7WTnvQRsaLWKzcpz6QmzTcI51DSbtRfj5?=
 =?us-ascii?Q?533mC6tBXDHRJRS/MFMddn5BK0lcZrf2x34ViniR9rzgA4PmOM8b7KXRL8lO?=
 =?us-ascii?Q?dvV69yFEzd8tZNjkWHKWlDyedWuaSs7kNOAc0rLHBCasaDUEZ5CrOQRTF47u?=
 =?us-ascii?Q?uw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: fnHrVdyL+/aYDh8gQFqeTXD4ysaW5h4BViTl3oHa3Wj1/oqfvxzlHywLd61b93JvamjdVuq02VypnPmlhxz2lBkkaiQMgQS8ItpE+Van2rpO6q96PZDjMU7NzZDFPg8UAeo5sT7ApgAXu9+3okRu+4DLnVf5k9pUhXwVR5zPO2nG28v9S1OI+KOqvlwYjySlgusAJfQo/rbrt0Xmx66TkwkddtRvOUZwjcUIzKAHfUAKkD8nWdRMIcEwfgK2r+6c9x7BL3nwFBy5/4Hv0YutBLfBdAfjr3o/gO3Uc6tyeqDUZ+LQeYV7emnmtETlQJu0PJoV/KSsqg/XzUEw9E3iLOeRO6EK+LJH1DEOfEEQLfjnX01ssL8quW4ZSSRQjkcZeIrqkS4bY8X1Lahzrmmk3/nRwg0guc/ZmeBDf/kh3I+L+R9HxJM6SG3tBy23wbqiP59EDtEG4idHSeuJInhgslR6WY9cvadRbdlnbf9+2MzXZ2A6XMxsL7UOnYvsMhD1vQtUJU3mZ7pPwgeZJofmw7xK1pXGrYSZNz2sEaMnIi7+7jjeECkZLS9kCeIaCZWKPkuubNwP0n8yWs+8KvfjMaXQP5UfaRJSP3xecC/BA6gumd5qQfI91KKUyWRlgKS2l50SC3vvpFNtw3l+s7UArXhO7wCijAV0jMh3R7ufb4TN6xkCnYPnnCiISSd6A5jdHeZSycbTLbJ8m+h6X4TDomh9erPXAHj3Y6ajZ/3jo2GBRkpzm0m/B2mRyVZIZmhJoKkLKDfm9n2PgxLFs0AtcRffk6NMu2yq1Ma1/r5kqAwVM+7TeGxv0ang0kfSyN2XRveeUwrfIRJWta6W96kdfw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e142ac3-7b9e-4e58-eb85-08dbc0d20661
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2023 09:54:08.7419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h1THJKJAGHskNGBpEh5TGXixQ4WAaUB4MVmi0HrgUbr9UHI1+bc55TnbiqKy0C3DTxc5oZpwRGktN4lRx19AeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5742
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-29_07,2023-09-28_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309290085
X-Proofpoint-GUID: ZYNAYxBvJ4mdNzExpnh1O7ZSM36SBODS
X-Proofpoint-ORIG-GUID: ZYNAYxBvJ4mdNzExpnh1O7ZSM36SBODS
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

Add a new inode flag to require that all file data extent mappings must
be aligned (both the file offset range and the allocated space itself)
to the extent size hint.  Having a separate COW extent size hint is no
longer allowed.

The goal here is to enable sysadmins and users to mandate that all space
mappings in a file must have a startoff/blockcount that are aligned to
(say) a 2MB alignment and that the startblock/blockcount will follow the
same alignment.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Co-developed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux.h        |  5 +++++
 include/xfs_inode.h    |  5 +++++
 include/xfs_mount.h    |  2 ++
 libxfs/util.c          |  2 ++
 libxfs/xfs_format.h    |  6 +++++-
 libxfs/xfs_inode_buf.c | 40 ++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_inode_buf.h |  3 +++
 libxfs/xfs_sb.c        |  3 +++
 8 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/include/linux.h b/include/linux.h
index eddc4ad9c899..05dde8723c15 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -251,6 +251,11 @@ struct fsxattr {
 #define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
 #endif
 
+/* data extent mappings for regular files must be aligned to extent size hint */
+#ifndef FS_XFLAG_FORCEALIGN
+#define FS_XFLAG_FORCEALIGN	0x00020000
+#endif
+
 /*
  * Reminder: anything added to this file will be compiled into downstream
  * userspace projects!
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 069fcf362ece..7aea79ab3af4 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -233,6 +233,11 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
 	return ip->i_diflags2 & XFS_DIFLAG2_NREXT64;
 }
 
+static inline bool xfs_inode_forcealign(struct xfs_inode *ip)
+{
+	return ip->i_diflags2 & XFS_DIFLAG2_FORCEALIGN;
+}
+
 /* Always set the child's GID to this value, even if the parent is setgid. */
 #define CRED_FORCE_GID	(1U << 0)
 struct cred {
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 99d1d9ab13cb..d31fe38f7c84 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -166,6 +166,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_BIGTIME	(1ULL << 24)	/* large timestamps */
 #define XFS_FEAT_NEEDSREPAIR	(1ULL << 25)	/* needs xfs_repair */
 #define XFS_FEAT_NREXT64	(1ULL << 26)	/* large extent counters */
+#define XFS_FEAT_FORCEALIGN	(1ULL << 27)	/* aligned file data extents */
 
 #define __XFS_HAS_FEAT(name, NAME) \
 static inline bool xfs_has_ ## name (struct xfs_mount *mp) \
@@ -210,6 +211,7 @@ __XFS_HAS_FEAT(inobtcounts, INOBTCNT)
 __XFS_HAS_FEAT(bigtime, BIGTIME)
 __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
 __XFS_HAS_FEAT(large_extent_counts, NREXT64)
+__XFS_HAS_FEAT(forcealign, FORCEALIGN)
 
 /* Kernel mount features that we don't support */
 #define __XFS_UNSUPP_FEAT(name) \
diff --git a/libxfs/util.c b/libxfs/util.c
index e7d3497ec96f..58b6a85562a2 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -206,6 +206,8 @@ xfs_flags2diflags2(
 		di_flags2 |= XFS_DIFLAG2_DAX;
 	if (xflags & FS_XFLAG_COWEXTSIZE)
 		di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
+	if (xflags & FS_XFLAG_FORCEALIGN)
+		di_flags2 |= XFS_DIFLAG2_FORCEALIGN;
 
 	return di_flags2;
 }
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 371dc07233e0..d718b73f48ca 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -353,6 +353,7 @@ xfs_sb_has_compat_feature(
 #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
 #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
 #define XFS_SB_FEAT_RO_COMPAT_INOBTCNT (1 << 3)		/* inobt block counts */
+#define XFS_SB_FEAT_RO_COMPAT_FORCEALIGN (1 << 30)	/* aligned file data extents */
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
 		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
@@ -1069,16 +1070,19 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
 #define XFS_DIFLAG2_BIGTIME_BIT	3	/* big timestamps */
 #define XFS_DIFLAG2_NREXT64_BIT 4	/* large extent counters */
+/* data extent mappings for regular files must be aligned to extent size hint */
+#define XFS_DIFLAG2_FORCEALIGN_BIT 5
 
 #define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
 #define XFS_DIFLAG2_REFLINK     (1 << XFS_DIFLAG2_REFLINK_BIT)
 #define XFS_DIFLAG2_COWEXTSIZE  (1 << XFS_DIFLAG2_COWEXTSIZE_BIT)
 #define XFS_DIFLAG2_BIGTIME	(1 << XFS_DIFLAG2_BIGTIME_BIT)
 #define XFS_DIFLAG2_NREXT64	(1 << XFS_DIFLAG2_NREXT64_BIT)
+#define XFS_DIFLAG2_FORCEALIGN	(1 << XFS_DIFLAG2_FORCEALIGN_BIT)
 
 #define XFS_DIFLAG2_ANY \
 	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
-	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64)
+	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64 | XFS_DIFLAG2_FORCEALIGN)
 
 static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 {
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index cbcaadbcf69c..d6ad361ea893 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -601,6 +601,14 @@ xfs_dinode_verify(
 	    !xfs_has_bigtime(mp))
 		return __this_address;
 
+	if (flags2 & XFS_DIFLAG2_FORCEALIGN) {
+		fa = xfs_inode_validate_forcealign(mp, mode, flags,
+				be32_to_cpu(dip->di_extsize),
+				be32_to_cpu(dip->di_cowextsize));
+		if (fa)
+			return fa;
+	}
+
 	return NULL;
 }
 
@@ -768,3 +776,35 @@ xfs_inode_validate_cowextsize(
 
 	return NULL;
 }
+
+/* Validate the forcealign inode flag */
+xfs_failaddr_t
+xfs_inode_validate_forcealign(
+	struct xfs_mount	*mp,
+	uint16_t		mode,
+	uint16_t		flags,
+	uint32_t		extsize,
+	uint32_t		cowextsize)
+{
+	/* superblock rocompat feature flag */
+	if (!xfs_has_forcealign(mp))
+		return __this_address;
+
+	/* Only regular files and directories */
+	if (!S_ISDIR(mode) && !S_ISREG(mode))
+		return __this_address;
+
+	/* Doesn't apply to realtime files */
+	if (flags & XFS_DIFLAG_REALTIME)
+		return __this_address;
+
+	/* Requires a nonzero extent size hint */
+	if (extsize == 0)
+		return __this_address;
+
+	/* Requires no cow extent size hint */
+	if (cowextsize != 0)
+		return __this_address;
+
+	return NULL;
+}
diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
index 585ed5a110af..50db17d22b68 100644
--- a/libxfs/xfs_inode_buf.h
+++ b/libxfs/xfs_inode_buf.h
@@ -33,6 +33,9 @@ xfs_failaddr_t xfs_inode_validate_extsize(struct xfs_mount *mp,
 xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,
 		uint32_t cowextsize, uint16_t mode, uint16_t flags,
 		uint64_t flags2);
+xfs_failaddr_t xfs_inode_validate_forcealign(struct xfs_mount *mp,
+		uint16_t mode, uint16_t flags, uint32_t extsize,
+		uint32_t cowextsize);
 
 static inline uint64_t xfs_inode_encode_bigtime(struct timespec64 tv)
 {
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 1e71d43d0a45..0c31cd062d63 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -160,6 +160,9 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_REFLINK;
 	if (sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_INOBTCNT)
 		features |= XFS_FEAT_INOBTCNT;
+	if (sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_FORCEALIGN)
+		features |= XFS_FEAT_FORCEALIGN;
+
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_FTYPE)
 		features |= XFS_FEAT_FTYPE;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_SPINODES)
-- 
2.34.1

