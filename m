Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD451C2302;
	Tue,  8 Oct 2024 10:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728384739; cv=fail; b=gWzH+icvJcfvrnBWl68jdjiegCvrKEP92ZwWzHksQK35v3Bw6bG4eEEr2mpdfqu0aRdgQlTsyFkEnomM/zKwdI8VcO7jCD/kOYt19fswcWPHm64NXHdUOfgeRnd+2jnqXo8yX3X3ONZqF0070uK73Jd2PU3p5++hRHdyhwKY67c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728384739; c=relaxed/simple;
	bh=14Dcdefdeu9IbIlN5+PEphr6c/kG8SDh1MJnwW7uBCU=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=BkF6Xjtr/WIi3HO+c9R1cYUbER3jdTx6ZmANPCiNiDQHDk5fEhWkC6nsLq7RKpSwwkfRbF5Jb5mIMX2K0H1/Nt5WAiNofqHCOap0w/3A5mdDG13yGiQWU77yvt6sI2LobBj42y9DNzmZQuk8E9dZ6imV7n31babAOQndNhHf+OQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=gjLAIlvQ; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=fsBoklYF; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gjLAIlvQ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="fsBoklYF"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1728384737; x=1759920737;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=14Dcdefdeu9IbIlN5+PEphr6c/kG8SDh1MJnwW7uBCU=;
  b=gjLAIlvQMa4tLfehkHX9vzEdIy9nO3hd6sw34uic3u2DNrIdda4+v5+M
   x4io4LmXAOUICZO4GevpBPjRAHaPgu6YTQKk/nhpgQQdUQaj/JUPjPLJU
   y41aPD9I2R3d7UwC1mM/ahTR5AUajz2xa25CIS+ywmVPiFgAEP5iAaLMc
   I7VVdZCYA9h2UYQzwMnqWRYnyGDaqQCZXhfAN7m71+VgY2KABZ50qo9O2
   HQ2bSfjL7JTSCOJ2XP/30e1E/gxDR0KdtTOEG3g0ZvR5sQ/yrhyMSvoFA
   ZedkJwfufFq/ipawG/VL/0506+r2Gj5RQd1QczdGf39ggKsT63L59LroB
   g==;
X-CSE-ConnectionGUID: Qv3Tf4vwQYmnmH99tiOLaA==
X-CSE-MsgGUID: BE5H+YScSfClOdI0ecuq8g==
X-IronPort-AV: E=Sophos;i="6.11,186,1725292800"; 
   d="scan'208";a="29398711"
Received: from mail-southcentralusazlp17012054.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.14.54])
  by ob1.hgst.iphmx.com with ESMTP; 08 Oct 2024 18:52:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aU4Fjd/JCn+f3CKj2F1XnPbbpuATLN5tx0pPcGsXlKXP/BH+yKvU6/gY5qlB5M3LVphrBZBlcp41settUC1Zy9onEi4tOMD7O38gyZCap39aQpGYtA8CIPick9boh7lREue5AOuBqrQQLzgOLXon4DZLFKBOdyvy3IZTH7/c6KanmmXZEQhAr/jWkq41VSV/qqrNNfaRb6DJhmXJvIrODY6wIOUolxco5sZLsJeCnDprDfry2ZQdeA85oHfyByFINz3YEAhjUvSSEaCmLZo1GUGdB1rzzUGICHf+8/uKRAi6xpKKJ8P1aRV4KRUQnQeR4VgteKcIF6PsTNlssSzBrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IO5L/tSauXVhPwPap+FyNMtBObWKzJfVMtupIRWiFXk=;
 b=SijCSEFWFbGW/A0fIJOnGaQk5KAMFJmTFhcGuA06YQY97WZh5KxVGF4ny1aeq6Eg8xQ2fB2e5Bk97QrxHbxEKd57z/N2YRA5mnO1ijjLMRx9eEBHDX6UF6p0Kro/Gt7E1SHnv+roDyDfrFYRGTVCJFKu860hQjZ3DqZMZNGtkE9sd3Z7zdD0TeQBRJ7r0VvvnnFzDoLqpZMVUzSHrizmpclYYfE4BuDtCCLjiSvfw4Z1qRKyqirZc3EUkHzOFxXaeFmEv12pNyppZDGVxlkop4MGRiyCEafeKFUAwTE18x1/Ob90as5DKqhXvvOX1ecHjREez8xo7ehQcP4rjl8l5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IO5L/tSauXVhPwPap+FyNMtBObWKzJfVMtupIRWiFXk=;
 b=fsBoklYFsZtBluCp3V3rNu2rU9H9o6WhegkCMC5m4JxvinLbfxNg6HgH6CodG5r3FqJ27bKdF+9YFdU8INzNbt4mEmyw4/+BW1KAIValNLKPnWnbNtLeF8OsjVOPERTsiz1Cq/l0HtaTGQylMG7kFl52sS6wpSBbgXSOcjxIw6M=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by CO6PR04MB7553.namprd04.prod.outlook.com (2603:10b6:303:a8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.23; Tue, 8 Oct
 2024 10:52:04 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%4]) with mapi id 15.20.8026.020; Tue, 8 Oct 2024
 10:52:03 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: "zlang@redhat.com" <zlang@redhat.com>, "djwong@kernel.org"
	<djwong@kernel.org>
CC: hch <hch@lst.de>, "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Hans Holmberg
	<Hans.Holmberg@wdc.com>
Subject: [PATCH 0/2] _scratch_mkfs_sized fixes for xfs rt devices
Thread-Topic: [PATCH 0/2] _scratch_mkfs_sized fixes for xfs rt devices
Thread-Index: AQHbGXAcDNmtKiZTk0Slf64ArF6TeA==
Date: Tue, 8 Oct 2024 10:52:03 +0000
Message-ID: <20241008105055.11928-1-hans.holmberg@wdc.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.46.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|CO6PR04MB7553:EE_
x-ms-office365-filtering-correlation-id: 86ebb5e1-2bef-4c1e-75bb-08dce7873eaa
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?kEcO46cfojd7+q3t9TPfPQd4ANiyLc+6Wingdzzdm0j94zEpDijrB1/50d?=
 =?iso-8859-1?Q?uCVcEmNq68v4AvW+BXVmtDg+aaToUSzLuB5ht7k+hlYYP2tUBp5cbsObjT?=
 =?iso-8859-1?Q?O8j0SnAGnWMORP5EJNTYMO9lkSDrxeha43Pzi/GCnj9js5BYo0OhVaW2Dy?=
 =?iso-8859-1?Q?pItNiZNAJWMP6sTz1+zPYlqtOQR3AGXTfWmSCdi69FM4sSbXwYxgQcLcNa?=
 =?iso-8859-1?Q?7OhtT61U7iRpLTEpP5s60JJ9h+YFHu5/HxM+SxV1WpTKuYuPWy8QUjfXih?=
 =?iso-8859-1?Q?XjHBzTVe2ff5kOcRUDgYsCyWHoupT4Pff8yyQq+GANyyIrduPHxh+PgeFZ?=
 =?iso-8859-1?Q?N/FTQOgqCPMUfOihTRnfq8HbVlf6+gqZjqbUFG2c6Mgg1FdleoaTvG9FAh?=
 =?iso-8859-1?Q?cqK+UFpOtPwtaNCjCfQ4CdCGmfBjzYa4ZY+Z/kCbE+O6U0nc2+zjozUvns?=
 =?iso-8859-1?Q?n3p0cJEOoLZung+HscMHlpPloFlYFCgb+hpc/4Vn8OZhllYjF5HyrA4JMR?=
 =?iso-8859-1?Q?aCgoGd+7BhmO+QLNS+QTxHC9Bpwtxka5VTbzgyCBBr4et/hE2P2mVdx4Ne?=
 =?iso-8859-1?Q?ZbnPBikHGKORyEpnGwmX0sXArgMld3T/FYf8Hld5bN3cSY6nbfELLD7P5W?=
 =?iso-8859-1?Q?LfYbMtQUq0Wi1KjIFBWMyHJE/OndGWodwU40a0XKOQ5FQuANsEDXiIMMmd?=
 =?iso-8859-1?Q?t4eaGuGBqiWRXyaYFlPvGzrfSx1XX0MapKCtmyIRzmgQoqUiw40EpWmYxZ?=
 =?iso-8859-1?Q?hqqLtr7ajh1oInoy6qNklRHdO2n+rpH94wulafwlsF1X/VkhzKZSBIuZrH?=
 =?iso-8859-1?Q?NSOKMHSeltJnlG5FAYlyc3jeHqNfALN4c7MFaQDujWo/K1NTv99581H4ex?=
 =?iso-8859-1?Q?tB8YJ5LiUgyVfdW4zZwxpCYnp+fIKjarN6e/JAE/axP8pPMhs/Hf6HSkPN?=
 =?iso-8859-1?Q?uBYHGY698S2AVfkWguBApxlBJpEgjM0kG1oE3J8P1Uhl6xKngyAEPyVcKy?=
 =?iso-8859-1?Q?BEQRtAh6l6G5P3Dummh7yyo60ubBqKy0gpTBVaU1wIBqFqaezaRD6dxcHa?=
 =?iso-8859-1?Q?k7VbFOc6JrHBT8+r/OK6BwS1Juvms6ti5qAqJKQbDrXWJXlIInyNGNTUiD?=
 =?iso-8859-1?Q?bl1CyyaBleAn0q3aqQBuIhsu9l2KvNQ67uLYERSMNSHIV56c5Ypg4hy4lj?=
 =?iso-8859-1?Q?pfKQMpVmphSLG/2weWZp9vUqI0t4rkYqHa04Z38f8r4DBo4/tTa0/fH980?=
 =?iso-8859-1?Q?20vztHww3QiBxNcgCjAs8PzKhLMV9+Hwa9abtR2aGIuV7zT2FRX06V2OnI?=
 =?iso-8859-1?Q?Zf3gmxfEoEzU2EnLOpL1vIkhmyctivy7d+LPCLrpfQ9pbqBjcZAj0F+506?=
 =?iso-8859-1?Q?T3cwfVi03s9jXdWFHMlH97snMJjheobg=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?R4bbJfqiEFgBzRp8SzheK9GzKVDfHCyBsybB9uY1U7RgFdmdIrOEy7jfWR?=
 =?iso-8859-1?Q?cwigoeoXmxaZApjlRM23agOdYxP2DWvo8Xk74TDYdpWWc0bRCI15fixFDg?=
 =?iso-8859-1?Q?TUTTgK71u9+UXboAXeQZDbYNPP+9yYFpnJS7v6jBcPkZS/EmvrgyWV0zQ4?=
 =?iso-8859-1?Q?isTQdyLtA//Z54+7GVGulFIiSN54RGp3At0IjdijJAmpFyS+Uiry5UdyyP?=
 =?iso-8859-1?Q?1YWUtAUF2KEfxuESQVtxRFLrPJcjc4u4r9iva9iCPtrzoGURbLDYko0pqo?=
 =?iso-8859-1?Q?8duicEW7hxXmpPpZuk9aIE9dxU5suxt2RFk4t10wbIAKn0lgXZo3mLbw8I?=
 =?iso-8859-1?Q?GJPVELLTVuOT32oNG2T2g5fjw9am16iwVTJpowBxxTd812wI/7M00xF4PJ?=
 =?iso-8859-1?Q?6tdToypbQOOVcH4Iz26sLMbRmjabYIP849en7zeD0O49opYfuXgkBKHaqn?=
 =?iso-8859-1?Q?jLHDsd4iJBpXWga7TSUcYG6xmlgRE2sDRVkNzLsWQRZ3GCwqATiY8xACOj?=
 =?iso-8859-1?Q?vIdqk8UvBgN1rFaHm5SAfV66o7wOz1PQzrFI4YWmeUfhKLdzFdGZxbmViY?=
 =?iso-8859-1?Q?5ngXTQZP8C6XPjA5JGNrUIoShxfKUJPmqQwbpD/2eJ/M8CrqNWHkR7QLTY?=
 =?iso-8859-1?Q?47fYjXwZ12m388zugK36d8ChEyyCptd9TURsz1McaOKR0giabH03oLSKV7?=
 =?iso-8859-1?Q?eBj9QIhbU23m9rdyKVi2jyz+9qf7fVBkcIe9J/zr3jUWAYHx1J+r/ou3Yl?=
 =?iso-8859-1?Q?Dp8f4pRm1JDq1v0Ih+HTZlPeIH4rvt5OFnwWyJ+m8J0f2wA7glemSP44VG?=
 =?iso-8859-1?Q?wXsXtPn5/5rEUHgQVarkG1aFV3YW7W24ROQBh032yhamAyPnCklTGm0KD+?=
 =?iso-8859-1?Q?LMy8p015xQjYhJRP76cHC4K0IjUrI0d/3sy7lkroBU6/qWQkGZeF+SE4VQ?=
 =?iso-8859-1?Q?q0rbUcMgVR5h12FxhEpTK2+GYcQCY+pMRbBs1iG2dUxFRXLA2wGrH6iHYK?=
 =?iso-8859-1?Q?yuzFeraT1ZonrqmObcErzhOO4iQtfIbv+nFLl+gMiRZtFua4jEWWwbR6CR?=
 =?iso-8859-1?Q?+AULSiYGpqG69aF2e2fT5zb3ratI3H4TYA/fKQUQmwIzixa99g2xl0cNHp?=
 =?iso-8859-1?Q?bsCBk2OHXQ0YZdJUhmfoFl5LToGeJUFn2e2rDHO7v0KEDVXP+WuPiMeFIA?=
 =?iso-8859-1?Q?9W4QO9j1LSfa3s01T8xTNZYaXfw9kdm9WMBEBn+OZwRQWAhmH+29zIgBLk?=
 =?iso-8859-1?Q?gU/h/fE0o5WVu/9R/uK8CrSJtVgZCUef219LR8GMiHbSQDjPqFX95GDm0g?=
 =?iso-8859-1?Q?W7Ec32CyAtKUxVkFWTwbeCFVsnzV1pawLPQCoWzpzlmHJSsHB05wYecVpy?=
 =?iso-8859-1?Q?QaC0bW4ik5Mvo1RTNWZiTnE6bYc5kiV2CFk+r8tjB8wkR/EtAEtZEbsc9w?=
 =?iso-8859-1?Q?MuMM4PB4jBI2k+kChwYj/ft6lgcMQL/OCBYp8zD83wVLiTdfWAbBD9Ic4O?=
 =?iso-8859-1?Q?q4PfGkRPTu6i9Kcyy5M8s7eyKgY806tLEI3cmWmO4Q7tJhercw9O+KPbGp?=
 =?iso-8859-1?Q?JT4VNVks4nId2pQ2nyXSjszON7DvUD+tomCXTi4BUbRXaHoSVER4VCeAsN?=
 =?iso-8859-1?Q?nM4lGIY4FYq16WiAv8IaZWja1/QLLehbS8ywlJAmNU2ARli8rGsfMQVw?=
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
	YV97MAhuoxPfDrootdm2qCGHjocdvGHf9g3UTj5E1RolOsw7Rnf2w0psvP2mmon/OkyWecbYkOgi2ClNplVyS6iI3d+DlFzVBezGtg5DhB1yPuNmDCZkxpOHsFVvgIjkbXFPLZHRRqeraIhXEnQLCn+PEUAgJUSS2xODz9Y6xLBPbnHnC8x7+JINS1EzTkae7jnKu2fo80XXU7OZtmAUq9gmbAQgFGTQ93ejqTzixz4I1Z9fN5J/Y+Mk9uR2WtUSKe/B0rbUCz2bVpIVoMUcF48hWUjCt5IfBd0Y3qlWLsMFHmt3eLRwMNwEeb8sJOUchgo9zzQrXdHMwTT+Pl5MOB4ayGRzU1l9u0IgITrFqCqXxKRe0JKXrprfabcFU51i8koFcJbyuyACCEGOGBSXhlawTE6xzZB+HhO9xWciDIv6hm6o4uNLJ6Hq/wyptyUayYNMZOg/kybKh4RSX8pfTUFc1Ie7vAP9mOoN8dklImafOdRffWb/HU8nuUj9jBXnYQypQSGWsi4bebmQdyl/p117rapilU2hZaUeS+32jDGrv9pMrpRkDP+7P3b+speehZxQNm0I3/KuVqU1rliMCmp9x8FpM1vgbfsWXBpCPbymHjfVMWp4TFzV3X2M/BUA
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86ebb5e1-2bef-4c1e-75bb-08dce7873eaa
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2024 10:52:03.7222
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vESz35ew3/vAIvLYLqcDEmBCpS+CUMihQnuLBvM4nJ/Wlv+qcRwBw9ieP9qus0UIeJpjIPmrt0DWzn2Kyv0eOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7553

These patches fix up three failures that turned up in testing xfs in a
a zoned rt device setup, but the fixes should be applicable for
non-zoned rt testing as well.

Hans Holmberg (2):
  common: make rt_ops local in _try_scratch_mkfs_sized
  xfs/157,xfs/547,xfs/548: switch to using _scratch_mkfs_sized

 common/rc     |  1 +
 tests/xfs/157 | 12 ++++++++----
 tests/xfs/547 |  4 +++-
 tests/xfs/548 |  2 +-
 4 files changed, 13 insertions(+), 6 deletions(-)

--=20
2.34.1
