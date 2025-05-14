Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6131827A93D;
	Wed, 14 May 2025 13:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747228276; cv=fail; b=V+RYjBWMTYjxIw83k8b0H6MW9uucgf15ynTxAroUtLDHF4xaIl00PdKZjgoiW4OqQfpdDuixfa71OSxdfASnxL8HSpFxI25BRpgkiiLoA8KbPJFzHcIuNOjhoehvj6O6ekVWtTYNA6Z9ggc7emmlt2vwb+0nR842aYi0Yn/3fWo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747228276; c=relaxed/simple;
	bh=xL0sQtl6WVks94UKul3Yee9LoHrXiw9DsKmi2g2YA+8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DUCPlAFf/PjGkwWnsNZFMbxpx9xcHejgsRyCY+a9MDch9WdHjGcKl/y5o/ljJtmP1jboEGVyitiha15ZU6fWeStGBsEc373FIY+7ntQTm9AgX6C7pHWSGKb7r88sAO2Ol7Dkg5m4Uiqjk0iymThotMvWGpeMzGvCOXvhBvGebhw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AGcdWJzb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hReAjcup; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AGcdWJzb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hReAjcup"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54ED9MIo024980;
	Wed, 14 May 2025 13:11:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=lfuZjVrg646nr3h7dGcFwL/hcvCJJOrXPN6EK1OG2j8=; b=
	AGcdWJzbB2rAKlZ9z63L4Kg2dVK79bHENIFa/TTSx82UO/Izw+PMxO8qIK95BdyZ
	ZgL5/2VPztP/1nNBA5B8CSsrbnJdtl0nMhGt0YIiVgj7Y5nJlfOnRxfuQxHEAjig
	BwltGUt9+qgSIdz3JepXDThvZ23Vck/DZ3PALdwbbtgxtgVSniyXwP4mRpe+a1Rm
	ZdlGKibS8xh7PgK+ORdlxDUkwtbOeFBZ0IDKg+GgH9TM2SZ/QXS6wFl12FtsXKl+
	F1c/3xwvWEVIqun1GqsxeHhHBl8LSG309Oxz0phg39OTBcecWu6vwY3fmARtsd3W
	jCwiL4NpcEhIGufUkWWNtg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46mbcm1k00-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 13:11:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54EBRkBc033319;
	Wed, 14 May 2025 13:11:09 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazlp17012012.outbound.protection.outlook.com [40.93.14.12])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46mbs96mqq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 13:11:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mZOqt/UzAeatpmLsfxokBia/DQsaEf1dfcznlIXlHkxr8ip/ghujle2BeXtOePex21Tj1IVw8YI9dfgmo7ib607ZjOb6KdMMp+Li2Fpdl9Ezvh3moLYwVkpD9DruoUH4RLKr8l5IIB6rpcv0LtpJx9EI/abFhQ599Qa1HXy5P8HwoaEj0OOsrLVzmkPl3kW/HMgz9ytfmkz1sxbQiEYm7uUnx4Rpl4DIP3B/Swd660Jz5P918EDF6uE4vvOQg5oB/VtOIY3iCKzc6R7WhjxXK+jFJOmZDn4uDs8nAGVeCYcKxRSEnqog+bkouYTQkH8QwpykSBK0GET/bnJg4pQ/3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lfuZjVrg646nr3h7dGcFwL/hcvCJJOrXPN6EK1OG2j8=;
 b=O9eLaZq0uLj26y64vj44vjl9/yoGpbqYRMZ1/kRrGz8YGZepe6Rpi9d52ZF93rzoQNjLVOwEdyITZm17wEenABiTJh/NWyNOWVs6gZWgz3pb9F78JkByb6q8fFFWGRI0HBFsDM4cSUex/wko+tWPLn/ae89szJFuHJQABahsWRFZnHBrzQ5BzaBGuUlFz3T7GOJn59xyyI+Q9ecE2gXPj16Ly7P1qqE8W/8s3QS5KAxyRsK9X0nRzUDGhYxwCjn0xBGrs24zLGk1kOKEHnNb9y9WFPHFLxMVJ5oliEmPIZ8GvJoYc1Yd5/zjsObR/hDH0eFBvBp9b1Ni9BgI00llPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lfuZjVrg646nr3h7dGcFwL/hcvCJJOrXPN6EK1OG2j8=;
 b=hReAjcupkulFCf1XOApNDPMbBT7/4q7MVI9tmBBvwELPI+6V+vmN7FW0thDrf1+vHYKTPuRkxdSb82F38FW79CZR5dQZqNaUQAvvXfLYrMdqv4S8JLFqC4vkxaVDehGFoOn6Wcry0YmfK0xO9qnPjbbT8stoJEOsKaYx8qToKCQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ5PPF4561E4FCB.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::79c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.24; Wed, 14 May
 2025 13:11:07 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 13:11:07 +0000
Message-ID: <73af7165-630b-469d-965e-a50c381298cb@oracle.com>
Date: Wed, 14 May 2025 14:11:00 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] common/atomicwrites: adjust a few more things
To: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Cc: djwong@kernel.org
References: <20250514002915.13794-1-catherine.hoang@oracle.com>
 <20250514002915.13794-5-catherine.hoang@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250514002915.13794-5-catherine.hoang@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0008.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::10) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ5PPF4561E4FCB:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e6e1217-7c47-47c2-e5a2-08dd92e8c95a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cTRLQUg0eXRlWHZtbnlsWlZRenEyWDllSWhxYXM2Vys2UGQ3VE9NRS94TU5t?=
 =?utf-8?B?OWxoVDhCclJ0bmRQU2tabjlNb2xDTjcrRFJuc2F4bHlwR1NyYmpXZS9KUndR?=
 =?utf-8?B?QlBmZ0F5SXJxMDZJcmhKZ0NxOXRhMlRTYkk3ZGVlajE2cTFmUWwwRHFQNG03?=
 =?utf-8?B?VlcxUEp0T2o5V3Vud3NmQkU4d2RrRXR2S3c0WU5YUDNrRU56cU9ma3pIN0pS?=
 =?utf-8?B?eUsydms0cytxWXlhU2piVFpuRndWblZwTDhzOGFSVHlUWk9KU2J4RnNQZFVK?=
 =?utf-8?B?N3hyL3pZTlpKdWI1SkEyT2VMMm5RQTRDUDc5bTdYQktaWXZDS0xWeTk1Ynhn?=
 =?utf-8?B?eU1tcHBvT0ZaZGtyQ3dOcXpESEZSSG1HbDBrVzFveERuVFNlSElidzNUWVdz?=
 =?utf-8?B?WDBiNTdJSXpINUprWll3eWFSbUZTUFY0WXN1VWNXbXZ6S2QrbE9SWTQ5dll3?=
 =?utf-8?B?aTNkZmplb3lWY1pHYVdpalR0T3dOK01kdWJvREJFWmRLdXc3cmd0eXFzbU81?=
 =?utf-8?B?R1p2OGtQZ1FhS2NBdGNoSFlhNGJvcUlqT1piYjlJS0hJUmFEbFlZWjNEOG0v?=
 =?utf-8?B?eXlqWG1zelYvbDd4VG4zdlNBTEUzSXhUNGRFT2RBQjZnRGtHaGlzRDN0Sllr?=
 =?utf-8?B?SlJ6WURLSnVSSTRXZjFPbXV0aVdhK3QyakhrOFZjSHZiRVNRcGgzczJvcVpp?=
 =?utf-8?B?STdQYStGU3J5aUtDaDZjc2IwRFdYWjcxcU1LWi8xcjlUR1FXdmg5T0RVeFZK?=
 =?utf-8?B?bG5iYitWMVprUWF5L2h1blo4MW4rbkg4K0tvcUdJa2tBR29uMXJGNWJEWWhU?=
 =?utf-8?B?UHlRYUFjaVdVRmc0UGJZRVZ3WmVvVG5OK04wSWR4LzN5d09LZGxtV3VINjhX?=
 =?utf-8?B?ZXhKaVdJV0VEcDBIZ3E1QnV6dHFSY3VLQWw3ZXVMYW5KRU9CZkUrSDlNU3Vi?=
 =?utf-8?B?OU1wNGJRMHpUbjNubTMrbnd0WUdrR0VUMXQ4eC9vUzNJMmFNbVY1eWh0Ymcz?=
 =?utf-8?B?ZGVmNzFXYThCVmNrekpTZmdlRUxGaGhZbjJzTDhtWkZkZmJuVHh3bkJuNzBv?=
 =?utf-8?B?WTcxdGs0QldyUEVJMzJBKzlmWXRXa2h0OHJLQThtMnJqdjVwTTlmWGVpejE0?=
 =?utf-8?B?UnBrYzhnaFRtUi9icHlvQ09yNVUvOWZxcFlzcjZtQU1SQ3NSVUdBMlVuOC9X?=
 =?utf-8?B?YXJqV2hTdDVmb2g5OFN6UEdrYmhlQzBuRWlIM1VmaTlEMVBEaWlGUW9lcUVk?=
 =?utf-8?B?RGNZbGJvQm1hZDJ4aVdVQXg4bGxNSmN5Ky91VmlQWHg1UkNwcDRQUEprb3FF?=
 =?utf-8?B?YTJsV3oxNGZJWldQMjFQR2JNWVNjdjdiQjlkcUJUMVFGZ3drSitJYis4dFd5?=
 =?utf-8?B?RzJhL0ZTdXdFd053a1BhOUdIUEh6K2U1WXZIR1FmNHlQWmhHR3AyOW16RGZJ?=
 =?utf-8?B?Z3c2ZnVob2RJS2dFaThlNWk0dlVFQmdDYUlPa1JDZ2VVYXJJWi9SMUQ0YnU3?=
 =?utf-8?B?RTZBTFEyQlRBQXczVW5vRitNRVpvbUdMZkJFMmdTd2hpZG5qWWhzRFlUc3RM?=
 =?utf-8?B?dGI0WEI5dkprcko3VjFtbFFqMGFrZVQ5b1ordjB3YWhuNVc1SlN4WE9WeGtj?=
 =?utf-8?B?Z3RlNnI2KzR5REFXTldMOWFjM0NybmhkRGNQMXh5U2VDTHdiaTBFRklDUlVP?=
 =?utf-8?B?VDNkSlJQemFzaVdxNVY2V0RFT3poSnkxYjFlUXNCNGMrSTNvdFY2V2lLQ0xu?=
 =?utf-8?B?eVNNd2wzZkMydzdVdjRRdDg0Y2QreElQbVU1VDlTVzYwOGYyZFN2ZDlwNGwy?=
 =?utf-8?B?R3JqVnRFMkRMR2pOTnNvWkdldWxUNUx0amZWTTdPaWJ3Q0lLa1FuamlZVldm?=
 =?utf-8?B?TjBBOGJ0VkUrRFA1SnptT1prWUpuTmhQdlFzb2ZnNTRkUWtERFBjeFYvVDhy?=
 =?utf-8?Q?uhWstgp/zko=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MHhtWmxjY0NHamROdW5WOUNxNGpmSnBlNHhub1ZYUm1nanRzZFlYeFFHc3Zs?=
 =?utf-8?B?MU54OXZXVnhrZUdDVkxGOFAxN0ErVG5NOVhRd2ZzUmxjU0g2Z0lnQkxjOFQv?=
 =?utf-8?B?ZFZubUsvd1JySmlvdFBSV0kxVkVENVpsb2ErbVlWTVNhVnlpWVV0UHVUY1dm?=
 =?utf-8?B?YUI5TXJCTjh5RWZwajRrN1RkSmRJRVJHY2kyVkhGVUg2VXpKMXQvYkpQY0Vj?=
 =?utf-8?B?aWhTcHBDT2ZseFpJU0xCMmU2ZElITlo2eEx4bDB6ekY5cmU4VDA5YlpHZ2lv?=
 =?utf-8?B?NmYwd0orQTdvSDRLcDdFVVZtVWJkUjhMQnE5eXhSSmxmN1JrbW9YTHhEeFRT?=
 =?utf-8?B?SVBQaWdZcW5vYUVGWE8yYzhJbk44bDBlMjAvS2orNFV0aW5senNjZGc4R0No?=
 =?utf-8?B?V3o5bzFQVXk4MUlNQzB3Nkd0ZlhscWxnY0MvYThCUldnaHlpNXQ1WVRrODdV?=
 =?utf-8?B?ZUZ3aXh6Wlkwa2FONE0yV25TVkd5TklZY0JDS0Qzdkw1cysvOCs1YU5uSDJu?=
 =?utf-8?B?U2RUeVpsd3FYU01YMjNjM0xxampzSi9JMCt5d2RhTitxcmVyZ1F3bDZycGtR?=
 =?utf-8?B?K0pEN2NTVFNGbUFTNCtpU2FNelF5Vnc4U09iNDg3UXA3Y2NoVXo2TlA0MGdG?=
 =?utf-8?B?M09UUUF1V2ZaNENkOEh3MVJ1UjJCT2gxcm9jTExwRldyS0s2UWY1MWRzd04w?=
 =?utf-8?B?YnhjQldDOS90cnFXeWR6aG5HMHZDQVVtNlJ2cVJNWUpDT0pHVGNtNFRWRVU0?=
 =?utf-8?B?N1FxRGJXalZ0Sm1hUEZnVlBBNks0Z2RUa1A0WTVMMGxoRzFGTGh1eWtCWXJW?=
 =?utf-8?B?amxpQVNWb0d1ci9YMHA5dDNrSmEvWG1sUEE2b3NBdEljZnVXcmJkSjJibEJo?=
 =?utf-8?B?dUI5REtxQldSMmdHT3FrRjFHa1NudWRMMmVsTlJZZzl1eUgwcUthdjBqV0g3?=
 =?utf-8?B?bTA5WituaTM4M05MbHV4TGJCdzJpd2FiYVVoVUlQMjV1TXJTQk5HL2l6UXVZ?=
 =?utf-8?B?L25sL1ZRSjRsVXVVbTF1YXoyV0YybHVad1BoK2RBMkJUUWhRYXJyWUpXaTlj?=
 =?utf-8?B?U20vL2VQWWhRcFUrSmNHWUllTmRVekpzWFZSYnVXV1QwMjV3VHpEQmc1S2gy?=
 =?utf-8?B?YlZqa045a2wxdXRYZkZ1aitIcXFCMXpZbWZmZjk4SFFINi9TWEFIcDFQYnU0?=
 =?utf-8?B?S0dNZ0pLaWdycmREL2FCWjJWY1BVRWNXZXVxcDh4czAxbklrdG8vQlptR1hW?=
 =?utf-8?B?TncxTmk3Sk51cDFqN2Z1WVR6cEFURjRRZFdtQnV4RTBmaHlNT2tlOGo2M25G?=
 =?utf-8?B?cGFOQUpGNGdjc1g3enlNUTF2T1FPTC8ybTg4YjhrbHc0b1FvK2R5b1R3eUg2?=
 =?utf-8?B?U2JoV1dESkRrMlVFTldVcEpRR0JLZEZ0aHdnQ2VKOU1CbjlVOHFSYUxZOUpx?=
 =?utf-8?B?MTZIelZ0WG1kWEtWelVBeFgzbTFlR3lkbUdCdHdjbE5yRG5uY0F6ZXc3eTVV?=
 =?utf-8?B?MUdpSEwwUTJYWFlxY29UUXNvZkp1VWJBVzc3WjJtaEFKQlFielF3MFNaMXhq?=
 =?utf-8?B?WEZ1TCtqNHVkRm5uZUM5eCtmcGlVQ2ZpaEswYnpmN3F2dHYvYnY0aTRaK0lQ?=
 =?utf-8?B?bHNaK2ltYzdUbFcxMWorZzNOTGdhRjZqcUI2dkNvZjdJNm5yS0Iwam42OUZ3?=
 =?utf-8?B?TVcrN3ZIN2pLMzE5OGlzUjZCdlM0U21IbTlpNVU4SzB0TWx5YVRzcU0xL1dt?=
 =?utf-8?B?TlJKd0tIRVdKRTVkY2M0UUlKZWtSYTNSVXV5cTdKRytGT292SHAyYkYvZ01o?=
 =?utf-8?B?ajI1NGhRV1JaS29HK3dpVXd2S2YxTDZsVzZTSVVGL3hxOVQzdk51cU96K2ZD?=
 =?utf-8?B?OHJCSER3dFZ6ZzQvRDI5SEdOd1JmS2IwNkFKV3ZWWGZDa2xsMkIyVFZFTEp0?=
 =?utf-8?B?UFEwSE9NQWlMc3RoZ1lNcFpqQmpzSXI1MnF3ZXdwWWhXK2huZFg3QXR6V0t1?=
 =?utf-8?B?VGhqaHc2RExxZWVxN1FoK09MeGViUXMwc3ZwV0IxNXpVQ0ZyRStnZzlzemRy?=
 =?utf-8?B?bHhLYXRWLzVvazJTMjFKSGlLZ2xGd1I5QXZ4L3NsSmRoS2pSM1VZV1BVWGhl?=
 =?utf-8?B?cmNzMHo4Q2pWczhnWk9maStlUTJzdDNnRmZ2WXlQbTE3bFRzVXkwcUFxOGVz?=
 =?utf-8?B?Y3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PsCyJW1VeSh48cvl84laGNFCbrMuORutc47utA5I7D3f4AxVtT0GckQhyGoViqSqmYz2fVkSibC1L794DBGJEyM4S5uvyGFEW1XZm4L9sL20pkfR7TZKDdn2uEs86jAU5jYFk4ZFZIN57zqbE5tNwSBo/abGXQgi9bnx5WeDtVP5FruPN0jiDiCGuWpei3eaKAUgDPPNkyQMFmktOGCvmCclWFk2i3nbrVHp2ekVpGaPN5CdRBFXYku9ojO0+bdaUMREh5/PnH+hk0+tVz3ZbAaUcdln680fLSrpOmQBYoTWxp7HqEDJAoL8J/4gyWdTVrWs9L0PatkdthG/8hN8a9eKqwGokSXq/gEL0VOL4B1lFyAvd4zVBdZ7oEDv2+dpMuwDP8YbtTl3qshBc7DEsOgBbAoz+PL5lYrQxgfAF0Z63EUIC1mzBaYy6OygcZwpoT7akNR2BNnF4vpsYjPPuBkPPKs6rUJdH02D/+hpoRqqJsHJt6P1I8ygEhDhtavx/kOXZ0mJxPn6WdZmy+kpFYxBsTYKlMViGmX+/OCrGdhxoL7S+y/0pCSTaMF21JHtS8iF//LgqHCLMsZIvaGpD5nzNfgtWm7u3QrO6r1LABU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e6e1217-7c47-47c2-e5a2-08dd92e8c95a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 13:11:06.9036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F9RO0vEohB3tO/Wcttt02PNYDUvEFFWdUf0zGCz74XCnHU1qeH8qiY6cavcnqZ9WzWC7mYn6Z6SiqUTr3LqkzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF4561E4FCB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_04,2025-05-14_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505070000
 definitions=main-2505140116
X-Authority-Analysis: v=2.4 cv=DZAXqutW c=1 sm=1 tr=0 ts=6824966f b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=ae96NSi8orusXfhojyoA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13185
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDExNSBTYWx0ZWRfX0zxo5OxH5vFA VtnIYv68U3UxAJ0gnzksgnPsAdpKgN+nC/idoQY7r+LNDMgEGkLehoH/zmjnfpjjKSqQk2WUltL tL/T0c8gdrI4CxayumeXSNVa4Oya2AwlC8Cj1jc01sG9tIjNd69npwHpS+yMJBu2mtvn3EWYC0T
 AnLPcVHRVOnHql2LufB4SHX/r67jb8MGRbS+zQn+z74x6oIGUW9ZD01zFj0EL0wziC4gR3J6zGO RgReVzYU8yUVo0pwvdXcn3ZiezZQgTAmBGqHSKDDGWffkPGwcTKWtNjGjeUemuZjFkOE4NL60h8 NdGvs4Xlq7zS7CeVfbpOvKl9PQa8+XLI25NSDbmEr1yowCVayCnoTid66fgKRi87PO4f3LAfuQJ
 7t37bRfqw8xvqPi5pLBcFdD9M+7y/6wvbuuj4cNT3dTe5oj9TiThr3uHSK3ut2f9UtugaSGy
X-Proofpoint-GUID: zJWMobmTZ3KcUGH0arsIv59XsSFVqq0B
X-Proofpoint-ORIG-GUID: zJWMobmTZ3KcUGH0arsIv59XsSFVqq0B

On 14/05/2025 01:29, Catherine Hoang wrote:
> From: "Darrick J. Wong"<djwong@kernel.org>
> 
> Always export STATX_WRITE_ATOMIC so anyone can use it, make the "cp
> reflink" logic work for any filesystem, not just xfs, and create a
> separate helper to check that the necessary xfs_io support is present.
> 
> Signed-off-by: "Darrick J. Wong"<djwong@kernel.org>
> Signed-off-by: Catherine Hoang<catherine.hoang@oracle.com>

Just a small comment query below.

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   common/atomicwrites | 18 +++++++++++-------
>   tests/generic/765   |  2 +-
>   2 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/common/atomicwrites b/common/atomicwrites
> index fd3a9b71..9ec1ca68 100644
> --- a/common/atomicwrites
> +++ b/common/atomicwrites
> @@ -4,6 +4,8 @@
>   #
>   # Routines for testing atomic writes.
>   
> +export STATX_WRITE_ATOMIC=0x10000
> +
>   _get_atomic_write_unit_min()
>   {
>   	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
> @@ -26,8 +28,6 @@ _require_scratch_write_atomic()
>   {
>   	_require_scratch
>   
> -	export STATX_WRITE_ATOMIC=0x10000
> -
>   	awu_min_bdev=$(_get_atomic_write_unit_min $SCRATCH_DEV)
>   	awu_max_bdev=$(_get_atomic_write_unit_max $SCRATCH_DEV)
>   
> @@ -51,6 +51,14 @@ _require_scratch_write_atomic()
>   	fi
>   }
>   
> +# Check for xfs_io commands required to run _test_atomic_file_writes
> +_require_atomic_write_test_commands()
> +{
> +	_require_xfs_io_command "falloc"
> +	_require_xfs_io_command "fpunch"
> +	_require_xfs_io_command pwrite -A
> +}
> +
>   _test_atomic_file_writes()
>   {
>       local bsize="$1"
> @@ -64,11 +72,7 @@ _test_atomic_file_writes()
>       test $bytes_written -eq $bsize || echo "atomic write len=$bsize failed"
>   
>       # Check that we can perform an atomic single-block cow write
> -    if [ "$FSTYP" == "xfs" ]; then
> -        testfile_cp=$SCRATCH_MNT/testfile_copy
> -        if _xfs_has_feature $SCRATCH_MNT reflink; then
> -            cp --reflink $testfile $testfile_cp
> -        fi
> +    if cp --reflink=always $testfile $testfile_cp 2>> $seqres.full; then

I suppose that previously for xfs where the cp --reflink failed, we 
would pointlessly try the write - am I correct?

If so, now seems much better.

>           bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile_cp | \

