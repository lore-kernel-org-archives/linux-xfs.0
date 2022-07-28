Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5BBFC19F2B
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jul 2022 01:38:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236838AbiG1BiZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jul 2022 21:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiG1BiY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jul 2022 21:38:24 -0400
X-Greylist: delayed 64 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 27 Jul 2022 18:38:19 PDT
Received: from esa1.fujitsucc.c3s2.iphmx.com (esa1.fujitsucc.c3s2.iphmx.com [68.232.152.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9A74E878;
        Wed, 27 Jul 2022 18:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1658972301; x=1690508301;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=cJfV8FGMuDNqb8VJOcoKhSYsn7bK+Q898FKsfJvBXzw=;
  b=QKZ9y6U4TqcehQw8RG6dUh7Br+xO5xuc7IJIeBN0QG6faErhZF2CeYoi
   3hY8nqASP3W4VVNHDJbSvf7/DozXhKBHxAShb/44ANhmIAH5CUkd9sh8t
   yrA+0Twe2vYpAqYMxImqREQq+bDPKeXXs9kbEDG1GhMfgW3eJ2EdWYSro
   3I6eQgzC1XSjrT1vqvOe5qMqL72ME5DBJGJHixuW8CBqgJOLob1UccKxa
   HMrHfBlEIKEs0jPCggnpPWpXUAMAckesIpapURK2zZH1JeBtl5HJH3Ckc
   Bb6PqZnCjGeKnQIkZJa6kr8R6RaFiq2IVO50KZI72BsNYvjhjd85HGoZO
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10421"; a="69650822"
X-IronPort-AV: E=Sophos;i="5.93,196,1654527600"; 
   d="scan'208";a="69650822"
Received: from mail-tycjpn01lp2175.outbound.protection.outlook.com (HELO JPN01-TYC-obe.outbound.protection.outlook.com) ([104.47.23.175])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 10:37:13 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PS3dCFskGqfYfxPlDWXzwJVvg9fnFZlV8gdK5/NQhVlfFxW4slbUdJboFq6RRn7mpOQZNYeqZ6wzpxSmon5LGc+3tnIDjamdAfjmED/MeeaFFGZ7FEL/JG2tJLxZzBJXLQIh+6Tp/OUm9N4kddR+H1CeY0DQjbmARURJpBEqJqtfDZOChFXGonRZrbygdgJGp4kWfeTs9LK4PDKRd724tHkiliandOkRFBqT434Bo7Taw6nkk6xI2a/fsfBzapZCfmKtGKurm+voZOSiV8sv3Nrgv11L17RTJ8LqbJbimp1NF/U9pRCEkuKn5pN6expghY2w4uCN8PKVeC66Hp+LCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cJfV8FGMuDNqb8VJOcoKhSYsn7bK+Q898FKsfJvBXzw=;
 b=d7Gs6kadV7DYJBV7VHAQY2rVTKfphJt2JsEro0s7Jcm87+PpoqbHRcvObr4ZNij36NEY+ZALMFULpYsDr7BBngPT/XGqrWL9XNHkFmjG5OzvUV8eFRblD/WMNT7Yjr4STAfJbNJZJyzR7y+89q9LyhjUOG2qNTlEDXttVJysxV+QqMUMtz9+dGhYPqgUR86WGjpi6CmtG2j0kx55gPHDTktoKfROKWD6wCPZ8Ui6rkbdaiyN/5b2wAvXtNBWVGp19FwDVvzBLp+HMqEbynenA5QNpjiKxQzEaNn1xQu4wQqIG6hBhP1e5rUvGXf1ytOz8ZAOjIpQp81bG10mz4/fMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OS0PR01MB6481.jpnprd01.prod.outlook.com (2603:1096:604:107::13)
 by OSZPR01MB8254.jpnprd01.prod.outlook.com (2603:1096:604:1b1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Thu, 28 Jul
 2022 01:37:08 +0000
Received: from OS0PR01MB6481.jpnprd01.prod.outlook.com
 ([fe80::ccd:ccc6:1a42:94cd]) by OS0PR01MB6481.jpnprd01.prod.outlook.com
 ([fe80::ccd:ccc6:1a42:94cd%9]) with mapi id 15.20.5482.006; Thu, 28 Jul 2022
 01:37:08 +0000
From:   "liuyd.fnst@fujitsu.com" <liuyd.fnst@fujitsu.com>
To:     "Darrick J. Wong" <djwong@kernel.org>,
        "guaneryu@gmail.com" <guaneryu@gmail.com>,
        "zlang@redhat.com" <zlang@redhat.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        "guan@eryu.me" <guan@eryu.me>
Subject: Re: [PATCH 1/9] seek_sanity_test: fix allocation unit detection on
 XFS realtime
Thread-Topic: [PATCH 1/9] seek_sanity_test: fix allocation unit detection on
 XFS realtime
Thread-Index: AQHYiy0iU/1u1BnWYU+VNSIpIwfG7K2TLs8A
Date:   Thu, 28 Jul 2022 01:37:08 +0000
Message-ID: <3f63e720-c252-a836-b700-7a5739312b1b@fujitsu.com>
References: <165644767753.1045534.18231838177395571946.stgit@magnolia>
 <165644768327.1045534.10420155448662856970.stgit@magnolia>
In-Reply-To: <165644768327.1045534.10420155448662856970.stgit@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0635bd2f-87d1-4958-d687-08da7039af44
x-ms-traffictypediagnostic: OSZPR01MB8254:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QfizOfUsr27+o2LiW9lqvBBvqs4lkCNG1kKR1sR1Y2jxg4nt0zkSyRJluSUo+Tg69UqXRoLjTGrGM/YKKbgDAzUDiqU5YTN41ArBDep91WX/NjEsygd+1Rs0Ojd9XufPZR2EVYKFqhV756OGxYd/z98jsINyodD//iO1OSSzk1pG3VFO7vyIs0vBvX3OhKgZfK6c3pSN3BFRh+lE1xH2ZFReMAGevuQcwCPevdFUErSimZr57+1BM8IHxzNADDnv+94y+ZJO7AfWPrvMbx8DUJJzVqit2KZtKQ4bVOCmRqMoav1mvrAEaR0o0LKeDWm/6DUqh7CSryTetVUy+yFuNpZ6f63ksyge40+10qwcKJbmo/yo1S6EVstN1MI1EPbNIHZqBYizUuW0v7mW8xa6GakXl95AG6uqZWdiOmGeUBM6ts/25LPT/DuTciPGlYxnaNkaOk6nS2URZeIbB9/qNffBX9IC0MYauN4NQ+8sTMiqasAJnCqbZNwBji4cMhD2q0AQNmqPKYPEK+I6JcWd6WR96duvegroHuvXihvvOUxMLNoE1EyXGdW41oHPcQ3TekAXdAojeh5fEWxl46BAOD988JpjH3L6rbQFAfF9m1y33G0/XrBG+ALAfA1Cum0cmnyBhklnlz0WTzO1SJRaoNOP11x5Tao5NmB3SN2dQ0C1On0fTHp69NqZtKYOH+0zE9MaoNZ7I+ojt1D0ACvAk3vnkoii3j2L2ErxrEGGEYDzD7MYF0vEqAzzPOPqaznFBBgIW+3pQ4goqKNwPB6yCfu+gM96jCdh7N3/4EgTQkaWvMPRQrE1K6wmNnTuF5yIV4m/3Nf4LpL8gQ8+Eysnew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB6481.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(396003)(376002)(136003)(39860400002)(31686004)(85182001)(8936002)(76116006)(91956017)(36756003)(66946007)(64756008)(66556008)(66446008)(66476007)(38070700005)(8676002)(4326008)(5660300002)(122000001)(82960400001)(2906002)(316002)(38100700002)(26005)(54906003)(110136005)(6512007)(83380400001)(478600001)(2616005)(53546011)(71200400001)(186003)(6486002)(6506007)(41300700001)(86362001)(31696002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MjAzMTZsN1VOMFFaSkJlMmk5MklKUSt2YklGOFQ5RldNa1Z5Ny9xNGwyN3Qx?=
 =?utf-8?B?TjFyU0pkYm80QUFUc2hmeXZvS1ZnM0RXU0J4TnRlSi9JMnRqOFZMZWlSWnhk?=
 =?utf-8?B?ZlRDSVdSelBMYXhycmErc1VkQ0o3cmpwMERJQ2dNdjYxMGhHbDdRNzZpWTlE?=
 =?utf-8?B?R0JIM0NURnk2YVZINGEyWDhxQW1tTHRGN3EvbGlwTCtMYjJzRTZ1eW9VV2R6?=
 =?utf-8?B?bW1xd3hWRm9BU2dVdnFSZmlSZS9mUUNaQjNYVE5ZQ1Vxd0pUc3ZxM1k4S090?=
 =?utf-8?B?UGtwd1F6VmZ5cE9UYi84MDAzd1BLQm9yVk5TdjlYd2F4MjZ0SFJlK0ZwMjFX?=
 =?utf-8?B?ZkJ4Sm1aK21Pb0V2Z0I0SU05Ly9CeW0wVmJXVC80c29GcVMrOU8veHNvWFZS?=
 =?utf-8?B?cVpuNEdBWjJhNHk3L3VudEtleFdLMzBNaGQ4MjdpNlRyR2ZyVWVqUlNlU091?=
 =?utf-8?B?RHcwQ016NkNsRDhmMGp3UlFOcFFoT3NiVExhaENpODZESDdBd3ZQQmJHYUNG?=
 =?utf-8?B?OHlMQWVqZzBsRmR0MCs5Y25rc3ZpcWxCTU15Y0ErdDc4dHJuTnJPUHdPV244?=
 =?utf-8?B?ejFIeFFOUDhCbm5GZEk1VjVOa0xtZHNXRkhUYnlkUk42RnlrbHp2akNsaGx3?=
 =?utf-8?B?d2x3Sld0aHovQWJFWEJJblpjd3NnL0dDaFVaeFYrRWw2T29oNFBuQkc3dTRC?=
 =?utf-8?B?OS9XdUhIWnVoaEpnMjNIb2FTSFJlNzI5eWRmNGlVWldzNHNKais1cWxLN1cv?=
 =?utf-8?B?MzJubTdwbHUvMGZpcGtkcWIwZzR5VGhVNG9ocFdLTnVsN1J0ZUtNdUVEY3lv?=
 =?utf-8?B?ZGw1eU1qRlRrbkphVUhxNnF4Q0hzbUVoM2RzVHV0OGRPdzY4cElsY015SUFT?=
 =?utf-8?B?OWd1ZURTSk1IckZ4UUlZNEpxU2t3NzJwaXh2UnpqTUI2TFRmT1RqeVh2bTVo?=
 =?utf-8?B?N2YveWl0NExrNGNPbE44K3I4eGJXdWNUenBaOTVxc0x5UXA2RDk2d2liSGdy?=
 =?utf-8?B?MFNEbm40bHFYR2tZcUVld0JFZnI3Q25JTXN2anpWV2RRNmN2RnJOR2NpbXJI?=
 =?utf-8?B?bXZ1MENnMy85S2FEZUhxNTdOaDVSeXNuSVp5UzdjQlpYZkZBRHJZOGhmMHJB?=
 =?utf-8?B?aVVMM1ZESTNEa0pZbE83QXFvY0l1VTlJMFhsVlp6aWc0cUtsOUErVnBvbXZH?=
 =?utf-8?B?VUx0eWZhL0RucFRiUW12Z2d3azY2UnV6bTc1VXhuRGhlN2l6V0NmeVNmNGpT?=
 =?utf-8?B?ZmoyRCsxSmRRRGxmRTcyNEpuSWVZRzhHTWdnbkEwZGF6dkxTRXhBdWlhWlNI?=
 =?utf-8?B?dWNvOGR4MjdXbGlwdlVMdi9ycHBNSHNQM3BaeEh3QXEvcUxpUGhpUHdrSTlk?=
 =?utf-8?B?bFpzbVlSN2NwV2tkMXU3aWQ5U1BpY2wwVG9DV2sxNDVwMUwyTHlXWlV1Z0ts?=
 =?utf-8?B?K0xxNXFESUMxOHgreDkxR3BBR2Q5aHd5a3FFNlJ2azc5SFhnYmQ1UkdSS25x?=
 =?utf-8?B?RFQwSng1NklEbENiK0tWa1Izc2JMWVdVUjZLa0RGYng0TmZXZUJIekkzaVVp?=
 =?utf-8?B?YzBxREpaYy8venZXVkV6ZUpqOGQ3aWRTMDVmOWN4UCtFMU5mZG82WFlhZjNK?=
 =?utf-8?B?SFl0aU9la3pwVTNFS3A1eG9kMUduZktWUmFnRVZDeFlTeW5DaUJHaTFENXR4?=
 =?utf-8?B?M1VYL1lwZkYrSTdVUTY2blFaVWYzSVQrUVlya1JieVdlVisxODBqZTNlK0ph?=
 =?utf-8?B?Y0NMMWVueGRjNzZrcGNqWXU0T3lOcWJ4RHpmUk85TWVSMWJ6aSs4eC9tNkpH?=
 =?utf-8?B?cUxScVRGbzc0ZzU0V0NjSUdlWUczeUdwaFZlSnlhVkpiVm9iMldqVHgvdFEz?=
 =?utf-8?B?WGR4RjZVTmc1clFDZFlBTEthc2U2VTAva2FLeUZ0bEZQT2RxRkJsWXN1MVBL?=
 =?utf-8?B?Z0xGNDdCUGsvS2xneWo2WWVaa0dIcEk1Z1ZyNzRYYWZqZk1ucWlMcENML1FW?=
 =?utf-8?B?dEx0S1JwazcyWWkzL1lrQzBlOC9wNE9xMHJDSEI2L1RVcThFMi9QUVZtd0Mx?=
 =?utf-8?B?M04veW1ZajcxUHp2SWIvK1JianFqZ2ZWVmJXbHk1MUc5eWxIU1NBMUM2VCtD?=
 =?utf-8?B?Tlk0UFpPVzBrS1dCYjNTYlRSTyttSHJqc3JtUndVYTRFMGVzOGw2Wk8rOVV1?=
 =?utf-8?B?NFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F0681A4C1990694EBD1F6ADCCD214DC1@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB6481.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0635bd2f-87d1-4958-d687-08da7039af44
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2022 01:37:08.2161
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q/FSz3Qrkzao9FzFNU5Q1KR1DTgUySPef66p8LxH1mRhUMpawE2KFQGxUmwnWjRVCqgA2KlxZlCCn7G4GsZXkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB8254
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

SGksIGd1eXMuDQoNClJlY2VudGx5IEkgaGl0IGEgcmVncmVzc2lvbiBkdXJpbmcgdGVzdCB4ZnN0
ZXN0LiBSZXZlcnRpbmcgdGhpcyBjb21taXQgDQpjb3VsZCBmaXggdGhhdCBlcnJvci4NCg0KUmVw
cm9kdWNlIHN0ZXBzIChvbmx5IG5mczQuMiBoYXMgdGhpcyBlcnJvcik6DQpgYGANCiMgY2F0IGxv
Y2FsLmNvbmZpZw0KDQpleHBvcnQgVEVTVF9ERVY9MTI3LjAuMC4xOi9ob21lL25mcy9zaGFyZTAN
Cg0KZXhwb3J0IFRFU1RfRElSPS9tbnQvdGVzdA0KDQpleHBvcnQgU0NSQVRDSF9ERVY9MTI3LjAu
MC4xOi9ob21lL25mcy9zaGFyZTENCg0KZXhwb3J0IFNDUkFUQ0hfTU5UPS9tbnQvc2NyYXRjaA0K
DQpleHBvcnQgRlNYX0FWT0lEPSItRSINCg0KZXhwb3J0IE5GU19NT1VOVF9PUFRJT05TPSItbyBy
dyxyZWxhdGltZSx2ZXJzPTQuMiINCg0KDQojIC4vY2hlY2sgLW5mcyBnZW5lcmljLzI4NQ0KDQpG
U1RZUCAgICAgICAgIC0tIG5mcw0KDQpQTEFURk9STSAgICAgIC0tIExpbnV4L2FhcmNoNjQgaHBl
LWFwb2xsbzgwLTAxLW4wMCANCjUuMTQuMC0xMzEuZWw5LmFhcmNoNjQgIzEgU01QIFBSRUVNUFRf
RFlOQU1JQyBNb24gSnVsIDE4IDE2OjEzOjQ0IEVEVCAyMDIyDQoNCk1LRlNfT1BUSU9OUyAgLS0g
MTI3LjAuMC4xOi9ob21lL25mcy9zaGFyZTENCg0KTU9VTlRfT1BUSU9OUyAtLSAtbyBydyxyZWxh
dGltZSx2ZXJzPTQuMiAtbyANCmNvbnRleHQ9c3lzdGVtX3U6b2JqZWN0X3I6cm9vdF90OnMwIDEy
Ny4wLjAuMTovaG9tZS9uZnMvc2hhcmUxIC9tbnQvc2NyYXRjaA0KDQoNCg0KZ2VuZXJpYy8yODUg
MnMgLi4uIFtmYWlsZWQsIGV4aXQgc3RhdHVzIDFdLSBvdXRwdXQgbWlzbWF0Y2ggKHNlZSANCi9y
b290L3hmc3Rlc3RzL3Jlc3VsdHMvL2dlbmVyaWMvMjg1Lm91dC5iYWQpDQoNCiAgICAgLS0tIHRl
c3RzL2dlbmVyaWMvMjg1Lm91dAkyMDIyLTA3LTI3IDIxOjA3OjQzLjE2MDI2ODU1MiAtMDQwMA0K
DQogICAgICsrKyAvcm9vdC94ZnN0ZXN0cy9yZXN1bHRzLy9nZW5lcmljLzI4NS5vdXQuYmFkCTIw
MjItMDctMjcgDQoyMTozMToyNy44ODcwOTA1MzIgLTA0MDANCg0KICAgICBAQCAtMSArMSwzIEBA
DQoNCiAgICAgIFFBIG91dHB1dCBjcmVhdGVkIGJ5IDI4NQ0KDQogICAgICtzZWVrIHNhbml0eSBj
aGVjayBmYWlsZWQhDQoNCiAgICAgKyhzZWUgL3Jvb3QveGZzdGVzdHMvcmVzdWx0cy8vZ2VuZXJp
Yy8yODUuZnVsbCBmb3IgZGV0YWlscykNCg0KICAgICAuLi4NCg0KICAgICAoUnVuICdkaWZmIC11
IC9yb290L3hmc3Rlc3RzL3Rlc3RzL2dlbmVyaWMvMjg1Lm91dCANCi9yb290L3hmc3Rlc3RzL3Jl
c3VsdHMvL2dlbmVyaWMvMjg1Lm91dC5iYWQnICB0byBzZWUgdGhlIGVudGlyZSBkaWZmKQ0KDQpS
YW46IGdlbmVyaWMvMjg1DQoNCkZhaWx1cmVzOiBnZW5lcmljLzI4NQ0KDQpGYWlsZWQgMSBvZiAx
IHRlc3RzDQoNCg0KYGBgDQoNClJldmVydGluZyB0aGlzIGNvbW1pdCB0aGVuIHRlc3QgcGFzcy4N
CmBgYA0KIyBnaXQgcmV2ZXJ0IGU4NjFhMzAyNTVjOTc4MDQyNWVlNTE5MzMyNWQzMDg4MmZiZTc0
MTANCiMgbWFrZSAtaiAmJiBtYWtlIGluc3RhbGwgLWoNCi0tLXNuaXAtLS0NCiMgLi9jaGVjayAt
bmZzIGdlbmVyaWMvMjg1DQoNCkZTVFlQICAgICAgICAgLS0gbmZzDQoNClBMQVRGT1JNICAgICAg
LS0gTGludXgvYWFyY2g2NCBocGUtYXBvbGxvODAtMDEtbjAwIA0KNS4xNC4wLTEzMS5lbDkuYWFy
Y2g2NCAjMSBTTVAgUFJFRU1QVF9EWU5BTUlDIE1vbiBKdWwgMTggMTY6MTM6NDQgRURUIDIwMjIN
Cg0KTUtGU19PUFRJT05TICAtLSAxMjcuMC4wLjE6L2hvbWUvbmZzL3NoYXJlMQ0KDQpNT1VOVF9P
UFRJT05TIC0tIC1vIHJ3LHJlbGF0aW1lLHZlcnM9NC4yIC1vIA0KY29udGV4dD1zeXN0ZW1fdTpv
YmplY3Rfcjpyb290X3Q6czAgMTI3LjAuMC4xOi9ob21lL25mcy9zaGFyZTEgL21udC9zY3JhdGNo
DQoNCg0KDQpnZW5lcmljLzI4NSAxcyAuLi4gIDFzDQoNClJhbjogZ2VuZXJpYy8yODUNCg0KUGFz
c2VkIGFsbCAxIHRlc3RzDQoNCmBgYA0KDQpPbiA2LzI5LzIyIDA0OjIxLCBEYXJyaWNrIEouIFdv
bmcgd3JvdGU6DQo+IEZyb206IERhcnJpY2sgSi4gV29uZyA8ZGp3b25nQGtlcm5lbC5vcmc+DQo+
IA0KPiBUaGUgc2VlayBzYW5pdHkgdGVzdCB0cmllcyB0byBmaWd1cmUgb3V0IGEgZmlsZSBzcGFj
ZSBhbGxvY2F0aW9uIHVuaXQgYnkNCj4gY2FsbGluZyBzdGF0IGFuZCB0aGVuIHVzaW5nIGFuIGl0
ZXJhdGl2ZSBTRUVLX0RBVEEgbWV0aG9kIHRvIHRyeSB0bw0KPiBkZXRlY3QgYSBzbWFsbGVyIGJs
b2Nrc2l6ZSBiYXNlZCBvbiBTRUVLX0RBVEEncyBjb25zdWx0YXRpb24gb2YgdGhlDQo+IGZpbGVz
eXN0ZW0ncyBpbnRlcm5hbCBibG9jayBtYXBwaW5nLiAgVGhpcyB3YXMgcHV0IGluIChBRkFJQ1Qp
IGJlY2F1c2UNCj4gWEZTJyBzdGF0IGltcGxlbWVudGF0aW9uIHJldHVybnMgbWF4KGZpbGVzeXN0
ZW0gYmxvY2tzaXplLCBQQUdFU0laRSkgZm9yDQo+IG1vc3QgcmVndWxhciBmaWxlcy4NCj4gDQo+
IFVuZm9ydHVuYXRlbHksIGZvciBhIHJlYWx0aW1lIGZpbGUgd2l0aCBhbiBleHRlbnQgc2l6ZSBs
YXJnZXIgdGhhbiBhDQo+IHNpbmdsZSBmaWxlc3lzdGVtIGJsb2NrIHRoaXMgZG9lc24ndCB3b3Jr
IGF0IGFsbCBiZWNhdXNlIGJsb2NrIG1hcHBpbmdzDQo+IHN0aWxsIHdvcmsgYXQgZmlsZXN5c3Rl
bSBibG9jayBncmFudWxhcml0eSwgYnV0IGFsbG9jYXRpb24gdW5pdHMgZG8gbm90Lg0KPiBUbyBm
aXggdGhpcywgZGV0ZWN0IHRoZSBzcGVjaWZpYyBjYXNlIHdoZXJlIHN0X2Jsa3NpemUgIT0gUEFH
RV9TSVpFIGFuZA0KPiB0cnVzdCB0aGUgZnN0YXQgcmVzdWx0cy4NCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IERhcnJpY2sgSi4gV29uZyA8ZGp3b25nQGtlcm5lbC5vcmc+DQo+IC0tLQ0KPiAgIHNyYy9z
ZWVrX3Nhbml0eV90ZXN0LmMgfCAgIDEyICsrKysrKysrKysrLQ0KPiAgIDEgZmlsZSBjaGFuZ2Vk
LCAxMSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiANCj4gZGlmZiAtLWdpdCBh
L3NyYy9zZWVrX3Nhbml0eV90ZXN0LmMgYi9zcmMvc2Vla19zYW5pdHlfdGVzdC5jDQo+IGluZGV4
IDc2NTg3YjdmLi4xMDMwZDBjNSAxMDA2NDQNCj4gLS0tIGEvc3JjL3NlZWtfc2FuaXR5X3Rlc3Qu
Yw0KPiArKysgYi9zcmMvc2Vla19zYW5pdHlfdGVzdC5jDQo+IEBAIC00NSw2ICs0NSw3IEBAIHN0
YXRpYyBpbnQgZ2V0X2lvX3NpemVzKGludCBmZCkNCj4gICAJb2ZmX3QgcG9zID0gMCwgb2Zmc2V0
ID0gMTsNCj4gICAJc3RydWN0IHN0YXQgYnVmOw0KPiAgIAlpbnQgc2hpZnQsIHJldDsNCj4gKwlp
bnQgcGFnZXN6ID0gc3lzY29uZihfU0NfUEFHRV9TSVpFKTsNCj4gICANCj4gICAJcmV0ID0gZnN0
YXQoZmQsICZidWYpOw0KPiAgIAlpZiAocmV0KSB7DQo+IEBAIC01Myw4ICs1NCwxNiBAQCBzdGF0
aWMgaW50IGdldF9pb19zaXplcyhpbnQgZmQpDQo+ICAgCQlyZXR1cm4gcmV0Ow0KPiAgIAl9DQo+
ICAgDQo+IC0JLyogc3RfYmxrc2l6ZSBpcyB0eXBpY2FsbHkgYWxzbyB0aGUgYWxsb2NhdGlvbiBz
aXplICovDQo+ICsJLyoNCj4gKwkgKiBzdF9ibGtzaXplIGlzIHR5cGljYWxseSBhbHNvIHRoZSBh
bGxvY2F0aW9uIHNpemUuICBIb3dldmVyLCBYRlMNCj4gKwkgKiByb3VuZHMgdGhpcyB1cCB0byB0
aGUgcGFnZSBzaXplLCBzbyBpZiB0aGUgc3RhdCBibG9ja3NpemUgaXMgZXhhY3RseQ0KPiArCSAq
IG9uZSBwYWdlLCB1c2UgdGhpcyBpdGVyYXRpdmUgYWxnb3JpdGhtIHRvIHNlZSBpZiBTRUVLX0RB
VEEgd2lsbCBoaW50DQo+ICsJICogYXQgYSBtb3JlIHByZWNpc2UgYW5zd2VyIGJhc2VkIG9uIHRo
ZSBmaWxlc3lzdGVtJ3MgKHByZSlhbGxvY2F0aW9uDQo+ICsJICogZGVjaXNpb25zLg0KPiArCSAq
Lw0KPiAgIAlhbGxvY19zaXplID0gYnVmLnN0X2Jsa3NpemU7DQo+ICsJaWYgKGFsbG9jX3NpemUg
IT0gcGFnZXN6KQ0KPiArCQlnb3RvIGRvbmU7DQo+ICAgDQo+ICAgCS8qIHRyeSB0byBkaXNjb3Zl
ciB0aGUgYWN0dWFsIGFsbG9jIHNpemUgKi8NCj4gICAJd2hpbGUgKHBvcyA9PSAwICYmIG9mZnNl
dCA8IGFsbG9jX3NpemUpIHsNCj4gQEAgLTgwLDYgKzg5LDcgQEAgc3RhdGljIGludCBnZXRfaW9f
c2l6ZXMoaW50IGZkKQ0KPiAgIAlpZiAoIXNoaWZ0KQ0KPiAgIAkJb2Zmc2V0ICs9IHBvcyA/IDAg
OiAxOw0KPiAgIAlhbGxvY19zaXplID0gb2Zmc2V0Ow0KPiArZG9uZToNCj4gICAJZnByaW50Zihz
dGRvdXQsICJBbGxvY2F0aW9uIHNpemU6ICVsZFxuIiwgYWxsb2Nfc2l6ZSk7DQo+ICAgCXJldHVy
biAwOw0KPiAgIA0KPiA=
