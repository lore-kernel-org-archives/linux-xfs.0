Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C5D3998B4;
	Tue, 13 Oct 2026 09:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884267; cv=fail; b=T+fDNdF2C14ZkloUtnjmYqCHOPzaqsW23R3vriVEiABpF1u7TK/lcS27gssoRuElsYKoZXKI/3vzTMRkwcatyQ3kOPSr96HAnBa/MtDLwn3kVxbkVz6Skmqw3Dgns6GmUulyQVJkBdqIGBTuL+4/Hw3kfplUFEInyQkavFP8zzk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884267; c=relaxed/simple;
	bh=GJcJJGrVL9mq2fuC6anFDSw0/r2B1tFUJpQMiq/qMII=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Ei0d1IWlhOKJRS6sNSf7qoEyInDDRNIGj1tBU6wgyL3FmnPPAVsFz+X6fAxudlQzXozp5ueh/Ja8St4CB2QKslcAH0WBSYaA+uoOlqOWU0XNFCNLB73bK71Xpt0Rgo2x+L/jvswDfq6p5w1J9GzSqDFpNTneXWkgnwvumyJFjBE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qGzlExFR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bfWKow54; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qGzlExFR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bfWKow54"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2CjVh3435771;
	Tue, 13 Oct 2026 09:37:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=PIXOXKQbWmVMtSHQ
	pok7l9J56BOr50KcIpFRG0v9IZI=; b=qGzlExFRupGQdaPJVpPg/FaFjf4OF+48
	xZVM4Fm2LVAg8BS6bAi3mKdSgmmos42wqlDIRH4ZQL7/q99QORS9sdjaZFT7V4XW
	D1ehs8XdfKgtGR1eIcZdoTm5k9LpWeSpjDv8XMyZLfzR3GFFdcjvdE90kbslP9U5
	vPBFiiXmceEjDXzdqFc9Jdf/0WCD1mKq09DQNlTYwgQqes9PMbOchZ6vPJowaa5h
	4POxXuZjFlcEVQacKjH/xbJTLnB0eLXBpHzIxoi6g8qNMqla3uwSta4mlgwfCYB+
	dCz1ZmLfkNdJY/ua/Ud4Ta56WbvYUiUiKhqmZ63vYyqFBlaFh1B/CQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7de1kp2g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:37:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9aTMk005400;
	Tue, 13 Oct 2026 09:37:38 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013038.outbound.protection.outlook.com [40.93.201.38])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bta2aus-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:37:38 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fvPaK23LxrvZuWcfpSZ3D7Fru/+T+KnvuFcHw+cHz0pqR9qug9Jg0WaT3FqXGOnndaieJrMZ7dHYgJERomm3nkqYvYxRQlvulgdOE+o9yl7bm/mkrquTLdTmmc//Alvdi9u8qa7uyxSKNqmFPH/QmZmChfgUsPZOjtyrLled7DXEdIpyHem6kB7/k3P7SDEr2IAdCBtw0yz32XOdT8WYopmKM+naICbuqme82BGwIzaUPDc+vFGM6+N70l/EU7X/MY6xFezw9SF97IlKG/JgyAF2M/Iw3GuMLMgcyYjBw1rQemGo4b13UOngQykTMSTOJsXJBorIf4HHCUrBOfTfVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PIXOXKQbWmVMtSHQpok7l9J56BOr50KcIpFRG0v9IZI=;
 b=EwKeBsK7D9plfKmdULoeeJwtihdp4pkiwNdtQ+6VonC20awL+vO2PoIBAZdFdEG1dNWcsov1SPrMatYR0YfxHwAYQAUsLQVRVV4bj1AlC+JWZqR8NzdL8QqWoS8b3r4jiYj9YMFUDQlaomrUM2RVe8PNiDQt2TTMX3PrQvrvnew7siF+BUgZezNfbHAetcAMFwUyZxzCmXzcuuSv9dfgTi/tunAjPU780HjBpRRL7J69/JZz1/ytbvADORumLYW3CNzmDXj0Khatk2YuVJmRKNfXntS2gpnCx5JEi7U4y4xm67T9duxsBw8q8MGmUBRE2htayiVJtN09fdKY710O1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PIXOXKQbWmVMtSHQpok7l9J56BOr50KcIpFRG0v9IZI=;
 b=bfWKow54nWvzTIv8X7XnbdjGuH/uC/Up+FZwt2tK3MiOwXxTKfmzMOZK6zGQMwcv1LaV7DcBnZUN/H96dnevv8frAJYYN1Sst/OSnSmbnATYj+YlZ93qw9dDqOq/PVtQsyFN3t2aGXp1f3zX1HV4iiSny8ACkX8Iu7KHi2/rmNc=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 CH2PR10MB4392.namprd10.prod.outlook.com (2603:10b6:610:79::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.12; Tue, 13 Oct 2026 09:37:35 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:37:35 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 6.12 v2 0/6] Backport of XFS umount hang fixes
Date: Tue, 13 Oct 2026 15:07:23 +0530
Message-ID: <cover.1791883280.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0122.apcprd02.prod.outlook.com
 (2603:1096:4:188::10) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|CH2PR10MB4392:EE_
X-MS-Office365-Filtering-Correlation-Id: 690c12ef-89dc-4d08-e4d9-08df290d9cd1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|23010399003|376014|366016|10067099003|261009223027099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	Waxz9VRWzIPICM2oG15SJbb1Gl4Q9Sam81WtUV5U1WrWR+qOpFSJyueLQe/+pzNg2bkHvvyQuF6/YgykDb1/C6puFeBAWvngKZsupj/5lci4phOffGAbx8ydtgnn6Uw+baFpiTVDjvQpT2Ea7PNtBDCL2huCmaFCqyyJkuvBTFt2bbDV8JQCdn4weygUZATBdFGOhcAovR+HAElT/z49fDa6J+I6Fc7Xw3+45PRybNNp58YkBpPvNZHrQV0elW00ZzoV5JMM/c7JMWzJPVXa0GGGoAlqu3B09gTa8MlZBSxzHHoOveEIKF6rEWr22pDJtDv+EOqax9woUh7OYd//14U/B9HY+bfMXwKCtByymJELWK2YB+7VySjt/fWqV/bb4CGr6027kHlDwwkm4vErQHIsg/OnR+AEW52kwf1wAElE3g7Y8iPyxue9nr/8u+hBjv11BXW5eVHgZeXeIQj6XfWECfJCBnImVbpQ7UcB2nZJ9Iqt68PGWIu6XZzNzLGLlw/hrmfLGv403/KVkDr3CXKVQVPIrbXTTuUz4RBjHQ9RYSFeXDFgPpK7H0/K2TqVI3PPGCFPA53Lq8SSlWynApKbwZJkao8+vljRQwNypb1q97POKggUJx5fMRERM1SF
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(23010399003)(376014)(366016)(10067099003)(261009223027099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OBAQgxeldF4lq5yZFaD1r93UXWgsWGPBj96hg6O7vLs03Bl1BAGmqU6dlQQQ?=
 =?us-ascii?Q?WkAMH9sliKPpONAXsQdxMKE5cp3jnW1sKCRflyBAX0O/VuxveOKaReodEhEB?=
 =?us-ascii?Q?dgEnNVabE69ogaSFFzU2is2B4NBvXnqKeg0oczo1Wu6h6ykyzAZmJsz9NGyq?=
 =?us-ascii?Q?Khq0pIio/BYMBU2df5YddNZCnjauMkX76wgaAbOm4sqMri4A9f1XA25xQFaK?=
 =?us-ascii?Q?bO0rDT0joHUSaA+h01TC8NuyQ3GNQ5Gq9+D/Eyt0N9U0Qz6fG0OMAHzIlMhX?=
 =?us-ascii?Q?FBwnB1CTeNl1kdTvjC+Vnc/5Xb88+kOqrNsBfU5apxRlzDJ0ehx+5qjOYz/c?=
 =?us-ascii?Q?FhjGTf8RMGrVlEBgyyD2XAcUGdy3NHHp73cATSs3gev8LxpV949TazVBZWiW?=
 =?us-ascii?Q?oNsXnQpizI/fyL2MV6RvC++R57Ww3VM+I7T+t7dPFpLusa+ai2YPhJHT4hgi?=
 =?us-ascii?Q?EMxqdx4H4HqS+aNc/aLRQYg9Y1MfU7VOwXu9jsFiGUDTMn+9v3pGi+XvlnOF?=
 =?us-ascii?Q?BGT7D/lDYovu8Dv4rUbMSAZqTnQB3sKyBceresmTp5tsi8FqhtYpRO8BIN5N?=
 =?us-ascii?Q?mYDN24ynRDgDRAG5uO2A7HxSR+hYDlN0iNeIjK/fQxKABR3wafC51jEJp9Uk?=
 =?us-ascii?Q?PXPxV7Uf6tpXe6q+VyScxWzd0UGgsvQDVO7IpRn1xCk4BqfIjrxIyEQtERwV?=
 =?us-ascii?Q?qQPbZANlHS1B5ARrs+9GiWp5/xP49jmrkP2oaftbLSyxFzVT34TdLdng5YFN?=
 =?us-ascii?Q?HAf2rfh/TZm3BVg7yXH6KZvlBoLpju8qKHplyy/TYW8OnMYaLx2cImzdkyPJ?=
 =?us-ascii?Q?daKJ3DuJa/sjCZyPYBFgmKUG/epMIitaIvgdFIq0wN++8rqhYxBM7F5q1MhX?=
 =?us-ascii?Q?k9tK0X758dC0eCanwE8MtmFV4p6Uan21rK0Oot0X/3CZQCdvqMJ4Q9h5tn/A?=
 =?us-ascii?Q?mVPybcfmL40Dab7r3REy8EABwgbq1xG3r3bBdCuRKEdOdDJND5t9nZpqmbzt?=
 =?us-ascii?Q?Zbm7/fwEuoK4FmAgkkOYDaMJEDZY6pLqIBm+jyuuOQ4zASYvoR7TU9AqyBBL?=
 =?us-ascii?Q?a8I7FYI6O2QQzTyfTQeyV5bP86TFMVOmJ+lMWPmWf1Duu1RL0DsP72ojBj5F?=
 =?us-ascii?Q?kL0QNd6HIb1rDqGi4lx8UKblxLCKXpoJR8fWQgvTJQ3Fggd2rG2g3A2UDrGN?=
 =?us-ascii?Q?NKEBNJkgsMgQxR23IjsLvmys5Rqr4DQP12DDuPvCJB5cCKj8p5Mpc+JzepTQ?=
 =?us-ascii?Q?v9rA4ViE220EwUgisbPJZefp4NHPIxTPAOarcIoK5GHMe8vHWlL48/36kxO0?=
 =?us-ascii?Q?OvP2C8MBshR257K2NSXJGOhHFvcdi2k3NPBfiy9DOaCR+fqJcnZyAPzhqbhT?=
 =?us-ascii?Q?tyKfaQ3lzKT4ig+SEKXizf94r9HlerzSnKohP9FJphRw77Rcr6PfbSaSgp/Z?=
 =?us-ascii?Q?bObxVJCnQY5uHmVhaLjXG+62zBPfuXrNTaDs6yCLI/oM+5PVk+R+/CgalkAW?=
 =?us-ascii?Q?LUDO5xUlYhC8sQb+lcB1ar4WP4hAj2K6HgmgQje2RpxOi6Q5vftT+3tBiqYx?=
 =?us-ascii?Q?kWQusl/dKp9ZYrEkz3hUaKmuGMuh3T5yW3B7jPiNk/q/xLtNC5DsevaLmDT8?=
 =?us-ascii?Q?HRHtHflwV49t3XK889mop7/WL4pKV8+lxZJeAj60pjJ0Z73CtU/Ot7WVO2rv?=
 =?us-ascii?Q?rbyxr80qsGVUWcVGIcTDMpSIJKkiEyZ7VemOjsHRYhjZkhV1WnMZzh95sGgy?=
 =?us-ascii?Q?SvSssS6cVWyUNPznRydL68xoEYiyzjE68W5FgEji1dgyuLXnadP/TjXeP5tS?=
X-MS-Exchange-AntiSpam-MessageData-1: G0o70iKQJHFaKmPDQIiBxb+IOAVg5im/LnE=
X-Exchange-RoutingPolicyChecked:
	zN+tzqf2PdjQYi5wjrjdc3gt3IlfI7hlgVihYVPFJMjO0dZm37Nmwy03pCRsX/RZwQBjF9iOcpOvq5z50PM9Q6POKyjZP8aEIe27Ds8vzXLavlUIjS217QI/gxILcrgQBkWfs8OfV0KAUzaZRvhmtT4KiPN/ivloMO43W2puBeQrvV1RvhsktNZlIzwh0HCpF8cAvgUtEVeXMqb9ASonPj4POA1drPjhUGntBWT9rf9OJ6+0APga8Xq9CLJT8j6+djdit+45Jy9AUMI0Z9M2YrKAwz5yNFfo7W/yoTw/Wx2Jdi2f3moTWDKHHp+H9vtM+dRsxDX5bvbDCdJE2K3o4g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qvYQc6zoH4PaaBGuj4qn5oOdIdCsaKreaOsFe/C229xGZzqyOz+WerdQ+3qAptKa4w0jkK/jl6pblWnCfFvln3YJTceolhZH/daIilJKKVelbBLHAPQB9OKDSJv5GtiQi4UWZSap5/SzYtN6qtzR3oHHYBEAnZWWZ84QLa0JzrOIdkU7wSiHhidqh6vE0pKZZ+l1Nl1e2QVa906eQ5o/jkL7emL0vm28//9aFZ13pn2t+riUjGgcB9aLPOUyjy39Lc4lq90YZS3x9jdMpMMwhm3F+MnrAHgr3e41xcf7keivP+RUasi5Cj+1QfzGmp4pY+MTUqVNQgueB7QHa6FDTvG5ktG0eYCOk9l9lzRJ61WL12fUH9yIS/V4YN5Gj1u3R1BjmQ9begNaSjyVQdIuiYIA6Yr3z8ng5MCtFJhM0jsa8UYPYAZxIHgJiPDx9N4qoQwnrooLzkoMwRfEjjoQrDfx/jx/QnSmHeX7agzvJdbe2Sh6/JOrhWhfbg1XVa30us3ET2X67/UPownYV3y+L/LSySv8LwApe4guNHxWdaOkgvZShqUq/3/1oJTIy0TbPdl67WXPNcSiEn9P31+yTikxzk2+e7NPRkY2c+MHxno=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 690c12ef-89dc-4d08-e4d9-08df290d9cd1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:37:35.6064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rsApo2M9t9E7hWAjUzJKbp/fI86O7vWJLqtoqaoWva1kQR8sM7Vunsb4kjIMH8GyIsfyliyJWx5Yp00lICx+pJK0Gk8inSc4zqu6JplKo/U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4392
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Authority-Analysis: v=2.4 cv=O9SsLx9W c=1 sm=1 tr=0 ts=6acdfbe3 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
 a=3OcxSVRvUSqaRT7DloUA:9 a=biEYGPWJfzWAr4FL6Ov7:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzNyBTYWx0ZWRfX20Ha/mzZ0zmi
 unMHm7kThiBbHOxjyDJBXp50SwRZZYWHL9TO7fs/YK7V44Vtihd927j1lhuwpAc036OENRgYOKS
 QkxUOxOCrDu5h+cW+q+Tz5fbjmcyTqGc5Z4OSeFWFLYt7XM6KBQa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzNyBTYWx0ZWRfX5CsM8ZNNn/3L
 K1jADvR2QvLqbCSZcoJEMdYSDuO4uReS+Hazn+1XqTSgz7pUD6VDRZ/QWPM3J088eZqaYP/V9Hu
 4un1lH1woDt3tdu9HeXwLPvPJsQPMHHGGWp2KP5lmtjEw5GNi53urxFxMoVBc5KTuh+JvrDbv/V
 O1pK4suPFl59yAKI6nJ4MOin3mDWloSvZOB/HMt1OPePuLCc3xrlmWQaDGqHAouFlCpuzeWFM6/
 RUl3vpTFJkMNcfTi86FNYVg5uhVcz2/tIkzvwdnR9Dv8RoQT1fHJCr8JACZPLdBhkvHVthmMhzz
 rOycHIcXYWlT6YbyBoOqQewd2kDtji57bMfSaMTrX4fq5E2J9iLDAvdHMBzT5tiaYkVhqL5hUbJ
 WQHd0c2Yrsk0mWVCiy8M+ArnnM2eIJgfBiWYa89qrIunl3ANOqnTm+obIUKvJdJZBLzBD/IBjeS
 LM6vp4hoAnvaE7DbYCg==
X-Proofpoint-GUID: DGgvTie7cBk4aNgiKHJGNpsm7NaxG4DO
X-Proofpoint-ORIG-GUID: DGgvTie7cBk4aNgiKHJGNpsm7NaxG4DO

Backport of this series:
https://lore.kernel.org/all/20250625224957.1436116-1-david@fromorbit.com/

I have added information in commit message upon conflict resolutions.

v2: Address Sasha's comments to v1 in the below mail:
https://lore.kernel.org/stable/2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org/

xfstests_xfs testing results:
	Generic:
		Ran: 001 to 771 (672 tests; gaps)

		Failures before changes:
			Count: 4
			IDs: 633, 696, 697, 753

		Failures after changes:
			Count: 4
			IDs: 633, 696, 697, 753

		No new success or failure after changes.

	XFS:
		Ran: 001 to 789 (311 tests; gaps)

		Failures before changes:
			Count: 2
			IDs: 300, 556

		Failures after changes:
			Count: 2
			IDs: 300, 556

		No new success or failure after changes.

Thanks,
Siddh

Dave Chinner (6):
  xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock
  xfs: catch stale AGF/AGF metadata
  xfs: avoid dquot buffer pin deadlock
  xfs: rearrange code in xfs_buf_item.c
  xfs: factor out stale buffer item completion
  xfs: fix unmount hang with unflushable inodes stuck in the AIL

 fs/xfs/libxfs/xfs_alloc.c  |  41 ++++-
 fs/xfs/libxfs/xfs_ialloc.c |  31 +++-
 fs/xfs/xfs_buf.c           |  55 -------
 fs/xfs/xfs_buf.h           |   1 -
 fs/xfs/xfs_buf_item.c      | 297 ++++++++++++++++++++++---------------
 fs/xfs/xfs_buf_item.h      |   3 +-
 fs/xfs/xfs_dquot.c         |   4 +-
 fs/xfs/xfs_icache.c        |   8 +
 fs/xfs/xfs_inode.c         |   2 +-
 fs/xfs/xfs_qm.c            |  87 +++--------
 fs/xfs/xfs_trace.h         |   1 -
 11 files changed, 270 insertions(+), 260 deletions(-)

-- 
2.53.0

