Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5342BCF6C;
	Mon, 24 Nov 2025 17:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764005477; cv=fail; b=Cfn2YvSubohpS7hWGlsUHNYzAUhBHhIKT/aFXM1a6umvYNcWHyAj/LqAJiL96W97aR0zTiHhmp5r+aIGpqa0hCF6urQ9+uc/v3Y8EK6Xjd/4iu+EsNjtM6ov4hp+L7Gbp30fdr+91OrtP9KhD4g0fABpb8zZBjLp8gzwfyS5yWg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764005477; c=relaxed/simple;
	bh=Vh3ysQRtJbDCfO2zk612gFN15q922Ah1cpGS0FVoi5s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=A7zPf3E0voasZowRCtf198Bx0Qe0y7ZBoeDiKWXFn0x62TaQ4PHEbejkJka1PB1/QhBLZNfJdL5ei/9U4njkm874wKSK8HSk2fugDrjbnviglHsKTXBdSfDtfHMInLD8sH+a+jcet0ZW2VchMytjlfpFUUpmHvIM9jfZu6x9QRw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=gKjMytQC; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=PGlRCfHe; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gKjMytQC";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="PGlRCfHe"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1764005473; x=1795541473;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Vh3ysQRtJbDCfO2zk612gFN15q922Ah1cpGS0FVoi5s=;
  b=gKjMytQCyDsPy1OQUbPFoC1JMaqIO6cIvDC3QvQPFxkY3le6XkPCzJ37
   gimrUCD0ag+w6AP3tYLnFJIKzDL+BnQn/fO/tUwuwDfJF6hMjFZpERejW
   AJrlJAfflu6j+JfB1i3lelTiVOx5gQoVWg0jxUTt7woJ8LKxq4BUiXTEt
   XttAhySmmYW93x+As2hSP9RWh3/S/5G1RkKB92O0hjuhh53Eh3acNsiik
   NLuMnyt6mVb1pCvsEvzSvXxuxs9zZ9IwPdcimF7J9Zru7IEUNYA06GuBM
   FxVjI9XWJunfbWCohRR/TGjHAsOS4zKul70nWDEjaVHoy7upqF1ehton8
   Q==;
X-CSE-ConnectionGUID: Val21TLGT1aAgxhGfjickg==
X-CSE-MsgGUID: hh7CzlPZQpG5E7PwCB9dug==
X-IronPort-AV: E=Sophos;i="6.20,223,1758556800"; 
   d="scan'208";a="135705760"
Received: from mail-westus3azon11012031.outbound.protection.outlook.com (HELO PH8PR06CU001.outbound.protection.outlook.com) ([40.107.209.31])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2025 01:31:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JsitXs3AQvYQCV9EGV+/rXEWFw9R/BHq37WtKzHSC6CQoRfjFTs0Ay6C9UK5IELHtEayxJgZ469LYHuLePHRF81t5wSdkidSbd0XoU8Ws+HJ7fuNzu4I4k7wOWx1ehm70UwdB/bn87yR6jv7F8NATx2TraY/J/XFN2U/ns5Hjrd0Y9SmQkg1j6kNpc+0z4sCd3W/aGh6XXouPpECkUgw6APk6c5SE9aglSmQpFV2SVbbiuH1sv2IvYcHbQqgxDwJ7nK2payQtfh5PSV/6NL4tDYqwLmaBYIhwxsoer26g/2VHhkc6LCQgqGDysOcat2lb6hBS3TzKv8KJrmQL586jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vh3ysQRtJbDCfO2zk612gFN15q922Ah1cpGS0FVoi5s=;
 b=f4kGJl5wridvSm/nH0QkK2bIuGzC99uhlssxl7NdMsmwLl9y5HfIsaUiODPrJrDZrXOp8UHEF10oo0Dc6JBfS16oUghzex14dUq5DZ3VpUtOG/z7q5EBtv+xSMl7NzFN7hE1aF/ISJFWJAx5CgccYW1jv5feMZ56dLfyu6d3dSmyPfCp1yCGBimix7XCl6F2b7KkZBhgXzu4nlZhhVz/kr0nU1APL6XpvkYrSoFYZvpMzC9itu0bOuiz7GGY3NVI8YC7r79XiaSrQ4RqLcQ4lDLh4cg2hHxmhG0byJkaOQPHGVsQ7N/HFUFWBibj5kB0omuk8PeFAZRG0R0cpktwsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vh3ysQRtJbDCfO2zk612gFN15q922Ah1cpGS0FVoi5s=;
 b=PGlRCfHerti7HF95o9qKi1p+HRBiydH0IiHujdnI5c+Z4Ylqgs/MCxeP5Ei5ouWvSgpfA0fneE18OzjPTtn+55SIVJB85ieFLfa3ro+YmgfAbG84IRLwGhDGoCFWsiPc8JYu/w8jgI0+DnOkCpgZelR9PXU71cFQSz069b25qIE=
Received: from SA0PR04MB7418.namprd04.prod.outlook.com (2603:10b6:806:e7::18)
 by PH8PR04MB8590.namprd04.prod.outlook.com (2603:10b6:510:259::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 24 Nov
 2025 17:31:05 +0000
Received: from SA0PR04MB7418.namprd04.prod.outlook.com
 ([fe80::17f4:5aba:f655:afe9]) by SA0PR04MB7418.namprd04.prod.outlook.com
 ([fe80::17f4:5aba:f655:afe9%3]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 17:31:03 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Carlos Maiolino <cem@kernel.org>
CC: "zlang@kernel.org" <zlang@kernel.org>, hch <hch@lst.de>, Hans Holmberg
	<Hans.Holmberg@wdc.com>, "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: Add test for mkfs with smaller zone capacity
Thread-Topic: [PATCH 2/2] xfs: Add test for mkfs with smaller zone capacity
Thread-Index: AQHcWjgQoqh4EHp59kCIrlcKzfAjxrT8shiAgAVHHICAACKSgA==
Date: Mon, 24 Nov 2025 17:31:03 +0000
Message-ID: <becfce20-3948-40db-bdb5-7dc64438da26@wdc.com>
References: <20251120160901.63810-1-cem@kernel.org>
 <20251120160901.63810-3-cem@kernel.org>
 <EffPQB_WQabsgl7V1GQULuAp9QQGB7KoH0wN5tHOvQUWRriHZorc1NPnsGnKEV1obcisN1kjuXM0KzubUhxk5Q==@protonmail.internalid>
 <9f6b4f20-9d71-49a5-a313-f860b3e8a4e3@wdc.com>
 <ba3tbnjq2dernii2n6leyc6z76lcezsjemomtm54mrbm2xcnz5@kx3qp3qgrtqe>
In-Reply-To: <ba3tbnjq2dernii2n6leyc6z76lcezsjemomtm54mrbm2xcnz5@kx3qp3qgrtqe>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA0PR04MB7418:EE_|PH8PR04MB8590:EE_
x-ms-office365-filtering-correlation-id: a432606c-b85e-4d18-840e-08de2b7f3e13
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|10070799003|366016|19092799006|38070700021|7053199007;
x-microsoft-antispam-message-info:
 =?utf-8?B?bDNWdWIzbzNRVlZTU3Nwckd1VTlYcWYwcWw3UGhpbnBRNmg4VXlVUjNrak5M?=
 =?utf-8?B?c2IweWhGVWNqam1OYUs3bUU0MXpTUmN0QzVacWptcXRIV0Z6VEJURnRGNFQr?=
 =?utf-8?B?a05zc1lMclRTSFlRNXBtR2VZTTZYNGtKcmVRY0dTa1hmMUowOFVQcjdEd0xw?=
 =?utf-8?B?dm1iZ25BZVVNNnRKQWFBRmFEd0FDWDBmOHRTSTZOMVlYd2VQZTVmcU5ETUk0?=
 =?utf-8?B?V0t6Y25oUy83a2JrVVZab1Z4VWh3UWliUXIzT1pKZllFeHlxMHdCNHE0ODY3?=
 =?utf-8?B?Z0hjZlVxcVBwcFdCT3Vmd1FBR3RRQjQ0RVBFUXl5OVVSdEtiQ0Y1ZlplWEJa?=
 =?utf-8?B?Zkhka3NDQmE2TkZ4WnU3azMvdDd0RVhNZWd5Nm5GZUMyTjkrK3VKMytZQlFC?=
 =?utf-8?B?ZEdOOStTK1d0NzhPaFIxQ1p2ZHVIQjliaFZPOWp1aHV2VVdTbUkrYktwNGdU?=
 =?utf-8?B?Y1hZMUpFL01aS1NqOVdCWS82aDgrMktKZzg0OW9haFdjS0hHTTVSTmNtanBy?=
 =?utf-8?B?NUJwdFpPMzFnUmFMaUlzRG40SlhLeW95UGJBazFOTlNKSDBvWklneG1zeTgz?=
 =?utf-8?B?RmpzdW5tZ3NReldLYU4zRDZ2SVhlNFUyR1VMT3J3aVVOMXZvRWM4TDBiWWJK?=
 =?utf-8?B?VVc4OWRMYmZaTmduZXYydUkwL2FRUHdPQ0o0ekZ1aC9QNkJWLy9qcHczT1Yy?=
 =?utf-8?B?L3lKZWRyR3ByWWRxb2dUTCtIeFNKK3lVY3JCWDFWcTBZSkxreGZjSEp1NnVq?=
 =?utf-8?B?RFZrZmlVZE1xcDJoL09FeGJLanlnZ0pUamwrd09Qa0NFQkNVbjUydVpDSStj?=
 =?utf-8?B?ZXBsbTRQb20xeERUc3dpOTljMGpFTnJZRjJNcXE4WFBoMXVEZndrUkZpRTdQ?=
 =?utf-8?B?dCtHMzR6M3Y4ZTh6N2Qvb3V4ZlJXdFpmNUFuTmxyN01YNGZ6UTJTbjJseHp3?=
 =?utf-8?B?MzRCRFdJc29mK2ZLUWhEV2FGMzNFQWJFVFNKdXByeXZPZ1VkMzcvazlBaFpo?=
 =?utf-8?B?aEd0UGJxM29oZnk2ODdZOHJ2em5NcmtPaHBGaXZrdW15RjVmbjJHTTNEUnRo?=
 =?utf-8?B?SzBZK2o0ZnNUOFA5c1M0cFhlN2NUb2NxbkNndWZQOGh3d1dRUlRwdTA0b1NH?=
 =?utf-8?B?QXBUVlh0NkdQQm50cWJkL0c5Z3F5Ui9tQVpBc2dTeDBlQkEvZ1g4RXhCWmdE?=
 =?utf-8?B?bitva043QlJUZk8yREd4dlRXVXVNNVUzRzJqWWFmbjVXTURCb3hiUFp0bS9m?=
 =?utf-8?B?TFpITlJxTWpvb2dhWjhWbERkRDdSbExSeGt3dStVS1FBQXNSRlFUbVA4WG5v?=
 =?utf-8?B?RFBPY0lEN2RwZkF3WDJQNTNlWnQ2OTZnM0tPTW1QN21HeGh3eEJNQU1xYjg1?=
 =?utf-8?B?ditPRUJYcC9kN2NzWFBPbW5TcG5iQUFxemF3TTc3RjU3Y2pGK3BaZlBLZGRS?=
 =?utf-8?B?Z0lsajg4biszM2dEekV4d0k1a0IxWnQ2c2lWWG1oSzh1Z292cGZZdG5RYUJP?=
 =?utf-8?B?RmRoMlgzZnhnSGw2Z2h5eDdNa0JLR2gxREU4eFN5OTVCT09OUFFIQk93a1dn?=
 =?utf-8?B?d1dxSUlhVmtxcnl4OUVONXE1TzJvTTJlVHk0YUNKSDRRTFAycHFCSkxiYXZz?=
 =?utf-8?B?NkU0M3h4dXgxSWRSK1BkS3RhZUxHTFlnL2FFazRBY2EzR0dpck04OWpSUjFi?=
 =?utf-8?B?SWZUNzNGcXZJVnBRQUo0SEpQT2FHVlFWQlF3VmVzb2lldnR6Qi8yL28xWU5p?=
 =?utf-8?B?b2N0NVBHWWZRU0J2YjVGU1ExMUFRYUNhM0xHQjVBc2VNZzBiSk93dWZlZ3Iv?=
 =?utf-8?B?MDVYRk1EUWlFNk5IdWRIdlBkR1cyZ1FnMWFPb3pxZFZ5Nms4L0NIVDVCUk1K?=
 =?utf-8?B?SWU0eUJTTVE4M1ZtbjczMHBiYVRNSVBWbmNWY2tncml6TEZjNi9UbkJQK0px?=
 =?utf-8?B?dTEvVUtEaTlDSVJqaDBxSlpBWitHbXN4aFJjQm5UZDVwdncwbGVXSmFvRmQ3?=
 =?utf-8?B?dWpnMHJMOHRPaVpFRU9LcDhhbXhUclRoTXFuY2tGUjkrTkpMMm52QTVOM05N?=
 =?utf-8?Q?cMpEAa?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR04MB7418.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(10070799003)(366016)(19092799006)(38070700021)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SEdaeFI4RzUyM25sQ2pLZldSQytPZ1BBdExNdlZsKzhmUW9vT2pWbkhSbGJZ?=
 =?utf-8?B?RS84K3F3b2tNdENwcTdNMm9TNVMwZ29EUWRoR3NBak5uY0pTaU4yelJsZmhJ?=
 =?utf-8?B?L1dXUHFyc3o0ZVdFRkovbGtlalNwRmdtOXRqdVhrZzJZNjRDTWk3SC9aTEZS?=
 =?utf-8?B?aUxpMW9yUFhIK1g5bDZQb3BJTXlrcnFSbmpEd2p4WGJmRlBqOG5ucDFodG9m?=
 =?utf-8?B?UHBrSVZqdFlaV2R5c01wOXNtVlZ1KzJJS044QjhvM0JnODJmMFU4OWNsM3RO?=
 =?utf-8?B?SjJ6U0ZCRExqMDF3VEJ4RjRITFdjZEVWb1B4cEdHRzFKaDdBZllPa3gya1hi?=
 =?utf-8?B?K1NjWnpwYTIyWXMxd0FDNEk4YzNVV29VVG55NkVURWNVbGpLOXNTeUl1UEwz?=
 =?utf-8?B?QTFnRGRYRVltTlQ0WWFEQ29kQ1BtS0dpdFpOenpKS0w5d1cwN1ZlSzc3ella?=
 =?utf-8?B?RGV6TXJ5VThBK2ZWUmE3U2phNVQ5OWVQRzhPQTNldU1XUytKRU54cDk5VkZq?=
 =?utf-8?B?U3JuSWc4emRDSzVxM2RkWTNvMmRpTjdhM2ppSU00aE5uNEh6Z0YwSUNWZlE3?=
 =?utf-8?B?MmxwSlU2elNuSHZUckl0OVVxQXFhUnlSb05VOXF1Tno5bzJla0p6aDBNd0xQ?=
 =?utf-8?B?ek5CUzBvMFYxenBtVmVvSy9iOU1WQjV2UFh6VzVJMkttT3pJT3hseFdaWDcw?=
 =?utf-8?B?T29zY0VQQjZZWHpISExBcm85WE5mYktVTXZRZmc3UVpaYVMvQ3hXS2poWFB6?=
 =?utf-8?B?VEc3L0ZRZEpZbS80cUpFNUxPc05uRGVxNmtUNnRHNjFkekluNzJsY1NCd21V?=
 =?utf-8?B?MDN6Qkl3MWJNNG02MDNsYXZhcjYvR0V3aFBPY0hBbllNakFmbDduTjFpbm0v?=
 =?utf-8?B?ZTNDazU2SFdZVnhWVTlRc3ZieGRvN01yaDBHRkdBTEszTEVsWVNTbW1qSjR1?=
 =?utf-8?B?WmxTM3pYUm55WHl0Nmx2bERNK1ZOcVVXV0twU29aK0NadjJpYmU2REM2QUxG?=
 =?utf-8?B?aE9pUzNRc1pvQnc1aUJZQ3VpY3pMT3VLUy9wbXlselp4WmRmc045R2UzYzJl?=
 =?utf-8?B?TVNjdTFOMHY4Zzh3WFphNGJuWlR5b0N1ZzNTVWRGYmNCeTNVUWg3VkU2MWZq?=
 =?utf-8?B?WnA2anZiemVoT3QwbTc2T1VTcyt0RU5hNy9OTXF5dmNpVmNXMmcrVEpMVitV?=
 =?utf-8?B?RUJIdEU1dkNsM205RWY3SjVPdCtIMW1NRHE2UGVNN2FvRmZyZmJqcU1RZ3pn?=
 =?utf-8?B?aFFYZW4zZkN1TlMxTjhicGtaS3RISHExWnBXVmJmT3Rlc1pwcjd4T2ZaWEJG?=
 =?utf-8?B?STFmZEduZ3ZRK0VoY1RWTnJkM1NxaHJzc0NJT3VFQi9OOS9lUTQzVVpyTVI0?=
 =?utf-8?B?VzRnYWlwNE13WGJRQWorWG9HRTFkNnZlNmltMk9BTmVRczFIak5mZC9LZU11?=
 =?utf-8?B?Z01oQnljQWU0V3JXdjZtNHhteE1jM09SR09IdVpFd1JrZkFiamExTThVZ2p2?=
 =?utf-8?B?Yk1WWis4RnNuOWcxTHJJdnNQY2NaSU1mU3BpU3MrRmJzZVhpbVMyOStaTUlk?=
 =?utf-8?B?cU1rMWs4ZVFiSjVtZjN6dkVDcHRibHZQMzBzOHpNN3Y4aWZHcmVScWFHUHlm?=
 =?utf-8?B?Q0xhd2x0OE9TODBSWFBpdkNpcU5KOFg3YkYrU0hKelc2WVJMbU9ldnJiL3kw?=
 =?utf-8?B?a3NJRGFIOWhZc25sWWtuVHB0bWE4UCtOWUlqc055eUw0Ry9wQURETlYwNk5C?=
 =?utf-8?B?cUVvZ3MrdDJYeEtIUGRxblZNeHYyazBZNldzZnNvNHFZWlVuSWVZOS8zNVE1?=
 =?utf-8?B?UFhrNXJHSXpWOTFhVTROVHFPdnlFMlExdmlxRXpBcGRoazB6eDdzcHJTcFZI?=
 =?utf-8?B?T0lWbnlxb2lCZ3NLZ0hsMXJoSWhGaWhFZlZZTkt1YjdZZXRMc05INmtSaVht?=
 =?utf-8?B?K3RVekoySTZSU1FydFMyRkVtNHgyZXRvMXRrZ3d3T1V5dnhiTTJya0NJc0I0?=
 =?utf-8?B?QzhpaUdBd1VUdG4rNll3eDgwbC9heFJIa1lyVmRzZHZINEkyRDZhZWJFTmdy?=
 =?utf-8?B?emhPWXVaelc4bTBRSVpQaHlKSU5kYWNvZUQ0Nlp5K2xxRU4xb1FWbUdEZDhm?=
 =?utf-8?B?N0tGZ1FLT1VPVFprc3FqbU1zS29wbkRlZGE2OXZuem53Yy8zeXVFMkoxM3lH?=
 =?utf-8?B?aHNYVEQybTl1UTF4YW5ETHZ2QTBtRGtBMHZxVTVZdjJDdlNjWjVCdkFmUWpx?=
 =?utf-8?B?d1l6aDNyVG03bzQ3NnZTMlk4UVBRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3A4C0A2F5D62DF4AA4627CBE2A92A065@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	r1CwDYpKlmPfzjDzdTxlaVx1Ck3wbKOOa2ImJFY2XY1gyCjMTzLMQh6ktW18ZzXHMKvqmQuNaMf318bfgDcDCqBm17uVyvRQdZpLmJ/AB5bNg0PtRc4DP1E9IcjuPwmJO24c2mXxuSyZ283LjMZAK5oqvpMWtuCL3jMxRf305rhXvnazcN+H6lix7W/zpzyEnZNS7wVNsiKUdRuXWmxnksIojClgziQSMPTuWolmwPTuHAaxS5fIo/7Y4rdopn5msco0P8xFLGZ4PRKPnyDwiSoyelnzpfC17coACI7byKbOyT3+26XQQJh0sF1WWma2BxMq0IAt6knyMz7dwvv04WGQZTAPqYM55JfK8BAqtXo2n8F5pUHgvLyFW+3RgGjg9aSl+ozRWc5AoLJu12NKSTAzb1bYWMig2BRLGH0tCMJ9IpD9hiom1KtRj9ojVw4+c7agYx8Li6E4ZwpQXkavSBvDazdLcZLFjPZt/b2ns/9R4kRcqOXtnvinA1zfBEvMccFX7oeOrvAGgav/6cZSRvuWGm3T8DFVqFTqif2+XjggpiKxF1Hpv7E4Hrb7PLwrtWKkz27V/xjZsaQ+I6bQUkQ5ufcsu3Z5e+5rWWcBeFTL8UcG12+GdiFh5clhHIwQ
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR04MB7418.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a432606c-b85e-4d18-840e-08de2b7f3e13
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2025 17:31:03.5295
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MxZB8rcfLt/sQGs783yl1BCNPXEmaeP+pxFmDeh1RqmTvUVb+QOfVvCu0OmA7QdDHrSLWcbsCQ4gGu15DaNzU+OBsE6aWi581szVt07Jt4o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR04MB8590

T24gMTEvMjQvMjUgNDoyNyBQTSwgQ2FybG9zIE1haW9saW5vIHdyb3RlOg0KPiBPbiBGcmksIE5v
diAyMSwgMjAyNSBhdCAwNjo1MTozMUFNICswMDAwLCBKb2hhbm5lcyBUaHVtc2hpcm4gd3JvdGU6
DQo+PiBPbiAxMS8yMC8yNSA1OjA5IFBNLCBjZW1Aa2VybmVsLm9yZyB3cm90ZToNCj4+PiBGcm9t
OiBDYXJsb3MgTWFpb2xpbm8gPGNlbUBrZXJuZWwub3JnPg0KPj4+DQo+Pj4gQWRkIGEgcmVncmVz
c2lvbiB0ZXN0IGZvciBpbml0aWFsaXppbmcgem9uZWQgYmxvY2sgZGV2aWNlcyB3aXRoDQo+Pj4g
c2VxdWVudGlhbCB6b25lcyB3aXRoIGEgY2FwYWNpdHkgc21hbGxlciB0aGFuIHRoZSBjb252ZW50
aW9uYWwNCj4+PiB6b25lcyBjYXBhY2l0eS4NCj4+DQo+PiBIaSBDYXJsb3MsDQo+Pg0KPj4gVHdv
IHF1aWNrIHF1ZXN0aW9uczoNCj4+DQo+PiAxKSBJcyB0aGVyZSBhIHNwZWNpZmljIHJlYXNvbiB0
aGlzIGlzIGEgeGZzIG9ubHkgdGVzdD8gSSB0aGluayBjaGVja2luZw0KPj4gdGhpcyBvbiBidHJm
cyBhbmQgZjJmcyB3b3VsZCBtYWtlIHNlbnNlIGFzIHdlbGwsIGxpa2Ugd2l0aCBnZW5lcmljLzc4
MS4NCj4gSSB3cm90ZSB0aGlzIG1vc3RseSBhcyBhIHJlZ3Jlc3Npb24gdGVzdCBmb3IgeGZzJ3Mg
bWtmcywgYnV0IHllYWgsIEkgZG9uJ3QNCj4gdGhpbmsgdGhlcmUgaXMgYW55IHJlYXNvbiBmb3Ig
dGhpcyB0byBiZSB4ZnMtc3BlY2lmaWMuDQo+DQo+PiAyKcKgIEkgd291bGQgYWxzbyBtb3VudCB0
aGUgRlMgYW5kIHBlcmZvcm0gc29tZSBJTyBvbiBpdC4NCj4gSSdtIG5vdCBzdXJlIGFib3V0IHRo
aXMuIERvIHlvdSBoYXZlIGFueSBwdXJwb3NlIGluIG1pbmQ/IFRoaXMgaXMNCj4gc3BlY2lmaWNh
bGx5IHRvIHRlc3QgbWtmcyBpcyBhYmxlIHRvIHByb3Blcmx5IGZvcm1hdCB0aGUgZmlsZXN5c3Rl
bSwgbm90DQo+IHRvIHRyeSB0aGUga2VybmVsIG1vZHVsZSBwZXItc2UuDQo+IE9uZSBjb3VsZCBh
cmd1ZSB0aGF0IHNvbWV0aGluZyAnY291bGQnIGdvIHdyb25nIGluIHRoZSBta2ZzIHRoYXQgbWln
aHQNCj4gYmUgZm91bmQgb3V0IG9ubHkgdmlhIHNvbWUgSU8sIGJ1dCB0aGF0IHdvdWxkIHJlcXVp
cmUgbXVjaCBtb3JlIHRoYW4NCj4ganVzdCAnc29tZSBJTycuDQoNCg0KWWVwIHRoYXQncyB3aGF0
IEkgaGFkIGluIG1pbmQuDQoNCg0KPiBJIGRvIHRoaW5rIGEgbW91bnQvdW5tb3VudCBtaWdodCBh
ZGQgc29tZSB2YWx1ZSB0byB0aGUgdGVzdCwgYnV0IEkgZmFpbA0KPiB0byBzZWUgd2h5IGlzc3Vp
bmcgYSByYW5kb20gYW1vdW50IG9mIEkvTyB3b3VsZCBwcm92ZSB0aGUgY29ycmVjdG5lc3Mgb2YN
Cj4gbWtmcyBwcm9wZXJseSBkZWFsaW5nIHdpdGggc21hbGwgY2FwYWNpdGllcy4NCg0KDQpmc3Rl
c3RzIGRvZXMgYSBmc2NrIGFmdGVyIGVhY2ggdGVzdCwgZG9lc24ndCBpdD8gU28gdGhhdCBzaG91
bGQgYmUgDQpzdWZmaWNpZW50IGFzIHdlbGwuDQoNCg==
