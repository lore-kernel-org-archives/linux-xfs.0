Return-Path: <SRS0=aFxQ=X2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2F61C388F3
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Oct 2019 06:40:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A60692133F
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Oct 2019 06:40:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yn856Uz3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfJAGki (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Oct 2019 02:40:38 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:55741 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725777AbfJAGkh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Oct 2019 02:40:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569912036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1MKhaYLN4HrjjcMIwIU1XzMdBAkAJuDkNCs1e2AoQLA=;
        b=Yn856Uz3zTBlITv1IW7yeMdncmDI94nvEvWe0uR6LL29hUiRarxqKHqKs11bm2XEq6Novn
        r5CHz3UjqaQO5kjAowuMedek0O1JILTwgyX+1hAsKORvnuqvn4+/uShSjWRj9g7n96Ccay
        yquPThCo3Wmtvo7erNCsV8sSAMAWH+Y=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-46-wzt8_kD7MJyilry40he9TQ-1; Tue, 01 Oct 2019 02:40:35 -0400
Received: by mail-wm1-f71.google.com with SMTP id 124so537867wmz.1
        for <linux-xfs@vger.kernel.org>; Mon, 30 Sep 2019 23:40:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=aYUJneUZiaudAbO/s6r2Vu4e57tSLWwbeE7YQJsvPCQ=;
        b=aNsLspY/XeWGvuqzkEasToeJpgalIbnWnww0hEFqxkCH6aMsnfn76xuZKtlJKGC9r2
         H9iXUxxqGxjuqzFZGgvT9OvqV6L1riF/cNz7GDFNjIqgSgA3jPjdLNgCF11zQmvLbB7D
         bzJejIqnzDkZ8Mejijg7Y5XWh75gRyeVr5IzfHO6OM1GLPuy2IRKYOemB/z58gSZrpsX
         N0EskKRhaBy+KJ5YNC5L+Z/0jshF5JCA1kcIEjRX7fnz3XOgFoJdCdZyeIW+T3pmi/Fu
         RxlZQYq2+pGo3gR59aH1UP/mH2IYwPOg7Y/2cmduiRZ3KapSU7WVaFyDYljU2Iw4BZPu
         imBQ==
X-Gm-Message-State: APjAAAXFTDpcifuX9xf2svme/23piJdYjMldj24VB8FNmAHRw0MGHzLY
        D78OO17Uo4DocR6nwLu3fKu3qYceho0OY8S/6AmQWzW4JHfjetq+VFmrCOhTRcVaAOmzG8SgQF1
        1Ixpd1i24mHMg3CP7xyPf
X-Received: by 2002:a5d:4a01:: with SMTP id m1mr16159914wrq.343.1569912033921;
        Mon, 30 Sep 2019 23:40:33 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwG35oe0GsHMptBMf1uQzruUCqYxDae/NJu9gMWFRzl8pI9yq4mzh9sccAcxSXQFBWEaaCX+w==
X-Received: by 2002:a5d:4a01:: with SMTP id m1mr16159899wrq.343.1569912033693;
        Mon, 30 Sep 2019 23:40:33 -0700 (PDT)
Received: from orion.maiolino.org (ovpn-brq.redhat.com. [213.175.37.11])
        by smtp.gmail.com with ESMTPSA id a7sm31445452wra.43.2019.09.30.23.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 23:40:33 -0700 (PDT)
Date:   Tue, 1 Oct 2019 08:40:31 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] xfs_db: btheight should check geometry more
 carefully
Message-ID: <20191001064030.6cx6ibw35v7inc77@orion.maiolino.org>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        sandeen@sandeen.net, linux-xfs@vger.kernel.org
References: <156944764785.303060.15428657522073378525.stgit@magnolia>
 <156944765385.303060.16945955453073433913.stgit@magnolia>
 <20190926190911.GG9916@magnolia>
MIME-Version: 1.0
In-Reply-To: <20190926190911.GG9916@magnolia>
User-Agent: NeoMutt/20180716
X-MC-Unique: wzt8_kD7MJyilry40he9TQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 26, 2019 at 12:09:11PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> The btheight command needs to check user-supplied geometry more
> carefully so that we don't hit floating point exceptions.
>=20
> Coverity-id: 1453661, 1453659
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good to me

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  db/btheight.c |   88 +++++++++++++++++++++++++++++++++++++++++++++++++++=
++----
>  1 file changed, 82 insertions(+), 6 deletions(-)
>=20
> diff --git a/db/btheight.c b/db/btheight.c
> index 289e5d84..8aa17c89 100644
> --- a/db/btheight.c
> +++ b/db/btheight.c
> @@ -138,6 +138,10 @@ construct_records_per_block(
>  =09=09perror(p);
>  =09=09goto out;
>  =09}
> +=09if (record_size =3D=3D 0) {
> +=09=09fprintf(stderr, _("%s: record size cannot be zero.\n"), tag);
> +=09=09goto out;
> +=09}
> =20
>  =09p =3D strtok(NULL, ":");
>  =09if (!p) {
> @@ -149,6 +153,10 @@ construct_records_per_block(
>  =09=09perror(p);
>  =09=09goto out;
>  =09}
> +=09if (key_size =3D=3D 0) {
> +=09=09fprintf(stderr, _("%s: key size cannot be zero.\n"), tag);
> +=09=09goto out;
> +=09}
> =20
>  =09p =3D strtok(NULL, ":");
>  =09if (!p) {
> @@ -160,6 +168,10 @@ construct_records_per_block(
>  =09=09perror(p);
>  =09=09goto out;
>  =09}
> +=09if (ptr_size =3D=3D 0) {
> +=09=09fprintf(stderr, _("%s: pointer size cannot be zero.\n"), tag);
> +=09=09goto out;
> +=09}
> =20
>  =09p =3D strtok(NULL, ":");
>  =09if (!p) {
> @@ -180,6 +192,27 @@ construct_records_per_block(
>  =09=09goto out;
>  =09}
> =20
> +=09if (record_size > blocksize) {
> +=09=09fprintf(stderr,
> +_("%s: record size must be less than selected block size (%u bytes).\n")=
,
> +=09=09=09tag, blocksize);
> +=09=09goto out;
> +=09}
> +
> +=09if (key_size > blocksize) {
> +=09=09fprintf(stderr,
> +_("%s: key size must be less than selected block size (%u bytes).\n"),
> +=09=09=09tag, blocksize);
> +=09=09goto out;
> +=09}
> +
> +=09if (ptr_size > blocksize) {
> +=09=09fprintf(stderr,
> +_("%s: pointer size must be less than selected block size (%u bytes).\n"=
),
> +=09=09=09tag, blocksize);
> +=09=09goto out;
> +=09}
> +
>  =09p =3D strtok(NULL, ":");
>  =09if (p) {
>  =09=09fprintf(stderr,
> @@ -211,13 +244,24 @@ report(
>  =09int=09=09=09ret;
> =20
>  =09ret =3D construct_records_per_block(tag, blocksize, records_per_block=
);
> -=09if (ret) {
> -=09=09printf(_("%s: Unable to determine records per block.\n"),
> -=09=09=09=09tag);
> +=09if (ret)
>  =09=09return;
> -=09}
> =20
>  =09if (report_what & REPORT_MAX) {
> +=09=09if (records_per_block[0] < 2) {
> +=09=09=09fprintf(stderr,
> +_("%s: cannot calculate best case scenario due to leaf geometry underflo=
w.\n"),
> +=09=09=09=09tag);
> +=09=09=09return;
> +=09=09}
> +
> +=09=09if (records_per_block[1] < 4) {
> +=09=09=09fprintf(stderr,
> +_("%s: cannot calculate best case scenario due to node geometry underflo=
w.\n"),
> +=09=09=09=09tag);
> +=09=09=09return;
> +=09=09}
> +
>  =09=09printf(
>  _("%s: best case per %u-byte block: %u records (leaf) / %u keyptrs (node=
)\n"),
>  =09=09=09=09tag, blocksize, records_per_block[0],
> @@ -230,6 +274,20 @@ _("%s: best case per %u-byte block: %u records (leaf=
) / %u keyptrs (node)\n"),
>  =09=09records_per_block[0] /=3D 2;
>  =09=09records_per_block[1] /=3D 2;
> =20
> +=09=09if (records_per_block[0] < 1) {
> +=09=09=09fprintf(stderr,
> +_("%s: cannot calculate worst case scenario due to leaf geometry underfl=
ow.\n"),
> +=09=09=09=09tag);
> +=09=09=09return;
> +=09=09}
> +
> +=09=09if (records_per_block[1] < 2) {
> +=09=09=09fprintf(stderr,
> +_("%s: cannot calculate worst case scenario due to node geometry underfl=
ow.\n"),
> +=09=09=09=09tag);
> +=09=09=09return;
> +=09=09}
> +
>  =09=09printf(
>  _("%s: worst case per %u-byte block: %u records (leaf) / %u keyptrs (nod=
e)\n"),
>  =09=09=09=09tag, blocksize, records_per_block[0],
> @@ -284,8 +342,26 @@ btheight_f(
>  =09=09}
>  =09}
> =20
> -=09if (argc =3D=3D optind || blocksize <=3D 0 || blocksize > INT_MAX ||
> -=09    nr_records =3D=3D 0) {
> +=09if (nr_records =3D=3D 0) {
> +=09=09fprintf(stderr,
> +_("Number of records must be greater than zero.\n"));
> +=09=09return 0;
> +=09}
> +
> +=09if (blocksize > INT_MAX) {
> +=09=09fprintf(stderr,
> +_("The largest block size this command will consider is %u bytes.\n"),
> +=09=09=09INT_MAX);
> +=09=09return 0;
> +=09}
> +
> +=09if (blocksize < 128) {
> +=09=09fprintf(stderr,
> +_("The smallest block size this command will consider is 128 bytes.\n"))=
;
> +=09=09return 0;
> +=09}
> +
> +=09if (argc =3D=3D optind) {
>  =09=09btheight_help();
>  =09=09return 0;
>  =09}

--=20
Carlos

