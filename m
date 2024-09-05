Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51EC1991A5
	for <linux-xfs@vger.kernel.org>; Thu,  5 Sep 2024 08:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725524160; cv=fail; b=rStDbOZmEf8FyERF8LwOCXsJrGr957q2vi6zNneuWLGQP0CBI49mDc64Z0YkaeyJwR6dleWCGQnBF4WkBjojomOVMqydAbtkllRkoLmNERJis7aISdLUMhYwmjQrvL8Rh1sNSvwbsRxvAWHxTeB5jnjIHhbUs5SQy9XY9KBVL7o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725524160; c=relaxed/simple;
	bh=iB6OujXJRJYt1bNx0Z3y5FE/glLeTlde36wMg35SMog=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QEta5SRykTJrFl48ul+3wVxF1LqM0Ccqr9AMtQimBsTOBGClSy9EGr4sFLe25b2afH83GovJ9F+QtHSSKX7l+2DGFLFsTbdrSPYioeqVma3BOOcc0x/7buobWnniazbhmD9laapCPOo0EAMIJwvsi1H1TU1pvB8Jmwp460RO1HY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dJ2ufN+X; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UfWvPR8T; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dJ2ufN+X";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UfWvPR8T"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4853tdg2022495;
	Thu, 5 Sep 2024 08:15:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=8U7LbNcK9rsu5A6gOu4p71+6kJzI7ZNW3IAgPMgzHIw=; b=
	dJ2ufN+XXUJy081bTuFx71y7u2+03UVqspbXwFIC1jvyWPiw/Pe/REL168VwiqLd
	05A6tZpT5eJmdYS6/V3visPpJLWOzLNETf9UiOWAy5s2BmYM6Wa6ZlhZyT/3P7+M
	knuwFuzauZ5fMr/ipG7j+yB6I9tzjNXtVc0f2RCgd1C3HO96eZpmCHGx6TfBb8gT
	UWwVoQ8LzRiFXBhg6fzisvhqT6+fVgnuG5InRqn4YLSZz8icx5+RMhE97JLL3acV
	D7ZEXkr/m7ZSRrydoBY46onK1MQ366yIR2PMuaC5oAy1j9tSuS9nAoxxsdNm3cJ6
	/9x6tT332qbBO23SfixhYA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41duw7wdks-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Sep 2024 08:15:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4856uMHv001688;
	Thu, 5 Sep 2024 08:15:54 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41bsmhf2dg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Sep 2024 08:15:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FmOZ3D3SGFRCRjhlBPa9JpnJ8c+8GMft5zS6b3VnCr8p6Gzp8O4MSq/9WoPEZ77555m8s1Ae65E+gT+NYaBJAkD5cTxPPbh5ItRMDU2Rz0d3nKr1CYOfxgsu4XzMLC92IUD16SVu850XI9hwfv2vf+UQgcxoB9dg2WLAx9OBB7WZ+GGhaqImmkxKrM2QQ5kASpora6K93FyXEg/6KkHenX1eAxvjNuVFrHE/cQhxs7CPQyztT3pIM/rkCmi5eQ2vawa5JPFi9pJUp6F0VkgTLJYQSeVwudytXMOQGfNnMe1XfWEbXnm0LNmcJ5nK7HxYuThMKe/CcwAvLRKAWrV++g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8U7LbNcK9rsu5A6gOu4p71+6kJzI7ZNW3IAgPMgzHIw=;
 b=zRluCEqOBi9PnG424EMPApmd3RAW6deOgsdduPCqxWM47nWMucXtJ98n2L6QRZsujfGZwZS/4hrGkqYF4LXFRNw++s28oTGz0j5ulacFQL6yCNISCz5RcQUFaL3zl0dm43acd5NEkZNd7xk/mpsB1XwDhd8AirRWx2Tc9Hjy0q7XRMLmxWgbRs8F+uyJysxXNn3xbbP6cIsX+wjwSJMYpjHKrkiL/PqApXXAHSXgEia6ElPXdduA2TLs/hdeQz+bOirj2znByy7cZB5mDK4ihn/J28ygMe3b1w1InXxUDVhaSkxrEAGBgIucKMRlGIUYU781enTWn406K0cDA268KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8U7LbNcK9rsu5A6gOu4p71+6kJzI7ZNW3IAgPMgzHIw=;
 b=UfWvPR8TBCuLfeTtenh5Yr0PJKb/aLTD2GG88gcPWa+LekiIdMfzCqETm+PUE8QHcOhOw0iJto2x77O6CKWt10nXrgHLaz6aognTKfEXVYw3c/Q4oU0BWCX/40dU0flOCjz8cVD56ED9Zdc9JmcC7hRnXu0NeGvPduk0IJ5hFCo=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by SA2PR10MB4811.namprd10.prod.outlook.com (2603:10b6:806:11f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.14; Thu, 5 Sep
 2024 08:15:52 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2%3]) with mapi id 15.20.7918.012; Thu, 5 Sep 2024
 08:15:52 +0000
Message-ID: <20472c92-188a-466c-ba10-2a634782782f@oracle.com>
Date: Thu, 5 Sep 2024 09:15:50 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] man: Update unit for fsx_extsize and fsx_cowextsize
To: cem@kernel.org
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org
References: <20240808074833.1984856-1-john.g.garry@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240808074833.1984856-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P123CA0026.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:388::6) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR10MB4312:EE_|SA2PR10MB4811:EE_
X-MS-Office365-Filtering-Correlation-Id: 1043df64-b494-4448-ecf4-08dccd82f53c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SFgvZkpDbWtSdjFuc1RYTy9za2IvWDd0WW8vOWpNZVpYSktKNVJmUjJNZEUr?=
 =?utf-8?B?TytlbUMzbm5iOG1DV1hSMnovcDlpKzB2ZkJLMzNEU2ZYSXdURUVNczFCaTk1?=
 =?utf-8?B?R3dCRGJ1eVJGNSs3SjFmOEpDRnNVRVFYRi9mUTlRMk1SdWo1aWpaNW5GUjZU?=
 =?utf-8?B?TE1FMkJMNWUrRmFpSXFFNCtDbllVWGRMM0d4UkpxZHFOVktlT2ZJQUV4Z1pF?=
 =?utf-8?B?d0dUYzVIVW5KMzdDNWoybzlpWStlN1Z6eElNRFFPWC9RWXhJZnZ2eFBqM0JR?=
 =?utf-8?B?ZFkwc0dZVEZmM3JXMjVQeVFLUEt0aTQxU1ZjVk41UGZVVTRUR3RzMDhDN0FE?=
 =?utf-8?B?RFlla3l1VXVnTTNoVGRrNDFmS3hQallITkV1OS9YOUh4UnRCYUdLM1RtVzZB?=
 =?utf-8?B?M0xtRFdLMVBMNUx4M0lvekppdk5EZjVKWFZkU0dNZVNIdXhTaVBqOEhoeStz?=
 =?utf-8?B?b0xUNFRTTW5yT1l5dHNVby9jbjI4V01rRFpvWVNBWlhYUHZSdGdrTmZlRUI5?=
 =?utf-8?B?OXlTMGtWbnVIc0ltclltYlludHU3L2ROMitGcmhRd0pFOWc5ZTdtenN4SjZI?=
 =?utf-8?B?M0NpSGRUb1ptaGx3WHZLYUlwRU54WTRDYlZQT3l1eW1xUTJFNzl1djZFUzRV?=
 =?utf-8?B?WkNJZ3ByU2ZFc01nbE8rc1RrRnVkdys0SkQvV3FicDVtKzE5cUZ6aEdrSk02?=
 =?utf-8?B?Y0tBa1NZMWs5UDhEOUZMWlVqVVh1cmhUbjI3WmVEUkNFSFhzTlByQytSazBG?=
 =?utf-8?B?K3ZDQUZ2WllrS1QvTmdwaVkwRnJCUTBVYkxVazd4OGJ6K1BEZHhCdVZsdHow?=
 =?utf-8?B?NjJtb3FXK1lITWVVRDdOeFA1Zm9vYmF2TTArMjdKTVh0ODMvMll0ZmJNamFF?=
 =?utf-8?B?U29CVGtWYUh3ZVNsN1pIcnVieUE3bUFVWU83bllQdzB0bnFlZGlRSWJSMzha?=
 =?utf-8?B?c05GYndSNmROUWlFdWpvRnlIc3FaVzVNdFB1Y2V5Z21zRDdwZDBWZDhOeUN6?=
 =?utf-8?B?aGdvcFdvVHVVQXcyU2l6cXczQ29jY3AyWXV0RzdHb2FoT202UjBWMXZCU1RC?=
 =?utf-8?B?UEErbGJnOVgyNXEyUXFRZ0V1ckRGT24zSUphVi83eTA1d3FiV21DajVBdG5M?=
 =?utf-8?B?Vmgzb2UrYjV6RW5ScDdEKzJZZzhsNmc1WjRZcVhzeFNpdzRFRnhickg5UC85?=
 =?utf-8?B?THJyWkdvNVZHZlQ3cGE3d2ZzMk4vaDRxeWg3UzEvUkE0SUdlQVNvQkxmY3Yx?=
 =?utf-8?B?U2ROWHdnRjhQMVRYbm92bVNpYjV1WTJaWHRNNjhDendvWXRVamRhRnBHTEN0?=
 =?utf-8?B?cHBwbC9TRTZVaTBjWDhMY1Q5ZUlaSXBtbG1mVlA2RVdNM2hybVJ0S2FkWWlO?=
 =?utf-8?B?MG9BU3VsWnlwL1FRVlc0L2k5UVJ4VUJZeWRZaDQ2MEZPWVF6TVZCQ1hxRHJD?=
 =?utf-8?B?SkdHdXRFTEZCN1czMkIrQnorRGJBNFpORWErSXZZYUNPZWJjRHAybFVBUGpt?=
 =?utf-8?B?QzdrMGdVaDcwVjVWd3l0cXM4c0VoSTJYWDkvWnBFOUkrV1ZRTS93K3FlK2kw?=
 =?utf-8?B?Yk5MZ0FFTWRkZ3B3T2NSZ29uM1pNSDFyNzhSNUVicSsyUFJTbjc1Z2IvV2l0?=
 =?utf-8?B?UWdDVS9JYm9jbk1ud0JmM1FGS2VvOHFXeUZIQmx2MW1NN091c3NHNm5ycG9y?=
 =?utf-8?B?eEkweCtmdmd6Y0FxZi9EY2xQd1c3bGM1ZVNoOHFzNCtIN3ZkblljWllXaFZQ?=
 =?utf-8?B?WHN1T21nRE9ZVEdUZ1ZldTZzQkFxYVJZRVVtLzdYN2R0aHdEaTJmdDFiMGxr?=
 =?utf-8?B?U2laWXF0bU8wUjVEMmgwdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V0hucktsOFd0WGpxTE83RzdFYXNFOGZMdXNaVG5SVlNkZXFydnRVSDFmMnhO?=
 =?utf-8?B?WE1TTkkxWWZMQWhtZlBUMll5VytHa1o3SEhzWWVlSlNpQUpaV3hCa1hsTUlt?=
 =?utf-8?B?WDlUM0sybUhscGNxL1NscmE4MXlGZUovZGRxTWpSNFFZUWM2dit3SjZaUzJu?=
 =?utf-8?B?QlB5NS9VOGgvTGFkb2VueTFlVnUvRGtseUNRUCtkUGhxdW5ob3lMMERFa2Nx?=
 =?utf-8?B?NUF6YjhpMGNydlp1WmZxVGRScTRKQlFGMnYrTHljU1ozdlZuK3B3WkVyMnY1?=
 =?utf-8?B?VFhZdGxwRERIMW05cFlTU2hkd2RUNytzMnVoTFQ4TU94cDVWSTR5M2toMXAx?=
 =?utf-8?B?M1BVbFNqcWlkaGppQUFsMld2TWdLczlSa3JDLzJVUlR3bXZid2wxcHhJUGx2?=
 =?utf-8?B?MEVKcUNrVFlEUnhZUFR4eWhEd2lUQ095WTE2RlF6QkFtVXBsbXl2UkxBUVRY?=
 =?utf-8?B?eE9lSmxxWGNpZmxJazhhVUF1Y09nOFU1T25mazRsaDl3cno2WjBrbGk5eS9J?=
 =?utf-8?B?RWwyc3ROWXk4SUNReGhiVm1EZ2I0QzNYNjd1SjB3QVF0VVJXVmJwZHU3WDg0?=
 =?utf-8?B?QnQrYmlJaWxhR1VqUWU2RXB4ejJCM1Y2VlczbTdpZGUxd3RhVTluTy82dzBV?=
 =?utf-8?B?Zk5CVUxrMmE3QlVwZ2dhZU5yQmd3cHVJWGFEaWs4YzNLU1JNS1B2TFN4dHpu?=
 =?utf-8?B?OFA5d241UVA2M0JDcjhyamwwS0gwTm91Z2VPNU9uT2p0VkV3R0YyaHQ2K3pB?=
 =?utf-8?B?YXpRdnlZdFJZczBxa3NkckIyMlI5VlRQY1BnMkhkUjhBcHorWEtLK1IyOVlo?=
 =?utf-8?B?YkExbUc3b3d1UENCL3hoODQrMzF6ZTM4OCtTdXVUWW9HY2dVeDBOd3dodXor?=
 =?utf-8?B?M2Jvbk1jdHRtcStrWEVRLytQRlIvYVlPcEhLS0REYXRTVjE4cVIyQW4wekw5?=
 =?utf-8?B?QTR6TldCYVVSZTZzZXRJK2xtS1pHNy8rMnEwakNrWlFadk5KdHBaNnBUNU54?=
 =?utf-8?B?bkE3MlRSSURVNGlaUWErbG5Ec0FTVVpWK1lYbE1QRFFiallxSTE0enRua1ha?=
 =?utf-8?B?WXBoRXRSc1VPRC9DNW1GakhiM0lnLzNhZHdHR3lUYjc0Vlg1Z2tna05CZEdV?=
 =?utf-8?B?T3FMSWxqallWcTkyNkVqQkR6WnAxL05yZFloZTNBaGEwVURBZi9hL0ZuYlRw?=
 =?utf-8?B?VzUrdm5mVEdabGJCeFVrc1BndWprN0J1dXQzcGFBWHZXb0Z1RmlGOGpnRm0y?=
 =?utf-8?B?WXFUUWRmb0xPd3ZUcFJHeldtb0RjSTcydGJLa1o5OWhURHNXemVtcDgvbWRF?=
 =?utf-8?B?NmhNZ0VrQ0NyVFU4cmtwVWQ3R210eEpUL3FiOHVGRlVFVFlnTjZpR0dDQWR4?=
 =?utf-8?B?WFBCdEdiU3JkZ0ZTN05oaGNGSmZ1TmdjQ25UYS9ZMWhIMDFlOVZCWkV5L2d0?=
 =?utf-8?B?K2xJTW1XYzZPZFl1elUzWW5GYUo4S0E3Z3hwdVowVUxpeVBCV0IvRFhNTzBL?=
 =?utf-8?B?d2RQVElzZ1B0WlgwUW1VYllLSzErOUkvMkExR1kzQU5HeXNNODhhOEo2MW4w?=
 =?utf-8?B?dzFQbHp2K1NYTzR6bDFnWkdhTEtoNEZpTzNhcVVXb25NZmVJY3F5NHpBZXUz?=
 =?utf-8?B?dlE4Q1J3OWlpUEFzVWxjZlJ2TlJINjVYelZmTzR2cGdsMXJxTWErbFJTd05V?=
 =?utf-8?B?U1V3STg3UkVDRXRRaFNBL1V4bHhFRjNIRWoxVkxiMTlzZFNrbmNzT3BnbXhD?=
 =?utf-8?B?L01BY1B5anNCcDhSTDQ5UUlkVkFzRTdubmtTQU9QcHJaV3MyVUhwZWVGaVBn?=
 =?utf-8?B?emFrNXNUbnA0MWJhd1o3VTdIdWxueEJndnBETkxzMHAyMkxTcFp6NVNrSC9U?=
 =?utf-8?B?VEE2aE13VG1FRm8zWFpEZS9JNmxhUTBqVG53clZMVXdZaWJidVBCb1hZV0U4?=
 =?utf-8?B?eFAwYmp1Tk9qL3RZbDJEbituYUxxbzJKY3dDQi9yd0VwOGtBSklTek5QV05P?=
 =?utf-8?B?N25rSTN0VVdVV1hjY3hiREdwVGtHandicHlicndwUElXMDViQ1p0RHlYa3Nn?=
 =?utf-8?B?UGZwN2s2bzZCb1VzNkJTbzJpL25xemhkNXc5aGxDV3ZvWGxlUTVEVUxqZk5i?=
 =?utf-8?B?RlBVSjdNeUVuVnVDY0l1cDZFMFRldmpFSkw1eXNVVzNRUUNkc1R2U0FQQjN0?=
 =?utf-8?B?MFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SetUChJDuzMZxsv0mNacS/eORokh9k9F73A0Uo0B/tRI5yXwtQmCI7qzO6C8gSYrt1ZbCTE+SgV/2CG/PfUyJr1Dz8iz8c0lbvrfmTMXAmmlh34z++VwasUqp6ynxr719HMXwoCu/6tT8imKuVwg3cmqN04zZS4Rm0tg28mfUHB74dVD9QFRyCnUJ86Ljm90F/OBdeV1WKplh6Pc/ptaCIiDZEn1XUeGo0RselgT05B1j6Z8iI1W5lN7i1vgmv9OV5pyTAA0fgclLOtF96MY3Q1AFSzauHhI/jNfhLkPttDg5zhhZLSyUSyl9k/ZtAwnLJYuyhRUJB1RvWcGZPPNElM74YpR5EllPieCpgukR/r6iwKsYbOxJ2tKiEZWctyowwe82vIBNJve/Dn/M0JCuht21OazYnZ/oXJjNmEl/Ykb25nR+HeCfaO8hefL9Lv3/xaXdp/ODJO89LhYijeac/+ma1+1T765LqXd/vL00+BnDZWPIygqr6XxoYFIVPPok4p0YqNx4PkLXsZ9sqL1P5Ltqs2YU6V4D2kjKy6CaBj5M7XQikWkTB/uP5pyHVwqc3rLCKpyi6njussYf1i2UYEJ/VSW17LClUIMXWE3VEI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1043df64-b494-4448-ecf4-08dccd82f53c
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2024 08:15:52.6600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HqRxEah1thuKDv2/PI46d7AXv4+23gBk2TS32FJiX79BTCNB+U1owwoBbd/a495AwCLpc27Vn7+VNNvkkgrpCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4811
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-05_04,2024-09-04_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2409050060
X-Proofpoint-GUID: BCT7eSO7_1HCE0L3WNCuVgz8JeQTDI87
X-Proofpoint-ORIG-GUID: BCT7eSO7_1HCE0L3WNCuVgz8JeQTDI87

On 08/08/2024 08:48, John Garry wrote:
> The values in fsx_extsize and fsx_cowextsize are in units of bytes, and not
> filesystem blocks, so update.
> 
> In addition, the default cowextsize is 32 filesystem blocks, not 128, so
> fix that as well.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>

Has this change been missed?

Cheers,
John

> 
> diff --git a/man/man2/ioctl_xfs_fsgetxattr.2 b/man/man2/ioctl_xfs_fsgetxattr.2
> index 2c626a7e..25a9ba79 100644
> --- a/man/man2/ioctl_xfs_fsgetxattr.2
> +++ b/man/man2/ioctl_xfs_fsgetxattr.2
> @@ -40,7 +40,7 @@ below for more information.
>   .PP
>   .I fsx_extsize
>   is the preferred extent allocation size for data blocks mapped to this file,
> -in units of filesystem blocks.
> +in units of bytes.
>   If this value is zero, the filesystem will choose a default option, which
>   is currently zero.
>   If
> @@ -62,9 +62,9 @@ is the project ID of this file.
>   .PP
>   .I fsx_cowextsize
>   is the preferred extent allocation size for copy on write operations
> -targeting this file, in units of filesystem blocks.
> +targeting this file, in units of bytes.
>   If this field is zero, the filesystem will choose a default option,
> -which is currently 128 filesystem blocks.
> +which is currently 32 filesystem blocks.
>   If
>   .B XFS_IOC_FSSETXATTR
>   is called with

