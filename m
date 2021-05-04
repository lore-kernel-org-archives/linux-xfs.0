Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4456CC433B4
	for <linux-xfs@archiver.kernel.org>; Tue,  4 May 2021 07:05:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23C9B611AC
	for <linux-xfs@archiver.kernel.org>; Tue,  4 May 2021 07:05:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhEDHGA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 May 2021 03:06:00 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:51429 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbhEDHF5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 May 2021 03:05:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1620111903; x=1651647903;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vbPO8oJwF1f/Q7IbPZOEkaMz5V8DxoaLrSHJBS421CQ=;
  b=JGXVRBMwsc0WdaiCkt597i31vJzwhV7HoZ4n1w7fUIHRq06RGab0sECP
   Rb2FUGfS+MmN0jFHZBF9c5C92HC0Qk+5IjhG8ElMBH+P9PhStH8FyU62A
   85fCfrwzPxYC/xKYaMvUvjD6ZMwWTSdl56G6/LSy1AL+sdte3jcFIYB7B
   Bf83AM3J3POr2TLS+LEayN+Sv07gNsjm4ZMohBGXkAmHL7Qw4uQ57uZmS
   3F6pcSPKYD/XFKdoEw4idUSiTVSfD6pEvrZWUZLn9YpNpWgc0Y6FexdMQ
   DOuTFlID2l4kgT+t4OdVgdt4/HKcNgaU7bju462bJZO1mNDLaxWAu1Dt7
   Q==;
IronPort-SDR: RbBXxvfOl4mpSppacHgTTErgpuRpIWRjcdklAAGhbdnbD9HZLr+qXoGYW74hR3Mu90Qb9VSM7a
 SAuKMSNuSCFh7ZkHqDKW/tEef6qba+Ewq/J1+wPhtA0lAfu/LhX7yAb7KRyEzbFt4Ksgykwt/c
 qeC3biQzuIKU7foE5rBbvIu1cYym5xImE7frgHot5sDYDDikphRzjcE+5/oeeIaFMmCId4Ihw3
 zFFtZsjA4UNUCM70f6WQXigZPm2MxF7E6P5v9LHHQqRZ+eB2T+rj6fR3OKgH0qgAKCaLBbx2Iv
 F9k=
X-IronPort-AV: E=Sophos;i="5.82,271,1613404800"; 
   d="scan'208";a="167607218"
Received: from mail-dm6nam12lp2172.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.172])
  by ob1.hgst.iphmx.com with ESMTP; 04 May 2021 15:05:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kv9NrAjUJT5sXMOTxEReCZUKE1mOJ+f3H2U14/aLbJsZqx7+ItmcTcR3hPBuU1b9D648HlAdsvZALi7BSoWlpaLCN/LWKFGqerF2CnPHR7iwQ1FPccXwdsEtZe4VemBNqzWdLENhyCLzzlqDXiNPItX6/S1BgaKT8vNSp0Tw1Rvj38ksmRTuu4Ymg0QyL/zZwnF3H/I2EXk3svrjEUmC9XVZki95Y0k9psmgXGD/sJLYPYfxyQ37SOjbjfRbLvr29xE6+WkmVaveOLCVySQMf2UHT2MF8jQV3sLG5GUPU7VFqyYPqzKbnniHZszJGqEvzzNbVVGWQodU3w8zvhGXQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vbPO8oJwF1f/Q7IbPZOEkaMz5V8DxoaLrSHJBS421CQ=;
 b=W5orGaSsfS0YMyA//UKPAQ0EdjAUpWexARynbm3kMcnpI8jAi0tM90Sf7Td9D8G+znXi8fc7jfoCxVZBA6Tf/yXXdNVaMkeHPI2rpZqw+F5elPIzK7t2lo6V1+yQhIVOGWgHg5V+jbSy/y1VovorHBAWMdZ22GCScRD0PMEK6FfRKlo73pKo2oS7Ynila35Xy2E0CsANuzUwPLImRYhpIIyoD4gXy1g17rGH2LIdTMIxBdRMG8cqklIsaxyDs8ekY40w/upWXg8rlOKr9NL2BSC4f7l9YzSUrnb9Tg5DXGldIN82l49M6E6GzL3RSd01t4pc2ZSISE/0L7AFc7DXvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vbPO8oJwF1f/Q7IbPZOEkaMz5V8DxoaLrSHJBS421CQ=;
 b=pFD9+LNomgTNHaX/sygX4+hkP+bAQy9795CT1eCNg8LIHK1yTXiRcgNej6PboG1Q9tOfPjXeLVPY4+sjN0VOvLMqbWmMyru7fHRqZWQU3YkqB8uP/hjLBx5VRuumySCqoaD735xcI1bwNdsj6lMJoRbCmf2gqsGvLz0B43NGaUE=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BY5PR04MB6278.namprd04.prod.outlook.com (2603:10b6:a03:1eb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.41; Tue, 4 May
 2021 07:04:58 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::6873:3d64:8f9f:faf0]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::6873:3d64:8f9f:faf0%7]) with mapi id 15.20.4087.044; Tue, 4 May 2021
 07:04:58 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: mkfs is broken due to platform_zero_range
Thread-Topic: mkfs is broken due to platform_zero_range
Thread-Index: AQHXQHtrn6kxpk8Aekeo0QzSMfXNVarS5p6s
Date:   Tue, 4 May 2021 07:04:57 +0000
Message-ID: <93DE53DA-6101-472E-86C9-06C34AD64F92@wdc.com>
References: <20210504002053.GC7448@magnolia>
In-Reply-To: <20210504002053.GC7448@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [70.175.137.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a4bddbdb-4e2e-4041-349c-08d90ecaed86
x-ms-traffictypediagnostic: BY5PR04MB6278:
x-microsoft-antispam-prvs: <BY5PR04MB62781533421739B057D79B70865A9@BY5PR04MB6278.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yt96a6bhqPVpA6hMMtB1hPC46LRBvJso2N+8MiRlMEkqQEBI8QCnm/reXJsxJ8VvfflfyuuCwjgJ2mlvBhaRlR6a09qnFoyS1j6aUUBkGFF05+asE4z+xdwfx1lLN8INFZv+k+3GQfK3gIqI0Rb/4+rx9VjxgmGnronEai6b/lJfnljPe3BYGOnydMumvWi6PX0uBs3uN9F+MAzySjm9cDdXMo0xuzqxg0GwGUk3wHcluSE0KKOvqvJnybrI4UtwvSRGGbr3FDL/LZ9jmT85kR8BD+ISeCmHKX/65V1NbesIffUkkaYn8d0S1531w+H6XslPVNW2AJXZ/BtaxiMmdEvC3oirhMohI4SjeUI/OBuOw2bt2i4uvQzPJttHDDu9bnbBzA2s2nxCDWQiQ3G+HHrnzSNOQQ+2Wnl2boi17l3fFwmZJgaQkBiuUIPi/mSMpu+1rlovf4zItQsCGaEofolpeI/y6IWSE4Sjv/oF1TjnYOvVMfHgYP6J2A3X4Wmr/0Z6sr3PRR5ttHnrCANox6fxxBeazwlXTQA7/RuHUZvKez/xA5OOxq2fR1AMZY9H7t8f4ttuLprlf8TdR1OA7dVDXUqnhpv3tmpIJNkqU7aRSZOBw2nCk5m5aLejurL0nwXeflB6d5DzJ6IOgJNQmw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(396003)(366004)(376002)(346002)(6512007)(26005)(478600001)(6486002)(64756008)(5660300002)(66446008)(316002)(2906002)(186003)(71200400001)(83380400001)(36756003)(4326008)(76116006)(8936002)(66556008)(66476007)(6506007)(2616005)(4744005)(86362001)(122000001)(53546011)(54906003)(33656002)(38100700002)(8676002)(6916009)(66946007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?pE2n3Xn3d7X6lD+drhcLclB0ueLAyLJLw5nzgfGPn2CEcXve1X4yNFEZ8bQ1?=
 =?us-ascii?Q?2iOFzvp8R5uGc+TXTOtHFeQb0adDKc+CAeogSqaXuGMu8s1wznS/mhy/cYZO?=
 =?us-ascii?Q?eWcnLJmsHjDtKB+igk6+1A6bQQ6qIgTuozymKLf2yPL3cdx6UTGOXU4yKQwk?=
 =?us-ascii?Q?Mh0V6znGGB8Ofr6l/eFxH+CrU5P0qOp9MyRxXIqLAMLAqQgMiS/rcIXNQNeB?=
 =?us-ascii?Q?8tSxgcXfqdvCMpzD7jA6Vv5rLz+F6IZIVSpsygEfWXyIGe0fJ4kvhbr15KlV?=
 =?us-ascii?Q?BLrBxaE5pOD+Ulw1rcauyq4coZLl6ptttbSeMWqvNQb0irhh2+osiv6DchoQ?=
 =?us-ascii?Q?2YOWdrREz6vTzJFcsJF1uj5snQQLhF3FYVFP4TtTjRcQdA8lc5bzBvijZMke?=
 =?us-ascii?Q?3+VT/NPAGN7dxgLhPdqs0Ke+0Cv76nMsjYJ5FGV58f7GXVCS1QmkSjpy+WPv?=
 =?us-ascii?Q?UN43053wGzTsiJwP4nM2VaA9XpYaIZ1PWjOqUz+nXHac36GtAXWr7YkuKnvo?=
 =?us-ascii?Q?OoCod/OF28wIzzU6zV+EfX5AwvBU1d7nQbTKUIqV3cQYTDHyADC2Znu5ucEW?=
 =?us-ascii?Q?DuWNR8Y3ptNfOusFuWen0PZPw+AlL1+QUSxFj0uNbOwYEU4D75gozIr6kQMJ?=
 =?us-ascii?Q?g3MwuYgmkz7QvInvgZBIsQ4A1dzJ3VEznUt6eBP0NDa9fuPGI+c3Wc596ORv?=
 =?us-ascii?Q?YxB6q2LllxlErXpJKMI7zYTtuWc+gAugZrKuWVW97XVIdvgnGiSTx8cfg6vv?=
 =?us-ascii?Q?0LiMEffheuLJMxa/VxgqzbD1sMU6OGVOEVsPMiQxoJRALpmTQw2EjOfEiLya?=
 =?us-ascii?Q?ovAkCDK/RW4Nk/P5dUo/ozEy4wY/q9aWSLKFrRB5TLJpw/gH+krOq3LY/6ld?=
 =?us-ascii?Q?Hd/RScj60EU3rIc/hS9ImoDH4afB0BHTmCUVrfUS+pTo27xKEhrGxLiYKoLs?=
 =?us-ascii?Q?bum9Y+F3lTsKQ5cMXSeD9g7gee94p12Z3Pmv1ZMpniGjuaAFXsxBrd6SIRDP?=
 =?us-ascii?Q?FWlEW4elg9bkekk7QKheXXiEr0ptBLHXoV7lzJNjIqSD9O7MWqWf3gfx9oQB?=
 =?us-ascii?Q?/5uIOOVx8Y6kRLHz5kQIgkTA5DAyjFf/13vvJqEy3yoxbjCD8e6++2jIKBRu?=
 =?us-ascii?Q?RytdPRDog9I8znTn0wKVI+qzxTVoKyNeDb4/iLCJH6da7CpMRiDf3uX5g3gi?=
 =?us-ascii?Q?C4Hafp/sA4H58ysQH9Ktlc+R7322wsVweNzC7faHCSC+1vfGevRpQ+JXvTzm?=
 =?us-ascii?Q?8q+OuGd81d0owt/c+B66tVOmkwsgyvC5AoljjA7r0mnvs3QAagP2drPUdz1P?=
 =?us-ascii?Q?TPFbtzkwLaEsO2WoGVWFfwdE?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4bddbdb-4e2e-4041-349c-08d90ecaed86
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 May 2021 07:04:57.9444
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MYGzvpA5qd6XjjBWY7eKFosDNyEPGo26MmS8JNO5F1wQmQ7SdtrhFGb5Y612J6pPx+an4wn7Je3JKSbpKtRoSNma1d2aRj/fYBIhogj9Tjw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6278
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Darrick,

> On May 3, 2021, at 5:21 PM, Darrick J. Wong <djwong@kernel.org> wrote:
>=20
> In conclusion, the drive firmware is broken.
>=20
> Question: Should we be doing /some/ kind of re-read after a zeroing the
> log to detect these sh*tty firmwares and fall back to a pwrite()?

As pointed out by Christoph and Dave, this maybe a broken write zeroes issu=
es for NVMe device(not entirely sure).

We have seen such controllers and we add a quirk so that kernel can fallbac=
k to issuing writes instead of offloading write zeroes to controller so tha=
t usrspace don't have to deal with it.=20

Please send the report to Linux NVMe list that is mentioned in the Christop=
h's reply.=20




