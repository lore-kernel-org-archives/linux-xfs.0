Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BD04C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Nov 2021 03:19:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4409D6124D
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Nov 2021 03:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbhKEDWg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Nov 2021 23:22:36 -0400
Received: from esa1.fujitsucc.c3s2.iphmx.com ([68.232.152.245]:29412 "EHLO
        esa1.fujitsucc.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232155AbhKEDWf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Nov 2021 23:22:35 -0400
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Nov 2021 23:22:34 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1636082396; x=1667618396;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wL/p9A26xNAX5AgF/+fhiAFsXbfZcjcwbzs7/PDY4To=;
  b=ltFtRprRlQSL5O9rDm6ed6pNsikVylsV2/BSAGPRVyuKGgOuRNED+9Ac
   tqPZScDJhfXX0q2Vhuaw78kffeQfgs6tNKNtb6uzVtLWQ6RDF9X+lozLw
   NivAkjkrn+H/IW3l4sMxF9tGe7XbBmhgu8F+b+3ApFFAcTJBlbla/OxEw
   AsO9bYkIi2uK/USkrQ4EvpmNOGnk8kLYZEf98vI3Yy372XWV+jnXhT2gq
   89PfQmjS1f+3RT3iGK9+F4i0/Ap1hx4jnAK+eruy7Cnppr0p824kKupTk
   IyVq5chmdK5hdtmGgGuxiTlVtXBbtE8+iIoDSIXIMYywStm8RywapC25i
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10158"; a="51107226"
X-IronPort-AV: E=Sophos;i="5.87,210,1631545200"; 
   d="scan'208";a="51107226"
Received: from mail-os2jpn01lp2055.outbound.protection.outlook.com (HELO JPN01-OS2-obe.outbound.protection.outlook.com) ([104.47.92.55])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2021 12:12:43 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fLqPpxtWTVc9w3duX9IAtXtcmibG/0BO5Q8EA1sNy/fmG7M/PMsBwGIjUBD4TrJDq71JFFoeZwagguMugUywabJxJeaIIEmWhWLHX9KUpVkZKzYy/FNoUUlY0kLDvUByHr6+CKPuPo5luWG8Xd52oqZi4BYN3d96b7GCfDB2FlBxVAV6mwlkA/7k0mSEA5/0hTriwhplc1RT0yYkgsCfeDytefLVPYsJcIoemgzdmyj1E6yQa4lWH9bemzkDuCpT4WnRL4FrcIR+g/0QoUMS5qd7CjcxP8BDP1SwYPxBzbreKzThIJRvz0QwZFQ1Z7J1t6jO3nZ7R/OBDENZDNihgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wL/p9A26xNAX5AgF/+fhiAFsXbfZcjcwbzs7/PDY4To=;
 b=OPVV0UR35X3/V9ir4HKhnmeB8wHM98A8xRuwvuWaEcRL0MrbRYQZeRpnyle6cPQljkMarbmKgHF7Z8awUa7yjl0eG4YqLeRp8UnlBvsYbV78LHpjLW3nt9DpgwR1rMszcezFh/an3Yo/ZeaEtnEQg3tB7YXFhzwAAQ2unnuhhVnH9C8Ar0tnAfamY3o3DLizbv7sN6DZYixeYg1PTvRoIViiYz+QAcS2635aMFwNSKejxew4XQXLsKMafXthMkYsjmy95Pq0xUa3D7FdR570fezp7QKlOQurGOyezdy7uEpGQR/EdOKbAs5Q2OXVcyurSXpT5kkaw3H3aqajhd/faQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wL/p9A26xNAX5AgF/+fhiAFsXbfZcjcwbzs7/PDY4To=;
 b=c/ztjyLkfCoVgw8jHTuObp1niUIphL+POb4xbcnBWB+0nP8NA1117hVirqdK9sCgM3bS4IxkJlzKVjT3RCGzmdw1qysY0zX9tkb1wU5laroq4FyDxwKX9jGz7V3t75JA+lZX9I0r3jW+bItAkADbDYxxMu4u9Rxkus81LvjbXic=
Received: from TYCPR01MB6544.jpnprd01.prod.outlook.com (2603:1096:400:98::6)
 by TYAPR01MB2319.jpnprd01.prod.outlook.com (2603:1096:404:8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Fri, 5 Nov
 2021 03:12:39 +0000
Received: from TYCPR01MB6544.jpnprd01.prod.outlook.com
 ([fe80::35a5:c639:9f43:ee9]) by TYCPR01MB6544.jpnprd01.prod.outlook.com
 ([fe80::35a5:c639:9f43:ee9%8]) with mapi id 15.20.4669.013; Fri, 5 Nov 2021
 03:12:39 +0000
From:   "xuyang2018.jy@fujitsu.com" <xuyang2018.jy@fujitsu.com>
To:     "Darrick J. Wong" <djwong@kernel.org>,
        "allison.henderson@oracle.com" <allison.henderson@oracle.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>
Subject: Re: [PATCH v2] xfs: Fix the free logic of state in
 xfs_attr_node_hasname
Thread-Topic: [PATCH v2] xfs: Fix the free logic of state in
 xfs_attr_node_hasname
Thread-Index: AQHXzu44WrbqcpYgsEK54PEhRm7trav0SCoA
Date:   Fri, 5 Nov 2021 03:12:39 +0000
Message-ID: <6184A132.3090901@fujitsu.com>
References: <20211029185024.GF24307@magnolia>
 <1635750020-2275-1-git-send-email-xuyang2018.jy@fujitsu.com>
In-Reply-To: <1635750020-2275-1-git-send-email-xuyang2018.jy@fujitsu.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: be2e0c8e-ec95-490f-744f-08d9a00a2003
x-ms-traffictypediagnostic: TYAPR01MB2319:
x-microsoft-antispam-prvs: <TYAPR01MB2319B09EFDAE2D4C42822A02FD8E9@TYAPR01MB2319.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LfqniHUUCCER2h5PRTKPBRaKAsx4vqtLz0atf5urhs6XZW01OaBdPzQGGw+F9ZNJudnBmUXApnR7FukLvr4YQHVBC/6VYVTXwV3oQFEVI5JwJQndjlAgKOr0h0Co22WWrBPFuuYlRNXjWLna38Hp9wPHzwMJmi/b0p3fDu/fqlq2rz02dDe2NBQkwTlZCLKUlQ20pv7Pp8NdiL2Nt4/eOMQswyfNlhTYk2EVi1DcXlnF8y1hTTCXAFQz5DwPlgSv3n0+ukkVYBz0nEpJtGuzqJZFfgmCLfMjNP1hUJ8i98frEv/X4ZUsOhmGYLrxNsKj4N5BNuXSokB/ZOXW+G8YAR2fejfSWSvGF1ajqPY3odDO/ezWKKIlacreAx9ZauAhgjJCI7rMG//Rd2aQtLVVs7buGcvwdKRTPWQ3pbxyuzSDtl4JxA1PXZcCOFO/uE7FIZ97p43QSubYtI0/7XNW+n/0vf2+TvZZ1u/wV6IcOeD1rba1ZO/hs3KyplJsaRZAQIc4hut+U3QBq1R2CoJws544Neah88PJ/l1uN11+YZfP3qmi+zySyJcLc1hZ/OcORlKxWX6VeCYmehaFzy0LI1IALkrsumZGgJf4cbSTeXePEj0mE3LPEwfdsSYGMnE6hfyVx0ozkzmEIMh4+6J11813dceg9rOT6kYt6mO21H56mBuaX3tP+y8DLz2EBAerxOfOrOMVVHeswB5PGYEYLA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB6544.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(71200400001)(36756003)(38100700002)(2616005)(316002)(8676002)(6486002)(5660300002)(82960400001)(4326008)(66476007)(83380400001)(91956017)(66556008)(66946007)(64756008)(66446008)(76116006)(87266011)(6512007)(33656002)(85182001)(508600001)(2906002)(86362001)(122000001)(54906003)(110136005)(6506007)(186003)(38070700005)(8936002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?dXFOOCtHQisvcERKZCszdUkrbjhnaFBXQ0R5Tis2WnJoRHhOUlNUb2hvSzNB?=
 =?gb2312?B?eXRJZG9CSW1JMnVRckpvZFZ6SzVLZ3k0MWlZY0FEODU3Qm1iQ28zeG5KVnRZ?=
 =?gb2312?B?Tmx6Zm9rcTgvY1lyWUhsckczYU9mS2QrUlZYWGFGbTFuSkhLaFRHSVRpaFdL?=
 =?gb2312?B?RUI5d1B0ZUJyRkU2bVlqQlpZL0h3aHZ2MVpJNm52cEZlMnhpdDV2Yk1mc3FU?=
 =?gb2312?B?QTc1Nkt4emU3SkdMOW0rQ1MzZmRnWThlbmJJbUdXa3paTmREWlJkaHY5cVB1?=
 =?gb2312?B?bFZPOFV5eWJUang3QmZrUy9aR2czRUxIMU44bEhxTVMwazBjdUd3OGpOOURY?=
 =?gb2312?B?WTYwUlFGc2trM2h0Ly9sWEtxZi9tTjY3dHl1OWxKNFpvclpWdzY1b1gvRGhE?=
 =?gb2312?B?VVBmRExCdlMrem9tUms0TFRwdjhnTjlIUUYzSG5sT2VrQWhOTVRxaTNrUzlz?=
 =?gb2312?B?R1FsM2JhKzdKbnhBNEZ2TkNtWGd2RU1yaCtQbGtiaVBFVEtKem16NVZlOG1K?=
 =?gb2312?B?QVk1M1JqY1NFNmVuaGowMG5xU0lpWkFzRXJQM0c1TEtpNXNGNWM1TW9MWmZs?=
 =?gb2312?B?TVZ4QWNvY1g3dUE1Q256ZGNvVlEvVXVleXB0WVBCbHNwOGtzaEM3ZUplQVNy?=
 =?gb2312?B?cm9HV0x5SDhDNzlndy9RSkFEeU91RVlQdkJEYVFycEdGWHk5RG9WUEY3NTJP?=
 =?gb2312?B?YUwxMXJCeXFQSVcvOHFQandxM1dZUm5KNDc1TWFjVEYwdmNiWkhKbytUbXdZ?=
 =?gb2312?B?SEM1OHUwUmx2Ym85V28xYXAxTGl4aVFDZTYvUjV3SHVEUUJCaXI3OGEzdG9x?=
 =?gb2312?B?K042b2R1T0IvWU9MYXBManNVR29rd1p2Z3BXUUJWdFNJYzdSb0duUWo1RHhk?=
 =?gb2312?B?b0NCaHpDS09Rc1pINzVLckNYR2o3ZUE1allpdWhGUng0b1RtbHlLVjEyaGxW?=
 =?gb2312?B?Y01ja2VjenNveHRwMXQ5eEVUbVhrLzBMS2toOWJ0ek00Nms3SDZrSjFiOFdG?=
 =?gb2312?B?eDA4ZkR5MTF5UzdrUFpKOFZtcUR5UjNHeTJ3czNoQTBtbnhoRFEvdVFyUWsw?=
 =?gb2312?B?K1JpQVFjNHU0ejM3dkNKT284ZUdkOFQ5dncwUnN3UytPTFdwb21qeW9jK003?=
 =?gb2312?B?MDlZaEl0akhlRUdSK0ZvMTZjMnJHc0R0Ylp0YVZ3QUJzOGpscHl1dmtGQ1I2?=
 =?gb2312?B?Wm43YUhTdEJzdzV1cmpNU3h4NThEdkpLTW5rbng4SXJVUktNcWVkT3FiL25r?=
 =?gb2312?B?bHZ2QVVjMnZKZDQwZkVHczMrYitqVnhxcUV4NkxxRC9jUnFIR1ZVUDJ4R0Vx?=
 =?gb2312?B?aHJJMktoUElLK29JRGtsMGp5Vm9ONDNjRThWYjlwMXNxNkFmMk4vNkV0QTNz?=
 =?gb2312?B?K29lNEpsYVcrRTlXRUlsSFRmT0JzM2pCMEEzcWx0NkwvbVJZL3B3cE05Q1E1?=
 =?gb2312?B?YWFmZ3J4VDR0QUNjY1Z5THlZV3ZXcU9Ba0lqYkgxM2Eybnc3ejJOekJGM3Ar?=
 =?gb2312?B?b05TQUttODFIYkNnQmdDQ1dFRzl6bnp2SkhSdFdDYVdWSmY1ZXN6TFZ0b0po?=
 =?gb2312?B?djV1aXJRRUtoRlEreWhWK1FaVUNZYXZFZjFvUmpXc2dWS25rb1Y5YmZOVmdj?=
 =?gb2312?B?bWJubFljQWNvZEM4NmdFdXZ0MkZ0MVpMQkxQUm1vdnM5bXlNSTg1WFBaMk5B?=
 =?gb2312?B?cFlETEcxN1YzR1VuU3FDVGkrRWNBSCs0ekYrbFpaS1c4a0FGU1BRY09KMWlS?=
 =?gb2312?B?V3laRThCKzNmN1pmTFhITjFzSlVnVmlYRlhwdVJCVDFYQ2x6akF2VHNwQzZy?=
 =?gb2312?B?SjVyMUUzTmhPMEVxZ1phajR5c2pQbjdPZTdhamJwRFJsRWRpMkRsN0ViWEhz?=
 =?gb2312?B?M2JScjQ4aENQalREYWhpQW1VV2wySDBCbkFaV0tFUEU5OWlWejc2UExCWTVw?=
 =?gb2312?B?SHJ6cFpIb3pvbjV3NlRBRjIxcVI3Qk5WcXNaaFV4ckpxZ0trbFUyOWRsNEpw?=
 =?gb2312?B?ZEt3dmdKOVNYQTRuR29aTUhiaVYwdkQ4S3RySEdTNXQwTWluS2I5emxEcUtE?=
 =?gb2312?B?QU5ES0RwSkRrWkVmOHJ4cGdLTk1HT3I2bjBvYzhMWXNRTFMxdHpnRThhaVVt?=
 =?gb2312?B?cXVrM1VUek1OS1BFQ3VtWkczSWMrS0E2TFExQVBadFJUSEFONEVhdWNZSXFr?=
 =?gb2312?B?UkRJeWNIZDdxK3JTVi9JZ2ZUY2NhR0YzT0x1UnE1SWFuRGpWdlJaMThKaTM2?=
 =?gb2312?Q?gpMaCmZHG3o1ehyoK1NFUF4lCM+RdzJ9LVmU5wddaU=3D?=
Content-Type: text/plain; charset="gb2312"
Content-ID: <57CD73381205CB458E23CE3078F9637D@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB6544.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be2e0c8e-ec95-490f-744f-08d9a00a2003
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2021 03:12:39.6252
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y1vv/qhH4BOGqqcds8jNkJB1H7afjLiFxySu8TizbVe496JBw3kz4YGjPNkXIMULy2I6T1sbQ822244AHVijL9gAQ6LYIt1AMGS8F/7Q3ws=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB2319
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

SGkgRGFycmljaywgQWxsaXNvbg0KDQpBbnkgY29tbWVudD8NCg0KQmVzdCBSZWdhcmRzDQpZYW5n
IFh1DQo+IFdoZW4gdGVzdGluZyB4ZnN0ZXN0cyB4ZnMvMTI2IG9uIGxhc3Rlc3QgdXBzdHJlYW0g
a2VybmVsLCBpdCB3aWxsIGhhbmcgb24gc29tZSBtYWNoaW5lLg0KPiBBZGRpbmcgYSBnZXR4YXR0
ciBvcGVyYXRpb24gYWZ0ZXIgeGF0dHIgY29ycnVwdGVkLCBJIGNhbiByZXByb2R1Y2UgaXQgMTAw
JS4NCj4gDQo+IFRoZSBkZWFkbG9jayBhcyBiZWxvdzoNCj4gWzk4My45MjM0MDNdIHRhc2s6c2V0
ZmF0dHIgICAgICAgIHN0YXRlOkQgc3RhY2s6ICAgIDAgcGlkOjE3NjM5IHBwaWQ6IDE0Njg3IGZs
YWdzOjB4MDAwMDAwODANCj4gWyAgOTgzLjkyMzQwNV0gQ2FsbCBUcmFjZToNCj4gWyAgOTgzLjky
MzQxMF0gIF9fc2NoZWR1bGUrMHgyYzQvMHg3MDANCj4gWyAgOTgzLjkyMzQxMl0gIHNjaGVkdWxl
KzB4MzcvMHhhMA0KPiBbICA5ODMuOTIzNDE0XSAgc2NoZWR1bGVfdGltZW91dCsweDI3NC8weDMw
MA0KPiBbICA5ODMuOTIzNDE2XSAgX19kb3duKzB4OWIvMHhmMA0KPiBbICA5ODMuOTIzNDUxXSAg
PyB4ZnNfYnVmX2ZpbmQuaXNyYS4yOSsweDNjOC8weDVmMCBbeGZzXQ0KPiBbICA5ODMuOTIzNDUz
XSAgZG93bisweDNiLzB4NTANCj4gWyAgOTgzLjkyMzQ3MV0gIHhmc19idWZfbG9jaysweDMzLzB4
ZjAgW3hmc10NCj4gWyAgOTgzLjkyMzQ5MF0gIHhmc19idWZfZmluZC5pc3JhLjI5KzB4M2M4LzB4
NWYwIFt4ZnNdDQo+IFsgIDk4My45MjM1MDhdICB4ZnNfYnVmX2dldF9tYXArMHg0Yy8weDMyMCBb
eGZzXQ0KPiBbICA5ODMuOTIzNTI1XSAgeGZzX2J1Zl9yZWFkX21hcCsweDUzLzB4MzEwIFt4ZnNd
DQo+IFsgIDk4My45MjM1NDFdICA/IHhmc19kYV9yZWFkX2J1ZisweGNmLzB4MTIwIFt4ZnNdDQo+
IFsgIDk4My45MjM1NjBdICB4ZnNfdHJhbnNfcmVhZF9idWZfbWFwKzB4MWNmLzB4MzYwIFt4ZnNd
DQo+IFsgIDk4My45MjM1NzVdICA/IHhmc19kYV9yZWFkX2J1ZisweGNmLzB4MTIwIFt4ZnNdDQo+
IFsgIDk4My45MjM1OTBdICB4ZnNfZGFfcmVhZF9idWYrMHhjZi8weDEyMCBbeGZzXQ0KPiBbICA5
ODMuOTIzNjA2XSAgeGZzX2RhM19ub2RlX3JlYWQrMHgxZi8weDQwIFt4ZnNdDQo+IFsgIDk4My45
MjM2MjFdICB4ZnNfZGEzX25vZGVfbG9va3VwX2ludCsweDY5LzB4NGEwIFt4ZnNdDQo+IFsgIDk4
My45MjM2MjRdICA/IGttZW1fY2FjaGVfYWxsb2MrMHgxMmUvMHgyNzANCj4gWyAgOTgzLjkyMzYz
N10gIHhmc19hdHRyX25vZGVfaGFzbmFtZSsweDZlLzB4YTAgW3hmc10NCj4gWyAgOTgzLjkyMzY1
MV0gIHhmc19oYXNfYXR0cisweDZlLzB4ZDAgW3hmc10NCj4gWyAgOTgzLjkyMzY2NF0gIHhmc19h
dHRyX3NldCsweDI3My8weDMyMCBbeGZzXQ0KPiBbICA5ODMuOTIzNjgzXSAgeGZzX3hhdHRyX3Nl
dCsweDg3LzB4ZDAgW3hmc10NCj4gWyAgOTgzLjkyMzY4Nl0gIF9fdmZzX3JlbW92ZXhhdHRyKzB4
NGQvMHg2MA0KPiBbICA5ODMuOTIzNjg4XSAgX192ZnNfcmVtb3ZleGF0dHJfbG9ja2VkKzB4YWMv
MHgxMzANCj4gWyAgOTgzLjkyMzY4OV0gIHZmc19yZW1vdmV4YXR0cisweDRlLzB4ZjANCj4gWyAg
OTgzLjkyMzY5MF0gIHJlbW92ZXhhdHRyKzB4NGQvMHg4MA0KPiBbICA5ODMuOTIzNjkzXSAgPyBf
X2NoZWNrX29iamVjdF9zaXplKzB4YTgvMHgxNmINCj4gWyAgOTgzLjkyMzY5NV0gID8gc3RybmNw
eV9mcm9tX3VzZXIrMHg0Ny8weDFhMA0KPiBbICA5ODMuOTIzNjk2XSAgPyBnZXRuYW1lX2ZsYWdz
KzB4NmEvMHgxZTANCj4gWyAgOTgzLjkyMzY5N10gID8gX2NvbmRfcmVzY2hlZCsweDE1LzB4MzAN
Cj4gWyAgOTgzLjkyMzY5OV0gID8gX19zYl9zdGFydF93cml0ZSsweDFlLzB4NzANCj4gWyAgOTgz
LjkyMzcwMF0gID8gbW50X3dhbnRfd3JpdGUrMHgyOC8weDUwDQo+IFsgIDk4My45MjM3MDFdICBw
YXRoX3JlbW92ZXhhdHRyKzB4OWIvMHhiMA0KPiBbICA5ODMuOTIzNzAyXSAgX194NjRfc3lzX3Jl
bW92ZXhhdHRyKzB4MTcvMHgyMA0KPiBbICA5ODMuOTIzNzA0XSAgZG9fc3lzY2FsbF82NCsweDVi
LzB4MWEwDQo+IFsgIDk4My45MjM3MDVdICBlbnRyeV9TWVNDQUxMXzY0X2FmdGVyX2h3ZnJhbWUr
MHg2NS8weGNhDQo+IFsgIDk4My45MjM3MDddIFJJUDogMDAzMzoweDdmMDgwZjEwZWUxYg0KPiAN
Cj4gV2hlbiBnZXR4YXR0ciBjYWxscyB4ZnNfYXR0cl9ub2RlX2dldCBmdW5jdGlvbiwgeGZzX2Rh
M19ub2RlX2xvb2t1cF9pbnQgZmFpbHMgd2l0aCBFRlNDT1JSVVBURUQgaW4NCj4geGZzX2F0dHJf
bm9kZV9oYXNuYW1lIGJlY2F1c2Ugd2UgaGF2ZSB1c2UgYmxvY2t0cmFzaCB0byByYW5kb20gaXQg
aW4geGZzLzEyNi4gU28gaXQNCj4gZnJlZSBzdGF0ZSBpbiBpbnRlcm5hbCBhbmQgeGZzX2F0dHJf
bm9kZV9nZXQgZG9lc24ndCBkbyB4ZnNfYnVmX3RyYW5zIHJlbGVhc2Ugam9iLg0KPiANCj4gVGhl
biBzdWJzZXF1ZW50IHJlbW92ZXhhdHRyIHdpbGwgaGFuZyBiZWNhdXNlIG9mIGl0Lg0KPiANCj4g
VGhpcyBidWcgd2FzIGludHJvZHVjZWQgYnkga2VybmVsIGNvbW1pdCAwNzEyMGYxYWJkZmYgKCJ4
ZnM6IEFkZCB4ZnNfaGFzX2F0dHIgYW5kIHN1YnJvdXRpbmVzIikuDQo+IEl0IGFkZHMgeGZzX2F0
dHJfbm9kZV9oYXNuYW1lIGhlbHBlciBhbmQgc2FpZCBjYWxsZXIgd2lsbCBiZSByZXNwb25zaWJs
ZSBmb3IgZnJlZWluZyB0aGUgc3RhdGUNCj4gaW4gdGhpcyBjYXNlLiBCdXQgeGZzX2F0dHJfbm9k
ZV9oYXNuYW1lIHdpbGwgZnJlZSBzdGF0ZSBpdHNlbGYgaW5zdGVhZCBvZiBjYWxsZXIgaWYNCj4g
eGZzX2RhM19ub2RlX2xvb2t1cF9pbnQgZmFpbHMuDQo+IA0KPiBGaXggdGhpcyBidWcgYnkgbW92
aW5nIHRoZSBzdGVwIG9mIGZyZWUgc3RhdGUgaW50byBjYWxsZXIuDQo+IA0KPiBBbHNvLCB1c2Ug
ImdvdG8gZXJyb3Ivb3V0IiBpbnN0ZWFkIG9mIHJldHVybmluZyBlcnJvciBkaXJlY3RseSBpbiB4
ZnNfYXR0cl9ub2RlX2FkZG5hbWVfZmluZF9hdHRyIGFuZA0KPiB4ZnNfYXR0cl9ub2RlX3JlbW92
ZW5hbWVfc2V0dXAgZnVuY3Rpb24gYmVjYXVzZSB3ZSBzaG91bGQgZnJlZSBzdGF0ZSBvdXJzZWx2
ZXMuDQo+IA0KPiBGaXhlczogMDcxMjBmMWFiZGZmICgieGZzOiBBZGQgeGZzX2hhc19hdHRyIGFu
ZCBzdWJyb3V0aW5lcyIpDQo+IFNpZ25lZC1vZmYtYnk6IFlhbmcgWHU8eHV5YW5nMjAxOC5qeUBm
dWppdHN1LmNvbT4NCj4gLS0tDQo+ICAgZnMveGZzL2xpYnhmcy94ZnNfYXR0ci5jIHwgMTcgKysr
KysrKy0tLS0tLS0tLS0NCj4gICAxIGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCAxMCBk
ZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9mcy94ZnMvbGlieGZzL3hmc19hdHRyLmMg
Yi9mcy94ZnMvbGlieGZzL3hmc19hdHRyLmMNCj4gaW5kZXggZmJjOWQ4MTY4ODJjLi4yMzUyM2I4
MDI1MzkgMTAwNjQ0DQo+IC0tLSBhL2ZzL3hmcy9saWJ4ZnMveGZzX2F0dHIuYw0KPiArKysgYi9m
cy94ZnMvbGlieGZzL3hmc19hdHRyLmMNCj4gQEAgLTEwNzcsMjEgKzEwNzcsMTggQEAgeGZzX2F0
dHJfbm9kZV9oYXNuYW1lKA0KPiANCj4gICAJc3RhdGUgPSB4ZnNfZGFfc3RhdGVfYWxsb2MoYXJn
cyk7DQo+ICAgCWlmIChzdGF0ZXAgIT0gTlVMTCkNCj4gLQkJKnN0YXRlcCA9IE5VTEw7DQo+ICsJ
CSpzdGF0ZXAgPSBzdGF0ZTsNCj4gDQo+ICAgCS8qDQo+ICAgCSAqIFNlYXJjaCB0byBzZWUgaWYg
bmFtZSBleGlzdHMsIGFuZCBnZXQgYmFjayBhIHBvaW50ZXIgdG8gaXQuDQo+ICAgCSAqLw0KPiAg
IAllcnJvciA9IHhmc19kYTNfbm9kZV9sb29rdXBfaW50KHN0YXRlLCZyZXR2YWwpOw0KPiAtCWlm
IChlcnJvcikgew0KPiAtCQl4ZnNfZGFfc3RhdGVfZnJlZShzdGF0ZSk7DQo+IC0JCXJldHVybiBl
cnJvcjsNCj4gLQl9DQo+ICsJaWYgKGVycm9yKQ0KPiArCQlyZXR2YWwgPSBlcnJvcjsNCj4gDQo+
IC0JaWYgKHN0YXRlcCAhPSBOVUxMKQ0KPiAtCQkqc3RhdGVwID0gc3RhdGU7DQo+IC0JZWxzZQ0K
PiArCWlmICghc3RhdGVwKQ0KPiAgIAkJeGZzX2RhX3N0YXRlX2ZyZWUoc3RhdGUpOw0KPiArDQo+
ICAgCXJldHVybiByZXR2YWw7DQo+ICAgfQ0KPiANCj4gQEAgLTExMTIsNyArMTEwOSw3IEBAIHhm
c19hdHRyX25vZGVfYWRkbmFtZV9maW5kX2F0dHIoDQo+ICAgCSAqLw0KPiAgIAlyZXR2YWwgPSB4
ZnNfYXR0cl9ub2RlX2hhc25hbWUoYXJncywmZGFjLT5kYV9zdGF0ZSk7DQo+ICAgCWlmIChyZXR2
YWwgIT0gLUVOT0FUVFImJiAgcmV0dmFsICE9IC1FRVhJU1QpDQo+IC0JCXJldHVybiByZXR2YWw7
DQo+ICsJCWdvdG8gZXJyb3I7DQo+IA0KPiAgIAlpZiAocmV0dmFsID09IC1FTk9BVFRSJiYgIChh
cmdzLT5hdHRyX2ZsYWdzJiAgWEFUVFJfUkVQTEFDRSkpDQo+ICAgCQlnb3RvIGVycm9yOw0KPiBA
QCAtMTMzNyw3ICsxMzM0LDcgQEAgaW50IHhmc19hdHRyX25vZGVfcmVtb3ZlbmFtZV9zZXR1cCgN
Cj4gDQo+ICAgCWVycm9yID0geGZzX2F0dHJfbm9kZV9oYXNuYW1lKGFyZ3MsIHN0YXRlKTsNCj4g
ICAJaWYgKGVycm9yICE9IC1FRVhJU1QpDQo+IC0JCXJldHVybiBlcnJvcjsNCj4gKwkJZ290byBv
dXQ7DQo+ICAgCWVycm9yID0gMDsNCj4gDQo+ICAgCUFTU0VSVCgoKnN0YXRlKS0+cGF0aC5ibGtb
KCpzdGF0ZSktPnBhdGguYWN0aXZlIC0gMV0uYnAgIT0gTlVMTCk7DQo=
