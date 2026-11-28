Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.60
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795874979;
	b=WPXArN/v1HnsYrOBWZiKpSaH/P1Iqh1qzarjK2kkd0FSmoUDp3HYRjjpSPzRZqslTYfl
	 6SVLdsnBvzFQG8QRpT1kwWTMG22tXQ2ullzUkIP2N2wGYZpcfrX8GuC2xgDA10L0S1bzH
	 8kRO8/xyjF6WkgnDcL774offoe4pDd5TzTce6vhHZtmTCOMljNv/iulqeURygYu6zh30m
	 xhntEcGQr64SWt5Yp8TiZhy0gsyGhvIi1HGG+wO4WPRmwzBaPrtAH4/chbf5Ej7ZtAPmy
	 dLXBbX1CNQ8Om3DTDrfoxhJTsUDQdxS1zHo8TS7waeKyDb5jCzszb7/iqQgE0gFURBg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795874979;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-Mentions:X-MS-Has-Attach:
	 X-MS-TNEF-Correlator:msip_labels:x-ms-publictraffictype:
	 x-ms-traffictypediagnostic:x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-atpmessageproperties:x-etr-sdm:
	 x-ms-exchange-senderadcheck:x-ms-exchange-antispam-relay:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:
	 x-ms-exchange-antispam-messagedata-1:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=GBOdonxnzVNxCOB0AlYy+e4vN82IVENNuXdB86MG50k=;
	b=ESTDwf+1satLuK9amJf0nafHLJhS8hYGZ+K8FfRTobIn4Njy8G4p2eyZR/f9ajej5Ovr
	 /JFD2c073zPlpaWcOg7kdOPfImrpDhSUmvbO7OUr8Kt7g73OjXsHjbYTmrn7U9VNHJC+i
	 U9OrZvfHQ4J90ItHv1F8ZPt9VX+XYFS0SmWW/B1+mjmdnZ6dxHmm4mjIe9CgQmIl3LDcA
	 GAH1uyrIh3iZYFGTagit9stb4eZEtsuaXuBS+F1k0npGTR1MnoNZAiZtqoA0Uh0mXTwCb
	 Idfxwcwp2F13FNtmgwJCY7v1Oa3X+nMb6ST5X9a7mRueAwd2fi/8FbH6NLbuw8fFZyQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=solidigm.com;
	spf=fail smtp.mailfrom=solidigm.com;
	dkim=pass header.d=solidigm.com header.i=@solidigm.com header.a=rsa-sha256 header.s=selector2 header.b=PrmOB6QG;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.60
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013060.outbound.protection.outlook.com [40.93.196.60])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715A1606A31C;
	Sat, 28 Nov 2026 14:09:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 715A1606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=solidigm.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=solidigm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=solidigm.com header.i=@solidigm.com header.a=rsa-sha256 header.s=selector2 header.b=PrmOB6QG
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YlfuxRNvxclhYtS7Sn7dUFzZ9ICt3YxVFOuCYGZ9q3nHrQMOofzCahpLaLs0BxOzcfacxmvv+Ra+MF0bRkdvqJSydo/f2SyH8YqxjLHWMK/+zN9N76e9D/AQ/Cre6aOYjGdQV87fgwmPRMZdi6OinVsnx/NbMIkBL6X6+8ZyNiFjFows+LbixjibmrZFkbqTqZRHbDvC/tJWfDmmn2TX51PnqZ5Z+mnJ0EsPDYId8fgicwJLeXqQ7Cn15JHuf8n4dC4TLjQw240tqXctpaur7u8oP4FpVUAuOHQX8EmyeWmietbTNKOgygtzc2gr6jAq8W8UKLsT+4KFdb5c8VroNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GBOdonxnzVNxCOB0AlYy+e4vN82IVENNuXdB86MG50k=;
 b=HdltIXhfI8j6Zja32IOzAJ2opi/jpZuz1Ex//+U6pM3daN01wqJv/+efvolfOewMwW+JdXuWhx4kH+TIGoN3V/XGvNyexua20BlHw4hpYPfynYZLVmOvMyC5OEAQk0uO5wHIq/QRR57SbTXL/w6+O1Ulz0Q5Lel2ic59nkt8x/MHb5dgF/0siMLeMaVjeQK60Zq7CIjlTbCEibk/Zy/nlLZQyB+qwZu1nF3ve7gmut9czgkahZoKd3l4MIT2cCQSKfduES2I9G2EH1SEHaYPNOyj/H8Y7+RwC8OKgdLIpeSjt734oXrtyfcCn/wc7YVF/K/7jsMZA8QYM1hlXRLEcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solidigm.com; dmarc=pass action=none header.from=solidigm.com;
 dkim=pass header.d=solidigm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=solidigm.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GBOdonxnzVNxCOB0AlYy+e4vN82IVENNuXdB86MG50k=;
 b=PrmOB6QGGPDQ/p77e/VQUnnjhirlFszr6oZnIpUIajHV34jtDUKABRFD9+5/Uq/VAkN2hqsH2OWtVQ7R6hYzo6Z9v37QCZ9HyG0di8IggQNeA8rmXk8Xss5P0xtsIWuIJGRLRvK1XvE02u2HqbECerFeNakp5m4hw4/tUhE8kzkuQIovFEcSqTsn8J2DUP4yAJRV4MnTJbP47cz8el+Y2OM0xzbRrCW2J7fbg0K3+aD8u/sVAJrwOFGsdyYBjmIxGvrV8lwOKsNie3ijNBmqTZfqS/YcOiKFj0Yj+bvYmZ0Km7xw8OZHWqwslHWtIBAkpah+lOiXM2pvRydPCbqp9A==
Received: from LV0PR10MB997684.namprd10.prod.outlook.com
 (2603:10b6:408:33f::17) by LY0PR10MB019827.namprd10.prod.outlook.com
 (2603:10b6:404:20b::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.11; Sat, 28 Nov
 2026 14:09:34 +0000
Received: from LV0PR10MB997684.namprd10.prod.outlook.com
 ([fe80::2b69:d102:4935:e368]) by LV0PR10MB997684.namprd10.prod.outlook.com
 ([fe80::2b69:d102:4935:e368%5]) with mapi id 15.21.0662.007; Sat, 28 Nov 2026
 14:09:34 +0000
From: Wayne Gao <Wayne.Gao1@solidigm.com>
To: Dave Chinner <dgc@kernel.org>, Wayne Gao <Wayne.Gao1@solidigm.com>
CC: "cem@kernel.org" <cem@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "linux-api@vger.kernel.org"
	<linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH] xfs: add a per-filesystem switch to force atomic CoW
Thread-Topic: [RFC PATCH] xfs: add a per-filesystem switch to force atomic CoW
Thread-Index: Ad15z2WocV/7eyH8R22b/KBFBzWDVwBt1w8AAO62PLA=
Date: Sat, 28 Nov 2026 14:09:34 +0000
Message-ID:
 <LV0PR10MB99768491C31E25FDFF1B21C403B9402@LV0PR10MB997684.namprd10.prod.outlook.com>
References:
 <LV0PR10MB997684D5CA8A6AC037F6D1CD8AB9472@LV0PR10MB997684.namprd10.prod.outlook.com>
 <awSd1JEB0F4WeKt0@dread>
In-Reply-To: <awSd1JEB0F4WeKt0@dread>
Accept-Language: en-US
Content-Language: en-US
X-Mentions: dgc@kernel.org
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_ActionId=52455149-be5f-41b1-82d9-c73e18737308;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_ContentBits=0;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_Enabled=true;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_Method=Standard;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_Name=P2
 Confidential;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_SetDate=2026-11-28T14:06:03Z;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_SiteId=4bb44aac-867a-4be0-aa34-30794e8470dd;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=solidigm.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR10MB997684:EE_|LY0PR10MB019827:EE_
x-ms-office365-filtering-correlation-id: 1ef29d79-72d0-4984-a9c0-08df4d593aa6
x-ms-exchange-atpmessageproperties: SA
x-etr-sdm: Outbound Disclaimer
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|10070799003|376014|38070700021|10067099003|56012099006|261028144727099003|261026121527099003|261026140227099003|261021123027099003|261021121427099003|261022075727099003|261022105027099003|261022113327099003|261102123227099003|261009223027099003|55112099003|22082099003|18002099003|11063799006|5023799004|4143699003|6133799003;
x-microsoft-antispam-message-info:
 zbo8TDx+luswNLz7jkfweo1w+1z1obGX5DTdo/xAXd2wYFp+0TlGXNplMTjO1vdsFbHnjwIusuXxYTk/mZvK3jcw6zlU1Vkzt48/HsOr4FlL9b+JfPjMKp88T0nALC5sXlslq/bV7AaocoRWjptzCcvYcaHHKWdoZM47HIlgC7AdspXeeT5Kl0449IZ0c93kamhcbpuvYUs4Zeiv5UhbyFdh833pt/7/wYeLTSVthBIGejHDezgndO6TmGdk5jHpGwQS1hvZ0C+Rgtv+2oc9oUvHFy/0lHttB6558miet2y3g3UFHGjOOz5eR7xgvp4HP8dcWr3y+SSBI6ikercq1yO9Wg3AF0w1B3FiWkKzdLOn1MeYAt13Nt4HwkgGPgLpJgoy4owLnJh8uUxPGh67FotWQXmlZmf3jO09N7fBrpuI2R4uKmGe3CP9kqxwTOkiyXiVjRWtuUUgyzG4SAHR5JGyEUkSKKP5FfPCrhfyhN0g2OML9eu7zg4KWyuC4kJLtfLS8/9ubOGvjE+Vfqj+j319UE3OmrRVakknX2QKM8B9ADMIKUJ76hNVH4ow2Br55XkqPkAyR5j16zOlaMnhZHEM1jDTm/SQPd9SErtYnTpWVxPx9qmIobUjehnfeW/ZcRYLVx8XTXqMdCoOe93uEgxDR2s598xCkhJWls8kqDuGudyX3hzXesyT3tIdYW7DE9jgn8PFXYlJRlqG08YCgZsILi1ljy64MXZ/OdoXG6g=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR10MB997684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(10070799003)(376014)(38070700021)(10067099003)(56012099006)(261028144727099003)(261026121527099003)(261026140227099003)(261021123027099003)(261021121427099003)(261022075727099003)(261022105027099003)(261022113327099003)(261102123227099003)(261009223027099003)(55112099003)(22082099003)(18002099003)(11063799006)(5023799004)(4143699003)(6133799003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?uTc4CkK5u3OyDOf3ayBWRf6hwFf+fGhV1UYTR3A5Qc6N3TZgOP1vqEJYU9wQ?=
 =?us-ascii?Q?bBysh8eYMyfPSp/9ZVb+hjTFRCmxKXiaxYKaT523GLRRR0aVwEsinGmOozZO?=
 =?us-ascii?Q?m6oasmXd3hUBQ5tlScl7vCQ6F6ZwBgQeIiYljcHgshsox9oEIyQvl1QxkoiB?=
 =?us-ascii?Q?B2o+t90IMAZb60KUkwiGA0WuuvP/+My1uB1Tqwhd/+b8MzONmG68siAC2WZ5?=
 =?us-ascii?Q?bis0ev31usiVeA6LpmicIrrGqL4jSdJBOQ/Ngq+LiE86EtAoqQ9X3V4nJh7y?=
 =?us-ascii?Q?Xu/jhj1tlD1PcpLSoMErhcfcRh4+SXb8ZDuwfK99NoQSop21kqiEp4OQFbma?=
 =?us-ascii?Q?oAvZu1297VwHFuO6qBWQfRIcTVh5czs8Pz8sB9275v8HJ83KCUH/G1wsDPtH?=
 =?us-ascii?Q?RPZ0jdWvZ/vM+zTnD8EDZ2QtGe2ydf8JtgMeeBvh4zqZAqX23yKQzws7k7Ez?=
 =?us-ascii?Q?GeiPQ2GZvFjNqrrEyXg8faiHYcvXbC2xIfgfaSSr1R7KGadmCi+7shokx0Ye?=
 =?us-ascii?Q?MLaSq/a7A/ff7+HSlw13+02GIqEGvDQdC1IPk9wWvoYOUsMHbSgGmZEMkjvW?=
 =?us-ascii?Q?5qYUOtUW4vDqj9D0+4hWE2CfRY+xj3fgGtJ21hC6eOf9R1oZyAOqwUoAi/HV?=
 =?us-ascii?Q?WpXsDmE7fS4xHf2S5Bx7kg3DSsywCMwoPhN6EcIvM4WmfrtYWu/Zk1FCDqlk?=
 =?us-ascii?Q?rcGmg9gYOqzj09laWlpzcqtY2Y2Uvvt9R8snZrABtKc0ko4VlMOeRQPsNqJN?=
 =?us-ascii?Q?gchupqX4MuUWe2TcWRJvZMWOJjghLTt6OkOx+EtDn52HASBo5nlmjoORz2Jr?=
 =?us-ascii?Q?pdspoVIjfw4F1/Zp3pbHUWj0D/GlXPBhKaVTQDG5nBM784Gft2x1skwrhm0u?=
 =?us-ascii?Q?R88DD52s2R6//Liea4QvgTR2EQz/vSJ8isiBwGRFWYJFN6Bbol/eNcXAMpXu?=
 =?us-ascii?Q?XtPQZPxoYwExUkQRjJSu3qUL8q0KBh6f4bKlfgrBMTw8oHyVNo4b3sR5S4NS?=
 =?us-ascii?Q?xDTAjhHUs5O+aPP2TwK074XwVnD/XAq+ki6S0h7tjMkM7utM9OMSL0++37RC?=
 =?us-ascii?Q?WVJw7O3mPrQ7X9lq874XLX9z31deBRNjJSc5gL/ptDmfs/K/H1l12903AgEQ?=
 =?us-ascii?Q?Yzu6lNbUi5I3MtXEDuunvN0WYrj57z2C056ID69tgH5tWUYvm9fIaO9U8xHQ?=
 =?us-ascii?Q?wC0Oj2uT5p6mNzJdEoj50KWMJwk0HNSjUfMjAfrkl3yyt1Ifj83TJcXh0gnD?=
 =?us-ascii?Q?AE8Pw8a8fE4LK+ILHltP7Gku6kyScK95+YHPmDA0JbPp+TL9xmdgDdR+OHwG?=
 =?us-ascii?Q?g1sjA3BIptET4waisOGKpBk4h3eJRAwh2M9NoHNePxUcTmH2vAcAYp8bylrF?=
 =?us-ascii?Q?rkmAMHRMPYxpWyM4uMQ+wsmAtWJmQnf3hhaJLKYibq9ypzTpwrWJfdHQsVgZ?=
 =?us-ascii?Q?rcy41yGm2Y9mcJESaOGiGQGb7l8ZkJsE0uXSGcI2aEHNntKbzTUDcQP/6dPM?=
 =?us-ascii?Q?1hmiwhB7Ir1wwIbBawIHxgF1t9/Y148tzF0OGQ0lXnh6nwOz/39mcj7OJ6uA?=
 =?us-ascii?Q?lwSVNTjUIMOM1ltl5G4HDkhieA0YApSTs8qgsYyChitkk+YODH9CQsVVHqFK?=
 =?us-ascii?Q?adzVTfsDeEWpBk60jU0u+fYERMYyr+2qj+8wd7UrZN30fXM31/6Esi3tz09P?=
 =?us-ascii?Q?lJ3OnNII/8EbHj5S9LguvNuQTwVhlRg+5vPj7n3V59B38je4Q5dnhu2u3fQs?=
 =?us-ascii?Q?KroUi8M1seo/jl9VgzRJcXel+kLgjEFH5JH7g6kwVdb38Ve9rbg0mUIZ1IJJ?=
x-ms-exchange-antispam-messagedata-1: ys5qe/v1e6th+F8hjcujrQNXhl1I9ALpUKE=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ef29d79-72d0-4984-a9c0-08df4d593aa6
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2026 14:09:34.0814
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4bb44aac-867a-4be0-aa34-30794e8470dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l2hWqGQHODgw998dUHqiqK0vcDRfnmSsu9Q9EEGMaZoc95r8SuoLMTwfFKP1LdeG8pOToHBUBGB+V9F7E4qNcSiOi+tW6g740z5kNhTbsiivb5azQ9bJ0sgh4mjy/MCa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LY0PR10MB019827

@Dave Chinner

Dave, thank you so much for the great suggestion, you prefer we add this sw=
itch at mount time, not a sysfs flag. Let me try to work another PR review =
with this approach.

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
