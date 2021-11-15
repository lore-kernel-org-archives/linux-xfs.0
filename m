Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D5C7C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Nov 2021 01:35:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D17B60FE7
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Nov 2021 01:35:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhKOBh5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 14 Nov 2021 20:37:57 -0500
Received: from esa19.fujitsucc.c3s2.iphmx.com ([216.71.158.62]:30291 "EHLO
        esa19.fujitsucc.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229453AbhKOBh4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 14 Nov 2021 20:37:56 -0500
X-Greylist: delayed 444 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Nov 2021 20:37:55 EST
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1636940102; x=1668476102;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qXVnEbigz8CcS85Dzx0UhOHGy/8hToaa+Ug+MJBL4L4=;
  b=HUXUr8ydW90Y97thui655/bC8TzvV+ZOm3y/xm8ZStQdQtFQaTxL5TaV
   5GYrgPKs3MwXTW9EIO3RvQkP9h2IIqzV8MPwrfMktZJ5Un9iTW3AcDyxo
   Mcv4M8oOTPJ8F94DmUpUwK2D53k8Bm8RObf22Vxj/6ZhZYqA0CEHjtzU6
   qJd1vm3/cOuIJ5vpa2D63Byvo2X0paDidR7rbb+4CUc0nHmVPr/NDnZBt
   7nrHZs0T0ZrG/cAgn+oznZOP6KmT7dUo7/71GQ0x4l8R3mIXNYNCMUnLb
   y4+5lon6b6flJebnEUvHqQFfnsrdf3cfwIiCoRJhsKgRnc12kWd2wzBub
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10168"; a="43246795"
X-IronPort-AV: E=Sophos;i="5.87,235,1631545200"; 
   d="scan'208";a="43246795"
Received: from mail-ty1jpn01lp2056.outbound.protection.outlook.com (HELO JPN01-TY1-obe.outbound.protection.outlook.com) ([104.47.93.56])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 10:27:31 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QaVZDWVf3zvq/1wwINkvFyVoGV0FFR5qDhsGRLKpcxBy6NayjIK9oogE4K0nN+PHxwYBSwKQyJtaJxhohe9532A0dTibz67YXmQ8sZSQuiUMpCrjpfj9eqyUuAZtPF+1HSWjKSr6dP/jfGeuCkSiwD/Z3oxTzyqI+iyMsOhowpUMG/o5Q5MR3R9nWGlyUrMPoC5T+zOMYVHsQTPlUdMip1W/LCk158T8cPJkuBAjcFgRHkpkXzB7uv5Gh0R93Q1I2/UF6VeDMOm2LuUjivKMIIxegRfDka11WmWTkw6oRF9anwRqoJxfOtBUibpcWvCKmEdXjQO8xpyP+XZ/0jBCtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qXVnEbigz8CcS85Dzx0UhOHGy/8hToaa+Ug+MJBL4L4=;
 b=I0aaFK7pDd+Fzf0CxQnIHzF/htgoP1dIzjLjp7NVPqe3VZDbzc2PTd/ijEGlBsEchmpt4shMjGTNKAIRu1+SxMew1T3WD7ornrzpbPoP+8hRlrybkOhdRGQLLW+paU+ooE1dGtpZ4vc1Q0Z52EjZHj8tcgMexEi1AF3I+kcQSfnt+72vZqK9t/2cwBmxTGo2/IHMsxCGBvnifHvEJxCN2iv6WBNEcOhKSOHmexzB8NJi9QWYo1QfJqFQ7H7BH0VIEYaKkw+V0MojN5y0t2dNsFC7VDXbuAE6R3ZSpTeFVVkSEJkaQTjgEIINSfQJVEmuxZCEA1zhVrzBGgzPB2eL8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qXVnEbigz8CcS85Dzx0UhOHGy/8hToaa+Ug+MJBL4L4=;
 b=SeRxdPqn6lXLOL8WPR+RPnyQ+dy8OYzLblwOZV21cZ6rVehUgesm4B/P2EosNwcYvP/i7UCdj6znb0A7G72fkzOYhYc8YayV7XTkNy+z0nzKW5GXfzGmjo/Vd3rUScCvXDGNwoRaJJCcOykx7nd6P3hrqiIzDgqQtzYeQC379nQ=
Received: from TYCPR01MB6544.jpnprd01.prod.outlook.com (2603:1096:400:98::6)
 by TYAPR01MB5150.jpnprd01.prod.outlook.com (2603:1096:404:125::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.25; Mon, 15 Nov
 2021 01:27:28 +0000
Received: from TYCPR01MB6544.jpnprd01.prod.outlook.com
 ([fe80::4997:e3e6:6502:9100]) by TYCPR01MB6544.jpnprd01.prod.outlook.com
 ([fe80::4997:e3e6:6502:9100%7]) with mapi id 15.20.4690.027; Mon, 15 Nov 2021
 01:27:28 +0000
From:   "xuyang2018.jy@fujitsu.com" <xuyang2018.jy@fujitsu.com>
To:     "Darrick J. Wong" <djwong@kernel.org>,
        "allison.henderson@oracle.com" <allison.henderson@oracle.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>
Subject: Re: [PATCH v2] xfs: Fix the free logic of state in
 xfs_attr_node_hasname
Thread-Topic: [PATCH v2] xfs: Fix the free logic of state in
 xfs_attr_node_hasname
Thread-Index: AQHXzu44WrbqcpYgsEK54PEhRm7trav0SCoAgA+aEAA=
Date:   Mon, 15 Nov 2021 01:27:28 +0000
Message-ID: <6191B7A8.9080903@fujitsu.com>
References: <20211029185024.GF24307@magnolia>
 <1635750020-2275-1-git-send-email-xuyang2018.jy@fujitsu.com>
 <6184A132.3090901@fujitsu.com>
In-Reply-To: <6184A132.3090901@fujitsu.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8b7b4b2d-d720-44cf-6427-08d9a7d7164b
x-ms-traffictypediagnostic: TYAPR01MB5150:
x-microsoft-antispam-prvs: <TYAPR01MB51500DA0599509E8865AC6BFFD989@TYAPR01MB5150.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uvYtkre3kR64TYBqpfOIRiDc2bucj/6D/rMgdWz/3CutzDJaAAw/eEsvGh4NhW76EXmEBPv87qzsHLok6SyDFMLQAbXbItdC187DY1N9W0SiOv+DO+2ELH7dAaN4hHslJnJJcXsZaiRnywEemWF9mObFA6kpgm56NbvftW4Zxgj9R1PrQYWKa56WY3RVrzNL+YQN7T02SODCWmoKLr8Lu0iqq4rXSIYaw5CmfRG7LSRDBoh2bkxHDvNJE2qakU3xAk79BgCbzZ6o3O3gCq7/EUm0QbYcYvtDSkB0vrvwKL9bEmqmlOxdY4FR84kW2fbmdpRf/SOscUBLD1SFw1PXx9d3ASDW47tASH7xXb18BIl6cDmdT1GVC4GXCFpxvf+a8PHpJFBv0/cKrdb65iiTzOs70ExMueFxmVC7zeVqESQwtyMgKK97YbAGxc9IsPurJ0nD6++U1OIQ274MxNVjInlZl4Y28c2R60MFYc90pJtydPrsaPWHrY3889ewbW0EVwPeg27R3raDY/JH5yv74pXgQX2OpMMLAlXCXHoZ8GfamlV8dkqEES5vDZ91XvKP/3T1vksyELHfO50pAD2UC3XJel4TodgniKwQhRRDUrV8HSEbj+0Ro0ofPddkrIHOXJ7VIguMZjsM6isrH1FxGffslFD/iGVHs/bXtSpPBElS1pG303DpQifofydDTWb8Xkl+1wnZ8vW0qwVA15/RHg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB6544.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38070700005)(82960400001)(122000001)(87266011)(85182001)(66556008)(64756008)(66946007)(6512007)(66446008)(186003)(83380400001)(36756003)(26005)(8676002)(66476007)(6506007)(508600001)(5660300002)(6486002)(76116006)(8936002)(54906003)(86362001)(110136005)(2906002)(4326008)(2616005)(316002)(38100700002)(33656002)(71200400001)(91956017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?SzhYc0pRNVYzR2NPc3dsTUovRkN6T00xN2diekhCbnhGUlY5aW9Pb3hnM1Q5?=
 =?gb2312?B?RnJ1UXUzOUl0Nm1oZ3Z6ZWxMdFRMcjM3WkcvczFjemxtL1htSG5sZ21HWmxW?=
 =?gb2312?B?RlZ1c3BROFZDNXFyakFadFNyWUJ2a2pEZGQwR2Izc0hlbjB1ampBNVplT2ky?=
 =?gb2312?B?VEd1VEMvT1p5TUhCb2tOSHpwek51eHl0OWNESk4wWHQ0SER2Y1RSL1laTENz?=
 =?gb2312?B?cWk1d0Y2Njhaa1BrNjNyZ1hrVGsyMmJsZHg0T1ZLZUVtQm92a1c4RnhlMzM4?=
 =?gb2312?B?QzNRT1FKa3B0bS9iRDFackNjbGFDM1R2SHp4ejlrTzBqYkVpQWZ6ajFMUVRO?=
 =?gb2312?B?LzNVZnRKbWZpZ3RVNzRjemdrT0RYVklYZnMyVmZMdWIxVlFmTmJZRW01R3dK?=
 =?gb2312?B?dnQ3YUdEcHNtVEo4QVIvNTY5Rjg4Y24vUGM3R1JPM1c2dWFlaGVoemFLRkxC?=
 =?gb2312?B?THdaMy9wNktQMDJRSmtPTFY4aE95NFVINXlZcDBzSFZVZ2xJSnFWbzdBdEgy?=
 =?gb2312?B?MVNlbmJYeHdXTlNyaEJsUXNxZ3lQclhTK3piZ1E1N3NTYzhwR1NXSDdOWFRH?=
 =?gb2312?B?RWZOZkxJYW9vN3dGb0x0VWRaVEhPKy9IVDBlOHpEcERIdXRMbG9xRjBTWDlQ?=
 =?gb2312?B?bUtnWk1iaWh0ZVhnamFIRVlnYnZBQTVNdHo3aU54Z3QzR1QyZ0d1SFR0MDgr?=
 =?gb2312?B?ZjB2RjQ0WEwyajFWblNoNWR6V0FqMVJFVjQrQWpaNURuUjVNUTZNTTM1Rlc2?=
 =?gb2312?B?Vkp6TVpySDZqTEpOSXJ1dm9Md2c0RkdnUy9QSHIwVjdieERWU2FkYUZGdmY1?=
 =?gb2312?B?a3YrQ1FOOHZXdEllNHMwTWpMRFlyWVNEL0crTXpXU2c0MHArNTBRNXI4OG93?=
 =?gb2312?B?YTJoZjdNZEhZRVJieHVvYmdLWVpsdU5uMUVuR3hyTkY2eDdEWUNIRWVvK01H?=
 =?gb2312?B?Y0ZERFIycWlJMlB4TEM2dXU2Ym5IcXRjVEUveEJnMHJ3ZktKVEFMU29WallF?=
 =?gb2312?B?TDlIQmg4aTRQclQ1K2Z3U1RoREp4ZU4zYjNxb0NGdS8wbGFsT05nRW1SeGk0?=
 =?gb2312?B?QnQ0Y2JMM0JqTFBqSXpUR0tRRnBYOWorZklTODlNejRCelJTejlCdXo3SFAv?=
 =?gb2312?B?R1VmWEl6TWhsR2ZkTjBaVzd1ZlUrYzdsd0tOSUErY3pyTCtyaWJBUGdRTndm?=
 =?gb2312?B?UWtBNjBQazl6eldiSTRnUnRnWjJZQkR3L29IYWUwMU9sZFJIbUVhb0dyM1Fp?=
 =?gb2312?B?RWVHWTBGcmpsaE1GSS9sOVFqa1YzdmowSkJ6NEU2enBjUTF5SVRoT3ltak9R?=
 =?gb2312?B?UDB4bHZTZFFsd2U0QUVXK1Q3TjFLLzR4RE1ndlJlazNzbjdXRGUweEpUQWM0?=
 =?gb2312?B?YnpXMHVKWkFvYXBwcnUrY2RrVjF1dHNZZVZJQjJ3Z0RWS1B3TWtHNzBtYng5?=
 =?gb2312?B?RzQ1em91ZWpBYVVja1ZGanFFMEdjc0lLZjcyaWE3dnMvWUZodGxSaVIvUk9B?=
 =?gb2312?B?MFRoUGZvTEU1YTB4Znc1QXJWNkx3YVJpN3JQa0hOdzB4R3dYTGErSFRwSVB4?=
 =?gb2312?B?WUxTT2ZsS1Jhc2RFYzVJTHJJSE0ybVIxeDR5cE5vWGM1NzBsWWU5a1kzSy9M?=
 =?gb2312?B?WlZQTnlpV2R3Z04vOHRRVGluYlNydWpISktOSXFpc1dLdERmUlNmRXIwR0JU?=
 =?gb2312?B?SUV4K3JzdEN2OVVMYXZmMlAzeFVTZENjY3NYNHdDTHptV2p0dU1pNDlQT3RH?=
 =?gb2312?B?QUpzRlltK29VQy9aNTNUYStPRlA0bGhuYVJLV3ZBR3RTU1dLS3hXdmpLTFJB?=
 =?gb2312?B?Rkc5NUZZQUxDTVpuM0t2dlZHZVB2dCt4d2QzTTgydERFNlNEQ3YvRXk3RVFC?=
 =?gb2312?B?ZDVQOHNIVU9UTVlLbzRrdEkvSWZUNlRQUW1lQjJkQkRQMXNVNW9zeEphWGRE?=
 =?gb2312?B?eEJnQk13eHovWFdvY0FyRGxwVUhCQnFYQ1ZZUTRUK0VpbUtaZTB4Ymc2WVhh?=
 =?gb2312?B?MExSYktnbWpCejJZZkdEY01qZzVNQWdkMVJ4a3ROc2hvZWcwZWRmWnJGdmNs?=
 =?gb2312?B?aU1wK0EzMVBjaEY4dVF2algxeTdEalB4UFEyWktFS0o4YTdEL2IrMDFWNUl6?=
 =?gb2312?B?bW9pL2V6bE5IclVONGozZEJzL0I0WEZiWjF1L1hGL3JsZ2RtN01BSXlCNHF0?=
 =?gb2312?B?eXVUTTM1bVJzS29CMlpKbTlhTmRqRnBDU1phQkNvdTBYaVY0cXZPWE5yOXdN?=
 =?gb2312?Q?ZwEzwv+eokh3iYImfNje1MsznvCijGgBV5f9RAyiMU=3D?=
Content-Type: text/plain; charset="gb2312"
Content-ID: <0D8A40CA0542724CA74E9F2636E47A28@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB6544.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b7b4b2d-d720-44cf-6427-08d9a7d7164b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2021 01:27:28.2546
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jbEZc/OwCAKmBAjKGMMiKbqeqIXRpFdIt8Sml32gv9ZKoQJXDpmRS+qmIsJX3wF97JikbSw/kPm52Q85y+dW2UboQycJFEUqZRxfDXGmbWQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB5150
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

b24gMjAyMS8xMS81IDExOjEyLCB4dXlhbmcyMDE4Lmp5QGZ1aml0c3UuY29tIHdyb3RlOg0KPiBI
aSBEYXJyaWNrLCBBbGxpc29uDQo+IA0KPiBBbnkgY29tbWVudD8NClBpbmcuDQo+IA0KPiBCZXN0
IFJlZ2FyZHMNCj4gWWFuZyBYdQ0KPj4gV2hlbiB0ZXN0aW5nIHhmc3Rlc3RzIHhmcy8xMjYgb24g
bGFzdGVzdCB1cHN0cmVhbSBrZXJuZWwsIGl0IHdpbGwgaGFuZyBvbiBzb21lIG1hY2hpbmUuDQo+
PiBBZGRpbmcgYSBnZXR4YXR0ciBvcGVyYXRpb24gYWZ0ZXIgeGF0dHIgY29ycnVwdGVkLCBJIGNh
biByZXByb2R1Y2UgaXQgMTAwJS4NCj4+DQo+PiBUaGUgZGVhZGxvY2sgYXMgYmVsb3c6DQo+PiBb
OTgzLjkyMzQwM10gdGFzazpzZXRmYXR0ciAgICAgICAgc3RhdGU6RCBzdGFjazogICAgMCBwaWQ6
MTc2MzkgcHBpZDogMTQ2ODcgZmxhZ3M6MHgwMDAwMDA4MA0KPj4gWyAgOTgzLjkyMzQwNV0gQ2Fs
bCBUcmFjZToNCj4+IFsgIDk4My45MjM0MTBdICBfX3NjaGVkdWxlKzB4MmM0LzB4NzAwDQo+PiBb
ICA5ODMuOTIzNDEyXSAgc2NoZWR1bGUrMHgzNy8weGEwDQo+PiBbICA5ODMuOTIzNDE0XSAgc2No
ZWR1bGVfdGltZW91dCsweDI3NC8weDMwMA0KPj4gWyAgOTgzLjkyMzQxNl0gIF9fZG93bisweDli
LzB4ZjANCj4+IFsgIDk4My45MjM0NTFdICA/IHhmc19idWZfZmluZC5pc3JhLjI5KzB4M2M4LzB4
NWYwIFt4ZnNdDQo+PiBbICA5ODMuOTIzNDUzXSAgZG93bisweDNiLzB4NTANCj4+IFsgIDk4My45
MjM0NzFdICB4ZnNfYnVmX2xvY2srMHgzMy8weGYwIFt4ZnNdDQo+PiBbICA5ODMuOTIzNDkwXSAg
eGZzX2J1Zl9maW5kLmlzcmEuMjkrMHgzYzgvMHg1ZjAgW3hmc10NCj4+IFsgIDk4My45MjM1MDhd
ICB4ZnNfYnVmX2dldF9tYXArMHg0Yy8weDMyMCBbeGZzXQ0KPj4gWyAgOTgzLjkyMzUyNV0gIHhm
c19idWZfcmVhZF9tYXArMHg1My8weDMxMCBbeGZzXQ0KPj4gWyAgOTgzLjkyMzU0MV0gID8geGZz
X2RhX3JlYWRfYnVmKzB4Y2YvMHgxMjAgW3hmc10NCj4+IFsgIDk4My45MjM1NjBdICB4ZnNfdHJh
bnNfcmVhZF9idWZfbWFwKzB4MWNmLzB4MzYwIFt4ZnNdDQo+PiBbICA5ODMuOTIzNTc1XSAgPyB4
ZnNfZGFfcmVhZF9idWYrMHhjZi8weDEyMCBbeGZzXQ0KPj4gWyAgOTgzLjkyMzU5MF0gIHhmc19k
YV9yZWFkX2J1ZisweGNmLzB4MTIwIFt4ZnNdDQo+PiBbICA5ODMuOTIzNjA2XSAgeGZzX2RhM19u
b2RlX3JlYWQrMHgxZi8weDQwIFt4ZnNdDQo+PiBbICA5ODMuOTIzNjIxXSAgeGZzX2RhM19ub2Rl
X2xvb2t1cF9pbnQrMHg2OS8weDRhMCBbeGZzXQ0KPj4gWyAgOTgzLjkyMzYyNF0gID8ga21lbV9j
YWNoZV9hbGxvYysweDEyZS8weDI3MA0KPj4gWyAgOTgzLjkyMzYzN10gIHhmc19hdHRyX25vZGVf
aGFzbmFtZSsweDZlLzB4YTAgW3hmc10NCj4+IFsgIDk4My45MjM2NTFdICB4ZnNfaGFzX2F0dHIr
MHg2ZS8weGQwIFt4ZnNdDQo+PiBbICA5ODMuOTIzNjY0XSAgeGZzX2F0dHJfc2V0KzB4MjczLzB4
MzIwIFt4ZnNdDQo+PiBbICA5ODMuOTIzNjgzXSAgeGZzX3hhdHRyX3NldCsweDg3LzB4ZDAgW3hm
c10NCj4+IFsgIDk4My45MjM2ODZdICBfX3Zmc19yZW1vdmV4YXR0cisweDRkLzB4NjANCj4+IFsg
IDk4My45MjM2ODhdICBfX3Zmc19yZW1vdmV4YXR0cl9sb2NrZWQrMHhhYy8weDEzMA0KPj4gWyAg
OTgzLjkyMzY4OV0gIHZmc19yZW1vdmV4YXR0cisweDRlLzB4ZjANCj4+IFsgIDk4My45MjM2OTBd
ICByZW1vdmV4YXR0cisweDRkLzB4ODANCj4+IFsgIDk4My45MjM2OTNdICA/IF9fY2hlY2tfb2Jq
ZWN0X3NpemUrMHhhOC8weDE2Yg0KPj4gWyAgOTgzLjkyMzY5NV0gID8gc3RybmNweV9mcm9tX3Vz
ZXIrMHg0Ny8weDFhMA0KPj4gWyAgOTgzLjkyMzY5Nl0gID8gZ2V0bmFtZV9mbGFncysweDZhLzB4
MWUwDQo+PiBbICA5ODMuOTIzNjk3XSAgPyBfY29uZF9yZXNjaGVkKzB4MTUvMHgzMA0KPj4gWyAg
OTgzLjkyMzY5OV0gID8gX19zYl9zdGFydF93cml0ZSsweDFlLzB4NzANCj4+IFsgIDk4My45MjM3
MDBdICA/IG1udF93YW50X3dyaXRlKzB4MjgvMHg1MA0KPj4gWyAgOTgzLjkyMzcwMV0gIHBhdGhf
cmVtb3ZleGF0dHIrMHg5Yi8weGIwDQo+PiBbICA5ODMuOTIzNzAyXSAgX194NjRfc3lzX3JlbW92
ZXhhdHRyKzB4MTcvMHgyMA0KPj4gWyAgOTgzLjkyMzcwNF0gIGRvX3N5c2NhbGxfNjQrMHg1Yi8w
eDFhMA0KPj4gWyAgOTgzLjkyMzcwNV0gIGVudHJ5X1NZU0NBTExfNjRfYWZ0ZXJfaHdmcmFtZSsw
eDY1LzB4Y2ENCj4+IFsgIDk4My45MjM3MDddIFJJUDogMDAzMzoweDdmMDgwZjEwZWUxYg0KPj4N
Cj4+IFdoZW4gZ2V0eGF0dHIgY2FsbHMgeGZzX2F0dHJfbm9kZV9nZXQgZnVuY3Rpb24sIHhmc19k
YTNfbm9kZV9sb29rdXBfaW50IGZhaWxzIHdpdGggRUZTQ09SUlVQVEVEIGluDQo+PiB4ZnNfYXR0
cl9ub2RlX2hhc25hbWUgYmVjYXVzZSB3ZSBoYXZlIHVzZSBibG9ja3RyYXNoIHRvIHJhbmRvbSBp
dCBpbiB4ZnMvMTI2LiBTbyBpdA0KPj4gZnJlZSBzdGF0ZSBpbiBpbnRlcm5hbCBhbmQgeGZzX2F0
dHJfbm9kZV9nZXQgZG9lc24ndCBkbyB4ZnNfYnVmX3RyYW5zIHJlbGVhc2Ugam9iLg0KPj4NCj4+
IFRoZW4gc3Vic2VxdWVudCByZW1vdmV4YXR0ciB3aWxsIGhhbmcgYmVjYXVzZSBvZiBpdC4NCj4+
DQo+PiBUaGlzIGJ1ZyB3YXMgaW50cm9kdWNlZCBieSBrZXJuZWwgY29tbWl0IDA3MTIwZjFhYmRm
ZiAoInhmczogQWRkIHhmc19oYXNfYXR0ciBhbmQgc3Vicm91dGluZXMiKS4NCj4+IEl0IGFkZHMg
eGZzX2F0dHJfbm9kZV9oYXNuYW1lIGhlbHBlciBhbmQgc2FpZCBjYWxsZXIgd2lsbCBiZSByZXNw
b25zaWJsZSBmb3IgZnJlZWluZyB0aGUgc3RhdGUNCj4+IGluIHRoaXMgY2FzZS4gQnV0IHhmc19h
dHRyX25vZGVfaGFzbmFtZSB3aWxsIGZyZWUgc3RhdGUgaXRzZWxmIGluc3RlYWQgb2YgY2FsbGVy
IGlmDQo+PiB4ZnNfZGEzX25vZGVfbG9va3VwX2ludCBmYWlscy4NCj4+DQo+PiBGaXggdGhpcyBi
dWcgYnkgbW92aW5nIHRoZSBzdGVwIG9mIGZyZWUgc3RhdGUgaW50byBjYWxsZXIuDQo+Pg0KPj4g
QWxzbywgdXNlICJnb3RvIGVycm9yL291dCIgaW5zdGVhZCBvZiByZXR1cm5pbmcgZXJyb3IgZGly
ZWN0bHkgaW4geGZzX2F0dHJfbm9kZV9hZGRuYW1lX2ZpbmRfYXR0ciBhbmQNCj4+IHhmc19hdHRy
X25vZGVfcmVtb3ZlbmFtZV9zZXR1cCBmdW5jdGlvbiBiZWNhdXNlIHdlIHNob3VsZCBmcmVlIHN0
YXRlIG91cnNlbHZlcy4NCj4+DQo+PiBGaXhlczogMDcxMjBmMWFiZGZmICgieGZzOiBBZGQgeGZz
X2hhc19hdHRyIGFuZCBzdWJyb3V0aW5lcyIpDQo+PiBTaWduZWQtb2ZmLWJ5OiBZYW5nIFh1PHh1
eWFuZzIwMTguanlAZnVqaXRzdS5jb20+DQo+PiAtLS0NCj4+ICAgIGZzL3hmcy9saWJ4ZnMveGZz
X2F0dHIuYyB8IDE3ICsrKysrKystLS0tLS0tLS0tDQo+PiAgICAxIGZpbGUgY2hhbmdlZCwgNyBp
bnNlcnRpb25zKCspLCAxMCBkZWxldGlvbnMoLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvZnMveGZz
L2xpYnhmcy94ZnNfYXR0ci5jIGIvZnMveGZzL2xpYnhmcy94ZnNfYXR0ci5jDQo+PiBpbmRleCBm
YmM5ZDgxNjg4MmMuLjIzNTIzYjgwMjUzOSAxMDA2NDQNCj4+IC0tLSBhL2ZzL3hmcy9saWJ4ZnMv
eGZzX2F0dHIuYw0KPj4gKysrIGIvZnMveGZzL2xpYnhmcy94ZnNfYXR0ci5jDQo+PiBAQCAtMTA3
NywyMSArMTA3NywxOCBAQCB4ZnNfYXR0cl9ub2RlX2hhc25hbWUoDQo+Pg0KPj4gICAgCXN0YXRl
ID0geGZzX2RhX3N0YXRlX2FsbG9jKGFyZ3MpOw0KPj4gICAgCWlmIChzdGF0ZXAgIT0gTlVMTCkN
Cj4+IC0JCSpzdGF0ZXAgPSBOVUxMOw0KPj4gKwkJKnN0YXRlcCA9IHN0YXRlOw0KPj4NCj4+ICAg
IAkvKg0KPj4gICAgCSAqIFNlYXJjaCB0byBzZWUgaWYgbmFtZSBleGlzdHMsIGFuZCBnZXQgYmFj
ayBhIHBvaW50ZXIgdG8gaXQuDQo+PiAgICAJICovDQo+PiAgICAJZXJyb3IgPSB4ZnNfZGEzX25v
ZGVfbG9va3VwX2ludChzdGF0ZSwmcmV0dmFsKTsNCj4+IC0JaWYgKGVycm9yKSB7DQo+PiAtCQl4
ZnNfZGFfc3RhdGVfZnJlZShzdGF0ZSk7DQo+PiAtCQlyZXR1cm4gZXJyb3I7DQo+PiAtCX0NCj4+
ICsJaWYgKGVycm9yKQ0KPj4gKwkJcmV0dmFsID0gZXJyb3I7DQo+Pg0KPj4gLQlpZiAoc3RhdGVw
ICE9IE5VTEwpDQo+PiAtCQkqc3RhdGVwID0gc3RhdGU7DQo+PiAtCWVsc2UNCj4+ICsJaWYgKCFz
dGF0ZXApDQo+PiAgICAJCXhmc19kYV9zdGF0ZV9mcmVlKHN0YXRlKTsNCj4+ICsNCj4+ICAgIAly
ZXR1cm4gcmV0dmFsOw0KPj4gICAgfQ0KPj4NCj4+IEBAIC0xMTEyLDcgKzExMDksNyBAQCB4ZnNf
YXR0cl9ub2RlX2FkZG5hbWVfZmluZF9hdHRyKA0KPj4gICAgCSAqLw0KPj4gICAgCXJldHZhbCA9
IHhmc19hdHRyX25vZGVfaGFzbmFtZShhcmdzLCZkYWMtPmRhX3N0YXRlKTsNCj4+ICAgIAlpZiAo
cmV0dmFsICE9IC1FTk9BVFRSJiYgICByZXR2YWwgIT0gLUVFWElTVCkNCj4+IC0JCXJldHVybiBy
ZXR2YWw7DQo+PiArCQlnb3RvIGVycm9yOw0KPj4NCj4+ICAgIAlpZiAocmV0dmFsID09IC1FTk9B
VFRSJiYgICAoYXJncy0+YXR0cl9mbGFncyYgICBYQVRUUl9SRVBMQUNFKSkNCj4+ICAgIAkJZ290
byBlcnJvcjsNCj4+IEBAIC0xMzM3LDcgKzEzMzQsNyBAQCBpbnQgeGZzX2F0dHJfbm9kZV9yZW1v
dmVuYW1lX3NldHVwKA0KPj4NCj4+ICAgIAllcnJvciA9IHhmc19hdHRyX25vZGVfaGFzbmFtZShh
cmdzLCBzdGF0ZSk7DQo+PiAgICAJaWYgKGVycm9yICE9IC1FRVhJU1QpDQo+PiAtCQlyZXR1cm4g
ZXJyb3I7DQo+PiArCQlnb3RvIG91dDsNCj4+ICAgIAllcnJvciA9IDA7DQo+Pg0KPj4gICAgCUFT
U0VSVCgoKnN0YXRlKS0+cGF0aC5ibGtbKCpzdGF0ZSktPnBhdGguYWN0aXZlIC0gMV0uYnAgIT0g
TlVMTCk7DQo+IA0KPiANCg==
