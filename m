Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65B94C3AA
	for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2024 22:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707171629; cv=fail; b=L1DPKBfZsLijDts2d8Usr/san9ihLTtl4wN8JN6bl24LPU6ZiRNShBwWAmw7QKoriAg2SpDj3VEIftsR10d69UpijpIISTZ/OKaqmEFDJ6Edf/dpOIUv96evRwD9iQ90dVNoWxp8To4hYrvxGKvz1NlO3Ej7sUyXZqFl01DDKC0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707171629; c=relaxed/simple;
	bh=VvzN4yu1fmQ0VYqSjtKVezznRw0LavjhUkFiu0aYWsM=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gZyq0UpLmklVMsOpuaOQMOI0Wkie2/YMfF4DUOQnQWws66Oup7qoTh+HOg5XgdA4JM1dpn9UDBzXjjXeZv3/P2PW7Xn5gFjWjmLrvabnNoM1+FbVZGjpd3OBOdCeZg7JHo5Lc3JOzU4DqxmhdUMsuWH+uM4pjt5knpcmNe6MtY0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NfamavOb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WR1VJn2g; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NfamavOb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WR1VJn2g"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 415LEBhC017450
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=BlYNkxjGWSfbfZQ+XxFjmVB/mlx/td51hSe1ITYbYsk=;
 b=NfamavObzozLFfbGAPlUz+QynpFk/ZN2/kA3LFPDVsaX66YJobvi1qqZpicvMxD/D22y
 BWUblrvlKkSEzTtU9dprvmTmhBZDw4fnG+dLbGg46LkiVRWRX8P3PKiviqkg+UAVeW+F
 t4KMFOjvyXGyGYquREDTCkZ+f6BKY1KFb00Im+4xao2+NgMktG6bN3Jm7Qw16C6pnLXN
 UrNYdN+UtIF+ZFT52UzdW1NDzb5E+iKV6PUTqOEZCr8jG00Ehrhay1Fi3LaHxz1zdg7C
 6hY7w1/r2VwmaNPFjCbILcbZnsWsyy2YBCrGBJZJfqzGGVGBEPdW4iCpWswzTfvlttsM xg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1d3ud830-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:26 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 415LBaFS007074
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:25 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bx6k59j-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dx54Eo0bQ4ISl1PCJJYQHa3RlOMiyaGpl3++7v6N0WRj3JyJrxOt39pjshAWnmiF48R3QPdjEa6zowgNvO/el2xxFImRijKyzmKvAvjifOclyNVXT6tZjBEah+M7tQrrBE9x2IHNsQ0z9qjM0O8KDSHXq+oS54CK0ezAcpT9dwh0qD+nIldFebb7ueXVBgjjSu+0gDKN4ySWsydCANgdlbwbfDEVo/2bEj8OxWgimfC1jAfV4yxPwhpj7F+6VqzPMqvFOBZYlyYIGpb7GDqS0txBrdbPkNwWmsN4ibSR/x/3Lwl4ovwgemLzbuDdnlywD0AkNvZkR9q1dKUmn38GAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BlYNkxjGWSfbfZQ+XxFjmVB/mlx/td51hSe1ITYbYsk=;
 b=CjMuFXWrg8u+qgN12k+GY1otjHd6JgmQBUTnQdKXS7bzhPXgdunupme1HnVyna7LO71Mj+xctijoB2au9/tFAyIfnJvS9+JxNCFlIVGVBpEgIY1mBo2LZZN8cNJsQKOCXRDN2yMS7R4htpL4XEOYpSzRs5Scgjvvy+a0UR4pGRmrxv3ehEwPs4by+hiUJzkEER0HeP3wqJ1xPXGSQBM+sCJAifsrXXUrPDEuHlLTAclhguTV9iDudd+64FTAIrE6/qfaGhfRF7ukYxdky6bmuwPiLDeOnew1DoXfuJGdG+1oApSzUhG+VBKhUqTVhb6SAaKML/b+CJigOouTI0XDhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BlYNkxjGWSfbfZQ+XxFjmVB/mlx/td51hSe1ITYbYsk=;
 b=WR1VJn2glOOEwYLzG4JsJZkqpW/og4A/DZRPn7FwXheqTEjOQtAqTUd/4dzPa91JXHYVDjF/O0X6Ido5IFJ6BmBQExxbhRpAN4aIM5pVp24x4ELRLHXR9JbOkWGwCdOvGINnxaGmoMVPI1he67XyAAkddnMkCTKaVuwvk8L68hc=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH7PR10MB6402.namprd10.prod.outlook.com (2603:10b6:510:1ac::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.34; Mon, 5 Feb
 2024 22:20:19 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.035; Mon, 5 Feb 2024
 22:20:19 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 02/21] xfs: bump max fsgeom struct version
Date: Mon,  5 Feb 2024 14:19:52 -0800
Message-Id: <20240205222011.95476-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240205222011.95476-1-catherine.hoang@oracle.com>
References: <20240205222011.95476-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0046.namprd11.prod.outlook.com
 (2603:10b6:a03:80::23) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH7PR10MB6402:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f1aeac0-c2c1-4210-0dd4-08dc2698a343
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	dMA+CL9XXFd7rcfTmITWaBECi1YBaN1MBjMnn5oguUYPO/btP3fqOjZUirOKRGNv2JSXuNvzwgqrcRstDTZoHKFOMilKrR319YoxWWzxupsmHJtw0IrpBUxwQSKC7W+6Ifd9A/xp14GkBKiNkDyM3w+gaJeXztzBJi0GP21cO0VOsn9Pqkls6YOmjYGRTWIa2o7skJfVTcSTH47rUcHqSDUPa1WbBlBq4/EL35RfRehZVygyrZpHnwzj5oT5PE14h9utalcCrNf+8uLLov4qIoqGPL0eVC7/wom4IJreM2684GVcB09QeE5Ye/X1cAtD/sjSumQEZaxQgA8OwG9l0asZup6QB38sQsM1ASs18cPH21I5Q9B20a2dTlV09DvP2sRv49pvfNWPmfyQYtauyuBWmrCeF0VsgbqCSoQphRXVGu0Tk/va9w6n8IZoAHKgPVrxUK4Q2TGwIpw0PYj5SDzbkj5PXEiIyj0+7ku3Am5wOmcqLpptDKgBLELBsrx4afwCSdej5QatenBjvO96ZmGRpxHa/y4FJ7EV/80MH28s1snuXDJhx7zh9UpNmujq
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(136003)(39860400002)(396003)(366004)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(41300700001)(6666004)(316002)(36756003)(8676002)(8936002)(6486002)(66476007)(66946007)(6916009)(66556008)(44832011)(5660300002)(2906002)(38100700002)(6512007)(86362001)(2616005)(478600001)(6506007)(83380400001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?Cz3KNz3fsCX/D8TGqRw2FbsqmfMe/WXRM8Y/Mncd4SBDCXQu58MDeU9sh5uq?=
 =?us-ascii?Q?bpqqyfVuR3ZTQzU8MkOZ6KYia4AU45w1VkqZd2jKpHAcf0zAhejGpyt0twkx?=
 =?us-ascii?Q?0Exov2hbE9tTVpo7OOyau/+RQ5zN5KkXGCeDXur/rFuKgftS+zWaWEc5tn9c?=
 =?us-ascii?Q?pPbxCyZLhnvdKus8xsms/I/4dj8ONBOaIOjMkOgUw00Z6dXuwu21lEWy1QDZ?=
 =?us-ascii?Q?8qw7XXQdaC755zIB4ZbIXvqwXdbzcul1DttEbBsbLguJgZZCVpy1atzc94ao?=
 =?us-ascii?Q?KbDSsMQsqNhJTyixqTIY8LKrFeY7RAIMWENFPJY56/JlUcUDSq/3Fx44KqtU?=
 =?us-ascii?Q?55+CaTwu0DUvTYt98txCVfQk+sexVcTEOOW1h2W0uoFD0wTUD30KfxHW38Rm?=
 =?us-ascii?Q?zjDD2DrKaCgCmo5qwcQexmyt0/7jg3JCXfVF7bTe9iQWwYfYv6Uo0M/LyQGR?=
 =?us-ascii?Q?N+E9TrTM16VO7O0AGnKlWQSaDl1bgFK8HgI0lr9Jo6uTEO9zlh5I3of7PBcb?=
 =?us-ascii?Q?Y/owfOuFfapLq5vidHkxuYGhdqpruMwxCWPmj7oz377RmkxzrSsSqWEAr3ZT?=
 =?us-ascii?Q?7DeZltC6g8u8Jo1CUP4/KqBKcVLwy21h1M3ZNJu3J8P0eehpKFMql7eoA8ps?=
 =?us-ascii?Q?ZAIavAlb/RqT1mKKgpFrzJq3PZ4RKC4qLnbXEV+N90i7/i0nB7e6hePAu8Z0?=
 =?us-ascii?Q?j/iKQs7osTCWnKowo0o315M/EjA0IzQKBBfUiNNSaJG16r7BwG9xfsezY7xx?=
 =?us-ascii?Q?KNlqWipL3EDbB2A7FR50AcITnH/y7PR2c/IBLotij8qk8R0H86R1I5OQugD1?=
 =?us-ascii?Q?69Dt1HGpBC9Ng8FPzSwONVbf2vAg4BvvEC3iiE+JM4zwA+2NSosEdg4UjmL3?=
 =?us-ascii?Q?q4fNm5c9P+OhhFREmaa4mc/otxsuHkh0iVN5U3h1zLcJa3vZI1Pq/YndYMsU?=
 =?us-ascii?Q?qQJwTaVy7cLcijifn4TwLBPrMmo8F9fYeG0bISIPxDYpdUny/BPeNDdKrImI?=
 =?us-ascii?Q?0A4OEnjKA1MYm4OggNIEvHuDWDbPhtALMFgzoPwAxIfeZNW2fEr8GqTx9QwD?=
 =?us-ascii?Q?05PZPFwY3fY7blqYiDB7WG20DL5TFN12n1pxgmFIPjULU3N5Yw3YnxBdhs1b?=
 =?us-ascii?Q?LBrw/+zEk+/DuzeH6YF5K9TtFWj+++MRnGVidcA0HE++cSE2N4ifEgYKFAX2?=
 =?us-ascii?Q?qgv7PDSnN6m6S1qIBfx2G1riI3qli6LLtc7HCxvv3774cbGMGacW1b2M/Smb?=
 =?us-ascii?Q?wg4f52dahhg6CnnqcXCnbe7YpZQGDLAPsJIXdnX0OsMXTVyQW1+Uq/KKHfoQ?=
 =?us-ascii?Q?t9uvsW88R/cVG4Rn4DxO/vhWpwQJ8uJI6IaZFZpMsSyoKwg+eecle+yMXecf?=
 =?us-ascii?Q?Nb6hRVgeSf7CHrTjOuHaGn7wbxNnf/fUr0UV68Y96NnBuFXPmi4fjTC9eNzn?=
 =?us-ascii?Q?FWrbcmRSY+mbGHuy7ST9yN2hnEh5sQLghA0Xo9m0m5R8VghvapE1s8WQ2XeD?=
 =?us-ascii?Q?KbTGn+IeXEBldNag3iZ63pHD3uuBwK9LDHmahapj2xp9z0erzq/RrmKRNvKw?=
 =?us-ascii?Q?WAOsru93Rcm+II4NkU+F+3prJEqfnp+t3I9imo/8GozSOy4ydFVXr8A6UIBX?=
 =?us-ascii?Q?F80hTPBAFLygloWWYQ44+uYtMXheSsy2HCgfNIvqsex1DdBGFLjCDl8rOoMn?=
 =?us-ascii?Q?hX3yyQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	AUQpvwn4l5V7DBEMCxjCrZF88IoB2cIRQt7K+khCkYvdD4AKiaH4KnSVgkQxYUS7rh2df5Ir4xulxNplVT/PQ21ZCxjfzfp+VFERaoJ9cthrBLEy/A0KryCpibGuCRkwjcjWWTfP3ihvxHlj0xL0IBfv7KBVKT55tvtmEuykrzl0IiABwsJf12f1yBH78Ntdr13ro5C4okWetI4A5pCz+FMOIYrvULtO6w7LCLksxjmk3Ea6qre5sdDLZHM5Yh/J14I8Pf2nq0im+86x/LDBm2HSXJDRHSqO1+BWsGwx+Y3ruH+G5Vp290h8mRRK/thPRmuqVd08HQVVTiwjC/dShUWBCmP/XNeXBHecjNBniIdZzU6niNPnscn2R2uuj6sT94Cu5kBy8ZwQO+dPIQFmbTCzFSzf+yixbd/OLP+e99/bU5BH4HB8le5nzORqqQKvEra4jzfsJ5BDT4kZbmBUvMKFSpgYEA0oc32PxsrK0Lzrhki490MQk9+o+HE28eXoWTm1/4xDyks0gFQ1MNFUoH9lqeWdhT4HmYdfo3YRPXTFS1G5vId30toSgoh6vynbwX6UGROiLmVM6eQU4snwKT0BJXaGvPYAfeRGzboahTY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f1aeac0-c2c1-4210-0dd4-08dc2698a343
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 22:20:19.6594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TLO1+v8UQ0N3qd6WRvwGfKgaKKAW6qb36HvITOo2txBFbF1/1cza/vfL8K9A395qSqnhTi7tsmHMP1qCNualbQxF63/bBt6Tuv25S8/wnCA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6402
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-05_16,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402050168
X-Proofpoint-ORIG-GUID: aU4Espj6QUqJbCcyxfVj7C5_0iSbVhw4
X-Proofpoint-GUID: aU4Espj6QUqJbCcyxfVj7C5_0iSbVhw4

From: "Darrick J. Wong" <djwong@kernel.org>

commit 9488062805943c2d63350d3ef9e4dc093799789a upstream.

The latest version of the fs geometry structure is v5.  Bump this
constant so that xfs_db and mkfs calls to libxfs_fs_geometry will fill
out all the fields.

IOWs, this commit is a no-op for the kernel, but will be useful for
userspace reporting in later changes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_sb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index a5e14740ec9a..19134b23c10b 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -25,7 +25,7 @@ extern uint64_t	xfs_sb_version_to_features(struct xfs_sb *sbp);
 
 extern int	xfs_update_secondary_sbs(struct xfs_mount *mp);
 
-#define XFS_FS_GEOM_MAX_STRUCT_VER	(4)
+#define XFS_FS_GEOM_MAX_STRUCT_VER	(5)
 extern void	xfs_fs_geometry(struct xfs_mount *mp, struct xfs_fsop_geom *geo,
 				int struct_version);
 extern int	xfs_sb_read_secondary(struct xfs_mount *mp,
-- 
2.39.3

