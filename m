Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8D3CC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Mar 2022 06:30:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237004AbiCVGb1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Mar 2022 02:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237027AbiCVGb0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Mar 2022 02:31:26 -0400
X-Greylist: delayed 65 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 21 Mar 2022 23:29:58 PDT
Received: from esa16.fujitsucc.c3s2.iphmx.com (esa16.fujitsucc.c3s2.iphmx.com [216.71.158.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353E0D52
        for <linux-xfs@vger.kernel.org>; Mon, 21 Mar 2022 23:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1647930599; x=1679466599;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=PvRsyrkrdlsYemtxK4ArcAAEN1WiVATJdcveuh11R6E=;
  b=iLkMu70mVHYwn69NuxuEp1QhdfMKIy2a5oBUJhn9hroQWjnrMIm3PYN5
   pon+MocTej/WmhZMLCm2pbuVP28SGLv1j6sV7Trx4h1FntlJovE8eCY24
   nxDuAu6qPTuZWcAWo3awmru4MtQZwkx9EAS/KN+MDW6/q7gWXFp8C+wC2
   dlXft8tNErxE8rKTUxrga1neS8WeGg/eRxfBOOYwhWJgyL6lUJqvQMs6W
   Vg0RqR5hnqxEPYheGXL8APesGqlK1d9o2og4gyEkiAG3KGofvFbPoC7CJ
   r5s4eEIq37ylBLE2hw7AC5z9/Qgm9tm+PYecMk1EtENpXaqE2b4tfuOu9
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10293"; a="52167769"
X-IronPort-AV: E=Sophos;i="5.90,200,1643641200"; 
   d="scan'208";a="52167769"
Received: from mail-os0jpn01lp2105.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.105])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2022 15:28:49 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fMBYAX5h12d47NIA7uakhWyhqDqkIU4+87qvHyissDk+OyKWe/EVBtG2t6M6Z41h2TNvGLLeg8PWmDdZphtbcdL0fYa/RxOSRwVHgxYR2HJex/1epiWCOjr+mWUcb3pumx3hPB3F6soiuKIU2bnAgkl6W5PZqO1xq9MBopHEInE1OYiiDT2NLuqD0Md40bB1IiQgEaDD5sLQnyR180/RcSD1KzxY/KUrPwEWcshelZNEi3EAN8HrFTmyF3fOJYdMM/6Fnad2Zu3d8YWVgJ9lo4RYvtuC+Hv9bv0440t5q6AQcTvcgQS1+r3AzEbfYXaAqDWhJChOFBfKx4aB9HXutA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PvRsyrkrdlsYemtxK4ArcAAEN1WiVATJdcveuh11R6E=;
 b=MrPJkYiXLs8NG3L8pz93y6z+sQUqQgzZLVafpJKl2sQSjGna2Eranv5InJBkAEHpvvgpWelpLGOtkjvGSRWTHp0RiycxqH+700d4zwd/0lBl2oTxqRk0lg8HcpSgCvc/i6AVPbIxkLOL2RClGz7AFPjSan/gNamSGnuFbQnzrppSJMQj6vgrLaPaTruEI/SXAtmyxGby6Or6E85OQ6fBTDPToKLoca12K4z7FvsFa6INTUdYJhuogQ9DldwJZIFv1XDZaZ9Qp778FM+vAqPLvLdyK3R1UFt1nj6zkUIvHY5QpLWdVlJRL2dl24n1RoynV1Liujyw0TGfBz9UuAeF2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PvRsyrkrdlsYemtxK4ArcAAEN1WiVATJdcveuh11R6E=;
 b=AHmD88OyXOuqALQaOmztS4rNHajxxaSUPvpTlCwkhPW5PLWDTd8Hf+O5N4DDUOGsalZd0bfZvm3scEQWVbmipO9lIhZmUOrlaNHWdKhzXYIRGl0U/DIsZFDciZqh8yR/gGnc8MMG9erzVBdkLrcIVzNrDEx8d5+UOQkAdGIxix4=
Received: from TY2PR01MB4427.jpnprd01.prod.outlook.com (2603:1096:404:10d::20)
 by TY2PR01MB2315.jpnprd01.prod.outlook.com (2603:1096:404:c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.18; Tue, 22 Mar
 2022 06:28:45 +0000
Received: from TY2PR01MB4427.jpnprd01.prod.outlook.com
 ([fe80::dd2e:e671:b3d5:d354]) by TY2PR01MB4427.jpnprd01.prod.outlook.com
 ([fe80::dd2e:e671:b3d5:d354%6]) with mapi id 15.20.5081.023; Tue, 22 Mar 2022
 06:28:45 +0000
From:   "xuyang2018.jy@fujitsu.com" <xuyang2018.jy@fujitsu.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     "ltp@lists.linux.it" <ltp@lists.linux.it>, Jan Kara <jack@suse.cz>,
        Petr Vorel <pvorel@suse.cz>,
        Martin Doucha <martin.doucha@suse.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [LTP] [RFC PATCH 1/1] creat09: Fix on more restrictive umask
Thread-Topic: [LTP] [RFC PATCH 1/1] creat09: Fix on more restrictive umask
Thread-Index: AQHYN9eJWCFPwI5fE0G2efRMRz6TPazEzJUAgAAsKICAAMI5AIAFQcSA
Date:   Tue, 22 Mar 2022 06:28:45 +0000
Message-ID: <62396CD3.708@fujitsu.com>
References: <20220314191234.12382-1-pvorel@suse.cz>
 <62343BF2.1020006@fujitsu.com> <623460FD.8070500@fujitsu.com>
 <20220318221258.GK8241@magnolia>
In-Reply-To: <20220318221258.GK8241@magnolia>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 29e04076-deda-4ee9-c46e-08da0bcd37af
x-ms-traffictypediagnostic: TY2PR01MB2315:EE_
x-microsoft-antispam-prvs: <TY2PR01MB2315FA890EBF33EA6782BFB9FD179@TY2PR01MB2315.jpnprd01.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z1aAU10enfrO8thFGHhwKbYG6NgTptjHO6jgSKgyMSqMOW0PQ6V0l5Gmy5zFDrQghZer0hnUnYSu/7PZKsAEo2CLpX+cUH/LUvTUy44ESCw2fWGVNFivLhOojjRKkNk91/e1KelF4kjyAplZhOYnCQCA6rKyfmu09DN9UjkWOHXW5K3naU3w0Kv+gnax4pq8TVkVu6d5aUQzwAHCZS74rTQvZ0vhPgLUa2/wtYEKi8P108thJ32vpI/0s/MpKqp5FHVvLWJZzcxIv35Fq5o1lOZ9dYmNkVw2utPqV8980WkFY9cyaEg76PLNMj+EFaXsA7jmyO4TKKAvB8caNGUlXr0+3WRHBAnTOW9OIJitdd/2YCKEOi23VKGER4P/1wdPnsM9otOa+wFXE+FwwjZ33nP/+gGUfEiI//O3KvmQhswNuWzOZ0T+PxHtz40NlFohwAPJQ/A5Ly6AP+Qm6YMcKcQFbF+SlW3rTCHGd2hjg5pJXOnt4TCFLWFbhI9q2afr0Ppf4dVQOVnZJbBPuAPtuTy9eGtIiKCDKPlUFcyJUPbbIy+DMgL1rh+Z+p3VQgtzXLfE2U4+M7RF5wEyTN91UuO611km9DRe9TEecYEVqa41aHtBQnXBHEQtc1wh38URFLCGpQH9vEjjiy0Hrp5xpyWIoeL9o9xuHDPaPuWVq5HWTyyqUbYDunbLKmXENRSaI8SwPyvVNX8iD6e8pHpe6LNerWWWSEYe/MO7+q/fHiNh/8esI/cLx3rkkgVLNAi39xb9NOFAJuslH/+SWfceOEAF0SPY0V3bNYn7zv+CT7U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB4427.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(66476007)(4326008)(76116006)(8676002)(508600001)(66946007)(71200400001)(86362001)(91956017)(316002)(66556008)(8936002)(38070700005)(64756008)(2906002)(38100700002)(33656002)(66446008)(5660300002)(122000001)(82960400001)(6916009)(6512007)(966005)(54906003)(6486002)(2616005)(85182001)(186003)(26005)(36756003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?Tkl2dkxpQWJNQWFXUnl5N2NYOUsvQWEvbVJxdkhvanluL0h4cnpWOXFnQ3Zt?=
 =?gb2312?B?WHJvdXh1UGw5UzhzMTkxOG53bkZQWjI3OWdPai9jVGdpbmRwSllsdUVwbWpk?=
 =?gb2312?B?Q0Y3ZXhDUEpReDVzTDNBMk9YVWJUaVdkQUViRko3eDBSUWNQeUpuUVhuU0Ju?=
 =?gb2312?B?ajV5SGtnaUlPSVhqeVNRRGowNDUxRWx2VmhoaGJnQ0FMZUMxbGd1NmFVNUFC?=
 =?gb2312?B?aURJeEJ1V0U1OWxjMTBveENpKzFOSWZrK1pJRmRrWnRsR2lJbEo1eXgzTExS?=
 =?gb2312?B?cUt3NGxJYnM2a3ZaVE1Dbi9UY1FSbDBsVldUZzEyRFVxTWN5Y0FmMkpxemZE?=
 =?gb2312?B?MnMzZS80MmdvYU1aQzhiYlZHS01jSHN2aWtXRVJEYk9aZVRGY0hTTW9vSEcx?=
 =?gb2312?B?a2hKNzREdzlNNjBhV2x1a2YyRTBLR1JoM2VVOHA3Q0pXM3pHZkhHcytSckov?=
 =?gb2312?B?ZWlQR21nbCtvRmdhNVBncmtPYThUbXUxWXJyVHBkQjl1QjJab2V6QytSejZI?=
 =?gb2312?B?TTV1blgzQTVncHZOQWtEeWluRDhFeWVXbGpCTXpoekFhUlh3ZXZvdDdJRlNC?=
 =?gb2312?B?VVRWcTRXWGZSMkxCZkpxaG5FaWlNdHpYT0dpTDYweXNBNnNmRkZ1K1VRTy9R?=
 =?gb2312?B?MkIzVXF5cks4eDhzOE12bVVJQ0dSL3FvR2lreiszNml3aUtienZLb0FFNmIw?=
 =?gb2312?B?VlpDeHVFTDQ2ZUdocW55ZGFzVjNQR3pkRjg1eWFEVllmdXIrc1diUEkyNU1a?=
 =?gb2312?B?TXZYTUhXRkVnUUNFVGZhemlBaXVTdmxHUlZaVUhJVWk0Z1pmajJ2MWNQamFJ?=
 =?gb2312?B?WkpOV0ZqcEFMems3ZEFLbkJYdDJCdGdsOGNCYStKQjZadzNNQ1dTcXhlMDhH?=
 =?gb2312?B?NUo3Z2FMdzl6Uk8vcElRTlA0UHpTL1lJQlkwVDhPYVV0TC9keDkwNEJIZHg2?=
 =?gb2312?B?WlNINVBaeWJpNzZOemwzUVZ2WWFPdXg3THNjaEFNdlE4Mml6L1hzYVR0RUxY?=
 =?gb2312?B?R0QvSWdKWTYvQkVYU2ZuS0pmU0JNZTg4b2w2d3NBWUhkTy82T0hlYWJldDNM?=
 =?gb2312?B?a3hnN3dRRzJKVW54S0NvQkdZUEEwb3QweEVSY21qZkFkY2hESDBvS2dwQWxa?=
 =?gb2312?B?WHI5dXNNV2pUbFU0TGJSSzJCMk1sVytzT21qMis4dTdMY2k2V1NjeVdybHE4?=
 =?gb2312?B?UG5BRDhQN01QQld1NUxGQUQrVXRsam01VDZMcjRoQjRid05LblhMS1pIaVUz?=
 =?gb2312?B?RzhmcWRLdXpYRzdTMnB3WUR0NGFiR3B6dWx6WXltVXdWSXFINlY1cVFhVzJC?=
 =?gb2312?B?aHNaZmdxTGtiTDFteHFUcm1MOC95a3Mwd29DZjlVbXFhVTVZUXRNWTNCTlNF?=
 =?gb2312?B?a2s1a3hXME9rSmIrUXBITXFlNVpHT0k4cllqWVNkZk5Wc0tkMS9WQ0UyU3FJ?=
 =?gb2312?B?QlB2NDBzTWNKQ2xDRG5xTU5zNG9ncTgwd1A5ZDU4cHhobzA4dk1ub3F0ZFZq?=
 =?gb2312?B?VEFxeE5EcjY3bjdFTkt6OHdyWktRQzBYUXAwVUZRSVFnQ2pPUWREUFlZRGRs?=
 =?gb2312?B?cS9nNlJDNGJXVUZZQldLbW5Uc1NxQ3BTRWVaL2tmeTZiZE1NTEE3SHpzZVdk?=
 =?gb2312?B?bVFiUmR5YXh0dmtDenhaNHYwYmNVSWRQcGIxMEN1T3NtSmxSNWlWN2FZK3Vx?=
 =?gb2312?B?dkFXRnRXV0xSbTlwYk5YTFlTWUVWdGdpejM5bVNSd0EvV0VrZCsxejl0YW9X?=
 =?gb2312?B?ZDI0bVRDTmRJZEt0cW5iNndkSWhxdDBJc0R1Vlh3SUdFeGN4Y0h0blFHVkQ5?=
 =?gb2312?B?NENPMU9hdzQvWkN5SEx2cWNONERxbzZaQnJxSGxlRWxjOG5PbGowY08vSFl0?=
 =?gb2312?B?bnRJYXllUVRjMGg2UzQydjZZV0FGVUVaVjZNeFB1ak5EWks0bDZMVnJQSzZN?=
 =?gb2312?B?M3Y5bnFyVFowUVhjM09NU1hTYXp6US93b1dYNGM0ZFE3a05RSmIvY1RvRVYv?=
 =?gb2312?Q?mnu7jaE1zZo4fzE4vnmdlLCgtiREGE=3D?=
Content-Type: text/plain; charset="gb2312"
Content-ID: <C5F5509EA344574991AB31DEDE94ED83@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB4427.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29e04076-deda-4ee9-c46e-08da0bcd37af
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2022 06:28:45.6344
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: udydmWFYUASJhOXHfJqjWO616iEyJSrtAh4ZdzrXmtQ/JUNDwB9oxVm5MaseqrNPxcagCWniwc4RkNA69pqXajo5NM12XErWN2YLTywPefA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR01MB2315
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

b24gMjAyMi8zLzE5IDY6MTIsIERhcnJpY2sgSi4gV29uZyB3cm90ZToNCj4gWW91IHJlYWxseSBv
dWdodCB0byBjYyB0aGUgeGZzIGxpc3QgZm9yIHF1ZXN0aW9ucyBhYm91dCBsb25nc3RhbmRpbmcN
Cj4gYmVoYXZpb3JzIG9mIFhGUy4uLg0KPg0KPiBbY2MgbGludXgteGZzXQ0KT2gsIHllcywgc29y
cnkgZm9yIHRoaXMuIEkgaGF2ZSBzZW50IGEgUkZDIHBhdGNoIHRvIGxpbnV4LXhmcyBhbmQgd2Ug
Y2FuIA0KbW92ZSBkaXNjdXNzaW9uIG9uIHRoYXQgbWFpbC4NCg0KQmVzdCBSZWdhcmRzDQpZYW5n
IFh1DQo+DQo+IC0tRA0KPg0KPiBPbiBGcmksIE1hciAxOCwgMjAyMiBhdCAxMDozNzowM0FNICsw
MDAwLCB4dXlhbmcyMDE4Lmp5QGZ1aml0c3UuY29tIHdyb3RlOg0KPj4gSGkgRGFycmljaywgSmFj
aw0KPj4NCj4+IFBldHIgbWVldCBhIHByb2JsZW0gd2hlbiBydW5uaW5nIGNyZWF0MDkgb24geGZz
LCBleHQ0IGRvZXNuJ3QgaGF2ZSBwcm9ibGVtLg0KPj4NCj4+IEl0IHNlZW1zIHhmcyB3aWxsIHN0
aWxsIHVzZSB1bWFzayB3aGVuIGVuYWJsZSBkZWZhdWx0IGFjbCwgYnV0IGV4dDQgd2lsbA0KPj4g
bm90Lg0KPj4NCj4+IEFzIHVtYXNrMiBtYW5wYWdlICwgaXQgc2FpZA0KPj4gIkFsdGVybmF0aXZl
bHksIGlmIHRoZSBwYXJlbnQgZGlyZWN0b3J5IGhhcyBhIGRlZmF1bHQgQUNMIChzZWUgYWNsKDUp
KSwNCj4+IHRoZSB1bWFzayBpcyBpZ25vcmVkLCB0aGUgZGVmYXVsdCBBQ0wgaXMgaW5oZXJpdGVk
LCB0aGUgcGVybWlzc2lvbiBiaXRzDQo+PiBhcmUgc2V0IGJhc2VkIG9uIHRoZSBpbmhlcml0ZWQg
QUNMLCBhbmQgcGVybWlzc2lvbiBiaXRzIGFic2VudA0KPj4gICAgICAgICAgaW4gdGhlIG1vZGUg
YXJndW1lbnQgYXJlIHR1cm5lZCBvZmYuDQo+PiAiDQo+Pg0KPj4gSXQgc2VlbSB4ZnMgZG9lc24n
dCBvYmV5IHRoaXMgcnVsZS4NCj4+DQo+PiB0aGUgeGZzIGNhbGx0cmFjZSBhcyBiZWxvdzoNCj4+
DQo+PiAgICAgd2lsbCB1c2UgIGlub2RlX2luaXRfb3duZXIoc3RydWN0IHVzZXJfbmFtZXNwYWNl
ICptbnRfdXNlcm5zLA0KPj4gc3RydWN0aW5vZGUgKmlub2RlKQ0KPj4NCj4+ICAgIDI5Ni43NjA2
NzVdICB4ZnNfaW5pdF9uZXdfaW5vZGUrMHgxMGUvMHg2YzANCj4+IFsgIDI5Ni43NjA2NzhdICB4
ZnNfY3JlYXRlKzB4NDAxLzB4NjEwDQo+PiAgICAgd2lsbCB1c2UgcG9zaXhfYWNsX2NyZWF0ZShk
aXIsJm1vZGUsJmRlZmF1bHRfYWNsLCZhY2wpOw0KPj4gWyAgMjk2Ljc2MDY4MV0gIHhmc19nZW5l
cmljX2NyZWF0ZSsweDEyMy8weDJlMA0KPj4gWyAgMjk2Ljc2MDY4NF0gID8gX3Jhd19zcGluX3Vu
bG9jaysweDE2LzB4MzANCj4+IFsgIDI5Ni43NjA2ODddICBwYXRoX29wZW5hdCsweGZiOC8weDEy
MTANCj4+IFsgIDI5Ni43NjA2ODldICBkb19maWxwX29wZW4rMHhiNC8weDEyMA0KPj4gWyAgMjk2
Ljc2MDY5MV0gID8gZmlsZV90dHlfd3JpdGUuaXNyYS4zMSsweDIwMy8weDM0MA0KPj4gWyAgMjk2
Ljc2MDY5N10gID8gX19jaGVja19vYmplY3Rfc2l6ZSsweDE1MC8weDE3MA0KPj4gWyAgMjk2Ljc2
MDY5OV0gIGRvX3N5c19vcGVuYXQyKzB4MjQyLzB4MzEwDQo+PiBbICAyOTYuNzYwNzAyXSAgZG9f
c3lzX29wZW4rMHg0Yi8weDgwDQo+PiBbICAyOTYuNzYwNzA0XSAgZG9fc3lzY2FsbF82NCsweDNh
LzB4ODANCj4+DQo+Pg0KPj4gdGhlIGV4dDQgY2FsbHRyYWNlIGFzIGJlbG93Og0KPj4gWyAgMjk2
LjQ2MDk5OV0gIF9fZXh0NF9uZXdfaW5vZGUrMHhlMDcvMHgxNzgwIFtleHQ0XQ0KPj4gcG9zaXhf
YWNsX2NyZWF0ZShkaXIsJmlub2RlLT5pX21vZGUsJmRlZmF1bHRfYWNsLCZhY2wpOw0KPj4gWyAg
Mjk2LjQ2MTAzNV0gIGV4dDRfY3JlYXRlKzB4MTA2LzB4MWMwIFtleHQ0XQ0KPj4gWyAgMjk2LjQ2
MTA1OV0gIHBhdGhfb3BlbmF0KzB4ZmI4LzB4MTIxMA0KPj4gWyAgMjk2LjQ2MTA2Ml0gIGRvX2Zp
bHBfb3BlbisweGI0LzB4MTIwDQo+PiBbICAyOTYuNDYxMDY1XSAgPyBfX2NoZWNrX29iamVjdF9z
aXplKzB4MTUwLzB4MTcwDQo+PiBbICAyOTYuNDYxMDY4XSAgZG9fc3lzX29wZW5hdDIrMHgyNDIv
MHgzMTANCj4+IFsgIDI5Ni40NjEwNzBdICBkb19zeXNfb3BlbisweDRiLzB4ODANCj4+IFsgIDI5
Ni40NjEwNzNdICBkb19zeXNjYWxsXzY0KzB4M2EvMHg4MA0KPj4gWyAgMjk2LjQ2MTA3N10gIGVu
dHJ5X1NZU0NBTExfNjRfYWZ0ZXJfaHdmcmFtZSsweDQ0LzB4YWUNCj4+DQo+PiBJIGd1ZXNzIHhm
cyBtb2RpZnkgaXRzIG1vZGUgdmFsdWUgaW5zdGVhZCBvZiBpbm9kZS0+aV9tb2RlIGluDQo+PiBw
b3NpeF9hY2xfY3JlYXRlIGJ5IHVzaW5nIGN1cnJlbnQtPnVtYXNrIHZhbHVlLCBzbyBpbm9kZV9p
bml0X293bmVyDQo+PiBkb2Vzbid0IGNsZWFyIG5vLXNnaWQgYml0cyBvbiBjcmVhdGVkIGZpbGUg
YmVjYXVzZSBvZiBtaXNzaW5nIFNfSVhHUlAuDQo+Pg0KPj4gSXMgaXQgYSBrZXJuZWwgYnVnPw0K
Pj4NCj4+IEJlc3QgUmVnYXJkcw0KPj4gWWFuZyBYdQ0KPj4NCj4+PiBIaSBQZXRyDQo+Pj4NCj4+
PiBJdCBmYWlscyBiZWNhdXNlIHRoZSBjcmVhdGUgZmlsZSB3aXRob3V0IFNfSVhHUlAgbW9kZSwg
dGhlbiB3ZSBtaXNzDQo+Pj4gcmVtb3ZlIFNfSVNHSURbMV0gYml0Lg0KPj4+DQo+Pj4gQnV0IEkg
ZG9uJ3Qga25vd24gd2h5IG90aGVyIGZpbGVzeXN0ZW0gZG9lc24ndCBoYXZlIHRoaXMgcHJvYmxl
bS4NCj4+Pg0KPj4+IFsxXQ0KPj4+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51
eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LmdpdC90cmVlL2ZzL2lub2RlLmMjbjIyNDkNCj4+
Pg0KPj4+IEJlc3QgUmVnYXJkcw0KPj4+IFlhbmcgWHUNCj4+Pj4gWEZTIGZhaWxzIG9uIHVtYXNr
IDAwNzc6DQo+Pj4+DQo+Pj4+IHRzdF90ZXN0LmM6MTUyODogVElORk86IFRlc3Rpbmcgb24geGZz
DQo+Pj4+IHRzdF90ZXN0LmM6OTk3OiBUSU5GTzogRm9ybWF0dGluZyAvZGV2L2xvb3AwIHdpdGgg
eGZzIG9wdHM9JycgZXh0cmEgb3B0cz0nJw0KPj4+PiB0c3RfdGVzdC5jOjE0NTg6IFRJTkZPOiBU
aW1lb3V0IHBlciBydW4gaXMgMGggMDVtIDAwcw0KPj4+PiBjcmVhdDA5LmM6NjE6IFRJTkZPOiBV
c2VyIG5vYm9keTogdWlkID0gNjU1MzQsIGdpZCA9IDY1NTM0DQo+Pj4+IGNyZWF0MDkuYzo2Mjog
VElORk86IEZvdW5kIHVudXNlZCBHSUQgMzogU1VDQ0VTUyAoMCkNCj4+Pj4gY3JlYXQwOS5jOjkz
OiBUUEFTUzogbW50cG9pbnQvdGVzdGRpci9jcmVhdC50bXA6IE93bmVkIGJ5IGNvcnJlY3QgZ3Jv
dXANCj4+Pj4gY3JlYXQwOS5jOjk3OiBURkFJTDogbW50cG9pbnQvdGVzdGRpci9jcmVhdC50bXA6
IFNldGdpZCBiaXQgaXMgc2V0DQo+Pj4+IGNyZWF0MDkuYzo5MzogVFBBU1M6IG1udHBvaW50L3Rl
c3RkaXIvb3Blbi50bXA6IE93bmVkIGJ5IGNvcnJlY3QgZ3JvdXANCj4+Pj4gY3JlYXQwOS5jOjk3
OiBURkFJTDogbW50cG9pbnQvdGVzdGRpci9vcGVuLnRtcDogU2V0Z2lkIGJpdCBpcyBzZXQNCj4+
Pj4NCj4+Pj4gVGh1cyBjbGVhciB0aGUgZGVmYXVsdCB1bWFzay4NCj4+Pj4NCj4+Pj4gU2lnbmVk
LW9mZi1ieTogUGV0ciBWb3JlbDxwdm9yZWxAc3VzZS5jej4NCj4+Pj4gLS0tDQo+Pj4+ICAgICB0
ZXN0Y2FzZXMva2VybmVsL3N5c2NhbGxzL2NyZWF0L2NyZWF0MDkuYyB8IDIgKysNCj4+Pj4gICAg
IDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykNCj4+Pj4NCj4+Pj4gZGlmZiAtLWdpdCBh
L3Rlc3RjYXNlcy9rZXJuZWwvc3lzY2FsbHMvY3JlYXQvY3JlYXQwOS5jIGIvdGVzdGNhc2VzL2tl
cm5lbC9zeXNjYWxscy9jcmVhdC9jcmVhdDA5LmMNCj4+Pj4gaW5kZXggYmVkN2JkZGIwZS4uNzBk
YTdkMmZjNyAxMDA2NDQNCj4+Pj4gLS0tIGEvdGVzdGNhc2VzL2tlcm5lbC9zeXNjYWxscy9jcmVh
dC9jcmVhdDA5LmMNCj4+Pj4gKysrIGIvdGVzdGNhc2VzL2tlcm5lbC9zeXNjYWxscy9jcmVhdC9j
cmVhdDA5LmMNCj4+Pj4gQEAgLTU2LDYgKzU2LDggQEAgc3RhdGljIHZvaWQgc2V0dXAodm9pZCkN
Cj4+Pj4gICAgIAkJKGludClsdHB1c2VyLT5wd19naWQpOw0KPj4+PiAgICAgCWZyZWVfZ2lkID0g
dHN0X2dldF9mcmVlX2dpZChsdHB1c2VyLT5wd19naWQpOw0KPj4+Pg0KPj4+PiArCXVtYXNrKDAp
Ow0KPj4+PiArDQo+Pj4+ICAgICAJLyogQ3JlYXRlIGRpcmVjdG9yaWVzIGFuZCBzZXQgcGVybWlz
c2lvbnMgKi8NCj4+Pj4gICAgIAlTQUZFX01LRElSKFdPUktESVIsIE1PREVfUldYKTsNCj4+Pj4g
ICAgIAlTQUZFX0NIT1dOKFdPUktESVIsIGx0cHVzZXItPnB3X3VpZCwgZnJlZV9naWQpOw0KPj4+
DQo=
