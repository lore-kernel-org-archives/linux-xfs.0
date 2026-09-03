Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE09D4AE10D
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 13:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788443776; cv=fail; b=o2CJgFyREezXeJ70RluEaG/xFNc56fgiVoN17EDykngfhkZ5yDq0jBk2QVygIKBa0eyjdXPDhgK4CZX3di/mlmoU5Dr5v/pp/QUhjDuQUJ/luZ2BnGaA+mB9sXzHVbXhJ4pgAROprzO5eEn00NMlWUCVSpIp34l2p5poralHX+I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788443776; c=relaxed/simple;
	bh=QXjmKXLbGRdAexQGYbfMzASr9uUsG+MiRdfXx+jY9zE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aoifWtD7/Kia34qXvIwfCZdw87/PzJbObxZIev/yqrcP9Ui1FzKwxgAtLhBtN5GeRq1tIdftp1HYf/q9o07IZFsQl8s4SBFtYG8fDmK2iU86LeXLISTl3eUf+oSP7bmOd7hju0TdmVNNi8naSvHRJEiTKhUjL7nQ0UT3EGktctY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Zn3vU5Wj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xQv1iBwb; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Zn3vU5Wj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xQv1iBwb"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 683DrI6N404993;
	Thu, 3 Sep 2026 13:56:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=g5IKzi45AaW7LnXPaOChVee6VG/Kt+9CbD6C5Tv72jI=; b=
	Zn3vU5WjrctKueFIMdu6mGyiePRO7RdHwE1TQ3suruh345pNJevl4qvkwvpELqBM
	2fhQEv0XcFUrQ5hGVgmvl8FLC7EgpKjNTYyeJga6/iKNVjEnGbGqRQKJWP1MU+XJ
	z5QDwke+B+iTGBhgvqcYphGyYjTPcUJAxBRLZmzr5t/UMTrac+rSxVavv3TbEx0w
	J3ZLsAB3JkrV7+D4tqEJ9+Mhuk/hpw2g+9tg/zEUh2mxKr4qALSdcLZDBLZ9BEGI
	Qoe4KyaN9nnnl3XLOb89Dtq5Jo9BhfZcw0ZcDQZrDi+/hJ4DOMxaYQroNY8r/Ii8
	Z92TpDYG/6pEXB6bHTF+Sg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbnubgy66-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Sep 2026 13:56:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 683Do8V5003419;
	Thu, 3 Sep 2026 13:56:00 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010038.outbound.protection.outlook.com [52.101.85.38])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvgur61-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 03 Sep 2026 13:56:00 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ELnS6uBxCE5+UsBRzVSLOF2SkIPLVUwnDtL4m1EVSuE+s1Mq9mHXms1mfbGpI+FJVlU4dcOu7RTm4JCYNCKMskp8URiOc8ykiqG/HSyfKRk/x3zSsDBYKocke0hq49yBFypZCJ70DfOvGnlnHj1Xio42nieYvi/oVLLb70cRzuGZSRjD0NWbeEwubQLxW8huxOyQgvaxTGlqCOwThVeEawY12HpBnwAbYQW4tcNWErCoHv/NCh/It7Ms2RaGCLa0+MTSLBqfGpS2xSyUdoqU116l8Bkh56oDfDUMcNdZsvM12fu0iA4Y5pi+qb2TmCe0h+nGAbzZw/eX3Oq68hNxaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g5IKzi45AaW7LnXPaOChVee6VG/Kt+9CbD6C5Tv72jI=;
 b=td9sUyMb1Tt114PuE07tFWIR9uQZomXwGubO0XrJv1T0TDEIBXjp2uuMMBiIiHKRkpb2pcE+Mr+WSNj8CktgfOpYpTb60MHUCtr7K9VVxNy5s2quwyCJP3D3sNdXwqiuigUbkMJcm3+rGyRy1ZivPRaJw+MWd6Hq04whjHN9IKhFgVhcCq8c9JR7cLKFVu9M3uMMhJzJX8WY00Nt2Bj8B5+87WImDHVEwRd94dni4wwuc3NW1wccXD/ERZzqwJW1rMwQ703nYEDBtydCUTeyBwLUI58vRUfifE+I93Jn618rM0ardCfVRXTdU+X+7p4dnFVSVjkR9AiL/uWGO9ERJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g5IKzi45AaW7LnXPaOChVee6VG/Kt+9CbD6C5Tv72jI=;
 b=xQv1iBwbJFNrBOFeetr2Ri7fus5IPB+N8q5xX3FWbrqJMnrjD/NesfccNI0SQGcKMDiHAdJS7Z0XkPWnHAYQZcDie52Kj5c3zFtzoXj9m3NxQwZvi27RzSDbNqhy09jG27ClpEJUxzMK4vgmKgkoW9lDOSX3p+o65CFjQKrUvic=
Received: from BY5PR10MB4337.namprd10.prod.outlook.com (2603:10b6:a03:201::17)
 by CH3PR10MB6883.namprd10.prod.outlook.com (2603:10b6:610:151::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Thu, 3 Sep
 2026 13:55:57 +0000
Received: from BY5PR10MB4337.namprd10.prod.outlook.com
 ([fe80::587:3850:b94b:3577]) by BY5PR10MB4337.namprd10.prod.outlook.com
 ([fe80::587:3850:b94b:3577%4]) with mapi id 15.21.0382.007; Thu, 3 Sep 2026
 13:55:57 +0000
Message-ID: <8cfc32e6-bce0-4291-8224-a26dfdc48f5d@oracle.com>
Date: Thu, 3 Sep 2026 08:55:55 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : [PATCH 02/38] xfs: fix dirty transaction
 cancellation in xfs_attr_set
To: Dave Chinner <dgc@kernel.org>, linux-xfs@vger.kernel.org
Cc: cem@kernel.org
References: <20260819001442.1451892-1-dgc@kernel.org>
 <20260819001442.1451892-3-dgc@kernel.org>
Content-Language: en-US
From: Mark Tinguely <mark.tinguely@oracle.com>
In-Reply-To: <20260819001442.1451892-3-dgc@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8PR07CA0023.namprd07.prod.outlook.com
 (2603:10b6:510:2cd::11) To BY5PR10MB4337.namprd10.prod.outlook.com
 (2603:10b6:a03:201::17)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4337:EE_|CH3PR10MB6883:EE_
X-MS-Office365-Filtering-Correlation-Id: 84a79690-077f-486b-8771-08df09c3141e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|6133799003|4143699003|10067099003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	158xPUiHAPLsVRflEEmNL0sGqh5SU8bwsSSZmQQNbB/1/63GUME5F8+IXIs5i10/FSFkez+7aHTfSIFokjLIYc9k+qJ5VsChTLl+2qNduXOiCRDLL9bhl2A2k+ZnUyx7g+EA/Wu2kMn8uO9MGUuCbYskBYouVqeshOZIfPMvrUjp8/PfgAaqEZmkko47a5XdSR/wBMhfP/CyHNDfErgH7ywl0KO6KESaMGSetRZwUGI2WGfl1SqXUOr2c7CyZTbPBNd+WwSKKa9XMXwg8B3j7nilPuYPC+YzYnfx7Fsm9HMKk7mZ8si4L9P6grvr8iM4Olhq7UtHbFylqV1MArVNdFibfUzHeLy46YpVexbRBf7QTAoYrOThQe+4/dYzAITlyo9nBA9yGWZ/zZ9xeiFhNNVgjmfSOADY7CN55t4CyUmtien4VZGrOauyN4O4BnRM1Qo5+C1iPjnZenpGCz4/RPqk6uP1EiAw+y/W3SfKn4XM5UdfjJ9Tj29hLe9UsMWiWtxOMtMshdXERSTOIPJfA59f60/kFgBOtrmbKsUgcMZ1H+635rFu8Fgf9V3iVWjdsCPWYDbNXY0H3ovzValwkaHaFNYKYWHvUGj9wJurPSyGd26ZpqGNG4Ks5MB9xweDOKvU+rutMKvNoAlrC5xzGBN+xpFlPoqtrpsGZMLUsf8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4337.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(6133799003)(4143699003)(10067099003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NnpaWkl3Qk5EeXlNaWN1cVU5WURXbW5PdktpN0FoS3gxQ3loaXl6M0pkeG1N?=
 =?utf-8?B?eFQ0THkyVzlkQXc5NWVRS2N5STkvdFNHQnF3RnJMeFVJb1VCbG1XWnE5NEFD?=
 =?utf-8?B?Zkt4cWZ1dTZxeGNaZVpNODByNVpKWDIxbXVobFdzTmJuT1pMWXVOUjZxUnBW?=
 =?utf-8?B?SnZQQ2Nqek1MKzRzbmFiczV4OUppdDJteHJlbSs5WDBUY2RPQnFlRWxxUFg3?=
 =?utf-8?B?S01Kd25ocjBwaGszejc4RFBId21xOWgyLzV1RVZ6R1hwN0NuUFZsTkgvUnN1?=
 =?utf-8?B?ODkxVTJLMUFQaXg0SGFuT1B3dlFNSW5NVG9CNTlta1lPOXplN1hKN3J5aEtw?=
 =?utf-8?B?MUNVeGdSRm4rNFhCQXRqMzRKb2UwcEszR3FsR3g1NnJXYjluR3NuOVNuQ1Uy?=
 =?utf-8?B?SDFKSWowV041eDdjSjZZUEtPQ3RtY2lUYlRuVWpJbTRtUnBjbUw2cmdjMTUy?=
 =?utf-8?B?dGJvd3dNd0p2ekV2eUZzeG5YL2FzRUFLQ294V0gxUWlBbEtwcmNEVTNFRlFr?=
 =?utf-8?B?amw1WVAwc1kwZ3JNUXJFU25mZWUwUXd4ZUZDbWlmMFYxcDFFSWlCcVRwUkFh?=
 =?utf-8?B?dzhaUzZoOFk4TXh0VXFiTXNnaGF4dUgzZ2U4OWRpY3pqSThLMVVIMzhJWTVl?=
 =?utf-8?B?WmdoTXFHdDE0bGd0SlkrZFJkYXA1SnlqODhQdDlUMFZVak5CN3RzYTJOaVZY?=
 =?utf-8?B?N3N2UHBPa2NhWlBKc25kT0U3aFVudFpMaGZrbjNJZnRZWXRwaEpJV3lMNkht?=
 =?utf-8?B?NkxMTm1ydDMySE0zbDRYb1RLM3R1WUtzMzlBa3JiYUZCYmhSUkxzK1ZRWElS?=
 =?utf-8?B?UUE4NFVqQ3k4cXNDTGpSTTFHRDlJUTJHbUJUWi94Mk03UVFHYkJuVUlodmR2?=
 =?utf-8?B?M2h0YzdzR3BpL0RNNjJaWE10MjlhKy80M1Z6SitvOTl2QWpwRDdGN0NUZnU5?=
 =?utf-8?B?S2xncGFXbFRidi9rRGJzeVFDRDVkdHh6ODJ0bGoxUTVud0Z1d1pnanhGTnBY?=
 =?utf-8?B?eXFGUHA1M0xObTRHNGlFVzhtYzdheVMveTZWdU44SE5UZkRaQ0tXYUhBekwy?=
 =?utf-8?B?L0RBNjhkajhnYnNjb2hZdEZCWXFQU3BISkxMYW5BZTA3VWJQaTdaSExiUHl5?=
 =?utf-8?B?TTU5WG84UTNhY1AvZnpMNXpQbUIvN2FLVTR3YS9LRDBnWVU1NzRhTEx4QmJE?=
 =?utf-8?B?eXBCRURFU0ZlWVN2c1BZTE5FNzFoaHVVM0xxUHlvRENwOTA2bkExMnJ3a2ov?=
 =?utf-8?B?dE5Dd1QwMjVYMnplQXdBczV1aDE3ZDJOaHlVTG1sYkpHc1cxZU5sL1Q2RWRH?=
 =?utf-8?B?d3JqQVdiMkpCcnNzd1MwRm5YUVJnL0tvOUxpTHJCRVJSdWR3eWppc2hJMWRF?=
 =?utf-8?B?SVBKa3ZLQllUUHVkbXhXbUxhVVhwTTNidHQ5YnlhMjhJT1FPcSswc2RweUpR?=
 =?utf-8?B?VzdSWkJHMFpONStXWWp3NStiUDBFd21Lc1lYZUttNlhYdjZsRWlaNlJxdUZy?=
 =?utf-8?B?RWZ5bVhVY3JGRk5LWDdHYitLYm9FbzFLWkRwNkx1OG9GMkJxV3VDdDEwK0E0?=
 =?utf-8?B?K0pRcDNzVEVxWWtTYnIyd2oxS0YzME5aOS84U2pBZFNFaVVlSTFyRFVlZTNp?=
 =?utf-8?B?ek5ZZ0NaaklYQTJvZ09pdjNKQmdXM2l5dmVSM1JCQVhaYVpMS2FQc1Y5Tnpn?=
 =?utf-8?B?ZkN3Q3Q3eXF0OXJIRFNrNk9MN0JSVHZ4R0k3UllSNTZ3U3RzdXU4MEdUN2Zk?=
 =?utf-8?B?NVRpY3QwYldpU3BMc0NqYzJ4Z2dYWVBpMGxCdDZXcW1haStoUHZrWTdmU3dP?=
 =?utf-8?B?cjJwSlZUeHdVNm05ZHYrTUVmWktVNEhtb1hzMjhUajM3K2pxQnhPdDFXWTRn?=
 =?utf-8?B?Y2lmSkF2a0pENnJoS3NYRFRtUjdwRnFWVlBGWE9lOWpjNkNhN0wzMW1FcTBP?=
 =?utf-8?B?VzUvcDhCS1Q1VU5wQTJEMjhNdlpuV05Ha3VYMzdqSW5ZTVk3eUpuUzZRMFQ0?=
 =?utf-8?B?NFJQcVpPTFUwQndmSC9WazNXdWdDYTU5RUVSQ0M3bDVsZTdYdDRwWkNVM2p3?=
 =?utf-8?B?T3pqdGxzdUx0RzNSd3pVTWFITjQzbks1VWI5dWdGVjdEMDFob01DL3JXdzJ4?=
 =?utf-8?B?L1JlTFNjTmFmUGVGS01JYnpUVFZUN0RxZHl1d3E0ZnJGRHFjUlBzL2VvSE56?=
 =?utf-8?B?T0RScTZtbWt2WmUwQkQ2TEhuNmFvNmtqL1M0SklHcklDbUdoWkExS0ZyQ3Uw?=
 =?utf-8?B?Z2dYSmdlY2ZCWkRucGZqazJqdW80R1FUU0xWNDRod1NOc1JoRzZBS1pNOWhX?=
 =?utf-8?B?eUFhMTl2RDdpUFBGM1ZzNDJjeE5CNVQ5Yksvd0J0MnJjSXhxNFdMVzUrOUVa?=
 =?utf-8?Q?+pxRqTtCXiiKMcNI=3D?=
X-Exchange-RoutingPolicyChecked:
	NO1cmNqfwBBgc/ZPH6uYUN5i3uUStqYT0QBF3wd4VPGridTWmrtGdsEBz08uNBNo7kdJO8H4zv3E6oEXrKn/+3TK9WiKTzPIsOLdPrykcwCruQJUh6CUzAsREcjIvtRskXeSmhhtF6Yx86Ruv7WoxO1O689pp14dEsZMhMsSWlFGPQHiJbruascp4rkV612pUESet1Nm82Lwa9CnrYBE3RbfWlkY4wHC/yi8kZgaN6E1lhMy8aVR8k+IuAlNis48Funec9vPHIWHC+VtWiWTudkWVfCWCZTpFgjge1Txk/fIR5Lj2yrj4veFtdoXJH3JMRKUL3GRVuvqPh6ivwb72w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xvNP3a0r7js1lV/tGxDc3rD9Zu4SSMcOW8uL+jv8oxx7FZ6+ykndl0NjhXNvHDODJIjP2wryj/uhvSGbLbaaoAzdqlflKoe9zRIxwBQkO+FOWyKFlXUA83w1atn3sD2Bg9r+9RDv10FlFI2HnDLRXt8wJzueXOBWHjXm9vXhGktHyStmNRpkhQRTxTdv0apwrU0CBeESxzbeJpe2HewWJpjwMtbDk3EV6hf1qaj/nHGgM2rtJzJsJGhIj6OYre/gOeUUeUr+4PrViSpnR5InE5qhVMQszebDg4HMgTaL9Z9CECvGXkwCefzQjsWMCH5sBTTN0paM3aU8+Xq3cr4ZNDnVcXZuZdznFNsrIXDVJ3hrK6G3j8CMbLDOqsAnZieSHAWYBr3wm62s5MzJPLC83hwVi9+H3kOC9a5NfsubKmb05aPTEdoBERF7CK8sBQEAZDDq+20QGxJDVY23v9ywZliDsgzKgXQbclMPVCMXASoKtqAQ5QGZ4RDbUwu5WBIBN8AqncA1OTyw++IPtFmNeb1sabLmx61x1F0Wx2iXildQhWczyTxcA429rvQkCWLGHA8HEsuzNnBvSdhZ+bwjCWjNGh5CLts2qWfEE+ESTvk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84a79690-077f-486b-8771-08df09c3141e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4337.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 13:55:57.1980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: modyhSLATiOhHr+554M2AERULCQByR+Nq49JcIs7KL012Mw3p2iiqM1vZifSe0GRmMuadKnOPute22TavVFtNdk7QRb7amMR/wdI5EOWjq4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6883
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-03_04,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609030120
X-Authority-Analysis: v=2.4 cv=QoJuG1yd c=1 sm=1 tr=0 ts=6a997c71 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=0HPdxQyJejeAu47PSjkA:9 a=QEXdDO2ut3YA:10
 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-GUID: g6TOjYq-AwTxe-ZS5keRVJ5DkwvsSyT0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAzMDEyMCBTYWx0ZWRfX0ndaDFQTiZ+F
 IwG7y/23a/RzkZYi4Pmt3pEh0+ZtNvZQFo6J7sH1EIfihs7ytnfHtMa9Gjcx/lNp0aQEu2VlXe5
 9SUdcbdmOF3Z8rdrhQQGxZ6XtprgMXVX1hwR8bOLA5nzWoRMfNfYkSbGdqjeb0IsKZhQ/edSdXB
 MXUYMNWW5GJR3H1gqKimJiSBsk47y3RYLlwnuVoMYoFPvkDqfmOjAvyFXbuWnEUXXATrFj38CT/
 FGhRQCR1Q8MRlQlzdr0+Hqabt/gyF4kGw7manlOhnOpncyNHJe4Psa/EnvVCuvw+JFFs26v5SZU
 YnT+wKHy3mD1oOXm2yUECdiCEjRPv2vOnNj1Xf++gff/E7K4yajDOlurZMuwA4U2v6bGBHVBM+I
 Jkm2xk3ippieorTob7xCE3FQjypzdc+9GHg3AajW6v+NPP5kcegFttPstSR1wYyAClAM4q7WC7h
 U4JvyySBf8plYijgdBg==
X-Proofpoint-ORIG-GUID: g6TOjYq-AwTxe-ZS5keRVJ5DkwvsSyT0
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAzMDEyMCBTYWx0ZWRfXwX2AQSBn9/Yg
 7lCjuyBftqk9/xJrLLMlW97rwzraxwWPUFeIyTqYUy+06j6J3Pp3DRL7anssVL+c2DziuICQ7OX
 D1h+lqzsh8jRmm63HOyrMGoAvOsQ7FrOZXPVYDNwdfS31iGS5J66

On 8/18/26 7:12 PM, Dave Chinner wrote:
> xfs_attr_set() calls xfs_iext_count_extend() before xfs_attr_lookup().
> If xfs_iext_count_extend() upgrades the inode to NREXT64 format it
> will dirty the transaction. If the subsequent xfs_attr_lookup() finds
> a result that is incompatible with the requested operation (e.g.
> EEXIST for CREATE, ENOATTR for REMOVE/REPLACE), the function returns
> the error and the caller cancels the transaction. Cancelling a dirty
> transaction triggers a filesystem shutdown.
> 
> Fix this by moving the xfs_attr_lookup() call before
> xfs_iext_count_extend() and validating the lookup result against the
> requested operation before dirtying the transaction. The code is
> restructured to separate validation from execution: first filter out
> the error cases that should cancel cleanly, then extend the extent
> count, then dispatch to the appropriate modification function based
> on the operation type.
> 
> Fixes: 4f86bb4b66c9 ("xfs: Conditionally upgrade existing inodes to use large extent counters")
> Assisted-by: LLM
> Signed-off-by: Dave Chinner <dgc@kernel.org>
> ---

Cc: stable@vger.kernel.org # v5.18+ ?

Looks good

Reviewed-by: Mark Tinguely <mark.tinguely@oracle.com>


>   fs/xfs/libxfs/xfs_attr.c | 70 ++++++++++++++++++++--------------------
>   1 file changed, 35 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index b3f7b2c34ad7..bf0e867628e7 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1136,7 +1136,7 @@ xfs_attr_set(
>   	struct xfs_inode	*dp = args->dp;
>   	struct xfs_mount	*mp = dp->i_mount;
>   	struct xfs_trans_res	tres;
> -	int			error, local;
> +	int			error, lookup_result, local;
>   	int			rmt_blks = 0;
>   	unsigned int		total = 0;
>   
> @@ -1185,48 +1185,48 @@ xfs_attr_set(
>   	if (error)
>   		return error;
>   
> -	if (op != XFS_ATTRUPDATE_REMOVE || xfs_inode_hasattr(dp)) {
> -		error = xfs_iext_count_extend(args->trans, dp, XFS_ATTR_FORK,
> -				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
> -		if (error)
> -			goto out_trans_cancel;
> -	}
> -
> -	error = xfs_attr_lookup(args);
> -	switch (error) {
> -	case -EEXIST:
> -		if (op == XFS_ATTRUPDATE_REMOVE) {
> -			/* if no value, we are performing a remove operation */
> -			error = xfs_attr_removename(args);
> -			if (error)
> -				goto out_trans_cancel;
> -			break;
> -		}
> -
> -		/* Pure create fails if the attr already exists */
> +	/*
> +	 * Look up the attr before extending the extent count so that we
> +	 * don't dirty the transaction if the op is going to fail with an
> +	 * error. Cancelling a dirty transaction would shutdown the fs.
> +	 */
> +	lookup_result = xfs_attr_lookup(args);
> +	if (lookup_result == -EEXIST) {
>   		if (op == XFS_ATTRUPDATE_CREATE)
>   			goto out_trans_cancel;
> -
> -		error = xfs_attr_replacename(args, rmt_blks);
> -		if (error)
> -			goto out_trans_cancel;
> -		break;
> -	case -ENOATTR:
> -		/* Can't remove what isn't there. */
> -		if (op == XFS_ATTRUPDATE_REMOVE)
> +	} else if (lookup_result == -ENOATTR) {
> +		if (op == XFS_ATTRUPDATE_REMOVE ||
> +		    op == XFS_ATTRUPDATE_REPLACE)
>   			goto out_trans_cancel;
> +	} else {
> +		error = lookup_result;
> +		goto out_trans_cancel;
> +	}
>   
> -		/* Pure replace fails if no existing attr to replace. */
> -		if (op == XFS_ATTRUPDATE_REPLACE)
> -			goto out_trans_cancel;
> +	error = xfs_iext_count_extend(args->trans, dp, XFS_ATTR_FORK,
> +			XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
> +	if (error)
> +		goto out_trans_cancel;
>   
> +	switch (op) {
> +	case XFS_ATTRUPDATE_REMOVE:
> +		error = xfs_attr_removename(args);
> +		break;
> +	case XFS_ATTRUPDATE_CREATE:
>   		error = xfs_attr_setname(args, rmt_blks);
> -		if (error)
> -			goto out_trans_cancel;
>   		break;
> -	default:
> -		goto out_trans_cancel;
> +	case XFS_ATTRUPDATE_UPSERT:
> +		if (lookup_result == -ENOATTR) {
> +			error = xfs_attr_setname(args, rmt_blks);
> +			break;
> +		}
> +		fallthrough;
> +	case XFS_ATTRUPDATE_REPLACE:
> +		error = xfs_attr_replacename(args, rmt_blks);
> +		break;
>   	}
> +	if (error)
> +		goto out_trans_cancel;
>   
>   	/*
>   	 * If this is a synchronous mount, make sure that the

