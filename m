Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977DD1D1752
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 17:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727890901; cv=fail; b=j6lA/pFdblKVn3TVxmMIGVzr6cppWJ/Nx6poLv/G+scpCF5kqSODyLeIROHc2oeuNNr5HbIRqQgm6wuwLhQWVeZEInq4iYei5Y1eh/egO9PhiLF+cZbJDcE+1ZKfF+zJDVxzOBwuFsTjS0NaH3Zscm/Kc5cBohwivj+C+QA/2nI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727890901; c=relaxed/simple;
	bh=X2DnA7ZC+DoRx60TbIiXRACpsYI11z5HLsh3cqWuPc8=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aiiYRyJT6gzap03U05aLM6sjvamZTdH5OwFJFAoszIbD7w6REI13W1o0ybvzZoXdsW8ObEb37yQI1kniZy3Gn7/01pfaW6CSceoOanEPkjlOaoTO/qQmGyTFl5N+9tZeQMAt6QOhsu75LUjF/e7yh+UBfN0h21pbWSM9LXBcTSI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Q9CU5IdI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Q5YEC+31; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q9CU5IdI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Q5YEC+31"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 492HfbnD027433
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=6d0nsBvi1FRbFaqVbRM5NAAPIbgj3sIou/pOldgMldE=; b=
	Q9CU5IdICEHqwmy4AY0FzYJIzmQn0zkZZzoRbgNwsJ8B0lEb+aqutOvMdAv40JBP
	dve/v/WZ6kIm9CSxG1ciZ/flWJ+fr1NYs6buO503/yyhP3huywpxFy0su7adqOtG
	FFG342awpxALqfd6FiyEWNi6wYCzacqMZYWciJshV77wi0rpbx/nffTcgj1HGDdO
	4zUMwvvYTjCnhT+Mu5Kub1JhWL4HH1L2CWnwapcsVsB6oMavNua9Ukd2y4qDzfyK
	HHQFrsNwua3m6sDMN5PCrChCUik2ofiv6JZtXM/dqWlPP0nLvBT3H5xn/VVqpLBF
	zxWhkOpDzL2jP1ZlPpmkVw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41x87da9dy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 492H0V4I028390
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:18 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41x889d3wh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q2vfkcUJ8yjkQvsV6YOVUJp0NTUudyEumWRV7a16XwrcA7gPtFtHT2LJXmHTVjS9MH7V9lDXb+V2I72fKgqPQRCGd1jhnc2jE2tZJkOQWGBI+0lhl0j3FXwmIinJ+HYrPLPHiJmMEVLD94XXcmpduxkQ/AG17+NXhavuvbdMdq+xyraF62YFBjiZ0demcDY6uaZT2UtQVxc1cMsYjexV3l7OhU8ixE+UBGlWGcsoVTAuiKKSO2eV8g8O6Cek/+qhJSyeEMr9SGcVvjwcju9oHwsbffq82/lEg4QkVuTdevH1O3OirZ1qLY7kVzMmWll1wh8Y8HU6DoOE4xf4ntyJbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6d0nsBvi1FRbFaqVbRM5NAAPIbgj3sIou/pOldgMldE=;
 b=CJdDxl7lBgb7fhWBKojOJkyYON2pNDLsRrE6mW8fPKSFkdskA2TdZhihA/tSZS2m499VNmUQday1LcyKB+7utgxNxBkAzF++ccTe53hp1hJPAJFvQ1KygNm1Cu85als24//oCTlrgaZjvFsqQgO0XLmpZDCIdEOO75BWp7pdPC60xDV/5yFrHZ2xaSPaX3ZutRep0N7tenzefns+6Atze9E5JnPd7ds8yDx7T782GJtt4aRqypkKWewIMnY2tY5iShL5fGbqfU1n5B5PSJPnad7QwWVluiWEBI1GH32JJ8gWHAdDYJw/+fGdeDbusLnyFPTC1XW6EWzTB9OT4vu/vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6d0nsBvi1FRbFaqVbRM5NAAPIbgj3sIou/pOldgMldE=;
 b=Q5YEC+31F24c1CavSGZzNkSNR8keLVW5dknKt0gTEW7UPm02ZAiCHvhhctY1nY3gFr0NISkqTohbFG0eLn6ujeKigriIec6GH92nHM+Kb5WKwx3ns8kzJ48RJQ8kxAeb3Rsx5vM6LSBCeuVksRNSMv8DE1zNF72m3xZtUW7AFQc=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CY5PR10MB6047.namprd10.prod.outlook.com (2603:10b6:930:3c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.15; Wed, 2 Oct
 2024 17:41:15 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8026.016; Wed, 2 Oct 2024
 17:41:15 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 01/21] xfs: fix error returns from xfs_bmapi_write
Date: Wed,  2 Oct 2024 10:40:48 -0700
Message-Id: <20241002174108.64615-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241002174108.64615-1-catherine.hoang@oracle.com>
References: <20241002174108.64615-1-catherine.hoang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR08CA0003.namprd08.prod.outlook.com
 (2603:10b6:a03:100::16) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CY5PR10MB6047:EE_
X-MS-Office365-Filtering-Correlation-Id: 98bdc83d-6517-4386-fbe2-08dce30969f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SHdmQ1N0N3gzbVk4RWE4STFHNk5sS2VXUEdlRVJLSGc0ODJWMW5HVUgyMTBn?=
 =?utf-8?B?ZngyMlIxckt5enhxQTNydWoxeEF3cXBBU2dSWGVDUm9OQzlrQWxMRVBWQkda?=
 =?utf-8?B?N3kzVUlqcnp1bEJiQmhXOGU2WS9JT1lMLzd4cTZMSGFYb1N5cGcwaTVZNXJy?=
 =?utf-8?B?aWVKTGt1SGc5dEFoU1J3Smg1VWNhVC9mcUNUM1Y0UHJ4SzhqVTZhcFlnTE4w?=
 =?utf-8?B?QWZITjZFOWsrbWw2ZllBSVYwelZPQ2N3WTRDQjZGdmUrTjZXZHhVaDZuR1N3?=
 =?utf-8?B?d3hvWjNDbU5BdDc3YkltcDdmSEk0Sm1sNjRiZ29UclpocFlERVNWQk1oVkRI?=
 =?utf-8?B?RU5MZWY5RCtqU2haakZ2TzRBSzNXc2thcG83WE9UNEZMbzRqL2VBOGVqTzVa?=
 =?utf-8?B?bUFoNjliQ0dDZ3dJS2hmT3Y2VEkydkhXZ05odkhlekc2TWFaNlhNaU9MTmdE?=
 =?utf-8?B?ajFEd1QyeGtwcDllNUJQMGJGSm02NmRRVGpVV3VmREgrUzVvMklhbHNibGFW?=
 =?utf-8?B?VWJZUkdUMHVrbXc3VzQwcWN5UGZPNCtWcFdJSWJiMTBwdGRqc2pnSWxnd2lB?=
 =?utf-8?B?OXFncmFqOUphRTRya3cxRUMrVFJRMzYremY4K3RiY2ZEejJTeUhJOS9WVUtG?=
 =?utf-8?B?YlBDbkFsZk5oT0piYm4zYTBYYWZCcnlYTGxQY2NvQUIzR3hXQmZPbFlDcHUv?=
 =?utf-8?B?V3VFTDB2NUVNR0NEd0lCb09zZGpoTmRwSkdqM3c1STFaVlBnZTA2TDloZlFC?=
 =?utf-8?B?UlZVVEFQK0FYVUhhR0VKME12M2hrSncrU2xaR3JmOWxUU3B3NlRhcXZTb052?=
 =?utf-8?B?cW5SMWRPeTMwejFZbHZVWDF6VnU2eDFCM3JCSGxjay9IeWZQR1d5MlN0ajRS?=
 =?utf-8?B?RndidTNWNXBMRE9EL0RQdUpUc09Od1UwVkpobmRLU055cUllcyt2UWtVUTFB?=
 =?utf-8?B?VTZjaERVSEdiaEhTVXFCQ2E5SGYwVHNDS2lraU9DOVJrWitvN0VxMW8xTWox?=
 =?utf-8?B?a2pTcDVWUzNBVVZZQ1NDQ2V6Z2JMdXcrc05nMjFZdnZaTkJWQ2xlZTRTbHJs?=
 =?utf-8?B?VnliRklHbHZWcjVDc0RzcnlETWpmNFBaSU8vZXN5Vm1WQjdjUkJ0SFlQekx1?=
 =?utf-8?B?VE1IZTBoSjVwVEg2M2VxQXhtMXVqWmFoWWxRL0w3aFFxSmZwNy82KzZiQm5u?=
 =?utf-8?B?QWk2dEdVNVE3eW1Ic1dsbitXVHJZVndTc1I3U2dJN2lRaUpPOXN3M0lnRW14?=
 =?utf-8?B?bUp0SnIvcFMxZnBib0hPV0Q5dVQwUC9tTjliN1NOa29vcUc2T2JUd3l0NlNF?=
 =?utf-8?B?RlEzSTNhN1V3NFRXTFo0WkcrT2NuNnBTNWkrYlJPOVI5U0NCbjRzcS95dHRk?=
 =?utf-8?B?MEVpcjcwd2tvRTBTb243N2VZQngyWnlDbWFFd1ptZU5uTUxZTnRLZDMwZFV2?=
 =?utf-8?B?MXBmMU9pTVZUSTRMNGxOQmxHNGg0bjZmQmZ0KytkSjROYTdlSnVsQXo5bXZj?=
 =?utf-8?B?V0JBU3R1NFR3YUJrSUZPMEtZUTlOVEhtUTNJV3hEMm5ob2FmQm44L0FQT0My?=
 =?utf-8?B?OUlwcmlkY2pJa0p2a0N2VFVSSC8yKzlwcnZNamdBOUk0cWdDUEFTZnZOdlRM?=
 =?utf-8?B?UWFMNFRJU3JzZGFEQU9PNVlkNzY4bCtpT0xaVGoyOVJBR3JLNTBLaXFjVWhH?=
 =?utf-8?B?WjlqWm1IQ2dhUUp0L1RrYzBVZTBWZTBqMW4rZk1KRnduei9RVjg0R3ZRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eGhJNVE4dGc1U3VKS1JnWmZ4Z0c0ZEF0eERNa1IraW9admswYjVicFlJclZy?=
 =?utf-8?B?a081ZFJkbW0ydkNEbkIrbEhtNFJOMGFHRHVUblZraks1YmNuZCsyOHJWUjV2?=
 =?utf-8?B?Qloyc1pRZ2dvQmZFWmlBdk51V3ZLTEo5MjJsWWl3RDBNbVYyUTJCRlpvaEZh?=
 =?utf-8?B?VUxuTkhpZzZ5d0g2SXBCdkowRFRUUUpXemJIZ1N0SHMvNnNoR3hJVUhtZXBJ?=
 =?utf-8?B?ZlBVSWl4UWcrb1lyd2FQdEh1L0VaaDdXNUdUNGFnczZBT0tlaFNPbEpxZEEv?=
 =?utf-8?B?R0xiQ0F0bjZZRjlhK1ozT1dWb3BjWlV5aE9jRy9nZXI2L2xuMEprY0xVbGxN?=
 =?utf-8?B?RzdsN0UwWnp0ZEVCVXVRK2d2MzNKTXRzQ295QjJOMXRMWUFCRW1YYVFMQkgz?=
 =?utf-8?B?LzVmemtCc21uU095cGtHTWJQbkZWL3FMWVdlWXd0MVJvdzdSVVNRYTdyQ3k2?=
 =?utf-8?B?OWY4UDdWYjU0azVMOE12ZzRNZDNlMEJDZDhCU0RCV2xnYmZNZnJ4R1p4YnE3?=
 =?utf-8?B?b0NjVlR2c3Z0T0MybnE1djQ3elhSRmNqTmNxczBnZmZSQTRmTHdVL0NwVE11?=
 =?utf-8?B?TXVac2gvcC9tYXVYb2REeG5qd1pCUGhXSWRMUG45Y2l2cVM4WDgveXhUY0c2?=
 =?utf-8?B?Z3ZxU3E0VFZJcENnVE1YbEpXeWdMMnhUL2NOZWF1OTBXRHRNWGRpakhra0pE?=
 =?utf-8?B?NTZaN2ZnS3EwVlVKZnQ2UkY4TnBGWTVLVnFIN0tFc016bmp5Y1RrOEI2YjRN?=
 =?utf-8?B?SFVWR2tFUzZNb01Edks2MGFZM05YbmgrWHp2OWtpOVR5eDhVbHdCVnZ1MDVF?=
 =?utf-8?B?QUwvT09PL2lWK3FLVlFuS1g3REJnZ2VzWCtvZ3RiNEVHVERZZ3F0ZEk4WERa?=
 =?utf-8?B?emVyQ0VvWUJBWEVDb2pMR1JlVWFDeVBYZU0zZlNQNGdsb21Kay9QVStiZTFS?=
 =?utf-8?B?R3gzc0dmb0UvWGYzdytRZjY5WHFIeG8weEtUSXNxSGx6S0JPRVU1aitYYklB?=
 =?utf-8?B?Wm5qaXl5V0F3YXFYSktaSHJsQkRkSEVPYnQ1Q0ZBYmFvTFh6cWw3U3YrSWJT?=
 =?utf-8?B?aVM3QzdHTkVqQkpyUXZyVG8xcEdyMFpPWUFhMFcrTkhjcmNHQ0MzTStTQVVt?=
 =?utf-8?B?eG9TaXF6aEpXNXhRR0pLQ3NOQlFiQkIxeGVydk45dU5lV1FnVXpWc2hRZCtJ?=
 =?utf-8?B?WCtEcS9jbHN0SUt5UnZNRnNZZkprUk40cmp0dUNGSEd0ajFaV09TaUNRQXB2?=
 =?utf-8?B?dlp5WDNEZWcvNm5QUW8yRmozS3ZOL09xanB6VVcra3dEbG1tSHhqWUlwQ2xa?=
 =?utf-8?B?TWd3U3QrS01QQ0NYQjliUDRaTCtYUFhPSXR4bkdTcjhXWFlCb2t1U2FPQkNi?=
 =?utf-8?B?MGNBODU1YnRlbFY5MitGOWtqOXhOaEpvcHlmNmxOa0Q0SmlGTHNtNCtMU2hu?=
 =?utf-8?B?SjJJU0FvL05hN2h6bDI4NUhPbnk3QTdZSHlBVEhrdkhqS3ppdTI5cUdNbndq?=
 =?utf-8?B?ZlFtTDF2WTRoNUNmQy9IaVFPUkt1OFRDTnhJOUUrWEZkU3RWeXBiMURGa1BY?=
 =?utf-8?B?eGk1WTZSUlBueGZQWHd3L2hkaWRwMDMvWVVTYnk5WDN2UVEvU2VaMWQ1QWk4?=
 =?utf-8?B?SXVMUENhQWxHWlJBZEhETjdWN1V2eGlEUldnRk9oUGIzRWhia3A4YnZhRHNK?=
 =?utf-8?B?NDB1azh3UVk2K2tLUDNRQ2YyL0RtMDhJYUtsVmFwQmRYUXJUblczcDg1VnE5?=
 =?utf-8?B?VzBON0F2cXVFWlJLRnFLYUdRREtBZzFmaWtLVU9MRjNLUlJ0TVh0eUlFY0Uw?=
 =?utf-8?B?dXRYVlNtaXdqQVhYQjc3d3ExQktzL1dhcUYxVkNyMnhCSEhoWng4RWJ2bWJQ?=
 =?utf-8?B?R3VDTnViaFA3M2R3WEhncEc4ZU9XeGpJT2Zpazk0MmFtMWpQdVU5V0NEUFg3?=
 =?utf-8?B?Yk0zVEprNmNBM0xFT2FUWDJzMHNZUG9aU1IrSGQ1VGVITTlSb2Nmb0JPdVhq?=
 =?utf-8?B?WE55S1lKaTdEU1B0ZWZCa09MT3ZOOENLTUdsazNZeDdRdVdZb0NCZTBFTEw2?=
 =?utf-8?B?RlpBRlhWUHdBOTZGUEI3MGhqOTdKQmhnYURkSjltOXVMb1A2T0RPdVBxaDJW?=
 =?utf-8?B?Rk5mRjFveW1xTmRMaUg3Rm01UmV2RHkrblIyZzAwb3oxbzV6VlJrdENyM0Ew?=
 =?utf-8?B?RktadFlycUEyOEdRNWNPVG1MR1I0NEwzbnp4U21zZUxDNmVMTVFOK0JxVDZ1?=
 =?utf-8?B?bStHaVRZekZyUTc0R1Jwak5WMUZRPT0=?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PuAueHtsfXZhCaXSZy6GZl+cU46VN/mSLS+n5O96LDQMPNmExjftOa4FQZFKjFc+lVk3pjA+akXf+0jdhQ+vhvBG2xVpylUO+d2ZBa1DEz9vrZwK0XI3egd9+Hzn0G4mXuzpbil5Soya4ZgOjL3ipGuzdNFs2oD2DIeZ+dLBBlcRrpessO9aYdYo2pXLD11dlMFsMoAU7clGUD9ckZMeaAK2FheMRYP5ChnUqETvgY9vit7nVH71GY3suhUFZiKAB+YFnu6g1gswEHospCxeYaDSUwv26obi5jhkCbTEK2WWvgutc2OZCVRNT5MF2h/RUWWtQwxF/0T1k+agFnF3vVM9OakXlLCYPQ6RxcRirhl6k2HmXUX4xGfR4i+E85xbzHgQYzHsJZ/7WMi/2rriHT4TKwgpv6+L2IHLjkrUqRCCeRAzp5KmMU1nBq0h53hhXi2wpPWlrV7GzPlBGCrMEzagMk3C5IU3R792fNYsZ792V7/fOKPt7I6Ek55QxBRjjVHRJRlmvno7O6Pu9AUeMOV+5A7yHGBP/D0DBVr7JfYD7yguGykV29M2d5dPMf/MqxX/dsynpEMm1h6BDpKKWhp9cntiVEsHkWP/3amTPFs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98bdc83d-6517-4386-fbe2-08dce30969f6
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2024 17:41:15.3582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 47vbyuDUsssK7jKWk+YWzHcbVC49QuF/QC1F9DeLDbhm0PQG03dnyabbkaqTLS9OPR6Y/sufKfF3CJxv9EJLnkkB7TRgSnDK5WhXB6A24/Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6047
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-02_17,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2410020127
X-Proofpoint-GUID: eXRO75csbwJe3mOX-hUbZcsxPNPh9S9U
X-Proofpoint-ORIG-GUID: eXRO75csbwJe3mOX-hUbZcsxPNPh9S9U

From: Christoph Hellwig <hch@lst.de>

commit 6773da870ab89123d1b513da63ed59e32a29cb77 upstream.

[backport: resolve conflicts due to missing quota_repair.c,
rtbitmap_repair.c, xfs_bmap_mark_sick()]

xfs_bmapi_write can return 0 without actually returning a mapping in
mval in two different cases:

 1) when there is absolutely no space available to do an allocation
 2) when converting delalloc space, and the allocation is so small
    that it only covers parts of the delalloc extent before the
    range requested by the caller

Callers at best can handle one of these cases, but in many cases can't
cope with either one.  Switch xfs_bmapi_write to always return a
mapping or return an error code instead.  For case 1) above ENOSPC is
the obvious choice which is very much what the callers expect anyway.
For case 2) there is no really good error code, so pick a funky one
from the SysV streams portfolio.

This fixes the reproducer here:

    https://lore.kernel.org/linux-xfs/CAEJPjCvT3Uag-pMTYuigEjWZHn1sGMZ0GCjVVCv29tNHK76Cgg@mail.gmail.com0/

which uses reserved blocks to create file systems that are gravely
out of space and thus cause at least xfs_file_alloc_space to hang
and trigger the lack of ENOSPC handling in xfs_dquot_disk_alloc.

Note that this patch does not actually make any caller but
xfs_alloc_file_space deal intelligently with case 2) above.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: 刘通 <lyutoon@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_remote.c |  1 -
 fs/xfs/libxfs/xfs_bmap.c        | 46 ++++++++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_da_btree.c    | 20 ++++----------
 fs/xfs/xfs_bmap_util.c          | 31 +++++++++++-----------
 fs/xfs/xfs_dquot.c              |  1 -
 fs/xfs/xfs_iomap.c              |  8 ------
 fs/xfs/xfs_reflink.c            | 14 ----------
 fs/xfs/xfs_rtalloc.c            |  2 --
 8 files changed, 57 insertions(+), 66 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index d440393b40eb..54de405cbab5 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -619,7 +619,6 @@ xfs_attr_rmtval_set_blk(
 	if (error)
 		return error;
 
-	ASSERT(nmap == 1);
 	ASSERT((map->br_startblock != DELAYSTARTBLOCK) &&
 	       (map->br_startblock != HOLESTARTBLOCK));
 
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 48f0d0698ec4..97f575e21f86 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4128,8 +4128,10 @@ xfs_bmapi_allocate(
 	} else {
 		error = xfs_bmap_alloc_userdata(bma);
 	}
-	if (error || bma->blkno == NULLFSBLOCK)
+	if (error)
 		return error;
+	if (bma->blkno == NULLFSBLOCK)
+		return -ENOSPC;
 
 	if (bma->flags & XFS_BMAPI_ZERO) {
 		error = xfs_zero_extent(bma->ip, bma->blkno, bma->length);
@@ -4309,6 +4311,15 @@ xfs_bmapi_finish(
  * extent state if necessary.  Details behaviour is controlled by the flags
  * parameter.  Only allocates blocks from a single allocation group, to avoid
  * locking problems.
+ *
+ * Returns 0 on success and places the extent mappings in mval.  nmaps is used
+ * as an input/output parameter where the caller specifies the maximum number
+ * of mappings that may be returned and xfs_bmapi_write passes back the number
+ * of mappings (including existing mappings) it found.
+ *
+ * Returns a negative error code on failure, including -ENOSPC when it could not
+ * allocate any blocks and -ENOSR when it did allocate blocks to convert a
+ * delalloc range, but those blocks were before the passed in range.
  */
 int
 xfs_bmapi_write(
@@ -4436,10 +4447,16 @@ xfs_bmapi_write(
 			ASSERT(len > 0);
 			ASSERT(bma.length > 0);
 			error = xfs_bmapi_allocate(&bma);
-			if (error)
+			if (error) {
+				/*
+				 * If we already allocated space in a previous
+				 * iteration return what we go so far when
+				 * running out of space.
+				 */
+				if (error == -ENOSPC && bma.nallocs)
+					break;
 				goto error0;
-			if (bma.blkno == NULLFSBLOCK)
-				break;
+			}
 
 			/*
 			 * If this is a CoW allocation, record the data in
@@ -4477,7 +4494,6 @@ xfs_bmapi_write(
 		if (!xfs_iext_next_extent(ifp, &bma.icur, &bma.got))
 			eof = true;
 	}
-	*nmap = n;
 
 	error = xfs_bmap_btree_to_extents(tp, ip, bma.cur, &bma.logflags,
 			whichfork);
@@ -4488,7 +4504,22 @@ xfs_bmapi_write(
 	       ifp->if_nextents > XFS_IFORK_MAXEXT(ip, whichfork));
 	xfs_bmapi_finish(&bma, whichfork, 0);
 	xfs_bmap_validate_ret(orig_bno, orig_len, orig_flags, orig_mval,
-		orig_nmap, *nmap);
+		orig_nmap, n);
+
+	/*
+	 * When converting delayed allocations, xfs_bmapi_allocate ignores
+	 * the passed in bno and always converts from the start of the found
+	 * delalloc extent.
+	 *
+	 * To avoid a successful return with *nmap set to 0, return the magic
+	 * -ENOSR error code for this particular case so that the caller can
+	 * handle it.
+	 */
+	if (!n) {
+		ASSERT(bma.nallocs >= *nmap);
+		return -ENOSR;
+	}
+	*nmap = n;
 	return 0;
 error0:
 	xfs_bmapi_finish(&bma, whichfork, error);
@@ -4595,9 +4626,6 @@ xfs_bmapi_convert_delalloc(
 	if (error)
 		goto out_finish;
 
-	error = -ENOSPC;
-	if (WARN_ON_ONCE(bma.blkno == NULLFSBLOCK))
-		goto out_finish;
 	error = -EFSCORRUPTED;
 	if (WARN_ON_ONCE(!xfs_valid_startblock(ip, bma.got.br_startblock)))
 		goto out_finish;
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 282c7cf032f4..12e3cca804b7 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2158,8 +2158,8 @@ xfs_da_grow_inode_int(
 	struct xfs_inode	*dp = args->dp;
 	int			w = args->whichfork;
 	xfs_rfsblock_t		nblks = dp->i_nblocks;
-	struct xfs_bmbt_irec	map, *mapp;
-	int			nmap, error, got, i, mapi;
+	struct xfs_bmbt_irec	map, *mapp = &map;
+	int			nmap, error, got, i, mapi = 1;
 
 	/*
 	 * Find a spot in the file space to put the new block.
@@ -2175,14 +2175,7 @@ xfs_da_grow_inode_int(
 	error = xfs_bmapi_write(tp, dp, *bno, count,
 			xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA|XFS_BMAPI_CONTIG,
 			args->total, &map, &nmap);
-	if (error)
-		return error;
-
-	ASSERT(nmap <= 1);
-	if (nmap == 1) {
-		mapp = &map;
-		mapi = 1;
-	} else if (nmap == 0 && count > 1) {
+	if (error == -ENOSPC && count > 1) {
 		xfs_fileoff_t		b;
 		int			c;
 
@@ -2199,16 +2192,13 @@ xfs_da_grow_inode_int(
 					args->total, &mapp[mapi], &nmap);
 			if (error)
 				goto out_free_map;
-			if (nmap < 1)
-				break;
 			mapi += nmap;
 			b = mapp[mapi - 1].br_startoff +
 			    mapp[mapi - 1].br_blockcount;
 		}
-	} else {
-		mapi = 0;
-		mapp = NULL;
 	}
+	if (error)
+		goto out_free_map;
 
 	/*
 	 * Count the blocks we got, make sure it matches the total.
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index ad4aba5002c1..4a7d1a1b67a3 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -868,33 +868,32 @@ xfs_alloc_file_space(
 		if (error)
 			goto error;
 
-		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
-				allocatesize_fsb, XFS_BMAPI_PREALLOC, 0, imapp,
-				&nimaps);
-		if (error)
-			goto error;
-
-		ip->i_diflags |= XFS_DIFLAG_PREALLOC;
-		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-
-		error = xfs_trans_commit(tp);
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		if (error)
-			break;
-
 		/*
 		 * If the allocator cannot find a single free extent large
 		 * enough to cover the start block of the requested range,
-		 * xfs_bmapi_write will return 0 but leave *nimaps set to 0.
+		 * xfs_bmapi_write will return -ENOSR.
 		 *
 		 * In that case we simply need to keep looping with the same
 		 * startoffset_fsb so that one of the following allocations
 		 * will eventually reach the requested range.
 		 */
-		if (nimaps) {
+		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
+				allocatesize_fsb, XFS_BMAPI_PREALLOC, 0, imapp,
+				&nimaps);
+		if (error) {
+			if (error != -ENOSR)
+				goto error;
+			error = 0;
+		} else {
 			startoffset_fsb += imapp->br_blockcount;
 			allocatesize_fsb -= imapp->br_blockcount;
 		}
+
+		ip->i_diflags |= XFS_DIFLAG_PREALLOC;
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+		error = xfs_trans_commit(tp);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	}
 
 	return error;
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index a013b87ab8d5..9b67f05d92a1 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -333,7 +333,6 @@ xfs_dquot_disk_alloc(
 		goto err_cancel;
 
 	ASSERT(map.br_blockcount == XFS_DQUOT_CLUSTER_SIZE_FSB);
-	ASSERT(nmaps == 1);
 	ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
 	       (map.br_startblock != HOLESTARTBLOCK));
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 055cdec2e9ad..6e5ace7c9bc9 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -317,14 +317,6 @@ xfs_iomap_write_direct(
 	if (error)
 		goto out_unlock;
 
-	/*
-	 * Copy any maps to caller's array and return any error.
-	 */
-	if (nimaps == 0) {
-		error = -ENOSPC;
-		goto out_unlock;
-	}
-
 	if (unlikely(!xfs_valid_startblock(ip, imap->br_startblock)))
 		error = xfs_alert_fsblock_zero(ip, imap);
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index e5b62dc28466..b8416762bb60 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -429,13 +429,6 @@ xfs_reflink_fill_cow_hole(
 	if (error)
 		return error;
 
-	/*
-	 * Allocation succeeded but the requested range was not even partially
-	 * satisfied?  Bail out!
-	 */
-	if (nimaps == 0)
-		return -ENOSPC;
-
 convert:
 	return xfs_reflink_convert_unwritten(ip, imap, cmap, convert_now);
 
@@ -498,13 +491,6 @@ xfs_reflink_fill_delalloc(
 		error = xfs_trans_commit(tp);
 		if (error)
 			return error;
-
-		/*
-		 * Allocation succeeded but the requested range was not even
-		 * partially satisfied?  Bail out!
-		 */
-		if (nimaps == 0)
-			return -ENOSPC;
 	} while (cmap->br_startoff + cmap->br_blockcount <= imap->br_startoff);
 
 	return xfs_reflink_convert_unwritten(ip, imap, cmap, convert_now);
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 4bec890d93d2..608db1ab88a4 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -840,8 +840,6 @@ xfs_growfs_rt_alloc(
 		nmap = 1;
 		error = xfs_bmapi_write(tp, ip, oblocks, nblocks - oblocks,
 					XFS_BMAPI_METADATA, 0, &map, &nmap);
-		if (!error && nmap < 1)
-			error = -ENOSPC;
 		if (error)
 			goto out_trans_cancel;
 		/*
-- 
2.39.3

