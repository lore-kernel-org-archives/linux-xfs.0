Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA03DC7619A
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 03:36:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbjDKDgg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Apr 2023 23:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjDKDge (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2023 23:36:34 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD18172B
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 20:36:34 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33AK8U9W004259;
        Tue, 11 Apr 2023 03:36:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=+EuhXFy/D7CewhMcp4KqSMGmH29WmNfzXFiPHJhfelU=;
 b=RGYGAWBAlhckk+VXixmkxX4K4BcnBpE8tkbFIMHQ0eTJgdJfxp2oRVr0hIoeh5HUsilL
 41ABa8gE2afz47GrZUjvTIa9Ha0lgUVp7+/Rvl1T3qgmklTejmKBgOPp5+xNQiMQ+fPq
 GO1EdsGtPT/dzm0FaQn+72zYlReHpeUfE95TYIiKG3/toPsfix2I+Psc38i8V5GNrXM9
 qOQDgSdpgZOrMd0s/7+LrQJJj5qKfCGSKpoi2/8k7T9lz0cH1z01lpPkUL8vmJIKh8tr
 kEodEmKF9EqAlmzai0pcMBwQ0TLE4wBtAiXAzzFcOjxucTvl4VmY6GMNJF3uEh7MtzFA gA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0hc4a8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:36:31 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33B3FbEW038633;
        Tue, 11 Apr 2023 03:36:30 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puwbm98sr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:36:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mAaq90oZmTyVZQPziEWOFFT+BFiDaMlaxSAV23VA/z8or0vdhaoIdppXjJDC5dhYOCeeWj0LupCXBkuJGB6bdXcdzDBPpTzZR3zV+Z5toi59Z8rrzL55Y2OoRPNbTmfnv2IEK+pQMmOV2rJqrGbQaVwAqNdmcwDHYvdq/gMRp4FhpdmLphMrh3oMwvwCmmtgSQPK+VQTglQv0HmonN8d4NiYPl/sAwt0zIbfLLKYXivr2ufrbhYxf2e2eW/KuFjmIDFSCm1wv2ruP5s9Ko2Hg/c9pKTbOfHn6+fKgQmcBVnketFwGy0VaVvWO2oi86cTYVbQwpCSHNkbJcWjFtUfHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+EuhXFy/D7CewhMcp4KqSMGmH29WmNfzXFiPHJhfelU=;
 b=MF+1Il0gcrum0u0MflGUtwcNLbajYHBX729LO1ze5Xp5qxnJ3x/9v3UokHVDwmUp9DNSPaS/R78zXvyPcSi+71JEvBFvAWYnTVJpCuWHOMpKuqfKyVNiCexj2grROo1wNnFyNsmF4ilAe7MHkFhC8OQHuGd6HMoTc2MI8tClRGmoG5ESpklrlvTC+5VXd5tyP+8l9dXe4FjUhkGlNGxKKOoFXWvQyrWzrY3I3FjaQsyoe3JKH7n0t6kq70wQi7PTz7DVSVzNs6uDsHGxPDmfh4qUkoSMSFHEEnIvmq2TfNySgMGxz019/vjJGTuJMsDg53a59B0aDbPGnSNKxAaDHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+EuhXFy/D7CewhMcp4KqSMGmH29WmNfzXFiPHJhfelU=;
 b=Zt8D3iu9nfZ/ISDPU5ASUJfW8f1o0RKRDf39S06A0wTOoy/qDxA8bji0M2pHrPJDxI5rCG9bSp6HXOsO6QrJKgNDm1aQDhZ5JWTh4Po/OUWz8YBdvn9Z9WNFrUMVjOqaA8GZa34PoJobVGpdw5SmkrPIGgAaN0lGetv6CxLlGLg=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by BY5PR10MB4338.namprd10.prod.outlook.com (2603:10b6:a03:207::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 03:36:28 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 03:36:28 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 08/17] xfs: simplify di_flags2 inheritance in xfs_ialloc
Date:   Tue, 11 Apr 2023 09:05:05 +0530
Message-Id: <20230411033514.58024-9-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230411033514.58024-1-chandan.babu@oracle.com>
References: <20230411033514.58024-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG3P274CA0015.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::27)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BY5PR10MB4338:EE_
X-MS-Office365-Filtering-Correlation-Id: 68e3e58d-827b-4107-3141-08db3a3deefd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9LQ3aYuPHrFSw72Z/4zUWFoEvpm3CeRTehvkSA0wi7vl5H3XZN9hj+QRrweQx6+QMohXtsPtwF0yJZ2rvxdF0S+6FupPjUbHgC2D5bu0l2ekk3NDZt5aVAZ1chURt54LyrwgOP2YmKKmgAt8r0JV4HN6zQJx3JIcGG6wC7J54k6QeYl3OR9shsxtnQ6OJSXi2triWt1wp7E6HNRhKhov1RhDhz7gAYpWoliUCHW7qFg9vxSVM7nA/TprVT/W1gjT5b/zUC/hWvjfrqyudA69mo8pLwg+d/XdUKeI4Je6z2NPVxlpvXSedmmtQEUZJ5vApCU8SppGrFrVeyOqXeMhJ+OOh2DzkY4Riyk3zr2yusVqWB5oazcDLj2sptSnCsZNEhU4ni8tpFmFjBiPfNAemZovyNZPUhwnQKRv8gMV3kt1ZpJaoSzRFyfk8G8sYI7cBXPchxLkeMXToShq6IZyY+693XblXqQrGshHSqS+U2g0GZmxNx16RxowZ1K1EjDSuCpA8C2Pzf2Ljcmqnl/gpL1p2Q/UMrD3p7tX1Kpn12fK/J1jnFh3C8s4VizXFf8NWn4oF9fX6YNu0FUl5u75cuf3aK0G8yrzeNC+NZ+k5wA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(376002)(366004)(39860400002)(136003)(451199021)(478600001)(1076003)(6512007)(316002)(26005)(6506007)(186003)(6666004)(6486002)(2906002)(5660300002)(4326008)(66946007)(41300700001)(8676002)(6916009)(66476007)(8936002)(66556008)(38100700002)(86362001)(83380400001)(36756003)(2616005)(218113003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pbq2CPUisUK8AQ1rSdFHOMj8NKg8I1Ky8iv37uVpCgXsbHSTFQ7mjfHKv3pg?=
 =?us-ascii?Q?9pIEYuwzgZ0IH4UUo3Wka5XgD3sW+i9cs80OwcKfiKMDzCxd5Q575zNvwime?=
 =?us-ascii?Q?yu0K72N81TxNAZKmJctNyLnPZq/dnMgQCWt4vZZiqGTQouu/ytvSJAqFgRGp?=
 =?us-ascii?Q?GIb1JL02BuhVESRbjSuxkT+IEjW3x+SmnxOwWzcWnhjEO6quqq6Jkil7qt1f?=
 =?us-ascii?Q?UG3SZraqqWEqDK9zM9xKtOjK2A6u8tUU8n3kphJwgQ1VJhlpHEqPL2Kk+fX7?=
 =?us-ascii?Q?8OT+HdmS+HGPGtQ9+nsV33nszKSMHb0nPE8Yiefsow2knWC9bq2HWP9hYGfh?=
 =?us-ascii?Q?iXbJCmTpekEsnFhTDEsVlvzQOYrq5aNmHPnsAXfqCdzXbReW4kI85D1vYYtV?=
 =?us-ascii?Q?KVqKSaMMnEZVk7Afde6Zam7sfQjMvH42us9gK/MQxU7te4V956d9oJfGxY40?=
 =?us-ascii?Q?52kYqPqXj/64E6FCzCHQM5C+G3N+CV+rE6BvwzrqAXWvT8pOi1eyAWknnEWF?=
 =?us-ascii?Q?NccRgPESRhGEm9gt/QucEbR5d/u9EqSJllHQSUoEWlkS6zNeDI9siKDK3oGo?=
 =?us-ascii?Q?SLy4wkPHPm5N3ri4uDbwb/n0sR9Yus7TlpSHaHW88bqwcp660AwVV8gMDgXV?=
 =?us-ascii?Q?cN46Sq/gqcBISHs9w1JKy9eXBDFnKFg2NzwqF1bdY5cxIlJ6qGy6XBxlQjiN?=
 =?us-ascii?Q?LyXVxy7O+SkQfrueKmJ3Wh14M96PUOq4kF7Vs2lV1u/RSYwF0BMFCxxz795O?=
 =?us-ascii?Q?qeZyc0VI1BHu+jRyR4jdahi7DGt5ietKqngfG0cGyw6zciScpyUWqGjq0GKI?=
 =?us-ascii?Q?b1GIMzSC2LOol3vkehcTKPIaJfgF5A6dODWdwum94B4i+IB36+CChzeN/+yg?=
 =?us-ascii?Q?t0RCGB37onZPzpYrZ9gbip2Ligg1TyPHB4l5vcwpnuFbUA+qU6uM6vnD7uOY?=
 =?us-ascii?Q?eKcFHmFviLCHR3gZQ5ZHRB5pjfRhsJ3y1g13/Hcb2E6PcUBE9wPeQ4Q+macY?=
 =?us-ascii?Q?E9QynqxTM7hk56GBHmOLp267tLLZFqPfmSxlorVXYg2tXVTZkEqLmnE+Cl2/?=
 =?us-ascii?Q?u0jRuAqyXkxS8+g+vJNUMX4m+X0lr514B6dmUxUg/DfA8WzjcXncEa9UbVv1?=
 =?us-ascii?Q?7TgVnhu4EhZLLsh2wYiCj6qAX7H/V3FoJzWHZsb1LCizCSlpOcw54kYm62VK?=
 =?us-ascii?Q?dg5l+EaeN3XJ59wqzNiMNgJkhn+WP3zx7qUflTp+ZNqF9w6zPI4aXRdwxxfd?=
 =?us-ascii?Q?2bI6Q8+X4KMvbJLYBAMzu+l2//yXgI8HPaB10ZDMI67yMjFEe+ghpy2A5xxG?=
 =?us-ascii?Q?Uv6U/AhAgNrKXKYDr3hXkU2bZS2UfDjljd/7BfaYuS+/o6jhvUe8gszKHIVZ?=
 =?us-ascii?Q?EyqbQQF4UvMW91eRcDortw72kciUodFc0kiZ5Toxzyk4XXe+wJZa6aEcycLD?=
 =?us-ascii?Q?Ht13bQvRv0Je10lCRrixv1P/oWiLPUaGc2G2TmYdgBMenm2xyh1P8ZQnnTvr?=
 =?us-ascii?Q?O9RKahCuiwOrErrPLb0GW98WT0ZNs649OWOalalMegc/XwUjAzyZfg+LGo9L?=
 =?us-ascii?Q?Mx8crIUaRhzEzMNy0Wl8nFjEhcXlQwKb7GvdQuLs?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 9+oOZX1I//3Ss7dusWEXMTM09sRL4Ol5Y/j0gIzlEuQnCovz71ifsUzPNvuC+gjtUDUZ1ns0nNMq0aqbZsbjldyNvD/yc3TUIUS3xY6FwEQ42T3reqWrQRr4OnHMqgUwNVESV7+biAkoHpRDXbZgRhjOfg0opYSSkLi8eRR2gJISXCHHoxMjwWqW4vHeRwx5bA8YHsXDAE4Ku2qZj/uUxJ+FjLRZU7TgU+LF6e+9S/8gMxr2yo7BcJER17iG2wfhwYPdKvLA4Q1dQcoHy4vpwxpy0XhVgAK4LGSB27ApZqDAOugEt/7ZjiXkylZ2I7eqbqumz/BfISzM/qLNBhrnng+YXHe/7qTSahEM096momrM3q8dTjRmPOL5n1iVYpMukk19WUy+Qv71Xv6usUEvdRzH+rCIsLiDmWhLiniclSGSi4y9iYmqmT05MDUX2YXkeh7BsI2uApZe0jpeD4QzyFjO66rZwrs+tQ+eWqnMJ3NBhzvG1Jf542JciZeGK2DmqaJQe6vvSfsW1CJurEnHpAnela1e803QKiK8zBrcaoA/X+gBt5ILqSm3sjRQr6xMBqPfLaPWyo7BrhO1q7JvQmikCUzdDK6TAWKgKMQEjA3Vk4R3EwF88MprIkC0VSu76dXvg7PV23Ucs6y4TYraZMa8tCgjyatw7nJ+eZyPP6QWvcQ/Dgzejh51jzazFT/yFWqAJD8Y7cQGIsjWIXtTvht2t0okxlnum7To20S3IXLf+Dpkf6D/gYw0KZDjh10n2tVwLa/9o/oBnNwqyaGhznf/cx26C/M2BBVwQRsDmdjt1CK5nuUj/DTkjKDa7Z1t
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68e3e58d-827b-4107-3141-08db3a3deefd
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 03:36:28.2694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +rPefCzj9XrgfiXjU6d5pE6phpSnnpqys8eTTJRAHULzmUiTjYANOuHlP1D0RsY3tbIx7+sPbkYhlJDn9Ylwow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4338
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-10_18,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=877 mlxscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304110032
X-Proofpoint-GUID: sIWI6ePCyGvlG7lUTZQ8UL0vKV46LnzH
X-Proofpoint-ORIG-GUID: sIWI6ePCyGvlG7lUTZQ8UL0vKV46LnzH
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit b3d1d37544d8c98be610df0ed66c884ff18748d5 upstream.

di_flags2 is initialized to zero for v4 and earlier file systems.  This
means di_flags2 can only be non-zero for a v5 file systems, in which
case both the parent and child inodes can store the field.  Remove the
extra di_version check, and also remove the rather pointless local
di_flags2 variable while at it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_inode.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9d6ad669adc5..cb44bdf1c22e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -902,20 +902,13 @@ xfs_ialloc(
 
 			ip->i_d.di_flags |= di_flags;
 		}
-		if (pip &&
-		    (pip->i_d.di_flags2 & XFS_DIFLAG2_ANY) &&
-		    pip->i_d.di_version == 3 &&
-		    ip->i_d.di_version == 3) {
-			uint64_t	di_flags2 = 0;
-
+		if (pip && (pip->i_d.di_flags2 & XFS_DIFLAG2_ANY)) {
 			if (pip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) {
-				di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
+				ip->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
 				ip->i_d.di_cowextsize = pip->i_d.di_cowextsize;
 			}
 			if (pip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
-				di_flags2 |= XFS_DIFLAG2_DAX;
-
-			ip->i_d.di_flags2 |= di_flags2;
+				ip->i_d.di_flags2 |= XFS_DIFLAG2_DAX;
 		}
 		/* FALLTHROUGH */
 	case S_IFLNK:
-- 
2.39.1

