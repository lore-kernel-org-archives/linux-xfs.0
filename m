Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7727B2550A4
	for <linux-xfs@vger.kernel.org>; Wed,  5 Nov 2025 08:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762332778; cv=fail; b=AelH3wIPMBNnmV5r0HwmVtTsosG8taH+RzobvSNLZymgpgggPiAEIDq4KTnlcMLifNz0Mlm7xoqnxpt5SSSVxNM27vfl5bB24HsbzwaXX9EpYmMda+cVt6aHhFhAXXkoSEv7FGa9i2AfVxOZGpmJG2b69keJMGuzKkOJm5m66Fg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762332778; c=relaxed/simple;
	bh=3SpC4/ILGL03bc2lLucim9lGq2GFppgNGwMswMDI4b8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=avUjTMlQ3VGddjJDytSDa47WPh+o9I0UJ2F3N7OyLt8dtrG3WbGk4PCJjAtTOlmGokgKFH9dJiVLeMdN+ORK7n3Cd6DGlemHJ9nNJksOHUTfyTna5K8Z3NFhIdNsOF20/H8A3ZY2pBCBFNjC2mRus2mhudU+hA2n4SU9SFQfk3Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BGfa9uCk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SnznmWfH; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BGfa9uCk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SnznmWfH"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A58Ecxp020334;
	Wed, 5 Nov 2025 08:52:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=E6M27hQsA34N2db97rvwkBo+yOPYxk6ipZaJjPzkP5k=; b=
	BGfa9uCkqAdm0usHPoxJGkwz7rj7p/zw9sTaiDIlEHUrWp/iKaMP70rdJFKI+dqv
	1lhbWaHzeic6GLioz/QISbnLSCXcHIfLxWsMarTB2Y7pRiarhd2Re/hu1nsVwx0m
	so0BGwqMqA7/g4OJhU5ws33dZ4yY7fiH7BcyIpEKfz4cJwB6DXimEvfOubm0i79f
	8YrbQVuLv5JRZXSL72uLS7raRraDmSQ11HsFMhDCb5VG9CFrNu7spL8L8VQUb/A9
	JQul/W0PSaLBO/1ZV6yr2u8w7DQZ/a9g+N8BNjZ3gpO9YwcirlipCtmElu6h6Z7M
	YgQgmgdApbmk3ZepUF0TIw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a82w3r26v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 08:52:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A58OULJ005115;
	Wed, 5 Nov 2025 08:52:44 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013070.outbound.protection.outlook.com [40.93.201.70])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58nafaun-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 08:52:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b7mldpSDYGiel2rgbDlDYL5ZV3tecavAS327SVxL6hPNALGdC1OEvuKn7oPKBpxCADBJvqxF2J42teYx3hvj2/ad3Z43GTkvn469IQ+IE6n5nLQXLq7Kv8IiVAV72FMe8cBqszJ3yEPgvfU/7TyUjXHRCkoO1Yi8y22Z2EIkcUKDVayZYq3TVMiqxuTsbR9dcNNrBJDGG8kshFcgjOjMLn85KK1devpONYTv+3LP6/o1hOiBCxXLs5EoFxudf2CiSM1PeEQrC5ehfbqUR2j8r2A2Sru4WgFgnqmm1RoaYfvVIUP/e8/+lPHa7BwfioJGNRxX0BECfIFPymr6jP/8Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E6M27hQsA34N2db97rvwkBo+yOPYxk6ipZaJjPzkP5k=;
 b=Ta4DvHZZ0AKikmnnZh1dDlP6p+VHUFmZfSzbeTX7eWCR27FBJt0f1m+yYUTBPlV/DL7GNIfNSfo03MoQPtdodq5syRMHJertxvyyKqn4g9Uo2gxCt/HF/Rpl8MOwLsnC4uxdZSVT+Xg/UxbQQfg8F9+eK+dBHYmPDjXUfrDT6zTb6/A4Q9IUGp600Jx+7wpgmFYg/b2BNZrVQp4yzZtw/akMmY4vj6PtL1fy4e08cGzSNyYKj/Rl6uLSlEvJmK/iMZoKKGwtnj1hBePTs7CQFHU0GHAEv4F6ao52zA7cquV0CjXY8zMqtzhV5yVug50aSmcgWPcyGnGOuK4rfQla6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E6M27hQsA34N2db97rvwkBo+yOPYxk6ipZaJjPzkP5k=;
 b=SnznmWfHrew19LFaqE8UKyE/veA/5jW9FLa2rzGqt6Qu8bC5SyXKhDLArFkaTj2UzyYYZvOBayT2AevCcQu0jknQ7xdNfyzqk6M1hWZ/10CLvqC1hYAvpYlCMDv98MRdkvCWabwn3gktfBqJEK/E/YxD0xHIVDxfGvfQiNwNFqM=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by DM4PR10MB6133.namprd10.prod.outlook.com (2603:10b6:8:b4::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.16; Wed, 5 Nov 2025 08:52:42 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9298.006; Wed, 5 Nov 2025
 08:52:42 +0000
Message-ID: <c5cff4c3-cf0a-47cc-9ae5-20d7316b3c09@oracle.com>
Date: Wed, 5 Nov 2025 08:52:40 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] fstests generic/774 hang
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "ojaswin@linux.ibm.com" <ojaswin@linux.ibm.com>
References: <cmk52aqexackyz65phxgme55a3tdrermo3o4skr4lo4pwvvvcp@jmcblnfikbp2>
 <20251105003315.GZ196370@frogsfrogsfrogs>
 <mx6gzhhkvcdnadmmxziu77cuywq4ql5u2hp6fd673vorhx35pz@jmyv74f236ka>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <mx6gzhhkvcdnadmmxziu77cuywq4ql5u2hp6fd673vorhx35pz@jmyv74f236ka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0515.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13b::22) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|DM4PR10MB6133:EE_
X-MS-Office365-Filtering-Correlation-Id: 67188dea-9334-4aa8-5edd-08de1c48ae41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S1BGOTlYUmdkU3NZU0pmMEdxakZjK0ZjdDF5VGdCR2c4MUk2RWViS3VGTzVv?=
 =?utf-8?B?QTJvbWx6d0tkZmR1TW14ZHl6bkM3d2U2MnNreHJSbDRJN3I5ZTJQQTRWMzNM?=
 =?utf-8?B?MzNYSXJUM3E5V3hJd0FmeDh5QWhPT3JmaElnVzJwYnJCWENQWVlVUzAwOU00?=
 =?utf-8?B?TTlJaTVGNHNhWWluQ09uTFRpZ1N0K1BGdzJhRHVJUFRRTFlqRktBWmtrZlRF?=
 =?utf-8?B?a2xta1pqMEgrYytjR3l0RExuRUJWU1FFam1TbW11ODJWaCt4KzJ0VUZ0YitP?=
 =?utf-8?B?NlBYallOSU40d1R2dmxzbUpCUWV4SzcvVjRlRnVCWC94YUw0Q1dGWWM5ekg1?=
 =?utf-8?B?QS9IV3pWTEJRNFZlUnFpOXJHanoyZjZ2YUR3bXpldmd2SDQ3N1RyTkh0aGdC?=
 =?utf-8?B?MEFjOWtueXFUMGZyRmlsZGpuVVFYLzBWME1ENCtJL0M0MlNCc0RYV0QwRHVU?=
 =?utf-8?B?dldrMGlXb3RwcVdXb2NoRk1WRXFqelV1cGN0cndMb2NRcWYxZ3hpL25RYTBO?=
 =?utf-8?B?ZmJSektsa2tNb1U2R2FBb0JUL0pCMEtqaFVZRVhZaTFqbmJCVUUxemdXTnpW?=
 =?utf-8?B?ZDBSdzMyR0hnbmlTYTJ1VmFZOG01emVhbXR2UCtSTEZjZE9OcXEwMUVNMm1I?=
 =?utf-8?B?aXJoWmpUVVBBVndxa0V5QndYbkRUOTVaUUpncXY5MGZXeU02TEswS3ZXVUl0?=
 =?utf-8?B?dnZGeEtlWGdKNFIrU2N0UkNwOXJZeDlySGZKL1FNeDV3Q2NMbWJ2WjRBMHJQ?=
 =?utf-8?B?SG1nQ2hMTi9UcG92RzR2WjE3MVQ4R2FCNzBJT2JJSDFNZ2VKbnBldEhEbkVW?=
 =?utf-8?B?dlRiVTJpdzQ0cmhqNm84Qm1SaXJmYmJPYkVsRk5qc0dYaGlrbEk5UCtRUVoz?=
 =?utf-8?B?NDRHTkFyY0VUcUxjOEhoUzhrSXd0dkZzcTBYQnMxeFFnL3RRL2xpOGFTeEtq?=
 =?utf-8?B?ZFppemdIYXllaGtEQTkvQURQajRGdmRldURRbG5RUG92S2xYU3I2bHhNN2l1?=
 =?utf-8?B?M3FiL1cySGliV3F3bXRPWWgrcUZwZFJ5dVhJVlVldE04eU15enJtNm9Va1Fl?=
 =?utf-8?B?ajdHMDF0dnFzNkxqZjJ4VCt6dE9TdlFvaER6OVdZem1yaEQ0SmZoUm1tMnFB?=
 =?utf-8?B?UGdtVVNtWVh4SU44SDNXbzBhRnFRMDBTeHBJbTVOOWtHejFqMFcyRFpxNUZJ?=
 =?utf-8?B?bXltMXF0S05UNitubXBqS0xrSEgrOWVNNFpSR3lnV2pib1ZDbmRhQUIxbzF6?=
 =?utf-8?B?UmxBV2tZOG01TzBYWE81V2NsWXMwZWFGWEdTcjZ6dGowcDdMUEE1R1ZhU0VD?=
 =?utf-8?B?NmJLeEZkOVpKRVRLYUJrZlBvVHEwTWt5S1lQMjhvYlY1aTRqZVJPOVZQMElt?=
 =?utf-8?B?SG9YNS9vMVVJeUpBY2hZYVNnVE5Cd25VMHo5UWQzWHRKdUhHbnNtY2lybzIw?=
 =?utf-8?B?aGFySUFaU2VUVndLZ2tuY2kvMmV3dlFmZFRxbEQ1NzA5dk9qT1UxQ0paOFRF?=
 =?utf-8?B?dXRORlRDS1RoVnpoeVUrWGxEbm8rMlN3NFlITWtDQzgrSTBYZm5kZmNFU1Jw?=
 =?utf-8?B?YUc0WkhuWmw4MU1BbjBtYzVoYXhkQWVZVzNWaVZmNFU5N2lzcEFuR256a2h2?=
 =?utf-8?B?QU5sWUliTUpoSi9VODNtaXpWQ0gzWjF4WWFuWGY4U3V1OU5BU01QR3pNalhn?=
 =?utf-8?B?cnlxY2dkc1o4QWU5OWVaZExYU1IyTUM5dlg2eHBadmNLcnNvRGJWcUdkZ1JK?=
 =?utf-8?B?SGNJeEJLMW95b3FydktBcVRobzBST1piRCtxb3FrejFzVDZyaCt4NGx2ZEU1?=
 =?utf-8?B?N2JkOHFkVE1PUnJZaUdJZDBZdnRUTGZrUzM2NGZMVVo1M1ovbVdta05sVmRi?=
 =?utf-8?B?TVNMZCt1SVM4WVlXK05YWXlWU1JMRnVITmplV0laVWxCaHd3RjFnczRWRGxm?=
 =?utf-8?B?cnM4bjkrMXp2QzVEQmxMM1FSNURUYm90ekxhNmFIajdpbENFZ2VDNG82dzZh?=
 =?utf-8?B?a2g3VlhzRUdRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TFlMcmFZT3RIT1JuVC90dktuNldmdWlWd2U4TGpLTTNiTXIvM1E4cGdudWt6?=
 =?utf-8?B?c0toU1pBQi9aUFM1V09RMURTOFRIU2wrZGorZGlKM0RFMngxTDJUVVZFQkFl?=
 =?utf-8?B?a2R2aDZVeU9pdHlIUk1admw3S1VudlJSRS9VT3hyR0ZYd1BMd0hBbmNFWFhl?=
 =?utf-8?B?V1RPSFFZQ0xmMnJaUkhQR3ZnbWg4YzBNVi9aeGxLN2ZoalR3RVlvWFlWMEV0?=
 =?utf-8?B?YmpNTnJuSURoMzVvejg0NmFLV0tSS1pNMGRYNXRhUnhMV242R1prd2FZY2J0?=
 =?utf-8?B?bkJ0RnpLZ2VZamg2STg2YlNPc2xheHpBMTRnSXZreEI2ZlpEdDE1NkY4cVh2?=
 =?utf-8?B?RlFaSGQxQ05wTktVaHExRC9kaFNLLzRRVm9ISm9QSHFjd3F6ME5SNnFXODRm?=
 =?utf-8?B?WUwyUzBRWkpOWUVCRUMwMFBuMlROY2pCaDZUakxGSHRYRFlrTmZEcEpUZW0r?=
 =?utf-8?B?elUzY0NXVXhOdHB2SXdvQ0VlS29yZnh0TmExS0x1elBtOXphRXh1TVhzZDdT?=
 =?utf-8?B?N2ZOZzR0RHU4aUZjaWxiY3hyL2lvdTl5aUZLL1I0dFo1a3JTUEJtM0FWcERY?=
 =?utf-8?B?TENwbU95OXY2ZTUyVHhMcmM3VDZSUk5reC9NMy9md2N1VWh2R0FLUUFHSnZn?=
 =?utf-8?B?T1Rxa3F2SEYxRjlQVFkxbGROeTkwWUJBZ3llVlBMY1d0cDVLNjR5cDZud05q?=
 =?utf-8?B?cE1rbHYvdDc0Z29KdGJSWjZldjI3WFhmK3lHcDBjVzBJZ1hkcDdVdU9UdWk2?=
 =?utf-8?B?UlVwWUlYYWZrZjl2VWNTM2pXR0d5THRkWDcwMnY0QWVaVFMxNmU2UjFjamJM?=
 =?utf-8?B?a2lVcmMwYlE4aGlRQ2doYW9IeGFpTktYRVpPQVdVVW9mY2N1YmpsNEhLMk41?=
 =?utf-8?B?MExJRFlSQ3p4eVR6UXcvbXQ0WVJNZ0pXZmwrQllORGQwT01UcFlwVlB2WXpO?=
 =?utf-8?B?SlJqdFRGbVM2Sm44NEZLSEU1RER3QjBNNXBkRVg4NUZiKzBwRFlLWXJ5Vkls?=
 =?utf-8?B?K2lHbmRCQlNjdkNiNms1aTdVWmJvSExrSCtBbVFhbkJwcXUzMFJjS1MrYTY1?=
 =?utf-8?B?alJJRGZXWVNjT0dadlZDZkJnSFczT3Z4VjBCMmprTktnUHEyd1A3R1k1SmM5?=
 =?utf-8?B?bXZ5YjVIQTVvbVg5QlRMSkV4cWZDNlNTd3dYcUNUa3BRc0ZxT1YxWDBEV1J0?=
 =?utf-8?B?WjlxVmpuK2YramZKRXZvaEpNSC9MbHJmVGpUU3ZtV3Rvb2VqSmE5Y2ZjV3Az?=
 =?utf-8?B?aEJnZ1lLWnNsbCswQTFSaTFSbnBxZ29TM3Fubm15bHROdGg2SUN3Q2lKdmlD?=
 =?utf-8?B?ZUJlTEMyVXdDbFBYNERjMVVIL1RkVm5HWkQxWmZlWWVtdVZpTWRzSlA2L2Vo?=
 =?utf-8?B?a0RydmR3aU5HV0x6SDNYM3dtVWpEWG9sUXJoS3FPMUtmNHBSeGxyQnFQQ2xL?=
 =?utf-8?B?L1hKbnNmTk93aHNBalVoUzRUa1UvRW1zZHh3aXAvMlhLOTk1Q3Rud091YUlJ?=
 =?utf-8?B?QU5xNXEyZk84WkhJNmllNUdYbEhzb1NmaEIxRjU1WGJsSHhvK29kandEWWla?=
 =?utf-8?B?VEUwYysxSlBhdnd6c2lITERUSDZLNkwrTlY2TFR5R2hQRHhBVjd2Z2d0R0k5?=
 =?utf-8?B?aFM5TXZSZ210bjdQaG9zbVdBc1pCK2VkRi9HYlUwZHRaSGkwNG15L2MwRW5o?=
 =?utf-8?B?VStYNW05U2F4VnVOV1krek5CN202UUE3SXlWWHhYdHBtL1lFbENvRWJkU2JN?=
 =?utf-8?B?YmhJWlFFSkRYYzVtRTEvL2xGRDBJYnRmSm9tMnh6WlMvakxqQWdaZkN4enBy?=
 =?utf-8?B?MEo5bE4vSjhuNzVUcW00VDlzZGlnZkRDMnBjMVJnSXZONE0ySDlCRGU1NGp1?=
 =?utf-8?B?T0lqODB2TitBRzkycHRpaDNYa3kwUVQyQ2NZeGp1eTMzVmJpMXdWeEZqR3hu?=
 =?utf-8?B?NUNzRlZabmpJN2pZVmN3NGxJbW9oOUJuQlM0TnQvczkvQ3NIUDhKUjliWXNR?=
 =?utf-8?B?RmVFeUpsUDdsWGlDWHlMYVNzc3hTVG9pL3NGT3pJZ2VhQlJ3NlEwWENrWEZF?=
 =?utf-8?B?VkduNXA0VUNCM1ZJMjJQRXhnYmt0YWdhcHFlSzM2RlQ2dGM1ZmZNVDZ6SWJP?=
 =?utf-8?B?VW42Sk5OWXBwQlY0ZkNNVDF1NnQ3YUFnWmVoZTNBZldTOUdESUN3YklWeVJi?=
 =?utf-8?B?OEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NjpBqQO15qpr0GM/IVzFnzMmf7AcYDE51n+tTR99ZhrEnASC28EW3lGFFJx5YCUsrEFopvtKshxm2i+0PpGpGg2Jxmn7LQlCHHgTbcRQEZKUZ2a0dJlalXsgeOMS3SjVCZaEpBKYCa2AASEHcj/Wxq7AyON68/R9TnsEui5saeQrhfNXtS0EfabwgtqU3Qj8Jl9VdEDR5x5pwRlbHoR+S4BN1NtNBnbhW8zvXiQyw9QWRyQmwsUKvyTqGjpuAQlZ1dqoSMJIlnCmcWOyGLDXsW+SRNFqSI95P+HShMLd89zRD+nPdSTpgzQlfUs480yq2ouE1Lw80VPIC6Azl93mUwhCaU3cxgEIHDfEWUlt0zNkNDUQ4yWiigLA35px4yFGR7STH22HeLWmiaKGysG/UMBcsb+i5LqDYNcjIBgl2qbo3KzG+/CsxC0uACz8KByK44PEOQA0KGo6umIVTNBjB7gjC3Gx0AQbE6Pi7dDMMbjfErTttViKodiII1YYIhpcTXyAm8j+6c1SfysOfkRXPkrQYqVneqHykj3BlitfrgifKfJu/GAojGIvA/aPpox2GvmyG1KfPBlCq9v/8UMz/Q46UlHjefMoIN2kivcK/B8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67188dea-9334-4aa8-5edd-08de1c48ae41
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2025 08:52:42.2483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WwXplooGfYwKYhQ5L6witbc8nvx+9TrjuWdIxv++8L8aFqXKIul1ZopnZ9a+/zVYMk5XNnI3A4tSWI9D8Ds/BQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6133
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-05_03,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511050065
X-Proofpoint-GUID: OYiWvv7vkm41Wr9bMs-ciVR8D-FPatKe
X-Proofpoint-ORIG-GUID: OYiWvv7vkm41Wr9bMs-ciVR8D-FPatKe
X-Authority-Analysis: v=2.4 cv=H8/WAuYi c=1 sm=1 tr=0 ts=690b105d cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=Owm6y2r-UPiDGhgCO7kA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDA2MCBTYWx0ZWRfX68NEZHzPMvy/
 wvoX/0GI1KC/mMYZG7HHx82tMjeHC8a4lihfZEloSGw5ePIofvPRAq+/1IStR8Oxqv8wU5+Eks7
 ygDPsMiU5KopV15rTABeNS71rDxR9JN0k0h/SQFAYZt4AGipHamtpqXOrEgN4pkd56fldijLxMg
 8YUFhCnXlKPBmTJgLW6yKYtj0CeNGSjRtUfeXrf23AAVHGrzfgSSPNSBpmKPbSI316DAGbld+1Y
 K/VjZqcKalVuLjZu1GF5qePz8d3EzYoNIMC8SDNMv61ghIceFWlr1Mm91OeSvy1DTDq7XEVeiYJ
 gTGWv5wHNtSSTCVsYwcAEhWvB1UMsmRDDKTla3atUg4RjAmw997g0u6F78HZ2T6w16JCVhNSH3m
 +P8p+NVorJ7L2dFEB4BlDhbONT86/Q==

On 05/11/2025 02:19, Shinichiro Kawasaki wrote:
> On Nov 04, 2025 / 16:33, Darrick J. Wong wrote:
>> [add jogarry/ojaswin since this is a new atomic writes test]
>>
>> On Thu, Oct 30, 2025 at 08:45:05AM +0000, Shinichiro Kawasaki wrote:
>>> I observe the fstests test case generic/774 hangs, when I run it for xfs on 8GiB
>>> TCMU fileio devices. It was observed with v6.17 and v6.18-rcX kernel versions.
>>> FYI, here I attach the kernel message log that was taken with v6.18-rc3 kernel
>>> [1]. The hang is recreated in stable manner by repeating the test case a few
>>> times in my environment.
>>>
>>> Actions for fix will be appreciated. If I can do any help, please let me know.
>>
>> I wonder, does your disk support atomic writes or are we just using the
>> software fallback in xfs?
> 
> I don't think the disk supports atomic writes. It is just a regular TCMU device,
> and its atomic write related sysfs attributes have value 0:
> 
>    $ grep -rne . /sys/block/sdh/queue/ | grep atomic
>    /sys/block/sdh/queue/atomic_write_unit_max_bytes:1:0
>    /sys/block/sdh/queue/atomic_write_boundary_bytes:1:0
>    /sys/block/sdh/queue/atomic_write_max_bytes:1:0
>    /sys/block/sdh/queue/atomic_write_unit_min_bytes:1:0
> 
> FYI, I attach the all sysfs queue attribute values of the device [2].

Yes, this would only be using software-based atomic writes.

Shinichiro, do the other atomic writes tests run ok, like 775, 767? You 
can check group "atomicwrites" to know which tests they are.

774 is the fio test.

Some things to try:
- use a physical disk for the TEST_DEV
- Don't set LOAD_FACTOR (if you were setting it). If not, bodge 774 to 
reduce $threads to a low value, say, 2
- trying turning on XFS_DEBUG config

BTW, Darrick has posted some xfs atomics fixes @ 
https://lore.kernel.org/linux-xfs/20251105001200.GV196370@frogsfrogsfrogs/T/#t. 
I doubt that they will help this, but worth trying.

I will try to recreate.

Thanks,
John
