Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37A113B58C
	for <linux-xfs@vger.kernel.org>; Fri,  7 Nov 2025 12:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762519734; cv=fail; b=bsuQwkwAQEC9zE9Sl9I96yeZlHO1KOcUI4K2wIiNz2JTwy1TGwZ5gFrk+OcA0Xth6Au0Np3W9z4j40j+1cur5hEQ/p8kkYlVjucLcHrj9JBi4ZOoFT1Dzjuls6vY1iV08C0I2O+griXOxR0i6eaKQeHl3zWuj8ChKuriZ9nDXqw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762519734; c=relaxed/simple;
	bh=aXgsnsxW5d7rfTOUz04DHW2LrquX7dlaaLlxvhqnpSE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lc0Y+Dhfi8Nn4nWPAY+hto/oti15onwJwrS+42fePuuUaqcc4vlrfiYm//aLegWKqZ9j25XuMuWQAhMMuFVPCsxIrZ5zxuH6fjNhjgUPcMBaq0iEpjRJ0ZdzGnfoH02MG0M5QULM65uhjn+8lIrDvLuM5AIUoK21Ir+zEGLV/Ws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Tab95lbi; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ckn9Zw3Z; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Tab95lbi";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ckn9Zw3Z"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A78uK0e029480;
	Fri, 7 Nov 2025 12:48:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qtbf4eAqyz43vunIe4XEN6+T+HzShhb5L5ZjOSbGQk8=; b=
	Tab95lbig/B8F2n4O78wh+eHfagoNuCfq2xI82Csl+hBA9vZhxWkS+qYCi7yC+zu
	MNbClVajI5VKqMUAZspw8FRpG853Jp6+IgH7bCjXBmIBSV4mRIX+D+u5/8SJYXpn
	xFcmW3hF9jiRcSxgniLsFQuhKKFnjQHjlX6IUiBSP6/penXr7u5Pmyv+4qBC3/6M
	Xn7eYlOPUJ2ojFuQBYHI62dgfEpebSb/zU67QZqsvU1jSSOGfr/zJEWDSeXjx/l/
	rpavuPBhKwzGAAPcTyIsMZSbpQ+SjynXWRcxq6G7zPC2sMCdWaIkiuCZEZfPsNE2
	Qauf67QYNfpgu8KZZ6Nd5Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a8yhj1u73-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Nov 2025 12:48:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A7B5gih035963;
	Fri, 7 Nov 2025 12:48:44 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012025.outbound.protection.outlook.com [52.101.43.25])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58nqjcyq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Nov 2025 12:48:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mIqNPfKK454XdroBTgoDLbHX9X/jEsSVRCbHd5SrcMQvUhlhXglyWl96MSYGwRfXnw5HE6858NHa1EaRt7tE3IotVe2fQZ9kScifIVnQKiQ5TrOmDglrLd2ID7dlYE6IJPOIS3AbnfJ0udVamRlGSUjAiXwlM5ljkMaJcagD67IGUDOjIozNqc8h1FRxqlK7t8n/2QsXpOkHJht67wL6qjoqHcW6Jvomj0D0pnTXPa8RGLYU8P2TcLaT5YBkCmcDX9GsBTXE49BZENvVFn08t/re1DgCZ5d4ggcUZ4vZYYssAWlQDRSxZbOAgKFOYBYf82+T219AUMMM0KKjC11y3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qtbf4eAqyz43vunIe4XEN6+T+HzShhb5L5ZjOSbGQk8=;
 b=ms0DpcjFfXVQ7atmH4TW3J7wrpmqVffOy//c65L1l+dT+VphkofFUqTlkTqfiOE+QA5w/LzY+UqxVgGjFuUgUaqTnH1BUzubKvaKRohd/OQV34axaQSXGNcv2pvw9u0pI1mhOcqQQXWDKW0TUGigiWm/bH7zPT28CCZi6ERpZiCcOpLGoDVeq5o3VZAggrVO1c4wAeSr1AoEBNcp6cJZSVlSOaGw7gfHodq3NRnS94cXeQFHH8cVBXfyuWk7QIUGVzSykIGtC6cLqCnZLaYHTlW/oNQHO7m9+mCB3h7x95NDMXJ1jJs3jUaVspWCofc61C4pZ3kEbio2/KC1vxCvOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qtbf4eAqyz43vunIe4XEN6+T+HzShhb5L5ZjOSbGQk8=;
 b=Ckn9Zw3ZN5d9RzbLLXH+LTMggsq+RRIjTa8mIFqwvKJ/l1RUmXRFJgjociqmDX/my+xiDlzmKHzG+5BRO8AN/gaEAtkjvLKQBHFcG4ZbyoNxOotEJP9CFpqPMAekVmQLQJvY4LiUbDYoacu+oMxb2yegCUMbq0p/UbrKHUMrvEE=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH7PR10MB6204.namprd10.prod.outlook.com (2603:10b6:510:1f0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Fri, 7 Nov
 2025 12:48:41 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9298.006; Fri, 7 Nov 2025
 12:48:40 +0000
Message-ID: <5e3f6b82-1e8c-4cd1-90a6-e1612f76370b@oracle.com>
Date: Fri, 7 Nov 2025 12:48:38 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] fstests generic/774 hang
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "ojaswin@linux.ibm.com" <ojaswin@linux.ibm.com>
References: <cmk52aqexackyz65phxgme55a3tdrermo3o4skr4lo4pwvvvcp@jmcblnfikbp2>
 <20251105003315.GZ196370@frogsfrogsfrogs>
 <mx6gzhhkvcdnadmmxziu77cuywq4ql5u2hp6fd673vorhx35pz@jmyv74f236ka>
 <c5cff4c3-cf0a-47cc-9ae5-20d7316b3c09@oracle.com>
 <2c4d144b-81fd-4e4c-90a8-fd3c2082246c@oracle.com>
 <6xn2324slfvddlzwydjxigijdfu7gbpzk77iumjiubolirqzd3@fbuqjbbirtc4>
 <coeibafpki7dasbxwom36kwjpfiv4urshmderxovgyuefx22pv@jiyp3ll44kyr>
 <c690eebb-ad51-4fc4-b542-58d0a9265115@oracle.com>
 <cc5yndgo6enxwtnwvcc26wdoxg3wdnnzie6lvn2mttrzkeez24@6sk5qlhlrozp>
 <20251107042840.GK196370@frogsfrogsfrogs>
 <raxwda5jgqm463olshbx5q32iy3kpfayoj7xaj5yl5dlduiv6m@szrvfmnxeant>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <raxwda5jgqm463olshbx5q32iy3kpfayoj7xaj5yl5dlduiv6m@szrvfmnxeant>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0100.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::12) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH7PR10MB6204:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fe1d0b3-4a21-4aad-4e4e-08de1dfbf9da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SURZVWlvQi90L2E4TkRyTnV0ZWxBYTl0Z2x1eHFPbyt3UUMrczdiWWN5Tm5a?=
 =?utf-8?B?NG5Db0J2MHpDYUhnai9nMHFaZFdoV3pYL2h1TVFUSmNCaktZNjZFV2ZTV1Zv?=
 =?utf-8?B?WGh3VUh3UjVUZEV0dnQ5OGh5eHdqR1VlRTRmczdNTS91ZWc2amlDQlkwWU5i?=
 =?utf-8?B?dWs5VVUrc0tRaEIrR2xlN1FHZTRWVXNZNEk0L0tubmVDa2ZkOEhOQ2NzWTR4?=
 =?utf-8?B?TXlRbTYyUGJ0cEJQaEZyM3pvQUdXbHFjMk9nM1hQQkZjWTRyUjNEMFgranl2?=
 =?utf-8?B?K0s5N3JKY2tNSlExZjZsZ2daYnU0emc1T3RDY2M2V1B0MTlBcENCYXNnb29R?=
 =?utf-8?B?aUtjYi9ZNWZ6M2hRU3BJaDZ0b1VYbjU1UUo3N29XRXVWT1pJcWd6ZW5lc0lw?=
 =?utf-8?B?Y3V3S2VYK01OU295S3FobXplUmN0SlJMRnhOYTVRSkpCUExDbXVtQnRGMmFw?=
 =?utf-8?B?ZXBDcHBwcFFMRW5DNUg5UDV2dmdlYVVuei9kMUFwU056M2Jpc3g5dGRPK3ZM?=
 =?utf-8?B?OW92UktHSnlDVnJLRFV5bTNoV1hBT1ZVQVF4TytNZCtiOFl2V21ld1JuTDFa?=
 =?utf-8?B?M1B4MnRWZEdoTVRmeExITHYxNU9tS0p0NUx0T3h6YlU2OWk2UlllRnhVZERZ?=
 =?utf-8?B?elpqSVNPWUN4QlROWWpyMCtJczRwSDArWHg5a3hSeEdIVU1LMDJaQit3cTJz?=
 =?utf-8?B?Z21CekE0YVFhK05nVXBXTlMvbGNrc2h4aitGWFNaSG5ScjBlY0NRRUNBdW5s?=
 =?utf-8?B?UmFza2tlZVIvR25BOGdrdTVHckFSSVI3NmNHc0h1Q05yV2NabUpXUFcwR25i?=
 =?utf-8?B?YXZ2Z1dCcDlrVHJaaHBIQk1ubEVoQmRpN1dwUzMxTlVkV1g5YnJyVlNLKzBy?=
 =?utf-8?B?d0JSYlJkc2RZRHMzb0pHTWlEclVOOXBNTTJJUzdWbTVFSzVMMVdOd2dSc0tC?=
 =?utf-8?B?c0FkZnlNRng1aERtZDlESmluaTEvQjIwaTdUQzUwYy9MZU5KaXNnU3dEQ3ZJ?=
 =?utf-8?B?ejZKVm1NVjZVc1Z6YUtlSHhLaGRLdFg1TjBia1p6RTBkbmFQblAvSzhBUkdi?=
 =?utf-8?B?TWdER0ltV0xoZ05lY3haRHFRa1NKamhwaEkxQzN6ZU5XeXRMeWtmd0JpbjBq?=
 =?utf-8?B?aGdmMkxSOUl0elNlTEtXaU5Ccml4VVlOMmJPb1VQZUtEWlg3bk5HUHRZSGQ1?=
 =?utf-8?B?WUNtdFZJRHpaZnZ5eWJGL0F5YmFCU1J4bTdmeDc1OVVaTFhIUVp4b1hqTDh3?=
 =?utf-8?B?aEg3ZXFhVjlSWGsyVnJOaXpWLy9zYXpRczhRWnM4L2hFMlF0NkhsVzVTVDlB?=
 =?utf-8?B?MmNlR21JUWlPakUrVFVlMU5JM2xBWkJpeVhzL2I5Si9OdEt0YkdJcXZIdkJB?=
 =?utf-8?B?ZDVFY3VsTXFJb25SRUJ5c29yOFlCMDZTVFEvajc5ckhTK3crNTR6bmhKOVNP?=
 =?utf-8?B?TWkwTGJRTksyaXFrcjJZNXdSODJlTFFEd21Od0dwUFB0ejVTZDJGUmJyOVVW?=
 =?utf-8?B?YUxPMHRkWDlveHJhek44bENLaHRRV3lLcHd2ZjRPUXU2YzFGb3h6Z3MvSmJN?=
 =?utf-8?B?TGRab2JKT05JU3dmbGdjd0lGL01ZZVJka1gzOThqNk83VXdMNTdUVmNkZENl?=
 =?utf-8?B?cklzcTYvWlpkZU41N2p6UUdNaERIQUllcVcvSC9hQTRLaW1LMXZ2UXRoUFFy?=
 =?utf-8?B?NHZ1TWZGUm5XTE8rSEFTOEErMUdOMlJLQ2Mwb0RqSnY4TmNndUhqREw1a1FJ?=
 =?utf-8?B?S0dqRXJrcnRHbXhiak1CdXYwaC9NMXBFNDZNS1JvY2poQ25kd0JiU2QycGRr?=
 =?utf-8?B?aDBlZWVOdTdKb1ZuSnJZZ3lubk4zTVFvN3BuWXIzNXcxQUtQL04yZ2wvMXdp?=
 =?utf-8?B?emFqSnV2VHRtdXZQUm1JM1QvekUybm82am1LSk5CNnZxbjQ2Q1RwYm9aUldn?=
 =?utf-8?Q?fd5onjIUUIDbVlh3GLiv4SBwgPL2rSIf?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MWUxL2luRGlsdFlIYWQ5dFg1K01tMzEvNVFWM0ZLYlFtcWV1N1dzUElzZDBi?=
 =?utf-8?B?d1Ezd0xicllid0JwUCtua0o4NTA2RVh5MDdwdnhGMC9WdmRNTzhtZlRUMFM3?=
 =?utf-8?B?RnFYZHN2UzIwNUFMcnFLUUVsL2M5ZDVybGtsVEZVbDZIQzk2SHJXd2tUV0dK?=
 =?utf-8?B?YTlqS2Q5ZnlaZnBvTDFmbXduVmQwbVByc0U1ZEhsb0lqckZrOFlDUWJDRS8w?=
 =?utf-8?B?SnpZQWFsZ0ZwTTlYVW5pSzFPNFhqVkZlOXlvcnZFWHUrWlVCRXlXVHZEYUx2?=
 =?utf-8?B?aVczNHhseEZXSlZUL1Myd2xyU3FjYjdySlBXRzl0MDhIeGp6S2dwanFtRGsy?=
 =?utf-8?B?RzhJWWt1TDdJM2lEY0pSVlNRQTZrVmNBRlcvdVB2QlczMldvYjNVZ2wzM2hH?=
 =?utf-8?B?bWg5UG5KQ2Y2T0lJSzBZYmQvV2N0NWo4RUpZQWFYYVpJTDNGeW9iZ2ZORko3?=
 =?utf-8?B?WlR2Rld0ZnplWnNWck1BWHRRUjc3OUZWSk5RZjBpaXRCRmlMTXlDcnVKZGpC?=
 =?utf-8?B?NUk3TXRzd2RxUkxZNnczaE03aXFRUlRld3ZrZ3R5eGY5bzROYkNhTEgxWXpq?=
 =?utf-8?B?eEtSN1R5NUdZbVBHYlVCTXcwTFY4S1pSbzVueGNTd3VFamw5aGZvUkt2YmdI?=
 =?utf-8?B?NlhyMlFDeXl4bWhMelFvcUVZNWNvWVVINWlrZC9ndFVDOVlvOUdMdkJKOS9p?=
 =?utf-8?B?R1p1L1N4SnNJWFcyTlVkUEM3TDZOSEdKMWFnL01kc01RZktxSFIzMzUrdzdX?=
 =?utf-8?B?Q0NGRW91OUFKRTVmYTlOWTAyK2NYaHFzU2Vyc1NheEpZbmFkQzAyQUVNbFpR?=
 =?utf-8?B?NU96VHBHNHZkVTBSdWY2QlJFM1ZrNW8zNklTdURUMlBsTGJLSS8xd1lFM2lC?=
 =?utf-8?B?S2VMNFl3bXp6TzViSWRBK1RZbkVyS3lmZDlsT2xuallXRFNuTFd6UC9CY0Ey?=
 =?utf-8?B?aVNaQ1RtR3ROMWhWUzV3dW5sS0pNaTZMbWhtNnhUY05DTEhvY3NxbSt1b1du?=
 =?utf-8?B?KzZUeUkxSnp3RUVJM2NOR29OVU1zRVBCZXlMUjMwbW9POXlMK1l4dnB0aEJC?=
 =?utf-8?B?RlRQVStwZ0pTUUZ5RURmNy9MKzN1RWprNmFHTy9PVHBNS3RxR0I4QThvY2l6?=
 =?utf-8?B?eC81akN5bmxSVnFiSml6OXk0Y0U5TEZYMEU5UHlCaHAvZU9mcnFuS1dvZTN1?=
 =?utf-8?B?QmJaWGpjQjNSSkJQVTYvOHg1RysxdEl3YVZrNUcwajdMZnhlVE9yeDlVMWk0?=
 =?utf-8?B?UU9ZZ2l3OWt3SUZDNDhhMzB5Q2luMC9GMjFaVlBPb1E1ZEE1cjJiKzk1cnE0?=
 =?utf-8?B?aGxyUVZUMzRjZ0JxUjBMVDk1SXhuYnI4ZTI4M3dBcUtRQm1QTWtxcFM3Qmdu?=
 =?utf-8?B?TCthUW1KT2ttWFNBdzRXV28xd2hhTWE3MWRhYlk1M21hMSt6OHp3dEN6YjYx?=
 =?utf-8?B?SFFUYlp2L2xkbGtNcmFjNmJnRjlQRmw1ZmNIckdDa1BhWEEvM2R3VVJhOTFY?=
 =?utf-8?B?bEluMVNuMlJ4Zy9odlNCSmtvUVRWQlp3cWVGSXplK0YrVTJZdThKQU5oTU01?=
 =?utf-8?B?dnZieitXbmZWOGZiQ241czhGdU13ZXlqcElNZmtIUndnM2tPSkIvL3JhdS8x?=
 =?utf-8?B?akRuSDZoNW1CRTZDbzZKRUhRWS9NWExtcGs4cDFSb1hJdk5lYm05R1VmZnBh?=
 =?utf-8?B?TUhnU29EaXFld1hRVkpSY1JKS3lMUEc5ZlhPVTR3Zithb0kvTmNJNitOZ1Zq?=
 =?utf-8?B?TUJkVmZTMmFCYmhTOXJFWVZ3dnVXQU42QzQ4a0JHRmUwaUx3cjFBUzZxRHli?=
 =?utf-8?B?TXhEOWZMMGhVbHJvcWpKZVZZMmVyUGM0VGtTUHMvZmcvbkVnRE5MMVdUV0dM?=
 =?utf-8?B?ckNIdWU0RTVITVN1UlBVL24rZ0RaeDVoVVBNKzBkdUp3VlRFWTg5c0lnRjh6?=
 =?utf-8?B?SklrNHpkRitFcnA5OTYvQXlneWVwUCt2WlFzelVXMXo1TG1zREVKRWYydWY3?=
 =?utf-8?B?Wk1CTDRjKzByRkUxM1dqZ2NGUXF3SXkvSlkwVUF6RmxSdjM2VXVVMWhQai9G?=
 =?utf-8?B?M290K2pXRjAzU05HZkNpc0dIenRodTRET043Z1dScEhTQzJJVWcrcGliV29Z?=
 =?utf-8?B?Q2I0a1E2SHo3U3FPV1A2NU9wRzVKMlpHTHRvRzhvb1ArRGMydDBmMzd5TWw3?=
 =?utf-8?B?Rmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bNUaV27+Nt/fFql13+0GsgYBleAOk3+TE31f2dC23KGzviAAZQN99vXG5ZAupvvPYHGJBEcAFLva1Rig8NzE4a+innZVvWGpS5blP9V/EWCQivRkVLElm4TCnMlFf6zPhrXk65aZRfR0bO4MZmeR5/PBG3rt81WtfmYiv/55FCQxmKdGzaI3t9lrU5DfAbrDgdBOjMHqQHBAvZMacv7NVtErja3Le9lJvS2y4yqJ1QWYR1x6qCXLdb1aSyyF0AaWIO6rejeBkzaeb/ZnJNc6uKE2SiFd7BKNS1KDA0Do1aD/eW4+F5KcAITDg3vwilIAoj7kI2D7EjnPyZdfVBGHwL9aDADHL00l38hxsFRbx9YPFY8JHRElCKykRJi3wqUgTSHizqnaw8/kxiuOn8INmSryeoSdSqbTlcxXVklzb5CRdj+YNZ8qE8cytvhfZzeZxKIxBousgZ95mq5kMyoSWBz0XXy4u/+FahF5lnUqENDCuigc9KWYWbc6hD+1WHyfjBeSlIfrtFiF0vJVPfypziikB5GlKQoE3OBSZgYAaed6Ca7gslySXFGl7DIQQEceFOmQq+ohRZa3KPX6MmD0LwwzR+qKsEWO9MDBZnSMWDA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fe1d0b3-4a21-4aad-4e4e-08de1dfbf9da
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 12:48:40.0975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yOz8ousyVanQ+J0EiupCrtUS0EQ2k/s+4qqtxIAj9K103YgVkqBGFIPF6aMx3C7pFKbTJ8ElGJrL1dxMpcHDhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6204
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-07_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 suspectscore=0 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511070104
X-Authority-Analysis: v=2.4 cv=BdrVE7t2 c=1 sm=1 tr=0 ts=690deaad b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=R_GEPjdYq2UwvLfODqYA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12101
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA2MDEzMyBTYWx0ZWRfX4+AHewWz+etx
 wYy8BS6QbaJV4sBFS/oHUx+PBVlE0ERngRXqgdf6c+anG0nv9xwV9osAEc9uHcv2Sd5hB+zpTrF
 qxpQNVVWaXBp811BOIpTnH1yJO42uS++UlTOl59GPzmReinh7CP7dMWSfBed5l4dYxmVmXHDKBq
 9+M5P06yJ7MckO7j0JOZUtWoTpU1AuE3gj11FXv1FxghnCYjxQuRabj28Lcbq84vmF4CgZPVdXS
 c/disgCeuxM70LLGOBVgdXn4jfyPKDtn1B5Yg2RdEEld8G1HOypQVs8j/A/SfweHOMsofY+AVcP
 uG3akUIXrt1g6HkTN1Lq3tnZNHtiarNYqMTa/JIE3Du6N5nb76/u/2U9tbOLhGDyQttPW263lHD
 BfkAa9tM3oAvnYR+JOPILqkkfFnOJZ9VCNAYCw5tKXdK788Da+0=
X-Proofpoint-ORIG-GUID: hdCCSjM3dahjfXHcjCbi3Y0ftZB86XVk
X-Proofpoint-GUID: hdCCSjM3dahjfXHcjCbi3Y0ftZB86XVk

On 07/11/2025 05:53, Shinichiro Kawasaki wrote:
> On Nov 06, 2025 / 20:28, Darrick J. Wong wrote:
>> On Fri, Nov 07, 2025 at 02:27:50AM +0000, Shinichiro Kawasaki wrote:
>>> On Nov 06, 2025 / 08:53, John Garry wrote:
> ...
>>>> Having a hang - even for the conditions set - should not produce a hang. I
>>>> can check on whether we can improve the software-based atomic writes in xfs
>>>> to avoid this.
>>>
>>> Thanks. Will sysrq-t output help? If it helps, I can take it from the hanging
>>> test node and share.
>>
>> Yes, anything you can share would be helpful.
> 
> Okay, I attached dmesg log file (dmesg.gz), which contains the INFO messages and
> the sysrq-t output. It was taken with v6.18-rc4 kernel with the fix patches by
> Darrick. I also attached the kernel config (_config.gz) which I used to build
> the test target kernel.
> 
>> FWIW the test runs in 51
>> seconds here, but I only have 4 CPUs in the VM and fast storage so its
>> filesize is "only" 800MB.
> 
> FYI, my test node has 24 CPUs. The hang is sporadic and I needed to repeat the
> test case a few times to recreate it with the 8GiB TCMU devices. When it does
> not hang, the test case takes about an hour to complete.

Hi Shinichiro,

Can you still stop the test with ctrl^C, right?

@Darrick, I worry that there is too much ip lock contention in 
xfs_atomic_write_cow_iomap_begin(), especially since we may drop and 
re-acquire the lock (in xfs_trans_alloc_inode()). Maybe we should force 
serialization in xfs_file_dio_write_atomic(). After all, this was not 
intended to provide good performance. Or look at other ways to optimise 
this (if we do want good performance).

Thanks,
John
