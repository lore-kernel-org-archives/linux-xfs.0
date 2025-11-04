Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A65D2D660D;
	Tue,  4 Nov 2025 12:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762258091; cv=fail; b=YzXYylh2NJ8Wsp0ZJHhTAJNsu22vci9MrzUULFR1X+rLub5bTJK7yT3HQZ4LjFMZAdduPv0sy4hD18whHWzV3wC0dwtiw9oHpfFEOvclBu8lgEeg34nk5zETrGhDAj+WrFSo/dPoT4UWtDZeNVK8RNew08IzCIKRfBpDGYVNhDo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762258091; c=relaxed/simple;
	bh=sFxfGgeDmGcjQ8MB+QIP+qSCnVh+Ha8MRK2A/q8MNXI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hv+oaWGjGDXLe2CGERtDe2REBAc+ZoPyasOm46UuaTd+SImZst3mphxkf8mXqTopZNmITeM8h1gX8KEPnFBVfUV0CrOkUJQOn5YjaTlgjDgD44TRoc9Qej9MjzT1Nztbbt4VB4Pid9d6TmUFncPXoLXxHDkKrWPyEkSL2ncfcY8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nP7EGiSq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=o2tBCpuN; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nP7EGiSq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="o2tBCpuN"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A4BuZe2011350;
	Tue, 4 Nov 2025 12:08:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=lq/8GpoC//BTu9QIz4B1sYG8I7C/NsZ+YXC/yhTjOug=; b=
	nP7EGiSqQXezOBwTUwgPa1vkE+Mbu34pPThclxfNMtdcWQkGU3eV6A7SQBNE525e
	kryLnQHvrFYtJH4gs8WeJ6gV+L5EUY1/GY7xynvVXHm0DWLmNy6aqLMXQM+FytC3
	Futf+1pSGmbiswCXpJjquE/nsHMi7F1aoSiyP8Pb51AQ0QDBFiIc+3Srab9n+NcV
	Nf5AO+h98X5u6RDrCaG2YyD6q2seisuoao9i4SkWSL5v+P+4R8t7HgPZOiYmivY6
	cxkEIf8U8x4/wmoYw46f+KmEfcTfIS8B3bJ34hYBWaboevPar106PEgng6gonN3F
	0BZ89CO2bwl6NNwc4zZlHQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a7geh839v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Nov 2025 12:08:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A4BrhKG015654;
	Tue, 4 Nov 2025 12:07:59 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012019.outbound.protection.outlook.com [52.101.43.19])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58n98eus-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Nov 2025 12:07:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cobhoij1sLVAR8pvkOUAveF/ghNnfSxfE6g1jwoGjxAS6CV0gHGgD3M22LM3+teW6hiWRTm+d8Q0uEBULqMqthDx+SNhSxe7UMqVo1H+dLbiHPeujFG2A3mfYTE/u64G2+LEPOqsMvaXBzYoY4cwlIVOmRlC3YmF2lDNxHsD3hWKzlOrusuUPqiRptIY1QnS+CcLaVJuluF/+44LkEnqZOJvEn2TBgrgw5dUl9u1/ZmDfxNHOeTYrabaGUP2wc+805ogOzuBZ7bGZXP8VTn2UDmfNieiiH0qT94a3eSysJCuxfnRWCNPmNHGcOVteMfdraIUEgcEWlk5Bb01hgx/6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lq/8GpoC//BTu9QIz4B1sYG8I7C/NsZ+YXC/yhTjOug=;
 b=vik1Bi7C/QCgn7lboqKw0BysntMf1F6QC/OyNs1oFT2VN/pPhGf1Tps87Bcdac8cxU2Dfsy+Q362Xba4rOAPvyFGdzsidsIcY0CneZxGOnJq62CgUTKpL4stdTaABZuUTHRuIos55F6SMql0RAZKCc+AfkEyto6XkK/apvl0ArBz4PQEBZAITbwsg3CJPMBbU1UN35iw5QOMeQI+hfPHhjDvG+oy7QVlZ26PCfFpZgEEqHJt61t+OXZ615N2XpA+kM/Lmn2r6/6GF7BSl6Yg7S7B6nKEiP+e0XPnlL2kS1Lhj473oOpCXl27DjhFLFFWEFohzREqGF8mQcvatUMpeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lq/8GpoC//BTu9QIz4B1sYG8I7C/NsZ+YXC/yhTjOug=;
 b=o2tBCpuN2q+pqE4byLtl5MTUw1WkZuFWygDji34HoXJJj08hWG+VcDybRyqkqm91pADdBdKM4g/ioOGOPWP3POLVUHqCYy9HIg2QH7sTOhFJUgyNLSuGVVLFYq1g8hpEOiPWHERSjQ9jkMKkO67bX/md8T3xi6Mpyy9A66yOWng=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by BN0PR10MB4904.namprd10.prod.outlook.com (2603:10b6:408:125::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Tue, 4 Nov
 2025 12:07:56 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9275.015; Tue, 4 Nov 2025
 12:07:56 +0000
Message-ID: <02174386-c930-419e-9ad2-2ae265235d6d@oracle.com>
Date: Tue, 4 Nov 2025 12:07:53 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] xfs: fix various problems in
 xfs_atomic_write_cow_iomap_begin
To: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>, Zorro Lang <zlang@redhat.com>,
        fstests@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
        linux-xfs@vger.kernel.org
References: <20251103174024.GB196370@frogsfrogsfrogs>
 <20251103174400.GC196370@frogsfrogsfrogs>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20251103174400.GC196370@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0346.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::9) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|BN0PR10MB4904:EE_
X-MS-Office365-Filtering-Correlation-Id: 0812d423-b456-4e5b-91c5-08de1b9aca09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WXc3aU13TFVqbkxhMTVhdDlRaERqd2luREV4RUF2b2VSYUlsWkpOV3cyUVFP?=
 =?utf-8?B?Q0hhZmNNTjRjcFp5NDZpVVBnOUhDc29kczhsbmsrMU9TeG1nUTBvaFFoQ3R6?=
 =?utf-8?B?WkZDSnB6R052by9XVkQ2OUpUelo3TkIrV2tkeWZ2aDNrRmpCTkd2RGFteVJz?=
 =?utf-8?B?UmxMOXBhVWl2Ui9pSGtvajZtU3lpV1QyeXlyYmx1clIwaTZIYkZkOWxEdHZl?=
 =?utf-8?B?NU9lVXN5emxmano4ZzZSNFZ5Y3JvSGhDblAwTDVvTFcrYUx3VG05eGppSUwy?=
 =?utf-8?B?RVM5M3NqZTJWM0tzaktDUWF0KzZhSHVmMGFqR1R3Wm9vUWdqbzdhZlVyeGEw?=
 =?utf-8?B?QTFpMG5lMDhyMzNNZFFMOElXdms1S1Z6ZjByOVJsK1FiK0VQNWFKUGFxTzMy?=
 =?utf-8?B?ZVk3aG4yZDl2bFdMNmpmZXF0cGxINWIvK1ZJU1QxNlh3aDZSNDRZVm9MR3dL?=
 =?utf-8?B?V1d3U1BLZENFT3p4U1NZVEVDSWRrWjdxSUE5QmRzMm1zZ1FJV25WaGdaRG9a?=
 =?utf-8?B?Zm9vMjhxNlVheS9NSTdoYkZiaGFOdDZENlN0ZHFibmRhOGZUVHNMZTh3MXRY?=
 =?utf-8?B?dTFsUVlJSkF0V1BTYjRmRzhNWmFzS2owbitPaHExaTdxaXZyUFRGRG1ncFY0?=
 =?utf-8?B?SVVxSFdSVDM4QVg0L1ErUlhLa2R0R2tJMEtva1Z2QkR0dWRCbHFVaWZZOGRm?=
 =?utf-8?B?cjMwcVd2eU5OUk1od1lLTnI4cWFCY0d2VFBiMkVvdGxWaElnWWNLdEZDdmRN?=
 =?utf-8?B?NllneGRPOEM2NHpiaEd3a01pcXBNNTVTbW5FWTJ0bGRzczdXSU8yaHl4cmJn?=
 =?utf-8?B?UWJqdGVQL2cxNCtOeUtqQXJSeWJlZm5VWHhQQjcvWmpDNzRXTkdlL0pTdTY1?=
 =?utf-8?B?aitDbWpqeUZBUWluWlhWdXQwQ0daV24vSmlyMmZZWXdCWXA4V0p1Y0dBY1V3?=
 =?utf-8?B?TkRwdXVzblZ6NWozNnB0NytZOXg1QXBMK0dCN1AxTFBCMXBVOTJ0SXlDTlp0?=
 =?utf-8?B?NTRKTFNlWHNFYUZjVkQ5aXB0T2ZSTXJQZnR1THhBOWpPd1hVbGN2SldUYVNE?=
 =?utf-8?B?Rkt2ZjMyM2EyN3I5Q3VUcS94a1ozeWhEWWEzUkEyb1BrRGxIN29qSXBrTmFK?=
 =?utf-8?B?eWJ0UzlXbDFLWDlPZlkzTENJZ0Y0eUZyUXh2RHZ5MzNrdVFhMUxOclJwNlVr?=
 =?utf-8?B?QXhOdG9nalltUEZaRDhQSU8zWjczZGJEZ0NRUVJXV0IyNUNFWjlMWGVObDRC?=
 =?utf-8?B?M2Q3SVpMWnpnbmpPNGdpT0Z0akczQVkxMTJTTGN0b3FIQjYxekUrMk9GZVcw?=
 =?utf-8?B?TXoyK0FWN2F3eFMzK2FVbUlCdTdrdlkwL05YNE84UTdxOGcrWnFTVEloVlFU?=
 =?utf-8?B?V1FKZlQzcnRGSTNMUUJsc3R2U1VQZVJVclcwM3g3MTB4NlBmRWhzS3lINUQ4?=
 =?utf-8?B?T01LeVBqcmhzQnFhS2YzcGp2dHEwbTFlbkZzUEZHaGRVWC9OdzhLaGp6aER6?=
 =?utf-8?B?dHBlMkpUQVRpSThzSDdwU1c5Wjg2L0pPMXEvK2VyNFNHaEdVS2xyYmkyUU0x?=
 =?utf-8?B?aGhObGU5c2E2ZXk2WEx1VU1WQndnRHBrdDhvNmRZdWlGK3dOMkJ3cThONTNs?=
 =?utf-8?B?L0pmU3E5clFzeTUyZUwyRWRQRzFIQjFNSUJRandVODUrUFQ3eXJ1UWdBM01k?=
 =?utf-8?B?b1ZGM1oraXV6Nzd5R2Y1WXVGVU9RdmNIRWdRNk1MdUJtWkxUaFdRSlRybmYv?=
 =?utf-8?B?WDhjOGJCLytMZFVTWkdTNnFiLzZhOFpLVUhOazJzNGY2YjJQTGt6cHNueDQ0?=
 =?utf-8?B?UUJlMFRZQlRSSjQ0bXVOSnliM0ZpVXpQVnEwRWlibjdYRG1uTm5ieU02U1Vi?=
 =?utf-8?B?WTF6cXZma3V5aGI5bGcrWkFSMkZQMWtRcWszWDNaSkFRdUJPQjVvdEljSmh1?=
 =?utf-8?Q?0kvvkJj+tBXRaZgNoq64kjHKvOWcDyYe?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ym9taklGeUZDekRqTUxTcWp0ZEJjc3lTZUtaV2pNMUNXeDExcllGOE56dFRi?=
 =?utf-8?B?dVF3ZklRT1NRTnNDaGs4d0xWNEdCNmt6Q2JGNUZGNzE1NGN1M2w4d2FWdW5B?=
 =?utf-8?B?K0ttOUFIWVRJRnpKWVZBUm4xWlV5dFY3aGZwMDJQNFMvTHIrL2JPbUxIeG9W?=
 =?utf-8?B?UTJsa3dxK2s1M2RmOWRwZTJKZDNpT3IyaGFWM3N4SWg3WFhwYTd6ZHhjOTFB?=
 =?utf-8?B?eEdZcmJHTS9pWjdvL0pnbVdENWJLMnhORjJUTEc3YVFIRzEvYnhveTRVa29s?=
 =?utf-8?B?SE04a0N4dFVyejYxR0RmZmdjNGliZTU1Mm9YNGVaQ1ExUy92V05qTDc5ZVVm?=
 =?utf-8?B?SVZCZWQrdVNUdkhhNDczK0F2REtTcm5XVERyb1ppNnp6Y3lUQkMwV1ducEEv?=
 =?utf-8?B?YTRvV29iWVhVQmFxQzV1ZXBUL3RNUEpld0ZkUXhPbEZLaVp5TmRhMkhUMmJQ?=
 =?utf-8?B?VWhaanNCaXJPWjBJVkRYWTY1K2gyUDV2TFpYNk1TNHViK0FsdWZFTEtzSndE?=
 =?utf-8?B?dmREb2dGdVZHK3d3MHgwakM4cmI2c2E1L3R5OWRoTXk1R3VrNkZQdUFGNEJs?=
 =?utf-8?B?Sys3ZitvQUpRc2VkMVBtK001M09ETjhzNzl1ZTA4VE9JWkQ5ekdFVW5USVNn?=
 =?utf-8?B?UWF0d2M0VWpaNi9qMU5MZEduMUJUeGhOYnRlNDJKUkNtcCtyV0JaS1VybmRV?=
 =?utf-8?B?bFB0dHVmTjUwU2NreTY5ZFRlSXdEemJJcSttTytlL0hYbUdUUEh2KzZaTmN0?=
 =?utf-8?B?UlVGOEFNbk1QelYyNityek5rR1JoNDE1ZU5aV3BmVUgvOFIvSnNJeFZkT3lN?=
 =?utf-8?B?UmVUWUdPQnN0TEFJK2UwTUdjR0QwQ0cvOEdxY2tZZkZRWkhyQ3E2VnVIdTVF?=
 =?utf-8?B?LzduYU5QUUUvSlNPY1c5YVpNT0E1YTV5b3ljeDVJYlo1Q2hDdzNJWFlWbHNZ?=
 =?utf-8?B?aHc0ZDc0OTR0amQ0b2FWWVQ2QTJ2Rk1lRDZDdGRRN1drMjFXbElMTUJIUnN1?=
 =?utf-8?B?SEExRmpmSWt0aDlpWGdOV3ZFNkMvdlJlK1RrV0I3TThWZGJ0Z1NjWGl3SSt3?=
 =?utf-8?B?MldJa1R5N2wvTUZyMU1nWEt3aU80S1ZLV1hlR3o3MzlnNURRYmdEbk5xOUN5?=
 =?utf-8?B?cGt3eitMNk1SUFZrNkxoTTQ3QUY0bCtZdEg0QmJnd0xnd3VXcldheFNCRVNQ?=
 =?utf-8?B?clZ3ZzM2czIyOW1rTGorQWQ2TFRVaTNnU3lTOExBYTdPWE50RXFFazQ4REdG?=
 =?utf-8?B?TVpFQkEyUkJSQ0pvemlkcUg1NTNYbmJTejFhVmJlUmNXNUE4cmNkQjdBVTBR?=
 =?utf-8?B?a25hR0Z4T2ZxNDlPaEJSdkJKM05kOGdaN0NXa2UwY21PdSt1OWFZd0lweWR1?=
 =?utf-8?B?a1E3Z3ZyUllqRGk1ZXJqcjBrMHRIaTJENks2NCtHV1lFNDZGZnBFdG9pNGY2?=
 =?utf-8?B?Z2NFU1FGdG91Vmc1Y0pkZUxaWW81RzhkWUNOaTBkUjFpdjhmOXo5OW1YWDZI?=
 =?utf-8?B?Nk1KbkNuMHhCak51aG1qRUtsOFZtNndtU1hGQVVYTlR3TU5ZSzdybzRHalRr?=
 =?utf-8?B?TGhoV2VFNW1JSjVGbTd5OVFXTHNQYTBqckR2bjdrSzk0Wi9xcnZ4dWVweXk5?=
 =?utf-8?B?cUpEVEM2dG9JTW5wdHZxcmhPSFpMcjZhdkNWV3RydEJJUTZJdzRhU2JwbkQv?=
 =?utf-8?B?Qjl4a3ZQaEo1aklKaGVJMzZuRkkwM3NDRkc3ZUNhTDBwYi9ZQjQ5V21uT0sx?=
 =?utf-8?B?amhJQ0dJVG5CVnFzc2E3MEY4SFVaaHlNTEhQTHBXRW40Slo4Y3VoY1hzNE9M?=
 =?utf-8?B?UzRlM0MzSks4OWZnMjF6ZGlwTGNnNzVpNXJva1o1TDFHUVYyOFFISGc5Z09Z?=
 =?utf-8?B?MytGN0thZWQ2WlJoVktUWnZzZ0dLT1hMMnBvdHhBd2pENDRhZTBmSFFvaGFF?=
 =?utf-8?B?RE9jeFF6T2lKNG11QkthRG9IeUdaUTV6QWhJWHA1ME1yRk5vc1RXVkNuY0Ry?=
 =?utf-8?B?c1BnMzg3d0orRmo3cWlFT1BwUjl2blh4dy9UWnBuNjB4RGhERTE2cjVFT21q?=
 =?utf-8?B?aGNDaTRUZVViOVhQUEdVS2Z0ZWlCQnZFeU5aRmgxdHN3SldYcGZtdnFkN2Zx?=
 =?utf-8?Q?9YYituqUbdbTtZbXWA+D+XCF9?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	X4YedC1yYnt5pxxiJ8xObPYOwPaZ+Y7krpJj/FzudBHdeP8oD7YdZ6HSHVHXPdhLt/ZfoWmILyQciDD9UiL5srv69bKSXMVn8O4gJ13OxtZRYpKYGPOiMZ8H0mFGQnGZ0kFML1YSltJbpjvflLjIuDpPnCtUU3+40OWCL/W5WWjceRNPJWOHc7sox2q1fVgFeXec9hEgCoTa4b1/CDCkgubaMaIdZ+gPXTvqsPGjOu9ZxZ6jE7Le61y8iPZwm36Som0BnUvFUlcHxYknls8gYokg1HqfNB625qKE4E93YrMFObWEB7KWsVjk3WnaookZSgsNwKv0ctcr157Ac9sewi0Fyftf4jmCnzPVpK6R+JOazB0l/2iWcknBLYneZVEfiXUroFpgL12dvmp9pFt8QMRgJC3SbQs4czouj8QtkW2TEiJ1GPvPG4fEx79IrZft3zr7Om76Kv3/e+JZgAb3nSKUC2ELVVnN3ceOHJHcBBnxV1ZExLqWIshChH6RV4sOBDCiFzgdWf55taMXNTTuiiEbODV8UoTJabFrKuV8EMuriZiI208kN3rBM9zeSkwZ1dz4aruvm+/GQ0+1nFiqX1AmaF9/eevFIobQQ5Z1ImA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0812d423-b456-4e5b-91c5-08de1b9aca09
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2025 12:07:56.3943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z0J7l3/tz2BeaeC3LnbH57fLtwAoO8KTOdblqRLEfh/SBw2M6EV0zizSod9M1Szpon6DuL6IIhj4OBBjoglnaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4904
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-03_06,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511040099
X-Proofpoint-ORIG-GUID: QCc-pzruMmRBF3BQa0kluKnGFKRp52Wl
X-Proofpoint-GUID: QCc-pzruMmRBF3BQa0kluKnGFKRp52Wl
X-Authority-Analysis: v=2.4 cv=PJwCOPqC c=1 sm=1 tr=0 ts=6909eca0 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=AxC0hQDNNjL9NOvmM5UA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA0MDA5MiBTYWx0ZWRfX2VnS01/8pMns
 3bHZg04OWUy1ExFNj9LiO0Gl7uQ75Binu4m/X5Efq9/ZVoTvVijc0a4r3CAjMNB7S6XQIzr+oyn
 Qs5FIHiJSA/czjAaSVN8EkuNqs9S5DG3oIxP5FBTxm4Gn9tJ2hCMM13B7II4fZ30QYA/RIC7YJb
 0B56n9cD6BGKIrNkbRNarLD9c7qSOTvtivObZTLUvV/Ih36APQdbZzMeFDIKraqIB1gbpcxoYmn
 EPEhrzaLRCcr//2N5U1OX9UNyY0XI8wIbAUx1cYl/qn7gO7Vy3iweCBcQNLh80d82M1nP8roCIz
 RfPMsraACrwLCSaiEyHyLo8r6WCOPVB16l3OQ5lBTQOK1rGEze+wGSgeRPF2EGzBGX2VJ1lDXhb
 V2p7TXcbYgcBWIml1UeDDEsW+zujDw==

On 03/11/2025 17:44, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> I think there are several things wrong with this function:
> 
> A) xfs_bmapi_write can return a much larger unwritten mapping than what
>     the caller asked for.  We convert part of that range to written, but
>     return the entire written mapping to iomap even though that's
>     inaccurate.
> 
> B) The arguments to xfs_reflink_convert_cow_locked are wrong -- an
>     unwritten mapping could be *smaller* than the write range (or even
>     the hole range).  In this case, we convert too much file range to
>     written state because we then return a smaller mapping to iomap.
> 
> C) It doesn't handle delalloc mappings.  This I covered in the patch
>     that I already sent to the list.
> 
> D) Reassigning count_fsb to handle the hole means that if the second
>     cmap lookup attempt succeeds (due to racing with someone else) we
>     trim the mapping more than is strictly necessary.  The changing
>     meaning of count_fsb makes this harder to notice.
> 
> E) The tracepoint is kinda wrong because @length is mutated.  That makes
>     it harder to chase the data flows through this function because you
>     can't just grep on the pos/bytecount strings.
> 
> F) We don't actually check that the br_state = XFS_EXT_NORM assignment
>     is accurate, i.e that the cow fork actually contains a written
>     mapping for the range we're interested in
> 
> G) Somewhat inadequate documentation of why we need to xfs_trim_extent
>     so aggressively in this function.
> 
> H) Not sure why xfs_iomap_end_fsb is used here, the vfs already clamped
>     the write range to s_maxbytes.

Can you point out that code? I wonder if we should be rejecting anything 
which goes over s_maxbytes for RWF_ATOMIC.

> 
> Fix these issues, and then the atomic writes regressions in generic/760,
> generic/617, generic/091, generic/263, and generic/521 all go away for
> me.
> 
> Cc: <stable@vger.kernel.org> # v6.16
> Fixes: bd1d2c21d5d249 ("xfs: add xfs_atomic_write_cow_iomap_begin()")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

this looks ok, thanks

Reviewed-by: John Garry <john.g.garry@oracle.com>

I'm just doing powerfail testing - I'll let you know if any issues found

> ---
>   fs/xfs/xfs_iomap.c |   60 ++++++++++++++++++++++++++++++++++++++++++----------
>   1 file changed, 49 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index e1da06b157cf94..469f34034daddd 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1091,6 +1091,29 @@ const struct iomap_ops xfs_zoned_direct_write_iomap_ops = {
>   };
>   #endif /* CONFIG_XFS_RT */
>   
> +#ifdef DEBUG
> +static void
> +xfs_check_atomic_conversion(

xfs_check_atomic_cow_conversion() might be better, I don't think that it 
is so important

> +	struct xfs_inode		*ip,
> +	xfs_fileoff_t			offset_fsb,
> +	xfs_filblks_t			count_fsb,
> +	const struct xfs_bmbt_irec	*cmap)
> +{
> +	struct xfs_iext_cursor		icur;
> +	struct xfs_bmbt_irec		cmap2 = { };
> +
> +	if (xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &cmap2))
> +		xfs_trim_extent(&cmap2, offset_fsb, count_fsb);
> +
> +	ASSERT(cmap2.br_startoff == cmap->br_startoff);
> +	ASSERT(cmap2.br_blockcount == cmap->br_blockcount);
> +	ASSERT(cmap2.br_startblock == cmap->br_startblock);
> +	ASSERT(cmap2.br_state == cmap->br_state);
> +}
> +#else
> +# define xfs_check_atomic_conversion(...)	((void)0)
> +#endif
> +
>   static int
>   xfs_atomic_write_cow_iomap_begin(
>   	struct inode		*inode,
> @@ -1102,9 +1125,10 @@ xfs_atomic_write_cow_iomap_begin(
>   {
>   	struct xfs_inode	*ip = XFS_I(inode);
>   	struct xfs_mount	*mp = ip->i_mount;
> -	const xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
> -	xfs_fileoff_t		end_fsb = xfs_iomap_end_fsb(mp, offset, length);
> -	xfs_filblks_t		count_fsb = end_fsb - offset_fsb;
> +	const xfs_fileoff_t	offset_fsb = XFS_B_TO_FSBT(mp, offset);
> +	const xfs_fileoff_t	end_fsb = XFS_B_TO_FSB(mp, offset + length);
> +	const xfs_filblks_t	count_fsb = end_fsb - offset_fsb;
> +	xfs_filblks_t		hole_count_fsb;
>   	int			nmaps = 1;
>   	xfs_filblks_t		resaligned;
>   	struct xfs_bmbt_irec	cmap;
> @@ -1143,14 +1167,20 @@ xfs_atomic_write_cow_iomap_begin(
>   	if (cmap.br_startoff <= offset_fsb) {
>   		if (isnullstartblock(cmap.br_startblock))
>   			goto convert;
> +
> +		/*
> +		 * cmap could extend outside the write range due to previous
> +		 * speculative preallocations.  We must trim cmap to the write
> +		 * range because the cow fork treats written mappings to mean
> +		 * "write in progress".
> +		 */
>   		xfs_trim_extent(&cmap, offset_fsb, count_fsb);
>   		goto found;
>   	}
>   
> -	end_fsb = cmap.br_startoff;
> -	count_fsb = end_fsb - offset_fsb;
> +	hole_count_fsb = cmap.br_startoff - offset_fsb;
>   
> -	resaligned = xfs_aligned_fsb_count(offset_fsb, count_fsb,
> +	resaligned = xfs_aligned_fsb_count(offset_fsb, hole_count_fsb,
>   			xfs_get_cowextsz_hint(ip));
>   	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>   
> @@ -1186,7 +1216,7 @@ xfs_atomic_write_cow_iomap_begin(
>   	 * atomic writes to that same range will be aligned (and don't require
>   	 * this COW-based method).
>   	 */
> -	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
> +	error = xfs_bmapi_write(tp, ip, offset_fsb, hole_count_fsb,
>   			XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC |
>   			XFS_BMAPI_EXTSZALIGN, 0, &cmap, &nmaps);
>   	if (error) {
> @@ -1199,17 +1229,25 @@ xfs_atomic_write_cow_iomap_begin(
>   	if (error)
>   		goto out_unlock;
>   
> +	/*
> +	 * cmap could map more blocks than the range we passed into bmapi_write
> +	 * because of EXTSZALIGN or adjacent pre-existing unwritten mappings
> +	 * that were merged.  Trim cmap to the original write range so that we
> +	 * don't convert more than we were asked to do for this write.
> +	 */
> +	xfs_trim_extent(&cmap, offset_fsb, count_fsb);
> +
>   found:
>   	if (cmap.br_state != XFS_EXT_NORM) {
> -		error = xfs_reflink_convert_cow_locked(ip, offset_fsb,
> -				count_fsb);
> +		error = xfs_reflink_convert_cow_locked(ip, cmap.br_startoff,
> +				cmap.br_blockcount);
>   		if (error)
>   			goto out_unlock;
>   		cmap.br_state = XFS_EXT_NORM;
> +		xfs_check_atomic_conversion(ip, offset_fsb, count_fsb, &cmap);
>   	}
>   
> -	length = XFS_FSB_TO_B(mp, cmap.br_startoff + cmap.br_blockcount);
> -	trace_xfs_iomap_found(ip, offset, length - offset, XFS_COW_FORK, &cmap);
> +	trace_xfs_iomap_found(ip, offset, length, XFS_COW_FORK, &cmap);
>   	seq = xfs_iomap_inode_sequence(ip, IOMAP_F_SHARED);
>   	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>   	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, IOMAP_F_SHARED, seq);

