Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43731C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Mar 2022 09:42:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbiCVJnz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Mar 2022 05:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231436AbiCVJny (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Mar 2022 05:43:54 -0400
Received: from esa7.fujitsucc.c3s2.iphmx.com (esa7.fujitsucc.c3s2.iphmx.com [68.232.159.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18EF366BD
        for <linux-xfs@vger.kernel.org>; Tue, 22 Mar 2022 02:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1647942146; x=1679478146;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DQzavNMcrsBfW734dURmTCCtSpBZ6ntdWyXbxrUtIyw=;
  b=Cj2jd3DrJBgYAtmgLWv8PGAXs4695TiD3YMpqdeBd7SqUVAiaa0iD9yq
   XaGVvGCW4fvAoGGOD70FeDkT/uLQBydx5HaK8gI5PkEDP7zfjeimjW09j
   o3t7R52zNTDVHrCQYKufG41vNKhIEJwpBG5/Ntdl/cY7YFIFPew150HKi
   t4+Z2v5v6g8P8wUEqqCdpFo9EWSGxlwTbFB7W2Uc/Ji41bgjeqkqSGMWt
   HiiJK6YLvX3jMfRVXQXX4G9sa5J8jdA+97hWzRSA9i8bMNPVYmmCZ6+sa
   NliV7UDWFFOayCufEl1xjwD0BwMzW+z38mLG3aIN5+ii0eViYfN2QROiz
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10293"; a="52259165"
X-IronPort-AV: E=Sophos;i="5.90,201,1643641200"; 
   d="scan'208";a="52259165"
Received: from mail-os0jpn01lp2108.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.108])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2022 18:42:23 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N3Upd2aKMA92CuEK3vRNtVOGtIyaBNLa3x1KHnc6tDiJX6VWh3QB1knExn9Z16OvIpHdIWsurtZApHYNki8d6K8tLECIk9p/QglDfuxqVZdI6QzWT0X77kUz9WvFK/q6mnJaQ3s2/qR/MnHKOGjx6RMwx8pqSOTLAo5pqOyMDevNxfukrQudUybLNp++WsMnwzM1cdXOr+oj01Ts+51j7NaV2us1PoX2dApPpaJaLxnYZfEsFqdPH+XWeG3cB6Tp8Cb5EYWhQ7QzlcXWCNX8qugeyvryViR5gz5tCmMuOS82kt6TSzGzlsmEp5BTwO+3vfauNvVLMq4I9vIEgkLtSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DQzavNMcrsBfW734dURmTCCtSpBZ6ntdWyXbxrUtIyw=;
 b=GkUHUo6+FsZYT1Nj86ObAMXLG+xjX9G+bNxksMi6bmuO5VkIPXnHjEfBjImIkrHu3/Y76Xuc3XjYCx1ffjCBeXTb0gkdQXMm6e9Lhe2CeEx30lLx4wgCg+koMkYv1cRKpc/4MU2ph3W8hW0vE8VpklPckjewxHW17J7ALEZDf1J5GdhlxdS3HFokD+sk27sX90G/cXwFdhqi2W6Vh2CvfhZKv0rFs5cO3FJVgGfkna1i5STmwjYb1HSnJPewnDIQQCIs3+DH0MJbvCcK4B12vlrZ+QY7LRAHyU2cbKt/ykGvGKJRWfpF4q0m023yZiirU3MsXzVEFQjnesRdmsiqaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DQzavNMcrsBfW734dURmTCCtSpBZ6ntdWyXbxrUtIyw=;
 b=ctVQPSJAOYwTE2LkfnZKyTLk8kJ+mPmkGYjlOb/B8DFjyOZeSdydJ1luvjkNr2XVWTzDL0wlgjkKoRcG77rhvyA4py5WNn6cfi4jpzixJk5Dj/fqqX5vyYZMrgMr93T/iyGfRi7SwEAq6+u3XtsXttOR19RXzEPR0W4oDveIMv0=
Received: from TY2PR01MB4427.jpnprd01.prod.outlook.com (2603:1096:404:10d::20)
 by OS0PR01MB5347.jpnprd01.prod.outlook.com (2603:1096:604:95::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Tue, 22 Mar
 2022 09:42:20 +0000
Received: from TY2PR01MB4427.jpnprd01.prod.outlook.com
 ([fe80::dd2e:e671:b3d5:d354]) by TY2PR01MB4427.jpnprd01.prod.outlook.com
 ([fe80::dd2e:e671:b3d5:d354%6]) with mapi id 15.20.5081.023; Tue, 22 Mar 2022
 09:42:20 +0000
From:   "xuyang2018.jy@fujitsu.com" <xuyang2018.jy@fujitsu.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "djwong@kernel.org" <djwong@kernel.org>,
        "pvorel@suse.cz" <pvorel@suse.cz>
Subject: Re: [RFC RESEND] xfs: fix up non-directory creation in SGID
 directories when umask S_IXGRP
Thread-Topic: [RFC RESEND] xfs: fix up non-directory creation in SGID
 directories when umask S_IXGRP
Thread-Index: AQHYPcNfselsqwhzC0yUXxz4p072iKzLFj0AgAAQvAA=
Date:   Tue, 22 Mar 2022 09:42:20 +0000
Message-ID: <62399A32.8090103@fujitsu.com>
References: <1647936257-3188-1-git-send-email-xuyang2018.jy@fujitsu.com>
 <20220322084320.GN1544202@dread.disaster.area>
In-Reply-To: <20220322084320.GN1544202@dread.disaster.area>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 87650cd7-3815-484d-5f1e-08da0be84276
x-ms-traffictypediagnostic: OS0PR01MB5347:EE_
x-microsoft-antispam-prvs: <OS0PR01MB53478B1A117A656A626F2121FD179@OS0PR01MB5347.jpnprd01.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fgtvp+mnI+xVXLLSXlnjQZWFAV7+YI2vw5qA/053hO650Kfsfrhd7svMO3cYE792WlUucNguVQ7Zx/UVv5e3SPtNIhc7lkOw6SLrMZuDqq66B5XWmpdyjciDo1Z5ivHrH30lDjFJrEIJaDiIcaSvwp9FHDd3Jzgze2uiHmSTZ/9737DATwyRMEZAVMBk+snfRcC7d9A7jnBtf+G29FBWviRFc9f+KDkHni2bnnEFf0Pc8Ajtme4087Wz9gLdu9WfTAU8rngbhOq+S+FE7Ho13SveRfFSr7tT+YZSEoa0YYV3WE/IFnbILX4A8yGwZFJV2sQ1VpdwmdsSPMkJEuFaJYdn2TYNj9S9vKj1yP1ZLA0zK5kHC2GzgbIf74PoCrVmnPVX/GzmjQx/SqlmzB3qMTT8ciNI//1cziazz4rNLKBSfpsbobh9DSbGIx1oveNIaIzVa7IVg0eVNATHcHaQf2y/C7laVN4Tfw5GH5fnFm1E6BDGt97+amRy0W2guo2t0jEDqzt6/nnTmmB43WDH1YZJKeX651SrZiAYHOAtYSvEQppv0bJJr/rgfGlNKLTccqGqfY2v7b0w6dTpWKU4Cv4Fb1Oc4k4h2tR35xbvvR/FmtVRs8kJVYKwb7TYG1ynRpJoW+milKyLWsjDE5m1hhw0KLgBk4DCGXX6n7uWUAOv/HfXnso9sFEjA5z3rTRNb9t8hse7tcqBCnYURErh3w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB4427.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(122000001)(82960400001)(38070700005)(38100700002)(6916009)(54906003)(6486002)(5660300002)(71200400001)(66446008)(66476007)(4326008)(66556008)(8676002)(316002)(66946007)(76116006)(64756008)(33656002)(91956017)(2906002)(2616005)(26005)(186003)(6506007)(83380400001)(87266011)(508600001)(6512007)(86362001)(36756003)(85182001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?R0cvTjIxMkdBZnJSZy8rOXo2MzhYdHhiYmJ4Yjlwd0Q5T1JNN1BPZWpocUlM?=
 =?gb2312?B?cDlRQjd4bVhUaXFqOEY3dlZtcDNjbXNiQ3VWRHQ3ejBlZEZUQUJPdlpxWUxn?=
 =?gb2312?B?R21YRHBNdlVEUFpDNEp1VThwblUxS1hBZHZ6UHlYQ0RUTXVPRXd3bllyUVNC?=
 =?gb2312?B?S1ZPZE1mcG5xSFJyTTd0UnhIcStEeE9qM2xxTURhM0QyNlE4Qm5mdWlaNUlC?=
 =?gb2312?B?dVNyR2xISFNkVmNaODU1V1ZrVW11NEJ2TGVZVW9sMk9uM2RjYXlWUmpIMjVz?=
 =?gb2312?B?WnF3Y1o1SXlic2FmQ2RDK3hYT3pWQ0QrUVpJYk1qWFNjcVI0TWlHNUF5ZW8w?=
 =?gb2312?B?SERwWEtUVVUxR0pBZGNwOUFnNFZ0UTlkdUIvajdvWUp1YThMcm1KNmNvQzFF?=
 =?gb2312?B?bmlZZnJSTjE4QjJxeHJNOEUyRXpUSkpjNXpONW03dlhKMCtkM2JLR1RobUI1?=
 =?gb2312?B?dHZJaGNieGoxcWdJSGFmdlo4OHRoS01mTFZyZEdVMkppcTlBSk9KS3N6T2ZR?=
 =?gb2312?B?Zm52a1VtejZ0NHM2RGVOLzdCUkxibUs0dWQ1dk5VQktEaERHZ0JacnhSRStY?=
 =?gb2312?B?TGhlVlNKcHVob3RMT1RhbzAzcDVucnlydEtNZ2pKaEZab0s3cFlxaTVoQTVS?=
 =?gb2312?B?SWJ4S2lrRzkxemhHTExTNUNIbkFNdnlUbzBlenlJMUpPbUsvTjdweTJJajBR?=
 =?gb2312?B?VFdsT25mRXdkZVhkekE4MHJ6Y28wYmV5OUFCM0g4VFp0czFDeVNKSW13NFZ1?=
 =?gb2312?B?ZytUa21BdnEzZ1VFVDVRbFlYWlBMU1dwQ3RYWmVJMmhPZVRjQnNBTjZVTGY2?=
 =?gb2312?B?SGRFNEo5dUpvb0VXdjNXekVLTTl2Ulk0M05ITldPMHlzNEJYbUNidldxcStw?=
 =?gb2312?B?TkZKY2F4UlY0RFczeFlyR0JDMGUwYmdIYXNXd01xbnp0Wms0ZEVuU3hua1RM?=
 =?gb2312?B?cFBRTm9oMmN4ZXNNUWNRZ09GR1FJRU1naE1CTWxOelRTd3JGQlo5Rmg2ZEkw?=
 =?gb2312?B?VVFkTFZUVWFBZndGMFN2Mngzczh2Q3NsbFh0SzQvNjY5WGtSZXo4MXRhTGs1?=
 =?gb2312?B?M2ZDYUxuVjNGOEdWZTF5aTIyNWhhOUhOcDVMWjFHTnFtVmQ3V2N5ekw4UklG?=
 =?gb2312?B?dm5QTVdkZmZQc1dWWkR2aVhkbWYvU2wzSHhaSnBmOWdhUFVBdnpFcGFKbUht?=
 =?gb2312?B?MlExS0lQamFoTUt3OUxER0xzR0pYSkFLbHVyMVdGSGZNNkdUbjB3MWYvNXVN?=
 =?gb2312?B?N2JnZjNBMDVIUDIyTUs5bW5FdHU2QWdoM2F2TTdpL2Yza0V6TjE3cnBnV0NE?=
 =?gb2312?B?OVYyQlZOV1BpVVdxZEYyTXM4NFE1ckRxWUNYUGQzL21CZDhqNFlFQXo5RWN4?=
 =?gb2312?B?SnhzRmNJZ2ZFVkFGcEUyVlBxZzltcGFMc1NvK3kwSDViT3BFZUdTaEo1MlZB?=
 =?gb2312?B?aHozZHgyRUh3NmR5Zk9GSUljZ3dPS29mTjQ1dFJiVVBnVnlxaFN0LzRHakEw?=
 =?gb2312?B?WmhzUHZLdDcxNDZJZENuYTl3VlJJTWtRSld2YnFXenhGTFNGREFSQ3hOQVFI?=
 =?gb2312?B?aGtReEtndHNtZFM5Wk45UG1mR1hoMk1pNHh3Ymk2KzBmcEVvRWVMT0ozdHVp?=
 =?gb2312?B?NFpucmp2eWtXWThZQVU3OU1uZHkrdkdpZTZ3dC9tVVJDaURQeFgxNEo5UG5J?=
 =?gb2312?B?VVVwajVGcW01V2Y5YnNSSjlRL2U3Q05GVEd2S2tOd25WdlVRMEhpdWJwSE1H?=
 =?gb2312?B?bjdZeFdUZ2FuREhnVzdhbkorM3BiRjVtNzBXSTJKV1JzSk54SGRFUW80dGc3?=
 =?gb2312?B?SzhISmpYSUd3UzY4TGlRcndXekgzZ09HMy9JTXZjYVVLM0VaVkwxajlVNjlu?=
 =?gb2312?B?b3ZhOVdLQXFQeUhlVFJRT0REV2M0dmpVYVE4WmJTcFluemZjZVNnTFhtSEd6?=
 =?gb2312?B?eGtLaVh0SUxwU0ZFN1UySTVUcjdURU8zQjR2ZXZNY0lDZDVybHVKdzBXSVM1?=
 =?gb2312?Q?TrouQnh1J0BLvmpkpJGCaBoATdyZnQ=3D?=
Content-Type: text/plain; charset="gb2312"
Content-ID: <9DF352AA68D39046B2524D095853F1DF@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB4427.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87650cd7-3815-484d-5f1e-08da0be84276
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2022 09:42:20.0937
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +7Lkjyn1vGPK/Y6D2Y/sQKQqoHeX6S3oBYxuTLs81qkf81cM3NuTc9WIzXVE7y9/HBXHBqnTsLRSfaZ8orBqGXUE3/RGx93IwUIPwQbb5ec=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB5347
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

b24gMjAyMi8zLzIyIDE2OjQzLCBEYXZlIENoaW5uZXIgd3JvdGU6DQo+IE9uIFR1ZSwgTWFyIDIy
LCAyMDIyIGF0IDA0OjA0OjE3UE0gKzA4MDAsIFlhbmcgWHUgd3JvdGU6DQo+PiBQZXRyIHJlcG9y
dGVkIGEgcHJvYmxlbSB0aGF0IFNfSVNHSUQgYml0IHdhcyBub3QgY2xlYW4gd2hlbiB0ZXN0aW5n
IGx0cA0KPj4gY2FzZSBjcmVhdGUwOVsxXSBieSB1c2luZyB1bWFzaygwNzcpLg0KPg0KPiBPay4g
U28gd2hhdCBpcyB0aGUgZmFpbHVyZSBtZXNzYWdlIGZyb20gdGhlIHRlc3Q/DQo+DQo+IFdoZW4g
ZGlkIHRoZSB0ZXN0IHN0YXJ0IGZhaWxpbmc/IElzIHRoaXMgYSByZWNlbnQgZmFpbHVyZSBvcg0K
PiBzb21ldGhpbmcgdGhhdCBoYXMgYmVlbiBhcm91bmQgZm9yIHllYXJzPyBJZiBpdCdzIHJlY2Vu
dCwgd2hhdA0KPiBjb21taXQgYnJva2UgaXQ/DQpZb3UgaGF2ZSBrbm93biB0aGlzLg0KPg0KPj4g
SXQgZmFpbHMgYmVjYXVzZSB4ZnMgd2lsbCBjYWxsIHBvc2l4X2FjbF9jcmVhdGUgYmVmb3JlIHhm
c19pbml0X25ld19ub2RlDQo+PiBjYWxscyBpbm9kZV9pbml0X293bmVyLCBzbyBTX0lYR1JQIG1v
ZGUgd2lsbCBiZSBjbGVhciB3aGVuIGVuYWJsZSBDT05GSUdfWEZTX1BPU0lYQUNMDQo+PiBhbmQg
ZG9lc24ndCBzZXQgYWNsIG9yIGRlZmF1bHQgYWNsIG9uIGRpciwgdGhlbiBpbm9kZV9pbml0X293
bmVyIHdpbGwgbm90IGNsZWFyDQo+PiBTX0lTR0lEIGJpdC4NCj4NCj4gSSBkb24ndCByZWFsbHkg
Zm9sbG93IHdoYXQgeW91IGFyZSBzYXlpbmcgaXMgdGhlIHByb2JsZW0gaGVyZSAtIHRoZQ0KPiBy
dWxlIHdlIGFyZSBzdXBwb3NlZCB0byBiZSBmb2xsb3dpbmcgaXMgbm90IGNsZWFyIHRvIG1lLCBu
b3IgaG93IFhGUw0KPiBpcyBiZWhhdmluZyBjb250cmFyeSB0byB0aGUgcnVsZS4gQ2FuIHlvdSBl
eHBsYWluIHRoZSBydWxlIChlLmcuDQo+IGZyb20gdGhlIHRlc3QgZmFpbHVyZSByZXN1bHRzKSBy
YXRoZXIgdGhhbiB0cnkgdG8gZXhwbGFpbiB3aGVyZSB0aGUNCj4gY29kZSBnb2VzIHdyb25nLCBw
bGVhc2U/DQo+DQo+PiBUaGUgY2FsbHRyYWNlIGFzIGJlbG93Og0KPj4NCj4+IHVzZSBpbm9kZV9p
bml0X293bmVyKG1udF91c2VybnMsIGlub2RlKQ0KPj4gWyAgMjk2Ljc2MDY3NV0gIHhmc19pbml0
X25ld19pbm9kZSsweDEwZS8weDZjMA0KPj4gWyAgMjk2Ljc2MDY3OF0gIHhmc19jcmVhdGUrMHg0
MDEvMHg2MTANCj4+IHVzZSBwb3NpeF9hY2xfY3JlYXRlKGRpciwmbW9kZSwmZGVmYXVsdF9hY2ws
JmFjbCk7DQo+PiBbICAyOTYuNzYwNjgxXSAgeGZzX2dlbmVyaWNfY3JlYXRlKzB4MTIzLzB4MmUw
DQo+PiBbICAyOTYuNzYwNjg0XSAgPyBfcmF3X3NwaW5fdW5sb2NrKzB4MTYvMHgzMA0KPj4gWyAg
Mjk2Ljc2MDY4N10gIHBhdGhfb3BlbmF0KzB4ZmI4LzB4MTIxMA0KPj4gWyAgMjk2Ljc2MDY4OV0g
IGRvX2ZpbHBfb3BlbisweGI0LzB4MTIwDQo+PiBbICAyOTYuNzYwNjkxXSAgPyBmaWxlX3R0eV93
cml0ZS5pc3JhLjMxKzB4MjAzLzB4MzQwDQo+PiBbICAyOTYuNzYwNjk3XSAgPyBfX2NoZWNrX29i
amVjdF9zaXplKzB4MTUwLzB4MTcwDQo+PiBbICAyOTYuNzYwNjk5XSAgZG9fc3lzX29wZW5hdDIr
MHgyNDIvMHgzMTANCj4+IFsgIDI5Ni43NjA3MDJdICBkb19zeXNfb3BlbisweDRiLzB4ODANCj4+
IFsgIDI5Ni43NjA3MDRdICBkb19zeXNjYWxsXzY0KzB4M2EvMHg4MA0KPj4NCj4+IEZpeCB0aGlz
IGlzIHNpbXBsZSwgd2UgY2FuIGNhbGwgcG9zaXhfYWNsX2NyZWF0ZSBhZnRlciB4ZnNfaW5pdF9u
ZXdfaW5vZGUgY29tcGxldGVkLA0KPj4gc28gaW5vZGVfaW5pdF9vd25lciBjYW4gY2xlYXIgU19J
U0dJRCBiaXQgY29ycmVjdGx5IGxpa2UgZXh0NCBvciBidHJmcyBkb2VzLg0KPj4NCj4+IEJ1dCBj
b21taXQgZTZhNjg4YzMzMjM4ICgieGZzOiBpbml0aWFsaXNlIGF0dHIgZm9yayBvbiBpbm9kZSBj
cmVhdGUiKSBoYXMgY3JlYXRlZA0KPj4gYXR0ciBmb3JrIGluIGFkdmFuY2UgYWNjb3JkaW5nIHRv
IGFjbCwgc28gYSBiZXR0ZXIgc29sdXRpb24gaXMgdGhhdCBtb3ZpbmcgdGhlc2UNCj4+IGZ1bmN0
aW9ucyBpbnRvIHhmc19pbml0X25ld19pbm9kZS4NCj4NCj4gTm8sIHlvdSBjYW4ndCBkbyB0aGF0
LiBYYXR0cnMgY2Fubm90IGJlIGNyZWF0ZWQgd2l0aGluIHRoZQ0KPiB0cmFuc2FjdGlvbiBjb250
ZXh0IG9mIHRoZSBjcmVhdGUgb3BlcmF0aW9uIGJlY2F1c2UgdGhleSByZXF1aXJlDQo+IHRoZWly
IG93biB0cmFuc2FjdGlvbiBjb250ZXh0IHRvIHJ1biB1bmRlci4gV2UgY2Fubm90IG5lc3QNCj4g
dHJhbnNhY3Rpb24gY29udGV4dHMgaW4gWEZTLCBzbyB0aGUgQUNMIGFuZCBvdGhlciBzZWN1cml0
eSB4YXR0cnMNCj4gbXVzdCBiZSBjcmVhdGVkIGFmdGVyIHRoZSBpbm9kZSBjcmVhdGUgaGFzIGNv
bXBsZXRlZC4NCj4NCj4gQ29tbWl0IGU2YTY4OGMzMzIzOCBvbmx5IGluaXRpYWxpc2VzIHRoZSBp
bm9kZSBhdHRyaWJ1dGUgZm9yayBpbiB0aGUNCj4gY3JlYXRlIHRyYW5zYWN0aW9uIHJhdGhlciB0
aGFuIHJlcXVpcmluZyBhIHNlcGFyYXRlIHRyYW5zYWN0aW9uIHRvDQo+IGRvIGl0IGJlZm9yZSB0
aGUgeGF0dHJzIGFyZSB0aGVuIGNyZWF0ZWQuIEl0IGRvZXMgbm90IGFsbG93IHhhdHRycw0KPiB0
byBiZSBjcmVhdGVkIGZyb20gd2l0aGluIHRoZSBjcmVhdGUgdHJhbnNhY3Rpb24gY29udGV4dC4N
ClRoYW5rcyBmb3IgeW91ciByZXBseSwgbm93LCBJIGtub3cgdGhpcy4NCg0KQmVzdCBSZWdhcmRz
DQpZYW5nIFh1DQo+DQo+IEhlbmNlIHJlZ2FyZGxlc3Mgb2Ygd2hlcmUgdGhlIHByb2JsZW0gbGll
cywgYSBkaWZmZXJlbnQgZml4IHdpbGwgYmUNCj4gcmVxdWlyZWQgdG8gYWRkcmVzcyBpdC4NCj4N
Cj4gQ2hlZXJzLA0KPg0KPiBEYXZlLg0K
