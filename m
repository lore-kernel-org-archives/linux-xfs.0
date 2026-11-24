Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.38
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795540569;
	b=YQnu5KP6Di2QAh7f6WtREf5uU0UVSvj4kwT4ZMbsedWoWUTzPWKLFK0UQG2w7Kp55W+0
	 lWyIOlQkh+Me9LGiFgON8sXkBp04ti9CF5pXdsZcv6CdcTY0tOhOmgDT/4XNGbwqvyyjk
	 S3WzG+5gCgVYQbKExnMsa/dJXIw6SZLGL0smECGMbyYjBQIs+A4kcsTAuf2sd16spwITz
	 SjT6IUTNnr16g1WIxWbsUelgB+mBnmWbAD6iMBSptikUTGzyy8pCSjjKPTxhGQHd+fUaT
	 BQPTl77yff25JM4atJDguEwhqe1J0DMX1OLcJToGscwXbuzLPFi6bdQBr/RUMQxtyxw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795540569;
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
	bh=cwXxQ7rOxRZ3jme9zJax/5w1jH6p7RkYA3JynHsPBGM=;
	b=EwFUcc1a4yye0luYJmpMNAsrJO233qbN2UZrl+Hale45YvJhgs5tygwlQViM5wH0d2Lt
	 qQkeR6QtTqjlPOz/gz9E4KYoxK+mSVZL9w/5J8PQdx926r0UYVTkhhz/m8J5r+AiGxNuj
	 8nBDfym9+L/SMRwgKdo6q341wjFNZMe8Qhp5m/vwc8SrwcGR0TK+OLrhmF24KcDkTwFi1
	 1QF/CalYZG8uovaV8D3RNEsvTnIFM7UnieqIBc5oItqeX5vq0/hlZSOzhe6BPE9cvevcc
	 8l11VKH+QbvsbvBdbRXhjm43zy9S95lgPwTwqdK4A3OD/ZAUWss4zYGdudMwYHhklpQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=solidigm.com;
	spf=fail smtp.mailfrom=solidigm.com;
	dkim=pass header.d=solidigm.com header.i=@solidigm.com header.a=rsa-sha256 header.s=selector2 header.b=acwE7pRd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.38
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010038.outbound.protection.outlook.com [52.101.85.38])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52083606A31E;
	Tue, 24 Nov 2026 17:16:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52083606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=solidigm.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=solidigm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=solidigm.com header.i=@solidigm.com header.a=rsa-sha256 header.s=selector2 header.b=acwE7pRd
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aR0x68WXAdTFbQnzVm5jAWpi/Nya7KVpqMjOKdrIp8LtJbHO9LPZjf5Be0QHv30mbleTU5jElKlN7Xz4jplfPRYwMKZPU5OQ9TS4hTlq42DtbEIf+qMjSTfhTCvpbyEoOE0KB5IBTpA6SrCR3GWRt9cMc96kuGyi5vmx6lbu80zd88zdxFHLAEmYyMTMZCWk4/gvPbzfoJl8bp5A4eHsFiigdW1Xz+JnUGnoLiwl+JkuDYxLfNR5Fbr7AIptglnM9Ewpgov0H6pHBpI1oHqN/e2H2twTynoVobbvxdyuyTKM/V2eHI9xuRu10rxKjWXFJLL5uljMAuJw9fMu3fcdCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cwXxQ7rOxRZ3jme9zJax/5w1jH6p7RkYA3JynHsPBGM=;
 b=clycu7MDyrnmsA5Nkh2KZYtiYRJLqv2c2NvkwnT2JiUyly6+0pIqmBFTSA7l3wUStvzipbrVZlgVNJHxjUzim3kcYWVBkiTBjwlrZSrONHufjawbThxdB7bUtGwZEATaCq3KHFYrejmHMN6prGhFPl66V7JioYsCN0/wIS0ny7Y38Fy2O/6wh1b2snc+A+PtjKt+hzZLnXpWGOtQO21R+CjheEHMpM4R7wT/khnmE0Lr/MyilIlyt/sSKBs0Ubfb5VJnKPC4D9evvN0hK1DlHCQAO0xhh+Xst/cAMJVQ6UIbWkK7xZFNEWlig+wtjJvvgbq68qV1fJhMVu6sBGRqYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solidigm.com; dmarc=pass action=none header.from=solidigm.com;
 dkim=pass header.d=solidigm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=solidigm.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cwXxQ7rOxRZ3jme9zJax/5w1jH6p7RkYA3JynHsPBGM=;
 b=acwE7pRdZhp28dKYWEuFPfO6XNuOeXQeLtvuLL7TdiJTXB+lAh2OqCWE8jlGPX1limIoQjQc9iwq2uHJsV32fzEwKsllNypxr90Qo6hWqwfa7PHsiXlU6G0crhdgB1C++nmdtVhBXATsPCgKGnqvXB+456sXcpbzXy/KCOeLQnQb6c/pxt3m+7FFAr8YCm14HUXH5bsnuD8lrr04C/tRRL+j8sV7gPkqhSLns3NjF1EnBK2cSm7qS7P+O2V1sew2DDYaX4okMCMD2CMEYEWu2Pa4vrbwj/WEiNpStbMm3Mbh2DtJ7mJ02Aw/mHpOYRPFplbTTapBR8pgDtikiBQCqQ==
Received: from LV0PR10MB997684.namprd10.prod.outlook.com
 (2603:10b6:408:33f::17) by SA1PR10MB6663.namprd10.prod.outlook.com
 (2603:10b6:806:2ba::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Tue, 24 Nov
 2026 17:16:04 +0000
Received: from LV0PR10MB997684.namprd10.prod.outlook.com
 ([fe80::2b69:d102:4935:e368]) by LV0PR10MB997684.namprd10.prod.outlook.com
 ([fe80::2b69:d102:4935:e368%5]) with mapi id 15.21.0662.001; Tue, 24 Nov 2026
 17:16:04 +0000
From: Wayne Gao <Wayne.Gao1@solidigm.com>
To: Dave Chinner <dgc@kernel.org>
CC: "cem@kernel.org" <cem@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "linux-api@vger.kernel.org"
	<linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH] xfs: add a per-filesystem switch to force atomic CoW
Thread-Topic: [RFC PATCH] xfs: add a per-filesystem switch to force atomic CoW
Thread-Index: Ad15z2WocV/7eyH8R22b/KBFBzWDVwBt1w8AACwXo6A=
Date: Tue, 24 Nov 2026 17:16:03 +0000
Message-ID:
 <LV0PR10MB99768487598606BD434E340C7AB9442@LV0PR10MB997684.namprd10.prod.outlook.com>
References:
 <LV0PR10MB997684D5CA8A6AC037F6D1CD8AB9472@LV0PR10MB997684.namprd10.prod.outlook.com>
 <awSd1JEB0F4WeKt0@dread>
In-Reply-To: <awSd1JEB0F4WeKt0@dread>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_ActionId=13c527f8-8931-4a86-af3a-2a5d24e4f7b1;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_ContentBits=0;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_Enabled=true;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_Method=Standard;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_Name=P2
 Confidential;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_SetDate=2026-11-24T17:13:30Z;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_SiteId=4bb44aac-867a-4be0-aa34-30794e8470dd;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=solidigm.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR10MB997684:EE_|SA1PR10MB6663:EE_
x-ms-office365-filtering-correlation-id: 46b35d30-5d0f-4598-0ad7-08df4a4e9eb4
x-ms-exchange-atpmessageproperties: SA
x-etr-sdm: Outbound Disclaimer
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|38070700021|261028144727099003|261026140227099003|261026121527099003|261102123227099003|261022075727099003|261022105027099003|261022113327099003|5023799004|11063799006|4143699003|10067099003|56012099006|261021123027099003|261021121427099003|22082099003|18002099003|55112099003|261009223027099003|6133799003;
x-microsoft-antispam-message-info:
 zymJDN9U22uyV04R+CdLS8/4GMMkrbTnzoiA07KKlhnZmBOVWCpxJA13kCiVWFpv7C9qrDzSRIgp11ekTn5AVzslDvT7jRat5VpEafqocV/X4k4nAA3tUp0Ypz49cMYnQPAAmAzmqc665mAnLz0iU7WBD5SK6BvjvzgNo0Jai4xQyQ+pxdbjwEePHQsahLFiJCXP0vJTmzGdM2tqbUC+jIaITAUERYpjVMiUSK7aqu4TSqY0/r+/XXvsklFD6L2iUO5HGs+iDXmaMZtvNkaXjFG5LowqUrJCZu4NGpQ0n5860ZKjBOTMr8rqCgoJHw5DEtzdJbhRTXFxW4ShS2pC18gVSvWz4jLXkXTZqyO0szZa9Qyuj+g8XngMWgwWoy5b3+gzrMKenxQbJyoUEm0kSua+/ZAhO/qLP725wnvk5buzqYDas7YoYlB0oF03MudwIxHajgUVZJ70IvKsAlkaVKA6fYfx1XQNE9r6bTIx6/QMk454DCysKbGJZke2BGO1rGeDYjGo96id/NM4k11b8xA2qI7B1566dyFC6v7Zi2w3HEvb3K9MrLJhJMdkb6iVga7sj0r92IWqX4d/nSBX2pmFqThgZiyrQT0UQu+MfTqStL8WOr+Gn4Dkac3AEfhzjPoBSDAEGGlOXEYxQsq0ySkKlkwGxmc3yxD9yqXoiG/dZ4tmroyGiao2eU2GZkYPto6eIVEogzu5YdLNb0lzjiH1cEvRf0J8CxMMFkDjVgE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR10MB997684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(38070700021)(261028144727099003)(261026140227099003)(261026121527099003)(261102123227099003)(261022075727099003)(261022105027099003)(261022113327099003)(5023799004)(11063799006)(4143699003)(10067099003)(56012099006)(261021123027099003)(261021121427099003)(22082099003)(18002099003)(55112099003)(261009223027099003)(6133799003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?OIbbdEsvN6s680ShE1bqJf8/F2tj4q4JHz7hyhrI70KO1A12l11xGzrcqrjX?=
 =?us-ascii?Q?0/QCNAXwRve3JFTa8sTRTIi624J7DvaQRXvQBNw/OqGGXN4U4ocvu80xQcPo?=
 =?us-ascii?Q?1BwHhZrc3H92D7fQk7qYk64KGRK6HGBGF8hlOycMibDLBRk4gaGJlBHm2KZo?=
 =?us-ascii?Q?YtZN1RDzE/jZ28K/YutcMN+Px+RCTafwlrLmMuRlXqDN+NWLe8dDWd7WeA5z?=
 =?us-ascii?Q?OvsbbvKJpTi1iF00GOuU8ZBdfFmgci7cqOEurHxonjPz4d/bJx/bD0BI+AyE?=
 =?us-ascii?Q?tlbsDaaJe+9K6H8w+KknK16AcHjo/ncacDx0wCF1ySYMTs49C5sM3riF8ikX?=
 =?us-ascii?Q?Eu+79F1P9GvdSfh3u1LUYTqxpDO4Y/VBPeIw8UrUEHJSc+TAIHbd6JafkqWY?=
 =?us-ascii?Q?l/1aaR3fBg2WE8qSfq41UCgIw9/m/v+gkGUZh613fLaGRgLffizTnEzS+ZIO?=
 =?us-ascii?Q?D+seFJaZ48qUTP/UOjlC+Axh2g245luvuSoBEjVQfvc5xibT5zejEiCReB5X?=
 =?us-ascii?Q?dT0v8OS3sDvUqyBCe4GGb2YnupChMozND2NCDY4l+tvaDub/uQjWpa/jDZY7?=
 =?us-ascii?Q?S0h0AIrS0TygL7AXvtBgPu4Aykh8xK8K1Ds4WKgv3zGkeqjREndYruTz2pYj?=
 =?us-ascii?Q?EsPkr4aOMbesMavD1RBtjkau+e/neAsiQ5b4LAYB4qyf8Uy24Mh+wNIxg0VG?=
 =?us-ascii?Q?TMMvbPFKul7ty1obcYFoPYNUlFm3m8v/Q/XjhU8n8lQMN2YjCFPBf/9YpT9c?=
 =?us-ascii?Q?gFF97/ZgN81HOPbLa/GYXSH8yV4YhtxR/5kLzeIfFFKqpM78vPJy6wzg9Ca+?=
 =?us-ascii?Q?u6SeqlDshAKY9U4x5/wyHTRGiSpf+lDIdmMeuVnjbaLlkGP5e7dBm0Ejxsnu?=
 =?us-ascii?Q?dPTGZJYAFCip52c526LvIUq/G6HbSEJ79oiKGNnE6FV/6UWMl5Ar5dTvHMYO?=
 =?us-ascii?Q?sIQhgAQnYsNS3issB9ApNF3/QCHtbwyFamNNSw2rt4RA4ofD+RO1UuUbV9jp?=
 =?us-ascii?Q?xM1SY/5usJgyMdNBszeeZIlJwTeAfwpn52YdzVsraPj55dHn2DeoSS1WC5f7?=
 =?us-ascii?Q?G/j4c9/W3Igyh+rIGjFPb/2YZ0Zhqwak06OKSaZE33ASRl8lOgAw2lrste9s?=
 =?us-ascii?Q?6gUd464MNia5CQwj0uqvSGNtRLSEXrvAmFO2eC/miUpVssVlMUWPWVz05Haz?=
 =?us-ascii?Q?nieAmVv7X8PtqS3al1pzs1XaO8Ek5BmSr8R0s+a2n4TO+s5NSJeQ77NcRnNL?=
 =?us-ascii?Q?h5jGxB42e/HEtx0JEgeiqnqc9GiVfmj1XEpwJPI22VEPir78hgm2D4off3tG?=
 =?us-ascii?Q?DYABKkjYmTvjQR756wONZJjrumpMwVtNYrFrcpaYixHrXkpGWAzAzDjwNEr4?=
 =?us-ascii?Q?g0vi3brgLVFLaPVccAquiuVcAxnBYAuAXNzg176QD1gY0vrXkuehaZ8gxeq+?=
 =?us-ascii?Q?h66LydsK3LK2hfTxfycuMBXsZt0SpXFKFACsIiQ+U6E6OToAvE5OfhP9YDHU?=
 =?us-ascii?Q?vNXPCj1newVHPmCUVeIeu5RVwe2+a0p5qdyMYjH8nRmRflx+EMS9eBKWgim4?=
 =?us-ascii?Q?b4+bPRcw8HGXwthKGzD8pA7b4SNf0q0aUpEv20eFxiK74SPGubXrQfwG5rMe?=
 =?us-ascii?Q?G+k0Z7gYSoMRKG6NezClSqR1yMu53+PoIKVjilpSQdPBjSe3ruApOeJDVaxS?=
 =?us-ascii?Q?rmbM9QAZVTN0l4k3wBdeStpgNby5abAx0Cod+WY9YpmWzhgZADYBLfe9Du0l?=
 =?us-ascii?Q?rkwALAFNLaEFx18fSQb0xYlNT4+1nBc=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 46b35d30-5d0f-4598-0ad7-08df4a4e9eb4
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2026 17:16:03.9775
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4bb44aac-867a-4be0-aa34-30794e8470dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GkUYBTC3+FnXieyOYBJpj1T/f3EnIg9V1mRMgCdcxH8uGAjdIQparaSD22UPymqqg5jspYdN5IzNOXLev6BXsQBY6WNySG3r4Hm5z+/r4PiAvF8TgJ3bvCSZn6DsKrkF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6663

Hello Dave
>
>
> Hardware-capable devices normally prefer hardware atomic writes,
> making it difficult to exercise the software CoW path
> deterministically without changing file layouts or affecting ordinary wri=
tes.

Why would we want to do this at runtime on production systems?
Wayne: Dave, it will be easier for user to compare HW atomic write performa=
nce vs XFS COW atomic performance. but any suggestion is welcome to make it=
 easy to try and not impact production system more.


-----Original Message-----
From: Dave Chinner <dgc@kernel.org>
Sent: Tuesday, November 24, 2026 4:11 AM
To: Wayne Gao <Wayne.Gao1@solidigm.com>
Cc: cem@kernel.org; linux-xfs@vger.kernel.org; linux-api@vger.kernel.org; l=
inux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] xfs: add a per-filesystem switch to force atomic C=
oW

[You don't often get email from dgc@kernel.org. Learn why this is important=
 at https://aka.ms/LearnAboutSenderIdentification ]

Caution: External Email


On Sat, Nov 21, 2026 at 03:47:32PM +0000, Wayne Gao wrote:
>
>
> Hardware-capable devices normally prefer hardware atomic writes,
> making it difficult to exercise the software CoW path
> deterministically without changing file layouts or affecting ordinary wri=
tes.

Why would we want to do this at runtime on production systems?


....

> The intended use is a controlled comparison of hardware-backed and
> software-backed RWF_ATOMIC writes on the same hardware, without having
> to construct misaligned mappings to trigger fallback. The existing
> DEBUG-only always_cow control also affects ordinary writes, which
> changes the workload being compared.

Ok, so you want it for your test/dev environment, not production?

I thought we could already change the block device characteristics (i.e. su=
pport hw atomic wirite or not) at the block device level? If so, why do we =
need this at the fs level? If not, why isn't it the hardware atomic write b=
ehaviour configurable at the bdev level?

i.e. I don't understand why 'unmount; change bdev setting; mount' is the ob=
vious answer for back-to-back behavioural characterisation on the same hard=
ware and filesystem with different configurations?

Cheers,

Dave.
--
Dave Chinner
dgc@kernel.org
CONFIDENTIALITY NOTICE: This email and any files attached may contain confi=
dential information and may be restricted from disclosure by corporate conf=
identiality guidelines, or applicable state and federal law. It is intended=
 solely for the use of the person or entity to whom the email was addressed=
. If you are not the intended recipient of this message, be advised that an=
y dissemination, distribution, or use of the contents of this message is st=
rictly prohibited. Please delete this email from your system if you are not=
 the intended recipient.
