Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B2071747
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711404474; cv=fail; b=lDPKQ7VQP7KV8lwCZMk034AK414iGmts90UKNu2VAPA7MQCgpzIR/C+eElrsz2ikMU0w/2Gs+QtHyZ+gZUq9Cl6yOiu/jK7OCRrbAMhl6GcHpOUNRtABKIYmf3Pckfurl41ooT7Zd85wBHFRNGVszeMtEos8MZpGvRbLsu2W3rM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711404474; c=relaxed/simple;
	bh=E/T+PN4/7W5IQsnZbVOj3oYtmT9OMWoZcTsF1K7Dhwc=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pRVwm51jOm9uiaIrbLCsQXV9E+2BKepwmmPsJzuWb2ceR1pKzNB4wtjlRLT/wPZB4iMsJeDuktTElM+la1YO0M8QiefetknVb8J3sePwY5EPcVOikg2d/qUg1EUDSN30LHLL43bMG/WintSj0XILNu+VBU2GoXoNYoJeWzwGdtE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Q4SAeWFx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xZWRS+Tj; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q4SAeWFx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xZWRS+Tj"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42PLFuQv012492
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=8e7ljh1M+YKG3vohNJMAR2I8qRLBTu62ixMOdtt7SXo=;
 b=Q4SAeWFx5LFooFXfO1BbO3eEZoWsRJjlvOgc9K+HshL2neaCt/tHGwQhxg3iofJi57/w
 g1YykZnDSZ7IXPz7Rs30/EAvqOz/WstF8DddUUsM9eDuhdqnThjLZzgYA+WlFI2aTM8W
 Hzdrz0QnR1C+L5ZOB+lAhc4wopJ3kPs0wGo70/tmYc1TrzZZ1yoetBU1suxcBGfQjO7I
 DpzjbM6YNLWbDS50acAhDZbQLT7koKdgR/JSz8nYl4R34TXGyPNR5oT6N2zevCiknPu1
 rVTt0Wc9pzIIh27EocHtHT9cPl2+MqcVaw83ra5CrSaoILV0fPQE2aAwKmQRHofCgs+X SQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x2s9gt7e8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:51 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42PKIRun024375
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:50 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azlp17012018.outbound.protection.outlook.com [40.93.12.18])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhccqke-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P6FHlJvGsH6GRSbh37kEeY2clYtJc7HbaU/1znHTB/6SwZ/TgL15zKX6uTOT0RD01puNyHD0Zun50D6RAWEJH6e2JawE2SbmVgAMSGttJ23JoLxK4o3T1fKzxpBuzjPf/e/6pyHIPJC50IkntdjRU5ytLsNEgoz+hZEDiRavupHL36CDFI5GJHP3tIl4eqFPStYo9d9kp3vkUA3fGsnRX4wFnqB2R4TzIL9DZmZE50GcIx2b1xutoncRiQp9QHU/p17DHmMvDiMg57+NOFkgqaupjJeAEvkQcm7m6WtRzeb3cKL6wlPtVNCO5Qc5LJ2W2HYc5Dd5JAv22v1o8jNWlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8e7ljh1M+YKG3vohNJMAR2I8qRLBTu62ixMOdtt7SXo=;
 b=edkpfM67wx8PAR59zhKLzmesSiG6Xo9IfMnCXuRie0/ratcY77xJmz3CcSkUcA7I/TufoHZ8psGduT6UX1yg08ZoLiKoUVU4a6gQTHYeRmEmyTHbvxJ68O/mHYxJAeUin4bV50TCHedSuLlVp6v77Cq9kVqimdV4S6Eqr9cM26Ro+X+WKyaP4WlAy09g6p+oDWuAYWJ0oRgrO88TpU8aRoxNxD1sjPex4ZyAfeP04FtYvsZpoKkSaHWZGz+BoSTrGgY1IvAOdKo8eAz0Vj+hJ9To5GMMP0jzppVjG2zbTUkvdSK1TZmrYNL1L1ErkjxWaQUrzD8SldUk7mkCgevXZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8e7ljh1M+YKG3vohNJMAR2I8qRLBTu62ixMOdtt7SXo=;
 b=xZWRS+Tj1R7jWPYR/VWhPdOY+5iuEFSd+nD9wZMsKT+iOyOb3LLs8VNQh4Ag1R/A16/pyVAXhIfXQ29iUQvFzQhXt/dE9qu5zBkbRywsZ0tIVokUvDWqAUl0dQoYO6fDWt/IEKov9zz/NbqJu4UrSO6EKk8VqZkGl8ywLrbpnlU=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB7476.namprd10.prod.outlook.com (2603:10b6:8:17d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 22:07:48 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Mon, 25 Mar 2024
 22:07:48 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 07/24] xfs: transfer recovered intent item ownership in ->iop_recover
Date: Mon, 25 Mar 2024 15:07:07 -0700
Message-Id: <20240325220724.42216-8-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240325220724.42216-1-catherine.hoang@oracle.com>
References: <20240325220724.42216-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0142.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::27) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DM4PR10MB7476:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	RzJAerU6A39eYD0MmKbm0YJ6JFoJogkd4PbBfmNAljzdSuzUbD71RaGJ/wpf8oWFtLOVZhKyLNA54jtR6uxMOQ3UgOG87KQCJgjgQw5MQ9TU09tNNLwN23PIw4rSpTZYbS5tEiKXT3/AtmzVPpCIDnXvt6JyQqEyAziXdLcStKjzo1lqH3krYg7Ol0aO28bf5kju0x3/0dBs1PhWS2Fx8RHTwhqk8F6UEwh99Gvnsthi1QYrXEJqgBx1BpmLd45HIUIQpG29XWZKWddMm8F+5+dqeuQKHieyI8QF0Tpf4LKEBwjI3jGsqUmOshgertXOwxVKA35CoaU+vEybS3iy9KtWRl3dBsLl2J7WorGqVH2D3uUh+ejLSyjYL6gejKA0ezamdbT/nDlHZ9+fESfDfIkKLmkarnct1Y0vS5ubnvuCzuQLbBwLdYDVqrWwYqbQCLSdTavwFmnuy67o1omWg+07cWCu/AFNIbKU/6k9mSQlrdngZSDtTMocLHYC9VYdwExgxN2Ehvr9vvdjqyYo+9Filj6XBFmjVoPehsbRcwx3Qfh80dyTVsw0qz090LgcVjWF1KA6kIfJRv0xYV9x+N1Ervw7eberSI/NyqQ9hIKVnG1tvZS8cT4DBJ2TygN7Vz6BziXoRw2IGSyQc1O+i7qvCY/dBReaDJFzOOoT9eU=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?/WTmKi4MBv5w+UfD53Za1xwwhbAYb7TMbq7Bf1H951n+9npKtC5qRO2QjxY9?=
 =?us-ascii?Q?lCP24LBUs32dj3iLfLbmU+VFamEx6YVPSoxSeddt8M+vgLyz7glr2FWUaooo?=
 =?us-ascii?Q?2i0DcnjPnswFwhM1WgakrTbAvKrYlP/9cFokTVUUr8yXr2VtPsJ8xR0YOgoL?=
 =?us-ascii?Q?0QC0d2DyUWLUBhVWcp/CNepDneyNj7u2t0AHlEPSYibL3SpwcQmZ2cyz7HxM?=
 =?us-ascii?Q?l766OoKH+jJgm179O17SYLcn6OBkwDtiYTZL9U5WC14+DxZ03tKMaMiPGX6Z?=
 =?us-ascii?Q?fBkLR293ugcbScpTPQthv/J6VtDli2sl9D4otI3kgvdYGgmBYC4r5JDr3D8x?=
 =?us-ascii?Q?ckWfOAZ5RHdd0PuFgXhBRp+P/MGKd/akdU1dGmO3OZB9HAz8TDZ5R8Ax97JU?=
 =?us-ascii?Q?jijgBHLe4Sp0PeYBWqjvzqNzOSSnyZ0V/ArHERt1XGlZUpSWDrucDeFXyLk5?=
 =?us-ascii?Q?y8BMu5JgUTaIQoJa4PnaR2IgTChb9wjcpKvysRsN02I8UbU9vvfYJCXtj2SM?=
 =?us-ascii?Q?ofsSWxZ/d/7MNYpEg0NjAHWsfPkhjYE9/e80FY7F2/LIjQ8JdszPnH9d4Gbj?=
 =?us-ascii?Q?rT6BvgW25S2b8TuFQhpdQ/HFRjktc0sTHxUzZHiO/TGEza/4o3wCdEIFUu/P?=
 =?us-ascii?Q?DmGiQDHsAo7aVCYm6cb+9g5IvL7ujbLn80f+k+brLBUoMRqioNNY93ZA9i4c?=
 =?us-ascii?Q?3M22ZUX0TM4FMCj7bbPHn1aAKrRPtg5DiEicuw85q0U8mfhh3g5yXYRWWps3?=
 =?us-ascii?Q?h5W3mxgNXlj+vKiE/4qML/RdiFhLHSHXGPJwUKHtOvdI6pgDm73AG55ErnAc?=
 =?us-ascii?Q?CYfizm+WJfwHXXWnTabVWk9PQ8ZRvh8qsnWUuLTzNAoomGGC/FS3RCgGB4KR?=
 =?us-ascii?Q?6N32XXFLjvbwiAMNOO28V3/kjGJvZs7AZEE/Xyhfm9ObKdiyuV7S7liHzkft?=
 =?us-ascii?Q?O81KBUlzRIRZ6/a+Hsa7r/8cvlpIjQMMgz76LbVdnbdvNEbIoExUDnBgrAY+?=
 =?us-ascii?Q?TBt6g9qAF9/oTPZaHH/NQ+OIeiSbsKkafJoszfFnt0oz+eAivRBF2D2HZO6Y?=
 =?us-ascii?Q?MqStI1Ybhn9foP12a3pk+BzScl5u+IyVZznlm+WhjNGe3fp9dnrV/rIFV4Rz?=
 =?us-ascii?Q?83ikibuM/c9ibTl5GMhrzC8mgx2JuCreE07C0NEVP/mU5JaGS46kDlWWrfMe?=
 =?us-ascii?Q?ePTqrR0Oy2nQTqXjxYJ/tMFmE3yaT7GcO2BABtHNOXNDO+De+cqUP6amkQvt?=
 =?us-ascii?Q?VXvDuGp23T/D6oRacl58/crgBSf68ghK2WC0XVXtzIDOGOVR770W0RaR8mNJ?=
 =?us-ascii?Q?i9YCePFidR96Hjo20WNZxW50fzQ5kd9vlxs1vbbHQCWz+Pz23+wDXZkNGiz+?=
 =?us-ascii?Q?itoQNwl2ZN2KuzzD2hlGWtXY3BPHnLaFPezQ4nY/CFNX7F/DnzLwXlvtjeUj?=
 =?us-ascii?Q?OSe+WY2gK+7oXt5zl6v1P9flkx0wUU52FvkqGjsGLXv043YMAkw619NdbQ8a?=
 =?us-ascii?Q?JVzY/YHf1l6YLzKydTCksBXFDHfUX+6u45CnpZ50fbm+dfqLP2Seyrg9vg9/?=
 =?us-ascii?Q?vXv6pb/mxxlkjXzFBNJVGhCdywMkoOCe3sU6sX4ITaaEAncYZGQX8Wzz9KqI?=
 =?us-ascii?Q?tN3/9jUggLImN1Mf5Jk4p9uLRAOYjZiBQLd0FxOarUrklxwCwK6ERGvV01SB?=
 =?us-ascii?Q?sIuFUw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	f/pSGS591ra+fmSiqjrpbgX8gPEJh5jPPAnZhTE0HUnsHsjTu8HrKwEvGrsTucqLC/Az+7L9La0ywpROciKn7tDqLXE1jZ39UyxnKZ76eYcGQND+Adjh0tElVbrwJwwjWqeDn93fppLUgBIEXTmolv5yGyxExuYdIlPX+m4i78uxSzryY2OO7kWW02QfGtNRBL6EfinpRWEoic7k0QTAQ3jCaJyS72RbSLRAlPYXMlLQHKmHtpR47t24VS48+A38Yo6MV01ceXLoq03bTQY74c68tcvVI1UDtYIcExS4oR1ykr9QfJB5goMOczaMtQs9TU9v8a8/7sONbYVMfVD1+jDUdH1XjMuKxy+Rk3NTaOOHy7/UGtE3KW/c9HzO4v+0+DiQ7ieuUn6NGeuzt2QDPg496IPk17m+34FobdYatfqgcTK++BW6DK/rRlsvBjaAfRl1+shQiwTmPc0ql9L3Jx/tUiDerzufgqSTs1T01PKHIl9V32x9JvMz0yWq0r2DQkewwhn5jDNogF8yLbCm+5QS13vogtEs9Dz+GG/sHvTcRuT9eC1LlHKMbW36e0Y5l9B9wGoY4GeK9W+iDoU2OmyMOGar6KQYalm3+Aj9FTU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb465407-c0ee-4a57-9451-08dc4d1801b7
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 22:07:48.4728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AlMQpq5gpRfMui+SRvF1p7RmqUKU7L0wnBJenUQfSJSNtdWM5/pF/uFsbOHt/pR2g4G6ZdnkOKqZZvPt/m77UvDqXomppmomgDhEEtdFo0M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7476
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-25_21,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2403210000
 definitions=main-2403250137
X-Proofpoint-GUID: DdyWBLYkycDk6j4zFy256yoUL-26psTQ
X-Proofpoint-ORIG-GUID: DdyWBLYkycDk6j4zFy256yoUL-26psTQ

From: "Darrick J. Wong" <djwong@kernel.org>

commit deb4cd8ba87f17b12c72b3827820d9c703e9fd95 upstream.

Now that we pass the xfs_defer_pending object into the intent item
recovery functions, we know exactly when ownership of the sole refcount
passes from the recovery context to the intent done item.  At that
point, we need to null out dfp_intent so that the recovery mechanism
won't release it.  This should fix the UAF problem reported by Long Li.

Note that we still want to recreate the full deferred work state.  That
will be addressed in the next patches.

Fixes: 2e76f188fd90 ("xfs: cancel intents immediately if process_intents fails")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_log_recover.h |  2 ++
 fs/xfs/xfs_attr_item.c          |  1 +
 fs/xfs/xfs_bmap_item.c          |  2 ++
 fs/xfs/xfs_extfree_item.c       |  2 ++
 fs/xfs/xfs_log_recover.c        | 19 ++++++++++++-------
 fs/xfs/xfs_refcount_item.c      |  1 +
 fs/xfs/xfs_rmap_item.c          |  2 ++
 7 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 271a4ce7375c..13583df9f239 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -155,5 +155,7 @@ xlog_recover_resv(const struct xfs_trans_res *r)
 
 void xlog_recover_intent_item(struct xlog *log, struct xfs_log_item *lip,
 		xfs_lsn_t lsn, unsigned int dfp_type);
+void xlog_recover_transfer_intent(struct xfs_trans *tp,
+		struct xfs_defer_pending *dfp);
 
 #endif	/* __XFS_LOG_RECOVER_H__ */
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 6119a7a480a0..82775e9537df 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -632,6 +632,7 @@ xfs_attri_item_recover(
 
 	args->trans = tp;
 	done_item = xfs_trans_get_attrd(tp, attrip);
+	xlog_recover_transfer_intent(tp, dfp);
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 3ef55de370b5..b6d63b8bdad5 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -524,6 +524,8 @@ xfs_bui_item_recover(
 		goto err_rele;
 
 	budp = xfs_trans_get_bud(tp, buip);
+	xlog_recover_transfer_intent(tp, dfp);
+
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index a8245c5ffe49..c9908fb33765 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -689,7 +689,9 @@ xfs_efi_item_recover(
 	error = xfs_trans_alloc(mp, &resv, 0, 0, 0, &tp);
 	if (error)
 		return error;
+
 	efdp = xfs_trans_get_efd(tp, efip, efip->efi_format.efi_nextents);
+	xlog_recover_transfer_intent(tp, dfp);
 
 	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
 		struct xfs_extent_free_item	fake = {
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index ff768217f2c7..cc14cd1c2282 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2590,13 +2590,6 @@ xlog_recover_process_intents(
 			break;
 		}
 
-		/*
-		 * XXX: @lip could have been freed, so detach the log item from
-		 * the pending item before freeing the pending item.  This does
-		 * not fix the existing UAF bug that occurs if ->iop_recover
-		 * fails after creating the intent done item.
-		 */
-		dfp->dfp_intent = NULL;
 		xfs_defer_cancel_recovery(log->l_mp, dfp);
 	}
 	if (error)
@@ -2630,6 +2623,18 @@ xlog_recover_cancel_intents(
 	}
 }
 
+/*
+ * Transfer ownership of the recovered log intent item to the recovery
+ * transaction.
+ */
+void
+xlog_recover_transfer_intent(
+	struct xfs_trans		*tp,
+	struct xfs_defer_pending	*dfp)
+{
+	dfp->dfp_intent = NULL;
+}
+
 /*
  * This routine performs a transaction to null out a bad inode pointer
  * in an agi unlinked inode hash bucket.
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 3456201aa3e6..f1b259223802 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -523,6 +523,7 @@ xfs_cui_item_recover(
 		return error;
 
 	cudp = xfs_trans_get_cud(tp, cuip);
+	xlog_recover_transfer_intent(tp, dfp);
 
 	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
 		struct xfs_refcount_intent	fake = { };
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index dfd5a3e4b1fb..5e8a02d2b045 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -537,7 +537,9 @@ xfs_rui_item_recover(
 			XFS_TRANS_RESERVE, &tp);
 	if (error)
 		return error;
+
 	rudp = xfs_trans_get_rud(tp, ruip);
+	xlog_recover_transfer_intent(tp, dfp);
 
 	for (i = 0; i < ruip->rui_format.rui_nextents; i++) {
 		struct xfs_rmap_intent	fake = { };
-- 
2.39.3

