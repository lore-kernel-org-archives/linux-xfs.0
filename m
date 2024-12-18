Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C912D15749C;
	Wed, 18 Dec 2024 19:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734549484; cv=fail; b=AS7JniNCBC0+5CKFEqwsu1twoxnBs2s5nEIM1IppgeuuXAsv90gldmITdy7nlTL1L2qbxa5Lr0x+CRI1Uee81p3Eyfke8cI3ku5gsWHdqaQejvDF14OTmYJn91yvXgTXXB6LydElZCVMw/9hrmnPIvw74yQk9QXaX7sUCQxhPFM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734549484; c=relaxed/simple;
	bh=TXd4bl8cugnlVSyzTtz0HvhSDT2SkrXNW1t/Njl8vLw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=c1k0IcgmiYDDh590XM6+hJpOChrIPBFr/3DbPDEvJv1I//GDGOwSgC/vCoOwPL6BgIb5e1U4maFVNlDSyljovpkQCQs+ALJFUfPN0+QOrEtA1c4LDHcYhJ4gQi8EqVG0P3lsY9GWrPpmA0qb1XgFWOGimHi+s4jIayK7cj8Klo0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=O7zi5Aq4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pIobLkDQ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O7zi5Aq4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pIobLkDQ"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIHQlkl012926;
	Wed, 18 Dec 2024 19:18:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=M5hqBXp1VP9dRMkW/mIo7rnXW5ncHroe+FsN84CMAfQ=; b=
	O7zi5Aq46NXbqLB7Q7DAjW8DNsL1wMPBDmoSGgHJLp3j6gFni0aIYy+9q/Ss9KM7
	J6grqSAf2RpS/HydaYQzcdPkSTSYcyHLnqDlq0E5eKnbrE+DmJR2we6lOlsJmY0D
	T0alV30wutW/jR0rDUUzhdWiXVlIBncI6ej7yxxdPucRPksGJ/gCtsKr2XX/ebUX
	SBVjnXJcQSzPdbeJWUVQgpSlrkY2PkKRLkZbElVuXFE0+IwNeTK/E1OqKhV3en66
	eJYcd59DDiyUeVTNw8voj/me7tYrY09/Bj+FArL0XH+Po08uXyNijGZdMdjgFoRl
	8WVckOQxAhpAxgX6ZqkI0A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h0xb1fjt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:18:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIHUWou000589;
	Wed, 18 Dec 2024 19:18:01 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43h0fad5nt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:18:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cvFKOPUXyavFrzf3QbAP2TuHvMvQWPIGBT4gl4AznOudm1wU9O0kuaLxgW6f05tG1iZ8wWLfuEKJNgZdJHs0ium8ADJya/7/mJCEO9/rs0kOpqXIZgt1OVWIUouxMR13oLIKC0XIHv1d3epcozfpqbAFVQwBS5bW4ipr3YScEUKZRZJVh1308gW1DApJYOFqFtPrVGNNXjYmaXITSfRKbfxEy/XZFKTMgg+YvpTGcN/3YXE88+1v6fbMQ/H8kqIzraEwgwTGUzTDERwW2dfivVjjy1BQmA5rj67hEgmfPkAtkCWTnXDxSVzoQQOhEFLBo5Sox2mMNQppcjci4dB6dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M5hqBXp1VP9dRMkW/mIo7rnXW5ncHroe+FsN84CMAfQ=;
 b=tQxK0/hxEE+tIu6OMqcvbSL1ITrmIls2bit9KENVp99BJuuT3Bb1g3aJMo/DNPdBE1hktCPXcJSBIdf+VESxlROh7u76ySWJ/n8Hm4N+kv8eot3F78vMpgNu/I079sBti4//VkmYbUV7qSdiREM+LiR13+aF/1douMTfzUvIagTH7kmYFUFd7LFGY+/r5htaA4iLe9UM2Hcb6yOqcapnwRPE+AMvq6+AWAov8JO93Xl6uhBLLwG98yhoEnUjpHj+7dZyKPNtjyvEmdGaahVvceUyGPO39Ok4eglF5Lc1YA4WutNfykeuZAPi2cxXt6fq3J7WGB59qWqKpWPj8WLJuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M5hqBXp1VP9dRMkW/mIo7rnXW5ncHroe+FsN84CMAfQ=;
 b=pIobLkDQ9MtSf7FIkZA4HjrbZOMJ0Yw5/NVNcQln++EGEaMFFucLaF49bovRjPuT/I/JkCaTF6elf6slBgGqR57lcuzLPqbs7MsBAPC6xli6r6yaghSRV5yHvuWvMVwgM7A5DyjI8bXAaumkHRgW3N/9nK7H6j+GrSfA29MBhjk=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CYYPR10MB7673.namprd10.prod.outlook.com (2603:10b6:930:cb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.12; Wed, 18 Dec
 2024 19:17:54 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.013; Wed, 18 Dec 2024
 19:17:54 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 15/17] xfs: use XFS_BUF_DADDR_NULL for daddrs in getfsmap code
Date: Wed, 18 Dec 2024 11:17:23 -0800
Message-Id: <20241218191725.63098-16-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241218191725.63098-1-catherine.hoang@oracle.com>
References: <20241218191725.63098-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0016.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::29) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CYYPR10MB7673:EE_
X-MS-Office365-Filtering-Correlation-Id: d3cd8b23-ad0d-4d84-608c-08dd1f98ac05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TRabxMsofoM3ufigxFFKwFhVqiwCUzfaGkvMOEnYRz4qyx+bQ3TKkRcXaKYS?=
 =?us-ascii?Q?QkRJ03EFDElrYOOF028gdfqVy6KSzAk2nCevUz/W3+x3Toz1Qbh2+Cbb0Ch4?=
 =?us-ascii?Q?zGzOUgD7gpTCy9r3JR+xmM4rGvy7cAEep1bOwdbwtXBJQFe3XvetOLnrnTuK?=
 =?us-ascii?Q?oolTdpF9OsaCaBBNbR/9Wq13/EM3NS0Q9YUJ1CBxiDR+QFJMFHIcuWj3eVPn?=
 =?us-ascii?Q?buAe4c0vc9dKNkt7gZPiTb4O66czO5tcagKL2e3O5oBJKO/ZpHHsyboRdVnZ?=
 =?us-ascii?Q?wozY+mTMhglYOQZaBmLAT1NYr76jLG+nP0I+ZGe/7V5JL4/rKVnY8cY8/v1V?=
 =?us-ascii?Q?zVhPPJsoUsX8rqXf+cDMS8PVTjhi5U/dsFpDktG9b3hRlyAIpBURGqtpVi4x?=
 =?us-ascii?Q?if/y4TjLc2jz8TXq5bH83uoeHH/6+mG+iPoW3l26PSo6LSR4Vwo3hUHKKsT8?=
 =?us-ascii?Q?ur2Ij5X9tC5ik5DURe/tGigeDxczCh7dkTNy+uTqIPLmblbg0lfhajrtzMjb?=
 =?us-ascii?Q?kQMhQiGLl3B64eeWXOfVTvCE+ipanEV1d+c4b9XV/YWRlcrS5Kmdt9fnd7Q5?=
 =?us-ascii?Q?PO6ld5Wphc1It98ILKE5tWcQBQNtS8J0pYWs8VVXqIcQhfjsGjvYnCyprNex?=
 =?us-ascii?Q?dMTP7dzbvmfQ+SVJz62/wnmzVwhhMyqGFvVu2p62hCVSuxXmVX1k2EhbBtB3?=
 =?us-ascii?Q?tuEFLW07r88Gj70QQFXQ4f0ciKX2VYqueRZy5Tn6WQV6A/dd7MOAkO7Br+ad?=
 =?us-ascii?Q?x5vy5bghiQJhouBJonc541abLFgh27tkDbkTaztQpLkzhpCV6O/3fjFlCwBm?=
 =?us-ascii?Q?trUuXl1wTPQ6zDOWKpZkk6Lho7ir3rY0qGP2TRp3dOIb1vjqWqmrmxSjdk2e?=
 =?us-ascii?Q?AF0DiezpP83QnkOOG1lvQYoQMAq0TaJzAR5dIQMQnw4z2rXOIiDiBA4sihLU?=
 =?us-ascii?Q?KrW6VWVdyQQafgNCZetIUbJFFNHTcPwsVLh2uzTO8qr+2yKqayLjoRU4NGSe?=
 =?us-ascii?Q?TRfeX89oglqOilKkX9Hmn78oSbLoLVEQx0DogaUZEo7lVc4AhEJmu2OqatRQ?=
 =?us-ascii?Q?9nd+JiOBPajQIxCyV/XiQQai1xKaGZ7PVGSyLA2cRl4ln16380yfkO39ex3D?=
 =?us-ascii?Q?vaxbJ1lhgL6I8xlC/plxmdBIiEpuNeB9aBtULG3Wd91bMuRH/MZ1ULkHil/J?=
 =?us-ascii?Q?LUrgCaYiQK5dx0fcPDHW8VAH0QYqEwCm6IAlnj3cAUCUeheItNm9DSRWeh+q?=
 =?us-ascii?Q?BRiDjuajbSbXIDn6cAYjAEskSai5fxQwCG9BKBYJ0qR7rgyTmhxM8b0QZlhX?=
 =?us-ascii?Q?9AJjoshAMM4u1tqeEB9l24wyYq6PU57fr+ZKJBeHsIP9bAeT/710X4rbaDlh?=
 =?us-ascii?Q?Vi7032RbBBW2rwVAol+5+58UNxFD?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cFrb7bTkpq8EbUtsibkiHDhIWxhOTnFC3FoOctJ3p7YDLuar3L0NNeXhgvve?=
 =?us-ascii?Q?1FDKyGm0pyvADtCi8rRQn3bdwpM8y624GTnoQYT5qVSXT9/KXJR9jEAVY4Ua?=
 =?us-ascii?Q?kHPYeQ7YNJdRWmebZLHp9F9kHIu45RENXNp09bH8yzu4Lv4MdkFaL+8pzD8N?=
 =?us-ascii?Q?WMZvVbp3U68l0pcd2BvCTkQvMA2ycAX3tPuu1F2AAkP8ZAb63rjgIWfSRbTx?=
 =?us-ascii?Q?4fJW6LSwax27Tou2qOBODEo79jWRYsEx/v/JnaYgouyAswoSu77qGq68d3P9?=
 =?us-ascii?Q?+OI2Pw2vFFx2M4uBa9O8pseEZqOAYRn7RhlqgMp+G2r4NaFvdc2UuFkGr+/h?=
 =?us-ascii?Q?Dw0k2qrQZx7qYah2IZ7I6mFsScwPAAYqTSSvPgxt0/HJUlmFmJ8m3Xz3T/9U?=
 =?us-ascii?Q?dI51+lnKeLGc7Qsuhg/t7LWn1FG1Wm4JAHuBGwrDQMUabG5F2ZuufkEts6lq?=
 =?us-ascii?Q?Z07p0eXZtvJM5S6AL5BT13LshCkxtdZAAHLse9jklRPWRce1wucpB4ZGSL0E?=
 =?us-ascii?Q?p+8VibGkL+QZnHUPHN2C3dH6xG0U4P1rbZ1w/eTWK6DDi5CSIjr3zdj6+Oz5?=
 =?us-ascii?Q?dW3h977tQnIH8Pv1hSBXtuw5lMRkL1sM64V/rHNKtXjW+HTaIuwQ+Awwjaqk?=
 =?us-ascii?Q?yU1aZt0IaHFnz0wnv9S0t3Jx/Z9DTW4GKjpu9YafRTeSiYVH6SUyT7dgNGsR?=
 =?us-ascii?Q?PiZIlak2+4qaGG/4PZrOxAPoyJ40muxlZSV+ynSm9sTxRqql1r3iMwcQkjzN?=
 =?us-ascii?Q?K3pWde1NOVVlp9itIQ/8TjZK7LZBquX0aX5dIjaN8gUjv7XiX/mYaIgHbhze?=
 =?us-ascii?Q?cPLr/Y2RYHogZP015EY64s5rojiwzalsQg7jNXfdNfglObEEj4If7kMzfhe5?=
 =?us-ascii?Q?9lJ0PMR+oy/E6K8cFx2x8AXAYkk2RpoQLmmSKsEmp2Njzt04dVqN/l8Vgmt8?=
 =?us-ascii?Q?Nt/80VAYon5jbyqOu0koqScvkqCdoa7UEq+brxQlNxR6ToXsuD935XnvYwm7?=
 =?us-ascii?Q?pGWagCVvIm8QfUrlxByF8batDvq+F3s9wJ+UjGv4Tzq0h5xUH95lnPEIUtYc?=
 =?us-ascii?Q?wZqIUzJ0lKMOu/+zA+t6SWQEb7CHH7licjYf8avrzlUwt/1Zl5wRHPSjdDf1?=
 =?us-ascii?Q?6YbXvRLC/jLTyrkWwlLAXgxosg0JqBn2qxTrIx5GCrp6vYvPlbu+KBUXHNSZ?=
 =?us-ascii?Q?4Iv4VH0+fbZwfd0geqBkrornO4cEK9Ix7vkQ0PNiS4OCmS5SVO/kkjfrv59X?=
 =?us-ascii?Q?gu+0DNivRzB6ViidS8BVv5WsL5d1lw0wnGfvOG5EcnxYwrm7G8EB0dEVN5Ex?=
 =?us-ascii?Q?c7obzFuqKY190H388lOT6kNliiQkCEcA4TO5rofgDaeiQsfWO5CkcCnJS4HK?=
 =?us-ascii?Q?IU8Q9u7SSzu60S0QEnwOYwTpRIXiB+L4HvLvxN6Z1euSvzQ4FOJ1zK77k5T3?=
 =?us-ascii?Q?s031eeQjbNmRxytq1ZZQhsFEouaMpVMUQTLsEJQcLFQIEPYKJn+CBPxnuW+7?=
 =?us-ascii?Q?1KrJ1/sb0k9ibGojVipbfvwNymMxBlbV77EuGIk/kZDZ30K6ucOBqq35Sko4?=
 =?us-ascii?Q?MBBx68hlaFTpxD+Apt0nIXs+BgCEnKV7OT8I/NJmhEzdYwFszVnKEdOFeSB3?=
 =?us-ascii?Q?AdUN9T7hlqm8+LaC72+h5Fd6oEh/QTQ2/mCW01SVQHZMVUONRh+RpUYVE/44?=
 =?us-ascii?Q?ewiIWA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sqwMXLEqIVZJP/yHGjKEk3+iE0sWpUeKyhkckKibKcYY/+13iivewZVyhoK3muAq53d23ijKutH8dvJmVBzkVeF3rasAg8Jyp3uz7LngPgRC8ODi9PTyO3DTpDVueh34I7H7/Yj+/ghGeXRAo0LaKvw1JEVpcVyHpLd2TCxPv5N6yO9QRj3srWDbfKjNzu5p9YEz9KQBXflMbOSgQ2rJOCemMC95dmnAIYiv+adQBeEbqqvnqvhw0Z8+cKbrmqgTQayzMRLrnWLrteqAR54W5NWQXbYUfmM/z6uo4W3JIhOwPkEs1cNqCUIUv7PQyESg9lzRZObIU2D4moXrRWsWF5j3rRuq2XPF+3iwqCGa+FtFQE9/3RRcumkCrgJLM0B/6PDyt5hQ/0WoCTkPbP03AwzSNvJuGiyTqlJA2LWtopWBqGE50VlOyHP+Hn/XjchWpqZQ29rETOJIIsgYmq2VAk37K0VFOxl6ujYKIbb8pgoaWlBFOYZ0ZK5lRmCcMOEKmAqhpm51JugBX19rAgVcrGBku6EHgBriG5N3Zn7YVTCfi2w9Oj7OdDdQtSUL6jJRL4cz6OZRsTCl+yWMeHJhlnFIXbo4goqtIhLaMNaEyxY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3cd8b23-ad0d-4d84-608c-08dd1f98ac05
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 19:17:53.9844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x2ImPU2sDZbNLThusyqr6U0vBqBzyFMUisGOnS/y8UAjID2n9AwLjrf2XGnsFpNH33a0eL6VfGthib549/MXD4A8jphO154RNyAZJd9GhDY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7673
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_06,2024-12-18_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412180149
X-Proofpoint-GUID: 1BGLA1VdAdgQXJyF3DWt_UhmWnX00JvR
X-Proofpoint-ORIG-GUID: 1BGLA1VdAdgQXJyF3DWt_UhmWnX00JvR

From: "Darrick J. Wong" <djwong@kernel.org>

commit 6b35cc8d9239569700cc7cc737c8ed40b8b9cfdb upstream.

Use XFS_BUF_DADDR_NULL (instead of a magic sentinel value) to mean "this
field is null" like the rest of xfs.

Cc: wozizhi@huawei.com
Fixes: e89c041338ed6 ("xfs: implement the GETFSMAP ioctl")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 85953dbd4283..7754d51e1c27 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -252,7 +252,7 @@ xfs_getfsmap_rec_before_start(
 	const struct xfs_rmap_irec	*rec,
 	xfs_daddr_t			rec_daddr)
 {
-	if (info->low_daddr != -1ULL)
+	if (info->low_daddr != XFS_BUF_DADDR_NULL)
 		return rec_daddr < info->low_daddr;
 	if (info->low.rm_blockcount)
 		return xfs_rmap_compare(rec, &info->low) < 0;
@@ -986,7 +986,7 @@ xfs_getfsmap(
 		info.dev = handlers[i].dev;
 		info.last = false;
 		info.pag = NULL;
-		info.low_daddr = -1ULL;
+		info.low_daddr = XFS_BUF_DADDR_NULL;
 		info.low.rm_blockcount = 0;
 		error = handlers[i].fn(tp, dkeys, &info);
 		if (error)
-- 
2.39.3

