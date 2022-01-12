Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF98CC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jan 2022 01:21:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344120AbiALBVw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jan 2022 20:21:52 -0500
Received: from esa2.fujitsucc.c3s2.iphmx.com ([68.232.152.246]:17805 "EHLO
        esa2.fujitsucc.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232589AbiALBVv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jan 2022 20:21:51 -0500
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Jan 2022 20:21:51 EST
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1641950512; x=1673486512;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=HJgc5DrHDMfKxohjdgAXl2qcjScU04zp5/2ZZOtnaFo=;
  b=ir3LZFjPB03meQGDiXWoM0ZXj3zmjJHUOdCFADAeW5RcJ44AGNgYAnqT
   VKOs8kKZa808ie2JvJVKIo3XpSPlz2f+8J5Icmvf3rmTAJ/9sQX+QrVvk
   KTyU4qB/eu2FMjVZW3O0kG/pYCT+Z/2SaIB/kktwJbKnm8WJFRXhxJlkJ
   tidDR9k8ghYVjPQ7ZM/yn41gXUdlhrRxDU898QIC6d0Nz9Wrz7xcmN+DK
   syz+PtDeJlPpRTgPxa1wrfy5+XRrBKKaGAfuwqHNrSINFqy8WUHAkcFO8
   tAG7ysQMNNjTcThy69+H3/9v3XkbCZ89ZrDYTMs1nai6IiZuJNVdGpGG0
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10224"; a="55687504"
X-IronPort-AV: E=Sophos;i="5.88,281,1635174000"; 
   d="scan'208";a="55687504"
Received: from mail-tycjpn01lp2175.outbound.protection.outlook.com (HELO JPN01-TYC-obe.outbound.protection.outlook.com) ([104.47.23.175])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 10:14:40 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MzQb+7fgm0QW1LOqgz9F6LcPEcg4bJTot5hUobWokZqLPbTnG34NxP+4qhHEbgKNiWheExFX0kgj1HQpzzZAkG9VZiEIJ12m7s+OEg4LmdGFdnx0I57rXMqE9MYqIvkxzsvSGU02dIJWRPK2RDztZ1DlmegIedeig3fNJudz1KGQy+m9SssxvhR+YbTXGGZ02daIvyZY9bP3SGqQFbdBxFjQOt7AUE3Jl8L5MboqisWRn3j1QhFRoJ5t+WHOl1pcI7bvkMJ74H31m8eyYOT6Eu4Kr9kmPDcANIGx/YGjb0I0AsoS7M4nS+BPsZXKP4/ZCAbUrPtKWN+RN6nitH2zdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HJgc5DrHDMfKxohjdgAXl2qcjScU04zp5/2ZZOtnaFo=;
 b=hIE/HpBxJd6oq5/enDUUMesK/G/l5QqPgT++GrHLGz3llZ2IgCEUxjIpxyMvS3uCkgeLSb60zmf/neRyi8tbJrD2NV3kUXc6k4SSfSFbHf9s4Z1xmDmeskuCgvQMj/KRFeTAK7JpZ/6tDae3qMHO8egKM+ZWVrzcPVzqiKIrKnrxFOFDYCz+V1XhCmd+bqRlO3A6FgZ5HYocMqW2QnhqbvQBrttGw8MXGPG1DUoB9FnT9wlOM9RpYXcx5LLoM371nUqCoMHWOqbG2+cbCXNvNN1/wl8mgwSFwmZW/v3irBSsKU9yw1AvxK4xJJK3zn/2Vy8UE9/MJKxjLnL9Uiuw9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HJgc5DrHDMfKxohjdgAXl2qcjScU04zp5/2ZZOtnaFo=;
 b=Q0pIOimM7J5x2kL/jNMVJM9He5sGOdub/RV89IO0WYrJir6jv5MwqKH+dDg5ulxgoRjaZDHbbbXfNdMD03Kh8v/TFOzW3joewLIQBEXs+dH7BDTtQ6qCcIStQiyQb28CCdRizgR1R5g0W9g3lpRQTtbkfEqn1h1dg3VBg21R18M=
Received: from TYCPR01MB6544.jpnprd01.prod.outlook.com (2603:1096:400:98::6)
 by TY2PR01MB4138.jpnprd01.prod.outlook.com (2603:1096:404:d0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Wed, 12 Jan
 2022 01:14:37 +0000
Received: from TYCPR01MB6544.jpnprd01.prod.outlook.com
 ([fe80::9486:fa6e:4ac9:802b]) by TYCPR01MB6544.jpnprd01.prod.outlook.com
 ([fe80::9486:fa6e:4ac9:802b%4]) with mapi id 15.20.4867.012; Wed, 12 Jan 2022
 01:14:37 +0000
From:   "xuyang2018.jy@fujitsu.com" <xuyang2018.jy@fujitsu.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     "guaneryu@gmail.com" <guaneryu@gmail.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        "guan@eryu.me" <guan@eryu.me>
Subject: Re: [PATCH 3/8] xfs/220: fix quotarm syscall test
Thread-Topic: [PATCH 3/8] xfs/220: fix quotarm syscall test
Thread-Index: AQHYBzVA5VGcE55S5Eyb5V4nwruB9axelVmA
Date:   Wed, 12 Jan 2022 01:14:36 +0000
Message-ID: <61DE2BAF.3000001@fujitsu.com>
References: <164193780808.3008286.598879710489501860.stgit@magnolia>
 <164193782492.3008286.10701739517344882323.stgit@magnolia>
In-Reply-To: <164193782492.3008286.10701739517344882323.stgit@magnolia>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7663f1ab-91d1-4a1e-078e-08d9d568e688
x-ms-traffictypediagnostic: TY2PR01MB4138:EE_
x-microsoft-antispam-prvs: <TY2PR01MB413848834E59EC4DDBEA4D35FD529@TY2PR01MB4138.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1775;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: htPeAKJw4kLI+v+2YYt7AcrOEH4sUQma1G9aXXHWVIBV0YrIO8vhnd8bAH6JSgH7bMDqJh8wVrdNbdN+D3BGi3Kbr8R+guf6N4TTWdXaqNrOmqyjd1nj/X1a70mTIX7oNnL3wj/1WLBysv7L3Pj/30dkKqXCEBLBu8rkqHRN09QCXEegUC4NuP8JMHeE1EC7imk7zuJcXWQXs23q+9+eg7TECL0Ukey7IkDzDo9pAxxqSJUr6iZt5b7o5VR14I7UdjD+6isa4XfNqclvox1RJdiKl3dp2ClOOwHwfv5ZzYDHa1rTqkGr5luisJhue7pFRyX6kLF935b4rwO4wDH1T+sG/a6DLuK1lhdyk6qabhYwtA3PSix9+cBBL9TS9QhaU9C1qZlhfnk50jiNafR1YTNV8ro8vMAFvzjypIPB95GlV/PnRzHyfzgeNx4lbyAXrWGg2R2lUWagPv3rZrHLCk4evhoSBj5lNIGzizSDzy9BLsSby1grY2b5/CiVqplt0JM631Fh41lAQWu0lv8et8lyErazb/g8r66hCEkEVNqdB7Qz0/pwyFpndGAF16q3yt0ngFLs9c6LlrE+of2miVErmZcqx72BP+KDv+IiN43ud3MGkt6az23cSUfOOxAaiYyJ4mBaSmvK+lBa381g4w+qR7a1VRuq5JK25AXBUZQhFDThbli2QSBkSu6tIKlsQ2ApoBiSYAfuYNj/4+5gXw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB6544.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38070700005)(64756008)(66476007)(82960400001)(2906002)(36756003)(66556008)(66446008)(186003)(71200400001)(66946007)(86362001)(6486002)(83380400001)(316002)(87266011)(122000001)(54906003)(6916009)(6506007)(33656002)(8676002)(38100700002)(4326008)(26005)(91956017)(8936002)(6512007)(85182001)(5660300002)(15650500001)(76116006)(508600001)(2616005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bVgwN2VxWGFmdGNMYS9vMDlJdVRvdGI0TmpGaUlOMjV0OXFBNjNuZG82R3Jj?=
 =?utf-8?B?b3gwYmRlVXM0cDZtbERsQmlqMjVDemd0dE1va3RCV2RsN1lMR0FoV1JJQlln?=
 =?utf-8?B?akdKQWtHZkhhRnhvcTAvQkw3T010Y3JzMlhGbG9rVEJ3MDNDTTVZUXBrc2Rn?=
 =?utf-8?B?YVNEZWJVVjB3REJUZFZ2WDU5NDZQYVF1cXcvMUNKWk5Ic3ZvLzMwL2VIeHFj?=
 =?utf-8?B?U3J3NzFNa0NER0ZvSVV2NWdkUndRRWQ1NmZpNERiNXIvM3R2Z0pMTU5xdlAy?=
 =?utf-8?B?ZVpnV3ZEWDBZTGZ6eEpuVmU3bEdrVUFRNjRGTU5LbURiZXk3NTVGeHBzOUJH?=
 =?utf-8?B?MjFnUUN0WEtodTF3MWNOWUpnUXQvVVZkaTdpWWtFbVVSWjZQYitWYmY1ekJX?=
 =?utf-8?B?Tzhza1VBMFkrblhQYm40NjFIWU1VN2FXMUxBRi9XV1NzTHJqZEZSOS9oNFA4?=
 =?utf-8?B?bVFVbHFOS1NIdkYxaDdhd2Y0Y3hHMWl2ZVAzTmJmRjFRY0RCaW5JL0NNTDN3?=
 =?utf-8?B?akFETkJCd2R2VGd3KzlvSWcvR08zcEw5WEhOMTdLRUlwZGR4elhBRFpFcWhZ?=
 =?utf-8?B?ejZFeFNVbWZYWmhVV2gxQ2VxdjFnWEdiSGliSGlEb2JvOVNNV3JHa3Fwc1dt?=
 =?utf-8?B?eE1HUGg5ejFLZkNhQUhJNHFOdzlzZTJxb092TGZ4UkFWVStiWHkvUVY1c0Fs?=
 =?utf-8?B?dllERTRjdW9vL2M1YTVERUdKUmthL2EwT1MybUQzV29PVmliS2VhTW5XWHdW?=
 =?utf-8?B?WjVPMGtmQWhtWFBRc21aQnFxR25NeS9mSEFWbFpIbUgyU0VSeHFlK3ZSbjlt?=
 =?utf-8?B?d1Z5eUVuaE94U3VUckN3RVNQRlVXKzYyRW9mODh5d0Ewd3h4dVBrTkd0akVF?=
 =?utf-8?B?cGFwUGRHUG10K1F1Y2xkSGN4dzl6TjFycUVBaU5CYVpXbHVJdGY1WGNlQ3Jp?=
 =?utf-8?B?WVhUSGlubWRLTTUrNFA3bWNLMi9mVU1QZCswa20yalBPTk1KdnAxYStpM2M4?=
 =?utf-8?B?V1cwU2JNK0ZSZysxTEcxWW1DdHJhQ2ZpK3pVZXBZTXJaTUNhTFlLdmg3WmpU?=
 =?utf-8?B?WjNSa1V5aHE0UTFPK3Zvbmt5VWRoQTltOWp1R3EwK0g2cktSVUlLa0VEYTB5?=
 =?utf-8?B?bkQrNkJNZHlIVC9ieWwrZVNJamgrNmpiamttWTgyZXRYU2ZDM3ZEdElHTGN2?=
 =?utf-8?B?MmZDTmJ0WWpybWxzKy8zV2ZlWndOc3AwMTFUNUtPaXJWME90cUw4bkpMRXJC?=
 =?utf-8?B?OXMzQ3JKNmtYMWphT0lCc0VZN2tqSG5JYUw2c1k4RjNNMmRPditEN3JkbHdE?=
 =?utf-8?B?NnZqQytiQmNtbVVKNDd1ZEttZHBJSGZxVjU0aWNLdmZkeVhnRWRWOCs1czY5?=
 =?utf-8?B?K2tSbGRpK3V4a2x4aVB0QW9Lb0hlVXVpTCt6Y3BPY2ZhZWYrZVNETit1TTNl?=
 =?utf-8?B?bzE2RzIxRE5tdDcvaFJ0ZGVYR1lRNGF4U0RsY3p3RWhvRkJZQzI3RFZSQytY?=
 =?utf-8?B?S0hlT3lyZGNTU09IWS9iNk5oTkZ5TWpTVyttMVJCbjVhQWZYbStmVm0wbmtM?=
 =?utf-8?B?WVU3SzlEL0hnWVZ0SVpNSG9DOHpnOXR1YjJuNWFkanNpMGF1ekM5WjJQYmx1?=
 =?utf-8?B?UHhCR0xXb0F3SVgyYzhMQXFxeS93aTR5RlU0N3QyS1NQUFRnYk8vd0Z3R2lq?=
 =?utf-8?B?cUg1VGJyZG0vSTZYRFhmU01VVnhIZmpESVR4bDdUNGZXQmprZVg5NnBRSWoz?=
 =?utf-8?B?bXRhU3g1WTlXZGZlUEtxUHZxK1AvUElwcVVFUjF4VUxwdzFZRlBKVytJc2NQ?=
 =?utf-8?B?WVRqcUF2SVVKckZmUUZPUFZzZ3dNOTF6QXFEdHdvZU5LYTl1RkRYdFV5OXB6?=
 =?utf-8?B?cmJUVnpYL05za3VYbEFuSG1XMXFURU9KZnhVcUl5ZE44OFhKdU00MU51czV1?=
 =?utf-8?B?dU9DOStIV01rN05pdHVhM3YxZy9zRFpLcUF3a095bUFUNFJ6a0R5RTBlYW5L?=
 =?utf-8?B?K2dMWkRIaVhaM29GYnBPd1FqemRzTlVqd3J5SDIxenBYVlVhZUFTL2QvVVYv?=
 =?utf-8?B?cE5lNUgzMWFXZGxoM003TXBjZEF4MzBCM01ZQUQwN3dLNzhDVUUzOVF6Mzg5?=
 =?utf-8?B?bmpKUmhjVUhNVUx5Nm5BeWM4TVN2ak10ZkZvNnVJdEI2MXVFbmhzei9pKytr?=
 =?utf-8?B?M2s1SjlxeG8zU1U2N1l0MzMwU1ZMeDBEcjc5R3lYUTgyN3lHZ1lHWjdvQWRM?=
 =?utf-8?Q?DSfX0RAAFrji9avJktYacSK3JtBaPvv4VVJhl3ebqM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D8BA936C8019B44BBFB49353196BDEC@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB6544.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7663f1ab-91d1-4a1e-078e-08d9d568e688
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2022 01:14:36.9531
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B3cZkVd6dGpt+K5dte1XrB6dTpy3qosuX774fMSONP+fU9SScrB7ckucEuiN733RcYjHMUEfdaLofI06i/2xg1MGQsWWIVmQVs+Crcutc2o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR01MB4138
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

b24gMjAyMi8xLzEyIDU6NTAsIERhcnJpY2sgSi4gV29uZyB3cm90ZToNCj4gRnJvbTogRGFycmlj
ayBKLiBXb25nPGRqd29uZ0BrZXJuZWwub3JnPg0KPg0KPiBJbiBjb21taXQgNmJhMTI1YzksIHdl
IHRyaWVkIHRvIGFkanVzdCB0aGlzIGZzdGVzdCB0byBkZWFsIHdpdGggdGhlDQo+IHJlbW92YWwg
b2YgdGhlIGFiaWxpdHkgdG8gdHVybiBvZmYgcXVvdGEgYWNjb3VudGluZyB2aWEgdGhlIFFfWFFV
T1RBT0ZGDQo+IHN5c3RlbSBjYWxsLg0KPg0KPiBVbmZvcnR1bmF0ZWx5LCB0aGUgY2hhbmdlcyBt
YWRlIHRvIHRoaXMgdGVzdCBtYWtlIGl0IG5vbmZ1bmN0aW9uYWwgb24NCj4gdGhvc2UgbmV3ZXIg
a2VybmVscywgc2luY2UgdGhlIFFfWFFVT1RBUk0gY29tbWFuZCByZXR1cm5zIEVJTlZBTCBpZg0K
PiBxdW90YSBhY2NvdW50aW5nIGlzIHR1cm5lZCBvbiwgYW5kIHRoZSBjaGFuZ2VzIGZpbHRlciBv
dXQgdGhlIEVJTlZBTA0KPiBlcnJvciBzdHJpbmcuDQo+DQo+IERvaW5nIHRoaXMgd2Fzbid0IC9p
bmNvcnJlY3QvLCBiZWNhdXNlLCB2ZXJ5IG5hcnJvd2x5IHNwZWFraW5nLCB0aGUNCj4gaW50ZW50
IG9mIHRoaXMgdGVzdCBpcyB0byBndWFyZCBhZ2FpbnN0IFFfWFFVT1RBUk0gcmV0dXJuaW5nIEVO
T1NZUyB3aGVuDQo+IHF1b3RhIGhhcyBiZWVuIGVuYWJsZWQuICBIb3dldmVyLCB0aGlzIGFsc28g
bWVhbnMgdGhhdCB3ZSBubyBsb25nZXIgdGVzdA0KPiBRX1hRVU9UQVJNJ3MgYWJpbGl0eSB0byB0
cnVuY2F0ZSB0aGUgcXVvdGEgZmlsZXMgYXQgYWxsLg0KPg0KPiBTbywgZml4IHRoaXMgdGVzdCB0
byBkZWFsIHdpdGggdGhlIGxvc3Mgb2YgcXVvdGFvZmYgaW4gdGhlIHNhbWUgd2F5IHRoYXQNCj4g
dGhlIG90aGVycyBkbyAtLSBpZiBhY2NvdW50aW5nIGlzIHN0aWxsIGVuYWJsZWQgYWZ0ZXIgdGhl
ICdvZmYnIGNvbW1hbmQsDQo+IGN5Y2xlIHRoZSBtb3VudCBzbyB0aGF0IFFfWFFVT1RBUk0gYWN0
dWFsbHkgdHJ1bmNhdGVzIHRoZSBmaWxlcy4NCj4NCj4gV2hpbGUgd2UncmUgYXQgaXQsIGVuaGFu
Y2UgdGhlIHRlc3QgdG8gY2hlY2sgdGhhdCBYUVVPVEFSTSBhY3R1YWxseQ0KPiB0cnVuY2F0ZWQg
dGhlIHF1b3RhIGZpbGVzLg0KTG9va3MgZ29vZCB0byBtZSwNClJldmlld2VkLWJ577yaWWFuZyBY
dSA8eHV5YW5nMjAxOC5qeUBmdWppdHN1LmNvbT4NCg0KQmVzdCBSZWdhcmRzDQpZYW5nIFh1DQoN
Cj4NCj4gRml4ZXM6IDZiYTEyNWM5ICgieGZzLzIyMDogYXZvaWQgZmFpbHVyZSB3aGVuIGRpc2Fi
bGluZyBxdW90YSBhY2NvdW50aW5nIGlzIG5vdCBzdXBwb3J0ZWQiKQ0KPiBDYzogeHV5YW5nMjAx
OC5qeUBmdWppdHN1LmNvbQ0KPiBTaWduZWQtb2ZmLWJ5OiBEYXJyaWNrIEouIFdvbmc8ZGp3b25n
QGtlcm5lbC5vcmc+DQo+IC0tLQ0KPiAgIHRlc3RzL3hmcy8yMjAgfCAgIDMwICsrKysrKysrKysr
KysrKysrKysrKysrLS0tLS0tLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAyMyBpbnNlcnRpb25zKCsp
LCA3IGRlbGV0aW9ucygtKQ0KPg0KPg0KPiBkaWZmIC0tZ2l0IGEvdGVzdHMveGZzLzIyMCBiL3Rl
c3RzL3hmcy8yMjANCj4gaW5kZXggMjQxYTdhYmQuLjg4ZWVkZjUxIDEwMDc1NQ0KPiAtLS0gYS90
ZXN0cy94ZnMvMjIwDQo+ICsrKyBiL3Rlc3RzL3hmcy8yMjANCj4gQEAgLTUyLDE0ICs1MiwzMCBA
QCBfc2NyYXRjaF9ta2ZzX3hmcz4vZGV2L251bGwgMj4mMQ0KPiAgICMgbW91bnQgIHdpdGggcXVv
dGFzIGVuYWJsZWQNCj4gICBfc2NyYXRjaF9tb3VudCAtbyB1cXVvdGENCj4NCj4gLSMgdHVybiBv
ZmYgcXVvdGEgYW5kIHJlbW92ZSBzcGFjZSBhbGxvY2F0ZWQgdG8gdGhlIHF1b3RhIGZpbGVzDQo+
ICsjIHR1cm4gb2ZmIHF1b3RhIGFjY291bnRpbmcuLi4NCj4gKyRYRlNfUVVPVEFfUFJPRyAteCAt
YyBvZmYgJFNDUkFUQ0hfREVWDQo+ICsNCj4gKyMgLi4uYnV0IGlmIHRoZSBrZXJuZWwgZG9lc24n
dCBzdXBwb3J0IHR1cm5pbmcgb2ZmIGFjY291bnRpbmcsIHJlbW91bnQgd2l0aA0KPiArIyBub3F1
b3RhIG9wdGlvbiB0byB0dXJuIGl0IG9mZi4uLg0KPiAraWYgJFhGU19RVU9UQV9QUk9HIC14IC1j
ICdzdGF0ZSAtdScgJFNDUkFUQ0hfREVWIHwgZ3JlcCAtcSAnQWNjb3VudGluZzogT04nOyB0aGVu
DQo+ICsJX3NjcmF0Y2hfdW5tb3VudA0KPiArCV9zY3JhdGNoX21vdW50IC1vIG5vcXVvdGENCj4g
K2ZpDQo+ICsNCj4gK2JlZm9yZV9mcmVlc3A9JChfZ2V0X2F2YWlsYWJsZV9zcGFjZSAkU0NSQVRD
SF9NTlQpDQo+ICsNCj4gKyMgLi4uYW5kIHJlbW92ZSBzcGFjZSBhbGxvY2F0ZWQgdG8gdGhlIHF1
b3RhIGZpbGVzDQo+ICAgIyAodGhpcyB1c2VkIHRvIGdpdmUgd3JvbmcgRU5PU1lTIHJldHVybnMg
aW4gMi42LjMxKQ0KPiAtIw0KPiAtIyBUaGUgc2VkIGV4cHJlc3Npb24gYmVsb3cgcmVwbGFjZXMg
YSBub3RydW4gdG8gY2F0ZXIgZm9yIGtlcm5lbHMgdGhhdCBoYXZlDQo+IC0jIHJlbW92ZWQgdGhl
IGFiaWxpdHkgdG8gZGlzYWJsZSBxdW90YSBhY2NvdW50aW5nIGF0IHJ1bnRpbWUuICBPbiB0aG9z
ZQ0KPiAtIyBrZXJuZWwgdGhpcyB0ZXN0IGlzIHJhdGhlciB1c2VsZXNzLCBhbmQgaW4gYSBmZXcg
eWVhcnMgd2UgY2FuIGRyb3AgaXQuDQo+IC0kWEZTX1FVT1RBX1BST0cgLXggLWMgb2ZmIC1jIHJl
bW92ZSAkU0NSQVRDSF9ERVYgMj4mMSB8IFwNCj4gLQlzZWQgLWUgJy9YRlNfUVVPVEFSTTogSW52
YWxpZCBhcmd1bWVudC9kJw0KPiArJFhGU19RVU9UQV9QUk9HIC14IC1jIHJlbW92ZSAkU0NSQVRD
SF9ERVYNCj4gKw0KPiArIyBNYWtlIHN1cmUgd2UgYWN0dWFsbHkgZnJlZWQgdGhlIHNwYWNlIHVz
ZWQgYnkgZHF1b3QgMA0KPiArYWZ0ZXJfZnJlZXNwPSQoX2dldF9hdmFpbGFibGVfc3BhY2UgJFND
UkFUQ0hfTU5UKQ0KPiArZGVsdGE9JCgoYWZ0ZXJfZnJlZXNwIC0gYmVmb3JlX2ZyZWVzcCkpDQo+
ICsNCj4gK2VjaG8gImZyZWVzcCAkYmVmb3JlX2ZyZWVzcCAtPiAgJGFmdGVyX2ZyZWVzcCAoJGRl
bHRhKSI+PiAgJHNlcXJlcy5mdWxsDQo+ICtpZiBbICRiZWZvcmVfZnJlZXNwIC1nZSAkYWZ0ZXJf
ZnJlZXNwIF07IHRoZW4NCj4gKwllY2hvICJleHBlY3RlZCBRX1hRVU9UQVJNIHRvIGZyZWUgc3Bh
Y2UiDQo+ICtmaQ0KPg0KPiAgICMgYW5kIHVubW91bnQgYWdhaW4NCj4gICBfc2NyYXRjaF91bm1v
dW50DQo+DQo=
