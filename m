Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A711A256E;
	Thu,  5 Jun 2025 15:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749136833; cv=fail; b=J6gnJiNG92jjGJuo3yNHQIAymgzfVBnY2V+N3zsfSN907ct0IkB3W9okj2kIesic88nOrccr9BKUTFCOkjlpOIshwwSHU79FmUi1sOyhm7zuVdp7n5vzMDzjDOz97ODW8g27soi6FH+o2pw/X3xtGa5/77ogiBbVM27XujP+FSQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749136833; c=relaxed/simple;
	bh=hur1Uccm68IdauCP77V55/SsuAq0tvWPQGSsrAMuekk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KLOCQXk3T34/5H+FiYt8w/tKFrNVkqjEABj7NLNHCwQA557med3tsQPGxPiTPKjFPuRCLEEq+4M6v62uiiSkxkM+SxI0YfVe6bRuoblqmQlK1ujEndzJdv3Hf6/vL5I8+i51YMk/FA8XmKSiN9H7JB3Ke/XQSkoAzxxihLCqo6c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hIgoYdTU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ca8uEW9j; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hIgoYdTU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ca8uEW9j"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 555Atb7T004948;
	Thu, 5 Jun 2025 15:20:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=fA2YZQK/rtlRezja/6nBJhXo3rQEj+yaLuQwZVmFhNs=; b=
	hIgoYdTUuv3Pq3Ldo0++FUCx2gRtJySoO+dKDgMcuDqjmpR8sBMCQqjQvXF6Lh2+
	sa3vPfrse2QqWKpRSOq5zcybTJYkS1EZCX2aCn/BZN2SaJfUIrkYFAJgPRuXB+Ny
	91IDR5z/D7Uhv6uIHhvVQojEP4AISOl4vZIylGvTA493dsyJoNoPRqwzp0BSrL6c
	83mUWr1WzinUU1bcAYMFp9Q3sbMDQEUpGhe+07dpLLt6X5uQ1E497iS+vREqiFoE
	i31nkdndcYXlPFUMt5TrSRdpOvTmj/HtHwYC0Jue2hdBUG+Wtu9h3MUsuBznBRXL
	pHJCI8vzXwUgsF3VvdWzYg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471gwhe6ty-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 15:20:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 555FAuwC034871;
	Thu, 5 Jun 2025 15:20:26 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010013.outbound.protection.outlook.com [52.101.61.13])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46yr7cf6g4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 15:20:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iC8kENx7fzWLuDci5CtVGKN8NQmz6DUZOexJW+h98f7JMQlW+caIY0F1le1RJNY+KrjaBOFhgbXSQCQxUbNaQL1n9TL3fG6IIsvt66N+XL2tF1VFdzYLcJz39bNrmhZhW/jAo0MKspDIh9ed+nNpe40nhqkUpk/WudxU7P0dIKBgttSppP7IArgr04FGjD0GOM9xUjc8UEx0issYp8lmBWZQ0/pPU2m/8Hfh+Q2u66ZXPoQlrGzoRSlwROSGP6qTxHrv7OIZLZ7mk3THgg8FQ60Fy7BL2F2HUSZbyRNKyl2F9xkqKPOxA+zgJGbBliCu2iQu4csj9LhIkh07uli9PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fA2YZQK/rtlRezja/6nBJhXo3rQEj+yaLuQwZVmFhNs=;
 b=zLD//WDjkwvWwd2KXBowLz+7963qzKftTGz2N5zM7CefPGCLTzkVFyZs9ZXSM+/gphO3sLMl7OoT9Tt0wwe1yzWPpnR3B1qx9qugM99RhFOquUb5PMAf7bkc7NPCKBR0G/9yhIAgYEV0fgzJalmPTtV5JURB7aQ4HsluCbdKSjnGXe+uMUxNYF4A6m4KPOcnuxWWKDq7mq+/BDymkkqDwKY+DQguwIBgImG5fO/vZOq77YIRAw4JqJBTHtzvSfVbhbTQs6oYZy78qwgTzd/04s9QyD8ySZcxA5a5//q4ZzVbVFPZ/Krh8w3mDWoXsRcL64BkOXZuAeMHnXApmR7seA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fA2YZQK/rtlRezja/6nBJhXo3rQEj+yaLuQwZVmFhNs=;
 b=Ca8uEW9jB5KlUdWrL2gC4ny0/SMiQxH2x5vAAP28b3USWhGn/nOrNXCujkgf6em0C/19zFyqUsdBFb8JAnKA1gYmBZcoorTBcB4WbOJz/UhXqPMGTZLOivLUMTdIJjuPNIvx/7IczQ5JbkctFrkH5SC6klGtTevUOP5mTgqeEe8=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BN0PR10MB5159.namprd10.prod.outlook.com (2603:10b6:408:116::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.22; Thu, 5 Jun
 2025 15:20:23 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8746.041; Thu, 5 Jun 2025
 15:20:23 +0000
Message-ID: <9073e63e-97da-4641-ac96-336678676e88@oracle.com>
Date: Thu, 5 Jun 2025 16:20:19 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] common/atomicwrites: add helper for multi block
 atomic writes
To: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Cc: djwong@kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com
References: <20250605040122.63131-1-catherine.hoang@oracle.com>
 <20250605040122.63131-2-catherine.hoang@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250605040122.63131-2-catherine.hoang@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P189CA0050.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:659::28) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BN0PR10MB5159:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f44e223-47c2-4725-8642-08dda4447d85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V1hrbTRyUEo5NFBHSGFTMmI2b0NCMmVzUGNjK2gzWGEwc2JrNTlBMmRheTBa?=
 =?utf-8?B?UUpiSmxzWlF2SG9MeDVFUXdoczRWaTNhcjRPNVYzOTE1eUdwY2JBOGxXSWlZ?=
 =?utf-8?B?bERyY0JITHFwRzA4cFltOGZKQ1NvTUpGdGJLY3VUbXo0dnZGb2tYekZjV0Q4?=
 =?utf-8?B?R2crNVhKeWovR0h6MnpJNVlZa1pGc2ZrOXdYNnlSbzB2SkI4YVpWQVQwRTZI?=
 =?utf-8?B?YUN2WWw1NzV4RCtkNUhseWVoWEJVbU9KbXdwKzJZdTliUmxLWEE5UTFWMlBG?=
 =?utf-8?B?S0dzMjU2Zk16aThtaXBBY2tpQU4vbmp5amNZSTdFRTliemNaY2lVZmZpSlNa?=
 =?utf-8?B?OTZqcmM5Tjd1Zmh6aXFWVUorRUhJMTg2dzQzd2JCMjgzMkw3M0d0dlNZcWZR?=
 =?utf-8?B?N0FsaUxlRjR4RVpad1VvNHdKZWdZcWY5TVNkN0t5TU1ReVV0VTZqY2d4NW83?=
 =?utf-8?B?cUdrM1hxZlJnNlRRQW9EeENjOWtRQ2N4T1h5UjJBTG5NV1hCekhvUGp6RDk4?=
 =?utf-8?B?RWh3MHFoNDV1SlpnVGFNWU5TY0lCNjAvSXVCa3B5T252QWtNTk1ldXhta2dm?=
 =?utf-8?B?REpTTUtvK3h5cGNPbVhndVFGcGNzMC9CUWRsVGdNMlg5c2F3ajU1L3RMSjVy?=
 =?utf-8?B?ZnJYSjA4U3Iyc2NYdDRUUUJTMlMvM2g3SGZBNEFLRHlWelJLOHBpNkJhV09w?=
 =?utf-8?B?aUtYd01abWd3YTNnYnlwcSt5MGg4Qmo0MUNEOHluWFBpZ09aYTA3RzlJWlJw?=
 =?utf-8?B?UkNSZGlDdGJHcEpuOW93L3h2Y0NVV1d3b3pSZDNUOHZha0gxNTFYc2E4Y2Ex?=
 =?utf-8?B?czgwVTlCN2w1cGptMHdScTUxQnVxVHBHMTRuc25qVU1oWjJsdWprc2dndnhs?=
 =?utf-8?B?d1A4NDBrWkZldTlYUWtBRkxicjNSaFlyUWRPYTZ6djhuVS9ZSDJ3dzJXVjFW?=
 =?utf-8?B?Sm85Nmp6TjlKNnA0VUo1a090Q09KdmR3YTFnNmF6MW0rdktrMUVlWi9NTktL?=
 =?utf-8?B?MUpvdnB3L1QyMmhTb0cwMTNGR0F0c2d5UGNzMXcwYzVrUDJNeUhpNWlFVnFM?=
 =?utf-8?B?blcvYmIvVDJicGtJcGpIcVRpZnJyRFR3OFgzeVByME9IT1FDK1IxOSt3OGFl?=
 =?utf-8?B?ZEIxNmpKRU9QU2F4cC9iOUxPM0RtWDJYQWhOZy94aVlROWhTTWJJN0hybkgx?=
 =?utf-8?B?NjZSU01YVFZuNjBIK1FIRUhTMlZCSlRaZE10dUhCSmlidDBjY3dXSlBxczRv?=
 =?utf-8?B?NkFLckp0Y1BlL29zZGVKaWE1SUhSQW5xMWhtZTgyVmhxV3RaYjV1QlhsdFNy?=
 =?utf-8?B?V1cxekhwdXZhNmFDem0rWGgxT2doV3J6dDhxS1RLTFF6QnIxb3piRGdEalVx?=
 =?utf-8?B?QWpjYVp0ZXJXUlNvY3loTFROZi9FMXM1akx6blBoWHNzV21KWkhkQWRCTGg0?=
 =?utf-8?B?UWh4MjQ2aEoweGJDdjJBYmR5SklWTXh5RElJWldwM1BjZzl5V0FBUUV3UDRn?=
 =?utf-8?B?VUpLTkFNQytBUmZuQ0RLbW5wNi96V2VZSk1uNFNmWkZOaThJbWxNK3lKV3Uy?=
 =?utf-8?B?Q1lwTUhpZ1ZXMGU5bXg2SWIyb1Z6NVpsdlpYMEtidzA5NHpHTjBpVDlzVU9i?=
 =?utf-8?B?WTNpUzBBeTM0Y1lHc1Mwb2RZUUZuSjRweVJydlU2bndkZlFWT1UraXdobURx?=
 =?utf-8?B?OWtLeEtvRXNIMm1WNkJqTW5TTGVNUG9zOERVU2lqaFdIZm9PcFJoTmhXcVhB?=
 =?utf-8?B?QThxSGsxTkx5bmk2SGRRckcwQlJhRjNDM2ZaYjB6NVU1VWFvbDFWN3FvWGQ0?=
 =?utf-8?B?UUpxZjRFcVBidm5SY2xqM0IweHdFZUVGU2h0dFBZejNSSmlmSERJTnFTUmwr?=
 =?utf-8?B?UnJQQ3dwZ3RNMjN2RjVvVVFTTUh4UG1jZDVxT3REbDc4Sml5YzA3Rm1Yb0J6?=
 =?utf-8?Q?1NuCW/Bbl90=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bU85SFArUzEyeVBsdEt6aThMeExmM1RtMHY2Z2pSYnlpNVFDWUFaV2YrY3FD?=
 =?utf-8?B?SWJ0U09CckZpM3JFSXdjblJSVkc3ZzM0bWFLczN5NThLOFU0WW4yQ2tSR3dU?=
 =?utf-8?B?a3d6RFpWQ1l4bjJEUWdIakJBQjRNamlMTVQyTG9HcnFOQVU4VFNqSVB2OHhL?=
 =?utf-8?B?SmtvNkRhc3R1QWVmY3cycE0yN2t4S1huUUR4M3NtcXFDVlNJdVJVdWhTK0Fa?=
 =?utf-8?B?SGhCZERqWFhLNjMyNUlTL1QwK3QzWUZweGhOeFVLVXl5TkdibXVYbFQwTUZI?=
 =?utf-8?B?WUl6cDB3d2NVL2FSRHVTTmtXTU5JTG5BaDMrQW9vOCtzY0hrWE5TTlp5aTVm?=
 =?utf-8?B?ZXRFVzJXNThVMDV5U3hHMjBmNDFLenNNbVJzOWhiNnZGTitaNFM1c0Q3c1g0?=
 =?utf-8?B?TENmMWZiUEVUbnUzaFcveVI2L0tPUEdNV2VnWUdLVWE5c3FFbVU3TEdIMzVo?=
 =?utf-8?B?TCtwSWVBNnpnMFJqNWJHUnpmb0l4MmZsQVdoUFlLamVxeG54V09FWGJPUEZG?=
 =?utf-8?B?VTIwQmc5SmVxT0xpdjNBQkFVZWJneUhlSnVXR1cyUG5qK3kzbXd4V2lPeVlq?=
 =?utf-8?B?aXdkcjZtMmJsck1OU2JXZkVYZEZic1kxcDhUVWpyUCtuSnZmVDRCTnJFb0RK?=
 =?utf-8?B?OEdjTjdWRzUvYWFmMHloMDJ3WFpRMENPbkU1VGx4VDA4QnpGNzFRZ3ZqU1RD?=
 =?utf-8?B?aDhQdTFSR3M2enNrbE5FTHVDMnNNUXRjdnVheGxjY0dwYmp6bERqbnJaaE85?=
 =?utf-8?B?NDlMcUtsdk03dGxOaHNiZVFiZGR3OUtmdHF2ZjU0NVRIMUlLcTNPSjBTL1NG?=
 =?utf-8?B?R3ZIUmMrbWxiNDFFM25IU3ZvNnBVbVhwMm1nT080RHUybDlUeTRmeCtHdDNs?=
 =?utf-8?B?dTZyY3REeEZwbWpiOWxkeTdRVDZLTGM1cFRoV3pGWENhRjZFN2JaNndzS0Rm?=
 =?utf-8?B?RkpPenBscHI2cXZnbkU2eGI4Z0doSGRwZDJIS3dxMDZ6K2diTnpNcVZnWklq?=
 =?utf-8?B?VjJUQWl0Z05YN2VhbmgyeDk5VFVRYXhFOFVxMys3UFRzWWhjazNZK0owZkNi?=
 =?utf-8?B?bmtKc2hWRXUxUWR1NmcyU1gzWk1lRzIyMCtjNWFXcTNaQ0NiYkNqK3ljVGwy?=
 =?utf-8?B?Y0psdU9YVXVoQ2ZEZk1tRDJyWUR6N3l5ZTBtZ2hxcGthSjRuVVlja0FMR1VE?=
 =?utf-8?B?VEhSeDFQQXFzVnhYN1lINlNpTGpybEhGekRWQTBqcitnRnJqQnZnSWtmUE41?=
 =?utf-8?B?ZEQva1BqVUhwTmsxcmRqY2wreGJEQjE3UEZhUGw3WjRyNUhuZjlsdUVnYy9y?=
 =?utf-8?B?dXE4YWovcCsrSkpQbTR1cVpnbm01VzZXOWd5QWFEOU9PTnpXTFBvYnJTcFEr?=
 =?utf-8?B?bENRVndkSFMzUFB2YWgvVGM4UThjcXBMUWo4cUg5T0I0RVNLd3Y4S0RVM0px?=
 =?utf-8?B?cFZlckNxK3JmUVlOMEx0ZkNrcUVMa29BdHd5NmpkZllVenkzckV6S2tnd1Yx?=
 =?utf-8?B?V1JINFJNa2pjMUx5dTR2bFhSbkNuSVpxZUx6TlUxS1VWKzg5ZnpLdnVPdUZo?=
 =?utf-8?B?RXY0RC9HcllqOE1JUUE5cWJpVkZFek1HTFFGWnNxdnNwZVM1N1BQSkNQODd0?=
 =?utf-8?B?S3RvZEl3a0NmaUI5S29DUE5qTlRucFdoNHJsSUtaWWdWcEt0NWxYZEF4Mjdq?=
 =?utf-8?B?TGhWeHo3VlZ4WUZFK1dhV1I4eU5PQkJIWk43bi9sYzF1SnFIQjM5dHJuTmtQ?=
 =?utf-8?B?T1BYMEVuV0N1MjFIQ1lmYUFBRy9yQW50Y3doalFhTFc4eHdlMnpjRlFML0wz?=
 =?utf-8?B?aDl5RXNZTUZBMjFQNHorbCtVbkpoVS91VitTTWVaQjZxVFE5Zm1RcG5pb3Ew?=
 =?utf-8?B?cWFoVThabXBsN2MrbTlRZnBPc2p1dTFxZTFkOFNjWEpjbkhwd201K25UcnJV?=
 =?utf-8?B?N21EMThma29HV2IwcGN1VHc0cWhpajZSczhsbSt3M2VTTVR4TUl0VDFsYkpi?=
 =?utf-8?B?SFBzSkZCbjlIaWdSc3J2cnBzN3FoU0Fnc24vbHNOZVdpMWNUaHhZUVNQWFJP?=
 =?utf-8?B?WFZMbzJpMDAybzFjWVVpTWprNURTcURKZTlLMmN5TEovN1VSUmJNVWVaOU92?=
 =?utf-8?Q?ok0rzmlvWq6fAma74bdxOccUk?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZjwIVu2MuTW1a5wSagI94ogPSTFye+qxhqz9IYsJvl5m8ExcxAc03PZONtxQZbHZPFv1D2rPRIoEZhEt6aJA9zAPiWwwi0KiqEjsotDcRB5UH9vwj0CHNE1Z7c3i3THataSf/mzzut7BOa7uG3ob2IzcNrl4ZosUInzFhSvcIlKVZ9cHHdl5zBS1wrJvpkKEjuF1neK6sqzlz+bQTVfXuX+2y63rn+iZ24Y012k8Noyj8nvz4pjGX4/KpUnmT8e0atdfQSHyi6X+kmu+Et9VTlCYQkZ41phLHB4/5no2lAVEr5LQ9+A2LcVTWwjmQDbwbkcbb2zWWcnnROUiHehLOb71JzAtle1YHLirv8Q1AjMChARlCkJfpZClo7EC3lIlZhA/1Wr/K4CU3cqgefVnDE0eKHxR0f+S44Q4/WS6TFED8w90GVpfRccx8R7KFmBcmU989XeyCl3XiqAQSzWWf0CjKs4Kxe1Fai7mv6i1+zfQANssIirhCJOu6iEOmxrYDUU8UzXMHP2aURO2Tkm+1wFsni/e+FHDpszRhevs66uqIFcr6VnBq0QozUuYNjoDQO8YTGHTACC229yDXo5bbmnPCNhLKpgKRjzro+ph7Sw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f44e223-47c2-4725-8642-08dda4447d85
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 15:20:23.0123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TspvMqCRh+Eaby/dmbCkM2k9C6BYVB1FWhvqosTls48l1CAzQHQn6rUEBJQTMJVGa3Bg33ngPRKqy0DVruXgRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5159
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-05_03,2025-06-05_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506050133
X-Authority-Analysis: v=2.4 cv=Wu0rMcfv c=1 sm=1 tr=0 ts=6841b5ba b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=GjJoXmgPIC35NYqHgI8A:9 a=QEXdDO2ut3YA:10 a=E1yzIcH3UoUA:10
X-Proofpoint-GUID: n0HfXNZY5nLzc24e3yw_DWu3HCbXan7t
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA1MDEzMyBTYWx0ZWRfX5TCE7Xo44hS9 AuN7Jgm8JZxG27i7d7zFhSQVSyfOn5z5taJL8HuiqzKIQIKiO8dp5vb0c4Y4oE0BJB0j0vtbjhz ol4aZrH95Ma+ftDenchQ1FDyKCnxIA1SdP3p8I9v8pqfgr8WTGrmaqEO+Nd5GEMGgXPmQHlCQhr
 DD7B9OFo/qqzrIbx9FLjxdQxi7fIHMsijdGkaj5/zSNbIF6KnsSSF/+g7jVeN6J0aI16T/y1R7D FKu3MzniLfmQIXCVVA8WwsX7m1R9Z7/FwCUozfDfjS3W5vSx3BJhJy7fz5u2DwYQ480emHwVe2d eKpIPDYFCfU9RTU+N/XBhBJK5i2LByUQUMENU55R3rAsaec5612VB13Z+gz3jfs0od1/Hq35Ixu
 /4kXAeRFHSb6gZmELPFsGVIsdUy00A/y2h3FpfMH6ptSMpNAbn+nRixHTvPierkokpgHjlLp
X-Proofpoint-ORIG-GUID: n0HfXNZY5nLzc24e3yw_DWu3HCbXan7t

On 05/06/2025 05:01, Catherine Hoang wrote:
> Add a helper to check that we can perform multi block atomic writes.

It would be nice to mention why we need this.


> 
> Signed-off-by: Catherine Hoang<catherine.hoang@oracle.com>

Reviewed-by: John Garry <john.g.garry@oracle.com>
