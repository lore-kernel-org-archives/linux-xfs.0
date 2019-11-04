Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7782CA9ED3
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 15:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 943D020663
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 15:22:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z2bvxrk5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728558AbfKDPWi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 10:22:38 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:38078 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727796AbfKDPWi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 10:22:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572880957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m5L++cH1qda+dyMDT6wDlmXkbFBFCrnRbNRJOkIzGGs=;
        b=Z2bvxrk57z64miTE2k0BbxWfR0uMvqOp6Wi620tpO/ZgUkH5tYnNAJkVyj7WDB3xzLA1vL
        BBzMfeVv5mweX9dB6lEWBB5S/z894ShpAnmWr3HnzqR3etjQ1g79LJr6PXOevLIsQG+SJq
        FRWm0jpDebLT58KELTY0VK+68NTthw0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-rvxUKfuKOCy5VGNC981eWg-1; Mon, 04 Nov 2019 10:22:35 -0500
Received: by mail-wm1-f71.google.com with SMTP id g17so6483638wmc.4
        for <linux-xfs@vger.kernel.org>; Mon, 04 Nov 2019 07:22:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=NNlMdgCUCpwKenX+nDG907ztgicT7FTcWXERXlwm7hw=;
        b=jmc6iMWYWzsRLspaqZwMgzIqzI3BMYlRFW5m1MEM7JLce0uv4FNsxW7Cw6NZhGWuJ0
         B69jYt4hvalUAWDaIlYQNPmlae/j4BObDOr6uvNiD/uJxohEF2x+a/CgWNaxmfu7t2Ld
         lM4qhu/wdQkt2hoJpedjQnuQI4CX1wuGA4jmYIL4iGwXm1qABNc8H7pT+CcRjUNcjcMY
         zbDrONHTp6yV0A/+UfZo4akFIVhFEC4hG0VOOrbDDoTpFIXUMNAF969vcMYBeMzAcUP0
         Pbe/plvq4joUlyFHFiCo3nB3Pqt3pWKbh26NhRmgm7HGmteuQRGqViqkaHLamEFPs+Jy
         oCJQ==
X-Gm-Message-State: APjAAAWxaj5e7t7gf7F9qOeN+7P6dw2NAjlpLPaeiJ2Y/cDLI1YOUtHT
        dQn/IhNSbMPPk7R91dXQ+Ydb3fEzDq89spD3zi0WXLERAPneLSz5sHDYQ4YLULTO4e43bGsO2Rh
        HOv1DVTyWCQz6rxXsX6Vp
X-Received: by 2002:adf:9bdc:: with SMTP id e28mr22436671wrc.309.1572880954560;
        Mon, 04 Nov 2019 07:22:34 -0800 (PST)
X-Google-Smtp-Source: APXvYqx+z0hJWEbZY9Gtg2bcY+8Q7oUhuaosv533XudH6D3BXhhoazkh8PU+IwRww2ug4hlEs1OwKQ==
X-Received: by 2002:adf:9bdc:: with SMTP id e28mr22436656wrc.309.1572880954285;
        Mon, 04 Nov 2019 07:22:34 -0800 (PST)
Received: from orion (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id z14sm6216769wrl.60.2019.11.04.07.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 07:22:33 -0800 (PST)
Date:   Mon, 4 Nov 2019 16:22:31 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: relax shortform directory size checks
Message-ID: <20191104152231.j3tzytxow6ulrkq7@orion>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
References: <157281982341.4150947.10288936972373805803.stgit@magnolia>
 <157281982989.4150947.13552708841526849932.stgit@magnolia>
MIME-Version: 1.0
In-Reply-To: <157281982989.4150947.13552708841526849932.stgit@magnolia>
X-MC-Unique: rvxUKfuKOCy5VGNC981eWg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 03, 2019 at 02:23:49PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> Each of the four functions that operate on shortform directories checks
> that the directory's di_size is at least as large as the shortform
> directory header.  This is now checked by the inode fork verifiers
> (di_size is used to allocate if_bytes, and if_bytes is checked against
> the header structure size) so we can turn these checks into ASSERTions.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> ---
>  fs/xfs/libxfs/xfs_dir2_block.c |    8 +-------
>  fs/xfs/libxfs/xfs_dir2_sf.c    |   32 ++++----------------------------
>  2 files changed, 5 insertions(+), 35 deletions(-)
>=20
>=20
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_bloc=
k.c
> index 49e4bc39e7bb..e1afa35141c5 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -1073,13 +1073,7 @@ xfs_dir2_sf_to_block(
>  =09mp =3D dp->i_mount;
>  =09ifp =3D XFS_IFORK_PTR(dp, XFS_DATA_FORK);
>  =09ASSERT(ifp->if_flags & XFS_IFINLINE);
> -=09/*
> -=09 * Bomb out if the shortform directory is way too short.
> -=09 */
> -=09if (dp->i_d.di_size < offsetof(xfs_dir2_sf_hdr_t, parent)) {
> -=09=09ASSERT(XFS_FORCED_SHUTDOWN(mp));
> -=09=09return -EIO;
> -=09}
> +=09ASSERT(dp->i_d.di_size >=3D offsetof(struct xfs_dir2_sf_hdr, parent))=
;
> =20
>  =09oldsfp =3D (xfs_dir2_sf_hdr_t *)ifp->if_u1.if_data;
> =20
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index ae16ca7c422a..d6b164a2fe57 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -277,13 +277,7 @@ xfs_dir2_sf_addname(
>  =09ASSERT(xfs_dir2_sf_lookup(args) =3D=3D -ENOENT);
>  =09dp =3D args->dp;
>  =09ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
> -=09/*
> -=09 * Make sure the shortform value has some of its header.
> -=09 */
> -=09if (dp->i_d.di_size < offsetof(xfs_dir2_sf_hdr_t, parent)) {
> -=09=09ASSERT(XFS_FORCED_SHUTDOWN(dp->i_mount));
> -=09=09return -EIO;
> -=09}
> +=09ASSERT(dp->i_d.di_size >=3D offsetof(struct xfs_dir2_sf_hdr, parent))=
;
>  =09ASSERT(dp->i_df.if_bytes =3D=3D dp->i_d.di_size);
>  =09ASSERT(dp->i_df.if_u1.if_data !=3D NULL);
>  =09sfp =3D (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
> @@ -793,13 +787,7 @@ xfs_dir2_sf_lookup(
>  =09dp =3D args->dp;
> =20
>  =09ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
> -=09/*
> -=09 * Bail out if the directory is way too short.
> -=09 */
> -=09if (dp->i_d.di_size < offsetof(xfs_dir2_sf_hdr_t, parent)) {
> -=09=09ASSERT(XFS_FORCED_SHUTDOWN(dp->i_mount));
> -=09=09return -EIO;
> -=09}
> +=09ASSERT(dp->i_d.di_size >=3D offsetof(struct xfs_dir2_sf_hdr, parent))=
;
>  =09ASSERT(dp->i_df.if_bytes =3D=3D dp->i_d.di_size);
>  =09ASSERT(dp->i_df.if_u1.if_data !=3D NULL);
>  =09sfp =3D (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
> @@ -879,13 +867,7 @@ xfs_dir2_sf_removename(
> =20
>  =09ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
>  =09oldsize =3D (int)dp->i_d.di_size;
> -=09/*
> -=09 * Bail out if the directory is way too short.
> -=09 */
> -=09if (oldsize < offsetof(xfs_dir2_sf_hdr_t, parent)) {
> -=09=09ASSERT(XFS_FORCED_SHUTDOWN(dp->i_mount));
> -=09=09return -EIO;
> -=09}
> +=09ASSERT(oldsize >=3D offsetof(struct xfs_dir2_sf_hdr, parent));
>  =09ASSERT(dp->i_df.if_bytes =3D=3D oldsize);
>  =09ASSERT(dp->i_df.if_u1.if_data !=3D NULL);
>  =09sfp =3D (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
> @@ -963,13 +945,7 @@ xfs_dir2_sf_replace(
>  =09dp =3D args->dp;
> =20
>  =09ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
> -=09/*
> -=09 * Bail out if the shortform directory is way too small.
> -=09 */
> -=09if (dp->i_d.di_size < offsetof(xfs_dir2_sf_hdr_t, parent)) {
> -=09=09ASSERT(XFS_FORCED_SHUTDOWN(dp->i_mount));
> -=09=09return -EIO;
> -=09}
> +=09ASSERT(dp->i_d.di_size >=3D offsetof(struct xfs_dir2_sf_hdr, parent))=
;
>  =09ASSERT(dp->i_df.if_bytes =3D=3D dp->i_d.di_size);
>  =09ASSERT(dp->i_df.if_u1.if_data !=3D NULL);
>  =09sfp =3D (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
>=20

--=20
Carlos

