Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E00ECA9EAE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 10:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43CA42087F
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 10:03:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ukotf0Pr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725839AbfJ2KD7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 06:03:59 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:46803 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725776AbfJ2KD6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 06:03:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572343436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7z4HK1MojMj+lhcZekB55U15g69o4fL3HC8ow2dbYd4=;
        b=Ukotf0Pr0T/ARda8NXbWTwPomtlUXYY3moQn7mCPkBs023W+Gu9S35ofmzbFKokohQxuOu
        NEEgKaRkMbk0Iiq5scfhtmBb1zmAwnUtJe49fG1ViK3Kv/qzUr+FFVlc/eDQ6HNw6u95BM
        4nOL36uRwL1jNSmLRQGsMh4msAt9Cfg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-0TQ-X7hINrqVpEOy4pnJQw-1; Tue, 29 Oct 2019 06:03:53 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E7140107AD28;
        Tue, 29 Oct 2019 10:03:52 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F22A60863;
        Tue, 29 Oct 2019 10:03:52 +0000 (UTC)
Date:   Tue, 29 Oct 2019 06:03:50 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/4] xfs: check attribute leaf block structure
Message-ID: <20191029100350.GB41131@bfoster>
References: <157232182246.593721.4902116478429075171.stgit@magnolia>
 <157232182873.593721.10436299832453896943.stgit@magnolia>
MIME-Version: 1.0
In-Reply-To: <157232182873.593721.10436299832453896943.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: 0TQ-X7hINrqVpEOy4pnJQw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 28, 2019 at 09:03:48PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> Add missing structure checks in the attribute leaf verifier.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_attr_leaf.c |   67 +++++++++++++++++++++++++++++++++++=
+++++-
>  1 file changed, 65 insertions(+), 2 deletions(-)
>=20
>=20
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.=
c
> index f0089e862216..bb80a01bcca9 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -232,6 +232,61 @@ xfs_attr3_leaf_hdr_to_disk(
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
> +=09/*
> +=09 * Check the name information.  The namelen fields are u8 so we can't
> +=09 * possibly exceed the maximum name length of 255 bytes.
> +=09 */
> +=09if (ent->flags & XFS_ATTR_LOCAL) {
> +=09=09lentry =3D xfs_attr3_leaf_name_local(leaf, idx);
> +=09=09namesize =3D xfs_attr_leaf_entsize_local(lentry->namelen,
> +=09=09=09=09be16_to_cpu(lentry->valuelen));
> +=09=09name_end =3D (char *)lentry + namesize;
> +=09=09if (lentry->namelen =3D=3D 0)
> +=09=09=09return __this_address;
> +=09} else {
> +=09=09rentry =3D xfs_attr3_leaf_name_remote(leaf, idx);
> +=09=09namesize =3D xfs_attr_leaf_entsize_remote(rentry->namelen);
> +=09=09name_end =3D (char *)rentry + namesize;
> +=09=09if (rentry->namelen =3D=3D 0)
> +=09=09=09return __this_address;
> +=09=09if (!(ent->flags & XFS_ATTR_INCOMPLETE) &&
> +=09=09    rentry->valueblk =3D=3D 0)
> +=09=09=09return __this_address;
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
> @@ -240,7 +295,10 @@ xfs_attr3_leaf_verify(
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
> @@ -273,8 +331,13 @@ xfs_attr3_leaf_verify(
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

