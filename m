Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91724283FDC
	for <linux-xfs@vger.kernel.org>; Wed, 27 May 2026 22:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779921196; cv=fail; b=o+zKXZwU8JFGTIaHan2a3kwdEGPp33L1sqxF5bdo2BLNiBcZGR+Iq3QyUF2T49L4VlWAUzIFtoR7wA7L7NJ3D8fpsuKL9P7+fowefH6L3iPkrcvg24nVy6FNtDxVXLRd3GTZ8Kx3qGeSvan/VsNutkEiodOsEnsPfZXm0OORpjo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779921196; c=relaxed/simple;
	bh=Y4fa26WSLqUsS66FDGfXlxiM39wlDVIBhWVjQx+kzWo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Cyir4EXlj+P+sVGdAx1UkUm9PNrG9kpXikGWTh6KdkW7UwT/zBOp15kb8PUM6EZWywDNUzyvlfIs+4Ui9Zm0I/vXWg+LCO9NgPZBcBkolHCjXJlpdEvksMExz19omrgb9WO/E62Rip7JAREev4EVNare6kyBgrswXWoF8NkuVMY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ejF6vUlZ; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=G8LLW+fr; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ejF6vUlZ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="G8LLW+fr"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1779921194; x=1811457194;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Y4fa26WSLqUsS66FDGfXlxiM39wlDVIBhWVjQx+kzWo=;
  b=ejF6vUlZuXN/DznBVuFX4Avy4PcXWSk+uP5M2ELhCmhyZ09dnH6BpyCZ
   +TEF16ZDKmwGCG/x9c0pCpiCOa/cmcn2ipGPDKJd0BcrMR9zpqSRt1QeD
   s3jcigkund0y+223tCGiohPYLWqeGl7kO4Gl/yPzIsA8qAuNXJtIZNVkX
   L+MloRFmtSpywM+Xxkf+yQCUB69cO4HkinP10cOpEfw/0j225C1/72PKK
   +LJlo9jUAS/+yscGSpI9aSE6O4QVBfTgXiPlTVFS04bRa1W4HvFJRtyFo
   SANbwEbyzz/KNe7ft+ArN6eh1sYUf1GpX3kSvNP3Ie3kugHdpHf4hW2gc
   g==;
X-CSE-ConnectionGUID: ImJIpOtqScCc3cf7mn5TZw==
X-CSE-MsgGUID: cKO1i62UQ7qnW6ulj2hdPw==
X-IronPort-AV: E=Sophos;i="6.24,172,1774281600"; 
   d="scan'208";a="148753789"
Received: from mail-eastusazon11012024.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.24])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 May 2026 06:33:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QZtL0qqrWWLJzF6QAXeRX3fNJCmjKkjnbYBoTUwU2MS+VmJDS85ceO4HqmXroinNcmz46cESp+LwIZZNSM2f7RGzUVztQ4w+kUMTComvvyDqoqoU7EZQsLraXmY8RTVxUHqYzl6Jfu8dcMh6zbt+sGjAd7haK7VVbjGXo+0uyy9jGAqm2A8XnyUj34daC/FXDT+6fU+o/VT9eWaTWYuzVcU6CR7McxONT+o4Xlvt5oBnIGW7MnH55ShqACdvaibuoltLn9Koght4NUqRtwmmJgQhnY/RYgGzN08p0iSnBI8MgaQ6HB+wfBOBezWIj7ER56Xmqbv+AXIkjajBj6P06Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y4fa26WSLqUsS66FDGfXlxiM39wlDVIBhWVjQx+kzWo=;
 b=Jx4cTP6t7kfLvpFjJ9Xt4ciiMCUwRjK7FlGR5vk90NTnFckTKLXAtL3/n93soxwlMpGoE/GP3pe6nZe5TiWOP0j3V/C50u+ygyi1SWT0OF93ekF3kDHOxXXswxvhPOvM26lnLVcJ3TW4qs7BnlgrMgKe0bx42XaH9PCbHcS7asqIRQuxT8JrpHsQG6Ok3BtItgG6LK3hw2lp77+qLy4jqH6pJzvFXXemEZmf9MapjskWraSqIj4jCrOecjgPH29+tyqrYbyRcCHwbf7bllbkmykNQh8Wm3lrhKxhWFMmUWTm4GnFw7x7qrYfhownPUngxCEJcT2dqN2oHVmuyVbCRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y4fa26WSLqUsS66FDGfXlxiM39wlDVIBhWVjQx+kzWo=;
 b=G8LLW+frmtTkbe41iwjHJaldOQx+Da+DuNp+OcMx0XESxIotNn3WSQtBUUMat54yPnWwG9JGlmXK+VLEziRdhZqP5StIuApbREw1ONUty+r9GnJXE/t6jQdMXX/Hr39mSvc0+coeBt3trrfx+6EN4F3clSgFmr6DMHUVDQVj1jM=
Received: from IA3PR04MB9680.namprd04.prod.outlook.com (2603:10b6:208:510::12)
 by LV8PR04MB9176.namprd04.prod.outlook.com (2603:10b6:408:269::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.13; Wed, 27 May
 2026 22:33:04 +0000
Received: from IA3PR04MB9680.namprd04.prod.outlook.com
 ([fe80::380:1453:ea86:e64f]) by IA3PR04MB9680.namprd04.prod.outlook.com
 ([fe80::380:1453:ea86:e64f%7]) with mapi id 15.21.0071.011; Wed, 27 May 2026
 22:33:04 +0000
From: Wilfred Mallawa <wilfred.mallawa@wdc.com>
To: "hch@lst.de" <hch@lst.de>, "cem@kernel.org" <cem@kernel.org>
CC: "dlemoal@kernel.org" <dlemoal@kernel.org>, Hans Holmberg
	<Hans.Holmberg@wdc.com>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/3] xfs: drop the RTG reference later in
 xfs_ioc_rtgroup_geometry
Thread-Topic: [PATCH 1/3] xfs: drop the RTG reference later in
 xfs_ioc_rtgroup_geometry
Thread-Index: AQHc7dXr0mI8inM6iUiOtOuPW9w+arYideOA
Date: Wed, 27 May 2026 22:33:04 +0000
Message-ID: <500f50f4eca284249205ec4a6e6fa94c995f3bdf.camel@wdc.com>
References: <20260527123941.2319377-1-hch@lst.de>
	 <20260527123941.2319377-2-hch@lst.de>
In-Reply-To: <20260527123941.2319377-2-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA3PR04MB9680:EE_|LV8PR04MB9176:EE_
x-ms-office365-filtering-correlation-id: 93d27afa-5f79-4adf-6963-08debc3feaf2
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|19092799006|38070700021|11063799006|4143699003|56012099006|22082099003|18002099003;
x-microsoft-antispam-message-info:
 LMQKBdvRoAn0tTvHgXrFcUau4LJnpy3P+c9kLULmGlxSJalM7+dQyLJgZOzPjeuowlLdQp5EEN8eL3CLA9zFPYZKLPeKbZ6XFPkO2u/SsgrNkO1NmjWVTT9BlyQw39TGLyxP9oZtq7youyeFySJkTsFPTYCTGrG4xC9KlCK0u6+UCXpkql9KsZCxJWfje/y2otY+Nq14AAW/L0F0zyOWY/QP+Zw9PCSDeTnLO7qSO70pY2z+sr/6Er4cHRtP0yBgHDu+aMaHm0SnhKettK1T8wbkhCkwK6QaTWGlqOmOJLXz8jZqAB8Xi6PLqBB0R8YWaKnigr2y2HKrTqSloW+7bGbbWm6a6KbTBeyMWmmUPWU7QVsvjAmQc+ilFNrBSyMTIciBeWDx8ifcdXC9rouusLdiDH8Vcm1UYWxYBuSRiJeVEG0+a4/QnO/G8BPUC2x7rQGHk7J9gY289iSFUWcEKZrzQBdf1nBZEqW5KDDr237wLgkQOS/Pek8PBXY77X2Xn6OwkPhzB22cLW2dzuwn0li3UWszIyZAyFK+uzPhoE4DEZ9YSM6lCT0p1zMn+r/3C/GBSSbqX4o7LIifBag/VArJ9hkEs61HOG60LgyyUkzpr/tAGy97Ys8ghiZlEhIxdAAbY6tRYhYagga1ha1FHORN5p1YnbLbA1umnTRSblL9/S+YyLXHLoD5uYjCy5JpK4NJGzD7UPuWkzvRrst4IdgWe7xzcR1jMHvyzJiVBH/k93wISfoMVOva85+fFgU3
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR04MB9680.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(19092799006)(38070700021)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dnZhQ1ZSWG9nOEtNaDRKeXdUMDErRDFkcVV2ZVkxMzhzQTZ4TFN5dXczTmpK?=
 =?utf-8?B?SXVMdFdlTDBkSFFTR05pS0JKVnQ1VnRzcVIrNlh3SXpCQlBmZGNUVnRqTkNR?=
 =?utf-8?B?TDdKRXZMbk1XbTFqMUYzSGorcFoyRzdIdzk1d29lOURRQlZYVHpDMFdlOXZo?=
 =?utf-8?B?ZWRJVTBTSFd2ZS9QcWE4WGlpYzI4N1JMSUNOajVZcGFKa2FwTFhHcGlEb0ZW?=
 =?utf-8?B?Z0hVT2xuL3ZJTlFjZjF1WE1mTHRvQm5OVmZqRVAzZjZkakhvM0FvMWZhVVha?=
 =?utf-8?B?cXpjU0d3NFNMSld1QTIySlB2VE1ULzZYc3RHYzUzeXkxdEpwdzRQTk16bjNI?=
 =?utf-8?B?OW1LR2ZaZi9QaS90c054eFFQd2dwNDk4Rng5NTQzSi9nMlBpV1AvYmV0NGU0?=
 =?utf-8?B?TzlYTmtyOXhCdytuUms1VzluUUs3djl2MXNKcmFFc3ROVExpRG8vVjcyZTRR?=
 =?utf-8?B?YmVOL1BvQWcxRVNRSmlzbDdjaG9jTG9scFZjV0Fxdk9abGtKeXpkRWhuSktr?=
 =?utf-8?B?eDZKejlsaXA4SFBFTXFiRTg2dzY2STR1L2hQbldmQVllVFN2ZUZlSFpoNEpU?=
 =?utf-8?B?L0lBbG9TR0YrcHA3aU8yc1ZxdWtnV3FsQlBaZWlhbVo1dkpkMU9xR0EyRS85?=
 =?utf-8?B?Rzc0elpmK1NTNDI5WkV1N2I5eVMvOFhMQ29PVk5ZODBIaWxWVTNKcFpvS3Vo?=
 =?utf-8?B?MXRPaEF1M3FLZ0JDSnZlZjJyR1NIOUViUUFReldDcGtxSHA4c0gwamtCc3Jy?=
 =?utf-8?B?QW0wNlA4aS93WEdBbllVdG1EYldwTldwbCtsWnYzNzFnRS8wYmxSZDNzZHJS?=
 =?utf-8?B?Z1RxdzNjYmVCa3pEdUlET0JpMWVzVkhJNUV1d3JuNSt1MCs2TFYzaGRGSEpQ?=
 =?utf-8?B?NjJhT1NKcDhCdDF5YmpIbk5GZXhKUlNXSXh3TWExWnQrU1ZHVWxQQ1dqcHNC?=
 =?utf-8?B?S3hFQlZMUzVqME1WMGdtUkJGUFJPTmJQdWNvL0Z0MU14elJwV3lEK2ZNWUNR?=
 =?utf-8?B?YW1YRHQzZHBFbFZYUXJhY29XZHF3L1FJblFNd1M3cUN2Rnk2THZrSGR4Mmkz?=
 =?utf-8?B?L0FuYlBQYWRFSm54WFEwYTkzMG9rTTl2Ukg1YkZNTVdaL0tVcDFJdTZhK2pX?=
 =?utf-8?B?K0JLbFlGMGY0S0E0ajlhdGxKNjlzZGVDYnNVVFV5Kzg4cUVvOFpiejhkY2FD?=
 =?utf-8?B?RVNMQXlFYjRXUUpuZ3FQTEpwU2dFc3IyUXhId29UcXFGZHJDenpPaHFmOGln?=
 =?utf-8?B?ZTAyUjFkSytiRkJKMy84QXhjMURaWFNQbzY4Tjk2SVJTWWFoN2dDVlpxVEZK?=
 =?utf-8?B?Tzh3UWRoS0lLZFpMRmFmMEVqQ2p1dk9qMmJkblF4Qis4MEJzMnlrbGhoVlhv?=
 =?utf-8?B?OXlNWU90OUNEdm9qTzBpdld5aU13QUNBZ2JnaDc4eFVrMTFWb0ZSRUtLd0ty?=
 =?utf-8?B?aG1zTGZFTlh3WVZERmMzMmN4dUhWekIyVGN0dExHUFJsejJTVnJ0OU83Nnhq?=
 =?utf-8?B?QWJiMzhOcld4NTdaK0x0SHRnSVI2ZnpvRGVSYURybjZxSDJJaktaVkowRmpG?=
 =?utf-8?B?UE45L2J4UDB1clo5cUlLQkVobjN5Q0ppenJab3Q5RTA0V0o5YjBVZnFFRjI3?=
 =?utf-8?B?TlJsUmd0aEtjclQ0L2ZUdnRRV2FkVWxoNFVMR25OdkJsOU1hRllSTUh4c2pr?=
 =?utf-8?B?U3FIYjhobzA3RE9wcUZ5QUpNandTWnEzNVFqM0RSNEFXeTdsRWwvSDNXNlpi?=
 =?utf-8?B?c1BHbUJja2ZqQnZYN3BFN1FsQVVQVVlKcng0QjdhSkpHZ2NOYnhsVHk2U0R0?=
 =?utf-8?B?QThxeVpxMU9SbjZ0RnBQa0ZkNWtPNVUwYjFHbUhSd3FPTm9YcnBEeGNzM042?=
 =?utf-8?B?TUcySzdVK2dBZU9hWTBCR2FkOW10c2lTdnFEdkRSZnZIVVdqNmJvUVFobjNX?=
 =?utf-8?B?R1NJb1BWQmIzQnBOSGlhR3RzVmNKeHVwbi96WFdETjFHcUpsNGtzRDB5K1RC?=
 =?utf-8?B?MHYxM0Iyd05tUDRCc2tOSlU1YTM2UXRoTVdSb2FjUjkrZ2swMWFCODJjVG5v?=
 =?utf-8?B?N29aSERLOXJxN3EySHpibHQxcVA5WVljN3BzVWZ0eG10UGRCRzB4WXYzMTFu?=
 =?utf-8?B?WU1sNHhMSFlMRjEwWnhBNXNzM042K2krRFJnQmUrek14NlppSGJKWjVSOTk3?=
 =?utf-8?B?NXZOcVV1SEtmUlY5SERLMG41a3JOcGsva1pLOXFHL0FmWXl0RUdJQVJDU204?=
 =?utf-8?B?WGhRK1V0Vk9YWkhlSGYyaXFMS1kraGNqT1lPdURwbnpMY2FzbjNCMk5vS2NN?=
 =?utf-8?B?TkV1Q0tycW5nSGkzNGtVRkFyV2k3RDRXRmZQcTZPUXV6Nkg2NG9CbDZpRlIz?=
 =?utf-8?Q?PE/Zau765qMbViJ4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6DAD75930BD68F41AE0C1129B1A1EB7D@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	bsJ1/Y9XZp7C6aDFpw9H/2FqgVY0BerE54g1QDbLWNqtCcUP2Fam97W2B//0Xass95Fq+nip0dljroKfPGl8aRpK1FC1YqxRwv2KUcNZOLZk0gJ7qrDtQ6wpxePco2R8Aqg3HtKUqfjYQBtY2vMVwpdnHn6vc6ZuUUAm1udQ+gHVfLJWRaEtzH7MkFrpKOS/0U8/t7gbPgoVX20bZH9F3yDW+SykOBSwa3ax4SMjGQi1Tjn7f7WElv24FRImFoQLuolDuc35kb4hvzznNhx5eTKFZHP2cV3MffFD4l4yo3nvgZMpMPhGaB/7/GPr/MeRbpsWDV/JrxOIplR4HxCPvg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	l+JRSiu2Ln2RgOY2HKiunpAw5xw/Lzj3nr7vD325EE8m0fErOaGG2TxzgT8Lmad/JhaDcqRvN/dAnPbI02jkwUWpo4aFo6eMz1Xu251LFc1ItLIvG7vEoFcun4udxlT4OC7eTibKb+sm8PenDtyQkGPUhdoyi/VRZ2TN2VzLiBH5QxLkFMbyvalPLDY46rECI+pVDpbcvTBQkTZ8A+nztRkdV9aYMRMGOnqvXUvu3FwJ4d0QVuYtDT6YKWxs82f4oRzaWGLcrCrkHBSyTFbCFSbtQMxSRNkQ4xP6Yk6hONKNF9YtnRGJGJpIy2evbAwfKU/vlc+ps8iSnwamxkSh1JoVEMXSQ1F/e1Xw7XDldZcmJZ80QhhCUWZqRFMhe5XzNmcdkOOWe9g+Eo8aKw4FP/Q/9EXvEClIF6jMhLydg6GLkeqcevJP9ZvQfF/c8gnT8iAV/Txvp1gpN6ltoM7YyWuYa7nn8A4hYBgPNSIoGVoELWpL1V3oo7VYRQRm5K5OzflvZV77JMBEBfd3KAjQGP8wsl/6wH4lUVPyaOBe3gLoefN2ysaWCignYa69VAp49VIalNzyd6Lbk5Jh797uEys4OcD1ktjoyrqtO8imeBGR128KuTRA4+jUWEEuBRQy
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA3PR04MB9680.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93d27afa-5f79-4adf-6963-08debc3feaf2
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2026 22:33:04.3660
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KUU4sEtG0FCZMA+R9KCDzJ/cqUN7B93pUPL1gmjOZTqaRXG/oZmnlrtOrtMoBxOVjBwpPg0MOn04pDeubKngaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR04MB9176

T24gV2VkLCAyMDI2LTA1LTI3IGF0IDE0OjM5ICswMjAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToNCj4gS2VlcCB0aGUgcnRncm91cCByZWZlcmVuY2UgdW50aWwgYWZ0ZXIgcmVwb3J0aW5nIHRo
ZSB3cml0ZSBwb2ludGVyLA0KPiBhcw0KPiB0aGF0IHVzZXMgaXQuwqAgUmlnaHQgbm93IHRoaXMg
aXMgbm90IGEgbWFqb3IgaXNzdWUgYXMgd2UgZG9uJ3QNCj4gc3VwcG9ydA0KPiBzaHJpbmtpbmcg
ZmlsZSBzeXN0ZW1zIGluIGEgd2F5IHRoYXQgbWFrZXMgUlRHcyBnbyBhd2F5LCBidXQgbGV0J3MN
Cj4gc3RpY2sNCj4gdG8gdGhlIHByb3BlciByZWZlcmVuY2UgY291bnRpbmcgdG8gcHJlcGFyZSBm
b3IgdGhhdC4NCj4gDQo+IEZpeGVzOiBjNmNlNjVjYjE3YWEgKCJ4ZnM6IGFkZCB3cml0ZSBwb2lu
dGVyIHRvDQo+IHhmc19ydGdyb3VwX2dlb21ldHJ5IikNCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0
b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQo+IC0tLQ0KPiANCg0KUmV2aWV3ZWQtYnk6IFdpbGZy
ZWQgTWFsbGF3YSA8d2lsZnJlZC5tYWxsYXdhQHdkYy5jb20+DQoNCkNoZWVycywNCldpbGZyZWQN
Cg==
