Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5412239099
	for <linux-xfs@vger.kernel.org>; Fri,  6 Feb 2026 08:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770367280; cv=fail; b=pmxIaW0FItCjHjT6ZRDXAWmI8jy2X7qLYSAS8z0gjdEOjirBp/ZOVJBCAlX3Qlvs3sUbh5WRN/kX15luDuZUgzZw/lQZadKq25MyPjQNAEtWfXFuIXB+fM0JCIYT0x6e3nVIi88uuCwMo1TcRS7Qr1sqCj9pSTUik4O3+hmZy3o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770367280; c=relaxed/simple;
	bh=8xGpRdTyx7FrK6Fi9e6maILTwbMU3KKXyRRBHgapI8s=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=eztJ+RPoV7zjenGKcbKocm2z/PVoQFuCpDnv76Mx7wS9WQY6akNVSwtgy6535TKP8ZOvUwFGh/HwiVhiXdjTBORoJbAPls2Rn9RlayNCbJtQ9ty+xtxyUxgMxJMkGH8JhU9y1LoUHXvCCCMxsiJp0x8C6GOELYXjv+bRk/NQRYg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=TlFQ84P/; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=JgZq7eLs; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="TlFQ84P/";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="JgZq7eLs"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1770367278; x=1801903278;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=8xGpRdTyx7FrK6Fi9e6maILTwbMU3KKXyRRBHgapI8s=;
  b=TlFQ84P/d7N2yhcsZMSVFOMO6S/cs7PoC+edmDuhVTck1iaPwLIj0lHu
   Bn/U5S3f2laYaywGQPo+iOdw1sUYWjOy2SEbnMAz/7jlNSv2NtapotSRq
   Nsk4YNG8G74PsKoZIwxcCri/vC97L+yoRkYqJIVmDT8KtUojqtOHwB0Fs
   4Xv3kENAv9IKTg7auWOHKSnHTBF0XOgddZ07c4aE5sbWIw2PjDUvbn7VX
   apuP9c/QdsZBBNedJAigCzHol9EVxHLd08wgUwo1a4O2vgpZDbYsTW36T
   QfoW54i6EnC4GbqKBgtLaaDZJVTEU7c8lzkv1TwJIZY3KQMXn8j49JbMl
   A==;
X-CSE-ConnectionGUID: WpDMM4QjSyKTsL7tGfde3Q==
X-CSE-MsgGUID: UM/6Xg68RtOvZJkhJ4Igfg==
X-IronPort-AV: E=Sophos;i="6.21,276,1763395200"; 
   d="scan'208";a="139912080"
Received: from mail-westus2azon11010031.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([52.101.46.31])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Feb 2026 16:40:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iNhDi/Dm4TiYRKSBfzBwk0c7mOWx4plcgBzmXUNBbZ1EEO3EUztlNy2CJMgc9JjhoIwQMPpqHvIfXK+kJbvPo9t5uYlaa4/5iAd+NxLC9275ggsDKxrKgk3L3+f+s0Xe35JJPdMAdlahEBwN/w8n0CZKCKzNYb6r1OtwXzeqFlRgHzd57/RnL7adamFDnjtOB5hUZCpg2n/Qj5Z7vmEqRRbx4bXeTKOLRCXDPAfXdjZhw6oO5D2uGi9+qYrBJYClMayMJeH7RgJzgHJAAS2do3FNKu8jXAieqAOK6ZsEP+zuYhElQJATtmO7+MvhtUSnMBBukOlfNXy2DK0sIksNBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/g+DArb42Pyq2TxUc/SKol16JVrkENlwI+5Qa0R26Tk=;
 b=S/oZF2Dj09PqsIAW8waz+5Sxv7uhLKCECHAy2587ITOuAR2XgSir5uu9D1eonjWGLpI5u7yOh3AEbA7dZzXJs61cUx2eKrVRjwfZ8yvwjc5oxmCAsMEecgN8kL9CbXaztAtvpdoz6lbKwOiInbLgss+3fuRXreJaEiKGBEN8NGIXb5aNXQdinfgAjuAgr2tX7B7N5LeKAUOfifal92h+xc1LKmGvqY8m3vOhOi7zBTAmS1jSjtPaC3FPtZ9cBRh4ek1cgenBf/kO4FK87aj3/MlXazyoxFIrmmLOd1PX2BV34EJKrFryRFy+BxYUZVoW4kUslLMgvnCwhdVM8fYPDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/g+DArb42Pyq2TxUc/SKol16JVrkENlwI+5Qa0R26Tk=;
 b=JgZq7eLsSl8yT7weznKUiiE7j0uUz0l8w/sTU6eaS1HKO+m3JScU8xlgRYtAMwjnOr66q0EWdlmdL8d0cOmU0vnoABUyEoD4qzD4icwzzi+7kgSYTAGw9eCW/qenpgqOZJ+uwpziq50Ahyqtge4aRYNnmXHPFLJyqsYPtfa8Nyw=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by CH4PR04MB9248.namprd04.prod.outlook.com (2603:10b6:610:222::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Fri, 6 Feb
 2026 08:40:08 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%5]) with mapi id 15.20.9587.013; Fri, 6 Feb 2026
 08:40:08 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: "Darrick J. Wong" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
CC: hch <hch@lst.de>
Subject: [bug report] xfs/802 failure due to mssing fstype report by lsblk
Thread-Topic: [bug report] xfs/802 failure due to mssing fstype report by
 lsblk
Thread-Index: AQHcl0QyMGi0b3KRKkOnzTIETMr5/Q==
Date: Fri, 6 Feb 2026 08:40:07 +0000
Message-ID: <aYWobEmDn0jSPzqo@shinmob>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|CH4PR04MB9248:EE_
x-ms-office365-filtering-correlation-id: d7a1dd13-d3e1-4387-df9f-08de655b5545
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|19092799006|366016|376014|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?QQFs2FjMZh15PMJP6qQQ7aPM891VjQ32my19D2l0Pv4Cmh2twUkgAHIQXORi?=
 =?us-ascii?Q?8mkm6BgYo8lBPlOfui+XMJZ6YFDIxEMw+HoaWognrUw6RWSCogD9DHtT1Vkw?=
 =?us-ascii?Q?i4k77wn5o8sDKeegkpZ4XF81WIolzvdMv7eyskp58myTfR8z5uev9GzhyNYS?=
 =?us-ascii?Q?N4jiKsc1VEBPDW8QEp5W7auOKyTjBfDXnGHthDmTIA8b+h1Yd4aemhpEEDIT?=
 =?us-ascii?Q?FJLlVlmPoz8MD/cO7FUrDptBLq5Ddi2cq7/zgM5/6+qdk1H6jUwfbZWrqVsf?=
 =?us-ascii?Q?0nnDu1Zw9xUzYcoe9L+A66GZoNj9q2Ub9OVvSUg6Jebb1ekMfErdAw1wMmkS?=
 =?us-ascii?Q?sCWPhTlmnh4Wce75U9jR1Ulpf9MaVmMs4Pk1hVxVX+CjND/b14RjKrXsmKdi?=
 =?us-ascii?Q?HMXFH0ZiEkS/6Kj4wv7F8ZDm+p8crvZ1MtuG0bniCRylSIQ91J5EfkHML+oi?=
 =?us-ascii?Q?LaXsPoltIRhUhrw/G+WYBrnNNFAhctQ2zzZNRnL+sMtvUMGD7nHa3//Sh8Xl?=
 =?us-ascii?Q?olY2+OjjbiUM0ZI/8U5ybFnUsd1n1QbHfW1ys4W+f6CE9CPhweCZUs2Vxwlw?=
 =?us-ascii?Q?GfjE81vpiGUcLj+5ZHCmiy+zXfZJMAm5I/zdU3k7TvSRtvSYD9iVx4cv25ew?=
 =?us-ascii?Q?7eZB0wVzT2xAhS+3sxJQcm7N5yGm8kDu9o5ZdsxD9pjvvSUMGEHPvJGKRE6H?=
 =?us-ascii?Q?qvi9FWOAF/40MGlUzLP/AwjsYWTHFaEPeZDKv+k8SeaoyzOOo555bYaUoYSK?=
 =?us-ascii?Q?NElBiugDCuxsoSAUKbYz54eIeKvI3XPzE7xre01zv3Cnbs674TeunwdRmO0A?=
 =?us-ascii?Q?8L0K6v8nrbkZkL0Z5YSgVDlvJARPqOfDl1y4/MqXpAOhbnpaTXL5TUqglkLD?=
 =?us-ascii?Q?KUC2uzaItDmLeTIYNhRNh41qWd8hWrQSQn6CaG/1FZwtE6fJfS/lV+BOxZGC?=
 =?us-ascii?Q?Y9Lm5EanmON4HNA3AGrDuryGUvNbKQuVdzDQzegWkuJBYq6roBzFwoCEvFsS?=
 =?us-ascii?Q?Vyxw2+M73EDRcd2MyWwsKdc/EuWZoq/BWz7zfiAqgHpZmF5GLra0lkXVSQDf?=
 =?us-ascii?Q?prIveVvB3A+NZZEtS0mMoJcoT0B+PI66n8qhtMLXzCzbC+18b65JvF331WoJ?=
 =?us-ascii?Q?XVH7VJuvVYglQ7dqnqrt2RZKNGVgFkAD++8Hi7bvqpiJ9JBcHflZonc6hmC1?=
 =?us-ascii?Q?FfFsbhr6qqZ4w6CETCTVr1g1DkggmtMzrcMWPNSFWqEnGKUoppBswqE2eQmM?=
 =?us-ascii?Q?JPEP/lXG34Q1f1XWRnJAqJKOhTNOYXp3FJK6WxQs6xu44EV54kE//SrADVQs?=
 =?us-ascii?Q?ooeCn60Q5ykB+F5IxG+jrdd2iu35qkDQZNL6yeEEdKOBRbZxcXNW3z0NHTNs?=
 =?us-ascii?Q?1ppNL0Sx3Kja0jSB8Ibd5nB/Ys59eEeXuexcPDYLjjaJe378tQwKlR8G6QFa?=
 =?us-ascii?Q?GhqCuhbkQa5bXLo0AdZne0A6ATw7pRJDR30HGrOpAmKJeEOObbN6lRbAvmM8?=
 =?us-ascii?Q?oa3yQfpsVNrttx+xuq4/K+1I8SWwMQSG7Ba9ZU3ylISon3PUUXveBqEAXi+w?=
 =?us-ascii?Q?AtwtoS4sAVoDJ9aapMeSJQppMLk67SYCWTuBI08p?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?TecClx8BG3r+CIN5ijeEjQYipQodfBgsiMHdR+P0+OR28hIeWTy6kAhrbC5M?=
 =?us-ascii?Q?VoeYt8XW7ZBLEkAEUovsFss7a6e+fAglro+M3uxl2O7j8gJGFR+4hmQ+GDQ6?=
 =?us-ascii?Q?ZyJMD6TPKEMI3wfIsDS+PL3QBn53DsZ1/nPQcPHHZx0pp43mJYPq31nUg+LD?=
 =?us-ascii?Q?mqBoJRF1iLDGsedHm5mqYAYjeAKQ7RfC1v9G2qBo1QET6o4h1mW/CtvfmZrg?=
 =?us-ascii?Q?RjIU07H5VvagWMvLJKr9HdFq5+txx7TrYKgyU8Pn7wx7LTFvjREiTZ+N0+0p?=
 =?us-ascii?Q?tds1vFfQFfas2MZhvVYTUfmbqKY00UDovaE9HDvN88WAqKUjlCxVTxMW3TEb?=
 =?us-ascii?Q?vIqzdFL6mKn5t73NKMsvhZ/l0iIITX0bpLj9BPf5jFVU8rfVO3kZSWuibiQb?=
 =?us-ascii?Q?zxDVl6H92jrOtigk1n7Jy4mJVtjhTm+Blhc+ln5j+mzmBR+I5XTSL8n3GeGT?=
 =?us-ascii?Q?Oxmz2d0inrWhQFIutL5IaOJU18pgYWCo3RDW3qfkT1rHAkqHHC/WH6M+rvqI?=
 =?us-ascii?Q?6IBi1z9G3fRiICb2MBY/xLCbN1/DAWBdJLvo0We6W2eTnKRNpYXpcfA6HnZe?=
 =?us-ascii?Q?i9/FxYGZKGGXIQ7sld/IUeuyRzwbq95i+WWKdeZ+WnqWNFYinUCroy6ofY2v?=
 =?us-ascii?Q?/Zr4waQmirOgIk/+J7FtGf0pvqw0Tzdl8YuxsZtBqGjmA/3f4cFsqOoHMI1b?=
 =?us-ascii?Q?KfMfb3zH2H9jEw6jrOgTR/w4Ja7+a+Du6LNzFZaMYxQUa1OV+Hyd3voq6+37?=
 =?us-ascii?Q?BnuILFia8hICUh5gWESqzGTBb1w9borVEN6COJyRvSCzlflm/3xYZgpd5fLn?=
 =?us-ascii?Q?hQ+9UJ9uu/PPvXyBS/G37YiHNjjOwLphJm/9yEUr/xx8bHITGgYBlQTTJ7yI?=
 =?us-ascii?Q?6s0wWv/IJoXbokYNngmU6EGzliTQFhFPseJ4ykVr6l0MOe8sgZSHisK0v/3U?=
 =?us-ascii?Q?Yw1Q5gx4TwUnepfRMiIAXNdNrhlN6Gp9n0gT+ckT+mUEWKc4ZPoQhPKOJpvc?=
 =?us-ascii?Q?8u7ZDJDmb3iKxOA5W8B5y7G3GSGAgns7VKn2rf/dlEI/JYPhHxtWCHlAz5aZ?=
 =?us-ascii?Q?uwgySfnSlF75uAI3x4dWcWK1XA8wpklom2LFrc2xS1CRZ92fXJnQFa9v9YUU?=
 =?us-ascii?Q?f1GxR9HSa+w9blCs1ucej8GqGOSLbpxDe/iMZ1Bb5dwBvjKO/6d77r/h6b9B?=
 =?us-ascii?Q?NPGKx0EdPIV+pD9ZU0E0AwpcU0yvb+cXPqEBnWJTIFSYMKj7OobTgesgZ6Ui?=
 =?us-ascii?Q?PulchIOEYr810YGt53ebmjV+w1cQy+2M/87k6EDjLKtgYZXz+xDg9A2Obwif?=
 =?us-ascii?Q?8plYc+1ll/CQmlYifG1pnFk9XI9N/Z1vvUIUl15sheUBymrt3FNgrwXM1EAa?=
 =?us-ascii?Q?xf+mMLIZKZRHP76JYuUOivP0m8frQuav2VynppGO9T+b7CHAFGILnJsnKw27?=
 =?us-ascii?Q?kxWCMUCgIrfVf5GWK86guyrVN5l3thNoz7GiFk8OVwDe132YO14gnq/es40C?=
 =?us-ascii?Q?5RvbG1aMijPw8wOQtfdOYynAUe4os4YI7cU36I/uIiAh6fJ5bJcL+W3wAi4v?=
 =?us-ascii?Q?5HmWRp9pX/JmPlWVaaSyMABNa9JMfMBa0i3ZTxuuz6dNsN1vzPpaCLYcCA3I?=
 =?us-ascii?Q?f3XixMQEgZaSOYp2nJu6u3pGYWccuNQJb+4hmU9rJ/bnuZBhBj1amGztlgQT?=
 =?us-ascii?Q?Jm5qgwKVZQpgorcjTJKBBdKxgwiLjVTr2gCMK8iHglNpnATaGpxbWMwgwh/S?=
 =?us-ascii?Q?FtyXQMVbiDk+/+IruOBQg2yY1Gg1mdU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5A559641F0FD964ABCC40145B3D387BD@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EdXEtcg9/TIVVXj6aEYX12xOJW3hxpiWLPGCEL34Yw247XXzmnmN9L4GM85sZLcgQxdGW+TGYLbWKxfUrPqRZma+6LGpCH6iyzIFYxPPpaXtBGPyx5dru+BYM92ttjrFxbUNxCVzkWUgdWsQCuGbXHMc9JPnI5nqJ8v75f6jhdCod0o7355fGYgpaPAVtH2CFuslPIEEu3fnLEJx3v+I7t9itQuzKG0jTdCdeuYc41K72GAR+SbYOzUFOo1XRYN32JosZN98O4a6nNHwICZwRgRDYGx2iXOli7BRksQo0iBWhidVPgRvp7SgQECNgfcm4IRcNzDOt1PCypjEDdCNGAY+qy/5/sK2jj7oDeJTmCQVXS6pSmyFomn3EUg0kpYpzXYrnjfKWDwU0PaTVweUwPgiFdZYRqs39k9S7d1VFz02fXfAdZgE3LsXoGaJq5qWzqNsi0+1s37j4TyP09sIBO8iWdfHK4043nXQVVxr1imtHpufj/bZAcuC95i26j87CVk+3U7lfISGUtSv1jjKAKQqMzJtCRGpoP+jfPzPZKoXGTpz/sLfd5b9Qr1yyE4D5hAtKUoD6pq69RQxTbsAQJYoRXrLxB1L9ko7PHnnpCSObxfJYMM0ZnW87nHzKw+U
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7a1dd13-d3e1-4387-df9f-08de655b5545
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2026 08:40:07.9380
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5JHvi0ga1FoSy+ypJHq4YKZ2UDfxoMM9WKbxucaKpus3funIsA+X1RW/JZZo2s8NicBfWicveseaGLn9NieGmdp6ix6hY+yReiREky81wSI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR04MB9248

Hello Darrick,

Recently, my fstests run for null_blk (8GiB size) as SCRATCH_DEV failed at
xfs/802 [3]. I took a look and observed following points:

1) xfs_scrub_all command ran as expected. Even though SCRATCH_DEV is mounte=
d,
   it did not scrub SCRATCH_DEV. Hence the failure.
2) xfs_scrub_all uses lsblk command to list all mounted xfs filesystems [1]=
.
   However, lsblk command does not report that SCRATCH_DEV is mounted as xf=
s.
3) I leanred that lsblk command refers to udev database [2], and udev datab=
ase
   sometimes fails to update the filesystem information. This is the case f=
or
   the null_blk as SCRATCH_DEV on my test nodes.

Based on these observations, I think there are two points to improve:

1) I found "blkid -p" command reports that null_blk is mounted as xfs, even=
 when
   lsblk does not report it. I think xfs_scrub_all can be modified to use
   "blkid -p" instead of lsblk to find out xfs filesystems mounted.
2) When there are other xfs filesystems on the test node than TEST_DEV or
   SCRATCH_DEV, xfs_scrub_all changes the status of them. This does not sou=
nd
   good to me since it affects system status out of the test targets block
   devices. I think he test case can be improved to check that there is no =
other
   xfs filesystems mounted other than TEST_DEV or SCRATCH_DEV/s. If not, th=
e
   test case should be skipped.

At this moment, I don't have time to create patches for the improvements ab=
ove.
If anyone can work on them, it will be appreciated.

[1] https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/tree/scrub/xfs_s=
crub_all.py.in#n55
[2] https://unix.stackexchange.com/questions/642598/lsblk-file-system-type-=
not-appears-from-lsblk#642600

[3] xfs/802 failure console message

xfs/802            - output mismatch (see /home/shin/kts/kernel-test-suite/=
src/xfstests/results//xfs/802.out.bad)
    --- tests/xfs/802.out       2026-02-04 20:44:52.254221182 +0900
    +++ /home/shin/kts/kernel-test-suite/src/xfstests/results//xfs/802.out.=
bad  2026-02-06 17:04:24.336536185 +0900
    @@ -2,4 +2,7 @@
     Format and populate
     Scrub Scratch FS
     Scrub Everything
    +Health status has not been collected for this filesystem.
    +Please run xfs_scrub(8) to remedy this situation.
    +cannot find evidence that /var/kts/scratch was scrubbed
     Scrub Done
    ...
    (Run 'diff -u /home/shin/kts/kernel-test-suite/src/xfstests/tests/xfs/8=
02.out /home/shin/kts/kernel-test-suite/src/xfstests/results//xfs/802.out.b=
ad'  to see the entire diff)=
