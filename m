Return-Path: <SRS0=ttQi=5Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 166AFC2BA2B
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 23:22:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83A5420857
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 23:22:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Sb/5kHM8";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="m6JEvxNS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgDHXWP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Apr 2020 19:22:15 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:12676 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgDHXWP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Apr 2020 19:22:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1586388136; x=1617924136;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Vx3U3p9jRHO/IcWV4UnV48tK/HNLN7td7BmO0GIgIdk=;
  b=Sb/5kHM82f1ikWwykxsQODF0LBME8zfAvjYocGG9W1VY5SgtrMgy4Dv5
   79MzH3zfcYTYXl4EUk2zQJa6O+dHCI2r3zh5MXz0F7u+RGGSBQNkQPJJr
   PkQOv8RLn550ZzvNUWa+/O8e79KyKhXThHo4eKB4pLRnqGUpIvMv9SRJv
   Od2lW8qLR/V+e6dCxyNRJQ3HSOy1uKd4hZozdNr50Sb7L4gAzAoAu6UWt
   UI/sfmF6CRtKmssvy3fse+x3WnoucHix6z72nG9v2eWoEksMuWwmjxaP+
   PY5u9NenZNjxUnNQcQU7HOZpk9leLXBEQXfSnZuy5jO9/sdkqSagN4Jod
   A==;
IronPort-SDR: 9nEIq2qCjv9YfRl3VsSMeoU4D1z7SMnkenU/e7QHS1Y3qbESnid9cXWayuXj8b1HWAuget0xgk
 9vzYQ9pMDPX1eVDFUQIGUls8HUNxPWu64hWxRg3vZTqGUbJyHkEl+wrkFgHai/+CnT9GHT8Yka
 /q0oavZR3+P2BEctA/juNdt4hnn1J1JKy05pO0OQPgvtzBtmH/etxAWr4rjKr/eUo6WD78tH4D
 tHJIyXc7P4a0w7LxDn3BN2o1D1iVpy/jpixTo4FeyIxLgt8a0ZDn0ZFlbNGiglI7cQaTidIHUZ
 S7g=
X-IronPort-AV: E=Sophos;i="5.72,360,1580745600"; 
   d="scan'208";a="136357878"
Received: from mail-co1nam11lp2175.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.175])
  by ob1.hgst.iphmx.com with ESMTP; 09 Apr 2020 07:22:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YNROnYg2P924SOR99tnH3g++SBbmfw/sUrJMEot48m4Xly2tfqZv5yGPC67Mgc4ZEguZPSXJLiYFZeStpIQXkC4jdtjT4YfQoHrdzA2fbREUAzWkBULbrJufZx420x/oeUITmc7L/rNVRbzLE++Uri4M7BzJcCIz7sYtEnjc0gumBZ/6CtUxXBv6m5tCAIC9ztNadjSYI4AQI9edkXrI/tzEs/Q3H0gmlnfAjy/9p4VafaAh7fjKogDLxv1uko8QJXGFW/Ss2wDx8QOw6jspUIHO4CfBEAb965/HSKww1D/xANvclCVilsN7XQ7cKRzJC7jOf3H28g09rD9TgLvBKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UgUkLXs00ds+m3rs2o4K1qAY1LMGdqlt+Ada35mOBN8=;
 b=MqIPgHiywTHZ8kzhgu95WhhplbBhwiKjYyH3elY3dn78aG5gt9cys2PAfHbeTgd7ziSMxt7mOzoT7EwVN6W7g5UjaUKnJyXeE4OL1N3Hnzdyyx3lIFhV01WcokY1CJNV5T8B3xJnqPbi5kKOM9G2JYoVUz6fIFOm1mC2DMaTnkkQvP+etn6bkRbKwypCXclVkv0S62Yacbidz36Pc2lb7dTfrSiUGy1YLZeMT4nDhN+8sIyldQotQ/BfJ1/qDk1s3/nxBxyWK13SMHByfrASpv0wPAMIdnK54lWQOlUUBLiERC3lnxFkmEaA1KvE+xk3mPOq4llBbJU8RIRhntgN5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UgUkLXs00ds+m3rs2o4K1qAY1LMGdqlt+Ada35mOBN8=;
 b=m6JEvxNSkbjsfkIYJTQf1uq97j6fxLTv+caDEIRiLCT/fLjI9tMcO5fSzAI72a0Y7p+9zOJBDrkMCY6caieEDKOgC3CL2Ur2KRVcYn1eOpokz3y4JOX+3FiAzTcq1gJXdcjY5i54YbjzcacIuK+7GmWD5jMS6ij1szvbjh5UqQ0=
Received: from SN6PR04MB4973.namprd04.prod.outlook.com (2603:10b6:805:91::30)
 by SN6PR04MB4127.namprd04.prod.outlook.com (2603:10b6:805:35::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.20; Wed, 8 Apr
 2020 23:22:10 +0000
Received: from SN6PR04MB4973.namprd04.prod.outlook.com
 ([fe80::b0f4:a811:73dd:6c4e]) by SN6PR04MB4973.namprd04.prod.outlook.com
 ([fe80::b0f4:a811:73dd:6c4e%5]) with mapi id 15.20.2878.018; Wed, 8 Apr 2020
 23:22:10 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "hch@lst.de" <hch@lst.de>,
        "danil.kipnis@cloud.ionos.com" <danil.kipnis@cloud.ionos.com>,
        "jinpu.wang@cloud.ionos.com" <jinpu.wang@cloud.ionos.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] xfs: use block layer helper for rw
Thread-Topic: [PATCH 2/2] xfs: use block layer helper for rw
Thread-Index: AQHWDGqdc+93DLJ+GUSwv5Qr3eKT0A==
Date:   Wed, 8 Apr 2020 23:22:09 +0000
Message-ID: <SN6PR04MB497355EBD0AF4F633B84A0B186C00@SN6PR04MB4973.namprd04.prod.outlook.com>
References: <20200406232440.4027-1-chaitanya.kulkarni@wdc.com>
 <20200406232440.4027-3-chaitanya.kulkarni@wdc.com>
 <BY5PR04MB690075C16A97151A6216948CE7C30@BY5PR04MB6900.namprd04.prod.outlook.com>
 <BYAPR04MB4965A3A58D804CCE9892266686C30@BYAPR04MB4965.namprd04.prod.outlook.com>
 <20200407232749.GC24067@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chaitanya.Kulkarni@wdc.com; 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6d5c64ca-89a6-4910-dda8-08d7dc13a989
x-ms-traffictypediagnostic: SN6PR04MB4127:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB4127086A6588E3D5F695EB7586C00@SN6PR04MB4127.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0367A50BB1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4973.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(376002)(136003)(39850400004)(366004)(346002)(396003)(5660300002)(71200400001)(6916009)(316002)(33656002)(26005)(478600001)(54906003)(4326008)(55016002)(81166007)(8676002)(66556008)(86362001)(9686003)(7696005)(186003)(66946007)(91956017)(8936002)(66476007)(52536014)(81156014)(64756008)(2906002)(6506007)(66446008)(76116006)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ldnCVoE0WKJpBsXctmmRvJX9pY9EFYwkdJdOd1pgq8+iJmStbM0VFcxOACB8897dlJ9DfmkGY7uJVyuFHqBHeTnHg/v+YLyCGHpv+JF7ve8fqsvYLTAymJzOqUEhe362niee8KFrxIz8mytiYfRq/mvuIUZkB/M+aTz2qDoTUgv3xM3IgHMc8aYA19kI7DHI+X/NKycBO7Ey9A6HqWc/Iw7gALSZV9F8SHk4teoUm7kO2LtMYwblS2KC+QmSnzFTRCkJwFa6Y5k39QmvR2x+iXR7ogRDK2QpMUNpiDdnqZ4ZgMIhFKdSqkY8YHr7y/iZlAowGKvzBaJXJcSYTi1FGnRm3/+BAXZ5tqHAMFJ5/4rlkeW+xmn6vl0cBIb1Cy5eGTcDtKY/rE3FRiBm9gbkfQlmoB8KoFqr6z4EBZoTXP1gvFLEn4MKSotwseh1Qz2U
x-ms-exchange-antispam-messagedata: UjK8uODn8HB90SR4X8X/7DD/npaM61miF4Cd/VzWvgeRqI05nszkRQwKtz2Ww4FSzV7miUG1/v+tKEC5Oy1OFon12h8WzE449rBIblfOzj80o4PZxgfKDRXTN+1YUIwjx0TDzWRp3Bs/8Y7x8m5JeQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d5c64ca-89a6-4910-dda8-08d7dc13a989
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2020 23:22:10.1229
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yrAYJmVexZAgsa0hybp5r9Jg9k5gWaR2TFmIKtbjJVXmETk7qYiNJa5qW1tksZjrnYfzSt5CxpVJZzZandc+Hh10BOq/hZPNwFVp1SgjC8k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4127
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

(+cc Christoph)=0A=
=0A=
On 04/07/2020 04:28 PM, Dave Chinner wrote:=0A=
> On Tue, Apr 07, 2020 at 08:06:35PM +0000, Chaitanya Kulkarni wrote:=0A=
>> On 04/06/2020 05:32 PM, Damien Le Moal wrote:=0A=
>>>> -=0A=
>>>>> -	do {=0A=
>>>>> -		struct page	*page =3D kmem_to_page(data);=0A=
>>>>> -		unsigned int	off =3D offset_in_page(data);=0A=
>>>>> -		unsigned int	len =3D min_t(unsigned, left, PAGE_SIZE - off);=0A=
>>>>> -=0A=
>>>>> -		while (bio_add_page(bio, page, len, off) !=3D len) {=0A=
>>>>> -			struct bio	*prev =3D bio;=0A=
>>>>> -=0A=
>>>>> -			bio =3D bio_alloc(GFP_KERNEL, bio_max_vecs(left));=0A=
>>>>> -			bio_copy_dev(bio, prev);=0A=
>>>>> -			bio->bi_iter.bi_sector =3D bio_end_sector(prev);=0A=
>>>>> -			bio->bi_opf =3D prev->bi_opf;=0A=
>>>>> -			bio_chain(prev, bio);=0A=
>>>>> -=0A=
>>>>> -			submit_bio(prev);=0A=
>>>>> -		}=0A=
>>>>> -=0A=
>>>>> -		data +=3D len;=0A=
>>>>> -		left -=3D len;=0A=
>>>>> -	} while (left > 0);=0A=
>>> Your helper could use a similar loop structure. This is very easy to re=
ad.=0A=
>>>=0A=
>> If I understand correctly this pattern is used since it is not a part of=
=0A=
>> block layer.=0A=
>=0A=
> It's because it was simple and easy to understandi, not because of=0A=
> the fact it is outside the core block layer.=0A=
>=0A=
> Us XFS folks are simple people who like simple things that are easy to=0A=
> understand because there is so much of XFS that is so horrifically=0A=
> complex that we want to implement simple stuff once and just not=0A=
> have to care about it again.=0A=
>=0A=
=0A=
Agree, new code should not make things complicated, in fact initial =0A=
version had existing code pattern see [1].=0A=
=0A=
Before answering the questions I think I should share few=0A=
considerations I went through based on the code and requirement :-=0A=
=0A=
1. The new helper is needed since XFS and rnbd is doing the same thing,=0A=
    i.e. mapping bios to buffer. The helper should be a part of the=0A=
    block layer library function, as most of the library APIs are=0A=
    present there, which are used by the file systems/network drivers.=0A=
    e.g. blkdev_issue_zeroout().=0A=
    Summery :- Something like blkdev_issue_zeroout() is a good=0A=
               candidate since it is used in file-systems and network=0A=
               drivers.=0A=
=0A=
2. Figure out the common code which can be moved to the library and=0A=
    identify what different APIs are needed for the functionality to=0A=
    save code duplication :-=0A=
    A. Synchronous version is needed for XFS. (without cond_resched() I=0A=
       need to fix this in next version).=0A=
    B. Asynchronous version is needed for network drivers rnbd as=0A=
       mentioned in the cover letter.=0A=
    Summery :- Add sync and async version.=0A=
=0A=
3. Whenever a new function is added to the library we should not=0A=
    invent new patterns and follow the same style which is present in=0A=
    the library code i.e. in blk-lib.c, unless new API can't fit into=0A=
    current pattern. This is needed since block layer maintainers=0A=
    might complain about new design pattern.=0A=
    Summary :- See if new API can be designed identical to=0A=
               blkdev_issue_zeroout() and __blkdev_issue_zero_pages().=0A=
=0A=
4. Look at the existing user(s) (XFS) of the library (blk-lib.c)=0A=
    API(zeroout) and how it is using existing API if any. For XFS,=0A=
    which uses existing library function :-=0A=
     "fs/xfs/xfs_bmap_util.c:65: blkdev_issue_zeroout(target->bt_bdev"=0A=
    Summery :- Since the  library(blk-lib.c) API(zeroout) is used in=0A=
               the user(XFS) that means it is acceptable to use similar=0A=
               code pattern.=0A=
=0A=
5. Design a new API in the library based on the existing code. That :-=0A=
    A. Matches the code pattern which is present in the library, already=0A=
       used in the exiting user and reuse it.=0A=
    B. Make sure to have identical APIs parameter to keep the=0A=
       consistency whenever it is possible. (including APIs prototype=0A=
       parameters name etc).=0A=
    Summary :- Add blkdev_issue_rw() -> blkdev_issue_zeroout() and=0A=
                 __blkdev_issue_rw() -> __blkdev_issue_zero_pages().=0A=
=0A=
Regarding the number of lines, this is not aimed at having less number=0A=
of lines in XFS only than existing xfs_rw_bdev() (although it does=0A=
that), but since it is a library API it will save overall=0A=
lines of the code (e.g. XFS 60 and rnbd ~50 and future uses) in the=0A=
users like fs and network drivers similar to existing zeroout API.=0A=
=0A=
Please correct me if I'm wrong in any the above considerations, given=0A=
that I'm not a XFS developer I'd like to make sure new API pattern is=0A=
acceptable to both XFS developers and the block layer maintainers.=0A=
=0A=
I'm not stuck on using this pattern and I'll be happy to re-use the=0A=
xfs_rw_bdev() pattern if block layer maintainers are okay with it.=0A=
=0A=
I'll wait for them to reply.=0A=
=0A=
>> The helpers in blk-lib.c are not accessible so this :-=0A=
>=0A=
> So export the helpers?=0A=
>=0A=
>> All above breaks the existing pattern and code reuse in blk-lib.c, since=
=0A=
>> blk-lib.c:-=0A=
>> 1. Already provides blk_next_bio() why repeat the bio allocation=0A=
>>      and bio chaining code ?=0A=
>=0A=
> So export the helper?=0A=
>=0A=
>> 2. Instead of adding a new helper bio_max_vecs() why not use existing=0A=
>>       __blkdev_sectors_to_bio_pages() ?=0A=
>=0A=
> That's not an improvement. The XFS code is _much_ easier to read=0A=
> and understand.=0A=
>=0A=
>> 3. Why use two bios when it can be done with one bio with the helpers=0A=
>>      in blk-lib.c ?=0A=
>=0A=
> That helper is blk_next_bio(), which hides the second bio inside it.=0A=
> So you aren't actually getting rid of the need for two bio pointers.=0A=
>=0A=
>> 4. Allows async version.=0A=
>=0A=
> Which is not used by XFS, so just adds complexity to this XFS path=0A=
> for no good reason.=0A=
>=0A=
> Seriously, this 20 lines of code in XFS turns into 50-60 lines=0A=
> of code in the block layer to do the same thing. How is that an=0A=
> improvement?=0A=
>=0A=
> Cheers,=0A=
>=0A=
> Dave.=0A=
>=0A=
=0A=
=0A=
[1] Initial draft (for reference only) :-=0A=
struct bio *__bio_execute_rw(struct block_device *bd, char *buf, =0A=
sector_t sect,=0A=
                               unsigned count, unsigned op, unsigned opf,=
=0A=
                               gfp_t gfp_mask)=0A=
{=0A=
          bool vm =3D is_vmalloc_addr(buf) ? true : false;=0A=
          struct request_queue *q =3D bd->bd_queue;=0A=
          unsigned int left =3D count;=0A=
          struct page *page;=0A=
          struct bio *new_bio;=0A=
          blk_qc_t cookie;=0A=
          bool do_poll;=0A=
=0A=
          new_bio =3D bio_alloc(gfp_mask, bio_max_vecs(left));=0A=
          bio_set_dev(new_bio, bd);=0A=
          new_bio->bi_iter.bi_sector =3D sect;=0A=
          new_bio->bi_opf =3D op_opf | REQ_SYNC;=0A=
=0A=
          do {=0A=
                  unsigned int offset =3D offset_in_page(buf);=0A=
                  unsigned int len =3D min_t(unsigned, left, PAGE_SIZE - =
=0A=
offset);=0A=
=0A=
                  page =3D  vm ? vmalloc_to_page(buf) : virt_to_page(buf);=
=0A=
                  while (bio_add_page(new_bio, page, len, offset) !=3D len)=
 {=0A=
                          struct bio *curr_bio =3D new_bio;=0A=
=0A=
                          new_bio =3D bio_alloc(gfp_mask, bio_max_vecs(left=
));=0A=
                          bio_copy_dev(new_bio, curr_bio);=0A=
                          new_bio->bi_iter.bi_sector =3D =0A=
bio_end_sector(curr_bio);=0A=
                          new_bio->bi_opf =3D curr_bio->bi_opf;=0A=
                          bio_chain(curr_bio, new_bio);=0A=
=0A=
                          cookie =3D submit_bio(curr_bio);=0A=
                  }=0A=
=0A=
                  buf +=3D len;=0A=
                  left -=3D len;=0A=
          } while (left > 0);=0A=
=0A=
          return new_bio;=0A=
}=0A=
EXPORT_SYMBOL(__bio_execute_rw);=0A=
=0A=
int bio_execute_rw_sync(struct block_device *bd, char *buf, sector_t sect,=
=0A=
                          unsigned count, unsigned op, unsigned opf,=0A=
                          gfp_t gfp_mask)=0A=
{=0A=
          unsigned int is_vmalloc =3D is_vmalloc_addr(buf);=0A=
          struct bio *bio;=0A=
          int error;=0A=
=0A=
          if (is_vmalloc && op =3D=3D REQ_OP_WRITE)=0A=
                  flush_kernel_vmap_range(buf, count);=0A=
=0A=
          bio =3D __bio_execute_rw(bd, sect, count, buf, op, opf, mask);=0A=
          error =3D submit_bio_wait(bio);=0A=
          bio_put(bio);=0A=
=0A=
          if (is_vmalloc && op =3D=3D REQ_OP_READ)=0A=
                  invalidate_kernel_vmap_range(buf, count);=0A=
=0A=
          return error;=0A=
}=0A=
EXPORT_SYMBOL_GPL(bio_execute_rw_sync);=0A=
=0A=
=0A=
