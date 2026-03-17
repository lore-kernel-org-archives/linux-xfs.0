Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18EC2372B2B
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 12:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773749970; cv=fail; b=O3ucSzTcMYtaf6hz76nksdc68nvXR2hVy2JKarinTq8fWlKuzoQ0C8+MUxMGnknRUSTJrNzivkTp/3t5domNUGK1xX2FlCfF8fW+OgY8A0hmOzogKbZRYrdsM9qrPQ79DZ2aH7oNisMo1/fQsrnJ0bClAVM3dpprBDIS4eXMizk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773749970; c=relaxed/simple;
	bh=1I/RQdKGk/lgATg9X89XBHda/mJcz9gE4GQrilvOo2M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lqMi9s6xocYsV+NrKUFPe8wKPzz6amI95ySJ3KMiIafCQk0zs4OqA93eKi/NWO8l1HH4yaU6UOoRyOjKWGmOvNbBUsWooWztHfoQoHBxwGKJzyfzhJcdK7ZqZ9A6D6ohvKsG59wm0R5XObmJpjY9k86kUE9ILYbaihEaUFeu8l4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=e6GtNrIN; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=EWSxFA2E; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="e6GtNrIN";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="EWSxFA2E"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1773749968; x=1805285968;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1I/RQdKGk/lgATg9X89XBHda/mJcz9gE4GQrilvOo2M=;
  b=e6GtNrINleqLtw0isU5Tr6wNYi3/zwL78Ugo6fr1D72WgLxMz7QrbCVr
   ch9VChw2SCGhQbGPVRJRrurNSiJQ0Jk06Tx6K0Q0eIL9irLaZHccIcVa/
   YpRbYzkB7zfZgsBFYdH130FjWGPAtD4/wHSZHE0T61PHdcA1eRKmRb1+E
   uYSL0bjegKw69M7xaJ+9gda8Ls1xFjjLtplvzsE5jHhCFc72c3NSMAYPj
   /VunptKAyqrw3JdWVnd+TVMFsSxbU/0/sbIvzvj5w3j9347qC/PUi8cLv
   yk5sDmLuRUkFNNO5PhyZ1HS6pA3O+0u+n8SHnJjZe7hezO2MZcoDTrZrr
   A==;
X-CSE-ConnectionGUID: CCq6dsfdRcylLy6HE1fR5A==
X-CSE-MsgGUID: DT5BEkXPQdOCBSp77OVfcA==
X-IronPort-AV: E=Sophos;i="6.23,124,1770566400"; 
   d="scan'208";a="142265989"
Received: from mail-eastusazon11011034.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([52.101.52.34])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Mar 2026 20:19:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QKwEkkKYtp77hsFCGEki7z8EcvgjREEwCg701suQ9SHC1MCxUX/uvYVO7nN4m82bHrRNvk3jbfJQkVPFd+jTexVKOLVMTZiaZiP0E4RffAjQThjYGOvUqJJGnlmS3OU9qbvj3zzKRBp5EIRxI1erFSQOpXi7jOlDzi34r7lEPqXV3uxzPRP97ZiGq9Z7Zr7vzaU5KIjD3nGIzvV1pnkOhKZlch6LYknTO5b7hIi5MC7MmAo4mAMWsWDIpCY0pdK1J1hrdfr8hTXQgBTifKKBNvt/REVoOPHGoa6GRay5IA60FHin/MfKJxuRLftc19PAwmV15K5MvDBZAyVcglvSwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1I/RQdKGk/lgATg9X89XBHda/mJcz9gE4GQrilvOo2M=;
 b=QjXYEIxRMP0Yu2rhOxbGQyGKyKU5J1INHAGCXEDWKWQL2WiYzGzel4ujxJZuEqZCdfJsUcbtKaBb+IitRmcfZ5P2I9UblM2RARrksoSEUCx+7p6TQxZ6CLaAS0ZBlCrrAQAeL4/oukaHMmGuCXlQPelgOVi10cvWPBZe6hcTeksTpt4otTqMy/kXyDUmNSvkiGcTvFJf2YG31qqplHfw09M3FfeP6F4q9bxArKosByeYkI8u6WzV4M6u6dCPPPJngF6juiu0GErheec52fG+dWEgtxtj5NpQelZ7OoWHvkJ8qxVPSunEKWwH04H90Qj8k4isfKqI0f2WkepUAeHKCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1I/RQdKGk/lgATg9X89XBHda/mJcz9gE4GQrilvOo2M=;
 b=EWSxFA2E54HEOsJi3sAhattmZAbWSb3tC1IgIFToJzyok3pxNITsoqKFNOqFnueuyLB9cHFseajtd9CrNa2XZydN0eKAQexV1xcYvhTTFAWIQREj9wHJPxmFlDSZv3AZTlH9dCcHo82n3kQEFx48aua0zsQz7Tt43Zx/yOhA7ic=
Received: from BY1PR04MB8773.namprd04.prod.outlook.com (2603:10b6:a03:532::14)
 by PH0PR04MB7480.namprd04.prod.outlook.com (2603:10b6:510:58::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.27; Tue, 17 Mar
 2026 12:19:16 +0000
Received: from BY1PR04MB8773.namprd04.prod.outlook.com
 ([fe80::bacd:b9eb:89b5:6062]) by BY1PR04MB8773.namprd04.prod.outlook.com
 ([fe80::bacd:b9eb:89b5:6062%6]) with mapi id 15.20.9700.015; Tue, 17 Mar 2026
 12:18:56 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, Carlos Maiolino <cem@kernel.org>
CC: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 1/4] xfs: avoid unnecessary open zone check in
 xfs_select_zone_nowait()
Thread-Topic: [PATCH v2 1/4] xfs: avoid unnecessary open zone check in
 xfs_select_zone_nowait()
Thread-Index: AQHctTp0LNb/vTReh0Wojq2RVGIa1rWypiAA
Date: Tue, 17 Mar 2026 12:18:56 +0000
Message-ID: <b8dc6c76-e695-48f0-b84e-4f9ffbfa1571@wdc.com>
References: <20260316114020.753228-1-dlemoal@kernel.org>
 <20260316114020.753228-2-dlemoal@kernel.org>
In-Reply-To: <20260316114020.753228-2-dlemoal@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY1PR04MB8773:EE_|PH0PR04MB7480:EE_
x-ms-office365-filtering-correlation-id: 97950610-bbde-4141-3f85-08de841f5ca4
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|19092799006|366016|38070700021|22082099003|18002099003|56012099003;
x-microsoft-antispam-message-info:
 9wWMl5zxu5MEPl53jWvmODb+W6xDh/blWdOdWa9TZ1nc82uM9NqWanWRhG52XsgRP5m8nQja268yHdfeXtmDaXTg69Cy2wSncoMrBmg5F/D/aeHMQ6TrWo723kh7DbnxGsdNOMKvZCKeZ3Z29mZJf4/qq+E9+EU9KeWlc/15o38hPgzaj1gZ4na/5pCob/PJLRJN2+YjgXwQXh6GOUqpEl+yhC1zSNb6i7SjSFgEAs2JRUepvYdQq0L+aE3S78ueK3Ed4G6/abw42KoPcFWeE/1VFgIcfVrCccqEsNxcjqdLwL1eDqNnqJzA/K/+dxMIpp+ynj6A/fxzFUo9Fi7cQV54Obft0qJ/M3UFLijGq5c3H9zZpe8CpgLuf4Qf2qj469dc1F7kRSs1vFMrqrSgaJFWYxjpXBS1TDB378SojpSO7vNlJ00kpuSqEpyIQDJ7ZLsqU/FeWkkxCSYxFX620n3Y8+rgoTM6uPDp44aeK1R/fGiaF9g6NcW+xsjSgijRksf+UASB+jz4Ll5SSAbbMCc45MghPxIt+Ai/ZoSJQIyFdrObsP4oepw3e5prdFExBqKWxQEA1NxXr6FW1yNdkn05ApdzSBcwfdp0kUxT+fieag2Hwrhqc2CaCF35lgLjYTLR52Rh9GgMWR421qekeDYFM+ZmjRSy0FLCnWuO7Pp1Xd+Jjdcx4xSFkPg6x1nJYJA0nV1HAS1rDQzz4HhNuAHrD6AYMjGhhe/4sltlYSprS3ZimP6hEsrx8/46inBHgTcD1207BtFDAPCAeCeDzaFdwZ47ToSskMJDpho2q+g=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY1PR04MB8773.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(19092799006)(366016)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cTBpaWR3dlpLZlp6T2Vwc2VNSFNBL1hTL1BISitJSGhuRmk5Mm51bWRNU0Fs?=
 =?utf-8?B?bDQ1TlU4ZjBhbDV4ZjJmZ1h2djVLeEgwK1NJRUpLVURPTmhzb0I0eU05S1Y1?=
 =?utf-8?B?ei9zdDNFKzFMZEZ0bjlTa1RJdUxBdW81aGJreERxc3BuaGowUjJUTDRqdzJO?=
 =?utf-8?B?K1BPWVRUMDJNRHppKzBHajYzdDJvVmFFWW1ZNmZvMHo3aUZvVHdQQU5LV1Zx?=
 =?utf-8?B?ckdhRFhFS2l6VHRQMjlOQUxSM041Yy83Sm1yMVY2UC9sUnZvbUxnVGtrRytl?=
 =?utf-8?B?eXo1OFlkQWlKMHBJcTFaUVVoTC9GbVZuRGdUMnRXN2ozMUlON0E0bjY5ZTNK?=
 =?utf-8?B?KzhTNjNvWWk2N2lyamhiNnVHWUswbkpNZDFXNEV5cnpzVjFOVlJpZFI2SWxn?=
 =?utf-8?B?UmJ5bUlDbWVlQk9oODlBaG1ZNERWbzFraFBLZGlFSVhqRWRFS3p5Smx1VTQr?=
 =?utf-8?B?eTdRZk1JMTN2U053SlUwb1V2K1llVEZocEh5M2VXRzZwVW9pTytpeEdNUUVq?=
 =?utf-8?B?Y0ZiNFhkY245bnNsaWNsMWxYVzA0ZkZWOUxMcndxdEJqWS9Ydk1SZ0d1eE1V?=
 =?utf-8?B?ZDRIb0NYNGJMS2c1QmRkQm1nblQxRzBhUis3S0paL3J6dW5GY3B1c1FDQ0V5?=
 =?utf-8?B?Y3ZsRXZkRjJBQWg0L2lkK1NWQzVyMGg2UlJzRkhPNmFOa1Z4WUdGNzV0M2p3?=
 =?utf-8?B?RmlKT2piaUtSQkU3bml5R1NUNjM4bXNHODJqbVVjcVBGdXZKOSthNWFpYktQ?=
 =?utf-8?B?b1NyWGVOSkRjMVNXZjlBenZlNkZzayt2d3VZWEd0SGw0QUh6ZC9WRGFKZmtz?=
 =?utf-8?B?VjlzOEVjcFVydkVPUUVKdlhwVWZPTGhyakJ1ZjZhc2daMlZuT3d6MzdHY2g2?=
 =?utf-8?B?cXBXOWpRZmw2K094MUFmZ3A1ZzNnby9wb0JxNTFRb2UyczhJQ2FLd0hNejF2?=
 =?utf-8?B?aG9pR3BPeVRQbmc0UDIweWtUOWJSUmtVSmNYMTVNZ0tqM3FWNG1oZm9MMklL?=
 =?utf-8?B?NE5PcUdZN2E2NXVpRVA4a3lPOTZBVzh3bWpCSWJUUHVLbU5raWFMZ3QzMkJl?=
 =?utf-8?B?dDZtWFVOdHVEdjR4L0tUT09zc0ZWSVdQemlJUDVGUmdGZElsRmFSbUYranNL?=
 =?utf-8?B?Z0xhMVBzdmxLMTR4RE5mUmp2ZjlpRG5iZ0JqMlNoMnQrTXNHSnRkdU4xeGFn?=
 =?utf-8?B?dHhqcUhHWk9SZWgrK0NWOEpxSEROU1lMQW51YkdlSTZuaHNHLzNGOXlsTUFi?=
 =?utf-8?B?bmxwdmUyTnVqcVVQRk9aZVA5UVhkMFhsODNwRXJsVkx0eE5TZWtkenc5Vjly?=
 =?utf-8?B?bmRiWVRtN01Lb3J5dGs2bXNoVWVXSDdKa1lSeGNSQnFxMnJyc2hiZUZ4VHA5?=
 =?utf-8?B?MDhyWFZTamZjQUhaRzJrL09xbkZpb21TcHJ1N1Q0VFF2bjBDd3BtSnQrdG55?=
 =?utf-8?B?aWY3VTQ2cXg5VnNUUFY1MlM1SnRTaklSL3h0VG5ic3Bid0RHd2hvdFdVL09u?=
 =?utf-8?B?YmU3QzJQcXMyOXkvVmVpSjdkMjVEdENCUXh2YnJkUmlQVVNVMzBmUWdWRDNJ?=
 =?utf-8?B?VDdyc3ZIQ1pGbEF6OTFHOW1LallhRm5tUitCMld6SHNSVW82a09tZnZJZ29v?=
 =?utf-8?B?UEZqeHB6U0N4KzFUQ09aQ1BHZWN6c0dSVTNKeFVGaVg0WTBQK25EanpqS3dM?=
 =?utf-8?B?emIyUC9MZlJJaDEwdUxMcVJ4WGlvZmZsME1qSnlVbUdZekZwUVMzQlVVUnRr?=
 =?utf-8?B?VDQ0elRmakNlRTN4M3hXbkdXRVRKd0pXbHBoa3ZhdVdoU3E3aSs3UXY4MG1B?=
 =?utf-8?B?S1U2MURkUld2TE5oYWgvbzNvSzllckprcGJGUTI3M1l3RFJYSGFLQ0tibUtN?=
 =?utf-8?B?bWRXUG5kaFM5TWVSVGwvdVo0QVViN1BVbnlFNnJnMzJ0MzZSZThLeVBuMlow?=
 =?utf-8?B?cFJ3S09TS2dOblRYZWk1ZXlkM2Z2aFJLVGh2TjJqTjl0aGpRQmI4akNJd0VG?=
 =?utf-8?B?dWgwUU5MMHdhZVhTbjBSN2VPdE91ZlZ1VWNad0tpOUdUT0ZJTXJYRGlLNWZy?=
 =?utf-8?B?QUVmd0E0bzUxWWNEbFllUjYxclFVZmFIRXNFcDQ2QmFJRkg1NU9mL3BSbW9Z?=
 =?utf-8?B?ZTY3OFZ4Tkxhc1ZodzFpTXRlVGlBSENSVmpaRVAwWSt3b082d1ZxU0orUzl6?=
 =?utf-8?B?WTl4RzUxR2c2LzlrMHJqQmlxNndURjdNWHA2SFljMGJHb3FvTGNxTUhLNmxM?=
 =?utf-8?B?YzNoUW0wMlRiaFA2d1JSZWRZaXJLdkEycGVnQnVISDBRRzVvVUlzUXlReDVo?=
 =?utf-8?B?RVJlUjgwM3hkOURscmF3d1IybFp3VE1OSkRDTitEcFBhMDFPVERjQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <509C00B2677A2E47B0327F7B873FFE23@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	X43pHhn9WsDNW4aOYKR0qVi90UxrghWb4Ydr6t4PDSsxgB+04XhSx5dyrhWcY09StgOzLvnF0RaSoLrjX5dSka6Yl5OjXPD7qWk1Y0mgrMLia838Hx4BBwlajiSD3aky1Rk+DTXXYjRt66JSEi2adKRD3QFoR00ymOhujsNkLEd50fSxhWp8gg5yLq32UEZHd7XkMrTmqwk3+N+1ETTurinHifiM+ohkA8WaF/TrYhBLA6Fb6Xc+7eeOERCrRl1Gv6KsPNzM3cZjBf+SxUxIAHGWA1n1L021tDRpj5xk43DeRiwR9EDSzijXbWI5lXXLVJofTRCVmy6nH5TWQY24jw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5pUshRFZjxCBIBU5KdoP0Fi3TVld5HUvlQbHw76p4Cv54HDUlgsuE5oYqJp5TyREqxOAkN99e0YH5HvlaaHuo190HNO/opO5S8Rt1bAYeVE90V4NrFTbhuPZBH/kGM9cLW+UBg2kXsAsyAUt3ZABnDoEhhi2PA+abjsAbZc9DIsEniEpOG2g5iuND7jhPaJ56qKL43UDAAG1ydq9Ce+3AswSFQk41DEthzgGHlrvkNa5VDKCY9jrY3QXX3QF9k7SGCko0dWnMvTq7sXtJ6R2y2DTg/XGfK0yqC3KamWG/1bX6diF2jaDsV4rP/pkVxeo4GLluiU+HlpgcuS1yIbBlVaxsQn1jU8eP/yEBVJJetH77SK74saac4RftfNJfNux/jITC1Z84ybBqSZ93uYoFeYiZ2dggI2ukfxlgwDjoYigZodISOEJl/LUqfoX5szXCbza0cDR32gJVwn/rCYTDl/dK7FR/+AD3dLf16JzQ3VHViyQyf63i5ff+729QDsFSLPheYRauN9uedgQnm2deQFYxitMxKsqU920Qx22g+KcQ885rfTVBYA3U8wq/sBvLqihCQYeCi/vpcSSk9E+pdmIhlBfAxuW0aTeAVwLZFylrYtu6Vm9oNvro/Vg9Prj
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY1PR04MB8773.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97950610-bbde-4141-3f85-08de841f5ca4
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2026 12:18:56.5705
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r4T6o/Uly1cEBn+Gn2UYabHVu9xvmND81Bkbr8e4n6DoJrIlPswFas0eS3cE/vlEAy7iroKUMzKYJ9I8jxqD1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7480

T24gMTYvMDMvMjAyNiAxMjo0NSwgRGFtaWVuIExlIE1vYWwgd3JvdGU6DQo+IFdoZW4geGZzX3Nl
bGVjdF96b25lX25vd2FpdCgpIGlzIGNhbGxlZCB3aXRoIHBhY2tfdGlnaHQgZXF1YWwgdG8gdHJ1
ZSwNCj4gdGhlIGZ1bmN0aW9uIHhmc19zZWxlY3Rfb3Blbl96b25lX21ydSgpIGlzIGNhbGxlZCBp
ZiBubyBvcGVuIHpvbmUgaXMNCj4gcmV0dXJuZWQgYnkgeGZzX3NlbGVjdF9vcGVuX3pvbmVfbHJ1
KCksIHRoYXQgaXMsIHdoZW4gb3ogaXMgTlVMTC4gVGhlDQo+IG9wZW4gem9uZSBwb2ludGVyIHJl
dHVybiBvZiB4ZnNfc2VsZWN0X3pvbmVfbm93YWl0KCkgaXMgdGhlbiBjaGVja2VkLA0KPiBidXQg
dGhpcyBjaGVjayBpcyBvdXRzaWRlIG9mIHRoZSAiaWYgKHBhY2tfdGlnaHQpIiB0aGF0IHRyaWdl
cmVkIHRoZQ0KPiBjYWxsIHRvIHhmc19zZWxlY3Rfb3Blbl96b25lX21ydSgpLiBJbiBvdGhlciB3
b3JkLCB0aGlzIGNoZWNrIGlzDQo+IHVubmVjZXNzYXJpbHkgZG9uZSBldmVuIHdoZW4gcGFja190
aWdodCBpcyBmYWxzZS4NCj4gDQo+IE1vdmUgdGhlIGNoZWNrIGZvciB0aGUgcmV0dXJuIHZhbHVl
IG9mIHRoZSBjYWxsIHRvDQo+IHhmc19zZWxlY3Rfb3Blbl96b25lX21ydSgpIGluc2lkZSB0aGUg
aWYgdGhhdCBjb250cm9scyB0aGUgY2FsbCB0byB0aGlzDQo+IGZ1bmN0aW9uLCBzbyB0aGF0IHdl
IGRvIG5vdCB1c2VsZXNzbHkgdGVzdCBhZ2FpbiB0aGUgdmFsdWUgb2Ygb3ogd2hlbg0KPiBwYWNr
X3RpZ2h0IGlzIGZhbHNlLg0KPiANCj4gTm8gZnVuY3Rpb25hbCBjaGFuZ2VzLg0KPiANCj4gU2ln
bmVkLW9mZi1ieTogRGFtaWVuIExlIE1vYWwgPGRsZW1vYWxAa2VybmVsLm9yZz4NCj4gLS0tDQo+
ICBmcy94ZnMveGZzX3pvbmVfYWxsb2MuYyB8IDcgKysrKy0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQs
IDQgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9mcy94
ZnMveGZzX3pvbmVfYWxsb2MuYyBiL2ZzL3hmcy94ZnNfem9uZV9hbGxvYy5jDQo+IGluZGV4IDdk
NzEyZDVhNWNlMC4uODQzNWNjYjAxOGRjIDEwMDY0NA0KPiAtLS0gYS9mcy94ZnMveGZzX3pvbmVf
YWxsb2MuYw0KPiArKysgYi9mcy94ZnMveGZzX3pvbmVfYWxsb2MuYw0KPiBAQCAtNjc1LDEwICs2
NzUsMTEgQEAgeGZzX3NlbGVjdF96b25lX25vd2FpdCgNCj4gIAlpZiAob3opDQo+ICAJCWdvdG8g
b3V0X3VubG9jazsNCj4gIA0KPiAtCWlmIChwYWNrX3RpZ2h0KQ0KPiArCWlmIChwYWNrX3RpZ2h0
KSB7DQo+ICAJCW96ID0geGZzX3NlbGVjdF9vcGVuX3pvbmVfbXJ1KHppLCB3cml0ZV9oaW50KTsN
Cj4gLQlpZiAob3opDQo+IC0JCWdvdG8gb3V0X3VubG9jazsNCj4gKwkJaWYgKG96KQ0KPiArCQkJ
Z290byBvdXRfdW5sb2NrOw0KPiArCX0NCj4gIA0KPiAgCS8qDQo+ICAJICogU2VlIGlmIHdlIGNh
biBvcGVuIGEgbmV3IHpvbmUgYW5kIHVzZSB0aGF0IHNvIHRoYXQgZGF0YSBmb3IgZGlmZmVyZW50
DQoNCkxvb2tzIGdvb2QsDQoNClJldmlld2VkLWJ5OiBIYW5zIEhvbG1iZXJnIDxoYW5zLmhvbG1i
ZXJnQHdkYy5jb20+DQo=
