Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66AA71739
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711404463; cv=fail; b=VY9fm9DHNHSahEFBbsI5uJMjiZliYs/PhtDDIKBiSXxwMUMdbt9VaEQz+MFYOGjODUAJRPwCEJSWrS5OL6Gnxo2CFoqQWzfprC2i0O8fPNQUu6DbrxHhkvIvDqM4fEzX0keqJribmhbXJe6w2R1WOJgD4otFbSCvZSws2kr7DLk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711404463; c=relaxed/simple;
	bh=/5qo+VfbWAXee5/QDwqbH5Xinqv1lh2Sw73o9/MTn+8=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=shPH0uwcxEJx9pty75BhCwoyRiDzr7Wlm/yM1jSNCye74Px6XCU67f3Leb/oSckJQ5Zmmpq2xy7+ZN+/pVBXejQ1zBQrL3p1ixq8yQDyhI2I2yv/jdpoG/DXtiVX8TVbW/Ur1mAMg4VMzdGTRtTQoG/242Tvzzyng5KAkEWy4bk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RoG2rEbm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Hzw08SO8; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RoG2rEbm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Hzw08SO8"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42PLFtoF012366
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=iBJZ8md6C22QZxlOAS2xsu7E1bKOMxjg6SgEc8VEc6Q=;
 b=RoG2rEbm5ZcC9GF0P0ih0lNMf2Dq7GiF4f/fqIG8Q7dccAjOQ2N7Yo+U8kWVwlglsQlj
 G0VsPEHAQmPPMmNgBcoGqFOgPo87J783fxXqnKRra1PWRxPnkp/c+etdYAn3tM9/V+FF
 Mr0tydrilm8lIB7cbcTVSSsHlzQKljgQH4QEHGXXjTRvztzgCDC4dXlBcMyPqpR3a3fU
 koHC1ZFVRbpLyGgnlZN6qTmmcbOufcWkvrOsvapWvslJfxDu8xOigV1mcxVxA1Sz6b8h
 eXT+gLQ1P+jOEmAPeuHxWQfMjt3mM4DaT8bGQbXpxjKXGGT9b6bYRs6qnVAbVWQh4ZY3 Xw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x2s9gt7dw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:40 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42PKCkLI024462
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:40 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azlp17012018.outbound.protection.outlook.com [40.93.12.18])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh6cce9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eqKf6DAbUrj8UnajAeG0JKUyUA10wVW0m2Zbmz4qcT0c3+WUOI3lgXz3VGap5d3MnQaJWAVhzlEo39nzt/AgLo1VCLgkvXTnQ/qltaAHTDYzKGL4Jvku8So3Fp8ILbh3hXyoFRFubtqeSrdFGaPKCUlxjBiNhC7CZl489DY1UHWy6CUwn+0ZR5hlCHHBJoGy779Bq/MrIpcruXvc9OTHAiBrW/gkzwaeDKl1Ca6PmSDf9YJjm5CBr0RfyhptReeLDwT9dlHoxItftfLYRNARqY7iIXemOb+LLmd0oaiYHJpDR2VJbFt3LrpmIk8msW2OUx/heUjeD20DqpoJy7XRKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iBJZ8md6C22QZxlOAS2xsu7E1bKOMxjg6SgEc8VEc6Q=;
 b=KHmHw6j2oR3lQ9FGHWsbuovNDqocrXep+QJTh0C4b+CAX+YtjE1kcNdCPLNRGPr3HaxRi9Q0z0RqfJjgbpjtlopdO1NxDuuHXQG79HYcqVBfo4CKsaa+Qj+EO8ZGY+d6AblLhdgelOTeqq6JBpTeKfhQYDrq0JRvFTKp3NPE4JWcZvhIEtPcEUQ1a+bMxz+SaCeAto8YGRS9ipAMXjgUMB/YAJyQl6BhTbudpR8NsVTn9pszPzW4ZMwvkJgDqnoAuZdlS7Rsp6uuz4AWRWCxQqN7HEs3pDAVZepXqs4VryZ9kYEI+p7nnbNFoB1poRRuUcHJ5HyswCpYBkuZosKVTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iBJZ8md6C22QZxlOAS2xsu7E1bKOMxjg6SgEc8VEc6Q=;
 b=Hzw08SO8fCufhFPyfU5ArbATESzWEkAn7ITY9EVlA9p3RCuMvI82VBEbSgIFWYctc356wJcEZNGcAegeW7KHAvbVHsFX/f/sLnw+HEH1nYfjL6GcaVZMsDG88yGEoBMqMsJ3zDsifMZKGEm4wmyUv0VsR6+6JlJH+nGrBZKHjXY=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB7476.namprd10.prod.outlook.com (2603:10b6:8:17d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 22:07:38 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Mon, 25 Mar 2024
 22:07:38 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 02/24] xfs: convert rt bitmap extent lengths to xfs_rtbxlen_t
Date: Mon, 25 Mar 2024 15:07:02 -0700
Message-Id: <20240325220724.42216-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240325220724.42216-1-catherine.hoang@oracle.com>
References: <20240325220724.42216-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0023.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::28) To BLAPR10MB5316.namprd10.prod.outlook.com
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
	GdXoh5hTrTmUeCTqvZoifkh1PGNv521v+J8WVOpKec0im/ubMZ7oiFrFUo1YJyMTTASGG2cLtpS8HFWdtaDPe18M3TRFEJnKH/UHEWj1drCyqo57Hy5KtNVIqh02mbHc7RgXCb+ZGo0wrKYYH3o1NU22hSWFUFDhIsleGz/lsLwXycy6u98ErkmprkTsyA/3KYZXwMrfZ5wZm3rUtxtHFtjveOw1E3uKS+oDokLAWPKHQMDvb1/wNlRwezRZUrRDSCHSjbJgrcKGqZ/raNsW6MmZrGoshLGlLP9nV7E456KxDN9J55gkI7PzjiKkLhm2yONouBWZmF51QAU30oRz4O4uirGipwaUU3wvcWy0gHu70GsXl7Gp7pfeFcSgUeLmOyAuJzP5B4PQ8Tl0C7WQw51DbReuGlLh7vQGBB0+OBaL4us6pt7/UEhtbfUJaQV1doXsrg+HMvMwSoPinqyTb4MMPV7B3zu3XVpcOSmshvYpBvTvKY2u3R76nBCvxiw55IxTdXZKIrOwyvvNqLLUGqr+Ke/SrOU1TtpEr5EQRuRJmJ6CdmIuWQWlN5tUWI7qDenSBsz4LtjvSF/NluKeks+ZU7ANd8jjA7LjK2rGO4oXFujJbOmMGpE5TzdSkT+CYZhiPIv3GiKEEXJfO0Y2ncGvxr/o/mnLkuPPnMakEJ8=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?MMpVMGWge2IvHhkk1zi3k4P3HYjkrq2WWDXGhFe7zctZUJCWRkf0YZdGHuQc?=
 =?us-ascii?Q?oHYGEg90KFu6tCOo+5p6RGsQBWWpnysQGZsmfJcjRoRuqR7c1WAEZA+N77RO?=
 =?us-ascii?Q?HBOfSruNFMCdQS4V6+tOBuTy9jX2GSkpWV/xfIPp0LpXH4RuaohD6bmh1MPi?=
 =?us-ascii?Q?TR1yrVQXD1SS7XZHUThcH5zHz0BtF8BhlG6X5vy03MQxmRrMI0HoTQ5ANSHM?=
 =?us-ascii?Q?8KxnKNSLvq1MKRaEcCkwuyKswaY0XMqdRU9QIRRZ1CSXEUbe3iN8oKdtAeVW?=
 =?us-ascii?Q?6Fx+fwwrNnINmod9DVxtD2efZ00PYBnuvxJKvELvMi/M3q9TvROwX9Lh3iPj?=
 =?us-ascii?Q?usqC6ZU1N0xoYhtCjOeoewjM/0ZcBMpuy9fvamF+ajpte8kVLeRbj19GE1FJ?=
 =?us-ascii?Q?aNPtTGc7c2FtemG7wosixIWn8vt455DKr4u+WWqrp2qUcyL+iJZJx9AdFMDe?=
 =?us-ascii?Q?111o7YM2V7YvYXbvBy4P7VsN9grqfqGix1W+3OOZQAkxVumjSisDFcAt6zTy?=
 =?us-ascii?Q?ZyRqvXmSLQbZEDpvQk/u5qpQi3N73Kl2gC+OK9DhWUwH/pV43okcQ2WMhhxF?=
 =?us-ascii?Q?bXBtz3+e5E6gty/FDYsjEZGFqHHTM8OYklF57xV2jrlz+PndgmIGX/WrKlyx?=
 =?us-ascii?Q?JAyVDTt/L6M3X86wnHq3AyoOAqe3Za2PTVIeMCGRM3G/XTZALuOfdcIYT/3b?=
 =?us-ascii?Q?BTRYF45/TaLim2Gy4vnZuxyQuVo2i0zhQcQqB2KumBS+wggNk8eoHB6EoMkw?=
 =?us-ascii?Q?Zc1KxhP03xs3f6AaS5XZy6ChPy8LUx33m630dleDPdsXY5IQccFdELY83czl?=
 =?us-ascii?Q?e6vmPMaucYmAcr8ILrGFBR/A1qPZg9fnROK/K1o8tiY2cO+afdKj3/j2glt1?=
 =?us-ascii?Q?zaLa8o31PfgwIIlPigSOobctF5P9HY8n+Zh8U9yIvL9hLLMQbwMA1jYUdVep?=
 =?us-ascii?Q?AJoqe21DZqIbBbeUG4BX4mXh+VhUAahQM/E3x37+UnPvjk6pHNEQkiqIVWDm?=
 =?us-ascii?Q?TO7RePNfBkAFUFNKO0qHtYrwFTUi7o8GOwbcIMspaPoQjuLUkZxU+x5Uz+bO?=
 =?us-ascii?Q?EVbW9rxRAFlatc6/vMAt5tXyvy1QK+23eUFvH4UcSPrx/6em5J0Qart/SAtr?=
 =?us-ascii?Q?NjrZ/aQtX5IF5JJosnIueD68Yuv4CHJb8XIS823ZVOPy/kt7gVmsI/UpYo4c?=
 =?us-ascii?Q?mbsQmp+J93j1w6SwUNYACFsw9KgzO63gCdz70NVSVPV9AJ04euWB4abAaCt9?=
 =?us-ascii?Q?0FF3ecJBj6yLpN2wJDvKquTUvA9sRNtammds58DgoPkuoy9DnsqFe9Y6NJcz?=
 =?us-ascii?Q?PDgn3snAt/BB0J4YFgKIUAV5/A9RullyEftizkJAPv+JM/8pZxEXXkH3EalP?=
 =?us-ascii?Q?uZALC61APUhLcgpkqplPiQy88XO/ULRaReVnkQ/kAgYiEClFpDGhdzt8WCYo?=
 =?us-ascii?Q?BhsPR4O4dL3mQD1xNQv0FCuU8PGzmI3YDJO3yaG6UTzi9kt6yjjJRH28YbrQ?=
 =?us-ascii?Q?mXtvxLV0QG+cJeWKaAg+OrEn+yibBqdHr63Evx3Mt/Pio6tD8VesV3iZLXmB?=
 =?us-ascii?Q?xaINmwC86bl80JhPrfz4+j0EjvLeFLd4TVpW4dFcOO0/OYwBpZRFhowL0hrp?=
 =?us-ascii?Q?Bi4k9RP6osB/xEW88wYvHB3r3zasE+aa0syqk7ZUZE4TbhRvo4EovryPXD/q?=
 =?us-ascii?Q?QhDnwA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	S3SBgRRFbFSDYnxxP9LEk8/uH6vDlTvvueQpLYrU42LuvR/oDnelaAs5HQIGT+XTL35Oo6YmIlGEKKY4QTYT8lQE33Iugo8pJpEb+asxRiedkj1ntdtTUx08J4vSvXQbRGbRxKE2+avC9VZnYyyoIVHYxNIAvvq1rFGOXL6qNT/TvtVpYTrwAtSZvpASDAGcZKzYDraN8LHByz6TkPDSzDD4k2Lc+zcE++PeTa/ZErTahdiM3A50TOrwr6MygzWgkVPeIea0AoeAbf6rVFpHpEYy6dBvVjbJ5MhIYTi7EXhZWycBXtMkUIbFzDa0G3QTtCOHEoP2MkHUaV6eVCQtSoKpEl6UyUWxGOgoUNgwgaEIndup7um835CVoK+i1VJx2xksijN5e5ROJIJCrS6gb9XdQIZl/B3SdYBTYVFqkvd5mFQTxqyive65k23k7pQjZgkDm+9FBOB+P5u09CTMFxO4xg761h/x5UJRLzLocjWf1mbht8tiQ9CnkgHqmRYtwbTMbwTnHVKOTmatHqsq24COTcipZRtY0Cx/86A2BStxz2efiOcYbD0sYSu2ybfqi12ni1tJ/xr9YWIEnjgNLxl4d3q42KW8QGq6Pc55pNY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6faf5ba-ffb5-4070-0681-08dc4d17fb7b
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 22:07:37.9765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y3Y21KiQWP495pj/FyYVrTceIOokItQX8NVRVi1Fvq3qdlnaE7GNzYQi2ApUuA9iwDMa8qiv75+/usWuKdbEZbEjQbuiOQ0qQqt1UqvyeCc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7476
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-25_21,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403250137
X-Proofpoint-GUID: 6wTWOURHPOt1wVh2y07rgChgePhGiFCh
X-Proofpoint-ORIG-GUID: 6wTWOURHPOt1wVh2y07rgChgePhGiFCh

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

