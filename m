Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C957AC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 20:38:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242552AbiERUiQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 May 2022 16:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242469AbiERUiP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 16:38:15 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 522D417DDF1
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 13:38:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nijk2QMWDhjJjLkQ1rJz5BzTpUuje0pReE1PTqiJgWxKbSNxmeWTV9zO+d0INnxkPIhR32A0WeLbhjX0diq0tFu7xHesSDdohhrMtJst/XL97RmFYmRm7clHcCigFMpEW/Db1ohB4ICiHlPtBI9ug1OCHK+mrj+dIowcGV2TZa5l13SGDGHzeEc1EjqA1Jf1zoQH1Wq55iR1C1WmLuifS/sBsywC5wNXwYw4HdzElJ3qhZUen5a+Og/L41ZbxaVfXywjdoNIWC8qeRCUwsvp8N7CQZjrWqHP+kIa9PRPkmeflA4e+kA2MDdp3xt/B8rYjBd7BqooEe4duSju/W7JVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=doW2MbZUTtqHdYHuuo83QAqRgDg7U4V8ArJ3hAXwcRs=;
 b=SoMTvFPLMQgl1ar9tO7xSgbTRONwYoFNjLH10zEexJLBB7Z7GA5sLv4sKt6dCP/0bqmio9TMGsGQE58QI/Zsk+ZXRqx2wxahR7iQmOb2WHZ4V3jzoC81a1m4L/qwEXtPisz4QGfmHQz7WvJHHio0HMd4fU7DDmug1t5P4mUnLOyjAuQ0oHEmiDLLkOejYRQwO5AaUOo/bkPoNM4yhEYsPGrY2xbkC+oI+rtN+SCLCRsG9kEj+JTNDGlS1cgoXlY7vYdQo90cf7E2WurC6Wqtw8v/qCnYB6XroltOODz+nZI1reBgr/GlxnPfwHa++gutfoxkQkaWzdJ8B9dkYNmYiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=doW2MbZUTtqHdYHuuo83QAqRgDg7U4V8ArJ3hAXwcRs=;
 b=M8O3XzKMycQbhx7zmmYcs6LD6GT3nKONcdgGQj7jVXt5xuQKRe3tnShC0QeyjvN5jKnnRnM2r5bPt1u6PzOub4GDIv6yzim9FbcILwB1U3dbxlOQI8WIJnjRe4wNcC2TeTiouCcz4jNmFNh77MM9dk5H9LfwsWDB9D7eswRl6fI1gc3fqQ60Of/VGTC8kD5JkqlDKpnENju413XF6FjPaiRLjOQ8QyyEpVMU92i6HK9srZDE+zeKurhkCGN+Qoogb8vzyNMv74bzRMXZ8eXeBRyYrjRF3OA0mkHtMlsa9xiYb9iAh7SXMa8W0DYkspfExkTld149m+GPohXzlBzPQA==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by CY4PR1201MB0135.namprd12.prod.outlook.com (2603:10b6:910:17::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15; Wed, 18 May
 2022 20:38:12 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4925:327b:5c15:b393]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4925:327b:5c15:b393%3]) with mapi id 15.20.5250.019; Wed, 18 May 2022
 20:38:12 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     "xiakaixu1987@gmail.com" <xiakaixu1987@gmail.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
CC:     "djwong@kernel.org" <djwong@kernel.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: reduce IOCB_NOWAIT judgment for retry exclusive
 unaligned DIO
Thread-Topic: [PATCH] xfs: reduce IOCB_NOWAIT judgment for retry exclusive
 unaligned DIO
Thread-Index: AQHYatDCNqGlarKHUkaa6u5n0dSSuK0lGL+A
Date:   Wed, 18 May 2022 20:38:12 +0000
Message-ID: <46821243-716a-86cc-e849-eafae5aa75d5@nvidia.com>
References: <1652889671-30156-1-git-send-email-kaixuxia@tencent.com>
In-Reply-To: <1652889671-30156-1-git-send-email-kaixuxia@tencent.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 215d1f9d-8d23-4c12-931b-08da390e53bc
x-ms-traffictypediagnostic: CY4PR1201MB0135:EE_
x-microsoft-antispam-prvs: <CY4PR1201MB0135ACA4CCBAB0808392921AA3D19@CY4PR1201MB0135.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XznavZbJuoSOqQc5EE9DcOQF5hRx+hv07GEXa7UMN04Dlm8GRMAhec1F5/31FzZ9on4vs/6jCslSvClqy4IAbQqiJtVEfcYvcob9SlDWuoSA5Je0uK9drp8AZErl0ymBtp5pGfiuQr9hTMcNU+JLBWuf0gTMw+RG5fL10t+rTIf7ArgAo3Xt44S/BF/4/zIMDos0tLF4cZmJSsahwNGB4ryxr/yBzRC/nQyZzSatJ0O7c9Tam3e+9wPo++UhP1Nja7FoaVlT/eAfG7vBo8QieFh7Nc4pwz3bkiQXEwMe899Vqbf+XGhFcipL5cP3joD2QGz0+U3oXja21+I4kigdHviF3UIU74w0u4518d/10YN5DmhnqOq56NlOemIqcqN+Ze51Cle/SNSnx+I/44K77Fmb6eDGjzgLxGNAGo2F83/rKVIHFCMidxZKnwfEC3M1RDseLS3WE1oqdXbrJ3Yg5ivDZ/TDbphRqKQNu2VK4x1aTwaOOdI3SeN4dmMW1ovHEQLJDCFEgOHF5/e9I1H7AaW+Ea8qSbAX0+MLOjvZN3SF6Ykdf+MYr9D+U49lW6LwTboN5swGxrNsWlr23Q2DfKI8WH/QJN/LUW3us0WEEPOpz6jyc4CnH/tk+jT6LxQScT/y5RCfXvQ3GOqnxxo5mnBgJHzbqyGLkadLMS7vci8NJqcYGr9Giuh68/uY4hazc/GaJNxu5D6hE0dBX+jNPPEUwO0suDDzEhb9npRkKiL8UXmthgZdcgFB92s6Tq2Rm/2CtboVRyPhNe8QHD6GXg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(2906002)(508600001)(71200400001)(4326008)(8676002)(76116006)(31696002)(54906003)(110136005)(91956017)(86362001)(316002)(31686004)(66946007)(6506007)(66446008)(4744005)(83380400001)(64756008)(66476007)(5660300002)(8936002)(66556008)(53546011)(36756003)(38070700005)(186003)(2616005)(122000001)(38100700002)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QUxZY0Zkc3gzYzZKdDgwb3g3ODZYUUljSWJlZVc4Ykp0RXJZeGExQnN3ckpz?=
 =?utf-8?B?aDFHN0hrZHRYclEwdktKK0ZQRG10RDFqZ1hsNHZ2OGIzQWxKbFhnSHh3TzFV?=
 =?utf-8?B?eC8vandSclFpMmsxaHBLaWl1UWl0dlkzTzRSMnEwc09kamNOaExIZkhCcUJY?=
 =?utf-8?B?ZkgrWkxCaHlKUi9IeThKSkJySjQvQ1d6Z3ovVWVlN1ZEUXlRRnphaGowRkRR?=
 =?utf-8?B?am1mSVl4MmxFY0tnbkJvclRFUGZ3YU10SWozMWtlK1JlTXBQMGdpTzBSMG5y?=
 =?utf-8?B?dlowcE1aUGxRTDF3dVZlWG9FRDNQTVhVSUpheWc3d3M4SytxSzU1VlNNSmZs?=
 =?utf-8?B?cWJlYSswZ1E3QzZSUTBxMklFSkFwQ1hSZDE1NTZabjF1alZQQWtJMkZUT3U1?=
 =?utf-8?B?THNwQlZZMmZNVVJWUjBsRWY1SmwxRk4vU0VQb2ZiZlU0azJBbDlEalBEMlNY?=
 =?utf-8?B?RUpSS2ZHMExTcW4wN3FiZ3lHeHRkSzZmS1dpL1N4MG5JVGNPVURxME80Y2NO?=
 =?utf-8?B?U1JuZmNUZFN4bmpNYVNCWmhEbGFuMGE1VVJyckg5WFVXV09BNUM5SXNBamJz?=
 =?utf-8?B?Nmlha2RzbHRRWEp5TzBFbmtURXJ3d255ZEpvMHlBb1JudWp6SU1Db0pBaVNX?=
 =?utf-8?B?ZnZLZVRMc0tFV0FsRFJQL0RNbHRWbkhkMUp2cG00RHZ3ZGRGU0VBb05Qd1Ba?=
 =?utf-8?B?bXJURjhudFFJYUNCMHhUakJXMWpSRExNeFFnUmxiR01pMTl3TS9oTGtsSkw4?=
 =?utf-8?B?dmRWTzJsVjlBaTFHTUlLNzg1TEtVbkt1bmFHelVkSzlJOWV2RkdnMk50UVho?=
 =?utf-8?B?OTRWWXZMRUJqajl2TVltcTQxTENVL2M1SU80MDRwTkNKNWNkYU5ZcHpxbGZC?=
 =?utf-8?B?bTlSMDdQa2JyeEJHQUlNemlqWEJFbjMxakhCc0gvS25Ta3ovVVdYdlVjM2Zi?=
 =?utf-8?B?WDFLMWFXZEpzUlVjV2NUWXRhbUxGbTBlUk5xYXdiOUdXSmJPQ3F6TmU4WS9M?=
 =?utf-8?B?a05YUnhmcnJ0NGJBTlY2RHViQkJwcXRGdjZUWUhENlNoTTQ0MVdDMVYxZ3hJ?=
 =?utf-8?B?eWlqMlFERE9NMDVPYUNxWWt4QUEvTld3cTZsMDlhRXRpUmlVa3AxSWR6RkZV?=
 =?utf-8?B?R0lPa0IzQ1dkOWZzYnNvMVhDTXRpVFpESHlVdmN2ZThEQk9qNVRqaldoaWtw?=
 =?utf-8?B?UjRaaFIrckorQnF0dXlIM2QvUlhhN09BVW9tV3kra1ExWXBRQ29ra0NuR2h3?=
 =?utf-8?B?VFUyaVJhWE1Lb1NxMUVYa3NWZ1pueFNnZVNueTlrUnIrRmhydE1QTkt0MlND?=
 =?utf-8?B?Z2xNekxKZ1lqVVRaODY0Lyt0Z1I3UGVJYkhKVjZzNHFjeDk4b2FVZ2o5d0NF?=
 =?utf-8?B?SC95eWhwNENBT2h3TDZydkIvaWhXeVhLZjRTOFB2M2lWbG9IQ1pyeTcwQ1Fu?=
 =?utf-8?B?dEQ4NnU0QXpFankyQzdTdktYenlzUnRMQ3hqREJhQzJWQzZMc01UZzFXdE56?=
 =?utf-8?B?SUJJSTJSOHNtQVRiZ09YemozUmJCdzJzWC9ZUm5GV2hLVDd0Tjl5QWk2VlFr?=
 =?utf-8?B?TFdKTm9nK043TGFid200bXNnUWlYbUw0ZGlVYkJPMnhSdDlSR3RXT0JFV1Rr?=
 =?utf-8?B?UkwvaTA4TUV1MkdpRUZwNXI4Zm82MDZpOXA1VjlLcW1FTUw4dnhNMUo0b0Z2?=
 =?utf-8?B?UHh3NEh6aUxjMVVXcDNycUU3YlliYXpwaXhvNDNoLzJMdDJFUHNPWktFYldF?=
 =?utf-8?B?anRsanNMeGZRQ3ZtWTJIYk0wRmFuSzNyUXFLbU92bUZLVCt4WUJORjVLWk53?=
 =?utf-8?B?bmEvd0pTSnhLRC9VUCt3S3RNU0dTTFdiNmJUUWNuWkpoV1pBa3p6WHhmSTVT?=
 =?utf-8?B?S01RSVF2a1FZaTcwUTJPdW90cDVYTm1OQWN3MHZBejlrTzRITWpjei82VlBw?=
 =?utf-8?B?Qm5McFpRM1k0WU5aUXg0M3dWRnlJeWZWSUJyN3lEREpkNVVwazViSVJUcXkw?=
 =?utf-8?B?MDVPZ0dhQ0gxREdBQkdONkx4emgvdVk3K3gwOHhod1l4cWpZUCtrNC9aNEs4?=
 =?utf-8?B?VTEwSitkcElwK29rQ1RCUWQ4ZVhIcFVodkdOVHNISTRHZU5vQXZGNTU3cXFP?=
 =?utf-8?B?L3hsSHBTL3N4SVpNUThHS0VIYnROM1c5QTcrTzdTaERBT1lJRTlNYmJ6eUw1?=
 =?utf-8?B?aVZ1c3RvR3VIUGJLc0JMMnpDcEhsdStoUS9mc2lxdlRlVktVWndaRWJWdVcv?=
 =?utf-8?B?T3hray9Jb0RZTGlBTHJ5ajJTTEJEMlQ4SHVVME5PaExVc29iWmxhRzk4VWFo?=
 =?utf-8?B?RnBCWHdUOEQyb1poVEQwUTBLY1dxTlBKZ2FzejR3QUR3bENQSG93eWxtcWF0?=
 =?utf-8?Q?tpEXiCbEXQJQFZgV1MHP35khg+FhXHVyicAG5YdRjX29b?=
x-ms-exchange-antispam-messagedata-1: rmLZCtf6dXlMeA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <51B992B7ACC0104BB4D4767DBD7BC36C@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 215d1f9d-8d23-4c12-931b-08da390e53bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2022 20:38:12.3382
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mDvH124XVoPudZJHWU3G5Me/dsi+53LX6C90wQUGSebI4hJoNEUJ5minjSkCfNK8UTlIeFvWvBfMmD/E0XwVNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0135
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gNS8xOC8yMiAwOTowMSwgeGlha2FpeHUxOTg3QGdtYWlsLmNvbSB3cm90ZToNCj4gRnJvbTog
S2FpeHUgWGlhIDxrYWl4dXhpYUB0ZW5jZW50LmNvbT4NCj4gDQo+IFJldHJ5IHVuYWxpZ25lZCBE
SU8gd2l0aCBleGNsdXNpdmUgYmxvY2tpbmcgc2VtYW50aWNzIG9ubHkgd2hlbiB0aGUNCj4gSU9D
Ql9OT1dBSVQgZmxhZyBpcyBub3Qgc2V0LiBJZiB3ZSBhcmUgZG9pbmcgbm9uYmxvY2tpbmcgdXNl
ciBJL08sDQo+IHByb3BhZ2F0ZSB0aGUgZXJyb3IgZGlyZWN0bHkuDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBLYWl4dSBYaWEgPGthaXh1eGlhQHRlbmNlbnQuY29tPg0KPiAtLS0NCg0KTG9va3MgZ29v
ZC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5jb20+DQoN
Ci1jaw0KDQo+ICAgZnMveGZzL3hmc19maWxlLmMgfCAyICstDQo+ICAgMSBmaWxlIGNoYW5nZWQs
IDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZnMveGZz
L3hmc19maWxlLmMgYi9mcy94ZnMveGZzX2ZpbGUuYw0KPiBpbmRleCA1YmRkYjFlOWUwYjMuLjI1
MGEzZjk3NDAwZCAxMDA2NDQNCj4gLS0tIGEvZnMveGZzL3hmc19maWxlLmMNCj4gKysrIGIvZnMv
eGZzL3hmc19maWxlLmMNCj4gQEAgLTU3Niw5ICs1NzYsOSBAQCB4ZnNfZmlsZV9kaW9fd3JpdGVf
dW5hbGlnbmVkKA0KPiAgIAkgKiBkb24ndCBldmVuIGJvdGhlciB0cnlpbmcgdGhlIGZhc3QgcGF0
aCBpbiB0aGlzIGNhc2UuDQo+ICAgCSAqLw0KPiAgIAlpZiAoaW9jYi0+a2lfcG9zID4gaXNpemUg
fHwgaW9jYi0+a2lfcG9zICsgY291bnQgPj0gaXNpemUpIHsNCj4gLXJldHJ5X2V4Y2x1c2l2ZToN
Cj4gICAJCWlmIChpb2NiLT5raV9mbGFncyAmIElPQ0JfTk9XQUlUKQ0KPiAgIAkJCXJldHVybiAt
RUFHQUlOOw0KPiArcmV0cnlfZXhjbHVzaXZlOg0KPiAgIAkJaW9sb2NrID0gWEZTX0lPTE9DS19F
WENMOw0KPiAgIAkJZmxhZ3MgPSBJT01BUF9ESU9fRk9SQ0VfV0FJVDsNCj4gICAJfQ0K
