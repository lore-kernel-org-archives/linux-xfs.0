Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65A9130AFC
	for <linux-xfs@vger.kernel.org>; Fri, 31 May 2024 15:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717170308; cv=fail; b=cAI1jbZ5eQCFYRVGoP0vWsVHEpdr9DBBao0xxnApBn5z0gqCDytKY0PsZbXaeRW8+rE/rMYkQZJYF0N2RhHT9qxNpEeXjD5GwSjULfyY4HsBPRT8lEve+VUCll7j2Mv9ZXpJc+Dyjum/c383BsoTYf1CwX8a9X5QQFgpl/4PxUs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717170308; c=relaxed/simple;
	bh=37bC6t+m5IBgMOexkh/0RqkXgUv0tQrEAWOVPxKXKQE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=O9hTlq5hVrzl3g8y+slmGgQ+RWXDg8M2pcsmvvsz5Ei/8BPdA5R+mT6k/sn9X9MRo7R6+DsbFz1ydcHTUW49ALpC4NPAPIuqmFLUWVA9UT7Rr0MluQRks3iL4a6oqUWnXv6OokpRs2Z56v01SuPlC/8K7eX1vKYQq9pdYLzNL9Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44V9T2ne019218;
	Fri, 31 May 2024 15:45:00 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-id:content-transfer-encoding:content-type:date:fr?=
 =?UTF-8?Q?om:in-reply-to:message-id:mime-version:references:subject:to;_s?=
 =?UTF-8?Q?=3Dcorp-2023-11-20;_bh=3D37bC6t+m5IBgMOexkh/0RqkXgUv0tQrEAWOVPx?=
 =?UTF-8?Q?KXKQE=3D;_b=3DhzWtv9LZ21xNMHDMaciunnZJeJa8fRLrc1rA3hUcihnPnwaxE?=
 =?UTF-8?Q?F8BuC3BLlFlB0+0A2mU_hiQBzWFEjXPhoX3n+zI6xcXEsitFcIXvydYV6ltRhE5?=
 =?UTF-8?Q?0HnaUH8wlJHqY5B45EeUVRJ6Y_8u3GPyK9Fku50Bizp63J6r/Wg1WtSzyUZ3xo7?=
 =?UTF-8?Q?4PhSJB2C54cCi6yIf+RCG3qY5hJeZ9p_/kL7+CWeNI+H0/4JqqvVf9RqL1uJrno?=
 =?UTF-8?Q?ewoY9yVGGWrLPQwKgFZkwMMy30gPcvne77d9G_SHJLBuonOBlhEGDeKHaXG/wFz?=
 =?UTF-8?Q?Lc/cYhYAxH1dThreios4Igi12nNbTSfZhFhOnshKt2T_UA=3D=3D_?=
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yb8fckg27-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 May 2024 15:45:00 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44VFRTRF026580;
	Fri, 31 May 2024 15:44:59 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2040.outbound.protection.outlook.com [104.47.55.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3yc50a1du7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 May 2024 15:44:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m1lW29bSPbFwFGk4rKi9L/+CE0C/H4VdneFmod7INKEuQzgONfXXfaA5jOMB9bcgFSDYR/2yCOH6uyXFDnLi10DXnhWTU7+LeCL8DrlIaZdabJVtQPDiYmNYX2fDR7A6wXdLDzzvbzdmZcLnpjCQowQzmo7UlhWpNMhV3s339AHGN6T50Hx/EayIMfpGNdpXpeWHXEwTv+eDhMV08S2TteypfsO8VbNTz1aqBXkBJ1ERtluUAnK19ST9CVV6xFofr5gc+R+9OBXrqbFzoexZUkMlHOIRoSdquOZRCUKn8mTOUJa87vs/B0r5ZRGWP3/D1B2ZKmetv/XOOOqp8oPQkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=37bC6t+m5IBgMOexkh/0RqkXgUv0tQrEAWOVPxKXKQE=;
 b=mR7yrxPgkUM2cbWmbpY9Bm51NmbUM0axaaNwkcPXGEB9Djk/af0i9K57yKo3A4W5QkfUzyoscr9xiLLmRHKpI5G6DUIRNQIy4rRt56lLnYaLQltFLkWsrGd040MjIdWBUwY+DuRcSeWiAPO1zIPv/vvZM15Cr8/zSG8Yg6h721vo/TVH8xGl9qGe18RHQsxVUH9vG7ZF/BaOH0FuY2lsHONWaVXIazxtVHJFpXXNmNO+7rn2U+oS5pO8bCegBym5xxgQVrWUGR1z8Gk5P8vP/RhRcW93vPhwJytnB4+pWEV80m7w3rQSHJGPH0VPK1Iy6uXTrB57g983zv+mMuyHDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=37bC6t+m5IBgMOexkh/0RqkXgUv0tQrEAWOVPxKXKQE=;
 b=KksNToqwSblplCfvST0aMQn33bCwnIk6gnyBIs4f8dZbS87BThJZeLmnfJosXiKovHNRq0MHyPROaCXCyIhN7bJR2AvYOi6efzLjO34Yh1s8mNNXJvJKTbuRuz2Jc2+VDDVpWR+WOCrlhdTpFbLgi1/GAm7FPtCO8lv+VnJcWzw=
Received: from PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15)
 by SJ0PR10MB5696.namprd10.prod.outlook.com (2603:10b6:a03:3ef::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.19; Fri, 31 May
 2024 15:44:56 +0000
Received: from PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27]) by PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27%4]) with mapi id 15.20.7633.021; Fri, 31 May 2024
 15:44:56 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: Dave Chinner <david@fromorbit.com>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: make sure sb_fdblocks is non-negative
Thread-Topic: [PATCH] xfs: make sure sb_fdblocks is non-negative
Thread-Index: AQHaozr8E9KmCgD/tEKemp9zonfvu7GRO4qAgAQt0YCAHDMbAA==
Date: Fri, 31 May 2024 15:44:56 +0000
Message-ID: <A9F20047-4AD8-419F-9386-26C4ED281E29@oracle.com>
References: <20240511003426.13858-1-wen.gang.wang@oracle.com>
 <Zj7HLZ5Mp5SjhvrH@dread.disaster.area>
 <AEBF87C7-89D5-47B7-A01E-B5C165D56D8C@oracle.com>
In-Reply-To: <AEBF87C7-89D5-47B7-A01E-B5C165D56D8C@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5795:EE_|SJ0PR10MB5696:EE_
x-ms-office365-filtering-correlation-id: 18f5d7b4-d0c2-4f8a-7d2c-08dc81889f50
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|376005|38070700009;
x-microsoft-antispam-message-info: 
 =?utf-8?B?TlZLWGpPVCs0eER3SloxS21tcUtwNzJ0dGlRK1kzcFhzMjZHN3VieVdNQmw1?=
 =?utf-8?B?Vk4wOHJUc1dkUVNYczF3c1hpOWQycnlVbDk2dDl0TDdPZ1NJTFlLSWFaMXZq?=
 =?utf-8?B?QmN3aHZzcHhFMVRHL01Bb2o1WDdsTVAxcDRwSEJSM3JlMnd3dGtlNGplVEp2?=
 =?utf-8?B?WkpSNnFwMS91WVVIaU5IWGZjMHhCZFVaQVVBMldMNG9Ta2h5bWZreXowaGF2?=
 =?utf-8?B?RWdSSE02cjh0bkU1THh4a3g4ZmRrY2JxQ1p0OU5xZXQvRUF6d1BqYWtHeEE0?=
 =?utf-8?B?aFlaRTJ2WitWa3NLSmpFN2F5Nkx3UTBWN1phTmlkM3dsUG14OWVyckEyc3M5?=
 =?utf-8?B?R0ZYdFcyRDc1eGsvajFReGdGdWhPdTgzbVZUMEdrUzBTNjdJWFZsU0wzcDRk?=
 =?utf-8?B?RndVN3czaUl1dEtkUkpQVm5XSjFxOG15RU9ZYmVDYmlDWFVPL3I0SjVsMVFp?=
 =?utf-8?B?TGJNcXdoTHA4OUxTR01nemZYZXR1eDBGK0dGL3BkWENqYWQ2UHVZTkozOTdh?=
 =?utf-8?B?UEtHVVNHekMwTE9GeWEySFRzbHZVUDQxcmhUR3Q1VUZmclVjY3NpS0IwN0tF?=
 =?utf-8?B?ck8ralFTMVFJL001cS91SkhrcGlhcWlHdVZLU1JRZzFDd3ZyaHNzcnJUWkpO?=
 =?utf-8?B?S01YeDFWREV0UVZSWlhmYWZ5djZRZmJSMHpRWnFtV1ArdytzTlJWdE1JVThG?=
 =?utf-8?B?SThCOVBNelNHV1g2MjAxdnRsT00wdlNkVi9MQ0xoR3U4aElkTFpKUlJiNms3?=
 =?utf-8?B?VGc2VE5UK1Z1QnJCdVNyNDFLa1NlOEdYMk51NHVoUG9MZ2lVRUs0bXplZVI2?=
 =?utf-8?B?Q1V0UGNXckxOcVBqTnVNeXB2ZVBYcWxRU202TksyK2FRQ1NhNUZUQXJ2NHg2?=
 =?utf-8?B?cFZSUkw1UlJQMEMyWVhuQXljVjFPZXM1V2kwN1BRekF3eEVoQmNQYzgxT0Z0?=
 =?utf-8?B?eFh1ZjdTdThVTExxVDN6VjJlZlNKcnFDa3ByUWQrSUxBaWR1a0NwdVlub056?=
 =?utf-8?B?REMvR0xNc1JFOXBSeTNWZXpoU21zK1NzZ2JIOWNnWFFKajdqRWRGQXhKQm52?=
 =?utf-8?B?MEt1a0ZSMkU3M3hSOVZnVzRUUXUvV051bkFXeExzRU45NUlVcC9seU12WEVY?=
 =?utf-8?B?c0VsRm5SUGxqbEZFTEVUWGl3WEFPaHVISHI2R2JRb1gxN3AxaWRXSUFrMUVS?=
 =?utf-8?B?Q1JVWk4xOGw0RW5tdXdkaGwrd3VXQW1MclBZMFlmbUllRVgwRG5WMmNiZ28r?=
 =?utf-8?B?c3pQc1Y4R3JCMzd4NDY4eUl4WHN4cXFVZHJLczV2Nncva2FoQ1Vsd2R1R28y?=
 =?utf-8?B?QzF1SFBPR0doTHZHYVZDL1prUU5wdXhVSlJVQUJBbE1iQUgvUnp2MCtNb0xx?=
 =?utf-8?B?RzNXc29oR0w4cUtvUnBGbzVKSXoydmRHWUJicXZGdjIrVDhQa085b2gxVHZN?=
 =?utf-8?B?TDRMWEYwR1JLK21ZNkgwdHJNK1lSeFRFcWR0QUdHeW41ZlovWndKMzZJc2hY?=
 =?utf-8?B?WnFRYy9RRGMrZFlBSDZIZy9mZzdpcWRZaHBrMnUwY3N3N1UxTHpJRkUrdm9S?=
 =?utf-8?B?UytBWVZKWFVCVEVYeEVrYWd6QUJUSlZ5emxFSmlLQnllMFphc2s1SUNsTDBG?=
 =?utf-8?B?RlZlVEZmZUZDNE1XSVNhSy9KcE51Y2N5bm1KaWpNeWRHMnJ4aEtwNEpCaFpV?=
 =?utf-8?B?emhjdUt6aUNvZFhrUXpYRWRKOTJpcWJmQ09Yak1pUVA3RHQ5cUg0V3NkWnIz?=
 =?utf-8?B?a3E3QkY0Z1JTQndFM25MMklsTnhKQXp0QlkwUWdRRVcwZEhrUVc3TkMxL0dM?=
 =?utf-8?B?T01uSjR5T1VrZjhIbW8xdz09?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?SnFMZkZ1OUhQWTdRRnk2V2dBRUZ6R0M1MFQyc0RqQnRKV0x4N013SlBQZ3JQ?=
 =?utf-8?B?TFpOMjVTbGJ3Y08rMkEvR1dEbXljMlNhMmZMNmhXRXc2Y0JIdmFsY3czZHpu?=
 =?utf-8?B?dEYzM3ZpNUlRQW1uc2hRTnFaOVJaN2NFc0ZyTEZiYndLUnNqRlQyWVBQa2Zy?=
 =?utf-8?B?SGx0U3Fwek9uQ0hMOUtnNzVQRkgxeGpBWGhWNzR0Y3lUVHl6RUVFSGtGQXJX?=
 =?utf-8?B?K0tVcXduc29keElRQzF5REZvY25DazRLQnduTFVTSUpWaTBHSU94YzRJRk1K?=
 =?utf-8?B?K0puS0dJdXBwUGVJc2F2QjVWYW5WZURSdVo0Z3ZTWXlVb09QdWVmejFZU2pm?=
 =?utf-8?B?RlZkdHpJNm1NZmkzQnYvUmZ5K1J6c2IwZVgyQ2FzL3IvbUgramdFZGljTWxB?=
 =?utf-8?B?cGJGSW1hMXhZNTEwZXlIdW1CZTVUNCtSeUo1bFZHNStIUklEYjErd3dCYVl0?=
 =?utf-8?B?VUQ3ME5KWU1VbVdYZXFITTBRQUNUbEp1MEdNMUIyd2V0QURSemRuYTA5SEpr?=
 =?utf-8?B?L3B1WGluSGtTN3hZcW5GRi9ILzNxZlAwakdJK0lzS1R3RGtxSmtuU0lGZTRl?=
 =?utf-8?B?Y3huZnA4NXpiY1lqdExnWFMxMytQaS9oandoaWdxQWZnS1ZtOFpwb3pOMXBo?=
 =?utf-8?B?ZTBtRVlITklocmI2RVU0NXdRWFVGSzVHS1FJekdRR1RTejVPdWNyc0NhMEJE?=
 =?utf-8?B?N0ZRajhIb21Pdi9wSUp2TDdlNjdOR3d3cGl3bURZZGRYZlR3U3JqS2QrNUpK?=
 =?utf-8?B?dEJhQ21wT3dDa2JTd001QVpoVHpBRzNreHlKQVE4MTJUNzF4MGJYdVcvTEh0?=
 =?utf-8?B?dURDSWEyR0JTYkRvTjhuSTJNbU42eTNBcS9lUllPVmQrMlp0cEF2OWxvSjh3?=
 =?utf-8?B?M2FJM2JEdWd3Nk5hY3h3SHN4VG5scWdYZUZyWE5FdTU0OWZmQk5JWHcwR0Fu?=
 =?utf-8?B?Z3NJa21XYkt2UXRUdUdVZGZRL0x3S1BWWDJGb1crSndwM0RUVE5hUlNoS0RK?=
 =?utf-8?B?M3VWTmh4d2dFaklJUFo5Y3RsUTZWenRYZ1IyUkdvYzJzNVlTaXN3SGlTTWZp?=
 =?utf-8?B?OFAyblUzcDRzc2JBRFhoYUFCbE9CUjREZ0sxa1RxaXk5WklCQ2Q4NVBDTjhM?=
 =?utf-8?B?RUMrVTY3WnFzbGNVMktvQXR3WHZzY3BHbXNYRFgvUVozOXRIMlN2cmFGRjdY?=
 =?utf-8?B?WXJ3V09qRjF2bHB4enBpSUFqbHBsbGpwclVXV2IxSENvUzZmbkZFazJrWUpI?=
 =?utf-8?B?VXBJTWxQd0hjS2hFMnpBTDRtQWJMc2hUbkZIV0wyVjV1VzBtTTY3RlJ3VHhO?=
 =?utf-8?B?UmQ0c1YvQ2xCZGREb1VXUlNkTXE1OUpoQ0ZXYnJQVnhRL3g2bnZZWHI2STdk?=
 =?utf-8?B?a3A3MGVsMDFpWXhab2hTRVdqYklQODlBd0RpSTFuNzUza1lJOWk1MCszWkxr?=
 =?utf-8?B?WXBqc3dNNUp4NWI3R3dCQnJRRTBFTHp5UHZySGhkNmNjNGZ2eFo2VkdETDgv?=
 =?utf-8?B?dnJVQjhWMWh6dnZoN0dxMGVsN1NpSVhwcUZ6aG1kNkhwMmxYZTZTZGpmVUVE?=
 =?utf-8?B?V01yWi96SHB6bzY4NGFLVmZBUVFNc1Q0Z2ZxdjZINVpUSDdWSWdQZjAwSGxK?=
 =?utf-8?B?ZzNZRDhHb2Z1NVJXaXpnZWFScFpMQi9KTEFHVXZxWHQzand1d3Jpa0RtOWht?=
 =?utf-8?B?dHdvSXB2elZPVU44UjVyQ2w3Z2ZQWkdFeEI3T3ptMnhmaUlUcnpuQTN6b2t1?=
 =?utf-8?B?cFd1Q3UrQTFEL1RGazB1dkVvR3hudXNwZ1RpVmlkWXVXYTBSdDZmVW1Tdzdo?=
 =?utf-8?B?clFQbkJTVUZNNlNPMnhZVjd4Rk9DTWZJc2ZBS0lXUGpJKy9ISDRBbjlYVTBn?=
 =?utf-8?B?T3Z2NnpPTmtxVmNIMnFPOW42bEE3WVRvSzFRTnpSVGl4bVovU3FtYVRDcVpK?=
 =?utf-8?B?N3FNY3dzb2g3T2NUSE96bTRuOExSYnZNTmJ3K3BEVWxLQVYrYTB4ODFEK0Fi?=
 =?utf-8?B?RDI2dzAxNVhueHdMN05pRTNISXg3dWdGcHFzdzJMNzhEcDFBdzY3Ulc0UmJx?=
 =?utf-8?B?dDA2UXBVSkRVeVlaSm1KRGNYMTNsS3hVSWNFRE1sU2thWjZRc2wvSzI5KzdX?=
 =?utf-8?B?TitxL2ZXWHRSWUlrVDBBMHFlWWI5NE03Slpwa2JLemlWOWhTcFZjWnpPbFVU?=
 =?utf-8?B?TVBTRjJUSG9uMGVaSXpUVTIwSytVVDAzd1o4YXhsaWNXSmJjMzVmQ0x4T3o0?=
 =?utf-8?B?cEY0bVBJMUxINmU2N2JXZEFSOURnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <95A4DDDCE779C24786466D078BF9B771@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	FcmhkgZySTIDE3pF1M3BMqsoQygeEn9XAyvWYXSASCoC9W6+6SKZTzXsMM9xM0YDx5ZCpo24RrX912kCM2gXgokwaskEycXVn1TwCsqlYF1ORFDhPArh/VcsfhtccogwNQBuQFidToi4Bi1fBoIwn+NdY7ClFE6SczuRnCeCeWjlAzKPJF1iHtCRVSo/xSK19PuDhdc79tmr0FI0v0HjmkB2I3oWv6SCz67zmHcWXu/Pfzb5fvxwzzhAEwgPvLnuSUprFVcscLu0zRvj7X2Kw2Onks+ifYmC0Uq5DOny7zX2Letd0EJ4XBRDedt1YvrZrtMB/lU1Rde6NIVDleH5uXhpUicEHYuurB01o15QfZDihsyMp9Rk4huWK+7V05YNeONXdvfovwkzoKrllZw/My3w5AfXm39iVlQAHU1yli26I2nmbaNskypJyAyarQbB3rtEQp2V1V4WuXMpRzsjt2hX2ODf7dZ5/x5f0QXkiyafKQRsNk2dGhOELgOoUBlext6qTjqS07j0/6SPvfvjTxAmt4JOS2kBNOpVIQkHJ/vNqpdNAmzx/GoSzbId/Rc0Pq1+AtoErMyKxwwcjMN2j2VF6TTlL5yZYEx7dL1mxVk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18f5d7b4-d0c2-4f8a-7d2c-08dc81889f50
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2024 15:44:56.7596
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DBt9NuYE9w20X0Gp/SuOzuNeimMZGphTjmIS6ecIpi6Szlqd76KwfcdqV6RhkKlZSksuLDExiZJqt6bczHCT2jUGwHdI/A57jGO6a9gr6xw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5696
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-31_11,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405310117
X-Proofpoint-GUID: LnHZS6Wa3_u0XaqSwOy8DNcTpOREaY4x
X-Proofpoint-ORIG-GUID: LnHZS6Wa3_u0XaqSwOy8DNcTpOREaY4x

SGkgRGF2ZSwNCg0KRG8geW91IGhhdmUgZnVydGhlciBjb21tZW50cyBhbmQvb3Igc3VnZ2VzdGlv
bnM/IE9yIGdpdmUgYSBSQiBwbHMgOkQNCg0KVGhhbmtzLA0KV2VuZ2FuZw0KDQo+IE9uIE1heSAx
MywgMjAyNCwgYXQgMTA6MDbigK9BTSwgV2VuZ2FuZyBXYW5nIDx3ZW4uZ2FuZy53YW5nQG9yYWNs
ZS5jb20+IHdyb3RlOg0KPiANCj4gSGkgRGF2ZSwNCj4gUGxlYXNlIHNlZSBpbmxpbmVzLA0KPiAN
Cj4+IE9uIE1heSAxMCwgMjAyNCwgYXQgNjoxN+KAr1BNLCBEYXZlIENoaW5uZXIgPGRhdmlkQGZy
b21vcmJpdC5jb20+IHdyb3RlOg0KPj4gDQo+PiBPbiBGcmksIE1heSAxMCwgMjAyNCBhdCAwNToz
NDoyNlBNIC0wNzAwLCBXZW5nYW5nIFdhbmcgd3JvdGU6DQo+Pj4gd2hlbiB3cml0dGluZyBzdXBl
ciBibG9jayB0byBkaXNrIChpbiB4ZnNfbG9nX3NiKSwgc2JfZmRibG9ja3MgaXMgZmV0Y2hlZCBm
cm9tDQo+Pj4gbV9mZGJsb2NrcyB3aXRob3V0IGFueSBsb2NrLiBBcyBtX2ZkYmxvY2tzIGNhbiBl
eHBlcmllbmNlIGEgcG9zaXRpdmUgLT4gbmVnYXRpdg0KPj4+IC0+IHBvc2l0aXZlIGNoYW5naW5n
IHdoZW4gdGhlIEZTIHJlYWNoZXMgZnVsbG5lc3MgKHNlZSB4ZnNfbW9kX2ZkYmxvY2tzKQ0KPj4+
IFNvIHRoZXJlIGlzIGEgY2hhbmNlIHRoYXQgc2JfZmRibG9ja3MgaXMgbmVnYXRpdmUsIGFuZCBi
ZWNhdXNlIHNiX2ZkYmxvY2tzIGlzDQo+Pj4gdHlwZSBvZiB1bnNpZ25lZCBsb25nIGxvbmcsIGl0
IHJlYWRzIHN1cGVyIGJpZy4gQW5kIHNiX2ZkYmxvY2tzIGJlaW5nIGJpZ2dlcg0KPj4+IHRoYW4g
c2JfZGJsb2NrcyBpcyBhIHByb2JsZW0gZHVyaW5nIGxvZyByZWNvdmVyeSwgeGZzX3ZhbGlkYXRl
X3NiX3dyaXRlKCkNCj4+PiBjb21wbGFpbnMuDQo+Pj4gDQo+Pj4gRml4Og0KPj4+IEFzIHNiX2Zk
YmxvY2tzIHdpbGwgYmUgcmUtY2FsY3VsYXRlZCBkdXJpbmcgbW91bnQgd2hlbiBsYXp5c2Jjb3Vu
dCBpcyBlbmFibGVkLA0KPj4+IFdlIGp1c3QgbmVlZCB0byBtYWtlIHhmc192YWxpZGF0ZV9zYl93
cml0ZSgpIGhhcHB5IC0tIG1ha2Ugc3VyZSBzYl9mZGJsb2NrcyBpcw0KPj4+IG5vdCBnZW5hdGl2
ZS4NCj4+IA0KPj4gT2ssIEkgaGF2ZSBubyBwcm9ibGVtcyB3aXRoIHRoZSBjaGFuZ2UgYmVpbmcg
bWFkZSwgYnV0IEknbSB1bmNsZWFyDQo+PiBvbiB3aHkgd2UgY2FyZSBpZiB0aGVzZSB2YWx1ZXMg
Z2V0IGxvZ2dlZCBhcyBsYXJnZSBwb3NpdGl2ZSBudW1iZXJzPw0KPj4gDQo+PiBUaGUgY29tbWVu
dCBhYm92ZSB0aGlzIGNvZGUgZXhwbGFpbnMgdGhhdCB0aGVzZSBjb3VudHMgYXJlIGtub3duIHRv
DQo+PiBiZSBpbmFjY3VyYXRlIGFuZCBzbyBhcmUgbm90IHRydXN0ZWQuIGkuZS4gdGhleSB3aWxs
IGJlIGNvcnJlY3RlZA0KPj4gcG9zdC1sb2cgcmVjb3ZlcnkgaWYgdGhleSBhcmUgcmVjb3ZlcmVk
IGZyb20gdGhlIGxvZzoNCj4+IA0KPj4gKiBMYXp5IHNiIGNvdW50ZXJzIGRvbid0IHVwZGF0ZSB0
aGUgaW4tY29yZSBzdXBlcmJsb2NrIHNvIGRvIHRoYXQgbm93Lg0KPj4gICAgICAgICogSWYgdGhp
cyBpcyBhdCB1bm1vdW50LCB0aGUgY291bnRlcnMgd2lsbCBiZSBleGFjdGx5IGNvcnJlY3QsIGJ1
dCBhdA0KPj4gICAgICAgICogYW55IG90aGVyIHRpbWUgdGhleSB3aWxsIG9ubHkgYmUgYmFsbHBh
cmsgY29ycmVjdCBiZWNhdXNlIG9mDQo+PiAgICAgICAgKiByZXNlcnZhdGlvbnMgdGhhdCBoYXZl
IGJlZW4gdGFrZW4gb3V0IHBlcmNwdSBjb3VudGVycy4gSWYgd2UgaGF2ZSBhbg0KPj4gICAgICAg
ICogdW5jbGVhbiBzaHV0ZG93biwgdGhpcyB3aWxsIGJlIGNvcnJlY3RlZCBieSBsb2cgcmVjb3Zl
cnkgcmVidWlsZGluZw0KPj4gICAgICAgICogdGhlIGNvdW50ZXJzIGZyb20gdGhlIEFHRiBibG9j
ayBjb3VudHMuDQo+PiANCj4gDQo+IFRoaW5ncyBpcyB0aGF0IHdlIGhhdmUgYSBtZXRhZHVtcCwg
bG9va2luZyBhdCB0aGUgZmRibG9ja3MgZnJvbSBzdXBlciBibG9jayAwLCBpdCBpcyBnb29kLg0K
PiANCj4gJCB4ZnNfZGIgLWMgInNiIDAiIC1jICJwIiBjdXN0LmltZyB8ZWdyZXAgImRibG9ja3N8
aWZyZWV8aWNvdW50Ig0KPiBkYmxvY2tzID0gMjYyMTQ0MDANCj4gaWNvdW50ID0gNTEyDQo+IGlm
cmVlID0gMzM3DQo+IGZkYmxvY2tzID0gMjU5OTcxMDANCj4gDQo+IEFuZCB3aGVuIGxvb2tpbmcg
YXQgdGhlIGxvZywgd2UgaGF2ZSB0aGUgZm9sbG93aW5nOg0KPiANCj4gJCBlZ3JlcCAtYSAiZmRi
bG9ja3N8aWNvdW50fGlmcmVlIiBjdXN0LmxvZyB8dGFpbA0KPiBzYl9mZGJsb2NrcyAzNw0KPiBz
Yl9pY291bnQgMTA1Ng0KPiBzYl9pZnJlZSA4Nw0KPiBzYl9mZGJsb2NrcyAzNw0KPiBzYl9pY291
bnQgMTA1Ng0KPiBzYl9pZnJlZSA4Nw0KPiBzYl9mZGJsb2NrcyAzNw0KPiBzYl9pY291bnQgMTA1
Ng0KPiBzYl9pZnJlZSA4Nw0KPiBzYl9mZGJsb2NrcyAxODQ0Njc0NDA3MzcwOTU1MTYwNA0KPiAN
Cj4gIyBjdXN0LmxvZyBpcyBvdXRwdXQgb2YgbXkgc2NyaXB0IHdoaWNoIHRyaWVzIHRvIHBhcnNl
IHRoZSBsb2cgYnVmZmVyLg0KPiANCj4gMTg0NDY3NDQwNzM3MDk1NTE2MDRVTEwgPT0gMHhmZmZm
ZmZmZmZmZmZmZmY0IG9yIC0xMkxMIA0KPiANCj4gV2l0aCB1cHN0cmVhbSBrZXJuZWwgKDYuNy4w
LXJjMyksIHdoZW4gSSB0cmllZCB0byBtb3VudCAobG9nIHJlY292ZXIpIHRoZSBtZXRhZHVtcCwN
Cj4gSSBnb3QgdGhlIGZvbGxvd2luZyBpbiBkbWVzZzoNCj4gDQo+IFsgICA1Mi45Mjc3OTZdIFhG
UyAobG9vcDApOiBTQiBzdW1tYXJ5IGNvdW50ZXIgc2FuaXR5IGNoZWNrIGZhaWxlZA0KPiBbICAg
NTIuOTI4ODg5XSBYRlMgKGxvb3AwKTogTWV0YWRhdGEgY29ycnVwdGlvbiBkZXRlY3RlZCBhdCB4
ZnNfc2Jfd3JpdGVfdmVyaWZ5KzB4NjAvMHgxMTAgW3hmc10sIHhmc19zYiBibG9jayAweDANCj4g
WyAgIDUyLjkzMDg5MF0gWEZTIChsb29wMCk6IFVubW91bnQgYW5kIHJ1biB4ZnNfcmVwYWlyDQo+
IFsgICA1Mi45MzE3OTddIFhGUyAobG9vcDApOiBGaXJzdCAxMjggYnl0ZXMgb2YgY29ycnVwdGVk
IG1ldGFkYXRhIGJ1ZmZlcjoNCj4gWyAgIDUyLjkzMjk1NF0gMDAwMDAwMDA6IDU4IDQ2IDUzIDQy
IDAwIDAwIDEwIDAwIDAwIDAwIDAwIDAwIDAxIDkwIDAwIDAwICBYRlNCLi4uLi4uLi4uLi4uDQo+
IFsgICA1Mi45MzQzMzNdIDAwMDAwMDEwOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMCAwMCAwMCAwMCAgLi4uLi4uLi4uLi4uLi4uLg0KPiBbICAgNTIuOTM1NzMzXSAwMDAw
MDAyMDogYzkgYzEgZWQgYWUgODQgZWQgNDYgYjkgYTEgZjAgMDkgNTcgNGEgYTkgOTggNDIgIC4u
Li4uLkYuLi4uV0ouLkINCj4gWyAgIDUyLjkzNzEyMF0gMDAwMDAwMzA6IDAwIDAwIDAwIDAwIDAx
IDAwIDAwIDA2IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDgwICAuLi4uLi4uLi4uLi4uLi4uDQo+IFsg
ICA1Mi45Mzg1MTVdIDAwMDAwMDQwOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCA4MSAwMCAwMCAwMCAw
MCAwMCAwMCAwMCA4MiAgLi4uLi4uLi4uLi4uLi4uLg0KPiBbICAgNTIuOTM5OTE5XSAwMDAwMDA1
MDogMDAgMDAgMDAgMDEgMDAgNjQgMDAgMDAgMDAgMDAgMDAgMDQgMDAgMDAgMDAgMDAgIC4uLi4u
ZC4uLi4uLi4uLi4NCj4gWyAgIDUyLjk0MTI5M10gMDAwMDAwNjA6IDAwIDAwIDY0IDAwIGI0IGE1
IDAyIDAwIDAyIDAwIDAwIDA4IDAwIDAwIDAwIDAwICAuLmQuLi4uLi4uLi4uLi4uDQo+IFsgICA1
Mi45NDI2NjFdIDAwMDAwMDcwOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwYyAwOSAwOSAwMyAx
NyAwMCAwMCAxOSAgLi4uLi4uLi4uLi4uLi4uLg0KPiBbICAgNTIuOTQ0MDQ2XSBYRlMgKGxvb3Aw
KTogQ29ycnVwdGlvbiBvZiBpbi1tZW1vcnkgZGF0YSAoMHg4KSBkZXRlY3RlZCBhdCBfeGZzX2J1
Zl9pb2FwcGx5KzB4MzhiLzB4M2EwIFt4ZnNdIChmcy94ZnMveGZzX2J1Zi5jOjE1NTkpLiAgU2h1
dHRpbmcgZG93biBmaWxlc3lzdGVtLg0KPiBbICAgNTIuOTQ2NzEwXSBYRlMgKGxvb3AwKTogUGxl
YXNlIHVubW91bnQgdGhlIGZpbGVzeXN0ZW0gYW5kIHJlY3RpZnkgdGhlIHByb2JsZW0ocykNCj4g
WyAgIDUyLjk0ODA5OV0gWEZTIChsb29wMCk6IGxvZyBtb3VudC9yZWNvdmVyeSBmYWlsZWQ6IGVy
cm9yIC0xMTcNCj4gWyAgIDUyLjk0OTgxMF0gWEZTIChsb29wMCk6IGxvZyBtb3VudCBmYWlsZWQN
Cj4gDQo+IExvb2tpbmcgYXQgY29ycmVzcG9uZGluZyBjb2RlOg0KPiAyMzEgeGZzX3ZhbGlkYXRl
X3NiX3dyaXRlKA0KPiAyMzIgICAgICAgICBzdHJ1Y3QgeGZzX21vdW50ICAgICAgICAqbXAsDQo+
IDIzMyAgICAgICAgIHN0cnVjdCB4ZnNfYnVmICAgICAgICAgICpicCwNCj4gMjM0ICAgICAgICAg
c3RydWN0IHhmc19zYiAgICAgICAgICAgKnNicCkNCj4gMjM1IHsNCj4gMjM2ICAgICAgICAgLyoN
Cj4gMjM3ICAgICAgICAgICogQ2Fycnkgb3V0IGFkZGl0aW9uYWwgc2Igc3VtbWFyeSBjb3VudGVy
IHNhbml0eSBjaGVja3Mgd2hlbiB3ZSB3cml0ZQ0KPiAyMzggICAgICAgICAgKiB0aGUgc3VwZXJi
bG9jay4gIFdlIHNraXAgdGhpcyBpbiB0aGUgcmVhZCB2YWxpZGF0b3IgYmVjYXVzZSB0aGVyZQ0K
PiAyMzkgICAgICAgICAgKiBjb3VsZCBiZSBuZXdlciBzdXBlcmJsb2NrcyBpbiB0aGUgbG9nIGFu
ZCBpZiB0aGUgdmFsdWVzIGFyZSBnYXJiYWdlDQo+IDI0MCAgICAgICAgICAqIGV2ZW4gYWZ0ZXIg
cmVwbGF5IHdlJ2xsIHJlY2FsY3VsYXRlIHRoZW0gYXQgdGhlIGVuZCBvZiBsb2cgbW91bnQuDQo+
IDI0MSAgICAgICAgICAqDQo+IDI0MiAgICAgICAgICAqIG1rZnMgaGFzIHRyYWRpdGlvbmFsbHkg
d3JpdHRlbiB6ZXJvZWQgY291bnRlcnMgdG8gaW5wcm9ncmVzcyBhbmQNCj4gMjQzICAgICAgICAg
ICogc2Vjb25kYXJ5IHN1cGVyYmxvY2tzLCBzbyBhbGxvdyB0aGlzIHVzYWdlIHRvIGNvbnRpbnVl
IGJlY2F1c2UNCj4gMjQ0ICAgICAgICAgICogd2UgbmV2ZXIgcmVhZCBjb3VudGVycyBmcm9tIHN1
Y2ggc3VwZXJibG9ja3MuDQo+IDI0NSAgICAgICAgICAqLw0KPiAyNDYgICAgICAgICBpZiAoeGZz
X2J1Zl9kYWRkcihicCkgPT0gWEZTX1NCX0RBRERSICYmICFzYnAtPnNiX2lucHJvZ3Jlc3MgJiYN
Cj4gMjQ3ICAgICAgICAgICAgIChzYnAtPnNiX2ZkYmxvY2tzID4gc2JwLT5zYl9kYmxvY2tzIHx8
DQo+IDI0OCAgICAgICAgICAgICAgIXhmc192ZXJpZnlfaWNvdW50KG1wLCBzYnAtPnNiX2ljb3Vu
dCkgfHwNCj4gMjQ5ICAgICAgICAgICAgICBzYnAtPnNiX2lmcmVlID4gc2JwLT5zYl9pY291bnQp
KSB7DQo+IDI1MCAgICAgICAgICAgICAgICAgeGZzX3dhcm4obXAsICJTQiBzdW1tYXJ5IGNvdW50
ZXIgc2FuaXR5IGNoZWNrIGZhaWxlZCIpOw0KPiAyNTEgICAgICAgICAgICAgICAgIHJldHVybiAt
RUZTQ09SUlVQVEVEOw0KPiAyNTIgICAgICAgICB9DQo+IA0KPiBGcm9tIGRtZXNnIGFuZCBjb2Rl
LCB3ZSBrbm93IHRoZSBjaGVjayBmYWlsdXJlIHdhcyBkdWUgdG8gYmFkIHNiX2lmcmVlIHZzIHNi
X2ljb3VudCBvciBiYWQgc2JfZmRibG9ja3MgdnMgc2JfZGJsb2Nrcy4NCj4gDQo+IExvb2tpbmcg
YXQgdGhlIHN1cGVyIGJsb2NrIGR1bXAgYW5kIGxvZyBkdW1wLA0KPiBXZSBrbm93IGlmcmVlIGFu
ZCBpY291bnQgYXJlIGdvb2QsIHdoYXTigJlzIGJhZCBpcyBzYl9mZGJsb2Nrcy4gQW5kIHRoYXQg
c2JfZmRibG9ja3MgaXMgZnJvbSBsb2cuDQo+ICMgSSB2ZXJpZmllZCB0aGF0IHNiX2ZkYmxvY2tz
IGlzIDB4ZmZmZmZmZmZmZmZmZmZmNCB3aXRoIGEgVUVLIGRlYnVnIGtlcm5lbCAodGhvdWdoIG5v
dCA2LjcuMC1yYzMpDQo+IA0KPiBTbyB0aGUgc2JfZmRibG9ja3MgaXMgdXBkYXRlZCBmcm9tIGxv
ZyB0byBpbmNvcmUgYXQgeGZzX2xvZ19zYigpIC0+IHhmc192YWxpZGF0ZV9zYl93cml0ZSgpIHBh
dGggdGhvdWdoDQo+IFNob3VsZCBiZSBtYXkgcmUtY2FsY3VsYXRlZCBmcm9tIEFHcy4NCj4gDQo+
IFRoZSBmaXggYWltcyB0byBtYWtlIHhmc192YWxpZGF0ZV9zYl93cml0ZSgpIGhhcHB5Lg0KPiAN
Cj4gVGhhbmtzLA0KPiBXZW5nYW5nDQo+IA0KPj4gSU9XcyBqb3VybmFsIHJlY292ZXJ5IGRvZXNu
J3QgYWN0dWFsbHkgY2FyZSB3aGF0IHRoZXNlIHZhbHVlcyBhcmUsDQo+PiBzbyB3aGF0IGFjdHVh
bGx5IGdvZXMgd3JvbmcgaWYgdGhpcyBzdW0gcmV0dXJucyBhIG5lZ2F0aXZlIHZhbHVlPw0KPj4g
DQo+PiBDaGVlcnMsDQo+PiANCj4+IERhdmUuDQo+PiAtLSANCj4+IERhdmUgQ2hpbm5lcg0KPj4g
ZGF2aWRAZnJvbW9yYml0LmNvbQ0KDQoNCg==
