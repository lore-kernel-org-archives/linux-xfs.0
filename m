Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.57
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795540754;
	b=tANaf7bm1c1hhnqCb3heVBr3RbzVXfRRKVTX4eJhDCcfe4fCa771lo7WqVDDDq6kuCJH
	 oltpFCFcL1YkzM7ixgw4WMNWXSMyjZhNdAu/mqzbF8Zt0tQDmYLfbZAN9xaXz3K0cRTAb
	 mPWtyQwMdmow55BgeZqa3AFFrcxJjB54x/GuLZ237/Bu0PoBHaLB5UfyQeswJnPIXvj1v
	 NnUMybiLImWxtox2kijmszuYF+bSOBQTkPjihuiMBN6tP5bCGSDeGsn6FxW3FPv6wNtAY
	 DHfHckNelpr3pyij76ejfyyoPUozcUGTOI7UNqu/FK6XxTAO71kcss2PyAFbW5MGDaA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795540754;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 msip_labels:x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-atpmessageproperties:x-etr-sdm:
	 x-ms-exchange-senderadcheck:x-ms-exchange-antispam-relay:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=vw2FvO65NxUPD/St8VaFlgQlxb7qFTCxscUoxAeBhVY=;
	b=xVSOvGQh+CcA6yMgkDVbVkR9jSCJr34Dx6pb9vvrflsuvH6pfA6FrUXwkDLYCm9LSTNW
	 KTx9dN/8hbPef+yF6r98dAOn2Ym/R01tWx8N2nPc9ZRz9lVB+JaiTXUO5WOFfaCchoUzo
	 SIWOeABlH4rXIabaiNXhdNLEljGqozcS0X99XCmbCSlcrP6XMvQJ7go9VAPauTwaYN0Pg
	 zWTlrMD4+xPVbt6M83tuYoMGhQq1eLJq07Y49W7X0UiGysPL7t3OY2m3LAg3Nke4/1BzW
	 /OrFpADUU9JPF0vllZO/59U/e3rye+t3hTgZ1XWqbqxaEd78C5qjwv4nHpvXwRtPkEQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=solidigm.com;
	spf=fail smtp.mailfrom=solidigm.com;
	dkim=pass header.d=solidigm.com header.i=@solidigm.com header.a=rsa-sha256 header.s=selector2 header.b=GdvrpoUn;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.57
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010057.outbound.protection.outlook.com [52.101.201.57])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5430606A31E;
	Tue, 24 Nov 2026 17:19:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A5430606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=solidigm.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=solidigm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=solidigm.com header.i=@solidigm.com header.a=rsa-sha256 header.s=selector2 header.b=GdvrpoUn
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mtqe3muXcR/HwqWerdrK7e6Yb/ndl3y0HZAXL+lC4niuZjjL6aI1ELbwuhZJ2ZuxLmshM5sHVcyu+y6I6ELiooIJ38NmM0/HB0lEWHWxNRx5iZKbnOc2CSUT4KznhG3PVy7pbd8VfU9+Y1iw1nSnPydBSOekdE9aWLwCeV+gjFezZOaHPO1yz2fWN6KUBuSNnHjsB5o+qQaXDZAAiLuOMqfN15v/o7sK1375gAjQPhClIKzogJiRn75b5/qmngzGNSfd7jFyymHPaKMDGBWFpY4WUavcZLMSEQE36C+2bbQyIa+L9naX+EmMPEd2OUJdlqsERKbYZhEH+1/zMna5uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vw2FvO65NxUPD/St8VaFlgQlxb7qFTCxscUoxAeBhVY=;
 b=Ne7+E6he66av30CahoJPciqfTW4LyXjeUjg71CRxjZnvVfP881fpSRvKZVmQ39W28zTk2EtYuM5ra6oGmO+lVlXcJcL7310L3Ix+QoR/SYlf5y7/mJMa2bmHs0pVoOoo7P46JIsNmwq9+8rxv/2OR0hWVX1t71iBpTUmGrXTndJKOo96++Oqkva9pOwmurNt6YgveILgsUWceenJUwFFzX9uoVvJp7iUP/tX3SA5OTE9vku47MukBAvqYYBOjkMGz7d1yDcSAjIFACAtoYg61G+R2m/PGYELEyG2VsvewgNtgnN0yePE+USXO78jhuSl2WgCp3qKON7BihLyGV96AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solidigm.com; dmarc=pass action=none header.from=solidigm.com;
 dkim=pass header.d=solidigm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=solidigm.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vw2FvO65NxUPD/St8VaFlgQlxb7qFTCxscUoxAeBhVY=;
 b=GdvrpoUntia8Vi+6L9MaNgch5UpZqpogDrKtAcF72ndYDeHT1qmP2+5spidhXKaug5zsNWAvdzdRt8whqq5KRKkBSO5qDYKuAk9mC+6Uy84jTGKL1WoZsp+a7/bXpriLLweAQviUC5kAPAZ8abh8NvQfqlCIqOFJRw/FUAQiF/dPsB3unqEVj3vlhzNTHWQn0InGYvHabYvvFh26ot2HaRrqynn4O+LlUBwWrYEdpKhI2AN/lowYwGcKjoCMDC9VfobiqpvHvpLkPR6f74rZWp1usVG8jnov3m452HzpKgIgW0kfChW+6pAQJdgWQiwFehwQ9ka9/Ir/l8S+09mF/w==
Received: from LV0PR10MB997684.namprd10.prod.outlook.com
 (2603:10b6:408:33f::17) by SA1PR10MB6663.namprd10.prod.outlook.com
 (2603:10b6:806:2ba::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Tue, 24 Nov
 2026 17:19:01 +0000
Received: from LV0PR10MB997684.namprd10.prod.outlook.com
 ([fe80::2b69:d102:4935:e368]) by LV0PR10MB997684.namprd10.prod.outlook.com
 ([fe80::2b69:d102:4935:e368%5]) with mapi id 15.21.0662.001; Tue, 24 Nov 2026
 17:19:01 +0000
From: Wayne Gao <Wayne.Gao1@solidigm.com>
To: John Garry <john.garry@linux.dev>, Dave Chinner <dgc@kernel.org>, Wayne
 Gao <Wayne.Gao1@solidigm.com>
CC: "cem@kernel.org" <cem@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "linux-api@vger.kernel.org"
	<linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH] xfs: add a per-filesystem switch to force atomic CoW
Thread-Topic: [RFC PATCH] xfs: add a per-filesystem switch to force atomic CoW
Thread-Index: Ad15z2WocV/7eyH8R22b/KBFBzWDVwBt1w8AABnpZwAAEkoDEA==
Date: Tue, 24 Nov 2026 17:19:01 +0000
Message-ID:
 <LV0PR10MB997684BABC9308E8156E972B42B9442@LV0PR10MB997684.namprd10.prod.outlook.com>
References:
 <LV0PR10MB997684D5CA8A6AC037F6D1CD8AB9472@LV0PR10MB997684.namprd10.prod.outlook.com>
 <awSd1JEB0F4WeKt0@dread> <2a615ca6-3777-4b71-bea6-4072d4fbd950@linux.dev>
In-Reply-To: <2a615ca6-3777-4b71-bea6-4072d4fbd950@linux.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_ActionId=e9ef09ad-a1a4-4f7c-9e6c-fd857e261114;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_ContentBits=0;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_Enabled=true;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_Method=Standard;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_Name=P2
 Confidential;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_SetDate=2026-11-24T17:16:36Z;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_SiteId=4bb44aac-867a-4be0-aa34-30794e8470dd;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=solidigm.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR10MB997684:EE_|SA1PR10MB6663:EE_
x-ms-office365-filtering-correlation-id: 9884ff77-3f3b-404c-f977-08df4a4f0869
x-ms-exchange-atpmessageproperties: SA
x-etr-sdm: Outbound Disclaimer
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|38070700021|261028144727099003|261026140227099003|261026121527099003|261102123227099003|261022075727099003|261022105027099003|261022113327099003|5023799004|11063799006|4143699003|10067099003|56012099006|261021123027099003|261021121427099003|22082099003|18002099003|55112099003|261009223027099003|6133799003;
x-microsoft-antispam-message-info:
 Cf/1/+GP4mJ8mjGn8Qt1b0PC1aUt1AdQW0RY2o61W2RmqBgT3SBrgXqxNVX13zhvsbLwHbo0MYw+cD8HivDK9n9I+MMI8QNZxHVqGlrbZJoVF9waUOI2q+PvrEYZF+YSan1QHeFh1Czdc0IpeByt36sXuE/30FcelvMwKgU9eqQTEvsufo75ggAVqkaDENhYmEb/i3l7Z7QLeIiqosrjn16Dw/G93GHSyDxb28S+xPxr/BUmXEb6RaNSMAnmgCQIAaCFGk7Q4/IkWn7HvWYWmz+690T+0ItgORm0UJ6KpvrIc6C8O0esdxnpZ5ZMUQxg5xx7XR5x8byUxlbXOXdl2X5cwD33k5CpOQtidbgw00f/5XmGfn7zSOqcDBOQrgk7C3khrZ/IB1bUQ8cfyGGMW1rolnVQ046DIm8XR2awCCbtXOhVYZc8X9+9XGkpvLBCXAIEXX2Zd4DqEMCH82NgX2lpScJzVO8Ml539+Y4Xqhb7ecArEDatsA218mwza1PUms60bROh04CZgN4EKxhBw/nN4QfhBUkD/PTrhEVJscDAmwSe0mcZhcFygS+3PMdmGIUs6Y8qSiITpgjG1CDGJzOK/qwNb6ZPwupXCf3ecD2/53Qesjq9C+QW/AoCJiigZW5efnpJM+s5wXzZbM4FFvoIjnQwQD7NmnQ4Daa5c5FJ+t9RdhUBucT1Tj+5r/dwkvNGvQ3PFcshOr3rjJWBWw==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR10MB997684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(38070700021)(261028144727099003)(261026140227099003)(261026121527099003)(261102123227099003)(261022075727099003)(261022105027099003)(261022113327099003)(5023799004)(11063799006)(4143699003)(10067099003)(56012099006)(261021123027099003)(261021121427099003)(22082099003)(18002099003)(55112099003)(261009223027099003)(6133799003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?gy3SI9XvJqiuEihOr2TXrqMeaGkc61boyrbw7U+3AUnmj7rVSmRRd+3sluEH?=
 =?us-ascii?Q?/Qhux6yr9ftTU7ZKe4f3nvINNgciHKbw/jIg2M9Xy/r/ZsEGVZ2TtKPTM/KQ?=
 =?us-ascii?Q?Q6qSW3jeqTtxT5capfknxz3J4SrNLdCUjAJdRystPalGjF/QeZwL7t2MfxmG?=
 =?us-ascii?Q?XqQzo1plOnQh/4imMfriiLLw0Aszgi0YD39x3cvYbxdxWHgIcqSs6Jt1kqms?=
 =?us-ascii?Q?Hqsg4cKiQeieV9lDp4wC3Jzoh2ST1qydOtRSmp40Fdr8K0C04IQCCn3m86fz?=
 =?us-ascii?Q?C1T48M8/TqGSRPJw6UDZdNt79lax7JGIZf6Qwj6yYNqFxsh+1U2see+P5dRF?=
 =?us-ascii?Q?c0QpnkfbC694QbzMqexUp8D8x7+yPgEyrbnabbXJJWkABj/WaCPaGb2mGpdx?=
 =?us-ascii?Q?ZnTil8Td3vdyNJdTKJsmhEeOim93iKSXCQEiYtvzHleVjhzhyHyfp0yQ7r4a?=
 =?us-ascii?Q?auS+fZHgbheyP+xuyNG/RxkCEyKGLnaTxc+xdcdXjULRyp7mYWyo1Qs2T3aq?=
 =?us-ascii?Q?Ulaes/lIfodo4hufI9qGcJYFOOFCgTJa0G8l5lMtk+ENSxv7ouCIrVOHAzRn?=
 =?us-ascii?Q?ndHr4OIeKp3avs9KRoLGveQsHyf5kFt4oHvPTWfmkLCoQj/LeK0rVn6Q58Cc?=
 =?us-ascii?Q?LzvLwF+MIDYbJYdoQvzlaVS+edpjXCoelnvxU2Dk09D520g2UrJppj4cVsFr?=
 =?us-ascii?Q?BMjYgwUjs6OjITmuNHu8JEeYPjwdzohI/TCM6eIZLqktZdaeqglnT5wRgWVI?=
 =?us-ascii?Q?N6DBAdK6IlmE52Vx1GD4h2zYFxMmZRW5jkRQJxwrQHvQpboijfGAEbik2S4C?=
 =?us-ascii?Q?Jnzibh/aIMBqZundKBdiVKVHLVpQqbIzYBQk2bsRnQRbIrJlMKbnLQwxVg07?=
 =?us-ascii?Q?wdrhyA7kRN1MaAQqiqHVQVu1AD34HNfrEULaq44sy9IFSkG9youpQTYyANeA?=
 =?us-ascii?Q?R3cwgvF3BDeeuCdICJa3s3tls7Tx4x26CQ7fepXWYAxxkMWDXU+LnZUD1eDP?=
 =?us-ascii?Q?HeEtad4TWslAtuFMP0pxEPYtCNShDZDJzWFuT02O1K49BxQC08HO2wqVzU6A?=
 =?us-ascii?Q?8JFyYuQJGVUQ6J00lor1j0EaPc8R5EJA4dq5CaHIN9Utz/huKWNKOru2qxpK?=
 =?us-ascii?Q?uF0zQ6DaLGE/tNWbHS09Nl5JNMxS1+kuIAOYTQ0fXupqbMtEgcEvdkIfaavf?=
 =?us-ascii?Q?e7SY6EFa90BRNBRgm8yVvXwtKsC4LyCmGOz7iv7Lb3yiLEdt9AjnMvt26XRP?=
 =?us-ascii?Q?h3I8HlBZKhqhzFSSwX0RE1gwUmzUK1pKdN47YmERrm5Rn/4STVqN/kkfKJE9?=
 =?us-ascii?Q?QzpFcJ34/DW4/ESJgVPMmCGL+guSiA/gLwAprM1k6lrCNZFTIm0nDO/cxPIB?=
 =?us-ascii?Q?B7WVO+z0L5Y6g3ZLTWhYW9FbfYwCIeskFFYldciO+QaqH0m8WB8mLu1SXK/b?=
 =?us-ascii?Q?rblvvF3B6oEO3Vcc8WcBZsNyqxqjfk1h5dUAWXj0j0oq9WSokp/9hnnIQc2C?=
 =?us-ascii?Q?9ctfatgAppbHl+hA+ffoi7UWoVp9nehmCz5Bpa5L15YLcRSbpCJES2VXWqWi?=
 =?us-ascii?Q?k0JSE/HXovU/O1sC+gpQI8pM/Zwymg+S32DNPww5XRwDpeKKNTNPTKc6L6h7?=
 =?us-ascii?Q?9yEgZ94tDrrJv27LmBnMu8ArNQ28uDbrW6cGV84JCm5DTU5x0PSs9mXCxtFp?=
 =?us-ascii?Q?hqXfdQ5D0/JYjGfVtCh46b4hnHFD0pRS6cPqNbFqIjtf3WzRbX8f2mUMoZ6+?=
 =?us-ascii?Q?zwtJfcst/JnTFMVypjM+P90mwtSGRng=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: solidigm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV0PR10MB997684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9884ff77-3f3b-404c-f977-08df4a4f0869
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2026 17:19:01.2912
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4bb44aac-867a-4be0-aa34-30794e8470dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I6FvUgEvbfOKsiEQm89gPpr+mFDDyDZh2OwDR4nZhsCYNSb/MtXA8KnxF4gcnVShWu73TjBp1pqBn9QV+qUl3+Zn3k/DdcNuLUQJsIZNelyeKuvi0DzjEgRbQbpOu0SC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6663

> If so, why do we
> need this at the fs level? If not, why isn't it the hardware atomic
> write behaviour configurable at the bdev level?
>
Wayne, actually bdev level have no control to enable or disable it. And NVM=
e does not have any atomic field to process it differently. Only XFS honor =
this flag.

-----Original Message-----
From: John Garry <john.garry@linux.dev>
Sent: Tuesday, November 24, 2026 4:33 PM
To: Dave Chinner <dgc@kernel.org>; Wayne Gao <Wayne.Gao1@solidigm.com>
Cc: cem@kernel.org; linux-xfs@vger.kernel.org; linux-api@vger.kernel.org; l=
inux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] xfs: add a per-filesystem switch to force atomic C=
oW

[You don't often get email from john.garry@linux.dev. Learn why this is imp=
ortant at https://aka.ms/LearnAboutSenderIdentification ]

Caution: External Email


On 11/23/26 20:11, Dave Chinner wrote:
>> The intended use is a controlled comparison of hardware-backed and
>> software-backed RWF_ATOMIC writes on the same hardware, without
>> having to construct misaligned mappings to trigger fallback. The
>> existing DEBUG-only always_cow control also affects ordinary writes,
>> which changes the workload being compared.
> Ok, so you want it for your test/dev environment, not production?
>
> I thought we could already change the block device characteristics
> (i.e. support hw atomic wirite or not) at the block device level?

The block layer just accepts whatever atomic properties is reported by the =
block driver and there is no method in the block layer to change these limi=
ts or turn them off.

Then for the only block drivers which today support atomic - NVMe and SCSI =
- similarly these we just use the atomic limits reported in the disk.

> If so, why do we
> need this at the fs level? If not, why isn't it the hardware atomic
> write behaviour configurable at the bdev level?
>
Thanks,
John
CONFIDENTIALITY NOTICE: This email and any files attached may contain confi=
dential information and may be restricted from disclosure by corporate conf=
identiality guidelines, or applicable state and federal law. It is intended=
 solely for the use of the person or entity to whom the email was addressed=
. If you are not the intended recipient of this message, be advised that an=
y dissemination, distribution, or use of the contents of this message is st=
rictly prohibited. Please delete this email from your system if you are not=
 the intended recipient.
