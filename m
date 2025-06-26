Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A635C2264C5;
	Thu, 26 Jun 2025 07:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750923231; cv=fail; b=ajbWN48CafOjx8CbFsy9mCn/ng1aSCVdMaUcg5JxXCGwfSpuuFlAHomdly/zVOyPbv0dHyHwi8WTnjC6AlwNfeoVvK32drvwvK3WGO0FnkiJxD4x20uVB75UQZsJgV4+m6mEI5Skji75alLuiCTdpRTWvksprhIB4INqZQX6hdo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750923231; c=relaxed/simple;
	bh=EaWwH7r7sNujAJ9jVn9jnonXwu2jk9W/G2U/2sHseb0=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SIci4Af/cJB1RrWMuMgI7m6CWusNG5/ljXcVSxI61B+LfCNrXlgxz7MsE1YKh0ZSOfXFNiYz1i8/8jQIwfoZ/3Sng1T+9W9k9DTnvmdGw2QqtxB2BQdRHY25Jha0ew3iUViqifQ2Z4162tKIAgz6Jye9lakBBbbejrNtkegGUOc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AsP6PpFg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RXgv0fZy; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AsP6PpFg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RXgv0fZy"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55PLBwV2026611;
	Thu, 26 Jun 2025 07:33:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=QQCMvuLLFzWLI+JG+uNM3s/o6ITD5GBQFQ4AYe/QFsc=; b=
	AsP6PpFgD4QycyP4XSGEtTVcWH6x/+NK/DSGwbOuVk4pZtU9ZE5mkmfOt3HfJC2F
	KfgHdaiER6/WJWhZHNZgRhoobTuaT/mGrunZEZA3/L6FnFVLiuMqOgLqgDaSKkXG
	MvkiZSLMIl6lJelKfc41InMo1yKM7CEOftvgpKYGUTUhQa0v80vdl2qskFqIkjIJ
	hi/Wq/gLr2wYgpHdaXAx6KblW8X/WsvikwZJFm6xFhIGmIvnTd2aniq0IkrzwxrS
	cT7utYa+K3v3GDyiQMySgORixjl82JMy86L2SWWSsk+QEz1sn6NxkUnRVRjjzERr
	YoaYrdSXRbjsNkRskTHmYQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ds8y98t2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Jun 2025 07:33:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55Q7DVva037930;
	Thu, 26 Jun 2025 07:33:39 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2061.outbound.protection.outlook.com [40.107.96.61])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ehq65d2g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Jun 2025 07:33:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WyeKAFw1n/m2IMB2W9KcT5AAoTUxb6jarx9cLO5Ubfr2zaOxdWKE7YY64SSn9bPEA3JfT3ZOf5CjpS78jeaeiLD4nN6bSrdY04LVjbO8l3wd72Caq5V15D8h7+ylYBR4uTMCXmzmd9NZjE7srMEFT8bQeZdrTala5Prp98Hq1q9Qk8HZEDITrtCzCPAwaDlRo0LML68Y8BRaY/lBxFeN6MTjePT2ShQduLaclwO+Y/HPSsbOLUEU2v+VeOfMyIK8Yez5vxjamAYehDhPqt8zIP5MhZcYknou0FOd5z3/lWAI+JHDJvDrnsfNvXp8r8ytx4rBWZB2ae9mUfc9Rzv8Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QQCMvuLLFzWLI+JG+uNM3s/o6ITD5GBQFQ4AYe/QFsc=;
 b=WustPuSivY6NP4ae3crrpPnSMhmanTlrsaqY+EKUS/20eVxKFYy+/eGBh/Xu1eHJCEmCKXeUtp/PVtxRPgtg1pBPciMVuur6fcgoDlU6a0GUI3cillGY2Jr8wVEOxbxF3Bjzs24PjFc2r2ziQtzsrsOnG0PM1amsA1WPbi6FhBbbDeBNHF7GVjNEtAr++oAlmmOHW8xT2Y/t7GSNFV953NJvikcnVrUelu/mX+LevaK0Wfe1GbCqaP0IMLT2pXElDiONrF0ACkHTuGCLmCmmjZF08UXaLwmDwc6n98bPJCKfH/mgSYhKhe3TieSiOilQ0ucYXEpP1259joS8d53XlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QQCMvuLLFzWLI+JG+uNM3s/o6ITD5GBQFQ4AYe/QFsc=;
 b=RXgv0fZyZ4217892FfHsQVOYWwCqK8PqdMm1jRUB26HIFaSUlcPPERc5+X2FNEShzsBv93ng395Hcn3AkJ7Xr85OAXDLDSOxvbvjMfhAUgvrsAZ1jsJxHzFCFjdVeVnwBXdRqksx5gXjTR7/nF/r9w4F09c/+VkCMwI06zOSQZQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB7089.namprd10.prod.outlook.com (2603:10b6:8:142::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Thu, 26 Jun
 2025 07:33:37 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8880.015; Thu, 26 Jun 2025
 07:33:37 +0000
Message-ID: <f9c44529-78cb-4db6-a83c-b5f3bb13ee6d@oracle.com>
Date: Thu, 26 Jun 2025 08:33:34 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [xfs?] INFO: task hung in xfs_buf_item_unpin (2)
To: syzbot <syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com>,
        axboe@kernel.dk, cem@kernel.org, chandan.babu@oracle.com,
        david@fromorbit.com, djwong@kernel.org, hch@lst.de,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <685c65aa.050a0220.2303ee.0098.GAE@google.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <685c65aa.050a0220.2303ee.0098.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0201.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a5::8) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB7089:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a3e172c-82e4-4682-4fa9-08ddb483c32f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZmcxK1JER1dvNzN4WmVmSVZDUUgvZlFkaS9DRU0ySThhWHorZko5K1BxQzgv?=
 =?utf-8?B?Z01IZFY2T3NOR2xONXh1UW42TjdZd3BsQjFFR1RLNjdNeitGdlBDSVYrbHRR?=
 =?utf-8?B?MWFGbU9RZmlhODlnakNpZTBhaHlIVHMyMFFoU3QvWnBHWmNwLzZPbUhMRGdS?=
 =?utf-8?B?TUR3UVBLU2tQbnJPUGpTYVJCc0x2K0lDTXErL0lPOEw0VUhobmhhY0NIam5y?=
 =?utf-8?B?M2VMMUR2MXc1WHJmUi9WOTdEcUpjMzY4MHZQdk9oTlJ0Y1FzNUxSUFVrMUJC?=
 =?utf-8?B?UnBWVFBPQjh4WERJcVFuY3lHV1dkbXpJajJaa0dZSERaZ09IekkrOTY2MVIx?=
 =?utf-8?B?blNhMDY2TUpKM0oyZTFSVitKZXlBbGtSbUFEUXViY29NRWFsY2VYSjE5STdZ?=
 =?utf-8?B?bEUzNEhTbzRlcGpST1djRG5JYnBjako3NFdxTHFicHZkdWFRYlJFeXpuVXk2?=
 =?utf-8?B?dW05M0xNdkc4dnBoRk1MS2F4TFRlUlRvZjBSUVFNendidUpMNXI3d1VvczRC?=
 =?utf-8?B?TzNBeWZVZ2c5TEZvYmdML3lYbWM3U3N4VFhRVDRwZ1RwVmFFZ2l5R3dXSmFj?=
 =?utf-8?B?L0xjSkRwdHhYWUhQTFNYTGE5RVVRU0w5d1ArT2ZXbHBrREUyd08zbEluTzdl?=
 =?utf-8?B?bGZBRnZjSXNUNWUxa1NsNVlkRjZ5NWcxL1YrR1ZBNEg2aitFSU9sSTJuQ0F4?=
 =?utf-8?B?WnR4dlFybmQyUWkzR05xNGZGdHZCVEVlRTgvc3FXcXlqcFJhaVBISHBnUm9h?=
 =?utf-8?B?dEZCQjkwOXpUYkthVnp1WFM2UkdzNlRBbmU4eGd2Qmk5eWNaWkR0SG5LZkFS?=
 =?utf-8?B?WUhaeXFyVFkzQnk5MjVFa1lpa2dvMVRac2Niak9ldDdaUSs5UmRMR2c1M0FO?=
 =?utf-8?B?NWxHUUZEU0tFZlM4eTVHcnBLUlNtNitkbzJUMVlmaEZ2K1JoNUsxVWxqVzd0?=
 =?utf-8?B?SVVnUkY2ZUd5enN5UGN0ay9MbHNaeVlER3JRRVVpd3ArVjliL3VrbHNyTmU0?=
 =?utf-8?B?dE02eDBqRDZhY05YeE10Z2RWSWJIZkVXK2tkbi8zTm5MZ09Xdk41aDJ1T2xa?=
 =?utf-8?B?T0puT1lEV3BTbkkwN3pFWS9Cd2dvZ2YzWDl2VmRhVmhGcU9MZzNFd0ZrZEZo?=
 =?utf-8?B?OU9LMTE1d3hxQk1VcnlTa2pZQ2V2U1NtUEZCVnR1SUJHcWFCWWE1OTcxZU1N?=
 =?utf-8?B?alNCbG5vKzBqVVBKN2QwSDlnU1A3YU03ckIyMWRKaHA0QlFySHlFODZQM2N0?=
 =?utf-8?B?ZGJqaXhDOUJjSGNSS2d4eHE0QTc5YzVza2hSVFRZN3I0ZUFlT2M3d3N6Zm50?=
 =?utf-8?B?dWh5STNSelBsT2xqMHkwTlBZQUZrdlJwMDA3T2RkRHRINzNpZlhqZWl1Qy83?=
 =?utf-8?B?bzRDaStiNnZrb3hFMHdQTitxOGE5bVRRKzVHZm1xbTBGWldJVi9heXhPdVRR?=
 =?utf-8?B?ODkrZVpTS3pTWk5YWUQ3V1JQb2FKMzFmZnJMUmdVdXcreWZCdGZsYzBLTkxF?=
 =?utf-8?B?UDRxL0ZTbVVDK2k2RWJwSXNNV09CWVBHcGdlTnlzOTR5SjYxNTdEazBmUVZ3?=
 =?utf-8?B?QWJ6MUVCajJTWnlWNGc2VW1lMThwQXQxOVp2ajB1Mm55enozTGFvRGd2RkxE?=
 =?utf-8?B?UUZMYksxNDFUSGY2OGU0blR2eXA5dGdXZU9GM3E2SkliZGMzd1dpa2NiVFhM?=
 =?utf-8?B?eUhaenNKZE02RE9xMjltZmNMNU1paFNtL3NaZHp5bDEvaE1VZ2RKcXBmWllJ?=
 =?utf-8?B?cUtwK014bXAzdTlmVUZxUEgxai9wdHNZWHcwc2g5OHBhZXdEdnozcCtad2dx?=
 =?utf-8?B?cTFEQStLUlZ3KzJncDRocGlwQ1lQNVJpZURDUGVydWtJdk9yWWJ0VlVaVnJz?=
 =?utf-8?B?RDJsdkpXeVVsZ2FJT0NvVGdDZnY4bTBSeThXdG1CSUUzT2FUQ01Jdzc0ajNy?=
 =?utf-8?Q?L3rQzJHdpGM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aDZxZ0NDQW5pQjZQTHZ0K20zL0pISnFMR2IralpDRHJxMFhobFhGem1TT1o0?=
 =?utf-8?B?dDlXdWNCdGdOZGtDQ3FDK1lFRmkwaFg1bEswZlYydG1FY3MwY0JraDZiWGlJ?=
 =?utf-8?B?dnlJMjNPNWJwU3BKcmJSNTdsY2FSMStScHFxUTV4c1pWWi9vcmxaOUdqRXRE?=
 =?utf-8?B?TnkzNEhtQXJ1VHQ2dW5ic0dNQllGQys3N2o1d2FtcC9YakI1a1I3aUtISGxl?=
 =?utf-8?B?bDFPWFJDc0xVV0F3RE94VER2OUdaTUxiSUFRREhESHJpTFh0a0dQWGFPZy9a?=
 =?utf-8?B?WTE0enNlUGczcjZiam1TdStCODlmSUk0Mzg5NmlQVGNtVGFYczVKbGhYNVUw?=
 =?utf-8?B?S04wNGxXUmYyWXlqT3hSZ1F5Y25KcXdlbWJFTjZ1QjA3OGNuVmxiQ0N3ZUhs?=
 =?utf-8?B?VFE4cnBiRE1PNXpDVEQ5TkUvbmVCVW53a1ZhUUdLZnlTV25yQitlZkI5bkQw?=
 =?utf-8?B?aUQrWTBjL1VvMFY1cGQxMWtHOUdGc0ZicHVOeUZ6by9IMy9BMVJaOHlnb01x?=
 =?utf-8?B?MWJYTWlNWU1nQlhIOGJnY1BoMlVyMmMwL0RCb1BSV2tjeFdHTGVxQzhNdmtS?=
 =?utf-8?B?bHNUVFFuMk9qQm5HVDZ1OEdPcExFNFhMVmYrNVVlTWdOV1dVOVpBLzEwMDQ2?=
 =?utf-8?B?VFNTZVJrTldQQ1ZBTWRrOXFqRjZ0c3V1QW9jdWxXLzdkV2ZEMXAvZ2VNS2V0?=
 =?utf-8?B?eXpjb3dSUEc0TXRkeE9CUUZjc2ljN1o0TGo3b1ppZThuc2dlcmFXYXR1ZnYz?=
 =?utf-8?B?MlhMSGJLQ0dGVlE5K0s1SlJINDVYbVZEcDhlUDBTZnV0aHZWcUYycFpQZ1hm?=
 =?utf-8?B?STdYcTRUQWZKV2VMcTdrR1dFb1JUTFczUXhqRElZUHlIczdLVkRIRzZPSnJo?=
 =?utf-8?B?clJyTTNZSDZCbWRKeFc3bWNTeVcwRmZ6c3ptaCs5YUxxTVdORGxXWSs1eExR?=
 =?utf-8?B?eDFFTGJET1Zyem5DMUdKUHA3a0N4WG1JZ01hK1RUbEQrUGMvNlA4aWpDc2ZU?=
 =?utf-8?B?UFJ6SmRSc0lWaWF4dWxHNit2Qm1TdHlEbmNIeEVueXptU3RLRXVnQWRsbTEv?=
 =?utf-8?B?NFh3eDg0SXliZGZZcllqZkVySzhQM2cySjJqRUpHamhUeFMySjJOZ3oxK3BO?=
 =?utf-8?B?WTh3YmRqTWJobHBtV2szUVJMWUZMdkhGVUFMZVNyMFhwWUFGYkM5b01DYlNB?=
 =?utf-8?B?dVdyUjlwOWdFTUNuWE9yT3NveS9QU1J5bFFTZFMxbzUwNGlrMDJwVCtrZmhi?=
 =?utf-8?B?eVhyVEJlWksybXhiaW5SOUpiQ2FHeVM3UXRyeFpEbEgzYmM2K1hVUS9mRHdR?=
 =?utf-8?B?L0lkVDl1Y0tVS0NLSDVLd3BPaGc5SGJRZXhDeDM3Sks3dHYwUG1wNlg4ZENn?=
 =?utf-8?B?MGNNVFh2cHpsaEozVkF0NExGU01ma2pmUEdrMnpKYTRPa1hUa3Y4UmpBeXhG?=
 =?utf-8?B?OXdnYzZHRFpoZXYyMWI2clJLL2hqZzRBaFFvaWtRdElJRkFkVmFIRXJWOGQv?=
 =?utf-8?B?RU9wZVNLM3FVK3p4V3JuQVJxUlQrT3M1aUFyV09yemI1YkU1ZUZWUjhua3BI?=
 =?utf-8?B?akpvWGRKTUsyQSt1a1hQUHV1VDZNRnh6UUQycUh4WTlHelFWLzdYL050K014?=
 =?utf-8?B?a0pQMExVZklkL2JibnY5SUR2c0ZmYVk2NVFsOFliWWl6bkkvSXlxZHpwZkRR?=
 =?utf-8?B?Qkp1RTlIV1ZUeWFZNW9oR0xNRFVMSk15QmU5ZUhXMWx2Rlk3MlJQUTJTaU1W?=
 =?utf-8?B?aldPN3ZqRDBJU0NqdFZLZHZlUzFlKzVrM3BCTzNPREQrcE41M1BQKzV2YVZF?=
 =?utf-8?B?SjlIcWxaY05Sb1RrM0tjZGxCd0dib1ZDczB1TW5vdEZrcHJwYUV5bWVwZC9P?=
 =?utf-8?B?eFhHd2s1aWtDUUQ2cUVFbEZlalBFaVkzR2d4VC9jODdtMDY3Vzc2TGRyalhl?=
 =?utf-8?B?c2JYZEhWZndPdG8zeElRa0Rlbmk2TXh2R2pSd1pOWlJ1V3VkOUVScXFVR0JE?=
 =?utf-8?B?QjlXdCtaS041cWZoMXpNMkRBQ1dVSlBuancwSlkzb0x6YjBCUmRITTk3TzZV?=
 =?utf-8?B?L09laXpVZUlsaEthbm1SMm1tRndEbnZuaklLTkpWY1BsV2t2M0M0NjFDc3Na?=
 =?utf-8?Q?3cICEjEkbs2Flyuw+7PnBlNBw?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JGrX5qHaClodfQN3HPdOJ5O5YbTr/f1FWXYS3Bd/pI1L7w9qiGBSjRlOVpQ1UojwJM4zIzQGj6UOcpiFzlj8ksO5sfJ5Ed5lDW7TmGF3XHsEX1sWIq4yD9mdJn00KhdFbbTRZZj+Ct1MCq5QMlsqOZjx7Q17pMoKtMF2XuzXsy7D5HbbKctBihfy0NihbkJoJBtC+J8MNJnTK9H9TZKh0vNGzYDYXnHO92f1GD4gWQ1QleU9k3Ffwlu/HiwIc2W7kj0TB35Ff28tX7FTw3krW8u+75+tjVvTy7SlYSGce6Cbp/UeSF2lIYnOgYs7h3zow6ZMPAxTtX9nwku7EBAEdG3JXXJk88DCSLVCCD4pp8MNxhO7fH8mZX8aYWfutIt3b22RvPex6kEwyZJaoq9GMXOQsshATNDhZkvVWKSpJuDisqFR0DGJfpdrk42DrD5OMiazJtI3C0tVAZqYDzMvncwBgNlWwiT1PBrJg7Q+t4AukCBzt+ZsF5LS0Nx7V9z5ypb5OyEcfEQYUQgUiBKKSSs+xI7gaCO9ukZ5LvyK0jC/04LPrB466ENqaw829zJOUr1e5bQu2zd6lhkjIytdPW7aH4glxNueDiiJIgT/WJc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a3e172c-82e4-4682-4fa9-08ddb483c32f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2025 07:33:37.0872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZGFYdBK6kUBEHWGeJxjE0O8zPQnYGoWbh2HhsFhMIvz0uxlwiZV4kgoc4tauG1KKZ4YBqfvxYagCd2cPNTFXDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7089
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-26_03,2025-06-25_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506260061
X-Proofpoint-ORIG-GUID: aRKlLLME7-f9vmYvyQ-Jb7b-JGa-3bUH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI2MDA2MSBTYWx0ZWRfX4kmUP46YVGMR zF9gxE9LsBzbygEmD2twHDKaH411fZCUGOfWrhz+Ja3BpRqxWLNAq0N+t7ccVUTHvk+zdDdcC4i uO/d15EkB9T36uL2CPL0LmiIuJhUerX43g8eHR7FlrxlTj/2hFU4+nxQilsq1s/KiYWOP2nntU/
 v/2LpvAKJBZzKwwnBMsoWG+jg5KStsjkxVTt2xPPky6i71SBvk0xtEq6dngWyobzUsb/fpNlqlP uUgdw56RzpvPDTXl3vtCaoEtZhKAm8qoGcC2NXJmnG1FliJ9QgwF8VOrpZediA9ptIyaVbXoo8+ 6TwzHGdrGgBdmfenAS3LI58CwF2C2cGo2BtW0mBubaalxlNNqFxPT/U+xyED4C26kE3e/5p1x2A
 sGHYnpMz67V+dic9xv5ubXDCAfIUFz9tbtZb6l5VKMl/Qqkh0Wa8ufyhUuGWv9Q+VVLu/ynT
X-Proofpoint-GUID: aRKlLLME7-f9vmYvyQ-Jb7b-JGa-3bUH
X-Authority-Analysis: v=2.4 cv=PqSTbxM3 c=1 sm=1 tr=0 ts=685cf7d4 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=edf1wS77AAAA:8 a=oHvirCaBAAAA:8 a=yPCof4ZbAAAA:8 a=qbMezw1CFuLAjdWZQ_8A:9 a=QEXdDO2ut3YA:10 a=DcSpbTIhAlouE1Uv7lRv:22

On 25/06/2025 22:10, syzbot wrote:
> syzbot suspects this issue was fixed by commit:
> 
> commit b1e09178b73adf10dc87fba9aee7787a7ad26874
> Author: John Garry <john.g.garry@oracle.com>
> Date:   Wed May 7 21:18:31 2025 +0000
> 
>      xfs: commit CoW-based atomic writes atomically
> 

I doubt that.

> bisection log:  https://urldefense.com/v3/__https://syzkaller.appspot.com/x/bisect.txt?x=1078f70c580000__;!!ACWV5N9M2RV99hQ!IO9HLnkduh21RXrysCkGd5EwKULWXBKlb3ev5ZMgQeelky5q1WN8EEbZRFGFt6mQ3V-5nQ0Hy7Pdg7_O1wnAnQsnkiZHt6E2Mjghf5yjgkc$
> start commit:   85652baa895b Merge tag 'block-6.11-20240824' of git://git...
> git tree:       upstream
> kernel config:  https://urldefense.com/v3/__https://syzkaller.appspot.com/x/.config?x=92c0312151c4e32e__;!!ACWV5N9M2RV99hQ!IO9HLnkduh21RXrysCkGd5EwKULWXBKlb3ev5ZMgQeelky5q1WN8EEbZRFGFt6mQ3V-5nQ0Hy7Pdg7_O1wnAnQsnkiZHt6E2Mjgh1hPp424$
> dashboard link: https://urldefense.com/v3/__https://syzkaller.appspot.com/bug?extid=837bcd54843dd6262f2f__;!!ACWV5N9M2RV99hQ!IO9HLnkduh21RXrysCkGd5EwKULWXBKlb3ev5ZMgQeelky5q1WN8EEbZRFGFt6mQ3V-5nQ0Hy7Pdg7_O1wnAnQsnkiZHt6E2MjghsY_KRNw$
> syz repro:      https://urldefense.com/v3/__https://syzkaller.appspot.com/x/repro.syz?x=12350ad5980000__;!!ACWV5N9M2RV99hQ!IO9HLnkduh21RXrysCkGd5EwKULWXBKlb3ev5ZMgQeelky5q1WN8EEbZRFGFt6mQ3V-5nQ0Hy7Pdg7_O1wnAnQsnkiZHt6E2Mjgh1b3S_m0$
> C reproducer:   https://urldefense.com/v3/__https://syzkaller.appspot.com/x/repro.c?x=147927c5980000__;!!ACWV5N9M2RV99hQ!IO9HLnkduh21RXrysCkGd5EwKULWXBKlb3ev5ZMgQeelky5q1WN8EEbZRFGFt6mQ3V-5nQ0Hy7Pdg7_O1wnAnQsnkiZHt6E2MjghsawMc2o$
> 
> If the result looks correct, please mark the issue as fixed by replying with:
> 
> #syz fix: xfs: commit CoW-based atomic writes atomically
> 
> For information about bisection process see: https://urldefense.com/v3/__https://goo.gl/tpsmEJ*bisection__;Iw!!ACWV5N9M2RV99hQ!IO9HLnkduh21RXrysCkGd5EwKULWXBKlb3ev5ZMgQeelky5q1WN8EEbZRFGFt6mQ3V-5nQ0Hy7Pdg7_O1wnAnQsnkiZHt6E2MjghUHDt4Ao$

