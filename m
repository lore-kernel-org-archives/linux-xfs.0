Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6528BC7EE2A
	for <linux-xfs@archiver.kernel.org>; Wed, 17 May 2023 19:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbjEQTPK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 May 2023 15:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjEQTPF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 May 2023 15:15:05 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BDBD2DE
        for <linux-xfs@vger.kernel.org>; Wed, 17 May 2023 12:14:44 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34HIGwOl021103;
        Wed, 17 May 2023 19:14:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=fK1tNhxhKdIo9XAYb3nqKn52nj8dX5OyzEcGHt1K8kM=;
 b=nYvBo0LhzJNanzoX2cquu3yX7FbIJxvx9NmxwVSAzVQJuZok6Hojwh4Tt3mlGVDpEibg
 lkazG7Szx41qN4APeV+HOYqf5nhBMi2mGD+oCkYGTL7uJGLcv6ZAxsrfYghJCAATmrD3
 qr2XuKYdvY15oFT9rCjIXDNTLYCPvBupQzkY1MvORH/vO2+KycV6/9KJdlY0b3gOuM0D
 QQR4IYnX0SKFjno55aB32LO4H/sUsM0ezQ/L/OKA+okPmR3iuVla+CX3QKbtE9GZbXhQ
 6wwKZT/3Tq4NSH5yhNXb0pf3A33Q5eevIONT+XJloDiUeIcjhNZXJuFysnkoxorjixz+ oQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qj33uxat3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 May 2023 19:14:35 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34HIubib032172;
        Wed, 17 May 2023 19:14:34 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2044.outbound.protection.outlook.com [104.47.74.44])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qj10bv69h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 May 2023 19:14:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j47QQnufI3q+ojxZgWlw7cOjmmjfMIPbOsiqBLxEDhywXyoghqFQEjpqEkWCRfmqpMukFUEYku9R/SGAptwvo3LNbKf3YvZJXo77JWeWXxo89mMnx01CKLT8bWnUhhBnuTBIedK7OQy/O8+qB0OOKaN/hoqs6/KW38ZBLJHBtGgkaaNhnwdVpwm9AgzPtfrNaaEABg7qU276gBZ0t0B4zdXo5jzq3pAspTf9CjO4aS+HhI/VAuuMgmJtRuS5RrHvKiSLefaOT+5RgcKWGXGZRIOhPIn/iGDNN9u06Tg8VoSQ2Ezi9n3+pLmDRSgmbjm4l5ATb0ZBAFkhpfjGfzSKvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fK1tNhxhKdIo9XAYb3nqKn52nj8dX5OyzEcGHt1K8kM=;
 b=QTlLfzlXxR1fbcgEObKMXenC5YQMKmlmlm5YNlTbB+B5/qlo/v0VSC7BfKasVoWjn7U/eH1tXa5OZ0PfhAqEHlYhHvaQyHB8MSu2GddEkfOO4bKqXtLtcZugoBP1VsU2yZPCLAzC5N7ZLa8P9e/g580yxIJtIh6mQgKuSm2n0E/kzg5gA5X2UZXvZ8k8zSB3QGra1SP5AoTgb1+/Yj23DBjVHOFzmOqXH5r68AzwhF9CYt+vGEMf2cJmpqEfJnde2l5JgxEO1ptVEblUVu2LTjYKYxGLqbOpcnRCZxma0/tjoQAsalJP+mC+3TzPE77IGJsBVG/Y17bwqiLAsOF9wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fK1tNhxhKdIo9XAYb3nqKn52nj8dX5OyzEcGHt1K8kM=;
 b=BLwfEuXzebeqUTHGCfubgQU6J3SCCq7dN0nPw2mKnWDbM9kAoZZspMKxIg8ruOn5BqvyuKTIvLYFwiUFtNBF2Bd7k9Nva6lpPLLOW2/R1zbvydpcdixpMpOdqY54/l45HHWc745iKF3LvMY3KKmdFZO9bW4YkiOrjD+uHEAjC78=
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by MN2PR10MB4205.namprd10.prod.outlook.com (2603:10b6:208:1d3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Wed, 17 May
 2023 19:14:32 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::58cd:8b89:f285:ca2b]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::58cd:8b89:f285:ca2b%7]) with mapi id 15.20.6387.035; Wed, 17 May 2023
 19:14:32 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     "Darrick J. Wong" <djwong@kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: avoid freeing multiple extents from same AG in
 pending transactions
Thread-Topic: [PATCH] xfs: avoid freeing multiple extents from same AG in
 pending transactions
Thread-Index: AQHZdv9AR28b2kBDxE2gDgdaeEYEXK9XEBuAgAAZP4CAABXWAIAAEsyAgAXgZgCAAJU2gIAAC2uAgAEmj4A=
Date:   Wed, 17 May 2023 19:14:32 +0000
Message-ID: <94FD314F-7819-4187-AC42-F984AF42C662@oracle.com>
References: <20230424225102.23402-1-wen.gang.wang@oracle.com>
 <20230512182455.GJ858799@frogsfrogsfrogs>
 <592C0DE1-F4F5-4C9A-8799-E9E81524CDC0@oracle.com>
 <20230512211326.GK858799@frogsfrogsfrogs>
 <050A91C4-54EC-4EB8-A701-7C9F640B7ADB@oracle.com>
 <11835435-29A1-4F34-9CE5-C9ED84567E98@oracle.com>
 <20230517005913.GM858799@frogsfrogsfrogs>
 <ZGQwdes/DQPXRJgj@dread.disaster.area>
In-Reply-To: <ZGQwdes/DQPXRJgj@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2701:EE_|MN2PR10MB4205:EE_
x-ms-office365-filtering-correlation-id: 7a4b5ac7-3d86-40a3-1d0e-08db570af201
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VgFU82ZcxjTXEHvT62btajdZ8Os6Alaz/DuEg/Xu0W3LWTCd+HLkt8OOBNmrwFqe/LXQCFRjs/weqPde249qO6P23k0Uj1ZBLcx1MsTCtLy9GH7jmGFLCj0eBbsQl0LeyH1VfOkvAPIcliR7RCYvUlOh3kkjQM77b17HfGDyb5OG1Nl2o8BtxuTdQcLUJpHscTj62QM5glVHsM7wuugpfhNizy382HpvwMjP6DisqwmPYnqIAKbVLWbd5AjuLA9HkZptZTT7Xqs/bO75szvCgQJ1ENfmLUn7f5a0QVJYyYdoDRTE2UrKAw/vLfo+wpj2fqPj75ESNaxFSIL5Ben7PZl6Tx/Hf03gkQ9LYQFLtabGqHkyYgGX3AosOWTOW4KX0tqiu6cXgGiyE94CHck1zzbMwFiKV8Si0c6qsVckSZ6+7oW3ioj3xU1qoHG/dcc0GBpLegvzL4dEsENo5jFE+IxTzhutUPU5nBmZ9xn9drsw9+9gdhpNTZM2z6ZHtfgegZeKcn+wOvRBjOeIsqUvjQi6XxioLcJVrhLFcHylHGUDRtiqmOhCU2BTOSTWl6zrsL3Va6fM1BnmJVmoS9zFyPh2HvJnZHQvYXorp0ubv7fc5U33ypS+kCGtOCaR99gby/7rLEXF6ZbvOFwkrJIEQzCjOAodFYi1KKKucRU2wn0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(366004)(136003)(376002)(396003)(451199021)(5660300002)(71200400001)(41300700001)(36756003)(2906002)(83380400001)(2616005)(122000001)(86362001)(38070700005)(38100700002)(33656002)(26005)(186003)(6506007)(6512007)(8676002)(8936002)(53546011)(91956017)(66556008)(66476007)(66446008)(76116006)(66946007)(64756008)(478600001)(6486002)(54906003)(316002)(4326008)(6916009)(21314003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?KzNIN1RKeDRJeThKdEpNbVFiSFhrZ3FuZ0N0MXczWTZQZ3IxVFphYktZWnFn?=
 =?utf-8?B?NGNhbWpIaDV2RVUyc0xNOFd0RU41K2Qwd0xCc1NwZjE3a1FNb0JhNzBxZUM2?=
 =?utf-8?B?TVhGK3c0SkgwSzlMYWVBUzNIVG5YRDJVQVBiT2lPb1kzK1ZHVGtaelF6WjlV?=
 =?utf-8?B?QzA4enRVVUVaMjhxWGU2SjZrVHRTQkQ0eGdHbEpXS3pNYlZCbkk4QXpFNGZ6?=
 =?utf-8?B?SU8yaUg4eGVOeUg1S2E0UjFsQ3kwTE16ZVhiRGlXTWFyMWJoZmNUTWx4RTF5?=
 =?utf-8?B?cGZhVElObWF2c0hPSHo0cStrS0xPWXpaZ215T2RNcHBWam1yVHFBSG5FZjhy?=
 =?utf-8?B?YnJWNlk4YjBqaU5YcTNYS2cvM1pJdzRBZk9aeEtxVHUyWEEvTDUrbUhZbTNt?=
 =?utf-8?B?Y1V5NENRaDdTOC80eTFPZTduRUdxTStEVENxNFZKY0d3cndta1ljVzBOWEtY?=
 =?utf-8?B?emJnSWE0UW5mWWVTcnk3MThQVE5rVmlTQkxhL0grczVtZFNLRTJEZURaTHYy?=
 =?utf-8?B?WmZPYjUrUlVqNmRxL1ROTVpacmRiRzN4NmpvRGhNenYwRTVSMGVqT1djaDJ6?=
 =?utf-8?B?UVJTYS9RdlNrZy9QVFFESm81OVkvTW1rQk45VzVSQllxNjZSNGFySmVjNG9W?=
 =?utf-8?B?d0hSSy9LakVTenNGdXpuM0I5dVhmMGxNeDhuVVhhc00yem1yL1hpM3MrSC9M?=
 =?utf-8?B?a2UzdW80a0JuZ3lWemlsaVRhTDNJd0E0bTNWMVM0cUFQWENlVktWZWFiU0pK?=
 =?utf-8?B?VGNQMlJFeU1lVjNFWFZrUWhOam9lc3FwTHBEME1Ja0xlSXcwaEdESmtFUi9y?=
 =?utf-8?B?WUd2K1k2YXdGNCsvbUd0T3JUUVVSdWd4b2I4TytCNjJpZTgzNU1WZ1hIZDMw?=
 =?utf-8?B?enJLN3Ywak1UVDVSVXFtbGo3cXplSFZlaDZIb0Y4V29HVU5BTG8xQ1lpRW5U?=
 =?utf-8?B?c3p5cGVzZ2hMZ2lVOHVkb1ZYanZHT2VkZWZuZitUc0N6YzdCS1R4R0hidXdV?=
 =?utf-8?B?WDRKSU40S3BXWWN2MnJDczZ4Zi9ROFpNWDQ1VkhnbDVhZkdiZWxIenVnY1Rh?=
 =?utf-8?B?YkNSVWZmU1RwQksrRU1SNnhLN0RqbE9xbzJWbGdNNS9MK1psVVNENFVsZHor?=
 =?utf-8?B?Ym5mMEpYZURzUTNlNk5Kb2FzK2hXYTRJQkNsWFBHVit3N2NYaHdlR1ZQQTlZ?=
 =?utf-8?B?QW05ME83WndieUZqTG14eGdycW1TcnE4cHBuWUFuSEp2OWd2NzNZajYvZERq?=
 =?utf-8?B?YmgweTdWaUpqbXNjWVg0Q1djWDcrUWh5MWZPV2hzOXh1MzU5YmlJNUcrTURl?=
 =?utf-8?B?UVI3azFMWlV0MUJndGxEcWVhMFluMEVFdS9tT3U3V3Rac0hlWm0rY1NzN1JZ?=
 =?utf-8?B?bjM2S2JWbG50UDd4TXR4ME1XMG1mQnIyVHc5NG5waE9oenl3SUNXTmR0WGp4?=
 =?utf-8?B?Y2NjRWk0UXQyUVVKU2o1UHFWaXhKOTdicWdpeDZwbFJ3RGFVOUxCOGJQeGM0?=
 =?utf-8?B?QUZLK1NhQ25sbmVhMWVQNlNPV2E1T0tyWERWWjBIVkc1QTBHN29HUGpKNzJF?=
 =?utf-8?B?VmlyNW41eGRwcTgxUFZpZXlXT3djZmFWV05PdlJuV042TDNzWHZ5QjNMVzQ4?=
 =?utf-8?B?MlpsZG9oSGUrTjlwL2pBMUdocFZqNkdaSXcxdEdBZlY3MDVIbzluMjZzcWxW?=
 =?utf-8?B?WTJKUmtMMkFsOEpkSFU5L1dESC9oYnJ3SXYzRjk5TElZNGgwRThZRVJWeXAy?=
 =?utf-8?B?QVAxYW5pYml3YnEyRjdpdjFRamlyK3BQNjVVeWZSVVJVY0ZrL3J2dmlWbU1n?=
 =?utf-8?B?UlhwY1NOYzZJd0lsbWZFQUp6ekliM3QwdFpRbjNubmc1M2JmVzVMWFJYYTBh?=
 =?utf-8?B?bkM3ZHk5dTlxWFlvRldKbmZ0VW05SmRFZExnZDRpQ2Q1V09qeE1lZW1iMGhP?=
 =?utf-8?B?NEc0QVVCbmJqTzd2Q2dRWkFJQ1F3ZmN2SFJjQkhFTVozVUwxQmo1dW1WRTY2?=
 =?utf-8?B?Q1NXdUtZSEdQS3Uwb1ZEdDR6UlluUnNocm1uVGxXcnUzMXhnQ3M5Sk9QZEoy?=
 =?utf-8?B?SWtPQiswSWk4KzF1Mi9nZnhGcStGbzREL210cGJ5SnJyQXJURWhrWHJabm93?=
 =?utf-8?B?eUJmYmFPSm5TSFV2TEpMNmUxaVNBTWRFR3p2NWZ4aXR5UUpWdE5HZUoxZWhs?=
 =?utf-8?B?cVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <77EE7BDD9829E142ADD2B0110736BD8A@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: vtw3X6UbObX1l/G+Ctgec06zqXFU+cvrkudCuWaijOfMYn+QTXGi3MoagebHynArPeJs2AUiBnILZmD8vagFEZ8bLu5szy0k4AMKu3yvn6QHkK2ss3Wru9n4l1gPZyGLLwf4XqzLcSnslGJZ9vfhwyLp3JrWy5E/an4uxhqWohCqRBCTRIeFGQYlW/FT7mJp56BMEX20BDINZLEWSdlr65RUx2oE/nh+gMgHU2PpdG8O5x76KkFC5xBoy6kUFf2lsuAHqsUWgp1Otc6d5fiL0WAmw8J9sXHGYozy37JmTQmVcVIJsbwuML/Rwibl99N7rrPv4jGPL8fOdvIVSptIteamed5ORAMaHHlU7VGG7iNZrwMiOzMm4eSeKH9epW6CXjS7Pq7jm8J++WCyPzRUG42yUSNU53Mfjdy5rirl187n1es1G78+WjiPnCoHG7J1HtvjrFxXMfv7KslvlHZd8CwCGagCj+ujRLUqbMbRcWSPHJTFc9H1i9dHVXMMQxTXYrJ+YjOnR4OLwKZcHNY7QEo5PLHvYp0Zmf0ud9ajilZHu8Zdl21mcFWtxthYEEOEy8CwcbVFHnIYR/FL4p+4Rf3kBCfV2dCnvWbw2zSxJi8PBiFzGeXqTCyYk6Ad6ZXlda35kmvNrAwzJSrcGilPGtAICZqHgHTfhEdyd3EhCBxASsIQk8Czq/QwJAkPvEONOIUK1gdikKxP0Wr4zCfokxUgHYQZKzsSoDArSJKOmNmfwdtqZIWcOXKxxYfKIfsnbl6H9UD54MOAtq+zusRwIgndF0dclVlXQzgmo2WIqunSKo9yvInuQNVnHzobokZvVzOUBnHrfdLwYDqWrU7H9w==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a4b5ac7-3d86-40a3-1d0e-08db570af201
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2023 19:14:32.3972
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yUYTVdGN+dy5bXVriZ2wbmbfsAU8m+8HgQmK7/eQN15APcHbzBVQlV8YXjgma8MYq0A6BKBiIqYCd41v9irPGq9h7ev9md7/qS/7f9NAcQA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4205
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-17_04,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305170159
X-Proofpoint-GUID: FaWeyxIID4I3-GqCjlCVFRij2CZ4YrHb
X-Proofpoint-ORIG-GUID: FaWeyxIID4I3-GqCjlCVFRij2CZ4YrHb
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

DQoNCj4gT24gTWF5IDE2LCAyMDIzLCBhdCA2OjQwIFBNLCBEYXZlIENoaW5uZXIgPGRhdmlkQGZy
b21vcmJpdC5jb20+IHdyb3RlOg0KPiANCj4gT24gVHVlLCBNYXkgMTYsIDIwMjMgYXQgMDU6NTk6
MTNQTSAtMDcwMCwgRGFycmljayBKLiBXb25nIHdyb3RlOg0KPj4gU2luY2UgNi4zIHdlIGdvdCBy
aWQgb2YgdGhlIF9USElTX0FHIGluZGlyZWN0aW9uIHN0dWZmIGFuZCB0aGF0IGJlY29tZXM6DQo+
PiANCj4+IHhmc19hbGxvY19maXhfZnJlZWxpc3QgLT4NCj4+IHhmc19hbGxvY19hZ192ZXh0ZW50
X3NpemUgLT4NCj4+IChydW4gYWxsIHRoZSB3YXkgdG8gdGhlIGVuZCBvZiB0aGUgYm5vYnQpIC0+
DQo+PiB4ZnNfZXh0ZW50X2J1c3lfZmx1c2ggLT4NCj4+IDxzdGFsbCBvbiB0aGUgYnVzeSBleHRl
bnQgdGhhdCdzIGluIEB0cC0+YnVzeV9saXN0Pg0KPj4gDQo+PiB4ZnNfZXh0ZW50X2J1c3lfZmx1
c2ggZG9lcyB0aGlzLCBwb3RlbnRpYWxseSB3aGlsZSB3ZSdyZSBob2xkaW5nIHRoZQ0KPj4gZnJl
ZWQgZXh0ZW50IGluIEB0cC0+dF9idXN5X2xpc3Q6DQo+PiANCj4+IGVycm9yID0geGZzX2xvZ19m
b3JjZShtcCwgWEZTX0xPR19TWU5DKTsNCj4+IGlmIChlcnJvcikNCj4+IHJldHVybjsNCj4+IA0K
Pj4gZG8gew0KPj4gcHJlcGFyZV90b193YWl0KCZwYWctPnBhZ2Jfd2FpdCwgJndhaXQsIFRBU0tf
S0lMTEFCTEUpOw0KPj4gaWYgIChidXN5X2dlbiAhPSBSRUFEX09OQ0UocGFnLT5wYWdiX2dlbikp
DQo+PiBicmVhazsNCj4+IHNjaGVkdWxlKCk7DQo+PiB9IHdoaWxlICgxKTsNCj4+IA0KPj4gZmlu
aXNoX3dhaXQoJnBhZy0+cGFnYl93YWl0LCAmd2FpdCk7DQo+PiANCj4+IFRoZSBsb2cgZm9yY2Ug
a2lja3MgdGhlIENJTCB0byBwcm9jZXNzIHdoYXRldmVyIG90aGVyIGNvbW1pdHRlZCBpdGVtcw0K
Pj4gbWlnaHQgYmUgbHVya2luZyBpbiB0aGUgbG9nLiAgKkhvcGVmdWxseSogc29tZW9uZSBlbHNl
IGZyZWVkIGFuIGV4dGVudA0KPj4gaW4gdGhlIHNhbWUgQUcsIHNvIHRoZSBsb2cgZm9yY2UgaGFz
IG5vdyBjYXVzZWQgdGhhdCAqb3RoZXIqIGV4dGVudCB0bw0KPj4gZ2V0IHByb2Nlc3NlZCBzbyBp
dCBoYXMgbm93IGNsZWFyZWQgdGhlIGJ1c3kgbGlzdC4gIENsZWFyaW5nIHNvbWV0aGluZw0KPj4g
ZnJvbSB0aGUgYnVzeSBsaXN0IGluY3JlbWVudHMgdGhlIGJ1c3kgZ2VuZXJhdGlvbiAoYWthIHBh
Z2JfZ2VuKS4NCj4gDQo+ICpub2QqDQo+IA0KPj4gVW5mb3J0dW5hdGVseSwgdGhlcmUgYXJlbid0
IGFueSBvdGhlciBleHRlbnRzLCBzbyB0aGUgYnVzeV9nZW4gZG9lcyBub3QNCj4+IGNoYW5nZSwg
YW5kIHRoZSBsb29wIHJ1bnMgZm9yZXZlci4NCj4+IA0KPj4gQXQgdGhpcyBwb2ludCwgRGF2ZSB3
cml0ZXM6DQo+PiANCj4+IFsxNTo1N10gPGRjaGlubmVyPiBzbyBpZiB3ZSBlbnRlciB0aGF0IGZ1
bmN0aW9uIHdpdGggYnVzeSBleHRlbnRzIG9uIHRoZQ0KPj4gdHJhbnNhY3Rpb24sIGFuZCB3ZSBh
cmUgZG9pbmcgYW4gZXh0ZW50IGZyZWUgb3BlcmF0aW9uLCB3ZSBzaG91bGQgcmV0dXJuDQo+PiBh
ZnRlciB0aGUgc3luYyBsb2cgZm9yY2UgYW5kIG5vdCBkbyB0aGUgZ2VuZXJhdGlvbiBudW1iZXIg
d2FpdA0KPj4gDQo+PiBbMTU6NThdIDxkY2hpbm5lcj4gaWYgd2UgZmFpbCB0byBhbGxvY2F0ZSBh
Z2FpbiBhZnRlciB0aGUgc3luYyBsb2cgZm9yY2UNCj4+IGFuZCB0aGUgZ2VuZXJhdGlvbiBudW1i
ZXIgaGFzbid0IGNoYW5nZWQsIHRoZW4gcmV0dXJuIC1FQUdBSU4gYmVjYXVzZSBubw0KPj4gcHJv
Z3Jlc3MgaGFzIGJlZW4gbWFkZS4NCj4+IA0KPj4gWzE1OjU5XSA8ZGNoaW5uZXI+IFRoZW4gdGhl
IHRyYW5zYWN0aW9uIGlzIHJvbGxlZCwgdGhlIHRyYW5zYWN0aW9uIGJ1c3kNCj4+IGxpc3QgaXMg
Y2xlYXJlZCwgYW5kIGlmIHRoZSBuZXh0IGFsbG9jYXRpb24gYXR0ZW1wdCBmYWlscyBiZWNhdWVz
DQo+PiBldmVyeXRoaW5nIGlzIGJ1c3ksIHdlIGdvIHRvIHNsZWVwIHdhaXRpbmcgZm9yIHRoZSBn
ZW5lcmF0aW9uIHRvIGNoYW5nZQ0KPj4gDQo+PiBbMTY6MDBdIDxkY2hpbm5lcj4gYnV0IGJlY2F1
c2UgdGhlIHRyYW5zYWN0aW9uIGRvZXMgbm90IGhvbGQgYW55IGJ1c3kNCj4+IGV4dGVudHMsIGl0
IGNhbm5vdCBkZWFkbG9jayBoZXJlIGJlY2F1c2UgaXQgZG9lcyBub3QgcGluIGFueSBleHRlbnRz
DQo+PiB0aGF0IGFyZSBpbiB0aGUgYnVzeSB0cmVlLi4uLg0KPj4gDQo+PiBbMTY6MDVdIDxkY2hp
bm5lcj4gQWxsIHRoZSBnZW5lcmF0aW9uIG51bWJlciBpcyBkb2luZyBoZXJlIGlzIHRlbGxpbmcg
dXMNCj4+IHdoZXRoZXIgdGhlcmUgd2FzIGJ1c3kgZXh0ZW50IHJlc29sdXRpb24gYmV0d2VlbiB0
aGUgdGltZSB3ZSBsYXN0DQo+PiBza2lwcGVkIGEgdmlhYmxlIGV4dGVudCBiZWNhdXNlIGl0IHdh
cyBidXN5IGFuZCB3aGVuIHRoZSBmbHVzaA0KPj4gY29tcGxldGVzLg0KPj4gDQo+PiBbMTY6MDZd
IDxkY2hpbm5lcj4gaXQgZG9lc24ndCBtZWFuIHRoZSBuZXh0IGFsbG9jYXRpb24gd2lsbCBzdWNj
ZWVkLA0KPj4ganVzdCB0aGF0IHByb2dyZXNzIGhhcyBiZWVuIG1hZGUgc28gdHJ5aW5nIHRoZSBh
bGxvY2F0aW9uIGF0dGVtcHQgd2lsbA0KPj4gYXQgbGVhc3QgZ2V0IGEgZGlmZmVyZW50IHJlc3Vs
dCB0byB0aGUgcHJldmlvdXMgc2Nhbi4NCj4+IA0KPj4gSSB0aGluayB0aGUgY2FsbHNpdGVzIGdv
IGZyb20gdGhpczoNCj4+IA0KPj4gaWYgKGJ1c3kpIHsNCj4+IHhmc19idHJlZV9kZWxfY3Vyc29y
KGNudF9jdXIsIFhGU19CVFJFRV9OT0VSUk9SKTsNCj4+IHRyYWNlX3hmc19hbGxvY19zaXplX2J1
c3koYXJncyk7DQo+PiB4ZnNfZXh0ZW50X2J1c3lfZmx1c2goYXJncy0+bXAsIGFyZ3MtPnBhZywg
YnVzeV9nZW4pOw0KPj4gZ290byByZXN0YXJ0Ow0KPj4gfQ0KPiANCg0KQmFzaWNhbGx5IEkgdGhp
bmsgdGhlIGZvbGxvd2luZyBhbHNvIHdvcmsgYnkgYWRkaW5nIGNvbXBsaWNhdGlvbiB0byBhbGxv
Y2F0b3INCihJIGRpZG7igJl0IHdhbnQgdG8gZG8gc28gdG8gbGVhdmUgYWxsb2NhdG9yIGFzIHNp
bXBsZSBhcyBwb3NzaWJsZSkuDQoNCj4gSSB3YXMgdGhpbmtpbmcgdGhpcyBjb2RlIGNoYW5nZXMg
dG86DQo+IA0KPiBmbGFncyB8PSBYRlNfQUxMT0NfRkxBR19UUllfRkxVU0g7DQo+IC4uLi4NCj4g
PGF0dGVtcHQgYWxsb2NhdGlvbj4NCj4gLi4uLg0KPiBpZiAoYnVzeSkgew0KPiB4ZnNfYnRyZWVf
ZGVsX2N1cnNvcihjbnRfY3VyLCBYRlNfQlRSRUVfTk9FUlJPUik7DQo+IHRyYWNlX3hmc19hbGxv
Y19zaXplX2J1c3koYXJncyk7DQo+IGVycm9yID0geGZzX2V4dGVudF9idXN5X2ZsdXNoKGFyZ3Mt
PnRwLCBhcmdzLT5wYWcsDQo+IGJ1c3lfZ2VuLCBmbGFncyk7DQo+IGlmICghZXJyb3IpIHsNCj4g
ZmxhZ3MgJj0gflhGU19BTExPQ19GTEFHX1RSWV9GTFVTSDsNCg0KV2hhdOKAmXMgdGhlIGJlbmVm
aXRzIHRvIHVzZSBYRlNfQUxMT0NfRkxBR19UUllfRkxVU0g/DQpJZiBubyBjaGFuZ2UgaGFwcGVu
ZWQgdG8gcGFnYl9nZW4sIHdlIHdvdWxkIGdldCBub3RoaW5nIGdvb2QgaW4gdGhlIHJldHJ5DQpi
dXQgd2FzdGUgY3ljbGVzLiBPciBJIG1pc3NlZCBzb21ldGhpbmc/DQoNCj4gZ290byByZXN0YXJ0
Ow0KPiB9DQo+IC8qIGp1bXAgdG8gY2xlYW51cCBleGl0IHBvaW50ICovDQo+IGdvdG8gb3V0X2Vy
cm9yOw0KPiB9DQo+IA0KPiBOb3RlIHRoZSBkaWZmZXJlbnQgZmlyc3QgcGFyYW1ldGVyIC0gd2Ug
cGFzcyBhcmdzLT50cCwgbm90IGFyZ3MtPm1wDQo+IHNvIHRoYXQgdGhlIGZsdXNoIGhhcyBhY2Nl
c3MgdG8gdGhlIHRyYW5zYWN0aW9uIGNvbnRleHQuLi4NCj4gDQo+PiB0byBzb21ldGhpbmcgbGlr
ZSB0aGlzOg0KPj4gDQo+PiBib29sIHRyeV9sb2dfZmx1c2ggPSB0cnVlOw0KPj4gLi4uDQo+PiBy
ZXN0YXJ0Og0KPj4gLi4uDQo+PiANCj4+IGlmIChidXN5KSB7DQo+PiBib29sIHByb2dyZXNzOw0K
Pj4gDQo+PiB4ZnNfYnRyZWVfZGVsX2N1cnNvcihjbnRfY3VyLCBYRlNfQlRSRUVfTk9FUlJPUik7
DQo+PiB0cmFjZV94ZnNfYWxsb2Nfc2l6ZV9idXN5KGFyZ3MpOw0KPj4gDQo+PiAvKg0KPj4gKiBJ
ZiB0aGUgY3VycmVudCB0cmFuc2FjdGlvbiBoYXMgYW4gZXh0ZW50IG9uIHRoZSBidXN5DQo+PiAq
IGxpc3QsIHdlJ3JlIGFsbG9jYXRpbmcgc3BhY2UgYXMgcGFydCBvZiBmcmVlaW5nDQo+PiAqIHNw
YWNlLCBhbmQgYWxsIHRoZSBmcmVlIHNwYWNlIGlzIGJ1c3ksIHdlIGNhbid0IGhhbmcNCj4+ICog
aGVyZSBmb3JldmVyLiAgRm9yY2UgdGhlIGxvZyB0byB0cnkgdG8gdW5idXN5IGZyZWUNCj4+ICog
c3BhY2UgdGhhdCBjb3VsZCBoYXZlIGJlZW4gZnJlZWQgYnkgb3RoZXINCj4+ICogdHJhbnNhY3Rp
b25zLCBhbmQgcmV0cnkgdGhlIGFsbG9jYXRpb24uICBJZiB0aGUNCj4+ICogYWxsb2NhdGlvbiBm
YWlscyBhIHNlY29uZCB0aW1lIGJlY2F1c2UgYWxsIHRoZSBmcmVlDQo+PiAqIHNwYWNlIGlzIGJ1
c3kgYW5kIG5vYm9keSBtYWRlIGFueSBwcm9ncmVzcyB3aXRoDQo+PiAqIGNsZWFyaW5nIGJ1c3kg
ZXh0ZW50cywgcmV0dXJuIEVBR0FJTiBzbyB0aGUgY2FsbGVyDQo+PiAqIGNhbiByb2xsIHRoaXMg
dHJhbnNhY3Rpb24uDQo+PiAqLw0KPj4gaWYgKChmbGFncyAmIFhGU19BTExPQ19GTEFHX0ZSRUVJ
TkcpICYmDQo+PiAgICAhbGlzdF9lbXB0eSgmdHAtPnRfYnVzeV9saXN0KSkgew0KPj4gaW50IGxv
Z19mbHVzaGVkOw0KPj4gDQo+PiBpZiAodHJ5X2xvZ19mbHVzaCkgew0KPj4gX3hmc19sb2dfZm9y
Y2UobXAsIFhGU19MT0dfU1lOQywgJmxvZ19mbHVzaGVkKTsNCj4+IHRyeV9sb2dfZmx1c2ggPSBm
YWxzZTsNCj4+IGdvdG8gcmVzdGFydDsNCj4+IH0NCj4+IA0KPj4gaWYgKGJ1c3lfZ2VuID09IFJF
QURfT05DRShwYWctPnBhZ2JfZ2VuKSkNCj4+IHJldHVybiAtRUFHQUlOOw0KPj4gDQo+PiAvKiBY
WFggc2hvdWxkIHdlIHNldCB0cnlfbG9nX2ZsdXNoID0gdHJ1ZT8gKi8NCj4+IGdvdG8gcmVzdGFy
dDsNCj4+IH0NCj4+IA0KPj4geGZzX2V4dGVudF9idXN5X2ZsdXNoKGFyZ3MtPm1wLCBhcmdzLT5w
YWcsIGJ1c3lfZ2VuKTsNCj4+IGdvdG8gcmVzdGFydDsNCj4+IH0NCj4+IA0KPj4gSU9XcywgSSB0
aGluayBEYXZlIHdhbnRzIHVzIHRvIGtlZXAgdGhlIGNoYW5nZXMgaW4gdGhlIGFsbG9jYXRvciBp
bnN0ZWFkDQo+PiBvZiBzcHJlYWRpbmcgaXQgYXJvdW5kLg0KPiANCj4gU29ydCBvZiAtIEkgd2Fu
dCB0aGUgYnVzeSBleHRlbnQgZmx1c2ggY29kZSB0byBiZSBpc29sYXRlZCBpbnNpZGUNCj4geGZz
X2V4dGVudF9idXN5X2ZsdXNoKCksIG5vdCBzcHJlYWQgYXJvdW5kIHRoZSBhbGxvY2F0b3IuIDop
DQo+IA0KPiB4ZnNfZXh0ZW50X2J1c3lfZmx1c2goDQo+IHN0cnVjdCB4ZnNfdHJhbnMgKnRwLA0K
PiBzdHJ1Y3QgeGZzX3BlcmFnICpwYWcsDQo+IHVuc2lnbmVkIGludCBidXN5X2dlbiwNCj4gdW5z
aWduZWQgaW50IGZsYWdzKQ0KPiB7DQo+IGVycm9yID0geGZzX2xvZ19mb3JjZSh0cC0+dF9tb3Vu
dHAsIFhGU19MT0dfU1lOQyk7DQo+IGlmIChlcnJvcikNCj4gcmV0dXJuIGVycm9yOw0KPiANCj4g
LyoNCj4gKiBJZiB3ZSBhcmUgaG9sZGluZyBidXN5IGV4dGVudHMsIHRoZSBjYWxsZXIgbWF5IG5v
dCB3YW50DQo+ICogdG8gYmxvY2sgc3RyYWlnaHQgYXdheS4gSWYgd2UgYXJlIGJlaW5nIHRvbGQg
anVzdCB0byB0cnkNCj4gKiBhIGZsdXNoIG9yIHByb2dyZXNzIGhhcyBiZWVuIG1hZGUgc2luY2Ug
d2UgbGFzdCBza2lwcGVkIGEgYnVzeQ0KPiAqIGV4dGVudCwgcmV0dXJuIGltbWVkaWF0ZWx5IHRv
IGFsbG93IHRoZSBjYWxsZXIgdG8gdHJ5DQo+ICogYWdhaW4uIElmIHdlIGFyZSBmcmVlaW5nIGV4
dGVudHMsIHdlIG1pZ2h0IGFjdHVhbGx5IGJlDQo+ICogaG9sZGluZyB0aGUgb255bHkgZnJlZSBl
eHRlbnRzIGluIHRoZSB0cmFuc2FjdGlvbiBidXN5DQo+ICogbGlzdCBhbmQgdGhlIGxvZyBmb3Jj
ZSB3b24ndCByZXNvbHZlIHRoYXQgc2l0dWF0aW9uLiBJbg0KPiAqIHRoaXMgY2FzZSwgcmV0dXJu
IC1FQUdBSU4gaW4gdGhhdCBjYXNlIHRvIHRlbGwgdGhlIGNhbGxlcg0KPiAqIGl0IG5lZWRzIHRv
IGNvbW1pdCB0aGUgYnVzeSBleHRlbnRzIGl0IGhvbGRzIGJlZm9yZQ0KPiAqIHJldHJ5aW5nIHRo
ZSBleHRlbnQgZnJlZSBvcGVyYXRpb24uDQo+ICovDQo+IGlmICghbGlzdF9lbXB0eSgmdHAtPnRf
YnVzeV9saXN0KSkgew0KPiBpZiAoZmxhZ3MgJiBYRlNfQUxMT0NfRkxBR19UUllfRkxVU0gpDQo+
IHJldHVybiAwOw0KDQpJIGRvbuKAmXQgdGhpbmsgYWJvdmUgaXMgbmVlZGVkLiBzZWUgbXkgcHJl
dmlvdXMgY29tbWVudC4NCg0KdGhhbmtzLA0Kd2VuZ2FuZw0KPiBpZiAoYnVzeV9nZW4gIT0gUkVB
RF9PTkNFKHBhZy0+cGFnYl9nZW4pKQ0KPiByZXR1cm4gMDsNCj4gaWYgKGZsYWdzICYgWEZTX0FM
TE9DX0ZMQUdfRlJFRUlORykNCj4gcmV0dXJuIC1FQUdBSU47DQo+IH0NCj4gDQo+IC8qIHdhaXQg
Zm9yIHByb2dyZXNzaW5nIHJlc29sdmluZyBidXN5IGV4dGVudHMgKi8NCj4gZG8gew0KPiBwcmVw
YXJlX3RvX3dhaXQoJnBhZy0+cGFnYl93YWl0LCAmd2FpdCwgVEFTS19LSUxMQUJMRSk7DQo+IGlm
ICAoYnVzeV9nZW4gIT0gUkVBRF9PTkNFKHBhZy0+cGFnYl9nZW4pKQ0KPiBicmVhazsNCj4gc2No
ZWR1bGUoKTsNCj4gfSB3aGlsZSAoMSk7DQo+IA0KPiBmaW5pc2hfd2FpdCgmcGFnLT5wYWdiX3dh
aXQsICZ3YWl0KTsNCj4gcmV0dXJuIDA7DQo+IH0NCj4gDQo+IEl0IHNlZW1zIGNsZWFuZXIgdG8g
bWUgdG8gcHV0IHRoaXMgYWxsIGluIHhmc19leHRlbnRfYnVzeV9mbHVzaCgpDQo+IHJhdGhlciB0
aGFuIGhhdmluZyBvcGVuLWNvZGVkIGhhbmRsaW5nIG9mIGV4dGVudCBmcmVlIGNvbnN0cmFpbnRz
IGluDQo+IGVhY2ggcG90ZW50aWFsIGZsdXNoIGxvY2F0aW9uLiBXZSBhbHJlYWR5IGhhdmUgcmV0
cnkgc2VtYW50aWNzDQo+IGFyb3VuZCB0aGUgZmx1c2gsIGxldCdzIGp1c3QgZXh0ZW5kIHRoZW0g
c2xpZ2h0bHkuLi4uDQo+IA0KPiAtRGF2ZS4NCj4gDQo+IC0tIA0KPiBEYXZlIENoaW5uZXINCj4g
ZGF2aWRAZnJvbW9yYml0LmNvbQ0KDQo=
