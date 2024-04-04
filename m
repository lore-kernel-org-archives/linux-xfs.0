Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4DD128818
	for <linux-xfs@vger.kernel.org>; Thu,  4 Apr 2024 13:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712238891; cv=fail; b=MIgOdZJkcUCWRtMrb6EtBriBj/Q/OiBxvJkrAlsNnvzJC58HvshflF0prAzL97OJ/y0W5YBjzb0Ee8wxwO5FeZwzewLQX+X3hvorrLtGzyIQ23a+oTEKXsghlSYm+v+wAGzEr/bDSBe3Rd9UUr0+Z5idh5rGM6jrYZOUZkEpvYE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712238891; c=relaxed/simple;
	bh=18BEriXG0x2iIxAMPC0tT8Hh9OrIaNZXXX3NjYd7VHU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ASmxXysys025pIxU+6EN05BPVrUMiXHsnu1BBWsDSO9/o3K09WZli61BLY+I/EtU4CjyAwfjmB58QNHAt8PZ3RZRJ0k11cNsyEdBe5ueOOADH1uAXnWnCUQDp7EEWJYkgCr4m3wM94W0R2Ci0w2vOAW8Z+Rhcv7rfJhMqtRO608=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WNZE6oz6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QN40Iar4; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WNZE6oz6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QN40Iar4"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 434CPbiQ027193;
	Thu, 4 Apr 2024 13:54:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=KCe/W+TJg8WIBJrugPVQsNnnBoh3Q2gUDyxt08IsLjw=;
 b=WNZE6oz6jGwjl6axRbRC7tMObYUkwhjSedsEYPNQnDMK8p+Ks6cZfIWAP41KF45/SIsn
 B/I4Em8oaO0WmGmc44WclILX8xAyA7RsVurtLR3Y5ypctuRuIR2tWIAzCBeI07ECZJ2v
 st/mSXwOyRvG+hT/kTOPXefQIi6Ts1RDqb1pKAOhaWykls3jdrkR8atwZeZ2MP4e1QVM
 A4pXCTWnovI2guu8eTpXINHvnrCqBx14DU+/iuOK7tpqr6/ZE5lqdvfK653J59/+YXC4
 F0abX1Z1aDUgiorMEUbiDWNy4zS30zNlO0HiqLjRSV/eJaoPlVzlJDZLgRkIZCAqjMBF wg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x9en0h9u4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Apr 2024 13:54:42 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 434ChuvI038965;
	Thu, 4 Apr 2024 13:54:41 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x9emr7t0a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Apr 2024 13:54:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E5lrhizSJYJ9HyODNgJ3LC3bJzki14B79HhLtssU5RcOUuNpoGo7VeZMJl4/KaSok3IJ6g3jwyOVkvo8j9MnZL3lK3n/lzar8vhNs3GEHHRwU4YWQTUKvqD0NVg0nTjbP6WXh9wI6UDnFxy+HFO+TlNTB4UKT8KIhAWEZWh5TeI2gqhoVHnE99/UstYGxcPM7FT5WHSY0Am1f64/P1osZKHjJqTTU3FwsK7/cOBvaQWyQc2H8JRwfR+XyUoH9gYJj/CyrYeW/RtltfUjjjf8Y6vTYAWtDqEtUXY6rZkjvrKhn0gX3OkjfDLIBKF6mfKqE7qlKA7UORNsOs/0OZ5EcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KCe/W+TJg8WIBJrugPVQsNnnBoh3Q2gUDyxt08IsLjw=;
 b=TeScy84dfRNULgntcBIraOrEHwrkx3qqKT7yfuC3S37SV6KTkgsYbQiirfzoAQM7vgImk2UO3+Ds8W73qLx6PuWRJXeb+9h7itjYjcfE4JvWReTPUYD2NlLLGdlaNWcrXOrsAlZOcQZsMGFWSJptBMYy5o978per9B1yLl64nk7nt4e6c04ekjEPFMmXuz0TzKMmOqhyUXOywduGzPn4QZ8A22qZHOxywvShIlLiD/TadZpAk2oyp/p1Agg7OUtWkqAVUhx/PeuK3WVEV6fwdRkEBSgPD/50oBfTz+DRsbANr0Wkv4/v8G66IpsQpBGXkqjOmQ8BJZh7xrqHSndDWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KCe/W+TJg8WIBJrugPVQsNnnBoh3Q2gUDyxt08IsLjw=;
 b=QN40Iar41z6UI1XDHbYTHegz1SiroTNbaLVr+3E70M9KoJuAz0qSW81+KT7LvZezX2Bvz6jqbqto+RTHif0sDq4+ZfmQeGxS/D0AmSZqBNxYi7Q2VdXtizV5wHyUs/zfLIEvN8/4iRwRgmCmB0gxj9T2+JBDluEMo3zryKsuJbE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH3PR10MB7836.namprd10.prod.outlook.com (2603:10b6:610:1b1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Thu, 4 Apr
 2024 13:54:39 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.042; Thu, 4 Apr 2024
 13:54:39 +0000
Message-ID: <0f905d4e-4d19-4570-93d6-b2540620a07f@oracle.com>
Date: Thu, 4 Apr 2024 14:54:34 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] xfs: only allow minlen allocations when near ENOSPC
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
References: <20240402233006.1210262-1-david@fromorbit.com>
 <20240402233006.1210262-2-david@fromorbit.com>
 <c515119e-5f0e-41ba-8bde-ae9f6283b3d8@oracle.com>
 <Zg3jBwIfZ1HVm8aV@dread.disaster.area>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <Zg3jBwIfZ1HVm8aV@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DB9PR02CA0003.eurprd02.prod.outlook.com
 (2603:10a6:10:1d9::8) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH3PR10MB7836:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	f9ZQDuqzQC5qAs+IRycju1b1NF/K5Fo+M1T3lDWGj4UnpazURTPv06I98VmtPUcJtwzqRO7rjQWu8/c4xgRM4/vRCuMpMVSDzY24hUFY9LAjh8+rYCa4WMVdGd8wyLyrw5xVMeZShMDLXHt9H7X+DsBasqGnahoUN4K5OnhjDdrHWCfW/qlAO+2b6SC0uSUUi6Fq12nADdK+pmmyZlXLkAU9CbD3CIDnO97X8R6vfCmv+A025u2h3uEPaZNpfTdILhfMKSTDtt8U3/izAXb/6ArgfH/IUPHmCNw16moFdSHXrbMxCBVVoiXvQwjDg6LETtE5mPe4aLE/AwnHc1/bymFOmp+SIp66/WeEVylMXLJMsd3NgkdIYthL/C7PV5ZGa3cvuqh+kbS062YvMu2FzdOYtljLgRpRI/VLP5ts7ndJ0BCuyvUnK5CMzvkOGUjudKvanV2DbAeB8qx6ReznIMhyILWZklhz7aNYv5GZicAmCWUBsqNm9wjC7KA5wws+RvLuPgfSIk7PRWRFyWq61GooH55d33eJut/BHEGMWB4VfcYdQThKv9orZK6ExhryVbo2XBJonDASkvU27fA7V3kwNbrf/t6jO+Z9Qoo9bO4gMg8uWE9EsGE/SJOh+ulhm7xAhWSipDdnSRCjV3Gg0xkbH2Zxx2Meabjytkhpy0I=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?TXROZVJxNXBEemgzRmRUQm9RNmVnUVN6ZlowSjNKUlFlOWljMm9uRDUrbmJt?=
 =?utf-8?B?TlpHemtaOXF4V2hKQ3hLdmxaRllPaWwrTHpWOFM4R1ZqTWgvR1ZPajhEZ09M?=
 =?utf-8?B?UGhKMms5YnpXVlNRQlZBNE1GQUJPN1RaM2FiY2l0NjQ0MmllVEI3KzFEZmcy?=
 =?utf-8?B?LytPWUVkc1k0bVBoZjVyNk9vOU00aG9OS0VSV1RNNzRiMDYxUlZ1YVhHeXRx?=
 =?utf-8?B?TVJKeVpBa2tUNEU4QTFBWUIwOGFub3ZYWUxCa2oxT2hEL0ZHL0h6QjBnZmVo?=
 =?utf-8?B?S2xYSFJEL1MwTUxoR3RIejBVOUdvYXBRdlVyVytQdUlIbGJTa2w0TTVVdGdn?=
 =?utf-8?B?aWQweDZSN3RxRnUvc1Z1ZWJZeVBaamZlQThCWGNxMnljSDJaTVZzb3JTeVdJ?=
 =?utf-8?B?S0N3TUlPUGpPQld3SkIxeGlpYzd5S3hiUElyREZxdXlwREsycW9IZHRsL1Jv?=
 =?utf-8?B?QkJaWWRFSGxNZ2xXbDdmRGpGMHp6Y3JyQ2x5SE5aczg3R2VJOUFWYkRucWpT?=
 =?utf-8?B?TlRQWWJXWlFBNFhVRnU0MUo2bDVIM2hRRVJ1Q3JJdTJHdlZVR3hLbGNMWlpX?=
 =?utf-8?B?WlVNL0V0VmFiK2Zkck5UbHRYU3dXM1EvdURPY2JoaU8yUFZUZTZDQkxXSk02?=
 =?utf-8?B?V3dpd2gycERDR2l4eFBDSDZnUktnbUUxNFMwdk9IYVZuWGJobEpBMEtKZEkw?=
 =?utf-8?B?QnhCdU5kcmZndGNRa25xSThEWlVhY2RkckpDenh2UHdVaUJIaUw5OU9mdUs3?=
 =?utf-8?B?dnhMZklHak1yaCthWG45d3lJYStjZ1hrWlk5bVp1ZzJRZHBHMkxzdWFCRUZX?=
 =?utf-8?B?VWNLdnByUXRnQmNyUjArVTlQRmp1cUVWRzRrNHpWNlFhOUVyM0pUL3FYZDQz?=
 =?utf-8?B?ZGkwb0dwMUNYMloyMDBUdDFVd05MMnEvem5odGNOTDBTNSsrM1lIeE5XTzVN?=
 =?utf-8?B?clQ5QnpyOTZ0NlMwaHRLZWtaaWd1ekpZTGo5YUNVaDdyRXdqTS9ST1gvN0kr?=
 =?utf-8?B?cFZkMVF3RENIV1NiVnVWZjJ0ZHRLTTFqYlFFOTdaZFA3MHJTN2MwUllSaGNy?=
 =?utf-8?B?dG01LzhlbE9STjNOakpZRFZsWXBDQldqVHZpcE1ZSUF3OVRNY0xKWjIrMSsr?=
 =?utf-8?B?ZmlXdDE1aGM5cmUzeGJyazhoOFA0NDRlbmtER2J1bDVXVkhmcEYrb2E5TmlO?=
 =?utf-8?B?eFpEbGVlUHJReUhWL2xlUkJ5OXpCcHZ6UmZiL0diRUdOMlorbTM0UjJRTjQy?=
 =?utf-8?B?YUFaZjJSaXg4bEMzRVhxNXM1QnFVZ05YbnRXWng4QXNKSjFuQWphVnJBOUxH?=
 =?utf-8?B?TmVkNlh0T01XbXFiSXpVck9pQXo1VDZJS3k5dlNxUjllTE1lb3VkczZBNGIy?=
 =?utf-8?B?MmtmWFdrVW5JQWJIV2pqdWpXdnpmbjEzdWZTekkwSnFxYmhBZnl5cnpGK1Q2?=
 =?utf-8?B?MXlWS0NtMHh3b2tpZVUwUVFQLzlINXgrWFNsMEN4K3p2T0tZdWdMbm14TklS?=
 =?utf-8?B?Q24yc0RRQUNGdzFHSnRUOVRweERLcVB6T2hpN2Y1amFtT1FoeE5md3pjM3RX?=
 =?utf-8?B?dzlLM3I4SklwUWEveGRuYnZRSjV6eUljUjM5TkFFM3ZFcDlORXpLNll6bjZQ?=
 =?utf-8?B?aStUUjZLUjVveS80YmYrVVhXSkJ1S0x0V01RVzBvU2VtVitqazEyRUNzMHQ0?=
 =?utf-8?B?Vmk1VFhKbjJ5a3FkVUhXOFhFVG1heXVJdEdabTJ3RGRiMjBKTzJhR1N4Mkxw?=
 =?utf-8?B?QzBVUlZZVnRxSDNkbElmZWd6RHZyRTcxZmJ3OGZvM0N0ZGp4dTlxd3IwNThO?=
 =?utf-8?B?My95UU1xVkhKbkhLMTVwNmVndFJmTmZrcThsaklvVEpGcWtkMlVMNzZWdGsy?=
 =?utf-8?B?Q3Q3WWdjeFRFenk5enBHN2FRRFM0NE9jOXgwVmJlZDNmQUxkL2xLYkNhdG54?=
 =?utf-8?B?U05uRFJ5aU8ybmtlNmpEc3VMMGFySmcwWnVRY2JiSS85MGYrNGU0ZFIrU2dn?=
 =?utf-8?B?OUFoamV5dGlHVlpTMzcyR2w3UDdmcEhHb2FvWVBTazJRTlpWZmovcWM3Qm1n?=
 =?utf-8?B?cTQxRUttSWlZN0wvV1E4STNLSGRqNU4vMkw3YWs0bFdpQXJkQ1Q4Wms5elRL?=
 =?utf-8?Q?AyW9qG42es4Tq0TvM3kcUWZEx?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	d7+FcNvX0wIoorL5ZoCjw77P6WiYBWIvGPIiNLpObfX+LXUC60Sw48adjxW2qyyyDtYUyOUro/e8ExWH5G1gKoL3PVGG723VwuOJPUILRUXo4wtVyY8ry2u3Fr996/zubpSmN1CLagHnZ8KCh3Oo3hKKzFqbLL2DVS72I7TkbFFgzOxKkrpf69MdBjbGYZNboOfg4wiojPKfYM4W7JrGtgchVwsBz08QajoUwchPhc6YPGpI7GDNzygjG/EcISHb3T2xhaycSJ4WqgKHIvivr5H9CORFIk8+Q3rkmw65lfkefkOAzGlBk9+Sfk1YbLsB8L7HKhNN3OmsXDxA8usw4ZBUnTTu7k+PfprYDTUn8lA95FexZkL5tBenjcFwUqxorCsg9VYNg6EYqXFmvabAwbmElIfOfPhMm+FPZS6jSXU9rMi6IVog+o5YQffYhDcqOIaMHlzKz6cz8J0GNr/q0fAhPvR4w3G6fabcGuUK2nquRPHRyMWZEJLmF71/C1SoIGMlMIHTTWXifnxXyywAyUT+Alc4f4UzT8VLBhyZgxHKjUmy6pcCSm8xe6JeymAXRPI+RWQis+GtUe+xT62fGjHQj5StxSFxB3LB20+pGas=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b1615bd-86c3-462c-6747-08dc54aec470
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2024 13:54:39.3139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2SS4jI4ZFNMkNZ2PqOo7Gf5xFo1n4c4bZuz0j2dFsAbmcabHpJG9NVUUsoXNSKMCaggT4MyzbWkwxRf/G4RBtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7836
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-04_10,2024-04-04_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404040096
X-Proofpoint-GUID: 1ilJB9Gujjtkc9jpkdTer1dmGVg6LqEp
X-Proofpoint-ORIG-GUID: 1ilJB9Gujjtkc9jpkdTer1dmGVg6LqEp


>>> -	if (available < (int)args->maxlen && !(flags & XFS_ALLOC_FLAG_CHECK)) {
>>> -		args->maxlen = available;
>>> +	alloc_len = args->maxlen + (args->alignment - 1) + args->minalignslop;
>>
>> I added some kernel logs to assist debugging, and if I am reading them
>> correctly, for ext #2 allocation we had at this point:
>>
>> longest = 46, alloc_len = 47, args->minlen=30, maxlen=32, alignslop=0
>> available=392; longest < alloc_len, so we set args->maxlen = args->minlen (=
>> 30)
> 
> Why was args->minlen set to 30? Where did that value come from? i.e.
> That is not correctly sized/aligned for force alignment - it should
> be rounded down to 16 fsbs, right?

I could not recreate this exact scenario, but another similar one 
occurred which gave:

/root/mnt2/file_2425:
  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
    0: [0..431]:        489600..490031    2 (131200..131631)   432
    1: [432..511]:      529408..529487    2 (171008..171087)    80
#

For allocating EXT #0, in xfs_bmap_select_minlen() we had initially 
args->minlen=0, maxlen=64 blen=70

then blen -= alignment (=16), an finally condition blen < args->maxlen 
passed and have minlen = 54


Then in xfs_alloc_space_available(), for check (longest < alloc_len) 
near the end, at that point we have:
longest=70, alloc_len=79, args->minlen=54, maxlen=64, alignslop=0 
available=155, and so we set maxlen = minlen = 54

Then in xfs_alloc_fix_len(), initially args->mod=0, prod=16, minlen=54, 
maxlen=54, len=54 rlen=54

And we end up with the 54 FSB extent.

> 
> I'm guessing that "30" is (longest - alignment) = 46 - 16 = 30? And
> then it wasn't rounded down from there?
> 
>> For ext3:
>> longest = 32, alloc_len = 17, args->minlen=2, args->maxlen=2, alignslop=0,
>> available=362; longest > alloc_len, so do nothing
> 
> Same issue here - for a forced align allocation, minlen needs to be
> bound to alignment constraints. If minlen is set like this, then the
> allocation will always return a 2 block extent if they exist.
> 
> IOWs, the allocation constraints are not correctly aligned, but the
> allocation is doing exactly what the constraints say it is allowed
> to do. Therefore the issue is in the constraint setup (args->minlen)
> for forced alignment and not the allocation code that selects a
> an args->minlen extent that is not correctly sized near ENOSPC.
> 
> I'm guessing that we need something like the (untested) patch below
> to ensure args->minlen is properly aligned....
> 
> -Dave.

For some reason that diff got excluded or mangled when I tried to reply. 
Anyway, it seems to work ok, but that's based only on a quite limited 
amount of testing.

Thanks,
John
