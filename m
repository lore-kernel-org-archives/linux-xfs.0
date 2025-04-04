Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D601DA53
	for <linux-xfs@vger.kernel.org>; Fri,  4 Apr 2025 16:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743784624; cv=fail; b=WD+KCAl6YXhswPTlTpR6IKY7d4MEqCIEDkuBc4WwfmDX1pAqfk7YQT+Bh4Y3j/7mu6rookjELsqfkTr4OFQMJxPvL7YQY6ntPz5uw0fg8orvoyN+DpUYwQz2jq3pucrZjDXiyDtReE0xgyPFjf5cI+w0TdShUN3gMzJ1BkLrKUo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743784624; c=relaxed/simple;
	bh=WH4kDwieQPi80HjGwDHPO1x5M9m452MOAdci0jlrEBA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eaNAG2Amy7f+fbLUERKa1hb4NETu8U5qTdgioWDcafjnUJuwYEK5B5AghELvCcgMFXrBDSzPSmtoTCTqZBADDLmwORKoYbBI4GvOLf8QktqeWG4TjcjmH6z9KEC/DSVNdjhNjnA7m1HzWR1CJ3ekiIjg2uyZY91d39neN0Ex9rU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hIJTvBDa; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LBOdN6EI; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hIJTvBDa";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LBOdN6EI"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 534Du6Eu000428;
	Fri, 4 Apr 2025 16:37:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=8smHYcxruOsVHX7vhgOa8heGmxU52OUoucsbLQHuOOc=; b=
	hIJTvBDaiH6LbsJ9uySkvi8qrqR/VlsMBWCaRTpfwnTjwyasgPjQq/L3akg2C/j7
	i/98uwWYPbmfmpat1sf1n3QooeyDO5MxCRzebRacyLKvJqG/hOdUSv8eI6GbZcJU
	htAGe+L8Aj6W5XsUeexLTBHG42CrEB6482rnbJO5cq7ywunF6ofHKrEOjXFYhre4
	RvCdUCHQTHXE8cJDXEvzBtkor1PeynSq3qpDl71Fs3uKrr3s9Z9I67aEqfs/+7Im
	m2m8hC9XAeTPfSbLQ++A4ah4LTFnBWODm23d+I2/m7vvh/r5hmDIS7S1qjeqoYyl
	7uej9WvWgK6x79Sk3g6Chw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45p7saydqx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Apr 2025 16:36:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 534GYdcr017316;
	Fri, 4 Apr 2025 16:36:58 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2048.outbound.protection.outlook.com [104.47.70.48])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45t2pthka3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Apr 2025 16:36:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RZLehLfA5X/nOnbND0F/Vwa2EpWOP7muKBLfT5XnhQSEmUbbuaPr156bGnwSKhEX2Rsy5ZtibBf36cT5cQCA0jtCVD9XlDdwdYb7UK+hljf8BvXgSxk9tQ3TtDcBkz+VW/87s35jEbc5B4z9yo9nqNtL0tWU/m3TW9ztMqpyGTr6w225h7sTtzbTYU0eMF2byfTXPGKO5+NtfEnAssUtvXEhDwB54zL+gr1Pk2dhj0s6V3m0NTNN9nuzo6BzqyBzGgqE3Og0VCcDND1b6xCB5+I/wetVf7scA1lZSYnX18salaoQEaTh4ungaVnawEayGkiK4GTvNH7dY3hU/IbMFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8smHYcxruOsVHX7vhgOa8heGmxU52OUoucsbLQHuOOc=;
 b=D7yvVs/Iy8jPax13VgAvACzhxXwfXWeQ1kSmvOjIpAEvYm9tI0Hxg3jTUXEY1aXMoLWpDzVjotJBmXCk1vcw9C7IlUeOfjfbPbSyRhoUaSqfHPNnwS8LK6sCj335oxy4VOO4eaR9vZ8x5JxSo9nhkOxlI6vBKoDhIc/3XjA4WhAkz3d8Re0QmGtk6820wCmSnirkZJjidn99f3oS5CF1jJ7pPgBWsnU1iJrwwEth1w8v6qKYVPiJTouiQOy+MGLFSGHjrPtNIbqVV+FgW1fSqkPGB6+fC+eXPN2dqDybTuOtM3ZE9J8t8CygXCWWjFk3gFX9kVr+MYdD4eWROvyopg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8smHYcxruOsVHX7vhgOa8heGmxU52OUoucsbLQHuOOc=;
 b=LBOdN6EI+pnhhY5nIjaqaxtrnOpmCLmLVzrl3WIhBFd359DaFuE2mAMAdLJqQClXjU6kXpTHbnFQRtLKVOPZqmP7gPMOoEpdS1dSL/J4F4z1r4dqUM1gpRHtLF8ZjfJn0oW027QStmeoHJ6y7ZIXcMhHC4cFepytcrWPwAT9oGI=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BN0PR10MB4982.namprd10.prod.outlook.com (2603:10b6:408:12c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.27; Fri, 4 Apr
 2025 16:36:56 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8583.038; Fri, 4 Apr 2025
 16:36:56 +0000
Message-ID: <011efc18-0024-402f-b79b-a8ea366fdadf@oracle.com>
Date: Fri, 4 Apr 2025 17:36:54 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: compute the maximum repair reaping defer intent
 chain length
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>
References: <20250403191244.GB6283@frogsfrogsfrogs>
 <ce1887ca-3b05-4a90-bb20-456f9fb3c4f5@oracle.com>
 <20250404160930.GC6283@frogsfrogsfrogs>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250404160930.GC6283@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0600.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:295::20) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BN0PR10MB4982:EE_
X-MS-Office365-Filtering-Correlation-Id: 62b705be-e721-4add-e87f-08dd7396ea00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SldQUWkzaE5UTzNWSWlyek04bnM3cGgvMzNPNEpMbGFRa2x0T0NnakVxWHl0?=
 =?utf-8?B?c1NURnVHQkRPMUVOMklRYWFDMXpoTkNpN1VYM3V2WnhYZXpGaUNBNkRQU1Z3?=
 =?utf-8?B?MTFDa1lZL1IwK05YM3FxTGNMeDc0YjZRSHcwZ3poZlByb1JMR2tPdmV2elE2?=
 =?utf-8?B?aHFtYyt0NGdlSnZ1VnBOYnVENWZVS1FXM3c4T20vUUp3S29nVWh0L09LL2c3?=
 =?utf-8?B?dGNCbUpiYjdnSlJKVjZDSGVOUUY5L0g1blVFU1VKYThvMmg4bUNCMXNmclZF?=
 =?utf-8?B?TWYzMWl4a0M1UE9SckVPb2dFUG52ZFNUR3J6ekdsMjdOZzBEOVlPc1MzaTRR?=
 =?utf-8?B?YVRYcVFMdmp3YW1WTEZBc2JHSW5PYlQ0YXFGSVpiQkQzbjZSc0FFSm9td09k?=
 =?utf-8?B?aUhER1YwS3BDMGk0MFBvTFNxLzhub1BtT0VaRW5zWXRYM3h5ekIyZDdhTFRa?=
 =?utf-8?B?c0lZQU54eWdRZmljOTYwVUk0VTNRaTd5UTBDZ0JhY045WmdhQzBPbmRLWG9a?=
 =?utf-8?B?N2ZiZHY3b2pSeWtUUW5hcHJlZWkzaDQzY0xHekt6K2h5UXpwcGJFeVZlRkZk?=
 =?utf-8?B?VUtCU2M4R3JJYm5CQnN3ZDY0QU5qUmZOR05yV0hGTFB5MEtyTmkrSXl6UFdi?=
 =?utf-8?B?MDFCYUpRNTdKTElLY1V6Rm1FWm92Vi83OGtmUU8yK29mK1RaZ0FjMUxTMjVU?=
 =?utf-8?B?TFhIVVk4RzlMUGJFMDQwSlhRdktURnU4UWxmcXNwdTQwQWEwYnFrR0JLY0xr?=
 =?utf-8?B?cnJLRTVQalZRdTdFWDRBK2IwN0JFeDFkSHhyQ3RaUFE3akIxVjQ2T2hubTZ5?=
 =?utf-8?B?NkhNWUtDd1RGRStkaFNsUTRMaGZOZ2FKZTBUeXNpaFE1OE9LTTcrOFVmbFF1?=
 =?utf-8?B?K0RIZEp5aGQwNzk5ejNXT2FhemI5c2tVZmRuRjFSUklldWNDK0wwbVdremtl?=
 =?utf-8?B?Q3R2OWQvMWpIaVlFZDVJNmVjL0J2SDJDYjJ5TmZhWUhnYU5hUHJla2txSWI4?=
 =?utf-8?B?Y1c2SkM1SG1qOVNKc2VmQkszNCt6Si9KVGViRzhTVnZQL3VrNS9la0MrM3dL?=
 =?utf-8?B?NVZBdFZqK1Jka3M4SEhVa3QzR0xtOURCRW94KzdPV3hiZVBhNURabVc2VUcx?=
 =?utf-8?B?aDVha0FLa1N5SDBEbUw2K2NSYUE3T2NWZDBOeHFNRERDRkdzSXZDYmJFTjVO?=
 =?utf-8?B?WGNGakNCdVVwcDloU2pJa0VMSDJ2UDJnc1ozaFNKYzA5YXViVXVPZlZVVGlk?=
 =?utf-8?B?WUtvZUpSVks4azdyaVdoWnFtcGZITHJtRmFJeDE0K0VhTjBVVXYrQTVnaVJD?=
 =?utf-8?B?WmhXcnQzMlp0UlUraWtiR29Ba2lQVkYyYzJ4YWxrOEE4djdwMUNRRXVkUzRN?=
 =?utf-8?B?UC9sa3BRZXVQdjFlNHNPSnVHRkZ5ZWx5YWNBd3pNc29td3dvTmQ1SUlucUhR?=
 =?utf-8?B?RXRSemYyQ3gwYkEreC9tQWVFcVUwYmVXZU9uMzhabjcyczBCbTZocjloWCtr?=
 =?utf-8?B?T3JqOVVzbVJHOGw2WjZQUWJTNlZ1WDNQR1JaTmlTclNtVFZOMlI4UkZQQlRy?=
 =?utf-8?B?UUYzYUwvb1RDRVZwOGpqSDE2eGxic0pBNFJUMWpEbHFSRHQ2c25yRXdSMmh0?=
 =?utf-8?B?ekZ0Ukt0anpuUnNhYnFQR09UK0pNd3NKTS9hZTAzZlkzY1gvRFl3S0E4Z2hG?=
 =?utf-8?B?M3FqaTdCMkNTN3ZGbGhhbTdZSjQ1ZTduVVBHdlRyYk9KcEp0OTFVWlZuYmRp?=
 =?utf-8?B?SDlMYVdveUZOSk9JanpSWDgwUStMK1BPdWVCTE11dUJwNE1HMTZ4MHdvaDE0?=
 =?utf-8?B?WjJ4VXJVZHJHZ3dXUFArUHlWYlIvS0RNaGo4Q2o1eUQwOW1hNzlQWDI2Z3ZJ?=
 =?utf-8?Q?fD7xc9TJGKRj3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WFcxK3FxdldFakoyTi8wODBlZ1d3NEpGc1RVSkFlUFNHaFpCNlBNcXFNL2tX?=
 =?utf-8?B?VU5UV1lTdm1yYXMwak9vS2VEc0dPbWFsWEZGZVNXZzdmWEl0QTRVMm02V1ht?=
 =?utf-8?B?bEgvRE1PWEVZNXBDcVliZ1p5MThuSmRJY1cyN25EZ3B2aHp6NGExM2wxaE4w?=
 =?utf-8?B?aUNyZ2V2bU13dkxsaUp1MUJaMzhQKzh4TElsVjRYQ0VrL3Fpd1h6ZDJubnZo?=
 =?utf-8?B?S0FiMUxZMkM5NVlWa1ljNzUzdlp5M2tOV1VNdUxwVHEwRXBDZXFlMGlXbHJy?=
 =?utf-8?B?V3JNbHV0Y3E2QTY4WlpQa05ESVRjM3kxY2NnZk9BRW1sSFk3RzdtTTgycFdT?=
 =?utf-8?B?MURiQXhycXhic25iSWttL0JJK21HeFVhMm93T1YrMXhMVlFVSFJHZHEvZ0E0?=
 =?utf-8?B?dXNsU1ZocVNuTURDQmdnNVE1VlRSNy9UWWdEYmtLQVkyUnA1K0VuZGs5U0Zo?=
 =?utf-8?B?THhtaHcvRXNOUStLMGRoVXZsU2xtQ3VnNVRCMlZSVmszb1FWN2FlYkdXUkVW?=
 =?utf-8?B?bzB3eGJYTkFMbldUOXJZMXZZdWtVaklmMFEzZ2Q3VUJhY1J0UlJqYTVvL2gv?=
 =?utf-8?B?UkI5RXhSQmRCN0FTdVNTUjZqVTRNN2d4MVF3c2lMbklSRjlGaUhLVTVoQlNL?=
 =?utf-8?B?Q2dxcmsraTF6TGZnZ1dHdjZJTWQ5VFU3VEl4WmFocmxZMDMwdkJieEZNODlu?=
 =?utf-8?B?SkQ1RFk3Z013cUNGanhocHQ3d0c0d3gwRjJwNDU5MGNLcjZEdnBzUUxmN2Iy?=
 =?utf-8?B?VHg4cGdyaWpVY2ttR2NUQy9abTNraE41VitFMnNFOHhuWktqbExjbCtKVDdw?=
 =?utf-8?B?WXh4c00vbG9KTVp3dDNrYnJjTUxmdjRVeTFtOSszTXZEWlh6eGIydkt3c0xH?=
 =?utf-8?B?S1RnTmlra2pHakZVRDlFbzRGWFE5bkhDWEpUZXE5dVpJSXZDNmJkSDllY0x4?=
 =?utf-8?B?VnZoNVl5akQ1dllTcm52SG1jV21ma2lyNVVXa2o4QVVPTEMxR2hCdVlsK3FW?=
 =?utf-8?B?eHpqVFJNS2hYMlpWQ0w2RENML2Jha01JQUh6T3krbGpLSjJueUNoV3E1RVho?=
 =?utf-8?B?T3ZBdnFaNWYxNDExaXNrcFI2V2EvQTZxRVJHNkFzT2lOc0NYWitlVjE5MG0z?=
 =?utf-8?B?SkRhVkp0MG9wZGJjSVQvK2dIcElFYTdZWEhtOFNIQzZ6QVlqc2JiUmkzRDl2?=
 =?utf-8?B?SWVvUVVpYjlzYXZ3dVREeml5U3VEbVdhdXV5TDNKcXA5cHpFcG5xZWxUNnpo?=
 =?utf-8?B?cWFPR3IwUS84ZC9NdGxmNVJ3eUVVTGtBQXR0K0RlOENHQUV5ZEpUMDFvZkNT?=
 =?utf-8?B?aHhRZ3VLMWM5U1ErRWZrdU1tS3d2cUdoak56d2xtMmZxNXRnaFFIZ044a3lo?=
 =?utf-8?B?NG5Cb3FLSzJUSmh5VnpQT0Yxam15akJuL295MzlFMmtlZ2VUWlkxR3pobHZ6?=
 =?utf-8?B?WVh5R0djbTlSRWlHU0RmNEN2Q05rL2dPYUphMlVSYndvUTZWY091LzRTdTV2?=
 =?utf-8?B?ZFpUU3ZVNzBkMTVuajB2WDNVNTFxc1U3NCtrc2FLMjRiWlNkTy9VSGIzbTZs?=
 =?utf-8?B?ZFRZbHZKaXlXMlVCY1JLOU5MNUhTZjBxdzg0ZTBvTEhiaEdDOEhzYjJtYXI0?=
 =?utf-8?B?enNZSXZFVFE3RE5DOGYxQ28yWUVVb1M1WXR6Y1poemUzeHJlOTA2a1p4ZGlV?=
 =?utf-8?B?UHg5YU1rbDA4K2Vmb3ZHanJ1N29jUmo5L0p5aHQ2elZ6V05DTC9xOStpRi83?=
 =?utf-8?B?M2JmZTg0SlduaHRLM2JUTVpiN3cxdU9DbUNDeVRSUXVacmlTaE45MGlTSDkz?=
 =?utf-8?B?K1JtSjNDVlZmL0Q1U1FKQ2V3Zmx4aGFMVU9HdGt6Uk41S1dPY1hJZWNCa3ll?=
 =?utf-8?B?ZHlzLzJXNEd5SVJQVHF1K2l5b0NMUVB5TzhXWXlRNXFoTERMQmtMNlFtMGZM?=
 =?utf-8?B?MFBNOUNENVFWVkhOakpvWGhxYit3T29kVG43dUpjZjJ5eWZzcnQzSUlWYW90?=
 =?utf-8?B?c3Q0c1g4WUxZd05RaXlQUElpQ1d0L01WN2xaU3VLTXlYMkU0TUFOMGh0ck9L?=
 =?utf-8?B?QTV6cmlHK0MwUGtGckhvT2c1K3VsbE5CV3g0UndKYjlVbXJlNk1JWmRYZzRN?=
 =?utf-8?B?S1Q4azlXYnNxeDh3VEpia3YwbVRIelJHY0g2TEFPSzltSy9yWi9qZ0JOOUlJ?=
 =?utf-8?B?L3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	h+hn1f3BJ/l3hsKvt+nDMPGNta1yWsNuyREMFbQg/HWeUSZdxsMO1A9vcja+XyGV/QQmxYbxhSFL7WjY9Q8kQuuJbXtcrqobQVdLgC2MYBvTHnBGitPRUrhPWCRTkXA2TRoj7xgCUQzSqQWgnans0iFJFFRZfOeehICWwCgqEs9ACogyiwCw2PxguXsctdVT/8HxRt7aUDrRMXcqs8gBiZ2OV1ESkd5IlMUDnC0XkjsoYOr0Y4CrvK4xIh6SDfCzF9pbPvEEF6kLm9JUT9CAVufLtRjEoXSQMxaEqLMcNxoGoyceCSbgn47/twHjmgjXxCHCtz+cTXROx2UeUxwDD99M//BYOwYIYkSae8yT4YoduqaD9L1RqkIQjEa26srETVnt1ZT8EujLub9TuP7P/vgEVXfWgAV1aNQ8TO0/zTcYi6Gf0coD18y00d5OG5dNAcDhji5NLZXFJJG4pcqyJZ0Iu8vWBkd2dYAmEFWGbwLCspTPcPInNUcNQDCTp4yq7M02hvpdu9v+8mShZe5HDpgTrHquDWVrCef7LviwArEOoNuF4acvFU2m1W/1XA3WVZ1VV5bP9VTk94OnK92VFeiynLJNJMfajeWE5YlO7pk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62b705be-e721-4add-e87f-08dd7396ea00
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2025 16:36:56.7583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5w1lsyAJCa/YdnU+KU+jAXEQ27KJUEHEkAN9ODU+we40xXkOmwFq23vecxQ9T+X9fxrb91AxHyLNcNR+54IJUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4982
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-04_07,2025-04-03_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504040114
X-Proofpoint-GUID: 0RlIpd5dVNFYY2NQCiRd_5o6mamHZQEH
X-Proofpoint-ORIG-GUID: 0RlIpd5dVNFYY2NQCiRd_5o6mamHZQEH

On 04/04/2025 17:09, Darrick J. Wong wrote:
>> and xfs_cui_item_overhead() - are not referenced in this patch, but only in
> The refcount intent items aren't needed for online fsck because xreap_*
> doesn't mess with file data.  They're provided entirely for the sake of
> cow fallback of multi-fsblock untorn writes.  IOWs, it's to reduce churn
> between our patchsets (really, this patch and your patchset) assuming
> that part of untorn writes actually goes into 6.16.

Can you please advise on how you would like to proceed this patch and my 
dependent work?

Thanks,
John
