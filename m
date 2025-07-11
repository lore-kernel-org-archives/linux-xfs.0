Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB85273D78;
	Fri, 11 Jul 2025 09:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752225405; cv=fail; b=mL8xy5kRx+M8tbojrW796HOUgjH4m9hb4Gwk3Fk3mYlUl53oWsuYiyFvDcnf6HdBusWjqpEtFJ+CbtJZFrblRZXhqdZXBlvIBv0aBRjgxPwWv7vaaUT4nOGX4EpjGH0l3aE/3hHaN6Y27guCfIi8YK6/rU1VInCae1LgLd4ghvo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752225405; c=relaxed/simple;
	bh=9Icx20IAAWwvO1oIA4OvPFiNBh7cLCW0wXJ72O0Nzic=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=S9DDk0uzw5aCfBvw/Z7oYKYQtvuQ8CopN/bpjLovVlizzvO72CnBOQznm0LglJzkRJQjFIT++6nL4t/smDiAz+9mST1TfkQdYZq5h+Mz1sBI9Nfq8T4x7ZdCpz4FG4QejC9JGZjM6mTioDozFXGwyGvqJqujEwragvIUcvWyC3I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TmauPcez; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Cw6OyzTh; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TmauPcez";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Cw6OyzTh"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56B8vx9I018485;
	Fri, 11 Jul 2025 09:16:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=N4AcqxcF8rje8GaYuvYxzToo5E8Qn+Ye6T+9cKFaJBw=; b=
	TmauPcezHl4nEEe9AkScC52I4n41lCFIxKQwBtz+npBjh8BKaihMXTGnLxLBn85g
	yB8vTKQxBOCiRUf+4XfQZGf4pN8bW9GVE1/l7ffHX0tPvbAm4GAo+snZNl/RX63q
	H84KnJeKHaUWdNrX4mrolDkUAWaYaZ+Ur5cavWQMSADCqASUwn4xxJqGmEoWR7LP
	ru0Sy8k9DIiAlDjgGxhxxR9ifxD+O3sCKA7WlbS99LzYQYQ10o2zOFzVNhOiq8DE
	DSKYMPhAbViIgk2aH60llvPxUjNelqiLTN2rtURp/m4JL1/n1yH14V+ooTfnbzog
	ptxEmlSh9cqq2itsTTCeTg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47tyj50139-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 09:16:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56B72f4v021384;
	Fri, 11 Jul 2025 09:16:16 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2041.outbound.protection.outlook.com [40.107.92.41])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgdagr0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 09:16:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h8UMXVa4lbIiM4nZS3+MgNfHL+FI38wC64TZjYpHazQ++PZLCZlsnaAL59Nvz72bDA9TtRVHJTpii7wZ/u/OyRQTS0fR+gDLFHoIx6ZQXkde+rgjuuiFYYQgowhTJ76CEgKbxJ19uk6O3h+QhXYDW1YWUmu1n8NR0iidAFVyXB231vlJIxbaTkAE4KEWlPqe49YGgTrJChwf9PBt4rdUa35N5uM6mHi4Cs9O9FTnUZNbM9HiEzQrFLwEOyLVCYN0u46cxzc/u6+O2lhmtsRqXGXe4+z2n6Fpi7Vvz+3q/qXVjfma1cv1LKDa3hjU6sF15MixMg+JVMeFzL6BRm0kkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N4AcqxcF8rje8GaYuvYxzToo5E8Qn+Ye6T+9cKFaJBw=;
 b=J8Rmfi+vnMW08SSsBFcKwrZN5VkNGeCOxygDeTkqxmY9mlWqQ58UCIrYZdQgRo0Iyj48T53w5foIgdqPPhju2irov7t+Ds1CzgPeSA5Oo+u3bpSadAi9jg3jcCdtNig0BZsCt5PWPDEUh1rDUun0Cvr2rygHiLwaJL0wb7VJhVll/xAzhnxWaJNqsg7p97uyklX5KYOp/PSMKRyWWdXVEv3GQtS9dLG2La3c+xALNbAg1F61xpNk6xZL2GqcPbWlBMOehaT0FrbsdhwglqokXk8i1gabt/fnHXQ3m3mFQMvLm1w0MQ/TqXh7iFRR0iscH+W1N8pnAsjelnQFURlQ7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N4AcqxcF8rje8GaYuvYxzToo5E8Qn+Ye6T+9cKFaJBw=;
 b=Cw6OyzThkhp4gw0iiZJrKQhMlQeAT2j1FU94mrzA0VS8W+dHdkcs4KE8cUaTpL8nxOi5BO1WMTUbfvxp6nwD7u5v5l3AK+ucS4tVXwXI6Wc6QKcNPlC3ZPCR8TUDJFjpscm9g20Mv+IBX1zD9lkAb95hM/D3TSuHWTxOpVEEgaI=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SA1PR10MB6472.namprd10.prod.outlook.com (2603:10b6:806:29e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.23; Fri, 11 Jul
 2025 09:16:13 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8922.023; Fri, 11 Jul 2025
 09:16:13 +0000
Message-ID: <28469095-127d-4d2b-b4b8-d83192d74951@oracle.com>
Date: Fri, 11 Jul 2025 10:16:09 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/6] block/md/dm: set chunk_sectors from stacked dev
 stripe size
To: Damien Le Moal <dlemoal@kernel.org>, agk@redhat.com, snitzer@kernel.org,
        mpatocka@redhat.com, song@kernel.org, yukuai3@huawei.com, hch@lst.de,
        nilay@linux.ibm.com, axboe@kernel.dk, cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        akpm@linux-foundation.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org
References: <20250711080929.3091196-1-john.g.garry@oracle.com>
 <f80713ec-fef1-4a33-b7bf-820ca69cb6ce@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <f80713ec-fef1-4a33-b7bf-820ca69cb6ce@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P191CA0013.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::8) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SA1PR10MB6472:EE_
X-MS-Office365-Filtering-Correlation-Id: 9341915a-203d-4365-99ce-08ddc05b9505
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YWcvUjVlZWhqM3h1YkdlY2d0SlN5MUJDN1hVUjBBVW9xSC8xYTRuNzdXRG5t?=
 =?utf-8?B?OHdPZ2FrbnYyTkcxOU1zbUtDNjFnaG5aekpPbnNvdXpkS3NaQ253VXc2NnRR?=
 =?utf-8?B?bGdJcXNOaUc0K0tVelc4TGxxTWUzdzg4cENIY0Z2UFVCRGVzY3EzN0lKVTRQ?=
 =?utf-8?B?Um1tL01zU0E3ZFdFbjZrbUdodVJEcVVIREhXNUN1c1JKUkthWXovc0t5ZEht?=
 =?utf-8?B?SDRlTWdGM1FQbE1CNHgxK1hoUE1uY3I4ZlFUcC9aVHdCNng2eDluVVM5ejU4?=
 =?utf-8?B?QlBreXExTTNmSDVLTVI4YXZDU1VIa1U4VW83WkxZYzJSTkp6akZOUzNqVEJX?=
 =?utf-8?B?YlJxekhpMjVwNVJaYUM2dTM4ZjhyekhLSVlMVmh5NnEyVENtbnN0a0tGUW5R?=
 =?utf-8?B?OGN1NVB3enRnbGtEdGlQN3pSaEhpYjRPYVVwQlorR2x6TS9hYUVzTUQ5cVBy?=
 =?utf-8?B?T2tTWlpNaG0yQjRhVVNYa0drOTJ2c2ltZ1BMVjBzYVorYWsxN3l2aWZja3pP?=
 =?utf-8?B?dkdnTC9yRjR6YzVXTGJHbUxBL0lRV0dOYzBEMFJSeVRwMW04blkyNjhXamp0?=
 =?utf-8?B?bllac3FybDI3bloyeG92SjVEakIrcDBmWkxvL3JoSzdLMm1GNllzV0ZlSEJD?=
 =?utf-8?B?elNhWncwcWpwT1RqSUpoc1dkRWVNUWZiVk9kUWU5UThjU3A3UUp6d1ZWb0x0?=
 =?utf-8?B?eUFhYWltdXRKMHo3VnBKQ2J1Sy9lZzF6T2dTMlU0aXFvREhjVW5YSkhSYkRv?=
 =?utf-8?B?RzhDeURGdjVVVnoremNWZUxkdDlKcnd4QjQ2dEVqVzVra2RwRm5QYjA4cGpZ?=
 =?utf-8?B?d25PdFlDUWdkUDh0dFVKOTBIWFhzdlo4T0JJeDEvVnBZbllIVEpoYmdYZ1V0?=
 =?utf-8?B?cFh1VVEvLzFSNVRJN29Od09LQUdzMFZJeCtkUUxhbWZsOHpzOFN3MThVSkNh?=
 =?utf-8?B?RWpaclBqTStZbXRpcFdFVUR5SEhjbFk4QWRRZnZQNGxsOHFTU2c1NkJjaEtq?=
 =?utf-8?B?cytMWmllZExhTXVqcDFHVE1GdXA0V0lwMHV0YjF1U0dReHJlNnFPb1lnS1hL?=
 =?utf-8?B?Y3NYSHBkV1gyeWNhNjZSUm82WVFvdWlWbE1QNy9jN1lXUXhOS2VKcnhyM3Fu?=
 =?utf-8?B?QVpwUkhzUTcvYlpyemdXSldNaDEzdlgzM2hFb0R3dUtHSnZqMHh1enV2MEtG?=
 =?utf-8?B?dmI1blMvREwvL2NmWUpTTkxrMkFGUG14Q1dxZ1RjZTZQdFN4YjV2NDBmcUZF?=
 =?utf-8?B?MlpXQ2tTUkhZTWFRa1hSMlhUcllkb0lqV2tuTTZudzBVWEpZaWthOWZCcUNZ?=
 =?utf-8?B?ZGhJL0hReVBkQmFzWnczK3VHM1U3Nks4SEZUOGVsYklzMFBma1R2KzUzUzNC?=
 =?utf-8?B?cWNwN2FCNytZZlhQZkxGaHJVMXdBZ3lLdHAyQUliQ2dMOVNFanVaL3ZkbVZ3?=
 =?utf-8?B?ZmhjNGNyWDM5UnA1QmNtY29ZcG1UQnpaOG4vVWFzeHQvWDN4TXpSRm5YVnpl?=
 =?utf-8?B?QW9BRnlDRFdmUEZJYWdHZVIzazBtaGdXUVZQekdvQkQvOVNKa05xWlU2OUQv?=
 =?utf-8?B?TjZmSEJEaUM2MThsTTJkR1ZzbFF2VzdtSHFVOGJ3SGN0V2x1WjNScFhtYkFv?=
 =?utf-8?B?ZEVRTUtOYkY5TUJnOWNOMmR6MVhRcDh4MzRCc3g2Z2wzbHNUWE9GRUx0WjFM?=
 =?utf-8?B?d0xwNFBqamNCTUl4RDRPRllTeUlFaUJMQ09NU2xWM1hQKzN3aGhJSnoyd2po?=
 =?utf-8?B?azhGb2JMUmVOWHp6MFBCM01YNXBMUlFkekFpamdjMjRHYjNtZkNTZUhmeFcr?=
 =?utf-8?B?bWJPeDhLSzBmMDBHT1BhMkRuWTU3TUZmVDBsOHhTeWZ3aXh1aW9WMVlRUkNq?=
 =?utf-8?B?RGhrV0pSeXBsTVdWazNFTElnOU04b2RLWmRQWlRUWTJYQis1ZzBqVzg3U1lr?=
 =?utf-8?B?UHBBQmpMcHI5bGNDbTAwdXEwS1BXc0NicWcvMjBWZktlREZzckszcDc1RW1o?=
 =?utf-8?B?NlpIV0x5VFRnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aVJaazkvSlRNdFRlZGNDeGt2WWMvREhWandqNmRSRHp2SFEzNmI4RmpSeHd1?=
 =?utf-8?B?RWp1K1JKeCs0RzJSMnlOeDd1RzVRRVdBbVpscklObDJiclorQ0pJNStidlUx?=
 =?utf-8?B?K0s4dmpNanRXQTN1bUdtdGJGak1DeWdiVGQ3THdiWlFER3g3eVRIZHo0YS9v?=
 =?utf-8?B?Tk85d0NENVFsdUc2eWF0U3hsYzZNb0diWHRJWSs5UEdBTUc2Y2JER1RMbHU5?=
 =?utf-8?B?bzlvSWpxT2NzQ0l4dURhcWNmbWV0MmxTalFSQUFKL21Ub1BuVnQxbWRWYm5y?=
 =?utf-8?B?MmVpczMvUkFTM2NnQ01aUnF5ZlhMZ01WUm5vYk9jdmU0WXUwQ2hXT0dDazhk?=
 =?utf-8?B?QU92WWIxN2xrR0JESnhCZjEzVGVncXF0RDdORkZHMnF3OEZjNUN4c0lMVG9j?=
 =?utf-8?B?RFNlY2tkU3JnVm1ISWUvL1pHUjVWWkpra2RvSUxYMHNtVDZCWHMxc0NFVXlH?=
 =?utf-8?B?Z2xYL1RYWmsybmh1ZStEQW85YUtaclo4NTVBbXpzL05GMzdFbWpIbHZXMzBy?=
 =?utf-8?B?WGJySVQrblcwTHVkb2NDdGxYRUh4SUp3Q1VOdDFkcUZCSUZuOVFxTjJhZjdH?=
 =?utf-8?B?MzZ5a0RIS2IrME01VjFRRHJuTENPcWJjTXltUGtqS1BuMnAzdTR1WlBGdTZo?=
 =?utf-8?B?ekZwdWRCbGNweE9wZ2hhTTBtTUlBakxQWlBIUm8xNDF2WGozQXRMVGI3OW1h?=
 =?utf-8?B?VUVscWdUOFk0eTd1MHY4ZXpieThwUmI0S2kwZ0RpVnAySDFUREF3eUUxbWlw?=
 =?utf-8?B?cFlIYnNleWNKbVhYM0VseWhUenBhRlAvdzlQNit6MnRVYVAxNFo4NzBGamNO?=
 =?utf-8?B?cVB0Unh1WmIrTE1GYmJKZmdSTFJJU2QxZm9xeEJ5YkZsT3FuMUNhVDRSWVRy?=
 =?utf-8?B?bXFweUdiUlMvdjN5WlJVdVA2K25PQTBTeFZoZ1RTQ0Rjekc3Vzk0VG5qZU9T?=
 =?utf-8?B?YmtPQ2VLbW9tUEhqMlg3Z3MyVHMvdnBGdTB1dWlVd0NMQ041bFJmYnk1UUc3?=
 =?utf-8?B?OU5rSHpxUS8xWDZHOGtpdU5kWlJRUmRvekp0VGtsZHVnTTZOalJJcWV2V2xE?=
 =?utf-8?B?OHpoUHFiYUo4VTRQczNWOVEzSVFXb1NRa0FQbDR1d2ZOdUlpYkFXaGhBZkNW?=
 =?utf-8?B?TmZzeUVWSy9kMXVsenVsVGxFa3MxMEZ3MndDMnlVSnVKZG1KQjVFNTZiaHVr?=
 =?utf-8?B?cVA0YnZ1Z09ZeDhFMjA2b1BudVZHQ3B0UVlzSjcvQWVWYjdpZ211QW04N1NO?=
 =?utf-8?B?VFhGRDBjVDVuTDBVbGdsRTRpZjFMTXU0cDlnV1hCMnlCamRNUnJ5cXhVVTdW?=
 =?utf-8?B?RUFuTzBqN05zMXkzM1cyVDhHOVRPTUg3bktMMFJhZ0d6MVl6WklXNkVXVUsv?=
 =?utf-8?B?elprT1FIY1M3MHZaR0FjQUpNQzdEM0RTODUzdS9sVDVMUisrRlVCR09XZHVu?=
 =?utf-8?B?MXFtcXpjdXlDMWZaOEFnMGtOcnZ5clhITXg3Y0NuUG9KMW1KcUVoV2JBVUlG?=
 =?utf-8?B?N3hFVG0yeVl1MWN3OXcrZEdmbEh2YnhTb3hpK256dldzZ0tEZmZwT1RYYVRO?=
 =?utf-8?B?dHlXeUxxcDQwNFZBd29ucUVKbXRoRVdob1RscU5KZlEvVERUdncxTlV2UEdp?=
 =?utf-8?B?MTlHc0tXWCtaaWVFNEtPQUEzVURGRStlOWxXUkZabk1EY1VheitsM2gvZzhQ?=
 =?utf-8?B?V3pESkZ0cG9zM3RCc0k3b2dvYjBmV2tuOG44OHFMWTJrY3VtczlxZ2lUVkda?=
 =?utf-8?B?Wm0rOGd0aS8xR3lwN1lOME1jQXVXL3FPeFA0RHJibkM1VkVTbHExbUk1Q2hX?=
 =?utf-8?B?dHk3MEQ4cWRKMExReU9KelNQMnR2MHgxQmF6MWRCTHJvUHBxL3EwS2pRUWlY?=
 =?utf-8?B?TWlPdHpUbUZLRm5GOFRLQ2V2SWc0Uk03MldLQVZ4WGJQSkFheVJ2MTBiU1BL?=
 =?utf-8?B?TVBXbVlIdVYyK1M5cnlrTXdCZzArRnUvZWZrQkU2emdCVjZ0ZFNUVDVZRmlx?=
 =?utf-8?B?Z2V2a3JwMHF1UXh1aE1ENGMxTjkxQzFmaFZYb295LytnY2VwRlhzMzNEL0Fo?=
 =?utf-8?B?ZWlCVzB0UXlFY0FjYnA4MW5XalphWGovVi9DaEpkcU5KNG1RbXdmeklNU2di?=
 =?utf-8?B?UTFOclVwbWp3alkxVWQ0ai9SSzhjZTNzWW52dlZodjJFS0lDUkNhUElGczl6?=
 =?utf-8?B?aEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OsxIGCWX8hO3FpNohc6xvTQuL7kOMnN6WJv8gBewhafNYcJr7HqjXLC/pheJgM6XEhOmPxREp5BGGAPSnBWC5gHBA+uyVSPAhKFEaH0okehhVYJg6E9WTPEjkf6wMXvnyjuSWytqW1/6/X3IPu3QmWPOAa2eVeYK0yZVt+g5aN+zXl5VgW2Ocn0KbK5JAavQeDv/bpwLHC4OrGQaYia/fMFVi2xr44g5sMYkWy3OkGDJfWYDF1Tm035zuejpsUO/slyIK/BGbF7CGxjDyy9SEuGT6pSmCX3vPf4onRtC+IhEqhG4y7C+5WJdX9dac2AQV7A/5yBGh7XyV8aJJJwL7+NaXi6ehsex/hmhXjM6wZQeHxyHUgdzabAFJTl64guzQjjfZ6d84RVx3MtqWzsOGUyPiWa4FdaTzSFBfyAbuQtmxm+SQDkSJzpTbFRHvc1VX1At0VFAjWUdMMULXD/Ajk+aLk/yrNPAPzP85/gF1Jpyyjxz3wHoAzVdRDWJI1ERm5eyLoYuaeYPsgK9hgfuGG8OijhDg/7h3edP+zIuGZRdYvf24a4p2k50nWuoc/pSkdZii1ibYIdLvYYGAC5EHXGURpVtoTCZQm1q/dWiqXA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9341915a-203d-4365-99ce-08ddc05b9505
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 09:16:13.3445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R2bNV707FOYGqv+aEzx6jRIvVokqsmNTaKRTvw8TXsftPuF7tgdCL4B6XhOrGJkIoP0dtvCJTF0xAF4f/WV/4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6472
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-11_03,2025-07-09_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507110064
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzExMDA2NCBTYWx0ZWRfX07ttr+XXeUFv kQA9D97221nl/vcnqiK2Cd4mf/svzYkxm7hyJPITjX/Wv2uiQpjAMg2YqwTFO6u/3jXiOgKYrQM YQ57Yn74Fy4oF3vKGRTu5kB3BnT5lV4fLQgAgKPgHshQYhV5qbs3ReFZgkMWfbn9rBdnchD7kZW
 pcf5ky5GWcbo+M1FIuHpu+qugjh43w4BqH/bpwpP1B24CPT77mkL0gwXE9Yp9tfuPOs8N/qxzgr riNe/cVxN10/CnWOrUODCw39gqtMboTFIPnBlxOxheZUMXsvAA8cFnLTxpOFY1NbPlv4neVCtnO DOdhF6Tmc64CZgHZTk0SLweRu/d9/fJDyMljipdTowUFx1phVkyZpp7XnBWW+zKaEq7tr5SNESO
 qERtMSosf5cuy3sweGisgsbI7TIMRXgT12crgk8kYRvrzs7X/SrTsE5yPuFwZRzf+DanGBRd
X-Proofpoint-ORIG-GUID: vX4ykdalVQqph-vtKCVcRw3ONw9OMxBM
X-Proofpoint-GUID: vX4ykdalVQqph-vtKCVcRw3ONw9OMxBM
X-Authority-Analysis: v=2.4 cv=Q+DS452a c=1 sm=1 tr=0 ts=6870d661 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=TCwCpg_Z5ho3h7edcYUA:9 a=QEXdDO2ut3YA:10

On 11/07/2025 09:44, Damien Le Moal wrote:
>> This series now sets chunk_sectors limit to share stripe size.
> Hmm... chunk_sectors for a zoned device is the zone size. So is this all safe
> if we are dealing with a zoned block device that also supports atomic writes ?
> Not that I know of any such device, but better be safe, so maybe for now do not
> enable atomic write support on zoned devices ?

I don't think that we need to do anything specific there.

Patch 1/6 catches if the chunk size is less than the atomic write max size.

Having said that, if a zoned device did support atomic writes then it 
would be very odd to have its atomic write max size > zone size anyway.

Thanks,
John
