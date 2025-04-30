Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275B5213E61;
	Wed, 30 Apr 2025 08:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746002488; cv=fail; b=fGkQcptU7c+3VqjCOyByjgqf6rrpge4BNANsK24UfP6Br3iZHXhlv2NjEcKCtq6a6/XoydI9lOVhKGxQdoleRWJ++3BBc++kmVQnnDa4a0EwayCEsRAshK16IwuZmuvcxTDcoSa0T/J6ijftYpe5Fb66YGOuwYwDi2yg9WFQdnY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746002488; c=relaxed/simple;
	bh=ACUESYWWeHR0r2L93H5wY5mkmpPc+210GNYKC9mYfpg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VA0Bt4SQqCMwiK1o2cve5fS1RzDSZF29CgMtrp8f10/HeGd+giRxa/ZJIrpsO98bkf4C1peo6YpGcvvImONZ+Qn8TeQx6u+Oq3D8Ws0xVkaIKvVuQklJB5SFeFBPNpWke9OfgWtCRyXuTowV09BfXNwQHdd0yvraHxII0Sf9JsM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=VIxcE8eO; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=WVdR1VEW; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="VIxcE8eO";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="WVdR1VEW"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1746002486; x=1777538486;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ACUESYWWeHR0r2L93H5wY5mkmpPc+210GNYKC9mYfpg=;
  b=VIxcE8eO4IZKNBdPNE0KdH+H/53zU3JWbat50N/5zHyEmfSp7olErSwn
   sH4cOFH7ViYe8Gn+w1ZbOm9RiOkqXCY60LuCLhDBtxEyloclX3M/sZEBi
   i3blLCD/1i0f2rn+fpbuv8P+N5W4G9hpINIfuzTknnjKBWVTy06aTjibw
   xhlnbDfUyk2sDVZE6/FNyCbl1AZALVUgjkcUi7Jpul0dbSuMhtIAZpi2u
   SiEk0OFhRlC3ebjzeRsdn0kjRJPRQwt4aPeG/q0jvmNeY8vn3xB3zT7JM
   yZW2ZkIkWYItlZ1eZeGfWHHkt1hEu/IAgsED7AGKKLEriMRzDWsXW2//V
   A==;
X-CSE-ConnectionGUID: eS4gLPG2QiyMQUh2Y9LBxw==
X-CSE-MsgGUID: cL9EgLfsSKKBFGj5fYtvAQ==
X-IronPort-AV: E=Sophos;i="6.15,251,1739808000"; 
   d="scan'208";a="83812755"
Received: from mail-northcentralusazlp17013063.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.93.20.63])
  by ob1.hgst.iphmx.com with ESMTP; 30 Apr 2025 16:41:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PnyEiNNXnLxsUvynF+I5KsPgkjEa01I7U5iKAycZSO/IXl5fMsNuVojocHY3qiFY5FIMlD04OefqRbikPEOhhatwBj/Vfowg7mSqGuCqbmJb6IHLSWAgoYVgDUmPPfZcUzi0ZRxLawHNszBTFXc+bwjFHWvXBnwEy+/sa5S++JANQ2JAaPmbH1OomsEHz1fLu1d390JYLC4mdbuSxNhz62n83wCyfvSMC1XB/7t6OURC/DiaeGO3v4Qx68gzQDvjDjfOIpGeb7Es5TgEIbHHPL4SAAEF+VPqG9R0cGZ6qQZgICNMJ0Uq4rsqlRJL9nygvmmPS7DyTxJTbWPZNko3XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L9hj0LWCJvA3D/EqFLQquEtQTD8QV/K4HR6YGhne1zY=;
 b=uOQLRgGT4MMsCRsQPLwS72qmrhmx22cy1eFspCaCaY8D7oAN2GxL+9+/OBKAJTqh00gPH3CxfDRY9nLYvzkqW0KdlrtTax+wDkElMTV0Sd5ADKs+oPiRmjlw9voHzhqEgI9y4/5Hb41L/l5UpfoaI5GLtSgOcJ0AFWLCfe98Goab911Lsmqe6+FJb7j+Ezve1DwFSFIRnhLsuT7KJIdThGdHqm/eXrSBdqpcrf9ow05gioAkg07QZIOfRhUy6ZiAd+LfrK0AIjsJgbJgD5mbBBBfIKbz7VYmSq5Awz1t202LNZaVto1gaNyn/Y/tTxzEP6+tdRBIKpiJaBM8DzjIsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L9hj0LWCJvA3D/EqFLQquEtQTD8QV/K4HR6YGhne1zY=;
 b=WVdR1VEWCj61rNWyDfhSLQdmTttSyX/Vf9VObOQmva2Ysok6rmEr2zIplRzwSVf9AkhWLVhJlmyLVK6VHPJ830GGQEgVBxgSu6EbWFlZ5QXbWbeo9B+d5AWRgj6vFh8yY8mSQV9DyxION+KcRLnRDvn3wplOw5T2vPRckNgOOsE=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by DM6PR04MB6922.namprd04.prod.outlook.com (2603:10b6:5:246::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Wed, 30 Apr
 2025 08:41:21 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%5]) with mapi id 15.20.8678.028; Wed, 30 Apr 2025
 08:41:21 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
CC: Carlos Maiolino <cem@kernel.org>, Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>, hch <hch@lst.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hans Holmberg
	<Hans.Holmberg@wdc.com>
Subject: [RFC PATCH 2/2] xfs: add inode to zone caching for data placement
Thread-Topic: [RFC PATCH 2/2] xfs: add inode to zone caching for data
 placement
Thread-Index: AQHbuaumNyX/nCllwUCypU9ZWm8vKg==
Date: Wed, 30 Apr 2025 08:41:21 +0000
Message-ID: <20250430084117.9850-3-hans.holmberg@wdc.com>
References: <20250430084117.9850-1-hans.holmberg@wdc.com>
In-Reply-To: <20250430084117.9850-1-hans.holmberg@wdc.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.47.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|DM6PR04MB6922:EE_
x-ms-office365-filtering-correlation-id: 312d0624-78c5-42bc-60c1-08dd87c2c8ca
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?Ub+xKyLiH28676P2xI3WdHTtxpdCVVSyojxD504Jub4XNOMthPZWUxmZ0S?=
 =?iso-8859-1?Q?rLQzpdXZIj4dQqC+dtxY4LcfIuPYCFGp05KuThq4fv1F7OgHgX8sdqRCRL?=
 =?iso-8859-1?Q?IHEYI73eUT7X+cKoIg5LHNW6fcjDkxFC1x3o1PKfUeh52JJRuD34rbBOSk?=
 =?iso-8859-1?Q?9DpsWP7sG5XeuDeXXJmwv4OJJHKZBI6Lyon/ZPWPKm+MLz92zvLBwutwAZ?=
 =?iso-8859-1?Q?yC9EIi9PCq7z/7GzIqDuYEEPrSD82wONRckZVpYTSWp70FOz/1wwW+3O6b?=
 =?iso-8859-1?Q?mw030L+IuJ8m+DjHIEaIjriGL8yACJasGZhsogUDxCtZMEGlqk0HM+DCfm?=
 =?iso-8859-1?Q?zkyca2cn3F+L0vPeeY6tyl5yr03A9F+XGzzOx+sOZH1bsoIcUk3a9sXGMC?=
 =?iso-8859-1?Q?+MonTTccWVYjK6DEI6wB/MbdH2vdOcqoLLBJEEoOyo8wPXfivQY8rZDMes?=
 =?iso-8859-1?Q?zZYrwzhshJgNsOf35WHzwisham6PJjdrKxFtq5H8XHSEguAsaxaUSCt+LX?=
 =?iso-8859-1?Q?sjvyKOpkrRpf/jGAHfGfKiszah96TdHmHvEfjnn7AhKiP5VaLKaP4iMKjl?=
 =?iso-8859-1?Q?dPvrhW06kGMAUttzPYqAtQhMVidHckTWsI3oEMG6kvNxeaIjLTQoAQTpXM?=
 =?iso-8859-1?Q?WS6um9YAaTN07m0NP08F+XtD/jJMOB4uP6FFgWAQNanlglImM53BBpvvD6?=
 =?iso-8859-1?Q?yRnMW4C1lBdRCHE8O01M5hPW2/tpFmuiQsF71yNphfxwU/Q2VWsqHZYIax?=
 =?iso-8859-1?Q?bSDOoTrgYzouAR7wQxn2oNvnrR4mChGmT27nKtT5/sfHIuQ5UAXmiQBzyi?=
 =?iso-8859-1?Q?EPYRNpsKO2IGaMWEX8XgXu/FK0SbYDTsV3qCCxjPhW3tkltjuYd2nrOIh9?=
 =?iso-8859-1?Q?vjqiTIA1pODEDX6ukrguTMXufgPI4/SEESfbnEL8SOwSa49Tg0G+jTlkU3?=
 =?iso-8859-1?Q?cpBMWZDbI6ypLPH0HfwoDyUrt59aiL924jge7HARaK8TCuZLQTEIvpetXo?=
 =?iso-8859-1?Q?BXjTGgK7FBzPiH7JQIaccpeQjTpDOirkzPq6esMir4XUgGJqlDqgQPWCLj?=
 =?iso-8859-1?Q?3khrgYnW8stNYpecnk/b2r4P5YojTKya3UREi/REtI9SvXBH0xFViz8mDp?=
 =?iso-8859-1?Q?EMnhuXsS8toEbDt1yjPZRdORbbGbq9ubCXBFzPp3zrptnFwUvgdAIHHIYv?=
 =?iso-8859-1?Q?Q5PDOOhBpstKf2Dre5ALPZnI95cl2kczUX+Xu5civ6XO1IAfeqIJcKh0zQ?=
 =?iso-8859-1?Q?lqjaFpT/q4d6tfQtn38+eZYuCjmAFRF56pZE23YoUVXtCchR3soT6D7kd7?=
 =?iso-8859-1?Q?rYOvcRhHinpSzhm/3rLcqdme/YgMFwyP2Wa10EimZHNoYoh2xPd1iB2eXZ?=
 =?iso-8859-1?Q?LUmlrSaMX0V1q5ebuoryVP6mfTi2Rl88uIMdfxAa3q8TZ+svvf9sx+HRmj?=
 =?iso-8859-1?Q?fgrsimZm2Islx6e/iOAAp7jQZjMJOxjuUyH5p1vdoHlo25rR1XaA5NhEm7?=
 =?iso-8859-1?Q?wSvscYXbI0NxQ72VD0rRtI4kw7bDyjdNSINw6EZSM8Vg=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?1hTA6lBVSJlTYlZ3J0+2CeCsG3w2cQzm5xTp9jRDE7iJXjy7ofU561VD2A?=
 =?iso-8859-1?Q?48XNR7uBRPFzac1KgnepLSqFPUkOLTXKaXkEIbu8nkR3Jek5WGZPquP/h1?=
 =?iso-8859-1?Q?TfTp1u725SaTmd0h7Vngc8Zv3prppLfCcK8JdiqMWpgqpKkcHSexOe8lHY?=
 =?iso-8859-1?Q?177C5U+EEvM/PsQxXlx9pmqpssBrYO/VjrN18eqtrcnE6IMNWuqgan4S3q?=
 =?iso-8859-1?Q?JqQAUKZD9+oyoQpNM2XWRpn18e/YAE5qJfdr51Jlk8tyKAwiNmJ4isxuvd?=
 =?iso-8859-1?Q?oLCwniLRsB++DBe414Oz6NxUwEnCN3vxDI2mVIjJu5lWjo9JHuDy1qFFYE?=
 =?iso-8859-1?Q?qbID/eJRdDwSaBzpMaZVVz9RInG2SldxjURSKQnd9+dI1OZwAxorYDkqQK?=
 =?iso-8859-1?Q?6T5lEcc3Sg0MxjX2TJ5gBvdRpRkHK6T4hvHO0Y6X5S7YnCK/di1rjVmrri?=
 =?iso-8859-1?Q?MmJiGBShPsTJQknC6/zXKcCXZiNhuQOP/E8JJfHnCSRtdctmWQAVfQ38j8?=
 =?iso-8859-1?Q?0mUwuWBa5Ntj9PVXMr/N9t8PsLuwaberF2d5eZRP3yy/VKwMIEzz6z6vR3?=
 =?iso-8859-1?Q?QoLzlCLZz6rgTEMwGKGRDx/2n4xwiS+tvfau4k+hg01CXsYKxo5/9B8IXh?=
 =?iso-8859-1?Q?yOpKn1Y5VTRvYcQjxHyG0Ym7iH5C/f7soaTokuUfOazJUVLa0DTGq/XtPB?=
 =?iso-8859-1?Q?j224l/gi8SdA1H+S/G7KpxwRAMjlsA4LnXEDYnflHcggFQDps6nTSnwvAe?=
 =?iso-8859-1?Q?0nz9UI2MV1Tb33EErISvN3p9qk2bPhFoi/7hBSfbZjiTuCkU+eN/p9PELt?=
 =?iso-8859-1?Q?npbIhPRRkdW10ZF46AcO7dZG4YiM7ZLwkQk4ymvOGPFvV3yIoTI4Md5PTY?=
 =?iso-8859-1?Q?AsGupGI4LFMFU4wAwV+Pz1OQr9P7YpHOgBkoDYX7PsJji+LlJL4/n+MC/Y?=
 =?iso-8859-1?Q?jIbnqsugiaVLLOCYqKXTPe2D9sXSSK6U5Ng6EAMfjnuwC4ZxzCv50KdYn+?=
 =?iso-8859-1?Q?3wDFF+OIjnfW4LOucOq8rO1TerHfNpN40loINZlizIS+omP8G5C/ZUJAK3?=
 =?iso-8859-1?Q?gGtkRVzag6B3KSwYRVzh6vsRGCZ9jJXqLtm3XpIrstLfgdslj7DqtkBu7h?=
 =?iso-8859-1?Q?T3BChKyxV6cJgCS5z0Zzt4sf0noxOhpzNGZmCVHLhe28PRDNRdCRB2zlWU?=
 =?iso-8859-1?Q?Yyhyqg1lSwj6lJLfLnBWU84CJ7K9U+nsIReoKeNWAeTmDZoxgNFHHFP4Tv?=
 =?iso-8859-1?Q?bsZSKunRdlD1TGawBGkvNFtvsT3tFfuO+DYWE097io7zegOolq8lJtICTz?=
 =?iso-8859-1?Q?ymuhARtptPVSSm160RE9fstYeEK3gqdV4D6VHlwcmQP4Z6j0PqwFyTwjQ6?=
 =?iso-8859-1?Q?yuOKjPlSPnX7j4jZqZMUZXgmXcnrnpdrN3ZjmZYaXXfXVZckph49YzyvXz?=
 =?iso-8859-1?Q?igergjo7d8qCaiaP+TdFMAEatJUArdd0AxlN0eXi5tU4CK+TbgM+8qkIKw?=
 =?iso-8859-1?Q?PeXsJ/sEr6o1LBTev0auW+wKpdoZ/qCsAfSRsC1xrwdBRGd+qiyOWhHTjz?=
 =?iso-8859-1?Q?DrG0K1kj+uXXiHWZ6kmXgFtjZ81nF+ZFCAbDB1UbL/wHYBbVhYQfVjmKne?=
 =?iso-8859-1?Q?KtDPIcEic23JvxzR0GlJj5+EVGO1HEdMzlw47EseMb/6eA2Um97Amf4A?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nBbwNvuzFe67N5Ri5RFlCOWZR76UKoNrtWoKttCHOstWiQfg5QcduKdK4J//fGusQvpDItNpL2CZqDrFwWO5Bw6dZBfBxgAcmh6/BYPZoy/yJwt9DCOPaup0IXS6sEaTu8y5JtEAOpvaGA4Q4cQKrztBLox7xCPdfj4TxcRAlQIaky7Vo1IGCVDJcU34ojhzPcJvZ2t+/IUzjIX/QqChBY08VBjCAtVIMMewQsYMwi3N4X2VLCZZc5oVmQWd8hpFZbl6jrv10Q95FG/1FHL9WakvshMdPrk86wXPt9+NUBDAQbMHJdvftPConseXiGM/naA2XN9MAqx0EFBVJZkGNiCksEiadxu8aXFj2Fqofjo6BMUkXOkl4S3jtdU/BPjuxvsOtQ52SpSswxOuhmci7dEyCXMeLPsdBYimZ7j/PC8BMbNaP2MclLNuVWc7xZYE1qP5tS7rJ4IrfYOLrQirlJo0GtuuWOUtCI/3gApCTAAKESluSrL7ccC3uQR7XKSFrdBq2+ZVWrFpFzutxmeJu6k0o54BdLsM5vhLwIt5DU4EodSUlXf0zIA5yptXmHUUBi38X14ChBQjKaI5SQur3yjTxcmYirkxF0RxK/8Mg7RIW/W0fciP+gBWrJJuNFjS
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 312d0624-78c5-42bc-60c1-08dd87c2c8ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2025 08:41:21.8395
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EI8zGWa3XL9zF0MoORztQqrpZWqbSaFslEDfJtDvCiaTmxXvzM/yKFeYGFrv0qRjhWph/yuUfIHz9Y5FdyMBbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6922

Placing data from the same file in the same zone is a great heuristic
for reducing write amplification and we do this already - but only
for sequential writes.

To support placing data in the same way for random writes, reuse the
xfs mru cache to map inodes to open zones on first write. If a mapping
is present, use the open zone for data placement for this file until
the zone is full.

Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
---
 fs/xfs/xfs_mount.h      |   1 +
 fs/xfs/xfs_zone_alloc.c | 109 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 110 insertions(+)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e5192c12e7ac..f90c0a16766f 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -230,6 +230,7 @@ typedef struct xfs_mount {
 	bool			m_update_sb;	/* sb needs update in mount */
 	unsigned int		m_max_open_zones;
 	unsigned int		m_zonegc_low_space;
+	struct xfs_mru_cache	*m_zone_cache;  /* Inode to open zone cache */
=20
 	/*
 	 * Bitsets of per-fs metadata that have been checked and/or are sick.
diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index d509e49b2aaa..80add26c0111 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -24,6 +24,7 @@
 #include "xfs_zone_priv.h"
 #include "xfs_zones.h"
 #include "xfs_trace.h"
+#include "xfs_mru_cache.h"
=20
 void
 xfs_open_zone_put(
@@ -796,6 +797,100 @@ xfs_submit_zoned_bio(
 	submit_bio(&ioend->io_bio);
 }
=20
+/*
+ * Cache the last zone written to for an inode so that it is considered fi=
rst
+ * for subsequent writes.
+ */
+struct xfs_zone_cache_item {
+	struct xfs_mru_cache_elem	mru;
+	struct xfs_open_zone		*oz;
+};
+
+static inline struct xfs_zone_cache_item *
+xfs_zone_cache_item(struct xfs_mru_cache_elem *mru)
+{
+	return container_of(mru, struct xfs_zone_cache_item, mru);
+}
+
+static void
+xfs_zone_cache_free_func(
+	void				*data,
+	struct xfs_mru_cache_elem	*mru)
+{
+	struct xfs_zone_cache_item	*item =3D xfs_zone_cache_item(mru);
+
+	xfs_open_zone_put(item->oz);
+	kfree(item);
+}
+
+/*
+ * Check if we have a cached last open zone available for the inode and
+ * if yes return a reference to it.
+ */
+static struct xfs_open_zone *
+xfs_cached_zone(
+	struct xfs_mount		*mp,
+	struct xfs_inode		*ip)
+{
+	struct xfs_mru_cache_elem	*mru;
+	struct xfs_open_zone		*oz;
+
+	mru =3D xfs_mru_cache_lookup(mp->m_zone_cache, ip->i_ino);
+	if (!mru)
+		return NULL;
+	oz =3D xfs_zone_cache_item(mru)->oz;
+	if (oz) {
+		/*
+		 * GC only steals open zones at mount time, so no GC zones
+		 * should end up in the cache.
+		 */
+		ASSERT(!oz->oz_is_gc);
+		ASSERT(atomic_read(&oz->oz_ref) > 0);
+		atomic_inc(&oz->oz_ref);
+	}
+	xfs_mru_cache_done(mp->m_zone_cache);
+	return oz;
+}
+
+/*
+ * Update the last used zone cache for a given inode.
+ *
+ * The caller must have a reference on the open zone.
+ */
+static void
+xfs_zone_cache_create_association(
+	struct xfs_inode		*ip,
+	struct xfs_open_zone		*oz)
+{
+	struct xfs_mount		*mp =3D ip->i_mount;
+	struct xfs_zone_cache_item	*item =3D NULL;
+	struct xfs_mru_cache_elem	*mru;
+
+	ASSERT(atomic_read(&oz->oz_ref) > 0);
+	atomic_inc(&oz->oz_ref);
+
+	mru =3D xfs_mru_cache_lookup(mp->m_zone_cache, ip->i_ino);
+	if (mru) {
+		/*
+		 * If we have an association already, update it to point to the
+		 * new zone.
+		 */
+		item =3D xfs_zone_cache_item(mru);
+		xfs_open_zone_put(item->oz);
+		item->oz =3D oz;
+		xfs_mru_cache_done(mp->m_zone_cache);
+		return;
+	}
+
+	item =3D kmalloc(sizeof(*item), GFP_KERNEL);
+	if (!item) {
+		xfs_open_zone_put(oz);
+		return;
+	}
+	item->oz =3D oz;
+	xfs_mru_cache_insert(mp->m_zone_cache, ip->i_ino, &item->mru);
+}
+
 void
 xfs_zone_alloc_and_submit(
 	struct iomap_ioend	*ioend,
@@ -819,11 +914,16 @@ xfs_zone_alloc_and_submit(
 	 */
 	if (!*oz && ioend->io_offset)
 		*oz =3D xfs_last_used_zone(ioend);
+	if (!*oz)
+		*oz =3D xfs_cached_zone(mp, ip);
+
 	if (!*oz) {
 select_zone:
 		*oz =3D xfs_select_zone(mp, write_hint, pack_tight);
 		if (!*oz)
 			goto out_error;
+
+		xfs_zone_cache_create_association(ip, *oz);
 	}
=20
 	alloc_len =3D xfs_zone_alloc_blocks(*oz, XFS_B_TO_FSB(mp, ioend->io_size)=
,
@@ -1211,6 +1311,14 @@ xfs_mount_zones(
 	error =3D xfs_zone_gc_mount(mp);
 	if (error)
 		goto out_free_zone_info;
+
+	/*
+	 * Set up a mru cache to track inode to open zone for data placement
+	 * purposes. The magic values for group count and life time is the
+	 * same as the defaults for file streams, which seems sane enough.
+	 */
+	xfs_mru_cache_create(&mp->m_zone_cache, mp,
+			5000, 10, xfs_zone_cache_free_func);
 	return 0;
=20
 out_free_zone_info:
@@ -1224,4 +1332,5 @@ xfs_unmount_zones(
 {
 	xfs_zone_gc_unmount(mp);
 	xfs_free_zone_info(mp->m_zone_info);
+	xfs_mru_cache_destroy(mp->m_zone_cache);
 }
--=20
2.34.1
