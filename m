Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED0B126F0A;
	Thu, 17 Jul 2025 08:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752739243; cv=fail; b=AVGiHeZ8LC3WkEyFrC9lazz4e7D6D9Zu9GJ9Snerv/QkDJTiLZ7RPXPnWOIHjpBzVu0mU1Fwg/Tq0vacMttBgjVXAlTnGZAqZvLJ1ePAaUuCBrSkWasp6JPnXgBJ7Wkm7IYlqmspOWjON3tOjV/UIZDCNf1p4KbXqqMb26IcMgI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752739243; c=relaxed/simple;
	bh=CySxNj5InwOGHoYlEDsjY4OIeHqUFBixl6BTePT7f2U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KdrYBvD/eS7FLKUg7zigZbNAwwtKlbdX8WUTWBfCWNX9UuQZqqA029Oq9l4MHoPdpSw6nQj1P3aBeaBux23G5qSRfaeNo82dtW+wdEppshbQUyBtHPJGtsBDbwHzICzk3EHtpkguo4/Y+VXlcRXOWnf3qFoAVkOu8RdH2cSY+lY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hCZCvxOa; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=brKHuxsN; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hCZCvxOa";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="brKHuxsN"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56H7gVWq012756;
	Thu, 17 Jul 2025 08:00:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=bkIOzU7FhnW3EdvtUbC44Rg3Jkf2RTI8cHUp21BLBpg=; b=
	hCZCvxOa7bkhT4d95+Jj+rZBg6GVmeaovDn2oFtm0Cqq0z2DZ81gzMbd7uZ8Lh0C
	8O6eWB7PeFdp3Jgq9N8povdrPgEXIRKDSIx17jyW6STkE3cUYRtXBeeQAN4pK5AD
	a1/k35KcxsZG21H4V8BUNbQaf/PxKXr35wcP/GvnJ1w/1TOoKDOUxnSJYBBsBLUD
	d63iB/p8PwVrCJ1dSSnXXlIeIoN2g5VINV8G4b6GMuzGc6YDihCzGnrVNhXtOzqp
	HdUcDnMjixpB5EEcc4Umn9pQVFi+hwdM+phfqmGFLg9Qaq0qEqnIpwRG3sOs6ajn
	l5hSBQ0mDVCM1LRCIUz85w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47uk6727qu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jul 2025 08:00:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56H6GBkm011670;
	Thu, 17 Jul 2025 08:00:08 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2063.outbound.protection.outlook.com [40.107.243.63])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ue5cdjb5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jul 2025 08:00:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dXQ7wo2VUumQQYxTmJjd4tg8N2ntmiOWpB5rxFZE3ixVvqzwf54Cd/f6w6IP+Xe0cJKGjZisMKKUopN3nm2/QNcVcfYUYH28VOLbr97yLGdU/wr1yM+NzGey+N079VcvHv9NY7EIhN3O5U5rvhQXlbaUre0NsASr5bg+C6pGf/y8sUJu2d1VClXKGO7rCX5i/2mR9LoBm1lp6lbA9w9g8FmYjlrjWUx29pFHycagvMMTbwl+pV5g7eJiH5lm6PVsC8ES45Wa7Vi/R8NKz/XWho2qKDNgzBRXJI1MVBm+9VgctjIROKV3ykrOdzI5fk/lOvS0barauJls43QYxbHBlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bkIOzU7FhnW3EdvtUbC44Rg3Jkf2RTI8cHUp21BLBpg=;
 b=PKlPOwVAruNXyBKC5qDeUFZIMMZ2I+hK1/Cxjq65qwG+HwXI6wb4hfcdhG9Nw+tsTBxzuxLMv8nY9YJR+1wUOHUXGwTD0GP8SDFNoVJMgsvgFItubBwyAZFeiSjILAOpckHRp+pAoTRYjwgFEI5F1j16P3Pq3IJMjLtImGspYeqRRxMULXPScGpakLed0/K/7rUbNSIbowJZNGi0emmbHgkZgiUMpXFDIsbbSfkVP3w+dFfwGnECPEonK2LOxM8AF8Dm8iTDD2aQD6nUH0j0kuSb+KN24HqX8xaBIvEb/rs+Nlc4kwT8MjkeMSWEMYrXa7lplYsK2uxwwiz9qoMYcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bkIOzU7FhnW3EdvtUbC44Rg3Jkf2RTI8cHUp21BLBpg=;
 b=brKHuxsNX2hMzw7xCeabRFGjRl7xJqDDm7mjOlocRmZc8Hv4oT5/8bMOg6azWyyqXKm6CeaJ3xR7ACSZpeJGemD4i1GVxnzQF/Jt9n4glyIE5gOu8AyC7xCmna/FeW5hNfkYSgtYDN4vxGnnGv4aw317bE27DEZMiPtofliWclI=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CO6PR10MB5790.namprd10.prod.outlook.com (2603:10b6:303:145::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.37; Thu, 17 Jul
 2025 08:00:04 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8922.028; Thu, 17 Jul 2025
 08:00:04 +0000
Message-ID: <b14be10b-cf50-4190-a03b-ad302a241e74@oracle.com>
Date: Thu, 17 Jul 2025 09:00:00 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/6] block/md/dm: set chunk_sectors from stacked dev
 stripe size
To: axboe@kernel.dk
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        akpm@linux-foundation.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org, dlemoal@kernel.org, cem@kernel.org,
        nilay@linux.ibm.com, agk@redhat.com, snitzer@kernel.org,
        song@kernel.org, yukuai3@huawei.com, hch@lst.de, mpatocka@redhat.com
References: <20250711105258.3135198-1-john.g.garry@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250711105258.3135198-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM8P190CA0021.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::26) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CO6PR10MB5790:EE_
X-MS-Office365-Filtering-Correlation-Id: 10ad152c-fa75-4cda-644e-08ddc507f003
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SXB5bEVNb2NPOGpIY2RqTUFGQmtQZEVzWFNVMWVwM25Wc0J0U3VRNyt4REow?=
 =?utf-8?B?WXZBd2s3V1ZQWXpDR2lDb3RZejMvMysrem1FM0xIRDM3Q1JYMk5xNjZUVXlT?=
 =?utf-8?B?UGpEaE01UjZZYXVvSG5YMlFWTGhFbEVOUDY0b1BmMytqVS9nVW5Rak0wY2NK?=
 =?utf-8?B?Nm5pVGdyYmZOV1JyRDRQTnQrM2FQTTVtR0F2cVVEWElRN1pIdXphMTdsdnVL?=
 =?utf-8?B?cWVxM094NHoyZ3NIU0xoWGRneXh0R0JJellrWkNPcDJ2RlF5aTBsS2RpWG5K?=
 =?utf-8?B?MGk1TlhzVEhXT2tIV095RzQyamZGRHE3ZzNLL09qZmJUWVZ0Si8xbGxXWWhW?=
 =?utf-8?B?WDFUOVdCdmt0T1lDR0NybGFRVFV1ektBWTVLYnQ2TWQ2ZmxkZE1yRXBKdXVU?=
 =?utf-8?B?ZDhOcTlESytzZ3czanZUY2d3YkxRTnJWY2t5TW1ibWk5STNnMzRmWmlKd3Nr?=
 =?utf-8?B?UXU3MjJSd3BSZElycXhuK3NjZ3lwSWF4MjFKM0hPYjJJdTErNUl5OTJYMW45?=
 =?utf-8?B?cFBHZmxmcUhSLzM3ZDVvaTBNLzlTL05GMUV4N3l3SlRVd0E0c0NQZGlqWmhV?=
 =?utf-8?B?Q2lTa01pTVRLMkNCSmNxS3pRMTYrVFJwdVNuSkRNMHRMZTYyNGd2RGVxNVFR?=
 =?utf-8?B?Ymk2OWViL0EwL3NmNDRWVUplZm5CcHA5L09ITVlNWnhnMU5CcVVWZWdhNlV5?=
 =?utf-8?B?cFVHSHROMTArUVFIcVFNYkFHWGpVMGI0ejJ2VURnMzVHcFcrNlJINWtCYnhM?=
 =?utf-8?B?SGs1SFJyOWszcDg0VStldml0MHlBZFJqZndwL1lZeXlFWStvQWZMb2ZOSGVz?=
 =?utf-8?B?OXhKWURXeVpmVTNrTmFMaURsSmI5aTBQdEczSnRGTVZLOWFnMk1rNE5XZjRY?=
 =?utf-8?B?S0tLUHo2OUROb2dZUWt1a3FRYnEzZThsMGJXakUvOUFTM2ZKVmFtazBjTUVT?=
 =?utf-8?B?L0dNNkU5QkZqVTZHaFJtb3AwZ0xXelN4ZWFFT0trendRMW82MVh1T09QVFpQ?=
 =?utf-8?B?Q2FUOTRjYklpRDA3SkEweTJaWWZZa2FKMzhhcEhLMkY1ODdDdFBGZzlRUUQ2?=
 =?utf-8?B?MnhaR3RSQlJDbkdkelgzaEs5V00xbFlCOURJWll0d1BkbUxhdG5IS1NudDdB?=
 =?utf-8?B?L1RQZnF4QW9CLy90OXptUUVXQ010OVpZYWZsdzJoZ0dBYlB4NTBaT3QvVk5Q?=
 =?utf-8?B?ZkhKWkFMZTEwWUI5R2tvaWN6RVBZUmlNUmtPMEQ1clhVT01VUkJXVjl6WXl2?=
 =?utf-8?B?ZGdkNVVYT09UNy9BU2Y1Vmo1WmxYLzlYTjJBVWJ5ZWFJUDQxdXgyNDMrYWZ5?=
 =?utf-8?B?ZFF3V2RKaU1GRHlzeGkzV2RKTmFubUFER1hISVFsWXM5b1AxRXdMSjErNkIv?=
 =?utf-8?B?WVZmNkQ3bkpUZkszY2Z2Um1IQUUwU1RZV2NINjFuaHhkRzdlUlNqbVN1Q0hN?=
 =?utf-8?B?WDZWelpqZFNRK2l4dWZCT1k0eCtYSW1weHBxL0trbXdidHNLYWlQRDdWcklD?=
 =?utf-8?B?YWN0NHF4bVU5Y1lrU082ZXpGZ3lxbDVDcURHQ0ZGU1hxd1VzeWNJbXdWNXpk?=
 =?utf-8?B?L1pleTdQWURtdzZHM0k3Qi9scDFkOElHVm8vbjBFTzFKeGZFTklzSnVGQjkr?=
 =?utf-8?B?Y3hpNkQzSklXNTdqS2MvVEdIQ3J1cTIwczFhK0IwaVIrVFVEV0hGVndQZ1Ja?=
 =?utf-8?B?SEtIWnJ6anpMeWZNbERPYzQ4SUd0WnN1KzQyT2VDTU5UOFhjbndycVF5MTNU?=
 =?utf-8?B?RnhBRVliY0lhNytzaWJlWWswb09YRzVYWERrRDZHeXBLWS83WUVKTkdwS2Jx?=
 =?utf-8?B?OFNaN0tKYTlZMk1NNDN3cmlYT1RMdkN2a29lalFhbXd0SktiTENpOXdzRTdH?=
 =?utf-8?Q?HbzFvGZINn6q2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N3BSRUhySGl5WVR4STE0T2hmNXhRbTFSNCs4aHJmNFljYzFHRk8yY2JoWXpp?=
 =?utf-8?B?d3d0Y0MrRHplNWxjVmFza3JydEU0SXo4U2RjQ0h6RTFHWlFvQ0REcXV4MWU5?=
 =?utf-8?B?ODNYdTB5eUppTlB5cmZOd0VPT1V1dDlGQ2JxVmF2dHNrNzNMVWhEdWFQenZO?=
 =?utf-8?B?YWRGcTVVTTR1K3VHZUxweS9BcS93ZkdyNXpsL21KSnJRYy82aHM0cTlZSDUy?=
 =?utf-8?B?L2hZK1RIam1kcnFCbHZDQVJZVkJVMjhrU2J0WWtmZSs4a01QeUtOcFRVZVdB?=
 =?utf-8?B?MUNRQlZtTW1SbFFjRVRtM2s0R1lPUHVNblJlcDVhcU9sTFd4eTJsdUMySGtV?=
 =?utf-8?B?STd2TllLUXBIMDUxK0U4UStNZENrcDhmVTRibThNR1BNQ3g0UUxRWnNIZlRM?=
 =?utf-8?B?S2lzQUVnbFpNaWFuRjQwZVRvZHdhNXRwdXgwKzloYnlmR0NJZDcxYlFWYitE?=
 =?utf-8?B?dTU5Y0F2QkhiSXFLZm14NytSWG1PT2llTlFtcElUN2VucUxwRlkyL2pLY1hC?=
 =?utf-8?B?dTQzU2kwcWZZanM4UHl5cER0UEZmRTZWc2xUT2JrR1BMWE52czhJMWpMaWtU?=
 =?utf-8?B?WnEwMXZaSjdqYjZnME1kWFpFeVIreW5NS0V1aTRmaGMvYmx2ckw0QXFPcXpt?=
 =?utf-8?B?OWNMMzl5dkUwQnF4SHc2WE8ySUJQU01ucHJxZm9YOEsyS3N4TTN0OFZFQXRG?=
 =?utf-8?B?QWs4L0E2SHVlWTVsUWxjV25qekJJNG1EaXVvZ29Ed3F2ZGd6cUtyaFVnMXo0?=
 =?utf-8?B?YlNweDZFcFl4d2ZQd3B0RkVPSDc1Zm1DVWhVTXNVajZtTnVUL3cxTUF4TnZ0?=
 =?utf-8?B?K3JHWE5UczkrUm9lbVh1WnNwK0NrbVd3WldTU1F3V21kbFJtcXI2QXFNWFpl?=
 =?utf-8?B?T0RsYXlUVVFvUFk3dFAzZHJSNHQ0YTNQK2h6STF4UWhsUmJ5V2twOCt6d2R3?=
 =?utf-8?B?QTVVR2liMGtMM2dYT0xLdUVkaS81UjhmR1ErQVdFUkJsZVBsbWNBRElsR0F6?=
 =?utf-8?B?YVZoVUYwcVRxYlZZUXRDRElLeG1zV3NUWENNQjNHQTVEc2poOG9qbHVxWlYx?=
 =?utf-8?B?Y3d4UDlVV09BNGRhUTFWNjJjMmE3N05KSlAyVHdjaHpINmZhemFyYVNadTZ4?=
 =?utf-8?B?QlI4UHZ3NTJiUTdCNFlYVjYxaVNjZzNlRjg4d21RYUFNaFUxQ215cXQ3QlJq?=
 =?utf-8?B?YVAvNFlJcVBzUEVLVkhnQjc0QWMxOGpnd3MybnFGMWlYc3UzYldYa0hGZTRh?=
 =?utf-8?B?a1JjTmxUK2tSTEw4ZGRuTng5R2tQbStERWxrS1JDR0YwMWRPTEYyQmlLU3lC?=
 =?utf-8?B?RHpTUm8vcGhEUTZiS2REc3JIaURBckVySGxmYkw3dDljYzl4Y0p6MU5peVlu?=
 =?utf-8?B?QlJwMWJ2dERhTnNheFlyak42a2xLa3YzNDZodkM4VjdhSWU0Rnk2blIvbGZj?=
 =?utf-8?B?dGpLQ1hMancwZ3NhY2FUbGlqTzUrMVVVQ3BOTzR6K0M4Q0RGL3lYRzZ0NzNj?=
 =?utf-8?B?azhOL2FZY3FyOGRqY0NqWEc1TTFNMndVYVJyTXc3Nm5HaVVnYVhIMWllekdM?=
 =?utf-8?B?TlBKT0dzTExOVFIrTnFOb3dhbFZHNmVCYk85RFlDVTRBYmkyQ2JSN0hKeG1L?=
 =?utf-8?B?OWxFMG0rTVJEWjg1QWFmaDk4ckdkeG1UWmc3djBpY2s5ZGxlNjVsbXZWa3Jt?=
 =?utf-8?B?cVU2RTE0OURpN0h1WFp1RVlabFl4dnVCVXc3UTRkbnNEVkU2dlhRVDYzcS9L?=
 =?utf-8?B?cEh1UFNadUZvdTVaWk1hQjBFZWd3NndaR2hYMGFqTzM1OFZldXdTR2VJdjht?=
 =?utf-8?B?cUJZMUZET0d2SEdHV3M4Vng4bDVKUDBuVC9oa2tXdjI2dVNnU3BDbENIM2d4?=
 =?utf-8?B?ZDd1Ynl1aVg1NUd1N2V3MEgxd2RSeWJCNXk2YWhnSEFFQkdnbDlPRHJ1WWht?=
 =?utf-8?B?eUZiTi81RDRpZ0RUeEtzZnQ2Tnc1SWprc0dhVWUzOTZYUXZTYmRwTHJBdFR1?=
 =?utf-8?B?V2t4NVhrazl6TUhRNXFGTHJhNW9BYjNtK2ZtRmFSZUZUT2RqQys2UUNUcHFD?=
 =?utf-8?B?K09jMzNwdEloM2NwUnVrck5UcVpQVFFtWEZCTWpGdDJaVFFHRXNUbVJnU2dt?=
 =?utf-8?Q?ee+Y5VhLuZBxmT12PY79WlVxk?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wXGiHgX0NmdqZRwhEdt9fqsO52gLYbVvJkb8UCkateKS+Q07RuSIZPYK2jbWscCBnfEPONyVHpXvV86Z13QS13x6qVkatPGZeaPGAHaDzNCdt9D2NHselHZbBFuqA4x2AtM4AjSiEvGWxXyCqDNU4PPvUGRZZfawaxg8bTv7j6XZR0RFadrxtCjCu4Izk2511OCWK/mlKZ6ALrOl48qsYYv94/6kogmRFb7dRM69THM8h9qfVT8CuP2R3KqYUo0C2rOOnUj5CfJLuR/JIHMgnklE3ewBVPQXN2vZLyYcOH7MhVQSeffJfb9NMLw9e/hROsouGbNxR8w5BON77TxnCDPVSDL0uRmu2asd5UjEneX/zAqeqyjTZdsIP5sNX/ejRr+Cs9wnN84PtQoycADENJMATJKzZUZIjB7TQtHzaskSuC53wXT3IwupWgLGnArvzyycxDfv/Zw44DETbFT5vNbxqZ5GACgmJIHY6O9PcDm73Vf9r8+i/IBqB8EQbp80+SdNACTRzBo2TQT2I7SdyxYWVNgTppZR/17MHGOEUJ/WdYxH0z9qiO1txfpXtGV6mT8r+TExo5GUfrt20EiXTPMMcfcEyOir6qzDnnhP0BY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10ad152c-fa75-4cda-644e-08ddc507f003
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2025 08:00:04.5319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q1XsZKdQ/CC/b036ujHQWhtiY5g2dq0qM4wMD1uNp27O7WzyLeDaYq81JfRh/41GYkrqmWJ2Sm5w8yUwTZjRsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5790
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-17_01,2025-07-16_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507170069
X-Proofpoint-ORIG-GUID: _Eh34PqOg-H458w-2J6-p1DdAO92N2N8
X-Authority-Analysis: v=2.4 cv=AZGxH2XG c=1 sm=1 tr=0 ts=6878ad89 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=68CbI73PNsLNAb4QjyEA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12062
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE3MDA2OCBTYWx0ZWRfX3Y/8naDaa7iL AQZRHbhtCkvc3mLC8bpTTeCciWIKZbqrB32Mf4zZT6PTvPhnFvhuONSiSuf8MjSoxX9wIBVMKra mYCn+PvlIsjLgfANi+Q1K/sgbCwIZ962i+3j1vuNe53YHI0v0LCtx4jMKjz6rFeh7uGAqnZblHY
 MaJQMkqP9AxA9SkcZB3CdAir1mIIU87eY/H/bAW6b0sokEmlKmHq8gEOpCGc8qz4caUXM+/gdvd vpXlXs2fNyc92Ke2UjagqOjTBnpwjFYVFHw5kgHpgDNnT6PhFLB/+RnmSLhRZJL+TeW1z0XaRMi PjQZ7L4zgF7hrJ1k83fkC9ER+CUYlfONbW7eDldS0QYKgzjRScp9QEdeWukIjBGOv4CtyZobY59
 jC79P+77GrLc7Sstk5RWWmM7n7Xx9hkVAzE2QYZ2dCcd3TK5Qu1xxsPkc0bAazuDW7Hx/Av2
X-Proofpoint-GUID: _Eh34PqOg-H458w-2J6-p1DdAO92N2N8

On 11/07/2025 11:52, John Garry wrote:

Hi Jens,

Can you please consider picking up these changes on the block tree? They 
fix real issues which we encountered.

Thanks,
John

> This value in io_min is used to configure any atomic write limit for the
> stacked device. The idea is that the atomic write unit max is a
> power-of-2 factor of the stripe size, and the stripe size is available
> in io_min.
> 
> Using io_min causes issues, as:
> a. it may be mutated
> b. the check for io_min being set for determining if we are dealing with
> a striped device is hard to get right, as reported in [0].
> 
> This series now sets chunk_sectors limit to share stripe size.
> 
> [0] https://lore.kernel.org/linux-block/888f3b1d-7817-4007-b3b3-1a2ea04df771@linux.ibm.com/T/#mecca17129f72811137d3c2f1e477634e77f06781
> 
> Based on 8b428f42f3edf nbd: fix lockdep deadlock warning
> 
> This series fixes issues for v6.16, but it's prob better to have this in
> v6.17 .
> 
> Difference to v6:
> - do comparison in sectors in 2/6
> 
> Differences to v5:
> - Neaten code in blk_validate_atomic_write_limits() (Jens)
> 
> Differences to v4:
> - Use check_shl_overflow() (Nilay)
> - Use long long in for chunk bytes in 2/6
> - Add tags from Nilay (thanks!)
> 
> John Garry (6):
>    ilog2: add max_pow_of_two_factor()
>    block: sanitize chunk_sectors for atomic write limits
>    md/raid0: set chunk_sectors limit
>    md/raid10: set chunk_sectors limit
>    dm-stripe: limit chunk_sectors to the stripe size
>    block: use chunk_sectors when evaluating stacked atomic write limits
> 
>   block/blk-settings.c   | 62 ++++++++++++++++++++++++++----------------
>   drivers/md/dm-stripe.c |  1 +
>   drivers/md/raid0.c     |  1 +
>   drivers/md/raid10.c    |  1 +
>   fs/xfs/xfs_mount.c     |  5 ----
>   include/linux/log2.h   | 14 ++++++++++
>   6 files changed, 56 insertions(+), 28 deletions(-)
> 

