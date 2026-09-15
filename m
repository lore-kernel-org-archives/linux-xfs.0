Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C69DDA9;
	Tue, 15 Sep 2026 03:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789444215; cv=fail; b=CgEjIxC+q/ZK0eAHAAnxQGrYE9YZ/p0joqvCWH61fEYw1zuL85Wfs36XmwqFgGFuAMpbAZHm/nGVb94yDtW7Rs1nGwoD0n55dDpKPYSu7p/EIku0sw5/5OoMKRoKOKjhu+f09123a40azb2X/mRWwpl3gnz0P0TWm49t0zjByG4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789444215; c=relaxed/simple;
	bh=DjI4osFzwDQZ++h7awz+JxKTIftFw20f/zu/4KRjf7w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tOQE22Uqh9yFBwcMa8fV5tk1dDw/i8nMOBuErYcxf1cR/VQtNaiYbNTueu/xvwN+tGBn4LIDyixSQodVRwhphBvHDIfMghkDdm40A0X1jZ9n4KzNLc5kltV01Avu0wFwoHfPa7zioZOQvIOx/2HCTjbdRTgr2956cicGQDr2ty4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=kPJ1EtKT; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="kPJ1EtKT"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68F2mhou2474481;
	Mon, 14 Sep 2026 20:18:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=4a/ldj40IairL5woHsM44r9gV3ZmXQxYzZkfsoLEaQI=; b=
	kPJ1EtKT0ychJtJ6QQ/8siF3n0jittHAI8eyfhuBBZ5YEeUwz8RH4xio4q1IjQlJ
	E1CKPO+c7lq7124lJxiFUrVAcmeyDZ7NlSD4BQs2WIQ1B/DHL+CusWFtHUE+sfR9
	uZ+k/WdWrCDBcWeZBrJgG3K08FGuZXXPOH9tKf18/LRiESbzuQErin/mJuALlOkb
	ErJeFFiS23RIZzckrJ9+/aIAHilaNJQcY3xkogrTkvQC09vhCtJyfJ0nrd1d0cFC
	O7ho0soGald2Dn55NVDWx6dN+wk/iLyzuab0Bb77AL6pZM6h9dLDhvfbe/sNj5e1
	f3GDz8s2c9p/gvamGz168A==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11021095.outbound.protection.outlook.com [40.107.208.95])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4gn68g4bpt-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 14 Sep 2026 20:18:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QbDde+yy8h4lfRfGN7ycxIWS8nUXrB3sg5M2Hgw0uKZ5GcJxS4Al2yg6OQDu2/h3hDOYwotodRhN0LWp0BE5xhZWun35+Ev+NHV1hZ5PvTuUk+2Z93yRBsQbzuQaCdf0Vj/4/fmaap+kHRAhR+TPnCf9vmh8OmmxntJzLVRFH6sLqTsaaVt4EMe2x4gGkAItdw+tUyBCP0mQITT7oajcMIeGVObWk1S3Xro5nVTBIY85DYjCwX/n3jkvhkZBkoXzxsJgms6VPvjQ+OhN9AO7rk2K3+WUJVDS0tY3tMbLN0JwR79xw2jLdG71XFC9vi9U8hReTuBRdsXusB5KIbCQxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4a/ldj40IairL5woHsM44r9gV3ZmXQxYzZkfsoLEaQI=;
 b=r9JfsYE1uu0KwayxBWqkiVM83BULajqWtBKRQ112nsjEjSX0nnwcpEUga1i3UP4ewYxmPYFJdTU+eTYeNXPjZnov28h+WAXLXAcaUyC0StBuP8Vvik43dj+z+pnE8f1V6ujIuVqEgDR2pXIXsV4NYRLQ6651odUC9eDT/GBrgGcyBQEJWkQU0kKzHZzwHX+FD5fueJyS5pFTDbDmKkDO2IioNIRp/x4BjnP1T8YllSMiyaQdnR6xb8dOto4FE4hbEXJDW7QaYUsCMxB+UovhP0EpQA5L4pL9YpVRzci/DGDYYRT1VCCbFC1PSQvvx714imM4nAPZpdocWedbUv8v7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by CO1PR11MB4947.namprd11.prod.outlook.com (2603:10b6:303:99::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Tue, 15 Sep
 2026 03:18:54 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0406.007; Tue, 15 Sep 2026
 03:18:54 +0000
Message-ID: <4ff8e91e-a5b2-4754-ac9a-20f64f169af0@windriver.com>
Date: Tue, 15 Sep 2026 11:18:47 +0800
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v3] xfs: don't hold buffer locks across sync transaction
 commit in xfs_sync_sb_buf
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260731031010.2627884-1-yun.zhou@windriver.com>
 <20260911174247.GK6265@frogsfrogsfrogs>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <20260911174247.GK6265@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SL2P216CA0205.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:19::15) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|CO1PR11MB4947:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f7e52cf-f653-43dd-795e-08df12d81225
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|6133799003|18002099003|22082099003|10067099003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	MS3gMqZuGYGIn+AJ7hw2FmiTW6ZS+z4aKKKjwSKl1KyzsxaH8YkhQ3bFEUPdHy/W9LxfmoO78EjBvxr5aAjCMvDMWYWRaCtca3H6HbzkVbuE1JKvaLk7Ba38HFcv5TQNheinRWV4Xs9QFTumLQb6XEQ2TGzIP0xgdGJEwFlAEwV3rX5phvtifM+agVNP7aW7CAFb3jLteiOGKYVB0e8PfS7//iLJLPggyMgAR0D4pg08lZXWgPsGG1NaiJGH1pCRF9x7ivXxoEFKnt1dnjvG5fN6NbmMaEtZDFEJxhc09y297MsTVSNkEJJDwnHM2lmrp/NnuF8kQWPPysrv9R33q8Obff8N6raxvFjqvFVroX6LAqCW4tb+5ntXbAADGb2Ju/iDCSpxF6zjw09wzwU2cr94oXszW6k1u0GBm6iuHBS7VSLuph0HkevsqFdkTv3tO995rRMRY3JynBL2yqCuaZEw39LqKWVMP3gDH78GPyXWpf4Hbgo8uaOPoLeE9BFb9edzA/D7dL0/ZW5Y/za0KkIVcWYZHshAXvHysrEzb0B1nlLmOg4FtieIs98ac7YPC2KiXploo29Kglrd5XOkgYBoWh+vYPwGfPQOgNuTi9AteU5TFXBFYrZYWczkxavb
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(6133799003)(18002099003)(22082099003)(10067099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MHVZL251UHJ1QlBIMFdhWWpHaThGZGpuNEczMzlBV2hLT1lzVWk1Y2Q5ZE56?=
 =?utf-8?B?TFIyMUtpQ2U2bldmZGQ0Q0taWVBUVTBoYXlpWVR2a0g5T3pqNFg1TE15Vlhp?=
 =?utf-8?B?RGlobmZsLzNKcFJxVTZabkJ3d3ZKdFJFV1UxOUZHaUhkM0U0VTd2T1dTek1X?=
 =?utf-8?B?L2EzVXRCRVhVOU95ZFhqdUVQRlBqdzVMREdBOTBDMHdLOFFyOVlGSFI0M2w3?=
 =?utf-8?B?Q0JUQlpRM3hFUUoyV2o0OXpWR0VCbmtSTncxSmZUakZKUndPL1V3ZmNlRnR3?=
 =?utf-8?B?U25Pa1B1ZmJlT3VuUExJUUJ6ME1NZ3JlUlcyczliMWFSKy8weENIaUcwRkpu?=
 =?utf-8?B?U2lybkxkRTdKa2FzeHhFdWdFSEhrNXpoeEdiZE5FMm1sS2paSVJkMnVBbkd6?=
 =?utf-8?B?dkNFUTNDMkRac0dPMVVoa0dhSFQ3b1hZaCtHZUd1M2k1MklOQTJTY1I3RzVa?=
 =?utf-8?B?YTdaMnNqN2hhUzN6N1VpbmVxdVA4TjJ2U0dISzlabmR6QkIrck1FcEx1Mzc2?=
 =?utf-8?B?YUtuWURPS0FCcFZSNHpzcGtlcjRKbkhrYjFPVUl6akVSL2lCN2xBNEY2WWUv?=
 =?utf-8?B?U2x5SXFBeXpkcWdoYjR2WmgyZnArem1oV1VsMjBId3hOQWJ1Ykl0dFVkc3lC?=
 =?utf-8?B?MFRNTTdFWUtvUE5rWkdyMG9wdlpHUFVwV29DeTJXdzlDWHZ4TjhiQk5jaE9Y?=
 =?utf-8?B?RUN1Q2lmcjF5UWZjMkszMUFDbFNseG1rL0ExOURXYWM3TVNGWCsvcmVFV0RP?=
 =?utf-8?B?S3FsSi9ZOHlSYU1CcVgvMVMyazUxTTArNXRhWCttbGlRd21abkdXb0VTaG02?=
 =?utf-8?B?NSt6RmhIOFJjM2pFN3g1bFpYb0tydE43WndId1V2ajdMN1VVWVJieXNsNlVE?=
 =?utf-8?B?L080VkI5dzJDdnV5dDJEYnptRHVyUElQQ25mdlg5ZEZZRVdranM4bE9vclZT?=
 =?utf-8?B?UmNzZzFwRW1BeHZTSXZxOHlGYmdZQkYxQUI3cWlnaytiM1cvbDNkN2tTNGVX?=
 =?utf-8?B?eXQ2S3h5ejZpU3ROU0VPbGNHVS8yenVzZEFjd2cwZTlZNThpanZzQ1BKNVZR?=
 =?utf-8?B?QmtNQjhDRFRhSnlEN0JGRXZDa1pDS1Zjc3Y3YTlicGxrSTJjRHkyaWEyZENU?=
 =?utf-8?B?NWJhKzBqN1Y2TU9oNjVkQjRzL29DWHpOaUtwT1l2L2dHbWhLcndOL1BzQW8v?=
 =?utf-8?B?U0dHSlZadmJoZTgrZnI1cnJSSExGZ3FjTUhVQWRVQVkyR1dGZFRzWEhobnNs?=
 =?utf-8?B?eUVVNnF2cTg0Z1BGOStxTFRJU2xZUGR3M2swMVRaOUFXSWo0VHNhSXY1WnpX?=
 =?utf-8?B?Z2JEMTM1a3BsdmFLS1NYTjBzNDRWQnJNaVVGc2RPSy9sL25iWjBEOXFqeU1V?=
 =?utf-8?B?U0N0ekRHMXcrMjZOME5zWjJxUkxTL1Z2Z1lpUUVqT1pLTE0yWGZjUTU2b0du?=
 =?utf-8?B?b05uYkkzZ3lKTHpiQ0d0bi85blgvNnNycEpxNzRLU2hSaXFLQnJIbCtDUUxr?=
 =?utf-8?B?NmJiaTk0VUNJczArY3RubWVZYTgySXdhNTFuQlBVay95WVhuZzJBSEpPUU1J?=
 =?utf-8?B?QmxiRmJ5U3hMbnQyUFVRcUpLYVZEODUvQ3cyK01VNFd1dHBUblMvM1hadDk0?=
 =?utf-8?B?aGE2LytHOTk1UlZLNzZPME1naUgxNzRVTE9FQko2b0lEbndlNDI5QmZOL0lE?=
 =?utf-8?B?RFlpWjBMNGpvWFFoaXAvMmZDaEdLSU5FbGx4NTNHSWpLelJaZzl1M2orM1dC?=
 =?utf-8?B?R3FmTW1zV0M4Q1dZVTdPeWdYQVh0dU02Z1lOU3RyYTh2Vk5Na0hRUG9kZXEw?=
 =?utf-8?B?TTRxS3d3RW1mdWxsTm9VWFZ6T1dRUENnMU1DL0tlZ2craS90ZUNzcU56VU1G?=
 =?utf-8?B?YUFPSmZNVlAwZTRPa1h5cktGZ2ZMRDY0Q1JRQmhpU2IzNm9NQVNvQ2VRTk5B?=
 =?utf-8?B?aGd3bnh1T1UwK3gxTXdnMEFuZzFQaFNDTWNoUEdXS01pTVhQaUFYcm9EdzR4?=
 =?utf-8?B?aUo3VER0ZXpyZm5qYzJEd281RVo5QnJwNTgyRTU3cU5yaVhtRmJjUGhkRk9j?=
 =?utf-8?B?MThhblhYL2dsbHJwZjRBTGpQT2paSjhpczdXZUpmdjJCMFRVMDc1YUpyeU0z?=
 =?utf-8?B?L2VPRngrTmI3ZmE0Vkk5dkwza0FUOWZ6c0t4ZmxQL1p4WjJiR25HNW80TXNG?=
 =?utf-8?B?bFphY21iWU95UHQ0TVNqYk4vU3FlbHdwVGVuY0ZsN2FaUVN5UlRqOWZ5Tit1?=
 =?utf-8?B?TGNwQjMyOGNWcEV5Y0FjUHk5cE0zYS8wWHVRWHNJaElaTU5kczNTb3o4OGRR?=
 =?utf-8?B?VGVPdW5rcFJiWHlodjlMazlmaFQ0NSsrVnZaaWVIYWZ1N3pTZkR5UT09?=
X-Exchange-RoutingPolicyChecked:
	ymBDZwzcYcUun0u5VjDXsmhfxQu7lYDcPdaYefERK2tsyOs72JluuYkunwUZHBYrPDvOj5GN2o+SaDt9sLfSAXMuwyrcxbMCXQyerdPBnm86XFx7owMu6vJCnFpW/iWoThdfPTA2v5dBFC66RzcuXi9HzE8M0F+jIx3NiQu6BWShuFHG7TNPMZRrwRyOM6+wJbG95fmQd9zYP6AJAvtfHhDByFs6B5YJqwJgxhAa4aWuYk4O7xoet25LCrcJZs7enzd9w18s81wEf1rS+hgzSN+MVdCqAgjBhDamXFyYlhOlfIHtxOLCte3doGW6mUuCDrqxMabRXR3WtVlR4hatgg==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f7e52cf-f653-43dd-795e-08df12d81225
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 03:18:53.9368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Zfkb/nzaPzxyGfR7MI+WsykJq1lwppYa4MzE+fuDFy7IZ0rLG0I2cRbwGMzy7xDRHFmIOcsygeNneLa0P7z2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4947
X-Proofpoint-ORIG-GUID: FkNqu9cklUsQh11tcis6-Qvg0CvRDrha
X-Authority-Analysis: v=2.4 cv=cswOAF4i c=1 sm=1 tr=0 ts=6aa8b920 cx=c_pps
 a=skfC1x1gg3P3nT2FkZteTA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=iKiJcTA2PjBS6x5JeXcw:22
 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=VwQbUJbxAAAA:8 a=t7CeM3EgAAAA:8
 a=w_CkZxRl3krUMGRYZBwA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: FkNqu9cklUsQh11tcis6-Qvg0CvRDrha
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDA0MyBTYWx0ZWRfX1BNBNSQhy17K
 1J0JeEO/R0SlpSm4/YFZ1JfcmlqfvSx2izFG5UBpMUTZxbBWj6AKSSTUDGpu00YoyJqDTc5/OwQ
 Oh7HABsFnEG3yQvGYnfqu0mtvxIHhS90kDlwW4ANojXHYLedpkQY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDA0MyBTYWx0ZWRfX3NZ2i9d19A0d
 W3I48orIazPNITAnmnBeNjLuI/Cis94HgopruX16bK2tACXyVsbEG6IaowO9By0vD8k2srZwwWn
 1ql3wvJ1K0EmeXe756GEX2dvzfMmO44FqrrgUmPJDnr9oT6DPl/HobPF+fPqGNU7SvKecUbSRsW
 6cxHp1n6TQBVpTt2t3eoJgTuQ9rs92vKqvwICttvUXsOKwdRmyChIVgMFxeHq+RrzAr55m76GKP
 8iRiQ6RjJkaNnoUgG5iiilgE+pwOFeeji5B/6q8ED/pK3mp0/2ABdLC+h6rc+eP9E3tC52p90Cc
 3rVwowkrJek2b00/aKqbeSvZoUV4FlnZsMwsDr6HwqcxCGXP6L7x4y4VKu+zBWKh51AfdQrIe2Z
 bPlFR7gnCcsrEyNRjIOSXMct86qfVIh//9KdY4tBkjFJGt5rBXP5IBmThufgWWXyrzeoHS9vwXr
 mXb+f5PpJ/QZSdwaTKg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_01,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 adultscore=0 clxscore=1015 spamscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150043



On 9/12/26 01:42, Darrick J. Wong wrote:
> CAUTION: This email comes from a non Wind River email account!
> Do not click links or open attachments unless you recognize the sender and know the content is safe.
> 
> On Fri, Jul 31, 2026 at 11:10:10AM +0800, Yun Zhou wrote:
>> xfs_sync_sb_buf() holds sb/rtsb buffer locks across a synchronous
>> xfs_trans_commit(), which flushes the CIL push workqueue internally.
>> If shutdown occurs during the CIL push, xfs_buf_item_unpin() needs to
>> lock these buffers to fail them, causing a deadlock:
>>
>>    setlabel:          holds buf lock -> flush_workqueue(xfs-cil)
>>    CIL push worker:   xfs_buf_item_unpin -> xfs_buf_lock(same buf)
>>
>> Remove the xfs_trans_bhold() calls so that commit releases the buffer
>> locks normally.  After the sync commit, re-acquire the buffers via
>> mp->m_sb_bp / mp->m_rtsb_bp for the on-disk writeback.
>>
>> Fixes: f7664b31975b ("xfs: implement online get/set fs label")
>> Reported-by: syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=837bcd54843dd6262f2f
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> ---
>> v3:
>>   - Drop xfs_buf_hold/xfs_buf_relse, use lock/unlock directly (Christoph).
>>
>> v2:
>>   - Remove the bp variable and pass xfs_trans_getsb(tp) directly to
>>     xfs_log_rtsb() to fix compilation warnings when CONFIG_XFS_RT=n.
>>   - Convert xfs_log_rtsb() stub from macro to inline function to avoid
>>     the need for (void) casting (Christoph).
>> ---
>>   fs/xfs/libxfs/xfs_rtgroup.h |  6 +++++-
>>   fs/xfs/libxfs/xfs_sb.c      | 37 +++++++++++++++++--------------------
>>   2 files changed, 22 insertions(+), 21 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
>> index c0b9f9f2c413..fca2eb74908c 100644
>> --- a/fs/xfs/libxfs/xfs_rtgroup.h
>> +++ b/fs/xfs/libxfs/xfs_rtgroup.h
>> @@ -359,7 +359,11 @@ static inline int xfs_initialize_rtgroups(struct xfs_mount *mp,
>>   # define xfs_rtgroup_unlock(rtg, gf)         ((void)0)
>>   # define xfs_rtgroup_trans_join(tp, rtg, gf) ((void)0)
>>   # define xfs_update_rtsb(bp, sb_bp)  ((void)0)
>> -# define xfs_log_rtsb(tp, sb_bp)     (NULL)
>> +static inline struct xfs_buf *xfs_log_rtsb(struct xfs_trans *tp,
>> +             const struct xfs_buf *sb_bp)
>> +{
>> +     return NULL;
>> +}
>>   # define xfs_rtgroup_get_geometry(rtg, rgeo) (-EOPNOTSUPP)
>>   #endif /* CONFIG_XFS_RT */
>>
>> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
>> index 47322adb7690..2664728f2d8f 100644
>> --- a/fs/xfs/libxfs/xfs_sb.c
>> +++ b/fs/xfs/libxfs/xfs_sb.c
>> @@ -1470,36 +1470,33 @@ xfs_sync_sb_buf(
>>        bool                    update_rtsb)
>>   {
>>        struct xfs_trans        *tp;
>> -     struct xfs_buf          *bp;
>> -     struct xfs_buf          *rtsb_bp = NULL;
>>        int                     error;
>>
>>        error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb, 0, 0, 0, &tp);
>>        if (error)
>>                return error;
>>
>> -     bp = xfs_trans_getsb(tp);
>>        xfs_log_sb(tp);
>> -     xfs_trans_bhold(tp, bp);
>> -     if (update_rtsb) {
>> -             rtsb_bp = xfs_log_rtsb(tp, bp);
>> -             if (rtsb_bp)
>> -                     xfs_trans_bhold(tp, rtsb_bp);
>> -     }
>> +     if (update_rtsb)
>> +             xfs_log_rtsb(tp, xfs_trans_getsb(tp));
>>        xfs_trans_set_sync(tp);
>>        error = xfs_trans_commit(tp);
>>        if (error)
>> -             goto out;
>> -     /*
>> -      * write out the sb buffer to get the changes to disk
>> -      */
>> -     error = xfs_bwrite(bp);
>> -     if (!error && rtsb_bp)
>> -             error = xfs_bwrite(rtsb_bp);
>> -out:
>> -     if (rtsb_bp)
>> -             xfs_buf_relse(rtsb_bp);
>> -     xfs_buf_relse(bp);
>> +             return error;
>> +
>> +     /* Re-acquire and write the sb and rtsb to disk. */
>> +     xfs_buf_lock(mp->m_sb_bp);
> 
> FYI, this causes porting problems to xfsprogs' libxfs because userspace
> doesn't have m_sb_bp or m_rtsb_bp pointers in struct xfs_mount.  It's
> not a big deal to add them, but if anyone ever wants to call
> xfs_sync_sb_buf then we're going to have to figure out when to populate
> those pointers.
> 

You're right — the problem is referencing mp->m_sb_bp / mp->m_rtsb_bp
directly in libxfs. I can avoid that by going back to acquiring the
buffer early via xfs_trans_getsb() / xfs_log_rtsb() (as the original
code did), instead of touching the mount pointers.

To keep this safe for a userspace caller that may not hold a
mount-level reference to the sb buffer, we can take an explicit
xfs_buf_hold() after getsb so the buffer stays alive across the
commit. Unlike the original xfs_trans_bhold(), xfs_buf_hold() only
takes a reference and does not keep the buffer locked across the
commit, so it doesn't reintroduce the deadlock.

Alternatively, since xfs_ioc_setlabel() is currently the only caller
and it's kernel-only, we could just move xfs_sync_sb_buf() out of
libxfs into xfs_ioctl.c.

Since this is already in for-next, would you prefer an incremental 
follow-up patch, or should I resend as v4?

Thanks,
Yun

