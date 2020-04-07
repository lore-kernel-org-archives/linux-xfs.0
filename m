Return-Path: <SRS0=E2x8=5X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F677C2D0EC
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 20:06:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D76D2074B
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 20:06:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Fl4c+od7";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="iUHMxJuS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgDGUGj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Apr 2020 16:06:39 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:5596 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbgDGUGi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Apr 2020 16:06:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1586289998; x=1617825998;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=d+/nrgYu/E+TbyecInClXpIgzb1ndWYZ/TB+/6Pu/+Y=;
  b=Fl4c+od77HUdHbipLUUNAcTJXTjhXL+Qexg1/cDk6mi12i40iIjx6mIM
   FFOmkxT5oPv4MmgXUywmVJcOUBb7ataeJL4e9DJygJ99lE+tgpPUvE4VT
   K7Mzs25ergNmwBi7OxXpPJQCX/SK4Eq5Sjzn9lW5zWreEZc4dLgU8RRv5
   TaZKT0k3zPLULZwe+1LCiG6U+wKyZPS+ZVlN52F8WLWMzzUV2itVP3R9K
   S2VQ7vmq5PXu8Gkhut2m5XcLyQC3f+NSSRi7IMkXSrypfJJBz/LgKNJfi
   DrZ4IJvNGH4xvWUyYRhIDbjLZ01QcQD8mGLZmZqh2mTSnh/HBS5Ilu4xt
   A==;
IronPort-SDR: Wz05/zSymVuCdGy6X4ESfvPUrPXAuq4Tv3SaCOplaz4sF4smFMiH/hmt8HN5POTPWBvKCiOQ5s
 VaQCdmJ2OnqUz9kOFRjI00KV5AIy99Z3FTZqLoIKRVc2manOfIAVV8+lriGCpPYmIEnZzCkuJy
 Qu1HTDeoNTjVziyhMSk4wTPqrHmI0Lp40k4/0PJKArnxF+/tFVfWY2syjkaChpFRbK+JP/UFLU
 3sNLGGes9P9WTJlumTjKMpA5sWbxVjtnO+2ALB3rWa/E4Eggw2euW0XFczDo6nfL1XnwY9ZCfk
 GaM=
X-IronPort-AV: E=Sophos;i="5.72,356,1580745600"; 
   d="scan'208";a="136258196"
Received: from mail-bn8nam11lp2174.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.174])
  by ob1.hgst.iphmx.com with ESMTP; 08 Apr 2020 04:06:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GgTXU50F/XR/dK4w3GPydxupqDGZ34cK2NgjoObRmgNQFV7qaRbbh2G/1Xxov6XOAu+gvY8IjVmbiaR0p4dSZbAvKuf9mBHqU1oLo1mp5vxrWP+NaOHN10AsCBFR2e5ZhFI7EQgKGbhJS3HvtaHjpIIDj+QbTE2gnup94Jq1HB+4xqgc/zmwv9DO8BlyFRjmEnsCc4TirPrYdzjUX3J/LYlzDW2SyH9NpDrBSLJxe/FsfkEzWJjsQuFnmbEziUCq5Nqg5Hyyhed8zY8VlQ1oH3zTjbfDfgJyf9Ef7lDPc7MFLo47VYoMgfEsg4c1hhyUcnPIP0TN+r0dJWRNBjjjiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=63G0SnwI9I0qB9y+7fqfY6ivyLJ4i3yvY8gVHqiplmk=;
 b=jCbJwsSgqshsSc+w7+kcDbB//wS3BhQNgtnfo+aGZ6i9yHrvy+evlaZzfEQfSzbqAVl/HoZCXQH+eK9cjTCr+WzIYwMwvAV1mSdiUVXYoIpAgL1bcVQoe9gNSktapoXA6+QbDSY1fUoyWdKR9SwW46J5BXxXlHYGFAYJRZudxevNZ4kDhMpm4XwRd6m28Lz5edKuyHJsp90VpXCtAxu+pHdyRuLQ37va7cZoIgKNAzlpMFg35YxJ8/oEWcHp+HU/KDP1OZfXqCjoFyIKz3O4qwfsySyeso8/vxwaUw036pcc1W5l7SM4VTWRlcZSfKpphklpUvW/Lu4mdtMdHhzwIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=63G0SnwI9I0qB9y+7fqfY6ivyLJ4i3yvY8gVHqiplmk=;
 b=iUHMxJuS2AeXK3C/UYbIB9/bfmeAbX9O3J73lKecvxG9N6+0QIPev/iiPg1h9zTzGjVpZ+xHXnoRKQxfjPK+g99AMSnHdPsvTMl1z7x6AEnOGQIwZE3euJytTHNz7l5+aZUaw+y2LjMVybYsyudHup3zFyEca0zbOz6eEtvKaWs=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB5398.namprd04.prod.outlook.com (2603:10b6:a03:ce::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.20; Tue, 7 Apr
 2020 20:06:36 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::d826:82b2:764f:9733]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::d826:82b2:764f:9733%7]) with mapi id 15.20.2878.018; Tue, 7 Apr 2020
 20:06:36 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
CC:     "hch@lst.de" <hch@lst.de>,
        "danil.kipnis@cloud.ionos.com" <danil.kipnis@cloud.ionos.com>,
        "jinpu.wang@cloud.ionos.com" <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCH 2/2] xfs: use block layer helper for rw
Thread-Topic: [PATCH 2/2] xfs: use block layer helper for rw
Thread-Index: AQHWDGqdc+93DLJ+GUSwv5Qr3eKT0A==
Date:   Tue, 7 Apr 2020 20:06:35 +0000
Message-ID: <BYAPR04MB4965A3A58D804CCE9892266686C30@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20200406232440.4027-1-chaitanya.kulkarni@wdc.com>
 <20200406232440.4027-3-chaitanya.kulkarni@wdc.com>
 <BY5PR04MB690075C16A97151A6216948CE7C30@BY5PR04MB6900.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chaitanya.Kulkarni@wdc.com; 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f16d745b-7319-48d4-6f0e-08d7db2f2cfb
x-ms-traffictypediagnostic: BYAPR04MB5398:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB53986CDC49531D3F6ED7754A86C30@BYAPR04MB5398.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 036614DD9C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(376002)(346002)(366004)(396003)(39850400004)(136003)(66446008)(6506007)(81166006)(53546011)(66476007)(81156014)(8936002)(316002)(8676002)(66556008)(66946007)(71200400001)(64756008)(478600001)(54906003)(86362001)(110136005)(4326008)(33656002)(76116006)(2906002)(7696005)(186003)(5660300002)(26005)(9686003)(52536014)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Awqdf07jo7MbP6Vb1ekDSe+yvCtk15esNpQLqzy3WdEyO2MERYawePyVRP7yVxNsUbaYQ8xRLGmo9JCInUECT0ulipeh85nHxlta0A45oSwc9WnknTLlx9eJTa/W3hC1bYQi/WvKfauMN5CC3L3ekuHZzC5ZCN0YENOgNyrjl9+nKXagieUiyrEk0ZVMvH8unbgQqt5UYblceT+xRcaAy5TfXywdypzQso+G9MnbZ0VW/sAURGwFq4fNr41Ch4WzPFSTMKQ6h/wnc/D38vpWEBD2E6tiKb8sIqX+BE+aF6lW5jUqykBFnbB9XmYptVAZjdCo/t+okKNTSy+k500gNILZBvff9DuYFqkcUXMHk5btgqm/tyOzJ8HoCKNOCRPYgi9tMQCrEYA6hytKkmjThFKnPh9lb/NxlCsZ99r3FcL9z18pBnKlxsdOn8Ee8ZvI
x-ms-exchange-antispam-messagedata: LeX4ZW/wX6yla2zwgvhk1Y1RuGfXkMHWuBi/Qnaf5EttqJDnbbFZfe7DhrUYDlOAGCbTXUyv/9zyDqMRampJUqzoCh/CQtNYOBbtX53s6M8GFkkjQ9yPJ6x+cxE8KTwVlmLo6boYhy+jTPyviw1zZA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f16d745b-7319-48d4-6f0e-08d7db2f2cfb
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2020 20:06:35.9076
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wLHDCoac/RDqMOAdcrbK01WfCpv0ZaINiv5wlq+bRQ8euXLL9RxeYZMvgcvc2x47eybI/n5ZlNv3GebGTvXyuRfTP5TSc28QezwW/Fs/Gwg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5398
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 04/06/2020 05:32 PM, Damien Le Moal wrote:=0A=
>> -=0A=
>> >-	do {=0A=
>> >-		struct page	*page =3D kmem_to_page(data);=0A=
>> >-		unsigned int	off =3D offset_in_page(data);=0A=
>> >-		unsigned int	len =3D min_t(unsigned, left, PAGE_SIZE - off);=0A=
>> >-=0A=
>> >-		while (bio_add_page(bio, page, len, off) !=3D len) {=0A=
>> >-			struct bio	*prev =3D bio;=0A=
>> >-=0A=
>> >-			bio =3D bio_alloc(GFP_KERNEL, bio_max_vecs(left));=0A=
>> >-			bio_copy_dev(bio, prev);=0A=
>> >-			bio->bi_iter.bi_sector =3D bio_end_sector(prev);=0A=
>> >-			bio->bi_opf =3D prev->bi_opf;=0A=
>> >-			bio_chain(prev, bio);=0A=
>> >-=0A=
>> >-			submit_bio(prev);=0A=
>> >-		}=0A=
>> >-=0A=
>> >-		data +=3D len;=0A=
>> >-		left -=3D len;=0A=
>> >-	} while (left > 0);=0A=
> Your helper could use a similar loop structure. This is very easy to read=
.=0A=
>=0A=
If I understand correctly this pattern is used since it is not a part of =
=0A=
block layer.=0A=
=0A=
The helpers in blk-lib.c are not accessible so this :-=0A=
1. Adds an extra helper bio_max_vecs().=0A=
2. Adds a new macro howmany which is XFS specific and doesn't=0A=
    follow usual block layer macros naming.=0A=
3. Open codes bio chaining.=0A=
4. Uses two bio variables for chaining.=0A=
5. Doesn't allow to anchor bio which is needed in async I/O scenario.=0A=
=0A=
All above breaks the existing pattern and code reuse in blk-lib.c, since =
=0A=
blk-lib.c:-=0A=
1. Already provides blk_next_bio() why repeat the bio allocation=0A=
    and bio chaining code ?=0A=
2. Instead of adding a new helper bio_max_vecs() why not use existing=0A=
     __blkdev_sectors_to_bio_pages() ?=0A=
3. Why use two bios when it can be done with one bio with the helpers=0A=
    in blk-lib.c ?=0A=
4. Allows async version.=0A=
=0A=
