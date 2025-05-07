Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781C54B1E45
	for <linux-xfs@vger.kernel.org>; Wed,  7 May 2025 12:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746619220; cv=fail; b=crvUzP9c8h2jJfrkoFTGWsnhagRv1993cMJiERVPo9hWhT26MWjqfdwUbPjgOUGp4eJT5BjnqyPmB/xHlE3Zg5jY/m2z9yMCIrNg8u4t8cWsGWnxrLDTpCrbt8LTpJaNMsScTSiMaeIjbmNWj6Tpr0D6tQUECj2gx3OSAU9A0w8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746619220; c=relaxed/simple;
	bh=NeQaPrw1RX9w0/YqpnNBGIchPuYXGIOof1m2w5iK5CY=;
	h=Message-ID:Date:To:Cc:From:Subject:Content-Type:MIME-Version; b=ACVdD147BOFJ0Od7LwDpWZCLU74jTQ8OLeoU4e+znVVV2fTq4mltLcF/Unt4MCaqv/y2g7t/qE17nBEn8/FTpASmDUxomdfQuH8PWEp7Jae5LeqIyc4KnkDPLDdtrfjw/gPoL7fb1nlpFb+L6xq6fB8WWX7FAKZcIANm7bsPUHM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=rNqhO0Sv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=y1fn8goM; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rNqhO0Sv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="y1fn8goM"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 547BqHHa030253;
	Wed, 7 May 2025 12:00:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=7s0quVeYjiAXU1UJ
	+LrqXuL+bX0QD/Ianv97qVMRCY8=; b=rNqhO0SvFg2wPluHVC5qL+59RSjeS2Wn
	6BtolUeE27lInMEXu3OY453Arl6uIEGNYIGRcNJBJb86QE/B+Xq7wdquZXZXlNDc
	yvXscFzuvX3oqYacbITSEXWF2004YlqFZO33cxr4R+dNaaW3a7E9AzHw9xSukKdo
	6xEjgRIDfJpCIRhKT3MMhXBv/rn19M8VWsqjwQA0xOp6hNAm6jQmuGSDf4ZKH3h1
	BXky+f4kKyoHB1oP+CohjNLjGfzuIbXqC2S6XwHkgAQo+PT5HTb04Z0LgydiywFK
	gTQ4EfQNhKqq8L359bqN5kFm7AxZheNLg+S4YkLVbpR42O7N4GLiAQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46g71680y6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 May 2025 12:00:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 547AQiOT037556;
	Wed, 7 May 2025 12:00:13 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazlp17010005.outbound.protection.outlook.com [40.93.1.5])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46d9ka2eyw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 May 2025 12:00:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v1ZEiRrVVC7wTtB4IGR/0jlVcsTyVxrhFtomg7hRIop/z/I+FPxhFolPTjBi4oZq4yfR+SGTEozqbCR48nA4R99NhQqTzk+096ctmvrvyM26tXrK5cbmuYo0gTnEEJmgHEI11iWv5fl5sj3lcUp3QSLFxPXWbNar53dqIwaHs5wFTcSFh2RUGPC/wCaND2EqTlG/5eaj2E4P8W/GgCWYSO34KVgqmVtsBHjlsZM9N3ankyoJbzwHH8oqPzyNyU8svzrdUlaB5XCJQMzJR73uIhgHj625gjwNwyS9r/EMtcLF4gVzMAmBbPTww8WTlwvn4gaC+pbx8aEQLZbc0wSy/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7s0quVeYjiAXU1UJ+LrqXuL+bX0QD/Ianv97qVMRCY8=;
 b=FUJPmtxO3y8mJ8eAg47YIMyiFEPWpbq/KJiuVes5nY3GUsZMOVguNlUUUKH9TT/g82/2GNSVzM4yFXFyQ8Kciz/4W+0g4qPZOOlk15Zy6ew0f1yHeanR7vV6SAdATtDiTe9bfmXy6z3UOyY8qmeFKuCcX3YxfhvgdACAmf4wv2YlaVSI52uYkGmXUPJ4+XCXDhkg6GIIqcRxtuNYdfXx47714l7NhxksvKqj3eE6hPrRNjFQpL+BwCzezD0+HtXJiJyQjLlUSUg1yk3FIWFjPSsCGmHw0qm9c2SJsdB93sKgfsxtwUpjZbw8WVqMxAg8BvvN3NLOiqQGfaREOBDhng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7s0quVeYjiAXU1UJ+LrqXuL+bX0QD/Ianv97qVMRCY8=;
 b=y1fn8goM2wgBXrjrRlZSz5oCGsrOVdT+5OF8UWjwSrY2mpx+5LJJLtukssqZ+gD0dS3rF+W2+4dWVoWheN0IaYME26myx3i3SY5JYS38lzSQnc5XfbNkZ9siscabzZuvntHyrj1dTkDFLhIARi3FqdKYB7Mwojbu3ipjd+NyKWQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BLAPR10MB4945.namprd10.prod.outlook.com (2603:10b6:208:324::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.21; Wed, 7 May
 2025 12:00:03 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8699.022; Wed, 7 May 2025
 12:00:03 +0000
Message-ID: <3c385c09-ef36-4ad0-8bb2-c9beeced9cd7@oracle.com>
Date: Wed, 7 May 2025 13:00:00 +0100
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: cem@kernel.org
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org
From: John Garry <john.g.garry@oracle.com>
Subject: [GIT PULL] large atomic writes for xfs
Organization: Oracle Corporation
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR03CA0017.eurprd03.prod.outlook.com
 (2603:10a6:208:14::30) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BLAPR10MB4945:EE_
X-MS-Office365-Filtering-Correlation-Id: 56c954f9-c8bf-43c2-2eb1-08dd8d5eb34c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bmp5Y1ZjOERvcGErVmF0SzNIa21MZVNhMlk3eTJnd3VQaEFaTVRRbHZyNkRB?=
 =?utf-8?B?bnVzMFd0d2dpVmVuQXdGUTlPbjIzYzRmM0xCZ3BqbTFzakFLdDNFQS9VSVdr?=
 =?utf-8?B?dWF0WmNubEVYNFlraU9jM1NYSlRWN0tBM2piTUU5d1ZtaCtLVTBOK3d1L0ZS?=
 =?utf-8?B?ejFqN2N2MExEdHZ6K0ZxOFN4OFVIQ1E5dlpyK0ZGcmNLbnIrdzVOOEVZdUtj?=
 =?utf-8?B?MDNTa2dCa0VYajdQYlliK09kS0tqT2dIaVZPc21aajY0RG5rNkFjbGpYU1J0?=
 =?utf-8?B?VFoyY1A4VHJmeWNwVDlRYjlyUDlhZXFrbkNoZG5sRklKcSszak9YOE1WVFMx?=
 =?utf-8?B?elVaL2tacFVndCtLUklKbkZ5TVVYNmszMFBVc1hwRk53VGFRb3RZV3E4dEZn?=
 =?utf-8?B?eitMVzFsVWVoTWgra0RSQWVOUHBzS1hCSnFzRnVTcDFxSUdUZ1hHUVZyMmtE?=
 =?utf-8?B?M2drZTU2T0o3VGZleCtiTzZzcGcwQXpsVnVnZWI2WHh5bGFNSmdCZmRvelhn?=
 =?utf-8?B?WC8xRm5qbVZKSFFROTRPTjVvazZEMm1GZUZvWThLYXpjTzc4Y1hxblB2SDA3?=
 =?utf-8?B?aW5IM1hscWFPQnh0aERtUlpyZHRhdjVYYW5HSWh0Mk5YL1Q0KzhyamNsNjBR?=
 =?utf-8?B?ek8wbk1TTi9LYlRPdk0zRTlxdmJZK1JvMG9KTWZBVWczejRaVndFRFhpRjBm?=
 =?utf-8?B?K3FleFRzeWF0ZXY3UUdaMTNEeFpmdUpxMndaNlg0cWJKRi8zNjVTVTc3VXpq?=
 =?utf-8?B?LzRFWmlkT1gwMkFlWTZZUUlCS0pOdmNZeGJMY3NIK01ocDlhRWlNSnVsWVpM?=
 =?utf-8?B?NDJRL3FtcXVDTVNwL2llRHFlUGpGWFJwYlI1NGtHMjU0SWI1VFdqK2YweHlX?=
 =?utf-8?B?aitIajVJQmN2SU9HalY3bFZOWnlLbjdoUEF6WEEzeDMyMXF4WXpOcURvU2Ix?=
 =?utf-8?B?ZkIwaXZUckJDd2pFK3BRSGtER3NvOHlsTHN0M3VYMVdndm8yYjhxSFJxbDkx?=
 =?utf-8?B?cVNWdk16TldKT2F6WVZoRUsybFhNT0tIM1IyZ2xhejlma0JjTzk0ZUpBL25X?=
 =?utf-8?B?d3h6R3ltd0dGZ0d4V3ozcFRUMGlZM1ZwQXBodncyT1N0NGpNOXNPaDRwVHp5?=
 =?utf-8?B?OCtlMnBsdE5SazNvOGZyZmk3RDE3b2FnNmEyRHVNdlVZNEdiSEdaL0ZpNHpL?=
 =?utf-8?B?ZFpyejNTbHpYUUY2ZzBDYnhnU0tXSndOZ3l4bm9DZ3Y3dDN5M0t2L2NKVmhO?=
 =?utf-8?B?U0JVTkJqWkpsdE1JUXY3MkZYcTVMYXJFZDlWV2lhaHErSUxSWEJGekhkNFpH?=
 =?utf-8?B?U3Y5MHlaZ01YMWthU1lGUFh2ZjhXRnlJNGpUTlFEUVI1aU5Pdy9XTzBNMFhS?=
 =?utf-8?B?eld0cWt1aGtQZVNzd1h0TVo2YmdYQkdvOFN1SzRzSnpzaW0vbTBzak9URk5J?=
 =?utf-8?B?OXo4eEpKczZTcjFTUFhiRW54bmNEeEdEeEdnd21pUVJIaVNlM0N2UGM4L1lo?=
 =?utf-8?B?MURMQkgxd3pvMjBpY2FUcjEvSExRWUZVbEJzTEt5aHR4djNjaWF1QktCT0xu?=
 =?utf-8?B?TkVWT3piSWw4M3gzTExWci9vQ0hHeW1kR1R1VVpFTittTVphK0RHQ1ZYZEN1?=
 =?utf-8?B?ZjdJdE9keURoU2E4dXBSSjZFdGpVdGJKMU1JVGZnRkdQc2NtSFVDQ1hMRmNl?=
 =?utf-8?B?d1g0YVVlVmZ3ZlVtTDhocDR6Z3hCZ1djNDNpV2dKMWVtb2tXRzU0dWZjYWdu?=
 =?utf-8?B?eC9LZFZ0YjZkb3hxc014U3ovSU5tTW9VeU5xcE84Y0hCemJkV29GOHdUWFVm?=
 =?utf-8?B?TWp1eHM2WHI1V2p5dDZyaVk4akR6STRyMWFmZVdZTTNHdjRRZ0xqdHRSd2Fw?=
 =?utf-8?B?QkZkMGU3bjliYWhuNGt6ZG85ZkVzU1BTdDMvRTczd0dWNGlCa3ZkV2dDSFI1?=
 =?utf-8?Q?kNSkTWLZTSQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?amd5N1A0aXMxTTkwRDBxcTlEYmVZbmlheDRhUjZHdHpKZW1HeEVySld0eUdq?=
 =?utf-8?B?MmNnZkpiRXU4NWxZVkV3NjErQWdZRkVBdnV3Tk9sa3JUek1BR1JUNnFnNkYx?=
 =?utf-8?B?MjU5NEdlVEhkMkVHaFYwUW9vNnd1RGxwV01ZalRhaXA1eCtOQUdoTmk4aTNJ?=
 =?utf-8?B?eHFnd3hubWNOZHF3L3hXQit2QTdQVWlGWWx4SUkvdmV4c1d6UmtKbFRCNGk0?=
 =?utf-8?B?c3M5alFVTFVEdzFjN2hQVi9LK3lwSmNNN1U4WS9Xall4UDdyWDQ0eWQwM0c0?=
 =?utf-8?B?M0k2dHoya3lQN3BhbTcyS2hvcisydlJGbzhFc0xNV0hOcy8xWDMrVXppamZh?=
 =?utf-8?B?bnQ0QWlkbkV1T1ZTcGV3UmYvaGk0elVRVzVObTJKKzh5U3JqeGc5Y3lUY2hp?=
 =?utf-8?B?WkZmQ3VwcUJpZFhjank3SXRnbCtmQjIzYTBFQzhQS1pZMzR1N2lYRkdybTMz?=
 =?utf-8?B?T2Znb0ZLNFRWSGhIT3NnQzhCcnVPcWJjWms2UU1HdndqRFNZOFArQXc4dlZE?=
 =?utf-8?B?U09CTkFqUzhKeVJVN2ZBaUdDak5LbXJiY1EzdjUwZVh2cnNOcWN3cmNUeUs1?=
 =?utf-8?B?aU5XUkFCbFJ4dmFWZW5JNU5acVROaklWK0I4MkUzWnR0R1BTdFErSHdNMWRF?=
 =?utf-8?B?ZVZ0Y2NqbzgvQzNxTUpOVEwyS1JlQnBxS0xLWXM1MXNwYjNqWm5qVE5nWWhm?=
 =?utf-8?B?SFUzM3cwREE0bS9US3pIampJc3VMZW5YSlBXbWp6dUZlak42T0k1YkQrZlZh?=
 =?utf-8?B?T1h5Q1ZORDlvcHF2WkRTLzdnRVZXY3JhbDVRZHdUTGpHTWR3ZTZmelUxMS9h?=
 =?utf-8?B?WFNxb3FyUkoxMEF3Y1lmYm1veVhuUHFPOWNQK0wraEc2Z3E4WXNQbUlwY2I4?=
 =?utf-8?B?N1paTmJYeXlUcGV3MUVqM1RzSEx4aG1MdDlkY2pMamJyakpWT2RBenMwL3lM?=
 =?utf-8?B?ZGlDVzI4dlRGYlBBNHVucGp2ejVEUldFQTJvSHRsc0ZUV2dxajJQNU1aaFZR?=
 =?utf-8?B?OWZqYm9ETDRxRkFKNGk4azlBOFM1ZkFldXdyU3pSTnBCcDRDS0VibDJ1Q25k?=
 =?utf-8?B?RnhoTW1vMkgreitBaHpRcElOK1lTMnIwa0JiMVVhRmw5WnZFU2VkMytHVXFK?=
 =?utf-8?B?NjBEbFVteXhXRUhpV1lKOGFhTUhxTDFLamswclNUanZuSnBMSW5TbG9taG9l?=
 =?utf-8?B?eTM4M1hWQzFyeDQ0THFQYWFEQ1lMMkRuaVpYbHQ0VDJjdjN4MG42Z0ZDS1RW?=
 =?utf-8?B?TDljcWVxYlhEUGhMcHdqTEFnbXVtL1hZQTE3b0tGd3VMenIzQ0lWblB0RTFP?=
 =?utf-8?B?aHM5aGVFc1BCRW94TkdDNkpuLzdmY040ODhpemxTYlpnaHd3WVRNcUxaMUJP?=
 =?utf-8?B?Z1JUVERiM1krdmRQTFVmL3pDejBqazZnbHZDVjNibDc1VGJYNHByZm0zNGxU?=
 =?utf-8?B?Yzd6aVp1azc3UUhMUFd0YXlpajFhWnBLeHFnYmNxSEd1ekJPSEFjYlRSTi9M?=
 =?utf-8?B?dXBJSlRuY3VNVVV3R09BRUtidW80MXlwN0VsRWRDMmlMeHNpaEVwUmo4QVo0?=
 =?utf-8?B?QUtiTDdwSzZaZHJFb3ZIVFczOTh2WmhaVVI2ZSsvVit0TWUwazNVcUdMUUZy?=
 =?utf-8?B?VFpRNnVyVzgybWNjZnlsdE02ODNoeFdFbGZ6YW1yeHN2aDNheVpCdmxjOWVN?=
 =?utf-8?B?cW9FMU8wWis2cUd1TklHTnBZbTRza2IvRHlWbitLZEtWNHYzenVaY2RBbVZ5?=
 =?utf-8?B?ZlJEZmFrVmRyVHNnSWJUNnMwNGhKMTFOK1F2REExY2dZZ3VyYTIydlZPbmtl?=
 =?utf-8?B?NG9NdjVhb2Rjbm5hZFBoWDJBb3dQV0FsTWh2S3NUT1BBSU1PcVJMVGNCcFJs?=
 =?utf-8?B?TFlueGZlSWxBMW5Sb2Urd05EaEJoSXMzZHowTFl0Vlp5ZEpab0ZjNzBBTXBa?=
 =?utf-8?B?Slpxc1BNNHVkMXJ4ZzR2SjRRT1dpTWUrblRGeTJpU0FWU0Y2c0FaMnA5YlUr?=
 =?utf-8?B?L3pEN2d5TjI2R1VzdW1NbGxsMHFjN2k3d2tueE4xOTdnUi9FYUthYURnTEh6?=
 =?utf-8?B?bmxrNDdIbUd0STdNeHZPangzUWNOUzVxb3pXU3Q2N0pGZ3BOdmxFRnN0bWxz?=
 =?utf-8?B?R2NyODEzS0dYMnV3WTNWcVQ5SHFRVUpPQmVWTHFIeXpUbEpkUlVyMmo2SllQ?=
 =?utf-8?B?VHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MPE+jxmSyuhb4PJclvSmflzIgWqQWbRJexoCPsFOk0FTVK8VBzGPfichGBMQ9ateJMMNfETrJDaifQlx/xVGLNdbYzXD8lmB7I1/t7RUO0PVZB44krtTAZOQuYsCakV6c9C8fuDXccXZX0Jt/jQcm38lTahtjB7p3LM+7VrwQ0t2Kre7CUmGEVy8et+6vqT3//3zaV87ydsxsbvWFKipryJscuPZh13mOqwpqiA9ejLU+CJft/GD3JKGVFX0N+F4hmDZWjrHHcE8dbTM6mJ7qm5Z5l8S1UpM5+pAQ1sMdlqjwt2gFJ+mFdpB8aYrGZlR9byMNpakfzfXnooUdXiGEkq6xAiLMEvZBOv34eimdY311Nd3tEkDAim3bFyO4wieFB/t8vcHwbk514IZxdp+j/54YF50hNqPzWE0kcDUrWLTFwIIFuypMhMbjm/jHvlH36GaUBvNAHdOgfBDBEu8S2EmY8kJCH57Du6uauc0MT3ooH2nKyg+pldG5P15rFqHfepSVLAYRalEQpBwcQUrUI0dVaLMwPuNgg/HrWPDFS38B8QD8M1kLdTSKNgPL/yoKx4vAWECDj0U3yG4r8aBJAGgjXPviuBz3NnAzgy9l5Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56c954f9-c8bf-43c2-2eb1-08dd8d5eb34c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2025 12:00:03.2306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3zSPwU35PyRENLhBVNr+1jt//lShm7NynVZrx2YQ7OMsSH6Kuhj0nksHhK8vR7q27sbekjh4cVHO3ALYwTtw9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4945
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-07_03,2025-05-06_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2505070112
X-Proofpoint-GUID: 00JWAevVi45DCodYCStkZWsL4nFgtwfr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA3MDExMiBTYWx0ZWRfXwqERyN9ydTSK 3QMrIJZRveg1frv/0RNreqzo3dZFWKmqobgK0W0KLgsNOwe604FmgInAqFn9BUR5dTg4x+u9KF2 mWC+KjAgPbiQ7+JHUOXLiarguYx4l1KrpT/GxV4ZkHTizOofD1vHTpSgKxikeFSKcNghC0maRmx
 Z7D7VEQPI6oqrM/zodBvdA4Fj1l/9fIU9ZR+IacmHYy0AFWY4BA3PGrSYGAqmmgMnmj+pd5Tv+d 6BPI2y4heglOZ5k5MFHbDw1Vvd8hD7uOTj9OLHyWTXLazVFRZMoS/BAKnKQcHxFUJu6qqxYb9Qa W85ZAhzkUBjw/wBxtnp957pS2QX7+s7j3FwNEjnmJQFN9HevFOmCW+xRN/9JJPIAh+xJzgHCuXZ
 IP/4KBDoVfjcl2Mi/o9NoJJG2HZafiNFUbCPDj8nyxuqBqKvXe1y1/MnBdxjsOXAPWaTEJ7g
X-Authority-Analysis: v=2.4 cv=LKtmQIW9 c=1 sm=1 tr=0 ts=681b4b4e cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=NEAV23lmAAAA:8 a=yPCof4ZbAAAA:8 a=v2unvJR6LPYVcdO3xGsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 00JWAevVi45DCodYCStkZWsL4nFgtwfr

Hi Carlos,

Please pull the large atomic writes series for xfs.

The following changes since commit bfecc4091e07a47696ac922783216d9e9ea46c97:

    xfs: allow ro mounts if rtdev or logdev are read-only (2025-04-30
20:53:52 +0200)

are available in the Git repository at:

    https://github.com/johnpgarry/linux.git tags/large-atomic-writes-xfs

for you to fetch changes up to 2c465e8bf4fd45e913a51506d58bd8906e5de0ca:

    xfs: allow sysadmins to specify a maximum atomic write limit at mount
time (2025-05-07 08:40:35 +0100)

----------------------------------------------------------------
large atomic writes for xfs

Signed-off-by: John Garry <john.g.garry@oracle.com>

----------------------------------------------------------------
Darrick J. Wong (6):
        xfs: only call xfs_setsize_buftarg once per buffer target
        xfs: separate out setting buftarg atomic writes limits
        xfs: add helpers to compute log item overhead
        xfs: add helpers to compute transaction reservation for finishing
intent items
        xfs: ignore HW which cannot atomic write a single block
        xfs: allow sysadmins to specify a maximum atomic write limit at
mount time

John Garry (11):
        fs: add atomic write unit max opt to statx
        xfs: rename xfs_inode_can_atomicwrite() ->
xfs_inode_can_hw_atomic_write()
        xfs: allow block allocator to take an alignment hint
        xfs: refactor xfs_reflink_end_cow_extent()
        xfs: refine atomic write size check in xfs_file_write_iter()
        xfs: add xfs_atomic_write_cow_iomap_begin()
        xfs: add large atomic writes checks in 
xfs_direct_write_iomap_begin()
        xfs: commit CoW-based atomic writes atomically
        xfs: add xfs_file_dio_write_atomic()
        xfs: add xfs_calc_atomic_write_unit_max()
        xfs: update atomic write limits

   Documentation/admin-guide/xfs.rst |  11 ++
   block/bdev.c                      |   3 +-
   fs/ext4/inode.c                   |   2 +-
   fs/stat.c                         |   6 +-
   fs/xfs/libxfs/xfs_bmap.c          |   5 +
   fs/xfs/libxfs/xfs_bmap.h          |   6 +-
   fs/xfs/libxfs/xfs_log_rlimit.c    |   4 +
   fs/xfs/libxfs/xfs_trans_resv.c    | 343
++++++++++++++++++++++++++++++++++----
   fs/xfs/libxfs/xfs_trans_resv.h    |  25 +++
   fs/xfs/xfs_bmap_item.c            |  10 ++
   fs/xfs/xfs_bmap_item.h            |   3 +
   fs/xfs/xfs_buf.c                  |  70 ++++++--
   fs/xfs/xfs_buf.h                  |   4 +-
   fs/xfs/xfs_buf_item.c             |  19 +++
   fs/xfs/xfs_buf_item.h             |   3 +
   fs/xfs/xfs_extfree_item.c         |  10 ++
   fs/xfs/xfs_extfree_item.h         |   3 +
   fs/xfs/xfs_file.c                 |  87 +++++++++-
   fs/xfs/xfs_inode.h                |  14 +-
   fs/xfs/xfs_iomap.c                | 190 ++++++++++++++++++++-
   fs/xfs/xfs_iomap.h                |   1 +
   fs/xfs/xfs_iops.c                 |  76 ++++++++-
   fs/xfs/xfs_iops.h                 |   3 +
   fs/xfs/xfs_log_cil.c              |   4 +-
   fs/xfs/xfs_log_priv.h             |  13 ++
   fs/xfs/xfs_mount.c                | 161 ++++++++++++++++++
   fs/xfs/xfs_mount.h                |  17 ++
   fs/xfs/xfs_refcount_item.c        |  10 ++
   fs/xfs/xfs_refcount_item.h        |   3 +
   fs/xfs/xfs_reflink.c              | 146 ++++++++++++----
   fs/xfs/xfs_reflink.h              |   6 +
   fs/xfs/xfs_rmap_item.c            |  10 ++
   fs/xfs/xfs_rmap_item.h            |   3 +
   fs/xfs/xfs_super.c                |  80 ++++++++-
   fs/xfs/xfs_trace.h                | 115 +++++++++++++
   include/linux/fs.h                |   3 +-
   include/linux/stat.h              |   1 +
   include/uapi/linux/stat.h         |   8 +-
   38 files changed, 1351 insertions(+), 127 deletions(-)
