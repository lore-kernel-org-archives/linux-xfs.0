Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74EFC3E7654;
	Tue, 13 Oct 2026 08:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879281; cv=fail; b=XPBtv0pBwELPAspWPVy4DWFNYTYGo3mtlQaxcWToRMME3j85QbRrnpj9PXbmmG41Im0/qLyBLmXiM/l6gNkSRxj3zS43UCKkVB/YWBnIkpWMFB9gUL3Q2NJzZYUB69PSN84n5LU1cFlE/DFUKEDmwI8JVROmhhrWgY4dSbPo3wE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879281; c=relaxed/simple;
	bh=QRJ8/9FbWuhsvWbfsvGvpyXyOvNCBcYyRicHhfNV1SM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=S46auWvL6DOC/qCRJ8rYZaI6LvM/rVgA9emHJZfU1EAsy9ykNfK6rJ6uzhL9P+z+mZLNy6Etzgm6w2hayLeGsvurYlDhDpFAwwb9QkWmHQgVrbZRjJbsokhA5zW3ipt/h9IeYMwhZ+xtB78N8LvcykDINbsXn5pN4UXIOAmMX4E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cyf+qjfK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zmy/dsZd; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cyf+qjfK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zmy/dsZd"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2Ck8k3113419;
	Tue, 13 Oct 2026 08:14:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=QL0CJZx36k7joUG1MvtFaeaEaisZwFkm8LbEszvtdA8=; b=
	cyf+qjfKKRYeQUCEI1dkOisyuxVxXXCRMrvI8u8XHfqPmegau207RJLRb95eizGG
	IFPUxjLVAxU5eA1lWFktOxOeOnMfbtv+UjVhxDZjF3IOLMyPZ6Ji2CS3w9XVUjUx
	ZSfz+qhLY2tROnvvDWzX+2VnNx1a9+YYyJJaZDPoA5+WYOy1VZGOlilSMd3unoBY
	byHN/uow3O2OaHdTYAZ20EMyd88DRV+v0r7SzjPI36kjrPaKSF8Zrdj6c+dwu8gC
	5FK6MyTNFQTnZiZ+qRisrkUc6yvKYdiC2PdHMktT9YUzO12QBv18VyJUws1sS0l+
	EkuNZILQ2OfdU2TG+kC9UA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7ddgkmj3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:14:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86jYf034814;
	Tue, 13 Oct 2026 08:14:34 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013018.outbound.protection.outlook.com [40.93.201.18])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btp7c9d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:14:34 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x1bD5m+Bt3lc/QqYebemJe0I7Ph/EO0iezaKksEDs1jmmDvdKRZCE1s9Eju3k4uJ21h3AJc3t8t+crZzH97HDWWY+KRV/71vyOc1hhUpylhsvtG2KhsM4GKDcl5jCHJTY/gYCYNMrY8nWgf7rViayAThYVYCbFT9Pv6jU3vdLbcHW3dbYRj5DdZyof+GJH6PDYRxdlm4FaFlGYBei+qzphWip0AkDSTxG0EUexven+xo7P02WD6u44m0gDTDQTcwwvt/DxuZeDW0bC6TT934KS0yM3WC5aftfBSk73diWAXzauFv0Sdbe22rkUtmGxdtGVtpgYnpDmYjhWJ+cQidaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QL0CJZx36k7joUG1MvtFaeaEaisZwFkm8LbEszvtdA8=;
 b=IMCPF7fA9Z0N1PIIZxpWo202WtAlU/cvaA2fvuNS0onf4kSiruUoL/S3kQvSYQuXNQqUYqd6GBcwoksn5qPJu+oAEjvfQOCAVZzYD2RSzLB34dQ4lxqT/JxMqsc12AiUtkrvb/1X6Co0UM3ipuY/V215tNEGl1FHozclw5BHNjSIkBLMrcgdoPqTanHCBKN8WKQdCNApmGua3+tPDkxUKiQPB6inYGQrOxpsZtBYdQwgUJbCKQFX6jc5ipY3iP/PZdP3/D6+T4cO53WdAwUw3WJgMGKocPf/DDd0ypbRmHDyXM1muNd0T7OMcN33xMmmuyheMVoYzAZKp1pCtPCVkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QL0CJZx36k7joUG1MvtFaeaEaisZwFkm8LbEszvtdA8=;
 b=zmy/dsZdEp7awNcXT71BV9xnrUguyZ7h57eUSpfXh2SFyp3UFSgHnba7mY46YexY82DuTRfGtVLYoU6BGplEr/rC1FvLctm+JGH/+WteFMbiBj5Hc/Elbr7nSzoeHSx3hTTwvG7es/BG/b1yqqs+HyihvDqIe19PFrPA/TOjFls=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DM6PR10MB4138.namprd10.prod.outlook.com (2603:10b6:5:218::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.12; Tue, 13 Oct 2026 08:14:31 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:14:31 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 v2 2/9] xfs: aborting inodes on shutdown may need buffer lock
Date: Tue, 13 Oct 2026 13:44:10 +0530
Message-ID: <7e7b833ff0157f3ac29b0de8e96d84dfc9638334.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877866.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877866.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0015.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::21) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DM6PR10MB4138:EE_
X-MS-Office365-Filtering-Correlation-Id: d0110a44-1569-43c8-c477-08df290201c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|10070799003|1800799024|366016|5023799004|56012099006|4143699003|261009223027099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	VhK+t0Sx0q3GO7r+9JvSJy+Xf9OVJI2AJ4GgiHtJD2Z3rUnOnZ2cqwnkdr0/qcsyBtSs4ifqApn7HhCwhGlc2do7sx12y+1CENc0G+74i75zc90YhQwNVoGDGjrUs5FnFw91OesmvXDC6I1UJDArVC1EWGZocpW4KfDGmFc8KG9JeNglEn0JcVGGDq55u6t7S1iMB5Xg8dKOcfsYeRslgFoN2nEs+jYK9jZ76MIcMeH72VDk+6SU0nlCGouxGBglbrHxt+Lq6YjsfJIECGVk9wZ3CNvCdvSPJ5ESRZ6OgecIWFPUKtuSw2XOJa+tIGZMgYx0I8ZAwm30PMRCh78GwafxETHcjJHeWownVRfX9YZIeNt62bEacy7Z+d6lHcameHQLPO5RcSnQC7YMzfZGntG5AXXzumFifT+cMjYat37jqsEraB8Hgs8TriehM8BTBZmQ+0k217NxRZi2qxVNeL1HOJ0XayCMd4mr5X4KORPOAxsl75sQlgJ/9ZMsFxhgntCAi1o8Z5DcvbygivFW5kaDDRDpbo0HVFo/LJk4voMFfufMU+uxiOyLD6L0XF4snuGJLzJ40vYPcAR+7TknEYV/b7zQ1Z+Nfa9KsGJqplUysqIbaK9Q+S80IJ1tp09yYKiXiMa9mp7mCXblN53JnX5FN1CVaqIO28/Aa4XsFNs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(10070799003)(1800799024)(366016)(5023799004)(56012099006)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1reNAlfZ9vL8dK3feaA84hZJI4f3KnzIHWMapMwirFf5GALZmScGbaIWAqjg?=
 =?us-ascii?Q?QSkKLeR2k6acBEkFdIYpG9IkzuRY5xMnMJR2gyHtGdNcyi48GY5C8w91rJ0y?=
 =?us-ascii?Q?zowm/vl4Gt9DNf1Qan189q5k/aPsIrGEfrTCnhammUsn/gFsvngDsEateqLW?=
 =?us-ascii?Q?QYcl2n09d3VyCbzpcTWYxan6TIpzzyOj28/jZvlZ5nF5VLjMvOvgq5dLU31n?=
 =?us-ascii?Q?vpR3XMS8PdP7FmCHpXGfQ+v7TpkNCCOYcYEIcfWg9qJMoOTcBzvwVO5YFSuO?=
 =?us-ascii?Q?3APD+OCb69njt73SeMiqlcUoSipTyWVm97DcMrZNlRAoJfC09l5PuoDgrU+j?=
 =?us-ascii?Q?cbRX/SFgVe2RtlFzBFNhO6Bf026zcqPYhI41q8OOfb1BzYpqLAslH1cD45ZW?=
 =?us-ascii?Q?ZFNk9a/hQ3i7jE7pWx+U4GUv+JU1HqyD9gnTwCCgRoU91NazogU58mCOKrub?=
 =?us-ascii?Q?3Sgt/GwZ/nnpN2AnoNa8e1wpmlYxRKVJjV+k1GZISDXgBVfpyQBKUYpXJQhO?=
 =?us-ascii?Q?0ywo15I7C1XxRxU31G9axO3vZmbGBqaZKEI3tc+MextioYFANyvqhOCDYIke?=
 =?us-ascii?Q?a4wA7nEl9VSkPuDjy/ZH9/643VpzvFhE61smshu8Omf3px4oZZdkmRf034pl?=
 =?us-ascii?Q?T6Ia5qjTWMmV+6K/XxkrtUv4j5E4Qpa75LRLjI40EUpRKMeXu8065PgRr+Mv?=
 =?us-ascii?Q?9iMmanK8ePfOOdWRr4YNUSQRbxem+govFKm41SoXF7v//498ydkCOUPe1ijh?=
 =?us-ascii?Q?nAtcbBGHUm+nTgYEBCdz+xR6UCVsFTJ7O+ZEMQNjxYASJ8bomu0PBnxb6/rp?=
 =?us-ascii?Q?M/Y4PK3sdStciMQWMSWshCamV8qKKJkT99//h3fZEW/oHx70jw2ANQ0CBe+U?=
 =?us-ascii?Q?e67rVqMF8DCeBHi2BoaNpxTIUjyoxhuwjyvK4nfQUnBdiegJMxDQfcSPBKAA?=
 =?us-ascii?Q?H2Gp9+psz/7Q9m+6gDQJlAITkwdbuZ8HhdsTiopnHaVSNofhWmunR4AiEPVW?=
 =?us-ascii?Q?3775JTTrVCzvAVm26XyG0x9MYIl7QZSDb4yJgIsinmISaQaWMY/tduxTT1ej?=
 =?us-ascii?Q?DsCjqP4vqcX3LlnoPdObHph9zMSV5dIWF5GyARzAN5p67i+NSexR6TcQ7ZBT?=
 =?us-ascii?Q?Sx5qM209zbVrjQE5hVDb1a7MoGN0n9RmT5lKPNYnAnaRLQnq9jhwwe5mLIW0?=
 =?us-ascii?Q?KAv3/cI3Kw6Y1Mqt5DHTgqWICANiaYiCaHYTZfJTvqCTp11aCpR3mZ2NVRti?=
 =?us-ascii?Q?cnTo93fOdk4Dv6ooa79PW8VhOu02sS9Cw4ArUZ2tLo1QPLQB+RMoHLB9OxrP?=
 =?us-ascii?Q?VAZfM6s8QzBQZ4QsWRAdOxfUAwFiXxN26NPLJg1ipW9K7n5NhRZRd+ubPNSM?=
 =?us-ascii?Q?jXzvb9lC2yUHGq05MIXSsc+ei6tFNR3arhCjm6Qs+b0FCgR+JXTxZSTU0lzg?=
 =?us-ascii?Q?SwKR0IDUdwxgV4CanIdxfbRyg+8i0uWA0TdkYc0v/YEx4uo0NRHzXQ8daAsh?=
 =?us-ascii?Q?AdibdnmpOF04NNSm7IU14Ks05zZlpfHC3weU0xlz7TX7Ek3M17C8nIsHmG/8?=
 =?us-ascii?Q?5N225LantnTblILP7ZNN6s8gpbVp+bpBpF1aQBfF1Rd1motCbVTwN6LkAsic?=
 =?us-ascii?Q?bydRrf0c6R/XsG48s7dPA/IU4zD9qZ3a/4BWGN/PNWxGgr0YZ7Vx5owzN+rw?=
 =?us-ascii?Q?eT7xHGE/e31/OZ3SpviIwtOumoRzEqf0jhYl/1ejSyxDQ6Py6EiskBW2X4Oa?=
 =?us-ascii?Q?n4XmKzdq4wvhbQUVzVdJGqtrbHs+bL+9sebWp2ndhT7a1XyEqUtTv9UHzMVA?=
X-MS-Exchange-AntiSpam-MessageData-1: DJZVEp/PbCdlv90hujjd9Crhx+ZUJ/VevTQ=
X-Exchange-RoutingPolicyChecked:
	SZGh1u9KB5vQvwZmG6Rxd1RPS+puYRv4Ti4rFr52ZKctZdFpwvpxDhK/vfi5n6cQnOOlEcAJLM4ijm6I2fKTkqsHotbpan2dCUtEiR27q8DwmWo4KcXGzZxC3jMhnwqbTMcfKaHV3AJOV4BXMh6Y5VtJaOiXCzksBxmIiWErI2fTnOjAnyz1rM060SGYFlFuAFcsd4alPa/8svaJp0xwGecSQ8B0ZbDqmWP9jOHPY2usu53IwhgP/h7vAlpLnSGbFmHGPWbWEsCaeRX9PaGDSiD7Z8RUuKGE0MfH/d2s5o78K19txK3tHaYgKzVyQ5X/amCdL37+k0qrXmsPv0ZyoA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wOP27AJ6yS1+PhkQTlYurBMXI/wB34XXNQEvID2KE0QUN6jIxcU93VFrCRwNZ1fMjurYZKZAxw+fKLJAtJtlPXJg/Wf3wVFVkln6LL8UccrXgHH3sS192QmtNkjU1BElI3XyGNz8dGPco9r93fpPW5uc8/MTbk1nYJ83/6RwEZ/76mMfRN7/7aMHmbFff8+5+vOG44nTN8mXFHkUUBsvK5aIhv+dzlHE87IAvH0aMVdcUfOru5ZNijIPuM29K+++R/2R+aOEO5mGlIcN+CSkOfVCovugFCG9UpMQ0yrraF9MgEwdt8/Lw2DVotqNizKwHRNWHEiYYp/LrmjncElQ8Oep8G9vzOf+XLsCE1ap28JUZnyUIKIO1Yp5wuX+WSBgETmCG5DPDhI1GQtV3JHlLUzOdunoHIHsKfis18nDwCmjtrLaszphcclijc6CmmcIiJ8SOHh9I29jSZZ20j1kttimD7tVVS4GdNvZg6myDDsVDfZrKULIdMsvNwTevNoTZQcW7Ki3cW8lxIl97yRHOFEF/rrKwOEbg8F1x0wO9DeD1JkNACQoGcGYnTwpjoqSC80e8N358+yS+BR2JbPk5F5QUec6RewGC6pZKKprxjI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0110a44-1569-43c8-c477-08df290201c5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:14:30.9638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zhtd+qfmDb+49RCul1LhEcLBqmmd1cZJfheGZoioOW0Jz+DDqxRJuJDnACkDexohI5szcfHOsgmt1l+3rV4IbakLgFCdF1h/39TIzpnLgc8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4138
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=EeZd0/mC c=1 sm=1 tr=0 ts=6acde86b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=45b4cX4q9fnkLCOmiR8A:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12107
X-Proofpoint-ORIG-GUID: peyuY7UO1GvM456BfzPu9srs8SGbQhmy
X-Proofpoint-GUID: peyuY7UO1GvM456BfzPu9srs8SGbQhmy
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX2K8I39IAzmax
 sTB87D72QyWIeZEm4RyCCX8ziclv/xxtkbI21wwBwa+noxI5gLTWuwAzFLEijOWyKu5Qtt7zL5o
 PQDddfPLd/MmphhFJcF/sjK4u0VaWcAX19X0WzsX413XI9U8c84E
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfXw9uv5HlY4mum
 I40BCpeXY/+mix0TX0cSN+tdogSUwo18s53I8ZxJzYj2Fsvt8ETX+aDIaHng3tlg99zalHoxQAA
 +avJSC6xpV46YO9NOW7HxpdaGihwNoPaylMkd0RdoUw/jQJImkht1gc6eWJPYgZhYkL/YrQ9R2K
 I1ewDUXeCAMROHXYenRfnrcV7S0MFd3kjnXp3Y9u8p9rDZhiMSES060CRzO2lY9ZspHMKxFsnRj
 NNMgYYJ6cOdEWYEX+ntuVsh3m4udHdWWxzD3CQScucHztdIg9vi0SmjF734YLvgcPLeAR2iR+qV
 HjRJr4ZOIqZ1OuSuchrCkJBO1fwSZgLpywCFIq95jFDk2GhCxOdUH7+gQZcYShqD5mDgwLP0RkC
 29ZoCjmVUrGBo1lTuh2940mH1Qu1GExV4DGPBS4Z9OObXODOvrCykQVXa73KWUepfJE96WjHfwY
 TlaynSSJHYwaMjQ37hXlh891RZs0blru5OJoQSLs=

From: Dave Chinner <dchinner@redhat.com>

Most buffer io list operations are run with the bp->b_lock held, but
xfs_iflush_abort() can be called without the buffer lock being held
resulting in inodes being removed from the buffer list while other
list operations are occurring. This causes problems with corrupted
bp->b_io_list inode lists during filesystem shutdown, leading to
traversals that never end, double removals from the AIL, etc.

Fix this by passing the buffer to xfs_iflush_abort() if we have
it locked. If the inode is attached to the buffer, we're going to
have to remove it from the buffer list and we'd have to get the
buffer off the inode log item to do that anyway.

If we don't have a buffer passed in (e.g. from xfs_reclaim_inode())
then we can determine if the inode has a log item and if it is
attached to a buffer before we do anything else. If it does have an
attached buffer, we can lock it safely (because the inode has a
reference to it) and then perform the inode abort.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
(cherry picked from commit d2d7c0473586d2f22e85d615275f34cf19f94447)
Stable-dep-of: 09234a632be4 ("xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock")
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_icache.c     |   2 +-
 fs/xfs/xfs_inode.c      |   2 +-
 fs/xfs/xfs_inode_item.c | 164 ++++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_inode_item.h |   1 +
 4 files changed, 137 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 8d5458b463e3..51fb70bce819 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -898,7 +898,7 @@ xfs_reclaim_inode(
 
 	if (xfs_is_shutdown(ip->i_mount)) {
 		xfs_iunpin_wait(ip);
-		xfs_iflush_abort(ip);
+		xfs_iflush_shutdown_abort(ip);
 		goto reclaim;
 	}
 	if (xfs_ipincount(ip))
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 98955cd0de40..13a113ed666f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3648,7 +3648,7 @@ xfs_iflush_cluster(
 
 	/*
 	 * We must use the safe variant here as on shutdown xfs_iflush_abort()
-	 * can remove itself from the list.
+	 * will remove itself from the list.
 	 */
 	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
 		iip = (struct xfs_inode_log_item *)lip;
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index cda71e0c70f6..1e9980a5f80e 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -544,10 +544,17 @@ xfs_inode_item_push(
 	uint			rval = XFS_ITEM_SUCCESS;
 	int			error;
 
-	ASSERT(iip->ili_item.li_buf);
+	if (!bp || (ip->i_flags & XFS_ISTALE)) {
+		/*
+		 * Inode item/buffer is being being aborted due to cluster
+		 * buffer deletion. Trigger a log force to have that operation
+		 * completed and items removed from the AIL before the next push
+		 * attempt.
+		 */
+		return XFS_ITEM_PINNED;
+	}
 
-	if (xfs_ipincount(ip) > 0 || xfs_buf_ispinned(bp) ||
-	    (ip->i_flags & XFS_ISTALE))
+	if (xfs_ipincount(ip) > 0 || xfs_buf_ispinned(bp))
 		return XFS_ITEM_PINNED;
 
 	if (xfs_iflags_test(ip, XFS_IFLUSHING))
@@ -827,46 +834,143 @@ xfs_buf_inode_io_fail(
 }
 
 /*
- * This is the inode flushing abort routine.  It is called when
- * the filesystem is shutting down to clean up the inode state.  It is
- * responsible for removing the inode item from the AIL if it has not been
- * re-logged and clearing the inode's flush state.
+ * Clear the inode logging fields so no more flushes are attempted.  If we are
+ * on a buffer list, it is now safe to remove it because the buffer is
+ * guaranteed to be locked. The caller will drop the reference to the buffer
+ * the log item held.
+ */
+static void
+xfs_iflush_abort_clean(
+	struct xfs_inode_log_item *iip)
+{
+	iip->ili_last_fields = 0;
+	iip->ili_fields = 0;
+	iip->ili_fsync_fields = 0;
+	iip->ili_flush_lsn = 0;
+	iip->ili_item.li_buf = NULL;
+	list_del_init(&iip->ili_item.li_bio_list);
+}
+
+/*
+ * Abort flushing the inode from a context holding the cluster buffer locked.
+ *
+ * This is the normal runtime method of aborting writeback of an inode that is
+ * attached to a cluster buffer. It occurs when the inode and the backing
+ * cluster buffer have been freed (i.e. inode is XFS_ISTALE), or when cluster
+ * flushing or buffer IO completion encounters a log shutdown situation.
+ *
+ * If we need to abort inode writeback and we don't already hold the buffer
+ * locked, call xfs_iflush_shutdown_abort() instead as this should only ever be
+ * necessary in a shutdown situation.
  */
 void
 xfs_iflush_abort(
 	struct xfs_inode	*ip)
 {
 	struct xfs_inode_log_item *iip = ip->i_itemp;
-	struct xfs_buf		*bp = NULL;
+	struct xfs_buf		*bp;
 
-	if (iip) {
-		/*
-		 * Clear the failed bit before removing the item from the AIL so
-		 * xfs_trans_ail_delete() doesn't try to clear and release the
-		 * buffer attached to the log item before we are done with it.
-		 */
-		clear_bit(XFS_LI_FAILED, &iip->ili_item.li_flags);
-		xfs_trans_ail_delete(&iip->ili_item, 0);
-
-		/*
-		 * Clear the inode logging fields so no more flushes are
-		 * attempted.
-		 */
-		spin_lock(&iip->ili_lock);
-		iip->ili_last_fields = 0;
-		iip->ili_fields = 0;
-		iip->ili_fsync_fields = 0;
-		iip->ili_flush_lsn = 0;
-		bp = iip->ili_item.li_buf;
-		iip->ili_item.li_buf = NULL;
-		list_del_init(&iip->ili_item.li_bio_list);
-		spin_unlock(&iip->ili_lock);
+	if (!iip) {
+		/* clean inode, nothing to do */
+		xfs_iflags_clear(ip, XFS_IFLUSHING);
+		return;
 	}
+
+	/*
+	 * Remove the inode item from the AIL before we clear its internal
+	 * state. Whilst the inode is in the AIL, it should have a valid buffer
+	 * pointer for push operations to access - it is only safe to remove the
+	 * inode from the buffer once it has been removed from the AIL.
+	 *
+	 * We also clear the failed bit before removing the item from the AIL
+	 * as xfs_trans_ail_delete()->xfs_clear_li_failed() will release buffer
+	 * references the inode item owns and needs to hold until we've fully
+	 * aborted the inode log item and detached it from the buffer.
+	 */
+	clear_bit(XFS_LI_FAILED, &iip->ili_item.li_flags);
+	xfs_trans_ail_delete(&iip->ili_item, 0);
+
+	/*
+	 * Grab the inode buffer so can we release the reference the inode log
+	 * item holds on it.
+	 */
+	spin_lock(&iip->ili_lock);
+	bp = iip->ili_item.li_buf;
+	xfs_iflush_abort_clean(iip);
+	spin_unlock(&iip->ili_lock);
+
 	xfs_iflags_clear(ip, XFS_IFLUSHING);
 	if (bp)
 		xfs_buf_rele(bp);
 }
 
+/*
+ * Abort an inode flush in the case of a shutdown filesystem. This can be called
+ * from anywhere with just an inode reference and does not require holding the
+ * inode cluster buffer locked. If the inode is attached to a cluster buffer,
+ * it will grab and lock it safely, then abort the inode flush.
+ */
+void
+xfs_iflush_shutdown_abort(
+	struct xfs_inode	*ip)
+{
+	struct xfs_inode_log_item *iip = ip->i_itemp;
+	struct xfs_buf		*bp;
+
+	if (!iip) {
+		/* clean inode, nothing to do */
+		xfs_iflags_clear(ip, XFS_IFLUSHING);
+		return;
+	}
+
+	spin_lock(&iip->ili_lock);
+	bp = iip->ili_item.li_buf;
+	if (!bp) {
+		spin_unlock(&iip->ili_lock);
+		xfs_iflush_abort(ip);
+		return;
+	}
+
+	/*
+	 * We have to take a reference to the buffer so that it doesn't get
+	 * freed when we drop the ili_lock and then wait to lock the buffer.
+	 * We'll clean up the extra reference after we pick up the ili_lock
+	 * again.
+	 */
+	xfs_buf_hold(bp);
+	spin_unlock(&iip->ili_lock);
+	xfs_buf_lock(bp);
+
+	spin_lock(&iip->ili_lock);
+	if (!iip->ili_item.li_buf) {
+		/*
+		 * Raced with another removal, hold the only reference
+		 * to bp now. Inode should not be in the AIL now, so just clean
+		 * up and return;
+		 */
+		ASSERT(list_empty(&iip->ili_item.li_bio_list));
+		ASSERT(!test_bit(XFS_LI_IN_AIL, &iip->ili_item.li_flags));
+		xfs_iflush_abort_clean(iip);
+		spin_unlock(&iip->ili_lock);
+		xfs_iflags_clear(ip, XFS_IFLUSHING);
+		xfs_buf_relse(bp);
+		return;
+	}
+
+	/*
+	 * Got two references to bp. The first will get dropped by
+	 * xfs_iflush_abort() when the item is removed from the buffer list, but
+	 * we can't drop our reference until _abort() returns because we have to
+	 * unlock the buffer as well. Hence we abort and then unlock and release
+	 * our reference to the buffer.
+	 */
+	ASSERT(iip->ili_item.li_buf == bp);
+	spin_unlock(&iip->ili_lock);
+	xfs_iflush_abort(ip);
+	xfs_buf_relse(bp);
+}
+
+
 /*
  * convert an xfs_inode_log_format struct from the old 32 bit version
  * (which can have different field alignments) to the native 64 bit version
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index 403b45ab9aa2..9c829cf5c839 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -44,6 +44,7 @@ static inline int xfs_inode_clean(struct xfs_inode *ip)
 extern void xfs_inode_item_init(struct xfs_inode *, struct xfs_mount *);
 extern void xfs_inode_item_destroy(struct xfs_inode *);
 extern void xfs_iflush_abort(struct xfs_inode *);
+extern void xfs_iflush_shutdown_abort(struct xfs_inode *);
 extern int xfs_inode_item_format_convert(xfs_log_iovec_t *,
 					 struct xfs_inode_log_format *);
 
-- 
2.53.0

