Return-Path: <SRS0=FA9X=D4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F793C4363A
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Oct 2020 09:08:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0355A22453
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Oct 2020 09:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408950AbgJUJIl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Oct 2020 05:08:41 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:44574 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388710AbgJUJIl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Oct 2020 05:08:41 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id F24431C0B87; Wed, 21 Oct 2020 11:08:37 +0200 (CEST)
Date:   Wed, 21 Oct 2020 11:08:37 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Sergei Shtepa <sergei.shtepa@veeam.com>
Cc:     axboe@kernel.dk, viro@zeniv.linux.org.uk, hch@infradead.org,
        darrick.wong@oracle.com, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, rjw@rjwysocki.net,
        len.brown@intel.com, akpm@linux-foundation.org,
        johannes.thumshirn@wdc.com, ming.lei@redhat.com, jack@suse.cz,
        tj@kernel.org, gustavo@embeddedor.com, bvanassche@acm.org,
        osandov@fb.com, koct9i@gmail.com, damien.lemoal@wdc.com,
        steve@sk2.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 2/2] blk-snap - snapshots and change-tracking for block
 devices
Message-ID: <20201021090837.GA30282@duo.ucw.cz>
References: <1603271049-20681-1-git-send-email-sergei.shtepa@veeam.com>
 <1603271049-20681-3-git-send-email-sergei.shtepa@veeam.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <1603271049-20681-3-git-send-email-sergei.shtepa@veeam.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


We'll need some changelog here.

> Signed-off-by: Sergei Shtepa <sergei.shtepa@veeam.com>


> --- /dev/null
> +++ b/drivers/block/blk-snap/blk-snap-ctl.h
> @@ -0,0 +1,190 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +#pragma once

once?

> +#define MODULE_NAME "blk-snap"
> +#define SNAP_IMAGE_NAME "blk-snap-image"
> +
> +#define SUCCESS 0
> +
> +#define MAX_TRACKING_DEVICE_COUNT 256
> +
> +#define BLK_SNAP 'V'
> +
> +#pragma pack(push, 1)
> +////////////////////////////////////////////////////////////////////////=
//
> +// version

This is not normal comment style.

> +#define BLK_SNAP_COMPATIBILITY_SNAPSTORE 0x0000000000000001ull /* rudime=
nt */
> +//#define BLK_SNAP_COMPATIBILITY_BTRFS	 0x0000000000000002ull /* rudimen=
t */
> +#define BLK_SNAP_COMPATIBILITY_MULTIDEV 0x0000000000000004ull

Don't comment out code.

Best regards,
								Pavel

--=20
http://www.livejournal.com/~pavelmachek

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX4/6lQAKCRAw5/Bqldv6
8o8cAKCGOfzRThj3PI/GUqFfrzx80xnZewCgo+dfOqsqnJNFU1gLe4HjXpbnNNU=
=H1w6
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
