Return-Path: <SRS0=q11v=YV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16701CA9EC0
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 18:18:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD8F6214B2
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 18:18:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XvfROCx5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733170AbfJ1SSU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 14:18:20 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27195 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730690AbfJ1SSU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 14:18:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572286698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9RHisSs84v8zR0Xr4TnlpboEg/mihm2sAKX/R9YyRw4=;
        b=XvfROCx52/H/ml4ptwWWcYZ/IoZ7s0MfmgOnGthuzGywGGcmUNyh1CmRBKM/XMFy3QM+w4
        vCXFvldTpe7w/RyTXLMXg3sVWP6VBCdr9OdgI5aTHpfLVaQySM32AM2qd/VUjCuTIrmgD4
        D+ya/1GLQrNfEkSedYxuwYHnZ1suNOo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-7GRbqkmMOKOU5BE96Az4_w-1; Mon, 28 Oct 2019 14:18:16 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E396C180496F;
        Mon, 28 Oct 2019 18:18:15 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E46C60850;
        Mon, 28 Oct 2019 18:18:15 +0000 (UTC)
Date:   Mon, 28 Oct 2019 14:18:13 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: check attribute leaf block structure
Message-ID: <20191028181813.GB26529@bfoster>
References: <157198048552.2873445.18067788660614948888.stgit@magnolia>
 <157198049357.2873445.8604948103647704008.stgit@magnolia>
MIME-Version: 1.0
In-Reply-To: <157198049357.2873445.8604948103647704008.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: 7GRbqkmMOKOU5BE96Az4_w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 24, 2019 at 10:14:53PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> Add missing structure checks in the attribute leaf verifier.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c |   63 +++++++++++++++++++++++++++++++++++=
+++++-
>  1 file changed, 61 insertions(+), 2 deletions(-)
>=20
>=20
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.=
c
> index ec7921e07f69..8dea3a273029 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -232,6 +232,57 @@ xfs_attr3_leaf_hdr_to_disk(
>  =09}
>  }
> =20
> +static xfs_failaddr_t
> +xfs_attr3_leaf_verify_entry(
> +=09struct xfs_mount=09=09=09*mp,
> +=09char=09=09=09=09=09*buf_end,
> +=09struct xfs_attr_leafblock=09=09*leaf,
> +=09struct xfs_attr3_icleaf_hdr=09=09*leafhdr,
> +=09struct xfs_attr_leaf_entry=09=09*ent,
> +=09int=09=09=09=09=09idx,
> +=09__u32=09=09=09=09=09*last_hashval)
> +{
> +=09struct xfs_attr_leaf_name_local=09=09*lentry;
> +=09struct xfs_attr_leaf_name_remote=09*rentry;
> +=09char=09=09=09=09=09*name_end;
> +=09unsigned int=09=09=09=09nameidx;
> +=09unsigned int=09=09=09=09namesize;
> +=09__u32=09=09=09=09=09hashval;
> +
> +=09/* hash order check */
> +=09hashval =3D be32_to_cpu(ent->hashval);
> +=09if (hashval < *last_hashval)
> +=09=09return __this_address;
> +=09*last_hashval =3D hashval;
> +
> +=09nameidx =3D be16_to_cpu(ent->nameidx);
> +=09if (nameidx < leafhdr->firstused || nameidx >=3D mp->m_attr_geo->blks=
ize)
> +=09=09return __this_address;
> +
> +=09/* Check the name information. */
> +=09if (ent->flags & XFS_ATTR_LOCAL) {
> +=09=09lentry =3D xfs_attr3_leaf_name_local(leaf, idx);
> +=09=09namesize =3D xfs_attr_leaf_entsize_local(lentry->namelen,
> +=09=09=09=09be16_to_cpu(lentry->valuelen));
> +=09=09name_end =3D (char *)lentry + namesize;
> +=09=09if (lentry->namelen =3D=3D 0)
> +=09=09=09return __this_address;

I think this reads a little better if we check the lentry value before
we use it (same deal with rentry in the branch below).

Also, why the =3D=3D 0 checks specifically? Or IOW, might there also be a
sane max value to check some of these fields against?

> +=09} else {
> +=09=09rentry =3D xfs_attr3_leaf_name_remote(leaf, idx);
> +=09=09namesize =3D xfs_attr_leaf_entsize_remote(rentry->namelen);
> +=09=09name_end =3D (char *)rentry + namesize;
> +=09=09if (rentry->namelen =3D=3D 0)
> +=09=09=09return __this_address;
> +=09=09if (rentry->valueblk =3D=3D 0)
> +=09=09=09return __this_address;

Hmm.. ISTR that it's currently possible to have ->valueblk =3D=3D 0 on an
incomplete remote attr after a crash. That's not ideal and hopefully
fixed up after the xattr intent stuff lands, but in the meantime I
thought we had code sprinkled around somewhere to fix that up after the
fact. Would this turn that scenario into a metadata I/O error?

Brian

> +=09}
> +
> +=09if (name_end > buf_end)
> +=09=09return __this_address;
> +
> +=09return NULL;
> +}
> +
>  static xfs_failaddr_t
>  xfs_attr3_leaf_verify(
>  =09struct xfs_buf=09=09=09*bp)
> @@ -240,7 +291,10 @@ xfs_attr3_leaf_verify(
>  =09struct xfs_mount=09=09*mp =3D bp->b_mount;
>  =09struct xfs_attr_leafblock=09*leaf =3D bp->b_addr;
>  =09struct xfs_attr_leaf_entry=09*entries;
> +=09struct xfs_attr_leaf_entry=09*ent;
> +=09char=09=09=09=09*buf_end;
>  =09uint32_t=09=09=09end;=09/* must be 32bit - see below */
> +=09__u32=09=09=09=09last_hashval =3D 0;
>  =09int=09=09=09=09i;
>  =09xfs_failaddr_t=09=09=09fa;
> =20
> @@ -273,8 +327,13 @@ xfs_attr3_leaf_verify(
>  =09    (char *)bp->b_addr + ichdr.firstused)
>  =09=09return __this_address;
> =20
> -=09/* XXX: need to range check rest of attr header values */
> -=09/* XXX: hash order check? */
> +=09buf_end =3D (char *)bp->b_addr + mp->m_attr_geo->blksize;
> +=09for (i =3D 0, ent =3D entries; i < ichdr.count; ent++, i++) {
> +=09=09fa =3D xfs_attr3_leaf_verify_entry(mp, buf_end, leaf, &ichdr,
> +=09=09=09=09ent, i, &last_hashval);
> +=09=09if (fa)
> +=09=09=09return fa;
> +=09}
> =20
>  =09/*
>  =09 * Quickly check the freemap information.  Attribute data has to be
>=20

