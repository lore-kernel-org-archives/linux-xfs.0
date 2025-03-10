Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A305B22154C;
	Mon, 10 Mar 2025 13:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741614013; cv=fail; b=k4duQC8F4jTtACreXVMklQWYXI4PWiQnPOcbb/+wLde0ACPFfxZQFEUd0zPDs2KCj1Hq7tCtoEo77ayY2Qkcp2LWKGKmJADVvLVDUSQbgqGv2Fe/KZs8cezWLsbHQoQ84C1UMN8Rq4EAGwV3fyInydd1zondncAYO2YShx7haFE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741614013; c=relaxed/simple;
	bh=W/+IYl1I3tRPDHOnZz0ydAVBDIhXiZABf+My/YOqzjY=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=VlNnTwrMxv29LAUPWymtGQGdsHDB7vB6u8eJekP3tK7c+HGYDwP25rBPJee/hCbxQDlxX3PHvnyybGLgxAajsP7IAMu2HgYxCEpegXN7wh/FHlH8MM39iwEECTvtIm9TzFfyFhWKa2iU9ldT1OstwP2noT+jIIIeacJzm88M3UM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=doFXu3ib; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=P3mTY7WB; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="doFXu3ib";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="P3mTY7WB"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1741614012; x=1773150012;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=W/+IYl1I3tRPDHOnZz0ydAVBDIhXiZABf+My/YOqzjY=;
  b=doFXu3ib5x9mruDrsVmHZqp4amExFgJfT63Vu9kaD87oKPJ4riT0eqbk
   d2wy6U5y+O8BJNTbp9Q3Tww6CPL3Xt8kIiaaX3LKm7V88zisPTEDDkcOt
   VzJ8q9w7gZPoM+b3sCYY3WiLkVlx2vhlGeMzA1exfXhZK9LRA9lcHVjYr
   XdhdMDFMxL7gN47GNrxIRXtLFk7yJavqn7i7Za2QXLv2WXtO1gIyaO7G2
   ZQXddDasFU2DhDxBhZLLM+8CZ6X2Iwk55GpvTRQu/nd7p5dXBFy5kLVeo
   tjga4rALFZPy4mqSEDzh2ooqQZX2xbRvp7l3s6xyzKRWDMgIdVmHGmV5r
   g==;
X-CSE-ConnectionGUID: NhP7y9jrSAOuguARSPGNgw==
X-CSE-MsgGUID: rpJLjp4nSu2VzpTDvmfKMw==
X-IronPort-AV: E=Sophos;i="6.14,236,1736784000"; 
   d="scan'208";a="44698052"
Received: from mail-bl0pr05cu006.outbound1701.protection.outlook.com (HELO BL0PR05CU006.outbound.protection.outlook.com) ([40.93.2.9])
  by ob1.hgst.iphmx.com with ESMTP; 10 Mar 2025 21:40:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hk1kVHjVhDRqNhKhQ94L32d/3b8CQXq5kr8RgpChebTvPxjkeIHhERIiQ7FFPOSOhLUI9UJfhap9U/DM6UQxRoJbW5WxB7M4bvMqJF+zbFJ8z15zgYxqQqBUoItKIZjz3lPkIHCSChX7kh+VMQg7V6SAmzTZDbRUruWfoRdSBU2TT8n/5Tkwvw/0HEYk7jU/dm/ORI7NpxMNYKg49oHMqYJJ0VwaDAE3LdcCet5pkQ3VQOuM7z6+A+lv5A/Fzel4vmitA1E5Kvy4pGz1UkkNGK5s6pvlAS3MZiaaDLKlXu7UZF1RAL9Yng+ruyK4xEpIezLTtpknOmYJ7ckyfSDu6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G0ON6s2ZiOKK7+/bVvAFH1ABAJm/O+R1yaJOmAtsS/w=;
 b=O9vv6bGSbuybXaudssYGXXIBK9TFCzxdM6Is/cZsnda/Eal5GfVgD7Dg5KACY5VVoLT+gavOboNE61lW+qub/44gRHtIO9K1EBRv57kVo/eC2ra1a3dBiIoSGiJN0Ml/l62lZZ/zjsvBim+hcUtkwTzwzeK5q2STJ+oKM+ZirxpZIZorW5GtMkytj/DGL6VJiKy842GOCgbOUd5zfKT8KC7UVnZEcS2SiVpw4lbT3mppUkP8JUSGWTKdN5Bb5KzDQOFeGFGnXVVbuT9oJfOiR1zezWphfZ3hoVYi73lGtCVaxbpNrreW8oz6SzKNj8rEiCUZxO1R4I6ol0HvZpB8Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G0ON6s2ZiOKK7+/bVvAFH1ABAJm/O+R1yaJOmAtsS/w=;
 b=P3mTY7WBQxHzo+fXmoA3hEU5f+FjsFDvmjCqMj8q98qjj9SfURL+DHiMGKCpB/ZmFcXEC/hh0JrviKmSw6UPaCJQErwiA94wX2NhZdAmR2MvACz99rv0wOxPEL/rfhssX81kWyfRRYi07rQybRKj2gnaU38MCqSj5BuJIbVdlBA=
Received: from BY1PR04MB8773.namprd04.prod.outlook.com (2603:10b6:a03:532::14)
 by CO6PR04MB8410.namprd04.prod.outlook.com (2603:10b6:303:141::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Mon, 10 Mar
 2025 13:40:00 +0000
Received: from BY1PR04MB8773.namprd04.prod.outlook.com
 ([fe80::1e29:80f5:466d:e4e5]) by BY1PR04MB8773.namprd04.prod.outlook.com
 ([fe80::1e29:80f5:466d:e4e5%4]) with mapi id 15.20.8511.025; Mon, 10 Mar 2025
 13:40:00 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Carlos Maiolino <cem@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>
CC: hch <hch@lst.de>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hans Holmberg
	<Hans.Holmberg@wdc.com>
Subject: [PATCH] xfs: trigger zone GC when out of available rt blocks
Thread-Topic: [PATCH] xfs: trigger zone GC when out of available rt blocks
Thread-Index: AQHbkcHru47f7mgTq0ydKc6KrGtHAQ==
Date: Mon, 10 Mar 2025 13:39:59 +0000
Message-ID: <20250310133848.9856-1-hans.holmberg@wdc.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.47.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY1PR04MB8773:EE_|CO6PR04MB8410:EE_
x-ms-office365-filtering-correlation-id: f771f6b6-4340-4c1a-a1e3-08dd5fd90db8
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?7Wfka3Dv16mkYYTL2Wcc5ixu/1Sj23xOusNjHPEXb68IYO+gcYyHJ8OxKn?=
 =?iso-8859-1?Q?IwF0ek0xvTHF8pU8aqW28UYo8mzXjWoE/Satu3yUSQGZ7I8CFkAoiGtcnX?=
 =?iso-8859-1?Q?mz9WCqvQeI9iPuqnG/c8kmV+HyrxGoz3wYKIE9+D2b8Wm5cWS6Y6Uviy/j?=
 =?iso-8859-1?Q?cZJ4kkyKluUW8GbbGgR02k4rMo5eAYsBTfnFtsYlDOfBKBwAG3sZ9PEGWf?=
 =?iso-8859-1?Q?QGxx3Ge/Ofv7Nqiv0EcaLd880hlrkyspdPLKsZvY7vp7xnSq11XtI/an4i?=
 =?iso-8859-1?Q?KzBjXlhUP7a1CodMpFgpfBCNaq1mf1k3cgRq2B4si5VmjQaFPiM8wLaFr6?=
 =?iso-8859-1?Q?QaMIUkr8Cyqh1FMtQgXcwASu9KMufFMPhqtDfgFfT1FCKKqGx4+yXGGvvi?=
 =?iso-8859-1?Q?EyefMDSmrCymp2BDBd3+4mfquSNU2/YUzR8JIbAtF7fipH51JxHHtLru2S?=
 =?iso-8859-1?Q?JvkEJgoV/z+rETU7nyZUtbwcGTA+LiPY5NB3KEL+p3YposgtQCrGydUQoY?=
 =?iso-8859-1?Q?CV/sPUHaHIrEt/nyO6Q/lh5PEVuVAjI6w25j+AUrG1w9CqidjRjVSQvIiC?=
 =?iso-8859-1?Q?8+NWobx60EE7r8hdWVQ3AIZ8JkLZu9/HGDy2Xww2KVF/gepHiMJz8m+psG?=
 =?iso-8859-1?Q?dFJkQrXP6RHhSwv5zeGx2xLaiZj0sJuesh7pGxhXBOBbRPe5XH9O53akKb?=
 =?iso-8859-1?Q?SyMXjPb9dA2XRay2ag2FSRjM1JMvu5i6fLF4xyo5RU5k8HcIjHHNdgtMxl?=
 =?iso-8859-1?Q?g1wheRjg6hpvdkP48+dbClCj1Vr8fjL44wH391qr3lF4ehF4Dyge8qT83U?=
 =?iso-8859-1?Q?yDKVLLxlcm/HIW5Ic02/twh4CYWtbnQUTSIcbtSqCCJkzpP+kx+SN+Qq5s?=
 =?iso-8859-1?Q?6YtVI9GB/0ycxOyM+UTfCJK8x4teAVkHPLjibdRJ/KYOiDEWNg2/i7v2M9?=
 =?iso-8859-1?Q?CUPnY5y6jfpFhj+13LRFM+AGo78BKxVwtLIB01q8eYraJHyomgCORBkWMv?=
 =?iso-8859-1?Q?0hDTzzpR1pIAhOx1aRrovU6GvDZczVkdyfZZyUtnG7G1/SZtOiFjVmXPnw?=
 =?iso-8859-1?Q?JdbzfywFzPhQJfbWwFXRNk+Axr8Qb5jb6iSsNSUj+uOp1bD0gkw579DhKP?=
 =?iso-8859-1?Q?fdEHsI5A6tsqUDUtEvC1+d3O5LLTXsLvldle/SVm+g8PprPsTFgmN5Qfma?=
 =?iso-8859-1?Q?uqQQRwIB2J+RKDlxFmoGdY/F2xNTWoM2uOzz6RrYDxM5w+dyXFJzSQRs60?=
 =?iso-8859-1?Q?wHCdoTxts5qsHn9bIbBCOMtn1DVGhApvraP2zYFRotoSnDrM2jV+A4oViu?=
 =?iso-8859-1?Q?221AS7IMVdO0AHWoLlQguir2RC07UHU46AHjruxuhDWsFpyyUV/6GBjSPm?=
 =?iso-8859-1?Q?ycnE7E4+dOAZdbAWULe4LvHPqGc1C5b32EZqzYD5ePgGO+QWzlzq2yEaTy?=
 =?iso-8859-1?Q?NJULT/pkYYfCOvNTX4TEhGqIpQ5C+c7u6eiTlcoyhdKi9GNXH52tLZQCZb?=
 =?iso-8859-1?Q?QWwGkz45T2vMmYQegVpHSf?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY1PR04MB8773.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?xc+wCqGhAeHZ1CnMuVfXc5K9tp27SCXrMwAQlhiWdf/o7q4vkLUeyaR/+a?=
 =?iso-8859-1?Q?k+z7g0EQ8Rmnyj0j6WL72hQ/XM5usYxPRTIV30HBxLuF3Im0V7oZoBxtEC?=
 =?iso-8859-1?Q?wwG3DC1ViCCsJQystsdpVX1Z0A10W2ARS7WqEPenqKQ+AeAoe/7u6Bx65Q?=
 =?iso-8859-1?Q?W+JX/KUzN6bhmjcOSg9ZIIlrjulqZClCWfiD/2XHUAimsFNwsTDRPaX4+G?=
 =?iso-8859-1?Q?Nzw8tJGDIhvSuwdhWkqYcCp/abSLhlJSVaWaJbXaZaqTVtsmhrGEZm29+u?=
 =?iso-8859-1?Q?vR1H69MzqF+q03M+fw22pGgS/HFFVQlBqhRoqHMMfFftiAA15z+qE4CgP9?=
 =?iso-8859-1?Q?0nNJsZc0p+jr+VIaFkEIBtdu1SfohPJM7C3JAdFOHe+e/kWSch8Gya+V0s?=
 =?iso-8859-1?Q?IQZJwFOOvuMzkHa+tPLTDoVtOBBiLllP5VqkIEMA1ZAt/d6CvZIm+xQ7u1?=
 =?iso-8859-1?Q?QjJuiIxq4YYCyB3I4yga11ru7dpzlhB+0IuZ2d02+UMFKiN78a2lcq26eo?=
 =?iso-8859-1?Q?vhand1JkTv2tjVCGADp80YGQGBdEkfrGBamZWK4w488IljOC25uEH9NRLn?=
 =?iso-8859-1?Q?KwzRqX7E6R+ih02kUZYrarcdgVbH7R+wabajRBi7ZedxlG4SUhwEcrpXIg?=
 =?iso-8859-1?Q?Gr4nyVfZdmKfjArR3aeLMcxY4ivNagZTWNUANtr7mS47ybwXtueL0sR1md?=
 =?iso-8859-1?Q?3Sm1hZ/MVjVUtPS6CkVrOBnpOaOoKYgRFfuJJhk+kIqU6NbAgzVhDCx2dN?=
 =?iso-8859-1?Q?klZOySPE6P6NLSKWtSdh6zxiPOK0MDfKQwrr3dyBWSd89M900AuY2LJYBp?=
 =?iso-8859-1?Q?STj8ZMtyNpTkTA3ZRJiOmQ7kmlNC4bAN585O6gUWYdReI3qCFjYnTMTjsg?=
 =?iso-8859-1?Q?9838ch+DBLzaRwgjUJrFnz1sFCqbGs1DHgPPw+yGnFUUB6fSEjNh49tuIw?=
 =?iso-8859-1?Q?4pROJ19S0NB4wnxjBZEBPESEIPIwZszrYFGE57GqSKtEV3zcDwpIVS2Q9F?=
 =?iso-8859-1?Q?PzrE9KO5kICbRVlk8XWgXjk7N9di82mWQnYn5swQCn9Aw7sAXqin754ZXA?=
 =?iso-8859-1?Q?4v/jewOkkw/u1j6salViImxK4Hlo/ltfOjcJ9B2WBMlWbYFEaIGPVaGQo9?=
 =?iso-8859-1?Q?TlgsVV2detgqLtcwDGxVSrHwORMrnLBfKO28PoSZT9WWw3QDZHZyvUd/VL?=
 =?iso-8859-1?Q?e+PXfXmJ2D4cP2qaZgFQsqlYQUC+DwCAkLZF6fT1mpb5yjaS4CWlY4zx01?=
 =?iso-8859-1?Q?blolPGHPy0rG980pNCFYuqoguVb57qZ7p+pCFjypkzgrh+vdqWS2fhLleT?=
 =?iso-8859-1?Q?pm1zQOgLIQv3U1+LiqCeYi4GT5phkxRi6Y1cH1+6SJNG22s6I7MfuGCCNX?=
 =?iso-8859-1?Q?+CVaTM4jVXYFdCxyLttfa43LTsJb7bMOvb4ipwxe9YkUHATpmBPI/W2Wpp?=
 =?iso-8859-1?Q?BUNL6FJbxZX4pjyaiH6NMGKgcNtb7YxujVjSA7PoJVDvFKXFZpn5PQYWXa?=
 =?iso-8859-1?Q?ef2O5uYdjCj3k1PTD22KpZgBg5rlAnYTYwvRFOZ/mygV6B5yFrDbA+y86k?=
 =?iso-8859-1?Q?qw/OG6NWWkIfjaRUc346CWIOcDyqKUkIHNe4dmhpRVWmuOvp13KFdV09ZE?=
 =?iso-8859-1?Q?BgetTrosV0CLgFWu/YdKyr2gZWh4BIvD3WAHvMYPsCiUBoYowRgpSF6Q?=
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
	9bjUJSzCG7EJ5OVwxb9fZen2HQFr+/Er7mql8uisPPBIMOg4MpCJ2tbK+mWtFRzGrB4Mx6S54Eju+H++BL6bwPCkSC9npZoKKA/75El/ZCwiv77/Dr8JhGMmeRSMQKVUV4O3YKydskBiEdVNOp5/yOAxH76u7Xnggh+wBTY0FsM7bcza+lk7oXn7H0HkRQeg+kuN7rE9/gD7UBvaUl7pG0ai3shN/MyXVowZz+U5wYlaovSQIYx6aKiIJqGAgWmWGOXXLdwb3t+1QEmfCDxpNKtTtI1AjDhBS+Zjwcm6XOnGbg/Y1+8UtGo/mO1VHMSszDTA2F48jGZlm9BdkwaY7/tDlpKJWAuLFqY4Gk9Cn6/fbFqnurXU5/QBAFlnlxE5TJqvyzZVW4e3i5Q0+0KjuZ8ea5atmUFdOEus4GPCoB6IuVDPGqWIjwwl7RNUlcatg2Tc7ICtX31fOk/zHvY61uB42oYRDKH3WKlkK1FCLs6G17Xjwy7oTKqIh9kqyN+DCXcl6IByWiM9BVObyaU+PFTYywZOmMi6jhzoApsz/m59FOOmxRFp8Yw3QTp0ZaNmXCHhh+Lwl6o/FUOFStS6At3qMs4TrcY0Y0dxLRmPWFd12T7WHo4qVD+PklUQO8al
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY1PR04MB8773.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f771f6b6-4340-4c1a-a1e3-08dd5fd90db8
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2025 13:39:59.8949
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U1/8o7C7jtZUUJM0ITK2i6izNftvTxVGzmTdYR1rXPiLzYDz65ga6Ix2HCU/GhJEFak++LA9znU00ccTx7ZYpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB8410

We periodically check the available rt blocks when filling up zones
and start GC if needed, but we may run completely out in between
filling zones, so start GC(unless already running) if we can't reserve
writable space.

This should only happen as a corner case in setups with very few
backing zones.

Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")
Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
---

This issue was found in a yet-to-be-upstreamed xfstest.

 fs/xfs/xfs_zone_space_resv.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/xfs/xfs_zone_space_resv.c b/fs/xfs/xfs_zone_space_resv.c
index 4bf1b18aa7a7..4433a060b7ff 100644
--- a/fs/xfs/xfs_zone_space_resv.c
+++ b/fs/xfs/xfs_zone_space_resv.c
@@ -159,6 +159,16 @@ xfs_zoned_reserve_available(
 		if (error !=3D -ENOSPC)
 			break;
=20
+		/*
+		 * Make sure to start GC if it is not running already. As we
+		 * check the rtavailable count when filling up zones, GC is
+		 * normally already running at this point, but in some setups
+		 * with very few zones we may completely run out of non-
+		 * reserved blocks in between filling zones.
+		 */
+		if (!xfs_is_zonegc_running(mp))
+			wake_up_process(zi->zi_gc_thread);
+
 		/*
 		 * If there is no reclaimable group left and we aren't still
 		 * processing a pending GC request give up as we're fully out
--=20
2.34.1
