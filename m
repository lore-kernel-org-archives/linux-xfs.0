Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6249B279DBC;
	Fri, 11 Jul 2025 09:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752225793; cv=fail; b=ZAUp/9Awq2P5XwaiA2YpTDq4ElNAgwfhw49BRJ2S94Tcsjj3G1zswCH41QSv0UsIfMvixhdPNhW+sw25MKrPrrnrnSu4mnd95RHtbX+7H+54Wu4zQAnP1nzqjYvFIoK/hJX2M7jf0r/hz681U1PKH6d/n3WyHcmnRU8WjGIYApk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752225793; c=relaxed/simple;
	bh=TNzKGI3C2ikQ5eX0S0HSMMAjQTVEW/pPOu5uAupojtI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QwwPkKnvuFchkR0Uzktbwc+0e07VbDyCv45aHzdZ+VJth9cz5bkkbH/AoW8VnSM1sU8dhgRd8hu5vgmzqg7IBAAU39cQH0eIiG5Da9ZZLrUIB0ZoT+FokfshvY6MJOuMlTgeVY34DWGWWkIXDOpMcNaylG9k3kXPx9StOR6b72w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=rg+KzBse; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aI0UlV++; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rg+KzBse";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aI0UlV++"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56B93eXa010375;
	Fri, 11 Jul 2025 09:22:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=KHS9nV0e1OaPF11WCH1C/+sF4CkJh+lX6GZdv4yItHI=; b=
	rg+KzBseFeZmiKQIDo05xjq3O8mKsmSQCe+QVtrutoEEsOBjDBsbRMlp4iYlDw5G
	8+pzGdj2Du9Ukqx5iJKFXn0Z8NN1gUiL6riA5YwjepEwilqLDB6tviT1jjAXjjyM
	BQKdKCSWDKAqrm0KzZcSYvtAh/5KYIYdhWyzA7+xJAfbptgwhvrxM8nf3NdPCcRL
	OPQxgeA7m4rrMa+7L87II2SPIDm1x2Q/I96DzhODJeOUyYXptEhoy5KOvMfWPXLt
	4U4OAkOBwToT/IhII+7AMj92KZQp9ZiP2aUc2STwqbAmdye0fyXEMkMNrb3I0EQn
	dRNL3vocVgX9iV35wMDa9Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47tyn3g12p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 09:22:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56B79Uew014057;
	Fri, 11 Jul 2025 09:22:56 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2050.outbound.protection.outlook.com [40.107.92.50])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgdcb4e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 09:22:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B/YcI8bQBR9QMczCV/eJMGjMrbWHenPAhMT+4mmplVdVZNfxT4NXG8GWUwm0aAfkJv54Ey8T4btP5enOGj01+2F9tcrf2KhgJx2EfesxB6PVXDUBu6zj0ejPLcToXtUjyjgcY7FOvWE6+oSMN60QtyNX8stw/dB02tJbEKfinbG5wX5dIJcpou9FGNFduLky276OXugWuQsPqsqad9ZJLjCis0AyWNt+RRR13jATDCarFbBD8oxD2Yl2YWKuaTrmMkEIUMnf3iQYEe13JCrQvJkh80+snIBFA+sJnGr4rKBKe7Ib0RX88sjeXa0yXV0g+BDlqvQu00ZxZZkRpXibtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KHS9nV0e1OaPF11WCH1C/+sF4CkJh+lX6GZdv4yItHI=;
 b=wgYr0b4AVXY532NY7ajT14d2e/b+TNxiM5oUkawzKkw08l0fg2dmHB9bzwzUxzTxbW50yMJFx/sG1XIbEumdHKN7paFrmXDtdigXU8WEvvtjrn4ym3MxxjqEQNOWC+cHBDu+trXLsG0gm1Og2LatSMMxaQ2doNytKkijI2gw5ttILgKHob2irfbNQ/QOOz8mPbUUxE+v435BKcoBSU9BrSUEcWQZx2Ztrbbd4fawKNZg0rujHd7qL9uej3/6MgpngpnpUK+dNTtvDVBAeki9jKLZJgg6sq1D9U+b/UpXnXThKC4OpWoCxw6MRbrbPCVEJ+hfwuPgh/WCNMDdgJSSPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KHS9nV0e1OaPF11WCH1C/+sF4CkJh+lX6GZdv4yItHI=;
 b=aI0UlV++SN1mA2Un2VMblA+rtpRIUzM6kahUULb85OA57OfMy28KnNTNL+5mRKDuHML4oRkiUWuPZhALRZmRAQheDBowcLS7uk6F+eTaFRjV5Uc9uqX41XNAlXX9a9GKNnjsZGPXI0lItOWsY2efV37fwdkkLlHsjiUE3Ir8QR0=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SA1PR10MB6472.namprd10.prod.outlook.com (2603:10b6:806:29e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.23; Fri, 11 Jul
 2025 09:22:53 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8922.023; Fri, 11 Jul 2025
 09:22:53 +0000
Message-ID: <322db102-81c8-4d68-93f2-333563e391e3@oracle.com>
Date: Fri, 11 Jul 2025 10:22:49 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/6] block: sanitize chunk_sectors for atomic write
 limits
To: Damien Le Moal <dlemoal@kernel.org>, agk@redhat.com, snitzer@kernel.org,
        mpatocka@redhat.com, song@kernel.org, yukuai3@huawei.com, hch@lst.de,
        nilay@linux.ibm.com, axboe@kernel.dk, cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        akpm@linux-foundation.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org
References: <20250711080929.3091196-1-john.g.garry@oracle.com>
 <20250711080929.3091196-3-john.g.garry@oracle.com>
 <901ca013-ad1f-45cf-9086-fb4db6c7419b@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <901ca013-ad1f-45cf-9086-fb4db6c7419b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM9P195CA0003.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::8) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SA1PR10MB6472:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c83f71e-3d94-4bcc-c771-08ddc05c8395
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RlBuWHZGWE8xaUwvM3BXWms5QzVPaENMaXllODV2TEcycXd4VWZOTWh5VVF6?=
 =?utf-8?B?SzQ1S2JTVFJIRVdYWUVLd1RGU0lyekNFTURPVkhlZmxJWUV4VHQ4MmJTdmxZ?=
 =?utf-8?B?UGxxZjJCN0ZIZjdkRllPemdlaVV4bHM1Zkh0NzBicXdRVlRyR2VEQ2pPaUZ2?=
 =?utf-8?B?TE54cVZpUWtueXUraXZybEhWQ0tCSXVzSys1cXUwT0VoMm1xdFIvOHVkR1M3?=
 =?utf-8?B?Yy9oMUpiNjBGU2hUKzNYMUhmVCtIK2d1cDBXbEZNSmZaNERxL09zN25hNkVW?=
 =?utf-8?B?YUswMXIxSE9FUElDQmpMdlRRRDJpLy9nellTZmpmMGJCOTdUNEN4RGRkWmU4?=
 =?utf-8?B?aTY4RCthcStnMFFJVzIrUGN1QkttVWh5TkpQcHV2Q3huUnJqdXNYU3hlbGNQ?=
 =?utf-8?B?QnRKYlk1NTNncGRldnYraDRzQnYvdmVFQ09wYkxtTVMwSzRLdk1nUElCckJt?=
 =?utf-8?B?eWluRmtIK081N1o1OHNDMGtXOFBXcFVTK0c2Z0cvblN1eXV5MUxuY0lRTzF3?=
 =?utf-8?B?eEEwU2IyU1lqWG5yZjNnWVYyMVZRTjQzcCtZM3NzNzQwWmZHVDZ3blpkYncy?=
 =?utf-8?B?NkZsL1R5K0NWbm1rOFFiUlBxMXQwL3J4a0ZzRTJLcjZSUTltWWxyZFNZVXdO?=
 =?utf-8?B?aUZpbDhpS1d1SWdrNGJxS1pqYU9LT2VMSysrWmJCRW9OWUFrL3lkRGRRL09U?=
 =?utf-8?B?NzJvMnBBL1FsNTd3OHppTEZQL2t4YjRvYWN3cklBZ2E4UlBLZWlqSGtyVFpm?=
 =?utf-8?B?ZEw5OThnd1l0dFN5cFZsaUJiZ2YwM1hJNUJBaStFTHJ6bmJSR2J6eGMxekJW?=
 =?utf-8?B?UmgwVVpZY05wTTh1ZGwyZlUrM0hPb3ZEVnpjQzdSYldpY09FejJmYjE0UURq?=
 =?utf-8?B?UFZHQS9KMlcvMXRWTVBLSE1tMzlKUDZnRTRCb0VFR2JkUUJ3bFM2YkJ4RUJJ?=
 =?utf-8?B?M0oxc21uRkVpdDlKOStTSUdMWU1Rd0dDZ1o4YXRWNVE0djBOTFNGRGM4UHRX?=
 =?utf-8?B?SjZDWTJLZTFnWDJsOTFJR3FGRytIdG1mRkRITXZvOHVHTld2UkxBeHBwMldl?=
 =?utf-8?B?V2JEWWw3ek56eGo5T0RMTk5veCt1N09jc1JhWVNMOWVDQWVUZkxpMzNXdkVJ?=
 =?utf-8?B?M0JkM1FqdlhWU0tBMmpoMXBsMDFObWNnQkhjS0x2QmltNFc2eE1pUXltQk9G?=
 =?utf-8?B?a2lOcVZDYlptNGtzTnM1bmhlSWVORGU0V3ZVU21rK2tFM3FQT3dDd0hZWkZJ?=
 =?utf-8?B?VGFMd3MxL28renJ3TkVsM0NvM0FqSjIySDBmSHdSOTVGOGhzV1lsclVwU1pl?=
 =?utf-8?B?QnpyUmRWTysrRzZhaXhZV2JQRkQwZlpnUlFYL2FnWm1vb2ZxMVU5SEhHdHdS?=
 =?utf-8?B?QTRkb1huUkFsVk11VG1TQm5NcVplWkppbW9KNEpCNjl6WEV5d3R2VExqMEJi?=
 =?utf-8?B?cVdyNmhTVk5QV3RvZDhvYmNBL2ZIcXBiR1pPM2w1RXNqQldpZnRsa3BIaTkz?=
 =?utf-8?B?Z3M0TmI2RzZWRllzOWMxUmIydE1IcTkxS1BkYXdET2liYVhFcU5VTEJaSUUr?=
 =?utf-8?B?dlRhNTdLQlYxRlk3Wi9mY2FMbVhjVXRMWjcwSGx2UHlCVXJacDQrSk5ZK2I1?=
 =?utf-8?B?NXk5UUo0eThlMVNHY295ci9KWTlKd21xTDNsMVJxbG9HVUQyaEZCMjlSbFl4?=
 =?utf-8?B?UjVOR3doYjZGa2d6ZTk5a0luYnFtS3graUd6TGFYVDRQRklhQkxDSzA3L2lm?=
 =?utf-8?B?Rm5kQzhRNUd6U0lBd3VZZVlaM2JhRWxDeU8rNTRhZ2I1TWJVTnlpUzkraHJo?=
 =?utf-8?B?SnpqSlVlWDBxa0VLTkVGbUIyS2tQSDNYdjZlRDZXczNFSm1YRWMyMGxrZTdy?=
 =?utf-8?B?WXI3cmZHLzV1N2pMeEM1OFdtYlZoWEpQT1EwMmUzM2dLMk5zL1h4eTN2SHhx?=
 =?utf-8?B?SFozVThzR2x6aTkvZFM1cDBiM0RJaVBaODhwS3R1MGJpME1DS3FVUEl1eTBB?=
 =?utf-8?B?YThLeXFYb2hRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dEtQcE5JTk55SHIyeCtWbG5GV0haT05FWGthTmN0eEhFbWp3bThyYjNGenhG?=
 =?utf-8?B?cldKN2lUcjBkaWpzV1pxTW9UazVMSXo1dkNtakRCVDZSTHc2NkNiOCtVN2dE?=
 =?utf-8?B?R0YrWEZ2MUdTYm5adHNqeDU0YWdZcXdJT2o3NFlsVThPUXk4Y1dzbVZPSlZI?=
 =?utf-8?B?YkhTRXJsbkhKbUFlZmlCZnJiWUlyQVhlelFzaVhCWGViMVRlb0lPQUNBOFFk?=
 =?utf-8?B?bi9LYURmd1ZRWklyLzdOZFRRZWxOazBNbW5XZ3lVcUh2QlRBK3NPVThHMUg0?=
 =?utf-8?B?ajBob09ETDNoYStLSzk0MmpuNENBY1kwVndMMi9qQTgreklNVXBzUkdxYWpJ?=
 =?utf-8?B?aFJkYldZUldZZDJ0SmRBekRaaGt1WFRLME1EU2lKQ2xKUmpGeG90Z1J1VllT?=
 =?utf-8?B?UmU3cXFQZU5ta0lwVnBaRzVOdG5DWlZvNmxMWnVGYVJBVGtOZFBOYmh0ZWF6?=
 =?utf-8?B?UGE5bzQzTWVCSG9vSHRjU01IbWRoVmhlNkFEcG1HOW1DOHBpRzZmTzZkTm52?=
 =?utf-8?B?dCthb3NtS29TWWwyRzRadVpiYktjdWZDMmFzUm1ELyt3ang0bVFadDFNVWpv?=
 =?utf-8?B?RWcyMU1OVEUvSjRqMDk5a1hIclF5alhhQ2g5TDFhQmMxdWtQM2NzaWtpdWkx?=
 =?utf-8?B?aWswbGVlbTBLNlJHK3o3RTZBc0Y0YjRVcUJsV2JTNm43cmZTNGtBaFk2RDBJ?=
 =?utf-8?B?cjFod3NMUHpZUWNxTHlwZnV0VDlIRDBmZUh1UDVBbCtRVEhnSUVZakN4dUpD?=
 =?utf-8?B?SjJwM2pqSVd5VmtndjFxRFhWYXdKbUhiRWY5aWl2eVlLS2JlcXpta3c4cUt4?=
 =?utf-8?B?TWtxZWN0b21DNG9SakpQTWhnQ0Rjd0IrWjB0eDhHTlNYbVdjTnVDMVpxY0pT?=
 =?utf-8?B?Uk10a2YyUHpSOHIwcEFzTzcrTVdCT1F2eXUzVFdxVlU2YjJsVG95MnBYUUpX?=
 =?utf-8?B?dW04SzJPeVRvZU10YjlQOTJObmtMdmc0ZDFMM2tGbXZJNm03a1plbkRwK0xH?=
 =?utf-8?B?UmRTTWZzTVBqUFlTM2J3WExZUTZXOG1uZzNaWXlFTE1pY3dYVm45NFZRUWly?=
 =?utf-8?B?bk1mNVZudGxEKzdndHdFOEZBU2tXWnRYTVhOaEZoVFNQRVdnM2FRd0svdXV6?=
 =?utf-8?B?MkI3bEJwQkF4Q3hRcjFyZW5HKzc0ZnVpK0dSamQxZlN6WG43VzRrV1JVeWNw?=
 =?utf-8?B?dUljS0VCTHZFUklLdmNKSHduaHBaeWx5a2RINGNBTFJETllCb05lR3dreGkr?=
 =?utf-8?B?cTJGbUQxZnpzbExjbGtGQzJENlBTbDlkaHppQkhCc2l4VlM2RXlKeGRZNVds?=
 =?utf-8?B?Znh0Q21mc0FKUE14bHFQeDVVUkRXbHdKT0NabGxRTjNoSXNIYVhuS1ByT3RV?=
 =?utf-8?B?akM4QVl2Y1RzNGtQKzhWUjNTY2kvcFJtQUlja3BGYjl4QXd4OW42Y0dza2pj?=
 =?utf-8?B?N1dSS2hsbzBTeWNiakRyZ3IxTFF6RzlvcVdrWDk0YVh3c0lIMjNHYTFrN0tP?=
 =?utf-8?B?eXJnSFh3cE9oZ1FTd0FNVWtQMUJ4VEFpRHo3eklyL3NuNjNZZHNORDcxSzE2?=
 =?utf-8?B?cHg0NkVZM1VHOThXT244NEdjWE9rNmxyZnF6YVVGV1ZjZXd5Mis2dCt0QVJE?=
 =?utf-8?B?MGI4Zk52M0VFT1N1VzRmMmEwN0FzdFVXcjg4MDBiU3FiZEMvNXFxWlJNSmFV?=
 =?utf-8?B?cXBpMXBobU5adzVzd3FlaWk5QnZxeWNWL1ZmL3kzTnByZVFhWURraGs2d1R4?=
 =?utf-8?B?NXd1bkZ6aWs3azdVc3c5eElrdm1NNGVoWk5POVZrUldRNnhGYjMzZmg3ckIz?=
 =?utf-8?B?UzJPanV2elJMNENlemNjaGk1Ry9nWkJSMTZOcVRWcDZvb0E2bWh3U3d5aXh5?=
 =?utf-8?B?M3doc29lSE85d0VZdXJNTnJEMHNrQ0lzTUJ2NVdUM1ZNNmwwS2pxZHk4bWNi?=
 =?utf-8?B?NTZGcW0yZDd6TmdFR3ZPaXNNdlFpMXJZREM0Z1NxVzRMZU9NbSs2TDJ6Q1pr?=
 =?utf-8?B?cGIrWlhReFJGSSsxV3FiSzZHTlF4T2FKV1dEeVpkMUZCV0JZVDdiOGVNZ2hs?=
 =?utf-8?B?SVQzZGRJZlRCVWRZZFhVc0hraUowbkg1RVEzVmZPdWxxeXVaK09FS2RPanRD?=
 =?utf-8?B?SVJrTDUrcHdNTmNpSHV2eC9kS2NzcW9WeWthbVROTnRqYjRZaXczdGF3a29Y?=
 =?utf-8?B?aWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ha0SXlxCAxBiLMKWprELre1cqDZ2n6oDpMezJpqbRZniDhtIakym1gujoBrfztGNmaW9hjSpoEU5NTFlJBQ6VgFPOl3xhYFleGKbTFYp2ba3fIVZgDI8rJ5cJ5jAk4+gPoXN1HJlROQpjfz9orEAF5w9ke5J8CcUDEdXLrLQ86TlH1FB/pD7lrIxAkX+k2Y7nPdAoPVNAa63RLPD+ZIMfdC+lHSpZ0qiFO1rGMc/oI8dz9yRGBkXpfeaW3oWMdRemmgxVHFTbiv8IbqlK2KN/L5breoKxC/OZ3nnO+SAfmOEQ+dVg7zAAHzDR/ZGHKOdFqvfpPIw/VP60jAWgqgzRxgSifW20ZM1u7c7z+sxSd/ghqq8GKO1sWJdCf87yH3rldhexfj2a+G5SZVNecGLOUd8GyUqBM/vNnTwUaJ/7kwhXoxsiN3ck1drPzf4i6eKpPYa4D8NSm6A7fCC01z+r5z5Afgdg5S0fdN1Lwmp4u0sQPOp0PuibMXEAi3LePPwGf1QBRsQrapBptNHSJ/bfD6iNndZN/MjpmxFuIlWIh/UYYHpWFOTqEU6C/+Y36ygf4BpyvJHm1i8AocUIyFyvWcjFR3shCU7ZknyYizyg3w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c83f71e-3d94-4bcc-c771-08ddc05c8395
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 09:22:53.5395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B3RQzSIQPhsd3OLgB/H7lkXxeW3O+5pDsdRSG6TwR2exYZciZJreGPsb+wVOBgsQjnok8Ku/EJ1rCaw/stb6/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6472
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-11_03,2025-07-09_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507110065
X-Authority-Analysis: v=2.4 cv=F/xXdrhN c=1 sm=1 tr=0 ts=6870d7f1 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=-K_0Cq8EI3eHA1kgPS8A:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12062
X-Proofpoint-GUID: 6IEP77Y88VOR5KKeICKEAE82Hvrwojzf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzExMDA2NSBTYWx0ZWRfX5MDBqoIpBGpT AhAsvz5KnyFaB1pjZFAH/BNHkE6lKiOAHeGKPsMLQp48baSDEV5Mp9aKojGmM0ZTSB2ooeNNCQZ M68GiMvqGgcbVzQTuw/3cZW4N2xbaKA/B8ilMoFCvfp33KjnKAJ3MzS/dbMrgfjBc0dfeET+w53
 k3pIz3u+v6hFk+ZXzPyNPVOSccFk6Vy1ndzdR1ZwwjtAHAPAXsiTJF3H+7l+FJ2W7jaZp7omMKE 2QQ9AO8ve+E5VmD/F0paulnyhQnW0k+23iXLzoyCdgyB+bjoKITBzwLPox0FTMQ/MZvvOjczD/2 YjfvQXIUFqNXTBZwBTNxFhYtmzyAe2YeV1mD/S6eHPQ6GAPo8gpZ8K/1eRJCowxQlFpDH0ds771
 5vghn/ljk8K6lJU/1hfUJW33y6tN8Qzf2puMsETlSK5TX/oliBiQGR9sJL+Zea9e8dggMRlB
X-Proofpoint-ORIG-GUID: 6IEP77Y88VOR5KKeICKEAE82Hvrwojzf

On 11/07/2025 09:42, Damien Le Moal wrote:
>> diff --git a/block/blk-settings.c b/block/blk-settings.c
>> index a000daafbfb48..a2c089167174e 100644
>> --- a/block/blk-settings.c
>> +++ b/block/blk-settings.c
>> @@ -180,6 +180,7 @@ static void blk_atomic_writes_update_limits(struct queue_limits *lim)
>>   
>>   static void blk_validate_atomic_write_limits(struct queue_limits *lim)
>>   {
>> +	unsigned long long chunk_bytes = lim->chunk_sectors << SECTOR_SHIFT;
> Don't you need to cast to a 64-bits "lim->chunk_sectors" here ?

I thought that we automatically convert lim->chunk_sectors to unsigned 
long long, but I think that you are right...

At this point I think that it's easier to just convert 
atomic_write_hw_max to sectors and do that comparison

Thanks,
John

