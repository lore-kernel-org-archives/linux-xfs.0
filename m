Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7AB37F30E;
	Fri, 24 Jul 2026 07:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784879699; cv=fail; b=JOfCGQi1mgNZlJiAv7tNcKyE1810zhqxQtA7asDB2A5GIkU0dqfS3YJHephJyTEFnyeuQMrgtif8PjqKY3ECelg6v0kz/B4fjtv04i0oSliNskCTDDNNCyHow3Qnpjh1HcQn74I/UpbCSRE2unL10nucpYEkl1zKMXxJDh4yUPw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784879699; c=relaxed/simple;
	bh=ukVsMI4HX+RsApCmpwHTtNPatJlHQedV6l22TO6XK7w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=L0jGPDBA0Ye4U4XHQ/28DMzGv1yYJfe7HpoT9RlEwWWo8JjL1vS2ac76SP9EDv5DsG3T3LKbTdep7fdph9Z+gP7d++4MMrZW2WaLt7Pm9zwWNmW2I1ba2jPMmL0I8rr6vr1IYS/7t2v02vfp6ygPicoRI7acEW7a5O0Ot0ZKPtI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=fail smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=a5dTMK+f; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="a5dTMK+f"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66O4mrk31115595;
	Fri, 24 Jul 2026 07:54:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=cvWsCJoL5PbCbP4unXzqA/WSn0FjR99gQZLMOOlJRR0=; b=
	a5dTMK+fkb3aPf9gnLJrWilA1E4cMHczhYuglHeY40r7HZiNna+fPju0O3+u/2X+
	CTSbCNXnUOP0rhk7C69T8EqvrhhUJsmkdTpnZpZfI15qy9AVPKNcsqDOHngmIUH7
	wtuGtH1hVUMzwJOQE1OZ/FOUmxKp2t1rNh2LOFw9VSn/vRjHbpv8jCENgWAJWFSa
	52/0X6d7nf1ovt0NW0fubJgw0cxLGiBnQhLbhDzJe4kyT6L+12RSDb50xTZEY5B5
	IIBF/X0XTrPOk3B/M8e8XZSDEiu8HOAC+EoZFRQDlMeY/FDU/a7Hj9ubfNEoaao9
	mkqrU0LweiWZ6ZdW+vr1NQ==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012052.outbound.protection.outlook.com [40.107.209.52])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fkdfsa7va-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 24 Jul 2026 07:54:24 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O9vKLawXsAyXKjvPo/FVt7hHFAoUXJ7T+si0cy2QAFG076nIaeb5OUEDG98jOdpfajPgeK/Fw1rslTOz0VI9e+Q0JugMpytL8qrCwrWC9CcK0jaWNV3tpqNSrhei3KfKQIzDMFewFky5ZfJwn/hIvBuqVPABn8tnLIz+4aG7ztOCQC6UT5LcepyrSXIk6mjZuI8GUzLKgOHGGlau3nMn0jFNk29TIMThoPSF3FKiKacIOLazjgWtQmEnlXaFFIMiVFXcb8ylMjHldvSeb7Lz0O4Xsad+43B3l5j+Q8k/OtU7UfqdddTIQX257OY3fOhO4880dq8rYnHghF1xneT82w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cvWsCJoL5PbCbP4unXzqA/WSn0FjR99gQZLMOOlJRR0=;
 b=Gb4x36bA7yPK+K7dziyzQSEkB0t81OQmAk5rrXoNRt+Kspzigo9qmuKSvI/umSXaDsMdp4Q6rAnXkniUCIFrKjBUA45+2lrpvZpb7U4BSqN3vs6tvjojpVJP2JFIZIDMYiZTCjSSx+C7XKsfQAgUVnoUm30YiH8uQzgIdrpWKeclpT/DYkxxOO1fR+zFWbGNEig6g18H39Al7no0GjYjFLjcoFSZ344Kg5XmAxrug8FUkRcWZU2co+mR9NLu1fP4Bvi/4/tQF4UYtb4SbzdPRr9gqwBlQZnvNL/cg9YKuuuuhGpjdVyRJRnfXb32+HkF2LH5yKybJohNcpIKCDIWgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by SJ5PPF8F93806F5.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::845) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Fri, 24 Jul
 2026 07:54:21 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0245.010; Fri, 24 Jul 2026
 07:54:21 +0000
Message-ID: <3f683dea-fdee-416a-8112-2db000c4cf4e@windriver.com>
Date: Fri, 24 Jul 2026 15:54:10 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: fix nofs context corruption in
 xfs_btree_split_worker
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
References: <20260720050522.3101824-1-yun.zhou@windriver.com>
 <al3dypUNu1VNZErK@infradead.org>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <al3dypUNu1VNZErK@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SEWP216CA0118.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b9::16) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|SJ5PPF8F93806F5:EE_
X-MS-Office365-Filtering-Correlation-Id: 884ec4a5-9a55-4f1a-9b95-08dee958c56e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|56012099006|10067099003|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	UAPvrHn+e6EV3IPkpsp6qQVn5egW7GycLhnHIKQNWvVW2I875ElPf6eV50thb+sZ179gEr1Vt+UEwczWxJFEmvWaV4gW5Tf8rifQxACD2+4wmfW/tbBGzdkNRw2iWl7oc9OXnWLS981vek7kLtG44EOGyv+/gAPTmHuA5bzjyhUHohGTJmFaKK5DnkR3CvEhuvziHq0wPJwFmiaP0okAetWqivZ2R6ayUzU4Wqabf2XBTXB0T4L7pbNhEq2gJ3llf1NmQL+3axfkFmhbIZoRjHYgq/839L1NncWvFj/o5vzxPRGzQUYK39eCoQ8St7JGLo46i+ZJO5ncCOrqmR4POtXOS9jlw8MvEQWHIca/es8gzJahc54Hc1jSp//lqHQuExmpqTrmZ6yQzZAT7fp0uhc9SR+Z6uUSVy0bqJgcXRiWgnzUjHs2fvSZemYggiNXvCfAU3m3UJAw95y/zFUjqu0qq5/6xbApU5C/yVKJvj28mZetU+0rYPqnILMY+BZnrEYxCeob3uFKjunKMtRu18uMiwLN+ZRlu52RN0/rmT1oTe7JeDwSYsJz7x24fyVR2/ujpuFhKirx8gEtM2nYWZpWrZBu3VhdImw93c2iq1X8RHnkAQesuC+ZpHfjBN9Bd1XHGiXQOqEnh5EyjQr3RH963tiUqcfuEHDankdWiLo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(56012099006)(10067099003)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aFJhVVpBTWYzYlJaUzhkVFpQS2Vvb0lVSnJ1MWVHcitsbE9Jd2xsa2pBY1N6?=
 =?utf-8?B?UlhsQzZoT0lUVVlhdUtVaUx4ZU1DMUg4RU5DKzRhbE1Zblh3Qk5oUkR0Njg1?=
 =?utf-8?B?eUFjNENlMG5aU3JpVzRpY093b1d6a2MwaGl0enZZdFBmdU5sZXlKallWL3JV?=
 =?utf-8?B?Q2podllVdHlSblVBVnR0L0lsbGoyc05hYW9XNStoRTdPWmdRMFVqcHJBL1l5?=
 =?utf-8?B?Tk4zbWgzYW9QTWM4ZmZhVEo5bk1UdTdGZ3N2VTRPN3lQbmJBcS9BSFNSemJC?=
 =?utf-8?B?elR4NFFuY1krNmNjTnFuZFJiSVhxTER2L21Da2RneDFrcHF6ZnVucUxBTVc1?=
 =?utf-8?B?OTdKRTE1TCtzanRLOUE4dmZKUVJKMnlxSERnMGVCZnJoa1JRazNvWEVhZE1L?=
 =?utf-8?B?dDRmczhuUnd6cGFBRHA4R09mYXA3c0hqNVc3bWcyeWR0cnlwTmp5TWdVUjUz?=
 =?utf-8?B?RWR2MEV4Q2k3RHZPVUtsNlgwWFpjZmc5eExTNUl4TGJENDlYc0lyMkhxSlFr?=
 =?utf-8?B?bHZjSExJdW9yTjd0NDdYcUI1ZTJreEVmRXFqWjZLckppbC83TjNjRXBpVWNV?=
 =?utf-8?B?V2gxL2NDV0g3SWRaVWJmS3JnMGxyaGFGcEI5Mld0T21vdVZMRGVHS3JwQkVp?=
 =?utf-8?B?dlZLUjV0Ti9zeGsvWjJNNHJ2Mk9Tbld1UWxOVlJKY0ZoMlRoK1NkOGlQNGk1?=
 =?utf-8?B?TFRFTlpSVXNnb2tIbmF2Y2FIcnFFSTZJR3pCa1dobHp0MHVZQ2ZYWXlYMDAz?=
 =?utf-8?B?T2V4MFdrQTc3NEJCYW13eHRJalM4OE1Ob0lZZ2svUUxnb3UrdlBoVi81NVpa?=
 =?utf-8?B?aHJEYlhkOVNLREh2azBTOWZKSzFkUmRobGxQSk1XZTF0ZXhwY2ZLNVNNRGJF?=
 =?utf-8?B?S2dXcU1TdFh4NTZvQnFEL21ldksxUEhXaERGaHF6eTQxUHlrMHUxUDIxMm5t?=
 =?utf-8?B?c2lxeFRKMFR6NzlrNjVOblJ4UWxCVE1Kc3o5TW8xUDlBVm56amVjREtMdXRo?=
 =?utf-8?B?ZG9valBycGVSRUtvVXJUdm44dUorS1QvQzVFOFZ2ZldPVkFnMFpPT0p5TUw1?=
 =?utf-8?B?NE5jRUtsZTlzOHBSeGNvbEczWmJkTTF5YjN3MEFld0dzTDdTU3BzTGhVWkhu?=
 =?utf-8?B?NmgyVGhRMEkvNTc2aVJUYjRmanNXRjU0UWdlNi9RZTRrWUFGWFo4UVJ2T01q?=
 =?utf-8?B?NE0vdmQwUnpUdE9vbWcrMXpNQTArdHErQ0JvVlhWWG13a1R3ZDNkOWpnZlY5?=
 =?utf-8?B?bUFVcC9wV1lZNDBOMXdzZE9FUlAwcjBINmw2UDFmd1d2eEZzK3V5ODUyaEpl?=
 =?utf-8?B?NGZFYUdTYVpmN3hONW51Q1hTOVBPWG9lQlVQWk1rZmVhaVc4d0FEYTltRVkz?=
 =?utf-8?B?TGJScCtDMlR4SmhkV2c5YzVsVldIV0I2R3Awcm1lR0VIS05oOHM5N2ljK3dj?=
 =?utf-8?B?dDdDRXFOVGpJeDVqelEwTTRTRDhWS2lxZ0JoR3dNQUR2cWthbXBpdDY4QzAy?=
 =?utf-8?B?MzFkRmd3SjVtVjIwRWcrS0IzdWFUODY4RTF1dEdRSkxqRTdSUUFjS05sL3dC?=
 =?utf-8?B?WGFDb0YyRTIxajZSbHBDNjNBWVMxcHdobGhBK09UWnNwQVNXdUk3SEQvdnh3?=
 =?utf-8?B?WGcvRGFqL1ZkcnVrLytHMzMwaTdjS3YvUEtuVGJmajN4cWt0RnE5WjJNU2ht?=
 =?utf-8?B?WWlDZzV3M3BZV0pBYWMrYm5BUVFGR2I2U0orRWFzRUJsMW5HVkxCWE5uaFN3?=
 =?utf-8?B?Mnlhbm5QcXJ4SnpzNlVkRUwwSFF1UG1jRzNFUmZ6Z082aVQyUkRVV3l3MDhP?=
 =?utf-8?B?VjI3MWlOMlN3QXhEOFlXZTl6VWJDbG1QWlExblpGL3dDNGg3aDNmYjN5eDRS?=
 =?utf-8?B?Ukw2OGVwd2hmWDI2Zmx1MVZaVVhrbmFTeHk3VnpITjlrYjBEbGFuczN1ZU53?=
 =?utf-8?B?VExHakQxeFNXWERxMG1GUkh3Qy9ZNnNCWkw5U1RzaXVFWkdMckFySDMzVHo0?=
 =?utf-8?B?UE91NXg4dTFzU3NaYnp5ODVJVDNsczdLaDdxalNCd0FrZXQzSDkxSFhJSXlm?=
 =?utf-8?B?ekdsL2p5MzRLZnpVY3I1SnZFVHlpM1Y2dnFHR3k0UmM3ZHhwMnNTRFlMaENx?=
 =?utf-8?B?QkpZTkhZRjF2SlFUK3QyY2drNml1RWg2cFcyUWRkMUpKVmlYbktJK1JiNGdi?=
 =?utf-8?B?L05JSU53WUt2NnRVdG5MR3BxNGxRbi9yd3NMVWJIOU9aZjEvb0M4ZkVlMzhq?=
 =?utf-8?B?aVBwZk90UTFKaGJKaTRXWFIyVHRnT1ZHemFvd3lYeHpEZk9DcGt0cnBwaWZi?=
 =?utf-8?B?WXJxL0l2c1FsQndrV3RQeHhqR3pFL29ISnVLK01icUxjTHRrUnpaQT09?=
X-Exchange-RoutingPolicyChecked:
	EFcmUrP1+X4i5PxeE+YvM5XoSdPFCY5XyBTnUpqYLsZN9SIRUnLLjKcgFioA2fncp4s1BedzhiFx4qFYTw2VymFP1VdzeLgu6O5cBR8ncNuvmCVoiBLc0ev7bRarqyDf+fukKyUqgneQnTeSP+SVH/W3awFg8qKYV/7bM1yIPJCZHTjCM/GBZohJmv9Rh3wKSqzLjwdvjUHVgTYzBHiqmfGUTjN5yVHdLVd1MdK+j5J+4d4atWTezpZeY8W7bq+0NwVCiRbRryU0ED33sPAhrlxoXXfv8tg0PUBfC01E3uEyLaaDOieMHt8+0nogDqJQz1fiW4J18pgl+W6T2b5U8A==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 884ec4a5-9a55-4f1a-9b95-08dee958c56e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 07:54:21.3018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SRJXKxoK1EqHGhW9Ga13NjjV5iXt0bsxeuxjSLlNKkqCWizzX51+AsApM6jiUtWqOVTbb3mX1EY7+BU6grDYzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF8F93806F5
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDA3MCBTYWx0ZWRfX0jwU98bhUazu
 zlF/7t0FPNILIbEE67SQsM55LTnHlYS8GKnWMWXVJ9Wsbgpz0vhKT75t4PD9c4BeAQpWS8AEUCK
 bPvBMxLo6bTBHDc2WYmpfHPayD13mDgbDmdM2zNyAkPWzj4tQe3j
X-Authority-Analysis: v=2.4 cv=EKE2FVZC c=1 sm=1 tr=0 ts=6a631a30 cx=c_pps
 a=GeWWyO5P+zJVL7v3m8oIig==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=klDOsUkWDRETUCZYPvoE:22
 a=mgsjeybLEnrXl880aBQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Zyq8fwKjDB0VcyAz0PSCVCmUVpjRQz3S
X-Proofpoint-GUID: Zyq8fwKjDB0VcyAz0PSCVCmUVpjRQz3S
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDA3MCBTYWx0ZWRfX6Uu6lV9FIkyO
 wk3eJTut3o+UhK7QJJBJxKBaL0guyjz2OfNQOa/K7YYmVp/b3TRafrG1c1NFw8uDxLJNMAPj3RQ
 wAl9N6ByALe2bwXaYT+H+Zvokk5rLyvDMhJN8RpnhTgtwmJUN02sbeemzkrr/ReIRREzVKr2Gtr
 MrrOE1hJxz6WpeilVjl5015Pec4/AgbVAzNc0MmtqWGXnmDLp4dBTh0SqXAiCMBOxfU26ePqgT/
 RbrFsE0wFFk5UYYPmpaEGuifvKzmJ22ArzHktLk0myLqU5Hyv/aNI6wbA+jzxDdJDMoXFUwgZJ9
 BXwF9+5VvCm1W5eqN6kDcZvIR1ztwMs5izc5GWyvPU6GrkE8u7m+UZJgpNay5q17G9Wtvitcpfp
 8wd0J2JIhaS3VFEHsjE/onp9Ya042BI+cHJgInUAGW5uwXGqPvbQDyJY4zwmEVb9UdUD8TmhLFe
 we3attjxqMTdAGXspdg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-24_01,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 suspectscore=0
 malwarescore=0 clxscore=1015 spamscore=0 impostorscore=0 phishscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607240070

Hi Christoph,

On 7/20/2026 4:35 PM, Christoph Hellwig wrote:
> On Mon, Jul 20, 2026 at 01:05:22PM +0800, Yun Zhou wrote:
>>        current_set_flags_nested(&pflags, new_pflags);
>> -     xfs_trans_set_context(args->cur->bc_tp);
>> +     nofs_flags = memalloc_nofs_save();
> 
> Note that the above is the only user of current_set_flags_nested.
> 
>>        args->result = __xfs_btree_split(args->cur, args->level, args->ptrp,
>>                                         args->key, args->curp, args->stat);
>>
>> -     xfs_trans_clear_context(args->cur->bc_tp);
>> +     memalloc_nofs_restore(nofs_flags);
>>        current_restore_flags_nested(&pflags, new_pflags);
> 
> and this is the only caller of current_restore_flags_nested.  Both
> of which modify the task flags just like memalloc_nofs_save.
> 
> I think we'd be much better of just killing all these silly helpers
> and do direct current->flags manipulations, which will both clarify
> this code and fix the bug it caused.
> 
> Similarly xfs_trans_set_context / xfs_trans_set_context need to go
> away as they were a part of this problem.  And to make this coherent,
> it should be combined with your other flags series.
> 

Thanks a lot.
I'd like to understand the scope you have in mind. Should the removal of 
xfs_trans_set/clear_context and current_set/restore_flags_nested be part 
of my nofs series, or is that something you'd prefer to handle separately?

BR,
Yun
