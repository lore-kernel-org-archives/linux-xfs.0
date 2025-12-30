Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5113251795;
	Tue, 30 Dec 2025 19:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767121398; cv=fail; b=YaSoy/oLAd4e8M7NtAB8Df4UrxmAYEyPKeEsumKu1f8240MOUpS3Beq1rFsPel75r0pRar00lWkxuf4y2BnYHjJdeZqbhcK751HMiCIvSSvTrc4ExBrw6gYm3lErcH1nGDzridZ0G2wt/pk8yzl6riVtGRMJ1tsBj3RxmxTHpsE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767121398; c=relaxed/simple;
	bh=ySUMAYiRBz5qldhzMu9IhXEaIW0JXhRtveP2WtDQ8Eg=;
	h=Message-ID:Date:From:Subject:References:To:Cc:In-Reply-To:
	 Content-Type:MIME-Version; b=mYSpsVCzuYwvK9b/6IR/5keQWVLwTxU4jZQgLhBE3kv9R3/IY5nXWuI42HT8YLl+xk7Mfduf5c541zEYDRroIKBaRDfAAb0uYxYAH5VM1EWDWYJ7zn1hrglybk1PWQS1p/VQkRUeJNvGOlr9bm3xjnIunSEef8rreB8gf6n9raQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WcVPZSvM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PgG+zH9S; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WcVPZSvM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PgG+zH9S"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BUBEMp54133800;
	Tue, 30 Dec 2025 19:03:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=
	corp-2025-04-25; bh=H48nr6FSkU2K4ZEsv7tT+xVcOVXGDyho3NCuO+lqk20=; b=
	WcVPZSvMajQS1wQFNYLCPMqpb/z/eQ8LF4PvOu/GeMHlRzpUizTOPPw4vxt0JYuw
	tB7o50vnyutSotvsFT2J85p3NGBLelVzHNo8I5AWTL7GoJX/+jffUGqR0YZ/+MUa
	/KpnVpG1HEfzvfmVTNrWLZDhCwRAju/RjoZX2E0a3FJgJJw1nB1eJfS97eNHq8fS
	VAIHCZpMsF0jbwFsbSr/ky9tNqYytBISWGIxHibMKU1+nc3jxESH3AbhfDQNLErs
	uXVbeU39wlBdlw+PioEu8XljNcUO0QMEFXmPLIOt5mqkET7vSdqpTC+NVOeS8xzg
	3hvGMlcmajpMhhlDGMzSXw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ba7b5juyd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Dec 2025 19:03:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BUGMI2h014251;
	Tue, 30 Dec 2025 19:03:14 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010034.outbound.protection.outlook.com [52.101.193.34])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ba5wc27qe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Dec 2025 19:03:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R4djm6ImDmqjgj8+PKAMm+0J76B9OfsyWRH/Bw4HaOgVjX0kRjEVPoe+g5s/JA9ek64tL8qMt/1jYrYSnX+rvhVl8evPTB7zfNRyvoeimu0DiW1TVb2NQ0orRk2eKi1H++46uzUwsW04PthcZJUJnBjLaqVl+MG2FvbXV7aeHtjvnG20dio54zCS7AmWPiL6HZX6QZQF1QEg6J25LoUI87J57rcYO2kmlLSkK5XGHB6SrcXLbBQmIccDWwp0RH8rV/zz2WLmFQgsHTZc6KwQh6k6DDe5thu795ewlqPupJwmkCSB6LVaCy8bgLY48zw9S3oYcTHjr1nQuhl0/N+R5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H48nr6FSkU2K4ZEsv7tT+xVcOVXGDyho3NCuO+lqk20=;
 b=YuJqbUN8/xMYZWjFkGl5UFN5zglq5JQdHKeBTUrBVNPQKD7RMGW270t5I9AcaQ6cvx2tX+AdCLCC4o4FofP0d0lQUBL9K2WcohLNUHVgPbMhb05lB0o8jm4BVpwGFVyV7tGDQCRolWuRGJI1E8GLWsqeU/NgofHlXVS9RzGm2byFRbltzqbJABls/U4YSGM4ebUSttD1I7fyIfnMsYrxs/hj0KVPiF4IVG0h0zY4nixwCQML3P+mJmSV1+N8R5xFX9j0G2p36g8RJHbcQbrWf8bOcJuwkPQaSel4fJl6Hf+czyvUZGCgwhA83M6bbVY5DVuULUfHrN6gkm/ERcorAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H48nr6FSkU2K4ZEsv7tT+xVcOVXGDyho3NCuO+lqk20=;
 b=PgG+zH9Sgqrdm86gSWe+UGU8TtINUNPNs4dgAuGwo0dhoDzAvW7B2co6WWcKROMt9ZaZYTyT1i+XcgH/NGWLQAU4YWyppli/BtibBt6+NasX9vHfsCG/x2wIUOUMYGFwW/wos0t0bpcXTjadw99ESeya2MoF6JoaJ/NmB+oW5Cc=
Received: from DM4PR10MB7476.namprd10.prod.outlook.com (2603:10b6:8:17d::6) by
 DS0PR10MB7342.namprd10.prod.outlook.com (2603:10b6:8:f9::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9456.14; Tue, 30 Dec 2025 19:03:07 +0000
Received: from DM4PR10MB7476.namprd10.prod.outlook.com
 ([fe80::bc52:af88:ebf:dd16]) by DM4PR10MB7476.namprd10.prod.outlook.com
 ([fe80::bc52:af88:ebf:dd16%6]) with mapi id 15.20.9478.004; Tue, 30 Dec 2025
 19:03:07 +0000
Message-ID: <17cd5bef-e787-4dc9-9536-112d1e2cda2d@oracle.com>
Date: Tue, 30 Dec 2025 13:02:41 -0600
User-Agent: Mozilla Thunderbird
From: Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH] xfs: fix NULL ptr in xfs_attr_leaf_get
Reply-To: Mark Tinguely <mark.tinguely@oracle.com>
References: <20251230190029.32684-1-mark.tinguely@oracle.com>
Content-Language: en-US
To: linux-xfs@vger.kernel.org
Cc: stable@vger.kernel.org
In-Reply-To: <20251230190029.32684-1-mark.tinguely@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:510:339::14) To DM4PR10MB7476.namprd10.prod.outlook.com
 (2603:10b6:8:17d::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7476:EE_|DS0PR10MB7342:EE_
X-MS-Office365-Filtering-Correlation-Id: 732bac1e-1ee2-42c8-ab44-08de47d61100
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VVFEaHJlc0VaT2ZjSFVNQmR1L0Zyckp5b2diUnI0SkVhVkd2cjNIRUVGQkhG?=
 =?utf-8?B?dzBIZEtraXJBd24wRjMrQ2h3Vk95alZUaEc5T1FCZDRHZHFCUDJQOENtd1JL?=
 =?utf-8?B?WWJ4VWR4UDVNMzA5ZDlxckltMnhjaHM1WHBkejJhN2xPZ0pROGN2ZDJMV0lm?=
 =?utf-8?B?aVJEVEhtZjN1M2dBbTZHMmdrREU0NExwNTk2YmtQYkFOcU5TNGJlNExqcjhI?=
 =?utf-8?B?S1ZPdHV2dDBIeU1nQVR0S25CenhZMnd0Zy8reVZqWmwvTkd6Y1pUTVUwYVlq?=
 =?utf-8?B?ZDdxOENuWE9WaTdKWXdpT1JhZWw0RGNaM3VBakRXR0t1NmVKNzEzZUtiZWVu?=
 =?utf-8?B?d01sbkFRQ0NJbTVGVVhQWDE2cE51QWVlMW9iWExtdHR4ZXdIL3VOc3JONVhp?=
 =?utf-8?B?WDRQUThuNlc0aEtnS0JhSHhMV1dOelVnOXd1a3dJRTBYRG1nUDlJWDhFNW80?=
 =?utf-8?B?aGd5dDBWemVERFo0Z21SdWtmMjg4bVdJUER6OUpjQzdKSUVkNFQ0SHhQVitB?=
 =?utf-8?B?ajBqSkpjWWdsNFZUVkRGWGJvSWR6WDZPUU9raDdYQnRrSTNiZWhDT0p6Sys1?=
 =?utf-8?B?MmhoWU9tcUdaR1djZlR1R3ovN21ZQ2tiQkcwUVVBeS9UMEpaUGhRYXpYcEov?=
 =?utf-8?B?YUNiamdtYzRLMnFjRW9NeVJJNm9QOVN3NGw3TmNuc0lHRlBlVTc4ZENUOFNU?=
 =?utf-8?B?YTF4MDdGSXY0U3IwcE04ckIrN0NGOFMwMXJRYW9RcEJNZVBlUnkrUFlFTndo?=
 =?utf-8?B?Vm85RFM1MkZXbTMzK05PbHo3cFdjUGJEdHhkTEk3RHhOU2RrOUl3MDVRcUha?=
 =?utf-8?B?elNwbEo0L3VZUExxaDNsdXhhclowY0s1RmtmdE5MUnNwV2twNGVpUW1vU0pX?=
 =?utf-8?B?djVTYXQ4R25wZW5Vd0RFR2lyR283SzVpSEZpTHFVUnNxQzM2MmJZMmllWXpn?=
 =?utf-8?B?MTZkMmZRZlhiZExwdGpmdEk5Q01MelUxZ3QrbnFXZzhseGdlUVZGckxNcWlG?=
 =?utf-8?B?dU5VTWE0cGdKUGpZZU43ZlYzSTl5ZFVDWWU4ZmRiYkdURU50ZTdHQmhvVVE4?=
 =?utf-8?B?NGl2TnBNMkFTZ2dNdnlqSHZhcm5EYUh4OU55Mmg1aEtCZHZja1RhMlRtTkhL?=
 =?utf-8?B?ZTQvVzhObUdhekRmTmFQaWhwMS81aHVmN1VmQjdqdTdGTi9ORk1vd3JqNDFZ?=
 =?utf-8?B?YW0yemVZenpVRFJ1Q2d1T2xqMmgwZG8rRWQ3R2l3WW9HYnc3eU96WWVrVndS?=
 =?utf-8?B?S09BbCtTL1liNDNBMHRPdmh3RmJTZUxnNlZJcWtHemZOR1VrVW1yNG91MDQ5?=
 =?utf-8?B?VXQvaEFwK3NsZ3B1TzFCeW5KYUkrQ3dUd3pWV1dVdGlYbnNEeXVEdFhHR0Y1?=
 =?utf-8?B?WUtkbkFsUVBCeXZDVVN6U3RJdUI1cVB5NkkrRnRad24xSVpJbXVvTER2Z0dY?=
 =?utf-8?B?ak45YmF5OE14bEV1V2RxanBPeVZjYkpGMnU2VXhBdE40RlZFUEVCb0xCNFpI?=
 =?utf-8?B?YjlKZjFGS1NsMVdUbGw2bWl2ejloQ0c3L3VBclVXTmY2ZDlRY3A5NUFXOWJT?=
 =?utf-8?B?RTF2QldkdWdCMDVkT2tTcjkyRGF3S0c2ektYclZpUjdPam8xNDVSQnFKbU8y?=
 =?utf-8?B?N3AzaVp5VlBDOGVYRTBlR1ppbGZiSWpwQnE5N1pxT1ZxaCtFVFpyZjR0OGdU?=
 =?utf-8?B?a3NqbUpweHlnYW1CTlQ4clQ4VzRYSGRSem5ocE1NcnQwcHRxek9RdkFSSllH?=
 =?utf-8?B?QndCVE5Ka0UrNDVsc0QrN2c5cHNXUWs4T0xrSk5CQXM3ZythVkkzdGpPVUVO?=
 =?utf-8?B?WDhEY29UYk52RHBjb0VDQU1Iak5vNG9vR0RrVzJkTDhINTNmczFmazA3YldR?=
 =?utf-8?B?SEk0cUJOaHlWNC9pc1hNMitFbnNFTmxSMFZRVG8zTVZaY0EyVm9kbDZoTjZP?=
 =?utf-8?Q?2QcUnvLRGOg2lyT5E1d1h7U+cdcsQtG7?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7476.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?azJMYXZxQWFLM0NQeng1VkpxWTZCYWR3R0RkYTdLTDZIc05YTW1YRUxSS1Q5?=
 =?utf-8?B?OVhzTGZJMGtobnpHeW50ajZ4MU1rYmRnRVhtU083RjdiYXVPWFZLWDE3b2hn?=
 =?utf-8?B?Y2JIREVmakVzYUVCMU5sQWlUVjg4Ry9BVTM0bWFUSU83NUtRQWdONGhCd3kr?=
 =?utf-8?B?ZTVLMm9iV1l5dGdmVWptSTMrSHdLOTFBUFRXNGY5YUxXc0FJbkdLTDI2M1c3?=
 =?utf-8?B?MTZRaDJLeWxieHV1TEFhTWtyVnFMdHFxUzBxMUJKYTZVNDFTdkhxY2oxcFRK?=
 =?utf-8?B?eDQwcW5LdGRBOVhCZXhsajhlc3NoRTB1RjFDRnhjQy81NUExRTJBWWJYbUdY?=
 =?utf-8?B?SHRTank4emdBSjRqbTNQNVZVZGUxVmdvZmlseVNFY3VYREJ1c1ZIUzVWV2hX?=
 =?utf-8?B?a2JjcVlzVVhGWnF6Wm9QVU5xa3FWcDJXNk1KT0lkM1h6aVhzbGtxSjZ4elZG?=
 =?utf-8?B?MTRIMWZiTGlVUFZZamROc2ZkOTNVNWpZWnFyVUFCYk1JeVNxSnNJT25uUmpT?=
 =?utf-8?B?UjZZdzZLSkFPTzB0aE01ZnVmV3UxZkszeUkyQ1F5WXAvL1A2M3ZKU0hjSXBF?=
 =?utf-8?B?QnQwSzRDK256bUNoZ2hlNnRsd280aVFyck5PNGJpSXFud2dNTDYxdXRSUExy?=
 =?utf-8?B?SnhJSHlHWkhWbXpITDZQM3lNclNva3NJUnRTdE8xZ01HZnZ6TklWdEliZnFu?=
 =?utf-8?B?U1p5QlVBaWdvdkZ3UzNBcE9BVG1Cb2Q5c3hXdG1HYUtaK0N5K3FtVTZlcEFR?=
 =?utf-8?B?eHd3QldDamVFdkk3L0hRU05RemQ3N1d5QzlMRWZVOUs3K1MyWmtrY0ZvYW1q?=
 =?utf-8?B?aG1CNU9IaCtlSmNnNmFKSFNpZGNUL1NHNTVIMU95dyszQXpPdnhvRjY1SkRz?=
 =?utf-8?B?N3VTRmNSTml1N3dXOTVHY2dWN01Ybi9OWDkwaGcyem50SzNzUTQvUTdzeGUy?=
 =?utf-8?B?OWxuZDV4R2oxOXQreDJFOHBxbDZvcEpva2h3QTFudkI4V05RVXptdFJDWFp1?=
 =?utf-8?B?bnU3UkhIWUFXcDRodGRuR0ZRU09ycFBnRVUzazRJV21nR0lIYVBPZko2NXhE?=
 =?utf-8?B?bzBkZVFLTHpBNXZYZ3dXYTE3bG9SMERYME5BbzltZVZHVHlaSXVUbURLUldE?=
 =?utf-8?B?WXVYVytlM0N5bEhwOGJYbU5tdXJUcC9TQzJCNENMTTVJeVdRUFRocXpCaVhj?=
 =?utf-8?B?QmZoZXlNN1Vvbng4NGJSVm9vQ1FKT1lVUlBySy8zRW9iSkp4UitVUGhuNW1O?=
 =?utf-8?B?NTVyL250blJMY1ZWMmh2Z2JFaDQwQ1NTTmliUVl4cmNzVHFFcm1TVHVqZ1Bt?=
 =?utf-8?B?Z0tDdlVZbEJnZjN6M3IyYnZBV0pCcVQ0SFdRZDJ1cHZZOU1BYVh4aFpQQzRZ?=
 =?utf-8?B?V3ZLMk92ZkJrQTlrRmt4WkFmOUlhNVZobGRqZjQzRXcwOHU0a2tUaVVsVzBF?=
 =?utf-8?B?b1pjVUFLSlVYOHl6QVJ4clkvU3VnK3hlSVZoZEJEd29FMDBCNDY4SjdkYVBn?=
 =?utf-8?B?T0tFYUo3RlJPb1NHbk5OMGRESU5SZnk2TXpGTTBuNFJ0VkNrbWpLL3oreVlN?=
 =?utf-8?B?V3RxRWEweW5mSUdIS2dvZytnd1R1QW1qeXl4dUsrY3N2NmZ0QlZJTThzYzBU?=
 =?utf-8?B?K0tBU0YveDNEdzJaZVdTZlNOL1JIWG9qTWdlK1ViRDV4RjRWZHU1NFk5VS9X?=
 =?utf-8?B?bjFQWHZwdzBXblYzcVluQlJvRmdTR1ZCcU41anh0OG44dEx2MHhhUmdQNVli?=
 =?utf-8?B?NnRUREF3L29SdVVNcDNTTEhYTUZWSFErUmZOckZWekpMQnFjNHpvWXJHQVcx?=
 =?utf-8?B?YXFISGpvWmNXRm9ob2VlWUFnVHdGRFpqZ3IrNXMzRCt2RXhlSXJsVXNIU0Rq?=
 =?utf-8?B?Nzd2bUxUTkprd1I4V05mOE11RFZWaGxZeWdyZFNwZFl1U0ZHc3dnbGt0bW1E?=
 =?utf-8?B?bDVHR2JPaWh0VlBIV291d1Z6NjJ4RnVSSXRWVmdmcDhZOHZxKzJrQkV6bzQv?=
 =?utf-8?B?TWhNQUFGRWk2VFpibW43Qno3QmQzNDdVckRia2RTc2JGeG5WRW1jWXJXY3dX?=
 =?utf-8?B?bFVFTU96MURoUFZmUDI1T3g2eXNGTTJyRnVnV2ZuaU8rQm8vaW54ZGNzZmFP?=
 =?utf-8?B?aEgxdERFRDBXeUdna0ZDTWtyUzIyMW1rbnN0d1loZTFnaktuYSt5a2pjRG5M?=
 =?utf-8?B?R3JnZmdGQmZSdnhPbmtrcXN6TENvZHRBNUN0Z0ppUkFKNStQclJjNTNkNUZn?=
 =?utf-8?B?Z0prNXR1L1FnUWpGbFFkbGgzZVFlU2VXMmQ1dHdaWXpBcXRWUUNjZEc2cGFk?=
 =?utf-8?B?Y1ZOZGN0TU9hYUZ3RjV3RFg4V0tZcE8yaTFDVWk5b3k1UW5ZRC9QNkthTnFY?=
 =?utf-8?Q?YliGdxHOOb4r7R6w=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5wx8XkI0FgTG4RPNmC7ffvQ30+0V9DjTR+gkWg82SCgHtqmVCINs6vApRxFchvUrKXT3XWYxEOarCCQzY96ZfOFz8tkT9pjI2s19lbZaPbJ3icJy952nlKiPreJERTG5whsg7y1tRSUU3StDndvtXIp7R/lF0toZzJqRzPXrkqtpfGj2UMocr/lMiE6uXlZC+5kqL4ipJ1D3mdC0vZQP84MRyqE4Eon5Zdiq1SVWXh799wAdoJbs1Bqdsk73xll8Hq+O7QX/y65IZ/6g+KqrSsVCMk7st8FGz3+rZXru/ZOMEfDHxdREOqklH0gMkOhgS0S7QlmvqmS6IlC6au34yXsnzZY5MvxlodhgO6iPM4iOtnCByiy2IUbIgbTPsAkDh1NIU4Mp47T5y9hx1KtSr9LnI6d7rMgUnFjTuIZh3QksHpAaLBInoyB9lEAliC437tB87UQ0qLSZToehVxoU4A5MEqq8JbP4PznORcqy/Xwb8MjY4iKnqeWVLxTZjz6JlRFet51QOtrWbKWHzO6IcHhNjLPvfWWn8aaaKhe+ncrR7RgBf5f70HBWLhHWXWOhv+JehGOuidC3S6MUJR+kuGGVJKegvjsTxVxH41HK6A4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 732bac1e-1ee2-42c8-ab44-08de47d61100
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7476.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2025 19:03:06.8998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wU1JMVKxHSaz3eq4/hfCRStPcsky6mZwW1C8Xp0fQH6NH2sHS5lytpmF3GqJPTVBEKp05a2GeOBbAm77NscdBmirBB04oZkFSGk3XpckpzE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7342
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-30_03,2025-12-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=913 phishscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2512300171
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjMwMDE3MSBTYWx0ZWRfX45M108KDGl2h
 Ek2vmPAAeAtr0vK0SxMuUDrgtGTLu85dEuEru/+RT/eiB5WlWpptUn+2S8Gpk5OiM6efnY1MLVq
 7ug1hqLv5kiQ8ca5oD/wB4C2k1O7jFoKgJPTWmiEzXsTTgj00drvIx4jPbrbFKMpCIttN5RYoRp
 Fz9NzPHgvRwy6U3J8wkaqLMmxYO5a7Dim7i94mblCpXRfOajfx2khE37uw4WL4dAECATUj1dXx9
 ztz6TcFEPloBGAkZ0wSMzDO9viRXiczos938/KTI9VRL4C3S51d8LKlWbjz3EecnOHwmIpscmOM
 6X0yXwQBc3ZyLcMwp4Je5tgbjukJ5ydvCtAZ6dXbAnqPmcYb9ScW+sc9y0pyhofMtYFSo4enHqz
 r3x/Cri6G/PZNbFyjq8xgyM7TQZbrdk4IPonJyzoi8jR2AXVgfhvJnKtCzltDB3aeT0KvrjxKpM
 VLTir+b08OnlUCuhA9iN7MXjcWHS5parlYn/6MBk=
X-Proofpoint-GUID: n2nodYTKmwdD0pVTEVKKTltBf6CH1Szn
X-Authority-Analysis: v=2.4 cv=ccjfb3DM c=1 sm=1 tr=0 ts=695421f3 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=awnD_I-WXSFK71HJXPUA:9 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12109
X-Proofpoint-ORIG-GUID: n2nodYTKmwdD0pVTEVKKTltBf6CH1Szn


The error path of xfs_attr_leaf_hasname() can leave a NULL
xfs_buf pointer. xfs_has_attr() checks for the NULL pointer but
the other callers do not.

We tripped over the NULL pointer in xfs_attr_leaf_get() but fix
the other callers too.

Fixes v5.8-rc4-95-g07120f1abdff ("xfs: Add xfs_has_attr and subroutines")
No reproducer.

Cc: stable@vger.kernel.org # v5.19+ with another port for v5.9 - v5.18
Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
---
  fs/xfs/libxfs/xfs_attr.c | 6 ++++--
  1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 8c04acd30d48..25e2ecf20d14 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1266,7 +1266,8 @@ xfs_attr_leaf_removename(
  
  	error = xfs_attr_leaf_hasname(args, &bp);
  	if (error == -ENOATTR) {
-		xfs_trans_brelse(args->trans, bp);
+		if (bp)
+			xfs_trans_brelse(args->trans, bp);
  		if (args->op_flags & XFS_DA_OP_RECOVERY)
  			return 0;
  		return error;
@@ -1305,7 +1306,8 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
  	error = xfs_attr_leaf_hasname(args, &bp);
  
  	if (error == -ENOATTR)  {
-		xfs_trans_brelse(args->trans, bp);
+		if (bp)
+			xfs_trans_brelse(args->trans, bp);
  		return error;
  	} else if (error != -EEXIST)
  		return error;
-- 
2.50.1 (Apple Git-155)

