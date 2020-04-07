Return-Path: <SRS0=E2x8=5X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 309D5C2BA1A
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 20:01:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C958E2074B
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 20:01:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="JqDK/rpz";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="L+H22BYu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbgDGUBr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Apr 2020 16:01:47 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:29457 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgDGUBr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Apr 2020 16:01:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1586289706; x=1617825706;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=6M3/dZpGCcWzYp54VgsQo0rqLLmnkfLbv2mXce7SgRM=;
  b=JqDK/rpzd8AIckSS4hdvaS/O9wEKsWQNYz7t4P3l+M8A6wIJGi1wG/qW
   Xf1B6ZLS9u+S0Glo041glGPdKjRwwmaye66nGBjtwq6z4BAo6XJZRU3/o
   tHYavWkn6v41RRrFbaI1sInktPv9wTXRRpYvQNQ1iCkojSGrnXEu0vn2R
   EUjj8lAglweEPMEH6CNWyZd++r7CoZuHwu1f163AJn2L13+UvCXy4eyVw
   5bLcI8t3sbOqnHVzeeydyuaXOrNMPRhmqusgtMeWqVKD01oj0hlR6yO/w
   5VXHpPnW706ipsAqoGI7Dh6s1PC5MFMaaOnWrkOQNkPRtWW9rEaQfnmFw
   A==;
IronPort-SDR: uPBRakMhOYjnCCNuRoS5884N6e0mWhMWrcnhdEHQdP6+Y8ao/RSLZCw2QMVS6hz6pNPKQHsF6c
 6ucy0FZYaAAqz3EOfEmtG/yyD5H7L7wwAznUG/IXzImOsU2kdkHO4CT8S0ECn4ohaf7tSxJumk
 qjDAj+3KRZEUK4LhlVaR1+EV53WY7JtgE5s0jTQ4J+nflbk5OAQuLGsf9RjqdUJfvgqWLPAHyW
 m68LrY9tPLS9NEa8vieH+KfLladfnWYuq/oA549qyycv2MUOzp6DyW6Y9dVd1yKxzFzWVe66oN
 0bM=
X-IronPort-AV: E=Sophos;i="5.72,356,1580745600"; 
   d="scan'208";a="243350664"
Received: from mail-bn7nam10lp2103.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.103])
  by ob1.hgst.iphmx.com with ESMTP; 08 Apr 2020 04:01:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dvl3B/DMMTtBtYX37HKy2d3s2A13nrvTeBH+Lt3wIYw0WQ/GUjnQT4xA5tNqJOaGsY9Vqg0WRaZPlrrugyIzGHaxHLTc4gi9fiqPngCotUw0prPdGJCu0HbR57rCn7cURzk5CpJf1+65Z2CFJsauFrsrEPNf90Zk8bvICM9d5plJhmSNblGRoHdTSF7vZMCuM/wWKqaRL3m9/zM4a8j31vhVddlOLIu+HEgK16Ve0BuqKGDU5DaHEccILOiqwA1Na0UaFfhV/53MT4vxkR5gJWCEiTOELNZIvf1o2B/QU/1N87MU40mvqR9qCZWrqG2W54oazCv7nMX78vI+A0EWIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y2zRKmlAYqFFlkvAtLYr7gi2IfcG+1Bv10COz9WzhGs=;
 b=bmICj7n8dluqTk+OHG8wYEKWO0WtzKbGr/NCrvDX3jAJPkb5DfGS1o2Yh9bPwslklgv8xwzRWjSoDCnWSIvbrs5XQoemiy260TGaTZ1sqTeKaXIOBM7D679RzcphUNekbQ7QxtvA0H8bFL741EBJGZwdbd8dPAtga1JcqkNRkhGGMH45W8fYE3vl0qtUQbdiC/ZW7nNIt+6Y65dqx4yDbT3LUh+vXAyYeUfnZAvURayUw9FBurDlHbH4Ex1PmUQu+z4KibvDIazFxTCfTuZ/rEc7CsC7GWp3GsOsk0aQzJ+rF9ewv/a4LIaWwx4zE2MRTlJUnOaFcYfvy5ePpeOEdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y2zRKmlAYqFFlkvAtLYr7gi2IfcG+1Bv10COz9WzhGs=;
 b=L+H22BYuzxDexjwlZj9Soh6kTYFo3t/JGm/ehT1L3tYzJiQu5ggKAl/kkuvEYhOqUyiY+09idcTYG2UPxE1TIaifOP7oCdYDgQnzpBCOVh7M8bkiu0UmW/5cowIV5pQ/BmD451sLqEkob6SBH1uq/aQssGDTj9noqnXvJB9CVXw=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB5398.namprd04.prod.outlook.com (2603:10b6:a03:ce::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.20; Tue, 7 Apr
 2020 20:01:43 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::d826:82b2:764f:9733]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::d826:82b2:764f:9733%7]) with mapi id 15.20.2878.018; Tue, 7 Apr 2020
 20:01:43 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
CC:     "hch@lst.de" <hch@lst.de>,
        "danil.kipnis@cloud.ionos.com" <danil.kipnis@cloud.ionos.com>,
        "jinpu.wang@cloud.ionos.com" <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCH 1/2] block: add bio based rw helper for data buffer
Thread-Topic: [PATCH 1/2] block: add bio based rw helper for data buffer
Thread-Index: AQHWDGqU2VOdDv5MT0CIzYNqFKOYsg==
Date:   Tue, 7 Apr 2020 20:01:43 +0000
Message-ID: <BYAPR04MB4965D18A3BE7602AFBC4951D86C30@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20200406232440.4027-1-chaitanya.kulkarni@wdc.com>
 <20200406232440.4027-2-chaitanya.kulkarni@wdc.com>
 <BY5PR04MB6900AB25131618BED40BE0E0E7C30@BY5PR04MB6900.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chaitanya.Kulkarni@wdc.com; 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c28f02b1-e22e-4bba-a263-08d7db2e7eb8
x-ms-traffictypediagnostic: BYAPR04MB5398:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB5398EB10DC2E32A431252D5486C30@BYAPR04MB5398.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 036614DD9C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(39850400004)(136003)(396003)(376002)(366004)(346002)(186003)(7696005)(2906002)(9686003)(52536014)(26005)(55016002)(5660300002)(71200400001)(66946007)(66556008)(316002)(8676002)(64756008)(478600001)(66446008)(66476007)(81156014)(8936002)(6506007)(81166006)(53546011)(33656002)(4326008)(76116006)(54906003)(86362001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o49+K4ihyVfK/78X8xqK4hERcu6zRqxMR9IYI7cAfAAyNllB7Un1xswtWKXcG4ZslG8aDMC9+wVc6wt3r2bThKRFSosxGuboY9KPGx+JEXlC57dPLvGGDSB3uGdvjGIBA4fXBW7c3ooM8D0P/r2r1H5+ySQQdbqHj3IfAzXnqK+i8Cu/BeqP7PIPh+SFgdSqzcAWGHqt2cAL6fVASUgimxse9s2ymQtClvDJLYH+xSEFkB6WJ3iWxvZGyUPKiPYws/BziDpWMg+9VchgzsQX4XCtLpr1bF4won89FC/h9IbKgho0qRNDFi+tnFOLmz080CkKBdjTl1BHIP0zz8ehMwg3j6xK8srMDk3d6LfrDuSIHtvSOjUWS8dt8DbCoed2R+PtG+L22Vj/BD/a4lyHxiQh1uOyf3yfZ0w9D5Hgm2TkJNiT2/1f/PHDTObp3gf0
x-ms-exchange-antispam-messagedata: RTfUXwcQ8qtfcwHEXmtx9hLgbo6sn2bRuMaNMWGcVKO74ypZG93BJ3795PzBhYKoAGxjuoKbBPLv/cqkFxRr7aYaCtOT9m420W3iPFniqXR6Mo99MKLA6IyC2UMnY0tw72RSRrYUORh/h+ZOfjLoBA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c28f02b1-e22e-4bba-a263-08d7db2e7eb8
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2020 20:01:43.5543
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lkJAwWIxNIc+gxCtNZdG8lbX6/lzsM97s4p0i1pAaMBG9Dtj/pClQn+sTm68lZ3tAWkU7/x9zssmC3lFxHA8sZwnev+4qdRVKi9olv3dhhg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5398
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 04/06/2020 05:28 PM, Damien Le Moal wrote:=0A=
> On 2020/04/07 8:24, Chaitanya Kulkarni wrote:=0A=
>> One of the common application for the file systems and drivers to map=0A=
>> the buffer to the bio and issue I/Os on the block device.=0A=
>=0A=
> Drivers generally do not do this. At least not lower ones (scsi, nvme, et=
c). I=0A=
> guess you are referring to DM drivers. If yes, better be clear about this=
.=0A=
> Also, "the buffer" is a little unclear. Better qualify that.=0A=
>=0A=
Agree most drivers deals with sg_list. Right now there is only one such=0A=
an example I know which is rnbd as driver as it is mentioned in the=0A=
cover-letter references.=0A=
> Another thing: "to map the buffer to the bio" is a little strange. The re=
verse=0A=
> seems more natural: a bio maps a buffer.=0A=
>=0A=
Make sense, will do.=0A=
>>=0A=
>> This is a prep patch which adds two helper functions for block layer=0A=
>> which allows file-systems and the drivers to map data buffer on to the=
=0A=
>> bios and issue bios synchronously using blkdev_issue_rw() or=0A=
>> asynchronously using __blkdev_issue_rw().=0A=
>=0A=
> The function names are basically the same but do completely different thi=
ngs.=0A=
> Better rename that. May be blkdev_issue_rw_sync() and blkdev_issue_rw_asy=
nc() ?=0A=
>=0A=
 >=0A=
=0A=
This is exactly I named functions to start with (see the function=0A=
documentation which I missed to update), but the pattern in blk-lib.c=0A=
uses no such sync and async postfix, which is used is sync and async=0A=
context all over the kernel :-=0A=
=0A=
# grep EXPORT block/blk-lib.c=0A=
EXPORT_SYMBOL(__blkdev_issue_discard);=0A=
EXPORT_SYMBOL(blkdev_issue_discard);, since as it is nr_sects and sector =
=0A=
calculation doesn't matter after break.=0A=
EXPORT_SYMBOL(blkdev_issue_write_same);=0A=
EXPORT_SYMBOL(__blkdev_issue_zeroout);=0A=
EXPORT_SYMBOL(blkdev_issue_zeroout);=0A=
EXPORT_SYMBOL_GPL(__blkdev_issue_rw);=0A=
EXPORT_SYMBOL_GPL(blkdev_issue_rw);=0A=
=0A=
In absence of documentation for naming how about we just follow=0A=
existing naming convention ?=0A=
=0A=
Which matches the pattern for new API.=0A=
=0A=
>>=0A=
>> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
>> ---=0A=
>>   block/blk-lib.c        | 105 +++++++++++++++++++++++++++++++++++++++++=
=0A=
>>   include/linux/blkdev.h |   7 +++=0A=
>>   2 files changed, 112 insertions(+)=0A=
>>=0A=
>> diff --git a/block/blk-lib.c b/block/blk-lib.c=0A=
>> index 5f2c429d4378..451c367fc0d6 100644=0A=
>> --- a/block/blk-lib.c=0A=
>> +++ b/block/blk-lib.c=0A=
>> @@ -405,3 +405,108 @@ int blkdev_issue_zeroout(struct block_device *bdev=
, sector_t sector,=0A=
>>   	return ret;=0A=
>>   }=0A=
>>   EXPORT_SYMBOL(blkdev_issue_zeroout);=0A=
>> +=0A=
>> +/**=0A=
>> + * __blkdev_ssue_rw - issue read/write bios from buffer asynchronously=
=0A=
>=0A=
> s/__blkdev_ssue_rw/__blkdev_issue_rw=0A=
Thanks, will fix.=0A=
>=0A=
>> + * @bdev:	blockdev to read/write=0A=
>> + * @buf:	data buffer=0A=
>> + * @sector:	start sector=0A=
>> + * @nr_sects:	number of sectors=0A=
>> + * @op:	REQ_OP_READ or REQ_OP_WRITE=0A=
>> + * @opf:	flags=0A=
>> + * @gfp_mask:	memory allocation flags (for bio_alloc)=0A=
>> + * @biop:	pointer to anchor bio=0A=
>> + *=0A=
>> + * Description:=0A=
>> + *  Generic helper function to map data buffer into bios for read and w=
rite ops.=0A=
>> + *  Returns pointer to the anchored last bio for caller to submit async=
hronously=0A=
>> + *  or synchronously.=0A=
>> + */=0A=
>> +int __blkdev_issue_rw(struct block_device *bdev, char *buf, sector_t se=
ctor,=0A=
>> +		      sector_t nr_sects, unsigned op, unsigned opf,=0A=
>> +		      gfp_t gfp_mask, struct bio **biop)=0A=
>> +{=0A=
>> +	bool vm =3D is_vmalloc_addr(buf) ? true : false;=0A=
>=0A=
> You do not need the clunky "? true : false" here. is_vmalloc_addr() retur=
ns a=0A=
> bool already.=0A=
>=0A=
I will remove it.=0A=
>> +	struct bio *bio =3D *biop;=0A=
>> +	unsigned int nr_pages;=0A=
>> +	struct page *page;=0A=
>> +	unsigned int off;=0A=
>> +	unsigned int len;=0A=
>> +	int bi_size;=0A=
>> +=0A=
>> +	if (!bdev_get_queue(bdev))=0A=
>> +		return -ENXIO;=0A=
>> +=0A=
>> +	if (bdev_read_only(bdev))=0A=
>> +		return -EPERM;=0A=
>=0A=
> One can read a read-only device. So the check here is not correct. You ne=
ed a=0A=
> "&& op =3D=3D REQ_OP_WRITE" in the condition.=0A=
>=0A=
True, this shouldn't be here, also I'm thinking of lifting these checks =0A=
to caller, we can add it later if needed.=0A=
>> +=0A=
>> +	if (!(op =3D=3D REQ_OP_READ || op =3D=3D REQ_OP_WRITE))=0A=
>> +		return -EINVAL;=0A=
>=0A=
> This probably should be checked before read-only.=0A=
>=0A=
Yes.=0A=
>> +=0A=
>> +	while (nr_sects !=3D 0) {=0A=
>> +		nr_pages =3D __blkdev_sectors_to_bio_pages(nr_sects);=0A=
>> +=0A=
>> +		bio =3D blk_next_bio(bio, nr_pages, gfp_mask);=0A=
>> +		bio->bi_iter.bi_sector =3D sector;=0A=
>> +		bio_set_dev(bio, bdev);=0A=
>> +		bio_set_op_attrs(bio, op, 0);=0A=
>> +=0A=
>> +		while (nr_sects !=3D 0) {=0A=
>> +			off =3D offset_in_page(buf);=0A=
>> +			page =3D vm ? vmalloc_to_page(buf) : virt_to_page(buf);=0A=
>> +			len =3D min((sector_t) PAGE_SIZE, nr_sects << 9);=0A=
>> +=0A=
>> +			bi_size =3D bio_add_page(bio, page, len, off);=0A=
>=0A=
> The variable naming is super confusing. bio_add_page() returns 0 if nothi=
ng is=0A=
> added and len if the page was added. So bi_size as a var name is not the =
best of=0A=
> name in my opinion.=0A=
>=0A=
Here bio, page, len, off variables are passed to the bio_add_page() =0A=
function, which has the same names in the function parameter list.=0A=
(I'll fix the off to offset)=0A=
=0A=
Regarding the bi_size, given that bio_add_page() returns =0A=
bio->bi_iter.bi_size, isn't bi_size also maps to the what function is =0A=
returning and explains what we are dealing with?=0A=
=0A=
Also, bi_size is used in the blk-lib.c: __blkdev_issue_zero_pages(), if =0A=
that is confusing then we need to change that, what is your preference?=0A=
=0A=
I'll send a cleanup patch __blkdev_issue_zero_pages() also.=0A=
=0A=
>> +=0A=
>> +			nr_sects -=3D bi_size >> 9;=0A=
>> +			sector +=3D bi_size >> 9;=0A=
>> +			buf +=3D bi_size;=0A=
>> +=0A=
>> +			if (bi_size < len)=0A=
>> +				break;=0A=
>=0A=
> You will get either 0 or len from bio_add_page. So the check here is not =
ideal.=0A=
> I think it is better to move it up under bio_add_page() and make it:=0A=
>=0A=
> 			len =3D bioa_add_page(bio, page, len, off);=0A=
> 			if (!len)=0A=
> 				break;=0A=
I'd still like to keep bi_size, I think I had received a comment about =0A=
using same variable for function call and updating as a return value.=0A=
=0A=
Regarding the check, will move it.=0A=
>=0A=
>> +		}=0A=
>> +		cond_resched();=0A=
>> +	}=0A=
>> +	*biop =3D bio;=0A=
>> +	return 0;=0A=
>> +}=0A=
>> +EXPORT_SYMBOL_GPL(__blkdev_issue_rw);=0A=
>> +=0A=
>> +/**=0A=
>> + * blkdev_execute_rw_sync - issue read/write bios from buffer synchrono=
usly=0A=
>> + * @bdev:	blockdev to read/write=0A=
>> + * @buf:	data buffer=0A=
>> + * @sector:	start sector=0A=
>> + * @count:	number of bytes=0A=
>> + * @op:	REQ_OP_READ or REQ_OP_WRITE=0A=
>> + * @opf:	flags=0A=
>> + * @gfp_mask:	memory allocation flags (for bio_alloc)=0A=
>> + *=0A=
>> + * Description:=0A=
>> + *  Generic helper function to map data buffer buffer into bios for rea=
d and=0A=
>> + *  write requests.=0A=
>> + */=0A=
>> +int blkdev_issue_rw(struct block_device *b, char *buf, sector_t sector,=
=0A=
>> +		     unsigned count, unsigned op, unsigned opf, gfp_t mask)=0A=
>=0A=
> function name differs between description and declaration.=0A=
> blkdev_execute_rw_sync() is better than blkdev_issue_rw() in my opinion.=
=0A=
>=0A=
That was remained from initial version, will fix it, thanks for=0A=
pointing it out.=0A=
>> +{=0A=
>> +	unsigned int is_vmalloc =3D is_vmalloc_addr(buf);=0A=
>> +	sector_t nr_sects =3D count >> 9;=0A=
>> +	struct bio *bio =3D NULL;=0A=
>> +	int error;=0A=
>> +=0A=
>> +	if (is_vmalloc && op =3D=3D REQ_OP_WRITE)=0A=
>> +		flush_kernel_vmap_range(buf, count);=0A=
>> +=0A=
>> +	opf |=3D REQ_SYNC;=0A=
>=0A=
> You can add this directly in the call below.=0A=
>=0A=
Breaks calling of __blkdev_issue_rw() to new line. This also adds a new=0A=
line which is unavoidable but keeps the function call smooth in one=0A=
line.=0A=
>> +	error =3D __blkdev_issue_rw(b, buf, sector, nr_sects, op, opf, mask, &=
bio);=0A=
>> +	if (!error && bio) {=0A=
>> +		error =3D submit_bio_wait(bio);=0A=
>> +		bio_put(bio);=0A=
>> +	}=0A=
>> +=0A=
>> +	if (is_vmalloc && op =3D=3D REQ_OP_READ)=0A=
>> +		invalidate_kernel_vmap_range(buf, count);=0A=
>> +=0A=
>> +	return error;=0A=
>> +}=0A=
>> +EXPORT_SYMBOL_GPL(blkdev_issue_rw);=0A=
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h=0A=
>> index 32868fbedc9e..cb315b301ad9 100644=0A=
>> --- a/include/linux/blkdev.h=0A=
>> +++ b/include/linux/blkdev.h=0A=
>> @@ -1248,6 +1248,13 @@ static inline int sb_issue_zeroout(struct super_b=
lock *sb, sector_t block,=0A=
>>   				    gfp_mask, 0);=0A=
>>   }=0A=
>>=0A=
>> +extern int __blkdev_issue_rw(struct block_device *bdev, char *buf,=0A=
>> +			     sector_t sector, sector_t nr_sects, unsigned op,=0A=
>> +			     unsigned opf, gfp_t gfp_mask, struct bio **biop);=0A=
>> +extern int blkdev_issue_rw(struct block_device *b, char *buf, sector_t =
sector,=0A=
>> +			   unsigned count, unsigned op, unsigned opf,=0A=
>> +			   gfp_t mask);=0A=
>=0A=
> No need for the extern I think.=0A=
>=0A=
Again, following the exiting pattern in the file for the header:-=0A=
=0A=
  # grep blkdev_issue include/linux/blkdev.h=0A=
extern int blkdev_issue_flush(struct block_device *, gfp_t, sector_t *);=0A=
=0A=
extern int blkdev_issue_write_same(struct block_device *bdev, sector_t=0A=
sector,=0A=
=0A=
extern int blkdev_issue_discard(struct block_device *bdev, sector_t=0A=
sector,=0A=
=0A=
extern int __blkdev_issue_discard(struct block_device *bdev, sector_t=0A=
sector,=0A=
=0A=
extern int __blkdev_issue_zeroout(struct block_device *bdev, sector_t=0A=
sector,=0A=
=0A=
extern int blkdev_issue_zeroout(struct block_device *bdev, sector_t=0A=
sector,=0A=
=0A=
extern int __blkdev_issue_rw(struct block_device *bdev, char *buf,=0A=
=0A=
extern int blkdev_issue_rw(struct block_device *b, char *buf, sector_t=0A=
sector,=0A=
>> +=0A=
>>   extern int blk_verify_command(unsigned char *cmd, fmode_t mode);=0A=
>>=0A=
>>   enum blk_default_limits {=0A=
>>=0A=
>=0A=
>=0A=
=0A=
