Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86761DD529
	for <linux-xfs@vger.kernel.org>; Wed,  2 Jul 2025 08:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751446218; cv=fail; b=PXrGQ5YUn2IgJ/ipX+a9mLCGY3GUjHFYlPCDQuU3d4xETm1JNTKWhRGClrz5JAHpTNRKpIeLCU+ijHwJP1IuY84DqQAXkqY1r6Mh4Rm9AhyHlUP8zy0i76lJT8P0TapSBU5kG7QuSujGVh28B1IWQVcJ8rziB55gpYk23t6Rm2g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751446218; c=relaxed/simple;
	bh=JnKPnb/Cxl7EWMYTv9Z5FiJBxzdTyqizdGx4E9Fuj/4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TMo0S6CpUD7SzZ6HJN37gx9VH5c54UHBWPUN1WJ6b0i5ezz7Ld96az3LvBcQpAmPA95UUHlsvy90RQPhpf+xUydQ7SUN49WyKxiRttBGZ9YVWa07YXSjTVDNBOJMXBCe3ZNDqqOGnLYxZm6uRopoD6XT2eHmcrIS3/23b/FnjWo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TtSyGiTw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=E8+zsD2H; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TtSyGiTw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="E8+zsD2H"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5627MaVm005747;
	Wed, 2 Jul 2025 08:50:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=lPtBOuMxFo+FIECohJfBuZWsSSJQCd880nrP3gSgIW0=; b=
	TtSyGiTwtS9jIvhIgr1sFugz3YI6OTs5qC6X2tayAesLGcLp174QZzhQJRImwl4H
	8qxBIkM46tmZRUHg2BLW95wk42ujEsleOkWjUu0Z3VeZDhltGzUSdEwPL4SLuGa2
	s/4JQW0ljH4KHUO17b76apcxv01dEdeBtdRhmOX26b4R4iw26+FZld+sCILLxPuY
	k0MnlYVBwQZ6oyQ6m8wmnLrfusH44mozxsfEcqnPHX/gp4nQTDmRiI8QZwCA41cX
	UD1BoDJC0VxvpzspdUVae0QP0XRe3hxoNaY3W4ncNi9DH9ZEdVOplCKOqRKdupyj
	V93rslTyCfGD6H6GB2Qciw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47j7af6equ-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Jul 2025 08:50:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5628OO2c033740;
	Wed, 2 Jul 2025 08:50:10 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2077.outbound.protection.outlook.com [40.107.243.77])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47j6uax79y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Jul 2025 08:50:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DQSvpI3Fd/hCFu8xqof5K/dflnO7U1TKv04VcUr6oBof+RUvTdWjTctRQ2W/G+owomG9X9GB2rnvmoXCZHqtOmEDdaniIUK3DW/nNyzN+sy5CFthGw8RLB/Lqg6WTCcE1ECalniowpFO/RLjUoxGcnq4dB3vkbgGquW2+Xd48UAmv5+Tcfng/ldarbDVevkOLDLBmUjdrdx9Wn39S8Uvh4UUCM+SwWPP4RCE3dsVBHLxiEnRHp8FN544qTFSP1x8v1aR87iDjQprYf9qd4JppQEcjsxH4ds9qFO40H9zIrP0GsbREmq3aRuO80H2rytDMIUIqsiXAqA0SbkglgtD5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lPtBOuMxFo+FIECohJfBuZWsSSJQCd880nrP3gSgIW0=;
 b=q4JHYaZQXUt+pOxP70+tHZ0iYA/TzN13nEW+2aUhLtjAe9lEjxfC/g+hsDCYd9vFUt98RiuAhkJXTMjPOdC11k236pzaxXLPwiCxKC9GERYXe5ZCdNibxuLP8mtX0UIm0On8UMcyP4MTvBxhiF5FvV51t+g6iHf9u1bg8649D2LQi5zmkMJF0MCpoaq467mdhG/9tWCsctcai1wwFGPCRd0quetzB2QHAiE4uA5LSRrV3NyGcqLCzftFqXmSUMrA++mJ/pxKeqeTd9qI42o41Z8XV0Av5TpgRyDWj3vjpdDkR/6L9gMIrikCIUinUS9Lty/fNE3LNiOwkBbo1vS6dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lPtBOuMxFo+FIECohJfBuZWsSSJQCd880nrP3gSgIW0=;
 b=E8+zsD2H99qi4ec6H040OD5bPGyflq15l4sLQGxEt2RmG5Wmm5NSIABPzRbzfYYnJsT7n9ofwMA0f2+E3yyd0kpThw81CSq8MDjCrBTT3WY0dIn9aakl9wqqoTran4YYXcxUjMRhlV8boBMTdOtjmDmfxaAhYjqsx7nTMLdJH7g=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by DS0PR10MB6974.namprd10.prod.outlook.com (2603:10b6:8:148::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.22; Wed, 2 Jul
 2025 08:50:08 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8880.027; Wed, 2 Jul 2025
 08:50:08 +0000
Message-ID: <b131893c-9952-4f23-8332-2191c3d1198c@oracle.com>
Date: Wed, 2 Jul 2025 09:50:04 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] mkfs: allow users to configure the desired maximum
 atomic write size
To: "Darrick J. Wong" <djwong@kernel.org>, aalbersh@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org
References: <175139303809.916168.13664699895415552120.stgit@frogsfrogsfrogs>
 <175139303966.916168.14447520990668670279.stgit@frogsfrogsfrogs>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <175139303966.916168.14447520990668670279.stgit@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P191CA0033.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:657::20) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|DS0PR10MB6974:EE_
X-MS-Office365-Filtering-Correlation-Id: 51d06c2c-1342-436f-5583-08ddb9457288
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YVNTUnNBODBsUVpka2QwK2QrbUFadWhBeFp1cEorRVl6L2JBYTJFa1FaSDJ2?=
 =?utf-8?B?QkxQK2FzeThFaEdaV1JjU0srcXRHSzVZYk9uR1pXMFRGSndGVkVIZ3Mxamt4?=
 =?utf-8?B?dVBkU2NQSEhuc3JCVHRmeklXUGx2UjJNS043WXhaYVF0SkJycnVUTlZVSVNS?=
 =?utf-8?B?UExVY3VOL3c5OFlhdDRmODVWYXJQU1pmcDU2cVZUZ0JpNTlSRW9FV25tMnll?=
 =?utf-8?B?Y2FWaTVQMEJxeVNWL3FaV056VlVQOWc5Sm40c3NUa0Z5SWgxSHAwaU5DZTJy?=
 =?utf-8?B?SnNSL21UYlZVRW5PQ0tmL3NpZGZMYWZNNDlpczhyb1g3dVRGQmZDN0VrZGM4?=
 =?utf-8?B?VUdKRmd0d25Xc0R3empmdWMxY2F3MVV3eXo2RmZGUTZmY0l0TzRrUVZFbkJx?=
 =?utf-8?B?NFJRTDJUYlhPMDVybEVVY1ptUmdGVUp2RWgxR1pGb25yMkFyRjJ3ZGdycldp?=
 =?utf-8?B?ZEloU3U0bWxrRy8rT1ZVRmxHTnI2alZoTmpKU0JXUm9iTnphMGI2dVRXaE1M?=
 =?utf-8?B?ZThWN29RaG5pR0F0S2FRV0VuaTVyNFM1Nzh6Rit4RDcrbFhQZmJCTWVCZkd3?=
 =?utf-8?B?NC84azAzQlUvMmxjR3RVckowTncyT1JxWjY1WXhYVTQwZFNVSlB1ems3WmZD?=
 =?utf-8?B?ZGVxVVVkVE9ibkxZb0VrZFVjbE4vOEp2anhSNUM4eHg5d2s3OFp2SnVuRkJM?=
 =?utf-8?B?OGoxOEdNdjZycTN3aDBPd3RTSFZFbXNwOXZOeVl6OWM5Y3kybktHd1V1K1BZ?=
 =?utf-8?B?OVQ4dm5hRE9CTW9pV1FPamI1SVBFYTRQRDB4YmZYL0hMKzNwU0pWQ2VPTlpu?=
 =?utf-8?B?UXk0VU5zSENCQ0dwejhuRjBHcHBqZ0RwNG42TDlDdWpHUXpxdzhyV0tWVUM0?=
 =?utf-8?B?amtYMm9aVVNsL3VhRGVteStISzlrOEJUOFNOTGxUMjcwOWc2QWl0N1FVaVpl?=
 =?utf-8?B?SGpkZ2lpcTlkZEQzRXFPTTZEWUVYSmhhdU96Q2lDWE8zSm1taEIzRVFGUjBk?=
 =?utf-8?B?MFR5QW5zRko1em9TRjJ4aWxJMzZ2TS80MjJUSmw0WWJQbnNyTThHOU1PdHBQ?=
 =?utf-8?B?ZytkbXpKZGNYcmo5Y1dBaHpoWFVDT2pIVlpheEtJeHlNZFpZdi8ycWc5VVo0?=
 =?utf-8?B?Um5FTFE0R01DUERtL0pxQkIxNTNiRkhpdktSMk1kckxJR0hsejlZUmFuOGQ3?=
 =?utf-8?B?ZityZ01BSWcvb1JTR2VYaHY2VTJlNmhURmh0ZzBWT0o2ZUdlS3d0N2FlVlVp?=
 =?utf-8?B?MGxuYm1RbkNucmdiWHE0ekorZ001MUJGZVVKQTR5dXdITWFsK0EyS0YraVYw?=
 =?utf-8?B?czVncFQ0NFlsNmVpdTZyRk5NMHg2MnRvcS90RG54cUVSV05tejd4dmNJOUJs?=
 =?utf-8?B?Z0RzM3JJY1MwdlIvNnlGT05uL2c4U0NuaFRTQXlkdk9xbmZvY1RtZDdrTENK?=
 =?utf-8?B?aTU0aFRWTDJ2RzlPZHNGL3RlbTI1WGdLZ1hPRmJXeUhrRndoZ0RvVkVoTE8z?=
 =?utf-8?B?b29XbnZmZ0tWald3WllVa1hHelVycCtlU3NHRGVndUVDQkVwTGowbTcrRjdu?=
 =?utf-8?B?ZzZLUjhBWFRkcEl5NHRITFc3bURTUnl0SzNVb3FVMU1mQitsdEJudTB0eElW?=
 =?utf-8?B?SzlQWDAvVjFXM3kwK0MvTlZ4RzNyTDFTVlBlT3hCTk5zczZCcDV3YlREcWZH?=
 =?utf-8?B?MmtibHVROU0rdmQ2eW8zOUF2eVhkR0Yzb0xWd21UWU4zWXdmTE1tWnRqMXM0?=
 =?utf-8?B?Rk4zWklaNnVIZHNiTXh4N21Hckt4UitkRlN4ZzEyVzJ4MmVQaUVFbTY0T3Ar?=
 =?utf-8?B?Sms4TGQrSHpsSCtHQjRMdzZTYXdVMGowOVlTWmFHSGVqcWZudllWaHdPd1dX?=
 =?utf-8?B?Z1pQRTZTOWhIam84UVpHNVg2YVBkaGpxWkhzM0RUSklUSVE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bkZkT1dLR1oxeXNlQ1pEenBHR014aXBDVzlORDlqdjJFZHJWcXVxZ1p6Y3ZZ?=
 =?utf-8?B?YVdJUURjdU4zbXpLbnEzT0FoTElaVFQ5V2RVWTdqaTBpOVZRYk0vVmx5WWRG?=
 =?utf-8?B?NzVyaVJvSWVVOVNLeVlqenEzMzdGSkUzOHR5VXJ4UFhuV1lIU3V3MlBzRHdE?=
 =?utf-8?B?UHVrdzNhQU9mQko5Tk92Q01YaXBCclNjbDlJWm1HL3Vtc0lCNEpVaWV3eEhN?=
 =?utf-8?B?ZWZkTllEcHpqTGYxMGVIbE80L2gzMWF4TnFGd1A3MVlWSDFnYzBBZllJN0Ft?=
 =?utf-8?B?YjdJWFpWUGN6dnBZNXlwbHBMODlyYmVLUGZnUmRVMGFlb0dObzZVczdkcWRK?=
 =?utf-8?B?TmVjT1F5MEhYNW1XQkloSDQxZ2JTUTc1Lzlzclc2OEJlQTlWcGRaRFRTZGs1?=
 =?utf-8?B?K3NtL0t3dVFyai9TZUxqYU9yWnAvWm1UdHJxQm9ydFVaUkpqU0JIdkVEU3p5?=
 =?utf-8?B?SHlwNU1XTDFzdWxuWkFnVWYzVlJxMkQ5am1ndlo5NEZ0cU1pa0FCMThyblcy?=
 =?utf-8?B?NUMrelYwSzd3T3VudUhHOHhGTkl0Rm9uYS9rTHZTakx4WklPL0NOaHBtRkM3?=
 =?utf-8?B?TGE4OWt3ajBxaEZCRXp0ODBybml0YVVEQUFqanBwYzl3KzJ5YmFrVU8zUVZ6?=
 =?utf-8?B?Tjg0UDFuN1VSQ3lMTE5nR2pORFdCRURRdkxvSnRic2tqd3plZTdWeWpmNTRL?=
 =?utf-8?B?RFpLNmtZUWUvNnVRYXR2NWowZjRPaTZHN3JvUnE1U0N4a3hiejBlMk0rZFNo?=
 =?utf-8?B?aUtTcDZuY0l6MFhvaGNHQUMrdWZtWDRhc3pJVTNjdm5EZU9KVUFUUkFzbUpW?=
 =?utf-8?B?QVlVR09iZGFpMDRUb0hRdlZCYXA1anBDRVJMcTdwbE92S0NUcU1vQStjRTcw?=
 =?utf-8?B?VURzdmNydmg2aWx0Q3B5cnBUaitPZ1Z1ZHcyMktmYll6NzZiVGZ6Y1luVFYz?=
 =?utf-8?B?dU82TnZJVlNicjZEOTJzTjJOblNBODRBTUxCbmFMbngzMVRhS0dMMkFsZU1r?=
 =?utf-8?B?czZFcGlrMnpoQUlSTzc5ZzRZcmdLVTJXWVNzbXFyTkhxcTZOSUtkcE93U25I?=
 =?utf-8?B?bmJkN0lBNUIzVlE1VTJ5TW1BUW5iTVRhbk0wZHpyM0ZyMGxWaFVZanhLZ05a?=
 =?utf-8?B?b1dDTG9La25tdzhBODRWeTc4RFdSUFQ0TWFYUWFGTkRmTVMzbEJ3bWtEV21K?=
 =?utf-8?B?UzBTV2F5UU9PemR2OXNXTHE1WU91dnlzNHZXOVg2SDRqcE1hbFhkTjBMdC9C?=
 =?utf-8?B?aFc1WGpzZVFyNUN5K0RickZZNGViYmZRNUhVeHlpamZLVG5UY3VaaGRlNzVt?=
 =?utf-8?B?NnZUUnZvbks3ZHV5UCt6cHFISzBYdUNacldZYXRSWWJ4aDREd0xqdEdQY09B?=
 =?utf-8?B?YTdOWk9CSmdvVm1uZGx5ZnpZTlN5OWs0YXc3K1JuRUV0RTFBNk1JTksvUGFn?=
 =?utf-8?B?bkVWTURyK0xiNlVWUEV5L3h6dENQUG03OVhUKzBEdHdnUmtkeEkzY3B4bTRK?=
 =?utf-8?B?eWxJcWFNOFJ1U1NiUVZwTFhPbTg4Vzl2SFF0ek9ZaGJSWjAzRUw1KzdseFU3?=
 =?utf-8?B?a2d5dm1kTUNHT2J1VWJwbTk0K3V5OFVIZWhUdVNNdTJxRHFmZVJPa2dBRkUy?=
 =?utf-8?B?ZGplTFVFYm4xWFU2V3FCbE1GYXpjVHRDTHVoejBYNHAwdGtXNHN4ZElUNVBp?=
 =?utf-8?B?a01LeFNwYjFQNVFPUVovOVlONkorZlN4WGRraU5jcWNpVVhqbVNKTjB5eEZp?=
 =?utf-8?B?MjF6YXNyNWlkSkNyQ3UwQVplZnRHYllqZlJMUSt0MGR4eC8wRnNmenlSdmhi?=
 =?utf-8?B?YW51eCtTdTkwNElETDZlOTdnOTZuNGZ4Mmg2L05pVFhPaDl2ZDhNM2Z5WVVD?=
 =?utf-8?B?TGhuTkNJaEQraklvVEgzN1QzUGdoNHNPU1dSK05mNmt1SFVDZm5YeHdGclVO?=
 =?utf-8?B?My9udmF1VFVPcjB6U3ZWVzdaSGRwWlhxdVUwdkVoWVRxRmxJVFVHcnBBTGFN?=
 =?utf-8?B?b3BjRkp4RmFJTVUwTXNlazJqaDBjbTRjZXdDaTJvZWU4MEVRd3UrQk5ZUG9U?=
 =?utf-8?B?eFhxOFpaWGhXaGRhUWxXenI2Y2FBaWJWWmtnRFNmbUJ0RERTdGZtY3BZdlJq?=
 =?utf-8?B?M0hJdnMxdkRYVjYzVVVVVnY0UUtPTUMwYUNmN2pabHE4eXpKR0p6a1pjVXNT?=
 =?utf-8?B?RGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	101Q7EYi8GTJr/rpVrV6GIWc/mutZYayU+xJW61qNdyeVWkov+p20eg4S+DW72m2MI5Aogf4GPXlSRkCIEv+kAW9d7xTvY4CZkB7Kw5AzpjYudYftz9RmhtR9PznyW7LmI1JAI4U8Hwchht0Q/ciE0x9QiJowZ9uK3jb4f8qDWGlIgevylG+tsll5GL07Yny37o1a5E021eSBfO4/rJC/dALgfvGqQFNnomi9empjM52V93b/7F6V+qA9f2HGPyK+B9gKXMQxqiMp/dHPgIBbrljMNufY5oPMhvJvezayy6ftMuyu1TLHF74Q6zNFMMzzalCM3WvYbq22uwzJzXgAg85q7jAMHuD3fNPxKUvGCbp8Md9BUu4QQovg23kcS4cf1jIwRsdg2bjPdlCLsfH+5ElhfZHRfp3ZGvprcpeSDaa6TG4i7LshMB0s6WT9xnMR7fCPCddTVNG6qCkHeaGJDqtaJIzW3UMFVJFbL7nwptfBbBX0kBvUCSp3cPRFHpJe7xVNTy8YvbQL8J6gtmUgUnm44L3GcdsFL9XBKYP0hTuvO8c1tLh/uCdMmeNmA92STJK2XitEpwsMzrUMcYGS7afjPfB6dmOMzVLpaImijs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51d06c2c-1342-436f-5583-08ddb9457288
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 08:50:08.3268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 38DbjuFf6qqW3g6Qn/Ed91grjOIYmLpj7EfbJM/t3M940opAtxY0l66QNy4LfmLSTAYVljABYjTb44hsXO5OqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6974
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-02_01,2025-06-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507020069
X-Proofpoint-ORIG-GUID: jkaszVu8V3xS6VrNmvh4-4UFCUGoaBRs
X-Proofpoint-GUID: jkaszVu8V3xS6VrNmvh4-4UFCUGoaBRs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzAyMDA3MCBTYWx0ZWRfX/OSQw2M8NkQb zAVxeTKPl19w7Y+eTlvO51GS9fcMTWkysp8mJzJQZLdO1zDJn3QGTsQQXOe7Ig5l3os9uVUvNMX invWc/EMw7up/EeSutBPNM0vekEcZC9nmQvVWiI8Op4g+1FxY2gXKGpYtSUKFVUIgMghirK58Et
 vdXuEhSEEdSDpdcJ8jY8lPoJrD3waSFZtWqMIJYymn38X+R6FOf82QiadjFQVxg2ud63C9QAKIO CC5ciOkHUJbILn8HXvSckDfEcARYQwIBZml+pkBt2fxsq/nDIB15YeFYsG6v2nASmb5AF0IGa1E bV1nqvz37G1sICaB4K/wnr8wc89sz0g95aQHsY3nbHrRB8ByRzj143zwkAbdlPbaXHyssgOyRDl
 uumUFnu57RGd2fCp0BXBOvXggpGXfuKZBkdJaYF/5mM27B757YsapE/nCs1DT71khjqqi9Oi
X-Authority-Analysis: v=2.4 cv=b5Cy4sGx c=1 sm=1 tr=0 ts=6864f2c3 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=K3q0MK5l5tTl9XKryPYA:9 a=QEXdDO2ut3YA:10

On 01/07/2025 19:08, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Allow callers of mkfs.xfs to specify a desired maximum atomic write
> size.  This value will cause the log size to be adjusted to support
> software atomic writes, and the AG size to be aligned to support
> hardware atomic writes.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

thanks, regardless of comments below, FWIW:

Reviewed-by: John Garry <john.g.garry@oracle.com>

>   		goto validate;
>   
> @@ -4971,6 +4998,140 @@ calc_concurrency_logblocks(
>   	return logblocks;
>   }
>   
> +#define MAX_RW_COUNT (INT_MAX & ~(getpagesize() - 1))
> +
> +/* Maximum atomic write IO size that the kernel allows. */

FWIW, statx atomic write unit max is a 32b value, so we get a 2GB limit 
just from that factor

> +static inline xfs_extlen_t calc_atomic_write_max(struct mkfs_params *cfg)
> +{
> +	return rounddown_pow_of_two(MAX_RW_COUNT >> cfg->blocklog);
> +}
> +
> +static inline unsigned int max_pow_of_two_factor(const unsigned int nr)
> +{
> +	return 1 << (ffs(nr) - 1);
> +}
> +
> +/*
> + * If the data device advertises atomic write support, limit the size of data
> + * device atomic writes to the greatest power-of-two factor of the AG size so
> + * that every atomic write unit aligns with the start of every AG.  This is
> + * required so that the per-AG allocations for an atomic write will always be
> + * aligned compatibly with the alignment requirements of the storage.
> + *
> + * If the data device doesn't advertise atomic writes, then there are no
> + * alignment restrictions and the largest out-of-place write we can do
> + * ourselves is the number of blocks that user files can allocate from any AG.
> + */
> +static inline xfs_extlen_t
> +calc_perag_awu_max(
> +	struct mkfs_params	*cfg,
> +	struct fs_topology	*ft)
> +{
> +	if (ft->data.awu_min > 0)
> +		return max_pow_of_two_factor(cfg->agsize);
> +	return cfg->agsize;

out of curiosity, for out-of-place atomic writes, is there anything to 
stop the blocks being allocated across multiple AGs?


