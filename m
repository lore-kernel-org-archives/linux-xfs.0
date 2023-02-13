Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1503FC636D7
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Feb 2023 04:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjBMEGu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Feb 2023 23:06:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBMEGs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Feb 2023 23:06:48 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74577EC57
        for <linux-xfs@vger.kernel.org>; Sun, 12 Feb 2023 20:06:47 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D1jUdO028861;
        Mon, 13 Feb 2023 04:06:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=mlQ7XTH8V1AAd8Au6Ti84A5yQOE4NoF+z2kS/An4LsM=;
 b=YSQ05BVO5TRR6QO/zvqoHfQyYUMbmW9RdxChVDvFiOSMZ1DeRK1mEXoDBTS0tA+M2+8s
 n1RZg3FE6x7nLYFDGJ0+jOLHpx5+CDrWY8JrXeYN8jNj81I1mZKO9vTTzi/oLXm7/HxI
 Nni1KLlC9KMTFwgzf16zB999NJetNjRtEwVJ0sbYRBZuPAANfcuS4vHUg0fcvSzL3f5c
 TjSekeo18LDtURAzCFKIzWs2HqGnLeSjtxWUUKvPn/YBj23La1YFT+yEFnFtcoVcsx8n
 YM3sNWA71+s5YtBzcB8+Hbq53dM4Ens4l/jAe6EEIS8oJETlEh9u+PpVQvHv9dp/1Vu0 7g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1m0swu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:06:44 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31D3D1p2032611;
        Mon, 13 Feb 2023 04:06:44 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f3k1hh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:06:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zc8ETCIE8ksJRS69ekfvCNJQEq1gThK1zb4OGC3IlqSVj4ic+TVxVBF4kO2547BM1fI3xIPVs6BBUEaR6mOEIwpENGz95u+7yZs0ERSEiPJHQPJlfLrOwX+/eDp4My3MOMY1FdHOHNDZXy42a29zzjPaWcFxc5G6+950EPkpWdEziKWXKpfsfIAdWLDqzfCfZhtJ7CPBIVoeOkRKhDxECSxaiEF/aTNkiLR6u6Mil8SkTZSTVn3cB1UHf4k3fRtRGpzpp+ILyclhzDJQWfybfer4bJelQ+3vZDPLFfMpMG//pu05ObSaBJz+neuxBzjF2NSbgm0PdenzQ9tat0Pt/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mlQ7XTH8V1AAd8Au6Ti84A5yQOE4NoF+z2kS/An4LsM=;
 b=gi9pNfllHwg/xpXF/gzGb0dGbDPx3m6a3NXvFsUJOymNZFF7FVmLi7AKvBcvlH6Cxpbh2O1J53Lukg0K+5wNsgaALEFkE2S2yomzDBPREPD7chGoyjDLUnGKYalA29RwLup5U+MOSJEqT8mmA6wjfsV4RWeTFj5kiKZ4CnAgL9WEAyrwBedKrn8R6xMubBiGbC1wclKezcya0cDbjPmfcNiNpfYPdIJWp8hJiK1vZQX+Ox46xH2dYbVpIPe0scpaoLD63SQ+CumR3bho0jZF1SqEV2vouafLIJXlI7cSfYUILq+ldREkHDjM41tFFU2IUcaIEoOlgbEixHxqbceBKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mlQ7XTH8V1AAd8Au6Ti84A5yQOE4NoF+z2kS/An4LsM=;
 b=WvD4NmMmywNNhk/iOLswRhfOMjrCRSBUXb42m0MtIkeKuVtGs2uF88x7Tijl4EylJuTK7P78t+eAxkBxkNlS2p2JN4saFXRAGm5jJhps4fn39BJGMEaTuhGyglYgsRS/Pgy5VavDOZwAJjfQ6IO1Ga3gRot4QNuDFPKgSZVAmFc=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH0PR10MB5225.namprd10.prod.outlook.com (2603:10b6:610:c5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10; Mon, 13 Feb
 2023 04:06:42 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.009; Mon, 13 Feb 2023
 04:06:42 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 14/25] xfs: clean up bmap intent item recovery checking
Date:   Mon, 13 Feb 2023 09:34:34 +0530
Message-Id: <20230213040445.192946-15-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230213040445.192946-1-chandan.babu@oracle.com>
References: <20230213040445.192946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGXP274CA0021.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::33)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH0PR10MB5225:EE_
X-MS-Office365-Filtering-Correlation-Id: 2949744a-6541-4146-1bc6-08db0d77b6a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y0cFhErnX5+F2/Y9L7XaGIor40ak7/D7OCu+Fs7acxV6NqUFy3me8lNfdbPXZJ15ndI+eioHMRj65pwHmxM57LjwMxiv1AmQnYudnkvN69ciJ9iMW3N9KQF/fWETNe2rx98Gnj1ffFoVMKfj5EPjB29LGfhIjYCTenX5her4buWRdPyZCm47apTAYxSfU2/jgXBaHFZvJ3nqPRLQhQq5gGqycdviGi6nMVEye0EL882zEEcXMl62ZYyijakbXLiALPr+TX/hmJF/cZsbI5pa3MePYBYeJJk74ee6wGPg80ZtYj25dKdloOMZLx/vxtHMBfVFHuQhM7VcUlM0Lv+89qx9mdgLUmk+apI1LJm9CnIDOLcQedx1coDBXRRQTPnXA9Un+qsjYbyCA/Zlk0QeNr4Uv4g5etzKCCKPKkSTWmx0xTnWGhUgY6GMafWcTk5QPFzZHML2Ml8m8b+BXUpHx1EivSAGVciNMll4IEDYgQMj5Ls3P5ZKHi+jx06RzeVklrv6wkjlwPA78KtupDg1Aga8PnRoaw5owlOP42EdoV6nlYvhgTUFMvPk6GB9MUux1a6NeRYJcSZ4/jyaXmBWPwQFRtdcZ6sn3wzwwCVJhmkCiHbj1KQ44XPrx91eKqHNeKWwgmTEZlHos6/sW/IXzg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(376002)(39860400002)(136003)(451199018)(2906002)(8936002)(36756003)(5660300002)(86362001)(2616005)(83380400001)(6916009)(4326008)(316002)(38100700002)(66556008)(66946007)(66476007)(41300700001)(8676002)(6486002)(478600001)(6666004)(6512007)(1076003)(6506007)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V1pROvtLG4Wp4p8qUoaWkOgEoZwxx+Wb/mVl7FNK1MF/HZUqdrUPhFPVTPN+?=
 =?us-ascii?Q?bjyFuzJTXMZmYERptH85N4KFwdewAbKoEEQ7O5bXKsqtZ8rJMiiLxn495dVg?=
 =?us-ascii?Q?iC+DznQRf4I4ANCkxAqUAo7Jp+kaqju8tNxRqtVGeh8BU7CjJdGqasCQoh5X?=
 =?us-ascii?Q?5yOr81T5D8O7y6ZSp2b5KA4JIhmp0lXIyJUi2WT96tQRbeI5I7b32fxiJed0?=
 =?us-ascii?Q?dllky8biix4uhX3AbvnCz5ZbNbtJpT5Xe+M9UNszf1IBzAwTSLfS6XYvrnWq?=
 =?us-ascii?Q?ZYhSJt32a+1dY0tbigFhe4jwcxwes4z4sAUoUSXS89IdXWBunYtU1EMIgsc9?=
 =?us-ascii?Q?+L5RTnDFo4gy9G8NIpJ1VWThWVhuhIwtoPV9p3nh1yH4QniFr3Fs9D7mC1kV?=
 =?us-ascii?Q?I+HvSB3CIIcq7Jtz0Yv0gBsbGDMd8YpwYG+mSWVcAylWJ4p8h58FBaifcK27?=
 =?us-ascii?Q?vmfkRfNGuBucJrm90ryMlcXgTluQmhb4qcxZtYuapgoV+8EGo0W4RqYswVRf?=
 =?us-ascii?Q?sYS411YS2vGlz5KXnpRec2aYiePd/RnsQ+wF958G9+CfuDuclF2SuqXTWueg?=
 =?us-ascii?Q?OhJ9lvMJYNkRQ0yYcj6vVtSmhBk6krhwkEfS80zVjPHqiHEYzAXwi9PYKW9i?=
 =?us-ascii?Q?9boRYbDWBb8Z21khf7attqxH53OscArAu38RSYy6CdtCL8+INdn4z8DBEVjo?=
 =?us-ascii?Q?EhblH64S/29W+UbZj1OfBbzGr7EnHMuXv8YRibEcLGP9anAuaCRlLNrvLkmj?=
 =?us-ascii?Q?p5KjlHAIP5+tNPBQX2u3qUWSw7afbYSNOaN0PkxLNADMtjWP9o+9nadLQ8Xg?=
 =?us-ascii?Q?NeLuK/xIk/N8+3In6j3urSKCMRKp3ChDHDfEWT0UhnKRm9i/t6LiSZ5tWMWQ?=
 =?us-ascii?Q?4xg5/f0tSogeXrSGClF4n3U6l2QB6g2cXipAYvlc0pJ2xg9RG6vcthkXjOxX?=
 =?us-ascii?Q?eFUf2SsgPz6lPe96dfo7Q42yfmiaIMHLukJyQqnhu+7IMNP72Fo07JHtaM5L?=
 =?us-ascii?Q?WUr4mTkDiHdx13/CrHbJBQ1vc+9PL6vk6lQRbt/WuXSWnA7PbiXxz+/7yAY7?=
 =?us-ascii?Q?5A1SbHj633XHEZoyFtDL276XzNPErKoHl0YQrZHohA+lpTpxTwNYENuT+INc?=
 =?us-ascii?Q?CeMxo6YEj/C+uPlvTwxx3NmTWHjsBP7afbExO68e2O0MjSOHNSF4T0vkRvpz?=
 =?us-ascii?Q?Ztzr1s5ZXBJvfCiOFHp0hGZtCFmS5GYmkmoixYHIc4bvsDZIPsdJcGCoUqbg?=
 =?us-ascii?Q?11oOJUVxlXPYtyUoSAwAzUsIBWq1n19F/yzh5+/dfpJ7qh51YGC/rDoG+N/C?=
 =?us-ascii?Q?bsEmD3pw6PW2p49mtgqxptmCfsSDuDegltG13KBZSYLOO7Ks9EGPre2Maby8?=
 =?us-ascii?Q?uEFwRkDCRRZnEyTKM4ePntOjMTVUsazkjkB2EOa36igeAlqbqiOLmaSdRb2o?=
 =?us-ascii?Q?/Bol7xthPCwnMDnbzBwbmcPExyqpHwHGR/gKC5xCEVto6VlNgd77wo4KI+UF?=
 =?us-ascii?Q?yXCpr5Ymmm77Te5oacUfgFaSkg4HUx3M10B3qs8OIm41B5+xJas5TnPNYFmC?=
 =?us-ascii?Q?PGiyNInXJYkuxw7tkiMnObUjBrGqUA2XaFMnVh1qrKsPMfpynKB1syMIaKsW?=
 =?us-ascii?Q?MQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Vdbo+am8/f17rAHld0Ss3xXZrs+ORYWaTWIKcM0FaFnN/cIdqoHAOc4vhvk5vYrGz9Y7Wu5NTdA4ZdY/jcNwzi00zXxgEAmVy1DMPi9YFH/HG210z6zYixUbQ1+ieUDjUgMOwZUW5lc7do9SOl5/GFOm3HSsa+AXXxyRxn4mCiC6w8byhbvaGeUmfOPLzGNw7cTRL76FrzxUTOMlKfz2qPG25FwMPee0Kc6Jcbl1Onln7Fv//eHykZZ0tyFZ46zSG40AqQ9ThjP0igugAB1BvSuB/D+GEQ9kvEvJ8FgizKJQyQmOof9WoHRWET4LjtVx9qPrpnyOJvj8i9IJ5N32HTXHjdX8N5EexIMfVLnqNDQBtUdvCuVIfJ2+mY1fhaolg/DxffzvVOIYttAviZI5TzJyI0heuug4vsGPawHV2rdABmhr0lsBra+gC9F8diOIqt3OOVM0i4KJfdmDlZf9O1AeaOqyp7jIkFC+KrgaRw9OmPsj6PmwL93dVX6ON7dMHRCF+848I0Dz7Kt6W49gOxfnPA+qQOzr1VjARpwfXn0mmcMCLzmawoKessSyvGmvL3v/XT7E7Wvb3mVZzVZqYnnmNpUPoM1zBSu8/AnVM+FvlZjigCALhmMjGeaus5f2SdAHhhqCpHZ5bv/dMd7343gb1VwadTHx92CYDm0SzhL7rmwTSGmOGt6SsExYIG3RcjBIwJhtsm9u68Vx3G8UuBcx67JO6ttfq6vIXXBuex5BeNAHqn9uU5WuMPeCktRPt0/LhreBex7qM6mDrxIiO6JdGvautOe7Uz5enBzuE/SA7xwLkLJo0lkj/OaGNoJc
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2949744a-6541-4146-1bc6-08db0d77b6a7
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 04:06:42.0824
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pq/cmgtWdPGFWcYDZmwQ2eMFohlDgLylXgug8MqSKPWFGxmBmlhvjs8wvSwoOo6RIOmQpS5SkHVLbRjAXIuYHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5225
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-12_12,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302130036
X-Proofpoint-GUID: z2JSpgTbhNVyijsro-Z6VxjIflAG31qQ
X-Proofpoint-ORIG-GUID: z2JSpgTbhNVyijsro-Z6VxjIflAG31qQ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 919522e89f8e71fc6a8f8abe17be4011573c6ea0 upstream.

The bmap intent item checking code in xfs_bui_item_recover is spread all
over the function.  We should check the recovered log item at the top
before we allocate any resources or do anything else, so do that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_bmap_item.c | 38 ++++++++++++--------------------------
 1 file changed, 12 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index e83729bf4997..381dd4f078b0 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -434,9 +434,7 @@ xfs_bui_recover(
 	xfs_fsblock_t			startblock_fsb;
 	xfs_fsblock_t			inode_fsb;
 	xfs_filblks_t			count;
-	bool				op_ok;
 	struct xfs_bud_log_item		*budp;
-	enum xfs_bmap_intent_type	type;
 	int				whichfork;
 	xfs_exntst_t			state;
 	struct xfs_trans		*tp;
@@ -462,16 +460,19 @@ xfs_bui_recover(
 			   XFS_FSB_TO_DADDR(mp, bmap->me_startblock));
 	inode_fsb = XFS_BB_TO_FSB(mp, XFS_FSB_TO_DADDR(mp,
 			XFS_INO_TO_FSB(mp, bmap->me_owner)));
-	switch (bmap->me_flags & XFS_BMAP_EXTENT_TYPE_MASK) {
+	state = (bmap->me_flags & XFS_BMAP_EXTENT_UNWRITTEN) ?
+			XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
+	whichfork = (bmap->me_flags & XFS_BMAP_EXTENT_ATTR_FORK) ?
+			XFS_ATTR_FORK : XFS_DATA_FORK;
+	bui_type = bmap->me_flags & XFS_BMAP_EXTENT_TYPE_MASK;
+	switch (bui_type) {
 	case XFS_BMAP_MAP:
 	case XFS_BMAP_UNMAP:
-		op_ok = true;
 		break;
 	default:
-		op_ok = false;
-		break;
+		return -EFSCORRUPTED;
 	}
-	if (!op_ok || startblock_fsb == 0 ||
+	if (startblock_fsb == 0 ||
 	    bmap->me_len == 0 ||
 	    inode_fsb == 0 ||
 	    startblock_fsb >= mp->m_sb.sb_dblocks ||
@@ -502,32 +503,17 @@ xfs_bui_recover(
 	if (VFS_I(ip)->i_nlink == 0)
 		xfs_iflags_set(ip, XFS_IRECOVERY);
 
-	/* Process deferred bmap item. */
-	state = (bmap->me_flags & XFS_BMAP_EXTENT_UNWRITTEN) ?
-			XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
-	whichfork = (bmap->me_flags & XFS_BMAP_EXTENT_ATTR_FORK) ?
-			XFS_ATTR_FORK : XFS_DATA_FORK;
-	bui_type = bmap->me_flags & XFS_BMAP_EXTENT_TYPE_MASK;
-	switch (bui_type) {
-	case XFS_BMAP_MAP:
-	case XFS_BMAP_UNMAP:
-		type = bui_type;
-		break;
-	default:
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
-		error = -EFSCORRUPTED;
-		goto err_inode;
-	}
 	xfs_trans_ijoin(tp, ip, 0);
 
 	count = bmap->me_len;
-	error = xfs_trans_log_finish_bmap_update(tp, budp, type, ip, whichfork,
-			bmap->me_startoff, bmap->me_startblock, &count, state);
+	error = xfs_trans_log_finish_bmap_update(tp, budp, bui_type, ip,
+			whichfork, bmap->me_startoff, bmap->me_startblock,
+			&count, state);
 	if (error)
 		goto err_inode;
 
 	if (count > 0) {
-		ASSERT(type == XFS_BMAP_UNMAP);
+		ASSERT(bui_type == XFS_BMAP_UNMAP);
 		irec.br_startblock = bmap->me_startblock;
 		irec.br_blockcount = count;
 		irec.br_startoff = bmap->me_startoff;
-- 
2.35.1

