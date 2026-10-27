Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793140760;
	b=2vHVWXFPCI5T/8G25q2DIP2utF9tlaJIpRfpseOGBPbVg96V2w2AI2wL/HRImh8uy9/o
	 2DTR5hBNGM1obyHwmcl7bj92TzjdsJ4F4IIY0Xnkq+aoLYbdStPn7fD9epdvHAy4Ze/YY
	 lKF663w9EZ99cgvwqc9wEIz3fwPzSny7r1KTgdw7h6PXPGiESDN5VTFWhxQDvyWilf0IR
	 +CiN2w82yhNDnHrwI8Zo3F/BtX3873ApTnQ0C9U4GJcFi8IpH0WppNW7jXc0frza5AuKK
	 K8kmA7aQFVHhWrfPJVt/q5R7XnUlXnmnswSp/U6zWbtZX4p24nIG4sQH9YCJimIWf4g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793140760;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
	 In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
	 X-MS-TNEF-Correlator:x-ms-publictraffictype:
	 x-ms-traffictypediagnostic:x-ms-office365-filtering-correlation-id:
	 wdcipoutbound:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:Content-ID:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=9sIzKTxKWeK3eZyn9rmWBacM3Iyth5qApB7bc+Pqw7s=;
	b=oi+DJET8mL0HX9qn1iK9Qt0NahCo9oPKDnECfdAiDtyERS+r+sS9nsGP8BtkTDo37wrQ
	 1rYSAALDwGLaQrmLql5lTVkcPwAtVBjiibBhX0TvFBdIFM6lYp5HCfcHxjvzV0nFlbh8q
	 nA70LcYbQbkg2sXxF3R3u0JiQpHak2F20Z8qEUD+/ePLvYORAuBfoT06AF9xFPN5/hlmp
	 iXDdBVKmJuOqlwYc85frwL4V7wEtmGCWG8tntFwKtRaRBXLPJkUTEByhynjsGDcymUWW8
	 gDNEfIjxYqTeV0sOMsW5GbyhK4zJyp/A3OBe5zNOBpQdjUSzVSJ32WeND1Ku5TgsNPQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=e8UMNYq2;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=JeC5ApGI;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0969606A324;
	Tue, 27 Oct 2026 22:39:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0969606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=e8UMNYq2;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=JeC5ApGI
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793140753; x=1824676753;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9sIzKTxKWeK3eZyn9rmWBacM3Iyth5qApB7bc+Pqw7s=;
  b=e8UMNYq2WftYg21ZNQ/Bz6nZMqa56FONm1KVgqDb+cWpTPDs4yp/dgt1
   OwJ2f++fKhbTNdWAE5r2oALl8+HHXaOT5B5w+w/AAYrbN7BA83CHjCAYr
   6ksVqk+p+s+fjT5nKJ9opLdA4Wg7Saz/KNfaG4qhtIb8Jmr2Q6v+G3jFW
   tqKL/725KnTT6vZEaZ0yP4YwQwK821YaqA2m0CVjU/8mZcZuPjU4V1/QO
   /2Cpv6p1d1Hz+t3ZNrPF9mtZ/2LlWnX5+qM9iLpOfP242/JRbcFcqnHoT
   wYc8dxeoj+zlk8LGZ9XhiHuj0q+9IVwuJ8GznUf5JVbwpFB8nujsdu3HK
   w==;
X-CSE-ConnectionGUID: kgKUFzUjRKCbrbRrj+pEpw==
X-CSE-MsgGUID: RW+D9m62RPOCfDGf0AvMuw==
X-IronPort-AV: E=Sophos;i="6.27,181,1786982400"; 
   d="scan'208";a="160111147"
Received: from mail-southcentralusazon11012064.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.195.64])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Oct 2026 06:39:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GHajXkAN+WqCv/q6WSa00XAeLU3v5+jzIzH5FYfXdaHTK+153HBmk6+IkXKsxNA87cU8m9yofQrdM6GWw3IZBJWBMg4Av50xHaTmgobXES9Pxej8I5232l6RFFsQIMgyE2AXGcrm38RG/cSBS/PBV+h3Jw3fyFtWHdGMCCvvFe4ax9wVihbhf821fXHHo5KMZiE3xUA0/wmia4Jad3r/2oAL9mpv0Nc8BFnfCTHIwp7Bm0Pp9fr97w0O/UvFMFa9Pc76s9s/0lVKzBCaaL1IbZBnHJVL3ZZVHZNKFfwhTzdPvWkmryyKloDeLDCAcySTnw7ycaR3rWei3skQBXEwDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9sIzKTxKWeK3eZyn9rmWBacM3Iyth5qApB7bc+Pqw7s=;
 b=O4xYH8hd4KQEHTnDC+M/qA7DhM5wFEyFfmR9Echo1rDs0O7FuBgVR4ZCqoPTGnAlrQP2ZdNwYtQhPxlUJcxD5RARh6+Iq/1wzBYeDDkeEo2+DDHnvf8CrkQG8TUD12o98sxLdy7cmreS3mjgtI6SgfEJz0ApoHByepDb01hFd+KoAgwGVejv/g8XjODPG1mSiHKaEgr/l9jOxu/qgvYRRM/X7Vd02jgREAsz0/zwxfBjZLxtY4m/BbQLtYlwts19SCkCrnsVsbPiQaCcGoGDVQfYwErEBFUrXEwZqH+b392vrbyUoizkNDK9kX6GfqWlMiauIMyUCqxwPDAxoN5FqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9sIzKTxKWeK3eZyn9rmWBacM3Iyth5qApB7bc+Pqw7s=;
 b=JeC5ApGIeshYckXxzRVjvUraMUZJnw4AFZIjy3EupEU1R4mRsmQcugLwPI03Jg+Z9gBb4YDujwDGyEHSqgM18jtRZyfeJ3xgPBeoSN4V2r1SrmmDLc1/KRH1C4zPyQGEgK5AvDUxELFkzM7MOwDo3RSNmyugWueW5yJg8MyZTgg=
Received: from IA3PR04MB9680.namprd04.prod.outlook.com (2603:10b6:208:510::12)
 by SJ0PR04MB10303.namprd04.prod.outlook.com (2603:10b6:a03:407::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 22:39:10 +0000
Received: from IA3PR04MB9680.namprd04.prod.outlook.com
 ([fe80::380:1453:ea86:e64f]) by IA3PR04MB9680.namprd04.prod.outlook.com
 ([fe80::380:1453:ea86:e64f%7]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 22:39:10 +0000
From: Wilfred Mallawa <wilfred.mallawa@wdc.com>
To: "cem@kernel.org" <cem@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix unwind handling during xfs_mount_sysfs_init()
Thread-Topic: [PATCH] xfs: fix unwind handling during xfs_mount_sysfs_init()
Thread-Index: AQHdZQvFl7RksBKAkkawL9eCkaPqG7cRi8GAgAByHAA=
Date: Tue, 27 Oct 2026 22:39:09 +0000
Message-ID: <7aa0056fad8faa98a79b2df930fec1119797b51c.camel@wdc.com>
References: <20261026053454.987673-2-wilfred.opensource@gmail.com>
	 <auDFY4Lkxs76I_F5@cronus.toxiclabs.cc>
In-Reply-To: <auDFY4Lkxs76I_F5@cronus.toxiclabs.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA3PR04MB9680:EE_|SJ0PR04MB10303:EE_
x-ms-office365-filtering-correlation-id: 3a0d77ca-a9d1-4514-59cd-08df347b1e16
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|19092799006|23010399003|261026140227099003|261021123027099003|38070700021|11063799006|4143699003|56012099006|261022105027099003|261021121427099003|10067099003|22082099003|261026121527099003|18002099003;
x-microsoft-antispam-message-info:
 ONtjhQZnSMElCIbBRGDVs3bU7G2wwOYT8Mh0dt6yL9jSi67H8JkEGvzIjkLMhuU2dPE7QPIxBEZuqD/d+21bQGb0FfUBg82mdT0/xGetAvaSInhwQGN0bw50d7RP+XBiDBATQ6NWSGZguo05G5GHzOR6iQ8Kd8p6XKFVw3iFe9L+SEN8QnWXZmY5VWAG3BESUU9St2CPK8LsD2ekjqcyrNq8dp0hwZwxqHwjuoAVgYTl6s+VKLDc+uwwp5ipYtz67j5Sz/NaQWCoTLdUQz6LnPoVj4eAIgzz6+5pAKidKspTZMstQgcFAq+/sGyJJxVLenIE27FIoZfx+BXFqrnTxvUdgllFuspnDOEnqyC+rKL9xyziL5udFHZi1QHDJyhUE3ACW/mbyXbnd/BaaF5XUNr9t7gfAR7uINQc5lkpy6aJ2eoyeUoZZaiitYMaSbnLfPOkWY4ZmFlqy8kiK5BOV5JArdpPXhlTaz4SyQaQJyzCTA2KWMz4cQUGT4ImesafMDb8b1uXZM6Hz4PSSu3gv53A5hmSomRKT8TBAV+ktGeVf7cHj4i1+lS2j8EgdYYyZ7ujkCmxtgyFeEgqiwncIL7tlls+KgFhxSkVclC+g2DzZj7FUdhutJ/BRW7R4dpkQ5FCZh+X22H9masY9rYkOQKCNJE45b12y3OqfneWXdFw2/BYG9W+iPHQRJirLuPJMz61Rfjoo6Ot38IP2dmwebkh6Hch4RnpA/y0H143xns=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR04MB9680.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(19092799006)(23010399003)(261026140227099003)(261021123027099003)(38070700021)(11063799006)(4143699003)(56012099006)(261022105027099003)(261021121427099003)(10067099003)(22082099003)(261026121527099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MjdTZXZWWkFtT1N5Q3ZjT3RERDloQmNLMDNxQWVFM1h4QmpxNmVWc01Hc0NI?=
 =?utf-8?B?bzNHVEE4TkdwWE1FUWlHR3dETDFKWDliSFIwRkc1RDVRdEd2SUhMZmwyQVFS?=
 =?utf-8?B?TVF4M243Sk5sOHA2cHMrOUljU2xDSmpJRzFjdlljd3N5MGFRZDNXdGt6QlJz?=
 =?utf-8?B?OEljeUU5UmhrR1hTSzlmTWV5MEFyVk9MRnZOaG5iS3BYT2g2SGdhQ0M4dTAw?=
 =?utf-8?B?K0ZQbFFxbFd6dHFFZk5tVGVpMGtXOVdTRExicmJXd0xNai9rUmNSODdhL1ly?=
 =?utf-8?B?WnVFOTFlWHF1aDc2bDl2TkNXaFRSOFE1ZUtZT0RTUjNmN2JqeUVGcWYxT1do?=
 =?utf-8?B?aE9BY0d0SkhVanluMFcrT0JHd0p1MnRnRy9NN3ZWZ0U2cUs2Z3ZrRXhKcFNj?=
 =?utf-8?B?eXc4TnY3cHZ4M3pnUVRRNyt6VHZDbENSUDMxVEtzWWRXK0xlY2J1VGtpZXBk?=
 =?utf-8?B?c0M2enVxNFNyUVJVYi9qNVBMY2VndUZ5R2lnQVlzVXpGVmhqeVB0VlQrTjBO?=
 =?utf-8?B?RE1NY3ZFNlVhem84QUVrMTBDdTAwT0tIODRTbmRxOFUyQXhickUvcElmUVBu?=
 =?utf-8?B?Z09ubkhEak5kaStPZ2wxM0VCd21XdDJzbVlxL2tkQ29tOEFxdGxJeFlPWEhM?=
 =?utf-8?B?eC9ZR1V3MU1UeVhNNllBcVFFNmgxempHYmpSY2U1TyszOHhKa1A4V2dXN2Vi?=
 =?utf-8?B?UitmZENYMHlVTEJndkJENFMxdFA5VFhOMTZHRk5YNnhtM0JraUVCQVJCQkxy?=
 =?utf-8?B?V3p3Z3lMNVhqVUpMTnN5QyttQjhPMFAycHF3VWkwMFI2dVRuUUx4WVh4d2FT?=
 =?utf-8?B?anMwUDlBL216R1M5KzZtQ25jRzhibGFOQlRxY0hvNlYxNElQUFg0ZTV0S0Fx?=
 =?utf-8?B?MGU3dXFGN2Z5VWpHcVNnZm4wT2dlUHpSRnlMUTdyRXEwWVBBd3lrK0xmaWM3?=
 =?utf-8?B?TXVES3dJeld0L1B1U1RnU094SmhNSU1qWXMwa1ZkaDUveDBoUWNXYW1tdEcx?=
 =?utf-8?B?Y2ZJa2Zwb0dHR2h2VWk4eW5UNXZCb0xZVU4yQktyTnY4NlBndk1od241UWEz?=
 =?utf-8?B?RTczWFZHYjlqQmNyU2hEeWxIVjBLZTkwd1M2SUMwWmN0eWtDVGFrN3k2YXhI?=
 =?utf-8?B?cy9KV2xadEp2R1FjdWNBeU41c050M2J1SGMxVEJnU2NpTzJYNzBaT2xFSmJp?=
 =?utf-8?B?SVNYdlJ4QmhpOG9BMnl2Q3Z2SkhkMUxGNUY5ak1KYWJJSmFuT0ZWbWpCTGtx?=
 =?utf-8?B?VEJRQnluSExhWS9IWXlZU1dqeEZIL0xZMkJMNitLekVnQjdjeEhONmhyc0F6?=
 =?utf-8?B?RGR2Rk1vOThocll3TkV2dWRyZmt3QzJiY2dlK0Z6aEZ4N240b0I5b2J6NGt6?=
 =?utf-8?B?bThyR3hINmdvYWVZSmhTUjNYVjJwWGJ0ZkhJQ2RyMTNYaVFuamplRmhNMGpW?=
 =?utf-8?B?eSs5amlTVG5EZVNXNzJVZGduOWl4WG5hVDd6cGpvNGRXRnpmakxOQVBqdDNt?=
 =?utf-8?B?SVRwVzdjQ3lpSDZqQnIxSUJuWkNnTnJ5QXQ0S1hoNUlCRTI0TEJUQ0dndFp5?=
 =?utf-8?B?R1ltR2w2NjlMUFFpQ0tyTkhaa2krVlNuVEJXMUZmd1hJZTFCdjdUQXA5aktm?=
 =?utf-8?B?dnV5ak82SXczVEJ3WlVuOStKYm5mNWQvc0VnRTVSZjJQZExOZVlRNVlCR0Fi?=
 =?utf-8?B?YkZnc1Y1VXRDMkRKQXQ3Uml5NEhaZUVwMmVINWN5RHpGU2htWkY4NjlhOXhL?=
 =?utf-8?B?dndGeGErVHcwSVp5cGN5MDRBNkNnSGF0M003am9FVTY1dzFlRS8wcUpPT0F4?=
 =?utf-8?B?NTEyU3dqWi9VdmJzcDZmUFJtR0xLNEpZaHZVUnB0cGRUUnNtaW1zZEpHSWVz?=
 =?utf-8?B?c29pczhuSlVMVGRSV0ZJb05CVGRhMWZSVjVQSHU2cTkyUWFtekpmaWpVckxH?=
 =?utf-8?B?MFAwc0xBMDlRcm96MGo3Y0owZUUrTklSb3ZUMkJqYUE2blc1aHpRWmtQUHdO?=
 =?utf-8?B?WHFBcjJXMmNUYXllbGNDS3dXTlBwUWZrNElGR015UStGWHhzS2lLcUNvTjhM?=
 =?utf-8?B?a3djbklDWStURmMvOVJVV1NVbUVqNkxoK05pVXkyS1VrVXk4WENJT1AybS9v?=
 =?utf-8?B?K0l6d0F2Zm1FKzhRaTFIWHVVTC9zME9zdFQyc3JhMVBFMFA0cHJXNEd2cmJR?=
 =?utf-8?B?LzZqbExKRUJZWXJwMlVBMXU0MjExTnlmTW11QWRnMTMvbitwbVhCOVkvaXVR?=
 =?utf-8?B?TXNGQUpHcGN4VjY2NFF2WGlnSnAxVFdQV1o2N2NSd05sNUJLVE1YR2RsYXJU?=
 =?utf-8?B?MU5ZTzd1VkxLb09sa2xIZVZYMnpqbFZlK28wZXUzL1k3WnFMU2R5SEs2cVFz?=
 =?utf-8?Q?HgBF9bDPbfweE6AA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D1EE8E9F342E62468E2E3356D7621A0E@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	sDRhC0x5sjKnolRf4zvr8Nu3ywTN5o2ICBj8hIU12cMK4FIG1LnsRuKmXSkolv7QnDPAWwV2qe1CaS+RfQ1A5ITVM+HRkTURbRTOHwyBho6tTWgtls/9O+MjX6HFxWbucoAablWFjz3EusHQYEHfutL9II9lrqVMQAoYy2YPcLKao3Ba2AmLNLgVS8ORy4I0zmpPKtcm4q2KxwdErffIIzqkmfDEVIzkpWW+6wxtZc/reWNu1hb73d+EH3f/+LbsGSNHRNLVULN7dfdkWW+XiZuf/0E63XqIu/5j754GDyrdd7o9ZsUCivJNjsxJgcKD/DJFrEiGFUPf3d0wjq135g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lh13Gbf4e8jHuw/QfI8OvV8bRMNSpsR2My9PO+lRZ/AQ0CntPE4mTqUWsITHnk42LLvLZQvAhcPij3OWMWcyKKtr+nehSb8Hoyok1E6uFFnJ5ZelIHuSvt2vXKd5pqCydJd88q2EbqlqLZ90HwGJT7IE0eJxr10USCA04nxrOo6NXf8riOF5pqvA1u0/cPRYyAA2R7LNTNUurkrYB5I2vwO5Q24ih2g4Tmk5dPuHCGkYPKO17g4UTahJE2CzDi9Hgbz8T2coY+67vxBrsg3HlhN0UrRS/ih10AyAeyijxkcRYb12+/fw4Jjyz46UOEAzel2YJ4Wf/JQ1RMsDGbhMXlAkGi8+nNWZ3Ki+aYjcop9DzR6WIe6ehAKZQSJOPbxuSCnYZqi6IyOeVGP+rJe0ald32y7vCMhlGeGq5Nhx0arZk9liBtJIRFfzjUcRpqvi9gO1i4g0UkZNLIXOawm8zLFFifgomaq8dBXw8749kz/H7KjqvvkkE60f3pKw1+1Gd2ZodGSfxmm2W8GkRmm6dRjCSElaqosKNlV5XyQEI0Vavp9ij1VaqelxFX/pajjr6RvWFGMKqvK/7ZkrQxYuvoa2mmnRY1qV+wotBVmqQewv2Z40sG26qWmHcxReT54d
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA3PR04MB9680.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a0d77ca-a9d1-4514-59cd-08df347b1e16
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2026 22:39:09.9676
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /TSlMQ4AzJvTZIP9Ihfp78T8eXKtyaA/gUD9MeFQxlMvMT3bBykmmnDjAt0WWgmRPyNfNwEmx67B5G7Umot6JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB10303

T24gVHVlLCAyMDI2LTEwLTI3IGF0IDE2OjUwICswMTAwLCBDYXJsb3MgTWFpb2xpbm8gd3JvdGU6
DQo+IE9uIE1vbiwgT2N0IDI2LCAyMDI2IGF0IDAzOjM0OjU1UE0gKzEwMDAsIFdpbGZyZWQgTWFs
bGF3YSB3cm90ZToNCj4gPiBGcm9tOiBXaWxmcmVkIE1hbGxhd2EgPHdpbGZyZWQubWFsbGF3YUB3
ZGMuY29tPg0KPiA+IA0KPiA+IFRoZSBnb3RvIGZvciBmYWlsaW5nIHRvIHNldHVwIC9lcnJvci9t
ZXRhZGF0YSBqdW1wcyB0byB0aGUgd3JvbmcNCj4gPiBwbGFjZQ0KPiA+IGluIHhmc19tb3VudF9z
eXNmc19pbml0KCkuIEZpeCBpdC4NCj4gPiANCj4gPiBGaXhlczogYTlhN2I5ZTg2ODZkICgieGZz
OiBhZGQgc3VwcG9ydCBmb3IgbGF6eSBkaXJlY3QgcmVhZCBib3VuY2UNCj4gPiBidWZmZXJpbmci
KQ0KPiA+IFNpZ25lZC1vZmYtYnk6IFdpbGZyZWQgTWFsbGF3YSA8d2lsZnJlZC5tYWxsYXdhQHdk
Yy5jb20+DQo+ID4gLS0tDQo+ID4gwqBmcy94ZnMveGZzX3N5c2ZzLmMgfCAyICstDQo+ID4gwqAx
IGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gPiANCj4gPiBk
aWZmIC0tZ2l0IGEvZnMveGZzL3hmc19zeXNmcy5jIGIvZnMveGZzL3hmc19zeXNmcy5jDQo+ID4g
aW5kZXggZTc3OTE3YWMxNzlkLi40YTZhOGM5MmMzYTEgMTAwNjQ0DQo+ID4gLS0tIGEvZnMveGZz
L3hmc19zeXNmcy5jDQo+ID4gKysrIGIvZnMveGZzL3hmc19zeXNmcy5jDQo+ID4gQEAgLTkwNiw3
ICs5MDYsNyBAQCB4ZnNfbW91bnRfc3lzZnNfaW5pdCgNCj4gPiDCoAkJCQkibWV0YWRhdGEiLCAm
bXAtDQo+ID4gPm1fZXJyb3JfbWV0YV9rb2JqLA0KPiA+IMKgCQkJCXhmc19lcnJvcl9tZXRhX2lu
aXQpOw0KPiA+IMKgCWlmIChlcnJvcikNCj4gPiAtCQlnb3RvIG91dF9yZW1vdmVfY3N1bV9kaXI7
DQo+ID4gKwkJZ290byBvdXRfcmVtb3ZlX2Vycm9yX2RpcjsNCj4gDQo+IEhtbS4gSSB0aGluayB0
aGlzIGlzIHdyb25nLiBEb24ndCB3ZSBuZWVkIHRvIHJlbW92ZSB0aGUNCj4gZmFpbF9hdF91bm1v
dW50DQo+IGZpbGUgKmJlZm9yZSogcmVtb3ZpbmcgdGhlIGtvYmplY3Q/DQo+IA0KPiBTbywgd2Un
ZCBuZWVkIHRvIGFjdHVhbGx5IGNhbGwgc3lzZnNfcmVtb3ZlX2ZpbGUoKSBiZWZvcmUgYWN0dWFs
bHkNCj4gZGVsZXRpbmcgdGhlIG1fZXJyb3Jfa29iai4NCj4gDQo+IEkgYW0gaG9uZXN0bHkgbm90
IHN1cmUgaWYga29iamVjdF9kZWwgd291bGQgY2xlYW4gdXAgYW55IGF0dHJpYnV0ZXMNCj4gYWRk
ZWQgdGhlcmUsIGJ1dCBJIHRoaW5rIHRoYXQncyB0aGUgcmlnaHQgdGhpbmcgdG8gZG8gaGVyZT8h
DQoNCldpdGggdGhlIHhmc19zeXNmc19kZWwobV9lcnJvcl9rb2JqKSwgd2UgZW5kIHVwIGluIHN5
c2ZzX3JlbW92ZV9kaXIoKCkNCndoaWNoIGRlbGV0ZXMgYW55IHN1YmRpcnMvZmlsZXMuIFNvIHdl
ICpzaG91ZG4ndCogbmVlZCB0byBleHBsaWNpdGx5IGRvDQphIHBlciBmaWxlIHJlbW92ZT8NCg0K
DQpUaGFua3MhDQo=
