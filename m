Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768C42DAFAE
	for <linux-xfs@vger.kernel.org>; Tue,  8 Jul 2025 15:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751987276; cv=fail; b=N77Mzdj8qmVs51lyeZK7RzOYZfgv1jl1JEo254yLrnL2R6QKZp3OMfuzUkgXY724puzJ8Kg/oeJaPlkROjSgi5Wfcl+cDNw17sAR5IkEsPZtPPmDcyjfBBcOH+j11xFu/J/XWoNF1BnA9fuc59cSa9+rn7eWzaspdMl0JXqYwS8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751987276; c=relaxed/simple;
	bh=NsCb5LBT+1cyfu/JQlUZrIqvpVCo+4tJmRurpb2QoqM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tKBMQM1WzQinXp/btauRbvznaVYwsK8scXScHyOqU4STBUvfzqZsrzihFtCMT70UeuK5jGBkI5l/Nj1ZWSXWXiDd1gsUTOJbQ81JDvAd74mrM77C7KrHDthC8sYiGdufQgkY2L+oVv5Pc7eDFF7IbwdTj2dbbRfR7jTcB9Hfnro=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NHznyA1S; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Sy2VRntT; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NHznyA1S";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Sy2VRntT"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 568Dl0Fo008507;
	Tue, 8 Jul 2025 15:07:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=TFFWbB8l+jdHNvePrb8Us+nGFcX5jmy5IRn+tBZ9TTk=; b=
	NHznyA1SXxHal1lktqGvH7RjSMoiH3ij1IVLWLvlPgVMXoJ17CnkX4LermJ0P5MF
	+qAyaw55UYR2DwX9Bs3aoUy1+Yt+2ydwJfsKnk7I19PCHpVDSeEri9u1e9jQnI/2
	XgQJLxYGLH15A/Ral/huRT0ipE6CKn83zspSN26+qVUXRhKdoKDK19tW4Eq7udAb
	snQlrszWR53S0h2YTAugORQETULrHnZSZGurdHnsvhvjpiHsG3wHUq070yuSMusD
	MTBzKRLzY1uAIZsUhb49IJ95LJaD2sOh5jFR17XGcfkAzBerKwlGgAErIIG4kB0a
	EXprbwQ9TxzWnti/8FNGSw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47s4gug6qm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 08 Jul 2025 15:07:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 568EZvZw014380;
	Tue, 8 Jul 2025 15:07:49 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2057.outbound.protection.outlook.com [40.107.92.57])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgagjy0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 08 Jul 2025 15:07:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eMD+xly4zYQTwasecbLX+M4Npoqfk24KrGPvC4qSgrF5PpMKaSD7J4npnCilH7t7HmLcPH5IcorgV8zxHRmDBY/2sMw4kZvMVLuO1IKGdVwZX8u3+Svog2omrv4ef1mu24tjkURA5fjOxoeXRZ7YPFUtbMMVSud89NIEkdiS2SblJ6U1ovkzh22r1ryyCZywhccg3nJBlF9Wns3scRMe7qZ5F4NVmdNz1ueaFWvcNFUh+eTIxzt4sfzt0RnGZxIY1yhYjmpCyOo61eZ0f8GBSkZ6ckaCTFVA64pg+EPwJNVI+4Nav9wnLwAnUyjZur0fLLVNy8O/Ms/7XSj37g14AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TFFWbB8l+jdHNvePrb8Us+nGFcX5jmy5IRn+tBZ9TTk=;
 b=FmbtVt5YOyAz7zSPSyrKKikb1AWaNXQuIeLmqs2EwuF8cAOnOH8jQFJRMY+NUjDArkv8B3fHuT98uu+ynJYJAhgm8qnrJOj04nn7YATEkx8t4ZvSzqj8Pl6iE1+piwlav3WtNjZku7H7O26pD2av2Ih3ieHRJUKqWf9kUyogxbFFP2JdKO1DIpvpdFLGY0GZyV5moy59tN8W0OTpZz07f+L7RNv7/CJGy3tWDYzQ33B3W33yCfJZt09254WGoPeEU3LDvRPrhKxcA2EeVE4nYKzndcY5CUOWR8WKnKv3hNQMsJnWIvMnECSTcV6yzkwwOD6/H3Dq8r010SWYGTw6jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TFFWbB8l+jdHNvePrb8Us+nGFcX5jmy5IRn+tBZ9TTk=;
 b=Sy2VRntTsa6ia5J8rw4aC4U9Ee8YXD2qqxPe93ijN8StaTTsDCIvL0XSitmRgIIvohpCdtlqWGlatjtUwjg3g95Bu27eSWhRQ48DOGzqNkcPgFDDPprcI81JdL5lYwLcsLExkTfRDfU5QfFjXm83qbSGBi8xsRXxfa3KVD07QQw=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SJ5PPF7F7BBD994.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7ae) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.23; Tue, 8 Jul
 2025 15:07:44 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8901.024; Tue, 8 Jul 2025
 15:07:44 +0000
Message-ID: <2ddf1d9a-6d04-48b5-be73-99f2bc3fbddc@oracle.com>
Date: Tue, 8 Jul 2025 16:07:40 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] mkfs: don't complain about overly large auto-detected
 log stripe units
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, catherine.hoang@oracle.com
References: <175139303809.916168.13664699895415552120.stgit@frogsfrogsfrogs>
 <175139303911.916168.9162067758209360548.stgit@frogsfrogsfrogs>
 <874db4d4-2fd9-4f48-afd5-dcdab88ca7eb@oracle.com>
 <20250708150526.GD2672070@frogsfrogsfrogs>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250708150526.GD2672070@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P189CA0021.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::12) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SJ5PPF7F7BBD994:EE_
X-MS-Office365-Filtering-Correlation-Id: 605298a9-bddb-4b2b-fe88-08ddbe313129
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ejlRTG12ZFJxZVYyMENQdGpOTVFyMVJuamNab1Izem9nMjY3WUN2ME4vMFp4?=
 =?utf-8?B?ZzA3dE9OcUh0cXBXMm9EQlNHQkdaY05vdVcwWE1iK1V4QkVvcmFhdUNmeGk5?=
 =?utf-8?B?NXdYbDZkR212U3RZMUt1eEpjL29UKzJBY0ozS20zNWtJcVY1YUQyaTJSQWty?=
 =?utf-8?B?cWRKbXFHc0lFYXUxdGp0QXl3N0NYNVVublFmTWlQUjYrMjZZZzdHS2NvL0xE?=
 =?utf-8?B?a1plY3hyaWJVK1pVOFJpMGtPSFFDUHdLejl0MDdPUVdwUmg0VFNWM2U5bnhs?=
 =?utf-8?B?V2daVzZvb3BweTJxRmhHQk1Gc0JsdW0yUmZvUnovaDJxdVkzeGFlWmFHcVc4?=
 =?utf-8?B?OUFnNXFiZEU5N2E0c0d5VmR0TGRpUmNTTk9teWZZZlVHb0Zna1JhV1RySUd4?=
 =?utf-8?B?Z3pHeFNwelJlWk55ZUU5U0FCR2R4cHU3QXRQSElZWEdoeWZCc1ZEOEVadDlF?=
 =?utf-8?B?dWxJNThhR0xMdjVySjRWbEhwejVNQ0UxTzZyTnpEL0IyMlBway9UaVFVa2ZS?=
 =?utf-8?B?RTFZY0JveXlTSHBNenIvNGpVbHN1ZzZGNklXK3JDTng1cFAyZ1Zaemh0VG5J?=
 =?utf-8?B?TWRLQ3kxNzBqQkhaQitDeFMyeWZ5TEtIUHJMekZVZGpBaUMvdGM3cndWelMw?=
 =?utf-8?B?QVpia3NGOXJqWmJzUkpiV1NBM0dwTzJLSW5SUWIwQmdSWXZMNjlOb1hybloz?=
 =?utf-8?B?VkZ3TFVKSXpoSy84WDltdVJ2aVRBT1F1UmFUZ3JYaURLWC8xNzRDdmZUSWl1?=
 =?utf-8?B?VFJHSUVpczhyRUQrNnUxU0o2dWpFVGRYT2pxTkZadGFDelkxZzVCSVJPY3pW?=
 =?utf-8?B?VWNUU2JiUUg1VGE0ZFpmNWloNUNNWllLb2hCbFE1L3gxQXVIVSs5clpmU2xB?=
 =?utf-8?B?MUhNOTRvQ3NaSXpMZnFMcUQ5U0xQSVFBUytIM3dHNyt6NGZuOEgzckVCZTVO?=
 =?utf-8?B?T3Rwb0d1WDdMZ2Rjb1ZSVjFSSTM5UDZOc0VsMS8xWXBMMFEvZm5lai84NTNH?=
 =?utf-8?B?WGtxb1BLemh6dTJLOVJ3YUxqTk1OeW5QQmtrTkw4RkcrMlBuT1VQSHBLUkU5?=
 =?utf-8?B?VTRwTXpmQzBQQjVyN2pCSm1mQU12SzFNQWw0L2haSVp2NWdDT1RHL001eVFj?=
 =?utf-8?B?cXJJWlhJZmIvTzZ6ODdwTE1DM2ZoRzRNcm01L3VQdVVINWg3ODVNcE04dzI2?=
 =?utf-8?B?RWhRdEdYTFBydjRMbVh3WlZTUzViUTNweWtuVXMrbGc5ejdUdEZNL3JpQkJK?=
 =?utf-8?B?KzZHOTlybVdDMC9SUEY5VGxlZTlQc2lpUWRZNUs1VUhzRExhdWZzVTI4RFE2?=
 =?utf-8?B?QXAvaWt6RDU5ODk1NGVqV2xNWm9kMFdwVkE3N3RCQ01PUkxNRjk4OCtvdjUv?=
 =?utf-8?B?SndCWWNQYitvT3dYVUR0U0RpOVFsMkhkdTlHN3FwZE40SGpkZWNTd3NlTzV3?=
 =?utf-8?B?R0h1RzFTQml2Z0RQMFdScmpKNXVpMVp4Z3lHZ2NPdkUwVy82bFJwb2Z2Qk1Y?=
 =?utf-8?B?ZWZRQTlINnU3d3Z2WmZmTE0rcjVVOGNzSmQxalNGTXZ4MjMyRjErQlNJVVBG?=
 =?utf-8?B?cU13VTh5ak92VkU4TlVVQzk3YXlrOGZab2t0SjlPSlJyZ3ZFd3FOVEdCQkpt?=
 =?utf-8?B?T1kxcTZveWRmbU8ySDBNT20zZFdrL2hoQXZKVVphZk5RQkJGKzBOcm51TWR1?=
 =?utf-8?B?aTJLektaS3UrY29ZaDFJb2pPbmFEQUp0SEswVE1iMitnSlB6a0JUa3EyZmkw?=
 =?utf-8?B?YTJIUTlwQXVxZmJ6Z1d3c2RHZUlNKzdOenVKUTYxS3Fsd25Fa1NQQm41dkNF?=
 =?utf-8?B?WlgrTnVXeE8rUmxONi9iemY2SVQ4RW1pSXZ2dzZKK1JKQ08raDRBZW44YVd2?=
 =?utf-8?B?RGRkYjcxNG9FNk12aDExSWFMN3JKVFBybXB4UjRLVzFCTTl1amJqUzRkd3BF?=
 =?utf-8?Q?9wDVjCgOjZk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S3R5ZmVKdUltOTlqZHY5UnE3ZXFTMk8wY1JQWE5qSW40dVd2R0x4ZnlWUDVy?=
 =?utf-8?B?cUQvZFZXNTRmRFNjbDFjMHgzcDhSMlMzWE8zOEc2UkhtdEF6cFAwdFhGNGJH?=
 =?utf-8?B?N2Q4SjV3M0hHbVZ6QXV6c0hjd1RpZFVKUmdCbDRkOUFSbWZRYkVpcGFDaXJF?=
 =?utf-8?B?K0VxTTNLV2pRNGxiRURRTXpTMG1wRFQ2cWJvNktVRkJBWkdLbGxyUlRNRDNr?=
 =?utf-8?B?eWFsTjlUdW8zM2RycytBU0J0cER5MzNQQWhoZ2FXRUZOQTgwbTQ4UTRMSmhE?=
 =?utf-8?B?TFhKNWo4VTNGRjdwY2R2dzVHTm4xZ2dhZUwrTlNYVmhNQXo5Y2JtaXpCd3R6?=
 =?utf-8?B?NGdabGlQeGl3b3Vlazc2RjZhNTcvZHhJYnVCVWp6U2ZUdWZWWnhNdnJZcEM3?=
 =?utf-8?B?cHQvN0YrZHFUeWgyK1Y2Y1U4OUVJSERqZEZrN3pVcStibHdHR3dKWmdHbTVn?=
 =?utf-8?B?VzM5ald2M2NvV2xTZXVyQUppTVFtQk9TWTI0R3hpZEEwZWFZOHlTSHpiWEZy?=
 =?utf-8?B?dnEwNjhFWEJrRzJqR0JVQk1FcE5sSzdoZDFtUzNTVmpkQnpxc21aRkdRSTBv?=
 =?utf-8?B?YmtkL0VJMXg2bXZUMzUzcnJtNm9TOThGVGpGN1BqOEpPbThwQ3QyRFU3RGJu?=
 =?utf-8?B?WURWMEFEN3F1VTlkWC9TSk9MVVV3Qm8xQktneTR2SFVvZWNsZVNwazZ1ZXlu?=
 =?utf-8?B?TStxdzh1MWVOZ1B6ZVNSajdseHBTRUxBZUREbEhlMWM5SWxJeXlBYWY3Vm1v?=
 =?utf-8?B?c0ZjNCtlcTJMRjhZZXBHZzFWL0gvZ0U4SS92MnVCSUo2UzcyK2VCRzVPZk1M?=
 =?utf-8?B?eTF6VE1IRjRmQlkxU2xjRGZKR21mcm0wRFNKeXNjUXRBQW9VZzhQMk9FbDJs?=
 =?utf-8?B?MWovYnI0K3Rzak4ycUs0RVAyZHZENFh2bmNrRGhyaGppWFZDRUNJeDRiMW0z?=
 =?utf-8?B?aGQyYmpuOHZ6dGs3bzVVZ3ZPTjVXOE9lYkFyM3RpQjh4YTcxOXM0MHBuUjBG?=
 =?utf-8?B?OVRnazhhd3lCNEJQcjQvdW8rVWVOdVdhK000OU1ybTMrTmFETWhoVzF4cHIz?=
 =?utf-8?B?SXFjcm5EazhkQ1Y0Z3NGNU5iWHRTS2xLbFBhMTRMbDZRbWpHRDdBVmhRYXYz?=
 =?utf-8?B?UDhiSjBNV1NYRkhJTVI5b2NtNXpLNTBpUVREK2h0WE9jTWVJL0c1MnQybVd5?=
 =?utf-8?B?VmhncEYzNUJCSTdpeXRVQitaQjZXc25zU096SEd5a0VWN2ZCR2F6YysvekZB?=
 =?utf-8?B?bXFBd1IzYVhMKzlaQTNRcitqZU5Ud01LbnZkNngrTlJ0elI4V1VjM01kaFVz?=
 =?utf-8?B?MHhMYVVWbEUxeSs2bUNyRy9udG1nMlVxSXgxNzR4Q1pyRWJET2loSE9vYlRz?=
 =?utf-8?B?Um5QVmJ4R21UYWhSUlg4ZG5KOUN0ZEFtakdFZU1pejFmMXFRemM0dUZ1T3lF?=
 =?utf-8?B?VFIvOGxnSUZheVR4UkV2eXlEelVlbTJMTkQrbis5NXRwcjlXVXlwTmpYZkl2?=
 =?utf-8?B?YllLWVhuRjY1OEMxUE4xY3dKR3JGUzZUZ0dET2F5L3FkSzFQNDRLRzh3NXV5?=
 =?utf-8?B?c25oa202SXQySE1FNmdHZzdERnlvSkZ6cTFkSEJjV1lGZ1ErZXdOWFppaTd5?=
 =?utf-8?B?Q1ZjMFZvQ0FiSjdvTk5KZlBtQ3FZMTNtbW1tMTRwc09PSlNQMUVnY3JmcDEy?=
 =?utf-8?B?VVIyWmxrakk5QTdFUERwSFBnYndoNm1jNHh0ZU55dVAyaE0wVHFIUFN0VzZo?=
 =?utf-8?B?bEV4dldISUo2dEZYV3NOWkk1TzRCL205VWcxckxQNTR5S0d3eTdTM244RlRN?=
 =?utf-8?B?ZGtiVXVzQzU1dnJQdFpCQUNSZU1Dd1RBWXRzZkxmQmJVaVRBTFN4d0dPQVNy?=
 =?utf-8?B?NWU0VGF2M1duMU83SEU4b1UrSDd4VWI2V0hJL0FxQlBmY241dWMvc3NWSVVS?=
 =?utf-8?B?dFNJakVlTnhIZ2Zmajg0UG1ERWZQakd3ZS92cUhvTmphWHlJbHpKU2xWb29p?=
 =?utf-8?B?Ym4zUlJ3VEp5ZVY4cUxwTHgvRkg3SElrLzg1eHN0UlJ2Ynd6c2lRNE9ZN0dt?=
 =?utf-8?B?RFhNYUFKM2F2alhFTWJmMWFYazcrVUZiZGN0SEgrY0lhdm1lVFIvTmowT3FS?=
 =?utf-8?B?YjdpQU1RTWxWRmt3Y1lBZUhjY2xnWEJUL2VqeHEvcDBWQTY2eXZzM09FeGw2?=
 =?utf-8?B?eGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZXBb/LwrZf1FQAX6DRPd5ENm8ibubOXAT2WlLXHbEta9ucMhpQpSLD7ivXnCwVny2FaxqNtp1WrG5dL3JQ1g9+Aaaga20awi0RK6e4p4aZFUCw/D0W/O1mv1vJJyDP2L0XgW2A0YwTIhGSUBH5C3U4FHmM8dzgjJkRQ0H897k8ryZe+EtmCqIOBHP1vqYptwZ1l5v+22sBj4f1WSMjM3IPJPHMX9rBNp5Fh08nb0pNjSwSxsf61/AjwzGQxGu5PAAOojJq+4OtugQnELAfr85lIK1aIUqLI4PrZeznfpsuQb6UZQSQ8F+nnwvquedF49fKAt8L2CZXPgxn0Sx941Q2V7vqWJMON69EQcsqBtpqCsKw0MLdb6tiWlnExgyd32TtxnaHvwcDoQZBMuUasoL+O1WcM/bKEa7GUG9dyU5uerAnCUniTF28e/4EOa8MrGWRmb2gKClaF2qYcwfLRrLl+nl9TKE83IsjNKmzs1wqqRd93siK5hcZ04kdfUbIa59JSsXlBXE4yd4COAFA7NOwyMqf/La9ksFiQjf5Nz7e87I2/CGUJR5tyoKGWknxkNRaUdHWIOKnvRQP6t/iZKSaM3SsvikB+n0pVl0xp/tJM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 605298a9-bddb-4b2b-fe88-08ddbe313129
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2025 15:07:44.5992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: efZ/7C5JH49QtbxnasGDS2IP9UUrDQ2QtbZmhdp4USuhmMeL4im928/XyBMZ+EIEpm8jqRDS40Az2im7mtV6aQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF7F7BBD994
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-08_04,2025-07-07_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507080126
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA4MDEyNyBTYWx0ZWRfXwHuMdBRVX2wD mUOTRqZ3INPKQH/wbQyW0rE1o0gQ3B3Yuwy6j4Az+TQAWzSqrnKjVKiy+REeqJeYuoF59LpfHcP foJqpzkZjMkrJhZYAsCiog2cEbzc5L8juxQXwVUQrz4woB3jXByhfol+0t68ufW0PM6+dEEuTec
 4xsQIsBA3ELwfbZiAX0+7RSaw232jdavj4UvLacUR6CT4WNdkNYM17NfBu1IuQlRjHBuHw/12nG M76xO15N2e4i3gU+ozWt5qO+EjBEAqhITP9owB6KtqbZX1p6m9xCp0KAKWApp+EX2JxMuk4S2wg QNTIwLwuc4Aixno/XuKn+HmAyRMzpwQlxlik7VwToNMt4d41kJGmwyZR1ZU9H3dd+nuJHhMYlNX
 TvR3uJ+h+uAmnl1C1CCMaQ6qFirYT4MonoWrKLwCAETv0QYFh6E84teOpUZXrNMAQ4KaPAyd
X-Proofpoint-GUID: wBqXz_DZC5CZasQLe861VAkSIphJkbtF
X-Authority-Analysis: v=2.4 cv=N50pF39B c=1 sm=1 tr=0 ts=686d3445 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=RgQDVteOkvV7nbhlF6kA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13565
X-Proofpoint-ORIG-GUID: wBqXz_DZC5CZasQLe861VAkSIphJkbtF

On 08/07/2025 16:05, Darrick J. Wong wrote:
> On Tue, Jul 08, 2025 at 03:38:10PM +0100, John Garry wrote:
>> On 01/07/2025 19:07, Darrick J. Wong wrote:
>>> From: Darrick J. Wong<djwong@kernel.org>
>>>
>>> If mkfs declines to apply what it thinks is an overly large data device
>>> stripe unit to the log device, it should only log a message about that
>>> if the lsunit parameter was actually supplied by the caller.  It should
>>> not do that when the lsunit was autodetected from the block devices.
>>>
>>> The cli parameters are zero-initialized in main and always have been.
>>>
>>> Cc:<linux-xfs@vger.kernel.org> # v4.15.0
>>> Fixes: 2f44b1b0e5adc4 ("mkfs: rework stripe calculations")
>>> Signed-off-by: "Darrick J. Wong"<djwong@kernel.org>
>>
>> Makes sense, so FWIW:
>>
>> John Garry <john.g.garry@oracle.com>
> 
> Um.... is this a Reviewed-by: ?

oops, yes:

Reviewed-by: John Garry <john.g.garry@oracle.com>
