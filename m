Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13792EFDBF
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 12:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769601777; cv=fail; b=k8zW0dD+jfvC/ykuNkfY/ecdStX/bC5/QDZlzaniey6RCkKO8eoOizCUhtkXRrgsTNjpIhLqO+Hx5uTVwmx+Sf1sR2wL8mqKR3af3D5F21Cn9h3K0oF2Ux/nMD2mjZNNEU75OTxECNda1DUlU+do0+2WtCOhugn6n2/EAt9kGFc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769601777; c=relaxed/simple;
	bh=ou412csDyw533/85bIUKxzFuVw3lPjD5W38BKev3PEo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jlAWsn6VBaZg2KcjKAaGjy77a9ZQfAuJk+Rh8ATcmxedrYmdniBGCLBEOR8QpwxTpqFT7FEBYSN0Ym64LMWaIJ3MeD2xoGRWPLBxbZQmB85prE6ktu40vtM1/qUH+Z7rgCCglHWXDj3HGV95lZ06vKKSLVbhG/jl7krwGgVf4Pw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=AVvkteYA; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=aPs5+3EK; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="AVvkteYA";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="aPs5+3EK"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1769601775; x=1801137775;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ou412csDyw533/85bIUKxzFuVw3lPjD5W38BKev3PEo=;
  b=AVvkteYApIUcN1hFMDUO4N8PGD+lQKu+kRDD3fZl8xnMWMWwVyI75v4F
   iyHucrH18k8zc3OXth2VRvy/GJrmp7K6Y0jSkoqHN/rtgKatnjtAe/Hwr
   l4YIflWWS8h1MP+hg9wra72ic0M1E6oUjHyL+MrKuOib9KLgp2sBslc2E
   2ON1oSZpeNbrdn7tDY5CydEgddjAy8QkbEojubVSFsISHcllGPwz2zpjs
   sXuaZTcR87TY4nAZ7W+w0+DOC6D09O7VtDFWFxkll07LpOaXOqlfBVU9F
   ybm6xJc6pVpaM3Ly5g3y89dFupXQ38tIhFtuWkRgv42pJsTTpZmtRN//K
   A==;
X-CSE-ConnectionGUID: VruAJczXTla/uy1R8wiQ+g==
X-CSE-MsgGUID: I5MjtPnaQ+2ih4SkEepKwQ==
X-IronPort-AV: E=Sophos;i="6.21,258,1763395200"; 
   d="scan'208";a="136200462"
Received: from mail-southcentralusazon11013025.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.25])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Jan 2026 20:02:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pJHAJSjemSiDDeX/FKx4TmFT6Y8nQ1Oe5+7+tIVRZZ/OCfxq9fh6VbtvFMm8WtRCD4wEJQuf3rW6pr//HDOGjgfdziH0a8JwdvqpJi9e/81Td2204hfi2RQn2xzqakyQDRNYcmUUho0MHTdZjCcfB1jhVjFQDiFyEzAHHdRCq97qQKnq565lKQ2X+iaiNgymFaWfXt3UmfcMXt8LIUYKqbn9Aprbd8EOKCkfdPIB5ms1uVkZryBcRBJ2HzQS5jvQBOmx6UxMnfZQTWVdqpJzqINovPIEY1DpEOJT8nxLSQty8OBeg2VdW2TIL8g3O33h/gXOxC/CBBFeGHKhK9gD1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ou412csDyw533/85bIUKxzFuVw3lPjD5W38BKev3PEo=;
 b=aq/b7Da0dd8AANmyZrJOlkK7WLgOaMli58vLkD+0RnKWhXUryWL+NxZbLp2xIkjaxyds7dOVgrMBwmQZhP/Cg1SwUlh7/YTwrio8j0t3ji0EzEpXhuROdGR6IGTmj7PtMudrGyf1OkituUudbjp+uTYv8deuog7IfQfIay3o+ezpesIatdtMscYeI4ryK+D6SOXmzO7tIk8NESlCeoOYOIsbacVk7+Hvp/H38SIrsJ5jhfn/tH09iOYbrtFoC7vKBB23lJ0odExMpyWOBRlUuJQoHQrG5JctBNkGXpshbi/TlHSSoGh9Sp87dJg4pVexdV/PQ+IDmn58vyoS78pZnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ou412csDyw533/85bIUKxzFuVw3lPjD5W38BKev3PEo=;
 b=aPs5+3EKkeDNmPxuc4dzoaKx5KiPB4kPN4Xv/pJ6LCeoNIH+KAID5QYdN4TU/PNJmB9+VNRSzUnsbIAag6xoseulsBp6TAqA+8pBPndmWUNhBCQEa0rF5kTfQvXssV7poibroqShhqtwCWCjJnll1NheVBihmrMuQKiDvf1GOmg=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by SN7PR04MB8642.namprd04.prod.outlook.com (2603:10b6:806:2ed::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.6; Wed, 28 Jan
 2026 12:02:51 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 12:02:51 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: hch <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: "Darrick J. Wong" <djwong@kernel.org>, Chris Mason <clm@meta.com>, Keith
 Busch <kbusch@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: remove xfs_zone_gc_space_available
Thread-Topic: [PATCH 2/2] xfs: remove xfs_zone_gc_space_available
Thread-Index: AQHcj58i0U+EwDbuVk+eu+XqtpFfv7VnfM4A
Date: Wed, 28 Jan 2026 12:02:51 +0000
Message-ID: <19a64342-a9c2-43ac-be44-ae603ead9e1c@wdc.com>
References: <20260127151026.299341-1-hch@lst.de>
 <20260127151026.299341-3-hch@lst.de>
In-Reply-To: <20260127151026.299341-3-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|SN7PR04MB8642:EE_
x-ms-office365-filtering-correlation-id: 3209cbdc-83c4-4992-3dd3-08de5e652957
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?VWpxWXhma3dra2pmbitNb0hPNVZsWTNyeEM5WDNUYlFjWkZuL1EzVDdlekV3?=
 =?utf-8?B?UWdiM2pwWkUyVEE3d0VYQ3VkMFNLTy9pSkJ4R3dmSXJQNmNTUUZCTUVHbWdO?=
 =?utf-8?B?dzBWUjNmQVRGcXVjSG8vZ3c1VUtJaWJuM0ZiUUVxVXZYM0hxcFg3bytRZE1G?=
 =?utf-8?B?UGFYeDBYRmVndkxaZ0M5YVpSVzJVUWRGMlNlODBjc0d6YmlKdWNLNmgvdno3?=
 =?utf-8?B?dDhGbUZwVmxoNlVkK1VUUDY3WkxUWEhWWlgvN1NPL2xhTTVmZnEvdlpsbnNO?=
 =?utf-8?B?d1BUMm5qRmREV1NYNzBnRmtNN0ZYTHNweXN5bHNCU2JhZFBEOENTcGk0NkFE?=
 =?utf-8?B?azl1VE9pUVRwYjdMSHBMNHhSK1k5WTY3QnE3MTBVQTBDY2gycndtNExyckRp?=
 =?utf-8?B?NUd6bThoTURoeGdOblNhUjk3WTZGOXB3VGI1NktReWxUZFl6VjdjTHl4Y3h5?=
 =?utf-8?B?anpRUy9VV2tzcTdzVHpvRDVKbnAxTnBTUFNkOTBycnlSUHBxREI2SHQwSmRU?=
 =?utf-8?B?ZS8vY0xqb0pZampsUkphbU51M2FBNDNVOERWSnlTY1orLzRPbk84bGFQaWEz?=
 =?utf-8?B?dWJUSnVpeURJRFBOL2E1eWlwRTE1WFJndk1yZE5CUmhrdHhERGhZeVV2K3BR?=
 =?utf-8?B?clM3eWtuQzFlQWxCQ2Q3T2xRUGY0T3NnRStWV3NNN2x0bno3bVRkWmJBR3lr?=
 =?utf-8?B?a3dkZnIrc1BtSlNWTGNaRGVISjVrOURkTjR6YmVZazJic1ZaMDFaREd0TFZq?=
 =?utf-8?B?ZDRVdDROVGxZRXBsY0diL2ZFY1JTQ2xUc2wzOVI5R1liUVl5alNTSVVVVWFM?=
 =?utf-8?B?dHg1b3Q2aHptZFdEeFBPNkI1cHhTUHN0U25lZDdZZHo4R3VWOVloR3R0SFUr?=
 =?utf-8?B?MHg4T0lObGhVVnJkUXNLTEs3bmhpMUNEcmdCY1RJWFRvTmcrdTRtcVlzVjRF?=
 =?utf-8?B?V3JUWWJZZEQ4UERSMzlUa0FjcytLQldvbUthM2JWeStDSGMwd2VzZU1HNTJz?=
 =?utf-8?B?QW5ldmNMREdNYUNKc2N4M1R0U2UwaTh6Y3l3cStHdmlYUjRSY0Fhb2J6VWE0?=
 =?utf-8?B?ZTE0L2wxc2VPRjR0T3VQa0VrdzBmemhjVDR3RGRLU3laVzd2YmRNWnQ2SGFz?=
 =?utf-8?B?RlIzZ2ZFdGhtOTZXL1dEcXpyNWl6eGJlM0UyVEh3Vk5aVXNXaFZxN2N1aUVq?=
 =?utf-8?B?MHNsa3UwRVlzZUpvc1dHMlJkZzhlMWRvZ2VMZ0s2OWpDYWVCNGdlV2hSR21y?=
 =?utf-8?B?dWZMRlJZREovNUxlcnVRbDFGd2VIYlFaaXQ1SzZPWXM1Q0xQY1VRV1VnV2ZR?=
 =?utf-8?B?NUNCV2c4bkxUUVB0QlZNWUp2ZEZIbktqYW91NkFPcTBBQWYwelRMSDBJUlA2?=
 =?utf-8?B?Mk5LRENlaWY4Y0lhcmJlSVpxdFBvZ0l4YTdoUWRObDJxdllxOE84UjdhVkxi?=
 =?utf-8?B?b0dsUDlSNDRqRWx2d0k4anRZU1p1cTlUMU01SkE0Nk9pNkdEdVhtV2FHMHhx?=
 =?utf-8?B?SW4yMEpCU3BicTlURUZXcFAreS9zYlVNT1JiRllNcStNVjdRWm5ONTkzOVYy?=
 =?utf-8?B?MERRTjBRc0dUSDJXSjErUWVwa25neHkxb0ozd2EyWnJTRjdVRzgvQ3F1RGE3?=
 =?utf-8?B?bHNndm9LalkvNDJKVjFXQkRGSU5wYzJ2NzNpYktVNThSemZvYXFuWDgrcGJH?=
 =?utf-8?B?Q1J5blRxWE5uYkJCZnZaZ1huREt5eFVWaTlEdWhHcm1FMmhDcUl4YitVdW11?=
 =?utf-8?B?K1F6bUJhQ1VCZ3RWMUR4UTZteC9FeXFsV2xNUkYwTUIwMlhKQ2p1ZnlXemR1?=
 =?utf-8?B?UUY4bE1CUlRmTkU2Rm9UZXNiaCtQOTZIU0VjM0xKMnZvM1YzN214bTNnQUx2?=
 =?utf-8?B?VlNGcHJzM0d2dFNtYkhkd1Yrd0xiMzNZUDlBam53VEpZOFFLWGZQdDRrTVk4?=
 =?utf-8?B?WFpTV293dTdHaTlpd0VTWG1hZHRwY2JkVHdLcEFLdldDYUtnL1NmdjZyOXI2?=
 =?utf-8?B?YnNxZDYvZ1RCU0REQ0x3dmp3bVJiRXlNQ0tSWk1hR1NPV2VXT1JIcjZwaDZY?=
 =?utf-8?B?UFAycWs0Y0liOFEyVCt1UldTWmdTcGQ1NkRmUUtodVV2TGkzYWlQa2JmcStG?=
 =?utf-8?B?c1VnSVZxT2YvcTBoU05FVVMvNTJ3NS91MExqb3ZLenhSS2ZjUURHS05GTG1H?=
 =?utf-8?Q?0TZW9KNWVriU2VhbMLH76GY=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MlNUMDNjMWZhT1M5RzlPalg4TnBuSCtXK2trclJEWXdGOFQrQm9JRisrYlpC?=
 =?utf-8?B?VFNSOEJveWRPVithWTR4YWdEOFdyV29kc3hTL2ZBTXh4Tnk3eTlrWTAvUDJm?=
 =?utf-8?B?UkFHcHpyeXpkdVBSWEdDK3dqdkhCUXdZRDU3czR1bGpybFRoeFlRa3BvQ3lU?=
 =?utf-8?B?amU5djNlNDNJYjJ6ZEtuR2F0blprOEIrTitmSlNlL0ZUclNMd2N6ZnFhaHRl?=
 =?utf-8?B?K3FpMG1qV3ZqbldBSXNYWFIzU0FWSElrU3Q3enk3MnY0YnpndnkzU3hZTXEw?=
 =?utf-8?B?dmI2UGxhOUxOb3Q3L3diWGhWUE1yL1RRVGpETTdaMWNrYzRrUVBBR1E1RFRq?=
 =?utf-8?B?TXMyNnF3aTMvMmcrU0dySlpFS2FHVWFsOFdkbFBPcTRYbkk4cXFteXRrK0c0?=
 =?utf-8?B?MDVSMC9KakZTNmVRVW9ON2NOeUtyQmpCS0lSWmJCTUNKL21aVUQ5MXE5d091?=
 =?utf-8?B?UTF3ZG43UU53eHRHZ2dzQlBpVjV5MXN4TzZXQ0NTR2hjNElIZmUrdVo3dUlu?=
 =?utf-8?B?YUJUR0ViNGtWT3BZOTJ2TXhGVWtOTVpMN3Z5bXR4M2NQWHovdWpVS0lhbDVF?=
 =?utf-8?B?ZGUxWUdtN0M3U0YxVmRUa0hsUzZoL1ZHYjlVNlhqTGowbXN4V0xNcmJZT0Z0?=
 =?utf-8?B?bjlaTVlrdy9Oai85bnh0dERveWJPZ1RqMnlrc3owWmtEKzRmNENaR2EwTlRj?=
 =?utf-8?B?WExCR0p1bW1WcnpLckRmUlVhWFlmQXUvKzVKWWJsN2hRRVVmMll2Z1l2TFJV?=
 =?utf-8?B?blMzTjZlWTRQcjBEVml3NkJQb2hVOGxjRmFVbUd4K3VCU3UwTG1wRS9CeTJR?=
 =?utf-8?B?Z0FieTJzajkyZUNYb1B5KytLMENicjJlOUNYOVcxK3BpOTVvaDZvdCtJeXNO?=
 =?utf-8?B?YXNmM0JDUWg3OFFEUkVGRDMrUkV4Q09Oa25hWDR2djRmemdQckxsWjF3Zlh5?=
 =?utf-8?B?eWpZL1Rwa1RQc1gyQ0graGw5UlEwNnlMWjBmZjhiOGFhRm0rTUR3bUNMY0tZ?=
 =?utf-8?B?WVhvcEo3eVdSaDR5aHp6N3I2M3NGKzM4WmtxZ2x4WU84NmhrWk14S0JPMUpW?=
 =?utf-8?B?b2RJcTB0U0dIZ1ZJdzFjSWV1MGs5MXdPSG9JaTJEaTZLZnVIZ0xtVEVlVVYr?=
 =?utf-8?B?SE5pMXNOaUxqTmhxOXdkTFM5UTg3R0pZUjhkQ3hOQWlUb0pYZk0rc1JGK0g1?=
 =?utf-8?B?T25YS0JVR2dhYjNMSTc4QzdkYUlVQ1prMGZHVEw4emk0b0lQTEVERkh1aG94?=
 =?utf-8?B?YmdJODdIZWZhYzlLTWxPRGQ5MU84cnp0NE9FZXpqSEhzU09lam5sTFU3WDFm?=
 =?utf-8?B?bmlWUmJuS2RkbTVIak9wanRUN3ZXc3hndG1lOVd6NnFZekFwS0EyRnBoSkhJ?=
 =?utf-8?B?VnAzVWJJamkwWTQ1b3dQbmg5eWt4UFBBUWRha2s5Z2s5YkRrblY0WkFxd25h?=
 =?utf-8?B?Y09aNEZVczhDcWtKVk1GSlpEQ0JtZ0IzMC9PSitrV1RZR2JRbXI1c2FIcmdk?=
 =?utf-8?B?OFhSdUZsQVlGVW5EZkFINmZ6UFIybmoySjJQTlJxbCtMS1BtRVE2Q0h2VXJ4?=
 =?utf-8?B?VllLOVFlVVphVlYzcG56V0VKanR3dFErTEdVeDNONHUyNzNVcXZDaWNqb0F1?=
 =?utf-8?B?d1p3S0U0NkU1YjhORFViajZKRE9rSDh4ekNDeCtQQlRRV0dZOWZUSnlsYkpu?=
 =?utf-8?B?NXNheU5zS1VvNnBhL0ZoZENpT0paNWZyN3BLWEVoRTFpNUE0blRCQXprd3dl?=
 =?utf-8?B?bUk0d1pxTTRjUUxvbG4vNURvQ3FBMzZMZVJJeFJLSWMrcUZILzBvV0hxTmtR?=
 =?utf-8?B?eU5FQko2RFJjSUpaQnU5NVBQZld0VTBncUlmeTZ5aml3OXpNSVMvTDZTOGtD?=
 =?utf-8?B?Wjg4MjMwdmJvaFpNYnJUK1dyR0pzbXYxS0VJazVwUU1PYkwrZ3BKenBBbDBn?=
 =?utf-8?B?Szd3bGpTNkxkNExKZVJub0xyRy9MelRrL3VmS3NieWRJazA4VktpdXprVTh2?=
 =?utf-8?B?UjFpTFVrOVpFQUJVVlpSVmV6OHpvUnd2bTNBWE5qeHBxaVpQOHYwaWZJS0Nu?=
 =?utf-8?B?THlRUnhaWncvUXRTWWduRC9wWUlseG9JQ1gzYTMyL0pQK2hSSno4S3NZVlNX?=
 =?utf-8?B?QU5PMEVwQlVqeTBNZ3o4Z2VhV2N3YXlxQTBHMDJMb21oZHY5cC9uVGxLN00r?=
 =?utf-8?B?NC8vYk9hUWtjT2VZR0RyNG1Tb1dBNlNHcVRwY0JHWjJQSGErT1FkNUJNbzEv?=
 =?utf-8?B?YXFZclB6SHFVNnVuQkVIZktEUnc2bFdmMXpWdXcxWUhFa2t3ZkVzdjExYzFy?=
 =?utf-8?B?a2d4WktpcFoyRFNzVUFacG5mbGJTSy9PdTM0SVdzbm95NnN4dU5aQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6BADBCF1B306F44D92A83A422409818C@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	b1SVxiBMzEON12FeBSZjYAWbzhjPKOVuyFEY+MsvMI1EWas7V0F+fH/hGQLEhte4F5AD9gt2JHmnGiddk/MlLImMx6rgJn2IrptXgeXiSLOltkrr6ziKMg2w/JO6o3R8lLKBYx3eG7v8gnE8O7H2826w4lFAcEOxXjrI69omlusQsly5YBKJ0NCmAul92KATe4EKMJw2L8EjBfDc6FJCMNxOAsVQbBIh8FFvQXwa/dKvJ9Yonbm8wgnxxqUc1IyNKpF+zOR7KNIDJq1RKmRAnavDg3DGQxmQU22sm3TBIzxIOjl4KXZRLiCEhidZmSuJb/WaleqLMZdxzNkz8h8T9MBn/6QvtO22vkS6Qe+e+p3ak36+nGxYaHSRbqge/4Vj7J8Kukawd1oprVp+EegNrCU4bfxOT7RWqIqv1SRgYQfOy+0rC4w31ljovS1758mRyqqYuSuqIm4b2/Qt7HSqK8VGToVQ/dd/P29Oucrx0YV0oEB3we7aRAYHsREN1YwIp/UOfD+AXMTiDv1bxIsGnyAOeN/zo5yojkMrHB1nb3b400ExASXlf/U+5thYYHXZrrTMZ0S/HKL1mxsYHYeXEx6k7t2yL92hT2uk2dRto2UBKWh8z5HRqPwD179xPvuw
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3209cbdc-83c4-4992-3dd3-08de5e652957
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2026 12:02:51.0844
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u5oWjbezP+lolBV+msgG4yFTat7A7IttrTXo/qbGktIwZDUkvXFVJe5Kx3S+Qj+xLdrf+cu8RjRurz2Tgca2Wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR04MB8642

T24gMjcvMDEvMjAyNiAxNjoxMCwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IHhmc196b25l
X2djX3NwYWNlX2F2YWlsYWJsZSBvbmx5IGhhcyBvbmUgY2FsbGVyIGxlZnQsIHNvIGZvbGQgaXQg
aW50bw0KPiB0aGF0LiAgUmVvcmRlciB0aGUgY2hlY2tzIHNvIHRoYXQgdGhlIGNoZWFwZXIgc2Ny
YXRjaF9hdmFpbGFibGUgY2hlY2sNCj4gaXMgZG9uZSBmaXJzdC4NCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiAtLS0NCj4gIGZzL3hmcy94ZnNf
em9uZV9nYy5jIHwgMjEgKysrKysrKy0tLS0tLS0tLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwg
NyBpbnNlcnRpb25zKCspLCAxNCBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9mcy94
ZnMveGZzX3pvbmVfZ2MuYyBiL2ZzL3hmcy94ZnNfem9uZV9nYy5jDQo+IGluZGV4IDhjMDhlNTUx
OWJmZi4uN2JkYzUwNDNjYzFhIDEwMDY0NA0KPiAtLS0gYS9mcy94ZnMveGZzX3pvbmVfZ2MuYw0K
PiArKysgYi9mcy94ZnMveGZzX3pvbmVfZ2MuYw0KPiBAQCAtNTc4LDE5ICs1NzgsNiBAQCB4ZnNf
em9uZV9nY19lbnN1cmVfdGFyZ2V0KA0KPiAgCXJldHVybiBvejsNCj4gIH0NCj4gIA0KPiAtc3Rh
dGljIGJvb2wNCj4gLXhmc196b25lX2djX3NwYWNlX2F2YWlsYWJsZSgNCj4gLQlzdHJ1Y3QgeGZz
X3pvbmVfZ2NfZGF0YQkqZGF0YSkNCj4gLXsNCj4gLQlzdHJ1Y3QgeGZzX29wZW5fem9uZQkqb3o7
DQo+IC0NCj4gLQlveiA9IHhmc196b25lX2djX2Vuc3VyZV90YXJnZXQoZGF0YS0+bXApOw0KPiAt
CWlmICghb3opDQo+IC0JCXJldHVybiBmYWxzZTsNCj4gLQlyZXR1cm4gb3otPm96X2FsbG9jYXRl
ZCA8IHJ0Z19ibG9ja3Mob3otPm96X3J0ZykgJiYNCj4gLQkJZGF0YS0+c2NyYXRjaF9hdmFpbGFi
bGU7DQo+IC19DQo+IC0NCj4gIHN0YXRpYyB2b2lkDQo+ICB4ZnNfem9uZV9nY19lbmRfaW8oDQo+
ICAJc3RydWN0IGJpbwkJKmJpbykNCj4gQEAgLTk4OSw5ICs5NzYsMTUgQEAgc3RhdGljIGJvb2wN
Cj4gIHhmc196b25lX2djX3Nob3VsZF9zdGFydF9uZXdfd29yaygNCj4gIAlzdHJ1Y3QgeGZzX3pv
bmVfZ2NfZGF0YQkqZGF0YSkNCj4gIHsNCj4gKwlzdHJ1Y3QgeGZzX29wZW5fem9uZQkqb3o7DQo+
ICsNCj4gIAlpZiAoeGZzX2lzX3NodXRkb3duKGRhdGEtPm1wKSkNCj4gIAkJcmV0dXJuIGZhbHNl
Ow0KPiAtCWlmICgheGZzX3pvbmVfZ2Nfc3BhY2VfYXZhaWxhYmxlKGRhdGEpKQ0KPiArCWlmICgh
ZGF0YS0+c2NyYXRjaF9hdmFpbGFibGUpDQo+ICsJCXJldHVybiBmYWxzZTsNCj4gKw0KPiArCW96
ID0geGZzX3pvbmVfZ2NfZW5zdXJlX3RhcmdldChkYXRhLT5tcCk7DQo+ICsJaWYgKCFveiB8fCBv
ei0+b3pfYWxsb2NhdGVkID09IHJ0Z19ibG9ja3Mob3otPm96X3J0ZykpDQo+ICAJCXJldHVybiBm
YWxzZTsNCj4gIA0KPiAgCWlmICghZGF0YS0+aXRlci52aWN0aW1fcnRnKSB7DQoNCkxvb2tzIGdv
b2QsDQoNClJldmlld2VkLWJ5OiBIYW5zIEhvbG1iZXJnIDxoYW5zLmhvbG1iZXJnQHdkYy5jb20+
DQo=
