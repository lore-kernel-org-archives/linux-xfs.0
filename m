Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0100217D346;
	Mon,  4 Aug 2025 08:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754294591; cv=fail; b=R2JQhPhAXL50Jh41+PmqUqKkb8gTRH+q6d1dD/QdyLtxICJhYMS5803zl4FfjFr5/3WxfepnwDyPeM3Sb9scsNhlvbd0RNvfTNtXwNEmy2vfkwSF/iFY82OIlEKi0SmuFw/Wpzp6dqYqTLogHXEIAsCRFvzJg2BGZCWRSQleDvE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754294591; c=relaxed/simple;
	bh=miCovPdU8K8HHZLD92bauJE817zz/TIcMeS8w5yMruM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=imhZoY28pFU9bXjbWYMWc1ViGt7HCjdPyvuL5ygdQpWC1/Lh2Z7KBfsvL2S4wpaQxv0J0ABsqou6nKEBe4GJmq9elQWuS7NbgCU0jYUig5VTJdA92LJFZw0yIYzqtTz+eYaPowy/WpTgbipYgjg3+/oAAcLzriTlYBjTiEe+c3o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=rOtf8B6X; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lozWCywS; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rOtf8B6X";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lozWCywS"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5747g7RF025817;
	Mon, 4 Aug 2025 08:03:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=hquSLfqdXtoXZRl4kgihrFx+4glRJj32pCuYI5hTKtA=; b=
	rOtf8B6Xhfq40h/YbpIiFktgQpMxn1/lP+QJYiGySfe3s7PmSxnvIPlR1ejY20oD
	AxbVICk7JPu8fbP5tiN4SKFerEbvBXLxirYqaw6Gksgddk7N9ghit1KCXWeT3fe1
	zgUic+S3lpnM4JrKYyz8mj3G0qbOajXhcNt22RUscwJXTiP++MyChkKkWnLjXluk
	TkUkv7sMtNyMI/oAsgXMq3iMrdCpkPAMRReza8TJbL5rfNMDrOkc8xkGucpyX5l3
	ydGQCXIL83VUuiYg4s2CVv8uWEWhyXXcekt9qbdZN83NDJoOzgYIogbsiioAkq52
	v95aScUsuQfENqO5OGPplA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4899f4t2y7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 08:03:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5746tIVU013506;
	Mon, 4 Aug 2025 08:03:04 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02on2087.outbound.protection.outlook.com [40.107.212.87])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48a7mr3mkx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 08:03:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ki5NEeuLSYgHw9Ff2i2YvWhQHbHXK3YGrWKrnH9bslWm3+7bPerXtEWDzQYVRSj4Jkg528JPJnUakmfp6FfJqKWggYcdyocQVwM6JgbDwTAHk09IPRAavxLRkpg7vkCQp1PcZxJwEekuWN/dtLw0v08aL8VOOtd12rTxMpm++v64O0Y0ci2Khe9+iwlLsBjA5ORrOtuPYZ4cFAt4FlUKtzNWG/R34jFevOC9yL9Y65vNw0M7hWBo+W0x4/KFX2APcEE79Lpxy8cFK9ciQxCwvrRpvReLsQ+zekAi/P38Y54l2IroqJ3jgLaiqCD4e0zYUPTh+pEkBT5HI+4cbOD3zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hquSLfqdXtoXZRl4kgihrFx+4glRJj32pCuYI5hTKtA=;
 b=wRuOQsylVWKk51+1Irxt7/iuo6ezO58QHX8lOU8XgEMajc8XMBY5FerGIkL3m9y4MgYrFXrzYzlffQIrr8Z4sIRiBYDmROuXSZkmsmLkOvX6SC8Pg2IDKPILXMb7/0RK2djOARBoe58Jy9ZbXRkdyMfBsjVX5V69++NHPalE0KiuvKk8kUn8qjdniWOT3w/YR/uUVCjNtIcyFzcu0UL8Xdo56FGn8VRKTi8F7M2bxbfd6ljeIE+FD4nmQf7S59280RFlE9WSb6+XHCQpRVZDY2lOX8okWpiqysov5RhhoTat14FIAuCj2i4dxgEh3ayvV5cWIVdXe+fc0vJZDX6Rig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hquSLfqdXtoXZRl4kgihrFx+4glRJj32pCuYI5hTKtA=;
 b=lozWCywSRWJAXHMo+9kSLEYzPrVbH6mTsNBQf7YvmFoXHWf/ti8DHBpBkHHMqTnRVIUTMJ8ScH5k4hsO0OJ3wxJ8m2p/m4L8zQR6DuRL+OY2YYWWga8n6mRFxTt1w5eJ5xR4K5o+wdhYCVYi0WH5iD0b9Oav7mE+VMZ2lFBgSIM=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CH3PR10MB7393.namprd10.prod.outlook.com (2603:10b6:610:146::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.19; Mon, 4 Aug
 2025 08:03:01 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.8989.017; Mon, 4 Aug 2025
 08:03:00 +0000
Message-ID: <fc36a6c5-8176-4cb4-9e00-3b4a03497930@oracle.com>
Date: Mon, 4 Aug 2025 09:02:58 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] xfs/838: actually force usage of the realtime device
To: "Darrick J. Wong" <djwong@kernel.org>, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
References: <175381957865.3020742.6707679007956321815.stgit@frogsfrogsfrogs>
 <175381958010.3020742.15091248211656555031.stgit@frogsfrogsfrogs>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <175381958010.3020742.15091248211656555031.stgit@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU7PR01CA0022.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:50f::10) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CH3PR10MB7393:EE_
X-MS-Office365-Filtering-Correlation-Id: b55ecbf1-f863-484d-12f9-08ddd32d54ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WW1lRzBnaFlMalZiSEk1Rlp4a25Vb2xVdm41ZENLbThKbE1uTWozb09iaVlB?=
 =?utf-8?B?UjVzZyt5ZzM1dVgvQk5DTFRyREdrMXlyOGk1QXkyNVJyalZCc3h2VURIQXFT?=
 =?utf-8?B?UW9ZNkNiV0V3aHB1MUlsS2d6b1V2Ymp6ZlZOSnkrTFc4SnZSQ0d3V1BvdzV2?=
 =?utf-8?B?QXZub3gzcHNqZndLQS8zbDY1Ynp2Y1ZYeWdFSkNqWjRxOVcrTTVPbUFMSjZE?=
 =?utf-8?B?V0toclZvOVhiblV4OTdhaVJTemVGaDV0ank0SmZQYStGVEU0YWFWUG9VdHN4?=
 =?utf-8?B?ai9ZWVhMMTBWRGNUb3hSbTZEM0hUME9MTFNxOUIrcGZwTVNteVhTWGJtcnhG?=
 =?utf-8?B?TmI5MDRKYkVndkh4TVFIalZmRytIUWdJSG83L3BTdjFLQXZxZmkxNGp3Qm1V?=
 =?utf-8?B?TVdzRWNicm43ZVAxQ3B0QlFienVJVmpjTXMrVzJUOWNjc0QvTVViazZZbW5w?=
 =?utf-8?B?Vm9XUktkdERyKzNFMFd0ZSt0UWd6STVydDZYYW56ZlRheFJ5Ri9SMDFOakJn?=
 =?utf-8?B?b1d5MWxKMWVuYnNBL1AwQXIxWGNXdEFRWHFjb2hoOE1YTjJ2bDUvVkdoQmJF?=
 =?utf-8?B?OXVKVG5sSDlWby9kVEJheXczSkl4Ly8rNDFrV0ZJRWxpWGJHM2ZBeGxVS1Fj?=
 =?utf-8?B?YldQS0pHSkNJdEZHTUpwanp4RXBuZmdPYnlUVEV2SEIxeWd2T3ZNblhXRENT?=
 =?utf-8?B?Y0Fzak51YkRUTlV2aXI1Wm9ab1U2L1F2ZnRId2J1QWdjc3p0eEU1TXQvK1h0?=
 =?utf-8?B?cU01eVJMVDgyM2g0WjJqcmk1dVhUcXRLaGFtN0I1QVJCbnNvOFZTdk9ZRmM3?=
 =?utf-8?B?N1ZHcGlabEtrVjFSNHFhSnNydGZ4YWNMazRMdEYxN2JwbEw3NWNNRmNiaFFs?=
 =?utf-8?B?U1V1MzNvdlovZjRmaFVoQThmSGZxMnNKNUtPcmZleG42SGJ3VmZZT0szY3h0?=
 =?utf-8?B?VWtWU0pIS0FpT3JQS3F4dy9aa09Zd2k3YzBBRXdOR3V2TTd4cHE3R3E3Umdi?=
 =?utf-8?B?SEdXbkV5bmhxNU9OZXNndEZxOXJyNytoQ2FyaGZuLy9mcmtaSlNCMlJIWjRU?=
 =?utf-8?B?UXB6SndwZmEyREM0V3cvS2FJMGxma0pUUWxnZHV4NFBMMEdtUElzcVV2YXB6?=
 =?utf-8?B?dlZWU3ZPMUR1ZDZNbllmUUlCUitIcWdOMHZrL3h2dENLeWpyQzZ6a3poOUR5?=
 =?utf-8?B?MythbUtCWS9Ha2poNUZUSDRQaVQxRnBjK29pU1J1RGc5YXA0Uk1sYnU5djkx?=
 =?utf-8?B?akIrdEN6ZXNITzFVNmtOczlHYTZVS3ZIWjZMeGc2RFc0WlNLaFN4Zmt3MjdR?=
 =?utf-8?B?SnM2aHRHYmxZS3kwZW05YmdIRVR2a25qbXZ3cDZNYVA2TDh2WmJBUkVzVU5j?=
 =?utf-8?B?T1RTVUlMNlJTTXRFNGt4OE1aSW1GOE5hcUVielYvZ3Y5eU9zVWE0YjIvWmxH?=
 =?utf-8?B?aitvdnlHU0JnKzFnSzBoam9QSmk4aTBDZ0lHa1E0OGtEb3M1OWptSTZwRDZL?=
 =?utf-8?B?aDRvRDNDNlMwc3BqRk5CWEkza1AzQzdKVXYxY0h0RFVHR05Xbk5kaHRRR1NB?=
 =?utf-8?B?MldJeUlNUUI0b1QzajlRKytoOWd1VUROM3l1MDB3TDRHQ2xjLzFad09OeGcw?=
 =?utf-8?B?NHpkVEZ6c2UzQ1luNDAvRnlmNHdZbVI3ZWNSZVVjZWxlNVZzbmhLNStzRnlM?=
 =?utf-8?B?OU1KaVNMOE1RcDYrNHRpanRCQ0JsRWVuMTdyUVl6T1pnZlgzM2VGR2NvWGpJ?=
 =?utf-8?B?UDlkM0NWUklHaGMyZkk2SUIzbnNWd0tkU1doY2VEUmloTnVCdlZBMm1KWExs?=
 =?utf-8?B?L1VNV1VacHVEMlQrekhOSUpQOFR2M2VySzQzNkM2Y0c2d2NWcm92M3VsM0U2?=
 =?utf-8?B?SDViUzZ5UFVsRDFVK25nRlZKbUlPSEhiUG9ERm5kUEJtN2F2bDNaN21uUEZJ?=
 =?utf-8?Q?hT2xar1I8N4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ek5IeFhBK3kvTENYbThFZVh6TXFWTTl0aWRGMVVrRWFScVBBS29GdktDdGFr?=
 =?utf-8?B?U0ZLeXU5U0s5R2RORGs2djFQV3Z6YUdPVHJCbWJaVWptNFRrSUJSN3pObms3?=
 =?utf-8?B?cEg3SVB5aDZyNXdlbEtlR05SNG1PajlHc1NxUDE2emROSC81RGpCa0xxUm1O?=
 =?utf-8?B?VnZxYXJzTk5KK0NjY1Z2MENTdlY0dUNXa0prem9EY1RxQ2M2WHA2MVR1eGxV?=
 =?utf-8?B?NEMrOVhKb2lTZTlrLzFxTHMwbjN1YWIrVWhpRDllK3UvMmhRRk5jYnlEVEtB?=
 =?utf-8?B?MHVxL0pua0NiWUMrazJOa29LaFFrNi9SUlVXaXlUaHFFMnNJM25acTJXeVhk?=
 =?utf-8?B?QXE2RFdUWDVUa3BiM3FDRDRISkc1bzF5NTVBUzFkUUZKZlR4blRYejVHN0tZ?=
 =?utf-8?B?dEIxb1RYQkw3VWtQSml3R2h6aDlEL1QwcVEvMzJjYWZQTE1zdmI1bFFPempB?=
 =?utf-8?B?WHJ2bTN4TE05WDVHZGdvRlZ6N0FqcnhHWFBQNEZGNUp5bDFkZkZTZ0pURE9S?=
 =?utf-8?B?aENlUW51MUhyclNSRWJySU5CNkZGSmV4a3ZnTFpzQWVnVkxTZHlrRysrOEZU?=
 =?utf-8?B?TXFFb2hiUGN6b2R3enBNL0xJQlVZdWhMVmZHQXR0akFpWXl3N0t1M2xEZmNC?=
 =?utf-8?B?UGZuNzFhOXE5cXg1b0FZZEFsYVFHRkptUk5rdWxCVXN1NWhnbjZNaFlveWhs?=
 =?utf-8?B?MVRxQWlCUURKSHRXQ0dLblV5aU5USk9FS3ArUGpXU1lHOURQbGxuaUJRWC96?=
 =?utf-8?B?TWhja0tEODN0ZGgrcDIwUEhIT3FMRE9jV20rK2JLd1haMTJTaVlXdGdOZXI3?=
 =?utf-8?B?QXBMU3Y3a0hMdEU5Mk1mTHRkL0FmVE5wLzJSbHNqa1laL21kT05ZclBHYnJV?=
 =?utf-8?B?TXpscnJlL2ZmVkdxTGlJYmJxaG92OWd6REozZEwvRE5Sck9vdHBiSGx5bUU2?=
 =?utf-8?B?NlZJRDc2ZFlBcG1ySC9yMU1PdTg1ckQ4WmVGNzU2NE1pT2pHa2RzSnNLYndx?=
 =?utf-8?B?anl6OEJFbUduM3VJUzVHZ3AvckFQU1o2OTZ5dUt4T1hLTmNpdkZucE1YRGJt?=
 =?utf-8?B?Z0lQNXNSNDltV3NBTGhzMm5hKzMwZFVGSUw2MEhvdVltNlFyL3dpY0dDSXp0?=
 =?utf-8?B?bXgyV1JiTUJnV1RNK0tPQkQwcnZUTFlOYVJCQ3lveEljeW5XU2c5SnN4d2cw?=
 =?utf-8?B?bStLUG8wdDV2dEVlSGxQSTI1V3E0azlJZWJoRjk5emFwM0doK2ZtdFI2VHNq?=
 =?utf-8?B?dlNXbnBKUW91c296WHhmL0xQNlhGK2hiM1RNWnQzWVFPcVRRRnVFSklRRjFn?=
 =?utf-8?B?aFVmb3BYNXVCYnVTR2lZT01rNGh1TGRYUEVvR2VLaVZWTEZhQkpVdUNDVnF4?=
 =?utf-8?B?c092eXZLT0JKWTU3ZXc5Tk9WOTBWeTVaZXpiMGQ3N2pUVWNlbHlTVFVEQS96?=
 =?utf-8?B?TXFyaklCUjJWSmRLQXJvUW45alJlMWZwVHF0YjdzTi9UdDVRK0JyWnBEaVVn?=
 =?utf-8?B?a1pPZCtmZC83RWl4dFhFQnBidlZpaUNTZXR4RmpnYUlLa2d2QzhUQ1N4ZWdF?=
 =?utf-8?B?UVVBeWpZUFo5bW93VUcwSDU1cUZnNDJ2aFBCNGNoOFJURVVtcGxOd05lM1ZT?=
 =?utf-8?B?b0EvTUk1cjM0cGRxb3pXR0oxTWt2VUVmdHpOZWRpNWNkM1FmUHIzVFZHSDJU?=
 =?utf-8?B?MFcrMTdKNXAvZzFiSGhVNjgzdnRJQWd5V0xCaldFUEdMOG5TeVBrVUJJQVpk?=
 =?utf-8?B?Mkh1dlJJWnhlNjc2cWd6VHIwUkR5ak5yeTFVdk5HUjljM09KMWE5OHpOUXJy?=
 =?utf-8?B?cmxLUU13bzRhcXc4aHFJNk5qakpkK2xHZ2pMR3E3YTcrdDNzMTg3eVVHYm1Q?=
 =?utf-8?B?VlNseXFEcVZpdjlkWFIwdFYxUHhwQWJWMVNsaHhJT3R4WkhOV2x2cHlmdmxU?=
 =?utf-8?B?SkV5bWZUaWZoMk5SMjJFZ1gzb2twSkFIRTlGd2RSZC9BMnhHZkI0b2RJditR?=
 =?utf-8?B?bm0yejcxWXY3VnZkSGh2M1hlWTd0cU10U1RKZ1F2bXRVSkJvOWNENGN5TjFn?=
 =?utf-8?B?SlFIU3pZYUlGYUxiN0pxVERVQ0F3MWNyeFhvVnEvT29NRi9mdjBLZXloRVB6?=
 =?utf-8?B?cjVzWkRwSmpLRnBTYUF6OUhBME9UUjlLRitLL2tBOW44UnlvMGJsT2YxRUNG?=
 =?utf-8?B?bWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FaeR6Q6XeEPwzyZ/ZVnYUyBlNC2bRa7kKfXKcdiyv3VION8d8l6R8FiX6Ul74xI7kJ/BFgOEKk+jqgFQe15Z8XIMmqA7jCiUYjccbX30/v9bs4tZoFYInhepYifigE8pAYepvwqmP0MKhnibscO1ym+305u9LkWAjwvnpc1oKDRi28lyLcMkAVpwA919P/301jQ1cDpw50nz0xjmcaT2Sx2L8Lnhb0kHUM9qAxW1KhgQK/u3fgxlSGSorlP7Ql9f8Q7mEG21eSq93LnbcRgHGnd4IT71jI6zWlyOab57h2yizZ2/NeW4OhzsgWbwiuUeywXVnGrtE6ve+xmKlGIWaNN7YtrzpYoWVtqHxVJ9u4OW5seg19lxaEggeKzkzuDqPaIwhorN90o4lyQq1tt/zJLTegYsZYfzPI3Axw0nRlqIWGx0HmsfJzjArv0M3GON/obX5ZFjmPsYNCruCdYtS3kHV2XPCys6HaOhx01pTvMfIzQ0vpGJ0R7NJFA8WddApYBX4X55B/EiJkXLQWDakfSqGHq1wcpwIyH+7XZGmsZknk7ySQ3hMS7bEI4OqZCrSDKNtw0rqX1BaPK1mBZKm8ypw80F73O+wV1g8/6U5FQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b55ecbf1-f863-484d-12f9-08ddd32d54ca
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2025 08:03:00.7871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2iqf3krveiEhZf6JI8pbGADn4t4UX56YVd2hCj9x5fSMZ+QfdPL2i4ijzhFinTw9Sv9ZQOisMlJB0KBOzG9mcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7393
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-04_03,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2508040042
X-Proofpoint-ORIG-GUID: zOpffJQJ6qV87TPX-fIQNAYccbjVkSJJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA0MDA0MiBTYWx0ZWRfX15W8p3Q9k0FV
 uM11N+gr7BBUkCbOXxr2N4ZTcEuXF8V2yT3M17MwwLhl8PaGcK5hzwQzpf8Z9TGKQ3ni+zwX28N
 14/xuJ0Cin/cnzmBogJmYsO7DmbewUfZ49WaL5Z6jfqbmllFCLyIOAWJDnATWfPyO37XQZHGube
 JuORBEtdgkQafiyg20lnJMJrvOwf13jnct1w+NefHfi+JoJYazQqbGKA+hUVutSfQAN/UlfdAVj
 kz+5dN9Tv6+3YkNMfRLv4lrmpaMxr1p/nWuO/ePg6WCe1bnv6fqUED6SVnCKBqsVJamdoTgU7hV
 A3yNtpi03UZ39DT58RpFzgY2Rl+NTIkTmjQp+gQnQfVbGxhjM5spgiy7I+ArSlrafsHfIbfWNOV
 SqslZTCBlNwzOAQjkuLaYisMTxXmiJMuhRDzcPwQzdpqaTgLl3XsN/juYsqS0BBCW8UozrNV
X-Proofpoint-GUID: zOpffJQJ6qV87TPX-fIQNAYccbjVkSJJ
X-Authority-Analysis: v=2.4 cv=daaA3WXe c=1 sm=1 tr=0 ts=68906938 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=aJtIlKC3vmDeMZNQHawA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13596

On 29/07/2025 21:09, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Actually force the filesystem to create testfile as a realtime file so
> that the test does anything useful.
> 
> Cc: <fstests@vger.kernel.org> # v2025.07.13
> Fixes: 7ca990e22e0d61 ("xfs: more multi-block atomic writes tests")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>   tests/xfs/838 |    1 +
>   1 file changed, 1 insertion(+)
> 
> 
> diff --git a/tests/xfs/838 b/tests/xfs/838
> index 73e91530b53a67..84e6a750eb07ab 100755
> --- a/tests/xfs/838
> +++ b/tests/xfs/838
> @@ -23,6 +23,7 @@ $XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_RTDEV >> $seqres.full
>   
>   _scratch_mkfs >> $seqres.full
>   _scratch_mount
> +_xfs_force_bdev realtime $SCRATCH_MNT

I'm struggling to follow this test setup.

How are we ensuring that reflink is available for the rt paths?

Thanks,
John

>   
>   testfile=$SCRATCH_MNT/testfile
>   touch $testfile
> 
> 

