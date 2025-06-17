Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F19A5383;
	Tue, 17 Jun 2025 10:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750155538; cv=fail; b=Rs44kM9pYCawjUwyauYB70UogJx28nxJjnfvDnaeZQhYJ8lgQnRCzicO+ATPEDpGHMHws/6IVIklLBopvgeZ5UsL4YeUs2bb1CXYrzJGaM47PKfQ/yzsbUO+OM5ku46krvJVzVLDbSKOaINGv8QUOdxjBvhsePolYjU7K/9skWU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750155538; c=relaxed/simple;
	bh=rY77mS2KdLSvySszoLITCutgSVojYuIoIIGRvIHIgH8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IMqPqyn156PTt0HZagm4xDODUaG71uyjaIqNdV0mxayf+HiQ0WWcCqysyI+O+tLwoP4ixma8+hg55Jl0uiDIi4HbUXrTv+8wSQ3Ht3dEYSdohlbETLHuswkkqwG6COkSbwS/8LOVL48RdeinY+iMPwl1EDtUgn/v0qjqBizhFSg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IhcwTgZ2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nOFVp7aH; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IhcwTgZ2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nOFVp7aH"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55H8tbub000451;
	Tue, 17 Jun 2025 10:18:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/JFTAb7CmEi6v+OQQOJCHuQ6+vEl5tBc5KE5xn7nZlc=; b=
	IhcwTgZ25dvPUmR2QL0FIBsmSJYaMHAsYmG+GIJP5NIbx9bmNnhsBYLPr5b+FjP6
	HjQWew4K+mkjSdH4tM42PaVyzDUqx4cv8/wsgGrE+Db8ms9aOPWNVN9BaaT0e+Yt
	xLm3/otVHV4Y9ur9DhDFo6/aYy6eKov1xutlWfJ+JkzWym7QThCLAnTAMmQ6pAnP
	zwDSjcP3ouBFbp5eOoW/Hwxy/yZEFkJp5l2LQcJ0sC7hh5VncrPRru4hlmXTNHGz
	8y4bqD4lGBw2G7ZizEwqprsmp7BlXf7SodahgSE+s5Qbqthem9lc9M/xNCgkq9RZ
	ytx5FsMOetMTCChlXy/8nA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47b23xrey5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Jun 2025 10:18:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55H8MYYF026029;
	Tue, 17 Jun 2025 10:18:49 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11012029.outbound.protection.outlook.com [40.93.200.29])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 478yhfa8q3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Jun 2025 10:18:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=avC5WjAisbdoM8Zp9sysyxFKDCRcSWi9PnIzVcA1WglEqBUI1P/m8DDxxkkuDpTOnvEK8iYcZJbWiM3fvr6XroUdax5zwRsu6D19E3szii0mMDo1knqFpv642hWBc/ehH55XA1raJGSiqg1IXKbKAVn0J0XjBAgiAGFHvuqYVu4LtaZWBvwrthORs58rowd1BnSDhhYngepaM4fADACDiReaH2Y053M1/kLMhpsrUQBDDYz8y3epqUEBwJ1e7ehh5+kd2Xvof7pZRPQRLTphlbgciP54Zi9u2A35qIpVppL0x7A0Kef9tVL2Uya2e91/CdEKhxJbRfEYcAIITrHHPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/JFTAb7CmEi6v+OQQOJCHuQ6+vEl5tBc5KE5xn7nZlc=;
 b=vWlfHSl+wYx/tlSoQylVykDU6gSqkb2m3XP3xIXiBAY/rG0HoGT6AhVtRHZw+NzvxcFeBzQpVGLdju7mb20AN8J1aVkRhfRnXX949BXkF03DNCEAOhXRmFH4rMbRz2WN9E6Fa8aTWUzvtz37YvT5urUu64CRv4xyYTKKuieUraqj4s4VCgddoDhG9aO6LWpJvmWRXXHqDknBxJ9hSXCLqFhNSsHR8Ke8IcluMXfRPP+KXCpuQ5A3Ndez+cvzuu3b9uMmRdeOyBgxqNOSMKKXAmEyIdbGvostLOqrFlq3JG+d3pLbOn/zzBsSEc3egUMDD2m+hMt6QTHKd8gnsb19RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/JFTAb7CmEi6v+OQQOJCHuQ6+vEl5tBc5KE5xn7nZlc=;
 b=nOFVp7aHoYl222wLvIqA/oAe7G8344FwXldn9riyv96CA8kFfSDdxr+18dUG8lWv+Ha2XjPR4gYcMWpNLR+t27v5X9W4Oy6VZJ8E4dXRJiGbPzHkT1JH6d2eiijceQhHSUP5vqts/uTQF7qGDigQbgitaZuEfTkkITL0O8C/QpA=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA1PR10MB6076.namprd10.prod.outlook.com (2603:10b6:208:3ac::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.25; Tue, 17 Jun
 2025 10:18:47 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8835.027; Tue, 17 Jun 2025
 10:18:47 +0000
Message-ID: <6d96c8e5-e3cb-419a-a04d-5002273a330f@oracle.com>
Date: Tue, 17 Jun 2025 11:18:42 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/3] generic: various atomic write tests with hardware
 and scsi_debug
To: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Cc: djwong@kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com
References: <20250616215213.36260-1-catherine.hoang@oracle.com>
 <20250616215213.36260-3-catherine.hoang@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250616215213.36260-3-catherine.hoang@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0657.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:316::6) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA1PR10MB6076:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a2f7753-ca30-4c48-bc31-08ddad88585d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aVJCV290MDJVOVo5ODZYYnhRSTR2dE1OM3VtZ3FSNWtFanVTOUVwbURVSDln?=
 =?utf-8?B?ak5mWkNybWJnelJ3N3Y1OTUyaDdXNkoyT3dzelNRSUQxNDd1S0I2Ynk2ZDZR?=
 =?utf-8?B?WllWUVVsajk3OTdQUGJjUDRYT1RNTjhRN3RFL2JQMTRDYktsNXRuZlhoeEVF?=
 =?utf-8?B?cUsxbFQyVHBUcU9KSDVDZEpPbXRBWDRwYm5MV0RLV09XM0JPdlF3SlRyTG02?=
 =?utf-8?B?TjVMYlh2NlFDN0czaGR1UXdDZWZzb0NSLy8xR3FocFJGQmFUTlgxb3dUTFcz?=
 =?utf-8?B?TUlHZ0JxOEM2eGtuT2d2WUJML201TmZ6eDNFWS9iNzVSK2NVSnAveGJSb2lu?=
 =?utf-8?B?VlR2RjFuTXo0bmtmZWRzZEQ3bFAzZzRaY3hzZWl1KzF4bXBiNDI3azJzOVdF?=
 =?utf-8?B?QzdZNS9lazdxRk1pWkFTdCtPb3kxdWIzZXpRbmlOdkNSNGZmdlNCbzBOeGVX?=
 =?utf-8?B?QVNvUzh6ZXRqdXJwdVB4UU1yelQySi9VL3h0bDZwbGZSMDF3UlNaRmlSUzF2?=
 =?utf-8?B?Sy9TV054dEZMQ3Z1VTVZTXRiWEpDSVdPeGR0RW9pZVRsQjFqc1NyUnVKQVlU?=
 =?utf-8?B?QTZmUWtYNWxLYVIyeEczTzBoRVZWdDJDMUhINVVIZ0svd1pwMldzR0hUU1U3?=
 =?utf-8?B?VG4wMG8wcW83VXpwVjRmcWhydE9ZVVhrLzFCWDRNZHNqT0FPUGZtSFlCTzZJ?=
 =?utf-8?B?Q0VDVDdNSTJFLzdleE1OcUQ3VkNQOFVwWWIxeWJwYnk1dVVaMXFweFJ1dWF3?=
 =?utf-8?B?N0tvdWZxRE1HYkd2MXRPQ1cwL3VoNUxQVlg4OFhjNEVIbU04cXNiZ0lwR0kx?=
 =?utf-8?B?SGdneE1CYWhqWHA1Q3FkNlE1SG15NkZDRkFDaDNOVEZMbGt4YU1LTExCZzJo?=
 =?utf-8?B?SFpxSVFFaG14QmFIa1NGeURaRllYbHo5MHc3RXM5L3N2MW1ja2pKR0RCdXUz?=
 =?utf-8?B?SUpxYkdhY3NxUlhoU1NnWWZ2SkduOTUxQ1NqRmdCK0dGR3c4Qndqd09FV01K?=
 =?utf-8?B?Q0tPSlZRQmhHLzVKVk1sR21BSU5KRlZ1S1BIa2xRdk8zd0lYM0dockJKNGlZ?=
 =?utf-8?B?MnpzdjhWYTNuUTlEamZOaVREZC8wNnduUTIwTU9KZ0MvcDN6QVBUR2xrZlRv?=
 =?utf-8?B?Zjk0TE9pd0kxSTlYcW9ZbTdWYnczVk1ZR1ZFbjJ3Qi96RjRZeVBJRmJUQklQ?=
 =?utf-8?B?YnlYQTR5TEVuSTFZS2tBaE5uOVJ3RmhWanZBQXh5cTBTWjFJV1ZpYTZVWFBp?=
 =?utf-8?B?RzlSeVl1VFYrNDc3Z1MzdGVCdUwvamg4eTJTc1BCMUcwUDF2S0ZLak0wemJM?=
 =?utf-8?B?bHdRb2hVUGx1NzNPZW51aURVbElrRmlDZEJpdlk3R0FKd0I5ejJwNjFQUm1F?=
 =?utf-8?B?cXowbWpBVDlZUDAvdWZyZVNRd2Z2MWs3ZGorYk1wV0VIVCtkVWxvNmJJeDFp?=
 =?utf-8?B?OFhRRldSVHM0TmFBOTYrT2VLN0NlS0RpcmhlcUhKL2taRFpZcm1PRDZIaklE?=
 =?utf-8?B?bU44eGNiS1FVdVU0U1kvQnBadDRKcTBGTklPWFhkL1RuTXpIbFA2bUg0U0VB?=
 =?utf-8?B?VStNZE5qbDVOdUZyaitYcjBCVUtZZ3RqOTA5emlFN3NDdjBkREtGaTVRUGtl?=
 =?utf-8?B?bm1hL0wvZDl1UE1OMXZqRFBURGo3ZEZvdjlha1RCMERjQVZBZFV4N1dsQ2xl?=
 =?utf-8?B?VWV5dVRCYVdzSFhhRmM0QjY1Rm5JMXFIRjl6Vnl4THJmSXR3bDk5SXFxY3pv?=
 =?utf-8?B?UkhMK3FHdmh6WE94Ymp0cUFrOG1Yc1l6QUlLcUI2cVloQUtLT09mbGkySHVB?=
 =?utf-8?B?c3ZVVUl0eklQdGdJOU00QzNBSXBCOTg4Q2ttYUErOWVVM1U0ZnFJUFdodHBo?=
 =?utf-8?B?NkpuZTJqcTFPLzhhMzA4MjdoTTU3RWE4UU0yaDk0UmhJUExsaEk2akZkbHo2?=
 =?utf-8?Q?IHPqyYmLIME=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YmdpWG8xZGR2cXpBVDRueEQvR0pXTXROWUMwUXA5elc0N25SNU1venFLQzVp?=
 =?utf-8?B?QWZTM2J5Z2x4dEVqM3VPSUJ1RStXSkRGWjRUdkJGWXV4WElpVkdwNEdTc1lv?=
 =?utf-8?B?NzNkOVBtQ01nVE0zT1RhcmtrSWhOQml3UWhGa1FqUXB0bncwTWdVdkVPQkYr?=
 =?utf-8?B?UU9FMXh6bXhkL1FhUDhXN1k0LzBQMGtvZ2dMZkFNRGdDTzhHTXhpdmRvZjVU?=
 =?utf-8?B?U3FXVXBCNlFGTUNrYjhUVjA3YjBvZXd0QlJ6TitTbjA2Ly9qTWVvZTI4aDAv?=
 =?utf-8?B?cU9wT1hnanZsMkowaEduRHdqcHlRQ2ZKOGZsY0l5YVFGczZGdjJBaXMvOHE2?=
 =?utf-8?B?b1RseG5aRkFqT1hQTEVUSWhsZytaMnJEQ3c1cEJrNS9qZlJ4cVZNVjRIRmZN?=
 =?utf-8?B?bW5NSUloaFI3d0JzT1RhZ05MdCtjSU1IYXFyL1BDbW91ZTBTSlBLYWc1SU1B?=
 =?utf-8?B?LzBuTFNqUFZKN3NqZ2pHQVZrbExUM2hjM21lYU5MZ21ROEJvVkwrMzQyTFJQ?=
 =?utf-8?B?cWpFNTdPZEVod0FXeWxMNHp4RERFaWlzMDk1MzZLSTJhc3JDRTVtUHBGS0xQ?=
 =?utf-8?B?bmpiV0JiOGwwSXRESUxjZFc1SlBXV3E2Y1JxM3A1OGtFK3BGMSsxUVhXYlBJ?=
 =?utf-8?B?dFVHUStLQmNXSnFBSlVZby8ra2phZnNIcXVvSThuS3RScStVQWNUalA1OEFm?=
 =?utf-8?B?WC8xU1lCYXRzMFBLbmpDakI1UUdkVXFOYmhTRUdyS2U3WGs2Q1RzVzJwNnpj?=
 =?utf-8?B?MWtpMVg1ZVhyYzVpQ3BZSVJBZ0RyRmJBMVlnRWpuR1FqUUxXVVVCdkRyNHhY?=
 =?utf-8?B?UW5pbUt5cUwza0k0YUU1QWQxZzVPdWJLcjlLRTkxWm5lNFlSeUh1bXp2VFNv?=
 =?utf-8?B?VjNwODdDaVMwRXlYN1NxYnpJb2lpbUhvUFZvMFJSWk12aVZwNmFmRytnTTJo?=
 =?utf-8?B?Y095YTNOYTdONUVhOC83cEtWTUNJTXpiOG1FQXZjZVZUdGxPbk1MTXZnTWxl?=
 =?utf-8?B?WlcwK3lNY3ZNMEtRYjZYUnR4TU4zS3NMUEVycytSOWcxcXNYUVRRcE9GMkNk?=
 =?utf-8?B?K0VJcUR4MnVYWUR4bE94VE5EZ1U4dVU4bitwZkdrZ3AvT0J0bDJlS2FkeW1v?=
 =?utf-8?B?Q013emJxYmxQa0t0Uy9pOTFvTGo5TUZpeXZPdG1xLzJoL1VEVFkxRHlHb2Rs?=
 =?utf-8?B?bGdzaDdtcmc5ejVocndTUGZlYzEyVk1pYzczMFRNN1VYRUlEQ1JrcnpTMHpJ?=
 =?utf-8?B?TVhVdWtYUEJKY2IveTR2L0FkOEZaVmJrQ0MzT1RRQm12TmtFa25WNGdRYldq?=
 =?utf-8?B?aFN4clFhdCtpZG8xL3pPdDN5WmZHeUtYL3FCNXlMV0dlb3VEUUE4citpSWNt?=
 =?utf-8?B?d0QwSGQvVW1KRktwUHI0b3FJVlUwU21OOHNIUUxKL1YxMm9OcUZuNi9UOWFs?=
 =?utf-8?B?YzQ5alJrZVYyb2YvRkhLVkRvODUyc2hZN3ArWVI5MTBYNXhOZ3IrZ09kNlRI?=
 =?utf-8?B?MHMvS1o0WmVEeXpLMndEY2pKd0o2aUh2dW50cS9qR3JDUWNCOW5meUN2NXV6?=
 =?utf-8?B?d2hFUTA4Zm0xSityT2xaSVU3OWh0MXU4NHIvUEVjVHNjUmx4bEdvZTBubnZz?=
 =?utf-8?B?ZWtOL29VYTFQVlRhTmdHZE51QlZzR0J4azVRQlV1eUgveHIxM29UdzFBTFUz?=
 =?utf-8?B?dGp4WW5hTGt6ZktDL0Q2Q20zRnVVTm1TaEwvaTZubTRUL0RnVWlDdzVMOXB2?=
 =?utf-8?B?OHQ0MkpwTUQ2WmdxZlE5YnRzUDlVMUQyTC9ZZWtiYmx4STJaRzZaU1NsWVJo?=
 =?utf-8?B?ZkRtUDRuLzVlSWJ1enpHK1hsdTUwUzlZSWdScGxvaDNad1BDRFhOblBKeFN5?=
 =?utf-8?B?QUlsZlFqL2ZpMk9Dczc5S0V1T3FGYkU4RitCSENqdnVTcnh6Yi9XcldoWTRF?=
 =?utf-8?B?cHJUWHNCU2krZG1tVExtcS9UYXFyRWpRbGgyZjVLdmtPTjlDVWg0VDVkWlpI?=
 =?utf-8?B?YUorU2JiNzk3ek5XWkhsdzVXK2NhS0hjeXVmQW1OYWlYYU9aZ2IrVURvOWQr?=
 =?utf-8?B?MjY2M0c1Ny9ZSi9TSGxjOEMwb2ZZeFh5L1lkdUpSeUdlQ0FNeWkzclppVGxk?=
 =?utf-8?B?UXBzNWVDK0JaTzdEem0zNGNSOHhXMEMxTVVwRmt0bHlxRDVVOUVUSmZ1SExW?=
 =?utf-8?B?Rnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	n5EeqMOXJENg6nLw33E6Wm2S2ZS56yQ5u1RKkfg9e6h7k1f8GHU//ks7o4x2Wv4NrUL0bfHYadS0gotwcqTZNljz80os7t+crWOCoGdpAcc99w2JAHI9WHgANU+gIxG6PyarCaF3Ny6TwGRlzO0uU313M5sxfNzHtBrtlCBi6xmyqco7pQsryh2IP1P8RjNiOR5k7J4ZnyEj3Tdc8/lrFvHBX7CLcrvpl5Cmxn8aSpbA0RiuQgfE/36vDYP6t56ULDTQK0APRU9ni4PuvPSoq/7OP2NsNU7+J/CqpeyvoU9qEwUyfYVVgyx4Ibd1d1MRPhF/R3wAck7uLJ0xVLF12kOpVvWRM130sHIJg8c2qng9BjgKrUmL6hOGGpULlQOZtXNcMuTGSd5X4QamUwQDx2sw1HNViOFTT1xYT7eGi5WPmRvOWqJBd4k0Ta98YDqAY09NMmwK9i19obeTcW2l5eqL2g1Ab/TFDrOCWwckU0JMF/edE2Rm95xX082VHDpgy6p1vaT1/dE5J7C5phAAp9LyIFV5io3UK7fIexBYI825x4G99FEoaR53U9aiBUt6RwBv5MLIKDaYF6JNZuhRHRu3CgEERtp2MEOewyQsr8I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a2f7753-ca30-4c48-bc31-08ddad88585d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2025 10:18:47.0285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pbcbc+QVErQe8P7IxAMjggfaN5CN4efkT3fIWji2i8WJO+COyHvAYo+168zPkVS2d9kIsGot2vKS8tCKDbG+Dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6076
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-17_04,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506170084
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE3MDA4NCBTYWx0ZWRfX26ZZ0n5+muVw 0gwWCZy3afp950CA8mRmeuNL1mePvUrBtNIh43ZJTDGfd/DB8ob2fnnxAaDo/H4ueR2UUJrqm8b F7hB4lSZ5Syax72mwnTPksoligwvv3aeFvNOlDgQhdz75gFUmuuARTnEahxo99uv7FyldYPF/Kx
 h5OyoiHTIDokBY6m5uSldH0wCMWXvGKewsQ6vx9iC2KXkvcYrO3WV12Vqq7ZDjvldUvmt8KD+MG SqnbuxKLd96DQa+Kg2Fwhdx6pIwhaFZDMAlSdXRfKBSt1MNUwsRaF9SKAQ/CGVZciqhj/0CURKp SRsoYpbbURnCTDYR4EOW07EDHxgEtnAyWGSpC2RR1tgglQ2VV0JcGgTeUZ/27zhxg+CEIym1zHu
 unzt9xBsdLRqI4WL1iNOMs0xxeSZB+VPQxsyAEInsycwSszf6mJTAg8Oxq+0/l34yOCZt8dA
X-Authority-Analysis: v=2.4 cv=DM2P4zNb c=1 sm=1 tr=0 ts=6851410a b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=2nle5uG55BRm5s_oWRMA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13207
X-Proofpoint-GUID: 2fklFfOtdXwgVSep7_zIlIGwI8d8p1hI
X-Proofpoint-ORIG-GUID: 2fklFfOtdXwgVSep7_zIlIGwI8d8p1hI

On 16/06/2025 22:52, Catherine Hoang wrote:
> From: "Darrick J. Wong"<djwong@kernel.org>
> 
> Simple tests of various atomic write requests and a (simulated) hardware
> device.
> 
> The first test performs basic multi-block atomic writes on a scsi_debug device
> with atomic writes enabled. We test all advertised sizes between the atomic
> write unit min and max. We also ensure that the write fails when expected, such
> as when attempting buffered io or unaligned directio.
> 
> The second test is similar to the one above, except that it verifies multi-block
> atomic writes on actual hardware instead of simulated hardware. The device used
> in this test is not required to support atomic writes.
> 
> The final two tests ensure multi-block atomic writes can be performed on various
> interweaved mappings, including written, mapped, hole, and unwritten. We also
> test large atomic writes on a heavily fragmented filesystem. These tests are
> separated into reflink (shared) and non-reflink tests.
> 
> Signed-off-by: "Darrick J. Wong"<djwong@kernel.org>
> Signed-off-by: Catherine Hoang<catherine.hoang@oracle.com>
> ---

Nice

Reviewed-by: John Garry <john.g.garry@oracle.com>
