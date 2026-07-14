Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAA0304972;
	Tue, 14 Jul 2026 01:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783993302; cv=fail; b=ZfATsJ/+jTJsZEALth5mwZtqFQzq91BVlSDgdQz0Rts7OeZGolINS58MmOIcjuKhqEDtEJKhSY0ptW7YP9V86h8VyaChQWV5ixV4sfHDwaHmRXv06VwKuavYz55VCby3xD3J9XxUld47z5ygDinlHivYajEr+yufebG4gwJWCL8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783993302; c=relaxed/simple;
	bh=4Bwwhpjw7DUYC+bkz5simmOlUlqgJQKmoHQ90cy1FeY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qyekMpwnb0QvKSi+Wxt5ESSo7xZAyTo18jzdxsvhHqwn6wQiFkMwLBerfKmHk56uMHeWHogHMR0PDvAbiXTvi5P25dHoz2vDQJMS78g7MpTTCUJQ773VQfbMpoTKJ0JgaVa8AXQtCvjvIjcK9MyTwFDXsRDQ+gj/5bUZYk2WKYQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=EJDkMR9z; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="EJDkMR9z"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66DNmKKC575808;
	Mon, 13 Jul 2026 18:41:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=r9WCKYJAtNx6BInrSmJfVWLZxcb5bSltQQhurJeEa24=; b=
	EJDkMR9zrewtGoGIs0mpghxavVeIe0k/xYz2GKp2Dtht6zujvTczrpnxKqh8F85a
	I1oTB4mjPQfvEFbMGnrEwW1YJFILvAe6u0MF1WYno/fx5ZRd8GWyeRbS2dY+gATt
	XIG8+X48IxcEZAqVDFtYH0mCLPCPfu4kYk/yLn8eeaZ1c2/h/UiKllo/2HXrOYOL
	R9NEGyM0Gl5mb9oWwGCkUzJMpVb0oNh//XV8bpN6QbCkFycLwVf1NXO5L8i6LNEr
	QtWo3GHDFcjsFIX8Q/TVddVrdb0xDT5grbMX7Jf6k8d3KAN5gwUtIpBMlgZR9kw4
	hswaSw1crLTHCopAx1paaA==
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011041.outbound.protection.outlook.com [52.101.57.41])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fbnbdk5bf-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 13 Jul 2026 18:41:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eZe0IIaTMeZm5/yZpPPaFB8Uq2B2tMtaUyjHuZDSrs3NuCmCly0S/6w5DD2GxeuqnYcGC0S/JBbSN9bt4b0yVkMBaQMjjQ31lglCxgx+vGIuB5jVtUUjjORRRaDKPzmwDoxwOYLGdLftkzeEi2E5DgOvcgQPsBAH9NFCGtUorELnfRJwrzmLXEadLrVoUaG3PqSILmve0rdCasKcA00IN+6bQ/kBOi5C8MQRvlkIm7yYyP8AS/6sBiIQSgc1tpObU05QG94EnPzFIic7j3syerNz5+uoYiwXIsc5SbzaC4jBdJlfX5NaF1Cqr07DYpUsWKm4to7BJHVQlnqSQjK+hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r9WCKYJAtNx6BInrSmJfVWLZxcb5bSltQQhurJeEa24=;
 b=jNdjMeduCvfEknvQchUPcLbAjLYmEyF+VCBZAOK6KuulIPKBmCwd5jU0EPjsuTgJtFgkC+XqQXPGaTt4x621QRyto5VM5u+9zzRc8NXPUj3TQJMekysU9oA0rFHQgrsjBqWsA8hZMFKP56rhOnAHp4EZ5Ec+eWYC2Rznzg25drrcdCF36iR3uUvAEiHO1zUol6FDT4Sjqa7nIWWGa+tVuqQ13gARSQodfIkPeRLZ8pQ6T19EdY+1K/z/wuHU+s0thk+2tC+ngcfSKvCIuhZIyoVuvAJAarHRTHes6uExt4wVLKESvKlgXFUrIDfoLv7Kjn55otStH0bC6ZOB0nwqVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by SJ0PR11MB5039.namprd11.prod.outlook.com (2603:10b6:a03:2da::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.15; Tue, 14 Jul
 2026 01:41:19 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0202.014; Tue, 14 Jul 2026
 01:41:18 +0000
Message-ID: <54dae2e9-6341-4d58-a92e-11852a12b027@windriver.com>
Date: Tue, 14 Jul 2026 09:41:11 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: don't hold buffer locks across sync transaction
 commit in xfs_sync_sb_buf
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@infradead.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260713145002.1627608-1-yun.zhou@windriver.com>
 <20260713220436.GH7195@frogsfrogsfrogs>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <20260713220436.GH7195@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TYCP301CA0081.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:405:7b::18) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|SJ0PR11MB5039:EE_
X-MS-Office365-Filtering-Correlation-Id: 0baad864-ceca-4e61-86ca-08dee1490035
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|4143699003|18002099003|22082099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	Ym83Zh8+4JTHsiCWmGXD3faBAizdm5Q5ypjvDsw041TOpxOoRVw4gdIsPcD0PO+4tugVPq/exjosqp2w5Jusi8nar2fl2T4uKtPOFztcGQqLIglcImIJRKUHYyIaOm35RFyOsA8RIbZQPsaFcXkQU+0V+PHhekmwYw/SIzNGLNyYr/4LOQIXhJp8wy+Db5OsfnyVUO4yawJUva/od8AuNb3/72iyOak2jx5kLRG6qJ8cGAK08rmNR6LJ5h8ykBW2JMSgfBoWenGdro2qx8/jfinwNaf3e9FeEOqWH+3fTp1vUIgPYCUAZk0LoLJIbOiJ1by5oFnq65imBPlqYwdhmZdCL47/Y50ZCZlPet6UM10Gx0pDRhz8FEavRr/jDAgFOqCGKZIoesAHZHqVDG+VF77YHMY27OBtBk+F3VsUHyYXObDZ/6ycMNVEhCwroJPCr8PMkA8M0Sg9eAGUVZ2oXjr9anSo+rc3aGUzfLezw3yVxA7cNC2KPOtIMpUkU9xVh/orn4IZl5lOAPD2MCne78yVfTjVOIE9i+tNGs+osEG9/JF9acceJpRLFOYpOgR4j77NNbl3rHZtsmC5J3vwYN5Nqv1xRqyGu1Upr8pTfCTWKrbcsWHbbPvIaoa9/OyfxCM+HV5tMroGtgbl71WlwUMZzClkb/t+E3JJD5DjEJ8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(4143699003)(18002099003)(22082099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bDh1aEcvK3BHbE9nVTNoU3RoSE04RllPRHpGSDQ3dDU5dVZkR1dLNlJCTUNy?=
 =?utf-8?B?VDNVTnZmR21wMVNEVWxkVFdpOWFYSEFaQmNGa2lRUGJUTFgxNGkvcis4N3cv?=
 =?utf-8?B?ZTd5UlBWdEVhZ0hoQ3owSXBsTkdzNExhY1pETUdLWnd1SG5TWEtWcFpuMTE1?=
 =?utf-8?B?Y25JL1k4SWZGQkx3MGptK2FHOWtDd1BEVUg4R3FsaHRhSW5aTWhCcWl0K29a?=
 =?utf-8?B?VVh2dko5cHliRW9UVjZLZ2NYeHU2WERST3VhcnZKbVZrMEtuSjJVWUh0Mit1?=
 =?utf-8?B?K3hrcytLVStkckpYTVRpSlA5S21VV1ozQXRNNFUrd2Q2ZUhRbmNlcVBMMnJV?=
 =?utf-8?B?YTRCaFJHOUJxaklIai9OSzhlcVJNTmlIdG5iNHpWanRCTDdWNGpKVzN3NFhn?=
 =?utf-8?B?NXQyZk5iZ2NCa01pTWFLZm1uT2RxZERMTko3RjJSeWxSOW02YW9DSk1rN013?=
 =?utf-8?B?dFFoKzI2VXExSGdEaGpxR3QxUkJkVVZ2TDdXa015LzY4STAzMGJnSVNvNm92?=
 =?utf-8?B?ejkzLzFoV0VtUysyTVY2OStCMGlCT1RmNzNPZllhOHBKcUoxYXQ1UXBYRkQr?=
 =?utf-8?B?WER4R0d1STh2V3BnMy8vRDh3dlNCUnQ0MUttV2xHa1pibTVsTWR6cHFqd2pw?=
 =?utf-8?B?YnlXZ2dBK3lZUUlUZ3k2R0F3R1p0UEw1cjIyVU5WMzhyckxKZXoyUmkvVkxW?=
 =?utf-8?B?S0hMMmlvekZTRFg1U1lNcFdaS1c0Y3ZNOU9LQVVIYUxjV2lBZ2Nqa0ZGZ05R?=
 =?utf-8?B?bW5LY01pVDZmSXBtRUwyRlJ3cWl0YTNRTXJjNWZINndwLzR6ZmhneHFkYWIy?=
 =?utf-8?B?aURYcExFTEd3Zk1LWWFwUVB6WXpQVGptdEgxenJDNERINzZEbXZGZWc4QmUz?=
 =?utf-8?B?SWRxaHVpMi9vSUM3RzhlcDlVZHI1N3pVOGpaS1BXaWtDRi8vdjdVWmVHVmNB?=
 =?utf-8?B?eW1Wc0grTERsY1E5SkFJOHQ5WlRxbmVUeHhJaTBiSjV2YUtITExZaGovV2xx?=
 =?utf-8?B?Nm5KRExHZEl6L0p4S1VDeTFmQmJsWjVWa0ZCaFJyY2s3TTJJdmxhMER0STE0?=
 =?utf-8?B?RG9xY1AyZDhUclAvTlVhNVhwUUtMOTMzajJrbDJEVUNVdDBtY0JzYllxMGY1?=
 =?utf-8?B?ZTh4ZVRVTFVsaEhjNFh4N292NGtxTFNDeCt5S0pYV1VzL2xhWVc1Sit4TndT?=
 =?utf-8?B?Q0d6N2NRYzBMdnAzY2M5dkk1S0VzeUE4OVRiaWtpbzlLR01STGpKRE83NmF6?=
 =?utf-8?B?MVdRR3RkUTJFS1h0SWt5MnlLMXk0SXBFaGtNemwzYnVPTzBnYXNxc0l2RGh5?=
 =?utf-8?B?VmJZRG1pWmFHV1QvQUFQME5jL1BIVWpmMnB0U01iWE9tT21lNzI3b2xBc211?=
 =?utf-8?B?L28wQ3B2MmtOdVhOYW9ZWjB0STRDMWZXKzdlRkRRT29UOGRwclVXeXZ6OTRK?=
 =?utf-8?B?TVdPZXREaEc5RjBLSnkvZVZtLzc4THhWcmtsVnRrcytsNndCU3dKNFRLSUpQ?=
 =?utf-8?B?NVBOaTBEZjBOUHVkME5zb3pkY29aNlRBZm1Nd2J1NGxGd2ZtSGV4bHU3TUxN?=
 =?utf-8?B?MXF3Zkw1VmFJV2lDZjlqaGZscDhDNTIra2dEZUJTSXI3Z2FOVjVOc2M3eHoz?=
 =?utf-8?B?cE5NRGNRbE5KV2k3T05TTEEzWWxTVWJVVFZYYlY5T0lpUzBSS1prU052d0FI?=
 =?utf-8?B?U2V2WVFLaFQwS3ZOMHA1dWxialNma2R0M3QzQTYvVlk2bVpqK3VMQjM5Mmox?=
 =?utf-8?B?dld5RERuYWQ3K3RVckc5RUZSTTFlZ21aZmdpOFlFVEdPNCswUFhNUll6b0tR?=
 =?utf-8?B?NHlZek9oT0s0dDcvdXZ3Z1gxaTVOdElVQ3NPMFhzR0I4Q3pUYXpqTHNUWHlr?=
 =?utf-8?B?OVRnZHAyQUNFQ3BPNDVVNmF3YkhKMDg1b1VGdlZzcTdselhHTzdqNzZjeW9p?=
 =?utf-8?B?ZmoxTVdBTWVlS0lRWnlJSnczbjRzS3dYTTBPcThBMWpud2hURXBVdDlNZGNG?=
 =?utf-8?B?RFVVYnYyb2hHTXZFMFNUQkpZaFhaQTRDakxxdjQ3WkFpQTFHankvaC9qM3p6?=
 =?utf-8?B?dElSS0xUWm5QMnMwdXJXTndqNjRzRkV1cXB0TUV6bXkrYi9YZ0Jhb3JFdUVZ?=
 =?utf-8?B?TmprK2NMRVJzN1dsMUdZTnhYM005eVV3aTFsS1dsYms1aXlWeDFJa3Z6K1Br?=
 =?utf-8?B?V2xpVnROR29lQ1ovV1U5cFpJeGZCR2NSdE5GRE9qaGxhV1pRdzlZOGt6NERj?=
 =?utf-8?B?V0xFSU1jbnZ0eVQ2cHY0bWVJK2lUTjhSamZXbExpWGFmNGlXTDJkODhxVWtp?=
 =?utf-8?B?NndjK2hjVlZqYThMeVJYWVBsZ1pEeTdYYkFBOGdMY0p3VlkxVWI0UT09?=
X-Exchange-RoutingPolicyChecked:
	StcPaI8DSwJCnyxKB7Ns+p36yG32N0La//TjUjGKNJG32cy5ej4deNcciiqBRhK+VICegH1atUhhesEkqJvihAdh1mBK8WEEmaUSad9LXox7a8FwrcAMMKpPK80Nv5l0uHh7JWVVcWK0gxiYUQyi6TcUJAxELNmb6MWPV/UzTwZl9GK1PCUV3HIYisKf6fA0lcwjcfMx6qqM2ElK+Fv6ZmybJsaLfxlkUVyEVYMS+UrpCAr0VG8Sp2+GbhQ3cG8z2FWQ1ZmGFJ9GrBx1Nt5b0Tgr38KDEaGtJX/f8GZZ23lmUjII+hO3feWou3+NvlXretPsnNIA+F2c1VxXq49CMw==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0baad864-ceca-4e61-86ca-08dee1490035
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 01:41:18.8378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T7KX7N30Qnp95uAT+88Xk/3N28JfitpqCl381j67EUuWd/tMyqFmMTYk8wo4Kkxei/S+IXFghmKrc9oeCp637g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5039
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDAxMyBTYWx0ZWRfX8j828CROKyrU
 eTjh0ImNazUaHVb6BHmyDXwW+GbbXXXxZLM+fTKcTmpjoWr4pbmBZzdNnp7gCdjF9F7HxGN9iog
 IMu3rgKXqbZc4Mmsu+KXIZCdmQBQZHM2g5lj4PnzEkYE5vgExUER9JRrjaoQzlBfi+SzlvjOOeq
 MwHUSpyr/n/0oQQXy5fCGT5hn9psXiLXnr7FjPEApE96+kj0XF5xH3wi1vx+XiPyrhqnpliPVeW
 oJBqnriFeJgwGlddhcbgOembta8WPvD0kz3K5hBjTkb1FfNHVMin2wPg3I9lxDmwENXNP+/7IMS
 Gh7Y3KUdr6SQTvAcJVY17zUKGwO5l/b9U4pte4fVDjfE4S1GzIUFZQELytIlCSFEdciQ15Qp5pm
 n7F9bqrOB2WjpNyUm7/mOwjfIY+oyTdYcCg63DAs3qaKDRSBWwqOXnTuLLQ2UgkUBnbG54WqLFs
 +xuruPvGK+Ttu5u8qmA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDAxMyBTYWx0ZWRfXzw4nlmg7dZj3
 G94yTSdyx/lmv35RgGK848mqcrPc3kKMlfxgXeOUpmaUX15eH+Ns7WrklUw1QNpz969f4uKNbp7
 wj3xxJm2v7QZ/qLCK6nB6+4He3VrgYGLWFFJ1cKuSD2CO6JO+an+
X-Authority-Analysis: v=2.4 cv=VI/tWdPX c=1 sm=1 tr=0 ts=6a5593c2 cx=c_pps
 a=QmrQXVULtgJTkzLS4HxzTg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=iKiJcTA2PjBS6x5JeXcw:22
 a=3YtPnNqK9KR2JUUSyXUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: dDTVvrUXOw4P0U31nzJLlsXZ7vtUbm68
X-Proofpoint-GUID: dDTVvrUXOw4P0U31nzJLlsXZ7vtUbm68
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-13_06,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 clxscore=1011 lowpriorityscore=0
 spamscore=0 suspectscore=0 malwarescore=0 bulkscore=0 phishscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607140013


Thanks a lot for your review.

On 7/14/26 06:04, Darrick J. Wong wrote:
> 
> On Mon, Jul 13, 2026 at 10:50:02PM +0800, Yun Zhou wrote:
>> xfs_sync_sb_buf() holds sb/rtsb buffer locks across a synchronous
>> xfs_trans_commit(), which flushes the CIL push workqueue internally.
>> If shutdown occurs during the CIL push, xfs_buf_item_unpin() needs to
>> lock these buffers to fail them, causing a deadlock:
>>
>>    setlabel:          holds buf lock -> flush_workqueue(xfs-cil)
>>    CIL push worker:   xfs_buf_item_unpin -> xfs_buf_lock(same buf)
>>
>> Remove the xfs_trans_bhold() calls so that commit releases the buffer
>> locks normally.  After the sync commit, re-acquire the buffers via
>> mp->m_sb_bp / mp->m_rtsb_bp for the on-disk writeback.
> 
> Is there a risk of writing out the wrong superblock contents if
> something else grabs the buffer lock(s) between the xfs_trans_commit and
> the xfs_buf_lock calls?  Can we walk off a garbage
> xfs_mount::m_{rt,}sb_bp pointer if the filesystem is being torn down, or
> does something prevent that?
> 

There shouldn't be a risk of inconsistent contents. Each update to the 
sb buffer is a full overwrite of mp->m_sb via xfs_sb_to_disk(), 
performed under the buffer lock. So when we re-lock after commit, the 
buffer  always contains a complete, consistent snapshot — we may see a 
newer version if someone else updated it in between, but never a 
partially written one.

For the pointer lifetime: mp->m_sb_bp is allocated at mount and freed in 
xfs_unmountfs(). The caller holds mnt_want_write_file(), which prevents 
unmount from making progress, so the pointer should remain valid 
throughout xfs_sync_sb_buf().

BR,
Yun
