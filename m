Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0487175F
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711404465; cv=fail; b=XIh2LaYn93Q6m/CEXxjZP5pZxJ6ig3sSyDVC3ZOX/Ug6F6//miqVs8iI6swmzz7DqlHM7iqBMVkcHMzzvlKEGraGOqw9OSQiosvMrdyxH1lViCO0DUdcV6BqvIFXt1YIPRfQcdqpCxS8wqYfmAVqwWjkJHLzlSyPA2B0FrHRxg4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711404465; c=relaxed/simple;
	bh=DABseXzTzi3gKfGJRuy8CPBfhSwuhGQtrf/9Ag16wrE=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CGYRJf4O6dqjQG+4CKC4dmreW3tNiQHWjWZOXBkPcy8stqNLJBYVoigBNEAMhlMUI8YjxECKPnpe+MmIu1Uroq1Xiajz0rHytJx8JQQV5mLQQ/DX1VGbeSXIvJfjSZYUb90T1fZJv7A/DefnxL0S/TCVcz/KxWkNHyRRD8Md59Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lZ+pPDEn; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YLWsd6Sj; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lZ+pPDEn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YLWsd6Sj"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42PLFuX6027157
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=MLEzSTX1mIEoCexCxoxLbecaFSizWrv3TRED2zmoxIw=;
 b=lZ+pPDEn4lwbjF3DSWWt+bAwHg1X2CNBHtADxd1cjZA94Q5XIpwR2OM3ICdTZxs/mpMO
 ymAYIGXWprIZfpxZm7YbeBLPezfu2Dnm2MHkCNi9Ho8tXr0NPSqgZPEH2FyJ+S8drQ2z
 aA1gGpbIhdcRvjG56Eft7PH4NkNY+XvH7S4gZZZuAZPm9cyfrkUEbLS8WIZMa7zCg4tm
 oopNmj9dDT1dVWkO5eGNF3IdQqAiKjF1bvQGgYxARwjWN8a9lsBPK8h+RGg3B8tiuMIh
 74UmmtX6QdLIOSShwstHw+I1WyNLugy2yYXwh4a1e8KKeINQm0vuroCb+6w+VgkKASv+ WQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1pybkqhr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:42 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42PK1P5m024439
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:42 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azlp17012016.outbound.protection.outlook.com [40.93.12.16])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh6ccff-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mo3dB8kUJRh3/OUucSrlALktpMiP1sQQquFmx9i+8i31/dwEEFC4oKh3SGqQY4iVNWCq0BuLQOfJZWhfKWvthU2rNdPo7EdgTqV5t1i4Cg6YVbe+EptlB43v38iIon4tIbCdi5KDmxR10N27JE4HRUvm3KQRFaNyy22xYx4sbzaU/jJ/5Qs6vSP0yRSldHUOodFTv7XavSKSghYWqm/fQY69QOt6SZqCV/bTsynZLjAFbxgr//wnYCspDmq2FKhRUT+gjMipcSwe/cUqy9nV6AEiiWlZuElx27lzBhdiC5PfPIztJNwfR7YnTbk13YSyVdW5/kH240sbi1E/CTHrjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MLEzSTX1mIEoCexCxoxLbecaFSizWrv3TRED2zmoxIw=;
 b=T/U3jmeOQGHx25XEttZzkBvGJhzE9Wfz0zDVcwR3RJxW8q/FIjgLCao16xkn1t3ocjI5lwqB3pGZ2zD9KmZSBjszaXPvhKIEyelxwALe2mdOcYM5smwAwHhiekvP5QdNaFkBzrshXCauITzC6BrXP9xM+CwvUCyyeuLpcB4oeNs/QiFlqaGooIaK7Fp6A6I8zf3OdcAha4f9NKUrLP6+pDjpbMnrNjCduCXs0a12T9Zbnh8ve/6Y/uNzVsva+hpTD+DKWqhGhcEP8N2sklrh6/qK8vjeiRneLf4HKhR425vjepVq3l0JX/2KxA2xyaRzRiXTc6c1usYizsZg8gSzLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MLEzSTX1mIEoCexCxoxLbecaFSizWrv3TRED2zmoxIw=;
 b=YLWsd6SjxC2Vc45MHEk6Kw5sdw/19ESiHsT/IJhnzUD5qQpTZJNlBdgM70WSDa2WSqTXrvdYWtqgPtl4BYZUYYXtFrEt7qLAHwARuqiwdfd7A25o5r/9SXFgjYsjC59moYHjbnDs+9oPDFSi4bQ/o2frARr1H06mCIAgOtm5yGY=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB7476.namprd10.prod.outlook.com (2603:10b6:8:17d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 22:07:40 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Mon, 25 Mar 2024
 22:07:40 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 03/24] xfs: consider minlen sized extents in xfs_rtallocate_extent_block
Date: Mon, 25 Mar 2024 15:07:03 -0700
Message-Id: <20240325220724.42216-4-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240325220724.42216-1-catherine.hoang@oracle.com>
References: <20240325220724.42216-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0020.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::25) To BLAPR10MB5316.namprd10.prod.outlook.com
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
	xwZtiuJ0PELr69K0Zvug96JfpALejJhnTGRZFoCth27g741oQJO9pUfNKsgApHNhtsqV06SdGGh9ZIZmMAZ+kkPaEZfXYtlI8vvdqJ16R0JS+khjEbQ+675gT0bWLqtEzqpl8WIpBMRYotxc7prNU5bNuBes79Ua9kzdcy7L0rH9IQk4Eka5OJAgzgIZPS5SJJtFK6UJie1+OY3XUWW42NbpkMyg6ynCcjlLIxQ6hQe9Sbc3CWpP64gP9cr/4u7odWXscDlwxOOB/OO1isjgJ3sVSdSbqvAlm+rxHb62Cr1RkfmhlXDkkB8y/uPvneNwSQnmiWobVvzfCKy8Nv0+BURSv1TEut1ZPUQ8e2u1iaqnZ5PZhXRvuRZL09ZQcazsU0rAI3Oo1mK5knP0wViHW80cvY/bOlaBpAUP2LAzE/gJ276elzlT3ZUao6wVB4S00RtObGxYwzkEPZMmyCJjXH5cRmkNB67EVE4QEDqRVtSshYvDJ/AXGP0j2QcM3QzgM6HS1xtBK7S1yj7FkoOWKjHwXdHY7volZIpNdV8Ue13AgPcSl4FZt2y6LAieSC8h+6HcEwtIpBSZhWGngbKlsYXAnkEdpUAoqtGMI+J/AyhQPFDnoA2Zauey+Ja2npWJCMZGW8cLqDe0w4857hzIvv4P4WxdCadd4UmjrkW8mLk=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?PjawynEXgyIkhI0TMsU0NMn4SaY+t/u+Ri65yLq5E9ZYHTd0BSwFiugCpA/k?=
 =?us-ascii?Q?q5YwLkWM7tX21Xc4GnYPS7/MnOi0TvAhsF8InyavU+UQl2GKeVgTOnaPQOwp?=
 =?us-ascii?Q?CF9SCcEyNsgvOOA1ilolhMdu6mafVEOMikA+JlVz09JAWcs62Zt/uveAJErL?=
 =?us-ascii?Q?cfMowKcNkHZij/qNPk+Svp87T1XtSF5aLvwX7wetRNEb0TNi9QtTTlcWh+fb?=
 =?us-ascii?Q?2MvuPE1sLpKqsybnU1Hl2vPWaH+MWKUgrJAzpI83DcOjDTX/1yP3XKyC2EaI?=
 =?us-ascii?Q?XZXyTFKBSEbC+Y/3M8Yc2sVny7Q8krgQbMiNAZYkoAVFgAhUO5N0bzM89yZ3?=
 =?us-ascii?Q?yCFUS2+KBf6LdUSMwBsX0ca1buF1pFED3kXfPM4tV+nLNeyBCl95rMmiFUAF?=
 =?us-ascii?Q?eMi2EnFivZmK9FxpxE+gB+GhNaY4QglBPuVE68MtxSyuukaPmRqKIKTaDBrW?=
 =?us-ascii?Q?FWjDAhK0wXQ6qMe/LQRxrjWxjGETHYG3RVU7HK732ivqDsVog8BLQoNLwzNy?=
 =?us-ascii?Q?nhRWO12hwzjid2PlaZ6vm7wgwtXLA3LV+ArHxHYpR8XD6cfzmWaAaSpUBjdM?=
 =?us-ascii?Q?3AfOVQ7JNi1y3ruTuQdji4cKIcWWiL8wJGQd0c7+A3UPlB8Adndw6YSniCJa?=
 =?us-ascii?Q?Yh86/XjdW/WhgvPhnWKJswYz2XMiQ4G6Tx4OTBzeG7TfMM9/uITDEZTeUFYn?=
 =?us-ascii?Q?BOYtfFTgxkaxl4EfYrHFnYYsoQVJQrL2z4VXRHV9faBhhIOoVFefP8vZkovf?=
 =?us-ascii?Q?qrxp4jcFRM+lPOKgjQ0h1p/yE12/THgE4QtHhbWTqWkawHWuRbas0c6ka9Em?=
 =?us-ascii?Q?bvwhAJGmcR0IeU8keoXK4MF9Lj0hCZ1KgPP5KepoSvRA0YYkvS04cqp+jFUc?=
 =?us-ascii?Q?sxlvTz8AwHIvja0Kcfgi63qnnvVkgBiHfDBItNOLjPZHmQ/WifbteNlw8+sQ?=
 =?us-ascii?Q?xChc1X9hmPtK/OHFWdITjufj+PqPu9wFn6KjVIqp9suDK8xTRPykLaYuOu1T?=
 =?us-ascii?Q?XPGujUhVp59KavjFnR4Mv0uUWEUNJw4j5/6wWKWrsMSW/erPtcE0KKfh1GW0?=
 =?us-ascii?Q?K++v4MXnRHgxRBiphK5ld2LHoolERHwJrapb8T9s0C4OhMuWrnZcV+Sb+Rrk?=
 =?us-ascii?Q?wnD8yvCM9atS+S9wqz6msDyaTSaj+ydz96qHb81B5GxEYgYCHbIiRBybwVkv?=
 =?us-ascii?Q?PP7Xo83LfbMWbc5cad9mel1uGO5ADv/e2ID0xkraNsTHwqWBD8PH/h18jdx5?=
 =?us-ascii?Q?29/6JljM90uFR4/Cr+SA4Ga76ZsXGiVePH6rUhRUf670aSrKlcRwhlgvFFyi?=
 =?us-ascii?Q?929Ip2vm+qds5rnTRoWn6Pn+/bkJ3SkJUEHS0J99i+mUBBMVEPu7BnhQkEmP?=
 =?us-ascii?Q?mfgcwHqF0/dFj3A2fuPcaUf07+oE98wKPS93WVNINsuw1XPP337zN33DCMRu?=
 =?us-ascii?Q?XalCZHbMp7oY/ghA4405aelkjOYUi5tkd+1338AFYcxn1LoD03y/kbD0DYxM?=
 =?us-ascii?Q?vKsLSp1Tb/XwNwDYNr+iDd5XMM45IPsRr1EpUPbt1Lw1w57LIDDLkcNNX4zH?=
 =?us-ascii?Q?nW259tm19H+OjwfGo4gc0SPxJbOizsim5JXJev6qX2/x4oMreMUVOmChVoOG?=
 =?us-ascii?Q?P8cg1Xzz0ybWpb7EFMjBvzUs4K9yDmyRlrVjKSv1LUB2CnlIfqRPuFkzL8Fe?=
 =?us-ascii?Q?2kujow=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	cGgX6TuEqpK7E1OUzAAtkuLDQYDUnZ3zX1ZYKnOU+hnEeNyiz0Orq09YN9KfPyE6KnbvIYRpH2Mn9yPzUsV5A70seEDacpP21H24OGMgHJYmgpKB6wmdxvZ1F2V/wxSwb+E7WQRanmoatMojnX25MvItmvnWZ90hDCtkU6NWY2XO98Vp5PPBqmOBncZsSFthGIypqb5KR7E0wp1Echj0DVGqWVRZbq6lSGDspyIOIPDz4shWS1Zr6b2dj0SKe+tJbnWZmG5VupHMKJ275JvgbtyLSgROdadMxdawb4HJ+U7R9BE68s+ISnS2aMqjDPVq0heUXaJZz6rKsvfOWCpPMMC1n2dCRn6HE2pimQHe4L3vg/rLdF/f+YJNh8uwXnDnRx72kOeMM7EXCUVdBxauST3sTACVAio/YiA8xiyEag1ANpPdN3OTIguyShgCPhb4z6vSod3TtULJHbyTO/NM2G6KmyEg0Wt3x8qkd895D5SCctneGBsDDvVvjCrkmCEnGyOIOumvUG/4D+wYsPSJoTifaGZlFDH4clTDJx8526hPvL+nCZwnvkTtccCzKetaLxJgwxpkqUpIVWLSFnWhief10CgkXnUnyL0dsW0l4C0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67cc4fec-f665-4039-3a69-08dc4d17fc9d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 22:07:40.3150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +fdmSmcraJ1AZ68v4Eyws+ju5eVWyCn53dpHunntSHslcC9kT3A24E2MTQPT80Je6xSfMOKUhvzfhmzVeqN4zw7y0yHw7/bcZdv8x9hlHSg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7476
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-25_21,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403250137
X-Proofpoint-GUID: 1Uvneu507iSzPbJbxpDmGt3JVZUG332B
X-Proofpoint-ORIG-GUID: 1Uvneu507iSzPbJbxpDmGt3JVZUG332B

From: Christoph Hellwig <hch@lst.de>

commit 944df75958807d56f2db9fdc769eb15dd9f0366a upstream.

[backport: resolve merge conflict due to missing xfs_rtxlen_t type]

minlen is the lower bound on the extent length that the caller can
accept, and maxlen is at this point the maximal available length.
This means a minlen extent is perfectly fine to use, so do it.  This
matches the equivalent logic in xfs_rtallocate_extent_exact that also
accepts a minlen sized extent.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_rtalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index f2eb0c8b595d..5a439d90e51c 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -318,7 +318,7 @@ xfs_rtallocate_extent_block(
 	/*
 	 * Searched the whole thing & didn't find a maxlen free extent.
 	 */
-	if (minlen < maxlen && besti != -1) {
+	if (minlen <= maxlen && besti != -1) {
 		xfs_extlen_t	p;	/* amount to trim length by */
 
 		/*
-- 
2.39.3

