Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3842F999F;
	Wed,  5 Nov 2025 12:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762345293; cv=fail; b=GmpVaz4mO9bqDcMiyXfd8wFGURKrlqj1oeYdlHSuKzD818Pvu249pSa0sFU9JXTdRn1YmfwBON4Woe99S0BtO9HoKA6HwTNXGsMwmtRNvnTzWc4rDFPaYLDQvPk/r+Nq0/ydhZiLLy5PFgYHHHhN7zUly2WgaHTbgE8GcxgEyFs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762345293; c=relaxed/simple;
	bh=7CO5tpQ7vvRyJN+gtcemjtG2DV7ZPQVBCEQLUqE1WPU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Yn5dgWS7lmBrbDMQnpmjqNN7o2V10bSPQSUw2odZNiwvcH0BV2SVjHnnh1hqhi1+5IbYG4jORAtD5xm0CcGyuwrfOtKJSOZ4rd/RZXByFHMSEVvDtFQfud91bLPznjNX2B+kl9x/ixLGiJUqtLqj3vz7bHq4g98X4rUKTY0OC1s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=odkW1S79; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=f7PdbfOP; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="odkW1S79";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="f7PdbfOP"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A5BJqOk015129;
	Wed, 5 Nov 2025 12:21:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Dk3Ii5rjLNR/HG+hWsbojHMtCAEft6LoPPi2MpiROZM=; b=
	odkW1S79zBaganR003oQ8wQ+EZmhohqYuC6Dr2OBG/qIZa/MfbEdgXjxVqzCtOcK
	1OVHI2erUDqmblqGrCYLZ55J6orlE/X8D9GpGn4lQmA51otaL/z01yir7xXHy5Fr
	7jXgElHwZAi4ZR6EmeheeEtom0TuLqoQHrwpb6mOuKkDgEO40uyCSluIR+UV4dix
	FjHVVv9Cv9KRblSRO89YV20TJ+6nY2cmin4k438oNJVflbrmnSpXlaV0rcFEQxH4
	rrjS8Ub7rnBThj2LyAs61J1oZ2GQd5MBWMHaSPYw3xqiQVOjUJkUlFA3gWjgd81E
	dm5JXR2ykAX8psa0XROssw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a85kur2nd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 12:21:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A5B3pq0007545;
	Wed, 5 Nov 2025 12:21:25 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012015.outbound.protection.outlook.com [40.107.209.15])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58nang41-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 12:21:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ixxei/6S/gWZQzPd5Zq/Gw1qbS187cakSY06RTVmkMpx0O0xe7dFiLg65BI3trGrF1PgVBq0hhyjO5sQpO7rxFq0FrhsLTgDmaLWRrhml3O8F4Hitl9wMmwCOcWJ8GsJwFw0U/ot7NgeJ9eAAIuMUQtqzH9eZtGAbb4mEjVfalIoqjDlLjIMQGAF5s0Ut21AGDdFDviLX6qY4u82Q0kErLOCjTqmoeKhld7wSCuULj5aGuukJoBxtZJh61fSJ6ytPSfFGxpM5JJK0pCrJHsYxUCsjK7tAozq8YhDd9JNMsB8zDdkEyUoUT101Z4eN1atOjZ1pkXSNOKY7hMBuXdH5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dk3Ii5rjLNR/HG+hWsbojHMtCAEft6LoPPi2MpiROZM=;
 b=sv/Z/ls+wa1iMlUHVmHlljyPs3YrZjB+ZrzakNEhBEA+QAF+bVpofKLUp2Li/3+lkMnmuAELal51bdfY6dANUWgeHhe9YoDQzY+Qyl+ac2a88y5KxO1onopFYWIvfv/HJdP2EYebXhUU5qLDXOEVEDif5yJGJ1itZLdBQQRWdmGrwZIDjO85t4uxEjKsIggQdn0RKCSZ+t6FEOFI8Qzfohgw4ooUMgEy7xGOqnb6yLYCCuCHPzSfuj5UEti0FEDc4W0oIsNu5H2l0ynWFme0M1/hFyp0ZNXvuifTVzwSWOCerGoyraZ1E3ZEhD9LsTOGuypCuC6V+7ErW779ETx1zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dk3Ii5rjLNR/HG+hWsbojHMtCAEft6LoPPi2MpiROZM=;
 b=f7PdbfOP90psBVjCBh0lr7nYhNsETswXecob00yqkxakOAEZpNWM1PTXk5jiJ0X3GsIzZX3qBNRzzZw6XSyCFlqQ11NR/e586VpZNrtN8llaNrQc+707at6B5rUDo7M7R8va01mg+Vc81xL0iRngytMZ82syb5VIWmdoVyMJSmY=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by DS0PR10MB7980.namprd10.prod.outlook.com (2603:10b6:8:1b9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Wed, 5 Nov
 2025 12:21:17 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9298.006; Wed, 5 Nov 2025
 12:21:17 +0000
Message-ID: <e5fa77c8-5293-47be-9f66-addcf458529d@oracle.com>
Date: Wed, 5 Nov 2025 12:21:15 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] xfs: fix various problems in
 xfs_atomic_write_cow_iomap_begin
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>, linux-xfs@vger.kernel.org
References: <20251103174024.GB196370@frogsfrogsfrogs>
 <20251103174400.GC196370@frogsfrogsfrogs>
 <02174386-c930-419e-9ad2-2ae265235d6d@oracle.com>
 <20251104171801.GL196370@frogsfrogsfrogs>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20251104171801.GL196370@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0023.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:151::10) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|DS0PR10MB7980:EE_
X-MS-Office365-Filtering-Correlation-Id: 1158a1c1-e20d-489c-9940-08de1c65d1fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UnJrakpNU2ljRzVQY1duZ1liTXJXSlBwSGluSnVoYVJWWkZUc0x2UFVCMWwx?=
 =?utf-8?B?N1RwZy9aS2M4cGdPbzJtb3FsQStHeFBibXBjajl0ajBIR21RVmNJRmI3TUkw?=
 =?utf-8?B?STNSQXhnTkk3TURjMHhEY1J2ZVMwQ1BCNTZUYTZFYmVHUFViNTQyRk9zaEZK?=
 =?utf-8?B?NC9yOVk5dVpiZzZRdFZTc3Q2UzczZzdPZDFVdGlYOTJPVXg0MEhlb1FGck1r?=
 =?utf-8?B?eU44eFN5Sm53R3QyZ044V01RMWUxNjB4SC9HenlqOG44SEc3eThLb2xVaE5S?=
 =?utf-8?B?bnFzRDRDeHJTaHgxNWh3SzZJUTA2aDA0ZTVWM0pEUmNia1dpaDRyVlNOMkVN?=
 =?utf-8?B?R2pad0V6YjdSZ3pWQjZmbFg0SzMxYy9ncVhWbW04YU5SRTgwKzkwMTUxUldh?=
 =?utf-8?B?WTBtZFFSc3VVdFJpbkN3a01GSDBiT1g0SmhiQm5pL0MxTlgwY1FrazZWWXhs?=
 =?utf-8?B?Q3l1TVNWVG05RElON2t4MTdLakFKcEQ3REd5bCtzdG12T29Wd1pFVVpSOXh0?=
 =?utf-8?B?MTY4ZXFGRVBqNWMyYWdHdStnUVAxWHRkZ0tQcWxxOTM2cTNmSjljaFZIems2?=
 =?utf-8?B?bHBDV0JWWFJqWmxLWEpFWUhFbE8vWllmSGl4TkxLRkR4cTdtM3FGS0VyeWFq?=
 =?utf-8?B?MUlBZU16YU5vUFA1U3VEdTlIc09Xa2N3VUw5M0thNUQ4RXl2Vmc3WXdJdStl?=
 =?utf-8?B?S2tockJjc0xBWDNyby90SVM3WXdpVjZ0Uk94TU5LR3QyR21JeFVaYnhPWS81?=
 =?utf-8?B?NGRrdGQ1ZlVnbW0wRWxWNnRoSUNWL2M1eTZOUDQ3cWRDVit1dk9lK3VJZVAz?=
 =?utf-8?B?NE95MnI1OEY1cXk4N0RzUitBQVkvRGlHOXhHMk1VNEV2Y3I2enUzQkJXVzQv?=
 =?utf-8?B?UFIwaWpKZVVuTFlWRHhzWUZSMFVrMmVVWkVwY0hJM1dZOUJBTnpDSUlLUzJG?=
 =?utf-8?B?dWhNdGFUNThCNDRLam52RURKY3BHTjl1RUhpN1JPRlRmK0VpUFkva1BPSnV6?=
 =?utf-8?B?ME5IbFVYRWVXbHJVcGhscEZFdEh1OUxHU0xJYnE3NzZYV3d5TmdjOVMyTkNZ?=
 =?utf-8?B?NTR4UnhEY01jRGhXbWVscFRoOUlYUkFLbGo4NzFJTWlYSy85UnpFeWtkZmhW?=
 =?utf-8?B?cVI5eDRlY2NEeWorNGppcU5DczQzUFlFaTNEMC93eC9RM0NteW4waUFIMVUw?=
 =?utf-8?B?Z0lVcVZZMFpUM1ZyVVZoQkZhOVVFQzY4QTFPY2srcGMwbW4yQzM3c3Z1MUdk?=
 =?utf-8?B?OUU3UjlON1Q1eTRiMUcrWnZNaE1UVFpzcTJRYW1KYmRTUithMWZHTUxRSlVF?=
 =?utf-8?B?dWpaU0lSTWxzckpXTVVYTm5RWHJZdHA3VEN5Vlh3TUppQjF0dUkyRGpmSnZM?=
 =?utf-8?B?a1pjT3N3ODRIcitNbnZkRklURTUzbHoxUWFHbkNJS1ZiSldlV2VmbXhJMFFk?=
 =?utf-8?B?RVR4bnc3U2ZMT2MrRWNRM1NubHhOMU4vbmFhbm1tL1dHb2RnMElmb21nS2Zh?=
 =?utf-8?B?ZzV6aTZzUDVDV3J0RnA3UmF2cGRVa20vOHZtbzUzMTdlTTJFZlpIcStFK1Na?=
 =?utf-8?B?a2svNFFhbWYrM1RFQUw1aEV4Mm1SdjBDK3dCa1I3ZHhWRDN1NHkwT1ZWa3Nm?=
 =?utf-8?B?UzJPZkNQd3BiVDMzeTlzQ3JqU2lnTng2amI2QWxKS1Jad0laUmFUV0swOFFk?=
 =?utf-8?B?YmxDUURGZ2tlU3kwSmpjc3NmOVREZVBvVXBCRVR0Q0F5UU04WHNzTGp4YUdr?=
 =?utf-8?B?cXhTTTVBZThQWFhTTCs3Y2dNU0VoSXdQM1J5YXhrb1lvNkhGOU1rb0RyN0ds?=
 =?utf-8?B?YjNQd1VqZFBsYkErZG0vd0N0MURLZEJzelFob0c4WnhhSm00MTRoRG1SSzNX?=
 =?utf-8?B?bVRFTEZFUDE0V0ZWRkRyUEZaVmlzOUJiNnBQVmJSbVJuRnc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OUdVeUtadnhiT25FUVAya2JLZExYTlo1cUg5TlRuME04RWhESEw5NUJ2QXN1?=
 =?utf-8?B?NlFBWHRDZ09xN2JFL1B6ZXQ5WHdOcXU4c2pHc1hxQ010SGs1dm14aWtYSzBK?=
 =?utf-8?B?d0VaNVhTQWlnNkZOMUhzYWVuL3h3NkVIWG9rbWxLV0Y5Ui9oQmxNQkQyc2xn?=
 =?utf-8?B?cmd0U2VLV1c2ME1sV1l1U0VsdHlnUkdtTld1dERzcnIwUmJHaDJybWoyYWdr?=
 =?utf-8?B?dVFpK1ZFVDRjUnNic0xmWnVmeHpxeFZFTGlwSlJyb25Wa0tjc21jWmg0KzdJ?=
 =?utf-8?B?T3ducVdXMWVtRGpQeW92NVU2WXlGcEJjTHhhVkpTUEJWTEdyelBWNnRLN24x?=
 =?utf-8?B?V3N4ZnZYRE9aMnBBUmJseEhOS0cxOUhSVUNYYzF4NU4vMEVueFNKcUx0dkdw?=
 =?utf-8?B?ZzdtaHdFYUdJUTF2eExvVndZUmRIb25raTdzR3ZkK2U5T09xcm1yQWRZVWo0?=
 =?utf-8?B?ZDdxQ25OcFlWRnV6cExydHZzWDFXOFEvd0tjNCtqTHdETlBXY2wweEk5eFRw?=
 =?utf-8?B?aTc5MitwNFBlTzN6SnhpZGlyZHQ5bkVFQUtwMFBmaTNpK0g2d2dyb29POWpl?=
 =?utf-8?B?eE9PTmFFcmRpdjdxcTlySzB6Y1lnaG5Ga3hFL1BtRytyUGlnNUQ5R0ZzKzFZ?=
 =?utf-8?B?WGR2M0NNaTljSmM0aitiZURDSFpnL3lyRWZ5cUhqMGNINWNlMkJQdzBRZXlO?=
 =?utf-8?B?MHF3a1gySWlFcFh3OUpDK3ZDMlFXMGV0dmFqWnRrekVOUzhvWDJHU0R1azBZ?=
 =?utf-8?B?VkhSRHJtRytvSWI2MU9hbkpPUGdjbHVVb2RvQTRyaXdPVjUwaEMvVnFhaFBh?=
 =?utf-8?B?dVBxekJ5TzZZbXVCcTNWUzF2YmJOaXBRajZnUjRnOFduZ1MyK3h2SUZmaHdU?=
 =?utf-8?B?dDZyaytMeGpFWW05Z0hYQkljNWhUNVVTL3RqSGlMMnVXNTF3d2hveDZ1NmFn?=
 =?utf-8?B?cTFXbUFyQVBLMHhycHB6eUlwbVp1djhqS2FpVUZwVGZkYlExZXlBcFZFNGEx?=
 =?utf-8?B?eTQvejhwZmlYZ29sYVpRL2pIelpYcWtZTGF3QXRLNjl6ZFpPcTVUVzJaYVk0?=
 =?utf-8?B?QVpjcjQyTVppQm9PUnBsUVZyb1Z5TnRwMHAzRVp0amtleXBqUVk3dFJCUzVI?=
 =?utf-8?B?QkNFbmppWGxHcEt6T3NEcHR1Vmd6dEh4a1puUXpuT01iY0U0SERuUVd2NHlm?=
 =?utf-8?B?a2JDdGQrQzdyRWYwdzV1SjE4SWJWaGxqQmZwemZvcnQ2bFIyWEZJVDVBL3hh?=
 =?utf-8?B?djRYN1d6V0Nvc0Y1NmdnUDV0WlNsOGwyUytkbDhQeklDOWFtcWEzRVRYUHZB?=
 =?utf-8?B?bG5aTmQxL28xRVI1SHV0TmpkcWNLUnZnSTFRblYrc2tKL1RKNVBoWVZMTDR0?=
 =?utf-8?B?Rko0ZnlEUTczMExEMVZFZGJ1TC9taVBJNXlXTVhkTFd1QzVKai9xSWhnMWlR?=
 =?utf-8?B?V2RSdEplNzdLdVQvSXBNKzBwQllzYWdpRHdya1RVdzFtK0Y1Q0ExWkdnK3Zi?=
 =?utf-8?B?eWdFampKSVQydU9wWCtmTzQ3OTRtWFhuek5UYUR6eW9yY2xBVU9heDF2RDlW?=
 =?utf-8?B?MlZ0QmVlNk9Eay9kTit5ZWVoQVY0QkpMdDc2UWplV3A5d0pwZGdwTjJsN21k?=
 =?utf-8?B?WW9Qd3l2bmkxWkhmdGt4WFNaQmE4S01WR0RUeEk0SkYzVXRvWVZmRjlGVEl3?=
 =?utf-8?B?ZEtxM1FUdDdTbW4wb2Z4NGE3V0V6VlQ3NC9XNmZwSmVIN0VDMDRvZE5kdkU2?=
 =?utf-8?B?d2NINTBDRUJOWXk3V1M0cWhyY2VQRkxxOXZiUFBsdFFGanhjV1Q5VVNxc1BW?=
 =?utf-8?B?L29wSzdjdWo4cUw5U3ZFSHFuZTZDcm80OWRHNVA3WnkxR3pHUk82TlpxTndT?=
 =?utf-8?B?cmYyQlBCNEVRMGxQcExRR2RkYnJYRCtCbEd4TUcyeHZ2K056TUpMK3kxSzFV?=
 =?utf-8?B?QklVL2NlZWFiSStxMUZPZTFrMVBBL3lCUEhkSVR6YU1VZ0VsUW1FOUFJTnAw?=
 =?utf-8?B?M29ZalZDMlE4SUFhR1B5VzNLK2MxQkNvQU5KclFmM1Q5U1ZLcEM0ZmZyVmJu?=
 =?utf-8?B?UFAxYk8xYmlmQmwvdEMxOU5qYnBwODZnbHUrUmd2V3NTbTFRaTkzZ0xIc1lC?=
 =?utf-8?B?aktQUEpwdG5kTE9HWlVqd1Y5YWdIU3A4c0twRTl6UzVMcXBYamFDQlJQb01O?=
 =?utf-8?B?U3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	q8Y3NgMeyNjR82w2EwGzOGFc7OStRN47VCbAh5ABBRb75o847Ax/9m3rqt/GegIhvgiAJDCn5KEosy/1/dVmZxrFpGtc+W0MA2enPMheO923t4RQzlseblJkM0G9nMvMausPbeYBmfrltJsFxvbNU+H34dNUi3TNTFTY4v0pEXlLqJ320gaL76u6rxDg1hQAuSE05KLORTzV4XBAeX7TzEmlkeMC4mFH0Avpk5Z+RDNMshwjUsN1InfF5/lfGoE+YeQsgyMQQYbETM3nUhbgyXxTEJTyu772AmDN+eOdDMQmj6YPcotcAZjAWw8D/xwBJCwvfnIwnuaamG5sSsIB/EC3zKvvXFLsfpDOPgYXMTcKA0g85KxvsP1vu+NiHN9+lfvV5ZZuXf48mjYWQu1pXe+eh1b193uHBafNQSWF+ViF5X2S2WHUxmbgLG4ob2dayhKd+NTBB2h38512zJVU8IEjTGc4nrEJ2qVijziaYFwr+3NpDm3UN1LbDPLobRH0/agPfu23R4IjGtC10xnnGB6pOwQAuQaYb6xg2w3GkSARlpkLzMJQ0WC8xXEWWg86sSuCG6geR7yZBggG/9mkOyZXLCkDsJi7da6JiENDA1I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1158a1c1-e20d-489c-9940-08de1c65d1fe
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2025 12:21:17.5053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HQ0zA2mrQV8/kZKDv5gZDhIeQnDKswWb4flBbDLKe4ux74j4gYUQO7D+9UffCSwPajhIb+IVhi2FV5NvkYcVIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7980
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-05_04,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=824 malwarescore=0 spamscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511050092
X-Authority-Analysis: v=2.4 cv=C97kCAP+ c=1 sm=1 tr=0 ts=690b4145 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=uherdBYGAAAA:8 a=P-IC7800AAAA:8 a=vosxXX1W1IDU4sdlIWsA:9 a=QEXdDO2ut3YA:10
 a=d3PnA9EDa4IxuAV0gXij:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: q0nMdLLHYVPg5hqqtY19pKa2o0UC-YVK
X-Proofpoint-ORIG-GUID: q0nMdLLHYVPg5hqqtY19pKa2o0UC-YVK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDA4NCBTYWx0ZWRfX4QEWdoA0ErxJ
 4d1tdgmKPaPB1Cedj1LU+wLqIkXLyVCQlD+4yKWNeKs+7N2afFyLkU0WTwWw9CF7IE9GKSSWrFD
 P8d08jnTWNqcdN/kgVWFYnL+Nm60pm76H/osDMr0hj+YLumkyhs5FEziHZxu+k7f5XjMudK/pcM
 X6m70L3kTCoTQLIIFChxNYSbbEyBya5N6ZqOat0tU1J9GGnpeD8uImvccEgqd4pWSNZiiSA61Bj
 3A/ISBFjAYI5eW/ZLKH2sWDn56B3RPBQurk43oAC1iKyYPvPe91oLUje3mJ86Vuf5/WcXu4epvk
 yT/lIREckxakSKq7f5hIDcThJ6Zztb9B5nOo8aDIZzAoWT3B4a1HSZwjFL4H+y8cBPmKG2Jx4fV
 MbdTjetVKCtX67cYah6A+pnHaevjPw==

On 04/11/2025 17:18, Darrick J. Wong wrote:
>> Can you point out that code? I wonder if we should be rejecting anything
>> which goes over s_maxbytes for RWF_ATOMIC.
> generic_write_check_limits:
> https://urldefense.com/v3/__https://elixir.bootlin.com/linux/v6.17.7/ 
> source/fs/read_write.c*L1709__;Iw!!ACWV5N9M2RV99hQ!M- 
> J1QmUWrGHUBb6gf9LHN33HxhBfk3rHcNR5z_glUHClffIPQ5UFQ1zmHpsetFGz3_3lHzUrwyAASD_90A$ 
> 
> xfs_file_dio_write_atomic -> xfs_file_write_checks ->
> generic_write_checks -> generic_write_checks_count ->
> generic_write_check_limits

ok, thanks for the pointer.

So should we stop any possible truncation for RWF_ATOMIC, like:

+++ b/fs/xfs/xfs_file.c
@@ -440,6 +440,9 @@ xfs_file_write_checks(
        if (error <= 0)
                return error;

+       if (error != count && iocb->ki_flags & IOCB_ATOMIC)
+               return -EINVAL;
+
        if (iocb->ki_flags & IOCB_NOWAIT) {
                error = break_layout(inode, false);
                if (error == -EWOULDBLOCK)


Note that I do realize that this may be better in generic fs code.

Thanks,
John
