Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09DF1E991B
	for <linux-xfs@vger.kernel.org>; Tue,  4 Nov 2025 14:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762265779; cv=fail; b=TREFj3ddwUI4pRPlU0Aq83+wZdfa8wyEzgIrUuQ2G1Zot0n/x3UQiktSPy890WO5Ag2TYNrAmSYelTIKmkTX6vGw5BQyfLsoohkGUUYrhjml7AxXmfTPjwKwR0X57wmZhud+rhJOXV543GU0+i2huuQUhTl0oFSCyAXOxunE4zA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762265779; c=relaxed/simple;
	bh=7OWoyC7xrryfzujsYQylv1Hn7vu+d4OAdoZvGm6oL4A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Lv2KrJtY9uenENWuRVlqlpvWi/l+qCE+58pC+ky8znhr13qhpsfeHfmQt4J+a86Rh537K4CYwIntwEaH/0PAsg+bHi2HRFtARiu+eyjy5JJzMLTCDwPENU862hnw5f9pp+ouXUj7DvRnSGsI6QRqWmYyZAaWmrfUKV+4DSHQ2FM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Q/T/7Hhr; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=VF8WUJKJ; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Q/T/7Hhr";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="VF8WUJKJ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1762265778; x=1793801778;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7OWoyC7xrryfzujsYQylv1Hn7vu+d4OAdoZvGm6oL4A=;
  b=Q/T/7HhrMRlwK47/lhxVBsxsX1HGyj2keJuMaaScRAiKxUBM/xLKj3Wc
   k+WFsE3M/fQC/h8059rYQ0Xb7mGu4SVFVrxKInXbErRrSRGXIN9cs0iMN
   U0D89FSxAMuG7baC36a1Bk3VCkzj79ejoi3JxLFpRb1gN6T+oXHzGCOR3
   j7oP4KC0ovHybx51EaBmsTOKjo1H2ipKDZCsvskb27hstdm7dj3JFLZq6
   u1y8A/IHZLLdGSWuteHZaE4Yn5S3W1KkL1nXTSbKo1rJj6iudB24dhQTX
   e8Ae0P7/meFFxnGEhbCIOIIRvmBebmJpTaR6pMBrwylKuzzbZA1RqG9Ss
   w==;
X-CSE-ConnectionGUID: L4FM2aTqSwqLYvGgTSkr8A==
X-CSE-MsgGUID: pZlIU+ekTeuYArH3WrJMGA==
X-IronPort-AV: E=Sophos;i="6.19,279,1754928000"; 
   d="scan'208";a="135414845"
Received: from mail-centralusazon11011022.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([52.101.62.22])
  by ob1.hgst.iphmx.com with ESMTP; 04 Nov 2025 22:16:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gAMlSCZts5bAWXRJNzAjrWz62x77EKg4hkux+/gwIIc6Zi4CfcXkMgT8kAyUYtJ4hidOnjHgz5uS8VhuhesqEnVni3NftesJSaqXctBdTIq592rNr+TyaVS+3WhV6uzSDZIV6nZa9JF294P5MNMCUjLvzWKfuKyBOpsdPUlSzNgMM/BrfXfqplO/zE9UpnwQVuNLEOWdiNpUj8PcJtZXLPnPygkuHiqW5sqroSvyljdMVhE6Guss8fxDCX8gAzHRaQ38blaRvEm1BVGBH6NDihAHxHCqN64uGUTe8A8YiIsPFABX9umD7JlegrKMKCZ939axh7fWFn2vh67aJfSHTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7OWoyC7xrryfzujsYQylv1Hn7vu+d4OAdoZvGm6oL4A=;
 b=Ji0ofM0PCUY2Tk4Ym0FWCYVVW0ASZIBZt8mMx5PSYgT+5Lk9Kx9AnMUaKE8SPaE8evriQ3N264wxPK0YJBDHbM2cBkrS6WqTyZdRVbIVwdybztLQaFDFZAzIdtqTtsNSoLek9L2nWkhJTg0uQVU8IAAdwyBWiWPmjVsBZhHHv1F+v72G3SW7TQAl7S34HMdy5d5r0//yNDoONwxTGXi8i/BuF8xXTOa5gIalyhdXkCK3CQI7LhnWwkxPuYmPkB1RMPjI5qPHVy/Y/jvTasZ9rqHbua5Hs3LBrPj7nEBbPM7Uk8JtFunS5NB5z60TdyDe/IdxIWuRkcbCN9q4lhujJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7OWoyC7xrryfzujsYQylv1Hn7vu+d4OAdoZvGm6oL4A=;
 b=VF8WUJKJO4Cf5PaDucYpnmMh7fjmH8qC4se8IYCD+JZRdi/x4xRoMhuLuYXsdtWN1WCfFGBdRqqU39M6XKedcj+V9dhs2tpjtIc8RRDf+ixSLopNHxdz87YH9mq5OHO5u/SdsXOz0NwLhl/qh5IqrwN0F4Z/37jZ1U++bqKX75s=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by PH0PR04MB7160.namprd04.prod.outlook.com (2603:10b6:510:9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Tue, 4 Nov
 2025 14:16:08 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%4]) with mapi id 15.20.9275.015; Tue, 4 Nov 2025
 14:16:07 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: hch <hch@lst.de>, "cem@kernel.org" <cem@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix a rtgroup leak when xfs_init_zone fails
Thread-Topic: [PATCH] xfs: fix a rtgroup leak when xfs_init_zone fails
Thread-Index: AQHcTZIQJ6YUhxy45EynCwZ2rlJpyLTij/uA
Date: Tue, 4 Nov 2025 14:16:07 +0000
Message-ID: <ebf1984a-5ea2-447c-a81c-c4d8fbe9f354@wdc.com>
References: <20251104135053.2455097-1-hch@lst.de>
In-Reply-To: <20251104135053.2455097-1-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|PH0PR04MB7160:EE_
x-ms-office365-filtering-correlation-id: ba6aa947-f4cf-4846-54e5-08de1bacb298
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|19092799006|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?T0oxNGlyWmt5UUJRd2dVM3NkVUFJb29tY201cm81aS93MUZyMXdkMXJ5UTVk?=
 =?utf-8?B?T1ZDaFB2Nm1iQUVLOWIxUEdFSVY3amRXV2F1SGthNDVnZWVzVHB3YjZ4ajRK?=
 =?utf-8?B?WEo0aVd3SHNuK1loOWtjNHBDZnNNb1YvajZGa3dEcGdyZVZ5VXE4UEc2c3RF?=
 =?utf-8?B?T0dnWEowbE4wYWRuQ0xXZ05vbUp0S0dTdVU4YVBsNFhaQnR0a1dSNHFRZXc5?=
 =?utf-8?B?NmU1QnZmUE9DY3MyV1JGQ21rRnFBclk4aXkxdm5mMlN1YVlVanVsbFUrVi9H?=
 =?utf-8?B?eENmelIxSGJ3U3NnMjBuQlhtSnJnV25XUk9zYTZCOEorZnI1VXZHb01SbXpU?=
 =?utf-8?B?eUR0a240QnpycUFlSVN2QW53bkFsTmVyWXcwcUNDdHdZWW8vWG1VUXJxQURZ?=
 =?utf-8?B?RC9rTEdEenVYUldlb2cxSTJVNlJ1Tmx3bjN3RkZlWjFORFlmcVIyRmVXWnVt?=
 =?utf-8?B?TmlEYWVNcW15bjRqNGZXVEVxeGtiZXlaTEhqaTdiTUx2MXV1WVdEbDNoaUlN?=
 =?utf-8?B?OXpoUUl3UVQzUk9mQnJ1QkF5bnRnenRnSlJtUzgyKzlPd3dMOGcxSEJmVldN?=
 =?utf-8?B?RGc4Nnh5MGRnZWlPTk82WkxNVlhQaU9nc2MzQ2xkYUFTOEFVQmdxcERvMENM?=
 =?utf-8?B?U252VUhmV2tJVWhJR3JlRHBqREVDeWJhb2lEdkR0OEtxS0R2T3VyY1dYYmpN?=
 =?utf-8?B?YWlVR3FoZCtYakgxNHJYWTFKbGJqemw3VWZzSzBSMEJxb3BUQlFpUjFhczRO?=
 =?utf-8?B?dWF0YmdhQUVremtDaU9scWEzM0lCZENkd284WElWY3k1UXUyWGNSUTdjNSt5?=
 =?utf-8?B?YlBqL0JpUTMyY2kzK1U0UGU3RFdPQmtmSGZzRWdJeEphR1BPNCt6K1lpNzdz?=
 =?utf-8?B?VTBaa21iMkcvYVQ2SVpWUGI4Y1hWRUZkZWQ2Y0FoNWFmb1g4NFV5ZWp5c25n?=
 =?utf-8?B?ZkhZZ25mQmdGV0JpU0NETmdDemZaWjJaYytYMXBXT2k5RUlWUUdycHc2Sk1G?=
 =?utf-8?B?Ky9sYWJpRElGUlkybGdURENLUGNkdS9GQ3lOaVd4Y0RDMm1pVERubGFwNGIv?=
 =?utf-8?B?SmlLK1puRG1yd21IM0I1RnhwbXVuYnIyYTRTNUVKR1QzQ1l2eW1VWEs5dDla?=
 =?utf-8?B?ajhKYkZlTk1vYnZ6d3liMGJrQ0djTjJhcXNLRmlxTXZuQUdPZmR4bmZsWlZR?=
 =?utf-8?B?YzZxOXVidjhaSzk0NVBoVVo2R3FDTWdjRGpmTytKK3dGNkFIVUdRcVFDQWdC?=
 =?utf-8?B?MUNNODdUOERKdkhLbld5NEJVd2kzQS9TcG03UXpFYjhOb3J3ZTFORWQvZmNZ?=
 =?utf-8?B?aXRPVmRGYXZZN2poSHFBRmlrRXZOeTFyUTM1aC9TbTVaYlo0cVJPa0xCOFRp?=
 =?utf-8?B?MWZYNS9OSWoxaFhiT0gxZUtrRVRGQ2RybHBNcGpxdFNlcnBDUVhXSkJSTDQ3?=
 =?utf-8?B?TitmUVBYWVlmVTlsOHJIRU1Ta2NHdUQvQ0Ezd2dpcEF4ZU12RWoyRmhSSXFn?=
 =?utf-8?B?TE9veHpGd2QzT3k5ZlFUWmtyREsyb1Q2WnErZFFQbTU5NWtnSFVYZm12Q1FX?=
 =?utf-8?B?eXllemh6QVp1WXpFMEFOcnU3dXA5T3dqQkpYOTV3d09qQVFtQndoNndBTXdm?=
 =?utf-8?B?QVZEM2ZjL3NwSkVXK0Q3OSs4Sytpc0dacXRXb1VHN1d3UExPVGRMMVJTcWps?=
 =?utf-8?B?NEhlRENJY2ovc3NIUWRYV3laNmppVGtOSzhmb0JFTGt2RHJ6ZFB3cmZFeUpP?=
 =?utf-8?B?MDRrb1FIV3B2dEg5ZGpnUkw3aG9oN1VnaVc2SWhGNGpGZGlzZVZyVWR2T3My?=
 =?utf-8?B?eG0vZVU1eU9Jd2p5cFZHVUVOS1IwU2tYOHB1RkVEdVVNZzV0VzZSOTl3a2Mx?=
 =?utf-8?B?YzcyNVJlSUtxaEFMSG9xdFllVjhlV0MrVHFGRGYydlFpdEgyVnhxRWpPc2Ew?=
 =?utf-8?B?bGVnVkZIVzlOS1J5K2x4RFlBam9NTUhDdW1QYmk1ZFV6M3ZLSUo0K1pOR0xy?=
 =?utf-8?B?YUpzenNjK2liTVBnUWF5b0ROQzZhR0tLdXJGQzdGL3lFTzd0UytGYVVpUUMx?=
 =?utf-8?Q?7vSCl7?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?U0prMmdhd09hOVMvN1RCYzJiRHdvSnM1Y3F5QUc2STdCQVBMU3BySG9tT3ZZ?=
 =?utf-8?B?cXI3UzVEb0xiRnpwZ09YREE5LzdwVjg4TXlZcEw2Q2ZIYTdBV1FuejdhL1li?=
 =?utf-8?B?blU5T1pCbjQyd0xLQktZZnhRK0lGY05UUDJSTWN3Y05ZR1FqOGxSa0Qva3k0?=
 =?utf-8?B?aU1kZDhaajZoS0NyeDBpVTIxZWs0WUhFWWRPZW93VW5zcVg2clZURGNUQzYy?=
 =?utf-8?B?WFdtT2FZaTE5cXRiWjNwRmNXVGVJMEVkbnJFZjgzaEtyY1VEZEJzbFRlOHZ5?=
 =?utf-8?B?YkN3THhMTkNoRFE0YjNwU3c3dUdDcTA0YVlDYnZJd1F5SkpwalpCWEtlaHA5?=
 =?utf-8?B?UWNJdm9JVnpRbEx1U09yVURsWGFaYm41QTlLVzgzRnFpNUI5QUJyQVZlSWdt?=
 =?utf-8?B?a1JxSUNoem8yZHp6dnpBamszVHFhYlhKK1ovT1JuNUxBbHJvdTZkYS9hNXBZ?=
 =?utf-8?B?MjRGVzE2N0hPbVdFRS9pa1JnRmc2SEIvYmhvRStpNGZGMjFST2xSQkg4ZXN3?=
 =?utf-8?B?R0FDdEQxbGRhL2Z3RUZ3azFjbnpoNjF5OWY1SCtmVDYxeWw3WVVpMFllS0tD?=
 =?utf-8?B?a3VKQXJMOFpuSWMzVzlEcW5jUDU0c2FnNkNyNzFhSWFmQ2hKY0NlT2JjSy9H?=
 =?utf-8?B?SWJsaHdNWXozMUxkYUh4SzVSTkhKczhldU9OV0srWi80Q053UUtTOGpvYWJo?=
 =?utf-8?B?a2w3eFRYTTNwbEc2Q1d1eFpobVRLRmJXUGVZRU5zakVFZlVvQllWUTRqdVRj?=
 =?utf-8?B?UG5DbElaMDFqdHlnWmlCRnRNVWdUNTREVVo4VVFrTXNVRlZBQ0pZYzlrZUtw?=
 =?utf-8?B?bk1NcGVRNTh6RVpBTzBTVHlldC9uVUQrSGFlNTRZcW5vbFVTVlY1VWdxSnB6?=
 =?utf-8?B?Uy8rK0EyOHB0OUFGVVFoM2R4NVh6ZVFuS0hjV2F0WGJBY2dpamtXMlA5RWNM?=
 =?utf-8?B?RHpPSkZhdE82TW1EYTgvUzMwTGp3WnIrWFk5SmNhQ2RMMml2bWFEYlRRR0Y5?=
 =?utf-8?B?OUlSWUVBOTNwMmNvQ0VkRW9EYUl4R0pUWGM1aHZ3UXpkSVlnS2NSMStXK2FB?=
 =?utf-8?B?LzFNTzE5RkdBWnptVGdVbGZwOGc0MXAyT0lFVkNsL1V5ckpFeEl5M0pLcEpO?=
 =?utf-8?B?R2g3TFdmU242clkxQkY2cWwwY3U2WGFCa3pCVy9XUjVpRjlTdUJTa2JVbk9o?=
 =?utf-8?B?MHRZaExUS0VQOGhDN0dJLytTMGY0Ulk5U0w0Q3R1VWRGK2daNUNxMnpDendn?=
 =?utf-8?B?c05uMldpS0IrOUYrQmJjSDNGRjhBRnlldUVFaG9zK3NTaGxaNGlNVkpoYVo0?=
 =?utf-8?B?RFZpSDFhNFZCRFRhK1JWdXpRV0o1ckxHa2xwUFU2V2llM3NTWUZzcjZpb3ZB?=
 =?utf-8?B?OXBTSmtyQUFCOENYajAydm1yTWYwNDJzUGswQUFOZEFNZjNGYy9vaUphdUVo?=
 =?utf-8?B?RlA3bzZXVTVJU3dqYjRrWk5RYitpVmY3RW1GWVUyeEQzblRCUk5CYXUralJx?=
 =?utf-8?B?a1BNV3N2b0F0Z2N2bDRFOFJrL0xzWWptZjBNd3FsNTNUbUFJUStqMWt6V0hB?=
 =?utf-8?B?bnlmZXZPL1NIUkNOcG1LWXI4ZGF4RU5DdXFzRlVDR1dMNE9oaGcvQWJQVVVJ?=
 =?utf-8?B?MGszZkVRWTdsUXhHS1VCbDhkWFdheVpQc2RoT25JcHNyWmsxdHN5VzhTRm9D?=
 =?utf-8?B?Q215bjNHdmZtTUlTWEV3SFZMRG9QTVdhd0R1cGVOcVhHdkFQeU9YN1lQbld2?=
 =?utf-8?B?M0h5Ulk3UDVkS1F6TitqbFdqakFzRk05N2VzL2kzY0VZUXgyT1VYaStOQ3A5?=
 =?utf-8?B?WlR6STJ3UzB4SnovWFFoRTRZbXVERldpb05MbmhEOUNvb25DRlBuM2hieHov?=
 =?utf-8?B?UDBoUVBjWElVemJnMUExWnB1b2tEUkNMbmp0NVRXZUx4OG9UbEpNbmxVNDdV?=
 =?utf-8?B?dzROK1BkUXV6RGg1REM2UGFVV2ZVK1pGN3ErdFluVVptN0JibXNNK2NvSGp5?=
 =?utf-8?B?YmZhb1ZrWDg0Z3dNeHN3QWFCbUhZaElLbVNmRzZNWStPeGZqaGxXZ2phbEx6?=
 =?utf-8?B?ZkxCMWZvSHFxQWVZb1BZM0lYOWh1SnBUVXY3cjJwQjlvYmJIQ2FpL0xOa2dR?=
 =?utf-8?B?U1hiNERZbUdqNDRpTjY3QUVLRkZuT3NteEtYZURsRlRsR2d4VkpjYzhVeUEw?=
 =?utf-8?B?TEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A7F2AE5D59149E4F84E6653ECE3D442A@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8cCYBe0tjvvjRw1V+ueBfgcZOEfEZPRroQBz5tTqCN+rJHMZYIi2NXUrzz3FNok1nhdfFqspAiRygnKWaapK1dngFRDwwCii80D2NYjXBckIl5BfLVgOgeIwBRc5zjN578p2sWI8GJiBN4O+yj3br6ic2QckYsJMAodC9SXSDXSM+WhRpbk2g7KJ8PrCiwByF6Aef0ObXFGaCu4NE4GykLDEuOcegeYDq7wgPbHMfYSOgs5+JL2UpSRKG0rrtcZAQdPy6+yDAMTJgCn0+btCGDCUHVv+V2nd3JXDj+YDBEuC0+aFuG4VEGv9tvOQN943VPJD5c7u4h/cEjTsF67m6zgh+O1bC3V4TO1ww8k3ATpFjqTRdOJy5ba1zENdPrxf3eEdFybMSHqaH6+0l4SDiuLhd38J4NVFLS+0rWZwl9gOqmVURLgq0x/xOSkjrPHNcc5HYXxl07R2lbLaedYB6CPZ/RjrDW2c7mOBF+D5eCdyTkXdMJ1kY/6ZbcoGujKnraczPTzwOG3BsLl7+TiI/ZpLwNPDYD0MyhL04CFHe0Gi9QDD0YFDw+9xNCAVIJL+sB+XJZWxj+q4rKpPcw8RgmdltIOSjCjKk4AKeuQsarC7unjb6RhMSV6ge2+Ngw45
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba6aa947-f4cf-4846-54e5-08de1bacb298
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2025 14:16:07.7763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ynpTs93p1bgqEoNMD9DYO9JScSRXMM/DHFKPTHnkNKq94a11ObRcvLbE8T/iYqdxBMxs++gLNQO9BpSZSephwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7160

T24gMDQvMTEvMjAyNSAxNDo1MSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IERyb3AgdGhl
IHJ0Z3JvcCByZWZlcmVuY2Ugd2hlbiB4ZnNfaW5pdF96b25lIGZhaWxzIGZvciBhIGNvbnZlbnRp
b25hbA0KPiBkZXZpY2UuDQo+IA0KPiBGaXhlczogNGU0ZDUyMDc1NTc3ICgieGZzOiBhZGQgdGhl
IHpvbmVkIHNwYWNlIGFsbG9jYXRvciIpDQo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxs
d2lnIDxoY2hAbHN0LmRlPg0KPiAtLS0NCj4gIGZzL3hmcy94ZnNfem9uZV9hbGxvYy5jIHwgNCAr
KystDQo+ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+
IA0KPiBkaWZmIC0tZ2l0IGEvZnMveGZzL3hmc196b25lX2FsbG9jLmMgYi9mcy94ZnMveGZzX3pv
bmVfYWxsb2MuYw0KPiBpbmRleCA5Yzg1ODc2MjI2OTIuLmUxMjNkODM0NWQ4YiAxMDA2NDQNCj4g
LS0tIGEvZnMveGZzL3hmc196b25lX2FsbG9jLmMNCj4gKysrIGIvZnMveGZzL3hmc196b25lX2Fs
bG9jLmMNCj4gQEAgLTEyNDksOCArMTI0OSwxMCBAQCB4ZnNfbW91bnRfem9uZXMoDQo+ICANCj4g
IAkJd2hpbGUgKChydGcgPSB4ZnNfcnRncm91cF9uZXh0KG1wLCBydGcpKSkgew0KPiAgCQkJZXJy
b3IgPSB4ZnNfaW5pdF96b25lKCZpeiwgcnRnLCBOVUxMKTsNCj4gLQkJCWlmIChlcnJvcikNCj4g
KwkJCWlmIChlcnJvcikgew0KPiArCQkJCXhmc19ydGdyb3VwX3JlbGUocnRnKTsNCj4gIAkJCQln
b3RvIG91dF9mcmVlX3pvbmVfaW5mbzsNCj4gKwkJCX0NCj4gIAkJfQ0KPiAgCX0NCj4gIA0KDQpM
b29rcyBnb29kLA0KDQpSZXZpZXdlZC1ieTogSGFucyBIb2xtYmVyZyA8aGFucy5ob2xtYmVyZ0B3
ZGMuY29tPg0KDQo=
