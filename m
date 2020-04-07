Return-Path: <SRS0=E2x8=5X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FB5BC2BA1A
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 00:32:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0635120692
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 00:32:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="YZkrCX+O";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="pu/2/5XT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgDGAc6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 20:32:58 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:60833 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbgDGAc6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 20:32:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1586219578; x=1617755578;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G3K8E/aYB7G3fsYTyrPssnKuolwBOJYb/B9HjScUT30=;
  b=YZkrCX+O05TQxBVlQlw8b38PVNx50kffsUBQLFT+pSCBhtAhSv+2u4c7
   r+b9t2RF8MTUa51Yc0+KLm559GO1OIoYjq/0C0WdvkS6qfVUYjQR45DjR
   qQFvYJDo0nk3kbYAmkASeCTHEWOqPDgfIRV8WGtzLIt3FjecUtt5YHjlX
   kEgnvixytwrV2NQyhORXWdc0aw+3pYqelcX88tjBCaf0mguVNIa0Ap9T7
   xWje8OnHCP9+jjrvzz79gilL2bTvGeYEU1QiLpOOgfbM15Ew/PjmifesI
   E4dIOgV51rzdJcR5ZSKR8NXw5DFm+me4WTe2FOsoPkzQrX19GDaqXIUtj
   g==;
IronPort-SDR: FudF6PIsLgvPrf4Z3/qMRe1dB5LV/IjHjjLAczqHj4VMvD0mmqdQsbnqKHfcxfYl881m7ILlRr
 isVzrb5h8s2gYkGBpLGVZS1o4KVx1XBg8ByeY6CCsiXb4mfGCjtczsbntBNdc9rhhGv4LSli94
 D8p3GSR+ym5J3bEM1mIzBKFqwfiogVAI13LT2OAefVOaCMnR45olVQnYC3K6xAmPhkqlH2Xdnr
 cY6Lqlz2BPm1xXMxkgxwWVD1Tz5taNr9e6VRjRMhFgR7KNmI8GvY3LWh2S6AsaON9H8aeFZ6r8
 xDk=
X-IronPort-AV: E=Sophos;i="5.72,352,1580745600"; 
   d="scan'208";a="139019682"
Received: from mail-dm6nam10lp2105.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.105])
  by ob1.hgst.iphmx.com with ESMTP; 07 Apr 2020 08:32:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gElaEis/PgPAEZ6q6kqd8Yq1EX5p510HFcFQqAWcvAKpv0hIsTix4qkAW29nBIgBRm0w/KUQukejfG7SkoE0AUM1mP2pUYrcYyCEoUbComEAvQMsnBYHrztivla5TPidXYvTFnMDqhTpeFrIPjGPA6kHnL8uktArGd+vi0unuWhrLd6ahDCmx0CoKX3yIsj8AN2d52fN2HLSQRdkGSG+/6H7NFSe4nw497YQwZyGhBQGMqM1ATirph2oQhtYuFb4IR+/QuxTeyBiSA1vYYkc613RKEo3x+yQP5Pq7vTlMMmn81853q1k9WJYg2ZUFpw07RBlMiLfnoMyQ+uEX9H0fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XrId1zNwCUSbJUm4l7V/KKkOYb7aMOrkkvesYWGYM40=;
 b=diF9hzizeMmPLNFMAY2oPyXUj6/yKGieKzju+b8RN3mZzqaBwC0HXt9T5zATMm3hauHbmMG47vc/7BfKf0/rP0elv6KEa7JFLBmOK4gyoLnPInBA647+Bx0wp94u7TolZPpQ3dR2dqBcCIQeAdp1gQGmC0RJwSUAGm3a+rbcZBS+2BfoMBuYwkrvjznYByDDiNwJcqKQA8ulPBhYQwpKu+bz4khgB1UEtzA3mT+UhCYGs5W6llLezJNRCsR44hKc3NXBZ+HmL7Zfnyg5PJjlQRnm1Hno4WLVBWXSqP2mveO4Ch/tXNaXmM4T8q9Q9eNYK2S/6zf9LI7atdYMDCWTUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XrId1zNwCUSbJUm4l7V/KKkOYb7aMOrkkvesYWGYM40=;
 b=pu/2/5XTNIQ/s+XFP90Q+lolm/GqoYgSOnpoecvOy1vZFyE656l4Z6IFR6RmSr6es3neJNBOdTtVuAz6Q3wrbyTaV43tLHZQGifePrYqnwtDJUyEHjheDJDlqPTlEiHp7EzmwhRtTawPgS6U1LZrylnjcPAjtqjjgTii95E6l0Y=
Received: from BY5PR04MB6900.namprd04.prod.outlook.com (2603:10b6:a03:229::20)
 by BY5PR04MB6533.namprd04.prod.outlook.com (2603:10b6:a03:1df::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.21; Tue, 7 Apr
 2020 00:32:55 +0000
Received: from BY5PR04MB6900.namprd04.prod.outlook.com
 ([fe80::d9cc:93c6:19f5:200c]) by BY5PR04MB6900.namprd04.prod.outlook.com
 ([fe80::d9cc:93c6:19f5:200c%3]) with mapi id 15.20.2878.018; Tue, 7 Apr 2020
 00:32:55 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
CC:     "hch@lst.de" <hch@lst.de>,
        "danil.kipnis@cloud.ionos.com" <danil.kipnis@cloud.ionos.com>,
        "jinpu.wang@cloud.ionos.com" <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCH 2/2] xfs: use block layer helper for rw
Thread-Topic: [PATCH 2/2] xfs: use block layer helper for rw
Thread-Index: AQHWDGqdekzH7uAt1UCoumX6AlqU+A==
Date:   Tue, 7 Apr 2020 00:32:55 +0000
Message-ID: <BY5PR04MB690075C16A97151A6216948CE7C30@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200406232440.4027-1-chaitanya.kulkarni@wdc.com>
 <20200406232440.4027-3-chaitanya.kulkarni@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4b5c881f-9666-484d-e389-08d7da8b374d
x-ms-traffictypediagnostic: BY5PR04MB6533:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR04MB6533ABB8693BA40BACB6052DE7C30@BY5PR04MB6533.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 036614DD9C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6900.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(376002)(39840400004)(396003)(366004)(346002)(136003)(8936002)(478600001)(4326008)(5660300002)(9686003)(76116006)(52536014)(66446008)(71200400001)(66946007)(64756008)(66476007)(55016002)(66556008)(8676002)(186003)(26005)(54906003)(81156014)(33656002)(81166006)(110136005)(6506007)(316002)(86362001)(2906002)(53546011)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eSI79HnwvSq2g8k5cFRdm+qszidBmPndeX7w8r2EahLiliZN/vajIcBY5IGmBH7dP9VzpViwFbjIfVXUkfS8dipOFsJOaKUJnzEnGoz/6BvtimB+bbBMOiXpqDtcDvpxMvS29Y0VxdOMpWR8V8m3YccYarbhN8xbnQHDYipq44Th1cTtTSSYvBg1CRsH5BnI3RYT2JoOUjwgh0B0yUs1ervr+ZddL8uSKDed7jX9C1TbSL6PDUMrgduv+cR2eZo6fLbNlg8HXAIbiSvepoOGKmIU3fbrZFAW3wl8TuFXI093IzqFYhTXskF5BbGCqYv0pYkndyCBV5Yn5VUBWZ6OhcotIhSQ0k72wJr2A2oR9rBe/aeYIgFVUMF97hyxHlZmRlquN6D0+eNy+AIhvCUCUFxhPrdA6b19TaBEc1nO0QyvH1P0jO8WP2sXyijiDfVI
x-ms-exchange-antispam-messagedata: cTCqy5Yd4Q+DlZtEcGRN40IU9em6CIlbPRMiK7FQo1UYe7B4MLPUAx7qzqL2ijgyXyb8glqlkWInWC+m3/JBHX7O4qhiuc9zIeOveAtx+W9HUDbd7WjW0oQILIkTS6WNM7j1U5s+7NIggOp2vCcyxw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b5c881f-9666-484d-e389-08d7da8b374d
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2020 00:32:55.7841
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vaR6/7gt2PfvRsVnLl88bG4hFNKM9Fb8HN/8km8JCsu+0qaNpIFjDOe2baYF43doEuRtjK9cYZitAUacouhC8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6533
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2020/04/07 8:25, Chaitanya Kulkarni wrote:=0A=
> The existing routine xfs_rw_bdev has block layer bio-based code which=0A=
> maps the data buffer allocated with kmalloc or vmalloc to the READ/WRITE=
=0A=
> bios. Use a block layer helper from the previous patch to avoid code=0A=
> duplication.=0A=
> =0A=
> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
> ---=0A=
>  fs/xfs/xfs_bio_io.c | 47 ++-------------------------------------------=
=0A=
>  1 file changed, 2 insertions(+), 45 deletions(-)=0A=
> =0A=
> diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c=0A=
> index e2148f2d5d6b..b04c398fb99c 100644=0A=
> --- a/fs/xfs/xfs_bio_io.c=0A=
> +++ b/fs/xfs/xfs_bio_io.c=0A=
> @@ -4,11 +4,6 @@=0A=
>   */=0A=
>  #include "xfs.h"=0A=
>  =0A=
> -static inline unsigned int bio_max_vecs(unsigned int count)=0A=
> -{=0A=
> -	return min_t(unsigned, howmany(count, PAGE_SIZE), BIO_MAX_PAGES);=0A=
> -}=0A=
> -=0A=
>  int=0A=
>  xfs_rw_bdev(=0A=
>  	struct block_device	*bdev,=0A=
> @@ -18,44 +13,6 @@ xfs_rw_bdev(=0A=
>  	unsigned int		op)=0A=
>  =0A=
>  {=0A=
> -	unsigned int		is_vmalloc =3D is_vmalloc_addr(data);=0A=
> -	unsigned int		left =3D count;=0A=
> -	int			error;=0A=
> -	struct bio		*bio;=0A=
> -=0A=
> -	if (is_vmalloc && op =3D=3D REQ_OP_WRITE)=0A=
> -		flush_kernel_vmap_range(data, count);=0A=
> -=0A=
> -	bio =3D bio_alloc(GFP_KERNEL, bio_max_vecs(left));=0A=
> -	bio_set_dev(bio, bdev);=0A=
> -	bio->bi_iter.bi_sector =3D sector;=0A=
> -	bio->bi_opf =3D op | REQ_META | REQ_SYNC;=0A=
> -=0A=
> -	do {=0A=
> -		struct page	*page =3D kmem_to_page(data);=0A=
> -		unsigned int	off =3D offset_in_page(data);=0A=
> -		unsigned int	len =3D min_t(unsigned, left, PAGE_SIZE - off);=0A=
> -=0A=
> -		while (bio_add_page(bio, page, len, off) !=3D len) {=0A=
> -			struct bio	*prev =3D bio;=0A=
> -=0A=
> -			bio =3D bio_alloc(GFP_KERNEL, bio_max_vecs(left));=0A=
> -			bio_copy_dev(bio, prev);=0A=
> -			bio->bi_iter.bi_sector =3D bio_end_sector(prev);=0A=
> -			bio->bi_opf =3D prev->bi_opf;=0A=
> -			bio_chain(prev, bio);=0A=
> -=0A=
> -			submit_bio(prev);=0A=
> -		}=0A=
> -=0A=
> -		data +=3D len;=0A=
> -		left -=3D len;=0A=
> -	} while (left > 0);=0A=
=0A=
Your helper could use a similar loop structure. This is very easy to read.=
=0A=
=0A=
> -=0A=
> -	error =3D submit_bio_wait(bio);=0A=
> -	bio_put(bio);=0A=
> -=0A=
> -	if (is_vmalloc && op =3D=3D REQ_OP_READ)=0A=
> -		invalidate_kernel_vmap_range(data, count);=0A=
> -	return error;=0A=
> +	return blkdev_issue_rw(bdev, data, sector, count, op, REQ_META,=0A=
> +			       GFP_KERNEL);=0A=
>  }=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
