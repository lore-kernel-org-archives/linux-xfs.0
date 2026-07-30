Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E135043990D;
	Thu, 30 Jul 2026 13:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785419066; cv=fail; b=ZTczYSydAUr61VVfnEE0skx6pCehR8TjvUbJnQ+q9NknBFTXWTe0vxk02BjJD03cVFaaTSkMt7waYubPEqyCJlprGjjNAMczhNzQ3SHReutT0svTf6qgSkW1xRKuEWMqibwvq5lFn9HP1quXT4xvH7v2tzG/78E4PzC3palsoIQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785419066; c=relaxed/simple;
	bh=lzBC1VteaEgOgEp1C8WuYD7LJicqNPXyu5AD/vwOga0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WmG5wpEu6FjqbewXSrNZ1ASCu6y+zDvpMucq9b5cYOwEuIUdYJi9wAtMKjTfE+Vj5jUREW3gtSD+ZByB0I9Sc4D74plTHAdD4wB+N0w8L0bcgPX3beRvPX3pLICEiRDVNuG5AoU4rpaUIs1867cY4CuwXzyHycFhIIcHtDmJNNk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=unknown smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=eHA8Rrc9; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=tempfail smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="eHA8Rrc9"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UDEacg3885332;
	Thu, 30 Jul 2026 13:43:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=/29tVIwbHPq+x70GTiY2Wih2g102FdILmgfUQaNwNFI=; b=
	eHA8Rrc9Jt5SXNhNRCInER1YeecMiXh0zxZrGJ3zr87mPQxMztmm6aJNLsFo8Sds
	pRGyfN+46BL0IMKVOwqBBbgtRMZj9MuMGyAoZLhgBUaCqN0mcsplclIFmjqvTiEM
	2q10/KIeP6aODVSb6Jg+fSI6IPzlI0V7RRYDAQZeIwOtdqK1inI5J+jEz6hgRBzl
	wCyuRsDb0hD4x6Jt09W2BuJ0LRZ0RHoF5PXd0VCNuTsmCY3gnzoJ32XZQayGwV0S
	jt/zcaozCP090GjEOas6lukmpCt3XW1jjyS8h4bD0PKQ93z7W1BjU/T02GdGD3Yw
	yskaHmsA2SUlA3brCCoMDA==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011053.outbound.protection.outlook.com [40.107.208.53])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fr5m807ev-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 13:43:56 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FEGssPCjReTZ/+QqGgMV9OzjsOfk5SCjKZ2nLHjF/DuFojdF2ShiOcgBwXhFf1bpb7tasG6v+zSccjpcO9o5iyMigzXqC1ZRtOv1OJl511dswaAcYu6m9RYJBDIxqHU+lPEKjr2885dO91m9BBcwKhZ+5sC0JdgjrYDpMa0ZbiwdsqpgB+9oaRjFvr7aKiMH8f1HXmhQi0KvLkrATyBTPIlFXAuY2L6enHCztv3YHlelKpkl/x5MoGefd/E8OLugCOyfOLvzBFlwl7lVWTBvllH3jsUV8fP8um4jg+1M+ODRl21kHXYL3PZBSVZJzufqnV1WIPnECqptlHu9LKruVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/29tVIwbHPq+x70GTiY2Wih2g102FdILmgfUQaNwNFI=;
 b=rroFLO3mv+AajN7owLBH4d5QjJ0WEfwldu4ULOCNvZ6y2II2cCGgksITg6LYxdPgvwwbY4EICnySKAFXlihdla5LP8OMB7fDdZayuxnf7/lOVBbIL6PPuunWAocOoO2Kh+cyxGR91/VoGBqtJmiHtt/A/phNu+/KjLuM8pvnh964GqF4YcdHSVmrWX9KJmZO7fdZlKZTaUNh2jKWjZTiv8Xz3vtNG8YMNAqRmEKQxFw/AXKCv5Z75KhPWb6h6eTdjJClTpWPS48tNDKITOyN11m57M8WELaDDOlgOy+MsrFf5ZuHuqudubUJc788PaRN1Sl0on3ugfXzIFAo2HT1QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by CH3PR11MB8518.namprd11.prod.outlook.com (2603:10b6:610:1b8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Thu, 30 Jul
 2026 13:43:52 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0270.009; Thu, 30 Jul 2026
 13:43:52 +0000
Message-ID: <537b5885-8829-4291-b588-28e54d0b3aed@windriver.com>
Date: Thu, 30 Jul 2026 21:43:44 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] xfs: don't hold buffer locks across sync transaction
 commit in xfs_sync_sb_buf
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260722133844.2900030-1-yun.zhou@windriver.com>
 <ams1vhkIBQOXQI_l@infradead.org>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <ams1vhkIBQOXQI_l@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0004.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::22) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|CH3PR11MB8518:EE_
X-MS-Office365-Filtering-Correlation-Id: 886876cf-8233-4fb1-14de-08deee409727
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|10067099003|4143699003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Ipr2rpdHvn/XmWqEdGIQlNCVkYuok8jmpbLzfyMJwPMkuSvxH9gfiLChR/2i1xpKxGqYh6N9+QMz/w66ByN9BzafY4gzntPuBfoDgZez8IJMvelLBgVJb27dLCnTaj3hy/YEJeLsnhtGYTDU33PUcSDyy1Tuhl4WVVDUUYd0PVeW1XG3osVy09/ZhDQYwoSQb4YWR+YxJlLXyLXCvuv0ElvEzawetW1yjvM8X1UjB2+DwYD9ifxjOagyo9R60mbDAenfosTAqJAQDdgeDdg44Io5LppXls7uW45kT0k65pKDrpfzJf5VcF+qSNynlM4/iZytP+4zCzjGuHA707keh4owYlIIjHLUYTWVuaoCNbYziMlMRsoxyPFw+TtZfE2waciAgQJuRF2m4txVjQIOEffR3ZbT9BLhMotfviB8aFgMGtlcPcvbrDDmUfAHEEVzSChmfiHOhtMxF6GWG9PHR9g2y658wRHeGaOc0T5FkwFs/AtbjO5JSzf4TLUwuCq7AIdD0IxtNEMxacelxCG8m0xll274VwHyViGU5Hb31ah6wh3qjpPJxCJyQdPrHxn0YK+TsV8nFDoYtlzED/gPg77HxvhAGhsCRFOWCztqVuOMoNF6+FUGT0czenysLcjOux3CQDVcLrvv2brzSfZ6OTX1juRASgxG0v4k/mwRYa8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(10067099003)(4143699003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?azNMUTg1a3loZndoOHdaMzY1RzVaUEFzcVAyVVJzQ01nNXhpdVR1QkVPMGRQ?=
 =?utf-8?B?WTY4YjQ4NExNRWRqOS9tWHU5anJvOXkvTTF5b0RTKzJTbVFCR2c4dXpqNHI3?=
 =?utf-8?B?UWd2RVFZWnNURFFRNmd2aHNjQkNqWU56UFdtUDVMU3hyWXlTOGFnUmpxUGR1?=
 =?utf-8?B?Ui9lN3B5SDdZY1dCcXFKZldkS3hKMjlFTS9tZ0RleHo3VXJNK2RucGUxT3lK?=
 =?utf-8?B?ODk0VHIrcVh6WEpjcW8zMCtmVjF0Wk84bGVGMHRFUGpHTlhqVUtIOER5d2pO?=
 =?utf-8?B?dWxkMDFUUGQvOWl3aFcvbUJWUXNLMUF3NzZxcG90Q1N1WTFqT05MRzFoVU9n?=
 =?utf-8?B?dUlocU12eFowVXdrUERYRzFhWFFMSXYrSGlCSHlQQSswR0l0a0Q1L25QRWdh?=
 =?utf-8?B?S3FVVmhaTmk5cWR3Yit3NGRKdWhURWp3RDM0QnlEc0JLUlRydExKdzNHKzlP?=
 =?utf-8?B?dUlFUUlOdWNmalpFRWpyR3ZGejlHY3hYWkR3T3VmSFhQbzRLR0JKVXNJTnJZ?=
 =?utf-8?B?TWl4a0o5UjEyMUFIMEV4cGh6cGdORFk2T2Z5QmVGcHBKNEdtRjVNOHhjOXA0?=
 =?utf-8?B?OTJJVTA3Z1BmQTFuN3lEM1RkWEQxaGhmU29lNW9WcDVaNTFCZ0Z1WjRmVmRH?=
 =?utf-8?B?VmFxYi9RcHZVNkswWkpFbkdCQUl6SjdiSkNyU0tVc0JHUHhnRE5DUWlROXZk?=
 =?utf-8?B?QUJ1N2Q2N2ZOczhaL3Avdm9DVU9OTlNsSytIQ1RLZHdOdmpXN0dxeE9zemRo?=
 =?utf-8?B?WlUwbi9SclBrOGtDQzF1SWVSczR4UWN1ektpNVdVbjNtRjJveUtvUEgxQ1Zz?=
 =?utf-8?B?VmFCa1V5R0Qvelh6NWVYcE5uditCTEUxT0k3OVVEMUVOeGo2NDM3YmdVc3Iv?=
 =?utf-8?B?VEFwOHcvSHJHcEo5OE1PUHJpdHJ6SnBTVzByNlU4UmRtZnRpUFZYVEtRdVNR?=
 =?utf-8?B?SXFMdFpLR01YRWpUQkVFYVg4aE5jT2NKL0lzYlRkN0ZVelZEdXZIa29lOC9C?=
 =?utf-8?B?RGdUQk4xNk1lTWlQME1ESGxUMEw4VkJjZ3lYQjZmNzNTc3B6cFRsNUQyL3NU?=
 =?utf-8?B?MFI3WnBSUTNvOFgrcHlzMDFRSmJHSUY0c0pESlViVlBpRVZlaUdtWU5pKzZJ?=
 =?utf-8?B?QTV0OGVuZFJWVnliSHp2bVROZHNFVzNoMlliNU9kelYwMEdteVJKMkFrdkZ3?=
 =?utf-8?B?VkJ1R3Y5T2Z4UUFXTkY4NEVDR2FZb3k4VHVqVnZpVzk0T2htVnNmZHZ2MTFw?=
 =?utf-8?B?QWZFc3UvbDQrME45cFdHRmFyUGxHRVdPaDB5MDh1MGtORlB2UVU2VXh2Vkts?=
 =?utf-8?B?RE5LY3VaZUVYU0gvTE9BTzRrTjRUU3UzVG9PeG4zZ3FSWG1PTXdsNkNBVm9l?=
 =?utf-8?B?dFFscjk0d2VxSVNEaEx2blpOYlo1QTA0REdvTXZjR1pMcG5oZkRrT0pyVThp?=
 =?utf-8?B?VU80bWlSZjlnMzE2VVE2UDA5ekt1NU1ZdHorUE90YkswSU1EcDVBbFlrTWdq?=
 =?utf-8?B?ZGZhaHROWTMzNG5MRFBva2xrU1hnQUdDSTZWNlYra3ExSmxreG1jbjRua1Qx?=
 =?utf-8?B?VnQ2SkVoRFY4NzhZejJSVlFHZGMzTndDVnFITDVFWFpGSlNQY3lvY2JIV2hC?=
 =?utf-8?B?TDE1WlhRQ1NHTkp6eHJmMEt3UnhGakt1bXlyK1Q3TGZabGNZWDk0NWZRWHFY?=
 =?utf-8?B?YVVtSVJEb21YLzRJOSswakltQnpZUHJtYVVUK0hwMk9lSEZUY0VoSUlyOWNB?=
 =?utf-8?B?N1hsRUtvTTdiK2Y4Z0lBdWJjb3NxQ2REVU4vQk1IOTBJdGtBcDNFWGZwRy92?=
 =?utf-8?B?elR5YW4vZFc0WHVYKzR2dXhnOGhwVXo5V010MTYyWVBpdU1DQ3FXbzl1Skw3?=
 =?utf-8?B?bTl1S2RiZ0twUHBmcllrMGpHQjlaYW1jZ2NlVGpYazVlK2tBSklYUkVWZ3lK?=
 =?utf-8?B?SEFteWJwT21PTmJnUXcreXQweWlWRjhxK283WHFzQ1hTdGc2eWc1T2tkSXNS?=
 =?utf-8?B?NW12S3k0dFdxRDR5bjg3K0U0TFk0ekQrN3FNVWNMUkxmek5odVc1S0YwQkE5?=
 =?utf-8?B?ZHlwcEdhNjRWUlBwWUN0elBRbFZma2xObWVRQlNaTHpWb0hBSCt4VVNMZCsz?=
 =?utf-8?B?RjBPOUd0U3loYU5oTW85MjJpMU91UTNnK3d6TDBNZitlaGhQUFVYS3lxLzFY?=
 =?utf-8?B?aFl1UVp4SVduTVZqWjRPU0RiblFpOVY0WVAwcHRYSTNuU3lQeHZENlkxbjc5?=
 =?utf-8?B?Q2FuemttM3R5WnZqb05kRG1uNDZNaFVWZUFLRW5aOEo0dmYwRkNmS1hHQVpk?=
 =?utf-8?B?MTlQT0I1RHpVU1NhTStUeFhuOW4vTDVIcjM0aUpQbjVqNHRpQXd0Zz09?=
X-Exchange-RoutingPolicyChecked:
	rdL0qZ0zP2HCd/FKg4gGIRSTm2PnyF7zazUHYuZelbCAm/AJfOjkwgp/37KBxWV4QRlH25dwl24cK8qRNj1q2B6bLrXdFMyeI4CBaH//AZi0pW3uspvPEpjHdRhzyaRgyxpqq34rkX2KyXx/6sYjEdm/rfeWhpWhH68g6tNBy6zmfTKJB5rsMU+0OTBJ8wtJB4FjLn0csIPA4ItpNoYgjZj0DHmhwQECYPKr40XHBjTB/10sAQ24DhzWECLWPrGlTcs+qFIW8nuNRzkxgEgNFq24VTm0kYvCNYxbuxOcTsvnTetTrY1Fk2JKhQQO0DIGaVIs/Ji6CVpIVryGA5J0tQ==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 886876cf-8233-4fb1-14de-08deee409727
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 13:43:52.2644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N60IezjHKOD0pkzOTlWshgRtn4O3cvJk8pTlT6HnVqxFSinTCEQcrYtGtwIj/IiagBR2ssV3+DhIeqT1aBLlPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8518
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEwNCBTYWx0ZWRfX2yYIfaSlu8h1
 qAQnH5MY1Iqqwj/MQyQvXgcfGeSzz6Kq0iShAYPajS+FG3vVVggfab0f35fZnETEROsTy1pdYw7
 8+5uCz8RbZQpJut3UNBnT1EFqsNpk8/noq9oXZm6bKRx78SmxpR4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEwNCBTYWx0ZWRfX6McKJpZ1J5QX
 p87ZxScx8aNvrODTs7R54XZDGqcck8+iPZTNgqX22Gg8+Qoi0x11JVEWpL7CPpfUvnR89AOJtlD
 kj5FbCbx4GuwIMOScQT74z4+Y1efF6UScxoTzLtwxwPZGPPQ5+Hee4Kq9fwHUkjmj9Y2hs1NH31
 xTfd5kxnsq/rO8bYB/ilf3jfzL1ObiYETdo9B7WYS1SAJqbn95dmestm7McXcD9SUIi1o8Zpnww
 GQ8xfdUfwlgbl4EzNww64VakWsWL51ELZx872U5P1e1z9sekkzB4t3EEFFJZx1zxGcdT7eOFwTN
 l3CMEqp+Mx+IoFc5dxdFRgrpJrH8pJAGiVZtZqH81jEZ22PpkBFDm5d0IpUdB4OMxE3W9atdDo1
 W5Z3obUwRD4HeEFG4aoGqk0SSqyi8YYsz13pMjcuFqY3cvrnYHXly8i+DRjURPFYJZRDCgmt43L
 ZKeHbxtD+OafmXVigrg==
X-Authority-Analysis: v=2.4 cv=dcOwG3Xe c=1 sm=1 tr=0 ts=6a6b551c cx=c_pps
 a=zYvZvYGA3P9ImFnKnvSfFQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=fTW__CHxibyLmBMfj2wP:22
 a=x3xrIyHCBBi7OEY6fxIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 0WsRW-3LO3IEXrZ9jTHeGB65sKYKkgca
X-Proofpoint-GUID: 0WsRW-3LO3IEXrZ9jTHeGB65sKYKkgca
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 adultscore=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 clxscore=1015 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300104

On 7/30/2026 7:30 PM, Christoph Hellwig wrote:
> On Wed, Jul 22, 2026 at 09:38:44PM +0800, Yun Zhou wrote:
>> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
>> index 47322adb7690..929677ad95b4 100644
>> --- a/fs/xfs/libxfs/xfs_sb.c
>> +++ b/fs/xfs/libxfs/xfs_sb.c
>> @@ -1470,36 +1470,35 @@ xfs_sync_sb_buf(
>>        bool                    update_rtsb)
>>   {
>>        struct xfs_trans        *tp;
>>        int                     error;
>>
>>        error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb, 0, 0, 0, &tp);
>>        if (error)
>>                return error;
>>
>>        xfs_log_sb(tp);
>> +     if (update_rtsb)
>> +             xfs_log_rtsb(tp, xfs_trans_getsb(tp));
>>        xfs_trans_set_sync(tp);
> 
> No new here, but I don't think the transaction reservation is correct
> here.  If we're writing both the sb and rtsb buffers, we need a log
> reservation for two buffers, not just for one.  Separate patch,
> though.
> 

Good catch. I will leave that for a separate fix later.

>>
>>        error = xfs_trans_commit(tp);
>>        if (error)
>> +             return error;
>> +
>> +     /* Re-acquire and write the sb and rtsb to disk. */
>> +     xfs_buf_lock(mp->m_sb_bp);
>> +     xfs_buf_hold(mp->m_sb_bp);
>> +     error = xfs_bwrite(mp->m_sb_bp);
>> +     xfs_buf_relse(mp->m_sb_bp);
>> +     if (error)
>> +             return error;
>> +
>> +     if (update_rtsb && mp->m_rtsb_bp) {
>> +             xfs_buf_lock(mp->m_rtsb_bp);
>> +             xfs_buf_hold(mp->m_rtsb_bp);
>> +             error = xfs_bwrite(mp->m_rtsb_bp);
>> +             xfs_buf_relse(mp->m_rtsb_bp);
>> +     }
> 
> I don't think we need an extra hold here for both buffers, just
> a lock/unlock, or am I missing something?
> 

You are right. I will change it in v3.

Thanks,
Yun
