Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3BD34751B
	for <linux-xfs@vger.kernel.org>; Fri,  4 Sep 2026 14:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788530499; cv=fail; b=OaYN9lqHiw3wVsAi0IIdAddHhEPoRa1AcIFBSRBDabvPvF4sma/UaIvv9GqwupG1Jzp3p365pDE63V10OPfUHArJ4/EgLe2uDRlAQ4HBJK+gwCcNvzGqdEXJ+gynRp9qVupReC9RyOkffiP1zhNcRD58UbkiPW7cnFhQAa1hCio=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788530499; c=relaxed/simple;
	bh=4YNOoNj0GFCKoMiF48b/pYOOoPbpTw0bbwuzmiLYxqM=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ezvq1gkZuHNi5CVMrKhvWFMUBZ5nYcXjiZxBcf6SgvA9rVvjNWQzpHGY1TfnyIMR4Bw0glkDuKaRaGuoEn2NVKtN0SBX2zvKkiHSoKFYE7Oze6/9Sn3jDpaLNh62U13E89Y8Ep3V30j0ORBuB7tf3pqP8E2Rx5aV+uzrHHikr1c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PHwD8w+f; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=reAirSBY; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PHwD8w+f";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="reAirSBY"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 684BflQK4015697;
	Fri, 4 Sep 2026 14:01:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=GRFNhm8QsprPYSv3QEcOXPEHS+uWEYomfFk7QVIrBSo=; b=
	PHwD8w+fIZqU6Z5FC4f7SgaUp/fU8HxIpsUJU2BRnZlD1z65tZkNfMvhfk+MOxeJ
	DR9AkNh7dXvOspDQbYzrnBJUFOCmyHyZGZQi/1nsq07YuB3QQISYREHP1kfatTB3
	KPMAz+K/p0YZoGL0KqKUtq1hsV+6PtOz2M9e1K5CVQEldxq1lNAh9QL7TN8qOUMt
	13MnucxFfZHDmptRcv2KsDoxXfllZohCGCTCdC3vXjBrGCQHOTl/spRabI1mt/09
	SgROZl/EVoQPHjpCWuJV8xcdt8BGSC2Bnraw1l4mQlJKclUKor5Sh69cMZdnNK01
	BKBPnHFDfnjbyLiWrKnxAg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbqfcb04b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Sep 2026 14:01:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 684E1002004034;
	Fri, 4 Sep 2026 14:01:35 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012023.outbound.protection.outlook.com [52.101.43.23])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gdymx5a84-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 04 Sep 2026 14:01:34 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=irWa61Fe4N89EDsrzXgHQotisol54W7GFJ7A3yMh0FU1YZJNztQk0grxHvST1ormn/IOK7tI094c6JyNEEdqVRMcCb8U4/tk7OV9TwnmGuWrVoLps/BrVK4wi4y7riOSLNu+Qv70PFm48C8iuSBepzH9iLUdHBr6K1BFkefR5Ro5eZ38LvOvbWn+tsTgTUazxf5dj+7bBFp2kSzIILg7+j6Egxe5y3fbRkp5REugUc1D5e9PhAN4HB2qNClymAB55eXZp1qkrA/2SbUjsg97zWywih5O/LwLoWQnBhh7HslXa33zU07odXCu9IeHvTGGi+TJ4dSE5199YF0bWtWCQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GRFNhm8QsprPYSv3QEcOXPEHS+uWEYomfFk7QVIrBSo=;
 b=cBHZ25WhqIeB8TSIP65u2nytQ3XdlcTDwneGuJJgx6p778uonVhb42AmZ6DC3OByFyMoDK44xnUGfwk1mY4Y6mlyp7CEcxOUEynQJ8af5KaTts8fn0/NKWgthuzo5CylMRaBVJ0Qo5zyK+zItppIl9vwN/5vbbtjQJ2h82Ofbik4dWazi3i463+NxAoyt/FPqjX26ygdGo5qcqN3GXzEXnjsgeqFshTnqftovdyXdLpEE5sffqZvnAPhYp/0ef12nO6I6nOt4M1pKSUgEICAW3DtBt+ItIwkrAGGxcAGR8+UEwWwHmJqR6NiZyjl1t4E6z1uEU9XvqVkfR8UqZ8+QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GRFNhm8QsprPYSv3QEcOXPEHS+uWEYomfFk7QVIrBSo=;
 b=reAirSBYDF+6yrOgRZJg6KL3g3nxCDRVqyGKWJKwyBZcaQFXSuSbGr1CMPvMwLt68Ogd2MmC6qPwzDqXuwxDnBuvj/BQ5YGN0lFBqY1YFeCwNLiPpmFUreDEBYRUFvRTWX3ZIGPJMyMiheBCuM81o3J3zJj8JR0epwW3loZyz/I=
Received: from BY5PR10MB4337.namprd10.prod.outlook.com (2603:10b6:a03:201::17)
 by DM3PPFCD1365510.namprd10.prod.outlook.com (2603:10b6:f:fc00::c4e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 14:00:49 +0000
Received: from BY5PR10MB4337.namprd10.prod.outlook.com
 ([fe80::587:3850:b94b:3577]) by BY5PR10MB4337.namprd10.prod.outlook.com
 ([fe80::587:3850:b94b:3577%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 14:00:49 +0000
Message-ID: <88401812-02fa-4425-b4b7-c6a2de07ab74@oracle.com>
Date: Fri, 4 Sep 2026 09:00:47 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : [PATCH v3 4/4] xfs: incorporate increased AGFL min
 requirement for minleft allocs
To: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20260902174025.284387-1-bfoster@redhat.com>
 <20260902174025.284387-5-bfoster@redhat.com>
Content-Language: en-US
From: Mark Tinguely <mark.tinguely@oracle.com>
In-Reply-To: <20260902174025.284387-5-bfoster@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR18CA0054.namprd18.prod.outlook.com
 (2603:10b6:610:55::34) To BY5PR10MB4337.namprd10.prod.outlook.com
 (2603:10b6:a03:201::17)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4337:EE_|DM3PPFCD1365510:EE_
X-MS-Office365-Filtering-Correlation-Id: fe8aa253-672f-428f-fd53-08df0a8cec91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|10067099003|6133799003|3023799007|56012099006|18002099003|22082099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	uD5Mj5hqGQBQ54rg9HwOYXWliPRjvXZ70gc9HVbsb4/3pZ0zrcwoLj5eIAuTyuCqFmnSzjQ5ofVEzJx6QJk/v8w9phJaRbfAnXuXI2629Iqly/9eTI43HF9+dNr491EqGDsZO9CNsfDGbzs89pgZMKIHucO9o0GqTwy1UkYIciRiAIeKO6E3kOPMr9JwQxCw1JBZ4h07ehzaSKcz7InLYc8QjRTvEX8S36AVmB3EkickBu91tfljfEgLzpink+bE7CSEdwvLYCXqGzqDVoijmKdVI3Dfbyw/pT/X/57bBZTbfn64Idvyebjivr5OahkMMgRW1onxHM0PIVOpqPKQ24m3VDhc6vrR0LKV7gz+gzSKeUcpcPb5aJ/YJODwge9VTBVgXwk9ZjmyIEL6tcbIpyMoAgH9ZIN5l6MFr/jnbvjjuz77nbpMY5G6jCO916HKwVh4a+pfsvRT07L1l1rNgvu2ps0yJ8sLn+HaO7bkOuzxhqKJUMjwSzakan5VElsTfXoAklAhKSgDKDoGq9Fn57QcsDwECSTEN9FoMWUltU1jlSm2DzWlE1okopPiDhk374lh2X01dIbYDTFSyl5hFi8VYO67VkZoQ/sWgxmEFYGbTetjzsn6B+1NYrU0viKVMopR6dsZls7cjaMrTA2X7T697G1q/R91uCGUmyPWfOM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4337.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(10067099003)(6133799003)(3023799007)(56012099006)(18002099003)(22082099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dGN1RXhZR2N0NTBiMVZJQVdVdUp3Tk9TSmRmek1MQk9JUVpwQWNWN202akFL?=
 =?utf-8?B?eHVQbkYrS0ZMUW82L2h5bVJvZEtxNWRNWjd4N09reG0yOFZTWllmZ1AvejAx?=
 =?utf-8?B?ZE1oVFRVczB6akFUajRNQVovRFc0MElBVkZTWHFFL21Mbk1SUWtIRmlUa3Fh?=
 =?utf-8?B?RlBXeDhjZFIxc2pUOWRvVEk1QTFISkhqVFFXbTFZSElwVHljU3A3R3h2OEUx?=
 =?utf-8?B?RUIwMmVCM1F2N0kxak5hUWdHcUhDZzFUZ2s1Q05OVjVxeWxJN09ZOER3YUd6?=
 =?utf-8?B?a0tUU3Y3TEh4a1lMNG0xdXpLUXAwRnlYQ3M3a2NCTUY5RnRIR0FrQStZMlc2?=
 =?utf-8?B?bzBHaDB3ZTc2RGFyTlZBaEN2K3M0WkhPWWxLZ3djMm84ek9mZ2FxR09WbUxx?=
 =?utf-8?B?d2xqT0VFRUdXcXJHRGY4MEZJVWQ4U3NFNTdmVVgxa3lUTSt3RXdncldPVkRx?=
 =?utf-8?B?SVZONlNQbytLQlFKYlJLUStOTkFtTkxVd1BCeEhKUFhkeEhraGNMRG5hcmJC?=
 =?utf-8?B?MmlCamdMb1R2ZytKR3dxaGg5UUpPR1NZZzREOFdaZTJZN2Z1Wm5MNVJtQzRh?=
 =?utf-8?B?UllSVUVnN1FkWkhiSTJGSXJrSkRqOXUrZERnbzVWS3Z1NWQ5MUo5K0NMcFBG?=
 =?utf-8?B?Y3RHVitjUXRkVXNHNmFETU1tKzZSL1dhL2hVNDAzelc3ZDV0WFRpemdGSXJv?=
 =?utf-8?B?d1BiTzV1QVlMOGNYajF6SmQyLytQU3NZTDFVR05zKzBWb3FDbTJMTGVnc1cv?=
 =?utf-8?B?R2owYjJyS2pjSEZrdHJZU1h4V3hacng2RHI2MHFEbGF5ek5Iclg2RE5Gc2Fq?=
 =?utf-8?B?NlZ3aDRUZ2xxUWdXSnZYZVhmU3VaYmExYmxRS2t5RGJZQjRVSm5rQkwxdk5j?=
 =?utf-8?B?UCtwNEVUb2RoamRhWjFpMytDOU9XclZrZlIrdDk3V09UQ3QzSitxSisrc1pn?=
 =?utf-8?B?NkJDTkxZWkVIUGNMU0hjVTB0eGVYdE9NTzVVR0thVDk5WWQrc3R1dG9UbkpJ?=
 =?utf-8?B?N0ZhNXpZQWN5bWdTNTIwY01yZTk5ckRtZGtoeUhxTGVDdW9FeGkybzRmZ1Yv?=
 =?utf-8?B?OFhxTFliZWZRM0trS21ueTZZUG9GYmEvZ3Rxa0Zsd3ZTTG5mUEsxa0lCLzB6?=
 =?utf-8?B?cTNpUjA4ZUFtYkhaQ2JjUm1VY3kyNVI5M0M1OGZSektXbHI4WDhPZUlPN3RN?=
 =?utf-8?B?anNzaHg3WDdRNkFyWWlTZERGTzNNZkpHU1pTVXRqQWkyYUt0bXpNakJhaEtL?=
 =?utf-8?B?K2FjT3phZ0FKaGxKYUVhMnhTRFp3NEFzRmtQNFNBMTRpY2NZTlAwelEvdXU4?=
 =?utf-8?B?a1R4RnBKemZFRXZ2L0NvK0pOd3NLbUg5YnZYZXRLSWYybG5wa3pvWWJJbHFj?=
 =?utf-8?B?OHJYOXZaSXhBWlJFd3hkLzR5dmxYN3RMT1R4R0V3aWxaUGZWeGVzZ0lWU3d0?=
 =?utf-8?B?YUh0cC8wejdUK2Q1elZmR1lHdFRxY1RIRC9jZUlHZnZORndJczRDY0QwMk9W?=
 =?utf-8?B?b3lJRGQ5OXFTK0F3VUJDVmpISmw2VkVpVmpaZSt4UTVYcVBaSmhJUkpJVTBE?=
 =?utf-8?B?cld0anBNdmpCSUlmMkpEVHVuMUxEdXByelp0YzhuY3FHSkNYY2ZBYk5jQlpZ?=
 =?utf-8?B?RkNuelNLbHp2LzB5MDRDUmcwK3FDVFJWMEN4YmIvTjI1ZitINkN2aW5lWEtw?=
 =?utf-8?B?VEtGSUR4Q2wxMU95czFQQ09XY2daeW5sbFBCalBWblcwSGxnOVhiM2d5REJz?=
 =?utf-8?B?U0VGMkFmOVk3elVrTmUrZU1VWVY0WnBVM0RSWkZqTkN2UUdQM3dwemJzNlln?=
 =?utf-8?B?L0dYakZzUFgzVUxQa1FKVWhXL3NTQ1EvWVJEbHVrYUwyZXVjSk9IN1FXNnU1?=
 =?utf-8?B?RzlVeW9GVTE4U0pIUDdzSm5penE3d05oOWdBWjN0UUNUbGx3UFhaT25nNHZr?=
 =?utf-8?B?cjM4UE5IbHQ4WExhYzJvbUo3VlpKWDNmSHZBajhMWFdSQ3VoZW1GZEwvcnA1?=
 =?utf-8?B?WVFrYTFHbVEvcHlYeEhaQWZYcHNLSSs3alBIbGxvdWJhd2ZUK0dhV3VHVXRs?=
 =?utf-8?B?RVBmbGdGQUV6RS9xQjZpRVZwZTNHWlN0Tk5POUpvNytMc1pETWtoYTB4M3R5?=
 =?utf-8?B?Z2xRaGdBZ2cxTmlmR1pMNzlseFlhTk9OaGRrc2htemlTd0RhMVRDQW1URWVa?=
 =?utf-8?B?cjRnTkJCSmNZVlJJSmxOTk53R2dsT3puSExjUzdRSDUxdnJIc0MwcVJUUm5B?=
 =?utf-8?B?a213Q2JEMEJEQm0wZHRpNVhEbTVTTlJMcVF3dUFrcEFUN3pvbk9jTUdKaXZJ?=
 =?utf-8?B?QnpQK3NrUWlGWlRZdVNXRjdGUEtESSttc1dITnlSME9jTm91aDY3aHZxUFQy?=
 =?utf-8?Q?S92m5clQGbR/1dso=3D?=
X-Exchange-RoutingPolicyChecked:
	JAGTnbXutKUkubSzXvq9lYUfUDtBmH8+/FPNIeqyyRu4iUcfmBy20u5NOtuSODS7Hj8Fq5FYXVwc9kgkAu4xrO/DruS9soQd167kTuFL2X+OK71RQeQ33A/lYWqdDgONSfm1tTfZy0F1XzM53hhOrSjKb7/8L81+COpv/f3f4cq844KZPSJI+EMth4wkNzX+eJldJww4A+P4pqP0huVa33yV+m7q+Zfs0YJBKulUGPH+4hJpwC/LHSVaWnTqB7xoADmlr/70Q+Y8/TWSgsNf0ueLa+smA80mcID9IZ9kw6e43/e3rQX947qVORmBCUItG6m5uMpynGDXLNFHHFJ3iA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	c1FCfnYbVmYC0p3wN3yqpdMsFohNgk0nmWZRC/1jUlwkM0uHxXXjyKx/3Dy05V8gnkyYvJw2wg7WhnPE/5JUnHLisjdL5DKTdxHmKwssnFgwEYtCxdIxmDQMp9oPZY+cRFySgml4nz83mf8rS4B0Kfv/7w35/hng9wOEs+rL5QfQ2mgXRVHd71z6Hs302ijrb+H1pUJQxZoT0Z4uCSjD6AAKzONzT+cugHeD25pi3gsqA2w680hpTFLDw9Rr55JWEFb80RZMaogwfkxdnU6ffKejUCd4kWnzhxXb1ib4FXsH6a5VhOiymYILKjgvh2DuexZd4X/qfOZZkrwKW5vbJzWjDGurgJGIX6eRdqQkcLIkog12zi3xG59DRls81gQ5cBl5yI08Fob1YETt/rDOgH9mfMGqbQo644ABC+OVkcOlhkyNpDHcBFPTnPmo0e6HNGoQS/Sv4l/tfv7dIfnrjEVgMf0+QvuovESlfQ1jRbRMZJF4J0GjVkSgEPGnC/gF5pduMVrqeg0Ig7zuVijuGQMK5CMo8p7HrjvGkrI+SRV844BYGpq3TDXL81SARS7r/qwxOJ6VEO44Zl+r6CBeZGnzVbD/qfm6VdtHye1HNbk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe8aa253-672f-428f-fd53-08df0a8cec91
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4337.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 14:00:49.1554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8OSWcNpeX/nygA0HPlOgc/FrGkEW1EnWD4iTctnFBc27s1oPa5Xh4NLXsu5sfu8k8clNqb/QSbxvYWLOcRyz9FUH4A8mqDXQtJDY80K6pJM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFCD1365510
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-04_04,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609040127
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA0MDEyNyBTYWx0ZWRfX6fVBBglsMvbR
 dLzq23h5QQR5h66GRHg64x69SaEJT7dtN1iDQtKQolrHeRmxpw8TJMiCeW6bvaN2YVJ4w3n9Uxk
 uXkE1zIM63sH+PUNzK+jhVAumbml1RRCPI8vnxRAl6VLjDr9HYoV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA0MDEyNyBTYWx0ZWRfX1IASZOu92wN4
 HzL4bujMbuPW5sT9aaJW8YL9xieyhvXp5G/ddjw4iNFp1MaMh4Y5nPkZFROawyGTATh4M6KCq/Q
 G0te6IjP5CFpOceQIv+ouMSvLidJGTWTQuueUNJWzkaPGmIhdUSYKLJBuUbrgV6Ac0YR/9FT1IY
 U3vpJrL1ACWlpd/7rraktEDhSST2qXwIa/t+U25IbsOiPL+l6d1TlGRJTyC7u8nIdOKQcApNMns
 czVlrlc001iJBv8LzRHFjl6mmYC2GRYdCbNlCWf/Uzuws6Bm0bZhSwY0ETdhFobI3+bhx9I6wGD
 O/w+jN/CFvB4oUtvxIzQ0giFpgzgHuTHQZbYwLNEqzaBfaXmKHgin+0b6yCR8CuMRoyXTJNQx+R
 A8lulGkcWImPNTxdteV5LN8CFiME/pODqS7idkPjDSVJNgT+ROo=
X-Proofpoint-GUID: fK2i2Ag5KW8tt1ZhIGoqi5wnX2CUR5n8
X-Authority-Analysis: v=2.4 cv=a9gAM0SF c=1 sm=1 tr=0 ts=6a9acf40 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=vjukTtsuAAAA:8
 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=yHwp-z0L11TGq4fV4R8A:9 a=QEXdDO2ut3YA:10
 a=pxVR4CkNEMOefyUi7ZpQ:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13521
X-Proofpoint-ORIG-GUID: fK2i2Ag5KW8tt1ZhIGoqi5wnX2CUR5n8

On 9/2/26 12:40 PM, Brian Foster wrote:
> Matt Fleming reports a filesystem shutdown due to inobt block
> allocation failure during sparse chunk allocation. Inode creation
> can involve multiple allocations in a transaction: the initial chunk
> allocation and inode btree blocks via inobt record insertion. This
> is expected to be safe by using the minleft parameter on the chunk
> allocation to guarantee the selected AG has blocks available for
> a followup inobt insertion.
> 
> The sequence that leads to this failure is that the alloc and inode
> btrees are all full (require a full split on next insertion) and the
> AG has just enough free space to satisfy a sparse chunk allocation
> with minleft set (i.e. 7 blocks in this example). The chunk
> allocation splits a free extent, triggers full allocbt splits, and
> consumes 4 free blocks for the chunk and 4 AGFL blocks for the
> btrees.
> 
> Next, the inobt record insertion triggers an inobt split. The AG has
> enough free blocks, but the allocbt splits caused by the chunk
> allocation have increased the min AGFL requirement for the AG due to
> btree level increases. The AGFL requirement as calculated by
> xfs_alloc_fix_freelist() is:
> 
> 	free + AGFL - res - minfree - minleft = avail
> 
> This evaluates to the following on initial chunk allocation:
> 
> 	2514 + 8 - 2505 - 8 - 2 = 7
> 
> ... and then after the chunk allocation but before the inobt block
> allocation:
> 
> 	2510 + 4 - 2505 - 12 - 0 = -3
> 
> This causes the inobt alloc to fail despite minleft being set in the
> first allocation. The error path cancels the dirty transaction and
> shuts down the fs. The problem here is that while minleft ensures
> free blocks are available for the inobt insert, it is not sufficient
> to cover the increase of the AGFL min free requirement.
> 
> To address this, first have xfs_alloc_freelist() return both min and
> max freelist values. The min value is the current AGFL requirement
> and remains used for actual AGFL sizing. The max value calculates
> the worst case AGFL requirement after potential allocbt splits
> during the current allocation. Incorporate the max value into space
> availability checks for AG selection and the longest free extent
> calculation. The latter is necessary because callers like the bmap
> layer can size allocation requests based on the longest free extent.
> Without this, aligned allocs can end up oversized, prematurely fail,
> and fall back to non-aligned to make up the difference.
> 
> This ensures the selected AG has enough blocks for both the caller's
> minleft value and the worst case AGFL increase. In the example
> above, the initial calculation now evaluates to 3 blocks available
> instead of 7 and the inode allocation fails gracefully with -ENOSPC.
> 
> Assisted-by: LLM
> Reported-by: Matt Fleming <matt@readmodwrite.com>
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>   fs/xfs/libxfs/xfs_alloc.c | 58 +++++++++++++++++++++++++++------------
>   fs/xfs/libxfs/xfs_alloc.h |  3 +-
>   fs/xfs/libxfs/xfs_bmap.c  |  6 ++--
>   3 files changed, 47 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 1377c65d694e..2ed269080bbb 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2397,31 +2397,36 @@ xfs_alloc_compute_maxlevels(
>   }
>   
>   /*
> - * Find the length of the longest extent in an AG.  The 'need' parameter
> - * specifies how much space we're going to need for the AGFL and the
> - * 'reserved' parameter tells us how many blocks in this AG are reserved for
> + * Find the length of the longest extent in an AG. The @min_free and @max_free
> + * parameters specify how much space we're going to need for the AGFL and the
> + * @reserved parameter tells us how many blocks in this AG are reserved for
>    * other callers.
>    */
>   xfs_extlen_t
>   xfs_alloc_longest_free_extent(
>   	struct xfs_perag	*pag,
> -	xfs_extlen_t		need,
> +	xfs_extlen_t		min_free,
> +	xfs_extlen_t		max_free,
>   	xfs_extlen_t		reserved)
>   {
>   	xfs_extlen_t		delta = 0;
>   
>   	/*
> -	 * If the AGFL needs a recharge, we'll have to subtract that from the
> -	 * longest extent.
> +	 * If the AGFL needs a recharge, subtract that from the longest extent
> +	 * because AGFL refill happens before the alloc.
>   	 */
> -	if (need > pag->pagf_flcount)
> -		delta = need - pag->pagf_flcount;
> +	if (min_free > pag->pagf_flcount)
> +		delta = min_free - pag->pagf_flcount;
>   
>   	/*
> -	 * If we cannot maintain others' reservations with space from the
> -	 * not-longest freesp extents, we'll have to subtract /that/ from
> -	 * the longest extent too.
> +	 * Extra AGFL blocks beyond the min are reserved by ->minleft during
> +	 * allocation. Similar to reserved, these blocks are not available to
> +	 * this allocation. Check if we can preserve the combined total without
> +	 * the longest extent. If not, deduct the necessary blocks from the
> +	 * longest extent.
>   	 */
> +	if (max_free > min_free)
> +		reserved += max_free - min_free;
>   	if (pag->pagf_freeblks - pag->pagf_longest < reserved)
>   		delta += reserved - (pag->pagf_freeblks - pag->pagf_longest);




The only concern that I have is we have to assume the caller calculated the max_free.
But ....

Reviewed-by: Mark Tinguely <mark.tinguely@oracle.com>


