Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84A9AC433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Nov 2021 06:33:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66E1860FD9
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Nov 2021 06:33:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbhKAGgC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Nov 2021 02:36:02 -0400
Received: from esa5.fujitsucc.c3s2.iphmx.com ([68.232.159.76]:19921 "EHLO
        esa5.fujitsucc.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229933AbhKAGgA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Nov 2021 02:36:00 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Nov 2021 02:35:59 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1635748408; x=1667284408;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=IEg2Kv2hdmLWCn0W2tEtQ0ZQlby5ktObtmU+rkbOj3E=;
  b=FNUaoOVbIM2iVBlja7aQdH0xxcWV3O1EskG3A2tKS5XM2okDBR1/mlV+
   6aK3RU8xK33vwDgWkncJAXMoMps/xiAFMOS/u3cra9pnsyaSAGrigwM4U
   ++eAlTK2kom6CHKNDNe2vJtghqfc0nxKsHlbKjT1u9otj10hb9KcOh5gO
   NsNXpWFJ9CuUhLbuQSn1zgWDE/bqmmmCj/a24d8rkG+YClkA8/Jirau0A
   6ixF53IsHbCNK9+gXP6wAz67QOU4PxWnqrFKGa73JNLVOlVab/H68bp+0
   IOBdaMQ+s3d9dLA/5znQhyiJCoOi4nUSPUZkkUBGGpjDX6CiHSipS9AuS
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10154"; a="42662545"
X-IronPort-AV: E=Sophos;i="5.87,198,1631545200"; 
   d="scan'208";a="42662545"
Received: from mail-os2jpn01lp2059.outbound.protection.outlook.com (HELO JPN01-OS2-obe.outbound.protection.outlook.com) ([104.47.92.59])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2021 15:26:18 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WSqAne5YpxXYi+8uOQVe3hodbecI6AmcT6nSVmkzbX6Is4uSYPDI2mjjnliktqA5HSBwLPbDmcjhOFbUn2d6OEBPJycq67FdnSqHPI0smYyihaeBnm5IC5Li2JyujzCWAMvio2y27ehBtNF31+4pGRtnTsD89xMBd29iULXNl3R4Uy6qiQgN1MdHfhgO9TKVhs7aQ9IvyqIzUarcO9hmAruvN1LQv7XtgDpQSChuXgahT36ZSx+Dl/YDP9TLyzfxLOpaWhyDCdCyWQxUSHvUrCC/Kz4R/togIRhGSj0vJrrveIWLw90w8Ifg27HY7VC2y77YJOBlSrpP1y70ta1Weg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IEg2Kv2hdmLWCn0W2tEtQ0ZQlby5ktObtmU+rkbOj3E=;
 b=LL9Dj8dS0tiG4TAeq63tCLTqYwm1V15uuG7lDHWttwjeb1hp7jfBt8uBjJLTNK1WdGI/XqvrLm6escvoVIu3gf/mjxPQIiTBEnVulRQD3Gtew/n+zOawt4OMkzZiL6JyuQjQWJq5/K5bbagO1R6/8nB0CRSAs7NPOhStAK6l6tVOEj8/sXHpjI6SvBRwbpCFlP4JGvofPHujGkFmHTA5kZ73s/fiIQEEJHZMMnjLy5i8ELErUzeeAXf+g3+arram6CA9d3fWkDvIGs8xfVhRaD/0iWLA3nKakZP43b8P7A9JR5i0RubMEdIXEaR0UIUoWRuVyGY+n10qq3swKvVmMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IEg2Kv2hdmLWCn0W2tEtQ0ZQlby5ktObtmU+rkbOj3E=;
 b=ptPLlxi3SWJSVwstZD2v5tfVeXtc6YRQ7aRRBrVt8JJVKxiC3g3itXnESb2471EAXQrLsEYw3VB8Ojk2BbHbQEvwM6PFXlGLtY4B0D5DRtFHsQMVUFMMlu2S20rxUtEnpVusH+87iUtSuraRN9zofDSHylhAyqajT+mY5XVVzy8=
Received: from TYCPR01MB6544.jpnprd01.prod.outlook.com (2603:1096:400:98::6)
 by TYAPR01MB6537.jpnprd01.prod.outlook.com (2603:1096:400:95::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Mon, 1 Nov
 2021 06:26:14 +0000
Received: from TYCPR01MB6544.jpnprd01.prod.outlook.com
 ([fe80::35a5:c639:9f43:ee9]) by TYCPR01MB6544.jpnprd01.prod.outlook.com
 ([fe80::35a5:c639:9f43:ee9%7]) with mapi id 15.20.4649.019; Mon, 1 Nov 2021
 06:26:14 +0000
From:   "xuyang2018.jy@fujitsu.com" <xuyang2018.jy@fujitsu.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     Allison Henderson <allison.henderson@oracle.com>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: Fix the free logic of state in xfs_attr_node_hasname
Thread-Topic: [PATCH] xfs: Fix the free logic of state in
 xfs_attr_node_hasname
Thread-Index: AQHXzKJFYHH4n9sw50GRQnvy+lWjeqvqUmUAgAPnI4A=
Date:   Mon, 1 Nov 2021 06:26:14 +0000
Message-ID: <617F8893.8090203@fujitsu.com>
References: <1635497520-8168-1-git-send-email-xuyang2018.jy@fujitsu.com>
 <20211029185024.GF24307@magnolia>
In-Reply-To: <20211029185024.GF24307@magnolia>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7bcba3cb-fa37-4520-baee-08d99d008147
x-ms-traffictypediagnostic: TYAPR01MB6537:
x-microsoft-antispam-prvs: <TYAPR01MB65374B3638A82DAA416FC4E4FD8A9@TYAPR01MB6537.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vq6+vfw5KYPXKGlV5iWH0+q/nQgMXIE8MQ39VcDoFn6cJGmE5pGF+ZUjS/oWKYDh2JvWcTl/1DXgyXhDmEI0A8f3sofLPP4rQ0utWG81Llo9x7XVjp8Kd5DsnvO46jeFq4wo8DhrUbol73OEOJlJOvK4dJY/HspOMxKeJOIVI28HVEtMAJvZyTI8HeCSx5ZtSX28QRo4NQOdD1MwIjZC7fC2DAZ9KM5r3LR/31cvI6XaSn0OJWkqW1C5TOnTGtQHUDLQifcJS/hFU1W6w+uqgIvGVVOUb3FAs6wwrlkqUA6YmClymyDWobLq1OGc3QX0ZNbchf2EoL1orvF4A1SQAGNMo1/77uH9iTFMyIkgdTRKq8j5eiKzbqqSwgetDq3e4PbavI/HEjmXJcYgd3h0Lw2MCoCtH+qQ0KkOO1gTXox9BjctJCe0hxd91FukZeD9vg9kgy3EPM46+d1dp7iTNfzjes8wJjdMJAj1LawABmWxDVqZvEQIOYINAZj9cDuV270/brSzSrhH2HRS8r2C7LA1HG5HObEL+qsMow3ctws7s6zW+3gfntg+08EuQ8xfhbXVY1ofAQzTRK3/UrYnld3w6XGarZdpVU/elRIwrcc2S4psFnsDc/eBCzjIG/7bsc+e5vyb3pfCgrLBhX1ScpHZcnivFMzSfAIHQT1rHL5E2bDcT+hsxJvb4BrebG+mX0yAZ3IaXwr8pHozFgEEIQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB6544.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(91956017)(76116006)(38070700005)(85182001)(66446008)(64756008)(66556008)(66476007)(5660300002)(6486002)(6916009)(8676002)(82960400001)(2906002)(38100700002)(4326008)(8936002)(316002)(54906003)(66946007)(36756003)(6512007)(83380400001)(508600001)(26005)(122000001)(2616005)(186003)(71200400001)(6506007)(53546011)(86362001)(87266011)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?K09veS85YkFkLzZEOXhwUjlsbVFMKzgvYU54bS9UR0NzeEMyYlBURGhicDRD?=
 =?gb2312?B?U1Rza2laZzEvUkFEamJhOWNiNEVaSWF0WCt2M1l4bUpiNzFnYnJvQTRGUXg4?=
 =?gb2312?B?Z05MNkdyUVBEekFta3JhK2tmZXRqUzh0aktkUW1SV0V5Y2hLN1FwYWRLWG1n?=
 =?gb2312?B?RnNpOTNBdklBMkdiMnVDbWZZclRrS0tCeEp0cCtYVDR2Z3ZhOGU0NGhsT0or?=
 =?gb2312?B?L2VwMjFXN3NmRFVlQzdjVGJTaGRMSkM1MjFtQlc3YVhsZ3BCMDVvMnh5Q0du?=
 =?gb2312?B?U25wUmtPVDQxM2E4d25TM2VycXd1MnY5MUwxUW5oaGRMRXFDUTRiMThHVmVF?=
 =?gb2312?B?ZFUwNVJSLys3ZW1jalAwTWNwd1pGUzBGRFBUM0NkTWF6OG5YeitTeGRPSkZK?=
 =?gb2312?B?WHUrV0tTOFFEelB2dUFPY0pGWWExSTV3WWU2ZUlpTFJ3eUhuM3FidlA0Vkl1?=
 =?gb2312?B?eVNWSWErdFpwTEFxcWo1SXJvaWZtKzlFNFVOaWpLdHNhQXNPRTN5dkVPb09i?=
 =?gb2312?B?eEdYSTVBRmZrYkIvYS9kd2NQMGI5WlpTSmZsODk1bm5GS2dzYlFTQUVQWURQ?=
 =?gb2312?B?M3RwZjVKM2gxZXlIejdqQnBKNmFZdXAydE1mKzNsU3F4bTNxa3ZkbzFXaEgr?=
 =?gb2312?B?ZTJwZS8xaTJlWGpyVDBPa0RyMytXOWVTaXFITkZlTldEWTVYcUpHRUpTd2w2?=
 =?gb2312?B?WE41dlNqcUQyOFAvRjlKUmNMTzNnSUtpWVZjS3lYd0NtaEVZWnU0UG9tSE9Q?=
 =?gb2312?B?dFI2aU1IbWtjcW9zS25ueVZreVNQbzNyZWFlaVJyN25LbTA5R2twNkxNLzFG?=
 =?gb2312?B?UUZCaWtkSmVMT0lqWGhRNU9XeWppWDJCa2UwUkZDU0xoUC9oRjlWcVVGZlNL?=
 =?gb2312?B?cnBERlAyaWo1QVVqbm9SMlQrdFp5Y3U1dk9adzF6dFBXK3p0WEFHM0dMaENV?=
 =?gb2312?B?SjZ3bG9HZ01saHg2ODV5STdWcjFoMTZOMGlCbFgwNnRTQ1hmZHRvWnFuaU5o?=
 =?gb2312?B?Vk16blcvTk01Tktka21ZeHIrb3Z6b3orcWw1b1VIYjFPNXZRVTdxYUN1WDkr?=
 =?gb2312?B?ZWRBMHd1emFPMGE2TlNmK3dJT21Cc0kvV29IU3hWdnN5cUMvOHc1ckRmejJv?=
 =?gb2312?B?NmVQRTRvbEFqS3E1VmJrZmFpSlhGOGZLYnhRU3ZYd0h2aE8yVW1EaUdQMkVP?=
 =?gb2312?B?S0hxR2l6T2RlTGEvbUFrSkkwdmJ1eFo5U2prNVQ2THBCVk9qN2psWlRjcDF1?=
 =?gb2312?B?NG1nTVZvV29yM1ZKVUVLUWZYTW5lODlEbU1WejRlVjJ6SGpPNXVleFJnblo2?=
 =?gb2312?B?cy85R2xidWZRbjdwbmxPOEtkK0FSZjZzbmlHNXI4c3RESUlPZUVsb3dsMXFk?=
 =?gb2312?B?dEhscnVnY1R3aUNiTnlKQ3p5WTFzN3psVU9XRkQ1c2JheCs2N1l3V2VFUmJB?=
 =?gb2312?B?NGhMZlpOOU1VYkdXWTNXQWdITXI5cWZUdlAyTXh1S1dvQUs2d3FXSGRtU1pK?=
 =?gb2312?B?VjNxbnNBeExHTVI5dmpFSmZSVENkK21lTGtOd3NHK1ZGSU1ldlpMNnlqV3Rx?=
 =?gb2312?B?ZkJVN21jTHYrSnR4VWxUcmVDdHJLNUQ0RFl1cXJLT3N0dUZpa2xEVCt3NTMw?=
 =?gb2312?B?ajNSSE1zTDkwUjNKNDRTL09uUEdvMFlINkJBYlFieEp6amJLVWdVZWRzZFFF?=
 =?gb2312?B?U1FjaDFiRExPS1orclpBazBEZ3RQVmFzRmJFRSs5OUQrbG51bnNHeHhCQnFu?=
 =?gb2312?B?cEhncWw2MENjRUJ0aVY5VTQrY3hsNk5zamJJUitxNk9RVXpVcGVTRXdGOE9a?=
 =?gb2312?B?dEgxWWVManhSVUhsZ25JdnYxZitzcmJYZlE1elFvTUc5MW95SmJEVkYrdXBa?=
 =?gb2312?B?LzhNU25yNmV0MWZnSzFTcytmMDFVb0xZcTg5TStveXMwQ3EzdHRnZUl1dHA3?=
 =?gb2312?B?THdEK1dDNndlREZmczdTZUJ6OXlaUHhvcHh0bFVIbmtNWm5SQnVoL09PSVd1?=
 =?gb2312?B?Q000d21UeHRRVzVWa2RQcFRLL05QUmpRZEFYbmhYMERFY1pBSDNmblNsOGE5?=
 =?gb2312?B?Z0RBNmtPWGJ1MEpMNm1BUHhXMjhZdmhMbk9ZQ0Z4OGdubndGNkcySkpWREpa?=
 =?gb2312?B?UjlmSExxWG43bm92L1lVaEYyV1h3aHFJZFNXeEY5QWJhcjIxWTFmYmhnUFEw?=
 =?gb2312?B?VnRLRDBjSVFpaTV1WGloa2RFTW9ITDdqTXo0OUJXVXFZeFhjcVROWkVtN0ho?=
 =?gb2312?Q?tGCTnecaYyZmvGAdvsw7uKq+utJcEa+yDU8X+DXqLU=3D?=
Content-Type: text/plain; charset="gb2312"
Content-ID: <F82AFD49BFFEB640961F83EF99FFA71C@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB6544.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bcba3cb-fa37-4520-baee-08d99d008147
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2021 06:26:14.3660
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lslEXzSfmsEeau3Gm73bduy+JufSJfkxRTMyM06lDxi9z6vo4h8bPBgJGNrloPMMXoEqCO4tGfs4R8heuwo8t7gRKLpLxFeYzBWlhnbanP8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB6537
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gMjAyMS8xMC8zMCAyOjUwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6DQo+IFthZGRpbmcgdGhl
IHJlc2lkZW50IHhhdHRycyBleHBlcnRdDQo+DQo+IE9uIEZyaSwgT2N0IDI5LCAyMDIxIGF0IDA0
OjUyOjAwUE0gKzA4MDAsIFlhbmcgWHUgd3JvdGU6DQo+PiBXaGVuIHRlc3RpbmcgeGZzdGVzdHMg
eGZzLzEyNiBvbiBsYXN0ZXN0IHVwc3RyZWFtIGtlcm5lbCwgaXQgd2lsbCBoYW5nIG9uIHNvbWUg
bWFjaGluZS4NCj4+IEFkZGluZyBhIGdldHhhdHRyIG9wZXJhdGlvbiBhZnRlciB4YXR0ciBjb3Jy
dXB0ZWQsIEkgY2FuIHJlcHJvZHVjZSBpdCAxMDAlLg0KPj4NCj4+IFRoZSBkZWFkbG9jayBhcyBi
ZWxvdzoNCj4+IFs5ODMuOTIzNDAzXSB0YXNrOnNldGZhdHRyICAgICAgICBzdGF0ZTpEIHN0YWNr
OiAgICAwIHBpZDoxNzYzOSBwcGlkOiAxNDY4NyBmbGFnczoweDAwMDAwMDgwDQo+PiBbICA5ODMu
OTIzNDA1XSBDYWxsIFRyYWNlOg0KPj4gWyAgOTgzLjkyMzQxMF0gIF9fc2NoZWR1bGUrMHgyYzQv
MHg3MDANCj4+IFsgIDk4My45MjM0MTJdICBzY2hlZHVsZSsweDM3LzB4YTANCj4+IFsgIDk4My45
MjM0MTRdICBzY2hlZHVsZV90aW1lb3V0KzB4Mjc0LzB4MzAwDQo+PiBbICA5ODMuOTIzNDE2XSAg
X19kb3duKzB4OWIvMHhmMA0KPj4gWyAgOTgzLjkyMzQ1MV0gID8geGZzX2J1Zl9maW5kLmlzcmEu
MjkrMHgzYzgvMHg1ZjAgW3hmc10NCj4+IFsgIDk4My45MjM0NTNdICBkb3duKzB4M2IvMHg1MA0K
Pj4gWyAgOTgzLjkyMzQ3MV0gIHhmc19idWZfbG9jaysweDMzLzB4ZjAgW3hmc10NCj4+IFsgIDk4
My45MjM0OTBdICB4ZnNfYnVmX2ZpbmQuaXNyYS4yOSsweDNjOC8weDVmMCBbeGZzXQ0KPj4gWyAg
OTgzLjkyMzUwOF0gIHhmc19idWZfZ2V0X21hcCsweDRjLzB4MzIwIFt4ZnNdDQo+PiBbICA5ODMu
OTIzNTI1XSAgeGZzX2J1Zl9yZWFkX21hcCsweDUzLzB4MzEwIFt4ZnNdDQo+PiBbICA5ODMuOTIz
NTQxXSAgPyB4ZnNfZGFfcmVhZF9idWYrMHhjZi8weDEyMCBbeGZzXQ0KPj4gWyAgOTgzLjkyMzU2
MF0gIHhmc190cmFuc19yZWFkX2J1Zl9tYXArMHgxY2YvMHgzNjAgW3hmc10NCj4+IFsgIDk4My45
MjM1NzVdICA/IHhmc19kYV9yZWFkX2J1ZisweGNmLzB4MTIwIFt4ZnNdDQo+PiBbICA5ODMuOTIz
NTkwXSAgeGZzX2RhX3JlYWRfYnVmKzB4Y2YvMHgxMjAgW3hmc10NCj4+IFsgIDk4My45MjM2MDZd
ICB4ZnNfZGEzX25vZGVfcmVhZCsweDFmLzB4NDAgW3hmc10NCj4+IFsgIDk4My45MjM2MjFdICB4
ZnNfZGEzX25vZGVfbG9va3VwX2ludCsweDY5LzB4NGEwIFt4ZnNdDQo+PiBbICA5ODMuOTIzNjI0
XSAgPyBrbWVtX2NhY2hlX2FsbG9jKzB4MTJlLzB4MjcwDQo+PiBbICA5ODMuOTIzNjM3XSAgeGZz
X2F0dHJfbm9kZV9oYXNuYW1lKzB4NmUvMHhhMCBbeGZzXQ0KPj4gWyAgOTgzLjkyMzY1MV0gIHhm
c19oYXNfYXR0cisweDZlLzB4ZDAgW3hmc10NCj4+IFsgIDk4My45MjM2NjRdICB4ZnNfYXR0cl9z
ZXQrMHgyNzMvMHgzMjAgW3hmc10NCj4+IFsgIDk4My45MjM2ODNdICB4ZnNfeGF0dHJfc2V0KzB4
ODcvMHhkMCBbeGZzXQ0KPj4gWyAgOTgzLjkyMzY4Nl0gIF9fdmZzX3JlbW92ZXhhdHRyKzB4NGQv
MHg2MA0KPj4gWyAgOTgzLjkyMzY4OF0gIF9fdmZzX3JlbW92ZXhhdHRyX2xvY2tlZCsweGFjLzB4
MTMwDQo+PiBbICA5ODMuOTIzNjg5XSAgdmZzX3JlbW92ZXhhdHRyKzB4NGUvMHhmMA0KPj4gWyAg
OTgzLjkyMzY5MF0gIHJlbW92ZXhhdHRyKzB4NGQvMHg4MA0KPj4gWyAgOTgzLjkyMzY5M10gID8g
X19jaGVja19vYmplY3Rfc2l6ZSsweGE4LzB4MTZiDQo+PiBbICA5ODMuOTIzNjk1XSAgPyBzdHJu
Y3B5X2Zyb21fdXNlcisweDQ3LzB4MWEwDQo+PiBbICA5ODMuOTIzNjk2XSAgPyBnZXRuYW1lX2Zs
YWdzKzB4NmEvMHgxZTANCj4+IFsgIDk4My45MjM2OTddICA/IF9jb25kX3Jlc2NoZWQrMHgxNS8w
eDMwDQo+PiBbICA5ODMuOTIzNjk5XSAgPyBfX3NiX3N0YXJ0X3dyaXRlKzB4MWUvMHg3MA0KPj4g
WyAgOTgzLjkyMzcwMF0gID8gbW50X3dhbnRfd3JpdGUrMHgyOC8weDUwDQo+PiBbICA5ODMuOTIz
NzAxXSAgcGF0aF9yZW1vdmV4YXR0cisweDliLzB4YjANCj4+IFsgIDk4My45MjM3MDJdICBfX3g2
NF9zeXNfcmVtb3ZleGF0dHIrMHgxNy8weDIwDQo+PiBbICA5ODMuOTIzNzA0XSAgZG9fc3lzY2Fs
bF82NCsweDViLzB4MWEwDQo+PiBbICA5ODMuOTIzNzA1XSAgZW50cnlfU1lTQ0FMTF82NF9hZnRl
cl9od2ZyYW1lKzB4NjUvMHhjYQ0KPj4gWyAgOTgzLjkyMzcwN10gUklQOiAwMDMzOjB4N2YwODBm
MTBlZTFiDQo+Pg0KPj4gV2hlbiBnZXR4YXR0ciBjYWxscyB4ZnNfYXR0cl9ub2RlX2dldCwgeGZz
X2RhM19ub2RlX2xvb2t1cF9pbnQgZmFpbHMgaW4NCj4+IHhmc19hdHRyX25vZGVfaGFzbmFtZSBi
ZWNhdXNlIHdlIGhhdmUgdXNlIGJsb2NrdHJhc2ggdG8gcmFuZG9tIGl0IGluIHhmcy8xMjYuIFNv
IGl0DQo+PiBmcmVlIHN0YXQgYW5kIHhmc19hdHRyX25vZGVfZ2V0IGRvZXNuJ3QgZG8geGZzX2J1
Zl90cmFucyByZWxlYXNlIGpvYi4NCj4+DQo+PiBUaGVuIHN1YnNlcXVlbnQgcmVtb3ZleGF0dHIg
d2lsbCBoYW5nIGJlY2F1c2Ugb2YgaXQuDQo+Pg0KPj4gVGhpcyBidWcgd2FzIGludHJvZHVjZWQg
Ynkga2VybmVsIGNvbW1pdCAwNzEyMGYxYWJkZmYgKCJ4ZnM6IEFkZCB4ZnNfaGFzX2F0dHIgYW5k
IHN1YnJvdXRpbmVzIikuDQo+PiBJdCBhZGRzIHhmc19hdHRyX25vZGVfaGFzbmFtZSBoZWxwZXIg
YW5kIHNhaWQgY2FsbGVyIHdpbGwgYmUgcmVzcG9uc2libGUgZm9yIGZyZWVpbmcgdGhlIHN0YXRl
DQo+PiBpbiB0aGlzIGNhc2UuIEJ1dCB4ZnNfYXR0cl9ub2RlX2hhc25hbWUgd2lsbCBmcmVlIHN0
YXQgaXRzZWxmIGluc3RlYWQgb2YgY2FsbGVyIGlmDQo+PiB4ZnNfZGEzX25vZGVfbG9va3VwX2lu
dCBmYWlscy4NCj4+DQo+PiBGaXggdGhpcyBidWcgYnkgbW92aW5nIHRoZSBzdGVwIG9mIGZyZWUg
c3RhdGUgaW50byBjYWxsZXIuDQo+Pg0KPj4gRml4ZXM6IDA3MTIwZjFhYmRmZiAoInhmczogQWRk
IHhmc19oYXNfYXR0ciBhbmQgc3Vicm91dGluZXMiKQ0KPj4gU2lnbmVkLW9mZi1ieTogWWFuZyBY
dTx4dXlhbmcyMDE4Lmp5QGZ1aml0c3UuY29tPg0KPg0KPiBBaCwgSSBrbmV3IHRoaXMgZnVuY3Rp
b24gd2FzIGdyb3NzLiAgQmVmb3JlLCB3ZSB3b3VsZCBzZXQgKnN0YXRlcCB0bw0KPiBOVUxMIHVw
b24gZW50cnkgdG8gdGhlIGZ1bmN0aW9uLCBhbmQgd2Ugd291bGQgcGFzcyB0aGUgbmV3bHkgYWxs
b2NhdGVkDQo+IGRhIHN0YXRlIGJhY2sgb3V0IGlmICFlcnJvci4gIEhvd2V2ZXIsIHRoZSBjYWxs
ZXIgaGFzIG5vIGlkZWEgaWYgdGhlDQo+IHJldHVybiB2YWx1ZSBjYW1lIGZyb20gZXJyb3Igb3Ig
cmV0dmFsLCBvdGhlciB0aGFuIChJIGd1ZXNzKSB0aGUgY29tbWVudA0KPiBpbXBsaWVzIChvciBo
YWQgYmV0dGVyIGltcGx5KSB0aGF0IEVOT0FUVFIvRUVYSVNUIG9ubHkgY29tZSBmcm9tIHJldHZh
bC4NCj4NCj4gTm93IHlvdSdyZSBjaGFuZ2luZyBpdCB0byBhbHdheXMgcGFzcyBzdGF0ZSBvdXQg
dmlhICoqc3RhdGVwIGV2ZW4gaWYgdGhlDQo+IGRhMyBsb29rdXAgcmV0dXJucyBlcnJvciBhbmQg
d2Ugd2FudCB0byBwYXNzIHRoYXQgb3V0LiAgQnV0IHRoZW4NCj4geGZzX2F0dHJfbm9kZV9hZGRu
YW1lX2ZpbmRfYXR0ciBkb2VzIHRoaXM6DQo+DQo+IHJldHZhbCA9IHhmc19hdHRyX25vZGVfaGFz
bmFtZShhcmdzLCZkYWMtPmRhX3N0YXRlKTsNCj4gaWYgKHJldHZhbCAhPSAtRU5PQVRUUiYmICBy
ZXR2YWwgIT0gLUVFWElTVCkNCj4gCXJldHVybiBlcnJvcjsNCj4NCj4gd2l0aG91dCBldmVyIGNs
ZWFyaW5nIGRhYy0+ZGFfc3RhdGUuICBXb24ndCB0aGF0IGxlYWsgdGhlIGRhIHN0YXRlPw0KWWVz
LiBXZSBzaG91bGQgY2xlYXIgZGFjLT5kYV9zdGF0ZSBoZXJlIGJ5IHVzaW5nIGdvdG8gZXJyb3Ig
aW5zdGVhZCBvZiANCnJldHVybiBlcnJvci4NCj4NCj4gR3JhbnRlZCwgSSB3b25kZXIgaWYgdGhl
IHhmc19hdHRyX25vZGVfaGFzbmFtZSBjYWxsIGluDQo+IHhmc19hdHRyX25vZGVfcmVtb3ZlbmFt
ZV9zZXR1cCB3aWxsIGFsc28gbGVhayB0aGUgc3RhdGUgaWYgdGhlIHJldHVybg0KPiB2YWx1ZSBp
cyBFTk9BVFRSPw0KWWVzLCBpdCB3aWxsIGFsc28gbGVhayB0aGUgc3RhdGUgaWYgZXJyb3IgaXMg
bm90IEVFWElTVC4gV2lsbCBmaXggdGhlbSANCmluIHYyLg0KPg0KPiBJZiB5b3UgYXNrIG1lIHRo
ZSB3aG9sZSBFTk9BVFRSL0VFWElTVCB0aGluZyBzdGlsbCBuZWVkcyB0byBiZSByZXBsYWNlZA0K
PiB3aXRoIGFuIGVudW0geGZzX2F0dHJfbG9va3VwX3Jlc3VsdCBwYXNzZWQgb3V0IHNlcGFyYXRl
bHkgc28gdGhhdCB3ZQ0KPiBkb24ndCBoYXZlIHRvIHRoaW5rIGFib3V0IHdoaWNoIG1hZ2ljIGVy
cm5vIHZhbHVlcyBhcmUgbm90IHJlYWxseQ0KPiBlcnJvcnMuDQpBZ3JlZS4NCg0KQmVzdCBSZWdh
cmRzDQpZYW5nIFh1DQo+DQo+IC0tRA0KPg0KPj4gLS0tDQo+PiAgIGZzL3hmcy9saWJ4ZnMveGZz
X2F0dHIuYyB8IDEzICsrKysrLS0tLS0tLS0NCj4+ICAgMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0
aW9ucygrKSwgOCBkZWxldGlvbnMoLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvZnMveGZzL2xpYnhm
cy94ZnNfYXR0ci5jIGIvZnMveGZzL2xpYnhmcy94ZnNfYXR0ci5jDQo+PiBpbmRleCBmYmM5ZDgx
Njg4MmMuLjZhZDUwYTc2ZmQ4ZCAxMDA2NDQNCj4+IC0tLSBhL2ZzL3hmcy9saWJ4ZnMveGZzX2F0
dHIuYw0KPj4gKysrIGIvZnMveGZzL2xpYnhmcy94ZnNfYXR0ci5jDQo+PiBAQCAtMTA3NywyMSAr
MTA3NywxOCBAQCB4ZnNfYXR0cl9ub2RlX2hhc25hbWUoDQo+Pg0KPj4gICAJc3RhdGUgPSB4ZnNf
ZGFfc3RhdGVfYWxsb2MoYXJncyk7DQo+PiAgIAlpZiAoc3RhdGVwICE9IE5VTEwpDQo+PiAtCQkq
c3RhdGVwID0gTlVMTDsNCj4+ICsJCSpzdGF0ZXAgPSBzdGF0ZTsNCj4+DQo+PiAgIAkvKg0KPj4g
ICAJICogU2VhcmNoIHRvIHNlZSBpZiBuYW1lIGV4aXN0cywgYW5kIGdldCBiYWNrIGEgcG9pbnRl
ciB0byBpdC4NCj4+ICAgCSAqLw0KPj4gICAJZXJyb3IgPSB4ZnNfZGEzX25vZGVfbG9va3VwX2lu
dChzdGF0ZSwmcmV0dmFsKTsNCj4+IC0JaWYgKGVycm9yKSB7DQo+PiAtCQl4ZnNfZGFfc3RhdGVf
ZnJlZShzdGF0ZSk7DQo+PiAtCQlyZXR1cm4gZXJyb3I7DQo+PiAtCX0NCj4+ICsJaWYgKGVycm9y
KQ0KPj4gKwkJcmV0dmFsID0gZXJyb3I7DQo+Pg0KPj4gLQlpZiAoc3RhdGVwICE9IE5VTEwpDQo+
PiAtCQkqc3RhdGVwID0gc3RhdGU7DQo+PiAtCWVsc2UNCj4+ICsJaWYgKCFzdGF0ZXApDQo+PiAg
IAkJeGZzX2RhX3N0YXRlX2ZyZWUoc3RhdGUpOw0KPj4gKw0KPj4gICAJcmV0dXJuIHJldHZhbDsN
Cj4+ICAgfQ0KPj4NCj4+IC0tDQo+PiAyLjIzLjANCj4+DQo=
