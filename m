Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03EBC1C701A;
	Wed, 14 May 2025 16:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747240217; cv=fail; b=g3FcWeBlJzzCfveHNikw2QXHcWp2nGBLjY2BmxtzPkDcx7m98iwoonFPYs6ciNJ/qwmJhJtTlIThEfh03C2Kv3s3ojdsVabh3sRwAgwanhLVHIHjZ4INkowC8SnhGwtKpunpIr37puv6gTxSTrzvAC5FrplLWEIxEVtV6Czkeys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747240217; c=relaxed/simple;
	bh=TIIumnUROOC3bKYEnO9YVfpwKThy56qp+D3r/GsMg4E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qaeaoAa1I332QeTI4IJy/FsBOhX81COuVbnx/5Ye/bmwiWZUlKRMqO1LSLWAWIKCaBuqWvs4Ub4nxc4DOfHBAE4nJnpVFJHm39PswNn6Zg51qx9s7GUUJqTRXBDMEuAjEOkFYIsett4gHOHJbCm/aJ/1DCO+ZMiQimjdJUNwgqI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CC1vArdd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RK7KwfZg; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CC1vArdd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RK7KwfZg"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54EDhu51011553;
	Wed, 14 May 2025 16:30:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=2dS/x5UzZx7y8L9dVZPZqWYC7dYalEhdMQMa9TKzPX8=; b=
	CC1vArddwIPtb3BuNGcwxBjryXUbIL4MAjjtFqVhHxKZ4WgWQh/a1a4UwFSMldz2
	jeyvVOG9YgRUP/4K+LX7qy7cYdp2YrjXnRVljZnYLvjxMp5+feg4Rcyw8m/LPCSd
	mN10NstBR4v47EOSLaI4tro110d+9qhV6g3aWm7pwRXnNhP6/Cg7MhwXOR/KH5MU
	oEN/wvT23eZaFlUiVP5ikcWD0F6toY72bQPofz9bW/ckLVWeE1veu1zIrF+BZM8x
	yZEm6soVe95FHIphnpRcMvdaBJy6umUQDOan5PzF+4seJCn9R6jWayxgkMibg/zN
	vup81MFnnN3xcju+qoYJtA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46ms7bs29g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 16:30:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54EFQt6K004664;
	Wed, 14 May 2025 16:30:10 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46mqmcabar-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 16:30:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=spMiSnrULE8tc1aqXpBQkjLlsiQ6uRzOpbal819aXpaBoXNaHR1Dx57qsCmexQwfUYUTBzjSETXybqejBTepfl6sWfv7ABeVMCNfqoVwNIawfOQS0bf6JlXNOmuEwQW2K+xRWmlOk+mL7JC/i9XHDZ2azTX2BQyCwW5Kmb4GsUYOVEaik/63dS3T1151qvPzFPLR7A2+seTK5UHg0LgI6PMDzXuZmjWZLZhmbOCc4N5NzccZsiINCrr9UnYm7/zRmgSnHcMMItjKnOZX4Ad5UtNQcOrrYIpSgvHoUjZ3PoVafPFPo6wb2wlj1PlJ50nT9sfyVJ5wWYFzXJd1hwX1fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2dS/x5UzZx7y8L9dVZPZqWYC7dYalEhdMQMa9TKzPX8=;
 b=x/z+Tv3sWy1QpBxODPRD0WsnqAjoekXpMhm3+lSIqKw/PW1+iI+FyxidULLKLp7PwT0bCIJ/ULvGtmHvNWziHvE5r9u2gT10WlGh86hbBoMegdj8zeFNzw0ynXeTIMxNjgHTO6nEpVRuzvNkXuIDRVcVtGrX+SzMuF2OOG5LQ0RwUxZVggy7d5GdtLoor88Yh7NzmZ6L6fy9/nRR1CK1KjLlTJDLGRDmPOSxP5Q3oIClmvHdTZnaY+zD8UTrMXED2aDp2jBw513+1jlerquU9bSDJ0FJ4IlBQhsW+C7Q0+vQtd5d5JQmZ8HVGJMH9ECUHLFQv5vh0TzVVTXuTfCucA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2dS/x5UzZx7y8L9dVZPZqWYC7dYalEhdMQMa9TKzPX8=;
 b=RK7KwfZgammCuLcMwF0iRHCQzZB3FfgEQqt4MxkH46agY1SGwAjDGcOkMf20I4ta3PSIVqwfQXwOg/74YIdqMbR4jmAZPxbtuDIqZtOCasb6cumwv3LCMBfdqufJQknlPoTq8EgUOL01Od2cMctA1aOZjLn53D9XmvfXi3vxVHA=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SN4PR10MB5653.namprd10.prod.outlook.com (2603:10b6:806:20c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.32; Wed, 14 May
 2025 16:30:08 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 16:30:08 +0000
Message-ID: <304e85b4-9c5d-40e7-aced-ec63942da548@oracle.com>
Date: Wed, 14 May 2025 17:30:05 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] generic: various atomic write tests with scsi_debug
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
References: <20250514002915.13794-1-catherine.hoang@oracle.com>
 <20250514002915.13794-7-catherine.hoang@oracle.com>
 <4120689f-27cd-4114-9052-adba0a7e91d4@oracle.com>
 <20250514160143.GW25667@frogsfrogsfrogs>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250514160143.GW25667@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0376.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::21) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SN4PR10MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: cc1d223d-ca86-40b9-a5aa-08dd930496f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L0gzYjFpWjNid1R2NGJuTTZBdi9BMXZBYUhaT3pXZm50M21BMUZDTFl2WDFN?=
 =?utf-8?B?NXdJOHhhMHlONGt1d0dvNUtGUXdoRG9VazkwbHE5QStzRXdvclA3TUZsYjIy?=
 =?utf-8?B?WVFlRjFrQ1UrYVpnRzRYZkZpSUZva0hwcjdMcDdjMzZZbUE4NHo2ZUFwYXow?=
 =?utf-8?B?OU9KL3FqOEdhRmZNSWoyVG9Sb3c3RUdUUWZzNmRTay9NTi9vL2NSOE1Vc0o4?=
 =?utf-8?B?S1Rub0lReEZ0RXV1K3EvU29BZ2ljbFFTcUtTcnJ5bFdsR08zam9kZ3F6a25E?=
 =?utf-8?B?RFFKTUZOYWZxZ3Qwa2JLeTl4NEthN3dQb2VBNFVIODVxMnl0ai9BMVFwM1dB?=
 =?utf-8?B?TFlPQVhlQ0tkSDZRY1BUWHFUckhQTmoyb2tvZE8wQkRVZG5kaFRMaVdTSThN?=
 =?utf-8?B?SjdzOTlMWHlnaHlvd3dEZXdUL29vOERzakZ1UmpjMVdWNURRUjMzNmVqRUJS?=
 =?utf-8?B?cllZNlExTk9zdGxlRVR5ZFhkL1lBNTJ4TWQweks3WkVUV21PYkdRaGM0WTZN?=
 =?utf-8?B?N0VWNnhBR1cvaGI1QnhSSUhzdktjRTl4RGNrVkRiYTFaZkRnenYwK3JkUEFE?=
 =?utf-8?B?RXhQVEI2aDdHa29jOHUySVU1M1EwOEFDendLN3hxcTNRNVpDQk1XeXc5dGRp?=
 =?utf-8?B?akdCK3hjYmgxTGlpTUdZaFBVcEYxVW1RMEU0MklvcGdXZzhWUGdiMWlsK2ZQ?=
 =?utf-8?B?V3RGeFVVbllObktRekdWN0lPNEo4YVE2ZHRaK2hkVjIwR3hRdlhoMG1lN0tx?=
 =?utf-8?B?WkJ0TmtpREwzbFFKSmNrd3VyR1hwdEdrZmt5c2J6TXJzNTNHWERBTWk4Q2tl?=
 =?utf-8?B?dy9zNkpTR1YxSTl3L3Q0N201amdEbk1YaVVQcmU2Tk9meklmZVdkNnlQZWUx?=
 =?utf-8?B?c1AwOUVqMklaZ0FhSlo2SjhKOXNXcDlRM3VUemhaTUp1a1g4d1J0clI5QXU4?=
 =?utf-8?B?cHgzMGc2MkFKN1o5TUR4alFNbjgzTHZDd3VXTVNrOSt4a0c3RGJiS2syd3k5?=
 =?utf-8?B?a0pyeVVUOWY2ZDhRbTR1UCtBMUljUlFJek5tcVVlN3pyU2h6SjUzYUtDbUdM?=
 =?utf-8?B?YVczZ3N4N3didlc0T2ZybmZWZDU1d1BNNk1RVGo1WTRSbDBETW5XaEs4TDVn?=
 =?utf-8?B?YXRYR2V6QzRXeTNhRjcycDJnOHVxemZzZi9GdG0yTW5xQTQ3am9VU010dEw4?=
 =?utf-8?B?dlJ2QkdoUHZVTlI2VzF1R3hCVjlmcWhQQ0lDTnRkaUw5MnAvZE9sQlBzQnNC?=
 =?utf-8?B?K3NsTjh4MVQ1UnJmd0FtWm5pZExuTVJWQjlwUXQxSyt4dDNhSXZnSGZaaW4x?=
 =?utf-8?B?Q1ZIZXJjVlZWejRSUGRvWENKU1NKdzl6R3pGeGgrK3ZYeFdBRUdpVXZ2MUlJ?=
 =?utf-8?B?ZVJJdWdCcHA0ajVBZC9TS0hoSlVhWlJSWkZyTEl5YmlCSVlhaHdqazlhZFNm?=
 =?utf-8?B?WUFrazhleWtVL1k0RlFGbUs0YmptR2J4RUEyNjBFREN6R0xZem1vQ3MzYVJw?=
 =?utf-8?B?SzdYazZTNngrYXo0ZE5VZEJLS2NhYkxTb05LUU9weFMybnUrSFc3SDVVWXho?=
 =?utf-8?B?N1ZxRmt2MkUxbVVrZUhvd3NHMFMvRGVFckhwVllvVFpkN3QwakNPeUZrWC9h?=
 =?utf-8?B?ck02Tld1aEM5Y1J5cnZKTEx1aW1zWi8vZ1Z6ZWFROWdYQ1g4MmgxM2NrYXRl?=
 =?utf-8?B?cDZnb0czV0xDYWlOaWhBVEV6Y0ZnVjhWbElWdkNXSDFsajNvVGxQQktGdHFv?=
 =?utf-8?B?Z2srQzBqcGtCRFArUDFSM1NKb20veGJPUndXY0V4RTN1UFNhOFg4M1drcFRU?=
 =?utf-8?B?YzBoTnM4aXJyaTBPT0o0SEdseVRCekc4c051ZncxRUdBQmhjbnRCenhLT3p1?=
 =?utf-8?B?eWxEQy94dldoR3FHZ2dadGJYNFlpZ28zR1loVzZpU05ab21xSmt2M2RJaXhN?=
 =?utf-8?Q?6a6h02aHNwg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RFl5eGMwSnZNN1JxOUEvVmJiMzBZbFZ3WXJxWXc3Rm44UFh4YWFadzBsYkwz?=
 =?utf-8?B?S0xtNlc2a0ZPeURJeE9hYkpzSFlEUjE4a1ZIYWRQc3ZvVG9reksrKzNIN2ZC?=
 =?utf-8?B?T1M5OUcxb3Npc2UwYmpnN0FwRjl4VHNiRVhBaHRFT2tkaEJodXNRazF1Vjcy?=
 =?utf-8?B?T2ppeFcwNVlrRWp3eUk2MWZSMkYwRG1FbTJDVkdBQ20zUGw2M2pyTit0WGZW?=
 =?utf-8?B?TklicEN2eU13TWNMSjVZM25UYkZmcDVFS010b3RuUUJrQ1c3cGRYdUVxRGFp?=
 =?utf-8?B?Z1F0RTQ0KzQwWXYxSFhZNlJGcnkrdEthNVVNSUd0Z3NRQ2JRQngxTVZBcTNM?=
 =?utf-8?B?MU5yRjFUa0ZMYkc2em9maEdEVmprM1o0QTBXejBjYmQ3L2RjbUhLcFVYaXMz?=
 =?utf-8?B?Q0Z4dkRCUlhGWStVMTJOaUM1SGFlUXg4aGtOSVlSVVp6N1NSRXFtQ0ZQSEI3?=
 =?utf-8?B?OENZUFJCUFd1TkdmOXVmN1N3VHE1V0NTZ3FBRWtEZWgyVlNTNGhSaGNXUFg3?=
 =?utf-8?B?UW9pc2xWbnk3dlZuRkhlRjlIRXB1b3Vsam9VaWozSHJBR09YTGFrRHNQUm1z?=
 =?utf-8?B?dmZzeXNPK0JjcDlTYTFzbUJYKzBWQm5YeE9qMnlvVE4wSldaY3ZaT3ExWGZ2?=
 =?utf-8?B?L2lSdEFaNjNURGFURHdsVDIzU25ZbDZxQVRpZlBId1o2OTFrdm1xTStGOCtv?=
 =?utf-8?B?RVI5OEt5Sll1a21ROEVUY0NyK09jbnJzak5TVUprM3pFQTdjNGw3MUdmcTJN?=
 =?utf-8?B?THk4NzRmckNpSzg0bStNT3BjSWpEbU5BenNxZG1IRzI0dTQ0dDU5d29MOXdj?=
 =?utf-8?B?LzVLQmdBai9xNWF4YjNZZE5IcHZjemw2alFjcHlmb01leVBxUk9QMHY2NkJE?=
 =?utf-8?B?dHA1dmJteUp3eDBUS1R1WlRvZFkyemY5b1ZwZXdXdUtrQ1RIY2pPU0ovQTgw?=
 =?utf-8?B?eWp1WmpHUU1rajN5djFTNEwxUzJ3SWxMc2VxQlQzcUNSMnYybkgycTNvRkpv?=
 =?utf-8?B?UjllSlRvajBLNHU1d2V6WEJnQ2J5Y1Y3WHVPcWJYUW5MYXRrTGcxOHhJZ21L?=
 =?utf-8?B?cDlIWlNyUkEybGYrV0xoV2FmczIvMG5EY2o4emNpTnREZWtpRUZncFpHUW1K?=
 =?utf-8?B?QzF2Y0hESjAyZjF0bE1FSGVPU0lSSmNOK2hmL2dkNWU5MllCckpVeEwxSTdI?=
 =?utf-8?B?STVkbWFETnE3R2NreUhaMHNRNFFjL1RxY0FqLytzYk42T1NhekVsMUtHam92?=
 =?utf-8?B?U1IrNU5xRnVLbSs3a2xGWGE1TnMveXB5S0dlRHpYVGhUdHNLOVpJS0dBQnMx?=
 =?utf-8?B?NkQrbkI2cFFLOVMrb2haTVVSOGRpN3R1UmllaFdqWkZ0OHFQcXlqenZuWU9t?=
 =?utf-8?B?N0VrWkp6T0RIMmtXMnpFYnhIam5JVUs5dG5EWVpzZFFQK3FTS0RHTjFMMDJ2?=
 =?utf-8?B?bUQ2WWhtUENrTFVYNXNMdHBCS2k2UDJseUFSa0lRL04zRzFNbnoreXMvTHJz?=
 =?utf-8?B?UGxIazB5ZWJ3dDRVNnZVSXZ4akxXZEdzUy83WjVKUGtkekczY2xLSnNuaXll?=
 =?utf-8?B?Y0ZhbzNURzZ5Ky9jd0VDWkR3WWh6RytzRFc2eWhaUmpqci9tTHdNNURqY3pt?=
 =?utf-8?B?eC9zbWNrQUNKM1AycmpnSHMwK2l2VFM0d3hOOHgrYVk4SGNEa0VmUDFvNnBB?=
 =?utf-8?B?Ym5vUWIxZkdjWmV3WDhaS3ByenUrbnlyYTBLZVQxUGtqZWg3Rnlvc2JaZkZS?=
 =?utf-8?B?dVBNMW1FbmZVbm1rMEQ0S0ZRYm9IRVRkWWc3TWxPL21GMGR4cXNwdjZXcUZy?=
 =?utf-8?B?RDhsd3RYR2VZdFNFeEdxazRXdHE0RTVaUGtZN3ZVemRHOGFVRlI2MGlNNVVF?=
 =?utf-8?B?KzQxL2hwdXNtb2pnbCtINFA5cnQrOEFIakJkNFgrTCtKUlU1RW8yYjNsMjNW?=
 =?utf-8?B?Wi8wZzVpUVVCWGt3TFRsNElua251dE9pNVFyaitHV2tYOXdRaGdybElKaGkz?=
 =?utf-8?B?bzAzL0hwVXFlSzQ5Ylg1aEdVSGJPV09IMkkyRHV2blErQm91bGcwN09CQXNY?=
 =?utf-8?B?TnE5V25ZSWhiQldiMlgzY3NoVnJKMndZVzdsWVZCb0ZGUy9JWDNoV0VkRzJo?=
 =?utf-8?B?SFdYcGRldGNMMW50MHNrWkp2Qmw1anNVYXFnZ2N2cFpsWEJ6L3V0dFZNTEMv?=
 =?utf-8?B?Rnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cC/7pK87N3oPW4bNvt87kMmCFtzNW2IpJh/gDxFp4acCcJ62FL0ZoSc+e3j0AXCKTLclijyqBgChksAdIq8IVq2U2Fz0Sej5ctrAwgBi1HgZundwn/w/ECwrqoESGEZZ637uAxMosz3F7k/U7bFyLPG5S/e96+MAf6pKm3Eh0FrUj8PpC6e34l1xtNghiv9nvS6ziyoPjGwkrgaOwN4ppAnPLMrdgS++LcVQX+w7mqAKU2qDVI002YTYnTC5Tc5sekdFmFW2W1ng/MtHDUfaJHnVPl3M2cgA7dEAB4/NtjL32Ligep9ep7BeOgjzYZ6nEwT0nEairRLcHICL/S7OEEscS3ssU6EAEZHJV3aMpkPgK7D6eyYluR2fEXhFWSMn5OmHSvKATCFVYymp8kCN4Wy35W7HhSauZsny5cdf7UD4LBUvMpRwiSgj2mgaBZIR1ks3RjT5yb7TQCj6oenE/3iFGN1WLLhMI9ciQ2oo0JEq0ZG/CqSA9yvav6sVXP8tICVUIZFHKhWu2YuQcs28Fvdgo1qdzpkfHQk8eENbqV8XTS6AQ1wnewziqAmcmO4wforwaanaxeEqURHqYxZs7OdaweTXTdJ3oqF9UHNx26k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc1d223d-ca86-40b9-a5aa-08dd930496f5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 16:30:08.2566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1ZXFjp6l3gtvWWJIdyV47KfxQnsf/+RLsBFj2wak+1Bc5FI5sWalmzYmwkzq2YHQ+LfqZtXqAGkdEyMgLRWTFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5653
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_04,2025-05-14_03,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505070000 definitions=main-2505140147
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDE0NSBTYWx0ZWRfX9OFdHe//jnKN NsCw5M/6d7hlA6uHdOF1kO14NtPssNbzfkECZu+/92hjvyTF3gLP7r6z79wvX/cLbhwtPoa3KLJ Xodt7bPvrC6UvU6xYSTXSu59v2Y/9GFq3bONUy/rhyT1zshvRStyzsQo3s6wtZno06MzATzIJ93
 IUzB/wB1bSJrf+GwyeblWTQMnsuw/O/5CSiRFmV3TFMsgrrstJoxJvO1raRhkJG/J3RD0pEU7Yp 0kw48GCtGgedv/XEao6Hpx03n9FO7dcju5+j90ZGfOb3P4oF1sSUe5aqSl1MczUIHG8UbLdTElv VfhNMAMTPJCDmKcmVzt8WX248MCWsqK7Zqumkx/Em/0UVUo4SVux8dBg5is6RGt/DarRYbHEkda
 8Bf4+CGRXmX4uuIn4C01JJbCey/5WCjbMJXpoBe8Jy2U4gMcL6gZAhL37xVELEBBh7eD/5rU
X-Proofpoint-ORIG-GUID: hCg0P1Kolsqwive7bQt__SkdJIyuBLur
X-Proofpoint-GUID: hCg0P1Kolsqwive7bQt__SkdJIyuBLur
X-Authority-Analysis: v=2.4 cv=P846hjAu c=1 sm=1 tr=0 ts=6824c513 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=smv6OX6-uiLDgJ-nPY0A:9 a=QEXdDO2ut3YA:10

On 14/05/2025 17:01, Darrick J. Wong wrote:
>> It seems many sub-tests are same as 1222
>>
>> It is difficult to factor them out?
> Yes.  g/1222 will _notrun itself if the scsi_debug module isn't present
> or the fake device cannot be created.  Apparently many of the people who
> run fstests also have test infrastructure that cannot handle modules, so
> they don't run anything involving scsi_debug.

ok...

> 
> That's why g/1223 only requires that the scratch fs advertises some sort
> of atomic write capability, it doesn't care how it provides that.
> 
> <snip>
> 
>>> diff --git a/tests/generic/1224 b/tests/generic/1224
>>> new file mode 100644
>>> index 00000000..fb178be4
>>> --- /dev/null
>>> +++ b/tests/generic/1224

> <snip>

>>
>> But we also test RWF_NOWAIT at some stage?
>>
>> RWF_NOWAIT should fail always for filesystem-based atomic write
> It's hard to test NOWAIT because the selected io path might not actually
> encounter contention, and there are various things that NOWAIT will wait
> on anyway (like memory allocation and metadata reads).

The filesystem-based atomic write will always try to allocate blocks, 
and this will fail for NOWAIT.

But, come to think of it, this is not even a useful test - so forget the 
suggestion. I was just testing this as a sanity check to prove that we 
are getting expected behavior.

> 
> <snip>
> 
> 
>>> diff --git a/tests/xfs/1217 b/tests/xfs/1217
>>> new file mode 100755
>>> index 00000000..012a1f46
>>> --- /dev/null
>>> +++ b/tests/xfs/1217
>>> @@ -0,0 +1,70 @@
>>> +#! /bin/bash
>>> +# SPDX-License-Identifier: GPL-2.0
>>> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
>>> +#
>>> +# FS QA Test 1217
>>> +#
>>> +# Check that software atomic writes can complete an operation after a crash.
>>> +#
>> Could we prove that we get a torn write for a regular non-atomic write also?
> Perhaps?  But I don't see the point -- non-atomic write completions
> could be done atomically.

oh, from my reading of the test, I thought that we were ensuring that we 
are writing over many extents, and so could not be completed atomically 
for a non-atomic write.

BTW, there is a typo in a comment for that test, please see "ssecond block"

Thanks,
John

