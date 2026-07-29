Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11023141.outbound.protection.outlook.com [40.107.44.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69D9632;
	Wed, 29 Jul 2026 06:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785308320; cv=fail; b=Iu5ZjRbKbN86TMoGJbF3s+hLq4oG+kqYcQvF0Hedzh+fQs48fbY7udZURjx3wMX91eYPZ6fwL22M2NEdOOWEylk/OeaXPrNmQqBktLJzR1yDkDdUxJeajIMPPLVByvIE4ar5StInRlynX1MACNy7FAyvmlZmrOH9MyLQdhZySbs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785308320; c=relaxed/simple;
	bh=t5+lnFDeu6w5l15MCFL8471OnIvXzAEwjCgHMz4JVw8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qn62j1ONLNXKMokXoyLDvCoR/y7d5sllfXY7iWto+qSoPFj7LwynPXoypxBjjVcNt0XAliZU9pgvr+SU5hrzYIT+3tUriOfPY85oJ5Hfb7OcLxE7vHlMAqFXvi+/Yk5weiBKyr274n4PSR2iFOnjOuieIWrRPBQPxONtZ8ys+q0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nova.gal; spf=pass smtp.mailfrom=nova.gal; arc=fail smtp.client-ip=40.107.44.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nova.gal
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nova.gal
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n8HdX8EBu+RnGl1/LKWzzkVm0+TcKL6ktDCXGsm71bc0IQIJiDXnKeH9AiNrqZqYy0QT8b8qybbNOkH3o41buCHIlG0HIc1LKZ9KUaE0XaRbM/fHX53RCzBl1ZSwCHdYQ3p/Z0iCTjGnIlFCBN7KTKMokY4AkVisB4UabCPiAKNGmxW6MU/soKsLKKkonep45hQXGC94mXzo1Yek8acQt/SPB5mKnvB0iVKqQSwgaW/gA81MpoA9Gfmzk/9EA1tmzUmboevBOLIN7sCGHufzN1JTZNZraRxzYdN+YW9IVM1VLf+4yXlOK8vtyi0/HIDTSqa9xMNEIiD/xl7lV+64JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/dK+LOTw6d1sJc+3Z4LdwWYWfKzVwbAaz3G3t/HcbEo=;
 b=q6SqDktIJ6X/K/K++Q/+WC5tYqv70ns8A813UV4U6w7oyV2U1RQ6KEIn5ScDmsWA5a1RhdFhtfAda7cecq9seklCK6SzRjywNB0Be7874/9ppmfJMcbcA4m5G+I6fndczlg/BVe/FtRMSKZQsFKtxbVfmvLD/wdX2Lw8mQvMApqqDdhruUSSEHpJFb4AUbiasUUlaK0BXVHM91tA5UMWkK3FwVEkc13I10m5RXBMI+l9Maba3aABaF0PETyXFbPw1SMPwQvvUNc9T+/JMe+z4KxqdwsBumKPKpM8EP9SUNj6/wRZLh0a6c0u6590LLPZylzRzUUPD6Z8YhX2yeLRag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nova.gal; dmarc=pass action=none header.from=nova.gal;
 dkim=pass header.d=nova.gal; arc=none
Received: from SE3PR03MB9967.apcprd03.prod.outlook.com (2603:1096:101:336::7)
 by TYZPR03MB8018.apcprd03.prod.outlook.com (2603:1096:400:463::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 06:58:33 +0000
Received: from SE3PR03MB9967.apcprd03.prod.outlook.com
 ([fe80::98a1:50ec:e93e:e0ee]) by SE3PR03MB9967.apcprd03.prod.outlook.com
 ([fe80::98a1:50ec:e93e:e0ee%5]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 06:58:33 +0000
From: MuElnova <muel@nova.gal>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "cem@kernel.org"
	<cem@kernel.org>, "bfoster@redhat.com" <bfoster@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH xfs] xfs: validate remote attr value length in the leaf
 verifier
Thread-Topic: [PATCH xfs] xfs: validate remote attr value length in the leaf
 verifier
Thread-Index: AQHdHlnQbKvHdJ/HUEGg+U6p9/toE7aDCfgAgAEIJ30=
Date: Wed, 29 Jul 2026 06:58:33 +0000
Message-ID:
 <SE3PR03MB99671599AB8C4D9C92A16BF6B9CA2@SE3PR03MB9967.apcprd03.prod.outlook.com>
References: <20260728062451.1296908-1-muel@nova.gal>
 <20260728151116.GL2901224@frogsfrogsfrogs>
In-Reply-To: <20260728151116.GL2901224@frogsfrogsfrogs>
Accept-Language: en-VG, zh-CN, en-US
Content-Language: aa
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_defa4170-0d19-0005-0004-bc88714345d2_Enabled=True;MSIP_Label_defa4170-0d19-0005-0004-bc88714345d2_SiteId=2adae87f-1bb3-4442-a538-a57c857641f5;MSIP_Label_defa4170-0d19-0005-0004-bc88714345d2_SetDate=2026-07-29T06:58:32.959Z;MSIP_Label_defa4170-0d19-0005-0004-bc88714345d2_Name=All
 Employees
 (unrestricted);MSIP_Label_defa4170-0d19-0005-0004-bc88714345d2_ContentBits=1;MSIP_Label_defa4170-0d19-0005-0004-bc88714345d2_Method=Standard;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nova.gal;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SE3PR03MB9967:EE_|TYZPR03MB8018:EE_
x-ms-office365-filtering-correlation-id: 8a2d6c74-dcf4-4bea-3502-08deed3ecdfc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|41320700013|23010399003|34036016|376014|56012099006|11063799006|10067099003|4143699003|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info:
 YwIVpOaJ1wjQX4xsSL4Ep71fpF5wGS/0dhTznP1KZxMkSyLa2a8qCKG3TPvxjUkDG5UmjPtn/JK5f3/8yPr0QJoIHEIZIfznRr7WjTkge74o8gZLqwPqhH1GSS01N9NdqoMNZxQrtNAf5vtLEKOtlVAa2AT1meyclTvpx52i735R3wNEwpAZRRuILKXSFYdG+LIZVxjgvuypnOnRRpHV06H+fPpYifJvWAPcJwnDLSNsotBVnttOclKUOHYQV4kLgEQxsBR6YlMDFIMB3XXwHCye5BuELZhSG0BT6kE/c+4aL/z/5hLZoxfuQMFCJ8Rn6g77YU/dX6fKuVaM/Bz7E0JB+nVdnB9jiiOPn306lK05mQ7TjUdQPulRwbmm5xvRgquVsUXmFA3ioEQ9CBwSfMnPqjs9QyQq9SnKl+t/0umaorjG/ooQpPQO1wztLO0l4bbpn/C3TAY2YUTaqM53XzCwLYfi+XPDkYE4CO6GQQSpzSP6YxOZtoEQiKcVkAnQkdn5MS1eSIEQ26CMFofzAhjV9REqG6HExmt3cbc1IbaeSInX7AI/koGqp64UFfCbgAnVMeGxpCxNUsjCjxcYC7fTFDZVgLrUoYwBbkKaU+hsaVf5KJXTxDE0cPYyuXbkC5RNNDs0fjEXrlQagENjWaO1eFzMQpRlmc1sTTy7plDoW7iV+/PQUfWTARbNxOTcR3PARYL727jybqhCWxQ5vMbFyYi7gctSO8Egh+776X4=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SE3PR03MB9967.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(41320700013)(23010399003)(34036016)(376014)(56012099006)(11063799006)(10067099003)(4143699003)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?Windows-1252?Q?chFRNEpX43J6xf2LvOWkBKdam7C5TB6bVLSSezsKn3zHI/OKHmtrZkbD?=
 =?Windows-1252?Q?Lwr/01jbTDL4tERCujRfAQso4JbsqQ9ufzXJ+LQsvNj88U5h+u0WWTYE?=
 =?Windows-1252?Q?NIi8PrHd9nPh8nShBSAgIvfl579VnyJEpyHFiTeFA/jrwwkTAgJG2XmL?=
 =?Windows-1252?Q?qo+hR7ZkxiqPs6dzgAwIbVzUM6KbvyUYT8meXDC4DveCZTs0FtM6csFh?=
 =?Windows-1252?Q?WnnT4W0q5xXIvDj4Ux+m8PVa9jgFX/U/6P2xIpqq9L2sMax+OsPNY8CD?=
 =?Windows-1252?Q?1kKzZON1/o0JwCAXEHKDn2RBxm1wBrAoAO3GbN2OvHM7Fcq4vd8e3Rg7?=
 =?Windows-1252?Q?zUNhvIpOTKPNX+tmPM8DJYQHxvGfqejtPoxT7upiYi0EGmprH5TSIVa5?=
 =?Windows-1252?Q?3oODt+dfsWOSWpqojiusxtDaEQkRMz6+iTyhguCqQLK+6k9oEUYxhLWm?=
 =?Windows-1252?Q?yucwCcOU1OFfptRMydSSoisU0SAI8S94iCWnweTwhOSrP5PaFQv1s+1s?=
 =?Windows-1252?Q?dgju4x2J++0mJoSvtwuy87QQ6/GW1qHdXt5QPvGQkw6Mr/ATFa+It6ui?=
 =?Windows-1252?Q?obe47xJCQUKvPCJo3hpDcBYdHF1omn+WkLZEXZ4UW9SQrN/UI2huGvEo?=
 =?Windows-1252?Q?CVv0VbvGzDw9bPjybUra5DFsQ9RppM/OouBv+0OnsEw63GXc/Rfn9gpg?=
 =?Windows-1252?Q?wvUeypxOPj8CvNZAo5MPv/6GYqzKHCXIf1tjCEfCpCH/iWyVg9N91G9l?=
 =?Windows-1252?Q?bWPlYB26BjuN+typygwSz7h3x0ABWhhLxsJHyPKJvHXGDKJFRVUR/xL9?=
 =?Windows-1252?Q?OK1aFbKAHTh79G0ACqxXecgGgHjBSqUvwL/xaDx8V055kqWTrTfWU4AW?=
 =?Windows-1252?Q?PAJA/wO0/WdvD1HWuMXmPfx459WQvkullxnCSdqxYga2IAZ9R5ESd6lV?=
 =?Windows-1252?Q?LnS2L2Y1hgsHYumO2NYsAsAuBnQqGSu6mJPuGGx/p6Q+XvcaTFcry5mu?=
 =?Windows-1252?Q?bf375mCu3M7+KjJrgfkydiNYNyAwZC8Ao90/sllxnT6vXQA7U8p79wqc?=
 =?Windows-1252?Q?Re2FU8w0e7xv3Dwrxa9xnwGDgR24vSABbxU7BN4jvstUhTtQSgPgNDpj?=
 =?Windows-1252?Q?SQxj36I049hNF53J+8ulOAWZ9yebNjNMPdptymgbsDCnHS9yevsAZEil?=
 =?Windows-1252?Q?VcmfvG/nXom/yyRAllJrIuvI3j7iumMQxRa3Swdv01DnCw979DX4t+Uz?=
 =?Windows-1252?Q?X/g4KdH2k8NOlm+Fv79ElHOmYneBOjlkF+1SHkOg6dShV9vnJ/KBZHtX?=
 =?Windows-1252?Q?Tcu6JzR1adVxJwEdrqdbveibunRPJaKa4lCvVOGyzGXnzw7okFpff7HZ?=
 =?Windows-1252?Q?7WOBJ3wq3YWTMHO8cBciLFvdUqkJeI+zNBIDHBu5Jvyu/ReMkj62Gian?=
 =?Windows-1252?Q?vJa4UWN4psRNHHsPxBonqv9LDKWtYOSjsjcJg2fdxx4+1IxyA5JdfX9w?=
 =?Windows-1252?Q?4OWXbHB6LLffbGi2S2HFQwxklXiJbJyfFZMcEwi29ffkxBhfFKTs2ocZ?=
 =?Windows-1252?Q?5HQGZj+li6kFM1HCxTi518fAB64AALMBljRvmeg3PX9RnwF8T7A1QSGy?=
 =?Windows-1252?Q?FXg8t4w982qCLr4akS1yxCo3exZoFhaPjG7ITYl+ztr6pswsv68ORgTn?=
 =?Windows-1252?Q?liFMit1RDt57yKBhfY4FKQZHvTlLBz7NdqSrVw7Jc9hewgDNWcOQr0yN?=
 =?Windows-1252?Q?NB9IhGVmSxgxneCZPGo6OYddoFXMLGTZ4axEb37Qi0rAeKL59R/Y8itm?=
 =?Windows-1252?Q?QtjuhaeDUTsLmesrQ9ijjInPko4=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nova.gal
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SE3PR03MB9967.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a2d6c74-dcf4-4bea-3502-08deed3ecdfc
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2026 06:58:33.2721
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2adae87f-1bb3-4442-a538-a57c857641f5
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v11QWRwRGC3si9dxm9wF+piHGEEK4NdhAmHG9q0lHHMHnodt1LRxND0i8cdPTPzw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB8018

     > Isn't this a duplicate of=0A=
     > https://lore.kernel.org/linux-xfs/20260707190038.3811440-3-qwe.aldo@=
gmail.com/#t=0A=
     > ?=0A=
=0A=
     Yes, it is =97 same root cause and effectively the same verifier check=
.=0A=
     My dedup search was limited to torvalds/linux.git (lore and=0A=
     git.kernel.org are unreachable from my test environment), so I missed=
=0A=
     Aldo's series. Sorry for the noise.=0A=
=0A=
     His series looks correct to me, and the 1/2 change to=0A=
     xfs_attr_copy_value() closes the signedness bypass at the=0A=
     consumption site as well, which my patch did not touch.=0A=
=0A=
     Thanks,=0A=
     Miao=
