Return-Path: <SRS0=E2x8=5X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 666BBC2BA1A
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 00:28:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AD482072A
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 00:28:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="PMunbgkj";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="T2VuaQHC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbgDGA2J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 20:28:09 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:50306 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgDGA2J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 20:28:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1586219288; x=1617755288;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=UQaIGFzqXsAQ0WBQgA3Menk/0KAk5II8ElX/IcXB3Qs=;
  b=PMunbgkjICF8x8WMKBgIf8YbhUjcuLzGyLOhS9K3BO8hZNN6mHwey9RP
   onLAY9Y3XJXoSGajsfbzqK1I/3tmQmXRnEluuXHwfQRuH22LaSp3m2Qqb
   ylYJvg44czera2uChft9RT2HxFX2oOkmu8hw8+MHHBZXGk5eXGTzc85lF
   7mP1T52sE/yRLw2siJqt+ssKSIW7h2n8kLP7w/nLJgD+q97el1JmFJgu3
   N4LQhmfGwURWdmyE8eyPOYJz/gyDDXsUf8kISNO1qySe9rNqAUeFFgIgi
   GOUFhNB/4iJo0WDAoqX8ezjsv+WQWwTqz71tQporU3DVEzbVamsjIgPjU
   g==;
IronPort-SDR: DSP7v0gXqESw5YO/TuaEb+8617u/3UEmMqYpRZjBFd4rusi7V9LuecQKzgTjJbbPDvQSXQwJkd
 o+YvoLYHZhEphnT6HDUasHv71SJNXAEguN8AgDQMUCm8RyFecqlHOA1XYon+G6Vu5FkU4zu2Wc
 h0TtfRRdU5iBvLjDHaMUxpPIFg+PYAK6qDzKE8gyFXMGeHQ/b5QTZ86ylFeqvcu0Jdcg5HnbsC
 a6ib+ZuIky9JlwJc+1zakFMNfVp+BLDQi9ntiOrnsiq33rRKBpRNCDmWuB94+/nEbzB5qJUdn6
 qj0=
X-IronPort-AV: E=Sophos;i="5.72,352,1580745600"; 
   d="scan'208";a="243265745"
Received: from mail-bn7nam10lp2109.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.109])
  by ob1.hgst.iphmx.com with ESMTP; 07 Apr 2020 08:28:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eaLtMF4bbKaOap6cBQ0Mm4mFxl+27sKg6PJCja8Yfw5pO/uY1rWqsTtGfCUn5LYRKvlU4DoX3yHQj5KYBkMzV3nx4e8tGHo+3hjhZDKqcG7QtrRJCOMjrukR+L/GVPEA7MiPxD3XhXhSA/8tnJN4+SrX0CEV6oztpLbBNMoQhdtFiaoC1rHcN2OIIQiTdFJT2s330walksSzklX4XxGGxOVDREpxv64B1vpYx8M87gHBR0WT7Cw7Hi8wGrnfbksyBeO9NH1vkL5H9PSD5uKroS4AFj+lvlqC9z0tClYdkTzW7tISi2KvxmhFmS1zQW2Kh+1TEWJyN8Mbo8gNMFGdwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FYaxCxSWom9cqFmeyYFsW0tBxbNSgkoKBIzBcEjz+wc=;
 b=ckd+OmyhpaFv/SEafkn/oE1nH2sVTGvXPz3x/sLl6HIzOsn/XT9+BTy30Md3j1nGeaWJ1WyWoyOokGwe/FtTDdVei5YaYjSok303nr6XXa6AI4dmu8E4j4i4gu0/3q13LW797shqX+q8knDbxRlh3UNEuDydg7n1Cz21vywgl9QWI1HrpWpyP6K39GstFMx5m7mJx8xzJO4pAVeP8x9P3TqSyDXcWZutmZepRK2/Yh5wZCaHyzineTv2pwWiBdVdyvNIq44QbT6Dyh4+2cvD/39LrWfv/cErf/xKi86uItsdySUZa/Ial6PpmGvrydhfWK3/mEP8KJdGbW6kHSLNuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FYaxCxSWom9cqFmeyYFsW0tBxbNSgkoKBIzBcEjz+wc=;
 b=T2VuaQHC3Mx/391xRi8M3unJh8r7mHADXNnWucaC2y7+o1Gz006Fs8PId0Axs9w1pnlwpt6IhAvwWI7265SEH5xw9dm/XfCXBuqcEOEwmRFQUY1kiij8y35BnAbs4MGFsRA6LtFFtisT7i1SiDKULUCQG1Y2663JfNq0s7j7VUE=
Received: from BY5PR04MB6900.namprd04.prod.outlook.com (2603:10b6:a03:229::20)
 by BY5PR04MB6277.namprd04.prod.outlook.com (2603:10b6:a03:1f0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15; Tue, 7 Apr
 2020 00:28:05 +0000
Received: from BY5PR04MB6900.namprd04.prod.outlook.com
 ([fe80::d9cc:93c6:19f5:200c]) by BY5PR04MB6900.namprd04.prod.outlook.com
 ([fe80::d9cc:93c6:19f5:200c%3]) with mapi id 15.20.2878.018; Tue, 7 Apr 2020
 00:28:05 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
CC:     "hch@lst.de" <hch@lst.de>,
        "danil.kipnis@cloud.ionos.com" <danil.kipnis@cloud.ionos.com>,
        "jinpu.wang@cloud.ionos.com" <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCH 1/2] block: add bio based rw helper for data buffer
Thread-Topic: [PATCH 1/2] block: add bio based rw helper for data buffer
Thread-Index: AQHWDGqXmuHGxXktHEOKVZcFwoeioA==
Date:   Tue, 7 Apr 2020 00:28:05 +0000
Message-ID: <BY5PR04MB6900AB25131618BED40BE0E0E7C30@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200406232440.4027-1-chaitanya.kulkarni@wdc.com>
 <20200406232440.4027-2-chaitanya.kulkarni@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1eeb4dff-a873-45ed-d6c1-08d7da8a8a47
x-ms-traffictypediagnostic: BY5PR04MB6277:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR04MB627749CD646BD20B581AD177E7C30@BY5PR04MB6277.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 036614DD9C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6900.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(366004)(39840400004)(136003)(376002)(396003)(346002)(4326008)(76116006)(86362001)(110136005)(478600001)(81166006)(66946007)(71200400001)(8676002)(54906003)(81156014)(2906002)(66476007)(66446008)(5660300002)(53546011)(52536014)(33656002)(26005)(66556008)(8936002)(64756008)(6506007)(186003)(7696005)(316002)(9686003)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KwVjGC9KdwkrKsQajj1igDcqzmbVUfAxUONy/SGDIykJCkATKaz64l9CtfN5/9BIvAmwiXjHMaNdc/cWcPSn4S8YUXPeYI0+6Zno+aIkAZnhqo8MYp5rbOo30/DFbvhl6gUDJArlpdbGyyUlfBJMKdUO0KtOPFZeAcwlT1qZqS/Vqt7MsFQ2AqHxfjjPk1DA+wIQ4jIEt+HSaoRZh98VwHegHu7j8rgUxXaoQKVAVLYH33HnyER6wPBo2BWM7SwKIh4REK/rYEcOviCR8bo0bEaFPRPqR10x40KCp8GdDF88gUrlo/51kR9ehLKVUlNGIJuaf8LeGF3R23WtXSxDKeskkLBe6e2oNCHGWsiICkSnenei2JkPwTCVhJVLVlDF2o/frrNOy7FhzcT2yZ0HKTHKz0OL4iG2E/bpCP6DyR1Q4Fw5uwAhRExYYqFeH8HZ
x-ms-exchange-antispam-messagedata: jYXKn3+w2WHXG6Se5OVsmR7L7AhVnEgyu0/TfnZcpzqvISTL+VBloml8oUskVGLp0xAxIiGtealF/79VTUkCatp2yTArEu6AH5GObnn7g+kc9BKlaJJ8gEqMf7IHa7nMzdBB189LwhR7g3NcxkuQsw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eeb4dff-a873-45ed-d6c1-08d7da8a8a47
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2020 00:28:05.4907
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WDfBZNYukL5GzLdycr50uIB/bvn0yPBdsfnwoBYITlQZvuS6P01X+gFXz3hvpkrzi0UYolFAd7zGF9//eiczMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6277
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2020/04/07 8:24, Chaitanya Kulkarni wrote:=0A=
> One of the common application for the file systems and drivers to map=0A=
> the buffer to the bio and issue I/Os on the block device.=0A=
=0A=
Drivers generally do not do this. At least not lower ones (scsi, nvme, etc)=
. I=0A=
guess you are referring to DM drivers. If yes, better be clear about this.=
=0A=
Also, "the buffer" is a little unclear. Better qualify that.=0A=
=0A=
Another thing: "to map the buffer to the bio" is a little strange. The reve=
rse=0A=
seems more natural: a bio maps a buffer.=0A=
=0A=
> =0A=
> This is a prep patch which adds two helper functions for block layer=0A=
> which allows file-systems and the drivers to map data buffer on to the=0A=
> bios and issue bios synchronously using blkdev_issue_rw() or=0A=
> asynchronously using __blkdev_issue_rw().=0A=
=0A=
The function names are basically the same but do completely different thing=
s.=0A=
Better rename that. May be blkdev_issue_rw_sync() and blkdev_issue_rw_async=
() ?=0A=
=0A=
> =0A=
> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
> ---=0A=
>  block/blk-lib.c        | 105 +++++++++++++++++++++++++++++++++++++++++=
=0A=
>  include/linux/blkdev.h |   7 +++=0A=
>  2 files changed, 112 insertions(+)=0A=
> =0A=
> diff --git a/block/blk-lib.c b/block/blk-lib.c=0A=
> index 5f2c429d4378..451c367fc0d6 100644=0A=
> --- a/block/blk-lib.c=0A=
> +++ b/block/blk-lib.c=0A=
> @@ -405,3 +405,108 @@ int blkdev_issue_zeroout(struct block_device *bdev,=
 sector_t sector,=0A=
>  	return ret;=0A=
>  }=0A=
>  EXPORT_SYMBOL(blkdev_issue_zeroout);=0A=
> +=0A=
> +/**=0A=
> + * __blkdev_ssue_rw - issue read/write bios from buffer asynchronously=
=0A=
=0A=
s/__blkdev_ssue_rw/__blkdev_issue_rw=0A=
=0A=
> + * @bdev:	blockdev to read/write=0A=
> + * @buf:	data buffer=0A=
> + * @sector:	start sector=0A=
> + * @nr_sects:	number of sectors=0A=
> + * @op:	REQ_OP_READ or REQ_OP_WRITE=0A=
> + * @opf:	flags=0A=
> + * @gfp_mask:	memory allocation flags (for bio_alloc)=0A=
> + * @biop:	pointer to anchor bio=0A=
> + *=0A=
> + * Description:=0A=
> + *  Generic helper function to map data buffer into bios for read and wr=
ite ops.=0A=
> + *  Returns pointer to the anchored last bio for caller to submit asynch=
ronously=0A=
> + *  or synchronously.=0A=
> + */=0A=
> +int __blkdev_issue_rw(struct block_device *bdev, char *buf, sector_t sec=
tor,=0A=
> +		      sector_t nr_sects, unsigned op, unsigned opf,=0A=
> +		      gfp_t gfp_mask, struct bio **biop)=0A=
> +{=0A=
> +	bool vm =3D is_vmalloc_addr(buf) ? true : false;=0A=
=0A=
You do not need the clunky "? true : false" here. is_vmalloc_addr() returns=
 a=0A=
bool already.=0A=
=0A=
> +	struct bio *bio =3D *biop;=0A=
> +	unsigned int nr_pages;=0A=
> +	struct page *page;=0A=
> +	unsigned int off;=0A=
> +	unsigned int len;=0A=
> +	int bi_size;=0A=
> +=0A=
> +	if (!bdev_get_queue(bdev))=0A=
> +		return -ENXIO;=0A=
> +=0A=
> +	if (bdev_read_only(bdev))=0A=
> +		return -EPERM;=0A=
=0A=
One can read a read-only device. So the check here is not correct. You need=
 a=0A=
"&& op =3D=3D REQ_OP_WRITE" in the condition.=0A=
=0A=
> +=0A=
> +	if (!(op =3D=3D REQ_OP_READ || op =3D=3D REQ_OP_WRITE))=0A=
> +		return -EINVAL;=0A=
=0A=
This probably should be checked before read-only.=0A=
=0A=
> +=0A=
> +	while (nr_sects !=3D 0) {=0A=
> +		nr_pages =3D __blkdev_sectors_to_bio_pages(nr_sects);=0A=
> +=0A=
> +		bio =3D blk_next_bio(bio, nr_pages, gfp_mask);=0A=
> +		bio->bi_iter.bi_sector =3D sector;=0A=
> +		bio_set_dev(bio, bdev);=0A=
> +		bio_set_op_attrs(bio, op, 0);=0A=
> +=0A=
> +		while (nr_sects !=3D 0) {=0A=
> +			off =3D offset_in_page(buf);=0A=
> +			page =3D vm ? vmalloc_to_page(buf) : virt_to_page(buf);=0A=
> +			len =3D min((sector_t) PAGE_SIZE, nr_sects << 9);=0A=
> +=0A=
> +			bi_size =3D bio_add_page(bio, page, len, off);=0A=
=0A=
The variable naming is super confusing. bio_add_page() returns 0 if nothing=
 is=0A=
added and len if the page was added. So bi_size as a var name is not the be=
st of=0A=
name in my opinion.=0A=
=0A=
> +=0A=
> +			nr_sects -=3D bi_size >> 9;=0A=
> +			sector +=3D bi_size >> 9;=0A=
> +			buf +=3D bi_size;=0A=
> +=0A=
> +			if (bi_size < len)=0A=
> +				break;=0A=
=0A=
You will get either 0 or len from bio_add_page. So the check here is not id=
eal.=0A=
I think it is better to move it up under bio_add_page() and make it:=0A=
=0A=
			len =3D bioa_add_page(bio, page, len, off);=0A=
			if (!len)=0A=
				break;=0A=
=0A=
> +		}=0A=
> +		cond_resched();=0A=
> +	}=0A=
> +	*biop =3D bio;=0A=
> +	return 0;=0A=
> +}=0A=
> +EXPORT_SYMBOL_GPL(__blkdev_issue_rw);=0A=
> +=0A=
> +/**=0A=
> + * blkdev_execute_rw_sync - issue read/write bios from buffer synchronou=
sly=0A=
> + * @bdev:	blockdev to read/write=0A=
> + * @buf:	data buffer=0A=
> + * @sector:	start sector=0A=
> + * @count:	number of bytes=0A=
> + * @op:	REQ_OP_READ or REQ_OP_WRITE=0A=
> + * @opf:	flags=0A=
> + * @gfp_mask:	memory allocation flags (for bio_alloc)=0A=
> + *=0A=
> + * Description:=0A=
> + *  Generic helper function to map data buffer buffer into bios for read=
 and=0A=
> + *  write requests.=0A=
> + */=0A=
> +int blkdev_issue_rw(struct block_device *b, char *buf, sector_t sector,=
=0A=
> +		     unsigned count, unsigned op, unsigned opf, gfp_t mask)=0A=
=0A=
function name differs between description and declaration.=0A=
blkdev_execute_rw_sync() is better than blkdev_issue_rw() in my opinion.=0A=
=0A=
> +{=0A=
> +	unsigned int is_vmalloc =3D is_vmalloc_addr(buf);=0A=
> +	sector_t nr_sects =3D count >> 9;=0A=
> +	struct bio *bio =3D NULL;=0A=
> +	int error;=0A=
> +=0A=
> +	if (is_vmalloc && op =3D=3D REQ_OP_WRITE)=0A=
> +		flush_kernel_vmap_range(buf, count);=0A=
> +=0A=
> +	opf |=3D REQ_SYNC;=0A=
=0A=
You can add this directly in the call below.=0A=
=0A=
> +	error =3D __blkdev_issue_rw(b, buf, sector, nr_sects, op, opf, mask, &b=
io);=0A=
> +	if (!error && bio) {=0A=
> +		error =3D submit_bio_wait(bio);=0A=
> +		bio_put(bio);=0A=
> +	}=0A=
> +=0A=
> +	if (is_vmalloc && op =3D=3D REQ_OP_READ)=0A=
> +		invalidate_kernel_vmap_range(buf, count);=0A=
> +=0A=
> +	return error;=0A=
> +}=0A=
> +EXPORT_SYMBOL_GPL(blkdev_issue_rw);=0A=
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h=0A=
> index 32868fbedc9e..cb315b301ad9 100644=0A=
> --- a/include/linux/blkdev.h=0A=
> +++ b/include/linux/blkdev.h=0A=
> @@ -1248,6 +1248,13 @@ static inline int sb_issue_zeroout(struct super_bl=
ock *sb, sector_t block,=0A=
>  				    gfp_mask, 0);=0A=
>  }=0A=
>  =0A=
> +extern int __blkdev_issue_rw(struct block_device *bdev, char *buf,=0A=
> +			     sector_t sector, sector_t nr_sects, unsigned op,=0A=
> +			     unsigned opf, gfp_t gfp_mask, struct bio **biop);=0A=
> +extern int blkdev_issue_rw(struct block_device *b, char *buf, sector_t s=
ector,=0A=
> +			   unsigned count, unsigned op, unsigned opf,=0A=
> +			   gfp_t mask);=0A=
=0A=
No need for the extern I think.=0A=
=0A=
> +=0A=
>  extern int blk_verify_command(unsigned char *cmd, fmode_t mode);=0A=
>  =0A=
>  enum blk_default_limits {=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
