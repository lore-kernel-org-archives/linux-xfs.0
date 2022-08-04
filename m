Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74A2AC19F2D
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Aug 2022 01:53:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiHDBxk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Aug 2022 21:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiHDBxj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Aug 2022 21:53:39 -0400
Received: from esa7.fujitsucc.c3s2.iphmx.com (esa7.fujitsucc.c3s2.iphmx.com [68.232.159.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD9FF4B0DD;
        Wed,  3 Aug 2022 18:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1659578019; x=1691114019;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RxOe7mN9EHk825GS397cG1KQghzmEWw4l6lRGiy5Qho=;
  b=XzUX/ffISv21j3vEtMenPeBt2Wq+DgBOiEtoAQyiZBoo01UkbcqLYq5D
   L9PQbhK4FuvxiL8YI0JshOjXZOHuaxus1DzLQ4DleytUAF4b0AVz9N+AT
   L+YxyGNRJDUNLra/neGnSxyYlN7VIN+UcH82vV7sdexPSpZu75GNd4bRT
   F2bFXVzj+RCQ1mnS+Cmb1evElqnDm2M+L+lD7fUUGANqn2p9VOuVFdhD/
   vyiVUk8X9fXeoTpGn1hviowOx6unNCFfVIGtQBrv3fhBeIAIaudSzNZlZ
   gcWYGSn57nFdsj6DgRRBTFl6bDuxymwPG6BAcllH7NIF2LqeJ9p2INktB
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10428"; a="62102890"
X-IronPort-AV: E=Sophos;i="5.93,214,1654527600"; 
   d="scan'208";a="62102890"
Received: from mail-os0jpn01lp2111.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.111])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2022 10:53:35 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DDJhLEv5iOpCXyQqJ9l/RDL3MGctQG1e7ZqjWC6s/BZvtVSfho7S2Npdag/T1H40xvGEBNt/gchBrv/4n4twXhqV9rXc95hBKGKIhkU8xcmz0tUCHemG/c2/sRiC2c71uHO0NcSl4uVe/xLgg/c06lIwGegKE7WG2tvgeyPVZdKkhyhOfHcp8n+lw8JszNf+QXJyLhiFr6MoCpXu1TJgfpJ45hPkCNU7MrAaadim9B5JF6stZAz8V7Zb6/UgZLK5sC0uWDfIHSnmNwmarSz9CZqZR2mtD8a+PsPf2VQuzzAxeHTwK3CrFagZRy/mklUANb7kv4LZgBjV0kB91C8IdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RxOe7mN9EHk825GS397cG1KQghzmEWw4l6lRGiy5Qho=;
 b=MNfsbqDWKJ8riBWEoCcjLpYIwztADPKcL5nn402TUSQtCvLPs8d54/1t42dKopORKNaTAIxrudOkAinjPFryQ26ysj6MkjzqTio7386qqGlYqwPE1ejWP2BfsZgKkFfyAxIObbEIGiX2ftArc99Bg1ywF86fnfL3W++0V4qD3mxBP5U4t/Qy6R5Whj5pL9mOyVnkSebGrs34BnF8qPiaqtkRvXgdbtXxPygumaTMFdGuuCIaRzfWPRocxbncj7EIrLuyZsT+7UFN+3PDHrhJSUwvlGHe611y+89ZJOHN0gR288Xgn7l1Rgav6cs08SA7NHBICrCiBiuWHjqh91TqaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TY2PR01MB4427.jpnprd01.prod.outlook.com (2603:1096:404:10d::20)
 by TYWPR01MB9572.jpnprd01.prod.outlook.com (2603:1096:400:19a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 01:53:31 +0000
Received: from TY2PR01MB4427.jpnprd01.prod.outlook.com
 ([fe80::5092:a34:8a79:5e78]) by TY2PR01MB4427.jpnprd01.prod.outlook.com
 ([fe80::5092:a34:8a79:5e78%5]) with mapi id 15.20.5482.016; Thu, 4 Aug 2022
 01:53:31 +0000
From:   "xuyang2018.jy@fujitsu.com" <xuyang2018.jy@fujitsu.com>
To:     "Darrick J. Wong" <djwong@kernel.org>,
        "guaneryu@gmail.com" <guaneryu@gmail.com>,
        "zlang@redhat.com" <zlang@redhat.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        "guan@eryu.me" <guan@eryu.me>
Subject: Re: [PATCH 3/3] xfs/533: fix golden output for this test
Thread-Topic: [PATCH 3/3] xfs/533: fix golden output for this test
Thread-Index: AQHYpvCQpvzlxY2Z+ky2Zn14ygvHra2eDRkA
Date:   Thu, 4 Aug 2022 01:53:31 +0000
Message-ID: <4094bf3b-9be0-c629-648a-b78999e3ec83@fujitsu.com>
References: <165950048029.198815.11843926234080013062.stgit@magnolia>
 <165950049724.198815.5496412458825635633.stgit@magnolia>
In-Reply-To: <165950049724.198815.5496412458825635633.stgit@magnolia>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3b34507f-ec3d-4b40-921d-08da75bc2240
x-ms-traffictypediagnostic: TYWPR01MB9572:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dHMaBcfW+aH4iSjce9psgIttqCLPbvDB1xKKR3EA9OUeW1kbksYX8EIFBV/A1t6bPDjkaaENafjvxFSVI3I7WD/G7t9wsbSmo86GDeinwEJgbIIhtr7WWOYCAQLF7E71RnpQ4gfs7v+a392RFkVvg+aQ7MZHFTu2OpYDD00Y9Qwr1CDg8duHP0F19+hUrkdCy95/SpFkCBCP+1Z809yrlZIbdBnobUkMVx0Fwyr0xKGT3nLgyzLIF/4b3q68rnVrGeRnXXl4kmDzOpgQG/2rWUAhJ2qVblPUSmVCit/FqDdzW5bvlEZSKzJsU1CPyORXx9y6VdQ562UhP4IMfGiNNCLLnRJ8lnf1eSRjGuAnjNfCA5k5aaew9iXrZU5gVyhAOtyqFKAPcB6T8U1uBNzcVGZFAo6/zu9MZRsXzp21EOvUuj2mbJArCTysy3nzuZyB5BXvRAOOt7PGmQuF//QUEQ9KCTeF63505ZzeR0Z9rtJonZPCT4zTo/C0A1oNANBGkqmVSBaWTfadNiaK/3h+22oHwmzJuUsIEEk7gDTjXMRUuLP8qphyjSm2N7VAq+0WX2dJvKmENenjkH8gHq+SNgen8X2mAQl1QFvPOANR30m6Nx93ncEYMg0ZZ+bGMVbyQpp1Sn64uURtS7J8pxQjlJSqnzZzovxCk+c+GDU4Vpueto5aJtaOMMCqVG4Tgf5/vEK+mQFwJVUVup+8ni3euroNckow0Bv8UdW1OQhquTcCBHtEuT7ODemOnfT7ChLZvQewKn+aXNo8PYeyX/deHsoJ1TStUemWC+e4WIwY5AnGJQVv6AgWPmAyU3WqY5Mb10jaAhkcIvTUFbJPULiEyg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB4427.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(346002)(136003)(396003)(39860400002)(122000001)(66446008)(31686004)(36756003)(110136005)(91956017)(4326008)(82960400001)(38070700005)(8676002)(316002)(85182001)(76116006)(38100700002)(66476007)(54906003)(71200400001)(66946007)(64756008)(66556008)(6506007)(86362001)(31696002)(2616005)(6486002)(478600001)(8936002)(5660300002)(26005)(186003)(2906002)(4744005)(6512007)(41300700001)(83380400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K0d2OXlObW9ITng0dzdsZ0E1Z2hrVlhuV004ZWg0TkNLeDBxNEdyb3NWcWNl?=
 =?utf-8?B?cC9lNDIwYUxiQkFZL3o5ZmpLMmxiUlZ4Z1dUQVA0dlBpRXNJWWdDVVRqVDJF?=
 =?utf-8?B?cDI0KzBQOXpDdTl4czlzU3lkUzRSU3BIdXZGM1o3cjRRZnZTQk9Sb1pYR2R4?=
 =?utf-8?B?TUZtbDlIdTRTZ3FvWVhGUVNFZXlmNGxDTnFWUHF4M29QYlViNi8yQ2NWd3Zt?=
 =?utf-8?B?T3dpWDhpN29OWWlCSWs5dEtSWnlqLzZMenlUdDlUTyt1czRvRTVEUHZQR0VY?=
 =?utf-8?B?SVlsaExZWC9ER2RUenhrRFpJcUZkb3FpdGpWU281Z1hYY3RKRDVFdlRxSG9x?=
 =?utf-8?B?UDQ2SEJ2VjhkSW4zdTNWNVV6dVVqU0xTT1MraUdmY2x0TVZxVlRWSGNMUjlt?=
 =?utf-8?B?dTRRWW5FbnY3MzRyK3kzUEtyanBWMEQwdFNMeVF0ekRWSUxsVmFjMTFRY2NN?=
 =?utf-8?B?NGo5YkxDeVNNU242dDhEN3ZkdllSS2xlUEFuY1NlQ2VBMVdJbEM1Y0N1TVc1?=
 =?utf-8?B?UHc2M0R0OGtTbkZPYXdXeVJBQnNuckdRVktzNWVudWwrakdnNFZidklqbVVr?=
 =?utf-8?B?dXdrbHpQTTJOWkhOYmFRcTJBcnMyMVdlcHVYdFh3bnlDTC8zbkpGdjZYeGdp?=
 =?utf-8?B?dkU5UHpHOGpQWWdNaUhCbmZVY3dNSStxZlpvdFJMSlQ0RDZiZldya3dENm9J?=
 =?utf-8?B?eVNybXRDZmZ3VEdkMXh1M2FhbFpHK2tEeDVzbmdqR0N3SzZRa1Zwa3ZJcXQr?=
 =?utf-8?B?SDN4Rk1jWW9rUDA4Y08zbVJRTnVwbTJCdGNtbFVVSkkzNGpaTjRBcS9GVmRS?=
 =?utf-8?B?dHE1UFAxUENSSnFad3lMcXY5ZWllNVZEZ08rL0ovYWlQZWhTMGk4QWZuVElu?=
 =?utf-8?B?c1BTY25sTU5VazBsQnRJM0VjbllzeFVxRnR2dVVMdU1GeU5OUWhwUFd5OExP?=
 =?utf-8?B?V0NvTll3R2dHeEJhdWZjK3ZBdzIvMkhBL0R3RzVnOUhmR3Y0cVlTSnBnNUo3?=
 =?utf-8?B?ZnV4Q1pzUU9Za0xSaHJmbTdqYStmbVZlN2pHL1RGS3pheEcvZys4K0ZUdms5?=
 =?utf-8?B?ekwya1Y1QXlPZ2J1Z1dYTVVyWkI4d0R2RVdRSGRJa3R2eFg1clVvRjFreXpT?=
 =?utf-8?B?Tkd1ZTlDK0lzOXZML2VmYWFNOWhvbXBnYmRaRTlNb1Z5VlBlWElFTDNZYUNz?=
 =?utf-8?B?ZThUbDRsMERkNWdySEtmZ2dEZGJJSnAyVnZxN2NjOHpmQ1JnWHQwT3I3N2dx?=
 =?utf-8?B?N21VcFBXUmpiK2pJVFM4UnpISEgySjRndW5RNHpaWXBGUnpkbFFwZzZoelVi?=
 =?utf-8?B?QURvY2F4Vmg5SWp2UFJpT1lCRzRCdElMZHZHRVk3aXc4azlmMnFOQThXWis0?=
 =?utf-8?B?S2tQYlpXciswVlpPZWFJVU80cUk2dlptZWpXMXEwM2NLZU1FZFNRZUsvc24z?=
 =?utf-8?B?ZDd4NFlqeTNHM0JSTkhWelJtMEhFM3ZtaTRJaTM3THZpeC9TWWNxVmhMVGxL?=
 =?utf-8?B?RzZhUWlIQ3pvU1RqOGFIZExoMVFNNlU0MmdNcG1CY0hTRjJMQVJuRG5nTUdp?=
 =?utf-8?B?Mkp0R1pmNzJKMDhhWUVZMSszKzA4NFVZWElaT2h6ZFFaU0dqTUprL0JSMFIr?=
 =?utf-8?B?SURmK0pvL2hONzd2aVVpMzhraEZETnRxNk5kMnJRKzg4cHFpeTJVcG41eTZ0?=
 =?utf-8?B?cUtOYWJKM1pycVJ1UTd6RnhIdDVDa2NnSnpDekpUT201QzF4cjNUNFpwSi8v?=
 =?utf-8?B?Q3dZS1BRcE5zK29nei9JcngzdGVtcGxLc3JBN2pvcGwrSzZKT0toVVk5U2xs?=
 =?utf-8?B?dWVaWVNBc3Q5b010Ry9xdUVTOXJiMVFaek1sd3lVdFJ4Q3U0RXpXdm5uRXJt?=
 =?utf-8?B?bVROUFo3MlNTUU5WUFVVR1dHNi9Sdi9CRWs2WExGZTU5U3g4Z0lsL1dEaVls?=
 =?utf-8?B?dmltektMb2JYNE5MUDltQW9Db0xjVnBRTTFNU0JXZmMzL2RZS1hsUklNQUxk?=
 =?utf-8?B?anZSMVFOUzBXSmVtREFXeFErcXd5K0hsSHBCdDlhSlRzZjZISjRHQ1plZmdx?=
 =?utf-8?B?L3NrbEw1RHZOK1JqVjF1SnFrMG0wMit3L3FFSnlrcEM0bEdsSUlkLzk5L08v?=
 =?utf-8?B?blgrRXoyY1MwSWZOYXVkOXVzRzUxVGNhQlorUTc1MDJZWHJmK1RqeXgxS0lR?=
 =?utf-8?B?YUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CC80F0EC69BD32478B06C98A53957BC7@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB4427.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b34507f-ec3d-4b40-921d-08da75bc2240
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2022 01:53:31.4992
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H0S6iRnioaG/VmKVtvxAFf8vmcqWZ0PLcJgt71r2w74D4JPzWBraP9Uy9Pco+4y9OtkPNy4RCIWh8uKZpHril1Fndx67o3sc4oiJUY+xOms=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB9572
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

b24gMjAyMi8wOC8wMyAxMjoyMSwgRGFycmljayBKLiBXb25nIHdyb3RlOg0KPiBGcm9tOiBEYXJy
aWNrIEouIFdvbmcgPGRqd29uZ0BrZXJuZWwub3JnPg0KPiANCj4gTm90IHN1cmUgd2hhdCdzIHVw
IHdpdGggdGhpcyBuZXcgdGVzdCwgYnV0IHRoZSBnb2xkZW4gb3V0cHV0IGlzbid0IHJpZ2h0DQo+
IGZvciB1cHN0cmVhbSB4ZnNwcm9ncyBmb3ItbmV4dC4gIENoYW5nZSBpdCB0byBwYXNzIHRoZXJl
Li4uDQoNCkl0IGZhaWxlZCBiZWN1YXNlIGxpYnhmcyBjb2RlIHZhbGlkYXRlcyB2NSBmZWF0dXJl
IGZpZWxkcy4NCg0KYjEyZDVhZTVkICgieGZzOiB2YWxpZGF0ZSB2NSBmZWF0dXJlIGZpZWxkcyIp
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBEYXJyaWNrIEouIFdvbmcgPGRqd29uZ0BrZXJuZWwub3Jn
Pg0KPiAtLS0NCj4gICB0ZXN0cy94ZnMvNTMzLm91dCB8ICAgIDIgKy0NCj4gICAxIGZpbGUgY2hh
bmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IA0KPiBkaWZmIC0tZ2l0
IGEvdGVzdHMveGZzLzUzMy5vdXQgYi90ZXN0cy94ZnMvNTMzLm91dA0KPiBpbmRleCA3ZGViNzhh
My4uNDM5ZmIxNmUgMTAwNjQ0DQo+IC0tLSBhL3Rlc3RzL3hmcy81MzMub3V0DQo+ICsrKyBiL3Rl
c3RzL3hmcy81MzMub3V0DQo+IEBAIC0xLDUgKzEsNSBAQA0KPiAgIFFBIG91dHB1dCBjcmVhdGVk
IGJ5IDUzMw0KPiAgIEFsbG93aW5nIHdyaXRlIG9mIGNvcnJ1cHRlZCBkYXRhIHdpdGggZ29vZCBD
UkMNCj4gICBtYWdpY251bSA9IDANCj4gLWJhZCBtYWdpYyBudW1iZXINCj4gK1N1cGVyYmxvY2sg
aGFzIGJhZCBtYWdpYyBudW1iZXIgMHgwLiBOb3QgYW4gWEZTIGZpbGVzeXN0ZW0/DQoNClNpbmNl
IHRoaXMgY2FzZSBpcyBkZXNpZ25lZCB0byBkZXRlY3QgeGZzX2RiIGJ1Zywgc2hvdWxkIHdlIGZp
bHRlciB0aGUgDQpvdXRwdXQ/DQoNCkJlc3QgUmVnYXJkcw0KWWFuZyBYdQ0KPiAgIDANCj4g
