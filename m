Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B59D70CC8
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711404462; cv=fail; b=JrF/47zbbBQZOA5a/ZO3DOIIRcTUA2Fm3c2vTRuXk6ORHwrtni1UQQfiB8y17l3csfiXM08OlDuadqsxKoCOzXbWU76yS9yTKnma2E2ds/powmW1UGqNbcowDcZMw+/5s4W9WkHsMR80YGqF6KVD+Sqhwsx8Bt6I0iPROtVmznE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711404462; c=relaxed/simple;
	bh=0K4zk+lMoVKo+zwzs/pxH6rmVtX/qqUwMruZ+R9wjbo=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nFo0s4i/Nxc1Iu83LBTrOeh8ytTzhuYYC0UwBYYuk0kiJvTOnXItfd67FcDIslrYiFe0npqGA3JqquKdq5VwZ8QFuPCF58JkfwfxxB4fucRpSW2xvD5sYXpfawkVAfV4Mqt7eLuOk5G6cgL2WPXA7tcOY9TA9qV1Pq80NAQWkPI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JNFzDPRS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=sBW1WjRI; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JNFzDPRS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="sBW1WjRI"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42PLFuKr012544
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=xctqRtu0tlSuh0UjmGybbrOqdhfcGs6vdWuB3jjBHJE=;
 b=JNFzDPRSygZPSjKj6KBlq5Poxop/FhWAQvH2j08gPHP+oSDhEuF0tpQgw0uPUDFQX/Jt
 NdM214p9vU0ZW79sVWE9uTBwYvFFMfS3zOS3CnvQBf/G6+6O2LdQTHfQtXwcOjP1Zc/0
 aB61+lYecETEiFkuKFbr0fe4XBuOYgGca0qy+R9ZEdn65nUD/W9RuB6wpdh8WXOptpfa
 ZaD6jCIkE3wyn9qRYIg/VFDepsWj3jntk/vQsmb4ZVDpyfPRBN3yBEpB802hGHhwXTZa
 WMQvqtKSJZvMKkMI+0ikkyfCmXugDb40Ww6gBV8JNoIoNexnL73NsNV+Nv+EvORlcOnU aw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x2s9gt7dv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:39 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42PKGKdI015967
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:38 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azlp17012016.outbound.protection.outlook.com [40.93.12.16])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh64qxx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZHZBm7iBTrRA9cM4bn23VOHqnZzYBZJubLAIuYP8BmXnV1nG5uag8BowKEjYCeg0UemHNvKPnhzVbThzyRtaHH95PxdoOUS50ewhu3STImmAxvLkKE2ncnJ0rghmQka7z9U6q0Z4eS9x4kU0BjJuhmv4K/pbgnbC0jvwkFNXGNIfmtn3Q6j3/hwql931zfoyqLrPNW7TGvj23Dy12Ol4vWQdhxKKH9aXSUb1TrbNKOWrtPhoyWwrAcTyod3zu9Nx0RgjmvPkm4ffg4VoUdJZP3FfPfx1xQyMGuOG9O2DPZLmHfA3GOfXuPFmts7OTjBau3wDroebqR1aVj2ykFBGCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xctqRtu0tlSuh0UjmGybbrOqdhfcGs6vdWuB3jjBHJE=;
 b=B6knnsZBLqT7yn7NXbBZgeYfMNZbN6/HyAlTKkWaoPLkTQYjpbugaRvpAnqbaMI/ga5oo8B0yS+dKvT8ciEt9zGIMoNwyRGCrb8oyFvu/RrAvVNYHNLUwSSiddyuU0OvLILiUpanLy1PkAgHj+/tQwUuM0V0spqe2mqh/nuaw+lD0w6jTNW19m+7pg3MHRSysq5/FVnJ1d8lOjGSdPRicTq6iWcwZ9AZ6rZq+FiTHEto3QijU3naObz2TodT1aiKo0k9OfU24PYB13q+p9J4L+ShHIHAJjbjccXxtxtI0WQ3Cq0kuXDMTwfeBntSCkHG0M3ov5qGOEZqNZingQPNvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xctqRtu0tlSuh0UjmGybbrOqdhfcGs6vdWuB3jjBHJE=;
 b=sBW1WjRI1Q6M9h0UzFpMvu6TYxpp0KdEPQBrl4Co29DAkO3r9N8Gq+jV3g4LmHnyNDx5FfmagTFZYMuqv5fx8cSTximhW0q988YvgSHNzlwHd2hQNMgXys4CmvoQMG69PsLvKxvBJPW2GQaiuregDAqirfsGKOcDtOL6prBNA2g=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB7476.namprd10.prod.outlook.com (2603:10b6:8:17d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 22:07:36 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Mon, 25 Mar 2024
 22:07:36 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 01/24] xfs: move the xfs_rtbitmap.c declarations to xfs_rtbitmap.h
Date: Mon, 25 Mar 2024 15:07:01 -0700
Message-Id: <20240325220724.42216-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240325220724.42216-1-catherine.hoang@oracle.com>
References: <20240325220724.42216-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::32) To BLAPR10MB5316.namprd10.prod.outlook.com
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
	xf29q2mPCFh60KpVovjsOCshQ/weLDfIrXHYRsnwmKt1U3CLoCdpBo9WPK7VbINREfmisB2xhl9vaNeSJHIgdqWxjjWWI8wmkhD5/dhI0MLtM0P9tLaJxFVLdM6MjcPstrfqOL8eVNhD+6313wY1T4CE7N6agHmH2fIzAePUeprX8n1dPovGjC++f7g5kLb8yY2mY6lOLeyhFVs4adkkgEnQBvxLvisfHJi6eW0oR0ESr+BWZGdU3NRiLMhOmaZtKySMDRrjGtGVrWXeGzgDIDmLZIWsA6t/DZDfjkMq9P1OQ3UtjTWT6TTg0f91fY27B1pxGFVzsuU5s7AZ5iGIjORINzQd1RPKpt7Sddc52yAI2UtgOlIsYTvsnIbSYCsNjxRruWfV7qd2v1iifSQ3C2BgOvtZvsduBrEj55q7xuMWTKjBHCgrpIyoTWbt/z0Yl7YCmnxldso/t3WQRSXYZpKrWNpDC+8Zj9bsQHQxdLFbtg47hQwIaKpQla30KXBseaqxyVYEXAKwkvl1vbJQ2pmyx3pas0GYFsrePas4okX/mbVE9Dln+pz1TjYqE/ZGrtxkY2dTJKft3CV1VSFL4qQN70UhHt9wXVrjKGYqACUCXmgPt9KHV3ciy+5Zs3Drques6pOLmRFX0qTixtfcQ7gkBfc3XbUewawEbJExqqU=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?hm7Eeehanrc6I/vNib7YbllFqCd+GQI7AzPSCEWAsn5OvdroMvJO8r4/05Ed?=
 =?us-ascii?Q?bzEe3qKJLztAFwl/Jo88v2v8r6s2v4VfO2NkUNX3YV2EjwCeRxd+A1fLbTDJ?=
 =?us-ascii?Q?kL35pXgyIjmTfibHg9g4GvftNkYjdUGrfKSSiT133gwO5cS4RyiLDMvsxgec?=
 =?us-ascii?Q?oHgglpqj6ueKTcYZ6/5DhTIUelEhX5ynqj/4CUICodWKT3mKWVcSlZz1ltbG?=
 =?us-ascii?Q?F+QCPaGhBUSpU+1+Qa5+JAA9PZXFThYC6QXFvSVkWmtf6pIX1s1oTkZTXypf?=
 =?us-ascii?Q?EBRdoetbP19dU5tDg1K4oeBCXYSru8jzV++IQuKCbeMeE6jLkHG0kJB9aCQf?=
 =?us-ascii?Q?PpHYLTZYGKqWRWmwyp/AJ4JdUjtFJyTCxdazRP6d0vU7R6CKD6z1gbCk9jwn?=
 =?us-ascii?Q?1soFq2eRBZHaapK2VOMVI/4go2X4X95ISv4TlymkboYRP1mT5aOwyhe8ZHje?=
 =?us-ascii?Q?nffO8CZA+ATN5Ro3Gcuk58OjCGC+kLHwdHPYA9LT9epbN7Rjs7RdjGQFYTN0?=
 =?us-ascii?Q?a/3oxprdNdrjJqc+wHgoLyo0srgL8RzCuzr2Do/4pAGq+Gwr1pUdrEH93smq?=
 =?us-ascii?Q?Hb4r5ERYrIY4RIbb0s3VBhGE0tyVMnNtPkO+FXwH6MtfH0m+1zNg5bm+z1fC?=
 =?us-ascii?Q?n2XI8E6Z7/Cgcxo5ymrgDh+AfcCM7USeV7ja2XItFU675GpR8VjQLxfuc+/a?=
 =?us-ascii?Q?cppBFRCl9OI8n0ICV0CiCjrA47cvtGWA+CLEmeWi6tyo+TzPedOFlCQJS03x?=
 =?us-ascii?Q?RybO8c/21i4t5JvjjmvxUzb9D2FJGsHOzrRgqGFFyXxkpngWeMTAi4DToRHh?=
 =?us-ascii?Q?sumBtXKqMmreMhh3TJ70rpUtd8by3j+LQy1f/y1AB/iLWea0G3qJdtETwcUa?=
 =?us-ascii?Q?FlEaTlCs8q7EXr6NDQqlGJGQy8Im8DJclXRM6bZDhSDU+r2knxmtwIuJdhMu?=
 =?us-ascii?Q?602qehsPtvjtW3qhwyUNfi6MJOxlwZ0fPhjQWHSCAjz7oBJM8cZt/uJpHDAg?=
 =?us-ascii?Q?mMO99PdZRaCviUBW77qo6/Tmr1rA0hborfijg14T1QgEOBAGxooyvU0Q/k79?=
 =?us-ascii?Q?i5o+feLazzH416Nl8ih/ck5lCpHZ8GJ/q/q7mKalEE1UXGYYCLyYMtvQuAgA?=
 =?us-ascii?Q?kCbd6HUbkG5Pi3dGy5gMO9VlKkxlMg5ICxYxyB7Cr7CPbStKdjgXuxitnpb6?=
 =?us-ascii?Q?EIKWQWyw+kdLY/mgVPo+Y1dTeM1n9XutPGimZJbOtmxR6DA/AzyZBAVLMlaD?=
 =?us-ascii?Q?MubHxtMgUrHai2jpNDPbGBUXpE3E0sY6xHmSVoAF1vnQ5kPR8+ycD39+05Cy?=
 =?us-ascii?Q?Pq5sTWVjjtZ3zPaVk7bhcrdueCimtcw2vLENmmBtGuKIpNE0v7KfhY7qAcH7?=
 =?us-ascii?Q?Mjc5wYtgQd1u4ZZgR6eh9cO5xDcWqLKDTZO66cdvVv+TolWqxI9Q+0EMUo66?=
 =?us-ascii?Q?VNeQ0k0LKdxptbfhiknbIhXxL/uQe+k52B24gkHGesWQjOQ1JEWOw9ov/9P5?=
 =?us-ascii?Q?ATz95PbZtkZtBRjysCPQje6eqWUJyDFd+I4ZuEDTKqCRMrpExrfWtE50xy8S?=
 =?us-ascii?Q?vhjsGRKZFSBlHDJRKfqMsJvzwHhHfDR8SXglaCigzz7drCaTOOt7mR2vrbXf?=
 =?us-ascii?Q?wG0F+VnLVn0twEQFJMSW9XsguwNefq8rFZmWoZAFC1xtWbvsBInRIHL0JEMf?=
 =?us-ascii?Q?xer8LA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	SmIiLzcjzR9UudH0XsIxY0XP2arTdhfTfDQ2nnjXZeoiJVGmraVwNngliU6I3lVSrVDvYgnOFR9xNdJvTLYqe20/wwb4drCAH3pD311wwAncyTj6O5VXtnCHGwYZxP0S6by0154hRj5U4oyC2MS4KhgvdIaVxyB56eON3hhcatLupwUtLt+zmIPowQFW4R9OjX9MSi1zdP4W6qSH2twH0el6013jUv54vIotOAOirByxPlsxmtyni6xXb5Fo3LXRaQwiBaH7OaP0PJyLO61iMllMmW633EFMiTvSwRMtecWRhsJrmbMQIn8QDvNLf/LlmfN95qZViopc7GCoF377r9fTAyma/9xDzTq+dZDFqwL14WZ/QYLHNW2ELqiRSQUrnfIoBzHMb/Y3dLtmhGRIMuldISr50V4jnatrYLcfQgWAS15mvv7V7a8Eunm8BGZrJnxbJsa9/eeNzhN/l0reqPvf2B7UxjnisVzPPJdgIMvo8xbILlihG9sp2eAaNqte4L1EOJv/ecECHoBwI5knwcBl3fQlW9S8mAkw/cx/s+kwcyCr8ziP3sdWDh0h0/wck39eyjMUUk5qOHnnQg7GTwOMyy0YElFwrMj2C+Kc5HQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa2c2684-c991-4473-4e3f-08dc4d17fa71
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 22:07:36.2564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZmRX+KPVnYDUMcU+1meH0/DfG5MmneBUUTdey+dwu0qbNBs8gUO2VOI0AD891q0GUGIkgW39CzmXwsDQNOPtcxsYHsOcr5rxXwLdRP5yXVY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7476
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-25_22,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403250137
X-Proofpoint-GUID: grG5vILlX9mf6e27zQatvJEJIGGrv1xy
X-Proofpoint-ORIG-GUID: grG5vILlX9mf6e27zQatvJEJIGGrv1xy

From: "Darrick J. Wong" <djwong@kernel.org>

commit 13928113fc5b5e79c91796290a99ed991ac0efe2 upstream.

Move all the declarations for functionality in xfs_rtbitmap.c into a
separate xfs_rtbitmap.h header file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c     |  2 +-
 fs/xfs/libxfs/xfs_rtbitmap.c |  1 +
 fs/xfs/libxfs/xfs_rtbitmap.h | 82 ++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/fscounters.c    |  2 +-
 fs/xfs/scrub/rtbitmap.c      |  2 +-
 fs/xfs/scrub/rtsummary.c     |  2 +-
 fs/xfs/xfs_fsmap.c           |  2 +-
 fs/xfs/xfs_rtalloc.c         |  1 +
 fs/xfs/xfs_rtalloc.h         | 73 --------------------------------
 9 files changed, 89 insertions(+), 78 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rtbitmap.h

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 617cc7e78e38..a47da8d3d1bc 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -21,7 +21,7 @@
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_rtalloc.h"
+#include "xfs_rtbitmap.h"
 #include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_quota.h"
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 655108a4cd05..9eb1b5aa7e35 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -16,6 +16,7 @@
 #include "xfs_trans.h"
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
+#include "xfs_rtbitmap.h"
 
 /*
  * Realtime allocator bitmap functions shared with userspace.
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
new file mode 100644
index 000000000000..546dea34bb37
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef __XFS_RTBITMAP_H__
+#define	__XFS_RTBITMAP_H__
+
+/*
+ * XXX: Most of the realtime allocation functions deal in units of realtime
+ * extents, not realtime blocks.  This looks funny when paired with the type
+ * name and screams for a larger cleanup.
+ */
+struct xfs_rtalloc_rec {
+	xfs_rtblock_t		ar_startext;
+	xfs_rtblock_t		ar_extcount;
+};
+
+typedef int (*xfs_rtalloc_query_range_fn)(
+	struct xfs_mount		*mp,
+	struct xfs_trans		*tp,
+	const struct xfs_rtalloc_rec	*rec,
+	void				*priv);
+
+#ifdef CONFIG_XFS_RT
+int xfs_rtbuf_get(struct xfs_mount *mp, struct xfs_trans *tp,
+		  xfs_rtblock_t block, int issum, struct xfs_buf **bpp);
+int xfs_rtcheck_range(struct xfs_mount *mp, struct xfs_trans *tp,
+		      xfs_rtblock_t start, xfs_extlen_t len, int val,
+		      xfs_rtblock_t *new, int *stat);
+int xfs_rtfind_back(struct xfs_mount *mp, struct xfs_trans *tp,
+		    xfs_rtblock_t start, xfs_rtblock_t limit,
+		    xfs_rtblock_t *rtblock);
+int xfs_rtfind_forw(struct xfs_mount *mp, struct xfs_trans *tp,
+		    xfs_rtblock_t start, xfs_rtblock_t limit,
+		    xfs_rtblock_t *rtblock);
+int xfs_rtmodify_range(struct xfs_mount *mp, struct xfs_trans *tp,
+		       xfs_rtblock_t start, xfs_extlen_t len, int val);
+int xfs_rtmodify_summary_int(struct xfs_mount *mp, struct xfs_trans *tp,
+			     int log, xfs_rtblock_t bbno, int delta,
+			     struct xfs_buf **rbpp, xfs_fsblock_t *rsb,
+			     xfs_suminfo_t *sum);
+int xfs_rtmodify_summary(struct xfs_mount *mp, struct xfs_trans *tp, int log,
+			 xfs_rtblock_t bbno, int delta, struct xfs_buf **rbpp,
+			 xfs_fsblock_t *rsb);
+int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
+		     xfs_rtblock_t start, xfs_extlen_t len,
+		     struct xfs_buf **rbpp, xfs_fsblock_t *rsb);
+int xfs_rtalloc_query_range(struct xfs_mount *mp, struct xfs_trans *tp,
+		const struct xfs_rtalloc_rec *low_rec,
+		const struct xfs_rtalloc_rec *high_rec,
+		xfs_rtalloc_query_range_fn fn, void *priv);
+int xfs_rtalloc_query_all(struct xfs_mount *mp, struct xfs_trans *tp,
+			  xfs_rtalloc_query_range_fn fn,
+			  void *priv);
+bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
+int xfs_rtalloc_extent_is_free(struct xfs_mount *mp, struct xfs_trans *tp,
+			       xfs_rtblock_t start, xfs_extlen_t len,
+			       bool *is_free);
+/*
+ * Free an extent in the realtime subvolume.  Length is expressed in
+ * realtime extents, as is the block number.
+ */
+int					/* error */
+xfs_rtfree_extent(
+	struct xfs_trans	*tp,	/* transaction pointer */
+	xfs_rtblock_t		bno,	/* starting block number to free */
+	xfs_extlen_t		len);	/* length of extent freed */
+
+/* Same as above, but in units of rt blocks. */
+int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
+		xfs_filblks_t rtlen);
+#else /* CONFIG_XFS_RT */
+# define xfs_rtfree_extent(t,b,l)			(-ENOSYS)
+# define xfs_rtfree_blocks(t,rb,rl)			(-ENOSYS)
+# define xfs_rtalloc_query_range(m,t,l,h,f,p)		(-ENOSYS)
+# define xfs_rtalloc_query_all(m,t,f,p)			(-ENOSYS)
+# define xfs_rtbuf_get(m,t,b,i,p)			(-ENOSYS)
+# define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
+#endif /* CONFIG_XFS_RT */
+
+#endif /* __XFS_RTBITMAP_H__ */
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 05be757668bb..5799e9a94f1f 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -16,7 +16,7 @@
 #include "xfs_health.h"
 #include "xfs_btree.h"
 #include "xfs_ag.h"
-#include "xfs_rtalloc.h"
+#include "xfs_rtbitmap.h"
 #include "xfs_inode.h"
 #include "xfs_icache.h"
 #include "scrub/scrub.h"
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 008ddb599e13..2e5fd52f7af3 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -11,7 +11,7 @@
 #include "xfs_mount.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
-#include "xfs_rtalloc.h"
+#include "xfs_rtbitmap.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
 #include "scrub/scrub.h"
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 437ed9acbb27..f4635a920470 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -13,7 +13,7 @@
 #include "xfs_inode.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
-#include "xfs_rtalloc.h"
+#include "xfs_rtbitmap.h"
 #include "xfs_bit.h"
 #include "xfs_bmap.h"
 #include "scrub/scrub.h"
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 736e5545f584..8982c5d6cbd0 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -23,7 +23,7 @@
 #include "xfs_refcount.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_alloc_btree.h"
-#include "xfs_rtalloc.h"
+#include "xfs_rtbitmap.h"
 #include "xfs_ag.h"
 
 /* Convert an xfs_fsmap to an fsmap. */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 0e4e2df08aed..f2eb0c8b595d 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -19,6 +19,7 @@
 #include "xfs_icache.h"
 #include "xfs_rtalloc.h"
 #include "xfs_sb.h"
+#include "xfs_rtbitmap.h"
 
 /*
  * Read and return the summary information for a given extent size,
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 65c284e9d33e..11859c259a1c 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -11,22 +11,6 @@
 struct xfs_mount;
 struct xfs_trans;
 
-/*
- * XXX: Most of the realtime allocation functions deal in units of realtime
- * extents, not realtime blocks.  This looks funny when paired with the type
- * name and screams for a larger cleanup.
- */
-struct xfs_rtalloc_rec {
-	xfs_rtblock_t		ar_startext;
-	xfs_rtblock_t		ar_extcount;
-};
-
-typedef int (*xfs_rtalloc_query_range_fn)(
-	struct xfs_mount		*mp,
-	struct xfs_trans		*tp,
-	const struct xfs_rtalloc_rec	*rec,
-	void				*priv);
-
 #ifdef CONFIG_XFS_RT
 /*
  * Function prototypes for exported functions.
@@ -48,19 +32,6 @@ xfs_rtallocate_extent(
 	xfs_extlen_t		prod,	/* extent product factor */
 	xfs_rtblock_t		*rtblock); /* out: start block allocated */
 
-/*
- * Free an extent in the realtime subvolume.  Length is expressed in
- * realtime extents, as is the block number.
- */
-int					/* error */
-xfs_rtfree_extent(
-	struct xfs_trans	*tp,	/* transaction pointer */
-	xfs_rtblock_t		bno,	/* starting block number to free */
-	xfs_extlen_t		len);	/* length of extent freed */
-
-/* Same as above, but in units of rt blocks. */
-int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
-		xfs_filblks_t rtlen);
 
 /*
  * Initialize realtime fields in the mount structure.
@@ -102,55 +73,11 @@ xfs_growfs_rt(
 	struct xfs_mount	*mp,	/* file system mount structure */
 	xfs_growfs_rt_t		*in);	/* user supplied growfs struct */
 
-/*
- * From xfs_rtbitmap.c
- */
-int xfs_rtbuf_get(struct xfs_mount *mp, struct xfs_trans *tp,
-		  xfs_rtblock_t block, int issum, struct xfs_buf **bpp);
-int xfs_rtcheck_range(struct xfs_mount *mp, struct xfs_trans *tp,
-		      xfs_rtblock_t start, xfs_extlen_t len, int val,
-		      xfs_rtblock_t *new, int *stat);
-int xfs_rtfind_back(struct xfs_mount *mp, struct xfs_trans *tp,
-		    xfs_rtblock_t start, xfs_rtblock_t limit,
-		    xfs_rtblock_t *rtblock);
-int xfs_rtfind_forw(struct xfs_mount *mp, struct xfs_trans *tp,
-		    xfs_rtblock_t start, xfs_rtblock_t limit,
-		    xfs_rtblock_t *rtblock);
-int xfs_rtmodify_range(struct xfs_mount *mp, struct xfs_trans *tp,
-		       xfs_rtblock_t start, xfs_extlen_t len, int val);
-int xfs_rtmodify_summary_int(struct xfs_mount *mp, struct xfs_trans *tp,
-			     int log, xfs_rtblock_t bbno, int delta,
-			     struct xfs_buf **rbpp, xfs_fsblock_t *rsb,
-			     xfs_suminfo_t *sum);
-int xfs_rtmodify_summary(struct xfs_mount *mp, struct xfs_trans *tp, int log,
-			 xfs_rtblock_t bbno, int delta, struct xfs_buf **rbpp,
-			 xfs_fsblock_t *rsb);
-int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
-		     xfs_rtblock_t start, xfs_extlen_t len,
-		     struct xfs_buf **rbpp, xfs_fsblock_t *rsb);
-int xfs_rtalloc_query_range(struct xfs_mount *mp, struct xfs_trans *tp,
-		const struct xfs_rtalloc_rec *low_rec,
-		const struct xfs_rtalloc_rec *high_rec,
-		xfs_rtalloc_query_range_fn fn, void *priv);
-int xfs_rtalloc_query_all(struct xfs_mount *mp, struct xfs_trans *tp,
-			  xfs_rtalloc_query_range_fn fn,
-			  void *priv);
-bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
-int xfs_rtalloc_extent_is_free(struct xfs_mount *mp, struct xfs_trans *tp,
-			       xfs_rtblock_t start, xfs_extlen_t len,
-			       bool *is_free);
 int xfs_rtalloc_reinit_frextents(struct xfs_mount *mp);
 #else
 # define xfs_rtallocate_extent(t,b,min,max,l,f,p,rb)	(-ENOSYS)
-# define xfs_rtfree_extent(t,b,l)			(-ENOSYS)
-# define xfs_rtfree_blocks(t,rb,rl)			(-ENOSYS)
 # define xfs_rtpick_extent(m,t,l,rb)			(-ENOSYS)
 # define xfs_growfs_rt(mp,in)				(-ENOSYS)
-# define xfs_rtalloc_query_range(m,t,l,h,f,p)		(-ENOSYS)
-# define xfs_rtalloc_query_all(m,t,f,p)			(-ENOSYS)
-# define xfs_rtbuf_get(m,t,b,i,p)			(-ENOSYS)
-# define xfs_verify_rtbno(m, r)				(false)
-# define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
 # define xfs_rtalloc_reinit_frextents(m)		(0)
 static inline int		/* error */
 xfs_rtmount_init(
-- 
2.39.3

