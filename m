Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05EE02E3705;
	Mon,  4 Aug 2025 07:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754293333; cv=fail; b=auRvjevduvo+onmyTNTgnSrnQ9uCB/UjUsogkRYz3RqBxMFDvnAuc55/G3HIOX5p1ULgNDaJU4kchdIBht/qVFNhmqq37ikBOHQ9bT9FpEUpYCmODdrW5E5bAJBrji6OhtorHBWrvcVwwGuURpI7w8c++U4H3cqAJMLVTTkJHdI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754293333; c=relaxed/simple;
	bh=b3d10NQJ+W/vdSq58QanKBhQ/7aSq3VIzpkDAVkxga4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=S1zVknCEBo1IreGz0SVm9GPhNNMX65AWKn6tKiJtCrKKRDKryLOpXefBJaAeXFNs29o3Sthsb/HWIOAzLT48LVHWugoRe0CjNFg6Aor+fzFSchbxA1UZsWJ4D2dw2/sXEFCCrX+qX0Fme/aPETLbvi8PcJ0TSq4wdBkztvyJlJg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=X4C1AJzL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ofwiV9bk; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X4C1AJzL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ofwiV9bk"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5747g7Fn012308;
	Mon, 4 Aug 2025 07:42:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=SbAD1MisHBCMpTFm6EOWJzyY0BevKBA4yorZSBdU9o4=; b=
	X4C1AJzLeu8BxhkfalbMC2PkfHnU1BkKrQ3qvZHoamOGBoApHBuzZBXF6fuTpVaH
	UbkYwtnZxGvwOh/pIer4kd2FJHKSPFlNPSBclKXLaPGqnsmV8NEXSiPC0f3ptKoW
	nh3M0NlxmirYsSj3r/rvPDZvN4gt7m4SiaXkfpjfMpYuf6FPHIJCcKcALonEZJKN
	VePRTYWl5zWZ+2JXT2M2+5miUWQVdX9GC1bA//6rf8MjZkjwkhb125Kk9zQoYn8S
	8iNuDgVOIllJNh/3JdpFhIckzk7m0Auy00YrZfDgdRgaA+u8TSi6psqVn1MRSsGb
	ksgR27ZkjDzfw2de1n7Suw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 489aqfj1mj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 07:42:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5746G5wB031943;
	Mon, 4 Aug 2025 07:41:45 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2085.outbound.protection.outlook.com [40.107.220.85])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48a7juabnu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 07:41:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m4C/5jOwQv6Pmz/Jm+1dw2PI7L/eiU9Q2boeVJV+QLK6GvhJdQ9EuyheDvwhIwJ25eX7eG5Lwg34j3fp5q9+otfjETww1vBWiwS7dxCdC/P5FUGXIdk5D7N55JNKHZZEOSVr3grwhWiuEmkEv3Cf4GVYY5QlFI1kvu2dUUW60+2raQF7/pNxGh70vVb5Pwh1NyzJyUMPWyZvmQNy0zfpk7RjcEhqr9nxcPvYwNJkAdrZ/xzU+8rVFtjlrZR8j0T+uDrRanugjXb3bGc4oPh0w2GeXbTuqz/fBSVuhSmSwUmmveaI1Re53JZzw6mbKd4yUKrXXvWl5ONXkZtlbu+Iaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SbAD1MisHBCMpTFm6EOWJzyY0BevKBA4yorZSBdU9o4=;
 b=MBXMwbOOVpIe+XTtFJfrfndBZa0EdaJaPIvOOTw9G76ffCi12hApML3xfw/6/9JmKAzxiCH1ivO8J3CvFl/qb9iafAifWy5Ab6dfI0367GXrrHCh2X6Avw6fDHyQ48rdhR9qM4Rkx9eEIJWrQmAc3P3tgZoSVQ/+lI6sfxQhsQ56E3iwQqzSFV4x7qSArcdL3jBJ7E/aKxNWoc1vuDmAVsQCkGedNoSGcPh/bVBVhnBqfUYvOT4l2gOqAZytyY2leSo1IRtW/Kl1XS6iFp0GN7mT+QAIEo7RW/4GWmkESieeIyDlpSHRh+LYLcBEf8Wyi9PVu5qbI8+TsR08zdVIUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SbAD1MisHBCMpTFm6EOWJzyY0BevKBA4yorZSBdU9o4=;
 b=ofwiV9bkjGdgDGL5yWiRWWHi9mAPov4NbWLfxvRgOIqVOMzBH7TqICPe0xHyR0Zcil1kBSD6rBNjyUxU8SYKiPkCvcCmwqCOxGgS1XNCy/H8UAPIbSCeigGLOjzSubx0aueh335Fw8XAqWfUNdc15+jY2GAgyKq28G9WhpfL8Qs=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by IA3PR10MB8347.namprd10.prod.outlook.com (2603:10b6:208:57d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.18; Mon, 4 Aug
 2025 07:41:43 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.8989.017; Mon, 4 Aug 2025
 07:41:36 +0000
Message-ID: <7afe34e3-7131-4f01-9a4d-0120f99f75c8@oracle.com>
Date: Mon, 4 Aug 2025 08:41:33 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] generic/767: only test the hardware atomic write unit
To: "Darrick J. Wong" <djwong@kernel.org>, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
References: <175381957865.3020742.6707679007956321815.stgit@frogsfrogsfrogs>
 <175381957973.3020742.7280346741094447176.stgit@frogsfrogsfrogs>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <175381957973.3020742.7280346741094447176.stgit@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU2P250CA0027.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:10:231::32) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|IA3PR10MB8347:EE_
X-MS-Office365-Filtering-Correlation-Id: b7cf2246-562d-4e45-8f44-08ddd32a5747
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ODhGQWlxTGpPR1E5Qy9UZFk5cTAxUE9jVkdpRnZ1Ri95b3RCb2t4d1lPUGpJ?=
 =?utf-8?B?bE5nMDQrcEd1ekZlajFKVTNZSDltZXg4Z2srYVhpS2NjNXZsZmNOMEYrd05v?=
 =?utf-8?B?eDd3aXNaclRDdEdsTm12SENMcTlVU0hkc3AyVkh0bFNVeWtmMWtWQkwwNWRZ?=
 =?utf-8?B?L05rM1R1Rk9LL3NPVlFSZ3NEbVhaUmRyYVZuZ00weUNTcnE5UUlqdUpST052?=
 =?utf-8?B?cHlDVDBRWGppWXAyUVJKMHVlRHVMN0VzdGJmeWNULzFKL2QyUXJ3czZWdmVT?=
 =?utf-8?B?c2ZRTDZobG52VDRMNzBxWUtKbFpiQzNkZmRmT25WS0lHY3JjblRhSTZWeUF1?=
 =?utf-8?B?akNYOVJxWER0L2dCVXhaUXB2S0lselF4YTdzaVNnS1RUSGVETDByMjdzRGFw?=
 =?utf-8?B?ZTYwWUJDdjFnWU1Ka2V2TlJsaU80SGQ1MWw3bno1UUdpV29sd01zL2pMOExM?=
 =?utf-8?B?N1ZkVUE1WU44eFRUUUdWRVpFY1R5SWgxM25JUzc5Sm9DbE1vVjc1UEtJL3JZ?=
 =?utf-8?B?NmkxbkJpeHUycUpQT2FQY3ljdkNFdy91eVphNXhqWWpIUU0xa251WXdVT0Yv?=
 =?utf-8?B?dFRqQVlrUHg0K3VEYUg5N3dxbjF6b0ZjQzRueFgyQzVrK0JQYjdoL2hSalU0?=
 =?utf-8?B?ZXlySmdoNEJhODBuUnRhdzV0YjA1T05nT2ZEYkNzTVJCd2Q2RjRnci9sakxQ?=
 =?utf-8?B?WTNzSnB3dVVWYkZEem9ZVjRST0lEY3N3emkwMm1DTXYydGtjSTYxRWsxOVFp?=
 =?utf-8?B?L21LalVFclNIY1didFMvY0lPV2p3WkVNYUxyWTVaanF1OHpxWnEvR2Q0Qngw?=
 =?utf-8?B?TGVFdTV5azdzNk45eEJwbmdjeUZFcVU0ZVRQVERHcUtPb0c5eG5vczNialJt?=
 =?utf-8?B?T3E1UTdiT3Y4STZIVVFJY21oN3c1bWNianZlNGNMM3hCajcyUUkvYmh1am5t?=
 =?utf-8?B?cmowUTQvVkxUdjRSMW4ra0R3dFpZaFkrVm1tbTFkMjJ3aXI3Qi8xcllBVjZQ?=
 =?utf-8?B?cUNSMk5jcnRSTUpWTS9iZXljTlNuTmptUWlkVmxZTFI1ckhXRzZjenZQci9E?=
 =?utf-8?B?d0RmSnZKemloZzNrZ0g2RUl0bHRzd3J4WGErUVNSM0tMRzZFb2VHRDQ4RStZ?=
 =?utf-8?B?dGxHM2Z4SUdsRzFJczNXY2M4RVpZSitsaWx0TVJnU1NlTkxnZmdMSEVFeHB3?=
 =?utf-8?B?cWFMa1pOellUdTNvbmdFUFQrVWgvSG1XalZscHloSW03WVZ5amRZMnp5aDVJ?=
 =?utf-8?B?aFNZNWNxQlZkSVRmQXlZRUk4MVdXVWlKaEd6alRWOFE3SlZVeFFmcTNGWU5x?=
 =?utf-8?B?ekRISE1GbU9YVTNsUThJRTZ6L3piaW9LVG5abTVkUk9iMFcrRzZMdTNsMmdE?=
 =?utf-8?B?ck9qSWk5MktTN0ZKNUFuNENzeGd0dWg0LzRhdmVGQzhvWmg2Z2FlZE5DdzJG?=
 =?utf-8?B?c1lmWU1Yd1ZBSURLZENBQXROR25BUDhyUEJPTHlMcU9jb1BQVi9KbWk1Z0w5?=
 =?utf-8?B?RG4wNmRBVU1vOVdWL1EwRU8xTUhyYi84VTlLRmVCUVZvWEdpbUxkZHZhZ3Z1?=
 =?utf-8?B?dkpOYU5JQWdrZnZNbU9EaTVMS3V6U3FLNlZvdC9tbkV6WWZLeWthc01YLzli?=
 =?utf-8?B?K291OFZRcEFyalllRFNOc2ZOdWRNaGYvcVY4TXdaQlF0OTMrNXg0aUFvRlhu?=
 =?utf-8?B?ZmpwVFNDMGtpa1kyQlZBTFF4THZBWnRrU0ZDL3RzRTIwVzJnS3cyWkloVjZk?=
 =?utf-8?B?ZzJ0RDNML2ZJbEYvc2tmTkh0aTYxSnFHTlRhcTc0Z0dCRHFnaVhRSmFtVUNZ?=
 =?utf-8?B?bldBeWROT3V1TUVpY2c0Y3hTZWxEQ2NOMHVKTFdmaU1KTHEzdCt5bTd6eXFa?=
 =?utf-8?B?dlJWRHVjUnlpMTZzTE8walFyZ1FobS9RYThNUHQxRjFWbGc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Yld3M3hGMGZDZURvSzU2bE9FNzhRVjZrUCthQXVaWnJKMm8vOWQ5bmdRalNK?=
 =?utf-8?B?b01oVGJaKy9hak4wTTZTWXY3V0xtSFJHTkRsaEFSaHBac3lWUmdha2lBcTls?=
 =?utf-8?B?Z0FHU1o3RFFYVnpRdTNmNWxuV3BnRXVYaUJub0Qyd000a2pxa1k0ajgycTk2?=
 =?utf-8?B?Q2ZmNGFwdVZJVWVJUGx1OFpUYTVXbm9IeXRwajV6M0p3MVhVSmxMOGZ2V3RW?=
 =?utf-8?B?dkEyblNrckh3RzN6RldCNjJ0RCtwTTcyRE5XQlVmUUI3ZThXcmwrUFZlbENj?=
 =?utf-8?B?WjlwMzF4L2RPcjl6R29JbVN1SlR4dHI3R092OGpRK2pmTnBjVFFZN3VyOUpX?=
 =?utf-8?B?ZUY1KzhkUG9pMHhKV2FVaW0vR0huWW9nekpRVUYvNlg5RnBjNFNmWXdzVk8y?=
 =?utf-8?B?ZGE2aE5rR1ZOL05TNDNjWDZkb1FYMlgwa0UxRXZ2T2RxWThKaEthZ0w4ZkV1?=
 =?utf-8?B?WnlZWlppNUx1WVluVktETld2aUJhTjNWU2xzeVlVdy81TklOditEd2RJMktZ?=
 =?utf-8?B?TmNHWlBZSndNZXJlTXNLUG54Z3dkSnh1clVkcnZvUWpUR0E3c0p6RjFYcUNM?=
 =?utf-8?B?Z2FzekNTUkovRFlZbkN5TCs1cHV0OGJSVU1jRER6ZXlWWVhsV1FDdVlYMnUw?=
 =?utf-8?B?K3d2T3dlRjhFc1V1a3plN3RTMWYwMVl2MVEzYzB6b3c5bXFnbVBHd1hLbGQz?=
 =?utf-8?B?TEE1RmRmYzJHdkRZQjloRVpMaTRKaGh1T2lROEJacUhycHl0bWw4NGx2cXp1?=
 =?utf-8?B?TzVDWnBZeFlTRTNQYUxwNkdrV2JxRmcrdGRQTElHN1dvanQzS1lzMVFRcExY?=
 =?utf-8?B?aUxsSk5qN0s3UE8zbDIwUEs0NVd0Q043WnZtMGpZMmt4MlBqR1NvRlkyM3Y0?=
 =?utf-8?B?Z2pmYWlMRGM1TnNOam9wYVBaRUN1SlJBUjZoZU5FdktyVWdvdEFvK3dsaVNQ?=
 =?utf-8?B?MXVncDJadDJTZDNrMjFadlNCTDBod2FFK3hHUjhxYTZzd24xTk9vRjFJY0w5?=
 =?utf-8?B?Q3RwK2RsdGxJTUZKWXFDNmtuMU1ZMEpBWEJNZitZZTBuMlA3VHFNbG5vUHU0?=
 =?utf-8?B?SjhIQTRCNnVDenJEc0ZqY3UvazBiT1hYQy9YQ0xFaHZCUEZTeHpDNHUvWkhk?=
 =?utf-8?B?czBLRjFWUzdSbjI1VzFrN1R4U1hLOEd1cXVzaTVJajFEYUNWREpUTE1rdVI2?=
 =?utf-8?B?bU1DQmRiTXZtNE5DVTRKOTI1MUcxTXJKRk5SSDVCWjBXTVU2OTBaV29uUDVI?=
 =?utf-8?B?MUg3dlFyOXpJdjRHbW4rbi91cmxsYzlhblBENGVDT3Y0M2x0bGNaVjR1TFQy?=
 =?utf-8?B?M20yLzZUaTVHKzdSM0puRnhCcjVnVjhJYzlIbUM4ZkdaNjVoOVdOYmJHbVF4?=
 =?utf-8?B?QUlNbTFJTis0YkYweE5JOEJ5RE44Uk5odzVibVk2d0lwL3hoblJxNWFub1RY?=
 =?utf-8?B?eXVoWE1Ya1I4Q0N5UTdBdXdzTGRUYWNseUpXeHRLYzZpTnpaSUtRZGVkZU5N?=
 =?utf-8?B?dXJXZkwwQkdmSEZqODJwK0xWM3NHS1JVTEFHeVE3eDBYR3hvSkJZQzBnUXY1?=
 =?utf-8?B?SVozbnYyOUtyVG9DT3VJRWpOcWZDcGthK2lJTWRUYkxJV2F0cmNRK2toOGRW?=
 =?utf-8?B?RitjdHhwRUxnQ21SVEgvYVFLbHhqRFNCeFRzOHg1Tms5aUNNd3FVc3g2clo0?=
 =?utf-8?B?RkMvNTU4N1JCRVNRUlJHUGtUSzNhelF3djg3TDBSWE9zbHdENHRNaDRLQmkr?=
 =?utf-8?B?YzZNQTVlTDA2bUVrL1R4R1dOMDNiKy84dDJxQVNsL2pKdExSdzZRMWpFT3hW?=
 =?utf-8?B?R0l2VEc0L3cxSGwreHRUVXNhWHMxYmVOdDVqNTkzcmdzMXMzM3V1c2pBNGZS?=
 =?utf-8?B?Qi9wZDRPQjltYklHM3ZNcUt6VnloNlBGL2V0UkFqZ0pVVDZoSERGSzIrSVNR?=
 =?utf-8?B?Tnh6aG9ndzRFNGttVzU0TG1pUW9MU2g0UXR3ZzF3ZW9OSERjZjkvckc0MkdX?=
 =?utf-8?B?T1Z1WThRcXh5UnJvbFFjQVNnNmU3amxXWGlsRzlLeHFMTUNuTENsLy9PWWUv?=
 =?utf-8?B?NjdyVVpsemFXQmNMcjZUTkZkeEVOQW1hUE5ZOVdQVjlPUHc3ZUJnL2FVaEZY?=
 =?utf-8?B?K2Vucy80YWVPVXZLdWVPeFlweCtiVXhJbUJGNkc2RG1lVzY4UFowQVBkNnBK?=
 =?utf-8?B?eEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NjInRFgH6AbYBDsD6UsVPUu/EKbDasKCldXPNk8qYpR1dbY238BpoJEinJ0Jn9aoIgBDDQZ8vS6/NIzFtUqTfOj5OUNlyCFtt+1CR3hIQqp5M3LmzMni7KStjytemhgLAjVWZlAS8kpEQItB3k4PcGBwjxpC0+ttXOHmbW9sTbEtZyomXeXKDogI/jVa9l2APkJvwCYW9txJphJWE3Z7yYcG4v57krdEb0TlBV/cjp8eNGoDJE6uiRceSPaOQev1H2FSwN/zWpwovbJu7YyS2CsJlP0J+QNtDealeiH0oKx8RGFyx45cGbQOWrzlsUvlxQEpvvq5fCvfFlVY3+k4ZH0iPwVbRZaqkQgU7cVIoMslDDPQ//aiBjIiwdjkqVL5tLnqZyyYaNx+p3ulm2+B7k5kMEcdL8p6pFQoJpec+3p7joe5klsriHf78rsQwmJiC8Z2ESC+rTh5B/DKA5ygiaMsISKPd2jQnn/5XXhGLCgtDHmGqpotweIJhQ/P0r4RgaR7WkY0rYfc8lViR8Y49loipZzsK1RLaI6tqZuEVGWTt/I9qdPOLTGkHj5pLLa/ee/hZqo4W3rlDVlVJTPXcoeOUwLUlSB/uZaIyK6AK1k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7cf2246-562d-4e45-8f44-08ddd32a5747
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2025 07:41:36.4502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cc6ujpa9+SGTMYLcxS50baUIADOD9GUX5MG8DOWHe7+IbkJoXsDAwu2BU4w0bBL8EWbDRPHWqbMae5tDqLJoNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8347
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-04_03,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2508040040
X-Authority-Analysis: v=2.4 cv=TrvmhCXh c=1 sm=1 tr=0 ts=6890644f b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=DgZduJ80Ni-c_zltFh8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: LLKD4rBnuaE6DKl5SYh-g0Y0iXq-xHc8
X-Proofpoint-ORIG-GUID: LLKD4rBnuaE6DKl5SYh-g0Y0iXq-xHc8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA0MDA0MCBTYWx0ZWRfX0dtu/rkCxL7G
 dRguQSsUZLIchMgwbZTLLhhLq6OMBK1clooAkc09SQ++sV3vm6nkRZu6hHi5GwsrwtK/00sVqd+
 zz42mIwO5fUSmfzbsKh0ScbbaH7J5ImPl+nrd1sRPm2/+CvlsIQAJqaOJ+3UlhtnbZ/aJNOTxR+
 NYvJScCM5m/InPZouQKNmzV/y4tgLQTZhh+oW+Oq+46IVi0YkPW/crDcmcjTBnN6CfK7YzOJeue
 Rbz9RP9wYB9RBb9Id+NBMRXzB/oirIU6ECimY0AKiZ55XLnXOTEyvRedPKlU0Bq1BrhmCU10Qs+
 5jDlUDFXO3YXaQiURsc5JDt+eLwiVp6E11pAolDOlI7oPCcPvUv9/9qYaIS319cAtBVJFw95Fwl
 ukCWUQguZwzb2C3tO2D2NTWGdlY7CvwBYM0OieacObE82O4qAfYCW51xO0zmfOV3oqZiUfbh

On 29/07/2025 21:09, Darrick J. Wong wrote:
> From: Darrick J. Wong<djwong@kernel.org>
> 
> This test sets up scsi_debug so that we can test the fs and block layer
> code for hardware-accelerated atomic writes (and not just a software
> fallback).  However, the userspace ABI for detecting atomic write
> geometry has changed since the start of development (to include said
> software fallback) so we must add some extra code to find the real
> hardware capabilities, and base the write sizes based on that.
> 
> This fixes a test failure with 32k blocksizes because the advertised
> atomic_write_unit_max is 128M and fallocate quickly runs out of space.
> 
> While we're at it fix a stupid variable usage bug in the loop.
> 
> Cc:<fstests@vger.kernel.org> # v2025.07.13
> Fixes: fa8694c823d853 ("generic: various atomic write tests with hardware and scsi_debug")
> Signed-off-by: "Darrick J. Wong"<djwong@kernel.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>
