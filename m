Return-Path: <SRS0=9/io=XV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFE08C432C2
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 09:20:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8119222C4
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 09:20:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BpHnWKIf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbfIZJUu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Sep 2019 05:20:50 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55145 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730298AbfIZJUt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Sep 2019 05:20:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569489647;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=veqIRvDn+REqjgwxZhvwH0CcWy/OKoPrL51kEWt4uPE=;
        b=BpHnWKIftlFFK/EGMYOsD/QKQS7v64LWbL4MJoVAZE8SHwPEwZ90g7KGXmlpF6kdUULSwi
        i0MJw60EAjjt2kUbbG1xMINtR0RohtW83IZNFfkPI/E7b3X5xko36PgppkMRiSop8CpWrT
        3H77Ts2AshNRal1EYWXBaKMu/jRf6DY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-WjRMk2jLNd-jcaHl1QQ8aw-1; Thu, 26 Sep 2019 05:20:46 -0400
Received: by mail-wm1-f69.google.com with SMTP id m6so770058wmf.2
        for <linux-xfs@vger.kernel.org>; Thu, 26 Sep 2019 02:20:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=qwed6MSWaMn3IrM2yrloFTZLZJPTmqDrqSnZ1iwoYyU=;
        b=EZWpwe8ky4UGK8Z572Wxf/+ivR6W01bw+dgjEGrl+FcFbK4h0yMJrrfrCT0ri0vFnf
         aKUbFXzZ2ADq5V8eyLMJM4b/xmu4zfpHeVKUVW/4YdU2z1m/aYDzEvwwjN+vJ2lw2gho
         S+w2N3/1DuL/2Zf4ENBBcGhOuaQVwUMlWsKfG9jDxu5e/stc001lrdZvNNUvPY6Xacfn
         23k5AZHGdNyArEEO23/5VYFjFN4vf6wtsO+VxIpV/+cgshhHOzUyHde/vPwDpESCZh0d
         PfLcBWW+Ewg21W9D8Q+nEvhZ7yRTTZeV6iKEkKaw8N653gIDu1dk7DuuvoNyzRDt+vP2
         7PVA==
X-Gm-Message-State: APjAAAVlBcE1svj11U2ltnhbDF41sGmn9hcGI9x/y76XHxUVhfMoaeD0
        2QnGFi5WhmmdsKN26FYOR+/0p4xygEdB9u3XUxeq8kSxFgOtIvQc3P4Kq+FgrIxWG+FIyPcGs1F
        5u8jO1ROl2Lj8t3rIMZLE
X-Received: by 2002:a7b:c5c2:: with SMTP id n2mr2069688wmk.20.1569489645008;
        Thu, 26 Sep 2019 02:20:45 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwpA6vf5alnKcPUp/E8tfEpeApNYkFZh0ws+76yZu7xj0E5DbPgYdJxCI7pctCKCiPJuHkFUQ==
X-Received: by 2002:a7b:c5c2:: with SMTP id n2mr2069671wmk.20.1569489644788;
        Thu, 26 Sep 2019 02:20:44 -0700 (PDT)
Received: from pegasus.maiolino.io (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id b7sm1601781wrj.28.2019.09.26.02.20.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2019 02:20:44 -0700 (PDT)
Date:   Thu, 26 Sep 2019 11:20:42 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_db: calculate iext tree geometry in btheight
 command
Message-ID: <20190926092041.4br7562bwqsqwznr@pegasus.maiolino.io>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        sandeen@sandeen.net, linux-xfs@vger.kernel.org
References: <156944764785.303060.15428657522073378525.stgit@magnolia>
 <156944765991.303060.7541074919992777157.stgit@magnolia>
MIME-Version: 1.0
In-Reply-To: <156944765991.303060.7541074919992777157.stgit@magnolia>
User-Agent: NeoMutt/20180716
X-MC-Unique: WjRMk2jLNd-jcaHl1QQ8aw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 25, 2019 at 02:40:59PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> (Ab)use the btheight command to calculate the geometry of the incore
> extent tree.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  db/btheight.c |   87 +++++++++++++++++++++++++++++++++++++++------------=
------
>  1 file changed, 60 insertions(+), 27 deletions(-)
>=20
>=20
> diff --git a/db/btheight.c b/db/btheight.c
> index e2c9759f..be604ebc 100644
> --- a/db/btheight.c
> +++ b/db/btheight.c
> @@ -22,18 +22,37 @@ static int rmap_maxrecs(struct xfs_mount *mp, int blo=
cklen, int leaf)
>  =09return libxfs_rmapbt_maxrecs(blocklen, leaf);
>  }
> =20
> +static int iext_maxrecs(struct xfs_mount *mp, int blocklen, int leaf)
> +{
> +=09blocklen -=3D 2 * sizeof(void *);
> +
> +=09return blocklen / sizeof(struct xfs_bmbt_rec);
> +}
> +
> +static int disk_blocksize(struct xfs_mount *mp)

This naming looks confusing to me, disk_blocksize sounds to me like
'sector size', maybe fs_blocksize() or get_fs_blocksize()?
> +{
> +=09return mp->m_sb.sb_blocksize;
> +}
> +

Otherwise looks good.


> +static int iext_blocksize(struct xfs_mount *mp)
> +{
> +=09return 256;
> +}
> +
>  struct btmap {
>  =09const char=09*tag;
>  =09int=09=09(*maxrecs)(struct xfs_mount *mp, int blocklen,
>  =09=09=09=09   int leaf);
> +=09int=09=09(*default_blocksize)(struct xfs_mount *mp);
>  } maps[] =3D {
> -=09{"bnobt", libxfs_allocbt_maxrecs},
> -=09{"cntbt", libxfs_allocbt_maxrecs},
> -=09{"inobt", libxfs_inobt_maxrecs},
> -=09{"finobt", libxfs_inobt_maxrecs},
> -=09{"bmapbt", libxfs_bmbt_maxrecs},
> -=09{"refcountbt", refc_maxrecs},
> -=09{"rmapbt", rmap_maxrecs},
> +=09{"bnobt", libxfs_allocbt_maxrecs, disk_blocksize},
> +=09{"cntbt", libxfs_allocbt_maxrecs, disk_blocksize},
> +=09{"inobt", libxfs_inobt_maxrecs, disk_blocksize},
> +=09{"finobt", libxfs_inobt_maxrecs, disk_blocksize},
> +=09{"bmapbt", libxfs_bmbt_maxrecs, disk_blocksize},
> +=09{"refcountbt", refc_maxrecs, disk_blocksize},
> +=09{"rmapbt", rmap_maxrecs, disk_blocksize},
> +=09{"iext", iext_maxrecs, iext_blocksize},
>  };
> =20
>  static void
> @@ -108,7 +127,7 @@ calc_height(
>  static int
>  construct_records_per_block(
>  =09char=09=09*tag,
> -=09int=09=09blocksize,
> +=09int=09=09*blocksize,
>  =09unsigned int=09*records_per_block)
>  {
>  =09char=09=09*toktag;
> @@ -119,8 +138,10 @@ construct_records_per_block(
> =20
>  =09for (i =3D 0, m =3D maps; i < ARRAY_SIZE(maps); i++, m++) {
>  =09=09if (!strcmp(m->tag, tag)) {
> -=09=09=09records_per_block[0] =3D m->maxrecs(mp, blocksize, 1);
> -=09=09=09records_per_block[1] =3D m->maxrecs(mp, blocksize, 0);
> +=09=09=09if (*blocksize < 0)
> +=09=09=09=09*blocksize =3D m->default_blocksize(mp);
> +=09=09=09records_per_block[0] =3D m->maxrecs(mp, *blocksize, 1);
> +=09=09=09records_per_block[1] =3D m->maxrecs(mp, *blocksize, 0);
>  =09=09=09return 0;
>  =09=09}
>  =09}
> @@ -178,38 +199,50 @@ construct_records_per_block(
>  =09=09fprintf(stderr, _("%s: header type not found.\n"), tag);
>  =09=09goto out;
>  =09}
> -=09if (!strcmp(p, "short"))
> +=09if (!strcmp(p, "short")) {
> +=09=09if (*blocksize < 0)
> +=09=09=09*blocksize =3D mp->m_sb.sb_blocksize;
>  =09=09blocksize -=3D XFS_BTREE_SBLOCK_LEN;
> -=09else if (!strcmp(p, "shortcrc"))
> +=09} else if (!strcmp(p, "shortcrc")) {
> +=09=09if (*blocksize < 0)
> +=09=09=09*blocksize =3D mp->m_sb.sb_blocksize;
>  =09=09blocksize -=3D XFS_BTREE_SBLOCK_CRC_LEN;
> -=09else if (!strcmp(p, "long"))
> +=09} else if (!strcmp(p, "long")) {
> +=09=09if (*blocksize < 0)
> +=09=09=09*blocksize =3D mp->m_sb.sb_blocksize;
>  =09=09blocksize -=3D XFS_BTREE_LBLOCK_LEN;
> -=09else if (!strcmp(p, "longcrc"))
> +=09} else if (!strcmp(p, "longcrc")) {
> +=09=09if (*blocksize < 0)
> +=09=09=09*blocksize =3D mp->m_sb.sb_blocksize;
>  =09=09blocksize -=3D XFS_BTREE_LBLOCK_CRC_LEN;
> -=09else {
> +=09} else if (!strcmp(p, "iext")) {
> +=09=09if (*blocksize < 0)
> +=09=09=09*blocksize =3D 256;
> +=09=09blocksize -=3D 2 * sizeof(void *);
> +=09} else {
>  =09=09fprintf(stderr, _("%s: unrecognized btree header type."),
>  =09=09=09=09p);
>  =09=09goto out;
>  =09}
> =20
> -=09if (record_size > blocksize) {
> +=09if (record_size > *blocksize) {
>  =09=09fprintf(stderr,
>  =09=09=09_("%s: record size must be less than %u bytes.\n"),
> -=09=09=09tag, blocksize);
> +=09=09=09tag, *blocksize);
>  =09=09goto out;
>  =09}
> =20
> -=09if (key_size > blocksize) {
> +=09if (key_size > *blocksize) {
>  =09=09fprintf(stderr,
>  =09=09=09_("%s: key size must be less than %u bytes.\n"),
> -=09=09=09tag, blocksize);
> +=09=09=09tag, *blocksize);
>  =09=09goto out;
>  =09}
> =20
> -=09if (ptr_size > blocksize) {
> +=09if (ptr_size > *blocksize) {
>  =09=09fprintf(stderr,
>  =09=09=09_("%s: pointer size must be less than %u bytes.\n"),
> -=09=09=09tag, blocksize);
> +=09=09=09tag, *blocksize);
>  =09=09goto out;
>  =09}
> =20
> @@ -221,8 +254,8 @@ construct_records_per_block(
>  =09=09goto out;
>  =09}
> =20
> -=09records_per_block[0] =3D blocksize / record_size;
> -=09records_per_block[1] =3D blocksize / (key_size + ptr_size);
> +=09records_per_block[0] =3D *blocksize / record_size;
> +=09records_per_block[1] =3D *blocksize / (key_size + ptr_size);
>  =09ret =3D 0;
>  out:
>  =09free(toktag);
> @@ -238,12 +271,12 @@ report(
>  =09char=09=09=09*tag,
>  =09unsigned int=09=09report_what,
>  =09unsigned long long=09nr_records,
> -=09unsigned int=09=09blocksize)
> +=09int=09=09=09blocksize)
>  {
>  =09unsigned int=09=09records_per_block[2];
>  =09int=09=09=09ret;
> =20
> -=09ret =3D construct_records_per_block(tag, blocksize, records_per_block=
);
> +=09ret =3D construct_records_per_block(tag, &blocksize, records_per_bloc=
k);
>  =09if (ret)
>  =09=09return;
> =20
> @@ -302,7 +335,7 @@ btheight_f(
>  =09int=09=09argc,
>  =09char=09=09**argv)
>  {
> -=09long long=09blocksize =3D mp->m_sb.sb_blocksize;
> +=09long long=09blocksize =3D -1;
>  =09uint64_t=09nr_records =3D 0;
>  =09int=09=09report_what =3D REPORT_DEFAULT;
>  =09int=09=09i, c;
> @@ -355,7 +388,7 @@ _("The largest block size this command will consider =
is %u bytes.\n"),
>  =09=09return 0;
>  =09}
> =20
> -=09if (blocksize < 128) {
> +=09if (blocksize >=3D 0 && blocksize < 128) {
>  =09=09fprintf(stderr,
>  _("The smallest block size this command will consider is 128 bytes.\n"))=
;
>  =09=09return 0;
>=20

--=20
Carlos

