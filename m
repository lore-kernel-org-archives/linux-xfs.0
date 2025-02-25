Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD0B2676F6;
	Tue, 25 Feb 2025 11:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740482849; cv=fail; b=BH0TgufS1hICSmT9JBR8yWdllM/9ap6ZQnDylnBDAkDedHsJ65FOZXyybdEKSgEDngIjLgpsS7YKkEAe8EG9t0SDSJNW9Tnyv6URXjqlKekdoEW69/yqYVnbpG3j59rm5b1ZlsrmjBfkDMP2oubB54BiSqn2eg6q6+0Fk5J78b4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740482849; c=relaxed/simple;
	bh=JGEr4+8o/dC8AGFEcSRDLbQIrjRbcjas4Lq8U5TyLmE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=phQIv+b3A0XWx3S5bJulkggJOOYvZ53UPDEbVn3DclXT5Y87A9jXY/LCrAoey5axc9IKNGuTWBmHAA2W1hK+owAIAX/6blYF2GEt76ESVXrSfQZnEVbYPFwqcdeScav+FQGZMnD8K9DJ5AIjbfXyuFpVJOjwxZnh4g3In8JmCUY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=rIsDvBy7; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=CTL0bKby; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="rIsDvBy7";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="CTL0bKby"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1740482847; x=1772018847;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JGEr4+8o/dC8AGFEcSRDLbQIrjRbcjas4Lq8U5TyLmE=;
  b=rIsDvBy7VJi0PsrbeLuqPdXbQxI2y/6kdSaGrpEmJP6VV6LAh7q+IaaO
   D0fiic0pGqu3fxhH2VTMqUAp03949hEMAJknCF/m63THQl8QQvw/f2/P4
   y2/9c0Uz48LIiMDlLVekjAgES6UbNzlHhVKpwI/1+uZBLwLAfYQD+up+B
   BSrqRiTJ4Gbs+rgPrBzc5IN2mWcXUD4VlSQzVg4/wc0NVe66o5Cc91cJN
   yWMoH/xY4zxMwGYVaLin8mzCjTLcNUhtXgR0Trc8V7W1SH+UAMSeyGyBX
   Djk7Q+2Ce53e7esWJxtA64Y0plMGWm5joHZaaULl4jMIh7E4x4AIAO72W
   w==;
X-CSE-ConnectionGUID: FLjWfStLR1uOWBp1+CBHIA==
X-CSE-MsgGUID: Na59xKALQxK9YWSB0ps+OQ==
X-IronPort-AV: E=Sophos;i="6.13,314,1732550400"; 
   d="scan'208";a="40401779"
Received: from mail-eastus2azlp17010023.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([40.93.12.23])
  by ob1.hgst.iphmx.com with ESMTP; 25 Feb 2025 19:27:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fjON168EGCdUF1UAvb2smir+D9U/NeeWLrFJE04jhEiQuPnxCs6lCSuIaVdfurTPpco2etOqOVvi9KZ4O0DBvSE2gxdL/mOBEEDuz2dI0JfOGhHvcqlCFt7b48ogOJZyrQk2CXHmcrNvmQe5rbfTZBeHZR/kUoOH4/l8/Fbz+rI2jTX4ooXqxk1VtlWUhqHReAU2v7tyXrWRFLd0nmX8EhTmGgxohBxfyCtkcYW++nDIHrZlTR+awR6Z+rZJtiIvYQf4HQ8lwhOF/7rY+LkmtZ+Z6FrRXK27/WBEj5g/FLdqU6bEEY3yCu+Xi5fWlH2XMBdoYUkPldV1MZt+ak7JcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RFyxV84CEVU/KmsHJ3tG9Xm1NOLfqPOWfg5xz+WGSMU=;
 b=bRJsOM3LQqepwdZW0hhhD5XyO/7vvIalZhlzO+/B2Obnl4wAMXQfZQ260tfjGQlN3xorLEzetGGhYmCuTmqLI4YiafykYQ2gylsIQQdBHsaj9v0eqDz64x0mglikAQYrDMnqTGF/62aKk8uct2hiv27t00C56LB4sSpVDV3XN6amDDjrZhqKp99L8nnfQyaPZzNxF3D4unKD4MmU2KT34Xv6a6EPzOlGXUix48d39FaXmGjKA+dlrRgsekkXiggLo4DPviBse7XOguWugN5qs5JEu6boNFdxEQImQamMb4EWS1T6ShghqUBgrJNY8fesNX0bPkgWTLxxo8/DZd+6yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RFyxV84CEVU/KmsHJ3tG9Xm1NOLfqPOWfg5xz+WGSMU=;
 b=CTL0bKbyzoyaAxbv/ozpewz+Cxwtp5kpsU+ls5VHdDdNZ5GwGLh9WmTAl0ahB9WWjvGH2sM1QKx0irMkX6P0t2wnNPsEQew+MxYZT54EqULMrOVZs8f+ft5NnnJBk1i8MvJC/1w9IGZ6u2xliSpwhNTZ+PZrk8mTbbI0Ts3tIDU=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 CH5PR04MB9573.namprd04.prod.outlook.com (2603:10b6:610:216::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8466.20; Tue, 25 Feb 2025 11:27:19 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%7]) with mapi id 15.20.8466.020; Tue, 25 Feb 2025
 11:27:19 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: "zlang@redhat.com" <zlang@redhat.com>, "dchinner@redhat.com"
	<dchinner@redhat.com>, "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Johannes Thumshirn
	<Johannes.Thumshirn@wdc.com>, Naohiro Aota <Naohiro.Aota@wdc.com>
Subject: Re: [PATCH v3.1 15/34] check: run tests in a private pid/mount
 namespace
Thread-Topic: [PATCH v3.1 15/34] check: run tests in a private pid/mount
 namespace
Thread-Index: AQHbh3g6PWS8ZtrV60aHdJXNmBxlEg==
Date: Tue, 25 Feb 2025 11:27:19 +0000
Message-ID: <6azplgcrw6czwucfm5cr7kh4xorkpwt7zmxoks5m5ptegnyme3@ldg2d6hmmdty>
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
 <173933094584.1758477.17381421804809266222.stgit@frogsfrogsfrogs>
 <20250214211341.GG21799@frogsfrogsfrogs>
In-Reply-To: <20250214211341.GG21799@frogsfrogsfrogs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|CH5PR04MB9573:EE_
x-ms-office365-filtering-correlation-id: 5c0b5f36-3873-4741-633f-08dd558f5d87
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?auqXqXmXY5bM+DpHdrCWeOr0VwMUmEIxoziC7Wfo7zeLcWtuKw/baNNdMokq?=
 =?us-ascii?Q?jyye3T548alRB4YyNLvPY5K+hxp5v29fZHP2VXlFknyP1tqTdmwAtPcf4fAu?=
 =?us-ascii?Q?sxZVgjxC7A2xB3sr2i8wa0tKRcPwesezKYEeCMAse50ClpWVY79ZBuGELnbT?=
 =?us-ascii?Q?f+yjgVG7LVE1hJqF1qPlyRfSqHv3b/SazRxNYY2Te7vYJoXcJDuHHGnPA7kk?=
 =?us-ascii?Q?51kZDoOS6p8pWkrHCM1UuwchOde2su4cjgoS6mMemULbvVp4RV8j+YvWs4LK?=
 =?us-ascii?Q?rwM5FbaAdZd3Ko6Q+TITqDX/xxno/We8D6SMmCsd6YbjwR9ThpXKqSKUe6xJ?=
 =?us-ascii?Q?1lm/XJn5lxUL+N43kwsp1pfyPOCfmrgyBXZjOwtFNZmuM8iKAvWtJY5tssnV?=
 =?us-ascii?Q?uVj4HFEWo6Ht57BpqFjzvkZ2vaW3iQUEBg6tXTfX3Rm34SyxPPTEJNdB9kqE?=
 =?us-ascii?Q?BzVzGvD9vGspokrHtdQdCsqI9uaYKWrdgzPgmcTrg9cl6GAie3bs/JHPPkoJ?=
 =?us-ascii?Q?lUct2g94nlhw7baou0Y+enZhZF2Kx2jShfWWoeVxrKFftLrR+J99Sayi0gNF?=
 =?us-ascii?Q?zb2vOU5KJHjYrnSSgVGATpGfVYVz6BZEHuknF3WvzU0R6PWQkDiA+ow3TaIy?=
 =?us-ascii?Q?fNG+gTwjV/nmCSB6xCE8km60+FHQ5bo4J6rsHg7LZVEKZ1MOZzEpStFKVz1k?=
 =?us-ascii?Q?uHeTyJNmmK6snP6v61HvG3yo5BRi0tY2PFzx4/ooI5Lni+t5GqOlRcaZEdn/?=
 =?us-ascii?Q?gkBYefdeyFednT/TnG7M3EiaPVF4GkG+XzeOJqcqo5jZPsdlu0nS+WMr5aYV?=
 =?us-ascii?Q?FsO2wG0fDe0gPsZXEn9sBD8ginYUpWwXStDf95lCueJh1JVe7AaxlZxPymx6?=
 =?us-ascii?Q?bxo9GQ7VKK9gmIkNHyRkxy9YxYhXtN3sMu2nsdIBU/MX3ZWxDbKGwLBt7Jdk?=
 =?us-ascii?Q?7QjHfA/gzZV+UH2YlhoXX4j0fFlp1LwQKX/AC52KJenXsQ0ycN+mdpr2BVBS?=
 =?us-ascii?Q?0neAIJdgVPsJwDyfZ9UheB7q3S8EzZUggZmpD9oIIvLNq4tozZn8i/elVuhO?=
 =?us-ascii?Q?FU5UriCmxrPbVW/PqI1JhNJ5h8/JU7DLLoH5K1ZkzZVpVYlCSi4UG9vHbvvv?=
 =?us-ascii?Q?XxDKIxUlt2Ix8h/iaHJDxf2hNP98lQKveYh/ZHVMJRHoSxUeX9JM/YsYITjM?=
 =?us-ascii?Q?SUOXn8hdBR24rUK0T9ImUMWIce/NNnVrYJ9e0fSFHJhGc+hXOW/QY8nHAJ9s?=
 =?us-ascii?Q?aeZWDl0M8Qst4LvUGFwCZFCxbYAV3bhUhHYmeBqm3J88wSglPy6jDGhEvFDX?=
 =?us-ascii?Q?kQTQbcSLt+oDJihLNhhOo9XnXudk+5BgnYDeCDAflpfTdZeTXqgFfQwFLnaJ?=
 =?us-ascii?Q?8fdLflRQbrwAAt+vmA4vj4lar5Eg9zE4Pdue3W2Xby8YVcZVBs5ri7jimb7u?=
 =?us-ascii?Q?yv11l0u57FgqmaNyfoamXHQHU+6Aact/?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?W+aHt3KYnwmXzpx0pjltCyGWNXfVJ3npso0P63NfZ5M/87y/lNW6dn1G9414?=
 =?us-ascii?Q?UITJE988MfXgBdb1rrh3lBdne9GJB/VhMeFDGAu3pGPhAcxh3R4xTGHAEBO2?=
 =?us-ascii?Q?t/ERu1F6sGJ25H9IipUEio8WtS9hlz5osK9wVUfZ/gKgFGVj2UXwwYcIHVdA?=
 =?us-ascii?Q?i0zluLTOwerUHPVJYGa3BebUJZAlzJOUAVyv5QZidP/5AbWn2QFTcf5XB9IS?=
 =?us-ascii?Q?8vaClPJzkyyZgguplMOCo7BTCZrbTkADbHw05zWMG6JzPpyFQ5nMMpE6Spe6?=
 =?us-ascii?Q?6u0d8eMQkzVTO1rY8fijrOnsaTb3cl7Hcve6mY53uFBJ+iKAn99B1cYSVT5B?=
 =?us-ascii?Q?+MY4xT+CclMs3DAdp/bzViqcMs0J3KPCiLg8xszAsvw2bz7LZso6CfgzNp7O?=
 =?us-ascii?Q?rcWWiUMxgTNzvQdW3ckLowd6I0f5WoVg6drIuM7C47e1ugTsK14R4IJuQHFf?=
 =?us-ascii?Q?ebgW7GNDfuABFhsj7m3t1VP1ryxUXUq3bqxBgh151iNfJpQ6eBlsLrdGU9m0?=
 =?us-ascii?Q?GTiFWLNutML+G/cOwjs9+6K8PgpZV1RGXXXiya3COelYvTfUzq06UvMyjDKn?=
 =?us-ascii?Q?FSHYAm7PH5l6icFwqspb4LN/difjiwgM0gZKArsTh94+oynItix3/1J80k5A?=
 =?us-ascii?Q?ITapgz2TB23bYLZyEwt5d3A1SRF+tzvzsUZSLa8bcYIu7hZZ8dEBo1B8GcSh?=
 =?us-ascii?Q?Q7umKqWgEKJMTtE90bR1G7P3epOPjqHP1IXikatC7qxtPlWIV55Al+His4oz?=
 =?us-ascii?Q?rn2wMfYpcb9QyXQTIqJm6eixagCrU+MZOlqMsSatq00uZkxDZNzRixqDGq/Q?=
 =?us-ascii?Q?LCmbMXrue8HdniztBDYAxubYfvHxkldPncvexrrn+zJMYDaktiI07q/tA3Y2?=
 =?us-ascii?Q?zQN9GSEfWCLTPfgogk5Kre4lBVVpOwcL/j0cxnYNj2EynUE44aKp0IFo2FkO?=
 =?us-ascii?Q?ZqbA5Ukjca7r1WiguRCM1fuKL0Mx9wuRXEuuoDaOX76Cthac+QuVhBbCAigM?=
 =?us-ascii?Q?obqGJN8hq3mT4ozgs4NxfMXrpdhT8v/q6fMYb60+mCLeSEQfNIeHSeKDCETL?=
 =?us-ascii?Q?BfnKDYqO5JidNI9ozO5qZyCYlnfhPAoyjYMUOdO3VFWSgeTgoUniPud4ObQ8?=
 =?us-ascii?Q?b7E3G0KqfTxw6eNfGhu43aTDVQYEy6/Ffd9A4k7GMGnPZ6iGBiN4iibvEk1l?=
 =?us-ascii?Q?G8ByS6G6TV6j+fbHv5kSHDAu4J7zHX9bvvZ4B2tgpLB9pfH/zfQsubMo1Cgy?=
 =?us-ascii?Q?5HfHwIqhdx0mVlc/noGL0KcrA50er4nMn+adU5e7s2ZlcbaOHqvvDNVqKR+T?=
 =?us-ascii?Q?sbJWaNxgO+v9oCBKm8zM8uVaNyfPJT+RZVbvjK+gAM5s2qquZ4CWxg4WdhI4?=
 =?us-ascii?Q?ktOrZU8cVwVgO27E7Ok+D0x8TuxFuewe0yxj1O97So1lFQVa2k3+e5VZkWZ5?=
 =?us-ascii?Q?Zjp1G4iHVmNMopdDJ6d4c6jGFB0TY+E3Hgbg7q1KkuQqZ73AUe9RKZZYPqX0?=
 =?us-ascii?Q?AMBCViteZS5/KmeyhzoA6fquUXE0SaQj3CNqYKqr9Vt/uyMj9w0itVpTIoXM?=
 =?us-ascii?Q?030pL/ChroQYYMzTJESdRX72n9eofwJAKeUthLgL3Rs0vXq0qQRj76zErSat?=
 =?us-ascii?Q?0iptdsG4PSL7MqpC98sampE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A96D90B19D54EE4B9288D0F37F8DBF1B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	usLO0m90BzpbJUDL47Clhk+13L1gDurrHX901DTvMV9sFC7bLtt7SADR0ZoYJN9OQrDFXgLwXIEU1HINDeDVnD0aCej7ghgk6FH3rcqcBZ3scjiXd7jdhMKHRlTL5zcgO4aEqBfLxGeDxgupQ2JDbkwwSy2Z4n0frtRQg8C3LgBfC9m2rOw01TiL5ZUXmFRYdfH4ireQep139Qn4rNp+4UL+jNhpA9nsOSZx/Clv7z2q7JBToMizWY3HEMkcbudEH6rJMyYms/nDC8kY4ISVCSqkMwotobh1Zm1xE2gJeUAXADI3yzjy8woXD3iDw5WTbDAxrLUqBapF27sL1BY/fMf+PGgtzsJ1R+SltVxFSbhQNJKEqy37sL+W+xHtZ+bTi3cL5uyPtmEmIiZJeeWk/o+bB360jcwEzsHZbkXjzLfGgzv7UV67sm/LJ7ITU4g/sdhLYACeNT2D3q9w6FHnyh/jxtngSoZFGVibi03lMGYlUY68BbALLyLnuNVIiV3sAOFG3H09qF/U8ZoeOxBNh17hvNU5PzJZMmrPNvaVsiR0LbxT+nE+Y6s3rFGLhqxnBjGiRwOmbpfxab1JP1/BsJfpqn/qzwI7AS8AoUur1xs68VrsD9OOT+kQT79kK62L
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c0b5f36-3873-4741-633f-08dd558f5d87
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2025 11:27:19.4061
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Tz60DW0o+OBTG+SYJv0oGZUKpNqB5+zERNBwrcX5Aw9zI0H15mrIAjpkgrdal3tPmmmlZ5LtK9iywQS8yC5pP1/bZxiFZVej8XkfyFA/3Fc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH5PR04MB9573

On Feb 14, 2025 / 13:13, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>=20
> As mentioned in the previous patch, trying to isolate processes from
> separate test instances through the use of distinct Unix process
> sessions is annoying due to the many complications with signal handling.
>=20
> Instead, we could just use nsexec to run the test program with a private
> pid namespace so that each test instance can only see its own processes;
> and private mount namespace so that tests writing to /tmp cannot clobber
> other tests or the stuff running on the main system.  Further, the
> process created by the clone(CLONE_NEWPID) call is considered the init
> process of that pid namespace, so all processes will be SIGKILL'd when
> the init process terminates, so we no longer need systemd scopes for
> externally enforced cleanup.
>=20
> However, it's not guaranteed that a particular kernel has pid and mount
> namespaces enabled.  Mount (2.4.19) and pid (2.6.24) namespaces have
> been around for a long time, but there's no hard requirement for the
> latter to be enabled in the kernel.  Therefore, this bugfix slips
> namespace support in alongside the session id thing.
>=20
> Declaring CONFIG_PID_NS=3Dn a deprecated configuration and removing
> support should be a separate conversation, not something that I have to
> do in a bug fix to get mainline QA back up.
>=20
> Note that the new helper cannot unmount the /proc it inherits before
> mounting a pidns-specific /proc because generic/504 relies on being able
> to read the init_pid_ns (aka systemwide) version of /proc/locks to find
> a file lock that was taken and leaked by a process.

Hello Darrick,

I ran fstests for zoned btrfs using the latest fstests tag v2025.02.23, and
observed all test cases failed with my set up. I bisected and found that th=
is
commit is the trigger. Let me share my observations.

For example, btrfs/001.out.bad contents are as follows:

  QA output created by 001
  mount: bad usage
  Try 'mount --help' for more information.
  common/rc: retrying test device mount with external set
  mount: bad usage
  Try 'mount --help' for more information.
  common/rc: could not mount /dev/sda on common/config: TEST_DIR (/tmp/test=
) is not a directory

As the last line above shows, fstests failed to find out TEST_DIR, /tmp/tes=
t.

My set up uses mount point directories in tmpfs, /tmp/*:

  export TEST_DIR=3D/tmp/test
  export SCRATCH_MNT=3D/tmp/scratch

I guessed that tmpfs might be a cause. As a trial, I modified these to,

  export TEST_DIR=3D/var/test
  export SCRATCH_MNT=3D/var/scratch

then I observed the failures disappeared. I guess this implies that the com=
mit
for the private pid/mount namespace makes tmpfs unique to each namespace. T=
hen,
the the mount points in tmpfs were not found in the private namespaces cont=
ext,
probably.

If this guess is correct, in indicates that tmpfs can no longer be used for
fstests mount points. Is this expected?=
