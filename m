Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8DE1859;
	Wed, 16 Oct 2024 00:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729037552; cv=fail; b=aIONO+/EcYs8fNL9JWDBeUObGjIqLIXHey5slfSjRa5ZMRmgf1FHRDmZKPaO2WfrgapgfqsmIHaWPfeVlpGQQhR3G7va3updK/Qi7kReup07a1BGHlT5xFqZ4FqkiXJjBI1mCNdRwwz3rktZt78mcnCmLlqY+KCmCba/KL8QlOs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729037552; c=relaxed/simple;
	bh=QzPMIzotBrczxSqSMi8BtEqNXdiFkSkAeE9L7FNGvBg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LqTTGz/doRK0RLNbozckSLAK6AmBnNfecXtf/8tuqiTzGliPsCK4eKsW/iY9dVu7DycCNoIXS7OO2JXAfw8dXWLT20esDv8i7Jvc08GAzAhsayAQGXCKbZaz9WhDGxH+NomnhN35AEpJZgU8OCfH4vYqK8f2IG1St9Cc2gwJMHU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GfN//Xpe; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zX0f7B1Q; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GfN//Xpe";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zX0f7B1Q"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FHtikB019421;
	Wed, 16 Oct 2024 00:12:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=4yKK90hFvHiC2ND2k51QMNfbbckh0+U5eQ7ymmFQfA4=; b=
	GfN//Xpe4lmd0MdHYLmOTMSF400s4Yl1elpaEgkxY5oRjFygPcgjYQLJvWVGY6p9
	4+XIjZIkvaUeMkwq2YD8Sj5sZnmbZwaZBNj/AlU0NDMe34P7FbGnoRH9kFkIoI4F
	6RogygSNfZQppgI1u7GluSny17waaFbUp7hPH9OGWV4jJx9goBP8hNU3zBIBIvHb
	ekES4gPugDqtuOR0h+2U2RA76SmHXKqGl/fRHO7Qsl9YGQrG+ddivhRP4Cny7g56
	eN7DQLT55zMuze/vdqyKHjFFBFF2Fo//iCwXKJBLCWVrVp1T9FSm13/vGfJw8Wvo
	SiwEq62Dyca9im6OujVidQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427gq7jhqs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:12:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49FLkLwB026369;
	Wed, 16 Oct 2024 00:12:29 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 427fj85aps-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:12:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=en39S8v07A+savMTpy9K8RPvjs8+MPNWgflPN310PcTvNFNk8IwaBpWDUBqUAWobbjxh7icOcfYK7owtb/4rt1p10gCPWAypiX8sl3k+yBBVE1nnijCyhlp7JAUPagoOvI4GUGett+FlQLh1+FKDNljZJas1FwKc/mai+ntRuDATKpSSvsP/PLV8cSwAivj29pAKCjzQPgtSEg1rWrAhDUA2pdSRPcpXi0noLydyKRTN1hF50kIyfQxcHNBHl6G9d2uCSM7s/f7y39B6Srx/85rygkOxwnKLeJ59vP3DlzGBwZBAWawVYUyYD3xZ7QPkN50C9PQGlS9S/NJxdal93Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4yKK90hFvHiC2ND2k51QMNfbbckh0+U5eQ7ymmFQfA4=;
 b=UU4gOvFb/qAwUTKPAXRYwHV1MjQZIrt5RmWnLFvEHGsjBlpZeyRVR+EvzcZ/azxpdD+WN3pl2ydPwc6bz3LJIU5ahI8ItCO2wel+1+rrhaC3tHS2uXQZ59cuWlwMQNBwR0/+sapkk3p0WTqpJPduWHYaIdvJgsZBO8viw/4nQ1eg3qKjeqLK9GHZ7qO0YCO/ttRHtCWi1G+9zjUw4S3S5W8Pf0/4KDDQweGYZJD3/ykuXRUA2xOoHCaD1hM9KM8df2kdH/zKA6i5w3h0DkiI8huW2HdSLFjyGVhdw7cyx9pJEUYApxPeB60Hx1SLPtZdftZ4sa56R5B6n/qGo+Euqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4yKK90hFvHiC2ND2k51QMNfbbckh0+U5eQ7ymmFQfA4=;
 b=zX0f7B1QC804EMPa/bdrskvdp9syNX4IaitdQIhoc8RXOhz1riZaRe35QarNyyPdGwqA5khhlhPyCb9EGude19pcpevZcIol6kuXJlaer9YSWHdSVrpkPBAK3xm8UuAb/85IwqoFHfUXWArJiLuj3/5pLsFLjdxGn1ruWrp+r/U=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB4727.namprd10.prod.outlook.com (2603:10b6:510:3f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Wed, 16 Oct
 2024 00:12:06 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 00:12:06 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 19/21] xfs: fix freeing speculative preallocations for preallocated files
Date: Tue, 15 Oct 2024 17:11:24 -0700
Message-Id: <20241016001126.3256-20-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241016001126.3256-1-catherine.hoang@oracle.com>
References: <20241016001126.3256-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0033.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::46) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB4727:EE_
X-MS-Office365-Filtering-Correlation-Id: b3c94bdc-d80a-4700-de11-08dced772afc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EquHdzs0Pzofk3SylLM2VrUwkx9ZqPUF8IGpep1CzE/yhcitoo3xrLkfSLRO?=
 =?us-ascii?Q?rojfk7fse/eLE0D3VUt6d3grN7vdJKZUwSkq4x5DcNaZ2Nwfae5uqwLYe1C1?=
 =?us-ascii?Q?3Td4AFmy1nR9EjdhGwJrDcwe3sOUGLhiLCt+fJcqbZrqrlpAkwhqkHQnOPUy?=
 =?us-ascii?Q?hk7G8E67PZv+DxWwvGymhbUbHLmFXVhB3KGqfReTS/lDlwWwBS3KF/BmFLaq?=
 =?us-ascii?Q?uYNwB/9ighiITKhMtx5L+wVe1Gqy3rBLDsTAu76jXL2iJOzKZh3IjRvxOZuR?=
 =?us-ascii?Q?61lqdpKAfOxCM7pucEe2gc7e6KOHp2NPgpZbH6zxW+cFMTuq6xkgfIQbj8Sb?=
 =?us-ascii?Q?+DdmT5HBQdiMEYWnkQ7YRKqcGsjRzdBO5/obpHlVedQOpVjNOVTErk1Sk+i+?=
 =?us-ascii?Q?6xfo+Nirg8CniPCblCxTddWcEz/syZzQfVcDPlYgaU3KXZfycXjsp3S32Olw?=
 =?us-ascii?Q?7DxornCArI9nRYuYZTEZ8fnS/HbR9QdFa5zGr4yBk+bnDM0wqlKZ2R1ZE2rD?=
 =?us-ascii?Q?WCC1IST1Euivc9FV4GIBw2UeK3h+NTEtl7R8LAZsR8L/mu8TcFlPUOk2gAfM?=
 =?us-ascii?Q?D4Eo4rRDYS4HuIEsNYjJBpiPF6jhiztmP066/rl2aynrBOG3ZqjCPhhqashZ?=
 =?us-ascii?Q?SMHy5WNT+0LBU3ZMGZkZuZU5TcZXlByp0vy5TQC6gr0LotiDsZXlvw0wKI5N?=
 =?us-ascii?Q?H825WgQCPnBbbYnLXUjbFWrnQ4Euq2LOWlS4lwzfWgQOWJ4WLGa2kAQF2q8O?=
 =?us-ascii?Q?nEBoKxIe+3S7wRVSXIUn43/eV3eHYFOGU2zBx6rFQjyJouqgj9aVQz2djOGI?=
 =?us-ascii?Q?nL/3F7DD8rnQGPB/djnoIs7bmLy2Mjf+XT9Q3WqPadD9TQgz5HyNo5f4ku7z?=
 =?us-ascii?Q?dq5n30TPNa3EwYKYKgcdHGtQT6ybp1wg+h63JZ01H2TFXdhA+aHLqah73ryN?=
 =?us-ascii?Q?li6s+7dRXqNIr8mi08Hk+TOE1/G0ZQfDCyG1jWhxmwlG7nfFOp2HVdpB0c71?=
 =?us-ascii?Q?BJWtIflLup6dhkj+SbGnDlGTpkRV8FRD6Zzc7dbEEoOlmc/U5oha1yHVQ5f0?=
 =?us-ascii?Q?mPw8GK8BQ3poR+zB6NberqbV2ZpZVOot2L7kZ3GGtaI61kzzTkqfNQuj5Q2q?=
 =?us-ascii?Q?gpU336T/pIqXe79llEyU0LxVFxmZ9kjxA3iPoBnBkp3SJE++lTQp7nk5VODL?=
 =?us-ascii?Q?2+EtyHmyt7fNT8SlTcyC18c0+s6fgW6s01m7wIMlO8agMDSypHpNIT5n6edi?=
 =?us-ascii?Q?F7VofRamnHXelzAsJCtbnUW3AOna1M/Qoxo+/6H/JQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WxLyntJLOLYvNPlh/OijhpdAZNV/wqC1gjE7vUXjyBu/mblA1IFAtUQFUCwk?=
 =?us-ascii?Q?l9o1PICk9B7dNmYVbczLtPWJ+yX2fC9CpVAMhsiFMP5nV+GCcspOtjhO7SjT?=
 =?us-ascii?Q?SCH0SsW94ObCwqhD+I5rT/dRy9v0pW5tPjwNEv3QHkaAnbXCfi8Xi94Rf5ew?=
 =?us-ascii?Q?6N44sUD8gVmL5NP+AYA9SvdhpALl96ktNHxC+DRQVPzXEeEhSo9HCvMGfebq?=
 =?us-ascii?Q?7Wvky51BPN33yjbVgKSi4TQm1Tc7EIxxZ0DdrIzcx7rNxE2C9PtIy4bKCimU?=
 =?us-ascii?Q?zoDHdbO/a4zuGIT7o5CN60AZ3Z+NOT0gNHGxK0s3lLXVUQcQ1w/WJPCYwrz1?=
 =?us-ascii?Q?NXeoHH/8aiJ38aV/Wnkv/pzykoM2cN3f5siCpp3eIbedyAwL25QVcCEFNGh/?=
 =?us-ascii?Q?tl0zHEM91iSoPH04/q1BymusUNKZg2mk8uMr9bI7M7dfKjtDB8+Ka8TxNKwl?=
 =?us-ascii?Q?ih+mOdXId4KD7H2ZaiL/HQsIbEaMIl1JxF0fEWF+900zEY0jQMPNFAEZKpiO?=
 =?us-ascii?Q?NfaaX3HKoZ2uiz1pZkYelA3MkEPbm+6BRjCfxjvbxNDlB65UTfVZ2mdkX95B?=
 =?us-ascii?Q?iNKkWdQEmlyc0DOfkdQBzEpNYiz/AW9SADmBgmfxSPIldOl7+jncAEbjwfLv?=
 =?us-ascii?Q?y9Vfn2pRNDzbXAd0tDkdeCuRGzidn7nYyAY/jdOcRGIfHuu7g24b9VHwob1s?=
 =?us-ascii?Q?7LVXMoZv/wjUp+leyZxixZTa5ThRuf7vyy25zKeUtniKUQPu6cyqfsoPgNj2?=
 =?us-ascii?Q?U6JkT7Y33xBSByk0RdwWmXCqMBtr9+a4j3Y12mVmJjgqd+0XcWoV04jH7C9H?=
 =?us-ascii?Q?RSh0N7+YIZhhuOYrvYhzz31h4/Uwy5B1YxJ3HoYR79o+Y9zVYBghN5L39GSG?=
 =?us-ascii?Q?Kelrkr2oxbB+4yvw+z1R6F3D6QTdPe1BNs4LcqBL5nLLQRYi9obU41sidl9l?=
 =?us-ascii?Q?tYFB600fcdDy0/M+Zi74wT15eMOlRagNI0TMF3vUs6O7kvyYJIyzz4eLx6pQ?=
 =?us-ascii?Q?Sog+5+87fhVTzvChf6xqVTwDED+toyUHjYsKaOzhWw8yRdUuzgSK4rV7Yrmi?=
 =?us-ascii?Q?xw62/Tar/GmW36kzJyXvBv1VR+a00bLaaSXRe9dr9X7rKpX+L4FFXm+CY2Ej?=
 =?us-ascii?Q?fDKSzEma6v5SuFNnZECmQ6n5pNM4ulLDOdSW5c1DQ2iEtFMH0c3yiVlACfco?=
 =?us-ascii?Q?ctGDlcNcznNVVhCaFIRZm4h1v7tRjzmk5JAFBetiJc3g7QpAQeLrS1+qOClW?=
 =?us-ascii?Q?WaQASMmNDUFBSps5pDpuVsXzkobu9tI33SPxV1puqbPUI+wJ9ZmvSFbs1Yuu?=
 =?us-ascii?Q?Io6ctpllnDJqnHWLTDBref0D/1X7XyiNzoJ2lDfc4PaE1jrxV5LgqnixSJ1t?=
 =?us-ascii?Q?8BpcipCw7wV7wo7h4+Ksj4mGa4WlAJ8agJL7J5NFVPD5hA9pYMfa/9ENYT2T?=
 =?us-ascii?Q?gvm795qd+bAEOQUkfLKG+iaB6O5Z5fc/eWExlQaounxK+k2c4jX0la7BreZ1?=
 =?us-ascii?Q?7q9tdTRCQEVv7gEWtilUDyou6l/8IAkEyLBGFWQ8grInRAVWwPaUcLkarhiH?=
 =?us-ascii?Q?GbwrZ8NpS1SYRcins+5hV35uADlRWZ9wbvzRAte3WKW/QW5D30gkprYDN/rb?=
 =?us-ascii?Q?rM/LQY93XNwYan0qv5PFXiSockmaao5+r4eKvOnIzFXAeDp5/tGFfSNR3ni5?=
 =?us-ascii?Q?Nj3mSQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	J+QDbfkZ1A2NO81OiEWYngEQSZaZuNvCuJsXiPpuRCHfdKSPForli1lOZrHSY4v6dRzIojM88tCJBBGWCz/i9UROW3K9LO0GoRtuX08HcLvNYiizVGOm+OCpqF6l/drdF7CzceFOiDZ07H3WdXmeb4mFGlx/DKXlEHiDRBda7UpItKkvylasZ7XXFrBTvP3WmEKrfBgBSLOF9ZcxgeDCWDlZ4cqLBwaiI07FBmyBVptSunxsVrhtI2ME8s13tqATEGrkZu0LA8tSvoLcNgQj8zoN6KYXFibFtzmx3SttcQbv8mYVJlkcM6mUIdFXIFdRhu1GacqIyaEP8Y9NU8wnCiT8zZHF0Tlxb+pr1zsIM0hNDAn1X2AgIn6A9l+4qHdI8L6ksGhbyOMMLRZedzNHM38+DUxsXOck6uWUHijH3H7f89urRcXJIQRebR8zOr64wUGTw+zcoK1nFboR5rRqg+xB8g5f/zI2b/vkJPsCe0Sz4/WCcd44S2Uo2LshboGkkMQAYhCu5NAgXSvSZOm0v1MR8gHMwu24gc9YH6/oGCf9iDzRRupguKaFKE8pErEVcAGQQsn6T9lqoiVH9O1d0RBYjRS2VeMi+yWmVGmVDXs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3c94bdc-d80a-4700-de11-08dced772afc
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:12:06.0848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a/lDt1ueyhOZQ4YUuyHP+iEtzXhJxvexSYG2Nn6Lxapy/nB5G6lWsW3nc93YqzVIwbH9vGi6S5MhM8bRaM93fVqp091nQ6gdB3aadmVsF80=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_19,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410160000
X-Proofpoint-ORIG-GUID: Ouoqn9IgAHKB946_dpMLn8_dhoMnc2H_
X-Proofpoint-GUID: Ouoqn9IgAHKB946_dpMLn8_dhoMnc2H_

From: Christoph Hellwig <hch@lst.de>

commit 610b29161b0aa9feb59b78dc867553274f17fb01 upstream.

xfs_can_free_eofblocks returns false for files that have persistent
preallocations unless the force flag is passed and there are delayed
blocks.  This means it won't free delalloc reservations for files
with persistent preallocations unless the force flag is set, and it
will also free the persistent preallocations if the force flag is
set and the file happens to have delayed allocations.

Both of these are bad, so do away with the force flag and always free
only post-EOF delayed allocations for files with the XFS_DIFLAG_PREALLOC
or APPEND flags set.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c | 30 ++++++++++++++++++++++--------
 fs/xfs/xfs_bmap_util.h |  2 +-
 fs/xfs/xfs_icache.c    |  2 +-
 fs/xfs/xfs_inode.c     | 14 ++++----------
 4 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 4a7d1a1b67a3..f9d72d8e3c35 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -636,13 +636,11 @@ xfs_bmap_punch_delalloc_range(
 
 /*
  * Test whether it is appropriate to check an inode for and free post EOF
- * blocks. The 'force' parameter determines whether we should also consider
- * regular files that are marked preallocated or append-only.
+ * blocks.
  */
 bool
 xfs_can_free_eofblocks(
-	struct xfs_inode	*ip,
-	bool			force)
+	struct xfs_inode	*ip)
 {
 	struct xfs_bmbt_irec	imap;
 	struct xfs_mount	*mp = ip->i_mount;
@@ -676,11 +674,11 @@ xfs_can_free_eofblocks(
 		return false;
 
 	/*
-	 * Do not free real preallocated or append-only files unless the file
-	 * has delalloc blocks and we are forced to remove them.
+	 * Only free real extents for inodes with persistent preallocations or
+	 * the append-only flag.
 	 */
 	if (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND))
-		if (!force || ip->i_delayed_blks == 0)
+		if (ip->i_delayed_blks == 0)
 			return false;
 
 	/*
@@ -734,6 +732,22 @@ xfs_free_eofblocks(
 	/* Wait on dio to ensure i_size has settled. */
 	inode_dio_wait(VFS_I(ip));
 
+	/*
+	 * For preallocated files only free delayed allocations.
+	 *
+	 * Note that this means we also leave speculative preallocations in
+	 * place for preallocated files.
+	 */
+	if (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)) {
+		if (ip->i_delayed_blks) {
+			xfs_bmap_punch_delalloc_range(ip,
+				round_up(XFS_ISIZE(ip), mp->m_sb.sb_blocksize),
+				LLONG_MAX);
+		}
+		xfs_inode_clear_eofblocks_tag(ip);
+		return 0;
+	}
+
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
 	if (error) {
 		ASSERT(xfs_is_shutdown(mp));
@@ -1048,7 +1062,7 @@ xfs_prepare_shift(
 	 * Trim eofblocks to avoid shifting uninitialized post-eof preallocation
 	 * into the accessible region of the file.
 	 */
-	if (xfs_can_free_eofblocks(ip, true)) {
+	if (xfs_can_free_eofblocks(ip)) {
 		error = xfs_free_eofblocks(ip);
 		if (error)
 			return error;
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 6888078f5c31..1383019ccdb7 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -63,7 +63,7 @@ int	xfs_insert_file_space(struct xfs_inode *, xfs_off_t offset,
 				xfs_off_t len);
 
 /* EOF block manipulation functions */
-bool	xfs_can_free_eofblocks(struct xfs_inode *ip, bool force);
+bool	xfs_can_free_eofblocks(struct xfs_inode *ip);
 int	xfs_free_eofblocks(struct xfs_inode *ip);
 
 int	xfs_swap_extents(struct xfs_inode *ip, struct xfs_inode *tip,
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index db88f41c94c6..57a9f2317525 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1149,7 +1149,7 @@ xfs_inode_free_eofblocks(
 	}
 	*lockflags |= XFS_IOLOCK_EXCL;
 
-	if (xfs_can_free_eofblocks(ip, false))
+	if (xfs_can_free_eofblocks(ip))
 		return xfs_free_eofblocks(ip);
 
 	/* inode could be preallocated or append-only */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 8bfde8fce6e2..7aa73855fab6 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1469,7 +1469,7 @@ xfs_release(
 	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL))
 		return 0;
 
-	if (xfs_can_free_eofblocks(ip, false)) {
+	if (xfs_can_free_eofblocks(ip)) {
 		/*
 		 * Check if the inode is being opened, written and closed
 		 * frequently and we have delayed allocation blocks outstanding
@@ -1685,15 +1685,13 @@ xfs_inode_needs_inactive(
 
 	/*
 	 * This file isn't being freed, so check if there are post-eof blocks
-	 * to free.  @force is true because we are evicting an inode from the
-	 * cache.  Post-eof blocks must be freed, lest we end up with broken
-	 * free space accounting.
+	 * to free.
 	 *
 	 * Note: don't bother with iolock here since lockdep complains about
 	 * acquiring it in reclaim context. We have the only reference to the
 	 * inode at this point anyways.
 	 */
-	return xfs_can_free_eofblocks(ip, true);
+	return xfs_can_free_eofblocks(ip);
 }
 
 /*
@@ -1741,15 +1739,11 @@ xfs_inactive(
 
 	if (VFS_I(ip)->i_nlink != 0) {
 		/*
-		 * force is true because we are evicting an inode from the
-		 * cache. Post-eof blocks must be freed, lest we end up with
-		 * broken free space accounting.
-		 *
 		 * Note: don't bother with iolock here since lockdep complains
 		 * about acquiring it in reclaim context. We have the only
 		 * reference to the inode at this point anyways.
 		 */
-		if (xfs_can_free_eofblocks(ip, true))
+		if (xfs_can_free_eofblocks(ip))
 			error = xfs_free_eofblocks(ip);
 
 		goto out;
-- 
2.39.3

