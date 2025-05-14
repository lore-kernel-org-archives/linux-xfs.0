Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92422163;
	Wed, 14 May 2025 12:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747227556; cv=fail; b=av8bNSw14cjfVzNtGCcKVWjP+iaOYVSIDL2RAcDu3/c4aaFmx3FRgpiLYzxY9NlnTRmivp6GjrDdVlJ5eKef3AfGhS4DB/NrYE55GxWKMh+3DfUhrGYjd4sFIl761s/KPkxBZx90cUwkjsp0muSutvr5/FJGrJqT6OAo9zTC1Dw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747227556; c=relaxed/simple;
	bh=j7vLvKLMFqIFGms35R+bOAktSVCL5KWw3SX1vbFPHFQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=i+PZVtO6UXLfytoAosNBD8Fub06B8xWhkSR+ISUVwoMhJze97fpxpyJvz9FUn41PDmmGeRjSnmuWD48eNemmm/gg/h9J3XWU32DI3ZRMfWKJIpevMmnZBLLPEX5/QbEn+EIuAd3xqshnQ0pWkqutiGVT6Ld6lNu4N9lO3MTIb9Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=piJLLwGC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=deabGS5P; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="piJLLwGC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="deabGS5P"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54ECYKDk020326;
	Wed, 14 May 2025 12:59:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=lZ4P5x7DGIOlQuTs+3lFnHauFD56tFNQyNlgabSpJ5I=; b=
	piJLLwGCgSa+1cClqrCiYLGQiAW84zZoXNS40X6ovkdGRL45QNJL0/swndzol5VF
	7Sgz/Qi1XAdubki0aITAdMJQbFDqoMbAnNu6PpTamO4YwxEm/gJjTh55Cho762CW
	M++gXh7eWcw2WxCaAR/ElLvJ8OHK6K/BVo3V8nVqCPhyqClVNYn8nHVEPnwvYsCJ
	u8CFn3JzbyQnq95LIT5V+TV9B5cIrmQzst91P7rPjlkf0aYXtTOg5y6W2ziqovpd
	fAAX7f4MRlWo5Ei6EjLDR9s9xbQFT2mrj2QS9ts+n/MEg4cpcQ6u786nhq+euZLu
	0YhOOaHTtGoSgD6gPUuTEw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46mbcdskxr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 12:59:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54EC1PSr016186;
	Wed, 14 May 2025 12:59:10 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2044.outbound.protection.outlook.com [104.47.70.44])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46mc33daf6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 12:59:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PGMyp8+E/u4zI2uYef5mX/7BrZ/e+6ccdKGJKTp5pVdKP9R+jd//uaj0z1yT0s8syUyAtuwWzF1kvDpNVmM1fiKdOPAAZ4S10mOR/whiUwituBDExwUV11keqoPCyI0o5NQu0qz9IIyb3wszw/QLegDMYV8Ht298JLweeGmxjQCkbgUailhmWhshMMT4jHXa9j6Vh+ccOqL1oY0UgXej7y0ceLeJJGRfugdcNlw5rTqJZ9fTnLvpO6Wb3a4KpwwJsQEaitwt6BUtCkoC6W8OdfShPu8L5e5uSKXHYVrJF7AV5XDE9ILGRRnkLJ2n5nONW/3JYHhju/gXZ7eE2iNUXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lZ4P5x7DGIOlQuTs+3lFnHauFD56tFNQyNlgabSpJ5I=;
 b=ZZfORjRm3mnpMiO7wgzNaFtIiZgTqsbj0O8YcOuZV/pa0NzzL2NU+rt5BN5avWlkyhatajts3rHiHdMUb3yQqGBY3+UKhgb/aZLlQJfc97mWS2epylByHTjVfqn0qd3R8o9S2OJ/vO1XkyzWlPuTFgGgFbXQK/98a2TzjgGkBoNDCtapX2CDfQTCcZpH8P2nPdoUrXJWquucoK6FMn22iqw5SWoadahP0V+XBs+H1suHGuznV6KcPNb3fLlicLoM2HCqEqrBmzgj+RM4MlIAf91r58+HLqdUTzvZsU0Lz7N2pfFFIurXAVw6I2HBHaAT8Dx8A10bX4YWRJFsd/jjJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lZ4P5x7DGIOlQuTs+3lFnHauFD56tFNQyNlgabSpJ5I=;
 b=deabGS5Pw6zLu+Zepik2Gqqv0RFjyBO9ABeWb8pccnQBYxNjMXzro0J19GZ891tRjO/saP+lpYQTZw6C8UgfgPZdwqg1xldvdwmGzH/VCVq+MEa/RndDq/I3v9qw812vnvMaCa6OWMKtiKaVH+z5a67XNoOzcY+GOI9odGkEWM8=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB8078.namprd10.prod.outlook.com (2603:10b6:8:1fd::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.21; Wed, 14 May
 2025 12:59:08 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 12:59:06 +0000
Message-ID: <24cb92fd-4fdd-40c4-a979-71ff8ba35bf7@oracle.com>
Date: Wed, 14 May 2025 13:59:02 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] generic/765: adjust various things
To: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Cc: djwong@kernel.org
References: <20250514002915.13794-1-catherine.hoang@oracle.com>
 <20250514002915.13794-3-catherine.hoang@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250514002915.13794-3-catherine.hoang@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0P190CA0024.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::34) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB8078:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a3bdc7b-cd61-4c96-7f19-08dd92e71c1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UFJxd2p5bGtYZjVSZEljS3NsMWg4aWhaSThxTnNEVFJVUXZobXFrcWdFc012?=
 =?utf-8?B?NmVxVzBYMWxkNTlDTGhoYldSTTNYWHNuQlM1UGEvRk1jcUlVTzZoK1k2Tzl4?=
 =?utf-8?B?ako3YnEvMTJSejl3bVJubkdpYW1zZVNIWGVMYXI3RXB2ckFCNytrSUF0Qllm?=
 =?utf-8?B?YVFFMDgxUERGajhmTmc3bENsaTlDWkpNa1RLUHZzeXZUZnQveitSUXJzZmE5?=
 =?utf-8?B?VkpnUDhyaXBvbUcxT1ZZeGVVUFQzZDhMS2RUVWFIM0hSNm1aRzhFNisvblNu?=
 =?utf-8?B?M0xWUGpkZGhJeWpzaUtqeGZwb2pHRnRWOVViYVczblVCNTZTSHRPL2xCNHgw?=
 =?utf-8?B?UmtRYnYzRm9DYzB3Qmh4blFXaHk3eE8wTksvSloyTFIvaHdQbjZNR3VxRXR3?=
 =?utf-8?B?T1Rkc2EzTE9wZlIwTC9SSzhOZDdUVW9WZFBwdDQ2T1gxK0VPL1NPODFTRFYy?=
 =?utf-8?B?UWRWOHdPSXVLLzlxZFZDT21jMU8yS1JIeDhTUndvbWk4SG9oMHNpSGRrQlh2?=
 =?utf-8?B?N3h3NHFOallwWXpxNC9LQXQySVlUNmU5UEFIdDcxU0E0eFIrUklDc3I1Y0U5?=
 =?utf-8?B?d3BVM2huRkd3YmtDa20raFdiYW5ObWtJeWhVMHMrN3FoS2JhbkxxMEF1c1Fr?=
 =?utf-8?B?L1l0SC9hWWc4d0Y0dFduL3RqVFd2MUgvSzRMVmlqalBoUlJsNUkrRlJvTU9O?=
 =?utf-8?B?Sk91cjRXQUloUFpXSys2VmQ3dUJVYVZHOHY0eEN4VFpyTGpTbFdYSWxBbmht?=
 =?utf-8?B?MGZzTExEOTdiSFlFcGwyMmdzc0FhK0Y0QlIvbUJ3YWVDeU5GNi9ubHpyRk9n?=
 =?utf-8?B?TnE0STVCd1oxWStCRnQ5alpXcW8rN1BSYUJIbzRheUNGN2lPVHFCZ29xdGhE?=
 =?utf-8?B?ZEpsbVI4RE1GOFBKcHdSdmpRYTZUanA2Y1VMQlN2cEN2ZGhwZFlqWUhjTy9Y?=
 =?utf-8?B?czdycWV4d0NFM1ZadGI0SmQwUGd4RHlLcjFLKzVya0tTN0RZdHRvQU5BZy8r?=
 =?utf-8?B?aUFMOTJzanJ0VTYwa25ORENVdUJvRjQxYkRsUkRNTkFFaHArU0FZRGNEVldF?=
 =?utf-8?B?NmVSbDN5L215cFRZNXBLSzhNTVZwQVh2R291SlJ4NHZ4Y3c3SThDNksvQkZi?=
 =?utf-8?B?b0w1U1g2MWVSWlp6RDBab2d2WTdkV1VmL3Q2b25rdjJ2bVdvRFMvTlFUd0Fn?=
 =?utf-8?B?akxTV2dZeWZUMGppc2tnZHlpNUsyZWoxT3kwSmMzdUJYZUk4SHVGT2I4Umxq?=
 =?utf-8?B?OFloajEvRGZHbVJUb1IrUFhUWlp2cUFqKzR6T1dTZmU3Wnk3RFgzNTg5VU9R?=
 =?utf-8?B?eWtWa2RZa25nQURlTFl3cDV6Yksrc3JRQkZQRXo3R2dwSHo4YlVBVU1Rb1VQ?=
 =?utf-8?B?d1pHVlhqdUJmWUYzTFJIWGlHVUtKSFpJMmRmTktRdFlLMk9BQ0FVSFR6cDdl?=
 =?utf-8?B?aEJiRUhBMnJqMCsySGcwRFZaTEE4N0FLYnFtV09KaTIzeUF1VXQzSTJSblZl?=
 =?utf-8?B?UUs2cExiRkhiRkJnVWY4aVBidVBmYnVEeWVJMWM3R0tzZ3JrOFhQMmdTb05y?=
 =?utf-8?B?V0ZNMlozN3VSVldKQmtGRk9XdXE2a3lIRi91eFB5UDdNMktQMnBSYy9FZnJr?=
 =?utf-8?B?VXdmNiswYmJoNWc3WmhXNWMyVzBDbnFjSTZ5MjZlaWdac0RyWEtQdWtNME9C?=
 =?utf-8?B?UGNSRk5zMnRSNjY1UENKVWlwS2w2RXBaRFg3elJlY083eDduN3RZNklkc1B1?=
 =?utf-8?B?WGNkdDVYT01TZElnRVRqc09kUHRpdXBFbXoydTRtZXYxaUxHMk91RXQ5L2o5?=
 =?utf-8?B?SEdlWVlsZmRPelNiTlhsVGJSeG9WdEowR2RDYjJyK1RrWFhTby9TQ1k1dkRU?=
 =?utf-8?B?ZkgvMjFvTzRvZFZUMWNvdUoxNU1haTB0L1VEcjljZDZCSHh3RCtmdHlIVXlZ?=
 =?utf-8?Q?OZ6tS2UG90Y=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Zm9WdnNlWVFiS3QzUkpzVlh5S01jYlo5bHlQRUgxeldZOWhIQWRLUWI0VHlp?=
 =?utf-8?B?OGN5Q2o0WHVha3lSTWtJRGRrUTcxTnA2N1JPdFU5T3NSVFFKVGI5dS8vZnln?=
 =?utf-8?B?MUdOWTV2SkRXTEtib1NYN3ovRkRhbUtuRUp2QXdjZWFmM2J1dXJMRWRiZmZB?=
 =?utf-8?B?WVZMZWhrNmZET0FkbUlEd0U0T1RhVG5iNmliVWVWQ2pOMFZJYkRPd1h4eU1u?=
 =?utf-8?B?YjZhaE9SN1lKQzJ4dXF4WmFNU0RlWTBhYzRZMDJFN2FsZXIxVFZxQlhocGFL?=
 =?utf-8?B?bFZnMmU5bGlOTTM3a2doUG9XWWEvaUZrejVaYkZsUnZVa1VveHZyMU52c0Zv?=
 =?utf-8?B?VEtSSGlFVVJCa3U1R3lkVVFDbzhRZ0xWaVp2VUVzcFNmNWxUOXBDWm1NYkFO?=
 =?utf-8?B?SkF2Ym04bmpYSHR5c2ZSNmpJeWNpUVFyVzcxQTZpNDQycndjblFGdGNRTjVa?=
 =?utf-8?B?WmRRVVA3RmF2RmtHQ3IrT3JkZVRlTVBmRFlaVUdkdzFYWndvZmFQWExLMVJJ?=
 =?utf-8?B?Y3c4SjB1WUxITG43WlBUVXI2eGw5UWFjTGZDVUdwSFJoeHlPWFluMlVqNXVw?=
 =?utf-8?B?TnRaT05ZYkU3UkVocnIwVWdIbCtJQWRiSmlBM2Z0WWQzY1JMM3B0bFdFVnZu?=
 =?utf-8?B?OHpGSHoyRkRQK2VNMnV4UE9kL2p2Rk9YMi8zdVJ6cjkrbWZQV2VWWHIvVVpy?=
 =?utf-8?B?WVo4aGRlQ0xMRDRGTURkdk1MRWtVd28vZU1sL3ZzNWQzNmVQK2hlTEhyQksw?=
 =?utf-8?B?eHBta1JNcHErOGxxdnNYVVlqdzNOc2ZoQWNTUWJKZzQ4bFJ0UzhuZEkybEVq?=
 =?utf-8?B?OVIyYWZERmFMeGduUHB5R3NBTDM5SmY0ekQ5RHBIcGFSaHY4N0Vmcy83S3lw?=
 =?utf-8?B?bnhHbHhwWjIvaGs3M2RiZ25rV1FGeUoxQllWOUpHZDRWekdmcWhGWFN6VWpK?=
 =?utf-8?B?bHZEeEtXYXQwRE1RZVF3bFA2c3J6dDU3TEwyVjZFNHJnUStkbXIrUFVGUU90?=
 =?utf-8?B?K2ZkVk4xOVJwY1F6ZkIwVjhqUk84WXhvZ2JRcFVZRitXOU5OcExraGkrNE5W?=
 =?utf-8?B?OXowdmtzVTBxaTZJVm9QZE9rT2phYnhsZ29NZGtVVDR3U3NPKzJDYUZpOFpl?=
 =?utf-8?B?TlUwQ0Z1Rng4NlNzTGw3NjQwdHdLUEMyNVBrdko0V3NnUkxXd3ZYUDJxWWdm?=
 =?utf-8?B?Y3lLOXlHVFgvQjFIQTdqcDAyNG9wT1NESFZtcENwbGNtV3FZYi90K1NwR3pY?=
 =?utf-8?B?Q2NsSGFjcHVjTE5ZWkFLSkJSYzEyTTg3ZHBDSnNJcWVvVzhjQTh4QkpDbFc3?=
 =?utf-8?B?VU5PVkhKTys1THdoV1NPMkNlN04yWEhYL3hnM01xdmkvcnQvNDdjd01WWG9W?=
 =?utf-8?B?eFhGQXpKaXEwcVh6OUZNeFc0S3RKQkMzcEJPS2dDNFRzaDdNaStwS0s3N09L?=
 =?utf-8?B?M255dzRIanU1ZEFoQ3p5THRGNXRMWDBrU3l0WjR6T1M1U0hVMTY0MmU0bFlP?=
 =?utf-8?B?NkczaHF5ckhHelJJSFd6UUhROUhkaWtZYTd4SHY4Q2lKeno4Si95NmNjaUpk?=
 =?utf-8?B?djdGZ2p2UXdqSjcza3ZLc0JsQ0F1c21vbldwTlB3NEsxV0hBNUhIdVU0d0lE?=
 =?utf-8?B?MVVsempxbG44Z3VKTXgvMTFtUytKaVY3TnNkWXNYbFJsdXpRcXV0eDlpOXor?=
 =?utf-8?B?ZFRQVUZ2cXFhUWorTVhpb1VCWUlxZXQzWlNBNnZ2U0FRTFdOSTErNm9lTUta?=
 =?utf-8?B?TVpJZGtPRUlyNGZkWXlWYUNyeVdrQk5va3BLZVpiMzBQU29ORitDNDUwODBi?=
 =?utf-8?B?Z1N1bGc2cS8vSlNKK3BWS1N2UWZtcFE5UW4xN1pXbVhvcVp3MlhVeER3T1FO?=
 =?utf-8?B?RUI0SUhKWUVmdmpFb3cyWXIzYVJTNi9CTkl2eFRKV3BibUkxUTVmeDArTWxj?=
 =?utf-8?B?Yzk3WEJHOTU0bktuSDAvbUdOQmdHcmRoY3FHOVZLdjJja0w1TnQ4YWtYeVFP?=
 =?utf-8?B?ZHpwbFYyNEM3U1FYRVlKZGZVY0gyK1c3dnNDZXNOclAvR3BFWjZPK3JvTVhP?=
 =?utf-8?B?ZlllOXNDRDVpYmJMMGVNYVVqR0NMd29zbUhiQXlpZjgzZVVjS3owSmhYNVpG?=
 =?utf-8?B?WXhNQVF1TDZocXhrdU91OEtyRnFWOUFUbUY1QXJlRnM0Z2tCaklLeHdETGRS?=
 =?utf-8?B?QWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZCvdxCtPHB/lPBWRC3wWm/b4/hzytcnjBEKD42r0IPlpg+X1+RcksyvvOuUPHORkikeeO7N5KaJypZH2Nhxz5Pz7xR2jJ0bHlPX4PZF/HIGh5QUhmU3HPcRDxYLALy4LRW0/AbTm57lBly1eknjAvTVYwpveQnIdxGBydXin91ocdCgxAPY3h8Kd7TacCt2l9lLOHbp1w7BcvnLTYGmMk+hjzKp6WVpAIxtBboSvzJwgg58R76uby72vRJk2X/Y1f2rwLw+ATzglAhhe23LaJbcFA6jMGc3a1mW2VkaC/h6DG6t79vr1Fm/1CxtJ6YILgCvRr9CtTBc1fP8NQ+2FLxb7E7YxQ/oEAFKi3gPclZRtajx5E6HVygwnWEG3OgdM0bhdntlPJiTlwAnXuAOclYVf0myOdlmyZxKBIipa5HEwIutBCwYiQBR0U6w5RuSlwge0fZ6w11tEDTJiEn1+DnG7ByeWbniqT5NNtLEpLak1E27heftAaiqkixgVecHixQRh1nzhIJm4bOy7ErotcFD8hFV9NHfX01LcHJB+s52FOwh5KqP073S986B5573RNItRXmOwA8m7H7EuwSgwZ1TjD9zueIUIHf75Qg/zGLE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a3bdc7b-cd61-4c96-7f19-08dd92e71c1b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 12:59:06.5701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LgB421BpKA4gYnfV+3W7ig4eR6jnqg2VoHRO1JvN/DjBGowv24PVQZdAEcopvIlCuhjiLC7vUYeQA/2xe/UWzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8078
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_04,2025-05-14_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505070000
 definitions=main-2505140114
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDExNCBTYWx0ZWRfX+2MFRSA5Fb1r 4XaQjfjAKG926GpYXm/FgzFf62Dpx2pc//jzo0O9y+VAWQjB9huazOVamVxl1Wj96duHLXjFt0U ThyVCVYzArO7yoErbxlKFkS1L/9GYnlRge/j11g6U7Awlgi+PHDHws1Nh5aeh++JINrHZFBoOV2
 UiNTDFMCtvvkjg4Qi4Kv3bM7ootUBJ0FPThAXhkySrEKsXA/W8pNRWWzLJA3zF1Kz4WTAj/xZ1U /LncprokneD9xFbia8dp592pgnEZ+QMKFgze0uHeiVm2PI9k5ijJPnWT37PxIcnYEQlcYPD+Kq2 jJd/7MtEmytvLW+6dln9aR983lOhY0AHcYmHpdLg0FcP0YVCEreRFeo7BOxxYhNdPO0giXHaIVa
 vQKh0fxCQ2uw5m+Xom1zWgAdDUUopRZjWXLIXRoi4RxonC3y6RWbLHWDuy92hdYF4aX8qfxR
X-Authority-Analysis: v=2.4 cv=Y8T4sgeN c=1 sm=1 tr=0 ts=6824939f b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=IdSNtB11e-3hlrgWVrIA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13186
X-Proofpoint-GUID: RsOENauOUYkUjy2aEsDZ8lxe8GI0xgmj
X-Proofpoint-ORIG-GUID: RsOENauOUYkUjy2aEsDZ8lxe8GI0xgmj

On 14/05/2025 01:29, Catherine Hoang wrote:
> From: "Darrick J. Wong" <djwong@kernel.org>
> 
> Fix some bugs when detecting the atomic write geometry, record what
> atomic write geometry we're testing each time through the loop, and
> create a group for atomic writes tests.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>

Reviewed-by: John Garry <john.g.garry@oracle.com>

Just a small comment below

cheers

>   }
>   
>   get_mkfs_opts()
> @@ -70,6 +74,11 @@ test_atomic_writes()
>       file_max_write=$(_get_atomic_write_unit_max $testfile)
>       file_max_segments=$(_get_atomic_write_segments_max $testfile)
>   
> +    echo "test $bsize --------------" >> $seqres.full
> +    echo "file awu_min $file_min_write" >> $seqres.full
> +    echo "file awu_max $file_max_write" >> $seqres.full
> +    echo "file awu_segments $file_max_segments" >> $seqres.full

We should prob report and test atomic write unit max opt also when it's 
available officially in stat.h

