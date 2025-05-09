Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD46270546
	for <linux-xfs@vger.kernel.org>; Fri,  9 May 2025 08:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746778141; cv=fail; b=mTFvWnH3N2zKoS9KAB/ASONOWrSjXiqZX6GdQzcewLAs/LiUd42mFiDSjea7ynVub8y9nNTNRppbtIjvds7la71TJE5H+CE06buMVvPFsTr9FiuvbaY2U3bLQXsIRQIm9aZ9N3LpzSjg3q1Bhyr9y+bUx/I1t+r4E9Eot9OCJRo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746778141; c=relaxed/simple;
	bh=49e1Y/T5Mer5vZGm2ld2IuKes4DBUd3Qie6n1C7c4w0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZA+kS30cpQicdjEsQM9jiSgAbtg/Et1gpzI1+xGDkkSiVC5zgcUXOLfHzSgproDDKceWobBEBcVfD+NlnWEE658bOYekBO1Sf73Dh8SM/LIXyUeAu4mT/C+IL9jWwiYSsILRM2g1+pEtO8euSfW6e3tlx5s2v+y27xTmUHGnl30=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nyikPcOQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ikXBtr/D; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nyikPcOQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ikXBtr/D"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5497T3cn019971;
	Fri, 9 May 2025 08:08:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=lC8nWpqYTni4+vSbT4SAbwjw+M92/89H3aDWTIIFjTM=; b=
	nyikPcOQvjmuy3mjuGDswwzOSdsj/F2E6OzUh4Xs511PK+Ug3IBdPZKELUkIQFjI
	BPFB5yb/rnisy7aWrrFz+UWtRn10fsKHQa76CWtQoQ+9ADeaCSbeDHdHT0lFS1XL
	NL4wGxLoqaVefbOIzwFL2+J1ocGuSklEafR0Z48Lvq/7EFG6TzPk12qlMpmH0wEY
	0eNi+QekKGToQoqkB+1BA22L8qeaByWlYzvuzcqlHQoAdjCPaH/Sok2XR5gnaEec
	PnD/npmwuBHShOrz5O4FmYLfS7JP3rzFs7OyyLrDddKbIjQ+t5BBtuDFDpHjG5Qg
	nmMQkr0oNAjC2y5zzyyTfg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46hdbs82dy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 09 May 2025 08:08:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5497q0kG025121;
	Fri, 9 May 2025 08:08:52 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46d9kjxspv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 09 May 2025 08:08:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nmrzhexfC4AyTuqHEi86U1/HNH6JVzArE7A14krgTKOokkfdopHBptJH5bjl1O/cgjN++WrmXy2hFRm1paR54rKU0PeaEWrUVB+0tvKq237VfwamzPNV45WgHUrpd/T+5KEJ2hvW0jRDgRYJLvWnrTETFGgkLmYsN3+i8BL9ibUN/m6Xo6O50pdLvPhhZiPk1RiyGlXrA2RtDaUVAw0kBhy1dOt1WWeWd+M20O80mG9lVVa6Mino/QM+3JjyzhTCz6fXy85hl+iLLiAXg5cLaBxWxjgsleSw6jawALlWfmmrWQf24mNWRi9uodibJsJKpXa+t+2WPOzkA6R0wRQsZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lC8nWpqYTni4+vSbT4SAbwjw+M92/89H3aDWTIIFjTM=;
 b=xsyxxMT1klu+uM1ffjnBkT1V27mxjMPkAA6L9USsqktlc2Z5GCeJ0Yvv+LRTy0xu917KJaxtOwrJX8C8/fsN9QwhzVAFABou5Sqnxmb4oHi2L5S5frBlqutv9nTGoJxpPhU1uiVdXg1Az2fbwzzf4US+psgrwu+vk+WBkzqs7Oth9XA5rTN5fs4rej9HI1I4TY8AgIv9P2yvMNoBjCcemt1ClcMTT3uscfEMfs7JviItvBisJNrKDjgniB3frNjHM8c2ra6PaYOQoQH/zb1hdXuEwdR4dyyYwpKc+xfRzHo7HcAWoYj3HOI3ZujQ6HMixkyUjjD5bzFnjWr+JcCBxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lC8nWpqYTni4+vSbT4SAbwjw+M92/89H3aDWTIIFjTM=;
 b=ikXBtr/DARdT1IWMZKgUAvnVKcFfVX7AA0w2O3Sz6o7yKS+AYNTLabFDBsDlqxnIFicU3ODBcIqM1zXZnWe49Z8QXrujfvuEt6tHXwHlj28t7r2XSc6jtFHYh6/R/6bT8evRkD7lUffft7lvGfeUjjt7tM5HCOkp0QyN0uPzT2w=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH2PR10MB4374.namprd10.prod.outlook.com (2603:10b6:610:af::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.23; Fri, 9 May
 2025 08:08:46 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8722.020; Fri, 9 May 2025
 08:08:45 +0000
Message-ID: <641a5af4-bc1a-400e-9e77-e48021788fb2@oracle.com>
Date: Fri, 9 May 2025 09:08:43 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] large atomic writes for xfs
To: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
References: <Na27AkD0pwxtDXufbKHmtlQIDLpo1dVCpyqoca91pszUTNuR1GqASOvLkmMZysL1IsA7vt-xoCFsf50SlGYzGg==@protonmail.internalid>
 <3c385c09-ef36-4ad0-8bb2-c9beeced9cd7@oracle.com>
 <cxcr4rodmdf3m7whanyqp73eflnc5i2s5jbknbdicq7x2vjlz3@m3ya63yenfzm>
 <431a837e-b8e2-4901-96e7-9173ce9e58a3@oracle.com>
 <jJwn3DRa-8XQPRv2vekPbys38m6rn6xH8BkmCT2ytu3xReNcMTq5d5tLb21DygEXpUS0pIVnrzvMBVBbO8Rn3w==@protonmail.internalid>
 <20250507213047.GK25675@frogsfrogsfrogs>
 <ym445g3xokwz24svruqtbqf5k6niqc3vamcidzmm64wm2uuo2c@voumg6yonqad>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <ym445g3xokwz24svruqtbqf5k6niqc3vamcidzmm64wm2uuo2c@voumg6yonqad>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0305.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:391::9) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH2PR10MB4374:EE_
X-MS-Office365-Filtering-Correlation-Id: b079cdc4-c4d8-4ba4-2870-08dd8ed0b871
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K3hpYmc1R05PZ0gwT1NXRmM4RDNBbytKWUlZakR2RWpKeHhYMEFBTitYaTdL?=
 =?utf-8?B?UFEvYzlNdFpyMFBOMnVnVXQ3QXZ6TDlhRFpDcjBSWGdySmxONkJaQ2dBS016?=
 =?utf-8?B?dUEvMjhjejZIRlk1TmlwUXRpaE5wOW8zN21HSlB2UXVNd2piWWhYYXllSU0z?=
 =?utf-8?B?ZmNhMUI0UjEwMU9SWTNkKy9aNzJDL05wTC9ZdGNlbGRIUExLek5ZTjlKZk5K?=
 =?utf-8?B?cEZvTEE3aXMrOGxtSFRlWFJRM21zNVgyK0xOczBwTXBibDJrbHhNZ2g2bk90?=
 =?utf-8?B?bnM5Zm1BMGhxN1AwYU9FSmZFb2xLUjZPblNpbXNYQ2w4L2FrZ21WQ2c3TEsw?=
 =?utf-8?B?R0ZpcHdROGxRdlg3aTFDMDVxK01jNTJ1V2lkWkR1TWlCY2RBMERoZ3RXeWxS?=
 =?utf-8?B?d0tMNmdxUzg0MHBROTIvMGlzQ2lSTk1TU05jc1dsZUd6TkNTRGxudEhvWWVK?=
 =?utf-8?B?UjgrdVROV3JBZTJkTndnc2x1SEZDY1IxeUhUemJFd1JTSnNsRlJ1Qll2d3Zp?=
 =?utf-8?B?ZjA0Tm1mbUgwNThGU1h1YVA5Y05DVjFnTHgzRmlXeUt6amVNbWRvRk0yL3d0?=
 =?utf-8?B?OTlVdzc4aFlFWERJNHY2ZlpyNTRUZE95RTBJNGtIY1JTOG9ydGpWY0t5U3Nt?=
 =?utf-8?B?M2EzdU5EVGZiZ1FvQm1wOTJlOU4yeG5XdFFHbmVqUlNPQVM0WmZLTmg3dld6?=
 =?utf-8?B?NCsxRUlERWI1a2JyclB4QnF3K2tNejB0aS9CUTI2aWo1QkVnbUF1UXV1OEFV?=
 =?utf-8?B?eDQrM0JsSnJOMzZFTThkOGY5cHlPRUVTbGZtN2RKLzMyMlJjaWE2VVRYTCtS?=
 =?utf-8?B?UVFLK1hjVXBJMWg4TGI3NzMxWXh4eFg0SGZVUm4weGNMdmdSc0toRnVwQWJD?=
 =?utf-8?B?QTE1QmJaajNIZFM3SEROM1pndEUxc3hCSnBlejBqNUs3OFJTd0trR1VTNDJU?=
 =?utf-8?B?ZmhCOUw3Vnk4b1pnckFIclpqVkhlaTdjRzEreHdOQWUvcGVTR1BvcUdPVkNH?=
 =?utf-8?B?cmFNNm5ZSGxLQUQxdUwxNXlNdWQ2N3doN0c3NzByb09YZytLRWh6RWZKWHQz?=
 =?utf-8?B?RWJOVzc4R3ZWVHJvS3lnRXpHOXlKVmtwZVhBZlhESXg0eDZPNWkrYnNrVXIy?=
 =?utf-8?B?anJtSTBxbGNlSitIL215WER1T2s0RmZscEY0TUFHRVZVVVFYNXFMSlhneEUw?=
 =?utf-8?B?UkhGaVNIY25zRmNIU0NSdDF1YlRRZ0hrdWxHL1NEV1MzSnNUK3hLZGs5aVdl?=
 =?utf-8?B?djhkU3gwcEJWNHllMjVya1RUWUZmSDVwWTRuT1dsRitUbllVcWI5ekZTNXhZ?=
 =?utf-8?B?YURFRHdGWDYxQk9TbjRiakwxSklGc0tPK2NLMWRxdmFERlE1ZTRTcmorZms2?=
 =?utf-8?B?d0dYL3JJUkZiVHFpQ3J0WWt0ZHoxZ1pvY0RhZTBiTlpiek9sdWt4NjJnTzhy?=
 =?utf-8?B?TW1KT2M2Q1hBSE5vUC9aRDhhWmFjd2N3QjJSbEhidE5vMk1FQnhQZlIwR01p?=
 =?utf-8?B?UmZ6cGk0VmZwYWlpcmpacTc3SzR2bWlpRnUvUFU4OEw3T3hzOXFLZGpwV0Q4?=
 =?utf-8?B?VzlSVEt2UUtuZXorcG9LWE1kTmJqS0ZlRmRVM3RYY0cyeFdBb2x2M1ByM1Ry?=
 =?utf-8?B?RXRJT1RsR2pJOWw5dWdEV1lKcllYWFJycWU1Q2c3aXcrYWFQQWRkY0NXTmdP?=
 =?utf-8?B?cnhvWU9tSDNock9BUVQ1SXBnYWtKaUJDMVliTFhXVEVIQStkMStVRFJRc3V3?=
 =?utf-8?B?UnhxaGludFhBeHFBYlR1MFRULzAxNGJ1bWR0ZlViU3M1VWdBZ1Q2Y05QUEtE?=
 =?utf-8?B?RlRIcmZTYk1SckpieFhPa0hFMThBR0VvY00zMEtqb0hTUjlOaVJGQVJCdmMv?=
 =?utf-8?B?ZG5qNVVuMlNlKzd0aTBLWktIa0o0MUVQM0RURmhwWHhsK203ZzlkeUJQWkFS?=
 =?utf-8?Q?jfhnQuDN9eE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eE1JanVSMTVIY2V1bFB4SU1uMzdVcEJhQVpaYWY5cVJ5dGFnb0NVdDNWSU91?=
 =?utf-8?B?T09FbVpOdURKUG45VnB2OW45dGE2UVROWE5xNUhCSHR2RlZvVjFJWWNyNUJU?=
 =?utf-8?B?b0JodW52TXFBQ2VveTFlMHVFSmxQa2VDeUhxT1JiMjJHUS8rSFBGSkoyc2Q2?=
 =?utf-8?B?NGYwdSs4Zml0MldoNDM1RktOSS8yRmQ1bEZTbzNlN0tEVlU5aFphZFYrZ0FF?=
 =?utf-8?B?WkNEN0hHSGxRNWZRR1oram5BOHR5NWhjVFZMc1NvbU9vOUxRdW9kWkVRUTZ4?=
 =?utf-8?B?cHFoWXdpY1o2NUFyZlhlRHdIaWJFTEVERVVkMHZMYUpXaHlKZEhtL3owQVZ5?=
 =?utf-8?B?WXVPTVhhalJHRUtwazlhYzRPVEFLOG53amRzdU9jRjA3bitXR3dHdHZXYjU4?=
 =?utf-8?B?VWdrd1gwVGdmZzFZK1ptblhQTWRQUHBsOXJtd1hXTVJKR2FUamlTUXRzdVd2?=
 =?utf-8?B?ekdibUJoNGwwamc0V1I0aFdjTlRWYlFscU12V2ROWTZybHVsUnFtd3duclp6?=
 =?utf-8?B?amtjcENVdDRQcC9UN0FmZHVyKzdJUE5IeERtM1B5ZmNZaE9BVVZ5bkZxU2FG?=
 =?utf-8?B?aUtKc3d1UVRwNFQ3ejE2S093NGJja3NqMi9DZG9DaFVVTEhpUEgrUklVSFU1?=
 =?utf-8?B?cWZPblJPL1JnZEhDSHFLQ2VOZUFjUEhQZXQ2eit0Q1RhVUdUYTJWb3JPOUxX?=
 =?utf-8?B?NTBaejFHUy9qMHloSFVkWjY5dGZpSllVMG80OXFKVDk5VkpmdTY3V1o1N0lS?=
 =?utf-8?B?bG9FU0c5c3JnbGxiVXpJQ2l1a1NTUHdNWEJQMmdxcU1RbkpKZTRKUkVNbDJK?=
 =?utf-8?B?QnhiRlREV0tDdDZqU2R2bDB0NGhRNXpaOVFKMU9kcGprbnVLSEROa0ZwaEZx?=
 =?utf-8?B?aXpBbWo5dmFnL0pQRHVaOERUUTVFMWFFdTJzdUNndy9icTRxUnpsUEtId1FT?=
 =?utf-8?B?ZWl5Z2pIK1pzOFVtYXcvTktMcnA4ZnJhQWppMnc2SFFrbVBWOWcxWkttdjFT?=
 =?utf-8?B?cmo0S1Y2M2phdkwyWFlvdzFlUkRnYU0zTjVzS2dYSE5aVjJPZk0wa0FZOHc1?=
 =?utf-8?B?RXcxTmVraVhaSXhrZDY4RmQ3b2p3VjZKTVhpV1l6SzNUV2xIeXY4UXpjMWlN?=
 =?utf-8?B?Z1RTSDV5V1U4NjIyUFpHM0cwOFdhRWdwclk4OVNnTWpiZEg1eTFOOExKMnFh?=
 =?utf-8?B?SG43aHAySlJrRC9XRnFaT3dDS3RCQ01LcjE5U2wvdi93bTR1Yk85ZUxEdjZX?=
 =?utf-8?B?Mk04Tkt5Z3MrbkhWU2FmU3ozaVpoWlh3K3didEZ0VmdLRFI4cFUvWnhFSE4r?=
 =?utf-8?B?RS9hSGs0UUR0WDhEUkVYdnVtZ3FTWUFUOVMvbjZ2Wm5TWitLclFxSUJwbVpX?=
 =?utf-8?B?V214L0dYanZ1TE5NWDN3OG12UWdXRFF6V1MyYko1d1FidjhsYmdid0tCcmVV?=
 =?utf-8?B?OEF3Q2p3TGFyTnl6SWpHTExneGxCditkVlNEMUlOaVErN1J6cG4wekg4QmdL?=
 =?utf-8?B?dDJaZWlad2YwVURFRWlwRW9pUUtSY1MzbjQyQVV1NVRPd0M1dXdzRGdOK2Fx?=
 =?utf-8?B?bnBzVVNjejNYbk9QcXF5ZXFMaEZGTDJrdmxyMDZZOVp3eG9RTnJDRmg2N3Z6?=
 =?utf-8?B?SUI0QUV4Mk9WQUg5aGtocDNnbE1GNGpEVWFTbUQ4azFPMzh0NWRueks0bVFw?=
 =?utf-8?B?Rko3RzhMcTdKNU8yeVNXbnIvT29MVjJQc0R0RXIwODdLbklsN29rcnJuN1lO?=
 =?utf-8?B?SzlRclNSb0c4YlJzS21mYTY5M1pnS21wZHczK0RhVEthcjVUS3dLNjRhcmQ2?=
 =?utf-8?B?VGt5Tkpmd0ZvS3ZMem9haGhXK3dGMlFmNGg3VTkxQWsyR01BNWR2ejdBMzZv?=
 =?utf-8?B?d201Nm80OG96NkpiRFMxaHdnYUo0SlZUb3pwVXo4Y2FYcFJKWGdLMUU5cHJ2?=
 =?utf-8?B?WW4rMXloVU9aam5EODNkTkNMeTdtSlhwRDFzdlI0QXk1VGJ4WEFheWk2eWtq?=
 =?utf-8?B?T2ZTRWZ6NEhrTnlWcnc4aGVsSlZrOGdJaTVjQU1mRDVPaXpQdXpGeVRpVXhW?=
 =?utf-8?B?VUlXL1FpQWtpUkNwMHV1OVcwZ3pyckxTcW9aSUZYdUdpNHkzTHZOMkhJV09B?=
 =?utf-8?B?c1ViTUxVdkI3YW1sY3hpRGlCUVk1YjVxNFhXeGV4N21SWnlTdXEyUlJHQlpQ?=
 =?utf-8?B?NFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	f2Bk0Zr/t3hwLgU8HsDX+bsG4ftc8xEc6RfQ/aFSd9mWrkBIaIyYfqLZPMJ9NH8OFTbSsCvwcGYd9QJlM7GSdQTgLutZIbPIhbPC6WzPd0Gl5M7MgXflGjQlSA0aaw9bVjU8GVAp3nHCdFtajdLILP5q8nlsJPuqitnlaOLgylCT+0ZYeQ7gwjS5lH/YTNYhsORgRwKWx+u3ynXweOL6X7cq6Kk+gClQfsGmDeWHNW0oeouQ1Ws5Mmd1w73bgXfYyP5Nol8HXhGYIzNOi6qQdwfvNsw3bSYZGVu0bOj2Yn5dFdJuMFB/ZxU5lvj2JvBMAwJQQk3xj9iLRZDykH80WPcSlnvJ5K/TRaeBhBQ15A/FbaXIpc9I1uHAc/ohhsASUG94/bFnKo/Wl3f+/l718qFMAc8lKv615zKXUui1T4t6GcRRRq7LKzcTyT75GcLqFz6h7gqBKRq6xzLt8kcPWi8UVtDVaSAwV+DVB2+nRO9U65n2/N1lvhnIG1fK6bYMKrcZgvOBjpCf7tIFePs0HavJqYjHBpRdiycBeBQ/iDk3605dgPGta1WTlHxy88PSYZsGH5Irbe1useKIBdWZFFpTi/6DLqcS6Aqk1etl0xo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b079cdc4-c4d8-4ba4-2870-08dd8ed0b871
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2025 08:08:45.7954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rFixaOeqk8oPWy1G2RFMC59rQeF4nOf2W1lvSyx5Vtrc10Ian9+GvlX3dgQtrSXbZY0SPwqf8uhkkjLydTncLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4374
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-09_03,2025-05-08_04,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2505090078
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA5MDA3OCBTYWx0ZWRfXw3LpJVexbyOd 69Fe7gXWLP+Mcb4xL/Yr8+d4Nq5u+mCkdDeSFyh5/n06Hnh1bKVYwOaJho0GzgUa00eqtnOPYsV mmT+4dYohm9YneTht5+WGUFCLJ0anuy1Zpa3+TkmhTEJXdEOjz+KGN0ViIt/Y8juWUyB+Y6E9Ix
 nkF/93ftU4RwBvLRZQg44LO6C8jr7Ca3klhlKVOOMKm8LOlpLQPGBu30UH5pjCvduAupU/yLhf6 4332uiV/F6mLUmlUgWiQXVSKM0ZILMoC8HI8xJtOU3fY2nr+doRACrEd1NXMEBa2dig1U5B5NRN P9KJ6sHHI4jw6IihlwE9NZJbyfJ0Yf5RVFHxES+58bDANtbRZEMMJ4DTbyyVcl0/0TNg95UFEt6
 DxXlHf6ju092qxcnn2nEeY9rLSL16nWZ3eddKbC2AXNkYr9V2bVYkJbqOhpaiKqJXF+ACB7n
X-Proofpoint-ORIG-GUID: brHokRBAqyua5rGOjL1mx4IQ8C-bGH55
X-Proofpoint-GUID: brHokRBAqyua5rGOjL1mx4IQ8C-bGH55
X-Authority-Analysis: v=2.4 cv=P6I6hjAu c=1 sm=1 tr=0 ts=681db815 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=9bK9LndARacgu9YLc6AA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13185

On 09/05/2025 08:21, Carlos Maiolino wrote:
>> Not sure why John wants me to create a PR, but I'll do that, and with
>> the two RVB tags received since V12 was posted.
> I think it all boils down for what I spoke with John off-list. John would need
> to send a PR from outside kernel.org, and while I don't think this is a big
> deal, he also doesn't have a key signed by anybody on kernel.org. This would
> essentially break the chain-of-trust if I'd go and pull his PR directly from
> his repository with his current key.

I'll get that sorted

> 
> So the possible solutions would be for him to send the final series to the list,
> and/or a PR from you, until we get John's a signed key.

You have since taken the PR from Darrick, right?

Thanks,
John

