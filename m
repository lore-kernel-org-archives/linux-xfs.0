Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0181DFE3
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2024 23:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720739329; cv=fail; b=Ruz/2XnOMZNAHbgf1m+qD2k3BSYQPa30KNSE6HAbjK7/Q3y/BloRPv/t68HcHQ5wHGSNbopoR2ZA9TzaLR/y5D8wnYHWTexeI7l8smc4oyo+LqcQm4YQpGBFpnMTEuELbRca78FJZuxXhGiDDnuEai5uqZwx23C+ZeSBiz6LBEM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720739329; c=relaxed/simple;
	bh=MfiYsJBKViLr1QXx3r/g37mKYW0sXTkXPedZXTn6LVk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dLpDR//fFn9Y0icuuYp3c64Yq6hpP//3lL0xH2LrAlGWHTmvYavsEe/AzOOKxs80TLfcBoa3N/x/0SOlJqkJvBsZaB4Vyn7xcaeZtxFpF6/q36Aq9glJx7rE9kX+sUJV+vmPYTmyrZdU9nbFy86dnKyEguy6gJTRaFdm6ZwNJWw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Rp8UqEnG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QvAJ6jyu; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Rp8UqEnG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QvAJ6jyu"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46BKXYJp031415;
	Thu, 11 Jul 2024 23:08:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=corp-2023-11-20; bh=MfiYsJBKViLr1QXx3r/g37mKYW0sXTkXPedZXTn6L
	Vk=; b=Rp8UqEnG3TG2rIAnkm6A1fi69DnjQIUYgyq2DtaH6+TgJTr25RGOqk1Oy
	L/ScAcNgeQcqkHQ6JewA56KJDbN8NImeSnpCooVqZkwXBvsctMwARtKRtDlMUBwI
	y6lZoVJvBEmpqhCQjzExhe7SsVzv3BFpkTMcNjutFWZHYuSadJ1EtlVIAp/q41kH
	w+Z39Hsj13pQ7A7Q2OCrL1+Pj7oK8LUJfFrtjRSyQbKDEAc9knZUnNZ7musiqTqw
	/9dcl/WqxW5q1ux2IFbTxzCDTZJXZX0m2Wyx2CQh/gjbLGVSMGf2wqbrqpsQOOf7
	/GHJF5Ty8yN+VYXkKx1J1fE1QMOJw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 407emt2064-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jul 2024 23:08:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46BLSThs030200;
	Thu, 11 Jul 2024 23:08:42 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 409vvbwget-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jul 2024 23:08:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WqzcrPvfH/8G4duQ3VeOITtjj6v5J8MvHzavjeCrEAeNKGHqUJIqjS/DpAkmqEagJvoXMAJUochsZYRxlZGTuKKGGTL3P5TPgSFLLbBAILl+Y1AdOwx/7DxpfaeWL6RdgktkOoNSRJUYhlwBeF4rAkGnLk+Z5ayEVyYI7h1W9YcCI0r/HWIXPhjZd9/mT2xxy/etwoKgNEj5gqab2mVEDPqb50CHAqMh4ERptSfEWgnZWoBRpUQBN5KEzW7ep2rgioMMF42dooiON+r01qXk91xeLwBkDa4+0O8oTykUkXp8VE70Di1II7uBAsXH2xrYL5IsK/E/qulRtsEmJeIpqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MfiYsJBKViLr1QXx3r/g37mKYW0sXTkXPedZXTn6LVk=;
 b=gwqZlTv211GZvwjLuIu0XEa5xlKS2NMFwPlyRAzh4ZLj/uA/YUzlR9O+xHCsDa6XwWfKlHdxeJPbd8kmIvrU7qF+fdxAp3fzdGmrwZ+ywGU0JiIK3EKxZ8043QUJsRHVzgkowZ+v8EaaGtacWRlzmutf8bqig+oIyjXmFcsoReRi+q4/qrspqlNUKycrOMeTPopT7m1POk1zvcmMfDNx9bZMA8KALVexFiFQFtrh2cFUrz/LmGxPq1ZEQbnDSv5M2GMXI014lfzpdjvSAtqcQ5RGI1HOrzX3g5tJaPVsumqO9Q+NkOl8xIqA3EN83vlS/sa2oa2RCozVsgmbF7V8Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MfiYsJBKViLr1QXx3r/g37mKYW0sXTkXPedZXTn6LVk=;
 b=QvAJ6jyuqp/YVGhVatfMvSxJ7bA7obQinn1b2cSxj06CvSDHVR49pYWWWcXf7pe0tIbsKw8XHR0vcKGMACp5pU6NA5KkbqvYVYwMb+aZSdErVcvqwnMT1/s6jB48SVnCkk4vtALlBOAlpW/+EaepyPFXmgSSYLo/wyCqeQWP5f8=
Received: from PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15)
 by SN7PR10MB7074.namprd10.prod.outlook.com (2603:10b6:806:34c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.36; Thu, 11 Jul
 2024 23:08:39 +0000
Received: from PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27]) by PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27%6]) with mapi id 15.20.7762.016; Thu, 11 Jul 2024
 23:08:39 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 5/9] spaceman/defrag: exclude shared segments on low free
 space
Thread-Topic: [PATCH 5/9] spaceman/defrag: exclude shared segments on low free
 space
Thread-Index: AQHa0jOvs9a6VVD4UkGqqb1BwkJctrHu4wsAgANHCAA=
Date: Thu, 11 Jul 2024 23:08:39 +0000
Message-ID: <26AC6539-FC0D-477D-8BFA-25EFC465794E@oracle.com>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-6-wen.gang.wang@oracle.com>
 <20240709210528.GW612460@frogsfrogsfrogs>
In-Reply-To: <20240709210528.GW612460@frogsfrogsfrogs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5795:EE_|SN7PR10MB7074:EE_
x-ms-office365-filtering-correlation-id: aa1537f6-a9f8-4605-42f6-08dca1fe666f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: 
 =?utf-8?B?TERDdHF4emE5akxzZjY2aXFqZzlTQ0dkYS84ZzlNMDc5QmNBYklBVnR1b3JR?=
 =?utf-8?B?dE12Y1BHUzZtMms0YkttTU9QOXRYNGlpRWhrVVl3OGdoTUNhajN6eTJ0T21E?=
 =?utf-8?B?Ukd2cHlaYVQzMC9yaTZOY0NsbXZ3c2ZNNmZZcVNaRjNxWFE4NnZwWmZzaitu?=
 =?utf-8?B?UG5OaXhGTHlrNStLdzBhYkd4NXFIVXFia28wREJ0Q3prKzlQbW5CNTlOTWVV?=
 =?utf-8?B?dWJyRm9NblZMMTY1dlRVc2RORlVQeGVrSllnYmtRRWRwVVFaa0RnK3kyZVAr?=
 =?utf-8?B?aWowY2lyOEQwajN5VFpycXdCM0V6RE9YT3pIWDNpenZpQnJxK2VUNms0ZkVE?=
 =?utf-8?B?NDhYVnI2RFdMNGZkYTdiQVp0NGJ2bktCU1h3N29DVk1rbGg4L0NGeUQzdExm?=
 =?utf-8?B?TWhwd3ZNOGxyOXVhYStOL0pTVWFOMlBwQmRIbkFCRUNqeWJrOWM1ZngzMmRD?=
 =?utf-8?B?eElwYjEvUDJ0N0E5THR5TkZaWllGUzRwQ0JaM1JQQTVnTGpZcWIrbUthS0NK?=
 =?utf-8?B?QWtQMjAweGFlRVEycWZWYUJoMkd1V3dyM1dqSjFva01rQnZpSDQ1YlhxMEJl?=
 =?utf-8?B?WmplTlNyRkRmRDFhd3REOE54c2YyL2RaOUdoVm0vWXBXM05ENiszbnJtSGJC?=
 =?utf-8?B?MU00ZkYyWnVhOWpYdHhNYWVNL09QamhPOWVXK0VYRkg1cGQvclBMWW9tZ0R1?=
 =?utf-8?B?VzFhNk1VbElTQXBlRkwzWVk1WDkvVS9GbmcwelBQK2xqT0l3NnBSaHFWbkI3?=
 =?utf-8?B?WXZKK1cwK2FjNG9UVUZsbVJlSURRMGRYSC84TXFubDhFQXpBNldvcVVLeXZa?=
 =?utf-8?B?b1FRUFVINkM1V3FoWXBwcHk1UXdWNDdIWlQ3N1UwdDFVRW5LUWJEaFd1NE9Z?=
 =?utf-8?B?QmFaWTRHa3pacDk0dWc0ek1sei9uVk0vK2pLN0loS1dCczF1RExVNG1xby9p?=
 =?utf-8?B?TkdGNVlya1crT3dJMUdKRUhIM1kzbTl0aVNObzNkcE9PTFlWamRQc1k4azZ4?=
 =?utf-8?B?a1AzZVdyWXBMZXhNTTBENVFFL2FIbno0Q2JXVld6VnVzZFNIT3RkVW50eElS?=
 =?utf-8?B?eWFmL1IzakhKWEs1Wkxxdk41YnFtbXc5VjV4VXFWUVBXZ3JrS3kyQStFV1Vo?=
 =?utf-8?B?WHpwaHBiRXhoVTRZWFFBMEJ5SnZ4TWF0TnAzSytyNkRIQ3hjZ2lWN3FjVlNr?=
 =?utf-8?B?OS9nM3h0ZWpJNUJuM09rcHY5Yi9jbEkxeWZheWJxYVREeTFLMWRQYXJaQjF2?=
 =?utf-8?B?THVTSzREb0Rsekd2RjY2UldjY2xvNWlGQTdHVG1GWmJ2akRzUUJIQ1BZMFBw?=
 =?utf-8?B?SGV3QUNlMkY0emJYRDNzSDNaWUZkZnY1Z0RnbXFHNEh4MXZDQUQ3clBVUDNV?=
 =?utf-8?B?djRIdlFmeU16QnY3NDFSbWlnRWVnazgyMHJMTXdveGVzSlY1dG0xV05DNW5S?=
 =?utf-8?B?dkc2UnlzVHc4OVlLQnY0emVjU1hBVStzbUw2V1hFZHdiRHBFSE13STBXVXht?=
 =?utf-8?B?NlFYeHdTNi9LWGlnS2JXWUlYQjJHWmJvNG96UEhHRHJ4YXArbUxyQ0dZRzBZ?=
 =?utf-8?B?OGNheWUyZVBpQW5SdUp2MUZmQ1ZZdWkzYlpRUElmYkRnR0pGU3hqUkxBZGc0?=
 =?utf-8?B?SWhMMy85ZGlkOXdQcEtnakc3RUcyUkRLMUQzT2VoMUVIK25vLzF0NUVHNFRW?=
 =?utf-8?B?Mkt4RU02RFp2OXY0T1FNV3dabmNxakhNOEZJam1UeEFMdWp0MXdpTXAxZGEw?=
 =?utf-8?B?RVpxRFRneGlIU2dzZXVMaEhGeGhuK3dvam1TbWdIQm53SisvdldWdTNyZEtF?=
 =?utf-8?B?N0NXY2tCNzUvZjhUV3k2OFhPTTB6aW9TSGJqTm8yTjZNTnlldGNyaENPVGY1?=
 =?utf-8?B?WDJpZ1Y2V3ZTc2VmRjlSeCtwMnBJRDBEOU1kcE1XU0NseGc9PQ==?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?UjZWR0RaWEVuNEJlWnZUTllCckszays0N2srUm1mQVVzZU83NlBGbUd1OTdj?=
 =?utf-8?B?V3RKTkMxSTlCZEFsWUU2dkZud05pVmVrWkkyQ0c2MWxOWlhBUWJNNTB1Ulho?=
 =?utf-8?B?Qjdyc0NJbjJ0eEhHN3hacHE1MExDK0dKdFlWWlZaSnI2c04yUlRMODBMSXdq?=
 =?utf-8?B?UnN4WlUxY1VPZXZYdGorMVBUQkV1Z2pPYVh1RHRRWTErSEN3UzFpMlJHSkJW?=
 =?utf-8?B?VFJqcU5LeW9yMG9MeFRvRmk4aTRtN3ExRlJWNGx2NEh0blg4SkdxQVlyNmRP?=
 =?utf-8?B?VlhuQ2ZVVUhGdUQyYzVKRTJoZmVUSFR3L3JFYnFPMXg0eklrRGQ5anlNbndW?=
 =?utf-8?B?TGZPUFc0b0lpVENoT1JqVGdOZEZ3RUx0Ylp5QWxpY1duSG52dWtwdmxwU3VZ?=
 =?utf-8?B?RWU2VkJyNkhmVkY2UkYzeXk4eEhXOXdaNjdMSVpFcW1kK3M5VWlVbHNYZWVK?=
 =?utf-8?B?WnpwSFZDR3RqalQ4UmdSbVA3QkNWRSs2OC9mK0xlOExVeTNLY1dWWFVqeHhN?=
 =?utf-8?B?M3h5alk2SUYwR2NmRFpTV0dTZ2dqUk11bFZqanBiYm1DNktVSDN6NzFqeS9H?=
 =?utf-8?B?Ukl1d3IyVFlIYVZ4VVJiWmF0T0hxQ09EcDdWYVhBT0ZzR0ZzK0RNT1U1NDlE?=
 =?utf-8?B?cU5oNmt3YnpTZkUzcm1naEJuLzA1NWxBeE9KNXllVldPOFY0RGtwWDBFSWE2?=
 =?utf-8?B?aVJwTTBGMGFLcVV3dXNaMkhwWU1saTN1Nno3eGZBVy9KRHVOMnlXNEFwU2lP?=
 =?utf-8?B?L29BYXUraEphVFJYc3l6WXRZY0QwbjVLeFVsRERwY0JvLytTenlSQTJIbkRN?=
 =?utf-8?B?VzZCdksyRzlBZmg4TU5iTjZEYW1nVFVvdkZnaDYwR0o2QkVwNFVsRmwzZmVu?=
 =?utf-8?B?UXZzMFdUYUhjUU9nNU1ERlRja0p3UnRnTGdZK0dtL3lFRDlvWVYvSlQ5RUFW?=
 =?utf-8?B?RFVOeFd3TUx3cUliemdQWHI2c2RpTi9SRGtvenRITXhWY2FneHBVKzZwSHE1?=
 =?utf-8?B?WSthMzNzRmwyaHJ4SkF2RUl1bHVZRTlmT2JTUFlTMEs4UklqOVdkTzEyN0lN?=
 =?utf-8?B?cmY2SURNSWV3L0orOVhadDNNdTBFZ1RBbjN6dTlVZnJvdG1GL0pxZDlvZkFX?=
 =?utf-8?B?QldYaysxY0tOWnlyZ0RsMFZTRlI5MG50RXY1RmdlZGFPMGt1K0Z3aG5PMUlI?=
 =?utf-8?B?Tm9CRWtsRmptN1ZOQmpGcWo2aVczUnZaeEVSNmY1am5MdGtEd1hBN1ZRWHpK?=
 =?utf-8?B?SWd5M1BhZUk5M3lGMTdHSXNMWFpvMXFDTFpKZ2xaT0dIY3ZhaTI1eXJtOXZa?=
 =?utf-8?B?T1RCaUgyNHV4ZWtXcXRzVEx5OHlNZ2hiR3dsYkFjZnVTNXAyVFZmTm1nL3BD?=
 =?utf-8?B?eUgwVnpNMUNKbXhkdERHYUdncCsyOEcwZVVVdlA3WWFHcEdHcEdsTTlNMkJ0?=
 =?utf-8?B?aUNaK21mUzB1Q24yQ2xqUEo2bHdVdGQvOTYvQjFpK1ZIR0h1RGtaWThTUmd5?=
 =?utf-8?B?U0NOcmNNbnN0aXJ0dVpZU0lTdkZTakxFTFprcVhOOFJOaWVYNFVpTlA0Z1ZS?=
 =?utf-8?B?dVdad2VCVmdkS3BKajlURkhXWlBZSUZabDM0Vm5SQUhQZUp3dFNLUkdyQURZ?=
 =?utf-8?B?S3VJVTZENG1DZU1TUjk4cWNjN0x6VW1tbDhqcjFkVk1pNEdNR2tOVEJDNDVk?=
 =?utf-8?B?a2M5aVBiWEY1SjFxR3lSanlkb1ZScHprSEROZjJrNkJvWGZ6UmxnMnRDTmFk?=
 =?utf-8?B?R0pKc05Xby80aS9SNFZadENtc3FJYVR4Q3ppMzhVa3BlMnNqK0FkeFJEV0ZL?=
 =?utf-8?B?Y1ZoT09qZDNIRFRZU29ncjBGZGw5Sk4yUDNmU1Bpbkd4L2c2OEJZU3BlQVJN?=
 =?utf-8?B?SFRIRW4xTkxuTVJ6RkFGYVZsT1A5VnpRY3kvc3krR254QUh0VUZGT3JMUHVp?=
 =?utf-8?B?WGpXUjRySXp2dDluU2F6UkxETDhrTmFzYnNjeWdKVXlFZ1I4MEhDdnNSMDF6?=
 =?utf-8?B?VWtvQnZBTFk5V1BmQ1FNUG9SVVVyRHlZTjlLejI4YkF5VnB4eW9obXdKYWdJ?=
 =?utf-8?B?Y09TeXNhSUdxZ1M1dDM4MnVqWS9zK3ByV1FxaGpuTkJNRElNMVJHanVsYjd4?=
 =?utf-8?B?VUpPRkJ1R0kzVU92Wk1HZmZENWVDeXMwMFlUYkZQTTM0Y0t1OE5KSGkzRHlN?=
 =?utf-8?B?TUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D474FEDC98981A418F7EB179F594A308@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	SQ9bsoPe08XCljSxmP2AZcv6sw1uunKtyIh4FuwJKU0umMaGF8fyQCm2tubTDSAieeml+yqxs2nDxoaulQHkbkudGOH0frlFckG8vJL16OEFuUQSaAybRTyB4d8bRqXxfAdv+NhgeLjt6E1VSHpcKD1LrbozzrG/wxoDdndpdTNX1zucBPcTx3OVR0doFQ7z0rXGhNDyhwEoBcCuw8pSbauuzf6pkmlH6PjFGRWRCAQ/5tYpAKT2tjRFhEMJwXL0iG7UWlvu2sZsj6B7bsVxf16xHEQe+RSLkV+s5+Xb8UIuhiIsi60Ajf42t319roAb+DsxX8l42G4rorRRYu+usi7qx2BVBWkeVbPjeRD+nRy/gfPoLvamSrRhlFF9mgTlrcfT2pq4dZ0OZdACoQH3zKrAKWZxB9BpusTJ0OZcbNYmfvIxi4qL7S6z2yj3hqJQkTsrxDDVxWec9fcf83sVgquqxQJ5KiEDEv5bGQqthTM4ePXVH6v1Ziz7Ta9WhM+0+/JtVlBi6rUMhks0To96uX1J2VGcpZuVnQZCBJOMYltrON0brfAphLIR/bxuFzpl/MK9avjV38scHPhsi0LA/SzVms15E5laMp1d1755Zh4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa1537f6-a9f8-4605-42f6-08dca1fe666f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2024 23:08:39.1735
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GZpQW8QrWQYcwIzmNCkYZhKLh2jvC5AGp5fOTl47jKt0t5WQSeSXIcJ6Fs7+XvnIkD8eFtgzLLtJlywY1PbHjIlJZH7LopWZxp8YGfoz1qY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7074
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-11_17,2024-07-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407110164
X-Proofpoint-GUID: MCRXPM_ekrEoFEZOu0ITyoPaFY-F14lO
X-Proofpoint-ORIG-GUID: MCRXPM_ekrEoFEZOu0ITyoPaFY-F14lO

DQoNCj4gT24gSnVsIDksIDIwMjQsIGF0IDI6MDXigK9QTSwgRGFycmljayBKLiBXb25nIDxkandv
bmdAa2VybmVsLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBUdWUsIEp1bCAwOSwgMjAyNCBhdCAxMjox
MDoyNFBNIC0wNzAwLCBXZW5nYW5nIFdhbmcgd3JvdGU6DQo+PiBPbiBzb21lIFhGUywgZnJlZSBi
bG9ja3MgYXJlIG92ZXItY29tbWl0dGVkIHRvIHJlZmxpbmsgY29waWVzLg0KPj4gQW5kIHRob3Nl
IGZyZWUgYmxvY2tzIGFyZSBub3QgZW5vdWdoIGlmIENvVyBoYXBwZW5zIHRvIGFsbCB0aGUgc2hh
cmVkIGJsb2Nrcy4NCj4gDQo+IEhtbW0uICBJIHRoaW5rIHdoYXQgeW91J3JlIHRyeWluZyB0byBk
byBoZXJlIGlzIGF2b2lkIHJ1bm5pbmcgYQ0KPiBmaWxlc3lzdGVtIG91dCBvZiBzcGFjZSBiZWNh
dXNlIGl0IGRlZnJhZ21lbnRlZCBmaWxlcyBBLCBCLCAuLi4gWiwgZWFjaA0KPiBvZiB3aGljaCBw
cmV2aW91c2x5IHNoYXJlZCB0aGUgc2FtZSBjaHVuayBvZiBzdG9yYWdlIGJ1dCBub3cgdGhleSBk
b24ndA0KPiBiZWNhdXNlIHRoaXMgZGVmcmFnZ2VyIHVuc2hhcmVkIHRoZW0gdG8gcmVkdWNlIHRo
ZSBleHRlbnQgY291bnQgaW4gdGhvc2UNCj4gZmlsZXMuICBSaWdodD8NCj4gDQoNClllcy4NCg0K
PiBJbiB0aGF0IGNhc2UsIEkgd29uZGVyIGlmIGl0J3MgYSBnb29kIGlkZWEgdG8gdG91Y2ggc2hh
cmVkIGV4dGVudHMgYXQNCj4gYWxsPyAgU29tZW9uZSBzZXQgdGhvc2UgZmlsZXMgdG8gc2hhcmUg
c3BhY2UsIHRoYXQncyBwcm9iYWJseSBhIGJldHRlcg0KPiBwZXJmb3JtYW5jZSBvcHRpbWl6YXRp
b24gdGhhbiByZWR1Y2luZyBleHRlbnQgY291bnQuDQoNClRoZSBxdWVzdGlvbiBpcyB0aGF0Og0K
QXJlIHRoZSBzaGFyZWQgcGFydHMgYXJlIHNvbWV0aGluZyB0byBiZSBvdmVyd3JpdHRlbiBmcmVx
dWVudGx5Pw0KSWYgdGhleSBhcmUsIENvcHktb24tV3JpdGUgd291bGQgbWFrZSB0aG9zZSBzaGFy
ZWQgcGFydHMgZnJhZ21lbnRlZC4NCkluIGFib3ZlIGNhc2Ugd2Ugc2hvdWxkIGRlZGVmcmFnIHRo
b3NlIHBhcnRzLCBvdGhlcndpc2UsIHRoZSBkZWZyYWcgbWlnaHQgZG9lc27igJl0IGRlZnJhZyBh
dCBhbGwuDQpPdGhlcndpc2UgdGhlIHNoYXJlZCBwYXJ0cyBhcmUgbm90IHN1YmplY3RzIHRvIGJl
IG92ZXJ3cml0dGVuIGZyZXF1ZW50bHksDQpUaGV5IGFyZSBleHBlY3RlZCB0byByZW1haW4gaW4g
YmlnIGV4dGVudHMsIGNob29zaW5nIHByb3BlciBzZWdtZW50IHNpemUNCldvdWxkIHNraXAgdGhv
c2UuDQoNCkJ1dCB5ZXMsIHdlIGNhbiBhZGQgYSBvcHRpb24gdG8gc2ltcGx5IHNraXAgdGhvc2Ug
c2hhcmUgZXh0ZW50cy4gDQoNCj4gDQo+IFRoYXQgc2FpZCwgeW91IC9jb3VsZC8gYWxzbyB1c2Ug
R0VURlNNQVAgdG8gZmluZCBhbGwgdGhlIG90aGVyIG93bmVycyBvZg0KPiBhIHNoYXJlZCBleHRl
bnQuICBUaGVuIHlvdSBjYW4gcmVmbGluayB0aGUgc2FtZSBleHRlbnQgdG8gYSBzY3JhdGNoDQo+
IGZpbGUsIGNvcHkgdGhlIGNvbnRlbnRzIHRvIGEgbmV3IHJlZ2lvbiBpbiB0aGUgc2NyYXRjaCBm
aWxlLCBhbmQgdXNlDQo+IEZJRURFRFVQRVJBTkdFIG9uIGVhY2ggb2YgQS4uWiB0byByZW1hcCB0
aGUgbmV3IHJlZ2lvbiBpbnRvIHRob3NlIGZpbGVzLg0KPiBBc3N1bWluZyB0aGUgbmV3IHJlZ2lv
biBoYXMgZmV3ZXIgbWFwcGluZ3MgdGhhbiB0aGUgb2xkIG9uZSBpdCB3YXMNCj4gY29waWVkIGZy
b20sIHlvdSdsbCBkZWZyYWdtZW50IEEuLlogd2hpbGUgcHJlc2VydmluZyB0aGUgc2hhcmluZyBm
YWN0b3IuDQoNClRoYXTigJlzIG5vdCBzYWZlPyBUaGluZ3MgbWF5IGNoYW5nZSBhZnRlciBHRVRG
U01BUC4NCg0KPiANCj4gSSBzYXkgdGhhdCBiZWNhdXNlIEkndmUgd3JpdHRlbiBzdWNoIGEgdGhp
bmcgYmVmb3JlOyBsb29rIGZvcg0KPiBjc3BfZXZhY19kZWR1cGVfZnNtYXAgaW4NCj4gaHR0cHM6
Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvZGp3b25nL3hmc3Byb2dz
LWRldi5naXQvY29tbWl0Lz9oPWRlZnJhZy1mcmVlc3BhY2UmaWQ9Nzg1ZDJmMDI0ZTMxYTBkMGY1
MmIwNDA3M2E2MDBmOTEzOWVmMGIyMQ0KPiANCj4+IFRoaXMgZGVmcmFnIHRvb2wgd291bGQgZXhj
bHVkZSBzaGFyZWQgc2VnbWVudHMgd2hlbiBmcmVlIHNwYWNlIGlzIHVuZGVyIHNocmV0aG9sZC4N
Cj4gDQo+ICJ0aHJlc2hvbGQiDQoNCk9LLg0KDQpUaGFua3MNCldlbmdhbmcNCj4gDQo+IC0tRA0K
PiANCj4+IFNpZ25lZC1vZmYtYnk6IFdlbmdhbmcgV2FuZyA8d2VuLmdhbmcud2FuZ0BvcmFjbGUu
Y29tPg0KPj4gLS0tDQo+PiBzcGFjZW1hbi9kZWZyYWcuYyB8IDQ2ICsrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKystLS0NCj4+IDEgZmlsZSBjaGFuZ2VkLCA0MyBpbnNl
cnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPj4gDQo+PiBkaWZmIC0tZ2l0IGEvc3BhY2VtYW4v
ZGVmcmFnLmMgYi9zcGFjZW1hbi9kZWZyYWcuYw0KPj4gaW5kZXggNjFlNDdhNDMuLmY4ZTY3MTNj
IDEwMDY0NA0KPj4gLS0tIGEvc3BhY2VtYW4vZGVmcmFnLmMNCj4+ICsrKyBiL3NwYWNlbWFuL2Rl
ZnJhZy5jDQo+PiBAQCAtMzA0LDYgKzMwNCwyOSBAQCB2b2lkIGRlZnJhZ19zaWdpbnRfaGFuZGxl
cihpbnQgZHVtbXkpDQo+PiBwcmludGYoIlBsZWFzZSB3YWl0IHVudGlsIGN1cnJlbnQgc2VnbWVu
dCBpcyBkZWZyYWdtZW50ZWRcbiIpOw0KPj4gfTsNCj4+IA0KPj4gKy8qDQo+PiArICogbGltaXRh
dGlvbiBvZiBmaWxlc3lzdGVtIGZyZWUgc3BhY2UgaW4gYnl0ZXMuDQo+PiArICogd2hlbiBmaWxl
c3lzdGVtIGhhcyBsZXNzIGZyZWUgc3BhY2UgdGhhbiB0aGlzIG51bWJlciwgc2VnbWVudHMgd2hp
Y2ggY29udGFpbg0KPj4gKyAqIHNoYXJlZCBleHRlbnRzIGFyZSBza2lwcGVkLiAxR2lCIGJ5IGRl
ZmF1bHQNCj4+ICsgKi8NCj4+ICtzdGF0aWMgbG9uZyBnX2xpbWl0X2ZyZWVfYnl0ZXMgPSAxMDI0
ICogMTAyNCAqIDEwMjQ7DQo+PiArDQo+PiArLyoNCj4+ICsgKiBjaGVjayBpZiB0aGUgZnJlZSBz
cGFjZSBpbiB0aGUgRlMgaXMgbGVzcyB0aGFuIHRoZSBfbGltaXRfDQo+PiArICogcmV0dXJuIHRy
dWUgaWYgc28sIGZhbHNlIG90aGVyd2lzZQ0KPj4gKyAqLw0KPj4gK3N0YXRpYyBib29sDQo+PiAr
ZGVmcmFnX2ZzX2xpbWl0X2hpdChpbnQgZmQpDQo+PiArew0KPj4gKyBzdHJ1Y3Qgc3RhdGZzIHN0
YXRmc19zOw0KPj4gKw0KPj4gKyBpZiAoZ19saW1pdF9mcmVlX2J5dGVzIDw9IDApDQo+PiArIHJl
dHVybiBmYWxzZTsNCj4+ICsNCj4+ICsgZnN0YXRmcyhmZCwgJnN0YXRmc19zKTsNCj4+ICsgcmV0
dXJuIHN0YXRmc19zLmZfYnNpemUgKiBzdGF0ZnNfcy5mX2JhdmFpbCA8IGdfbGltaXRfZnJlZV9i
eXRlczsNCj4+ICt9DQo+PiArDQo+PiAvKg0KPj4gICogZGVmcmFnbWVudCBhIGZpbGUNCj4+ICAq
IHJldHVybiAwIGlmIHN1Y2Nlc3NmdWxseSBkb25lLCAxIG90aGVyd2lzZQ0KPj4gQEAgLTM3Nyw2
ICs0MDAsMTUgQEAgZGVmcmFnX3hmc19kZWZyYWcoY2hhciAqZmlsZV9wYXRoKSB7DQo+PiBpZiAo
c2VnbWVudC5kc19uciA8IDIpDQo+PiBjb250aW51ZTsNCj4+IA0KPj4gKyAvKg0KPj4gKyAqIFdo
ZW4gdGhlIHNlZ21lbnQgaXMgKHBhcnRpYWxseSkgc2hhcmVkLCBkZWZyYWcgd291bGQNCj4+ICsg
KiBjb25zdW1lIGZyZWUgYmxvY2tzLiBXZSBjaGVjayB0aGUgbGltaXQgb2YgRlMgZnJlZSBibG9j
a3MNCj4+ICsgKiBhbmQgc2tpcCBkZWZyYWdtZW50aW5nIHRoaXMgc2VnbWVudCBpbiBjYXNlIHRo
ZSBsaW1pdCBpcw0KPj4gKyAqIHJlYWNoZWQuDQo+PiArICovDQo+PiArIGlmIChzZWdtZW50LmRz
X3NoYXJlZCAmJiBkZWZyYWdfZnNfbGltaXRfaGl0KGRlZnJhZ19mZCkpDQo+PiArIGNvbnRpbnVl
Ow0KPj4gKw0KPj4gLyogdG8gYnl0ZXMgKi8NCj4+IHNlZ19vZmYgPSBzZWdtZW50LmRzX29mZnNl
dCAqIDUxMjsNCj4+IHNlZ19zaXplID0gc2VnbWVudC5kc19sZW5ndGggKiA1MTI7DQo+PiBAQCAt
NDc4LDcgKzUxMCwxMSBAQCBzdGF0aWMgdm9pZCBkZWZyYWdfaGVscCh2b2lkKQ0KPj4gImNhbiBi
ZSBzZXJ2ZWQgZHVybmluZyB0aGUgZGVmcmFnbWVudGF0aW9ucy5cbiINCj4+ICJcbiINCj4+ICIg
LXMgc2VnbWVudF9zaXplICAgIC0tIHNwZWNpZnkgdGhlIHNlZ21lbnQgc2l6ZSBpbiBNaUIsIG1p
bm11bSB2YWx1ZSBpcyA0IFxuIg0KPj4gLSIgICAgICAgICAgICAgICAgICAgICAgIGRlZmF1bHQg
aXMgMTZcbiIpKTsNCj4+ICsiICAgICAgICAgICAgICAgICAgICAgICBkZWZhdWx0IGlzIDE2XG4i
DQo+PiArIiAtZiBmcmVlX3NwYWNlICAgICAgLS0gc3BlY2lmeSBzaHJldGhvZCBvZiB0aGUgWEZT
IGZyZWUgc3BhY2UgaW4gTWlCLCB3aGVuXG4iDQo+PiArIiAgICAgICAgICAgICAgICAgICAgICAg
WEZTIGZyZWUgc3BhY2UgaXMgbG93ZXIgdGhhbiB0aGF0LCBzaGFyZWQgc2VnbWVudHMgXG4iDQo+
PiArIiAgICAgICAgICAgICAgICAgICAgICAgYXJlIGV4Y2x1ZGVkIGZyb20gZGVmcmFnbWVudGF0
aW9uLCAxMDI0IGJ5IGRlZmF1bHRcbiINCj4+ICsgKSk7DQo+PiB9DQo+PiANCj4+IHN0YXRpYyBj
bWRpbmZvX3QgZGVmcmFnX2NtZDsNCj4+IEBAIC00ODksNyArNTI1LDcgQEAgZGVmcmFnX2YoaW50
IGFyZ2MsIGNoYXIgKiphcmd2KQ0KPj4gaW50IGk7DQo+PiBpbnQgYzsNCj4+IA0KPj4gLSB3aGls
ZSAoKGMgPSBnZXRvcHQoYXJnYywgYXJndiwgInM6IikpICE9IEVPRikgew0KPj4gKyB3aGlsZSAo
KGMgPSBnZXRvcHQoYXJnYywgYXJndiwgInM6ZjoiKSkgIT0gRU9GKSB7DQo+PiBzd2l0Y2goYykg
ew0KPj4gY2FzZSAncyc6DQo+PiBnX3NlZ21lbnRfc2l6ZV9sbXQgPSBhdG9pKG9wdGFyZykgKiAx
MDI0ICogMTAyNCAvIDUxMjsNCj4+IEBAIC00OTksNiArNTM1LDEwIEBAIGRlZnJhZ19mKGludCBh
cmdjLCBjaGFyICoqYXJndikNCj4+IGdfc2VnbWVudF9zaXplX2xtdCk7DQo+PiB9DQo+PiBicmVh
azsNCj4+ICsgY2FzZSAnZic6DQo+PiArIGdfbGltaXRfZnJlZV9ieXRlcyA9IGF0b2wob3B0YXJn
KSAqIDEwMjQgKiAxMDI0Ow0KPj4gKyBicmVhazsNCj4+ICsNCj4+IGRlZmF1bHQ6DQo+PiBjb21t
YW5kX3VzYWdlKCZkZWZyYWdfY21kKTsNCj4+IHJldHVybiAxOw0KPj4gQEAgLTUxNiw3ICs1NTYs
NyBAQCB2b2lkIGRlZnJhZ19pbml0KHZvaWQpDQo+PiBkZWZyYWdfY21kLmNmdW5jID0gZGVmcmFn
X2Y7DQo+PiBkZWZyYWdfY21kLmFyZ21pbiA9IDA7DQo+PiBkZWZyYWdfY21kLmFyZ21heCA9IDQ7
DQo+PiAtIGRlZnJhZ19jbWQuYXJncyA9ICJbLXMgc2VnbWVudF9zaXplXSI7DQo+PiArIGRlZnJh
Z19jbWQuYXJncyA9ICJbLXMgc2VnbWVudF9zaXplXSBbLWYgZnJlZV9zcGFjZV0iOw0KPj4gZGVm
cmFnX2NtZC5mbGFncyA9IENNRF9GTEFHX09ORVNIT1Q7DQo+PiBkZWZyYWdfY21kLm9uZWxpbmUg
PSBfKCJEZWZyYWdtZW50IFhGUyBmaWxlcyIpOw0KPj4gZGVmcmFnX2NtZC5oZWxwID0gZGVmcmFn
X2hlbHA7DQo+PiAtLSANCj4+IDIuMzkuMyAoQXBwbGUgR2l0LTE0NikNCj4+IA0KPj4gDQo+IA0K
DQo=
