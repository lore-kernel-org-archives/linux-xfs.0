Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3314A23;
	Wed, 27 Mar 2024 00:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711498392; cv=fail; b=IGEbm7SIAhzrh8lIt10AKiv8KUWhlHDlcVlQ1FOUqS6suUT1WxXhVRo2jx/WBorCUkwVeOm3WbgVYVZC556kCo2BedqvmYfTt/0XXJcxf0FzHxI0gv6lZjrJ3LK8/VoBih1Jyr2KYCk3VrqbTkfkN848/qv96488wDCk/UsYGiA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711498392; c=relaxed/simple;
	bh=GTc+b7VOv4+RgvKzsNW7nPd0pAXFGqxOr5T13OKO0P0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nkzu49OQSQh05+I5Bj3jnUw6WeOl08uL9XG6k4rFd62wkqiMKCXH07COjR2YKDGSN89dwk4+uHX6E/mfpRpsH4hraRd8X6MZMWU+uAwqOv3+RZnRyyIx0CK33TEDtkGlNGy55Mn/UDZ2ZOEnpsPmzmUoWqoQyYcah88tnyNUKBQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=STYbggQb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=deEuOTp8; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="STYbggQb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="deEuOTp8"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QLibh4032020;
	Wed, 27 Mar 2024 00:13:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=QT+DNcF/Ar6G2NSETgU7/hd1dVpmP2nLLa1WtoSTQR0=;
 b=STYbggQbnNasLhr4mahY1V6yvjPj7Vo5mhnBwkukNjM1qCfLXYkWIF24Y5Uoqz6X5dOp
 onrbvlBsirPTGx6Ap4fJiLeshCNkOTLwzv3RAsjs26v1z2rbNll/dQ3HOZkRYEJnllA7
 MvkIB0EbYAxq76+ET4xya719Nd1zIuOdRzDcDbI1cXsbH2V8/YL+sx0xQFFwnVL4yKVB
 ILxCcBjH7wu0M0vdPlejTj0deqKnbT0EgghjmCVAiNbH6K5GKkEKFsV1c1JVuFIxEsVi
 EZmYtwdtDetlapa+b1VWBlsJ4XzYQYsLjSeHpN8mKAUWVk1iIV/ceb6LMepp5sUNY/RA 7w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x28ct5n2w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:10 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42R00j6Y012418;
	Wed, 27 Mar 2024 00:13:09 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhe1ref-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iwz8zHEW7kpanFTG5VCYrkEg6x0FS9yowj9fQRrtp41PK/KwUI4zAZKIhZ+9GulqHGDt5OJ2TofapZEVzoqI1ospwdg5qfrZDSJtIZZOYxFVM1feZwBt/BVLeJlSBPNiJnKjh08i/XoGRYLwWmgLO1IIzjo4O1AyzYRfQXc3bQJXa4M1jmDbiP48TshsyLH3MK2WGO5qyS+5pr36RgODf5WlzWht1aFlyxLki0Y2u2/RaJIm81qwuuF1bY4N431z8peS/SMfa8J8csyDM/ajVmfr6uSf54U5pyau5AQE1ZXifE2RYunZsQZiNZJXe6GCL5+oRnejd19SXfLAQqaEFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QT+DNcF/Ar6G2NSETgU7/hd1dVpmP2nLLa1WtoSTQR0=;
 b=OzDqy9o6yjHs0L6dWcGPDc/onIZCJUN/9w0IFuJ2cBMjiQMJf6w+esLV+CXUu4ka+uA2kezM4L6pYdQdVrcfqNdd6pihKdhrwJ1PAvRwM3wxIYVmqWLe+XzloDifrHqpJdQJbC5UEONM/WjLaVa61TsCm9dKDpMj6xW2btSkYZCtSK+lX9AqdxxluKpQhwiKAR1AtnMMGC/Pt5+LmCzgD9d+R37tC933XT/g1OHoBkHykdYAhMJjZ4Vpm9a3kElCBz5E/CB32qAm9a9uW7oSJdKuPEO6Y9DEbwK6IPA83sZZJx8fL/Ykqeb9ZChvco9TN1YPr+k1l8kyhKLsiLTvTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QT+DNcF/Ar6G2NSETgU7/hd1dVpmP2nLLa1WtoSTQR0=;
 b=deEuOTp8+Skx8CLllffaXNkcEiKIWTxE1XBRG5Co5j/nx0uYkvY2BEYzM8tfBlisYcnpAiTm/aT259ersLOKMPVeSgan/OS1DTKHOSqnUlLntqjN9PnBgslmnWQj73pUn0t16xO9qmfmOTfZqaZiYIIe2w38FL1bkCKaQnO/qSw=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB4897.namprd10.prod.outlook.com (2603:10b6:208:30f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 00:13:07 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 00:13:07 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 12/24] xfs: remove unused fields from struct xbtree_ifakeroot
Date: Tue, 26 Mar 2024 17:12:21 -0700
Message-Id: <20240327001233.51675-13-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240327001233.51675-1-catherine.hoang@oracle.com>
References: <20240327001233.51675-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0028.namprd13.prod.outlook.com
 (2603:10b6:a03:180::41) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BLAPR10MB4897:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	lYnWHFYOSOUfvSVnxrFNoi8+VYxTZ5jnvfv4HdxOZ4UkABpfFUdQbjvCcVfPM4evAJQ/hbPbrf5zKWyZU28+MPL9k5fHheiRsWmEAXiYmkTGqbDa5E4w68udK1Ek3IlJPkBILySzD3JbuBn6Frsw5rXINopkbGHlNOeVtYH4sylvmhRyXIuBQ9GAP0/JdWAC/QKJ0WsYvnH1o5QOvN2KjOIinb1L/CNWiIom3GQh/YGn7W1yzVQPdhv7BPgkJQuMPNZs2WkG41SfuoEswRYRPheTqDef+2aLgTJDTb0SZ6mpjGVrQTEvcjnedGsY38PJhWGfB2cpFCsBh6WrKPXgIv9qTMKP2887jASaaQ5kfolwPnl9N1S2QZ9vSkntqWE84Q9mP6pZwk+7CbNfIKxlItZGmbJo6vSRehAiNIIXM5XBaX1LYKCZe58kCIuUnlHp3NpIlyAea90+Xa7cJUmITQsjW3IBH1vKMyWld9NH5rSNM+/i4lHGGR7aWjA9kPdJf0odc59esIXItrMnYxVh2oK5NV9pigBivZSknK6XQyjoZbtHm3wYb217H/r77nhnypk+bF3Jk0PAYLxuwc8mGZL7IxzcpygaSrX8Yrd1GNuBT4ZU5aHcHyGCvBPHIbUCOFMA/A3xCr9upJxSZBTGaJbCmpIVsa1SuO+hwsff738=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?4kHgOBul2J+cBCFIJrjuwbj86eGSLhw81Exuc+Q0ToaGNbpMwX/05kcLK2L5?=
 =?us-ascii?Q?eMeAdsgcHPDZ/kn0D2tfFthL4IaZFMsLOHD3i1fpxJ1nCqeztGq6DWxIl1by?=
 =?us-ascii?Q?aOfXdyKmj7bnN3emje2zy6HGCrIq0ET4ffO85+EtIjBvanytuXZHGb9EKq6e?=
 =?us-ascii?Q?/gwB3s2OL0OShDNide1lpu3IgMjrjRUcMjriKk8+MBiSinsDTl6X5M7WDi4u?=
 =?us-ascii?Q?Q9DM7dSPHDZ9kSRgnoU0F1lXPwNtI9ksc9mBJnqzse2jFqPGdvLfoceRrpTj?=
 =?us-ascii?Q?v6IqsoeLwLvEbCn292a5x4iOCCI3cbz+BTjzr9jLkM6W5oATkvTm7GLGdyvS?=
 =?us-ascii?Q?dN844pHGv3RdIK3V3Gs4/3fZOU65NS4KQxkLqb1pTQ+f/m+iRZC5rQ5hhgXL?=
 =?us-ascii?Q?VWGPiLrLBYw8BqBE+6X1IE+DnOnECSx5/6NgtRtcFnxaDI7yj9+oOCX3zZC0?=
 =?us-ascii?Q?da2PuPQCwdtSdxwE8a9qhpnD0uVYaowTv2AmpImIf4Jj6cF7kEwernV8a5JT?=
 =?us-ascii?Q?pt7kWjCLVfhxJRRPiHMCFmIXmUmK/ffEzo2Ar8F0l3pAlAKwnyVEehdNTjSD?=
 =?us-ascii?Q?II/u0+UZvWCu83NxCFzk/YLwFFv+yTGuRcM/wc68NihPMzBo0HVDz+TmnUfw?=
 =?us-ascii?Q?tMV7EIUbBxXMxngu/LciTGp/yymjbG3XKhf/5dtzWw/d/mtsKBmLFf++xN8v?=
 =?us-ascii?Q?otAEAXDIAG5pEDwRxxBRPWR7ZEy2moc4IOH67Qihn18QvzE3iWqiO/B/khgZ?=
 =?us-ascii?Q?r8deZAIlwGrEcrrU8EYNeIY9P0kNNqH7aMMpXzFFHSP53L9ND+w3TPet9ly3?=
 =?us-ascii?Q?CMGdlDl54efw+s1JoRAJd3G7/tKe3C1K1daCyk8wd49Kw+aH0ps8+IZty3M3?=
 =?us-ascii?Q?wx2Skr6+3FlUjZWQKwuB+HMe+xwx+STa7t9MTRSMg/UGwM42FysqMQDu3aOV?=
 =?us-ascii?Q?wjG1k1HWjPy45UBMzvUOxc63HAqo87Nu+4rgV2sGRlPfEefbqYHv76x/C3Td?=
 =?us-ascii?Q?0Gxf0CMNELGyAsILxgjtJZ3/1aJkuIQySPeoR18dIvWSIFYDPoVrQF72Iq8F?=
 =?us-ascii?Q?++/jd334dkK/7Qftg31oz/vvBPA+1uKSYKlJGbtMJl5zyZyA+xdvHtIAcXc0?=
 =?us-ascii?Q?VmaMjaQy7q+3o8MCQW9hey9BZ1u4snUdy+BGdZdJ4uBhpZBWQvXOxFNrRmNc?=
 =?us-ascii?Q?t4j7gmAaT1JK8BAetqtm417iqsB/Gda/nFrhkCWzI1SjkDFNuw0o+5nTLaG6?=
 =?us-ascii?Q?tYjkaVzi0KX8htbX27MO9XKS73JrauRTpCll+5nVYQsDbgwSHVU9oq8YQC6/?=
 =?us-ascii?Q?dmzGlMHlcVUvQP61J4Xn5Ys7n4PkGX3pxpRE0jr0tf7mC55p3Ubm//zv37Xm?=
 =?us-ascii?Q?eitZTQjZLnPV5T2qCtNFfX1wDtd9aDy+VL2L0wLGi/tdvb/+iLa+wizewBYE?=
 =?us-ascii?Q?pC0cbPL8nRtB1Fd8VrF6+HUdUnNXLFmChF+MjZpMO962+PjlMaIzaXkjed3A?=
 =?us-ascii?Q?zOAWxXXvOzK+Y9fdb8ZChgNtN3/UmpojCfCoHomMVMrB+79pg4q7G2D1QER3?=
 =?us-ascii?Q?Lt5Yf/pvPTHN2AfsupIQjfhbg3katANLKZlHRCX2bd0x8qseDSmFKK2koKlm?=
 =?us-ascii?Q?wCmwIdDNBk8opp75BgoHYYYIcoqsNWwxU8wmEG9wCxqRYz8UVFnzH/dk3llN?=
 =?us-ascii?Q?36JkgQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	pOiPCj1HFgcnrm2k48nj67iOk80IzcyqaZEpDGwzrb6XOkOprQKZ9lWewv4UNLs5iJgeqe9zAw/JFSFoSMAUo1OzcqIpHBDBfN/AW0nkYTv6SxYwFiRBTyASojKULi6U6BBSUvHgz5RsxbjxnK7evA2sKHszkXjA4j+Oo2nXkNZWflsjBGm4OZlR6j3iK17xc8bgdBpC0YPhN32IGCCwt9A80J12Rq0lMTch4I3aS7rPREqLUosP1alboSRbIQi/f4OqZTm31ZYC/WFKUq45M8FgQApZUD5be/K/D4RPp9nU7zeqgfg5ZMHYRInOJo/k4nlbS1cBtVE9Wcjylp5DnGfa8L6XEJ3bZmiBxUqBoELS+hQY/hFs/DcqllTUfYEIfDHb3GuXZHdL7jqmtGKds8EBKfOI43ZetW9ZIx3zx26qeq6y8YRuF7hLCAMg/D08L2O2t8gJoAfjiwwyx/qAjzGcgu2mUoUVHb08eOXDodnFJWG3Kn1FOs9ev+vx1+Bpqu/wC6ZenqYgPB/Da9U5xAjhzi+n7NNzC3nS0sBO0hbe3afO1IL9I0S+NpdHHk2jO3R2ElaMiylJixp+7lVW1fVEVG/iG6yxsZBki79vHYo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 748d331b-3fe7-49e3-ad96-08dc4df2ae0e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 00:13:07.8626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mCSFSsbPpBmJc0x4wPnmbeG14lGQwiGs94gbu7KErly0ZSisH9oOsy8sKIKUVN+aOqrHp/mvfsrG+9GCa30KzMV+ZYhYvOwW3uehxy71eV8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4897
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_10,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403270000
X-Proofpoint-GUID: gWMJYAtIu3SX8rp0xExxXlKEaqfCnQMt
X-Proofpoint-ORIG-GUID: gWMJYAtIu3SX8rp0xExxXlKEaqfCnQMt

From: "Darrick J. Wong" <djwong@kernel.org>

commit 4c8ecd1cfdd01fb727121035014d9f654a30bdf2 upstream.

Remove these unused fields since nobody uses them.  They should have
been removed years ago in a different cleanup series from Christoph
Hellwig.

Fixes: daf83964a3681 ("xfs: move the per-fork nextents fields into struct xfs_ifork")
Fixes: f7e67b20ecbbc ("xfs: move the fork format fields into struct xfs_ifork")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree_staging.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree_staging.h b/fs/xfs/libxfs/xfs_btree_staging.h
index f0d2976050ae..5f638f711246 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.h
+++ b/fs/xfs/libxfs/xfs_btree_staging.h
@@ -37,12 +37,6 @@ struct xbtree_ifakeroot {
 
 	/* Number of bytes available for this fork in the inode. */
 	unsigned int		if_fork_size;
-
-	/* Fork format. */
-	unsigned int		if_format;
-
-	/* Number of records. */
-	unsigned int		if_extents;
 };
 
 /* Cursor interactions with fake roots for inode-rooted btrees. */
-- 
2.39.3

