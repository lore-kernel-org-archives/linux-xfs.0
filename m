Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40831DE2A7;
	Tue,  8 Jul 2025 18:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751997635; cv=fail; b=cUPs33ThbWV65l1/8uEtECR5dRu5uFMshNuezcaFsTPTbIxf3Urd2VfVDbftZBOIVSfYABaRk4bqbd7e700K3S5W33ZhmSs7ZUe6PZSnD6RYbSWpTI3RmmAs7FXTVHntCNMvrC0yrCBHk3NGz6brTT0aaEAvvo1wDHeqXrRZsG4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751997635; c=relaxed/simple;
	bh=1Wb7mQVhmSfEn028GsdQGokD80KsIUk242JXTDTjFVc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iQpb+dpHT55i0iF8iqUQ1m0gqu7PDs9naDdKuBUvUkBg6OQ8USZPCnL774SOK8MTwpMOoRlf3193l1+tIuY9SG2Kk0+VHCd1hyvsZNnRWKeg6rWLjDEf3+ESCWw9bx7YgaMx7EemeKQLumRFJCReA/1aKp9WXYqEjtyRmL1EQ04=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HNVHyJ2M; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EGlYQr2Z; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HNVHyJ2M";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EGlYQr2Z"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 568HkH0j019288;
	Tue, 8 Jul 2025 18:00:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=3JPPdAgbyrwZY0jWyzlCrf/M3U44e38bgmBVnO/3EOg=; b=
	HNVHyJ2MnfD+JeugOdVz7F7ygid0j9j0hXUmldj6tHoAqwAOE04T1rtX2txAkgaL
	40aJq/mAIFcJVdronc/d5CBpohNk8x32YkryiNh1eP1xdMo6f2Wv83uelCwlcN+0
	CgWh+npijtxq5Q4ueD1So6YHEbk5+iddzf45prqQyM4CO5F1egXbOhN3zyutN7J1
	ibY43B8Md9o73CMEUgYyJRHZZNVJMWziGV1TbOklVZf0OfA+R2T2YIqL6RTmB7MG
	bOoCmGPnx+8aaabBBdJWAUyxvrf07cCP7zz3YaufHti5wALs8SW5wstHwotX5yIm
	5dQEyrUqQq0yXxTRGz+Ceg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47s80vr0ue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 08 Jul 2025 18:00:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 568GEo1h014012;
	Tue, 8 Jul 2025 18:00:10 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ptg9xw5n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 08 Jul 2025 18:00:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JFunvtRVUI+lGRgae9/QDCDvuzLNCaUVOa80F3/ivTytOxIeBVjEGk9U6120tqQPw5cMoUYqqugXHt+t8cxyzeEFQxDgBUPF00NVPMaozMB9JWNLJ1qzwQVMQ4kUsexZZpoJHa+tslt9M+JF0J7JZyQhlhNikIdZ4rRxVM0688fGNVQ+qEima9ctm1Hyvu9MXYD5iPARaVWNh/bDd3e9WULg0s5GdhKCqa2AKPFbFJvCOlhqBV/90qg3KYAluhBZ5NTg7TLocbVWT4h+D718i2oSPQ4JJWd8F1NDi+8iD9ot3DhKqqe+UZBhLZ0YOoKgp/dB2iVf2d0wteNQCTD/Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3JPPdAgbyrwZY0jWyzlCrf/M3U44e38bgmBVnO/3EOg=;
 b=s21bAceSXQ+WV8ZqcZd8mZfKe7i1ZNHYP7/PKXYMASkiQYSZ9h1smLA7dzaV+k5B1JWJYSLWLpKpEPoQ0z/uV4JSrYmhVDzwPScv8yOylK802JB0Lsqcqpj7iBYWnrsSsNgjSPaGT/ySK+IgCy1zklVeb0jEnhyx4TfNvCa3Z4FmpH9xIiIGnoCBoAKxYSXznvZk3l+5jQNqeBluGIfqraGY42tTEsfknzH/QMgfCHg7lHNGqt3guhX5cY7vcfwQFy+oSbEvv831d/CDwbNwXNKx1t7GV0uTIcJWrI2zKQARS95Mp6t8r7vRubNgYv44yXWkMLIoSFB/9JzFekfPWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3JPPdAgbyrwZY0jWyzlCrf/M3U44e38bgmBVnO/3EOg=;
 b=EGlYQr2ZT+IioWbsl96sFDpRT99Ipev1qh8M4GmNCEf/665wiPsy7hfYR+0Nhua0QSKb0VdMomtmhUJ9N9aRc0HNUIk+v0GC8d7W63acn9JtnT0KdcyVp+UMR36OQtcVY96IWmaDdMBNkcWF1u9JXpBITIhi0qhRgpmIxPILbh0=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SJ0PR10MB5597.namprd10.prod.outlook.com (2603:10b6:a03:3d4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.22; Tue, 8 Jul
 2025 18:00:06 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8901.024; Tue, 8 Jul 2025
 18:00:06 +0000
Message-ID: <a59f21eb-e668-458d-ba01-e6b1a21a75ea@oracle.com>
Date: Tue, 8 Jul 2025 19:00:02 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/6] block: use chunk_sectors when evaluating stacked
 atomic write limits
To: Mikulas Patocka <mpatocka@redhat.com>, Nilay Shroff <nilay@linux.ibm.com>
Cc: agk@redhat.com, snitzer@kernel.org, song@kernel.org, yukuai3@huawei.com,
        hch@lst.de, axboe@kernel.dk, cem@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org, ojaswin@linux.ibm.com,
        martin.petersen@oracle.com, akpm@linux-foundation.org,
        linux-xfs@vger.kernel.org, djwong@kernel.org
References: <20250707131135.1572830-1-john.g.garry@oracle.com>
 <20250707131135.1572830-7-john.g.garry@oracle.com>
 <51e56dcf-6a64-42d1-b488-7043f880026e@linux.ibm.com>
 <f5ddc161-5683-f008-4794-32eccf88af65@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <f5ddc161-5683-f008-4794-32eccf88af65@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR03CA0092.eurprd03.prod.outlook.com
 (2603:10a6:208:69::33) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SJ0PR10MB5597:EE_
X-MS-Office365-Filtering-Correlation-Id: db1cb212-0925-46b0-2ae3-08ddbe49450a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M0twWWFFbklCQW4vaGxZbXBUQXJXb0NPbkkxS2R1T2VuRmRVZExNRXByVk1o?=
 =?utf-8?B?b3FZeHBiVktjR2dvVkpYYy8xWXZZeDFGbVhtWmxlcjBIM3ZmbzlWRnZLNWp3?=
 =?utf-8?B?Zm5wQThqRnlGOFB4M2MrdENxNGJIaWtkcE85Q3I0U21uSWZJYUNrS1YxK2or?=
 =?utf-8?B?VjhpK01lQS9DT25iWW1FNjMzeWF2VitlS2Z4UEFOT3JJaCs0L0NPWHJwM1VH?=
 =?utf-8?B?WUxtWUxxeDdINyt3ZUU0c24raXlGSU5kcEdNeS9BNGxBRlE3NStTdnlpTnpx?=
 =?utf-8?B?Uk9wYklrc0pLSVpEY2VTMCtGR2h3RnYrMEdMUDVvZUhtSmJVWGVqUE91dmpY?=
 =?utf-8?B?S283ZDJ5Y29ncXE5cEZrV3Nzd2srV1BXd21mdmcvRmZtSzFLWkVqUGpZSGRR?=
 =?utf-8?B?NDhqbmRybWhRRkFLQjJtYUhwTVdDeWNvLytxWHJBdjBjMnJwMGFaMmhvY0ZZ?=
 =?utf-8?B?NVVnOEluUnVOaXVTZ2lYMUVSY0N4ZHRKeCsxWXlOMFJxbFRvUFBGZGNQUXh3?=
 =?utf-8?B?aCtidlJXbE0wVzc0bWtNMVc5L2xlRHpPU0czMUxlRHFlZ3lkTjI0V2lYSDlW?=
 =?utf-8?B?TC9MTlYvZnhoYVN1Y0ZsM2poUzg4VU50c2lqMVJIY1huNWhLUmt2b0RiSmNr?=
 =?utf-8?B?dGtxRmwrT3RWWFdwOWRaa1FwMkxxOVNCL1hVNnRwaEdoZGhGTG00SGdnRU02?=
 =?utf-8?B?aTJsTUs1M2F5cXl1eDhiSG5aS2VwY1dnb1FYaDN3WEU5Ty9XSFNNTmVSZm5x?=
 =?utf-8?B?djNvQVlZZHhOR2EyUytXWmZDa2phQnEzb1VmbWNvU21qUm1qZEFKc3VrNmRo?=
 =?utf-8?B?cmpLRUE3WW1pVFIwSm9ZS3QyUytubzdJUkZBL0IyYjQ0NXFQK01pUjQ3OGRT?=
 =?utf-8?B?RnBIcDNzTDRvODd1ZzVrOEFtVFZRNkg3OWNvRUNSWVlsbGhEVHRCZjUxeDZH?=
 =?utf-8?B?MVNLblUxcDdaS2NEQ1NIOU1oZU1PV2pRY2ZJVGdVUUVWNlBpSFE0Y2N6Yndr?=
 =?utf-8?B?RGhuU2RFbUxaNVdnc0ZVVmZtVUk3MEo4VC9DT2c2VUpFdXhkL1pvay9uejZT?=
 =?utf-8?B?dHpRcjJJY0V6cE9iM095d3ZZOGZrNWlxYXEvek56RW15R1AyN1FoaUVGbFZm?=
 =?utf-8?B?SWZTK0lQTDE2WkpqdmxZS1pOdmNaS3hmTURmdGo2clYvMUFSdnBXMjJnclJm?=
 =?utf-8?B?WWoySEgrelNnaEpXR3plNDc1Y2JnSUtmVTdEdTljQkU0V3hZSXgwcWhhbkh1?=
 =?utf-8?B?QXNJWnIvKzNLcUZJRXdPL2N2b2JIWFZ4Sm9JcHBJQUpyNU04dW5uNnhSS3Jo?=
 =?utf-8?B?azR1TDhmcWF6ZG9RUGI4OXk3OXk3Wmh6N09oS1lYNDRmbWJjVk03VkMyN244?=
 =?utf-8?B?ck1rR29rUTF1N2VVdDN0VkZCb2dtSGJGNnNDYWhYQnlKRUdGY2NXVE1xeWhk?=
 =?utf-8?B?bmpkTThhYUpmeVhCd3YxVUk4MVBGYXh3YXFvL1J0dUVYUHd0YlE4ck9qbUEv?=
 =?utf-8?B?V2FmQWtHTEtaTHJiRXFnbEFmYmpoWU9wZFhpZWxRWWNlejMwL0tPQndQb0Rv?=
 =?utf-8?B?dURoV04xdXJhQ01sSzNYVjQrcmVBWHVZamRyMXpTeDlmb3hydkRPRUtDQVBV?=
 =?utf-8?B?WExtZHVIODBKZnk1WUNZRlloajZEbytoUFBQNGRTVTA1aFQ2bGtBZDVoYzNF?=
 =?utf-8?B?QzNwN3lNeHZmbUYvMWt3SGVPRGt2TDBjU3BGc3A4alhoZGVma2d3c2pFVkl6?=
 =?utf-8?B?dlVxOFlsd2YzSFVkajhkN2hwNzdiMU1xaHFUb2RGcEVQOGJtMDlZR3RxK3My?=
 =?utf-8?B?ejVQSWRiNDd2eFUrZHNZQVFFRkRacmplTHBPbzFydEhXM29Vd3hMMjJYeCtQ?=
 =?utf-8?B?NHV2VjZqZDRna0Nmc2hFQklOb2dRcXFsYXpZNUg1MEtWbCt4eU9CODhCTm5i?=
 =?utf-8?Q?26Uh1zR7iqk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?enFidytpN3RJb01remYwNlBoQmNucUdTTEY5OW9EQXBNdHkyNW0raUJpNE1O?=
 =?utf-8?B?ZUJ1YUpSOFhWRC94NTFRWk9HVWU0ZE5FbW1PNTh1TnRxRTZYWnlPV1dHck82?=
 =?utf-8?B?b0pkR3NvYUdWZDAwUk9xT2JhaGxCYlpxSklRM0xXRXJCclhNaU9hYy9KanpP?=
 =?utf-8?B?bXlTeWhEWTNyRmRDa2FubVp4elVPSVpsQjRYOFM4di8xUVlsTlB5TzJ2SVVJ?=
 =?utf-8?B?dmNjOFNKc1hDazFoN0NNVWZ2akkra3lUVDd3ZHdoNHpMaURIK1ZSVXhqaXVJ?=
 =?utf-8?B?OWMycDJ6RWtDOU93ZHMrWVY3aTFjV0xiYTFKSnNRRUFHWHpiRkptTmNOWXJC?=
 =?utf-8?B?dlF1dnY0T0NWL29qY2MzWFAxbW1BWTcvTzBXY0dORFN1NTYxRzVaazM5WTQv?=
 =?utf-8?B?b1plSlE2c2RnYlBxQ2MwQjZiQlhSRUYyMWtSVjZ6ei9oMU1TVlBVa0R3aWVp?=
 =?utf-8?B?cUVJc2sva0NUVkxZdyt1c2pxQU5tWHRIZjNMWWZCZWlOOHQrczVHRVNrQmpl?=
 =?utf-8?B?NlJpcXlsTWwybkEvUWxYV09BN1BwMktaNzlOMUI5SkJrdFRmT1Nxd0x0RVhz?=
 =?utf-8?B?a0txQUFSU2NZK2VQK3lGV3RvM1lFRkZ1TFRhcjFFQ2FkcDNnTSt0WXdNQkVx?=
 =?utf-8?B?MlQxLzREdmhuUDRCcnVDOWI2UjBEblpSUmZUbGR0U293T3lVWGZ5eHdZQXFk?=
 =?utf-8?B?ckV5ZnUwVzQ4SnpPRkpldkpISlRNM2ZpaWNCL0NGOWZIRTkycnFFTWR0eHRK?=
 =?utf-8?B?WWQyTmlOU2xUOTMxazVvUnZnTTFvRzZZdkNrQnREbnpIeWV3aWMxYmlqb0p4?=
 =?utf-8?B?RDc4TmtOL3JWdU9YT1NkbUlpSEgzcjNLaVlPUWpEemN2T1Q3UFpkYmlpMVZp?=
 =?utf-8?B?UTRGOFc2T0ZMWHd5dVAzaUdhZ2JjRW16Qm1yZE5FdlpsLzdGenNMZjh4VFJK?=
 =?utf-8?B?Q0NTNnI3M2lOVGtwbW5EU0cwM2h6dm42b1EwbTdES2VGWU9IVGRvTGV3RnZw?=
 =?utf-8?B?ZitWbHM4NVJxVWNmQjRzUHB6eXhoS0thVGk4Q0RJVm16UjV2S3h6ZFJBUnNQ?=
 =?utf-8?B?NTVidndRRnIzbFFkNnRyLzMxYm5WT0NZYkhCR2NZelY2bUpaK3pHYmtXR2x4?=
 =?utf-8?B?UlJkeFlZQVpGaU9EQSt6QUwvRzV3SUdhU0JpeEMyZktVbk5ZM21OUE5PSk53?=
 =?utf-8?B?dW1PSVhCYTlKbjZ2TnJHWEQvTzZwT1Zwb2JUYTNUcDFKY3BlVTNubTEyZ3Er?=
 =?utf-8?B?dHdObDVhVmlKWVlSRTQxSUxaSkpaUEdEdjZvd0V5M0hkUmNLWFI4UUlub0hk?=
 =?utf-8?B?ajFqZFQzN2hiR2RNNGhxQk9yd1NJR25tQXoyeDJYa2tETnlSd1R4Z2hxNnVp?=
 =?utf-8?B?VzZrUXZ1YlJnNjlUeEdGR21FSmtOM2c2MVlGZU1kd3BpMjV1dS9manUraVdu?=
 =?utf-8?B?WDh6UFY1dHpreHcwQ0w1b1F6Ykl5V1JjK3N3cCtOaC83TVUwa0RuK1VuMkN6?=
 =?utf-8?B?TTY0dWtmUDR5QlJwZDQyQlJTdlNZL09DMkxEK285MHJGVUtIbEtGUjhHMlhV?=
 =?utf-8?B?YjRCVHRybElsMWVUZmZ2aFJwOUlkVWZHVHdXMllqYlovUGV1UGJaTk9oYitu?=
 =?utf-8?B?SWE3RzEra29KVXpyZWVGUU9ENERwdEJlNkNibVBJckcxK2I4Z2I0Tm9rYTg2?=
 =?utf-8?B?YndSeFpNdnV3RkJiZDFvK0VZWkw1STlSdFBSTm84aEFKV0xHQXQ1UHJneDdJ?=
 =?utf-8?B?RVFMS1I4YS9NUGpLeTBpaVd2UmljY3VMWG9jQnM4VTg0TE0xcnNVcHQrSkFD?=
 =?utf-8?B?YUVHSEk5TUc3M1RpNDlVU0ttS24rQ0lDcE95eXM5Q3Y2bGRCK0ZvUVNpZjlO?=
 =?utf-8?B?Yk5CaU1DNytYMmQrd3NKdGVIUVhYalhpZUF5SlJGSmx1UXRQSnhxNGZtMEJz?=
 =?utf-8?B?cng5TUgyaUJSa3E0MXJkQmUyVHRLdVpldFJVRlpUN0NWSVVxc0g1eFlNblhV?=
 =?utf-8?B?YUNFUFFUTFAzV3lwaXk3T2lxNFYreWMxVmx2eFZMbm1oMlIvWWVkQVMxMzFX?=
 =?utf-8?B?S0doMGxIb1QwYVc5VjFRSXpTWlBEVU1VeU85VC9KdnBubVlOQk1XV2JqQmtR?=
 =?utf-8?B?ajZmR0RTWWt1Ly9oQ2VXcEUwN0Z6TmJ0WVdYcnMza05WSjQrMDlJSVNVekx3?=
 =?utf-8?B?cWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nJQeSb3eSlYryLHuBo2X/BdWPMba7v+3R4u2hMhVi+/iqp6a7egbg0NFeOuGp6IB7QGlI1VkC8O79nkdIInBosZsJMTM2P5KLsvPwwg5xPqCCIc+sZlYIVt1to5dvSUFPNmnS0joxInMQPSbjwnQJrrVOlsXFApUcjohgR8inTiuoH+XUnhNRHpaxudYKwWNP+4l2vtQINQdKigJppcgvEep43F3CPdptCFrs8Pwu7k/KUhC4OzarVeV4kXE+7HgGgaq6nhjPpBByGbHK4qFDzFiTBU16+dWLW9IIS7n+vkYll4M95PCw4m0cVj2GAIxgODA3pmWpVpgR1l43stn9rSwAT5iKRECjN3PNf2xM24UW5cjHKsCOnsAfdfM+ZrjTWb5hIC3KtiRxQbynQ4XkzrdIarwQ3rPs1dCIIAg4OvECbtAXg0tCJ6qk95sVf6301betGhvY/oxoO9mb2tYKhWCeDm5Rg+DjCPdqDKovS9VRgOAtu//M3kpMsiUzfJ2BIVxkj9VxcoFVcnKCVHbgNddS2Jzo0y8VD5Q6+Bk9CK+MErI9kMxeGZubyOb8al3Py8WGHLwt10JQpDIR0sbXihX5XbfId23MyT1FbzXFUQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db1cb212-0925-46b0-2ae3-08ddbe49450a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2025 18:00:06.0545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZxaXVkob4yr0ENHBM6TgHwnr/BTWWBa96XRJB4yoTNpFUk98oCp2rix5oZ4pFXbRmhMMfgmpy4hu2uxAD0mMhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5597
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-08_05,2025-07-07_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507080150
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA4MDE1MCBTYWx0ZWRfXzXjSxcDxzhbG V5UOeSDFVoIN4wRJYGNAhdac8Bmd7eepOXV+dgYXgmIvE+WDiyi7e9u6sgV9dt+qnggo6YkwlKW 9kmzsmM8Fuvs92c5sYdfnTcSaIm3z3ptov2Fw0CsXk/pqy8Gl/aRrKcxbruhQDHkAXXpef9DAiR
 j72EAQy+y0bt/8uNv7sH6bvyJyC3FZagvPSz0hwUwiMnFcnHUUd5cuSFa3uNEW3zPAPRUPVIvxN q4loH0DW2zTf0O7ErqpuSmD+jRUF1/zs9nB4Ef1q2kdpQpYSaz2dGN8ksr1pLJPVg00xf2J1KUS JG4WyWaUL2TjAPvqyOuHI13C/cR0z4OtCMF8Qi2jbeRSZIBlMMqYdmbAFeOClCy5FNGENRnwmQv
 /reB2piRY64EtxHlGhmHNpl4cBC0e2ULDtF+G+H93qF8YX4LUXHyFjZtcJj5CggDACnGcJxE
X-Authority-Analysis: v=2.4 cv=TKJFS0la c=1 sm=1 tr=0 ts=686d5cac b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=NQpddHvQzxd-IJSSFWMA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12058
X-Proofpoint-GUID: Hicq4IS8r98IM0HUSxFkKPPqDBN01AR7
X-Proofpoint-ORIG-GUID: Hicq4IS8r98IM0HUSxFkKPPqDBN01AR7

On 08/07/2025 17:59, Mikulas Patocka wrote:
>>> +
>>> +	/*
>>> +	 * If chunk sectors is so large that its value in bytes overflows
>>> +	 * UINT_MAX, then just shift it down so it definitely will fit.
>>> +	 * We don't support atomic writes of such a large size anyway.
>>> +	 */
>>> +	if ((unsigned long)chunk_sectors << SECTOR_SHIFT > UINT_MAX)
>>> +		chunk_bytes = chunk_sectors;
>>> +	else
>>> +		chunk_bytes = chunk_sectors << SECTOR_SHIFT;
> Why do we cast it to unsigned long? unsigned long is 32-bit on 32-bit
> machines, so the code will not detect the overflow in that case. We should
> cast it to unsigned long long (or uint64_t).

Right, I said earlier that I would use an unsigned long long, but didn't 
do it that way, which was unintentional.

Anyway, I will change this code as suggested by Nilay.

Thanks,
John

