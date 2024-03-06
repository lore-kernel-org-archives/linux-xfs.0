Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C2A5D48F
	for <linux-xfs@vger.kernel.org>; Wed,  6 Mar 2024 17:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709747800; cv=fail; b=A9s6gmCfZD6hqFzz/tZw6iZnFrFDy+5Nc3wWZUfdaiBwi1YfsX55QbrMEj7k7GA4l+MR4JtT0PuBlKb05KaYLKsMAFaKK0iKDjW6dio3845pp9OS0IQyKbWP6N8kLfEv/uOs5gTy1UGQAIMawAQ3rLuX/CUdL6nIXBkS2xir1tc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709747800; c=relaxed/simple;
	bh=exrNhZoRrSOva5sVtQdRdO6PyxbyBm8iUD1F5w21TmM=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VpRf2sepwxgrxVkPIo1BOWsWaNzy12QOO5Roic9UlC4++NcGC8SXeGClCXaAXAoaYPlti8Kp4lg7Vm8bNKbwP3vx+qnqEavTyAVh/dEpEEfHMG3pUrGN3POZx7TW5zmWFSHgT+05CqFpBRIB7O6d9SqV5/ksszmfXWlViqziHLc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=A2Qebcaq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WwZ9CLmT; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A2Qebcaq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WwZ9CLmT"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 426H47JX024573;
	Wed, 6 Mar 2024 17:52:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=BptM4iK4wJ5P7hLj+akI3LurQxF/FT0P/a+TQp9lX7A=;
 b=A2Qebcaq6f5k7oKKPI9hzvZ2CiQ5swrzpDkyv7DDI5WMuDWqPYInYx66lu9u/XDCZ2Qo
 ayQjUKnVpXXqVzPiQFh+MznSLQThpGJDa3LqN1RXxlJs/G1jXRs7ge+F7hUvgdOPqc07
 TOE0m6ZEy4PNHDSPOu/HiFRL/QuCbAYJMCmg3bxdPw9L2EoIkRE8hHcV5io7r+WAVBFS
 npEMirfDAUuX/Bskkroa6pUhIvxhkfk+KqJ5nOFl/JTsMeHFQMEEbXr6cERjw8Le+kZL
 +Jm7zbRc2bsTI8ziounsT83dvCj03GLkczkaCgNS/UiLNfQer84JsamT4eCOdbpKPXdg dA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wktw49hss-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Mar 2024 17:52:35 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 426HVZ7f005323;
	Wed, 6 Mar 2024 17:52:35 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wp7nsf6ch-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Mar 2024 17:52:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NK5K30lsz+JFXkiPfqN7A40pRMwUsik04Y4IJhtR/+5dRDlmfQILq9J3h8LgV2cFjkeS8JzUXaCRG8JNZIKJ93+aJOgP8WWON6hkOZ37ivN+qtRjIl0akQEPNLQHqBICBpyIBjqNPw6nNOYo95Frw+KFFEby5LhjP9yjyl2DlvChSY7ObyGaf58O0QlqrGEpXbPzR8Ty1ky24dadyFxNExtB+h+wUeqOdbTmxorSOpeNq09+IeaCFniIziYaa+lexVdjmywy3ZUhEwpNtbjr92JGjBBxgy9Y62KqyEOQlm3dJQxO1WaiEOGWeSExRPzNJhFo9ChCfW6QN5K/Mg1BHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BptM4iK4wJ5P7hLj+akI3LurQxF/FT0P/a+TQp9lX7A=;
 b=bZW6Doygc/H2IT+FjZiMMhA2J5kxPRBHDk+MUdrWS+F/FPGt0mt8bs9t/uHJYMYQeQJl8izmbDT2xpEbz5Xg/rLCGIlwJbC/4YXYivmBgorF7d677OjKWyT/PAqcEsXgoLRcscDS+vgQ05v8cfv4CbyozmAp1cU+Dz/PVhsgr6G5QSRWExBLnPxRp1LSz6eiccG2eRJvMgG/dBLWpSs8XVSuCqdj6qweebOVzSg36vl6Bj9bvvN6N1NjZ2SMGmIv6l3pq2R1iLndIg/Ow6rcb6pdyAy8+vv9GJ7YJLrDqzp4LVPc/nb5YFmtO0mNhwKg8ld7XOsXLTGp20qZeXANOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BptM4iK4wJ5P7hLj+akI3LurQxF/FT0P/a+TQp9lX7A=;
 b=WwZ9CLmTFXlF7mzC0TtuxFQC4TTRAYjmDKhk6GgwgLBcR0FAfP+ag+K86ucR9DQtvYj3xgKCC4GVkeDNsbRtNQQYuhteP9fGn3nkvtgn/Q64fjxG3nZ/JizeAb5yZa0zKXXJ7yocQiZE36N2mz757BnuoOvFbRKOLjohfXgkOM8=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BLAPR10MB4962.namprd10.prod.outlook.com (2603:10b6:208:327::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.26; Wed, 6 Mar
 2024 17:52:33 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7362.019; Wed, 6 Mar 2024
 17:52:32 +0000
Message-ID: <6c932fab-0229-468d-a0a1-60883f7c1692@oracle.com>
Date: Wed, 6 Mar 2024 17:52:29 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/3] xfs: forced extent alignment
From: John Garry <john.g.garry@oracle.com>
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc: ojaswin@linux.ibm.com, ritesh.list@gmail.com
References: <ZeeaKrmVEkcXYjbK@dread.disaster.area>
 <20240306053048.1656747-1-david@fromorbit.com>
 <53f4519a-6798-4925-ad5a-5d2d17b6a00f@oracle.com>
Content-Language: en-US
Organization: Oracle Corporation
In-Reply-To: <53f4519a-6798-4925-ad5a-5d2d17b6a00f@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P251CA0006.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::15) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BLAPR10MB4962:EE_
X-MS-Office365-Filtering-Correlation-Id: d128d935-e64b-4df5-9485-08dc3e063311
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	UX96kLYAWs21sU3qyrTyTLT19Y5JmG+qfsIMwvv9yF1n3//6zb9T+p0TqfL1HLhnuOwVaCzorU4hOIxbeSe7rfqs5K4nx7k1vVqK+ecxO3ZKF8CdscsSnHYroCYftsk+26amD6CGycVn9SpSiwpUAtt3jtDuM5sMFUvik6AIYLMtcmU+EUHqtbaM3XuFkGkh0wx5xK2mgl4nFh31ImF7fKIrNDfUUZiA8Ox5nyRHN51Wx8DVdXoB9rVyRzgb6x5GzHIwBaRI6FVuGHfYEJibgq+wx0uZ+WhAtV/udmmMmT4MBju6Nx2KH11W9lWBVG3LbYMb8u+j2MjmiYbG0izDpCS/+GmEUMl1meXe1SETiTSnXVDePd1Lo3XcgJ4eMxmialtgV9bQff64cxjD5/DUsRYr4trF0VFaHH1b7UKomcpC8+NChBLXCW2sQNclHX5awcYTCu26HPpVsoKOOXZA5iWiXYwjSdFcwyVzj2wZNWAnPRkw/w30AhBXWkdBxFaoEEf9Byo2KjCwVqWxwAkyvAIR8iYJluTpLVU5y7sneqEJApMBOWWh8RzKO63SbxJIzOw6N1XcLJ0dMUbILYNopRY2egquWZ+91IV9sWvARJw=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?UjVtZTJrUjZaZVhEMnJOeHMreUwzNVNhWHZoc3lOdUZvcXN2Z1NmOGEvc0Fq?=
 =?utf-8?B?TE5qZkx2ZDI3RnZPVGJWZStzaEprbVc4R2hsWCtoY2hsUlZyS3RVeCtQYkJU?=
 =?utf-8?B?cUdTSTJUSFRvY3FDSGxBRHlGbDc0Skl5cU05ZVQ1eHVRUGNoSjl5YjQ4TDhK?=
 =?utf-8?B?ZG1XK3ArMWRZNWh0MWtoUVlrRDZaS0hVSkI2RVdMUStwMW9CblhQeXdpOVlj?=
 =?utf-8?B?VUxMejJHSlJKOGVyS0xFUUFTaEp3Q0JUUVZQUEI1S3NTWk0ydnBrSS9UeXBh?=
 =?utf-8?B?S05jTnk5Z051LzA4OVVYWlErelZRREJyTGxpWllaNGJRQkx5RE1uWlpvMENO?=
 =?utf-8?B?N0xybFZvNC9NMlMyQWxGTnNieHIyczd6OTY5S09IR1NNZ3Z4eHAzMU5FT3Zl?=
 =?utf-8?B?ZGFRK1EyNlhrRHhXSmhIK1VVa29UdmtmNGpORlhTWkZ6NVNIeSswK3hzRVZ4?=
 =?utf-8?B?cVloNk5saXAzWk5QQVBqamR1bmlBL3BlVkcrMzFPRjhSaCtwZEx3bnE5djVL?=
 =?utf-8?B?ZnF0cExDdjcxcjVyR3BYWVFoVWUzWG12eCtXeDZMcjBnOEU1MThJMm94eXRa?=
 =?utf-8?B?YjdXOFAxVUlMSDRZNUdzdGRVTzRqNzl5V1FJeEJ2a3lWbnN4WE80NmMvQUls?=
 =?utf-8?B?Slg4eEdudDg0d2tNdEVZS2gvRUNtcldsQlVzL29JS0FCQVdEd0RuRFFwWGFn?=
 =?utf-8?B?KytjbHA1ZkwyU3J6azJrMHJKM2YzK1F2VHpzcDI5QWswREh0WlJhd0dVZjRX?=
 =?utf-8?B?N0U2VVViRU40Qk90d3FFM01XNTZaWVFGaGdqWGcxRGpFVmtHU1lGR25CT1lk?=
 =?utf-8?B?QjRDZ1RjY2MvWWZOYkgvaWVGWTYvNlpyaDlkSGZPSzl4am5ZVVcranpWOFV5?=
 =?utf-8?B?YXRJNW84aWVMbHBYazFZYm00MEg3TzZVYUVramk4S1pQVXYra1BtbE9ydzF4?=
 =?utf-8?B?WTJhWlVsQ3RkbHVNWHZEMmNneUFjN2Jhd3J0eHdQVzdVMmlHRGdQNHNsRUxV?=
 =?utf-8?B?MFNlY1Z4MGw1bjI1NWF2MnVySFNScU40N0l3YVNPZkg0MjdWRDhGVmhZYnU4?=
 =?utf-8?B?SDZ0MjlLMWplK0pEOVF2d0NPN3RKT04xNUlHSHVUN2xPOE9hNzQ1Vm55RHRu?=
 =?utf-8?B?SG5BYXk3aFhyNzNmZ3NSb3dmTHRhbHk2VUNCZVFpV2lab01yb3YvUUVNWmQr?=
 =?utf-8?B?Y2NBbkdSUjVrQTBtQlRuYVh1SUZ3WkZ0Q3NzN1NuN28zcjJnVlJCQWpxNXZJ?=
 =?utf-8?B?UGdHN3lPUWJ6Qkt3c3h3K01CWmNLdGJ5UCtoTEdSTExXTHMvTUVOTk5IdTBM?=
 =?utf-8?B?bzdyUXpKVDJMaCt4Nml0T2M1emJtK1NQSFI2aGtxLzlrUzRqWE1vdWRFSE9o?=
 =?utf-8?B?YVRLSEppS3ppM0lyTzVXVzdzNFNydU12MVg2c0sxbHNjQzJESnp4Z0tKVU8y?=
 =?utf-8?B?cGszeHZZNWh3Si96QjhTT01MUUIzWlhwZGNCRU9ZWTBESktPUGFFN3VscUxN?=
 =?utf-8?B?bUhUcU1UWEpwNUZVeW1pTURuNkJ3NCtyYy9XeklaTWUySGxHRG10RVpMcmFB?=
 =?utf-8?B?WVZ5Q2ptU2lBbWxlRVo4STJYR2dLODZsdUpKSGs1bXBxcjdHZGk4ZnBhYXh5?=
 =?utf-8?B?UFU2dkZ6a2h4dFNoRElCZCtvdGJFMG1ORHZ6c1BlZ1RFeWlEU2RoTVdYY2Jr?=
 =?utf-8?B?b1Y0SjJqNmNxbXlRS0ZlbVRTV1N6ZUVGSlJZQjlZZmFkSDBnM0ZMRTZHZjdv?=
 =?utf-8?B?NWhFd2hEWGtQd1NrbmV3eHN3WFUxZUVsbUp6ZEc3QTc1dmN2ajhYejcxa0t0?=
 =?utf-8?B?THZRYm1EUlNyQlYxT0k0RTR2MFdNRTZhcWQ3ZjZXT3MrS0JKcXJ3RG01bVJ4?=
 =?utf-8?B?NWFlOG50UkZXWjczSFlKRjBpSzA4ZVNSNmFxemhiMnJySlFsaFJ2THJNM0dj?=
 =?utf-8?B?UzRyOTRjVTFsaisyZnhCZU1rNWxROGg4K01IWE5PaWlSbDgrN0I3Vkl0R2FM?=
 =?utf-8?B?anZybUpQZHJtNjZwVGRNUytqa2VFTEN4Rkx0R2VnOEpweFRaZmRnNFFlclFp?=
 =?utf-8?B?aVpUNGV5RWs4QWMxSm9kMk1vNU5Td2hYaVp4a0FHYkNxU2dnMzJSc2ZrWWxP?=
 =?utf-8?Q?bKNgP1E3TgwGT1DVqBB70dmt9?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Mj5EECMew2RE0EU415HiTCpvxS9b7ZUIrsICjPChldlzsfi8KCj9xAORVdG/vr7CcBcwa5cjuYil/rXY4PDXYtwYP8TMflY/3S597JnLRxDBcxx00MQrwRcU6C7RfCRC0E+pKc6SyRzkOgjHUm9Gw4+CQ3vvoV4uxBvVjV0qlA1HTgwHNn2PkTNsZ8i2HPpojgSMYwObcStUqfpim5ROReJixh+EIdbQoQpY5Gjt/+0sEPsowBiX0egfKbAwnVAi2d5/hO4pOnrBVc/KCJxChjUUN0bPWz47KArBCZHH1qHzfZKq/gQWhaMUccIMFH1l9rQHmkukSin2iQTkSYIn5Y2mHiizZQdM2tsx3Ku/HY7NcrnBzNMp5ZGmydHRSdfz+tdwtQF+kE/k5JLSGukjn9nv4a9VhVZqmTURLymzI2Fe3NCH76TJIQeTNW5peTZw/bAFyLfW1NF1fCRysvMhwZ68SQwbx1nlg/dT6tMjSZ+lau1ILZqzVc0wBRwC71juZuzv2I9QFlMxixYtyzo0TeDWgpS7Kflsq9duvdkeDCaevPhSGGasd3/z+8c0J9bFedrMkCD0uUIFHGxPbP6p9cPw8ZVp0xTWPipb+5YQWBY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d128d935-e64b-4df5-9485-08dc3e063311
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2024 17:52:32.9355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B8dYQL6pTB7uvCG6yv5C9cCcyxzBUEr1upXLHAy4uFU6LwFftQCjwKvosKmAnBX44q19/0nqydsnzT2/vaA1IA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4962
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-06_11,2024-03-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403060144
X-Proofpoint-ORIG-GUID: 3Q7eiLG8qTYY8CjyOkYORebr97JxAuEk
X-Proofpoint-GUID: 3Q7eiLG8qTYY8CjyOkYORebr97JxAuEk

On 06/03/2024 11:46, John Garry wrote:
>> The following 3 patches:
>>
>> - rework the setup and extent allocation logic a bit to make force
>>    aligned allocation much easier to implement and understand
>> - move all the alignment adjustments into the setup logic
>> - rework the alignment slop calculations and greatly simplify the
>>    the exact EOF block allocation case
>> - add a XFS_ALLOC_FORCEALIGN flag so that the inode config only
>>    needs to be checked once at setup. This also allows other
>>    allocation types (e.g. inode clusters) use forced alignment
>>    allocation semantics in future.
>> - clearly document when we are turning off allocation alignment and
>>    abort FORCEALIGN allocation at that point rather than doing
>>    unaligned allocation.
>>
>> I've run this through fstests once so it doesn't let the smoke out,
>> but I haven't actually tested it against a stripe aligned filesystem
>> config yet, nor tested the forcealign functionality so it may not be
>> exactly right yet.
>>
>> Is this sufficiently complete for you to take from here into the
>> forcealign series?
>>
> 
> I'll try it out.

Update:
I replaced your patches with the relevant forcealign patches which I 
send out in "[PATCH v2 00/14] block atomic writes for XFS".

So far they seem to work fine. An updated branch is here, if you want to 
check what else I am using:
https://github.com/johnpgarry/linux/commits/atomic-writes-v6.8-v5-fs-v2-dchinner/

I haven't tried any stripe unit testing yet - I'll look at that now.

Thanks,
John

