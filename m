Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29A0DC433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Oct 2022 10:29:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiJDK3o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Oct 2022 06:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiJDK3n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Oct 2022 06:29:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112C420E
        for <linux-xfs@vger.kernel.org>; Tue,  4 Oct 2022 03:29:42 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2947Uihi000851;
        Tue, 4 Oct 2022 10:29:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Lk/g3M2G2amE+n6rpBJVoKI+E5jgP7Suy74Yn1iQHl8=;
 b=DftmnTkoSWwMthPZDJyFO4Fpi/GU9J6h3glbSJaQb9A1HzOMpybmw65cLu14rFH5pg7O
 lMDM7sxGbYDbZ1tLGZWAPDRb+GJX0Y/VvhjYpeo48LdLExiexeT0T1dP6V4SeDFG4c0z
 Ux19tnlZdYeZaPwDUkcfxq0G8LxAZSQPBoHWUktnhFSHJexovU+wGs/dVgbOYMOiiKfr
 DtJ5MaYZXpr1N/qBDeCoD5QL8dN6Vl3tD0x7zUyVmdRpndTZOmu2qCiVIKNoUjT9H0LM
 r09BEKXXUihzqN1/utwhkxXZN+rL8WLVsNrDACF5QEBuzV+XgyTKLRIj6sY3vy3YbbkU Iw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxd5tdxfx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Oct 2022 10:29:37 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2948AYvX020157;
        Tue, 4 Oct 2022 10:29:36 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc0abhrj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Oct 2022 10:29:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZMB3J7rtpnRcY0dOoHHeIl+eiWSqLuSoGSrKhehHJCE1gdmviYn7TZyYfISv5yrCZ8IXhPfMftZMSyxwlqRCTcfrFgfhyG2oUC56FDhzTbnVI9NtjDn3HgqsY2UFRJGD5pT0T1bUifRkLBXC2/OrTCOQ8M0knAB7zgN/tWQU5JIxhx/YJJ+fow0z6jG35Z6y+QIZmchs5NmeCPz1NTRJl+Zdlg9y7S8TWjXd15L73XR00jrisNbtqlqkhMGlzcDLxpJw8HbKvkkp4FObzICls6c8EoQkSl1wxTcRIME3JGiZQ5AkF1A3lBaxzHG4djv99fec0So+yer3Cbt9PLpf2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lk/g3M2G2amE+n6rpBJVoKI+E5jgP7Suy74Yn1iQHl8=;
 b=R2nIhlpL9BYh2bbGSIZ6iA/Ww1aldKXTyTr+W9w91pySeoL5pB6b/nSLSNqaBzjTlHh/dBJEnNRdo2oPwm8ky2QLfyKFhr0UZpBh756eJ60XE+Cx0SIymWJJfGfJUdYwXM4ptI/KRbPQhcMOpWcmbaWmYlP8pQO/XWiMrzWgpbHpKRJPe+Ya0TQC21HujDPDHZbn6saPy7zmb4aAvlccbdeX+/poqKNvInEAPQc50Py9Qj0w+8d7D1icTFzynvQjA3uDyqVDfiFeH1SHq2uT9w9OT00qSRyBGYQzeisAo8/8dheAAlFSc4lExxlayFRhPArT3yBohrHnaTPTZWKK8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lk/g3M2G2amE+n6rpBJVoKI+E5jgP7Suy74Yn1iQHl8=;
 b=J1fvEYKGS23OIrRk3ENwXF/MAPIE8SaWSzaa3umjOdbXnAwLAUuoTnotAsaiR0EoRU8MpYRdvtFswY+6OyPLC0gMNbmZQDJKfX3X3+JFWm7r7RQRTTaHdU23baf7u2Nu0FY1aL9BodP5k2TQdJg2DlxQau+c8v1GbpDqfv3qDYM=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5184.namprd10.prod.outlook.com (2603:10b6:5:38e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Tue, 4 Oct
 2022 10:29:35 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%8]) with mapi id 15.20.5676.031; Tue, 4 Oct 2022
 10:29:35 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 10/11] xfs: fix uninitialized variable in xfs_attr3_leaf_inactive
Date:   Tue,  4 Oct 2022 15:58:22 +0530
Message-Id: <20221004102823.1486946-11-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221004102823.1486946-1-chandan.babu@oracle.com>
References: <20221004102823.1486946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0115.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:29c::19) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5184:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c036caa-fcf6-4be0-184e-08daa5f35521
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T3ihHzSHkyBjjwfd0dsFPEc1puQHAhBVsB4gIGD+aInSIwphJas48DY6cftuueRer3A0ZMv4/cWY3qWXxK2D93BVCrVaFORJd+jem4yFMxYTVl5hUQGqrDiqhgQfOJtCnfe3OHtceSOVDmTG484qXrZXaQLwUFrBNu9sUhKOOziPxKee5NA5tHPj551LkectfzTPlv4x8F8tu+l9YQsOMK5yvIDpNpol85oRD/csiMj1RBeyqX/Teh7q2dkDAhc3MnMptz9xGNqCFd01XhoceP5ET+Qk5QSkc9R2E3F7BN2tVNLq5POAtsA+Y2FF3C/mpbFRqUDLdl3/3BDVbZFq4zdtZ+qAGQ6LkXqmTO3ZxykCzmWm6ttBcj3za6APVWKlHaOLBaYuoFVzZrpsX8wSxd9oiuWVyYTTOv8N2EAfS9pHe9TSP0WbTCdvYqssu80EWKG/ZvU4quVSZPJCRHnInk0wcOjyEmNnzUS1voFib6rlmU3PfOMRbcR/4bVATcoWNwJZSAeKDwy7OEZG5gcdFkH25mYB4ApWMd0Sih4sMzCYcKYm3MPoqm+eUUotQuGBlzfZSbB1FxT8QqxrIY7m7H88NMm7e1+35poy/NTw5Xzh71B0JBjSUNd5jgfOp/wHaLf8iqrXZkSBaXfpPju/rE5fRPTfhIdfPimqmAX3PvvbNGXDly5DERdgse4zCXKOs+yJezJK9wjMRf/Fv7JNPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(39860400002)(346002)(136003)(451199015)(83380400001)(66574015)(38100700002)(86362001)(186003)(41300700001)(8936002)(5660300002)(316002)(6916009)(8676002)(66946007)(66556008)(66476007)(4326008)(26005)(6512007)(6506007)(6666004)(2616005)(1076003)(2906002)(6486002)(478600001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GaWBbB1qcmQFlk9bgq3duwDvkHkc/CTYF1kDy603u27O/QfPR/HTyltFj2M4?=
 =?us-ascii?Q?OB1XXVCUD+6tpvUttuGj2k/QAxb1o29JzdDvouB9f0QgS99yp+jyqOQtXRtT?=
 =?us-ascii?Q?Nw7kVwT0R2ZIO/9m0lLWZIV1K8aCpC5APUJh8cxJ4I2aTUHttsXBcUk9FWsz?=
 =?us-ascii?Q?lKqJjMjzI1Z+/QOr+zbAu/CO3gneOQLmf8sfTjhdVhjUyTCpdlEOUgvpu2h6?=
 =?us-ascii?Q?W/OVc7ZcUtVDNQL33v8zDBfFu2wX+1jU+XT3fzeznVY1iYctQQwG/jRxRq/G?=
 =?us-ascii?Q?mSbNByaa2skV40o8uAYhjDLE1my72omqibOK7H411sW07FwyBMq+wKRraGgw?=
 =?us-ascii?Q?CMyXOUDXiwph91lsAyqalXd65beVjwau8YnmJRnpY5E1clVF2Z/lXLrJD0+g?=
 =?us-ascii?Q?brqdiJ88hjabyYpJs6gGMLSIFrAAsmIzFXNSQhriplujJcwtLJzaqnEBAf9n?=
 =?us-ascii?Q?VlkMvNQztYrXC1wNBs7pUVB8lyXW4KmUpp0UJ6ofETKiY3uEK5y8UhiR3UnA?=
 =?us-ascii?Q?/9dmWZUhEdrq+hE8WNcW8Koi4q/Xy2Nk1eBSRLLEl8Ca2x50/YejhlBh8thE?=
 =?us-ascii?Q?5YG75zPgVJZkFdjHmqC3HrHXDYz5i00hgjYWB0WeCnq1ebadBJyFaDzkx9mG?=
 =?us-ascii?Q?Xr1Jfx5es9H/qJ8d+0jFMftIEwj9wo2jfj8qJOdqHnsglyQM7qrF2ro/vZMi?=
 =?us-ascii?Q?Oy1F24Fdqw91AWfDrS2myh6t1oWTocwjEIV0wBPNJE/uSC7LGKMiIM8xLzWj?=
 =?us-ascii?Q?Gr2lK3bVUshTL6efHumVIoqGdw+mf4pm8PFcSgGF0wUBJHlXr/4umht0cNFt?=
 =?us-ascii?Q?1yJPs+R0YaoNGfyk7kwYCIF/XaIAyLvBZyT3yJtRXnStL7DPMmr0zpJlsogq?=
 =?us-ascii?Q?bjQ8GoRUVKe11RmoX/BtcPfy/2YBD9bdQ6rHKTNM62SSLjhfINC3wqMsOSOr?=
 =?us-ascii?Q?rYBcq81QgU7s7nCrUREhmhwsE37SBC0RpOKpEh02jpJ/SnxDZwCL4dm7DycQ?=
 =?us-ascii?Q?ap1mipvRV3JxwfmMx6CVf/BC6OWghrdsnP4oXtKDWhC3UdjtqVSO84s+cd00?=
 =?us-ascii?Q?67oKHFfUa32YUDnbFPzV4Qv8bYkEFC97xyen7f/qHZ8fFgA9jbpkpiYen6IF?=
 =?us-ascii?Q?4CqM7P8h2us453gPfyQuS0Gq4noWjOL5ezjPpNi9QZ84eKevf4wrEY5RV7dc?=
 =?us-ascii?Q?iiVMJ1VC5HxNBo8rLWPfJ18Ke9o2Of+ZmRsv7glvpUPqB0GT6rfATUQjLk9+?=
 =?us-ascii?Q?jfeUV/A3lP/qYQQufi22/o2CXUOpJTzvtif0G0tVO5cXjC6zMF1tg6q0WBkn?=
 =?us-ascii?Q?N94VilCRIRSlzF4NNsJNKWX3fY4lNVdICPEeXsQ1b+x2vaVWs8bhp6CkujXL?=
 =?us-ascii?Q?FxHEBOyqvQcnxDtPebQeg/KfrostyCrKJgKqpDjyqINg0Vgs14+wEeJSSRNS?=
 =?us-ascii?Q?vsbYhJc8wanWTc+kVRX6h53/CopHW0Hyf5etrX6DTM9Kc8OPg677/F0OC8mr?=
 =?us-ascii?Q?j2+VehOOG7Rr3+vDw4WK7hATHWB8qPZogN8ZOHIx+bAmQV4IutdcqPdc5pcM?=
 =?us-ascii?Q?i66qomDm3DY/JXgGXO2+mgSx9f9oDHjR5BDdNWnHxW2XaUHShmDmMBGktOK1?=
 =?us-ascii?Q?VQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c036caa-fcf6-4be0-184e-08daa5f35521
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 10:29:35.1945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ug58gPEwIBn/fBtWfZqHDXWKQKQTlMLwPX4XYmwDluQvyzdc5Yj6bMbAY5AVYnybFhwCFeQiLN7BJLLS94L+TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5184
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_03,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210040068
X-Proofpoint-ORIG-GUID: jedGFqYJKhyCiTSwqqK5hdUEvrkpZefh
X-Proofpoint-GUID: jedGFqYJKhyCiTSwqqK5hdUEvrkpZefh
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 54027a49938bbee1af62fad191139b14d4ee5cd2 upstream.

Dan Carpenter pointed out that error is uninitialized.  While there
never should be an attr leaf block with zero entries, let's not leave
that logic bomb there.

Fixes: 0bb9d159bd01 ("xfs: streamline xfs_attr3_leaf_inactive")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_attr_inactive.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 1f331d51a901..9c88203b537b 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -88,7 +88,7 @@ xfs_attr3_leaf_inactive(
 	struct xfs_attr_leafblock	*leaf = bp->b_addr;
 	struct xfs_attr_leaf_entry	*entry;
 	struct xfs_attr_leaf_name_remote *name_rmt;
-	int				error;
+	int				error = 0;
 	int				i;
 
 	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, leaf);
-- 
2.35.1

