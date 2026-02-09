Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208F129B77C;
	Mon,  9 Feb 2026 07:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770620673; cv=fail; b=WLhvLCmTfVMbycWzcMZiOG98796zB6B6gXkXQNqf1NNjdlmFpt4pd0eEGY1M8RT/elIpMm50QFo9V23009ND1NuG8Deio+0bmaUr7yIWjixejhRvcGbWg9Xe3PpsfVJYVKIwsOGR6XNvOS0ffFpNZ/tKuYWBY/tS1xAEt2TTWhE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770620673; c=relaxed/simple;
	bh=giLiGzKzFEr64GMhpTfxawaJketZn32QSGlG9ndly20=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Rb9yd2P03VsTXbJwFVPkepCOTcbkwtYzL0CWeUj622WnQsWCDQ6l2q0tSy9II6GnFu4dJRIsHE5FLKz/OwLIRgw6DCgOOREC66nvvYkPBGkQPJg07/QyuqdmKHpqtn/uhfZUxwde3AasEVrDnKNm90PFOd/jvI/Vbssgb1z2it0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=EjviJjL/; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=t4ipjahz; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="EjviJjL/";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="t4ipjahz"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1770620672; x=1802156672;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=giLiGzKzFEr64GMhpTfxawaJketZn32QSGlG9ndly20=;
  b=EjviJjL/54sQvGzrIDs8zwoH0+a8RecStvaWrqqPCM4wN/3uybkIFuDO
   L5wpa2qfo20HJYH2JXt26wxht36LncJo07FvbaKbOmvaq0XpHBqkUx7Cq
   CZyIeZHefdW8N2+yymXUUHnvDFw6R05FxnN3bBpVbn3svZWChJKXQOZb+
   IJQsAwxWqlXw7riq3oywkvGo2XQAzO7X25M/Mb80hEl/RzKVPIm/0bc2n
   n9MnwaaRcsne6/oyA4ZJn7WC6XT24xZuEdqWEmXlGtj/3IorzT4x4MCab
   V5SLBhXdq96lxSEwtaBOFKanREjCIu+A/Okk6rVvtzZrdqQ3Co4kcgzE8
   Q==;
X-CSE-ConnectionGUID: iCptni1RRcuiHnlxJriDTg==
X-CSE-MsgGUID: fFRZwLfJSJuO2M3YC8fm2A==
X-IronPort-AV: E=Sophos;i="6.21,281,1763395200"; 
   d="scan'208";a="140040575"
Received: from mail-northcentralusazon11013009.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.9])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Feb 2026 15:04:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ceHeRm5DepqIJZlNTWfRTaoXEEmy7TzhZ6vcHO++fy0Ugql0topBExDdWc/O56thd8ONcua2jJTkChOMyGJYUorrYQqC3eC8TETIdv2da2xkH1hOdqDLFY8s7zDu+UemikG7IZZA+sFRPBB22Pr7+Px8X7fREHpQrNfmmRaibo4/R0kyp3FmT/A2+1NHyJRbC3DJu271ymXoe4EhRn+UaFIOd+VdriiOGFxja8iq2MPvndqUtrTucdomwpy9lZbsST976VxjUV4xaqxpk2k6n8MdqAn5+3Xkf57irqw2rT7OspvGpFfsj7tRxpJfO/kbGswzfRdbJ9SaQ6qNDgVdyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=giLiGzKzFEr64GMhpTfxawaJketZn32QSGlG9ndly20=;
 b=Q6NXtwhqvhRFMXZE3bc0TS6ZUFvyuY9GhVivB7a6KinVv15D3vINALJpX5mBy8ijJm2DmmNmNNQf8Sd3jOHOi367DJzEVTv36uy3TcJ5csjlNDlhTB9pV1sjDsUWTT68akRCMnGUuXGW9Sr5LDiC14qL1arc+XQUbd8dtZN4a1tZhfu0gavcC65r2cCfVEKg1AqAp/6cApEIiUVitg+p1s1AKkEKkx7uhZFdbP/xHf2f5TmPjqJyAF6EVOpuBbTE/eJhHl/27dYKaW9aS68USdHxCMpFCTplzrKkGazan/jbIV09REIeN9uifdB0BmiCv6Yv+6yuHmbBTcmH2NxY3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=giLiGzKzFEr64GMhpTfxawaJketZn32QSGlG9ndly20=;
 b=t4ipjahzwvZ6IdtHpKqlKZZp5UihiBmsJBWG7+k0wvfRftxFnRQDrPDSwYVHGrl404EyPrSyNlGVA3YRapK0XGG0jxbGfunaZD+Wel6iFJ8IxfKtWpalR3fqZtU/oWxPj22nbdLS8W6FV3WgSEcRsdcy3DgkBum4cc/KWgGtup4=
Received: from SA1PR04MB8303.namprd04.prod.outlook.com (2603:10b6:806:1e4::17)
 by PH0PR04MB7448.namprd04.prod.outlook.com (2603:10b6:510:b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.3; Mon, 9 Feb
 2026 07:04:23 +0000
Received: from SA1PR04MB8303.namprd04.prod.outlook.com
 ([fe80::8719:e407:70e:f9e1]) by SA1PR04MB8303.namprd04.prod.outlook.com
 ([fe80::8719:e407:70e:f9e1%5]) with mapi id 15.20.9611.006; Mon, 9 Feb 2026
 07:04:23 +0000
From: Wilfred Mallawa <wilfred.mallawa@wdc.com>
To: hch <hch@lst.de>
CC: "djwong@kernel.org" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "cem@kernel.org" <cem@kernel.org>
Subject: Re: [PATCH] xfs: add static size checks for structures in xfs_fs.h
Thread-Topic: [PATCH] xfs: add static size checks for structures in xfs_fs.h
Thread-Index: AQHclxW65B7KzMvbt0CIJI16Abrfu7V1L7yAgATGuYA=
Date: Mon, 9 Feb 2026 07:04:22 +0000
Message-ID: <41ea75676ea983281368c449647599aad9551d1b.camel@wdc.com>
References: <20260206030557.1201204-2-wilfred.opensource@gmail.com>
	 <20260206060803.GA25214@lst.de>
In-Reply-To: <20260206060803.GA25214@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR04MB8303:EE_|PH0PR04MB7448:EE_
x-ms-office365-filtering-correlation-id: ac02070d-e063-408e-1893-08de67a97435
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|19092799006|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?MkhmQWo0NnlWMWN1ZTVNUDFwc2lacXBaMHNic2pOcjV3SStUb0N2bUI0S1Ix?=
 =?utf-8?B?NDF6elY1SXNYMWZNczM2UGs1REtDY0pOaUN4ek1McXgwNnpIU2Fxc0ZUN2ZY?=
 =?utf-8?B?WlMxQ3pQZG43aVpTcEdIUXpMbTRCV29GWHQ4MnJkRTM1SFdqUVZvQkdjdXNa?=
 =?utf-8?B?YXozM1JYRTBJTTdhZGl3NmhrMWxxVVVjV3E5TGpnSzBMOVY3MzVuMVNDV09l?=
 =?utf-8?B?bnk0Q1VuWTN0WkVVWmt1U1JvTlpjRldVbEFYTXVMWEYvdHpweS9KQktrWlIr?=
 =?utf-8?B?aG53UWJudHNFSjNvMW96c1VKNTBoaU5OeG1lWFkrRUpYM1dHcFJaK1diL0hR?=
 =?utf-8?B?ekNETU1nRjFxRGZ1bXBUSlFtMnpyYVRqSUFkV2d5NTFIdFFyZThZVyt1Nk0z?=
 =?utf-8?B?Q09FblpuKzBIOVp6bmdaQnp5MEtRVU9kZE40SGNLbXNkTm1wUElpcTlMMld4?=
 =?utf-8?B?Z2pDZkQzbWtJN3NJQTFmc0xhL2IrekNHb2h1TUpDZDBuR1RaOVJsNkVIekM4?=
 =?utf-8?B?K0c4NjZJeFlKTnhvMVlSdzV6KzR0SmZQaDdzL3o4WTVNWkg0cy9SSVdFZkFT?=
 =?utf-8?B?SjZmV1llT2xQTzR6cDVzQW1TbW1xaUorTm5qZHNxcFNSd3dPY1A5UkJieHNh?=
 =?utf-8?B?bTVJMTQwTWxPVDNEbm1uVlpWTDV6NWpmV2pWZk91MHVpWW1ZMDJQU2ZjcGJt?=
 =?utf-8?B?Y0NDNnYway9jOHhRZC9KejN5a3RXajNUTTBkdHpveFE1YWpvWVRKT3krS0tR?=
 =?utf-8?B?OGNXME5LTUoyMitBMlUxYWRoRW03bERPcTFIZXUyVHkwZDViQUVBa1NMbjFS?=
 =?utf-8?B?LzJhVmZQUVBoV1FNZ01zaFcyV3hPa2JTTEdXdk11S2pjamgxNWJQaHlPQ2RT?=
 =?utf-8?B?V2hXUXR6VHNlKzhWZVFpTHlWUXUrNHQrWjJEdVJRb0p1RW5qTWl2anNRRFl5?=
 =?utf-8?B?Tm44VHI5MnNodUR6RjB3clkvdjhNZ3pzbmJwVkF1YUliU2ZOSEtUS1ZGQWw2?=
 =?utf-8?B?ejVNYjlRdDlhbVNKWjlpSGVMZjFuT1kzL3FzbndNQ2sxZDVxUC9hY2RwaW8z?=
 =?utf-8?B?bkN1b24ySXo4K0laYXhiT3BzR0dxQW5KVE1jRTFJYzA5YXk0Wjhrbit4amJW?=
 =?utf-8?B?TmlQcmVMNXRJd0liVTlNa016bzdiMGVhbU5wc0FMYlpyWGRKZzZjaTMrRWgz?=
 =?utf-8?B?ZWZid21oNCt2bGQ5ekZLSG5HQ1FDcldoQ213ZWdRcjE1eVd0QjNSTlAyN1dT?=
 =?utf-8?B?WWFXa2dWVWd0SmRXNFZGbFR2MWFsS290M3FicHpwaGk4bGVIV1NlTFRhek92?=
 =?utf-8?B?Yjgvc2JORjJCWnhhMHpqSzc3VFJFK2xQZ25iUzMrTFcwa01KdFVTeERMT3BH?=
 =?utf-8?B?WjNkQm8yd1NTQm02SHNROTZ6bWg1dUdHclRTc1k2dVF2ejAxNVlkQ25ueEFP?=
 =?utf-8?B?NTlIRXFIcnBzbUk5RjFFbkpXSFVIN2ZCYkIrTTdLeUhlTXBxUzdXbjRLR283?=
 =?utf-8?B?SHk4QUs5enFPYytqKzhuR0VLLzhiL0xmMi9EbW4yYk8zcVU5dTVOWlI5eUlY?=
 =?utf-8?B?dDlZRjh0Q0YxaGdNaEdpckVwZEJDR2prWUFlZ3R1OGppT2p5ZnZ2cmkrQ0Fn?=
 =?utf-8?B?bk1TalVqSDBPRGkxb0VtMytna28wUmQvdU95SVVhSUJncEhLdkV2bWd6UE1S?=
 =?utf-8?B?OUJxL202Vm9LUDVqRm9NOVdQQmoydmFoaFJBYUR4Z0RCMFVUUHZ1Q1BXUzB3?=
 =?utf-8?B?ZWJoa2svM24vU1NkVjdteUNRWk0xZmRMMndnVXRHZ1FONi9PYkdGYUpDbHR4?=
 =?utf-8?B?RmxsZndzL1NyMllRR3h6alVBZHljMTZKbzZTUk15dmsyWXlacWwyMUU2ZXo0?=
 =?utf-8?B?aTZFZTA4Q2VsY2VWZzFLZmdReURiUnA5NWgzaGRpTWo0RGNRbEdWVjJ3U3lI?=
 =?utf-8?B?U2ZkWjhxbDBqOE4wc0h3NnVkRU1XeVhZRGYzL2ppaDMrdU8yTVVjRGtyZGdW?=
 =?utf-8?B?Y1M0L3N4RW04QzZiYWpoYkVnVmRSanZrUTNWSmVrNlhMVlhzaW1pc1dFNEJ3?=
 =?utf-8?B?dUc3anI1MkhLOUVnRDJzU3RNRUJ3TmlWMFhHSGN6VnJmSXJOUTdGZWpscGVG?=
 =?utf-8?B?dVQwNlRtOWc4dW1UWEgyaFg1ZGFtbmh4ZlV3Vy82dUpoaEtmSXZZc09PWXp0?=
 =?utf-8?Q?H9MYrFJJ9thGlqxbbzA9sQ8=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR04MB8303.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(19092799006)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?elhCZjFRWWRYOGNjNUxvZ3Nwc3NVMEpSR2ZNVDJqZDhTTjRKa2JERENrRVRs?=
 =?utf-8?B?dENzVHFoSmVVNG95VW11UnVnMUp2S2xMRHlkS2tQOGZ0Q3FKUk5uelkxbVlz?=
 =?utf-8?B?SEJRUnhLS0gzRmhIWDNwWlk3WFRiTVlPcFF0bnc3NmliSGxPOWZaV21DVVhz?=
 =?utf-8?B?Q2djTlVoZDlZUEJIYWhySW9tVjJWWUhWVk8wYzhNVC9xb1FvTVI3cG9aeTdY?=
 =?utf-8?B?U1NWZTZmWXFDRHdhaGxVV01PVlMwNkIzS3dPSFRNQXVwT09wc3FYZlNCQndL?=
 =?utf-8?B?ZkJzZWVieFZUenMwNWwybnVSaFp6UXBmdjJSR3M0NVorajdPb0tjdXNvRTU0?=
 =?utf-8?B?UThPNWUzWENYQklhaHZESnRocjkzTDduNmtZSVdPVjM4TXpzRlVmM1lydjdL?=
 =?utf-8?B?SUhtMktJejYwbWhlbmRhRUhsNUdWeVhIajNxdnJEelc4RmNpdytNMU54R0NH?=
 =?utf-8?B?ZUZ3V0VIOGxyQWJpMzg5dWsyVXJobWxZOENCYzBCL3VzUFNlQ0JRT3FNbzlX?=
 =?utf-8?B?czV1d3VMMmxZT0ZRRzN5Zm9zYXhJZDRSVGR5eUhpcHdROE9FOXpEZUdnclZ0?=
 =?utf-8?B?NXhySjhWRVpmUGhaT3Q0L1BIdXAvVnVBNWpib3EyV1h0U205ZjVCZFZIdkhu?=
 =?utf-8?B?cTlabStXYktoc29IVGRNWEpTQlNmN0d5WkMxa0E1UDU4UE9HTGFuU24xTmY0?=
 =?utf-8?B?NDN2Y2tyNW5jMnpUMjhRRXJIUCtiMTBJMEcxU2JQSmM4WXhpYjNGaUg2bVFO?=
 =?utf-8?B?WmVDaGdFcW5WYXJvZGdpbitFK3BnSjhiYjUzRUlNRDdjNlN0VlRybmFHemll?=
 =?utf-8?B?OGt0RUEvdzN4c013bVM0RHcxTVQ2V3JKSENXZ25UTUF2K1B0WXU5eXFmT1Nl?=
 =?utf-8?B?TjZSeEQzKzJRWmVWaTByVThhenorYS9wOGFYUUsyRTEyKzIwa3N6aDhNVFY1?=
 =?utf-8?B?VWRmUjFyNDF5dE8rZVBmWDEzVEV5RTJLaU5hNVRzK3ppSGxCZlc1VkJ6RzFO?=
 =?utf-8?B?azd1NkVRYmcvWm1uZm8wdWU0bnE3N3dpdUk3YzVpaHppNk9ES0U3OUxYUjRk?=
 =?utf-8?B?Sk1TVmlvSmVFWkduR1pnRnpzZ1hNWk1qMlNyNStGQkF1N0lLeVV3UGp1TUtk?=
 =?utf-8?B?azY1dzJEQ2pXd2NJeHZLTEFCRzZEZW1hbklsVXNQVGgwSGJKRyttZlUxSm5Z?=
 =?utf-8?B?dWhxT0NhWlNJSlhFT0dwa0xXdkNRQXpCQTUrTzFoNVljYXA4UTlTU3FqQjhM?=
 =?utf-8?B?QUN3d0VZWDY4SlhNODl5Slk5RzcxZ2xIK25jYkRDdmV5VHo3OUphTEViS3Rj?=
 =?utf-8?B?Y1VMdTJhcFpLMkFWVG1mZ2xKYVduUkpBN21aWElkTjFONGJPSGhaSmxYZEFB?=
 =?utf-8?B?SjJxQ0wwTGNFaWR4bGhNNm9kQjFqd0wvbjlmNlRFMUpWZ2MyQkhGSjlkd2ZG?=
 =?utf-8?B?aFloc1ZWQUVpV250enFicVRwcVhMeU9DRzhVcE1vUW56Zm51cDMzVDY5SXpM?=
 =?utf-8?B?ZHVXcXI1eWpoYldIUU1ZOFVsM3RLekdCaWIxL3R4bGMvekxoZ0F5dlZjWnB1?=
 =?utf-8?B?M3JCd2RnQlQrakxEUWVST2UvajZsdlNlVlVRbXRVdEdLSnRZdTBhL2xvUWcw?=
 =?utf-8?B?QTMvMmJKcXBvSncyL1ZXM0pUdmdRaVhWUlZlU1V1ZzFIS0NnWWc4d2ovZDNl?=
 =?utf-8?B?T3I0dS9wVG9WSmdIK3hoNytjL21HUDg0Tk1BcWZSTnJPNWNyeVVOVVd6aEMv?=
 =?utf-8?B?aTY2Sm04bkVWcGhubmRLcHBSUzI4Tk5KOHhjRkNoMkJMcmFDYzFCa2JNdW5j?=
 =?utf-8?B?Yjdra1Rhb2ZsTkZBZFBrZ0UvUnlMSjVCeTJjbHRIY0U4aDlLejRsRFg0SC9k?=
 =?utf-8?B?bXRzWmsxNnJkTjA1VmNER0dSS2RZeGUzaks0SVkwQkQ5SG16bFF5bWN2UzlR?=
 =?utf-8?B?QlduNVprOFFoVElrV2tMbFJydkx4QTdTRklPL1JuWFVTMWZnN3VKMW90UmRx?=
 =?utf-8?B?akZaelR6Mnd5aWp3OFpCajVOZmtDQ1dNYm9ib2VGRW84QmxoQjFDQTEzcE9t?=
 =?utf-8?B?R25nRmluNnpSbGVKVzZKSEp4NlZyR2c4UnRxNkYrNkZreVRmRTMvdnlHMXFY?=
 =?utf-8?B?cStxRm91akZvN0JtOUx3eWdXVzlNMkRObUQxeEIwN2FUSHVzOFJ0L094UXBI?=
 =?utf-8?B?eG1WcEp4RFFZTjFjcTVuMGhZeWJBK0FiamcrS1NxYThOWm5pM2ZhL2pVZW5F?=
 =?utf-8?B?RnVPSm4vVk1YZGU3djFyV29qY21GTjBxMWdwSjFkV3dLMEVKNjJYdGw1eWkv?=
 =?utf-8?B?NFhLN3ptWmZiK1BNZVVQMlgxRXVlbTZIWjQyOUc2cFNITUdLSGl5d2JpMFdE?=
 =?utf-8?Q?PXzUhSqIfVgZFH4c=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F2D0756A2484354DA7D8A2459038A5ED@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	h0MUgKhN3iFHw5Gom9oF79J2I2DRGwnT6P4e67fSsITiRNVE0jjMJh6LXtIcrxKs4Gn750DG13M8KvsNnrUZxuf0taFDvLoSpLZ6XCobOYLRy7krbkoFOQXJyyQiGv9ZHNJqdh2ILlyYs3PFXZk08uEB6JLAJ817Q7EYwOpQWFLo9ub14i8etW/WnPYHRdpN+RWMZJqBaNDHlIzu3+VsurxEqV0qDhYcbcoXJEZd9n4QKa9VKYDIdz0JlZhcf3TFZq9n35aoaYbQ0AN6jikX52hK+xadGya8+Esk7FN7FSPTftPQQRlMjfapq+M5AtkWRptd4NFreVkW4WcHCM8IpHSnnnycEjVwv/xpKrRugXNUUkmToAKmoCXHUML+1ZDjhezzWK5X2uTj0mXb33ujDvOap/ytqymGDdmq4nMFvG9XKpPzSMybqnoUkHapk6BI4Cdn1ECvnzsxvKUclEK6zl2LTStVTgqHeCka6q11CgsAS8KIngzNwH6XgY3L+1r4chQ/XYs3W6wZjun3Rhttby2Sd6daSr9Spift6iIglr9lNTT04XK0GUVTzcdROZY2aIvDQej/WIj2Lxim33O75xAwQvDIiTsbH1dItsUtBkAwN+6YTZ9qDhKYVjXmFSwr
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR04MB8303.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac02070d-e063-408e-1893-08de67a97435
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2026 07:04:22.9788
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1Hz62zs/C6KMIii+x+9DhdPQKh8Q4nAyspJljp1iszC9T1Ksl78/AcrUvE7ETuPR47tW92NeR0j5HoVfo49N3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7448

T24gRnJpLCAyMDI2LTAyLTA2IGF0IDA3OjA4ICswMTAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToNCj4gT24gRnJpLCBGZWIgMDYsIDIwMjYgYXQgMDE6MDU6NThQTSArMTAwMCwgV2lsZnJlZCBN
YWxsYXdhIHdyb3RlOg0KPiA+IEZyb206IFdpbGZyZWQgTWFsbGF3YSA8d2lsZnJlZC5tYWxsYXdh
QHdkYy5jb20+DQo+ID4gDQo+ID4gVGhpcyBwYXRjaCBhZGRzIHN0YXRpYyBzaXplIGNoZWNrcyBm
b3IgdGhlIHN0cnVjdHVyZXMgaW4NCj4gPiBsaWJ4ZnMveGZzX2ZzLmguDQo+IA0KPiBUaGF0J3Mg
dmVyeSB1c2VmdWwsIGFzIGFkZGluZyBuZXcgZmllbGRzIGNhbiBtZXNzIHRoZW0gdXAsIHRoYW5r
cyENCj4gDQo+IE5pdCBvbiB0aGUgY29tbWl0IG1lc3NhZ2U6ICJUaGlzIHBhdGNoIC4uLiIgaXMg
cmVkdW5kYW50IGFuZCBnZXQgc29tZQ0KPiBtYWludGFpbmVycyBlbnJhZ2VkLsKgDQoNCkhhIHRo
YW5rcyBmb3IgdGhlIGhlYWRzIHVwISB3aWxsIGtlZXAgdGhhdCBpbiBtaW5kLg0KDQo+IE1heWJl
IGFsc28gYW1lbmQgdGhpcyBibHVyYiB0byBtZW50aW9uIHdoeSB3ZSB3YW50DQo+IHRoZSBzaXpl
IGNoZWNrczoNCj4gDQo+IEFkZCBzdGF0aWMgc2l6ZSBjaGVja3MgZm9yIHRoZSBpb2N0bCBVQVBJ
IHN0cnVjdHVyZXMgaW4NCj4gbGlieGZzL3hmc19mcy5oLi4NCj4gDQo+ID4gVGhlIHN0cnVjdHVy
ZXMgd2l0aCBhcmNoaXRlY3R1cmUgZGVwZW5kZW50IHNpemUgZm9yDQo+ID4gZmllbGRzIGFyZSBv
bW1pdGVkIGZyb20gdGhpcyBwYXRjaCAoc3VjaCBhcyB4ZnNfYnN0YXQgd2hpY2ggZGVwZW5kcw0K
PiA+IG9uDQo+ID4gX19rZXJuZWxfbG9uZ190KS4NCj4gDQo+IEdvb2QgcG9pbnQuwqAgTWF5YmUg
YWxzbyBhZGQgdGhpcyBhcyBhIGNvbW1lbiBpbiB0aGUgY29kZT8NCg0KQXMgRGF2ZSBtZW50aW9u
ZWQsIEkgZGlkIG5vdCBjb25zaWRlciB0aGUgYWxpZ25tZW50IHJlcXVpcmVtZW50cyBiZWluZw0K
ZGlmZmVyZW50IG9uIDMyYiBmb3IgZXhhbXBsZS4gU28gSSBkaWQgc2VlIHNvbWUgZXJyb3JzIGZv
ciB0aGUNCmZvbGxvd2luZyBzdHJ1Y3RzIGZyb20gdGVzdGJvdDoNCg0KDQp4ZnNfZmxvY2s2NA0K
eGZzX2Zzb3BfZ2VvbV92MQ0KeGZzX2dyb3dmc19kYXRhX3QNCnhmc19ncm93ZnNfcnRfdA0KeGZz
X2lub2dycA0KDQpTbyB3ZSBtYXkgaGF2ZSB0byBvbWl0IHRoZXNlIGFsdG9nZXRoZXI/IEknbSBu
b3Qgc3VyZSBpZiB0aGlzIHBhdGNoDQp3b3VsZCBjYXVzZSBpc3N1ZXMgZm9yIG90aGVyIGNvbmZp
Z3MgdGhlIHRlc3Rib3QgaXNuJ3QgY2F0Y2hpbmc/IEFueQ0KdGhvdWdodHM/DQoNCj4gDQo+ID4g
QWxzbyByZW1vdmUgc29tZSBleGlzdGluZyBkdXBsaWNhdGUgZW50cmllcyBvZg0KPiA+IFhGU19D
SEVDS19TVFJVQ1RfU0laRSgpLg0KPiANCj4gT2gsIGdvb2Qgb24uwqAgVGhpcyBzaG91bGQgcHJv
YmFibHkgYmUgc3BsaXQgaW50byBhIHNlcGFyYXRlDQo+IHBhdGNoLsKgIEknZCBhbHNvIGtlZXAg
dGhlIGZpcnN0IG9jY3VycmVuY2UgYW5kIHJlbW92ZSB0aG9zZSB1bmRlcg0KPiB0aGUgIi8qIG9u
ZGlzayBkaXIvYXR0ciBzdHJ1Y3R1cmVzIGZyb20geGZzLzEyMiAqLyIgbGFiZWwuDQoNCk9rYXkg
dGhhdCBzb3VuZHMgZ29vZCENCg0KUmVnYXJkcywNCldpbGZyZWQNCg0KDQo=
