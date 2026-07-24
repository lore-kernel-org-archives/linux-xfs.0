Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEE33CD8CA;
	Fri, 24 Jul 2026 08:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784880939; cv=fail; b=Q6C5XYy6CqONesUowGWbVl5waolugE43WE91smw3aJ9KpkbYc/rfHu0VMC2E0rkNSxS4ley1aiLQg//APerxWDUhkK6wr/h4YzLo7sri+iJxZ1Q9mUsGWjuvMm5S7lM6ujKGD/y3m661IySs3abwhqoQfQXOdtXRW0Iv28futmE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784880939; c=relaxed/simple;
	bh=d/mLrH5vLDcCGUYhg4TT0GE2SlugiaOWgecMVqllxNQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NZ0uo0/74eKmOszHhKS77aG4/CnCioCrgjt4MofIp0LJL4QNPUiF78E3fY3txqdy5lygn8qZmo+5RbTdpynyZcvjZJRVeHkgd5TgNmkNDbtkQabWDVZCeGbfUepUGGvOt6s2ixHuAuivsnfYay0oUvEImbd7J8Q+YSxxO8Nq6vM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=E3CK9Frc; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="E3CK9Frc"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66O6ibo51096250;
	Fri, 24 Jul 2026 01:15:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=tlPRxPbtA2KwOQVgK5ofSlpVgQkC1Ov0gwF54nzjKvI=; b=
	E3CK9FrcFgbbbi+j5dfIuog1JVzFyBKxsKcVnv3F2lTBHwWdQSPcydFrnHPa9fGT
	PJ6KM4TmFvo2ieqYEUPmlyYdWAALRdxPlfEVH3eMMDf/79XeCFRutUR4o/ZbDjvs
	nJrcrqStkGY3OrGBK+vVTXIAgZj3kGzZjnSsEI82F7HZpp24j83bZGA4luf37lvf
	lbCLFvvr2mqkkS7gf1CKyDtLbE0CExSp6GX9qzNupwGnfEmCt+uk9jlqNdMfd3wD
	5Clkk1SCHMj/G1qQe3jziighQnIoYfSKz7UO/d1EclAPmOvUuJreqZrL4VkVgGI4
	HU7K8mxNKXUbM/v9O4HCiQ==
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010039.outbound.protection.outlook.com [52.101.56.39])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fjt3u4cj9-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 24 Jul 2026 01:15:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O4Uw2bvCtSiVXLYY25Nsll0cvEtg83Vl1Cekm5SJkUFdnn6+JXSmmuEJwFvBxXB0VkV0a/rHwX31zl9vuN6Dbm9ki4Q8Oo5MKp3UdWtvmBAK9SbKo/ONWgdEi7S2CwfIQexNV0K0o5UhwF3QK12yyRUnPeqFC9Wm5SOxfCkl3v/09bBYwbi+AaieNLTeIVdyuwOKv/C5PfKVqY230+CdUY8h3vGKE1UciH7wgTtos+5RHeEhqAssY2L1mKWgOTuqUp+VA0h1Qm6HFLMPj1aiU/PJVgRZ45U2CVM0PnTzt9IRS+eRc/4qh5Rdg/JgSPRcTIDsmyMRE6UcICjVI1WgJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tlPRxPbtA2KwOQVgK5ofSlpVgQkC1Ov0gwF54nzjKvI=;
 b=Kx4sNaCojbFfHsNkweDP9Zc682NkFLudIU0rPYLe/vKlEGn6/XH0WGq+Y3LHmANt8JjPlpdpruaJLy+Fu3KHY4ukrUSb+Fh0swDu5JwEfhzqoD+1mrjb/CygXnuAzg9huCv0psCLqRwV9YKGr179/RrJVGI942ZE/rWwo5WVB2U6V4CfrfxBEaDt0OmzYhm0PxyiPqCwbRyCXejoV/nyUF+LNfvzWVMdzuixLdHMrpwr1oh99b+SsMtISVZA3ChNhMTmrV3yE6ptnBDT5rSBPY4pGNx40XeeGFL4u9pI2GlebSag0k1DLOaSPLaNaEhXtY+mfA6Uc20pQTjeXsbPNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by SJ0PR11MB4846.namprd11.prod.outlook.com (2603:10b6:a03:2d8::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 08:15:01 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0245.010; Fri, 24 Jul 2026
 08:15:01 +0000
Message-ID: <df41a675-2991-4157-96b4-f8672e906a6f@windriver.com>
Date: Fri, 24 Jul 2026 16:14:52 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: fix nofs context corruption in
 xfs_btree_split_worker
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
References: <20260720050522.3101824-1-yun.zhou@windriver.com>
 <al3dypUNu1VNZErK@infradead.org>
 <3f683dea-fdee-416a-8112-2db000c4cf4e@windriver.com>
 <amMdC5fvYcsFXNmA@infradead.org>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <amMdC5fvYcsFXNmA@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SE2P216CA0127.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c7::16) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|SJ0PR11MB4846:EE_
X-MS-Office365-Filtering-Correlation-Id: ca876dad-c491-48e2-3599-08dee95ba889
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|22082099003|18002099003|56012099006|11063799006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	vHUFJpBasS54vYvh3pZUpHOzpmBxklTXOKoP4oRGuRTzm5/FmalZ7zqZMD2umm58OQ6GAxPaKv9NGk1cMFHEvf8Vrq5hidJhGgQc1HX/Qb7dqu8eYgd6jgzOfsHeCuPCRfBv4JUNjpLs/4+I/jR7tB4vEbKJU66A3cbbsZEutXrLaBPGIZ/xCiJL9580fr4QMD1CMLjP8vVlzwHMMAKRO98M5teXKOrbULxKlW5diwKmpZom5f0a5uiDUM8O99FSI79zDEMTtkuS6fJIGL9sUYVWSXW/ct9wRGOM4YhWCqW1+qAPZ1/8OUN8yWx8rF7fYSssmEbCsSYHoWTpueprCWy5fL9yt9W98ugtkzz44hLuhKDOutvtERkIhPwnJWbO6Q0Kon4ufbMPXW78CdS4bQKdbz7yQskXNjK9I7udlz5tYgnk9jHK1BasOXYsgyh5CwqocnIidQENLwXIgxTh2dulUawViUR4gcPFxFvvsWf6U+VnwZ1C0Vcn8M+d9tSnH1TQ9Ma3oAsxEJ7q2g7VM+YnaQ2QDlwvNOU8h2ctJsbq4uGE6DHaVB8tyRvpGmm/6NuriYqOcpvxjNLzhrivhhGZID9/LiYcgrago6SHCuewCz38sT5UyaWIKcIFwwvH6DJWxt47pHxMBiQNcYYWeubZEk+yKRcuVtwJ+xtj/oc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZE1qV00zQ3Y0c3hUTXdYWWtnZkk1UkZ3b2FiMzVma1hwTkxGeWo0aS9PdjBB?=
 =?utf-8?B?ZW9JQU5qY3E4UUF5MWpOMStMZ0ZxaFE0UDZmeUZiWHhhblZlMU42RE02K2Ro?=
 =?utf-8?B?UDBxbGNjeFhoS1VUNGlyeDZPd2x5amdaaTBtKzVLNTNCbTVFbVduVVpMdFNT?=
 =?utf-8?B?b1d0VzExaGoxY2VVcFlpeHllL0NQYUtNNzgxZ091ZEh2MTU2UW10WWFkZzRy?=
 =?utf-8?B?Mnc0bmlEdjhBRDU4QUNEMGlJTHlNcDVoTkdGc3Erc1VvOGRjKzNmekJpTlpS?=
 =?utf-8?B?MUpBbENyR1ZvSkpMa3hJOTdmTzAwOHhIdEREcG85SnBLOW9HdjVYYTd3bEU2?=
 =?utf-8?B?Y1hXSlZzQXRyY1F1MHV3aHBiKzRpMVYzL1h0QTNEVzN2VTlQVFJHU2JJVVYw?=
 =?utf-8?B?a3dES2JlY1ZTclVpaTczZmNnYmRGVHA3TlkvQVp4alBEZmVzQjBiQjZpV1hV?=
 =?utf-8?B?dCtyRldVdGdoenVZcmJIWUFQc3BWRWRmQi9xMDN1SmVTSm84ektweVJqdzMw?=
 =?utf-8?B?Y1hmNHE5MkU2RVByWEt2YzZLRit4Z2pEQU1TUkZsUG5aa1ZtSGxIeTVCVldP?=
 =?utf-8?B?ZVRhN3RycGl6d0JobStzbks2V1JEeklnaWJESXdsNUdOVllCK0tnVTNNSk1v?=
 =?utf-8?B?dlJMVklHbVh5MzRaZ01PQ1lMUnVNWGNheEtDK3VsVjdrY1IxUnlJS3JOeVJZ?=
 =?utf-8?B?NkxIYjhJSjJubXN3eFZqcklDMGlTby9WbTV6ZnJxV2pkdXV4YllxNm5uY3lJ?=
 =?utf-8?B?YTI4VTJrTFBsei84azV2UHl1Ny82ck5NRDVGZlBxcnViNU40ZVJQNmk0Mk1E?=
 =?utf-8?B?R1FhVGkrVGJ2R2YvODFUSGYyYjY3M3R5dWhqSjFoSGEyaFA4WXF0WTlaSW14?=
 =?utf-8?B?S0VUR2RndGRBVnhRS09ENEMxZnFwWGVVY3Nsb0tYb3dYcWpmbTMza2VyYXJy?=
 =?utf-8?B?OVdHSjFNMU1BbkxBVXFBOE1JVlRFT2FoN2V0a3BTd3oxeTRyVUc0NTY0TWFB?=
 =?utf-8?B?NzNvZTRhWnFoTUJORGdBM2o2ME1oZURYc0dwOURlK1FiV2R1VitsSFBDdGJm?=
 =?utf-8?B?VmVoYmFvM3FnNzNaRnpPbWc4QnZQeG5COGtURjQ1N3BXZEZ2VlM1dzNzV2k1?=
 =?utf-8?B?UTZGTVJ2MG9rRURVV3JXY2dHV2d2N2hMME10WlRzMnVuTWxVMkFJcktJUlNP?=
 =?utf-8?B?Tjc3eTBKK1llQXhxendqdzl5RENHY0tjcXZpUFhPNHE4TUgyZjhZT3FVbDhM?=
 =?utf-8?B?cVBibVdCbUVJSGpTVmdOdDNIL2crRGZLam4vSGtmZEdXbllBa3lac0N4NkM2?=
 =?utf-8?B?RTdlb2dKcXFsd28wME9ITkZKMnkvYmVVUTBLRmZMd3ZLV2EyWU43R0t3M0NJ?=
 =?utf-8?B?NXNBbmNBa1pwRnMvbk84MUVKTVNZZW1BZFR6Q1hXdSs2bithdmpzUWd5eWh1?=
 =?utf-8?B?OXBTb2Vya1FQcHJDZXNZaHozT3ppZTdHOEYzUDNzWFpVZkJWREdjQ1I4VHYx?=
 =?utf-8?B?OW9PN1o0c25XWlhPZVpZT1ZBMVVBRHdDQ1V1enp3dWh5MnNsYVZvVytESG9S?=
 =?utf-8?B?bWlPZlVJZ2M0cmQ3RHU5aWtmeTRINEhkWjNnVXNUQ0dEcDFvMmlQbHM2TkZ4?=
 =?utf-8?B?akhJZHdmTnNIdm03VjdqaWdyMWJPeVB5UlZtNVBEbUFZR0h3TWJHaEd6L0dE?=
 =?utf-8?B?ZkRSTG1zRnpKWGtkbzdyVGVpMFl3SEdsMnBDZEtycDRxS0h0RkxUL0orM2lF?=
 =?utf-8?B?dnF4TnlxRXNSN3JpNGYzOENtbzNXWXJpM3pFZFAvSFVoeEVmb3lwb28rQmU4?=
 =?utf-8?B?eDFyWFdvMzBEZG5EdWQrcGd1Z0hBODRCSHk2WTZheTlGaFlKWmRQOU9YMnBC?=
 =?utf-8?B?d1VYT0JPUHV5RzdDcFh5dldpK1lQS3p6OG5KL20wZmVNelNwbEZWQitRWVBU?=
 =?utf-8?B?RTJldXJGcTdseUNQc2R0V0p6b0FxS1d2dU5nbkVLeldtc3ZPM2FiRytzSENJ?=
 =?utf-8?B?bFNYZ2hqdnc4czVOclBzK091S2x1Rk9BMk5IaGQyTndqTitrY2w0R2NtRGRu?=
 =?utf-8?B?VGo3MEFLTGxkbStIQ1NMVTNYNkdZT0RMc3hrSmF4RlVXME94RzM2M1o1WUhJ?=
 =?utf-8?B?U0I0OFhRT2c4L1RxTnpoM1VnRUxCcTRRcWRtOTRmY01vVEMxaklGazliQzBk?=
 =?utf-8?B?NUFTMlVrMzBTT2Rnajg3MnlMb2IxeHJUUlBxNllORzdDOUk5ZjdBaVNUYlNP?=
 =?utf-8?B?Yk1QOE5QOVBXVHBacWJjUjd1KzV2aTRNcTVqNVp5M3JNL2UyOERrTUg3bFZB?=
 =?utf-8?B?U09WamlOdW9QQms3V1pBSVBwYllJTjRiRW1naTY4UVNCdFBvOVZHUT09?=
X-Exchange-RoutingPolicyChecked:
	QCqK05HI8OUsupx3iBKjd9Tfuky1e4m+ax7ZVZVNQJKupfUYyZk67t26VsS9VOtEad5YkN2MycRQ2ZavToLR/We2fsEqHrGkAWSbP0gNX+iKpHvgxcDWj+xgd2ea7gvhE+aBoNKbgdRmgLetOw3c6DqDu0dLYogEonEe5TxdkYlhN58Emjk2QvoKJTHR9hhEMYceG9m/zjrO11thyt0T9IfP7CPivx0JJFPu9t3lbTMIdjAEYtb507gLZOw1/2cQ6PvAC2ix+VRCbzMgM3IARK2uk/mDy0kckWsvMykC+fUuuBc/jtcDZ+xRxsLMPFwXu2xinTBk+rktHCUnV5RVAQ==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca876dad-c491-48e2-3599-08dee95ba889
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 08:15:01.3511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9vO1lXSVukNIWLmckizJfiB/MK7ksG48/Ar9vurkxQ49fnPHjdmBzGcTs9mPuMKGWV2ONQo6ed+90LubQOx6Ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4846
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDA3NCBTYWx0ZWRfX4Ij7VKbRJlcG
 2765atujVpJA0IeU4kNSsMMDmhKgH4oHjw9u0x4NNTtX82Y7VXqur1MSLU9iCebp6I/ylvaflYN
 6coXOzfmZ8ZXQ7xHZ+hRvRUU3S+9KIyFdYTrv1atzePtpW81Htc2fr0PUxTejkcunKZMeNaxDxU
 2HsKvnvbytLnsAPVUG7vT5RoAMAEOI5RH3MCiYZmK8NyK8RetHiYyKnGMyvnW0VV/Szb/cOVLTY
 edm97PZprBnMQK1dgInAXKRBWac/42j78Kd17Lg6IH/HocLwhYzCse2W9qN3U7Wnk9pOG55HMC6
 Z4pbLSu8x56u/M1xcQId+OfZC8RjJbYn12xnuZFKcj0LEZQk/I86fKImVUrkxsbppd9CIVq0+YQ
 uYszlpMbpinYthVIMZYapmKKEPcvTZM3JB8UBXxrTpFR0HgN/W6gXbJuWq4cEECtCcqiSivG5RJ
 I0AkAOfWDXX1fVHLWIg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDA3NCBTYWx0ZWRfX7uJGAXvBV0e/
 ydCwnxnYCWTTxpY9Swa3NCI3FOxt2F3BxKtfVFck2fH6TNVWRI3viGh1S7Jc79OanqfDHta2mLV
 sDjzqeMicgI4hMMpTU/TlyBYkM9g28aYlbWsuipSd0IxmyOlFCjn
X-Proofpoint-GUID: o1NeVaT3wmmhsts4foEv_oQuIGp_Dnyw
X-Authority-Analysis: v=2.4 cv=U9yiy+ru c=1 sm=1 tr=0 ts=6a631f0a cx=c_pps
 a=BlIXLFXQXelmgi4pYy3AOQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=iKiJcTA2PjBS6x5JeXcw:22
 a=oqIRtgDX5uB9IJKAlrYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: o1NeVaT3wmmhsts4foEv_oQuIGp_Dnyw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-24_01,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 bulkscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 impostorscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607240074

On 7/24/2026 4:06 PM, Christoph Hellwig wrote:
> On Fri, Jul 24, 2026 at 03:54:10PM +0800, Zhou, Yun wrote:
>> Thanks a lot.
>> I'd like to understand the scope you have in mind. Should the removal of
>> xfs_trans_set/clear_context and current_set/restore_flags_nested be part of
>> my nofs series, or is that something you'd prefer to handle separately?
> 
> I don't care too strongly.  Maybe we should a minimal fix for the bug
> in ASAP, and then we just need to agree who cleans up after that.
> Happy to do that myself if you don't have the time or aren't interested.

Thanks. The patch I sent is already a minimal fix - it just replaces
xfs_trans_set/clear_context with memalloc_nofs_save/restore in the
worker. Could you take another look?

BR,
Yun
