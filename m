Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40279149C41
	for <linux-xfs@vger.kernel.org>; Thu, 25 Apr 2024 13:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714052055; cv=fail; b=udmttT1CzLCOhp1WRTGKUVV17sIZwzwJFsN1klRqRh88JJtwZyNLahtAuDQEdfnEHuYNS2JppdWlsGtjRLWXVpaPSP6KRgOB4WXOm/I2OxUqPzmNswiwNLozYsoyOq5gz7J8t1R9u6880g0bqVdzNzTGI3DutFgeRoV666zV1wM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714052055; c=relaxed/simple;
	bh=8ORJyoBDjlPvwKYB62mg6+ZluhG86hlBXJ3W821t3R4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XCsJUh/kI8x2qO1OrRziDd6moSnDLrcgkH/4pjgDmdPG15KVwsRlXxbDjUHDykldDHoGUwbBhbnOIlxuIlNw9HXRwkO6BwMnLba/zSTSmNMkMEu87HzrbMSo8P209tFemlj7dSMjeBL2WHeDpfY4SMd8sEvGo0BK70DUxXtLmFA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nRi04tKm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qW+Jve46; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nRi04tKm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qW+Jve46"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43P8wrDm000606;
	Thu, 25 Apr 2024 13:34:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=f1fky6Q6G9gmfROMCw0uv+74pEd3YWM9u6sLWMXAIzk=;
 b=nRi04tKmyp2VbuoBsCbCNCPXiYe6js+qtASX0+MmjnTc4v+o9oxsr8Qv+gM0p+DtENIM
 l9O801v4MmO+RFdrZ4jIsrbbLdFbpFDiH4tTTu5vdqna3ljZCiPeIOVPikwuJ0g3rkph
 wLRY18EJhNiKmFS7zeA7HFxM8Gk0TCpeKEj67nPRQ1HkBcGPvF/Zu7jdDi19GJ5saCKw
 WjE9340o52LW6vFbEhukuetV+Q89QOqj25b1hBLD1zANC+zhStq4Hu5rKqYWG+v4tXyc
 dRm9nNXjmZx5yK9pD7F0KZDRaLdmcFUPHRzuT/6dCxd8WSMA05X3IrSVtz0NJ2TKL/tE ug== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xm4g4jgxd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Apr 2024 13:34:01 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43PDDm5O035535;
	Thu, 25 Apr 2024 13:34:00 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xm45abvwe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Apr 2024 13:34:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WEaJjnBrFCuknOAH3cDjb+Dh/X53okNstGTOR37/BVm+VJyRk/HZAd3y24pTBcNaTYT7hHGjAUIncw+dpR7J3QwayAleXwNtJE9R4GptVth/wpMC+MCYei/a6JinZQrulh4jPM6Dei3FU/xhwiWU4uji1yqF2Y6nau75kYKDsyVa89GgF9fguBcwmku+DXrT7xQ2vNN+8dlB1Oq/Ixzl8igOuX6miHziNeEV87YDqQ6YzRdoPVeXPtv9U36vxDPLn3vXwmmHtgo1/atSXAtTmMm0meAe/jL0tGNB4kxsxr2bkF7371uZYe6jWrbjzB9RjNg4PYRk0N3oQFX7/I1kgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f1fky6Q6G9gmfROMCw0uv+74pEd3YWM9u6sLWMXAIzk=;
 b=KCMiYcHwR8PQ6yyp95f1+brQvqb9zSLdYZjz1vW4eYnrzSM4g6GNjqk1lrnsIC73sFvCHaBauPZACyOolSfelKqnIuogFaD28ZqPGpHOU55WnQODrzAQciPteOJMBgVuW1+2zcHNiUqe/hfvTAzraLoRYrLlU8UMO2ug39LWOMNv1yKyZRviZoChuocoSvchva5B/tKq0wrmpAsOLCWOSGWLNXx/XzvwV1RCQSf3tbqiVjnQLIt7qWx5c5vWIemV3zaRq7PA+QsHgShVRvftd4fwvR9yYRAKo3nes25lo6xbbaRmHp26aTQIJYpdtJnt0cbwpQZKR3agEjFiIa6fHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f1fky6Q6G9gmfROMCw0uv+74pEd3YWM9u6sLWMXAIzk=;
 b=qW+Jve46eHHzj9OqGDWUe5EffhFfHYG9osqSq0p+fHcR25UPdWz/czyz6KCPz/tjrJF5Z+pTZvqPNOf0+ApvA+B4drPCPCiZf8yG0q1yq3RAY7ZJufNcdxC7cr1j185RI7aonFKb5+0VRd0aFyxhBPZzc2sbcv7ciEwENRzCugM=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA1PR10MB7359.namprd10.prod.outlook.com (2603:10b6:208:3fc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Thu, 25 Apr
 2024 13:33:53 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.7519.021; Thu, 25 Apr 2024
 13:33:53 +0000
Message-ID: <9a0a308d-ecd3-43eb-9ac0-aea111d04e9e@oracle.com>
Date: Thu, 25 Apr 2024 14:33:50 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] xfs: Clear W=1 warning in xfs_iwalk_run_callbacks():
To: Christoph Hellwig <hch@infradead.org>
Cc: chandan.babu@oracle.com, djwong@kernel.org, linux-xfs@vger.kernel.org
References: <20240425120846.707829-1-john.g.garry@oracle.com>
 <20240425120846.707829-2-john.g.garry@oracle.com>
 <ZipJ4P7QDK9dZlyn@infradead.org>
 <01b8050a-b564-4843-8fec-dfa40489aaf4@oracle.com>
 <Zipa2CadmKMlERYW@infradead.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <Zipa2CadmKMlERYW@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0261.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37c::14) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA1PR10MB7359:EE_
X-MS-Office365-Filtering-Correlation-Id: b927e090-127a-4f9f-8400-08dc652c5962
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?RnBqY2poZXBFQ3NiOTVWeUdWM3Fqc3JaS2F1dmN6RXNERTZTSHJRckVXa1Zw?=
 =?utf-8?B?OFY2Tkk1aXAraERGdzc1RzMrZXBYYjhNYUhMYVdpV2hQQVF4NmdtRmt0bHIx?=
 =?utf-8?B?SGlJN0pPWVo2YldLQ216ejVlR3VleXgrZTFJM0Y2ang3TW92UTJZeUsrVUNI?=
 =?utf-8?B?YTdNSGpZM2RYOGRIS1RsaFJtQTlxRFRVSUtXa3E0bnpIdmVJMVZwZUVPQ3pl?=
 =?utf-8?B?RWtuNVpYZjVvNmNpMEgvTE84UW5nb1lVTzZ6Sy92dXY4bjFWTEJPVnZ1eDdY?=
 =?utf-8?B?aStYL2o5NjRleUtiZy82aUpkQnVsem8wN1RxWVJUQWlDbWtUUnRUREUzUy9z?=
 =?utf-8?B?cXplcW5yRkFEQkNVb3QyUWZ3V0R0L3V1UG93NG1icjJzL0s0eFNkeFloSC9F?=
 =?utf-8?B?Y3A3RVdFUWJsYXFEQzdiRnpZa1FWZitIOFpKcmxpakVocWZRUDZ3ZnFlNW1l?=
 =?utf-8?B?T2c1K1l1ZVlUR2U2THEwUEl5Ym5KU0pxdkdIb2prRUNJaFRDckkyZU85WUdz?=
 =?utf-8?B?dGw5aWZkYjFjOWRCWVZOTHNQNnNZQWtzUjY1ZXZ1cUZUVEpvK2JJaGxqWXlP?=
 =?utf-8?B?VzBnajN1cmoyd0VPdW9SanlobFdMSHlJTDBJWjJJNk0xeGhCVDZMa0hTS0R1?=
 =?utf-8?B?amc3d2V2a3RJeW5ZNlB2TXN4VWRWRjl0aE5JZWF4MVNsNjdjdDBNdTNQNG5C?=
 =?utf-8?B?dTJaMDRvaWszR2VvanBaU3U4WFRMWEFud0VQMlgwcmJNMFZMSzNKcmU2RHV2?=
 =?utf-8?B?dE5GYlpOdTNVeC82VmtuYWNQRFhxWVhIY0d0dXEzVmR2anI1RUJ1V3RXRk1o?=
 =?utf-8?B?a2M5MVpIMXNhV2NqbllyYXorcGYyeUZvMUpPUUJQVHNBemVxanl3UGQ2Szk0?=
 =?utf-8?B?eXhsQXpIVFhWTW1UOEc0SlVZOXFoSE5lcU91cTAzWU5KNDFCVlNTNGpqb1RQ?=
 =?utf-8?B?UVhDRnM3aTIxUzdVWHRNTVBpOEZlMHFjMmIreXJwSDJLQ0dzcFhwcnJpZFI0?=
 =?utf-8?B?TDhRNE9rY1FuaVBJVXJYNStKTzArM0M3OW11ZHIwM0trT0RCci9pQmFnYm1a?=
 =?utf-8?B?azlid0ZxNzRkanppTWZwNDZ5L1BvMVZ5cGN4ZW8wVFVvR3JvUzlUU0t1N2hF?=
 =?utf-8?B?eUtHblNOUzB6TTJwS08zMUlHWVpaRjljZnlGZTIwUnZtUk9CK1hKOEFCOVIv?=
 =?utf-8?B?VmZtSmhsUGoyV3RvUGNFV3pha0VJNDdRSmRWNndHeExiaXJxTDI1VmdvVHhF?=
 =?utf-8?B?ZklJS3BlSDJKNnJOdnAwWFZOcnROdmFZN0N2YlRReUp5VjlZc0plNURhNlBy?=
 =?utf-8?B?RGxhZXFwd0N3UGRxbWsycXBhL0RaTEtabnI5TFp1RkNla1R2Z2FBajhnUHZU?=
 =?utf-8?B?V2cvVFFmMFJKNVAyYUVyMW5PRFZwZkM1UFFyTFhiVHpwSUJrK0dmS1E2Nkdl?=
 =?utf-8?B?VGlTSTdUMUdJR0w2UWF3TDNSeGpqdSsxYUpEM3c0aWxkNUtBYVVUWDNZczlX?=
 =?utf-8?B?RTQ2b2U3Q2JWL3hHZFk2K09CM1lKQmIzYnd0YitPUnd2OXFXNmFPM083enVh?=
 =?utf-8?B?QlVBNjNrRnNzSFlFMFlUSnpFZi85NjM0eUdZbWtnRlIybWptQ0d1RzlERDhj?=
 =?utf-8?B?UzhMbzJPZXBYNUQwVzZoVHoyRTVjSnVJT0dxaEtYK2JaQndJU1l6UUpTSktw?=
 =?utf-8?B?Z0xCRUlyQUVBa3BpaEZDKzlVOU1jeDdYTWNxUEc2bmJkaUVhdHJqbElRPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?V2FNejYybkNiNk5DS3lGNkJxV2M2bEpCUWc2bzVuR1c0QXJ5L0lFQ0VKMWFZ?=
 =?utf-8?B?YU5aaFZCb1ZnT2NmbWk1RStvK2VKQmFJT2VjaUptQTcvK2trNjVzeFA0VW8y?=
 =?utf-8?B?YVZLaXZZY3cwVHZ4ZkhLSlRPc0x4ZEU4YmcwblQ5U3ZkSlJLWGx3c3J0NjFs?=
 =?utf-8?B?ZjNadlhnSFI0Z2xZYXJnUklGbGdjSHRpbmpSeU1KekV2MkJzZyt5UmNURmVR?=
 =?utf-8?B?b3kvYTZOOVBMN2syVWJ1WlQ5YnJlM2Q1KzBRZEZBYm1aNmJlUSt2NHJFaFIx?=
 =?utf-8?B?OWlnL2xVMmRYYW1Pa0doYUZTWllueFFzVkVmbjdKWmdFeU1xRUQ0Vkx2aXBl?=
 =?utf-8?B?Wk1qUUlyeVdJeUxtZDZ1cCtJQkV4dDRtb3FnMHBJaDJXeUdtZWZ4TGRKQnpH?=
 =?utf-8?B?S1VSV3VoRnZUQWdDbDRZc1poTlFhcG82OFEyTU1iRmRsVG12Q0tsNzNoeVBo?=
 =?utf-8?B?WVgrb0lTMUd5aTN0OWNEaDlWNUo2U1JWbUd3cjRvelhtUjV6ekZHbjhCcXRs?=
 =?utf-8?B?SFk0bTdGSnl2V3NNdHhsMW9IaExDN3pkWDAvSXNyaXdPSWFBL04zaXhCdjFz?=
 =?utf-8?B?cUpPbVJYKzg2RjBoZE1FNm5PRloyM1MzV1h3M1lnaXRxSVVrS0o3Mk1Qajkr?=
 =?utf-8?B?S2oyOUQraUk2QzhXdHRFZ1BOb0hvekZxdWpnNlAxU0ZDRDBoUE9rN1JNVUZl?=
 =?utf-8?B?RENQYU9Oa3RhWVlCdmIzZGc0bExQdTcwV0RIV1Q5enBnYU1PS2FYMjFiVzho?=
 =?utf-8?B?ZHkvb1l6Mkx0WUdvR2pmVldUUHdqUlhHZXRYTTJtMEwyTWhsZ1ZpcWE4QXA5?=
 =?utf-8?B?NDZ6YTFxTUpVTWQ0ZGhCbkZFTTlrMHNFbmdQWG9HemQ3bjJFcjBDMzd4N0NU?=
 =?utf-8?B?TjFVS1pZUTMvZXp0cy9zZFNrQzVDQTd2a3RpeXpEZU5kYUcwQmszZTJqNFFR?=
 =?utf-8?B?bU1IK2tURlpuK0NoS3NoVE5Td3dVc0ZIbHdhNzdRZVVEemJvN1Jadk1ZUEhD?=
 =?utf-8?B?cXhsb0FXdzFRR0VkSUQyRTdHWFEzb0pGcGIxS3VpNkUyMGlxOXUrZGRwWTBy?=
 =?utf-8?B?L0E5dmVaMmZhalg3d3R3bWNwblJRb1JpY3JvOXRTZ3hZVmRmQlFLVUxyRTcr?=
 =?utf-8?B?RDZGRjBJRUd3Rm1oalc4MDNvQ2c2eXFkZ0VCQXp3aWV3aVdaM0dDWkhCS2Np?=
 =?utf-8?B?Y3NTN1doY1VDZnltdkFrZiszOWVFSlNGeERPeVh1TnhzMWRSUVNoZytWVnp5?=
 =?utf-8?B?dkh1Q3pJMGYxOGcrRWlpOURaUzJPRWZRam9helNEb2prSzMwWjNhdFU1cS9p?=
 =?utf-8?B?bUJDT294ajVHMk9GeVJrSnFUcm1CbVJkdjVUSmx6Sm85N0Nmb1k2SGNIT2g1?=
 =?utf-8?B?eER3MWNkQnZ2K2tMckZRYXRzSFlKVFUyTXhsaTRXaGthMkhKT2lHOWo2Uloz?=
 =?utf-8?B?dzZ5V1FFRHlwRVJ3TUcxSTNjaW9wcXNaK2xxVnFnT0NjNHJzeTdBdGl6UTN6?=
 =?utf-8?B?YmNqcnlBcTNzaFNSaVNnbVl6OElRT29JSnEwbFJtSmlnbHpKazN5dklwWitW?=
 =?utf-8?B?cEtiV1o2Szltbks5NFBBdHhJdllFQkgwT1hPRVhCZjFvZDRvSXBxa0Zsa0JO?=
 =?utf-8?B?STd1Sm9VWEtyeTZ0aFRsUEJSUCtEU28rVlIxdzFmeGxWMk5NNXBxUVYxTE1P?=
 =?utf-8?B?c0hiNVIvaWJCbWZmR0lDU09XaUJXVWYyVXdEZDNKYm9xYk1XMmlubzVpZTZ2?=
 =?utf-8?B?cmFzeXhSaUc4RXhzTy9kSzlSYVZCMlc3Rkc5UmZrYWJiaVI2OVllMFdnTUZK?=
 =?utf-8?B?QTBMRG9iYlVKN3ltUGFDNngwZ1N5dk1kQ0plNERTcjA1Vlh2MDNVQVJhN0tC?=
 =?utf-8?B?SEtMck11ZnpTV0hYaXZaQXNDSFlMMndLbEQwcjdrUmRWdlhmcHg4a3F6QTQ3?=
 =?utf-8?B?N3ViYzBjMkhpeG5wanI0WUVSbnFSU0krSzd1QklaMEpuYkdGWi9yUmRLYjFQ?=
 =?utf-8?B?MkdDazRyNkVib3pBcGZHYVhOR2F6Uk5EWTBqdm9NL1R2Y2RsbFcvSFphM2hx?=
 =?utf-8?B?NlVadWFyVHB5TnN2OVhHcU9ZNXFBR2tvNjJWaXF3THMxcXY2aUJkb284ek5z?=
 =?utf-8?B?eDdRdnh5NWlpSFZZWTlIKzlLUHN4MlFNQmpSY3ZuNEQ2YVBubUVwMEVvTlA2?=
 =?utf-8?B?TVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	dsxQz0HVh23sdFZnu5JtMZsdIQauXxRapiV6otLJyc2MDUpgkY76IvWl2jWfaoc06CLFqDzA2e84z6Icu8aD/CCIlFvIfC3J5zXYz/notB5GqfAFHP5J6AReWFQHADIgNBrfqBF1swmyaOVkILaRcD9e4YO7x7UcMsPzxZeDSUJ3UaA5uHNQ78ytoT2ZLD419neEnveav4CBLugL7B5f3cUO6//4fN2hEzZKokCPcFORH6gvHcedqI7Nw5t6trpSPsRaeQyRcigyq7gTT6uVHVAx5AZoWtcXKU2HR48k18nB/9s+8GiDcWZfy5SsUh1wW8ofdyyweiSrdh6kk3Da1xPEvYmn/NvSbWSI0PKT4rQvXYry+2iBFHt1bybiq3fExFYu78hnh4SeLi6JqhuBnGQtJl3jlOH+U2DgpmeRGAlT8BC28UEj8wadfMDkjrsHOEN4DFWXJYLNBkCIbzoRiwQulIl99Sno1FvvZN3GEUuE3nw9raRGG5OeIN/xaRUWIkRqlLIBUj5UxmHqFDAYqvHK32g+vqS+ttYU3VPohwYIl/6xIAWQ7uJazI8xgju7oaJgW6XBJy6yhWlkeCh3JWxWI6gnihc851ngVbVKsuw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b927e090-127a-4f9f-8400-08dc652c5962
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2024 13:33:53.4838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tqErpv0tRq9hTxfN3pr2y5mODs1WL1k/uXhUYqwvo3dXtqfFOGBacL25G1sYQ2RxNCKurprc3akWiW3NdG3rgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7359
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-25_13,2024-04-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 suspectscore=0 adultscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404250099
X-Proofpoint-GUID: 0V2Dbdf7sBrpsE3ps8xI-dzMKjHt3CDq
X-Proofpoint-ORIG-GUID: 0V2Dbdf7sBrpsE3ps8xI-dzMKjHt3CDq

On 25/04/2024 14:30, Christoph Hellwig wrote:
>>> I've never seen code where __maybe_unused is the right answer, and this
>>> is no exception.
>> Then what about 9798f615ad2be?
> Also not great and should be fixed.
> 
> (it also wasn't in the original patch and only got added working around
> some debug warnings)

Fine, I'll look to remove those ones as well, which I think is possible 
with the same method you suggest.

However, there seems to be many more in -next now, but not for local 
variables..
