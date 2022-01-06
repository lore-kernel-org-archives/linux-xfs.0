Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B149C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Jan 2022 01:55:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344450AbiAFBzK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Jan 2022 20:55:10 -0500
Received: from esa13.fujitsucc.c3s2.iphmx.com ([68.232.156.96]:15835 "EHLO
        esa13.fujitsucc.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344427AbiAFBzI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jan 2022 20:55:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1641434108; x=1672970108;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=u3fIXrxZk75z0LhDqJ/V4btD2ekMT650k6dGbxR9ezs=;
  b=umuyyzizF4agGcA9/aAtVlYfCt/H2J/kksVu8AM34vmhapSfN8g27TvC
   DK/4qms7c6fjEurESaBNXQLAe2v8v5uuew7WeXiL9CJywcj2hZhxlZdVr
   ZLeRiyJiqH1xdxSKqjyz6Sa9c//tGwFq0TrFvxQMbUdlkhrYEwGqcTihZ
   /e8OFTGlNRxtN7p3JMGRC+KEhXjQvC/COjPsSLCDjGxoSNrxwc7qX3Cs4
   eWu6H2CqtB2BtYQed0NOGN8ldugFgAlVGKGgcYW2FvohH8iG0MIS7UiWh
   a+2L3ERDPhm5AWqwcRckmkK/D3nr/KkyBbADh69jNAZGvxoMIiuoR+46/
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="46909655"
X-IronPort-AV: E=Sophos;i="5.88,265,1635174000"; 
   d="scan'208";a="46909655"
Received: from mail-os0jpn01lp2107.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.107])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 10:55:04 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gEsbFMRIK6DpDrcouU4RwN5EqRHzsP9r8sFrpVbC9i+2QcAQ0qaUdjMtpvIgumMxUdDa0TlSTdh+XZcm7CWle7YKWcjOMLhHibqu0j5u3/1pZPVDjU6YbQRvQ8EUlvbgB3Y6sA8cnbgLruv5ti8LNqwcoiTBEF1PpGHbM3M6PGAWV1FuARbnCuV3RsCZ5kSIXwNOqSkyH2zWMmzyk0QOipd4t1i9vbjt2355JYwqdjNkPzWgm0Cv2lKYRBCi1I0rz4enljHkRR2K6gjh31w7xWkTMfy5PtXhkPmC0O8bl0gC1K2ErYcx3DhRC+eogQv2DCbX/r9s6fRoMqkrpS0+kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u3fIXrxZk75z0LhDqJ/V4btD2ekMT650k6dGbxR9ezs=;
 b=ILmCYjfCJJE1VgiwdWGeQctRR7ddc7FVRzHwAa4zQ5K5z7iLy0E/zdW5b0xgHCdSBzooV0kKYbyYiz5r+PAfjUg0hLIjlE3Bk4lsDqRjbfqdXFQ+t/ywoqtXxlIvKOMGVWvoGf8yMxhGSe4dTyOzCvFEgHul72Ica9gMMxcUftJcrv3dcbXQoFkVpLD+YsGQq0ARnp02lUjSRkERUYO3Z9fR/eEZCc4doU6UxST4x7eap6J+Ushsum+i+jci8kgRzFg233GMIcjdx1nhNIWF5a6WDgE+nRkEZsv5AiUZgr2S7PvbcoxfS/af15X0prqPvORJQEPpVZF+wOcuWd8W/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u3fIXrxZk75z0LhDqJ/V4btD2ekMT650k6dGbxR9ezs=;
 b=pIdAO7ClYiskjTscgjwMd3jTQEan7kQQaTbC98Dvk23lcPZm9jCSV/rIYQkCvaljyNVFMPAbYIor+FAvrZI4yZFF+xcgmaZs9CVOJcbhc5lAWd3pMt72JWZqRqvj3AM8omleZzSegfX0+2Ocybcbveycu2Vm6+d/+krVPGIIuHg=
Received: from TYCPR01MB6544.jpnprd01.prod.outlook.com (2603:1096:400:98::6)
 by TY2PR01MB4572.jpnprd01.prod.outlook.com (2603:1096:404:11b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Thu, 6 Jan
 2022 01:55:01 +0000
Received: from TYCPR01MB6544.jpnprd01.prod.outlook.com
 ([fe80::9486:fa6e:4ac9:802b]) by TYCPR01MB6544.jpnprd01.prod.outlook.com
 ([fe80::9486:fa6e:4ac9:802b%4]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 01:55:01 +0000
From:   "xuyang2018.jy@fujitsu.com" <xuyang2018.jy@fujitsu.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     Eryu Guan <guaneryu@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH] xfs/220: fix quotarm syscall test
Thread-Topic: [PATCH] xfs/220: fix quotarm syscall test
Thread-Index: AQHYAm38rsSu9gd3zUeW/z4JXrGKFqxVNksAgAAF3AA=
Date:   Thu, 6 Jan 2022 01:55:01 +0000
Message-ID: <61D64C1C.1090602@fujitsu.com>
References: <20220105195352.GM656707@magnolia> <61D64732.3030505@fujitsu.com>
In-Reply-To: <61D64732.3030505@fujitsu.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aa5c2a40-1960-4487-f528-08d9d0b78d15
x-ms-traffictypediagnostic: TY2PR01MB4572:EE_
x-microsoft-antispam-prvs: <TY2PR01MB4572EF313D4437B1B6E6F2D8FD4C9@TY2PR01MB4572.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1y5+CnDpB9zZi/WQrqbIl5K6t/fMklCVW+QDN4Qs9hatlz2eF7s49MbryucP85RYpbnb0DBqA8cjWpHJ+sx5HDXb1a4ckkj41Oo9TUBGLHbgCG2rSgAvkvhv8MaeAwliKjkXgJlvQ4Pied0c7b0S5HZCDvRXsihTcEt7W4pxs5k8LcSjxvyiO+XzATbly1Vnlfhk9JfakPMRIQCrCexBfSu6D7cvrI9Q4t5rBPtKCVxccAFu6L80FiXv5kJySuRT0uNjseYTPc+nXgsECdM8LIAhrG9h+Gncu6GSSsNeC44Wx1J4uZ8ouUvUuTd5EMgx8jTIPnK0K0V0hlwSrpdvwJB5L+98XzzAcGRTS7qJhLOlcVn/OWAhav5BXc3spHy9buGDdxsDjXXjL8sLYTHIQ9sAPT/aCMRmM/fLCvJH2QGJ3WmgVwN2H90XiHQbPnta595bM5GAic6nmAnziFOjskX1H8HcsUdFsd/vb2agleEUtD9tNq4IYBucdnEnt+PE9n1hoN5+okgPhWHQ4gXs2jUm6HdPEvQ74DdpGQXMxynENcXMJd5oeMA8h5NRLaxxLgWcArF6p0cknD7LM3Vf17kcnjKzkghqIFamewBKbzqwc0f76gQrz/XxddMN3ZIjpV2QVIdhV90AmCh9AzjhcDQ7fqfKwGkVn0+OKAFMA93jWPKytktrICwSP+VhJKPzOTDke/Wb2JK+C9qpCf3Nuw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB6544.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(26005)(186003)(15650500001)(85182001)(316002)(6486002)(66556008)(64756008)(508600001)(66476007)(66446008)(66946007)(86362001)(2616005)(71200400001)(83380400001)(82960400001)(54906003)(38070700005)(91956017)(36756003)(2906002)(76116006)(87266011)(8676002)(6506007)(122000001)(33656002)(8936002)(38100700002)(6512007)(4326008)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?NVVxK3d4M2JiQWRhd3RpeHBzN2JWWDZPOGpQaURKUC9rMlJnSmp0cU9QU1Vi?=
 =?gb2312?B?T2NWbTQwR3NlZ3g4TXJXSlFkTzUvMUxycnRGKytmcWxVSGJvUXR6TkdhNHE4?=
 =?gb2312?B?TGVydk80QjN6UjQ1MElyMVMwRG5sdGw3bXpzT0ZldDRlZUduakVxUWNtbG92?=
 =?gb2312?B?ZjdGRWFxSTVIcExOQmNRVFg0S1Z0bXZrNFlWNm4xczJMMTdpOTRzZ1N0a0o0?=
 =?gb2312?B?eU94T3dYRW5TZVFRY0laMmhHcitZSWNFcUJnNnJVMVJabFExMWI4b09jY0tq?=
 =?gb2312?B?NloyZllpaE4rcUJ3YzBiM01iQXpMeUZHTXk3Sno2azBDK05IZnJzL29CbFVK?=
 =?gb2312?B?cW9QS2JWcUJ4WFhSVFZQb3E0bUhWUzJJLytYWThod1ZRdzRaQmZEZVVKNW1t?=
 =?gb2312?B?MUw1TFJoR0czbXVpUDhZeU1HWWl2TjFkZ1ExMnUraldzREVJWW9POHBsMk1U?=
 =?gb2312?B?UjhxNlpORUl3eEpzOGRWcThHeitVaVI5c3VpM1RleTNtb1NET1hueTNzNFYz?=
 =?gb2312?B?RlA4OXRBL2x1TWp4Um9iSnpiUFBqbUk4aGFmSEhQbVZlRTVQZzhmc2c5WjR0?=
 =?gb2312?B?ZC9qNStEcy8vY2tOWmtRMVlwUlpRVWZheW9XZDVPcEsxNEZHOTk2L3RlVWVz?=
 =?gb2312?B?WUxVbTNSUDdLSTAyaDAvcUZqRklmdTVINisrWi9lajBicnFQejJJeHdBbWlO?=
 =?gb2312?B?OE05RnhNbmFVSUJOY1hJcFd5NFBGTmZEeDdkd2UwNE5EdjJYQmNCdEF6eC84?=
 =?gb2312?B?RTE5cmFxNTQwOGdPeXlNT2tJTlVBbWN4ZGJ1UUxxVktPbHYvajV2UVBXMldB?=
 =?gb2312?B?SC9LTWY2elovVDZFblBWZWZsL1lJWUVZSHFUdnpoSFpaTVo3V0dHcXM2SHl4?=
 =?gb2312?B?aEs5RVhCM1U5WElrcXpmQU5COFArV2R3ckhjTmhDdkw3S2dZbkNCbk1KN1dP?=
 =?gb2312?B?SFZQdkJuS2pGMEQzRm45TlZtZStjS0FxcTR1MC85QUdGNHk0OFRLK3FxTDlh?=
 =?gb2312?B?NEtYSjdFMjVHazlHUlcxRE9MUUhITXZqQXZyZTJxK0M5dHBZNUMwbnlOK2FK?=
 =?gb2312?B?TGljWHd6cit4RGRoY205YStOOGZPbkZwK1BQZTdBM0x2Tlo2ZElaSWhtQlB5?=
 =?gb2312?B?T2NXVlM1cGlQQjZiTjVpZFBxNG56QWRxb05QVU5tNHZFcDFXdHlGK29MU0lr?=
 =?gb2312?B?Y0dIck9tTmVwSHBROENVR29ObVZTM2JadGo1VVAreDVyNEJqWDBBNTVobmRC?=
 =?gb2312?B?Skx5WlpsT1U5T0drMittVXVhYWY5dWM1clkrLzZmMWluQkpwaGk1eHZpNjVT?=
 =?gb2312?B?bXpjSWZHTm13UmtTQTZBcjRkM2IyMjkwdHFDRXYzdnNzcUtXMWp5dllxOGlz?=
 =?gb2312?B?cUVFbEFFT0RoVnQ4a2dMM3NpYUs4WHVjdUtDSEpPQ211b3loWFBRUVdEY0lk?=
 =?gb2312?B?OG1lSGlUeElWK3JmMEh0QXJ6alB2cFAwNFFCWWRpcFlTTi9RNjFQVkU3aExH?=
 =?gb2312?B?czhVT1pHMDJKQU9zd004WllMZVFpOEhRaFV0cExnRU5Ga0JTa0hvVjhTNmVF?=
 =?gb2312?B?WTB2MTRiWkRJK2xTSU9SNGx5SFE4aWN6clArenNwalBRUlBRR01POWRlWlJS?=
 =?gb2312?B?cW5kY3N1ZWIvZU9Jd3k1cC9QaFA4TE8zZ0dKNWM1MG1LSDU3VEhTdjVpTmRr?=
 =?gb2312?B?d3ppQk1vNmdKZzNkV3FSUU0rWjBEZXlmeTVtYnhsQkhKc2RrNHpBMitSdFly?=
 =?gb2312?B?a0ZPL0l1WUMyUDd0V0U1TGlxUnIrU1Z0TTcxQjIxMllhUml5ZDMrVnZqZjkz?=
 =?gb2312?B?UGJYQXFCQVpXNGZNSkFKYjVOSmxFc0NFQW5XZkhlSTEzSlkvaEp5Qm1aS3R2?=
 =?gb2312?B?V2JVK05vRlZ1RWJnZUNIKzJxRG5UVXNoYWhveW5qNjJkL0tteExPaWVEZTVh?=
 =?gb2312?B?c1hEaHRrMGhRZ3MxeU1TY3hBNHB4U2h3VnJjdFpoSDhWVmMyTEI5WW95MXFq?=
 =?gb2312?B?SWlTeDZML3Y3bjU3VVFIUytJWFR1ZnUzbHBiOHJ3UDZDN04rak9SOWRxWXQ2?=
 =?gb2312?B?eW5KbklVbXVtMVNRQ3ZHdGp1TXlybllzYUI0R3dITWlxNnpBclc4cWpOVm1q?=
 =?gb2312?B?T25kYVhYS1hTV1p1S0NROTN5VXJKakZhUVkxKzJlRzFNcEk0NlY2cGlTcklM?=
 =?gb2312?B?aE5xdXVkeDFmSzE5bHJqYngxVTNiTk10dXNpSGVKWWZtb1Q3KzFtQlphSUdi?=
 =?gb2312?Q?6AHMqC1rpvzrNeT73Fucpa+B+zu7j8aeLM7cHn6lCs=3D?=
Content-Type: text/plain; charset="gb2312"
Content-ID: <B9DDDF80D61A3946A319090F16E6BBAD@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB6544.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa5c2a40-1960-4487-f528-08d9d0b78d15
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2022 01:55:01.3785
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lFIyh75an46uR6wW/jNeyBs3B7Lr0JEEYM36PgcNU0JQgoTivBGfMk88UyzkQWUQJq/dH48Wg/GrqiR3Rphy26aAhItjBCRtPka5vUUdCMQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR01MB4572
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

b24gMjAyMi8xLzYgOTozNCwgeHV5YW5nMjAxOC5qeUBmdWppdHN1LmNvbSB3cm90ZToNCj4gb24g
MjAyMi8xLzYgMzo1MywgRGFycmljayBKLiBXb25nIHdyb3RlOg0KPj4gRnJvbTogRGFycmljayBK
LiBXb25nPGRqd29uZ0BrZXJuZWwub3JnPg0KPj4NCj4+IEluIGNvbW1pdCA2YmExMjVjOSwgd2Ug
dHJpZWQgdG8gYWRqdXN0IHRoaXMgZnN0ZXN0IHRvIGRlYWwgd2l0aCB0aGUNCj4+IHJlbW92YWwg
b2YgdGhlIGFiaWxpdHkgdG8gdHVybiBvZmYgcXVvdGEgYWNjb3VudGluZyB2aWEgdGhlIFFfWFFV
T1RBT0ZGDQo+PiBzeXN0ZW0gY2FsbC4NCj4+DQo+PiBVbmZvcnR1bmF0ZWx5LCB0aGUgY2hhbmdl
cyBtYWRlIHRvIHRoaXMgdGVzdCBtYWtlIGl0IG5vbmZ1bmN0aW9uYWwgb24NCj4+IHRob3NlIG5l
d2VyIGtlcm5lbHMsIHNpbmNlIHRoZSBRX1hRVU9UQVJNIGNvbW1hbmQgcmV0dXJucyBFSU5WQUwg
aWYNCj4+IHF1b3RhIGFjY291bnRpbmcgaXMgdHVybmVkIG9uLCBhbmQgdGhlIGNoYW5nZXMgZmls
dGVyIG91dCB0aGUgRUlOVkFMDQo+PiBlcnJvciBzdHJpbmcuDQo+Pg0KPj4gRG9pbmcgdGhpcyB3
YXNuJ3QgL2luY29ycmVjdC8sIGJlY2F1c2UsIHZlcnkgbmFycm93bHkgc3BlYWtpbmcsIHRoZQ0K
Pj4gaW50ZW50IG9mIHRoaXMgdGVzdCBpcyB0byBndWFyZCBhZ2FpbnN0IFFfWFFVT1RBUk0gcmV0
dXJuaW5nIEVOT1NZUyB3aGVuDQo+PiBxdW90YSBoYXMgYmVlbiBlbmFibGVkLiAgSG93ZXZlciwg
dGhpcyBhbHNvIG1lYW5zIHRoYXQgd2Ugbm8gbG9uZ2VyIHRlc3QNCj4+IFFfWFFVT1RBUk0ncyBh
YmlsaXR5IHRvIHRydW5jYXRlIHRoZSBxdW90YSBmaWxlcyBhdCBhbGwuDQo+Pg0KPj4gU28sIGZp
eCB0aGlzIHRlc3QgdG8gZGVhbCB3aXRoIHRoZSBsb3NzIG9mIHF1b3Rhb2ZmIGluIHRoZSBzYW1l
IHdheSB0aGF0DQo+PiB0aGUgb3RoZXJzIGRvIC0tIGlmIGFjY291bnRpbmcgaXMgc3RpbGwgZW5h
YmxlZCBhZnRlciB0aGUgJ29mZicgY29tbWFuZCwNCj4+IGN5Y2xlIHRoZSBtb3VudCBzbyB0aGF0
IFFfWFFVT1RBUk0gYWN0dWFsbHkgdHJ1bmNhdGVzIHRoZSBmaWxlcy4NCj4+DQo+PiBXaGlsZSB3
ZSdyZSBhdCBpdCwgZW5oYW5jZSB0aGUgdGVzdCB0byBjaGVjayB0aGF0IFhRVU9UQVJNIGFjdHVh
bGx5DQo+PiB0cnVuY2F0ZWQgdGhlIHF1b3RhIGZpbGVzLg0KPj4NCj4+IEZpeGVzOiA2YmExMjVj
OSAoInhmcy8yMjA6IGF2b2lkIGZhaWx1cmUgd2hlbiBkaXNhYmxpbmcgcXVvdGEgYWNjb3VudGlu
ZyBpcyBub3Qgc3VwcG9ydGVkIikNCj4+IFNpZ25lZC1vZmYtYnk6IERhcnJpY2sgSi4gV29uZzxk
andvbmdAa2VybmVsLm9yZz4NCj4+IC0tLQ0KPj4gICAgdGVzdHMveGZzLzIyMCB8ICAgMjggKysr
KysrKysrKysrKysrKysrKysrLS0tLS0tLQ0KPj4gICAgMSBmaWxlIGNoYW5nZWQsIDIxIGluc2Vy
dGlvbnMoKyksIDcgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL3Rlc3RzL3hmcy8y
MjAgYi90ZXN0cy94ZnMvMjIwDQo+PiBpbmRleCAyNDFhN2FiZC4uY2ZhOTBkM2EgMTAwNzU1DQo+
PiAtLS0gYS90ZXN0cy94ZnMvMjIwDQo+PiArKysgYi90ZXN0cy94ZnMvMjIwDQo+PiBAQCAtNTIs
MTQgKzUyLDI4IEBAIF9zY3JhdGNoX21rZnNfeGZzPi9kZXYvbnVsbCAyPiYxDQo+PiAgICAjIG1v
dW50ICB3aXRoIHF1b3RhcyBlbmFibGVkDQo+PiAgICBfc2NyYXRjaF9tb3VudCAtbyB1cXVvdGEN
Cj4+DQo+PiAtIyB0dXJuIG9mZiBxdW90YSBhbmQgcmVtb3ZlIHNwYWNlIGFsbG9jYXRlZCB0byB0
aGUgcXVvdGEgZmlsZXMNCj4+ICsjIHR1cm4gb2ZmIHF1b3RhIGFjY291bnRpbmcuLi4NCj4+ICsk
WEZTX1FVT1RBX1BST0cgLXggLWMgb2ZmICRTQ1JBVENIX0RFVg0KPj4gKw0KPj4gKyMgLi4uYnV0
IGlmIHRoZSBrZXJuZWwgZG9lc24ndCBzdXBwb3J0IHR1cm5pbmcgb2ZmIGFjY291bnRpbmcsIHJl
bW91bnQgd2l0aA0KPj4gKyMgbm9xdW90YSBvcHRpb24gdG8gdHVybiBpdCBvZmYuLi4NCj4+ICtp
ZiAkWEZTX1FVT1RBX1BST0cgLXggLWMgJ3N0YXRlIC11JyAkU0NSQVRDSF9ERVYgfCBncmVwIC1x
ICdBY2NvdW50aW5nOiBPTic7IHRoZW4NCj4+ICsJX3NjcmF0Y2hfdW5tb3VudA0KPj4gKwlfc2Ny
YXRjaF9tb3VudCAtbyBub3F1b3RhDQo+PiArZmkNCj4+ICsNCj4+ICtiZWZvcmVfZnJlZXNwPSQo
X2dldF9hdmFpbGFibGVfc3BhY2UgJFNDUkFUQ0hfTU5UKQ0KPj4gKw0KPj4gKyMgLi4uYW5kIHJl
bW92ZSBzcGFjZSBhbGxvY2F0ZWQgdG8gdGhlIHF1b3RhIGZpbGVzDQo+PiAgICAjICh0aGlzIHVz
ZWQgdG8gZ2l2ZSB3cm9uZyBFTk9TWVMgcmV0dXJucyBpbiAyLjYuMzEpDQo+PiAtIw0KPj4gLSMg
VGhlIHNlZCBleHByZXNzaW9uIGJlbG93IHJlcGxhY2VzIGEgbm90cnVuIHRvIGNhdGVyIGZvciBr
ZXJuZWxzIHRoYXQgaGF2ZQ0KPj4gLSMgcmVtb3ZlZCB0aGUgYWJpbGl0eSB0byBkaXNhYmxlIHF1
b3RhIGFjY291bnRpbmcgYXQgcnVudGltZS4gIE9uIHRob3NlDQo+PiAtIyBrZXJuZWwgdGhpcyB0
ZXN0IGlzIHJhdGhlciB1c2VsZXNzLCBhbmQgaW4gYSBmZXcgeWVhcnMgd2UgY2FuIGRyb3AgaXQu
DQo+PiAtJFhGU19RVU9UQV9QUk9HIC14IC1jIG9mZiAtYyByZW1vdmUgJFNDUkFUQ0hfREVWIDI+
JjEgfCBcDQo+PiAtCXNlZCAtZSAnL1hGU19RVU9UQVJNOiBJbnZhbGlkIGFyZ3VtZW50L2QnDQo+
PiArJFhGU19RVU9UQV9QUk9HIC14IC1jIHJlbW92ZSAkU0NSQVRDSF9ERVYNCj4+ICsNCj4+ICsj
IE1ha2Ugc3VyZSB3ZSBhY3R1YWxseSBmcmVlZCB0aGUgc3BhY2UgdXNlZCBieSBkcXVvdCAwDQo+
PiArYWZ0ZXJfZnJlZXNwPSQoX2dldF9hdmFpbGFibGVfc3BhY2UgJFNDUkFUQ0hfTU5UKQ0KPj4g
K2lmIFsgJGJlZm9yZV9mcmVlc3AgLWdlICRhZnRlcl9mcmVlc3AgXTsgdGhlbg0KPj4gKwllY2hv
ICJiZWZvcmU6ICRiZWZvcmVfZnJlZXNwOyBhZnRlcjogJGFmdGVyX2ZyZWVzcCI+PiAgICRzZXFy
ZXMuZnVsbA0KPiBJIHByZWZlciB0byBtb3ZlIHRoaXMgaW5mbyBvdXRzaWRlIHRoZSBpZi4gU28g
ZXZlbiBjYXNlIHBhc3MsIEkgc3RpbGwNCj4gY2FuIHNlZSB0aGUgZGlmZmVyZW5jZSBpbiBzZXFy
ZXMuZnVsbC4NCj4+ICsJZWNobyAiZXhwZWN0ZWQgbW9yZSBmcmVlIHNwYWNlIGFmdGVyIFFfWFFV
T1RBUk0iDQo+IERvIHlvdSBmb3JnZXQgdG8gYWRkIHRoaXMgaW50byAyMjAub3V0Pw0KU29ycnks
IF9nZXRfYXZhaWxhYmxlX3NwYWNlIGlzIGRlc2lnbmVkIGZvciBmcmVlIHNwYWNlLiBJIG1pc3Vu
ZGVyc3RhbmQgaXQuDQoNCkp1c3Qgb25lIG5pdCwgY2FuIHdlIG1vdmUgdGhlICRzZXFyZXMuZnVs
bCBjb2RlIG91dHNpZGUgdGhlIGlmPw0KDQphZnRlcl9mcmVlc3A9JChfZ2V0X2F2YWlsYWJsZV9z
cGFjZSAkU0NSQVRDSF9NTlQpDQpkZWx0YT0kKCgkYWZ0ZXJfZnJlZXNwIC0gJGJlZm9yZV9mcmVl
c3ApKQ0KZWNobyAiYmVmb3JlX2ZyZWVzcDogJGJlZm9yZV9mcmVlc3A7IGFmdGVyX2ZyZWVzcDog
JGFmdGVyX2ZyZWVzcCwgZGVsdGE6DQokZGVsdGEiID4+ICRzZXFyZXMuZnVsbA0KaWYgWyAkZGVs
dGEgLWxlIDAgXTsgdGhlbg0KICAgICAgICBlY2hvICJleHBlY3RlZCBtb3JlIGZyZWUgc3BhY2Ug
YWZ0ZXIgUV9YUVVPVEFSTSINCmZpDQoNCkJlc3QgUmVnYXJkcw0KWWFuZyBYdQ0KPiANCj4gDQo+
IEFsc28sIEkgdHJ5IHRoaXMgcGF0Y2ggYW5kIGFkZCBzb21lIG91dHB1dCBhYm91dCBkZWx0YS4N
Cj4gSXQgc2VlbXMgYmVmb3JlX3ZhbHVlIGdyZWF0ZXIgdGhhbiBhZnRlciB2YWx1ZS4NCj4gDQo+
ICAgICNNYWtlIHN1cmUgd2UgYWN0dWFsbHkgZnJlZWQgdGhlIHNwYWNlIHVzZWQgYnkgZHF1b3Qg
MA0KPiBhZnRlcl9mcmVlc3A9JChfZ2V0X2F2YWlsYWJsZV9zcGFjZSAkU0NSQVRDSF9NTlQpDQo+
IGRlbHRhPSQoKCRiZWZvcmVfZnJlZXNwIC0gJGFmdGVyX2ZyZWVzcCkpDQo+IGVjaG8gImJlZm9y
ZTogJGJlZm9yZV9mcmVlc3A7IGFmdGVyOiAkYWZ0ZXJfZnJlZXNwLCBkZWx0YTogJGRlbHRhIj4+
DQo+ICRzZXFyZXMuZnVsbA0KPiBpZiBbICRkZWx0YSAtZ2UgMCBdOyB0aGVuDQo+ICAgICAgICAg
ICBlY2hvICJleHBlY3RlZCBtb3JlIGZyZWUgc3BhY2UgYWZ0ZXIgUV9YUVVPVEFSTSINCj4gZmkN
Cj4gDQo+IE1PVU5UX09QVElPTlMgPSAgLW8gZGVmYXVsdHMNCj4gYmVmb3JlOiAyMTI4MDgwNDg2
NDsgYWZ0ZXI6IDIxMjgwODA4OTYwLCBkZWx0YTogLTQwOTYNCj4gDQo+IA0KPiBCZXN0IFJlZ2Fy
ZHMNCj4gWWFuZyBYdQ0KPj4gK2ZpDQo+Pg0KPj4gICAgIyBhbmQgdW5tb3VudCBhZ2Fpbg0KPj4g
ICAgX3NjcmF0Y2hfdW5tb3VudA0K
