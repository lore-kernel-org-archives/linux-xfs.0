Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21742153EA;
	Thu, 30 Oct 2025 16:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761842421; cv=fail; b=Gqa2hg3xbDG+E2V5dk6gBrXSDeKcBoToTutV8lZNwMgy81WyTuR1qs9HHFSz67Sh8hrv7CkA8vO6M/OjDC1fZWpqwKViJCik3Iq5HKf7yks5EHgLf76rQVfLb7PqkaHsuzJ9QW06FLX1hznZAPw7IVp/LCd5loVpFDK4Z3qi7Wo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761842421; c=relaxed/simple;
	bh=i/0nT2/Bg3Io7MflmAgfd+1L8r6gaI47MbThrU9XrEE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tHe98oqpKrLl56zGG4ssWLx8qP94Zur+H+UK8pPldNSBKnHc7FKfM3VCWyxHicm12vY8V3aymLlJzwOYHp/MoOJn01mMRwZARmocovv9UWaZ6nrGlKAhR7H7xPyTwogE5ffMGZp3Z/3EbDc9YrOu5XG9zCu40zPGZrNa4BFWAQs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Se/QGzAq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=geLOKf8v; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Se/QGzAq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="geLOKf8v"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59UGS8wb025227;
	Thu, 30 Oct 2025 16:40:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=JspA3Eu3igdbxjgHR3Cn3MIFGYTVEYTAKfI0eyJWTlY=; b=
	Se/QGzAqYHvbBT6D9pPJJFmEb3k4Eeav9NLkZ2ikIrh/5yI6ZmGdQywnsLImZVwr
	3T8MAZsy5+jy/gbDntdAZu6zfdhxBvMK5h9KsEy6hXhDeBJ2lpOZizayqxvyxBQo
	1tzPnXuuiYALFQt69lcurRlBGFaVcTrGhf19CdOgQOfTz9eXcbggVbr5BI7cYnDE
	kGLqyLdYk72J3XHqY+rARu5seriyCCq4pN4hIW0FME8fCZGi8QkCvCatVr1j35z8
	qL/kaiNf7P9cgww8ZsPp5KE1POzBSm/Jeg5lzSkW89rhxoEzCQ2Oi2O84rQGkHTK
	9J/johkhWHNkNop9w0oIjw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a4amrg5rt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 16:40:13 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59UGLYI9034049;
	Thu, 30 Oct 2025 16:35:13 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012036.outbound.protection.outlook.com [52.101.43.36])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a34edkmu5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 16:35:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rELvHHnX8jNxpLfOhrloPO6cbea+KZfmZE7Cncj2eOud12RTuIAHWYGFffKJ549o2PKbdgBgXjc3bJWYuuTBslytQj4Gev8V9ngDsXx7MQUHmN2pkaD6cwRmfsB7bbPBmNCfiK5MSwU/b3i710j66FKtKHEE4gCZvou6LH8dDZ6lg20qtCgOmKUvf4xJziEiNNRWG8A479BcUKeSUIhdLt1Gs/i+a6+Zpv8A2fXCgyKyb9e9lPhwnrLt6RjbP3Q/yxGysoDSAnQiAygC40cklaYNpkwtqRxMl+EbjIj2CDXz6SyxqIxLeZrGV9l/CN2D591kIcJQnJ1RQmSTtra5KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JspA3Eu3igdbxjgHR3Cn3MIFGYTVEYTAKfI0eyJWTlY=;
 b=YihAA1t/sjiiOUADyBWD4/rDVdHOrlhNiArOD4LMsqMmOfoKUx6yigjsnOMu+VfSIiB4V9PS01A2DWkfKrbZr8GTFBFl2CGJ9No18Fe3LJNBK5irs3UYH7l0xuqVlCjUijPZPpy0YVyBOnfyq9m84Qmd0mkcT8vMaUHpYT98rKI0OcFff3ro5B0e7PgiLuiFNoSFAEKZt+s0Cz2ViGyme3cFxwwqezR02QpiY4h51dx1msns6ghwX7/CPg6dIw7mX39r2fL3LnO2bo3jGKlq0FWXn4vKGSk3lIzlOwDLfAJbkdctoHKBE2hz9TdDGI4X4q4cOLWEpoCaWLJlx/+qhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JspA3Eu3igdbxjgHR3Cn3MIFGYTVEYTAKfI0eyJWTlY=;
 b=geLOKf8vrgop4kjKj0DNpIpZq+w+2qgGFX/y8lFG4rqFDotBUFlWwwpAA8SGrZOhwokfVejiEmcyTJDXTf0w6NLwlCLRvhEsSZU+AGFhSRnpvu0f/q7ml1WozmJLXLA3kdRcHmwT2Pqqh2r/k/PW8UASzDqUa2f5ku3HPGRk1+8=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by IA1PR10MB7286.namprd10.prod.outlook.com (2603:10b6:208:3ff::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.14; Thu, 30 Oct
 2025 16:35:09 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9275.013; Thu, 30 Oct 2025
 16:35:09 +0000
Message-ID: <c3cdd46f-7169-48c9-ae7a-9c315713e31f@oracle.com>
Date: Thu, 30 Oct 2025 16:35:06 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: fix write failures in software-provided atomic
 writes
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>, linux-xfs@vger.kernel.org
References: <cover.1758264169.git.ojaswin@linux.ibm.com>
 <c3a040b249485b02b569b9269b649d02d721d995.1758264169.git.ojaswin@linux.ibm.com>
 <20251029181132.GH3356773@frogsfrogsfrogs>
 <02af7e21-1a0f-4035-b2d1-b96c9db2f5c7@oracle.com>
 <20251030150138.GW4015566@frogsfrogsfrogs>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20251030150138.GW4015566@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0105.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::20) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|IA1PR10MB7286:EE_
X-MS-Office365-Filtering-Correlation-Id: b5ace0a0-a2df-490f-3894-08de17d24a70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NWJoRmVicjZxZ2ZKc1NETUViSGxFNUtZdGlNU1drdG9JYUk3TGRtellQWTBY?=
 =?utf-8?B?OGJhd1VFRGZrZTQ5ODNZZEd1YUJ4N1dINzZ4OGk3d2JrNng0bjA2ZTdERlk3?=
 =?utf-8?B?UWMvZUp6aHlnc21BN2dKSzY0RjRGQVdOWDAwQXhOTk92N3BzLzNFNWRFK21Q?=
 =?utf-8?B?WGRhRVVDRHp5bFNaMVNnVTBlL3l5dFRCb040eE1sOU9JQTdEOHEvSzZuNW9j?=
 =?utf-8?B?RWtHbU0zYXdJRHZpdE1yVU8rRklPUi9icGs5NEVOc0ZBaEF6RkF0akZ4L3Fo?=
 =?utf-8?B?OUtLRmNJNmFNVnhMemI5eTFRenZaM3ZMVHFKdXZ5VXlVZUxRQVdVSTBRbGsz?=
 =?utf-8?B?TFh1elNnd0lYZWxSYklCc0xhYkZnc0VWeVRpc2MvUnFaWURBSGZwNUJ2MUdq?=
 =?utf-8?B?bmhJR2JJbllDS0x5MUg5eVJibXV4UUI5eXh6aGhueVJ6Zy8wTngyakw2bm5p?=
 =?utf-8?B?ZDYrY2hJQmxqc3E3ZG1RQW9BTlh3WDhrSXVPM2o2RE95bzl0emorSytLeUtz?=
 =?utf-8?B?S0k0QTZNejdrc1VsUFpYSGtVbXZzcTRUUjlOa0Z3MnVLdlVKY00wektVVjNh?=
 =?utf-8?B?NXFaa0pacjZLdS9PVC9lakw2NnlWSERScjgzdSsxZ2FEa2RNSHdZS1BkMDVG?=
 =?utf-8?B?THV3N2J1eUxWWU10ZG5FaGljNVhoa3dUdjQyRU9JNk0rSG9xVUpBTkZUZHJP?=
 =?utf-8?B?amhSNUpPNkxvOVFVSTVielJjM1h1Njd3SUp6QWduWUwzcDFGYlFTTCtDVENJ?=
 =?utf-8?B?U1lmUmpxaSs3UW0zaFZzc1VhUlZ5M1RWcmNFcTdWdjJ3aSt5V0dHbmk5OHNt?=
 =?utf-8?B?eDlWZGc2RUdjcW9VMHh5REFPcVNSVEJVTXBFTmU4TEJnMmk3SUVNYndMM3ZZ?=
 =?utf-8?B?MEY0OFdtTmdjRmdrSFFHV1ZFdDdDU0Y0R3BneDBDMDUrVHZaZ3RUeWpnakRq?=
 =?utf-8?B?RHdSczVpRHlrV0JRaEJtSTJDRWRqTFdhblZvTnNhOCtwVys4ckNmRXh1VW5h?=
 =?utf-8?B?aVRkUWZockFaQlJNLzE5RjRMa05Xc3YwNWZnYVRkU01JMlZxNm1naGN6ZzFV?=
 =?utf-8?B?OXlXNmRGUWxLbzlld3lxc01oSVVxamcvUnYvOXl3VEduMExkdWwvMUNxVTly?=
 =?utf-8?B?YWRsK3NSQitjcFhnWG5PQlJublFWTUE4ZytOVlA2WTVnMGUzYS9PbWVsU0F1?=
 =?utf-8?B?eHNYWTkyYk5ScS9FdW82L0JCMEhMeHpyZEEwemttL1BWa3BJWkZ0STFkZG0w?=
 =?utf-8?B?U0RuYTZCR0JsNnVubjZVM2RabFlTR1ZqM3FvYUpMYzk3Ujkvb01BTVpJQ0J6?=
 =?utf-8?B?QlVKOFl5UGt3TWdOVVkrQzRrdXNrMzcrakJ5REhUWkk5RTNLN1FDSnFLY0gx?=
 =?utf-8?B?S2tqMHIvak1DTDlEcHlaYmI5ME5Kb0RJeDhlZnRTVElWaVpRRzZ5ajNwd1VE?=
 =?utf-8?B?MmtvaU1rcnAvWmVPWFd0bDNpVndaMytxZzgrZzI2dmMremNNSnBWeUVYWUlh?=
 =?utf-8?B?N1haczFTeDNiMWlvU1MwWGs0WFVIQndzSEt3QjI3TGdaWmxJamo5RXNKKzdZ?=
 =?utf-8?B?eWpRcnFlUmF3Y3hpZ0xhcHdJY1g2dEZaaTVySk1rdlg2dDhwWmVGcXhuNGs5?=
 =?utf-8?B?Q2MwQVQvdnQ1M0tGamI0RG9JMVUzSkZnOGgwaDZjOU9nMmRpY2R1QWlqcVI4?=
 =?utf-8?B?cTNXd2Z6Tll1dHpxT2Y4akdQVjQ3WFFiU0VoNkVOYTVOcm5mbk93ZHFuYU90?=
 =?utf-8?B?Y2twN3pkOXBMRjNpakxmSFExcUdrajFUbVBoQUdRNlJVS3VxNUVsSEYzUUdR?=
 =?utf-8?B?ek94VTltWS9hSkNaTnBHTnBKbVVsSGJVWFZ6b0JOS1FWWStvZ3VKSEI4SEFL?=
 =?utf-8?B?Vm9Xa0kzSE9BdE05ZC8xZWJyTnh5ZldnYVl1alJyMC9BNUpJbkdPSUQ3MnZT?=
 =?utf-8?Q?kdoiO0mgpWmk/hloCpUWGw47qbPQCOS7?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cU1UYWV1L3orazFJcmZMYWZNQXVvTnN1eUYvSnlYNGtuTjFpN3pqeWt3Z1dL?=
 =?utf-8?B?RjRxT0hVM3g3aW1qZUVhTkNodFBSQ3ROclNMSG9TY3l6RGJMbSttVjA2ZHlp?=
 =?utf-8?B?cWw2d2I4d0ZlakpIalBQeHpPMzIzTGlXMGhwQ0dscG1vSXdzTlpRMXg3Znp3?=
 =?utf-8?B?R3N5aUlFVCtOcDM1S285WHdyTzRZTXZoZWVTbDdPVXlSUndsUlVYbC9jVTM2?=
 =?utf-8?B?NTVVR0dDOWpPbEpselUvWjlYckEydk1rc2NZU2lrMDJVSlVKT3oxbS9seHhU?=
 =?utf-8?B?S1FOanZwTzdvUlc0anJiOUhyUlVpZmRTdHJVMEh1UGwralNUMGxLTGpZdXhm?=
 =?utf-8?B?Z3c1Y3l6ZzZnNnJBYnBoVWRkTC9MR2JBU2gzZjI4VTVML3N5bVk2ckJvbFN1?=
 =?utf-8?B?d3hYM2cvcWJ5NFFoZmFKSlp3bWt1L2ljb3lzV0xES3FHam9qTUhQK2diSVpv?=
 =?utf-8?B?NllKZDRzei96azJhaXhGeFJYNlNsRE5HYWU0Z2R5S3JtRU40TGVvQjZTQkln?=
 =?utf-8?B?OTFaZXY3RDAyQXU1eWt1UTRsRjZqWXVPaHo5c3hkSmJOR1ZldU9qODZ5elUr?=
 =?utf-8?B?TFFpYTY0NHlYTXhlZFl4dUFuMWhCZVZVQUlneUZURG8zdkJ0alZIV0hmdHdq?=
 =?utf-8?B?Q2IyME44Vm9Cb2h2dHhhMG5Wc2xTVHJ2NXF6T2NnZWxJeGEwYmdIVVVUSXc5?=
 =?utf-8?B?TTFXN1dVSkNJc0Z4RVgzQWI5ZnFlaDByQ2d3ZGhUZWhDODNPNjI1TjdyQXJh?=
 =?utf-8?B?RzdRQ2dkMm5pdVRxVDlydU1PdmVBMTJxNzlJbzlXQVQ3dVdzdUhvZDJOZWFC?=
 =?utf-8?B?b0pBRit5RUI1WU4wdThPc3pyV1d5R2RBdlpCN2EyWUJFdXlVeXlJTm1XOVhE?=
 =?utf-8?B?eEpDQjdzSTJGVW1PQnFYWlBZR3g4aGFmdFlnZldSREt3UnVFN0w1VEF6dzNz?=
 =?utf-8?B?SlVmOWk3N0JqUEdXQ1pKcmJucE9GdFQ0TGVPVnNTK0FTbFlPcHJjcHpGOW85?=
 =?utf-8?B?RUZYSFFlV1RkWGpzVUVCZkUrcHh0SVVYb0swRWh1cER5cnhMU3VxY1Rrclhl?=
 =?utf-8?B?NUlFVnJoWWdUdERYZStPNmErdWtHZUwyVHFXS3JudW51WWZoRGlQOEt2THVm?=
 =?utf-8?B?eVJkaFg3eS9aRDV2OEpBVzJFMTkzK0lRVkRyZzFmSStIa2s3OUljckRkNzFh?=
 =?utf-8?B?WnVqbTRkRFpuaWJpcURIZVFRcUIydHluVWJTT1d3ZFhVSjBzUjUwU3VJbGRI?=
 =?utf-8?B?dTZMWjkvZkRGOVpqZHVNMlRqdzVrc0NaUHVPeVFYNGE0YVRQU3FpaHl1dFpv?=
 =?utf-8?B?c2prS2NXZHd1eGZNcDVLeWh6RHZhY2V3M2tiSFZIeTRCTFUyWi9Ma1d5a3dr?=
 =?utf-8?B?ZVMyODFDNVc4VW1EUFJ2SXdEUHhwUG16TkhMVklKT0Q5RWR6Q0JhTGVjdXM0?=
 =?utf-8?B?Q1pseHRsTW54SG1TUEpNVU1TY1lsNEJpcDJnTnNia3RmZmZGSCtzT20zSnVv?=
 =?utf-8?B?a2F1bU5tcTk2MmI3WllNTWtXRVBGWnRPcXhSMGtBRWNMaVhmalpuZHpTZnRD?=
 =?utf-8?B?Sy9qUEtRSEhrcFlCVlltQnJNOHIxeG9CeDJaYmwvRlNZYlZKUEpDMjYzdDRo?=
 =?utf-8?B?c2JwV1ZoNVFOc2lFbTY0L3lpL1UxU2x1MURpYnpkNlVQZDlVVVpBcnBLSXBr?=
 =?utf-8?B?WEFSbCswTUpodC8ySWFIbE5hOWErNFh6UUtSM1MrYU9abEFpbUZDZ0taTzla?=
 =?utf-8?B?VEloSWtFMnRkTlFSMWg0S0tWT0M5cWNFaFRpaHptVVBMN0tuMFlVRXpRRmtX?=
 =?utf-8?B?K2h2RkNOUEJtYVpHRzdCRzV5VUlrTWhRYldEMDVJOGR5M3BWeTRyUWQ5U1lx?=
 =?utf-8?B?ZFZXZ2hObEl5bHZMK3J6NGlScE54cms3dW9mWlROOEJRK1lxbXBkQ2FiYWNl?=
 =?utf-8?B?aGR3V3phUlBGQm9yRnFySGNWbFBIWStYbUJUZ2NaTlNDYWRLcFJNL01hNkxi?=
 =?utf-8?B?UjlySlRXS2NDVzBoSUdiZlNIc2praXVXODZ5OEdhclRSTm9KVE1jM0NiSnlP?=
 =?utf-8?B?NnM0cnZkWFB2ODkrYlh1dnFKV1FvS214aElxclNPdU1RbThxUGl2eWxVbEpR?=
 =?utf-8?B?WmxSTW9QN3lCVHR5L2lhK29JM2s0RkQvejFJUlFycDhiSXJsNFdFNkRJWnFM?=
 =?utf-8?B?SWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Y+OWwpL1zMgvicwb0wVzYEBU4uQRdQ9ZQWLvSMYBe296H+oLmtcg0ER5YNPQEUBiU83aZtwRiiMFwac28b6r+s8E0ifKMhk1OMqaDsShl7mCz1B0KCc/OAVDG7Dpz5Ie3/ha/C37jihoV499lUYZeqE6gScjzNhb07UQJq8JUfdctCiUUhpJrMPJUrbEs2C6GQ3m5f94HnoeLz+gJOLNAEFwXoP6OTCLBg68rHld+DOs8fc/BCd16zxFwybTJsF4rWi+NfgTrMmOQ6as8DG7YwktbVOew+0fj1HzOmpDkHcnAjOeJmBx4vheGSB+ZKq7o5QGsmL9IFC9MKa/ua/FdvL4Jli79HU62bkUxQm9p61bpp/rMpC9KmmWkMjhVopXM1/Geryy1me9ML9UovvoefUwdBVJsCwztxa9W5PyNhfwpZ+5M01Zf71zIWaxNIM3P0dY8AHDR7VYne8fM/CkGcn9fkbNe7uzQMfUSD2Slr+R/62GxmErs8BoA6WW6wT1BhoFNXWgQkutSCwZxkKIXRA0ISaAD6I1VKppiUyVnfoM+n3PHq4C2qXt6hyMHFTP8xxscNvMeJGyo54plCcyPWA4TF+F0mZsNbVMRpZAteg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5ace0a0-a2df-490f-3894-08de17d24a70
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 16:35:09.5758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sTsFzQDVBib8dKRc+4rYpTlsxk2FuJdv7eTe8GwlpQzvPQwdaTBV8QV0pPEEQS+g5z6Jvh06q3+G7BXLxFEW0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7286
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-30_05,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 malwarescore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510300136
X-Authority-Analysis: v=2.4 cv=HeQZjyE8 c=1 sm=1 tr=0 ts=690394ee b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=ifA-nIKBFLfgKJlUBVUA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13657
X-Proofpoint-GUID: VwMbpONQQCwrsjDujXOxth56xJPgnfAD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDMwMDEyNiBTYWx0ZWRfX91UEdW4GH3M1
 R9GRhUqqs2hkGREXoyAML3bigNwcqADj2rk64Bj7sAbvSn4Z7YH0n0h0RZTZwYMQw6gxovOXdRC
 Ud633f4Rm58MVzEBjVnc8DPTedkyNFrC+2ECAvbARecnu/UJLGN+HuU2z/H4NduDBxaJuvjj1Mg
 M5BBJslL2zXsIm+lZ7lS+JBcJGX6X47fYpqfMlIv5ZrXDdNgBFpYZ3iwpz/KcUAzzpgxoUL7fwd
 TETmxxX05it4FOjA6qlxVRhzkXQzldA07kWZFatOvRB9VD69P0ZtjgNIcxTHTBwx2NW5pp06HLD
 f8VWDIXIfbPKP8ltgQVwv3H368KMw7is9o6nwbeVfn2XHyB3bhZWiSauoSF9CY04nQyVmu4+LgH
 xQSle0FEy2sn47IodlWtUZEvp1gvMccOpf6AOYHii/PztsluGm8=
X-Proofpoint-ORIG-GUID: VwMbpONQQCwrsjDujXOxth56xJPgnfAD

On 30/10/2025 15:01, Darrick J. Wong wrote:
>> As for that corruption, I am seeing the same behaviour as Ojaswin described.
>> The failure is in a read operation.
>>
>> It seems to be a special combo of atomic write, write, and then read which
>> reliably shows the issue. The regular write seems to write to the cow fork,
>> so I am guessing that the atomic write does not leave it in proper state.
>>
>> I do notice for the atomic write that we are writing (calling
>> xfs_atomic_write_cow_iomap_begin() -> xfs_bmapi_write()) for more blocks
>> that are required for the atomic write. The regular write overwrites these
>> blocks, and the read is corrupted in the blocks just after the atomic write.
>> It's as if the blocks just after atomic write are not left in the proper
>> state.
> That's a good breadcrumb for me to follow;

I hope that it is ...

> I will turn on the rmap
> tracepoints to see if they give me a better idea of what's going on.
> I mentioned earlier that I think the problem could be that iomap treats
> srcmap::type == IOMAP_HOLE as if the srcmap isn't there, and so it'll
> read from the cow fork blocks even though that's not right.

Something else I notice for my failing test is that we do the regular 
write, it ends in a sub-fs block write on a hole. But that fs block 
(which was part of a hole) ends up being filled with all the same data 
pattern (when I would expect the unwritten region to be 0s when read 
back) - and this is what the compare fails on.

cheers
