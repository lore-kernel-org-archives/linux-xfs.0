Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 907ACC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 25 May 2022 07:24:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240405AbiEYHYK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 May 2022 03:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235495AbiEYHYJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 May 2022 03:24:09 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2069.outbound.protection.outlook.com [40.107.212.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408E512A8B
        for <linux-xfs@vger.kernel.org>; Wed, 25 May 2022 00:24:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KOKzliLh5f9wuFklicLk0u9ELWz0Ra6u2SQQKLO5ZOOcbwHKs6wyBGblbnE98yJLsygneDiZx9Cl/FPKiX4/TCdZvsJX13NdhbS5lfeNGE6N7oE3Lootplx0HEWtDS0xEknhz+GPbL3O+lzh7e9H5aD2gEkJsQ34CJTnFHMIbEM6ngayCRRvVypyw0Rf5aGfxr3hXJCXGgr38XifiO+7BodnLxWUTZ3z3N6b+yQ/AuUyv3OWsafsIHavdOtVVUo6oRk3IAMmQAdUVKmNq634FfM5NUeSARCJ+bJXRMXWdKCUpEafi/CR0xSoIJJV3XNpJpHlyhaZtc7UQifz6KSmRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ns8m02klZbly8+wAqIWw7MOYUj+ctx4vD6hwNdfafWg=;
 b=UVreOTHht5Wg+RI0oOw62Y7lAADhlODXdP3K11DeIkk/muvDRPxcw3e47jAi4AszRnLgm0lVC99R86BboNDWoeZsYKs6jRUNNIn8wpuyt+3DfiZk5GE9I4TnWFTVDQx2ngzMxE+LMvQi/1ZNfRDtkRFqp6p9VLFQP70SF54AVo7eoLJz/oqCsWWbRa2gqhM8fRv0SBIFccvCmQelIXuMImK2k6W+2MZcoFUoi2tIO00A/Q683Kki/hb7XETE8mPTOSvoma7YRBRtsSS1SoBXc38kFJhHs8YlRHANrUnGAN26ikUsf6Od0DHjMUpZHQsvsFRqWEmOmcg1cCFq9KZ60g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ns8m02klZbly8+wAqIWw7MOYUj+ctx4vD6hwNdfafWg=;
 b=m6IuZaRcLLSoNo95AWafXIdiaXpj7fSeKzitMwBCxuqArQz2HipO4KD2p3mZBwWCmFRtPCezYLherK1CR3uwOtV7bIPAmH3zlWPcVKptF/WrG8LtnGb8ArOHvtkjbOfaYpRDLENDTS8sAg9bYDYddAu/6Cyly92v+3zdVq9FFeDOnlKS2GkovLGv2AqNdkAlKp8HnxkqH2kWSOQ+82HRXvjHDjVkp+TX7vitrQhgtR+H1PXFv8IqfxAdGukeuqKcDrOWVm7mQdPSVwyVnWxyp+PrIFF1nWTcYyLB1hRjo8TTlC06vVfefcp52RgBi3POjYdrDbjhABsv7AbM1sRGNg==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by SN6PR12MB2733.namprd12.prod.outlook.com (2603:10b6:805:77::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Wed, 25 May
 2022 07:24:06 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::d9a5:f1df:5975:a0d6]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::d9a5:f1df:5975:a0d6%7]) with mapi id 15.20.5273.023; Wed, 25 May 2022
 07:24:06 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Pavel Reichl <preichl@redhat.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] mkfs: Fix memory leak
Thread-Topic: [PATCH v2 1/1] mkfs: Fix memory leak
Thread-Index: AQHYb7pd59RqNOI7xEKpgwg4988UIq0vMWAA
Date:   Wed, 25 May 2022 07:24:06 +0000
Message-ID: <ad1f06b5-b4af-1b56-6337-0dee850c940c@nvidia.com>
References: <20220524220509.967287-1-preichl@redhat.com>
 <20220524220509.967287-2-preichl@redhat.com>
In-Reply-To: <20220524220509.967287-2-preichl@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f15f367d-d358-46c3-4486-08da3e1f8d72
x-ms-traffictypediagnostic: SN6PR12MB2733:EE_
x-microsoft-antispam-prvs: <SN6PR12MB2733AECE13B8F786BBA4F7A5A3D69@SN6PR12MB2733.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ScMVLAM6QFqITwLmSsGpeokiJd0c+BNePZsB/W1UG/qpWDO4kPoMrU8TuYwn6YeqKw8WcnXmk7Q8imxFeEwYTirWTRnulUp0Xx7hgiVrRgh4qeN30PuNSIpLFiZ6CBhsy4x/BPEVs4nOkCJ0lhEp/0zIGzW2MlSBluSuSgixi1Km8AE3l7Q7MCivoDaaQXUPoCI704oDSImdqMyht0VZ3fV88h+ul5E6la2UBN2+eYahnaWNZ4Qsq71Vo0KvrQdYIIoguGOAK0rq2wX8ZHlyl7MXuSUjrmzSYTOS73M5yPlvn3EvevTzyc8mkTEDpP89xinJuVpk4PrYdYawXzX4A288/rz0EGGk41ubpZGBLzjw4UDbz4d1BZLAz6+6dfhHGbq0x2N8KmlOMOzanO8gtFfe2gmDoxL9sw5kHPZeHn39h3ya0xfAiNM1o1ad0hsgiKdgnRKF+hfRYzkqYM02gb/wOOdW6tfftmz7NxHhFVt4PTthdROQU4x5uN9olBGz3JqyDWzQvn6jpPh6ldUJM28GIy38TyZYJYf0YThHRDzhksXp950yOetCddYM8t/+uvdcIPArGzAjVGrsYYmL0UM9WIsI6hEgrKvR5KJEm5wRrgODMNZM5pqg+ZB2G55a+UteiSimqTGdeqRG3BldP4jtlOIVPEsTvg/Kb779QJEN/gXb+/YYlq7qoHN+1PdVvpZLvlyIs/7tr1/jtH9fYNUGjdx62i5KQ2HWlYsOWxS4nmydaE+jI0tWWzHsyxYVEZjM7V1Wpu5ZzUbjxrOr0g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(66946007)(64756008)(6506007)(31696002)(6512007)(8936002)(8676002)(91956017)(66446008)(66476007)(76116006)(558084003)(86362001)(71200400001)(5660300002)(508600001)(6486002)(122000001)(2906002)(38100700002)(316002)(31686004)(2616005)(36756003)(38070700005)(186003)(53546011)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NDI3SjkzQlZFMC91VXFyaytyTng4K3JPMkY1ZTEreUFVR1o4THVlNGRtMDRa?=
 =?utf-8?B?QURZMkVGWG42aFRrT1VSQzk1c0NEYU1CV2x5c09wc1BEL1A4WWFRMkJ4UzBN?=
 =?utf-8?B?N0h1WXRwU0llZnlPU1NBaFFZci9CZHhuQ3NZZTl1TG1ZTjNYenEveUUvRGE4?=
 =?utf-8?B?bEhzaHVNMjFHWGgyTGJKN1RQdVN4ZWtlZmRLeDNFMDFQWU5oWWFXM1ZYd2hJ?=
 =?utf-8?B?dy9abUR5ejA0QkhSdEVWSlgvS1VJUWQ2SWlLRTh3WHFJRjdUQngzT1dsY1Ex?=
 =?utf-8?B?U3pSQkJnbjRaWUxrZ09Xa1ZIdHhhOXVaUmxCK2tnMnFrUUQ4YllLRnU4SnNr?=
 =?utf-8?B?UThJdTRIbDBDL3E4VXNLZEltTUY5eWlRait0Ym1SQmIvWE53MUNpbHZaQzNj?=
 =?utf-8?B?dG5tTDB6N1M3ZjFmaTAyRVF0QmxUOUJWakpaUkVXVTF0Uk9iVTdGVnBHd0xl?=
 =?utf-8?B?YUlWT3Z4dVV5dXh3TDdJM2dFZjVDNXcwU0cxeEhZMi9YRVhtWDRZU2pjTDlZ?=
 =?utf-8?B?Q0p5OXJ3L3JzcUZmaVpXYUMwbjZiSWZKOUJBUEN3cjBvTEhhQ3BDektRblRp?=
 =?utf-8?B?eVJHak5GaVZmTHdHODAzS3QwdEQ3YWtHMXV6S0xpK0tpeWJtR05KYlZuTDRG?=
 =?utf-8?B?cSt1TU1pVDRVK2plZGp0R2Y1RHlnb1VobnR3ZWwvNjBZUTRFcmZuY1V4aEJr?=
 =?utf-8?B?UXlqV1ZoUkhndWI2cGZqbnBvWWJ3aHhwMEM5S1dKa1ZoZEVMMzRUcHdBY012?=
 =?utf-8?B?TVFHM3Yra3I1eUl0YTVaSkl1OVdpR2ZuclZqM1BRZkp3TlFzWlhzNGVRbkJr?=
 =?utf-8?B?eksrRzF2Sm1qTU9Zc0xURGV4dnhRRmJzem9sK3Y1S1c1N3U0RDFqY1NZdzhv?=
 =?utf-8?B?bnJIRnJGNTNmYlZYR01TWm9EemZXNElXTzNHQ3RBNVZsR1JIUzMwRnNJODFr?=
 =?utf-8?B?Qmd4bVFMbkxjQkZtM0xlNkZqVG5MakV3ejBIK0tUUCs0T0ZqdFg5a0dwTWwv?=
 =?utf-8?B?Nzc5MksxMnVRUVFLcXJqcTRXdllPaTlvZ0JLa2JNYkNISHlNYXlwZE8raEdZ?=
 =?utf-8?B?NHkydFpRZFIwWk5aOHF2clNFd0hMTUFET0xSTlM1SjBDdlEzMmR1ZjZTMXEx?=
 =?utf-8?B?OW1obUlEQ2lvWFN4UGNZTnM2OU5wNVFvZVhGS1J6Y0FNRnN3SlRUY1I4VHJz?=
 =?utf-8?B?SldhWmZzcW1ha2o5TWZDZTVKZWNhMVlZcVhsZzdTZVhTT3VWTis0TnhVWXRH?=
 =?utf-8?B?cE56Y0RSZ0wrWHowcForVkxjM0JvZVVraVY4YnUzc3g2QUczMTB4ZVN4Yzh2?=
 =?utf-8?B?T2tJTWFNdUcxN21kTmJ1Z3loeGpjWlZtMTlTTlVyTUlHOEx2bHUva25kcXNt?=
 =?utf-8?B?OXRocHZuOXcrV1RpVW9EYTRIS3lHYjAxUjVMVUszTkw3ZVMxYmNOeXVaV1dF?=
 =?utf-8?B?cllJbnF4UlY3dkEwR3JvRXRJUUJHSVYrQU4wT2lTZlVHNG1zSGpERE9YVW9Z?=
 =?utf-8?B?bmVlNTlOajBZZmxISy9ZamtvYUVaTnNQS0NuODBHeEpPWnFNdm11V1Y3dXhS?=
 =?utf-8?B?SlB0RnRKditibnlkMER6bFh3L1dweTUzUkpZZ0lEdXN4amZMbXhUTkNEN3Mv?=
 =?utf-8?B?elBtTTloM1E0WGpvS3k2VDFKUmhFUkZXSnFhZmpqd3ZGZENiQ1d4b1hjYjZF?=
 =?utf-8?B?aWRod2ttRDFPemNCSkFuMW5pTW1kNWR3Tll6b2hoTVF0QXBBQThkNTNLK3dx?=
 =?utf-8?B?R1ZtRmtPY1BNK3RFR2E3YzNmVTVFMXYxRmhsSU5ndEdEMXhxYnVQUHVtSlhK?=
 =?utf-8?B?aFZ5Y0NmL0R5RU9SeStVbUpxazlJKzdYcmFvekx4NERaaHk5VUFNUTRTK0J6?=
 =?utf-8?B?eDByaENxK2lhRjVVRGtLcjJMQXJ2TWgyc3ZzbEtZQzFhOWxqZTZvMlFIU2xV?=
 =?utf-8?B?d2dtbmorVHQzQy9uakJheUJ6YTF5QVJjUUJwK0NRNEsxZHd1ZnlQeFZybXNF?=
 =?utf-8?B?NURQM3kxSk1HamM3aVp4RGlqK3FJb0hFeWNiY2MxdW90UGlLSCtMRmNOanFT?=
 =?utf-8?B?ckdUVjUwWXUyaUI0OHBFeVJJbmpYam12NkQyZXRxaHI2a0V3YjluQTVXY2li?=
 =?utf-8?B?Wis2ZTAvbUFlNFRNWU5XMmFaQmNETXk2RFJTamZ2TmdJRzgrMWZWWXhQa2Vn?=
 =?utf-8?B?YXV3UXVjckVzYlhCTVBhWkJjZHhqVWlmdWxleS9YNEJoUk1LVE5udEdkdzRF?=
 =?utf-8?B?VDNJVklGNXhYN3AwcW9yS1ppMzJRRTdWbTZaL0VxejdlM3lUNXZneDZwVGJ2?=
 =?utf-8?B?UG5CY0RlMTNHYXNMK3dqUk9TUG5teGFnYWUvTFRhOE1SN3dxR284QTJKcWpz?=
 =?utf-8?Q?5lNJYyb7BLerwpsgs76cmN2WyE97kmuLJAt1e4FRIjMJW?=
x-ms-exchange-antispam-messagedata-1: 7yUikqcFnI6aRg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <B2630A0B56E8E14EABC4EC36F9B6014A@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f15f367d-d358-46c3-4486-08da3e1f8d72
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2022 07:24:06.3862
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U/vDumFPZg8C7X1hvjwn7ZWC0MSKMzmdDarJZO12m90itfMfIoEd7R7LBn+Jp7//ixTxMXEfu0MrllBxMaUI1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2733
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gNS8yNC8yMiAxNTowNSwgUGF2ZWwgUmVpY2hsIHdyb3RlOg0KPiAndmFsdWUnIGlzIGFsbG9j
YXRlZCBieSBzdHJkdXAoKSBpbiBnZXRzdHIoKS4gSXQNCj4gbmVlZHMgdG8gYmUgZnJlZWQgYXMg
d2UgZG8gbm90IGtlZXAgYW55IHBlcm1hbmVudA0KPiByZWZlcmVuY2UgdG8gaXQuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBQYXZlbCBSZWljaGwgPHByZWljaGxAcmVkaGF0LmNvbT4NCj4gUmV2aWV3
ZWQtYnk6IERhcnJpY2sgSi4gV29uZyA8ZGp3b25nQGtlcm5lbC5vcmc+DQo+IC0tLQ0KDQpMb29r
cyBnb29kLg0KDQpSZXZpZXdlZC1ieTogQ2hhaXRhbnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNv
bT4NCg0KLWNrDQoNCg0K
