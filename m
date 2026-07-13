Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C92381E8F;
	Mon, 13 Jul 2026 10:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783937225; cv=fail; b=VdWM853XVBOAwW/C/MsAakeBG3+f3+YaHcn2xqNXkrYTqVpYb1eBVqgys6q8AyW4p7MkqeFUGwEv6p/rWG2R/HcmB9MaEDvhHSAXFT8chZkpLDNE66AN0MeyZjN+nLsa53h9wayXKrJHcoaKxftd7HKJUh15PLtKFTzDabNwooU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783937225; c=relaxed/simple;
	bh=W17vTq6V991rae1J5z/I6BrLOXaM+fXpIVZLIV73vg0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jAl5+yQHXZbO/Xc6Qhw9M6L3umUTT23d6JKtGu78+VEGgm7+7Rf4VDi7c5KhrMI6o8TqYbqfCS993NoM4iaRuIcMsniHjtNtccZShRIHUaG9E3GPCP9vvx+NAhpfjRogeG/rZNxSUiUT5m7v+5uoLk38UDmHUMkjkhOHanTaO7M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=MtJLV5v3; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="MtJLV5v3"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66D6QkP53026568;
	Mon, 13 Jul 2026 10:06:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=idtHBiYwD+T4cYqpnkePszKZ13vzgVvQnwqRvNM1mOg=; b=
	MtJLV5v3MIHo2RfKkMVKtqNVaKe8g+Fb9Z/TBv6yFcTUkbXH3PlK/0iApw0CTHsR
	kFLvDPZX35biDyAx3LwXz4ptf0nlJrC/xWYfIVyMiV6lnv6bYtbZ38R4P06PZv15
	5tTLTusEWErZEFVryJXXGqeOpu2LNPNLM1H/5taPmdAmJTjqpw1sDG+VMZBhH0Ki
	3n7Pn+96ozXgf/Wi8RJ0IwZ4iP8d9uDujPXBgUi9qjb1NDQEkDmwmIHwGk1Mc+Kn
	YHiOxELMK6KI1vf3IdjqS56XMeWXvL654XPZL5tGvEVlidD+vSb4QNc5vyspRfvV
	yQ4p7WO5SojjnOZJcMAXtg==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012004.outbound.protection.outlook.com [52.101.43.4])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fbct4j3fu-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 13 Jul 2026 10:06:48 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MNn9vOG78eGcPxOfdGU7J8oArnK+8nIbe1g243X+POKEDs42Ut1W3yaJIGUb8isxIkzw0HWyI+7NwRxocry2eqY+vuhRSyPU+7iOB5YD0lXCi2DScOAYRyFKux3Z8m2NcXX9SzeqFWqhiaUw9NndEUmScXtdPLSuudgSCjeDeUpgWB+g+gH6gPsF/FMtpxH3eHxuLK762K9XbC8dp8P5jFhOtnf8s+vt+TE//5QDgcHYdZsvxY7B2oyiq5IJ97kxQ/QLlpkaxkr3GqFEY7bLGYcBuEIh9D0i2R+YmyUmQ2Nz1V+Szto99RU7aipK0ENBpKSEmTqW3F7Zs9yHjXVG8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=idtHBiYwD+T4cYqpnkePszKZ13vzgVvQnwqRvNM1mOg=;
 b=CMVh6BEmdSm9255GnjSd/xTbBn9ExMpaAPiQR5DfDXNrnXmmBpJB0VmaTpNE37xCqG8KfVxFMGc2YNGDYLCqxADrzzL2Eo/iWKy0OpqExTs7b7FrymZR6YhbhnSQcQRWLkpmwElvPpfabnpNDkl/sJLtUFaRzdwPcM/DK4kc7DjLjp0MH+umc4eTdaW2Wus8jjO8icLKPFEdsStrU6iYfSneJkid7bboMFWYsGeveVYOBrGQFXBdWYxSWFRB1K8AutabuTPqinOhuk3JfjaPC8IPxUALPZ8RsJpttqG5+gbqXhDLSHeLJerTVAGp37l0O8Xr9tLcjs35M/qfozu43w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by PH7PR11MB7963.namprd11.prod.outlook.com (2603:10b6:510:246::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Mon, 13 Jul
 2026 10:06:44 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0202.014; Mon, 13 Jul 2026
 10:06:44 +0000
Message-ID: <7a053113-f678-486e-a78b-8f5e94e73acb@windriver.com>
Date: Mon, 13 Jul 2026 18:06:38 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: restore nofs context unconditionally in
 xfs_trans_roll
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260713035505.1635191-1-yun.zhou@windriver.com>
 <alSrO3aDTuZkX0K9@infradead.org>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <alSrO3aDTuZkX0K9@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SE2P216CA0187.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c5::12) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|PH7PR11MB7963:EE_
X-MS-Office365-Filtering-Correlation-Id: 52ec5638-adce-4360-d7b9-08dee0c6716a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|4143699003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	PtvbJGxG0SeneoWUR4yhLQfk+zvNcw/CuxAu+OB5NO8AV98mWdQ4SA98bwqxbfnsTBeji7XLkM7U2uDEbdOAnwvyG4DmEG/o9yfug79a7SmZW1mkUoeG45h/3x3p7zhs3aIC3BMKQb+bL0XlHVuZ5+iHz3ApDaFgQA1MFzRW1lQAzHf4lyG2sN929gzrjr7AjcL4a/0SU7oegmwRsbaGK6LkfaaH8lULzbMszonbVv3tt0lS070ZlpfZjhaD8vnbXli+EceoZmHAHJCKbm3TPtT4V9wDV6v84af9hg6I94oYvzKPWgmPkEzfEhGu6Eqmw+YKH0fvwlpWO5u9U6srkuapyNentoW9QrzUpcWKKjeQUW1Uj6qco3GLyw9LeJWuLDZQd34zjTeivSsl2upSxSp8qvEqmG1YRiWbQNc9A80qyGyN2wbSnVETeEBOaxq8FcdwVHq611ke8jEzDfcXypZcyG8dy4mJXy2vU+Ytv8kDx3lUhuQu/IMIA6wQS0Al19NtKo7Uxhs2IwJJ3tMaanr36fOLjAd09Da7mOP/dTN2l/91Y+EX2yp2zpor0OSF+FzxMLGbcFRNE2Nk7nDASLiWbqMpY6bEzNTLPI4OMJQGXO+PFXH6G6OyynsWHH62Qf9xFAhs5p23n/pmlbqhzPduH4ZRzfVORim3liMQt6w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(4143699003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WlZMQ1lwMHNWTjVSRlRXdXhaV3hreThiaWZmMTI5bEJMN3kzVTBqWVRXMjRV?=
 =?utf-8?B?RS9TSXlBYlBBUTZlSjRHdVpIUVJRSUZCT0s1TFBWVlRVOFNkZ29jSTVWQk1t?=
 =?utf-8?B?TUxUNUIycVBxZTlEalk3WmViOTE2dXZqY2M1Q0M5c0RMZmt4ZFBFUTRuaVZB?=
 =?utf-8?B?aVdtYXFLQnZCZkczOVJtY1BLTTVvY3dCS2M5T1hJa1p2RUVuRTQwc3VzWEE4?=
 =?utf-8?B?bnRGMXZhUk1oMXRKUFVlWlBlVmI2Zjl6eSsvRDlMN1dHWTQxTDBCSzVFUGlV?=
 =?utf-8?B?Rk9qcGdnTFVFUFM1U3QrSXJnRGgzc2JOWHgyYWtHb3lObTNQRms1Wjh5SFMv?=
 =?utf-8?B?dXIrS0wzZXFkRVZRcTY2MHBObktWNEJndzBqUXFVSWY0QnVmNGx6L3huU2x2?=
 =?utf-8?B?aW9HTEhBTGZKd1FMRWRseWRUdmRJeXZERG1UQk9jdnd5NmxEZ2U0anJLcVZD?=
 =?utf-8?B?UGVoeWhNb05OUHltVFNEL3ZEYmU2ejF1WGVjbUhqSmxTOUpCTFBUeThINkFy?=
 =?utf-8?B?cGUzaHBKZUp6aXZVNmZyUElhVnVxdmJ3VGVSQ2FUUnRMbjlkaDVJb1VHM3lI?=
 =?utf-8?B?QzlNRFl6eU9aV3RTR0FRV3lSVjcwNDZrQVF5K0kxMW1QZmlyZVN3K09IQkQ4?=
 =?utf-8?B?dmVwc0R0cDJqZ0FTTTQ0ZjlxSStmcVBRWjZxWjRiZHA2OWFRRDBQZGVYWmEw?=
 =?utf-8?B?NEdablgwbjlJM0V5eExadG1jcnlISUU2NUlhK2FyS3B3MVRTRkpFaHFIOXJI?=
 =?utf-8?B?YkxFQjlFZ3NkVUhYU29wLy94QUd1azZmVFhUOG1XRzc1dXpNTm0yL2dVWEdj?=
 =?utf-8?B?RGlibHc4eHNmYThXMy9rM0wxZml4MENIczFHT0lYMlhBUXJpdnJlaXhMU2Mv?=
 =?utf-8?B?eXB3UlRwSU1kdEY1SDVHTitKSkFyWmZZRW9pUmZiWHRmdjNHRU9UZEFaaFFN?=
 =?utf-8?B?bEZIamNzcHhGWEhtMDIybnMzRUtTSDVHbm1pTVZEL3VyTzg1VjNRU0VXUXJE?=
 =?utf-8?B?UkZHOEVvMG9tS2RSUTVKNzZTa2FxaS9hKzRXamJZRUJQQXE5ZW4wOXVxS1Yv?=
 =?utf-8?B?U0dZdm1mRFg1OU5hNStmTVVEQ1N2bktkNGV6NktNTmxBS2tJWkZsM0RxOW5l?=
 =?utf-8?B?ODNROXNWM1hseS9TOTFHOWt5MlJqci9Sb3FYVWxMODk3bWNHbit2ZUFVcTFs?=
 =?utf-8?B?WVRHbXVxVHJjUU5HK1VINHJ4Q0ptTUMxMG9qNmtGcXA2TXB3SnM5eDlhdkpW?=
 =?utf-8?B?TFFRUjV1ZDlwUUtiSGxUMWFjM3pqbVpuN2xsZnd4emsrdzYzd1JzNzUyYlpa?=
 =?utf-8?B?eDNPbXEwS01LWmhLcXNtbTVodE1jMmFOdHl5QnFjaHRlMG5XY2ZyQ1JCLzFB?=
 =?utf-8?B?WUVJdkpNc2tKL2VMV2xJcUo4bXZqYURvTTAzQzJBOU1FdXBFUk93R2FPTkda?=
 =?utf-8?B?OFkwSGphcThEMkVLSER1TDVPRlRma0ZpSUE0WUp5MXZxaHhkK1ZyRjMvNk55?=
 =?utf-8?B?ZzJObEJZZDI1UWt5ZDlGYU15b004RnFEcyttdVY3NkhZVW04aUZDaTR4eUJW?=
 =?utf-8?B?MEZuR09WdHN4K1EvWlo4aGNVOTJoUjVwcHh2MHJJN25hYklEMlZlMUlBVS9V?=
 =?utf-8?B?YzVlbDdqdVFJRm80RGppRXA5Y2JlS1YwTWFSaDR1eEJoNWZoUUZGQVVKVm1H?=
 =?utf-8?B?SjNIMGNFV1BUU1lkVzU4TVZEVXBOd250QmdVY1BzUXQyMGRIbmw5QXRYd2JV?=
 =?utf-8?B?TkxSQmJJUmVET3FtZ0Y2Q0dDOGx4dlNRRmRNYXM5clRoeTdtZmRjdUJzbk9h?=
 =?utf-8?B?UFozQkdGYnkxdmJxb0pJaDE5ZzVLRHI3eXoveTJOSno3d0RXN2hrRTQ1a1ZU?=
 =?utf-8?B?MXBvMXRyUFU3ZVN2cEZQcldlU0xlU3ZEMDdZOTd4UmFBTnpkNzE0NTNJWlVh?=
 =?utf-8?B?cXprR005SFF5T0JMcnZwd1BjUDN5UlRHOS9hY2cwOUMwMm5PcVhqbWNVNTZs?=
 =?utf-8?B?QllFZldxbXRjeG93S0dVTWJzd25oQmM2Z3JSZDA3UHprRngzb1dlSis4ZUtY?=
 =?utf-8?B?VkFhM2pHMWI0cEtYQTV4Vk12QzVWWHh5UDhFcVM5bXYvTTN4RjJqRXFhWXpY?=
 =?utf-8?B?QzFpSzlzcTNoWXZTWXgrZVA2VFVKWG9hTGlEbE1nd05uYVVjSFBZRjFUYmFF?=
 =?utf-8?B?dkFQN0RmM3liS0pCaTNKWmNGWDJ4VTBKMXZjL1lmSlNUWWZvdEhiRHdRbTFy?=
 =?utf-8?B?bzJJeXFTRDFWVStIOUkxaWYrY3RUTElLWjRHNW5kUHdjWFJ1WEh1WVRJL1d0?=
 =?utf-8?B?MVI4NTFiMk1kVkc2YzV6ZktYZ04wTDZ0YWFVR0EzNmJnS1ArVEpCZz09?=
X-Exchange-RoutingPolicyChecked:
	N52wYjMq/rbewreix6kLTKeb52eXVu8lastLjNbNhMX67ifJnmXc1wyDrj4QVfAooPjZ6BlEl23+YQwf5eV57ZyBbfag7ydQswV6Y1d6QMT7LB5taa58cLb2nHe/ahMnRwptGRAVBYOtnmMmw1RZTYdTJzLyEC3R+21NEjLoqYFrJ6hoo9l/NR30exsaBvLhR8f8TBEYFYxvIYY80dSXPjO74ivjQlqz+Ldwgef3ZzvLibQABMKMlynv+Jr7RI41wfw5Zaxw0j7tyrpej3VLl+kZvn8+2RbkddbyxZMl4L1hu4D9zuTmOtIBMwOuetNIVTPgdYrL5/+bbJrB/yajng==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52ec5638-adce-4360-d7b9-08dee0c6716a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2026 10:06:44.6569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RNyGbJO9281PXMqj9ykL7HdGf5dIiltdALYOa0vT8YGh48V1V+AS7DBKeAL1kysGiVW+waXm+8JsekAiawfu6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7963
X-Authority-Analysis: v=2.4 cv=J9CaKgnS c=1 sm=1 tr=0 ts=6a54b8b8 cx=c_pps
 a=1mmXF8F6+aLADKsbn3w/2Q==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=fTW__CHxibyLmBMfj2wP:22
 a=m02ADufbSeu-mUpWbTMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEzMDEwNCBTYWx0ZWRfX8MXUS3NYsHw9
 tGO3h5LRSitfSEmcEmEFKdfH1Fj7ufQUeMaK5tByssPTxDNLl4R6ovrmsT3XOgb81DNhcZLTHo8
 55aB9M6p5qhAI0IKFxGXeugu9475P50Kd/5+y5zYJjnYGBlXle7y
X-Proofpoint-ORIG-GUID: OtA237vy-xakvqzwm-_hZgQm5_UBwqjr
X-Proofpoint-GUID: OtA237vy-xakvqzwm-_hZgQm5_UBwqjr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEzMDEwNCBTYWx0ZWRfX/NSyKo6OzlK9
 AKmFwbtI3Tth6Ij2tYRa6WOFCXGTYhDCF7PWOqrVbIzJPe1Pj0CTLy0GGFMZD7ZoTMt2vdueVg2
 nMb/Vrt3VhH9DTVLAMB4t3o1ryUX47Ab568gJPDzbFrVnanUFZSzeO55eHrECjDnjuyizCi8tgP
 32p05ZXLGmwTEZh8o7Eilgxb6BFRaFhNEGFfUwDKPrNt8isepJVtr16jJOR6Gbf766rMkfEo/zs
 66trgIbl6Pa4tZf2PydN/EYy5xHe6wpwDinPNcZDTfWYB8MAKzwuWPa7RZT35e3EGgX3gaLL604
 6zJgCbK7YaPa6dKdPpooZKDhgBNJTC5eEhEdZZOqBUp3/epolSuV0fvESHR1xXtmBD/SMeFuViN
 h89PXPBFxy1kI1qOmcwCwiObMlRiiePzn6ZW9LOIH+/IZfmJrcFQFawttfDI3Y/nWw4DRiSZ2JT
 NN0/HJXfYRmn5EtTgvA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-13_02,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 clxscore=1011 malwarescore=0 phishscore=0
 impostorscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607130104



On 7/13/26 17:09, Christoph Hellwig wrote:
> 
> On Mon, Jul 13, 2026 at 11:55:05AM +0800, Yun Zhou wrote:
>>
>> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
>> index 7bfbd9f6f0df..1b36cf12d4e3 100644
>> --- a/fs/xfs/xfs_trans.c
>> +++ b/fs/xfs/xfs_trans.c
>> @@ -1029,6 +1029,15 @@ xfs_trans_roll(
>>         * duplicate transaction that gets returned.
>>         */
>>        error = __xfs_trans_commit(tp, true);
>> +
>> +     tp = *tpp;
>> +     /*
>> +      * __xfs_trans_commit cleared the NOFS flag by calling into
>> +      * xfs_trans_free.  Set it again here before doing memory
>> +      * allocations.
>> +      */
>> +     xfs_trans_set_context(tp);
> 
> The tp assignment above now returns the incorrect transaction when
> __xfs_trans_commit fails, so you can't do this.
> 
> Otherwise yes, this call should move up.  I don't really see how
> it fixes the syzbot report, though.
> 

Thank you very much for your reply. The tp here is a local variable only 
used for convenience within the function. The caller always gets the new 
transaction through *tpp, which was set by xfs_trans_dup() before the 
commit call. Moving tp = *tpp before the error check doesn't change what 
the caller sees - *tpp still points to the new (dup'd) transaction 
regardless.

If I have overlooked any edge cases, please point them out.

BR,
Yun
