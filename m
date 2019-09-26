Return-Path: <SRS0=9/io=XV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E834C432C2
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 09:11:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26E06222C3
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 09:11:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L2wYshFa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbfIZJL5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Sep 2019 05:11:57 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26284 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbfIZJL5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Sep 2019 05:11:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569489115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BbmjTDrW5mWb+hQVL4QfxP0Eug4Kl5iuBYv7KhJyzrY=;
        b=L2wYshFaYsezaLubof/9/IF7mxWoyyE/xMEZ9UpgceZY/QoAou15XnZjXXfyiZCJM+V2Nw
        iPlJNn8tzjWpabu+UBAcY18VP9VDSe5CK2l2fHXjhT8kLToYowEfRhaceSBLkGKRYd3YEF
        aF1zAQk0MjMfjgyYJi+1NxI54R6d+xg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-oo-aX2BJMiuufxJxI5qiZw-1; Thu, 26 Sep 2019 05:11:52 -0400
Received: by mail-wr1-f71.google.com with SMTP id v18so660746wro.16
        for <linux-xfs@vger.kernel.org>; Thu, 26 Sep 2019 02:11:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=V9NCsEUe1zBS5QYruQMUnf8str7i8WADLPgIyPeiC3s=;
        b=ZffNuElSJ7sOZewhdWGKFXK57cnUbYS9BDsk9hwEpdEDYaIQ+aW5S7H5wUfuYvTv3W
         tNRW3gf6cU76NXkPyPPk3Qt3jgmUJRjgRucXcDPpsuEkEIqoK7n8/CPQzlpc0MHYfh3s
         M1HFedaYguxbgBEJXVzYCEwWpQg9AG4FijMNnyn+x9K5VwjJQ+X1+0EnM2oYwdgQzkMX
         iH82jfPg3TXC6QMrmWMryOGY+3oY5/cLNl7cAn2c/jSHVLM+Dr8Li4sG/8O855koZ+1E
         t+9nJWVCTB0WcEDGsSksvysC50TU3/t3V2/lHvZQ8fn9jIGSsvDxPrau8jZ7M2saBjb8
         /5iQ==
X-Gm-Message-State: APjAAAXlMKy2szsHd/n806kBZt5UgavqXnN73I5o5dikSHi/K+mQD1YK
        lqEl+7/5zQE21w/09mFp7Bjuldq0BgYvFpmJ1MLhQQrLIpWaLDG1JQVUGLHILt1x+6+yehLzFx6
        QxEyELvEqv2IBnmKxI4xP
X-Received: by 2002:a1c:1f47:: with SMTP id f68mr2262907wmf.78.1569489111501;
        Thu, 26 Sep 2019 02:11:51 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxsUoQpf9o1zQtXxnc2q/e5goeFBUTOPhb1DxwC57zQrBLEXJ8XSP8LQiONtI5qsOXi/FSBNg==
X-Received: by 2002:a1c:1f47:: with SMTP id f68mr2262887wmf.78.1569489111239;
        Thu, 26 Sep 2019 02:11:51 -0700 (PDT)
Received: from pegasus.maiolino.io (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id q10sm5663021wrd.39.2019.09.26.02.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2019 02:11:50 -0700 (PDT)
Date:   Thu, 26 Sep 2019 11:11:48 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_db: btheight should check geometry more carefully
Message-ID: <20190926091147.dbjrf5i7rfgmzehb@pegasus.maiolino.io>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        sandeen@sandeen.net, linux-xfs@vger.kernel.org
References: <156944764785.303060.15428657522073378525.stgit@magnolia>
 <156944765385.303060.16945955453073433913.stgit@magnolia>
MIME-Version: 1.0
In-Reply-To: <156944765385.303060.16945955453073433913.stgit@magnolia>
User-Agent: NeoMutt/20180716
X-MC-Unique: oo-aX2BJMiuufxJxI5qiZw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 25, 2019 at 02:40:53PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> The btheight command needs to check user-supplied geometry more
> carefully so that we don't hit floating point exceptions.
>=20
> Coverity-id: 1453661, 1453659
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> =20

Patch looks good, but.


> +=09if (record_size > blocksize) {
> +=09=09fprintf(stderr,
> +=09=09=09_("%s: record size must be less than %u bytes.\n"),

=09Couldn't this message maybe be better saying "less than current blocksiz=
e"?
=09Saying it is less than X bytes sounds kind of meaningless, requiring a
=09trip to the code to understand what exactly 'bytes' mean here.

=09Maybe something like:

=09_("%s: record size must be less than current block size (%u).\n"),


Same for the next two.

> +=09=09=09tag, blocksize);
> +=09=09goto out;
> +=09}
> +
> +=09if (key_size > blocksize) {
> +=09=09fprintf(stderr,
> +=09=09=09_("%s: key size must be less than %u bytes.\n"),
> +=09=09=09tag, blocksize);
> +=09=09goto out;
> +=09}
> +
> +=09if (ptr_size > blocksize) {
> +=09=09fprintf(stderr,
> +=09=09=09_("%s: pointer size must be less than %u bytes.\n"),
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
>=20

--=20
Carlos

