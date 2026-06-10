Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB4E375F9C;
	Wed, 10 Jun 2026 06:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781073730; cv=fail; b=TsI5pOv25GvCB2bV2nRPMpJNhuB6W0k9i2xA/UCldHy4HaDgl8T6YlaqYQhnabg68MLUXTxdxj+ryFwUWlOENtIUagfx5Ue7X3ROoHKpmIwTLiMeJHKlsPEWCtKcLxO1qkJbj0/3TcNpIya1nLcvT18TpN9Jp78ST5E9ykJORsg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781073730; c=relaxed/simple;
	bh=jYomwSP5FloKRBNXWfH8w3Tj/lCjMQE9Dtm2ZOEOZdk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ShCPuFX4Mf5XBKy/2/kL00WiAk5sktcn1yTpGQ+WmTY1CXgr3prV693L0yKoxTgCY/7rRrYmNEq4KheC3F0VSX++y09sIl/15ZFKM66+GR3izTlosSmO5zV0yssr+ZbmgYX5tdRzTY19FLPTML0A3+poqUv0yrx078ve6gnKdqU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=gDok7mFQ; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=XkgK+f+G; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gDok7mFQ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="XkgK+f+G"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781073727; x=1812609727;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jYomwSP5FloKRBNXWfH8w3Tj/lCjMQE9Dtm2ZOEOZdk=;
  b=gDok7mFQqFdGP3/aAgS+lJJGXFNJLs4rALHbW7WVEDjIw5TaCLQK24Rk
   XCkCO0GZpTWtdE0lY/yjb64b5YI+wHKd2Jl+bmIZnnher6m0imd1DCkjL
   fiZ/mOhVjiERB35uGcBOKJcRf6K7V+HuFwW8aPcXxBrIlD1OBkgtcCjw+
   f7Ya/ixhB102bx/JrVIuZA377ihyYZd0eiiRSq7y6zpxDtGtUPRTh2xGo
   gZgX19l7VJINjtD3vvHdfVdSw1u1IVN/ea6cJtnNZov3n5bu37MkWgGOq
   z7FfdZosMhk+Nh0gM/EnJ5XquXrQHe0bwnrDQR7qCdRJ+uNUndn3IHwGz
   w==;
X-CSE-ConnectionGUID: QsvFOiyXTsmtqJRr2FOBeA==
X-CSE-MsgGUID: SdQMG0TTTM6aC+df9ueEBw==
X-IronPort-AV: E=Sophos;i="6.24,197,1774281600"; 
   d="scan'208";a="149698172"
Received: from mail-centralusazon11010002.outbound.protection.outlook.com (HELO DM1PR04CU001.outbound.protection.outlook.com) ([52.101.61.2])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Jun 2026 14:42:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y/E0BnuReIgx4k8YPXAUuq/ESEi0v96pJUGgohsrIBJWwJuPClsm9lH2V3nLilpmAZukYTxucJcrlRVEbuPf+Q4TOGE7JTqx3OVi8LloltPWTB+x09FsGIk2V9J1z7CovmHPKz/7zAxe82kTQqY41hGKMc4nReR5fqdAnLNQ6c1Sy6Fnf+PFee/2yPe5My1YChUeE8fCKNgQbgVEVqXeDs5EllH12cEcA2bOX3P5GpApULEkvO7bIcP51Vec3G/8UPBvO0Ub29wafVWxLEqlz4EZ6Aw0iryriP7/HLWAiPpvAYWCw0TGeG6DVd97JUvZMSHxj29fMlr4Yf3ZY1iL1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jYomwSP5FloKRBNXWfH8w3Tj/lCjMQE9Dtm2ZOEOZdk=;
 b=t2FU4vl+S9h+ByFI3DfEdlR44iOrV+Zv5gH4r3j9c3PVkY3wXc6QDDfXO7kQP895TRBhzD9a9LInrDp9NYmbAeM56EgPgm1HmyNQu0nQaBwtIhIuMYeoTxPa1I+QdIlyrWmJY+OO++GOmtEUHEODlNl2moGdBa7WDldfHpsznsPSyFsoU+qpDDgd/eaFzxysTwmSeAbPz8mllcprniBoFlRH9SphK/obf61EciBkocN11mTOLADhRSMBav6RRQS2Px+Jiv7neM4jx6OC0GMt2q8TSE8TtZmDhaKmKRkawvMmbXrQTptc8/3YNncZZ4THHVpI13R5Ewmq0ymL0VOJHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jYomwSP5FloKRBNXWfH8w3Tj/lCjMQE9Dtm2ZOEOZdk=;
 b=XkgK+f+GigJvEVKUQ0JhQdfxQg7SdYtfsVGwJ80KlXdxCJp3P60lbJInfLTTCQeMFE/p1EJGIgat7jaNhH78E7LHdXbRIDtOBNEC0afOrkMt4doHqldl/j7cxG63bqqhySewwUSq6ybbWuzGOeBa+61bOsOS7jyb4PRHtyuBTPo=
Received: from LV3PR04MB9259.namprd04.prod.outlook.com (2603:10b6:408:26d::9)
 by PH9PR04MB104520.namprd04.prod.outlook.com (2603:10b6:510:3ea::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Wed, 10 Jun
 2026 06:42:04 +0000
Received: from LV3PR04MB9259.namprd04.prod.outlook.com
 ([fe80::ad82:88c4:91dd:53b1]) by LV3PR04MB9259.namprd04.prod.outlook.com
 ([fe80::ad82:88c4:91dd:53b1%6]) with mapi id 15.21.0113.011; Wed, 10 Jun 2026
 06:42:03 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>
CC: "Darrick J. Wong" <djwong@kernel.org>, "fstests@vger.kernel.org"
	<fstests@vger.kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: test that a grown RT section can be filled
Thread-Topic: [PATCH 2/2] xfs: test that a grown RT section can be filled
Thread-Index: AQHc9+fD8GuSHeVdw0CZcZsxsUoVG7Y3WK6A
Date: Wed, 10 Jun 2026 06:42:03 +0000
Message-ID: <f511ef88-b899-4d54-9967-2d435c8d112b@wdc.com>
References: <20260609080051.1712103-1-hch@lst.de>
 <20260609080051.1712103-3-hch@lst.de>
In-Reply-To: <20260609080051.1712103-3-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR04MB9259:EE_|PH9PR04MB104520:EE_
x-ms-office365-filtering-correlation-id: a954c42c-b1a7-4284-cae2-08dec6bb620e
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|376014|19092799006|366016|1800799024|3023799007|56012099006|4143699003|11063799006|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info:
 3uKeT5UfFoYVvHF7+9tK/VdfbImJtiDbsQ5CXPDBvyQV2Jvpruf+VmwGcIw8dme76r9yQnDykeS7MJYPHYDPv0OYsr7IQFPi8gKdNIUuWDdI7DNtwec+bfVbs9lYGtIVzTXBmCRKJPn40sv77S5SfJo5N1cAh9uFaXcWKSTzk6im/734xMojCSdmB7v46UBj64VZyMKzJNxRpS/Cr7AItwAu+pEumxvvjib6xNahIGISZNVoaY/mbeY4GDZhxoVlKCl+ucJjkjLPKifrbfxQbl/tLv4Ei6/g8LUVc30rWU41KFir2ZfNFvgoT6k0QrGPwriOavi2sIocNzKlL7+Mln319b8rZa2zJSMUaUF+5cpzCVOvIMIAq8YywdmyoEh5QpoyEZWBJU9I7U6l3SPKAIVBfapwHpx4KUFHPPrYPeDKUg6qbPC+1CDNMWEVNEWZXkrtUYg5rbt/uTLflVeSVgl8gXs+tNiZnEZJed2PALI2ib6/BBKQ2kZkqlBKajrosF+g5uxTKkMULD8lM7GeIO/5E84NkFL/iH4tTex9ooj78+dcueymOi2BodUj5LJinFqxX2om6lnqbTo4VVkBj1F1+Oen1qTAGZakUiiYpX6RisYEq/hHvTlWxfvs1Teni8LwN578+ko05swNSCX+e5MwDKt6K2jay42D1iwDyiuRgozWFVlSUSCu1muKM+TUEpfFxSnH1kWWWzlVFsmomUIKFiSi2XTcH9IYt5wp1f+/pP9EbR2I66dTyrzeoxK9
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR04MB9259.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(19092799006)(366016)(1800799024)(3023799007)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TWk3azV6TDNYdUNwWFBhcHBwSVVEUG02RHBsLy8yNTQ4MDdPUHJneTd6Y2h6?=
 =?utf-8?B?bVU2Umc4c3IyS2pIMi9jVXJDWExRV0YzRXc3aXA2bm1uSndlaVJvTy9CaTFE?=
 =?utf-8?B?aFlIKy8wYnd4dXphVGpTVXpUWjdqT01VTkpPTkVtUmJEWUFIREJwb1k5aHg0?=
 =?utf-8?B?QTd3cWdzN29peHVjSGZKd0VoUVd6NzQwOFA5L1FlRnFGNEg1NHU0K1JGMHBR?=
 =?utf-8?B?QlN0bDdOdkdabTlaYVpZV3FkeW5La09udi9mWlV4QTVaYzN4cnR1Q2c1OGpq?=
 =?utf-8?B?S0k5elhWdXpjL2hkUFBqa1dhVnVZTHliYzR6U2ZFQzhqSjJQR3FKQ1BWa1R5?=
 =?utf-8?B?azJ0a0NRbFRQTU80aXV5UzNKZURVZGFTT2wwNEZHZnhiTG9iMjRJZXNabFlu?=
 =?utf-8?B?WmtkSlJvK24vVVRjWnVxUjJhU1pHT1Vsb2U5OEJSUktONnZQczNnOFNiSFBP?=
 =?utf-8?B?TExiYkRqNkNySXBOUE45SjlPVmJvWG55ZlRLRzJGaXdtdEk1enRPNFF0STlE?=
 =?utf-8?B?TEVQNnNZT0pYNnJpOWF6aE1Lb1RjNG1IYnFLeUY0ZEV1TW5jOU1PRXUvSTVW?=
 =?utf-8?B?QXlPT20vbTlZRWQ4WTBCMGtHVWJjRXdXczhlV3VjNHZRU0o1VVVFdHV6UW9L?=
 =?utf-8?B?SGlPOWE5ZTh3emFPcm9SM05pVU82bVM3RUVITnlnaXRURTlvL3Nzcklhd2hK?=
 =?utf-8?B?QnhWUGFZV2hYYWhXNXJtMGVDTnF3TG5oSWlPY2NmSWpRZXVkdElLb3Z6dTh5?=
 =?utf-8?B?Mi9DSTdTalZsbHRkUHBvNThQNThWeTNMUjBFZ09VMUY5UU1SdHppVG9sZU5W?=
 =?utf-8?B?SFZMVkRVYW9JQVVVa2tlLy9LSDJSbE9xQ1NJNldYV2VZVFVpbEpLRmM3QlA3?=
 =?utf-8?B?NjdNb2E5ZGZ6WHZnWS9MTlFPZ1E2SGhWOHlyWHljeFEwRTNuWm9aK002VERp?=
 =?utf-8?B?SXZpSWNxcEFJSVB6ak8rak4wblMzcUtUTXJqemw0aG1HK1UreVd5MFpTaTg1?=
 =?utf-8?B?STc0VFcyNndGdTBPajlHYXJFQm1IeEJnVjloYWFDVkp3dlZrR3dIVEZoUGlV?=
 =?utf-8?B?cWVyc01ZWlZkTU9vMWJud0FoUlZZQWY0QUdOU3IzMDF6RjNteW5FNzB3V21C?=
 =?utf-8?B?WG5jZ1JTalUvc0ZvWks5cFZKNjJNeUF6Yko4b2R3MjZldEZldGErdTM0WklF?=
 =?utf-8?B?Q2pLcFlrMXdibjN3aEkwZ1FucnJmb2pZOEZFUEZVakNNWXpvcEVZVGw1eDRm?=
 =?utf-8?B?VGI0aXo3VEEyUXRrb3ZwY25QRFNVSkVDbUNSdytEdUxGL2h1V0ZQN1M4dVRD?=
 =?utf-8?B?M3dONStQTHQ3SnhSQkwzRmhpQzQ5WVdFdkw5VXFTcE5vUnhNMXlHZ3JDMjBy?=
 =?utf-8?B?ODhFbWN0eGJVR3FQT1hLOFNkTGpQUDR5MXpCYWJsWHlvSTVUZjB3RHFhRXFz?=
 =?utf-8?B?YnZ3cmVZU0xGSFRHMUNnL1hFS2pUZ3JWTkYwNE9pdHhpams3b3ZiQWVqclkv?=
 =?utf-8?B?a0ovcllWejNGZzkybmNvRzIzTDhaNVdvZC9wZUIxczVmZWhIYWsxMUVLT3ZE?=
 =?utf-8?B?YThLY0NZMUpqdzJ3dmJZK2hLeDNpQVVLNko5OHp6eFNlVkFjN3VWMjRpWGNn?=
 =?utf-8?B?cys0d1BPOWMwV2g2V1hEdGdKcy9Pd1E5STdnZ29CTGZsU0wzZmJCVUZhTzZM?=
 =?utf-8?B?NHRMdVlQOFBjci9ETmw4WUF2WFRRWDBDeUNsV1c2SkhjN0Vyakd6ZVNyb2Zv?=
 =?utf-8?B?UDFSb2xickhPb0dOM2YzYWZNQ2NaTFViY0lEWHdNRTBpYkJZOUk5ZEkrTGx6?=
 =?utf-8?B?SFNCNGtFd3lXdFFYUEdrSU02eTA0R2szSi9ncjg5ODk1V1lWUmJqWjR6cTVD?=
 =?utf-8?B?WXY5M04zVitBWnovVFVBb1Rib3J4QXY2Q2F2TFlRd2w4bHI2UmlrU0FaKzlW?=
 =?utf-8?B?U0RrTDU1SnhrR2kySG1UeEZ0UjFTYXBsWjVIdmRzRi9Sb3JabHQ4eWkweXhO?=
 =?utf-8?B?Z0NocEpnb0p4alhOUjJQSE01UFY2Y0lYbHkwL3FrQ29wZzF6NjBmMmpEVVN4?=
 =?utf-8?B?RWF2dkNqUFFyWlBaeldXYlBsbzUzVENIeFRzZ2RoenY4T2dIelk1Qk9sbWxI?=
 =?utf-8?B?d2xxcnhHWkoyM2ZXakFsQWhYemRoeGhodXJnSEVFQk5PK1F4enU5U1Vvblcv?=
 =?utf-8?B?T0FmYnZJMWdsSkJha2l6QjhFVGpvR2d5Y1RDcVFacTk2T3l1OFhBRTQyK2FT?=
 =?utf-8?B?Y01GNXV5MG5Uck5sWk9Sb3RyUXFucWhqd01uVFJsa1lMdGRuUkpEVUxNRUpx?=
 =?utf-8?B?MXAra0M5dDVNQVlkYmJ5ZTZNcHBUOVdWMkdkSmZBVlRQWHJ0WmxNQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9C10A25A0975444F95BCF141CDC99717@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	EjrGDv5llzqHJtFdcq3K55xwNdpD3Iqad17zt8qw7lCtjC30bVhsO7m2Xb7fGOmR90CK+58k0SqoPT3Hoj1KyFGDr7FLzbFCfkLgFGHjeVnz1GTBTCrRent3qeqN+R3VVL8CBECqjjIRaQZC0gRuabyDaDkXKhSjb50hQN5cFebOXQMAgNbtPM7oyjYINTGN0e5r+IbKjkrxF52GT/yJrqUyFwHNKVnZDOhKLnOYkJmwKnYuUvgW7VkD9rkAA/BHe9X+E3QbkbzzPir/agWv01T/vT8S49tfi5Puo7Q/yb0DRoq7VuPfuH1u1CHIL1AEFYZ/CSaf8FFMCatPllghow==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HJbwAb7tpKurw/Q4I+7bWpqO+x8VY4008RywtVZZ+ybO5WWtTKyJE3TKTBZgFhSKUyYFyJU+U9KiODFKunX6ZHMImgCll4121oPRT7R2hpgQWzBGgDBnxuPgF9nMZmxjoSJGJ0RWuRDu0C2/ciZyakwVmV9irI5q9aAn/x/8ywNf5JtGI9vVrYYG6U2J1bmiWhNjsEr4qsiK/qIC4pu/m5cl6bZwmDKmN2XZb66EnrodgMS7Jt2MTZlNY+Q4nVV/mULrJSAicU03wnDkpITP0GreUbHIthN4OhK//Fi2/G+bopI5WLBXiiQZp09M6K5NmRa9/ISSycCeBhO72TUj7JTiksVdM6jWwsm5Hu89+3JHcTDnapl3GfGPqqdaMtoFPz1o96MBF/Ea+d2VzE5mnNCr2AE+U3bwOIXDe+WIJ70rrM+slpWHzhB++SKemc7D5liJokQrS9nnN3bU6PdKXtlbDUGjl6yO3DK30FxqpwZHqU4p/l4TD1fcDllQQspKFbanPiQO6s5a4c5V2IEkKGmeenaivLN2izi+VmqC+kOXTNzFhNPVp4+0tMyA75YmVw45yedKLx/FzLZCNMuEAvcAtW+nytvZCsgenPPDR8mi50sN6FsRgjYBCL45FUKk
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR04MB9259.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a954c42c-b1a7-4284-cae2-08dec6bb620e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2026 06:42:03.8910
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mflqpceEfUvYM47Pml4VfCEgzUWfRnAlnAbF1gjtWEmGTSdYBTr0bS4U9X6x08WnMvwy0oK6WtnSsPd48aq2Sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH9PR04MB104520

T24gMDkvMDYvMjAyNiAxMDoxMiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFRoaXMgcmVw
cm9kdWNlcyBpc3N1ZXMgd2l0aCB6b25lZCBncm93ZnMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBD
aHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4NCg0KR3JlYXQhDQoNClJldmlld2VkLWJ5OiBI
YW5zIEhvbG1iZXJnIDxoYW5zLmhvbG1iZXJnQHdkYy5jb20+DQoNCj4gLS0tDQo+ICB0ZXN0cy94
ZnMvNDIwMSAgICAgfCA1OCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrDQo+ICB0ZXN0cy94ZnMvNDIwMS5vdXQgfCAgMyArKysNCj4gIDIgZmlsZXMgY2hhbmdl
ZCwgNjEgaW5zZXJ0aW9ucygrKQ0KPiAgY3JlYXRlIG1vZGUgMTAwNzU1IHRlc3RzL3hmcy80MjAx
DQo+ICBjcmVhdGUgbW9kZSAxMDA2NDQgdGVzdHMveGZzLzQyMDEub3V0DQo+IA0KPiBkaWZmIC0t
Z2l0IGEvdGVzdHMveGZzLzQyMDEgYi90ZXN0cy94ZnMvNDIwMQ0KPiBuZXcgZmlsZSBtb2RlIDEw
MDc1NQ0KPiBpbmRleCAwMDAwMDAwMDAwMDAuLjFmMWM4ZTdlYjE0MA0KPiAtLS0gL2Rldi9udWxs
DQo+ICsrKyBiL3Rlc3RzL3hmcy80MjAxDQo+IEBAIC0wLDAgKzEsNTggQEANCj4gKyMhIC9iaW4v
YmFzaA0KPiArIyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vci1sYXRlcg0KPiAr
IyBDb3B5cmlnaHQgKGMpIDIwMjYgQ2hyaXN0b3BoIEhlbGx3aWcuDQo+ICsjDQo+ICsjIEZTIFFB
IFRlc3QgTm8uIDQyMDENCj4gKyMNCj4gKyMgVGVzdCB0aGF0IHRoZSBlbnRpcmUgZGV2aWNlIGNh
cGFjaXR5IGNhbiBiZSB1c2VkIGFmdGVyIHJlc2l6aW5nIGEgcmVhbHRpbWUNCj4gKyMgZGV2aWNl
Lg0KPiArIw0KPiArLiAuL2NvbW1vbi9wcmVhbWJsZQ0KPiArX2JlZ2luX2ZzdGVzdCBhdXRvIHF1
aWNrIHJlYWx0aW1lIGdyb3dmcyB6b25lDQo+ICsNCj4gKy4gLi9jb21tb24vZmlsdGVyDQo+ICsu
IC4vY29tbW9uL3pvbmVkDQo+ICsNCj4gK19yZXF1aXJlX3NjcmF0Y2gNCj4gK19yZXF1aXJlX2V4
dGVybmFsX3JlYWx0aW1lX2RldmljZQ0KPiArDQo+ICttaW5ydGRldnNpemU9JCgoNSAqIDEwMjQg
KiAxMDI0KSkgI2tCDQo+ICtydGRldnNpemU9YF9nZXRfZGV2aWNlX3NpemUgJFNDUkFUQ0hfUlRE
RVZgDQo+ICtpZiBbICRydGRldnNpemUgLWx0ICRtaW5ydGRldnNpemUgXTsgdGhlbg0KPiArCV9u
b3RydW4gIlNDUkFUQ0hfUlRERVYgZGV2aWNlIHRvbyBzbWFsbCwgJHJ0ZGV2c2l6ZSA8ICRtaW5y
dGRldnNpemUiDQo+ICtmaQ0KPiArDQo+ICtfc2NyYXRjaF9ta2ZzIC1yIHNpemU9MWcgID4+ICRz
ZXFyZXMuZnVsbCAyPiYxDQo+ICtyYmxvY2tzPWBfc2NyYXRjaF94ZnNfZ2V0X3NiX2ZpZWxkIHJi
bG9ja3NgDQo+ICsNCj4gK19zY3JhdGNoX21vdW50DQo+ICtfeGZzX2ZvcmNlX2JkZXYgcmVhbHRp
bWUgJFNDUkFUQ0hfTU5UDQo+ICtmcmVlX3pvbmVzX3ByZT0kKF94ZnNfZ2V0X21vdW50c3RhdCAk
U0NSQVRDSF9NTlQgImZyZWUgem9uZXM6IikNCj4gKw0KPiArZWNobyAiR3Jvd2luZyBmaWxlIHN5
c3RlbSINCj4gKyRYRlNfR1JPV0ZTX1BST0cgJFNDUkFUQ0hfTU5UIC1SICQoKDIgKiByYmxvY2tz
KSkgPj4gJHNlcXJlcy5mdWxsIDI+JjEgfHwgXA0KPiArCV9mYWlsICJncm93ZnMgZmFpbGVkIg0K
PiArDQo+ICsjIEZvciB6b25lZCBmaWxlIHN5c3RlbXMsIGNoZWNrIHRoYXQgdGhlIGdyb3dmcyBk
aWQgaW5jcmVhc2UgdGhlIGF2YWlsYWJsZSBmcmVlDQo+ICsjIHpvbmVzLiAgVGhpcyBhdm9pZHMg
YSBoYW5nIG9uIHVuZml4ZWQga2VybmVscyB3aGVuIGZpbGxpbmcgbGF0ZXIuDQo+ICtmcmVlX3pv
bmVzX3Bvc3Q9JChfeGZzX2dldF9tb3VudHN0YXQgJFNDUkFUQ0hfTU5UICJmcmVlIHpvbmVzOiIp
DQo+ICtpZiBfaGFzX2ZzX3N5c2ZzX2F0dHIgJFNDUkFUQ0hfREVWICJ6b25lZC9tYXhfb3Blbl96
b25lcyI7IHRoZW4NCj4gKwlpZiBbICIkZnJlZV96b25lc19wcmUiID09ICIkZnJlZV96b25lc19w
b3N0IiBdOyB0aGVuDQo+ICsJCV9mYWlsICJncm93ZnMgZGlkIG5vdCBpbmNyZWFzZSBmcmVlIHpv
bmVzIg0KPiArCWZpDQo+ICtmaQ0KPiArDQo+ICtlY2hvICJGaWxsaW5nIGdyb3duIGZpbGUgc3lz
dGVtIg0KPiArd3JpdGVzaXplX21iPTMyDQo+ICtkZCBpZj0vZGV2L3plcm8gb2Y9JFNDUkFUQ0hf
TU5UL2ZpbGwgYnM9JHt3cml0ZXNpemVfbWJ9TSBvZmxhZz1kaXJlY3QgXA0KPiArCT4+ICRzZXFy
ZXMuZnVsbCAyPiYxDQo+ICsNCj4gK2Jsb2Nrc2l6ZT0kKF9nZXRfYmxvY2tfc2l6ZSAkU0NSQVRD
SF9NTlQpDQo+ICtmcmVlX2Jsb2Nrcz0kKHN0YXQgLWYgJFNDUkFUQ0hfTU5UIC1jICclZicpDQo+
ICsNCj4gKyMgY2hlY2sgdGhhdCB3ZSByZWFsbHkgbW9zdGx5IGZpbGxlZCB0aGUgZmlsZSBzeXN0
ZW0NCj4gK193aXRoaW5fdG9sZXJhbmNlICJmcmVlIHNwYWNlIGFmdGVyIGZpbGwiIFwNCj4gKwkk
ZnJlZV9ibG9ja3MgJCgod3JpdGVzaXplX21iICogMTAyNCAqIDEwMjQgLyBibG9ja3NpemUpKSAx
MDAlDQo+ICsNCj4gK3N0YXR1cz0wDQo+ICtleGl0DQo+IGRpZmYgLS1naXQgYS90ZXN0cy94ZnMv
NDIwMS5vdXQgYi90ZXN0cy94ZnMvNDIwMS5vdXQNCj4gbmV3IGZpbGUgbW9kZSAxMDA2NDQNCj4g
aW5kZXggMDAwMDAwMDAwMDAwLi4yZTdhYzQwMTlmM2YNCj4gLS0tIC9kZXYvbnVsbA0KPiArKysg
Yi90ZXN0cy94ZnMvNDIwMS5vdXQNCj4gQEAgLTAsMCArMSwzIEBADQo+ICtRQSBvdXRwdXQgY3Jl
YXRlZCBieSA0MjAxDQo+ICtHcm93aW5nIGZpbGUgc3lzdGVtDQo+ICtGaWxsaW5nIGdyb3duIGZp
bGUgc3lzdGVtDQoNCg==
