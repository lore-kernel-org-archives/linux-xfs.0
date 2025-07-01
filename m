Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BF551022
	for <linux-xfs@vger.kernel.org>; Tue,  1 Jul 2025 10:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751367237; cv=fail; b=TPL+rI3TfHy9GTWLyLwheg/alU4oN4qeDjHLTeYI0QOzWi3zSdAWyhuG3MzwVXqAksCKjqqRajjdODEv3Jl4iOwBe3URmp4Fm07fvOm4WFPT1UDi88Jjc0msyXZM4Jq/CHc3gTiD+1ELA8eRHJjvW2onGigzsBjb+txSL9iej9I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751367237; c=relaxed/simple;
	bh=QjvtCkMiIaCaZs9P+DugFUZEbpwAe3sRxXgjt6vSKak=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MRswJph/QR+q7r3RckKOZbPzyf26VNroG2yL7jto79Z/EdH7YYcF5hHOb1CLh8plh7RJPHgzUgvavH1dbIBh0EPijKhHZA44rSNzx/uL2Ra9THiImMbxl4p9GbVN9VOowMsQuKw0V+fzLMpA29vs/RdSIZPvcj6NcT7nwDsnuRU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Gw+PCC9d; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=t4fiDCMR; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Gw+PCC9d";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="t4fiDCMR"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5611OrLh007225;
	Tue, 1 Jul 2025 10:53:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=m6dikZSakXArSrS1B6CZr7Qt6LxEQVv25n1nExe91jM=; b=
	Gw+PCC9d54W6tHnkfUg2NJGuLdZ1BJpeUKFkD+tpZENfZ6xE1AhmLOqECaw8/XDb
	GFnghCuPwZYbwGEdalqB+7espWZGNKeZj+G5Y5w2tI0fiTZ+2v7kAAWocI3gkpC5
	hOLR83oUDPntLKS1Lpm7Gtwt704HPWRM6QcPY71vurX/tqk1hh1ebnKENjUrxi3u
	NyoADbiqSVpVQzAHq/Djit3u4NP3vZyIyFPq2c690ZIjIP/3Q0ocwstb1nb3BV1F
	AAXHyAsbkdmfRpxNPsu3CJ4Wotd01C9mZRHBtKGCquZkCFSlr10ntbaJhOxclHKl
	N8YFkRb4y6PAzoVaJ6VGdA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47j7af4gsa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Jul 2025 10:53:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 561AW7i8009035;
	Tue, 1 Jul 2025 10:53:48 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2058.outbound.protection.outlook.com [40.107.220.58])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47j6u9m480-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Jul 2025 10:53:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tJafCrH57MdsjmhB7Un2TI7RWfOiDzEn9SV0J9MRq4t/WDH6DC53BO46Uoet0RfVT9QpLVb4Q2eh9NvidpIGMQMlpHb2AThc+fAjMh1brqC3R0bSTuiawkogITCscKMHkyH+bQ036rkxdPR8RbIV+gK9w2fjewG95HimkWu09/TQV5zEIvaVn9Gxf5Eph7jhANrVwFkaNa+70P+Zpabm87Yw4SbU2d2tQZHp1VESxT/e/YVCjci9bceDnSKiuKrKtHHZ0plUnFFr6fZxLURtkC3JzIV53aKMTsAfr8gPjU4Qpux/5DhLKtCXi+0XuIzKUeetGjPlfhEIzzyPPSOM5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m6dikZSakXArSrS1B6CZr7Qt6LxEQVv25n1nExe91jM=;
 b=MlMBTz4icPFwruFJhl4+LO5bN744Y1mgieGE9PNw0LUmQ0Mt7YlrUPqQXA+nS801b5zBerPASATRp+gmER6j1r5rNZKeE96qgAcKF4Q7Nx0DMqjprYM73GqZ+IeLu0n8XNt0ai3hVRDM0K8gXw3w6CD9HRdSc9OyMnF7Px9cNUTTfIQqnu5Jk5gUEQnFHAJm7FyXGY4Pp+ipsqNkoV7Es9EIjDKPB2yGpLDqQbbJXPTc97pBLRt2yhsJa8AfLFrLcBpHHNe9NPRvESbfaxxpgB8U2T+9HNOJDCoKmTlrcClq5qQQ4jM6hhUoTOVO1+oSFokXWZScQzEeVlfsDfx7Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m6dikZSakXArSrS1B6CZr7Qt6LxEQVv25n1nExe91jM=;
 b=t4fiDCMRc9jNn67uIftZFJvJWi0OTfvXqP/rv9clOyey7nhb/nw5Woou1UHLHE7N54gjEt5rR44AwGbm/AgXi6DKYTWQF/mzLvLvKUUX/VzcIKD+AU8d9Oza1RKcgDw0Y56n1pTYiSHg0HYbhB/4tFBhkey4lYBJbr7q/yW5LYM=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SJ5PPFD020A49E6.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7d0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.24; Tue, 1 Jul
 2025 10:53:24 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8880.027; Tue, 1 Jul 2025
 10:53:24 +0000
Message-ID: <508a9ea2-1c45-46a8-a0a9-ef8c3c2ba04d@oracle.com>
Date: Tue, 1 Jul 2025 11:53:20 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] xfs: remove the call to sync_blockdev in
 xfs_configure_buftarg
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
References: <20250701104125.1681798-1-hch@lst.de>
 <20250701104125.1681798-3-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250701104125.1681798-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0012.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c2::19) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SJ5PPFD020A49E6:EE_
X-MS-Office365-Filtering-Correlation-Id: e57e1617-0662-4fad-12a1-08ddb88d8037
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QWRHell2MS8zU2hnUWNhb2U4dlQrdVBzS2xnWm4zQkEyWWhFSlFnYSt0NWtv?=
 =?utf-8?B?eml4STZMWUpnZGVXbklXTnlHVlUveVFCVlI0U01vN3AxdHVUdEJ1TXBUUGN3?=
 =?utf-8?B?eW5nMHVIZGlTaDEvZkRIRTZ4TmJqVXJ3SHVHdmdlZHlqcE82TUx5TmZRbUJq?=
 =?utf-8?B?djM3aXlmSVhOdHNhNWMzZEpscnhhcjJmaUQwL3MyQk8wVlY0cjFjUlNVOTJD?=
 =?utf-8?B?VzNrc1cwS1dRU2dBTzM2UTZRMURmcjdVak15Y3lVQU9BeDNWRWcvazZvS1Uz?=
 =?utf-8?B?K0xGL1ByNm1ISFhoVzE1RjdJOG1Yc2oxeW5IZXdhRFJtbWNSU3JucERKWk9v?=
 =?utf-8?B?eWV1dkU1cGRvaGZIb2tnK1QrNVpxVGZPb2REMWhoSUowMHM5endpWXJYVU5R?=
 =?utf-8?B?Q0FsTStWaDRERFhTSnRLZXVIVUZqSTd3ZFhFK2YveXk2WU54VmFzVFFVTGR5?=
 =?utf-8?B?VzI1c3ZVc3EyN1pzSHZIelFCS0s3VFdGVVZWcXV6TzF6NEVlK016UktkejNp?=
 =?utf-8?B?eFpKU0xIU1k4OCtxbWlySzgwWGsrN2ltdHNkQStmR3VTek90cHRZZGJGSHRw?=
 =?utf-8?B?UFpNU1Ywc1JFVWNTYXlUejROTUNtekhsTFBkN1lQZHduWVRlU3V1SGxYYzM0?=
 =?utf-8?B?N2RjRVlhbkdPa1VsZ3VoMndYam80NkhRUS9VSWxOdUpNOHZRb3dYMWFEMkxj?=
 =?utf-8?B?MEtqOTFWZmhlNmJ1NlV2NjU1YlRrR3RSdUd5Z1l6ekhKRm0wdW9GdEFMK3JQ?=
 =?utf-8?B?TmwzWmJmcXRIUVlwbXlJcENEaE12dG1OcnNPd05rdFdQNnc2MEh5ZCtjU2Fq?=
 =?utf-8?B?UVlhZHlkMzlTM3VWcE1IVkViNDBmQ0JSeUsyaW10czV1QVpIS243TkFnQXpD?=
 =?utf-8?B?TFAyRnFnNDQxUXRWZ3FqWmxPY21lQUdQelQvWFRvc09lNGRXY1dVYSt3bCt4?=
 =?utf-8?B?a0xmd01kSW5WSWlNOG05ZUEzN2h1d2N5MUZpSHVhQjVncGFUejlBY01QZFUr?=
 =?utf-8?B?Wml1ZkdqUkVGb0FONWlYYUZ0UFFrQTlMM3FHYmRDWW8xNjNaRDJqRW42OXli?=
 =?utf-8?B?eGFUMHVXem5LczBsQjFxLzFvL0JWY1Rta0tkSVBwVGNCdTRYSUplRWRZZTll?=
 =?utf-8?B?MkNuMlFtY1ZEMHh1a1RNMm9DbDNzSXhtRE1PVFRtT29GbFBTOVJJY1J1RWE4?=
 =?utf-8?B?MlI5QnBwdHRwVkJrQzQxbmcyME9NbjhsNk9aZG11MEdYOFg3azUzOWh4OFJM?=
 =?utf-8?B?Y2hxVUJEMWJnUXdBcVNOUXVPNnZEOFVmK2xYNHMrbGtLUkxZa0xBWThDVTdB?=
 =?utf-8?B?WnN0ZkF3SUs0Vm5MOHVncFpHT0ZSTnZUdDVmcUcvZ0pDWkJSNFVPaFRibi9C?=
 =?utf-8?B?Nm9rS0ZESHh6THlOdDF2R0RZajlOOUJ3amFWSGl0ME5pYzBmT2QrM0t2Um9o?=
 =?utf-8?B?THBpcHRaU0NjQU4zYzBSb2tVbUdNeER0NUU0Z1E0Y0RGMURMTllSeGg0SXZm?=
 =?utf-8?B?cU54dEM4NnZHL2ZoWjJtV3UvRkh2VXBacENUNmU4ZUtidzJLRkkyMTArWjc1?=
 =?utf-8?B?dlJ5SWlDWmxhR1hxVjl2S0o5Q0greEgvd08wMTNuU1hvcG52ZjFlOHJ6Umtv?=
 =?utf-8?B?VkZYRTJPako2aE93citXZkx6a0tSSWRVTHZhVmcrSWdqUDVoOHRCSkwvdkdo?=
 =?utf-8?B?MHhLOGU3N3FxT3VoUXdXZjBJazBsalhwcEFpV3hqOEJiNlN0NUcxRVlVK1dQ?=
 =?utf-8?B?VnJienAxOVY5MHFlWjA2N1NwZFVmMWg3TEdCSTJxVjdCZEFCUUJwOW1TSkJU?=
 =?utf-8?B?V0k5NEFuR0ZRT1BpWllJaXhvRzZZOWxEVGcrYTQySTI1WWRtUmlvV2xrYW9Y?=
 =?utf-8?B?S1lUYUZRN1VLbEJaaHl6QzJ4UlhUNkxvK3lwM1Z0MzcxMm44ZitKRkhaYjYx?=
 =?utf-8?Q?/buCPoa4E8M=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TDZzZXc4aHU4akJrb3pGT0dsajRzSXl2Y0pvMER3TXhTTzJaZTVhUFo2blRF?=
 =?utf-8?B?S09QcVZIYndHYUhuK21hWGY3ZFE4UTV0NGZKcTZMMXN6UHRVWlFmY1Rua3hZ?=
 =?utf-8?B?TTU4QTZxRkkzM3F2bzlKWnFrNUpXS2xYOFYrZUpvbmVCMDRRNm1yS09GUFNB?=
 =?utf-8?B?UHViSllkQXZWZ0ZoQlg5c2Fxam5Pc2xsN0ZmQVF4cnJ4VzVTeFdOUXp4bGtx?=
 =?utf-8?B?anNQNTJqcTlLRnUwNGJJVjdnc2Q0bnFYR3lZV1d4Z0tQZDZvcHFCcjVleVFz?=
 =?utf-8?B?WGlKVXlsZFpZcDM3K083cEk4UCsvRElKRUthUkRQS1QxUUtBOWZCSGdERVMv?=
 =?utf-8?B?cVNRKzlJOVJnbnJUbGF3MmZJQXl2eVRCdXFjcEUrcktuK1pUTGE3czV1QWRH?=
 =?utf-8?B?OHQ0SFhjeWlUSDBEZDJQbTR0NERsbDlpOFVPU3lPWWY4QUFPSUxWNUp0MDcw?=
 =?utf-8?B?cXowODQvNHNZblVRQXpVeStTeDQzUXBlYVR4VmU3bHhsRHlCUmtaYSs3K0tS?=
 =?utf-8?B?eThCNTNnd21QdmZlMlBiOWlVck9waGdVZC8zYnZRdzBXTFRuMGlNcFl6Znd6?=
 =?utf-8?B?bkhJOTFlcmZVcWpQMVk4czA5YStNendtTnZHZWlJVExGd1dhWUk1V3ROd2R2?=
 =?utf-8?B?RnpjZW9TdHlsTWhXUXFoeEtLRkw0QkFlUGN2RnRVdjhuUkRUMElxZWorVlMy?=
 =?utf-8?B?SWpzYll1SDVRSG1IRXZ0TkR0Um15RVpKOFMyektvM2xFL2psTmhVQkZzOUh1?=
 =?utf-8?B?MkhqTzZUTGxqdCtkOEFhRGJXM3BMZU9lcjJPUS9CZ3lDZ1lkVVROMEsxMEkz?=
 =?utf-8?B?alBydjZpYlJ3SEhKd3VVcE9aazZ1V1k4M3dPTE9SYitHcVU4Y2hQdEZNcXBk?=
 =?utf-8?B?QnpncWYvRWozMlF3WjdTZ2Z6YkJSUHo5T3NXMFN6R2NTY3llOFdTcStzSDB1?=
 =?utf-8?B?R2dRRStBVnpNTUdBQm1HRHpXN2NHaFpxRVZzTmdiUmU1V0ZuK1Y4NGNoWi9t?=
 =?utf-8?B?MGtJNDlqTWhOZThZR01iU0JDaUJmTVZRK1kyWnRhZmFTMFp5cStqVWpIVHRy?=
 =?utf-8?B?THp1ai8yTkpHMXM3L2lxRTNiaTZ6UVpoc0dVZGJ6Y2xVc3ZRY21PSUk0Tk1q?=
 =?utf-8?B?Y1BvMnlGOE1UbzJLNWNBZXJzSHUyV2NISFliS3VDMXBQRXA5UkZYRGUwM1d4?=
 =?utf-8?B?bWhhOW1mdzc0V2I1MlFJUm1DOGs5aXlaQjgvTElNUDQ3TDVmUE1UYzU1VVBV?=
 =?utf-8?B?V2l4azc5bXFQQnRTL3pZd0QyaytDMzluN3F0SE04bEF6RXVoYUhoUVBra0hX?=
 =?utf-8?B?K2w5aFRmY2hCRE9BWVJ0eEowcHhhTEQvWFBSSzZZUG05RTU4WjRkQW0zRW04?=
 =?utf-8?B?QzdIYVRJd1J3N0kzR0ljUS9xdGJEVDI5b3ovRXdRNUhUamg0VjAwUUtaNHdw?=
 =?utf-8?B?NXVXYXJSVUo0L0s5V25BZ3l4cXBWTHgxZkJETmZDZXJ4WnRqdWh0b1dXYWYx?=
 =?utf-8?B?Qzgzd3lsOVVYbjhDV2JWSVdHYk9jVmZvRkdXdC84Q2s0ZjJIcWNFODcwRjhk?=
 =?utf-8?B?dG1aMU42TlNySy9UY0x6SGpCTFNReGhvcFMzVEpXNjBrRzRpVW9YZ0ZRRzE1?=
 =?utf-8?B?cjRTcGVvTHM5aSs3R0ZvL2YvZVBOUXdFQzg2VmVDNW55VlVVa1dVcjF1TEI4?=
 =?utf-8?B?c2xjZzNrdldEckhZZ1Ayb3RyQ2hDcDBVSHpLQkFGV0JEWCtzcXdkZjlYd1VQ?=
 =?utf-8?B?OEpvMmMyRHI4N2owTVhLS21tRjIvTGdPMDBJTUVJUVlVR1k1am5CbXcxdGo1?=
 =?utf-8?B?MlRnL3VZSUpQL05CSmE4aEdERUJJbkFic3ROWGpwRmI0eWxuaGRNWFkyZW4r?=
 =?utf-8?B?aTBFUWRFbU03OE94TnFXd3duQmVxaEpncHJ3dThWZTJOMndLRmIxQzBLWDVT?=
 =?utf-8?B?dzlLaDhjd1JpSk9aWXNGd2VoaWM5Q1BrNUZrVFdZYW5DOU1lKytvcG92eStv?=
 =?utf-8?B?VUpXd3RRWUs3aWQzdDY0bDRMaWRCWnNkbGRKTURlQmFqNmFiUHM1OGxSMWl4?=
 =?utf-8?B?UTFxbFV3RkpXVE5DNEsrakJPZ2FDVGRiS2Jobk01WUZvT1UxUnA4UytjKzY0?=
 =?utf-8?B?bms0UXAyTmEyUjkrMFI3RlBDL1F4ZEkyWjdsVTVmYjBCamUwNmdYMmx3TWZv?=
 =?utf-8?B?c3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	n99Xl9/MvqDapudfCBB4HOg6G6QgkYlpSomswPmsmUt5D1Y9ozVLMmw6v4J+tX10OL5IE8vzv0Pa+w1n7UwwQK/rflQnqlK9Hgr5um/JDwrqQw6sZCHskHZbBng+WUaIp63hEAQqZ/5TwdcdjEyaP1n/QwwJ6Ly3hj5BW0VtxWR2NojbaH9SceSIsDDbnE6YmSbEXTuwz3JZeGAwjXt03JLDoZpuSt0Tt5K1+wZp0E69UE1ryiX+9RkNyG/GjuKNZLOj5kia0lmoQ5iRHEPm3lAND+HVXSaqIXpLpJQPih6Gmlc2C8xNQ2FPy90Z1fYJnH77kBXBbhjgGK63B6xdUFfYpriVxic9AqlIBL1CzbX12fHlX3IqinYFeX+bIKfpi3mOSXtsd848ZJHPi7sT4t/LZVbGS02e4K22xj9VdgArrgwdvnHIw/yGI1cYj6RB49+2d0GDwG1y74wOzzTPODL2rAo/AB6oJ65WHQ7lpkzfAM5jrd+kKvQlNsY0ovnw6maMwFbTL2jvAAq/BZQYFUEfGPngZXgbAhgyhzAg6emVHV09MD1tWtyretEnCvxPA63sTpH/lHqG/jlWCMPFejm4wJP9oLZcTDpMd8QkTfw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e57e1617-0662-4fad-12a1-08ddb88d8037
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2025 10:53:24.1756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h0aAnd1SGHFycE4tpQMIx1dZkUnY4mX7oh0CCLV2PsOMAcuEgmCv/niIjRviFgPxGQr42ZU+otHwc6YMOtbkTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFD020A49E6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-01_02,2025-06-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507010066
X-Proofpoint-ORIG-GUID: xhtTUMxepsAG07t0wkfTDgPFBpJmJqhD
X-Proofpoint-GUID: xhtTUMxepsAG07t0wkfTDgPFBpJmJqhD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzAxMDA2NiBTYWx0ZWRfX59UTHkt+UkZz NuD5VYBaU5KxDx2k+CvnA/P/j6r5dq8ROtCeSrnLx/n6nwuzzHfr5YXKNWF7tUfsgBWZat8F0nq rZMl8yJNCpvbPz7P6BV7yBvbfCLZrSGefyNS6LGqljUvhPKqoJIuQdEgn2XOsz0fEAPNBV9d1he
 dFWGZ7X/Yes6Z/f5zseo5nvqGXh9FhPBl7P2UXLhBXvrAWZlxWYwyPhYuBE8ENp2b8zcVJFjbcW SDX0+Kb04r1TeoZuk1O8buTPZMcJ509w2N18CaIV/61aLlTj31WSGAVWymeZ/bbHhf5sKwwOSgy a4Y6OVU/QDCKpGwzXstsYJ3D4s5onaZZW9+zHf159VpiV3hpJaGi0eQsrgvz9Zydi4y0BkBBz/m
 A0agJAjOS368nJNoIMN4DOxL+gLkGDKHdzHITfNtcyPgfJMkEdQmdhOvFYQhqFCwJXKnBKol
X-Authority-Analysis: v=2.4 cv=b5Cy4sGx c=1 sm=1 tr=0 ts=6863be3e b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=MrLvtdr4cProC38NKlUA:9 a=QEXdDO2ut3YA:10 a=UxLD5KG5Eu0A:10 cc=ntf awl=host:14723

On 01/07/2025 11:40, Christoph Hellwig wrote:
> This extra call is no needed as xfs_alloc_buftarg already calls

not needed

> sync_blockdev.
> 
> Signed-off-by: Christoph Hellwig<hch@lst.de>

seems fine, so FWIW:

Reviewed-by: John Garry <john.g.garry@oracle.com>
