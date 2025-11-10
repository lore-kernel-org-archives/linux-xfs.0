Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA45E30E83E
	for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 12:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762778790; cv=fail; b=h2RDmgVEUB58eslWYff++8H/5GqiFu3lHCYgO24hDSzwkzFOXfFAbf9QQv0uDABrCFar6heHBGSM+eEv1SAHhRU8eZjW44chRlBj0PfzFMTKlNSyjtDISi4muAER8hx5pIfuyxGp4vdPbP2dOsOFSazhMkvnmjTdjURQHrxKQuA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762778790; c=relaxed/simple;
	bh=or4RH94XozASg9wHYKnToni13a+cfXi5uaHHyt4K1PA=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=udayNK1Lx58H0+shMi/KMwPXE6b4BOZ/cENRciuzk8o2vWsTZoozjiRUH5bTBYQ93TRfLYb21+cueSvPr2Ze4zWDmhBcVrIW5CIKxTx1o7wNc97SBLwypSGemI6+ipNiH89L/Knw+dJUG4/+qfrOuGQDIYqAlmtRub0PV3xqnFA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=T5XU/CHd; dkim=fail (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=IjjC7lep reason="signature verification failed"; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="T5XU/CHd";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="IjjC7lep"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1762778788; x=1794314788;
  h=from:to:cc:date:message-id:references:in-reply-to:
   mime-version:subject;
  bh=or4RH94XozASg9wHYKnToni13a+cfXi5uaHHyt4K1PA=;
  b=T5XU/CHd+7rRO6szrXx5I0qH0XRUa3qRHgL+GZQpD1EwTQxDlxzVplWo
   HXOZhnJmtQstrdAscPgjVfAwyIsqOE4vPWO0Fb0G7OA+rAQIWAJazhzRl
   M+VztoXmLt9BKnj29ev7+e5bB5TyS6tAP4UW+p1zlKdGfA1jpIA6dksfm
   q1pZlTiynkkrBBPeY/aHq5M8jyj+J4xN7/d8YceAaHC2cC7qWRw9kIIvr
   k0bZkvsjvGoSdrgtG6y1NKbb+x2SjoSiBC0SIMedSouKf3rB4M6LVZGWJ
   fuod35JYrdXe5dv7n01TW2TZsA9FYUwUXtDeneW2pe1wpp5QhdGFL2+31
   g==;
X-CSE-ConnectionGUID: zagZQ0FfQNKOou4782Yg9A==
X-CSE-MsgGUID: wMz8EULgR8mFbvvb5QyJjw==
X-IronPort-AV: E=Sophos;i="6.19,293,1754928000"; 
   d="full'?gz'50?scan'50,208,50";a="134849754"
Subject: [WARNING: UNSCANNABLE EXTRACTION FAILED]Re: [bug report] fstests generic/774 hang
Received: from mail-westusazon11012054.outbound.protection.outlook.com (HELO SJ2PR03CU001.outbound.protection.outlook.com) ([52.101.43.54])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Nov 2025 20:46:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oAbrva5a+ddPZYKQapLnVpWA87YshmSJ+K4bztOZuVuyFGZveHTvNSSCNscO8LF8MhLKe9A2uzClZqUCQPBT0YviLDVw/8srZk3lqy7yvXtpWX1YN0m742/KBf+4wcYOvRf2GHzyBXm1ePs7g0CCn4bUCgZFE3b9lR3Vn29F+csJuofqQE2pY2pa3DuGRi9dqpgdQUMipJJW37PNFB3rJeVjOvlvogGwYHhfSVC7FoatzBVZ4FrNJGnnYG8VKlMFX7Cbttb0Z4ch41vJH876yHGYXeZAcBqTyX1gQYaVDj7q/rrU+X7CsSU9hYsv5YBOuV+3VeaDLHvDiawrMKHJKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kh/rXtwXWhKXtcX2muVekersrK4m3xNCwQHv2sTWIMI=;
 b=caSEptHqXom1WMmD84ow07yosoAj1Pu4RSxs7JEtORpnddEkGxIDt+tNnxtZf1tTm9gXJcn7AmNC6ZoOgaoLmaWOdF8nOH+KPQqKMho2QirTlgXIMxza792bBhB+vVDFhhpn+DYM1DXbT9BggeebuCnB2j9KQ4xbGr36vQWpEEhzNO54ruUIlAValPsNr+8nvjxVmpcbS2SOwqh48INwkUgsMKE8HAty02zcj9i8I2xpPCuFj4+vlP43sK8PRyPbGVSox0AsmGYbR9NNPPvCRsevf0vmXW6PZ3JBLbaXNxAkonBzhbFUiSoBMIGyuGkYT/dHo/M0pFe7wQkORFtGHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kh/rXtwXWhKXtcX2muVekersrK4m3xNCwQHv2sTWIMI=;
 b=IjjC7lepSKTvvnYrFgZb/Wg7qaKD8m1+4s3sYJ1cwbhJ0udtBmWqdMnCj3yPA0OJIl+9nuyW8DMZMAgODVJgc77GUHktRW3yDtotM18itHr1H1BreTb5ywLOClpeFr64bYjgAz02zhTaBLKeKrTLZyw7Zz2exV4o54B4kCVodog=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by BY5PR04MB6850.namprd04.prod.outlook.com (2603:10b6:a03:21a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 12:46:20 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%7]) with mapi id 15.20.9298.015; Mon, 10 Nov 2025
 12:46:20 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
CC: John Garry <john.g.garry@oracle.com>, "Darrick J. Wong"
	<djwong@kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Thread-Topic: [bug report] fstests generic/774 hang
Thread-Index:
 AQHcSXl9LlvNthA6Oka+c9m+4a5IsrTjRJmAgAAdnYCAAG3sAIAAHemAgAAgzgCAAUpDgIAE9XYAgAGefwA=
Date: Mon, 10 Nov 2025 12:46:19 +0000
Message-ID: <gefhyxokf7l2kbwy4fazphvh3dlodztngje7r4n76zmvylpgri@kca45isrne2e>
References: <cmk52aqexackyz65phxgme55a3tdrermo3o4skr4lo4pwvvvcp@jmcblnfikbp2>
 <20251105003315.GZ196370@frogsfrogsfrogs>
 <mx6gzhhkvcdnadmmxziu77cuywq4ql5u2hp6fd673vorhx35pz@jmyv74f236ka>
 <c5cff4c3-cf0a-47cc-9ae5-20d7316b3c09@oracle.com>
 <2c4d144b-81fd-4e4c-90a8-fd3c2082246c@oracle.com>
 <6xn2324slfvddlzwydjxigijdfu7gbpzk77iumjiubolirqzd3@fbuqjbbirtc4>
 <coeibafpki7dasbxwom36kwjpfiv4urshmderxovgyuefx22pv@jiyp3ll44kyr>
 <aRCC5lFFkWuL0Lph@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
In-Reply-To:
 <aRCC5lFFkWuL0Lph@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|BY5PR04MB6850:EE_
x-ms-office365-filtering-correlation-id: 93c6f208-136a-482b-0250-08de205725d2
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|19092799006|38070700021|4053099003;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?ZXaBA35Y0F0x7/YW1gnMusYQwuMMMkkFEhpwTY2PI8yklh2B0T5rAx9LWSLU?=
 =?us-ascii?Q?p+DFkzihCZ4hbe0oZ/X0pJdrms67BR3FhWwvd/Ro8hTeXubMdXRiJfSOkweq?=
 =?us-ascii?Q?CSEqRsrfb4nM2Udy/IyTmTzjuqAakyDZjF3Ah3yNv1dGDkhQc33MDMp80r6x?=
 =?us-ascii?Q?Bq9BCiLj2PI36zbIRP2hhQ95JNIt+EdL0eaKa+WUsxkJGiiy1qRiYJ1kk080?=
 =?us-ascii?Q?zq1ekLKwB7YQDYLTYFgZertq8piEH7vq9avcTp11/QSBP4obfjkTn8tRGNY5?=
 =?us-ascii?Q?j6RkSRIbzsSEi+7qYWVHnsSbz7d2Bhnxgpho7tUVfk+RKbomYWlP/ZamabG4?=
 =?us-ascii?Q?hwRR7TRVXuk1Vh+X7IWq2AlCTSa4rqGk+bDh4tE8c5XKtRCt6dUgNtaEe/au?=
 =?us-ascii?Q?uvyl9LkN11CB2PnKIDPH3jE1Tt3K02l2QHEDzZ9Wu9tcHgrabu047qCCsqPt?=
 =?us-ascii?Q?lMnEk2hrRwYjEGYXNc/a5/4je0i2OaWYJFbS4DZZbxv6VZ7Giy0kzTXFUMZA?=
 =?us-ascii?Q?9rHQRhMxvDLcoZgZMnzWfaZP6KD+UiFOU+6+kgv2ZcO1Db3sdGNsv4FDHoof?=
 =?us-ascii?Q?xVEAmtquQeeWGLV+AyQDWNQpWAauiIZyxi3YY6beIvlpm9V6QCs5fmx9C/a1?=
 =?us-ascii?Q?3I8epLjQR8kLanXEgDQbp/nj3th3QvPI0kDFwSLR5/0lG8ItXE3aoB6ppyla?=
 =?us-ascii?Q?17EwAtlATIyPYFtmPK1wjW2E8IsWAr33kc5KPWB833U1E+oYC61hFtWz+wRq?=
 =?us-ascii?Q?uh59+mB7iUekcT/0TjxUYi2rYdAFLJz2uTeoTFAHLujDZCiQoYJ5aq4TfYlE?=
 =?us-ascii?Q?4Cl6TTpH2BwvORc5cke+lt0DV17qyglNp96a+YsUajbFNoPYhIp8TIeC51s4?=
 =?us-ascii?Q?d2Sp+4a8T/MGUEG4s97/5duUSG5VfGPxfeB8+D6m64W1qGjjuzx4Tgd18sh4?=
 =?us-ascii?Q?LvHcRMA9ylzWZ2tkYBbae+8k9fyrVRhMzfPZJBJ6kVy3zWcHFLuGUVR91EfF?=
 =?us-ascii?Q?l3R1TmnJi1U7PWfRdDyP43L8qFZMR4NutVf8SffAmoPwAVS2BrAtsT4GBPg+?=
 =?us-ascii?Q?mRxfunNcM/1MSxjQ5p2WhLVal2DiKTsrlFzRzMTli0oY7KhT29Fp8YkFsrAG?=
 =?us-ascii?Q?KpnmSqNQJQ3VJXDk9PzBYaS7ujsAoy7fzUf0F8ETEiBXha5A+BO1Pl6mcE1T?=
 =?us-ascii?Q?/UyrAlCpszsz8Ve9C0X2l6NmHDAKwfgq07jiJHtQvlb161oiSAVKV1bPLO75?=
 =?us-ascii?Q?MiIfRglZ3OfKcNig434ui5/eeYqxjxAyawde5p5NRdgenMMIvn+OZyhTBoXx?=
 =?us-ascii?Q?gwBAubBDjWAXO3TJXCctxOxp9gWbrlzmz6P+zp40P5oWqdswuHHAMoQOtKoU?=
 =?us-ascii?Q?nonXsQRj2m3SPOY/guwP3D2yACR7Yda0k6jscR1x7I1d4PmuBDiGwK/sUtww?=
 =?us-ascii?Q?Kezyh4PiEZZc7DPsPuJ2TqiyhvdUYc+Z?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(19092799006)(38070700021)(4053099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?yFfinUO8EH6kRVETKdBguQtsDuH7yUhq1Guh2dmVES0PZ7P8aUVBns4qdSKE?=
 =?us-ascii?Q?SmL+wZ7g2HVvYsXg2OfBiW6gtMy/pNAhByieov+RwS+tUFHAQhhuNV2Me+cJ?=
 =?us-ascii?Q?r5Gbt1VZErSty8UGjUWj8jDCV59z9L0qo2yff0XeH5sNLXbb97qfBR5iHD/L?=
 =?us-ascii?Q?4eXJzPWmxT/O9Z17A4RyMqPgX1OHzsQDZmnqVdLMx5uLXoo37ZOn6q3CCSzG?=
 =?us-ascii?Q?kKheFkM5oEPbZbxH0qpMqodIXnTSdaagIymFvsUyh3zYFV+sg1wJeoNskjo8?=
 =?us-ascii?Q?y90NEQG5mZQeXLV+f3BoSxHkTYEiqcTtP5ydz8AsRUwS7fqKnkBdNdP5iPLD?=
 =?us-ascii?Q?j0C+3fZhQlF/emCGAeRjnB20UGteqyveaz0BTrWhJdbb6y5qhT/rTc5NZ90q?=
 =?us-ascii?Q?hhvd5tcqjxrTvZUNPcHh5x2yD1KYVR28PMouTaAF2RIIMhWh8CKfa8b/g8vt?=
 =?us-ascii?Q?Gg1DoEk9ZA0yboHshQW1PaICc8sgACiwDSfJ2FqzsGU2CKGzsYE+H230N92A?=
 =?us-ascii?Q?Zit+UAn6WLoK19saoT+ZOe7CGkrRERy0GO1zNg61lBXLHdPqGKXSdbTsP9Vk?=
 =?us-ascii?Q?vhrc3e9AS4J3rEcu+0ChnyOVXELEHagO6xoyHSjQlaPpnUxGirNxJsG9Luxt?=
 =?us-ascii?Q?p/lJA5rO5d2AOQpbznHVcz94UVnEH7mZBibJ2lQVapg9p5/AwCLZIbscLqBu?=
 =?us-ascii?Q?r8MSiIXWc4ignrrbk/F5arLMe/fhrE4Jcl6isCYgtiLWbGPMChTV2GjUzXzs?=
 =?us-ascii?Q?7l1gEh7sYtNK7xeec1g7qOhKA3gcIIXNnXy5y4u1XFq1UCMjq04+ME6RnO+P?=
 =?us-ascii?Q?891q2PhGOGtj5T8dw+hHkTT02s6v7SFAiPa8uOTcVbVLhNLFVQmzx8++p7MJ?=
 =?us-ascii?Q?6yGMQngZ27AZLRX5rZQUChKKnBO6RVy6fiTTicgo2zoks7uGnR2QTuKx5lr6?=
 =?us-ascii?Q?JMkuKENusNIkdrJpVnTJ35lepVOQfwqokETwbHID3o+Y1aiDYX9jwX8CZNyc?=
 =?us-ascii?Q?BTsnYAUodM2DTclDvyt6a580VZtRYE0iHWMa8aR9IR9ikzU+IGh8m3VDSit0?=
 =?us-ascii?Q?Y0QTr2UOIyB0nbRJebH3JEZNijT4ZiO3ceIPWNzY6cknisubGVFN2mLPV7rs?=
 =?us-ascii?Q?U1Cnyd3wmiDCEWVcGMGIto4JBi6M+bx99GPVeZj+Uj4xx/gPCuf01Wf9gCWH?=
 =?us-ascii?Q?gTIcsVPL6vDmHfFfnqhMc4dly315lr11GA8l6jI6lH8iHqe884pxbMwvh3kb?=
 =?us-ascii?Q?jCTORz7HPkBZcBK0VFiRbDQg1XddjVplPB3mtUk+l0NLP4rp+nhCbVulQNP5?=
 =?us-ascii?Q?+ewuYusUIEIVRLO4zQXwY5UO1gEvGi7ouDzPhQhyZsZor633gzpMiDvh8NkK?=
 =?us-ascii?Q?Nhrt0fhhP29ujP2c7Kr8onVOFCDsjZ1Lv6YvyyTP8P7YULVctOqcf39irQ64?=
 =?us-ascii?Q?XHcP5xXBtlfx2OjXA4n0znUbUaNAkvlnXAekviT2s+J2N/7L7bXISyNyZQCW?=
 =?us-ascii?Q?GJdb+R5zhrILgrXlZVrRbmzAe92oVnr6ypTDNNG3qx1Mt0avQkKnUq4sexnl?=
 =?us-ascii?Q?W+tl4APQg/wUoBjqRZazeAWRAqXZpCbii/eZyBCiSUBNJUqhPrIXvr2yQN1+?=
 =?us-ascii?Q?GwLmLWwye10cJre+0I/rPxg=3D?=
Content-Type: multipart/mixed;
	boundary="_002_gefhyxokf7l2kbwy4fazphvh3dlodztngje7r4n76zmvylpgrikca45_"
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4jIeRSLfpTQpk3ubR+CF0j9eeSL+vjujnW0Clk7k5daNaDiAUdcxadDCnAFX4vn8yLMZIz7kSE3fTo935BXh6Hcj8R5+mmS81Ra4llEHZ6VHjRf7Qq1nVb3VmJyB3R87/AqVUI1amVPV+BWveIQRam9tF/pG86Ywe+3VJiaYecB1FztEn+qYWI/j8rHhB+a81Ya8XyCZZ0ruEctIMN0AxjdAQ0hJMWaMr1olzMXdLMt5HRXQ3gbpaFT73GiEZfX3LD+qKyy1NIaXwU2sawUHT1D7iqbYt+9S4WrFaS30KrD9zL1yANf1StyhJtGli6AVZuv6LjjSiQ55KjNLLGILcpajqvy54l6BTEo++rWZ1FNXL6jvil01Vcecx2Jf9Bovc6R9WlPSNa7HcLaMBweOyY/KNOI5HNNlBK3EnNKrccmLofcd9enLg8gsqx7PPamxXZzotwDJcXCaLMzJA+nucKZIUNMVUnrNrNFL9gII5xyxSbDr8danm8+FkZA8pRHaX28b5LZL0lReg1+Zcqkk8kDxz3331J8gHvYDQASI5fvIIlBUAeuEEz8oSbUf9lyWwFnqO4I+aK8NPnkWwfhItVTpUGEC5EtNBlaEKZWUtBxP59AXyfXozhqcgfIPUtX9
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93c6f208-136a-482b-0250-08de205725d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2025 12:46:20.1901
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CwTjiCMfH4twoxwCJAyTgbKN/N5WwHYCYYTGCD4sCE10j4hKnW6DgnMAwshve7H3BZMMO+aaZSnW+5gnHNmEAXINNYpw6OfzUw/K8rqZVWY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6850

--_002_gefhyxokf7l2kbwy4fazphvh3dlodztngje7r4n76zmvylpgrikca45_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EA35D2F2E433BE42B4520584C50735DC@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable

On Nov 09, 2025 / 17:32, Ojaswin Mujoo wrote:
> On Thu, Nov 06, 2025 at 08:19:12AM +0000, Shinichiro Kawasaki wrote:
[...]
> > I tried the other "atomicwrites" test. I found g778 took very long time=
.
> > I think it implies that g778 may have similar problem as g774.
> >=20
> >   g765: [not run] write atomic not supported by this block device
> >   g767: 11s
> >   g768: 13s
> >   g769: 13s
> >   g770: 35s
> >   g773: [not run] write atomic not supported by this block device
> >   g774: did not completed after 3 hours run (and kernel reported the IN=
FO messages)
> >   g775: 48s
> >   g776: [not run] write atomic not supported by this block device
> >   g778: did not completed after 50 minutes run
>=20
> Hi Shinichiro
>=20
> Hmm that's strange, g/778 should tune itself to the speed of the device
> ideally. Will you be able to share the results/generic/778.full file.
> That might give some hints.

Please find the attached 778.full.gz, which I copied about 50 minutes after
the test case start. The test case was still running at that time. Near the=
 end
of the full file, I find "Iteration 13". It looks like the test case is not
hanging, but just taking long time to complete the 20 iterations.

--_002_gefhyxokf7l2kbwy4fazphvh3dlodztngje7r4n76zmvylpgrikca45_
Content-Type: application/gzip; name="778.full.gz"
Content-Description: 778.full.gz
Content-Disposition: attachment; filename="778.full.gz"; size=1985;
	creation-date="Mon, 10 Nov 2025 12:46:19 GMT";
	modification-date="Mon, 10 Nov 2025 12:46:19 GMT"
Content-ID: <CC1552EDF563B34A93C47857464ECDB4@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64

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

--_002_gefhyxokf7l2kbwy4fazphvh3dlodztngje7r4n76zmvylpgrikca45_--
