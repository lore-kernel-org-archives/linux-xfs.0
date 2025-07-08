Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C58D1C5499;
	Tue,  8 Jul 2025 12:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751979134; cv=fail; b=lCM/k7Qzxab+r8O95BnpThLUBNnyccoRNDJfAp7fadaHSaK4an/YE5A90EuDapbR7GU6tdPOVLWATbGEMfxPvcb/Sw/0u+MYL/yvMbwa27xWxMhhb0lx6FExPK6twdVZkU6J2svqZYze91oZkdudz9uoSP+XDurs4sSoK2OlZYA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751979134; c=relaxed/simple;
	bh=bnlOHsn2tHKbDF5wPtL3Up9dNLgOQSzxhtHmU0cPHeE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UQ0+lBy0hqte5gLpZlTlgQxf4kQCNIA6sp/F1Q3BbSWi4rAaqbfR/xnUFzIBzZ6FL8MonQgt0gGSEiCsQAd4rvDGh+7U/fzODYGCJGOnrVFvNWW32j5/er5qFQj/EHv5SN0wrkM+CjTKKDWwzhOkNXU5+D3/+/9mN9j0911NfkA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZncvQ/U8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KRRP5qui; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZncvQ/U8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KRRP5qui"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 568CRm0Q029805;
	Tue, 8 Jul 2025 12:51:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=weVVSc9oKLWreDh2R0KKVDbLfu3Im9F/ndLHMn9BPLI=; b=
	ZncvQ/U8r6WsiJy4EAAXE9i2Lkqp1HtyIjCWpwAcdiOfoKx9ghxD9Mh3Vf4JauW+
	iW+H2LrXc597blpnjx/x82FNd5R8eorY1441Stumk9i1fY+E81aUcDdtcqKiGVCE
	utpTvOsAI58NVX0xw/wMe+lOttJ/tMPpUFFpjAfZenTJtcTRhlM+gx6uAQvvYtLk
	PMmMpV8kxRoXzHKMhx2XMDlpNqi4YMdobmB8C2i82b6BIblbeQSfn36y1OqJ/q/D
	Sf+XDEmUIXmSPgDzqPchlwqUw+Li+mcSRszSy6Y9f7EbLX6UUvB1Z3qSlww3cTm8
	xJIgMtAfoOZ5Cd7TnMFX1Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47s3bar24r-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 08 Jul 2025 12:51:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 568BoEjx027319;
	Tue, 8 Jul 2025 12:37:02 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2060.outbound.protection.outlook.com [40.107.93.60])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ptg9j057-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 08 Jul 2025 12:37:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DxrFtDBxTjXSkMOX98UKA2Cbap7eWBg7xq9rYe1QulUqaD89BgYI1/Blz0/rUz7VWfK4uIyVae+d0eCKaQf12Gmv3p9q1H7YbLXFtgDNJCVObvn00yMzZ2UXr750srYT+EMU/QDkwCzgRsd6IrLWT6K7L1RdjO+yw12MPq6r89A4K4vSzO689PeoK38HdAPGvw9zvyxtxJaJINil3TJAoRBuJXLdbyxiMW0xTdOyBNULqEz8Dgev5mcKrO7bPrnulvNGNrF+f+AXm3YfXo8U12OHmRQuix/2vlM5mRPRZ7On/rUPpNIidyJK2XaK2EWFVPcH+ayAaDyurvqLRuTIkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=weVVSc9oKLWreDh2R0KKVDbLfu3Im9F/ndLHMn9BPLI=;
 b=pjTQKiAOmkCMPAkJzWyIgQKLftKojj+Tl1S13vtDZrqiZJDesvCVB5/engwjz2XHPb2nHjzWZouGyMmVbhbA+6f2T3y/Bji93qGrc/e3Rv1zj15sOKRaqhB3pDbTYTSv7PoLQ2pxXgKVLsPcd8IEmwxmeUF+sZZRm087VXXBRrnOWWF3w3R0pvmIcRPXokTIe3P4mLlovGrjYZOkp/3LlnQPwzmqXqW4qbPh5d8J5TR7s+Mz6ra0besoy26x1zk57RVAWLbWX63MiSUcL+uI0U1oOIIJsMtLpyTJF49aeiFggcjSn8bgRRxVLGcG2D1mGkju/IVObO4YuF19kQO8lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=weVVSc9oKLWreDh2R0KKVDbLfu3Im9F/ndLHMn9BPLI=;
 b=KRRP5quivgh1QLY5UJpweIAB0g4VevXz1RZd744WfVgeWIrGmz5G6khN/NDyyzyzPaUhsN1aosuBQrXl+LHza+UoiiB7J9lzVWaZDdfx3ywOBWYptjHm0X/3vdQm0h2a82hiLR8oQW9YKIehhF86jiFTITCKtGRnbe1Jeuc079I=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by LV3PR10MB8105.namprd10.prod.outlook.com (2603:10b6:408:28d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.21; Tue, 8 Jul
 2025 12:36:59 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8901.024; Tue, 8 Jul 2025
 12:36:59 +0000
Message-ID: <d84e0629-28a4-4876-9395-4eb1d4bb280c@oracle.com>
Date: Tue, 8 Jul 2025 13:36:54 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/6] block: use chunk_sectors when evaluating stacked
 atomic write limits
To: Nilay Shroff <nilay@linux.ibm.com>, agk@redhat.com, snitzer@kernel.org,
        mpatocka@redhat.com, song@kernel.org, yukuai3@huawei.com, hch@lst.de,
        axboe@kernel.dk, cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        akpm@linux-foundation.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org
References: <20250707131135.1572830-1-john.g.garry@oracle.com>
 <20250707131135.1572830-7-john.g.garry@oracle.com>
 <51e56dcf-6a64-42d1-b488-7043f880026e@linux.ibm.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <51e56dcf-6a64-42d1-b488-7043f880026e@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4PR09CA0013.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::19) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|LV3PR10MB8105:EE_
X-MS-Office365-Filtering-Correlation-Id: 1681dfb5-373d-4d03-8f29-08ddbe1c2186
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QnMxRDFqRENGbjB4NzBUb1g2VnhLVFFTc28zOFJrZUZIdkYvL29IYTZNenZq?=
 =?utf-8?B?NU9hamlCa0o0NWdKcFhTSUVicTAwV1NnMnhKeEVKRnh3dlBYNkMxeXdTeXRP?=
 =?utf-8?B?ZnZscFkxbTRsTjJKOVpJWnp6azZFdkpzRGdudmNqM1Z0QVJTMjRKNmUzaE5Z?=
 =?utf-8?B?b1l5aFA2dkt5cGVmVVJRUVg2OS9XcXdNZ05BLzZPRTZlK1UrR1JxWDRRT1FG?=
 =?utf-8?B?Y0tkekVWK2VGQUNxRWFqMWlsQnZYQlBicDlQejdzZSsxVnJ2dVJUL0NVV09T?=
 =?utf-8?B?aERJdEdYQlkweWVmS3hyOTVCcmtNcVY3dk1RN1VBY0NWWWwrQlovd0FtZEVF?=
 =?utf-8?B?RiticjZBc1Y0blQ5dFZqV1Y4YzFZOEgzTW5BUVJIQVh0R2VMbVBaZWdWcXVp?=
 =?utf-8?B?UkJjQnVzS2hZelVLUVlQejlJM0dsQlU1SlZJMFY5aWxGeExXSTdRcWFidXV4?=
 =?utf-8?B?Z2FWRnNiR2YxUE1mNVNOYU85c2dsVkMzd2Q2WVRXdXZ3MlRRQms5WWxieFBq?=
 =?utf-8?B?QTNRdHZKUXkzYVZmZUo0UmwwWjQ3L1d4TTI5b0ZndGVCN3RrQkN2SGw0b0FC?=
 =?utf-8?B?dWU5Qk1oMlJOcGZ3ZG44czJnWXAyaGdJbkEzT0tKQmh2ZVRZRC81STA3N3NK?=
 =?utf-8?B?cjFjNklJalE4N1NRaXI1UHBlMXNacWlTNGVPS1hxKytuWnlUcThWMktjM2VH?=
 =?utf-8?B?SStHL2s0NzlEOU9tcFVla2JoUXBiWEVEREh2a0VEcGFndjNPR0YwMVZQMG9r?=
 =?utf-8?B?TStTUTFvZVczVkZBcFdGckg5K3BCU2YvbG9hN3lWcVhtR2YzQWtFdXhjWEQ1?=
 =?utf-8?B?YjZCZE9vaHJCbUFtRCt5SGprdXBpRlZpZEVoSmJGbDZTM25mNkUrZGVwa3Rp?=
 =?utf-8?B?dlFaVGc3SGVoMHZSWXFRMGRjTkREMWlzNzBqUEtabVZYRktDcDhNc0lyV05P?=
 =?utf-8?B?Zm9nZ292QzF5YkF4eFdnK0NuSDViYVRCUndDbVdzZW1md1E1TmVTYkNFa0E3?=
 =?utf-8?B?T1VmNTgxVmUzYmdwVW9uaXM1Q1JSQlJvZk5IL1Y1REJMaDdxcXJHVDN6QkQ1?=
 =?utf-8?B?TFMvZ2YxNnYxSHZ3K3hReFlvZHRTUVgyUzl0UGlIUG94Zi9wdGg5KzIzdUZl?=
 =?utf-8?B?OTBreXVXUXBWVlZ6NXJLRHAyM2ZHaEk4Y29TdVRYM290aHBsRkpSdHN5ZTl6?=
 =?utf-8?B?eW9xK1VUN1VleXkrMFU2VUxxVzRuYlA1R05IUlZUUzBCU1EramlKNVMyTWFO?=
 =?utf-8?B?bXk2dUlEY3B4aVFoSlR2azNiS3JQUEFHUitpRms5YWQveW9GSUx5VzZrY1pB?=
 =?utf-8?B?cWVzWTRMT1lBN3NhRFdjWEppd0ZVQXlaMk9ETVVQTW9ISjN2aWl2QmhzM1Rk?=
 =?utf-8?B?ZzNhTHhKOHNYT3ZwZElqUkVZMHdMUEdTYXBqSUhrN1N3YWx2OXVKaG9WeUVt?=
 =?utf-8?B?WUxIcGQ4SGc0cThjWUxXdDc0Z3RrUW1laVJRdktCOHB1NlBzTUl2R1NobDUr?=
 =?utf-8?B?NVpjOTlWNG5iaEVOTnBwdXZ0ckM2QTNiY1o2aitPV3ZiQ25VSEFUZ1Y1ay8r?=
 =?utf-8?B?aGRNeHFLOWJGVWw2M1VNQ0JoMnk0Wm1BQ3o1MlBmcG4rTUlIOEV2UFVzUzBy?=
 =?utf-8?B?eFdzWG15VmtGMkk4bEc5aUlSRXIyYkRwTWQrb0FZUytUMG0rdUpDN2JwMmVZ?=
 =?utf-8?B?dEE5WWlGMXNTcS9naGthTTk0a1JPdkpaVG9aVnVuOWdGRURYQ1d0MjVnUUp5?=
 =?utf-8?B?ZlYwNTYvSUp5WXB3aHBqYzMyVUIrRStWcTFvbzRINmtRd3ljVVRJS3BvTzRy?=
 =?utf-8?B?OU9aV3VYRzR2L1NRcEFNTTJjaDVjQzd6S2RHaFFCU0llOFNiZURXQ2s4RVR0?=
 =?utf-8?B?SlRrZjhtV2REdEtMU3pKeEQzS0dQVDdRa1UrK0FPOFcweHRyYU43L2pqMGdv?=
 =?utf-8?Q?WmeBP2dZ2MI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ny9aYXN4T1A2U3IvWUYvMXRVME5EMXAwQXNGWm9JYWVjRkVQZ0xJcmI5cTF0?=
 =?utf-8?B?SlR0QU9uRU0wNVB6L0w3Vjg0K3hyTWtPRC82ZHpXTjFtTlpxNm13MHRxK3ZE?=
 =?utf-8?B?WDY3QmFrUGF3amtRRnY4czV1cElFTjNTVElUYzlBWE91ODR5aFMxVm1kc01r?=
 =?utf-8?B?K3FNUU01K3B2R3NnbHJuZ3ZjdXEwS1lVU3RxUU5TaFNCb0NGLzl1aXl4ejBS?=
 =?utf-8?B?cHVaVUFlNEZaZVFQRk5aZkUrRkdXdUdVS2U5dTJlT0YwY2JSZWpmNWxiTUZX?=
 =?utf-8?B?bW5HQ21wbkFFeWNmODFFWnlOYmZsV1FqSXdxS2dnaXMvcDlHSDNTdmxQdXVX?=
 =?utf-8?B?R2JmQXNUR2pib3dHWDFqUTM3MlZHSDNNQUtFMERNeDJIYmIreEZuOFB0TFMz?=
 =?utf-8?B?YnZqb2w2aVdveDdXRlVWeXVMM3FVYk4rbnRqbk52VC9mVVp6c2FBckl3NEpZ?=
 =?utf-8?B?NGo0YnRLOVlKdVhXaVBtbGFTemduaXRJbGlyV3dNNTgrMXBaMTF2Rnpkd2ta?=
 =?utf-8?B?L0Y2M2pmZE5oUTd1TzFkTXJQOEQxWHNCMGRWRlRENVpCRTNQUjhqdHA4eHZN?=
 =?utf-8?B?TDVpU0JEOCttWld0WElpZENHM3Z6OWNVakhKcU51dm9hYkwrdndHSElwdU1H?=
 =?utf-8?B?Q29PcWg5bHQvd2YwcXZSQ0orWUlWVlNZVlVjV2VPZGpTbVRjME42VG40VDVB?=
 =?utf-8?B?SnhNTzVSM1lVdmxxKzRFelNxa3ovZ0IyTldNb2FIMUJLNGJ0NldSa1BEaXlv?=
 =?utf-8?B?UlRhTGptV1dPUENFYlhaTkIzdmc5UXBPbi8yMSsxM1B2T1VhQnRSaVdReTFO?=
 =?utf-8?B?T3UvcjhXZDdFYkhpODdUbjdsYXN4TU9KbmplQVBQSFp6N1pZT0RRdlFzYkhl?=
 =?utf-8?B?MWNMVnhwVkU5YWREbHRNQjREcFJ1N1YzYU40UDRvd3BnQ0hMYURhQ1o1SWta?=
 =?utf-8?B?aHZXSnBCaEJsSzgrdWZuVG1udTYyZkpwMkoxY2t1enRoZU9LTmVwaGhoKzRU?=
 =?utf-8?B?dnlDc1gxTS8ya3V1bWJick85NDZwaGhFWFE0L2V0SWRJM1dHMGpSOVFtNHk4?=
 =?utf-8?B?VlhYU2c3TExDUVNSbmt5TXYydmNLb2xRNEhCbjZqU1M3ZEhFOUZzcVpBd0Nw?=
 =?utf-8?B?Wm4wSnJ3TkVrQ2JrcXN6Q0owak1KZU1kekNtbEc2VFZicFlESS9sOUZoODZ4?=
 =?utf-8?B?eWRxT3o5SFhQeEtUOVE1MVVUWjF0bFA2N2xyTDhVSk5tK3F6dDdyQVZuT3Rs?=
 =?utf-8?B?alFOaGZSR09wcHk0cHhNR2dBLzlYam0wMTNReks1bnl4QW9HYWlDTnlBSDBh?=
 =?utf-8?B?MkZOR3VTQUh6UE92aEFmMVhCUm1kWUR0cVpOMTZhZkNiTFZFLzVVWXorSDZT?=
 =?utf-8?B?OXpsbmk4VDV4ZU9oNlRlTURLOHdZR3F3cDRqMCtvRWNVZERucm05NEthV0Fa?=
 =?utf-8?B?bkxoM2xNWXJpU3NSaWRlVmJTK0JRWHhwTlhGNS9SRUs0d0x4QmNteFZTNFRR?=
 =?utf-8?B?NXg2NWUrR0NJYXIrb3R0UUhqdG1TZ0lZWlBoV2lXdnJBcWZ4Q1pyVGNTS1pS?=
 =?utf-8?B?R1pnaUM5SWQrT0RKOXVDd3VZWjlDa091bFJFcG9wejlIZlVuTzZJajNhdGw1?=
 =?utf-8?B?SG1yblZtN25mQU9jMHZUNk5yYitqTmpVQ0NsZ2VBTVgwbjhzYkhKMWhyWWls?=
 =?utf-8?B?dnFWNlU4eDlpMk96akVIeUJYK3JFcHA4QldEcXpYNi83eVpodG5ZWTE5ampD?=
 =?utf-8?B?U0RrUTJkQkR5ODJLUXJyczlEZy9ReHJWRTFmaWhvdnNJZEtRZkVOM0pvM1JY?=
 =?utf-8?B?T1l0RjkrQTU5UndKRUtBR0VBNndBWDNvWFdEeitSWWNKRWNFMVdNWE9KeEdU?=
 =?utf-8?B?MlR4a0d2YllrOVFzZGhDYTVWbjhjMzM4TjBZSWJMck5IYUlsTFFlR0ZTV3RQ?=
 =?utf-8?B?aUw1RXJmazBlTnpWYzJQVkFDSVNWSUpXcWpRaVlmVEZxYlFtYkFqU054TERq?=
 =?utf-8?B?c3Q5citqbGZJUnJlc05KY3JhMnB5WHhMbm5wYXhmcXM1eVZWMzdyelpHT2M4?=
 =?utf-8?B?RU9mOXBOazBLWG9DdDVsaGZ4WHJ3ZW1td1ZyY0F3STRNZFQyc2lOSnhnS3lt?=
 =?utf-8?B?VzNZSjMrYnJVQzMxNS9FYllEQis0QzhJZGM4SGlHaC84WnIyS1BZMHh2WGdl?=
 =?utf-8?B?NXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xqcJfzBMcASDFXrDXVH6IqaKwD5/c9iOaZeezqZAdcZVjQSgLN+r2B/OhMUJqEh+AcKwl5KOklMByt9DqOgv8IKAjaxRuuavwLjjJtD9I57YctpiQQs8dq116SUuc3FtcaRYRvEUs4D07bCXdxvlJxY90ivfoLXlR/4RiPxvPJ7+AGoNVt5OrAhZpZLY+REIga6udtgenbwaVgfPXImx2TyI7d4LAxl6JLtqpORi47y3cmTPNKQVG9G2MGggDfsMkZ8XE18FI+zHJ8EGhBv+9yABjy4HgVv8L33t5CG4CfPmRJCN7TxTPPX+zNmudZMCpmeFecQMUMR5NqYC4UMWRMuRCb448D4MadRCRS++U4GHTjmiuWVB3AG4XVbKog9frWmrWAGnmcCkjYs7oLlVEyYbL3PH7C3QMqbY4E2m60PPZ5g92tljNY7KuSafz286THGZ78CDSMS0ArYhBbFs3JtYsOvKgn8xwsFD/1G35IIBDA3PI6heBSY5UzceFiyHK63JPc1jkNJbDSFKkYRs6pIpyogH6envHduu+LbFcf5xDzxKPlAj5XKLzM18oDX8Jkn1DrITn2pr6KtooKfxLSTmi4ZqI8ggqOSJUAZ2YT8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1681dfb5-373d-4d03-8f29-08ddbe1c2186
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2025 12:36:59.0057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hH5jljwaqxC23hcIQJLzbhmjPbFk+ruXWZHZ1Hr82ZZ/tElJQJujbzrdaXjzSrqrazKuB5k+tHXgAPAZJr4t6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8105
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-08_03,2025-07-07_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507080104
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA4MDEwNyBTYWx0ZWRfX4oUtbkIOf4mv /LdllDAItwhFKJwKiQRgECgRfV3R7FH+nNbeSPmhE+oksQwhp9mzQssZjtXJmjl8sbKsOesr2f2 xeC3NpS8LoH94brwYPQNTIGpeQU1HMfaXP+5dcbvH8ip9mQEGdGsMnw3V/l/6G/NRQJjXYopMKw
 9CCdNqT5rLUZcDvvONV5npFxKKyJIm2REmCUuzAxBumuoreFgXe1syjHjiIJYnjZjvw3bLamglm h9zubBAcGj//9w3kqOx864mvZf5x6ztcj8Wjhfq9Rd0rUjSP1ZM6uUWzuxi8/zqMa1Cte8bO6qI h4MIDXGUWT161YoavWOyFKKQvJFiBkd8PYXwWK67N7LOK1PpMSbfVVAfKCu2u/CCb13EdmWTmE0
 SmIMxjE/eOLDoRWpwGvZVbrOD/J9LkcoUrXo4FtypPiQw3uZJb6AhMEii9jIvrkFLyZGnfdx
X-Proofpoint-ORIG-GUID: UP3fE8cWERQP5tWZMT97s5bc6h5EYM3f
X-Proofpoint-GUID: UP3fE8cWERQP5tWZMT97s5bc6h5EYM3f
X-Authority-Analysis: v=2.4 cv=C5jpyRP+ c=1 sm=1 tr=0 ts=686d1468 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VnNF1IyMAAAA:8 a=ZWGQkdUZNeAX0SpAKm8A:9 a=QEXdDO2ut3YA:10 a=zgiPjhLxNE0A:10 cc=ntf awl=host:12057

On 08/07/2025 13:27, Nilay Shroff wrote:
>> +	if ((unsigned long)chunk_sectors << SECTOR_SHIFT > UINT_MAX)
>> +		chunk_bytes = chunk_sectors;
>> +	else
>> +		chunk_bytes = chunk_sectors << SECTOR_SHIFT;
>>   
> Can we use check_shl_overflow() here for checking overflow?

ok, I can change.

> Otherwise,
> changes look good to me. I've also tested it using my NVMe disk which
> supports up to 256kb of atomic writes.
 > > Reviewed-by: Nilay Shroff<nilay@linux.ibm.com>
> Tested-by: Nilay Shroff<nilay@linux.ibm.com>

thanks

