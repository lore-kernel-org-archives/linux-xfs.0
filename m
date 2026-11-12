Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794488255;
	b=vtXoxdLsHMacDs+eFyGqyQb/saPkT7zPVwUi5SfIJFCR3l3CqhwC/Vz4m8XQYgIyujIO
	 Us0rMa3SVPF73jZBfTjyXsBKjHrL84glHV7XWOCDhWexMVRe8F38iiM6bLudta562lbyj
	 vxmlxlSXBXImJdqi2+L/B+tc8TBTJCExTkaa4CR2n9CpQsuncP9dIW7m96CtzytnYdEp6
	 DoEb5ptA/YsjOXY+tbPmkUdUy8hkpjlJU+wOj5vnEYhe5GOte4lTxiLjhDZanh0BYHduf
	 NaRHaYFychTn2GznV+hGwNygDHjaVm/TgXSyM+sjs6ID92hwIqVRtkTqn7duiyjbwlA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794488255;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Message-ID:
	 Date:User-Agent:Subject:To:Cc:References:Content-Language:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:WDCIPOUTBOUND:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=Kq1mSMe1H2lduzs7r2lpsckiF4jZZaC+UQbUGGAjcNM=;
	b=rGBL+8NhQVovMrqe3MtGrVvJE8XICccOAUlaahWt1Gre4nHn72kQo6u6pz331YS1htEr
	 tHybrzLxiWHWOv0nSZG4rbqKOmgc0dxz6ss8MYp2fKXZKEK8GkN4130jH2gy5VNyHgv/P
	 JHXQiKnCj1n3g1uiTavoNi5SQC6jIGsjNLfWiiADd8OfgJXdMOoMemhLYbURpbekJZBHZ
	 +rjUio649AWdeghQVWtJlbiDfilORHdwVnANvMshLGK1FtegHmYBgYCwzOwDIGrDnXNni
	 02I5JdRGpIQq9h8sBmpzlYSHTsDxT0kL+8AwBwBAVeVplFQSz8s2zdRlyNJp1WnDklg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=LLvalFB7;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=zZnCWtY9;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816E9606A31C;
	Thu, 12 Nov 2026 12:57:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 816E9606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=LLvalFB7;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=zZnCWtY9
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794488253; x=1826024253;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QcuC1d52E2SYpWWvtR3iFR095DiD/ed67yIg+l+ZTUY=;
  b=LLvalFB71E2WVJuLWEiD1dKmj6m+PT69LRn1sycqx6jVKyZlxmacJQr3
   zbRihy9TcCQNOV3PtmoWgQahfU4ps01r0NhLQHgLChPdN/9kjJyRGZltz
   +CmHNgidKv/dyUkL+R8r1wTFOtAecASOI9VMeSi2PIiOf6UeUVa99keQu
   oSxXM72VM/T9ARCC5AhA8CP9btC1+GjdoRMSloJB9j8Y+80JezMfL0bTk
   WIeJy+XomXmZAq5v+Fsmn6O+8KUzuNgX7bpV8BH8d3RYCiSoJd1IwsqDa
   lb5aYCJ11ywf8cuV9xYgZogwRLS8mA26cGRblxmuej0aUMrJgjGEJsEac
   Q==;
X-CSE-ConnectionGUID: nfKWJlkbTIKzWvsnDTQh+Q==
X-CSE-MsgGUID: gGabsdcJSiOyvVtEXgo3zg==
X-IronPort-AV: E=Sophos;i="6.27,209,1786982400"; 
   d="scan'208";a="161705663"
Received: from mail-eastus2azon11011049.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([52.101.57.49])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Nov 2026 20:57:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IVPzl6ux2r1FlPc8Q+6iL6zyp/fhSRSMLe+XiTAM0pomgTtskavcneZ2EWPx4j2VMVAltOgJqrkHcsTTOucWtf3dI6wvHkiOozXHkzcCRPoCxlkUVHGRuVFytZBMESIE5GmibQayvZbAKJHx1b2g1LGzSitcglVzx707i8EAIEoixrAr5NPrEnHVq6XaQ1GgRSag6MpJALcDMpueAPzLFVW982luxdl6LtMOZovsA4gHzCL2xVRDSWmK15MBPCl2jIMD6YiLZgDaxhi9QNcOc7sN9moQ+NxzbLSm/n12nh1GDtPFle+mk5DKJVMiqokZMVUDgcfkxCgatLhkUWn2+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kq1mSMe1H2lduzs7r2lpsckiF4jZZaC+UQbUGGAjcNM=;
 b=fttmOf2aBm+GQ1J8HidaX0iL5qrnNvIQ+gIMVoo73kgijf0+JIZRPWnxtFKRf30yK09YxZ/J9QisIBPcTG/132LpX8u/Nka8NC5J4tIgrk/NGS3nSW1n3RytFB/0wpb6i/kSCANrg9ZESgdXHL+34NL/DKQeCfNrUgSdrU6Gg+mwSnfu5g5nZo5vBW4z3HYNkcwqETA1NorUNnWl3h3OzXp6NXe4R1bmfOiPVk4vDm1tSGTDZexSZ9Rdhx53eLjTiAgWQ7ac0VfwzG5r7kR5uMILtzhsbOkDXUnHAgRaXTWVm9WFpNVorhuX4kksZWSCpZvfEUSydjNR0wtAZTUoAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kq1mSMe1H2lduzs7r2lpsckiF4jZZaC+UQbUGGAjcNM=;
 b=zZnCWtY9HoS6Wsy0SwVn22DRCyTt3ldqZWnjRIY2+iSKpbIlXLzK/pO8+PzxmcaWvs3EDRUd2TsUXi+9w6bUhD6WzUiMmsfs6rsPfO/JcqrBN6wiTw+itME/OM2qvz2sYrkdeL73qdm7ezgXMh6qfxhalujI85u1DZw2B71dN90=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9269.namprd04.prod.outlook.com (2603:10b6:806:417::19)
 by IA0PR04MB8835.namprd04.prod.outlook.com (2603:10b6:208:48f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Thu, 12 Nov
 2026 12:57:25 +0000
Received: from SA6PR04MB9269.namprd04.prod.outlook.com
 ([fe80::f392:fdab:14ae:7a94]) by SA6PR04MB9269.namprd04.prod.outlook.com
 ([fe80::f392:fdab:14ae:7a94%4]) with mapi id 15.21.0592.010; Thu, 12 Nov 2026
 12:57:24 +0000
Message-ID: <ea775e38-bce9-4dd1-98c4-5d675b5bd3b5@wdc.com>
Date: Thu, 12 Nov 2026 13:57:19 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 4/8] xfs: implement software write-stream management
To: Anuj Gupta <anuj20.g@samsung.com>, brauner@kernel.org, hch@lst.de,
 djwong@kernel.org, dgc@kernel.org, cem@kernel.org, jack@suse.cz,
 axboe@kernel.dk, kbusch@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 gost.dev@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
References: <20261103110640.1000095-1-anuj20.g@samsung.com>
 <CGME20261103111031epcas5p19a4cdbbf45612ff2c541b2aa0bb6cc30@epcas5p1.samsung.com>
 <20261103110640.1000095-5-anuj20.g@samsung.com>
Content-Language: en-US
From: Hans Holmberg <hans.holmberg@wdc.com>
In-Reply-To: <20261103110640.1000095-5-anuj20.g@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P189CA0009.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d7::13) To SA6PR04MB9269.namprd04.prod.outlook.com
 (2603:10b6:806:417::19)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9269:EE_|IA0PR04MB8835:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cfd7989-a160-42c5-7a18-08df40bc7f78
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|376014|23010399003|7416014|1800799024|366016|18002099003|22082099003|4143699003|5023799004|11063799006|261026121527099003|261022105027099003|261026140227099003|261022075727099003|261009223027099003|261028144727099003|56012099006|261021121427099003|261102123227099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	46dbfb3qnb4yIfzj4TDlcg3THvVlr7Y6FfQZ2CmcgQSYIvg96X39izwlYgx1bqtwcyM18RRni5xGOpxouC+2XCp59ott625Lvk6sTZSJOnHcLa2xhdTTha0UDhbQi8fbAW/FKu55gdPcC+VpYSR2O1Z3thw/kL0ekftNOIqxjMWpYhtrLenXHtTNhXC+EdCiapFkA4FKa+MMeau4/nUlxM3D4eQNfCxHCbC9yflmhdXJaVFh9DC1gK6Hni/GmuC0p49s1rydKQ/WQihpl6vGF6GF58r96a2GLUIQZ5FviwXjT/IZO3mnIyCEOX8+9xOxDVAcPtrG3kM/XOy+CGODch9ouPRB7Fim2BzFG/qwqsn0ap+wTfJsewagZ6sJ424DQ2dfOJhVDjOzW1fOtcFXq3fTPNCdeofqRA3/J+qEJ/JwiGtWsdlg37NJSk84c7+e3wPBZFv+HYtEaHr16nAX+I24tVKCKBa3ix+pRUCBr+d7HbXtg2YxKpy8MPf15SQWDFd9LzKW+uzY0m8h7yUizjD0nnXEE2asvKvxPaXWzgu0LXvg+cupISjzbuLPbceQVX4cJ8a5UfnVGtWOdhEiqOb5nR47/YBKKGvmb5i4nD55byE3eXPofh5tHdIbixPG3mwYRNhGuY4tsdS+jSEjbbHu8ffGTa3qQhGiX13dgsc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9269.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(23010399003)(7416014)(1800799024)(366016)(18002099003)(22082099003)(4143699003)(5023799004)(11063799006)(261026121527099003)(261022105027099003)(261026140227099003)(261022075727099003)(261009223027099003)(261028144727099003)(56012099006)(261021121427099003)(261102123227099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZTRLYlBkMStYTkVMbWhDMlFJT0FDaExWSDhFcnhUNEhOMmF6TDNJUmZQNTBr?=
 =?utf-8?B?Nm9wcEhkTE5BNTY3RWhRenAydVcvUzcrVVNjSlBVQ082clFtVzdyOFFQVmpY?=
 =?utf-8?B?Sm5hYWtaQWFQK1VjeFY2NCtBMERuaVpJTTZxY3cyMlY0WW82UStvMVA2MTMx?=
 =?utf-8?B?S1BneWw3QW1hWTlWSWRjeUs4S215V080TUJVNGg5R3Z1SFBwcFlnejVXQnhi?=
 =?utf-8?B?V2Q1d0tSUmVoeUVjQW1SNjdoRGw5QTk2TFBMQXhzODRHK24wOTZobjh2enRV?=
 =?utf-8?B?RXR3WHV0TVNZV2kwU3pJNGVqUHY3ek5IUGZOdWhhbFZCMWdkSjJtUytLcTdX?=
 =?utf-8?B?YTREOVFVNDY2RXR4VDdZK2xpZnVSVG8xeHRYSjVQeUxKdmxDQWpwcWk4eDlx?=
 =?utf-8?B?UEpFTzFSdnl4cWttS1VlUWZtbDg4UFBpRFpQWngzcU1wcC9idUl2TC8rbElJ?=
 =?utf-8?B?MXlxZDFuem41RHoxRzFTQytNT3NZRWx6N3NSQ0pBSFBISjZhWVVPWXZQMFp6?=
 =?utf-8?B?eGJ5TXFLUVZXcmZReThaS0hraVlING1tTkY2VG9nT2J4cUhJM09uaUtrcTdC?=
 =?utf-8?B?NFJhQjl5THUxQys1L2ZlZnBaTVA0Ti9JMko4TTJZeFdSS29ERVVqN3JobTJ0?=
 =?utf-8?B?cHl3Y3lWM0NsU08vYkNyT1lscTcydWpNUkZMdkUzM0pGbmxQYkYvZ09IQVdB?=
 =?utf-8?B?NFdaYVVIOW1WSjJaUWhPOWNZZmxhd1hnQ2ZtbUhkVldaaURST08yVVhGWThZ?=
 =?utf-8?B?SktoQjd3Szd2eldrZ2U0YnJzRkJEbGpYR3E4d0ZweHdpUkJOejA2QU43WWI0?=
 =?utf-8?B?WGlTemZzNEFwV3NNcHluUHN2MytwSnJKcWQxcURFZ1hTSjVlM1NqNS9ZeFBV?=
 =?utf-8?B?Uzc3ODRobDRlOHh5OUxCL09Lc2ZTTDhvMkpJTEVCVVZCV3k5TS9QSTMzTkRP?=
 =?utf-8?B?QWFQandlMUxCZUlaVXpRN2JYdHQvb0lGWVBBNmI4Z2xXbkVLL1N5NkRBVSs3?=
 =?utf-8?B?VlQ5K1FPOXlvN3ljaHlhYUtDekJ2YUxtRVBaZ3pKekU1U2pMV1NsWGsweity?=
 =?utf-8?B?L2VhSGR0SEZ4MHZpWTN2ZjU5c1RxWkVsUStuMjF0TlYyQ3Z4UUt5d2h4UHRu?=
 =?utf-8?B?SXhxY3BHakpKaXIwdXM0NE94RmptSGpGWEJ3WGlHNkNxNVJoWk1MZFJMSmRN?=
 =?utf-8?B?SjJ0YkRZbDMxOVRFUlQxUmRtd2d0UmlOMHlXVm1qazAwOTcrNnJsdklHK3JR?=
 =?utf-8?B?Z251OWhyMHZvWUlWK0QwaGoxOHUrM3gxdXpobnNyTWtOMzQzSDh1SVh3WXd1?=
 =?utf-8?B?c2JHK1JaMDN6VHkxWkdSSkp5SElubXNxckZBY0NiVUN4UVhqNTlUSnd1SzQ5?=
 =?utf-8?B?YzFYb0RTQTMyWTN4UVRWU1R1OHk4NEFMcDluazNZMlhyblBUbUxCRTJSOFlq?=
 =?utf-8?B?UXlzUFRwYThIaHBDRXVVYjJlSGJoaWs4Q1dML0lHc0hIQ0pLREwrWlJ6SDB3?=
 =?utf-8?B?RWRFVEJPaDByaklnRGNnN2RoVEFlVUo1ak96Ukp0eFlKSzM4WHN0V3RyM0I5?=
 =?utf-8?B?S0U0UStEMk8rdTZ0OEJBZjU3ZHIxeDB0T2R6eHlJbnpXc2hteDZKYkN0VTBw?=
 =?utf-8?B?a0dsWlB3bzkzWDJBSUhwVGc0VnMvY0JYSzYwVEUzK1ZFS0pCQjdqWjRSSXFl?=
 =?utf-8?B?NitIUnFjWVRxK1YwOXNUb2tCNWpySk9QTlN4N1AzQkljUGIxTVBIb01ma2NY?=
 =?utf-8?B?dXlDU3FhbVZiWHZ3NTZxTWdRNkI1WHhOYXFiVlNVN0hFMFk4ZU4rVWladkNU?=
 =?utf-8?B?by8wT1JKN0xsazZWUjhqQjJWY0xsYUVjdVE5ZGhMTGhnODByWWV0NjFCN2dq?=
 =?utf-8?B?UVZaT0JrU1RkRXNCdFIvMHB5TCtydk14UmdBdlF5YlMxWWlyemlpSzJncUY5?=
 =?utf-8?B?Vk5pcEZhc2dDV2E5UGlFOHBoNnNscmtIdVlicVhoWm1UZXlicnZVVjd4NjdK?=
 =?utf-8?B?Mm13UHlnQ0pSRzZKSjYzc2tFOVBneGw1TEUrTHBzVVBmc2RMZ1pQRlhUUzBi?=
 =?utf-8?B?YnR5K1pocVREZ1N1WVBudm5DdGI0NXNzQkowc0Z6RjBhemNsYWxtQW1JYlFl?=
 =?utf-8?B?b1dSUHR0WDI5UGJKUGxLWkpYSWl0L2dQT0FFNk45UXFoME9mbnBtYTd0SXJH?=
 =?utf-8?B?Si8wNDdxOW03aW5Sc3dCclpRU2NvUFBtYW8rWk1pbzJoQ3Zib2EzYTB1VzlS?=
 =?utf-8?B?VUN6Tk1PU29mTTRqZVE0TytaMDUzc1I3a3YzRC9MRmdzd3RpcjhUbDdPaDQ4?=
 =?utf-8?B?MmYwbC9vRkpxdjFwZnV0Wk9UL2wyV2pyVlZvZVJ4Y2szVlVGN1U1UT09?=
X-Exchange-RoutingPolicyChecked:
	IjvgeOvxvuEWOCdfyV5fOtAnr+x1bn8EH1BKJt6itH3wEmDFrDCAlZ5WdZFxW1Z40smk8bipMoijTPURQDzXh3/YE6QL5w0vGHvT5Wb/OGjroU9JG6eWo8fVIQvRLS24N3YlnwvDavycyhMP/RldAv/o10YLVp8fRzh22us/b0F1nqVdcLz/ev3/7OQI/uayKZ18jJKNzwVUsAX7QAprKeaGm8yx6G7tZ/noor0+AczPvmaEgM8qVymIquWVydmQ+Q3cCWyqgaXWUr9ojx1z+QQE7TrjAG923Ro7F6UV3Zj88ScL1ce3d7tODF6t2yT/3kIoFWfe25os3/n4xFc2Bw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jmhWVZbShZNWDVxSrUpeWS7MjT95OcvbGUzGdT0ko8Ovxn9ZKOY5/TWr63vtQxXsmKzyNewpI6TJf5qQct90Tch3jH5Nx9Dm5eCgV/HJif3mdb1PM2tLcWRbMpF/oJxEPFCE4OTBE5izPdbFRqNVCTVDmwbN79bhGRMdPEFK6g4ynQHSp+LT07b4B2x6JzT3TY82XdtygGpuBscaGXtFw2H17rgiiGwz8iYSDxGORSDHA0B3kMuTwPmEBQZmIkipLpUDQPEcBAvGkvoQUIzZ0d7D1+XvP8jzrux2y0yG7HU6l+nyGe9bw2T8CZP4iFM349juNbap7MelvcUYzboEJFor5EA/fgZsroROPSzQNlci1JUMbj65VCeQU6eDm47c8lxHi7HxMFGAYUC9UQvURoEIIbo3/Fq2+8HN3QLdIhZz+wRiSBsHX+3S84DWmA7D1LTbkADhQdbPiRSQrzeBBUJ85q4WUmoUKYkIsplJ+JU7gI0ovRFxW+Szt9DEMh1leSE9KAIrUXdI/3J8IYHTuRH3V6Yj6Fsdwb7QYKGhep2EoT2EiE6qotJ9aTW0HnlBNjebFdEzNqqCyCqkpDP7P2EEaNqI4gCuKJm9YN+Ndwj9sURcC+YgG7fyBxNqacwy
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cfd7989-a160-42c5-7a18-08df40bc7f78
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9269.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 12:57:24.7425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: btyIB9WXK846IqwJOAe5gWFIix0ChuNswP1wdvujtLDG9pOOesMTVQbCKwqtC9z3hMNxApzYWVC6tL2LkR3j5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR04MB8835

On 03/11/2026 12:06, Anuj Gupta wrote:
> Implement the FS_IOC_WRITE_STREAM_* handlers.
> 
> Keep a stream pool in the data device buftarg, sized from the AG count.
> The id is stored in inode->i_write_stream and is not written to disk.
> 
> Write streams, filestreams and write life time hints are mutually
> exclusive. GET_MAX reports zero for filestream and realtime inodes, SET
> rejects those and any inode carrying a hint, and setattr refuses to turn
> on filestream or realtime placement while a stream is attached.
> 
> ALLOC is restricted to CAP_SYS_ADMIN.

The ioctls are defined as generic FS_IOC_* ioctls, but most of the
argument and permission checking lives in xfs:
 
- xfs_ioc_write_stream_set: the flags validation, the stream_fd == -1
  rule for CLEAR, S_ISREG, FMODE_WRITE and inode_owner_or_capable
- xfs_ioc_write_stream_alloc: the CAP_SYS_ADMIN check
- xfs_inode_set_write_stream: the stream fd lookup and validation via
  write_stream_get_id
 
None of this is xfs specific, and it defines the uapi semantics, so
every filesystem implementing these ioctls would have to duplicate it
and get it exactly right. The CAP_SYS_ADMIN check in particular should
not depend on the filesystem, and any later relaxation of it (e.g. the
per-user limit Christoph suggested) will have to live in common code
anyway.
 
Would it not be better to move the generic checks to common code, and
leave only the xfs specific parts in xfs, i.e. picking the pool for an
inode and refusing streams for filestream and zoned realtime inodes?

> 
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> ---
>  fs/xfs/xfs_buf.c   | 31 ++++++++++++++++++
>  fs/xfs/xfs_buf.h   |  6 ++++
>  fs/xfs/xfs_inode.c | 61 +++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_inode.h |  4 +++
>  fs/xfs/xfs_ioctl.c | 79 ++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_super.c |  5 +++
>  6 files changed, 186 insertions(+)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 6c93b4f5629c..d8ce03a9f49c 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1648,6 +1648,7 @@ void
>  xfs_free_buftarg(
>  	struct xfs_buftarg	*btp)
>  {
> +	write_stream_pool_destroy(&btp->bt_stream_pool);
>  	xfs_destroy_buftarg(btp);
>  	fs_put_dax(btp->bt_daxdev, btp->bt_mount);
>  	/* the main block device is closed by kill_block_super */
> @@ -1685,6 +1686,36 @@ xfs_configure_buftarg_atomic_writes(
>  	btp->bt_awu_max = max_bytes;
>  }
>  
> +/* the block layer can tag I/O with at most U8_MAX write streams */
> +#define XFS_MAX_WRITE_STREAMS		U8_MAX
> +
> +/* Heuristic to derive software write stream count from a group topology */
> +static unsigned int
> +xfs_sw_write_stream_count(
> +	unsigned int		nr_groups)
> +{
> +	unsigned int		group_set_size;
> +
> +	if (nr_groups >= 16)
> +		group_set_size = 4;
> +	else if (nr_groups >= 8)
> +		group_set_size = 2;
> +	else
> +		group_set_size = 1;
> +	return min(nr_groups / group_set_size, XFS_MAX_WRITE_STREAMS);
> +}
> +
> +int
> +xfs_buftarg_init_streams(
> +	struct xfs_buftarg	*btp,
> +	unsigned int		nr_groups)
> +{
> +	unsigned int		nr_streams;
> +
> +	nr_streams = xfs_sw_write_stream_count(nr_groups);
> +	return write_stream_pool_init(&btp->bt_stream_pool, nr_streams);
> +}
> +
>  /* Configure a buffer target that abstracts a block device. */
>  int
>  xfs_configure_buftarg(
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index a4729253b56f..b5292e5731e3 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -15,6 +15,7 @@
>  #include <linux/uio.h>
>  #include <linux/list_lru.h>
>  #include <linux/lockref.h>
> +#include <linux/write_streams.h>
>  
>  extern struct kmem_cache *xfs_buf_cache;
>  
> @@ -102,6 +103,9 @@ struct xfs_buftarg {
>  	unsigned int		bt_awu_min;
>  	unsigned int		bt_awu_max;
>  
> +	/* slot pool for stream fds on this device */
> +	struct write_stream_pool bt_stream_pool;
> +
>  	struct rhashtable	bt_hash;
>  };
>  
> @@ -360,6 +364,8 @@ extern void xfs_buftarg_wait(struct xfs_buftarg *);
>  extern void xfs_buftarg_drain(struct xfs_buftarg *);
>  int xfs_configure_buftarg(struct xfs_buftarg *btp, unsigned int sectorsize,
>  		xfs_fsblock_t nr_blocks);
> +int xfs_buftarg_init_streams(struct xfs_buftarg *btp,
> +		unsigned int nr_groups);
>  
>  #define xfs_readonly_buftarg(buftarg)	bdev_read_only((buftarg)->bt_bdev)
>  
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 05a14da28031..636f039e8f71 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -4,6 +4,7 @@
>   * All Rights Reserved.
>   */
>  #include <linux/iversion.h>
> +#include <linux/write_streams.h>
>  
>  #include "xfs_platform.h"
>  #include "xfs_fs.h"
> @@ -47,6 +48,66 @@
>  
>  struct kmem_cache *xfs_inode_cache;
>  
> +/* Number of write streams available to this inode. */
> +int
> +xfs_inode_max_write_streams(
> +	struct xfs_inode	*ip)
> +{
> +	xfs_assert_ilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL);
> +
> +	if (xfs_inode_is_filestream(ip))
> +		return 0;
> +	if (XFS_IS_REALTIME_INODE(ip))
> +		return 0;
> +	return write_stream_pool_count(&xfs_inode_buftarg(ip)->bt_stream_pool);
> +}
> +
> +/* Bind the write stream named by @stream_fd to @ip */
> +int
> +xfs_inode_set_write_stream(
> +	struct xfs_inode	*ip,
> +	int			stream_fd)
> +{
> +	CLASS(fd, f)(stream_fd);
> +	struct xfs_buftarg	*target;
> +	int			id, error = 0;
> +
> +	if (!fd_file(f))
> +		return -EBADF;
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	if (XFS_IS_REALTIME_INODE(ip)) {
> +		error = -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	target = xfs_inode_buftarg(ip);
> +	id = write_stream_get_id(fd_file(f), &target->bt_stream_pool);
> +	if (id < 0) {
> +		error = id;
> +		goto out_unlock;
> +	}
> +
> +	/* Filestream and write-stream are mutually exclusive */
> +	if (xfs_inode_is_filestream(ip)) {
> +		error = -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	error = inode_set_write_stream(VFS_I(ip), id);
> +out_unlock:
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	return error;
> +}
> +
> +void
> +xfs_inode_clear_write_stream(
> +	struct xfs_inode	*ip)
> +{
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	inode_set_write_stream(VFS_I(ip), WRITE_STREAM_NOT_SET);
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +}
> +
>  /*
>   * These two are wrapper routines around the xfs_ilock() routine used to
>   * centralize some grungy code.  They are used in places that wish to lock the
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 75eff68c1e39..15cd735d8fe9 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -681,4 +681,8 @@ int xfs_icreate_dqalloc(const struct xfs_icreate_args *args,
>  		struct xfs_dquot **udqpp, struct xfs_dquot **gdqpp,
>  		struct xfs_dquot **pdqpp);
>  
> +int xfs_inode_max_write_streams(struct xfs_inode *ip);
> +int xfs_inode_set_write_stream(struct xfs_inode *ip, int stream_fd);
> +void xfs_inode_clear_write_stream(struct xfs_inode *ip);
> +
>  #endif	/* __XFS_INODE_H__ */
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index f81b6e52ac40..2490b6ec5f4e 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -557,6 +557,11 @@ xfs_ioctl_setattr_xflags(
>  	bool			rtflag = (fa->fsx_xflags & FS_XFLAG_REALTIME);
>  	uint64_t		i_flags2;
>  
> +	/* refuse a filestream/realtime flag change while a stream is attached */
> +	if (READ_ONCE(VFS_I(ip)->i_write_stream) &&
> +	    ((fa->fsx_xflags & FS_XFLAG_FILESTREAM) || rtflag))
> +		return -EINVAL;
> +
>  	if (rtflag != XFS_IS_REALTIME_INODE(ip)) {
>  		/* Can't change realtime flag if any extents are allocated. */
>  		if (xfs_inode_has_filedata(ip))
> @@ -1436,6 +1441,73 @@ xfs_ioc_free_eofblocks(
>  	return xfs_blockgc_free_space(mp, &icw);
>  }
>  
> +static int
> +xfs_ioc_write_stream_get_max(
> +	struct file		*filp,
> +	void __user		*arg)
> +{
> +	struct xfs_inode	*ip = XFS_I(file_inode(filp));
> +	__u32			max;
> +
> +	xfs_ilock(ip, XFS_ILOCK_SHARED);
> +	max = xfs_inode_max_write_streams(ip);
> +	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +
> +	return put_user(max, (__u32 __user *)arg);
> +}
> +
> +static int
> +xfs_ioc_write_stream_alloc(
> +	struct file		*filp)
> +{
> +	struct xfs_inode	*ip = XFS_I(file_inode(filp));
> +	struct xfs_buftarg	*target;
> +	int			max;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	xfs_ilock(ip, XFS_ILOCK_SHARED);
> +	max = xfs_inode_max_write_streams(ip);
> +	target = xfs_inode_buftarg(ip);
> +	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +
> +	if (!max)
> +		return -EOPNOTSUPP;
> +	return write_stream_alloc_fd(&target->bt_stream_pool, filp);
> +}
> +
> +static int
> +xfs_ioc_write_stream_set(
> +	struct file		*filp,
> +	void __user		*arg)
> +{
> +	struct xfs_inode	*ip = XFS_I(file_inode(filp));
> +	struct fs_write_stream_set set;
> +
> +	if (!(filp->f_mode & FMODE_WRITE))
> +		return -EBADF;
> +	if (copy_from_user(&set, arg, sizeof(set)))
> +		return -EFAULT;
> +	if (set.flags & ~FS_WRITE_STREAM_SET_CLEAR)
> +		return -EINVAL;
> +
> +	/* Regular files only. */
> +	if (!S_ISREG(VFS_I(ip)->i_mode))
> +		return -EINVAL;
> +
> +	if (!inode_owner_or_capable(file_mnt_idmap(filp), VFS_I(ip)))
> +		return -EPERM;
> +
> +	if (set.flags & FS_WRITE_STREAM_SET_CLEAR) {
> +		if (set.stream_fd != -1)
> +			return -EINVAL;
> +		xfs_inode_clear_write_stream(ip);
> +		return 0;
> +	}
> +	return xfs_inode_set_write_stream(ip, set.stream_fd);
> +}
> +
>  /*
>   * These long-unused ioctls were removed from the official ioctl API in 5.17,
>   * but retain these definitions so that we can log warnings about them.
> @@ -1575,6 +1647,13 @@ xfs_file_ioctl(
>  	case XFS_IOC_VERIFY_MEDIA:
>  		return xfs_ioc_verify_media(filp, arg);
>  
> +	case FS_IOC_WRITE_STREAM_GET_MAX:
> +		return xfs_ioc_write_stream_get_max(filp, arg);
> +	case FS_IOC_WRITE_STREAM_ALLOC:
> +		return xfs_ioc_write_stream_alloc(filp);
> +	case FS_IOC_WRITE_STREAM_SET:
> +		return xfs_ioc_write_stream_set(filp, (void __user *)arg);
> +
>  	default:
>  		return -ENOTTY;
>  	}
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 5a06132aa384..a541e97b580f 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -608,6 +608,11 @@ xfs_setup_devices(
>  	if (error)
>  		return error;
>  
> +	error = xfs_buftarg_init_streams(mp->m_ddev_targp,
> +			mp->m_sb.sb_agcount);
> +	if (error)
> +		return error;
> +
>  	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp) {
>  		unsigned int	log_sector_size = BBSIZE;
>  

