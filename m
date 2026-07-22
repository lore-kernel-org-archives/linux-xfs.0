Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769E13DB655;
	Wed, 22 Jul 2026 09:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784712211; cv=fail; b=SOL1ss1pL/Qi7rx/AmLQye14YRamIGrsoQ47tml4CID7axD3sVBRJTan9WyLy4PojsZRGrXIwo2Dicl8TBdOXwJvQnPPrsAGX2bTQz95CdKNlC1nJULyzTWyH6lA22y0YHSRCjRYt1BR8D7+cqlNWivpWhJYzXm0BU6U/9fS2HM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784712211; c=relaxed/simple;
	bh=HtyD4J1g5y+4OXShmm8Sh60OZyiYkc3ZiEeZaq7YQrU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fqnIMsAsaolLcD/f/A0Bp3w8W4xujUZaWpA/fXeL8ijK4bzVFVeHsAyAi/h3rX5+TXe1cu5VuCqGm+rzVjoW9M/N/C6eqcuRUl7EN641ESWp5jRNTreoOVkcKZeiAFit6PuVJfmAyahU/Xyi6aWGZsVNCtjZU+/5eoH9y+Fhg3E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=fail smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=rDUuiSJD; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="rDUuiSJD"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66M8xE66451310;
	Wed, 22 Jul 2026 09:23:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=1TOe1sK+hGyJuGj49l0V1cQQ+fl3UEnShuIJaLznBrk=; b=
	rDUuiSJDHPvCLHk+7wpG8xXvv36secnpjLd8XYpJ1K+q2hkfuWW/4QR389OdSMkC
	c0vI79YDZMA92V1+fY/ud66peDDNBklEe2JV5SIAToFF0uT6sz+AbJUWOuomYpka
	Z6kUl9wO7UjIyJ2EQW36LyFDWB0wYjwp+bgQXe6Y9bYaVUz9hFqQVs9OmrT5K8s2
	mrfuJYvZkEGbzKe+c9YWfMfo2uAQQsk33CDrcIHB2+G8USH8SknmXv+Wd58YMc5f
	OeNp9xi8KvyOQhXEgIPicpJKTghFmdNpDe1vLSFBKYF67vrfqUGnQzNl/sqIkswi
	6oJQEpxEbPA6wupXkXZ+Xg==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011024.outbound.protection.outlook.com [40.93.194.24])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fg0f5fqh5-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 09:23:03 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k16issNChkIKt4YB9uOZzIAv/AZn/VV7mXN+Vtxf1jdoLfiheUuJR420kKHxChomTu1gVy+2a1o1SS3vCuT1ruQdC2kZQFCtvX8YXP9cED+K+c4PSvNP7aKxN0Nr3x1iB3jmoCdLDoAdxLKCpxn5I+hQTk5dRdz2cj1wWfyyYJuZWc4IqY9LKYWYJVPeY5f7BwFza6UUaRotNsHhCOH40ZyL+iGx+31a6p/IL1LBncaIMEp6EEUEyPQbBKmOnfLx6FBPEeCrogIw/WZYe0Mu0U3ZulPb0CkGiClxg0DVREDOMw8EvdhNblzb8vsLup/oakQ2d5D0CNROBvFndv42yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1TOe1sK+hGyJuGj49l0V1cQQ+fl3UEnShuIJaLznBrk=;
 b=Wta8DPre3wxF7fZjga9bwekhYF3tCRN0jaaIqf+zgLZSe2Ngg9ypewhBiXa46zk6YRWJpg6Qzj5l/VxgfFI1Zx1NTmEbTocnr8q1qiSRgV13i44+88MsMfuD5UWTbqtzvPyv+eHNKJXT+clCD4eLnCBYDtktuygj0N9nBK2xLQHAKwvI82JlJTzM0sCB6vlEmMPR5VJgB9QdXJgheskOJa9ZwqSshGQ/fAN65nLHqPfeN8WuzQP4AJhDY9AJTuED7C3eUhYzeuFdnpfCZX3os2JlO8yhGpsCTuRMhuAcUh6rGlYJZHHOyEINY643jTwD7FMPFkWtvvWZYxm98givSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by SJ2PR11MB8449.namprd11.prod.outlook.com (2603:10b6:a03:56f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Wed, 22 Jul
 2026 09:23:00 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 09:23:00 +0000
Message-ID: <58efac85-a279-4c4b-bc63-0ee0d29f4fec@windriver.com>
Date: Wed, 22 Jul 2026 17:22:53 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: fix compilation warnings in xfs_sync_sb_buf when
 CONFIG_XFS_RT=n
To: Christoph Hellwig <hch@infradead.org>, Carlos Maiolino <cem@kernel.org>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260722042841.220534-1-yun.zhou@windriver.com>
 <amCBowU-Q-QrGYoX@andromeda.toxiclabs.cc> <amCGQTUW34EqflCj@infradead.org>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <amCGQTUW34EqflCj@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0038.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::15) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|SJ2PR11MB8449:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b93b633-3b72-4a1b-7941-08dee7d2d2d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|11063799006|10067099003|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	kASDsXVO3sdLZ1ZYBnYXtaPQbihv7jcjy8ap7bVVRfrl5AM7V8Y6oFCAmDiQP3SzlrrLuM8OW1w83YbboK5nMqHkkIT2NR9qdavwuO77VbLc53MPZtOO54nYToDEnkxZVGKGzJOh94H9mt6T+fkeic5kTmyhJq1fM0ue10+nCUnsO5eZa2jHOTHGVU7/I5HzuxvL/1hCrXCzh2/jdOhSPIPsqr8xibV6CXBevvso6k4tDanB2mncAYUzEHNTNLSSqpGV4rfSWec+a0mZmW9XEaMIGCUme+TJ4gh4/HmF35GBFj8DSZ9Is1rMU1bYi3XndwrjzdxnSl/VYWb3IabBUWqhFiz9U8rYvsWFs7/0poNAmRdjm/xcqBYQXCZQq0+rwqVpHF583vVoyCInkeqlQDUqgfrCdRlXwfIzTjhTuViA8i3w88r4qlVp03taZyPffiuqV8qf4DSKIJ3rWb8PpdJKEQKZyszKT/Fnuuk34dmZw5JLXeoRv6TQgn1pWLGgUj3BTUJb1frOQ3u5XbpG3q1f8TuDuHTUhKSbagyoSyOAV1dOL8mvB51bMAS89WQjOTiB1cLm5zrDh+fdpbuuNCRsXh8h0S36yx1XxTqrcTRfxeamgsmmq4qepQ6EZEFXlMOqNUCBZg6Rvns3zkEsEX606Bu1w+CO7cdkwpcXv/Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(11063799006)(10067099003)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RFJ4SDh5WGt6eXpyaU9rdnRYUzBIQjBJMEtwWFY3S01xR3NvN3NCUm8rcjVy?=
 =?utf-8?B?OGhWYWtaNnNzZUxDam1HWFhvUzU5RkdXdjMveG9ONGhFTjJLbk00VWQrQUF0?=
 =?utf-8?B?WXE5bk9EU3RYSGMxeUNIWWVTaEpLK1ZJSUtCNWdiM0lBcW9lVXltcHRISkFl?=
 =?utf-8?B?RzBreXVlakRrNkxGbUQ1WmVzVTVScFpZWEtQNjRiSkRsaStKVEZGejhRd2d6?=
 =?utf-8?B?bm1WN0piOTJRMlJrR1Ezb3pMN0JOSmtwc204bjV0bm1mMGNTVnNaT0NBSTdC?=
 =?utf-8?B?R0IzVjVrb1AyOVdGMEo3VElncHFLaGJSNDJCTGN5endUVVovZFlUTHlNdHRx?=
 =?utf-8?B?SXZra05RZXJvL3NnNWUxcDNEczFXb1hHTWVsL1YxV1poNW9lcjFKVFVVNmkw?=
 =?utf-8?B?R0QwQXlhejYyUlBpS3l0ZmVyOER3V3J3bHJHRmdFYVBRU1dITGhkelRUTzF0?=
 =?utf-8?B?d3JpbWRFRWhQTjUzRFhGb0ZTV3ZyUGgzVmJQM0xxNk0zY0NxcnczL1lzTkxz?=
 =?utf-8?B?b2ZDM0J5TzZZZzVpemFCU3pVMzVmWmFaODhoUEhhMzNWc0ZvWnVTcnNSZWJl?=
 =?utf-8?B?UUs1a3J1R0RQRENmamRRczhuOGY1Q1NxWW44SUh5bk1PL1pIdm1vQVJkZDhi?=
 =?utf-8?B?R1liV0g2dzZXQjdscGF5K1pTVURZMzNnMCtUMFdrZmMxRkt5TmlmSW1iRlNs?=
 =?utf-8?B?emY4YmdKNm9WZ3BkNjYzejNsbEYzYlk3WlU0aWduS3pUbXozV3VYZmkwc2k4?=
 =?utf-8?B?T2Q1MGVXWjJrTmViSEdvNUMxS05mL0wwOFlNWnRQdmFaS3RsMDF2cTlvS3Zn?=
 =?utf-8?B?N01wamZNNGFWM2wweTFIeExzamtOdFlhNFN4aDh5UWJIR2syRk1rK3dNQlB3?=
 =?utf-8?B?T09wK3M5cDhoK1FycjVGNmIzS0E0bW85aWJUUzUyNjVTNTVXcDV2akRBVU1z?=
 =?utf-8?B?UUFCcTlWV3Y0SDkreUt5clhnbi90T0tnZXJnb250Uksrc2pqRW9IbmlKL1Jh?=
 =?utf-8?B?RUNrMGFDdG51TmhpdXNyMnNnZlBqTVNNNUgxSFpDd01ZMVRIMVZ2RW52MHh1?=
 =?utf-8?B?WEh0YncxNS9vZHprcjBEbkxUY2pLZmJTcFcvUG5XTGF2dHNPTVZ1N2x2WHNJ?=
 =?utf-8?B?anFOOEUrMlpHc3QvYmdScW4yekl5TkRpbEs0UEVEWlJMMVA5YUk2VUlRTkpW?=
 =?utf-8?B?MVBQem00aDlJL1R0YVJyWUxtOVBqbWt1MFBWTmw1bEZGZ0xCR0VBOTRoYitB?=
 =?utf-8?B?RENERU5wdHQ2c0pwOWJ4RWFNRWNFcG9oZ1N2bGFIa2ZhUW1kZ0ZvTjdzSito?=
 =?utf-8?B?c1lrVjhMcjhyNmZrOVAwNmplbUFLL0dSVC83cGFPZXdMUkdlRjNLYitRZUJp?=
 =?utf-8?B?OWoyRlRqeThlMjZPaWNGekVmeHFDZ0szZUhCbEVwYU83TlEvQy9tQkw0cjNi?=
 =?utf-8?B?VS8xd1BCRFRkUUZWdHJyK0s2dXRCdkN6d016NzRldEUxZkkwaCthdUdYR0Zt?=
 =?utf-8?B?WGRVa0JXbFg1WGZYYmtlVTlrOGtvUzVod1BHQkJZSC9WWC9wQmIxbjFXdGZE?=
 =?utf-8?B?cTZ0MGdqenpXRklNQkQ2RXVLTzdmNVByNmUya2NmUTNqMTJEdjcyTnZuRGJ6?=
 =?utf-8?B?U2NyMVZ5eFRpL0R6VWRIbEc0dzFFRW1PTGE5SWpHU0pjZFZILzZBTjhicVJn?=
 =?utf-8?B?QnRpUnlhbTdrRWwvOUg3OUJlNDBxbFM4MklGcmpXSW1tZjRXaHZ2VXk4MHFY?=
 =?utf-8?B?ZG9YRDgyNGJxTEtLQ1FaZzVnb1VmYWpWY2VsRVFvUW8veVhIT1BWcXdDc3ZE?=
 =?utf-8?B?OEpDQjE2WVVDU0pFcVBLSXlPUlpDNnN5NUlkaDFLVlkwNWVkS0hiZUt4SnVp?=
 =?utf-8?B?QWFseWpKaWxMM0tVL01hT1M3cys5SzZrUFI0SDNnYm9ka3U0U0pOVWhIRktw?=
 =?utf-8?B?R2oyU3FYRHEzeERTMGF0UlhrUzhkendPcFJNS3V3QVRJS2d0aUM1LzJrdW54?=
 =?utf-8?B?c0Z2dndOK0ZKNTB0eitJanp1RmpyMWJMUnNTTnA5Smw4dUdxY2hSVVU0N1E4?=
 =?utf-8?B?ZXRsb0JteFQ4dnFENGFhL2RuL0JYSGpmOElnbnNYZU82dXRmcXgzbTZ5NW9w?=
 =?utf-8?B?NHYvQTNnR09waE0yOHgxTHh4TkkrSjlHZFJnWmcvTEdkd0V0dkIvUXJ1U2p5?=
 =?utf-8?B?SHdXNG9ua0tsVkZlb2tCbmMybUdNbGtjVWZETFdzd0lYdGhJS2RBWThJQTdt?=
 =?utf-8?B?MXZDVGZNWERqVWRkVEl0NWwwdy9WSzhhRnh2eGdFOXRGWDdNM3BEMk1aN0x4?=
 =?utf-8?B?eGdYSEF0bWZIMWdmSEFNNVZHdFY2WXE2WmtBSWQ3SkhKZkE0alJkdz09?=
X-Exchange-RoutingPolicyChecked:
	RxTDLUezVdpSC/1iw2k76f5x35/V8o3Cr3B4Rh1dqNMNOV2g27wxrAGssUOScvhG09gmulXt/v8/AIDvLo7gL76ALap9gVjxb8nadynJBDsMeE7x3pRlpOFStx+q1cPV2KsxRjm/Ory59a1hniuX75WaksHpMx0RnfOba/5RfnHmbCTnwxZ+sKKSUPJAmbimr2bsktli4Tb85bpiaYTDK0moppmORQVVNcZpQ4ahO8Ako0VJaOAHb5DqU/RpyljdHuWrDrVfU286JItT68RKfNxRzMYqJx9WyGr0eOOxJSk1uffBV7EqWl1j1xwkReQIW3i4yDsqS9svnpMXsJ0nQw==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b93b633-3b72-4a1b-7941-08dee7d2d2d5
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 09:23:00.2937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gQyu9cvZ91yJKPMpYruhYIzGuyqE+eoF/1NhAIRF9vF6KBouNYx5xU1PEWBPrlE4CrD1y65FRnCnryP6ACUk3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8449
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDA4OSBTYWx0ZWRfX3uLL0xDedeoM
 QL1cgm8e2/iNvC+dLr2aHahVqJuRYuL+85qkyr7lrGSTj/LY/okaxpiUGowr/asVxV5iwEhWnqM
 4v82Ei06iPgnZGe4NcHSeKog/kzBEUoyDVUMO0llJDFcmm+zCTseSjpHHR46JFrqdP/z4Aj4Ztm
 ttr+bbeACgT/jccvtaGq0RcktdzztLHO55Ps0BXk0jSgqaijHOzhfGJqexW7fRFojcM64urirSY
 BzZy2oJStq5HJcgE901WWsT1iiXjk7UFZE1uhvbKbJ2BHsuL62FyK9M8AkSu7Yq+u/yAaOplfpN
 tlU6V7Y3oG/72Gt8BvTQIXjvMRqfgNyog8lEuIwzHg+b+kCwxVqFWPEqnjwtiNxSDxCe2tUU3gJ
 M78TdkWl9hWLsV7v2IjyhbJ3T5osdrm/JPZTOGsAegdk4aSAtiyN8/zYr3eiUDL6XLaHR6ahB6l
 3rjAzG98Z73rR0i33Qg==
X-Proofpoint-GUID: bS8hgN-IVLHmW19dFI2E5b2KeFyoxykX
X-Proofpoint-ORIG-GUID: bS8hgN-IVLHmW19dFI2E5b2KeFyoxykX
X-Authority-Analysis: v=2.4 cv=IM0yzAvG c=1 sm=1 tr=0 ts=6a608bf7 cx=c_pps
 a=msEVGK6UkFBbvU8JCjtEeQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=fTW__CHxibyLmBMfj2wP:22
 a=gSTgCWlGJzkoYMtLPxgA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDA4OSBTYWx0ZWRfX6mlcgv0X78eQ
 LmONLwVnB13nF09IALltOXmDce4jq6MucDD+U2nda+vrkq6dHH+lzBV+ucbCyItHAAxNAafze07
 j+K+yQthCZTa5q5wyYkOhQ0OjKK6IvhDIG/C8EFfBqkOfZfcY7Qp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_03,2026-07-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 clxscore=1015 adultscore=0 phishscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220089



On 7/22/26 16:58, Christoph Hellwig wrote:
> On Wed, Jul 22, 2026 at 10:49:03AM +0200, Carlos Maiolino wrote:
>> We don't need a fix for a patch that is still in linux-next... Merge it
>> against your original patch and re-send it. I'll just replace the old
>> patch
> 
> And please turn the stub into an inline function to avoid the ugly
> void casting.
> 

Okay, I fold the inline function conversion into v2.

Thanks,
Yun
