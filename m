Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A09DDA0;
	Wed, 27 Mar 2024 00:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711498374; cv=fail; b=WPC/hlAM4CidWGkSKMr7gbQNgqVkDkJlATxxiS8b7Jh5x5XsfCgCNuMf4JBx1lSMhXP/cPfWUZanbkz0RvBLgoch2DiWc/zl6/XE+0NlacZtYDYQ6mRtOuY7wMbT51FJmO0KNrsK5CcE17a3HHePrecajas1VP1PTyEa3CL5Adw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711498374; c=relaxed/simple;
	bh=4l+0DH9zeDI7Suvn/oDwu2/oJmiqwSjUZePOQbqscLs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jHOsfR6oadIy2npdP2waxI9RZu76UnI63wEJQPX/bMsCoM2EBdZ9IHmnEZQISADSTdu15ItS6Bvp+8ClfuFnXL80G/Dv5hhu8vhFB36AtAg5so2mhYObaIJCQKmZXj/AESo+2pDJD0p18MI+bFM/aq5dT35lPEp4YxuTRaj5pUo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=B/usuY9y; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=j0qx7FpT; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B/usuY9y";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="j0qx7FpT"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QLiWAa026006;
	Wed, 27 Mar 2024 00:12:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=puonQDncL29Iv+ev8S+31dwewaismEPtaTaww+WbBRE=;
 b=B/usuY9yhi4EW/AwTfT3uKAh8a9ERYLun0adTvxsKHnKzfiKNIfuVyq+2s8+c4yxOK9y
 xAWiHbXTHbTTz3Tel+PgMtISe202hvYZlcWlH0BjF65o4RJK0eaCqlnK3WY6DWxWA/Uo
 Laj52hlvd2jrsaUPujagZ0XrnpzmqTlyjgh2HLJ7pLlnKaWFeN4G8VIE8qN/POFq0fnf
 uH+pr8N7g/tTXr82VXz0SeVY3Xhy1D0cuXcRrK5QUIerODgReYrUE12gFf+4Hi847c64
 VgvBQLWUyKeuh14cWm3oRgx/LJN5Yn9cbWcQ1DU6UeSVUzybaT936j9W6L4uapyqFiDv ew== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x2s9gvscj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:12:51 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42R03ovA020681;
	Wed, 27 Mar 2024 00:12:50 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhe1a75-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:12:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l8Gm9uUKF85vQ0dtcPbDaKA5cFWyObBTlHyrMF6LVB35BR8ELg7jrq+Z29BBCFvmokpMRnrTRp+CEBhTCuO0Vk3s+3G+bTFloUILMzFLvh/TgjUmEsufDBR96DZ0gAGmVtGhYYD0QsVYL9P0lP9tQ+6S2eMl4K6Ai1PgniI6eTOdn6UAgszDsCNIuCLezPZmlyNQiyl7QxDjQHW4rM15U1Cfc6WsZVNt4DKu2e4UvLXo5kH7/5tyX/bUIpSv2bAYEycwq2AcBSggdCH7JdXnYhZq4jrqNA/3uy1MtRvPp/xUrhpuSBMG2T2yVJoZNGyyCG4xQBUmvrKPi+kW+5YZOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=puonQDncL29Iv+ev8S+31dwewaismEPtaTaww+WbBRE=;
 b=OFoBAoUrUftwRKU0Yu1TUUjoh6JRREVEk9S/Pcvum6u4Kcf21yNADMUJ0N0yth8h/7+56Qc7fBMJ1r5N/+pdJmQDhKyfL+yeJ6QDVhwWhUE2z/5hU8L2tWQP/EGKZoyF6OHh9VdVELraXTUcTJ6filKFhU/2vTa7XYylfnawo7I0ZtNT8dLfEDHpI8Y584iowosWJjduBXO82tPCRIbP9WVAvqiuir7HrBpWKppr51sZ9s9ziZ5OYVd8SwiOQDDVjmFowBVyCj9TH1PjSz8vKvE0E9oTR2u8YNH2/DmU9UvpW5o7HO1vYyji8EzbE17RcFwyZDucWETc2G77olxZsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=puonQDncL29Iv+ev8S+31dwewaismEPtaTaww+WbBRE=;
 b=j0qx7FpTWHW/Tlwb4LvcgzzhoriGJ6nkHEzzrZq9uYKIKaNUjzjo912MayUSsueKNp9BJrA+A9AWKS9vBYmZWYx69QCtMb0/9+43hRruAx/YDHuqqRBwzf3rTBXl/zQFqlNsMhS2K6Zs3Ry8RGlcWf3kl8G2Wy1Yx28KZfQZYvQ=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH7PR10MB6226.namprd10.prod.outlook.com (2603:10b6:510:1f1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 00:12:47 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 00:12:47 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 02/24] xfs: convert rt bitmap extent lengths to xfs_rtbxlen_t
Date: Tue, 26 Mar 2024 17:12:11 -0700
Message-Id: <20240327001233.51675-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240327001233.51675-1-catherine.hoang@oracle.com>
References: <20240327001233.51675-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0002.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::15) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH7PR10MB6226:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	llfIm9aV8Nf+1IPnfs1mNKV/KNlNK54ylmXzVLJ1+XqnBglSn86CWPYFDZD4QiEyNLfE48pUMPhkq3//aNzHp+o7bpkx2wl87d7opQ47PpjlH7vCil79I7qP6sU4R1u4dG1cdW0lfF5xJuob06ijHXdIOt+HfEnIMpzmgcZvoIn/4XT8I3nYFo0YEoaXGK5eUuyoiXWlYiyhbJXYqbg0QomU8kCTxkqf52oBIVIDPnapgUqB660WFtYPQGkZX8gfwZyGLA9qy05gSYB8Cc5HbF+z6PjzbYyic7qIB8hZjzCkbBOMu4YMtzl3z6Tl1hzLl3lAlkLYV+C/SK0D9Iy+ahwf6/bVo8ufsKw6f7oQYHTqrmntKVX1slNzVy4P1BBXAIKZNFuqotuQRwiKahCCnniTqnZxMdXQUcwcY/8GGuyegdlAd+9f7kVSKr547XT5oCDEn12fmATsYeM6AV/GFk1vGVOVLm8FZlLgoQsl6x205Jf1Pf/naD4cq8vGw+5Zr+A4D/Df8T4EgmHJlS2wyU2SKROoH05kZdbTetXZevPyyeQ6kQGE7h3B9zFjiv5emt0402kaOlk9iCxOJERYWlopVDYCe/vvEDM31TYmALLDImDpI8RsjqTxrVNa5D9RvWvSaXblhc2NLzjyt4FGmMBSQm4uHefzTTDRCV2GuiY=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?07VHyz911JG9WuVhaTiqEFJ5sb7oW+GDh/OlN0ufwX3tBMXmpbmZoUTec8Ta?=
 =?us-ascii?Q?Yf/t3lgkqqAmXZujhsh35JJYwAhWf3nLnECK474mVGzha8wmKi6dk5fp+CPs?=
 =?us-ascii?Q?b5TsvG1l/mILhk/FOtqcC50A32RZ3YxdwGXCUusAgVrapUB3gHvb1K0B7Tw3?=
 =?us-ascii?Q?l7nokqrmVUb3VkeWFDjldRzUgSGUfgGGHJ8dTp4768daOFwP0NbYtQki/vMN?=
 =?us-ascii?Q?Hz+MpxJoN4uoBLyXvbQ2wEKe9yRrGMyfESTYOPdZ0j2Vg7/af3KHEVdtEYeq?=
 =?us-ascii?Q?wwa5RIT0rz2XwAAzkjxj44++JIwa52PopFoRYLblvplt07f1RTftzXNFRboo?=
 =?us-ascii?Q?F7VvwQ2XxXFjcFwzsA/PwzZhkli9czCXGrI2Z+X20it6P9HD173JXz8qyioo?=
 =?us-ascii?Q?xpSpHQIJ+tmgMx963mEQcdaEZO7dfPInlA2T5l5jRThjUo/X5zmOcAkAVyF5?=
 =?us-ascii?Q?ljwV/oM+bfxD9R3vpS4D35rxq+ptNjAzRswRMu5xQfeQE9TH9fsOMI8Mw32Z?=
 =?us-ascii?Q?+CwCiTVuaofhR4duaRYOQroFazKYRbHS6uf4baVRAM0P9Jn8Gqo09T4Ti7qj?=
 =?us-ascii?Q?/iZNU/N442ukwm1kjtHTICj35Il/HREaifRu8zoFMC1AVTDPc0coNfDCGWgh?=
 =?us-ascii?Q?5voThV0FpIsCCBX0EN9AOgbWBVtxW/bH+fi4YGXu5w2BLl+l1jMdrsJ0uk9N?=
 =?us-ascii?Q?yZiz7+Lo8tvNbpbnaYK2c9eSdT5CR0CW9kFpZ+VWlm60jJqQ2O+HUyCJZcuV?=
 =?us-ascii?Q?MMn0s1ng4fAD7PCskldSBLdV/hnR3Yrjyvemdf5uO4suITGUiE7A5hgPz+Nb?=
 =?us-ascii?Q?rks8SFlN62E0/XG4NO74xTr9cgnSJPwOMreV0+3y8od8aVq4jfCTHpHdPddK?=
 =?us-ascii?Q?tmjUSZOO873xwqp6IgzbKPjUlzetdcf8VHtqH5+dgn3I8TSc5tF/W9KSXvB+?=
 =?us-ascii?Q?2jbJt30/1iy8EyEMtlYq5XuO5saY2otg/+zLWESIv0W4dvO2bTeaEQxpFjdv?=
 =?us-ascii?Q?3sKlofEORlI9Afn9L6gvX0bRB5qcBlGx24SPCGNywV45HIJedih7WVqQbnWb?=
 =?us-ascii?Q?LSiVWQejCzs7RFBAVtDTCd63Tmz+XrCvSDZULbrVO15LJzk7mOXlLv4h7a4t?=
 =?us-ascii?Q?38r8DkJwvqOZGC72jQBTyu0uErfpJMW9NtR3LqR5D8yBNz0hwWhswbNDlo4X?=
 =?us-ascii?Q?bjfrWzrwJQeINgki16FkttMMTRb414eW9FYriOYzpTIgPgZR6fyMQ8f6GShL?=
 =?us-ascii?Q?QFfO7LsGKuhQbvjeqRoe+10gzGeDSbL/OzKUgp2HXmAYUBcTDMKiU1I5Ms5O?=
 =?us-ascii?Q?sPLTe2TlPeL2zBkYN1i6SStb8Wh/aqa3V6JZtkHWd0eG4AO++mZXDu0a1ytB?=
 =?us-ascii?Q?51xYR62745+UFua4GWUFp5bMtnkxay00g6f3mOFCkMPw2CC8YtTpNYWg61SG?=
 =?us-ascii?Q?i8ThMa8Hgl3YBYe2JUGk3mVEF+TPOHBxo02nfVe557Fzad1HY9UO+BWRCG7e?=
 =?us-ascii?Q?roJcBIppwq2SdIZT+ZZSk7QCBm1vQLHCLykW1a3qhFGmVFeQWAkMX8KsdFtr?=
 =?us-ascii?Q?Y+/ujkbMQUfRrYQtneEzzKsheWUBHpvtM0+pn9WjLNJnJrwicey3PVCE89yC?=
 =?us-ascii?Q?knuWCVc7Lkquf9+OyPH0bnDz4BT0uPL+NIw1Hmmu5FgBUZwYbGy0pM0uDU6r?=
 =?us-ascii?Q?8I+LIw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	H2FUz00AWggW93HRBdQo4PKcS6pJcQFkdrtbaQIBBxsQNdgr3aXl7Md16NAVrO4GGIuEpw9sr/iSbP2ktO783Vuj3gHh56i5S6YifMgrbWGgYTIz8RTpCrWamqE3dFC1HVBrwkVu/fwkXnTzsH2dlLBP3ITmSsk/8WHlgULhuhVylu4lpFdSr319i4Npk/V6DOxatla5p9JQJ52U7Zfv1EM6vhLSH1GyIBUKWPg1i8foHxipIoMwZiuwTS2iRFac2Q4oerPBh8Nz8h6uuzn67Jp2NW8PxhZ6mZak6JWy40kqLDBthXIJglq3XUoWf+1yvXT9CSx01wp6KaTfRzkCDTG6irKldGRqHr+SVoudC1IAianzMJmp0a6inNJr4tQgc3I1i33E5MkwWB1AkZyxIofxgogJwHaFEDbxuYd5koFf/rvy0KKW2mFwZqcEG4imG7uFnugp6ggj0gadc11iXX3sXmSQDD/BpoapeuxbGg0k4+vW57RgtLciwyXHw99KLBT5f9Ktad6d04PVxwh9cZMHSq0SsW3zZPeJY+MDC2+S+ciNyqq+5UQDA5UPe6E/6DzOjqQ1+Bs9+TcRpQvxJCT832pX5t8ODeiOEcTWKG8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4165790f-43c7-41f8-ad84-08dc4df2a1e3
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 00:12:47.5842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y2lHdwGDEU9xLXMneHTXLwrvdi56g4pHu5Y2Hm34LLRD3OupgpyWHrB1NfZ09FNP3IjdZZ1hesPnXVa0Ir+FoIOoXK3j6cRLAtX7uymrtEQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6226
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_10,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2403210000
 definitions=main-2403270000
X-Proofpoint-GUID: tbs13oaQfst--hdoNO8TEjMvEBea2kpU
X-Proofpoint-ORIG-GUID: tbs13oaQfst--hdoNO8TEjMvEBea2kpU

From: "Darrick J. Wong" <djwong@kernel.org>

commit f29c3e745dc253bf9d9d06ddc36af1a534ba1dd0 upstream.

XFS uses xfs_rtblock_t for many different uses, which makes it much more
difficult to perform a unit analysis on the codebase.  One of these
(ab)uses is when we need to store the length of a free space extent as
stored in the realtime bitmap.  Because there can be up to 2^64 realtime
extents in a filesystem, we need a new type that is larger than
xfs_rtxlen_t for callers that are querying the bitmap directly.  This
means scrub and growfs.

Create this type as "xfs_rtbxlen_t" and use it to store 64-bit rtx
lengths.  'b' stands for 'bitmap' or 'big'; reader's choice.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h   | 2 +-
 fs/xfs/libxfs/xfs_rtbitmap.h | 2 +-
 fs/xfs/libxfs/xfs_types.h    | 1 +
 fs/xfs/scrub/trace.h         | 3 ++-
 4 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 371dc07233e0..20acb8573d7a 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -98,7 +98,7 @@ typedef struct xfs_sb {
 	uint32_t	sb_blocksize;	/* logical block size, bytes */
 	xfs_rfsblock_t	sb_dblocks;	/* number of data blocks */
 	xfs_rfsblock_t	sb_rblocks;	/* number of realtime blocks */
-	xfs_rtblock_t	sb_rextents;	/* number of realtime extents */
+	xfs_rtbxlen_t	sb_rextents;	/* number of realtime extents */
 	uuid_t		sb_uuid;	/* user-visible file system unique id */
 	xfs_fsblock_t	sb_logstart;	/* starting block of log if internal */
 	xfs_ino_t	sb_rootino;	/* root inode number */
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 546dea34bb37..c3ef22e67aa3 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -13,7 +13,7 @@
  */
 struct xfs_rtalloc_rec {
 	xfs_rtblock_t		ar_startext;
-	xfs_rtblock_t		ar_extcount;
+	xfs_rtbxlen_t		ar_extcount;
 };
 
 typedef int (*xfs_rtalloc_query_range_fn)(
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 851220021484..6b1a2e923360 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -31,6 +31,7 @@ typedef uint64_t	xfs_rfsblock_t;	/* blockno in filesystem (raw) */
 typedef uint64_t	xfs_rtblock_t;	/* extent (block) in realtime area */
 typedef uint64_t	xfs_fileoff_t;	/* block number in a file */
 typedef uint64_t	xfs_filblks_t;	/* number of blocks in a file */
+typedef uint64_t	xfs_rtbxlen_t;	/* rtbitmap extent length in rtextents */
 
 typedef int64_t		xfs_srtblock_t;	/* signed version of xfs_rtblock_t */
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index cbd4d01e253c..df49ca2e8c23 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1037,7 +1037,8 @@ TRACE_EVENT(xfarray_sort_stats,
 #ifdef CONFIG_XFS_RT
 TRACE_EVENT(xchk_rtsum_record_free,
 	TP_PROTO(struct xfs_mount *mp, xfs_rtblock_t start,
-		 uint64_t len, unsigned int log, loff_t pos, xfs_suminfo_t v),
+		 xfs_rtbxlen_t len, unsigned int log, loff_t pos,
+		 xfs_suminfo_t v),
 	TP_ARGS(mp, start, len, log, pos, v),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
-- 
2.39.3

