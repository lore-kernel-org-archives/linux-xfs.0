Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBEB1C10;
	Wed, 27 Mar 2024 00:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711498406; cv=fail; b=kikzElPcUlqCW7wYUNEFoF9sI8xrSlpVauXNQLk3kQQkX+IFie2w10AR+pDn4xCLBjtToagjryLu7Z2M0+tkzL4xDjdU6FzXHdri4pKU1dRkGHbe7f0X+g4QiworVFaUM5tq+HlNwA/xUsfEZ4+PFnvM95S53fqozabOpeYk420=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711498406; c=relaxed/simple;
	bh=/lNuW6I9bQ66GCeG0AUVKivDJGsgnyNQqtROQdvIluw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=C/dKZlTkP7OnifOgRCC5/EYvkBVc89embupZeeLgDzZfydeNTlATt/hCF43xvDD1tVVYkLv55yQspEcXCN+J5Db7wRw6Er7iEwhIwIMoI8qnWdhCNnNVm4Bfj9d1PDWj9E4shg11CceICR0c+dY9gsXR4Vux1ceLvxqDj1Vv554=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GbsKOIi5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tHaTbRbs; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GbsKOIi5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tHaTbRbs"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QLkgQA021526;
	Wed, 27 Mar 2024 00:13:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=ELuv0lHBGNL3nMP3uQqp9PUjqTrEl0sxsWB7xFqi58M=;
 b=GbsKOIi51CrYrEXb+oca3rdWRKmvSDEwHW2fzUbgMLnOOguhtEL9Bfmg82zWLSL/16bu
 hLKEy84yUjXg/+Dgu7JZtFvG4y9CsAZxLTzVAtE+30t8K8c0HuYUCLdtIzIU4RLzQSYI
 NYZ9XuAo6Ap/n/V6qi55w8ecQLWKHlNzTrMIFFZFu9f0bOow6Zr4AI+hYD5u0vNt7eIS
 PgrVCqUboaAfM+vMvikrCFBBb7wPo+tMXAS8HCOc1PwpTwDVaqJPtS93hSFYtxMHIBrg
 Xr6CM68EyoQqXtjqscwrshpMKh6sJ9aIBy6hKhQfa69opoFN2wupCARpX6VbHBdDc7uD yw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1np2ecc3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:24 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42R05MAl020824;
	Wed, 27 Mar 2024 00:13:22 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhe1akw-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GA1zmkxZa9ktxB4SjtbyLmi4gJc14KxcsYWNeatrWi0cwPxm6dtSTq5etXRYKbvethbu5iAJ2lPGCGaZC1JU5eSf5GgKAmq993kkUHNPRNbFYO+iOmCTtLFeCMdPoDToM8UHFiuA3Kgd/vtVpPxl0Hwx9ZsfPfSCaMsjwCTRyDwArhArqXgoQNkUMS5IgZNgV8VjUvRbWwNhe5EWeLg/s4qt4yiKhKwRyuGJ/T4/AcaIm/HnrD9HngmMxhFKehhqgUQNoA3fWhzWoYWqfSZF59TJybGeR0BwyQ7PuQe8zo4xjYI0bz2MGoh+wxf69Rq9orhQclc7WHol2HgWHPig9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ELuv0lHBGNL3nMP3uQqp9PUjqTrEl0sxsWB7xFqi58M=;
 b=f/4Ck5aiDN8xxgXRXh3VhlVi1HZxsxKS2NyLcWTzKuE8opmx2q/7UOGPD+crcoD1MW45PIAeTDiObmjOBgeJH/m0XHugzmHZQ8TeD7GF7TwUdtLTorlSK9STi0Rz8LDQyxud+UHQSFNzXYB8FG1dRcNG7twFTmh224dwu1SbOESug2tb22lZUfl5IoUUN5mG7cUVUnzzXh+XI/T+GMhl4A+yZ4Ld2sCttAYqW6gTVHmREy9U2FTzUqTU8lJWUvbNrXYherpKUrAyXFIiNloxYrCHmG2T3F7jENJ3FzgLaTsmX1UnV3/KYnH7HrSwKo0hstzCOS5rZeBBR0ZCT0f0Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ELuv0lHBGNL3nMP3uQqp9PUjqTrEl0sxsWB7xFqi58M=;
 b=tHaTbRbsGmV9oOvSoqfM7WmZZIdYe7iey+yhL5XebjMl9tVw2wrSYhqyoFM+SEaMaWNmBvXbd4rt+7ai+hq7WyeOMqejIGWwkmZtCTWDV04xjjyCnI+14G8+yzU0L4dtUydmQUqGEmcKvAuPV9tO12FxNx2hLZMd8gkiHy+qDK0=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB4897.namprd10.prod.outlook.com (2603:10b6:208:30f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 00:13:16 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 00:13:16 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 16/24] xfs: add missing nrext64 inode flag check to scrub
Date: Tue, 26 Mar 2024 17:12:25 -0700
Message-Id: <20240327001233.51675-17-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240327001233.51675-1-catherine.hoang@oracle.com>
References: <20240327001233.51675-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0012.namprd13.prod.outlook.com
 (2603:10b6:a03:180::25) To BLAPR10MB5316.namprd10.prod.outlook.com
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
	wzUurcuWK2mrLm1ydE7/kEzf5RZGoK6XgrYe+T9bPQTsYqonZtjJTAvnOOLqyC2PzQsKgEs73sXgc9Lf4ftCanpytEj9suDJZ3zu7seMH6+ev/0phUo4696l6Y8ZpaMxaOcX7Z2LHgv8w/0h5MwJGxXxYL6bvT4H6s9H+GK0PRI3nMp1YUi7rvCVWMTGMzbcrwJF2jlJNkNY2qIcMyhdMB9qVgBLvj+ZK9dWZkzvkjPTZKdmF4dsv6yHQNnmQ1OYo40mCHzslDwAvF8/H4yt699img6stpcIvxT4D3+hoFSMOsXIYZDusUJCaYzYSGlK85U7p3jaZWuomCfXFWOzX4yMr90l4HADBpxwX6O/Y4sfOovOmdyMIM3cNJ2BWno9QMRcSbpvr00/qMzu5s0Gqeaz6ktoHDJ8jD6L7BC0tRwPunt0RL/xGNG+GgaxaSQEaMWXEjwi2mZnJ+OqNsDeRDfaxSZUvulUUHpfkRCeQbiFhWZU+4MCPy3wvD/CGFfvPRa6lZMVz1QBx9jxyFVRJMl/uwy0oSUTEXnUS0/v8yw85Pt32HfhwfMnxHlCUJ8RXCSd14nsOWNLPaqbXzmBw2Or/38xb81e+qHWVqWYZUTG7jyT0vEePX/98aOBGFTtL5JxqwtzUHwx0l0t8P7C3942KqNf88a8WaO0ou4AUhg=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?sVRgE6h91WGmQJQ9P7BdaGlFP15ja4YizSjacIcwg5/RenXGSAGgBufG9TxX?=
 =?us-ascii?Q?mevT1AJkF9HUIhqX1GSyLdM4Tmzv5ddy8CkvhNjxFsxSe7FKUwDGd4EQiGdb?=
 =?us-ascii?Q?FOQwWzLJol8nEYwCClJKHP4Cz+2sFn6LaMQyS4MWYmxcxjQr7lqkH4QVTq63?=
 =?us-ascii?Q?/ahptTDTo8jFsDOxOc6VXTVYtmUMsQyMY+D27Lkpae4gUso3uDab6AmHnB7f?=
 =?us-ascii?Q?egVX+2ZZ0gHfNsJfabBdWqegtKeJwZGgzr3QovNEYflr1MF3mPCxLRFcvL7B?=
 =?us-ascii?Q?x4yi8g9CI+Past05+C7QDb1gwp78Q2XiVQ7KnKLspIBe4bxrTGKTcbZS6JMF?=
 =?us-ascii?Q?2LuR/SNpAbiFv9bw6UJlModRLiHU4IfN0UTgYOVXKQgdO49ITYY+wTp2mpPs?=
 =?us-ascii?Q?kveCz44inLkEagMycSsuzB54tT1mGZBCfUINd8ifa4RqJ7DtgY6IecV2Cp5x?=
 =?us-ascii?Q?kzA8GcXPW5n10tRZ0pZOvmNpFS7CHNFPhJh/6TcD4fflDjdZb+wQvUbHkOO7?=
 =?us-ascii?Q?rgEgVjKKSmpElv+/FjIdol5jrxHR6XRldiBkb7oyXPSKbhBoIuU88MkTZkFN?=
 =?us-ascii?Q?9RY2YZMNeY7Gr5aWEWBJoyDk0Ylcq2gQohntMVpzfxu4byz2TvUJY3I5xYuC?=
 =?us-ascii?Q?BkiSfgWCXtp+BXaJ6rs5brlQ+in9YDedLPbL0mQG8UYmkLrC2XBvybn9avX5?=
 =?us-ascii?Q?E7RZPsE9uBOCAEgSp3Z0wp67nJlyp6ULy5sL4m/N59++yUuz09Et3zE6nwFo?=
 =?us-ascii?Q?geAvtbM4PgVu3tB32nYEWOgWcrruIdiQFzXMnkkn4B5QML43/68Ds2TwutKt?=
 =?us-ascii?Q?23n8/UJDIUm8cf44NhCVbTlH12nB4kziGojf5C/1NDW9Sl2ArWe3JevEh7J6?=
 =?us-ascii?Q?3fQ6t/1nRgiY16nWyJC1xH8JPLbR0ZmBx6xbPZuergBiDgMsRyUt7L3Qo/Fw?=
 =?us-ascii?Q?LjoeQ7WFjcDcEWKD5clIh96VNZUkwg+V5TFo83UUzFOyv96wD8xUIcxb1f5z?=
 =?us-ascii?Q?PbyB8B8h1hb70mJh3FWW9T2k2HiLyYBywkdBlXJ7d2+t0bhTIs4Lmq8nOBRM?=
 =?us-ascii?Q?eMtx2Ec03puv2RLIXnx+Tl46wOP4D07LiEfNmed84QAHw5GuhWDfgeVGgVT+?=
 =?us-ascii?Q?uwN8S80ko98r0nUnXpxFdYhhsOU2mlwNFfg14GWdrq5mj9bsxSWeH42XQb3p?=
 =?us-ascii?Q?0YrjEKWWwtHDtLtnqJcW2NPyBpqZyD1+nVn3gJo52eDpRVqm9taV1+SulN0o?=
 =?us-ascii?Q?+A/puyWKiDPysNf3rmRtTXJiwLWzkBl0xdbETKXmZVWpKxIN7wVz9NwyfpiC?=
 =?us-ascii?Q?QzQHOXcaekQf68jeGLIy9zZ86UbI3hUNYBTkUJdJd3Ujt7P1JARRCK/PlJNz?=
 =?us-ascii?Q?4B9JBPydKYcaSMMlfFk2WOdVFrpI0it9C0rrctD9ZjZm1h31R/lB6SPWw+aE?=
 =?us-ascii?Q?oVHaVkOw77tbgMKlmZPtqhf8c+JVFR4xxyxXH6qAYTCk50fWHm4IdngFjfLb?=
 =?us-ascii?Q?qNZ2RNJxZfpKzt6r9mPV1axZrNEA1Ddys633qylOwOOx0Gfi56l/gt6Qgpic?=
 =?us-ascii?Q?KiFc0nlG+nyCSpuOYyu00N1SBgk0OZs+9HNOAhh7APoc137jcI8w3Z70FMfN?=
 =?us-ascii?Q?tM4GoPrI8+rXaFZJEm7hZwwRifwrTLpDrX3haL/mFEnbe33i5za4go8pGXb1?=
 =?us-ascii?Q?DqtplA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	4HWubCKI/MtbEep9ua7ZbXwHsYNNJGl+/hzOrQAQCr6NiupTG5BPZSc4zsCm163gfdNDmKi6uQyKNH5Lh30crjKfNG9iY5nvYuV692lOIzFJDlm/8LARNcOOVONi+DR1Mk5/3+vSKLUnO/VofvvQyAd8tjZpExI0l+mTaKZWBj6ve70eYMPaN4g5te51wvLvA4FbExjJ8BeAqXycue7SEtktIyBeYUQJrCZ0/Rms9z0GVzBqkJpAuyoCKZMM1QzjUAz9YE/oHwIDVYiirG2lyWUN+OmdEesyMk64GbmXYl/GrFrCsXTSDBlrPiCADoQ0e+2BQ8zmwDxdmmYroHG/VeS5GceVP9PpOh12/tQYpgH97LRTD3369bAn/25f+gsJsSj10Q0WgLsT0tWRZuuV3IFEFa6w9s0XnB+1U0yhZZ1pNjrCUDhGIJk16UtK6fzDZdmPa4LegeL/qFaZ8j+njHSP9gBFnImowMpAMzQZqVZPS7BF+pUvQ4nwfna8guTHljecbzy6QYlb6BfuDNOX/g8xq79iSBem4aJhOFe0lsJS2qeIemb95mwBWlVnxspYFMzOSVnHAfRIqPA7iQwNKHe4DFSx1f1u7OTmRh5Zcg4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f094e911-d1a2-4741-e3da-08dc4df2b339
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 00:13:16.5528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iKj6Ix3GXULqx/A6XTwZRDrgKZDoPK2tfUnczN3qbGMQce2th8d8EfS/SFTus0sjmnDopRM9BSmoP3FdzfkAsifyUDGGy4a7KV6k3QLISYU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4897
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_10,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2403210000
 definitions=main-2403270000
X-Proofpoint-GUID: 3Z3Qp0McVbgZDBcaHd6kE-GapRmdXdFQ
X-Proofpoint-ORIG-GUID: 3Z3Qp0McVbgZDBcaHd6kE-GapRmdXdFQ

From: "Darrick J. Wong" <djwong@kernel.org>

commit 576d30ecb620ae3bc156dfb2a4e91143e7f3256d upstream.

Add this missing check that the superblock nrext64 flag is set if the
inode flag is set.

Fixes: 9b7d16e34bbeb ("xfs: Introduce XFS_DIFLAG2_NREXT64 and associated helpers")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/inode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 74b1ebb40a4c..d03de74fd76f 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -337,6 +337,10 @@ xchk_inode_flags2(
 	if (xfs_dinode_has_bigtime(dip) && !xfs_has_bigtime(mp))
 		goto bad;
 
+	/* no large extent counts without the filesystem feature */
+	if ((flags2 & XFS_DIFLAG2_NREXT64) && !xfs_has_large_extent_counts(mp))
+		goto bad;
+
 	return;
 bad:
 	xchk_ino_set_corrupt(sc, ino);
-- 
2.39.3

