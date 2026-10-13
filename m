Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D0D3DCD8D;
	Tue, 13 Oct 2026 08:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879266; cv=fail; b=U/b/OsWWWYwqGK9Y56gnwDqgeUDKTFmrCLnYzKPu7qkcVxiou3VhdIu3SV8rH/qeCMAME7ZjER18QsJQZ09ll+XD5nOEw3G/AZ+Yqi2l0LAKQb2z3vQSavA3tzVXAKPOZGh6FrAdYSnKJl/I9+Bb+OPXF4LNCR0zQDCrzgNUiwU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879266; c=relaxed/simple;
	bh=G8LYIQwIf35zcCyXfy8Jkwp9L4phUuIpyvkzwx495bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EqAhcC5dcbX0SQxmIjZxraGAwaY9YGZ1AxiqsE8Ik1phV58kNmU7itFR2NV+MTsREjggDhjcF1/Gl+Bnt6Q0CZdmwNbrCR9pZinjHRbYBL/aSSy9ewlzx5EzMUEHbnuhMph7oUiXzxy6ARi6LxXcoD3CUb3N1B6PN+qCh2O842Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=i84A0muA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XwuBm9kw; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i84A0muA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XwuBm9kw"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2BrHL3109986;
	Tue, 13 Oct 2026 08:14:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=q45FVh/H/qUI6Fc0J0+qVJhr/t3mIu3FWueF+8gwJB8=; b=
	i84A0muA9qp1T0h8b+aNI+KwPj91SCOtzB5ISVkIJCvbmRfaad/3zsiP4TkvixUo
	MVMifKy7gM/wZLNT14m69VVernTtj8g7ZoEtRNf0mFUVPdtbAhN7CiiSyCsbLgW8
	s3dAAmrI3zsi0lUhoxa9g63VMU7dB7A0aCMASlwae9RwdJ+Iku74NIAngZ5guLak
	K6U4l53KExZAd8IbYi9GhQYB9se5QMisoqYqP19Acvfs1deXtTXmNhbueCSaALhB
	y+d+drP2vW7PBGxG9bXu6N8dMQb9hON7qTOY3B4KTGrlInsU8A6mDdFNLrZAf3r4
	NOT8Fx3fsLEXgsJ+8wdUSA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7ddgkmhv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:14:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86ho1033534;
	Tue, 13 Oct 2026 08:14:19 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013039.outbound.protection.outlook.com [40.107.201.39])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btnxqtm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:14:19 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EWwNjdv16h2WwIGax/GcSwE6Odg4N8ToNyswQ0eCUOUS99/MOy0vK8Kbb6rKe8MvUStEcAxogTD3KfYfP0tY/VmY7gqJ2HNu1hZxzKHXE7Z8Dlk7orgkr3OSFE6x+CLn1rRRMEo6nTkv4f2EWJeLAt6lyBmj7VWuZYHkSDtKuBhYHcc3d/DwvaFDtAHWAk3fPjjM+7ePS2tS34kay+0MFE2tc9qZx8iGp9G9gUuD72plmyY1b13Ii6FwgKyvrYKGBiUjaMjAuBLJI5BB8dZSP5H1IVWxUzkdAFtk+xdPhA8VTBQyTK4ylddqFxDUjY1XevHZNeZryow1MC8gc3CGqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q45FVh/H/qUI6Fc0J0+qVJhr/t3mIu3FWueF+8gwJB8=;
 b=kl/l+/7TyJt8GtsQBPnye1kyEhlal79EYrdXFy92d18p37bXwR2MFmk8o39AfRipxjO/yCjpvaTTR/GJxeeKe4zmh8VgVFR/hMkq8/EQuhkUWH99S7+GUl51CmUDyh3H9Sf87tggD2tK2+zYo0cp0gWG79zDrPI/FjwOAxrDBVQNTzrsV/Rrd8c5WvWjUJkebHKTB6Wx55ggwi48BWHZhqlC7WR9dRYJ9E73yQZwG9v8oJ4qTrLtwT789g6//9DXLi9sozdHAfb/omgjHKD/IGxut1eDC9MgdDYBARmwAcyXVSJHIMApdXR+HVJ8tClJSyadsr5snfxbcvMtvJVstQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q45FVh/H/qUI6Fc0J0+qVJhr/t3mIu3FWueF+8gwJB8=;
 b=XwuBm9kwrUtW3kbCJvGTVBT6b2NOB2Zv2wM/zYg4anGRL5gpTQJHlhl7ewI+I4s1w6jn8vMXKVtPWqp6JIdsTZoL1WAllQJiSbvusc/QNtH2jqhaIbWooJJXjUwmk13sPc3tlqhGQJgTsachFeeKTCWhmVYaaF1CgEFb6oi0qh0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DM6PR10MB4138.namprd10.prod.outlook.com (2603:10b6:5:218::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.12; Tue, 13 Oct 2026 08:14:17 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:14:17 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 v2 5/5] xfs: fix unmount hang with unflushable inodes stuck in the AIL
Date: Tue, 13 Oct 2026 13:43:49 +0530
Message-ID: <4d6cbbf72e257e9eddb41aa6083d0a69eec9aec5.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877866.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877866.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0060.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::17) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DM6PR10MB4138:EE_
X-MS-Office365-Filtering-Correlation-Id: f5dbcc04-9144-4235-7c9e-08df2901f99f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|10070799003|1800799024|366016|5023799004|56012099006|4143699003|261009223027099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	+bJhq/gzEOvaQBlkYndVCD8Z45vOLwsZ1l8w7pUsOanI5mXETePQYIp5TDo83QwV+Ow2Bdmx35OTBjoh0w1MK+KDahILf9O4rYjSYmZ2mjGfzMjBTRY8V0PyXtxW0cbRjLTonfDiUt2va0urLT7v7y0g517pZwXeVozQUeGJHMLx+0skE7mrKYrnwsMFe+E6l8MxEGxL/AiIYWWdp/oziFVK2h21Vme2HOMT48AOjaLtIEeLGTyZ1S5++UOEatJBpT1bs5aiiPvQ4DRVe9+V0beD2WjvdjKAWFQ5jYjPvMmmGcvIsAFS1QcbRATzuQDtMm6ogDJbiyVWp+QIuTkHiDfGk+hjAYQFd1EOHgGHpvV0CRdywJ/ZPJYfdkMInwmndnftLUCMQwwYEY+fIRwJOyzyv0w1NVuHKndgz/HgXJFzW9D9ghj8WYeOGvYh53FD+NFmknT20ea4n3TybsLkDooK2k4GilyneBI0zB4EISzcvHjHTJYfaU3K8b0fCoFdi+9QeCtSJHVPOx4uGVvXUHN33gTajgyyd/oItwi39gt/Mdio+9KxL1ayz829LLzMlf9RHPEhyYdfwvWgqRlEODNW1GHl04FYbEOjlaPtfWwdPd9/00IfF/H3XWFS2pGtOtmJz7dgsLmrH43dVBqsxPL57DDfrOyBKAePKixdIUk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(10070799003)(1800799024)(366016)(5023799004)(56012099006)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RPxXTcS2THAemHnmjFG7p2N4PV1vW6DoNEmQGxE7d9gzGhrXUVHr8ZBe4XPL?=
 =?us-ascii?Q?LLDW9RgBR9SB5oMqHT7Y+78SzvB4Hu8OXK0VW8bWEmguyMIldYuVbRywWSKK?=
 =?us-ascii?Q?C61jyQBjzSQHmv4kow+7CkoJf/I1cuXQyVhqL2+ArkqNrbJQR11OinNNserH?=
 =?us-ascii?Q?mI+G2ThCgxCm9vemwcoqRYI8d7dl1V2lVrfdpUkJn3UI7SWoTstxEc2VgT+w?=
 =?us-ascii?Q?4CZvjN9qAcVDi4XI2zlBrcsy+PU4cDXL8RolDENHCGzYUYnZXNKpjBxuI6jy?=
 =?us-ascii?Q?Dfqf1ljhs6csjSXeM57Txw6JeNNnB//HfOkcy6zTrsXw3Uh6O8PqW3BohcMq?=
 =?us-ascii?Q?+wSISH+ahQm2AfQ4aHb9Q16qHTr4iQfDBIgszhhggVJWaNMgPTNCXLZr3c3D?=
 =?us-ascii?Q?laB7/EMN7vSeL2TmG178qiV008pgd6ZPWMR8kU1in4Nnpzu619UP1YG0iWEw?=
 =?us-ascii?Q?d1JH0lkCCedPcr7cghuF9sm2mMamtyNgwYueKDNNdma+UcHf2tjiEZWvwOQy?=
 =?us-ascii?Q?vtGJHDYxLJo0tH0yQnKhUtIiPXa+H6m3qDz8QA8IXQEXcGEfm588BGaW3PhZ?=
 =?us-ascii?Q?R2q8wOFAJVZFw1NjphALT4Nw9PxnrzNRPYSMKNPlRqNnvz3+Xyt+L0+ysRSV?=
 =?us-ascii?Q?Dh5LwbCqkMLzox9liVDddPElHunk3Q3FSAXU3vXKTj8OMwM5X+0++pm3z5Ra?=
 =?us-ascii?Q?r7RQ5CF71KMK5Kv0Rs4+XIU73pxXuG1uUDEpiCxxWY2DUlfQdY+wUFNSJYz7?=
 =?us-ascii?Q?PgBx5LdXBYvuKUfTzCm3IeN+4kNu7e0pP10iwSxkHAF5gzHHIm7SsgISqdBh?=
 =?us-ascii?Q?ArFORYBTqp8bQUYbYKdX6oQEbD40Gt6kaGf5k54z+Xgh4MdT/tZALJoFyODl?=
 =?us-ascii?Q?zdkFCcqg/4AQ4eV5MSg6MqB88u7Dq37Qf7HoHh97JZ8566QpTXZgxi9QmIHj?=
 =?us-ascii?Q?Dvupwi/yJVwzNKhwYJHVEvLI6TtDBNteRD88gn3vQqjADzrCQnV3wBFERdiB?=
 =?us-ascii?Q?hcXPT4cSMTUlxmtlKrvcvy1JoDyHKDJtDdvrk32IOZmXgJeY+cTvvvolE2vY?=
 =?us-ascii?Q?I7r5qtqGgW+/szqTN6jZlUIix1WppV5ad/cqhYWuTHGwbhEA/8isBcjeFLcE?=
 =?us-ascii?Q?0rDZEleqBa+7SxUoTYRs5IYsCXPOKYMh5ESjRzO6MdwxHiKjQgqKFjgajVVC?=
 =?us-ascii?Q?5LEQ3xuOkxpB6J2BF0OjXF0iJmUoV0CoSmXwqbwznYLrNnMmtj833ZxWLImS?=
 =?us-ascii?Q?Y7TXufx65LlqKBAyxHuIQnnyKL9izrTvpPRUGlZmEvo6D3VTPUDR7yksSCY5?=
 =?us-ascii?Q?c66kZC7COaFmO3zmjEveRZcBtaVxPpyySyerrzsInYG94FBctU/gqFjJ9I1v?=
 =?us-ascii?Q?h1mcWT/dzAqVB3aBi6BrKYEamxjqbBrxHsr89KyKawmCtoN24ZrYIBps12Yh?=
 =?us-ascii?Q?fOjioM6qQF3OPpKSaeeG1dC3Kn30TRqKRhHKjHVqJS/978DxMah+ULc4WgK+?=
 =?us-ascii?Q?3FJ74EgtttsfznYe+/AGmv3XdIyGn2oeRtbM0k+inmrtolIVx+X4Fz1OUu0t?=
 =?us-ascii?Q?QUQgA6dN9qxa9ByxVEOxi9JE69SPwyiKqd2g2ctrB8gIUxN4pF8Jf2iztS0z?=
 =?us-ascii?Q?hKkFBmC6OPNNjb6Ku8JjwJi7sgsV0oWYjX5H6jGZ8Vja6tkAah70F2QlP7L3?=
 =?us-ascii?Q?E5nYrtpywJ2Ew/jD2xGMv+HId9Kfw2+e+SG/JvxrWNceLbXP0Z6fbPRuxlRg?=
 =?us-ascii?Q?VYFlAU32ssnSvIVidpep9YUfFLYOrTR7sAv89VAulMD63rqJclvMoYHhBzjr?=
X-MS-Exchange-AntiSpam-MessageData-1: ZbVy3NWTPvt0gCNvrCgqKrgaqa6mrFTpnoM=
X-Exchange-RoutingPolicyChecked:
	Py4L1axgUwAzpK5otEmr4axTyt3yo+U2gWCTLqeMoahek+OHx6wN0ASfdZT00Kf3+aHyL6MGA5hst21iZvDibAAxAo5hKEUNi6HRXhLJsdE8uHq0bp4X/6Ktz1JJg3dRz2WSJLdiFzq2qNluW8O9EU0A5BOsUe4iTFRK/DsoTWOpyZLRt4jwdtzo7qv1R1FZeQ37/2u2014McAh22uzJFZBRjKibkfDd/Dc4fAjjRKZydsbnAJsVYss49bOXC3jKx6h4+wSb5CqycYiKgNoC5xHBRsh8F8SER8ZldCLD7mR07JKHmK2MsQwjS6ECGyrlSUtCRv8xAcMkjnIl/cik7A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5krDIGaVl+vwPtn18BLzIohVAss+RvxfEmUYuXUv1MAh0DOfyg5LplVp17gqTrUNXFAatDllTT31D37TcR2OB9QkaxIIuyjQAB70ai35QheqoTUNeYB5HKCCq1L382LOZPUA8kQdm92nkyt+rFYyzWq7S/Gt97P6dLdkvRiPI87ufFJb4h2VCkPaGmNPPzQcAWlCEJKwJW92RiuvuWczg9PkSjQfkLlbBPR8ljAfsIq+ZS/INpsOyl5/KP68ACMT6m7RtzZqDKGo6oiYCrNf+L9tE9aX45aE7f+MO5iHGjIv4NaN6GOh+q8oVa10L9LC+s1q2dp+2RHgQQpN1jIlqUKkvt2Yla8+4krtGBE2UK7rDeLNN80m64j/IAOEaMfofEZ0m2Rz9GeIVlYJsG1+1eMVKwpQY6lX14d7L7T/B8gBLvSCQDzoQQ4cOCHy0hBl03k3z+AsU9CYNjDumJN0bUUuG7afulm1MhCACILYSGx/f4pzwfVt51611Yagoo6nic3qmJ15/pklVikqKoPWmcSvNBLk6eJ2Hcag9qgQal0s9yGhexYd///I69+41K712k3fEGnyzSpu1Kdm9m1Fe2RsHG5/DUPpS7RYIAKRdMY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5dbcc04-9144-4235-7c9e-08df2901f99f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:14:17.1623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aHuiw9li+FwLR1GjnUcb4NIz61cZXPMSOlTIkPa9j7oyldfJ3VS0hcsIaKE1XMoRAvAKXnP0bIIUjFEHLrtp2i26joRWcrFVjlVmwYtQkuI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4138
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=EeZd0/mC c=1 sm=1 tr=0 ts=6acde85c b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=kGPDooFuvBrjL3bSUbYA:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13537
X-Proofpoint-ORIG-GUID: L1PrRG6KhmRnJJTseaz6oe_NOZc9dtJP
X-Proofpoint-GUID: L1PrRG6KhmRnJJTseaz6oe_NOZc9dtJP
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX8Hq5tXyZoSGJ
 cCntomtv78olFffJXpzUYCpOhBEGGx5aV8U/1vwrN9ve5pNcOHp6i3ofOz6g3IoquMlH7NM6NTR
 aHC5SdwAJyiuSGlDa00/mtklUAbjFbiarqS8diswukjRZkKKSX2S
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfXy/K60QKcOQ1+
 W0VMvyE9NMpB1oIp/P5naOlXos+4qJHkNNk8lPHw9iprhhZWfjjlmqob2QbZeV1N9xB8q5R/3vm
 HLN/ApUP9HdIQLMWv385yo/aCFlKOQcK6EBI7mcotW+86trBwW2c0m3zuLxLmnl5CTAyusdc47M
 zCUJkgoUtOYIHc28u0f+pJsIqogf7RkNEAPyJtIjzirLbZS7cDLTkQbVC+4rN3X+n2hhzmo22S8
 Pya74eCVW9O2Nj8GkJYz9/hvQ+T3417DBdapJps3z1pvYY8dknC08LhKNDMfd1nIzT7AwCvlN1D
 FTKbyrsj07gk4Ky/I3PNdyj7RiynQPTGWF5G4775b+te7kVy477Ojj/HRyJgL0nl54J9FFQzUYv
 NKs9wNPqZH2eF9CoDe+Z0Tw1biwVZlgDUI55J5o3OB6TiHkHXzIHEMup3f9o/pv/MVG/+YzntD+
 Ubic+EadxjKhIr4MX7FIm89D6uY/XHInEs7zoJhg=

From: Dave Chinner <dchinner@redhat.com>

Unmount of a shutdown filesystem can hang with stale inode cluster
buffers in the AIL like so:

[95964.140623] Call Trace:
[95964.144641]  __schedule+0x699/0xb70
[95964.154003]  schedule+0x64/0xd0
[95964.156851]  xfs_ail_push_all_sync+0x9b/0xf0
[95964.164816]  xfs_unmount_flush_inodes+0x41/0x70
[95964.168698]  xfs_unmountfs+0x7f/0x170
[95964.171846]  xfs_fs_put_super+0x3b/0x90
[95964.175216]  generic_shutdown_super+0x77/0x160
[95964.178060]  kill_block_super+0x1b/0x40
[95964.180553]  xfs_kill_sb+0x12/0x30
[95964.182796]  deactivate_locked_super+0x38/0x100
[95964.185735]  deactivate_super+0x41/0x50
[95964.188245]  cleanup_mnt+0x9f/0x160
[95964.190519]  __cleanup_mnt+0x12/0x20
[95964.192899]  task_work_run+0x89/0xb0
[95964.195221]  resume_user_mode_work+0x4f/0x60
[95964.197931]  syscall_exit_to_user_mode+0x76/0xb0
[95964.201003]  do_syscall_64+0x74/0x130

$ pstree -N mnt |grep umount
	     |-check-parallel---nsexec---run_test.sh---753---umount

It always seems to be generic/753 that triggers this, and repeating
a quick group test run triggers it every 10-15 iterations. Hence it
generally triggers once up every 30-40 minutes of test time. just
running generic/753 by itself or concurrently with a limited group
of tests doesn't reproduce this issue at all.

Tracing on a hung system shows the AIL repeating every 50ms a log
force followed by an attempt to push pinned, aborted inodes from the
AIL (trimmed for brevity):

 xfs_log_force:   lsn 0x1c caller xfsaild+0x18e
 xfs_log_force:   lsn 0x0 caller xlog_cil_flush+0xbd
 xfs_log_force:   lsn 0x1c caller xfs_log_force+0x77
 xfs_ail_pinned:  lip 0xffff88826014afa0 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff88814000a708 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff88810b850c80 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff88810b850af0 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff888165cf0a28 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff88810b850bb8 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 ....

The inode log items are marked as aborted, which means that either:

a) a transaction commit has occurred, seen an error or shutdown, and
called xfs_trans_free_items() to abort the items. This should happen
before any pinning of log items occurs.

or

b) a dirty transaction has been cancelled. This should also happen
before any pinning of log items occurs.

or

c) AIL insertion at journal IO completion is marked as aborted. In
this case, the log item is pinned by the CIL until journal IO
completes and hence needs to be unpinned. This is then done after
the ->iop_committed() callback is run, so the pin count should be
balanced correctly.

Yet none of these seemed to be occurring. Further tracing indicated
this:

d) Shutdown during CIL pushing resulting in log item completion
being called from checkpoint abort processing. Items are unpinned
and released without serialisation against each other, journal IO
completion or transaction commit completion.

In this case, we may still have a transaction commit in flight that
holds a reference to a xfs_buf_log_item (BLI) after CIL insertion.
e.g. a synchronous transaction will flush the CIL before the
transaction is torn down.  The concurrent CIL push then aborts
insertion it and drops the commit/AIL reference to the BLI. This can
leave the transaction commit context with the last reference to the
BLI which is dropped here:

xfs_trans_free_items()
  ->iop_release
    xfs_buf_item_release
      xfs_buf_item_put
        if (XFS_LI_ABORTED)
	  xfs_trans_ail_delete
	xfs_buf_item_relse()

Unlike the journal completion ->iop_unpin path, this path does not
run stale buffer completion process when it drops the last
reference, hence leaving the stale inodes attached to the buffer
sitting the AIL. There are no other references to those inodes, so
there is no other mechanism to remove them from the AIL. Hence
unmount hangs.

The buffer lock context for stale buffers is passed to the last BLI
reference. This is normally the last BLI unpin on journal IO
completion. The unpin then processes the stale buffer completion and
releases the buffer lock.  However, if the final unpin from journal
IO completion (or CIL push abort) does not hold the last reference
to the BLI, there -must- still be a transaction context that
references the BLI, and so that context must perform the stale
buffer completion processing before the buffer is unlocked and the
BLI torn down.

The fix for this is to rework the xfs_buf_item_relse() path to run
stale buffer completion processing if it drops the last reference to
the BLI. We still hold the buffer locked, so the buffer owner and
lock context is the same as if we passed the BLI and buffer to the
->iop_unpin() context to finish stale process on journal commit.

However, we have to be careful here. In a shutdown state, we can be
freeing dirty BLIs from xfs_buf_item_put() via xfs_trans_brelse()
and xfs_trans_bdetach().  The existing code handles this case by
considering shutdown state as "aborted", but in doing so
largely masks the failure to clean up stale BLI state from the
xfs_buf_item_relse() path. i.e  regardless of the shutdown state and
whether the item is in the AIL, we must finish the stale buffer
cleanup if we are are dropping the last BLI reference from the
->iop_relse path in transaction commit context.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit 7b5f775be14ac1532c049022feadcfe44769566d)
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 123 +++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_buf_item.h |   2 +-
 2 files changed, 87 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index ade89a233e68..a5f3408e213d 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -709,43 +709,42 @@ xfs_buf_item_push(
  * Drop the buffer log item refcount and take appropriate action. This helper
  * determines whether the bli must be freed or not, since a decrement to zero
  * does not necessarily mean the bli is unused.
- *
- * Return true if the bli is freed, false otherwise.
  */
-bool
+void
 xfs_buf_item_put(
 	struct xfs_buf_log_item	*bip)
 {
-	struct xfs_log_item	*lip = &bip->bli_item;
-	bool			aborted;
-	bool			dirty;
+
+	ASSERT(xfs_buf_islocked(bip->bli_buf));
 
 	/* drop the bli ref and return if it wasn't the last one */
 	if (!atomic_dec_and_test(&bip->bli_refcount))
-		return false;
+		return;
+
+	/* If the BLI is in the AIL, then it is still dirty and in use */
+	if (test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags)) {
+		ASSERT(bip->bli_flags & XFS_BLI_DIRTY);
+		return;
+	}
 
 	/*
-	 * We dropped the last ref and must free the item if clean or aborted.
-	 * If the bli is dirty and non-aborted, the buffer was clean in the
-	 * transaction but still awaiting writeback from previous changes. In
-	 * that case, the bli is freed on buffer writeback completion.
+	 * In shutdown conditions, we can be asked to free a dirty BLI that
+	 * isn't in the AIL. This can occur due to a checkpoint aborting a BLI
+	 * instead of inserting it into the AIL at checkpoint IO completion. If
+	 * there's another bli reference (e.g. a btree cursor holds a clean
+	 * reference) and it is released via xfs_trans_brelse(), we can get here
+	 * with that aborted, dirty BLI. In this case, it is safe to free the
+	 * dirty BLI immediately, as it is not in the AIL and there are no
+	 * other references to it.
+	 *
+	 * We should never get here with a stale BLI via that path as
+	 * xfs_trans_brelse() specifically holds onto stale buffers rather than
+	 * releasing them.
 	 */
-	aborted = test_bit(XFS_LI_ABORTED, &lip->li_flags) ||
-			xlog_is_shutdown(lip->li_log);
-	dirty = bip->bli_flags & XFS_BLI_DIRTY;
-	if (dirty && !aborted)
-		return false;
-
-	/*
-	 * The bli is aborted or clean. An aborted item may be in the AIL
-	 * regardless of dirty state.  For example, consider an aborted
-	 * transaction that invalidated a dirty bli and cleared the dirty
-	 * state.
-	 */
-	if (aborted)
-		xfs_trans_ail_delete(lip, 0);
+	ASSERT(!(bip->bli_flags & XFS_BLI_DIRTY) ||
+			test_bit(XFS_LI_ABORTED, &bip->bli_item.li_flags));
+	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
 	xfs_buf_item_relse(bip);
-	return true;
 }
 
 /*
@@ -766,6 +765,15 @@ xfs_buf_item_put(
  * if necessary but do not unlock the buffer.  This is for support of
  * xfs_trans_bhold(). Make sure the XFS_BLI_HOLD field is cleared if we don't
  * free the item.
+ *
+ * If the XFS_BLI_STALE flag is set, the last reference to the BLI *must*
+ * perform a completion abort of any objects attached to the buffer for IO
+ * tracking purposes. This generally only happens in shutdown situations,
+ * normally xfs_buf_item_unpin() will drop the last BLI reference and perform
+ * completion processing. However, because transaction completion can race with
+ * checkpoint completion during a shutdown, this release context may end up
+ * being the last active reference to the BLI and so needs to perform this
+ * cleanup.
  */
 STATIC void
 xfs_buf_item_release(
@@ -773,18 +781,19 @@ xfs_buf_item_release(
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
 	struct xfs_buf		*bp = bip->bli_buf;
-	bool			released;
 	bool			hold = bip->bli_flags & XFS_BLI_HOLD;
 	bool			stale = bip->bli_flags & XFS_BLI_STALE;
-#if defined(DEBUG) || defined(XFS_WARN)
-	bool			ordered = bip->bli_flags & XFS_BLI_ORDERED;
-	bool			dirty = bip->bli_flags & XFS_BLI_DIRTY;
 	bool			aborted = test_bit(XFS_LI_ABORTED,
 						   &lip->li_flags);
+	bool			dirty = bip->bli_flags & XFS_BLI_DIRTY;
+#if defined(DEBUG) || defined(XFS_WARN)
+	bool			ordered = bip->bli_flags & XFS_BLI_ORDERED;
 #endif
 
 	trace_xfs_buf_item_release(bip);
 
+	ASSERT(xfs_buf_islocked(bp));
+
 	/*
 	 * The bli dirty state should match whether the blf has logged segments
 	 * except for ordered buffers, where only the bli should be dirty.
@@ -800,16 +809,56 @@ xfs_buf_item_release(
 	bp->b_transp = NULL;
 	bip->bli_flags &= ~(XFS_BLI_LOGGED | XFS_BLI_HOLD | XFS_BLI_ORDERED);
 
+	/* If there are other references, then we have nothing to do. */
+	if (!atomic_dec_and_test(&bip->bli_refcount))
+		goto out_release;
+
 	/*
-	 * Unref the item and unlock the buffer unless held or stale. Stale
-	 * buffers remain locked until final unpin unless the bli is freed by
-	 * the unref call. The latter implies shutdown because buffer
-	 * invalidation dirties the bli and transaction.
+	 * Stale buffer completion frees the BLI, unlocks and releases the
+	 * buffer. Neither the BLI or buffer are safe to reference after this
+	 * call, so there's nothing more we need to do here.
+	 *
+	 * If we get here with a stale buffer and references to the BLI remain,
+	 * we must not unlock the buffer as the last BLI reference owns lock
+	 * context, not us.
 	 */
-	released = xfs_buf_item_put(bip);
-	if (hold || (stale && !released))
+	if (stale) {
+		xfs_buf_item_finish_stale(bip);
+		xfs_buf_relse(bp);
+		ASSERT(!hold);
+		return;
+	}
+
+	/*
+	 * Dirty or clean, aborted items are done and need to be removed from
+	 * the AIL and released. This frees the BLI, but leaves the buffer
+	 * locked and referenced.
+	 */
+	if (aborted || xlog_is_shutdown(lip->li_log)) {
+		ASSERT(list_empty(&bip->bli_buf->b_li_list));
+		xfs_buf_item_done(bp);
+		goto out_release;
+	}
+
+	/*
+	 * Clean, unreferenced BLIs can be immediately freed, leaving the buffer
+	 * locked and referenced.
+	 *
+	 * Dirty, unreferenced BLIs *must* be in the AIL awaiting writeback.
+	 */
+	if (!dirty)
+		xfs_buf_item_relse(bip);
+	else
+		ASSERT(test_bit(XFS_LI_IN_AIL, &lip->li_flags));
+
+	/* Not safe to reference the BLI from here */
+out_release:
+	/*
+	 * If we get here with a stale buffer, we must not unlock the
+	 * buffer as the last BLI reference owns lock context, not us.
+	 */
+	if (stale || hold)
 		return;
-	ASSERT(!stale || aborted);
 	xfs_buf_relse(bp);
 }
 
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 8a8a46e698be..141c3780a36b 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -49,7 +49,7 @@ struct xfs_buf_log_item {
 
 int	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
 void	xfs_buf_item_done(struct xfs_buf *bp);
-bool	xfs_buf_item_put(struct xfs_buf_log_item *);
+void	xfs_buf_item_put(struct xfs_buf_log_item *bip);
 void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
 bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
 void	xfs_buf_inode_iodone(struct xfs_buf *);
-- 
2.53.0

