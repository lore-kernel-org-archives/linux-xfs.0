Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560472580F2
	for <linux-xfs@vger.kernel.org>; Tue,  1 Jul 2025 11:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751367845; cv=fail; b=lTuxBgkqYDjZmVKE9hOkKdP8HuGDlHNmcSUjn80bRUgUOfEQGwHg3i6+GrThi3bp3HWcvAibHclgR7XX4I3Pj8fzMteLlWjGhXRdQnyJQ/UNTx+OmhlnnIoQF9xLarSXKVobaSd4LsbZyzFJlIQyR7O+ludUZxUOugQTfjUzp3s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751367845; c=relaxed/simple;
	bh=VqfX6UC8+O93CWrMzG/HBy9xeQFdx95WrYLGteD1sZc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kSNQxAkhg7Vx2lib9AB5oKefS47uf298pKY9pfAI3g4O4a+faKhniRebfuSMqXC7zoJvZShnOpxUI7g8Ximk2Qi5BJNWXT5Q9UBD7szZi9dIHKXmvFmF2insBrVj7k9Rtv6bx9OWxrZkA26TBdKcPuhOf6U+r4dDc39Hl7rwwqQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SFHFS6Pj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MnkSdtkt; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SFHFS6Pj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MnkSdtkt"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5611Ms8k008504;
	Tue, 1 Jul 2025 11:03:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=gOn1h0PZGuizr5DLffS9+YOr/XbRGTguOYciRpjgtrE=; b=
	SFHFS6Pjf+y/rGRB8NiL5kyl/C3i0PmjvkGYlkeMSJOmDogexpIAQl5AKJ+2HuRL
	+XzpF/qpd/TfNUcFe7xNF/XeCpzy+RSAaJIzkIWhXKlNgitG8xei+MjydRX6EzDa
	EFzoCQAi9Ily473ZKdMfW7CNXbUwMN6brffHdnS/94pN9jjIhO+FnU6j0V9ICs93
	LaQB6Oh8KYMpJzFrmWy2KVEaIx56l+t5YlK53dt1Yn7wt8DpP1w7tmmles027/ZU
	gpvgh8U/8cCcR2G3PWJsnm1LYLsDrqIpLG1Z3ilylbfTFJs3NK42CiUFLH92Z0xf
	nq0PYHMuzA8cIQdckcOi9Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47j766cjas-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Jul 2025 11:03:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5619cj9l011462;
	Tue, 1 Jul 2025 11:03:57 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2076.outbound.protection.outlook.com [40.107.220.76])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47j6u9btuf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Jul 2025 11:03:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jVzm4mLr25DacmISOijZxNbGEsFNJmqmWerzwh8xOP1pwjBIN3jHB6UkzSMsl1o6j00sC1vXTCWoo3XTFOX6OmIn6KIzvsjNJIxFgsiJRCMhHPWDJzHTLuWeFt4EPiycuYLDvwj4Sj0A1L64hAHKp8Nq8i49xPY8YSbuyyJawy4eY45ktYNGKMpTKNdbnArAeeqPIaSVmk84thIEOe6G4h+v4NlXxlwNobyVocI6+yaNtG+iA+5Xl0w48mSsn3ak8kJfrV2/SBsBrDfuWl4JgVKSIIKOJKHpqCelTwUjL7l9hKv5oV8PQCUkmKbm8gFi0REFLmkT7Ge7Xj4sSK1kMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gOn1h0PZGuizr5DLffS9+YOr/XbRGTguOYciRpjgtrE=;
 b=rSUNPzjRJSyslz2ChJql14TPlq19zmwgJlEHTb+H6gSt7m7z+bbjBRQkW9a9zDVBwzvxDWZU1+vxLjvJljIZA7KQc18ZZ6OLN1XLrESWkaGsmLaY9plXqUfMirclwwHxSgTEwN6hUWGpqGp7O5SvSjmzcadOYR0VpbgNLCROnepe8OB9caZLplawRXytriGleDPghImtSGraqOiZk//cFLgr7dUaCMS8j7UhGN0ysQOktikgD3vMVrob7kQ/WuRDcQ4ietFAXx/Gaf7dESJ0ISYGgQfbAGyfmYtPwQa/Qd0XTJjoG4eo5oYdvBLp4arnP7fxvIVcpArG+MRsbBxtsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gOn1h0PZGuizr5DLffS9+YOr/XbRGTguOYciRpjgtrE=;
 b=MnkSdtktnqooc2zVBniB+SLXfdQ2rRg3+f9rQ7jVQkZdjwSVdxYoHnQqoB+/oysLeGQ6Kl0IUpg8SWcxiWHFYIaHlB86wKrKYUklWHc4u0YvuOIsY8U6++ODEYVY0ZMuSnxOTUlx3ksuqSEilgljAktDTF/D+Vueqya0MO7SHnQ=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CH2PR10MB4359.namprd10.prod.outlook.com (2603:10b6:610:af::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Tue, 1 Jul
 2025 11:03:55 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8880.027; Tue, 1 Jul 2025
 11:03:55 +0000
Message-ID: <d779b905-5704-44bc-ba8b-0d520de37f2f@oracle.com>
Date: Tue, 1 Jul 2025 12:03:53 +0100
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
X-ClientProxiedBy: LO4P123CA0361.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::6) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CH2PR10MB4359:EE_
X-MS-Office365-Filtering-Correlation-Id: fdd11695-768e-4a2e-da70-08ddb88ef886
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SjB4OThDRjdwMml1STRPdXAwRW8vMUJVMFN0VzJNWkVXbGN4Z0s1Z3FCTG96?=
 =?utf-8?B?SGZ4ZHZmTm15OHZLWlNyVUpRTHl0TWtyVlBwRXBUU1N6VmZZa3NaQ2pVTXVz?=
 =?utf-8?B?bXNzUXQ5MXZ3dktXRDdtdFIrcVAyK095dVlua0NNaUhTenFqaUdjOHR4N1Nk?=
 =?utf-8?B?NEhPbG50ZkR1QlFIUm96b295RnZ5ekpIRkxTSUwzdEpVNDljN1ptakE4KzZW?=
 =?utf-8?B?alNKblYvMUpFMnZHZ0pPM01JSzV2RENJdFVjSVVHTzRmR0tlZHdJVTNkREJR?=
 =?utf-8?B?eVB4MC9NME84Q0gweEVVVEdVS2VhL2ZFUC94ZXlXSno0UnVDNVY5R3p0dktU?=
 =?utf-8?B?Mm16ck1pZUF6eUtRcFhPb3ptaklGcS9taW9PWXJPMTF6eDJUUmM4RHM1ejNH?=
 =?utf-8?B?ZmFEWEZZTTcyWFpkajBWeVIvRVdZYytQS1M3Q1ZUS3VHV0l3cmNtQ0dMTGVs?=
 =?utf-8?B?WXQ3NDY5VDgyTUx6ZGdtdnJwbW1yc1FJTCsxNVU1aWQrM2wvQzlKcFdvdWVa?=
 =?utf-8?B?M3NFUW1FakJvZGhSRE1nRm1iS2dxWTRsbHA1cXptN1g4bUI3Wkx5TXJnTU4z?=
 =?utf-8?B?SldvSk5kNjFkUDVhMnJIZ1A1LzdQRWJSRG5qVVFJaHJZS0k3VFNnT1JCVVBC?=
 =?utf-8?B?QXlQWTlmMGF2V1k0cGtrb0traGVFcDd2bzFiTllJMWRyT0ZLclY3Tzd4aUNt?=
 =?utf-8?B?WHpmY2p1VUdBajhwOXpSdS9hYm94SmYwdGVsdG9sR29jQjJlTHhKL2k5Q0ps?=
 =?utf-8?B?Y2xHT3BLU1IrNjVvSmt1c21ab2UrSW9hNi80SkNYaGlQSWdBdDhnUXYwYUZk?=
 =?utf-8?B?M0NiN1hUL2Q3QzB5cTNjaldJd2Zla0FudE9XVGxpa05jLzVPWXVFcHB5eEwx?=
 =?utf-8?B?Tm40MHh4ZTc1cnpxaXdPTjVxQ2VFK0piclBVNzBoNmFSMVE3WVJrdzJyTG9K?=
 =?utf-8?B?cDAwK21sekJHdW9jaUtjcUhtbUc3anNOcXVmNHBuOWVCZ3dhWTFMekxTTks5?=
 =?utf-8?B?dFlGM0RrV2tTSU5aZXhNZFFRTS9jNTZ0MWp0UnNQVDR0M3pHMTNTQjdXcHF3?=
 =?utf-8?B?QVltY2x0SUo1eUFCdTdwWWZGcXgycDR3dm8zbUtWSW1Xb3VsV01CaTE1Nzlm?=
 =?utf-8?B?Y2lNZ0c3U1VrZ3N6eVh5WFY1SHJUZEVJYkFZV29vYUR5bXNsbk1lblV6UFZ5?=
 =?utf-8?B?NCszZnRKemJRczE1NnRybzh6N3RTa3hEazYyTk1iM0hLMmxwZGRGMnM4Sk1U?=
 =?utf-8?B?ck5heUo1eXRJY1FFRlFiWlM2NWxxNjRwUm4rSUxpRXJydzdhRnltRWp6TnBT?=
 =?utf-8?B?c3Jyak55aE5CU1h2amdiMFVWN2QxYzJiSzU1Z0cyOTVQNU9OaUZtSUdCMFh2?=
 =?utf-8?B?b3N1WmhXaCszQ2oxdHZDN0ZSS1VCTFBSS3R0OEN1NEFVZ1RYQW1FQ0JYVUFF?=
 =?utf-8?B?RS9RTHc1ZU01aFlOWDZvd3dxemo3ZEZZbk1Ub0lpMHNvaTdzaURpOE1MUzQ2?=
 =?utf-8?B?SjVCemh3NXpycnFndXZwLzZUSkRTUGhNVWpNMVBka3ZwUWR2Z3dBekM4Slds?=
 =?utf-8?B?TmxYSEo2K1c5M24rRnU5YTBRdzRkMzhNbEJ0MERLL1pCeGVkUHJhSXVYdXZt?=
 =?utf-8?B?WVNlYUVWeThUMC96cHk1MGxRdjlvalQ3TDdvR1I3ZlovamZQcVBtWW1PK3oz?=
 =?utf-8?B?b0lMZE9LaHM3QzVwTXU3V3FpSVJ3NytDSDM1cFg2UmFlcmZ5YmRRYVRuMUJk?=
 =?utf-8?B?UkQ2WnJVOXpCNmg5QVNRdWN3WXJ1YWtVUlpySFo1TVd5RkpBZU1jSFpxbkxm?=
 =?utf-8?B?VXA4S2RYdUNpZkt5MGxncDhDNVFkSEZvQmpWSVo4V2dqZ2hSZVlSbUVwZ2N0?=
 =?utf-8?B?a1JkY1g3UXI2NzhlbTlVMURmK1hjelV1UVZkeWlWUXVKNGU3dTNWZkVKcnlI?=
 =?utf-8?Q?6V0zQsSraK8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?blNaazZhdTdqVUVDYm1BUitBTnM2UDRVWTlROFIxUkppMWlzcUk1WXFTeGQv?=
 =?utf-8?B?UHpoamR6Ri83cjZ4aUdoRlE3Z0F1NG1qdWVkOTUwNGFWc0VQY0VoRDZTVnl5?=
 =?utf-8?B?VC9BSml0aHpFdVhzaHhYUTI2YVh1MWsvc1VWUjFsditSdEwrdG1DbHV0dzRu?=
 =?utf-8?B?T0pwZDJtdEp6VUVSaWpDaHFNMW5hbkFGWmVtUHhxbkthaHVwNGRnT2R4dDcr?=
 =?utf-8?B?WnVlQlJHRWJobHBBZDRIR0lrYUFsZVhiSFc5aktESmNWZXNtZS91YXhLcVBS?=
 =?utf-8?B?MnNOdW9iUGY3a1loT1YybVorTnc2Y2owNUxiOUEydm9NMFFwMkxyQ1JIK3RJ?=
 =?utf-8?B?eGZ1RElqVzlQVFo4VFMvVnZiM3ZjcENTUHZwZzBZdzhiNWRLb2pDRTI5ckU1?=
 =?utf-8?B?dmJBUUJ2MG9PdFlZaDhFZDJFa2EyN0FJZUV2MUY0SldwVVpJc0JkYmcra1or?=
 =?utf-8?B?aDd1Z2ZGY2d2bmRHY0V3SmpMZFpIdkRnenBvM0xTclpPbmdIL09XVmk2eVBs?=
 =?utf-8?B?STFVRHVteisvcVVyOEowNTNqRjZXekMwMTczMTY1ZUQ2QWMwTzVPemhSN0dQ?=
 =?utf-8?B?eEUxYTJBTmpkMTYxYjRzVUpqelplcGwzVXo3UnJ5Y3o3WURRU0xBVFhXOTkr?=
 =?utf-8?B?V0RLYW9SWlZrVDF1a0V1MlZyMVNwYzdyREhFL3FWVnZTeTk2d0Q1d3pacEhu?=
 =?utf-8?B?NmdIQ1FZa0JWTWlBWWJMOUU5YXZQZHlLR0U5eUtpU1lmd0h1MEFkOXV4ZVhs?=
 =?utf-8?B?YXgxSlRFQnVnb1ZCaktZcCtza0phMGZ0QUZpbGRXVHlXdHhFR0grb1ViV3Yr?=
 =?utf-8?B?ckNsYjFQeW5QLzh4ZkVCRm1vUUlRSUZuWFIzV0VYNnFJdzFITUNXekZZdGNP?=
 =?utf-8?B?M3dpRjFBZnpjd1FiWUkvNVpFRWpJTEtPbEJXYWQ2eXJTTWF2SzJycEQwaDRL?=
 =?utf-8?B?c241NXNvNS8vY3p3V0JZSkM3dnhpN0RXamEyRVduYXZ4cC95bXFWbUU1N1hs?=
 =?utf-8?B?MUkrTmpHeTFNY3BOUmRUYmZNZ1E0K0JYMkdOUWtGVVAvMmIxcnIxWTZhcEd2?=
 =?utf-8?B?ZHFMSWlxdzJjTEF4aXlLS1E2c2NnQVZRY2RNY2NlSVlSbUduaHJxaEtYT1Er?=
 =?utf-8?B?cEsxdEtTN1p0a1lPUkRURTFoTFpRVUsvQXJSUk1yT1hBNUlQalVMbUNtN21w?=
 =?utf-8?B?Y2lqek1neXpXMWY2eXZuTzZmQlhoVng1R1BTMHRvU2JUYVNVa2IzdUhCZC9m?=
 =?utf-8?B?d2tuTmRzNkovVTBNaVlKWW9tWWJKeVF6d0V1YlpJVmxOTWpQd1ZNMjA2THlI?=
 =?utf-8?B?ZXE2NHkxOFJZQUpRQ25mcVJIdHVGd0E2L1IyMzBKdWVmTE1taXMrZTRCQlRR?=
 =?utf-8?B?YkVpRzR0RVRrQzhYQ0FacWF3V3lBU2Ivck41K00yTlJzU2h5YnFaaElyTFdW?=
 =?utf-8?B?T1B4TmhHZC8veUNtRlBBVDQzMHJMekd0NXdoOHhTVDBsLzNrMktHZDl1RWlC?=
 =?utf-8?B?WHUvaWRBa2c1ajR4cC9qMTg5WmVtcTdIdWRPZEZFUm1VUXNrYms0SGtEaWFY?=
 =?utf-8?B?bnJPQWhrL25ZQyt4SlVoZkhieEZnL1NNQU5ldit3OUM2TzM0YlQzUTJmb1J2?=
 =?utf-8?B?WU11dEczd0lwOHBNdFNFdVY0OUZEV2Fia3ZHeE9IUTc0SldzZHp6VEphN2g4?=
 =?utf-8?B?WEtRcXlabkJ1K0xpdThPSngwenFIaDhOTWhrOVB1ME83UTBENy9uSDdjTDE5?=
 =?utf-8?B?bC85RDBRbjdIK1dRNDNwTGpyaVVQS0dNcERFUDRzbzU4anFRZElJZGxkV2pz?=
 =?utf-8?B?M2tPSnBpN3kyMmx3d1FaQktrbmlSZUQxeEFQRHNVSXdRZ25FMGFvUXo0VVAz?=
 =?utf-8?B?ZjIxL29nMHpjTm1WM25Ec3VwTERuSnY0Undwdk5PQWVsR0VHbmcyaklCOU1v?=
 =?utf-8?B?OWZLYVkyQWdXZzVoVEt4U3JMMzFnVzRSQXJGUnFGNkQ4WkZFV09YSCsraVc4?=
 =?utf-8?B?YlhyTXFvKzhCTU5YSUJkZGw3MTBzclRYZEpuY0MyTVpSZk5FVG50KzhHVnlD?=
 =?utf-8?B?aGVzTERoODBMcDhFMElPSHFMaE43VlhlNERSeXEyTGxnUWhQQmNNWFdKM2Fa?=
 =?utf-8?B?cWxZbFhHeG5aSXhYMFBUb20wWnF3bWNReGVCbHRhdkVhM2V2ejlKSk1qTWQ1?=
 =?utf-8?B?aXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PFWS8ww0ETzxm5DoFQF59LpFuuVHDygJkar6KBXa33EuGnYoeQv/BOi3+zyQzN6kpVtFuazNsGDE/ei2SQJ0goxt5U4AwOWx3H/x+vmzW+dy0QmKWpGEGyDqNXqQwOSvyJjDE+cl/zes1NKSm8/nbm0TA0PsNqWU2llqCZSiuO9lXfVxvjyYEP7cADKTOa85HOSGEoEvuqVbJukYw8aoeBXEoN4mE83Q+m7AjQpIW01wUoDBKwVCOMsIC3loz/1d60EdNUfaA5ohi/J7Qcg/0WFp9b7FpLhklJ9h5a6a+U0Bu7BYEw5vXOxmdH30kGkkZYhg48swdqYZ/BN7rMHSiI66PVFQip4MvUjXgXvZn9bU6COn7TQlDiGOxdFeYEhjTYk/8j9tfo1TlAuNh66iEXQ4qdGrWvVJX0RkmoHf0TnrtLdMv5CS/va84zX5XTXrxoLeNGoKw5nwcQCScDp9tgEZIJ6Hu56sa3Na0UCKpJyQe3b0q1brEhqjnVH317/iiKE9CZ6BEeg6Qb0reafdiueZqWHmBi3vVGlDduxjoO6MX+TUX4HazatlHS4T3OmZr0kHTdN6liOVl4lXsk+zqMCVlqu2JGvosSRNZ3qoymk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdd11695-768e-4a2e-da70-08ddb88ef886
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2025 11:03:55.2724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9rTFsuXPaVdWTuuTEpA53MX3UJ1trur+l4frTA794KaCQnEvyngREhh/zPEuk5kl6kMHvM9ER5XxltaluB+F0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4359
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-01_02,2025-06-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507010067
X-Proofpoint-GUID: EL4V-xYQ5twbv-RK_Qgn8TV8JVHs-XWv
X-Proofpoint-ORIG-GUID: EL4V-xYQ5twbv-RK_Qgn8TV8JVHs-XWv
X-Authority-Analysis: v=2.4 cv=b82y4sGx c=1 sm=1 tr=0 ts=6863c09e b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=mcKW2pmY5da0iwsSobMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzAxMDA2NyBTYWx0ZWRfX+XTCeCRfvBEQ FPwHdsEEqiH+dKGwYUN1LYhPSiLkhY1wUBgX3JYXUvKx4XStcTzd5SN7b4i4TWRNxbodZ9H+kAZ LM6MPztoFmMV+s09U+eFjHXYBuWLZD8zrbt98ux8OJf1rZ4PCuzo7Mp2oFfRjoIDkBZ6bb1dKEH
 j3pfPRQZ5dtdI6HV6I2HyD9aN5T9K9MuiV/IT2PxJSxTt5Wq696SbHADiALVNFPwCvng5kFZcda kpB62/J9l9BkCqZmMI3xYCfYar0x2uYaAMIsa//1kxSmXcbkSDYI33Z+yKiR7Zv377bVBhLdJSd 9ila+TIN3dVSIn+AHLCNzdDaS/PB/uhQs+CPgKXjLVYkXSLqqk7ika+kHEROS/V9Lot44teFdJc
 BZEr6eFGxTGU7EoRv9hAdiohbqX8IdxRcpdr/bm2xuFFS711D9X0vP0m7XRxCEg1a4CUD8Kv

On 01/07/2025 11:40, Christoph Hellwig wrote:
> This extra call is no needed as xfs_alloc_buftarg already calls
> sync_blockdev.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   fs/xfs/xfs_buf.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index ba5bd6031ece..7a05310da895 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1744,8 +1744,7 @@ xfs_configure_buftarg(
>   	 */
>   	if (bdev_can_atomic_write(btp->bt_bdev))
>   		xfs_configure_buftarg_atomic_writes(btp);
> -
> -	return sync_blockdev(btp->bt_bdev);
> +	return 0;
>   }
>   
>   int

BTW, the comment would need to be removed as well:

	/*
	 * Flush the block device pagecache so our bios see anything dirtied
	 * before mount.
	 */
	if (bdev_can_atomic_write(btp->bt_bdev))
		xfs_configure_buftarg_atomic_writes(btp);

	return sync_blockdev(btp->bt_bdev);
}

This all seems to have come from 6e7d71b3a0, which is a strange 
resolution to me.

