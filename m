Return-Path: <SRS0=6LQP=Z3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27BE7C43603
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Dec 2019 14:39:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFE14224F8
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Dec 2019 14:39:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="grOGzrti"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729406AbfLEOjC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Dec 2019 09:39:02 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:24041 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729099AbfLEOjC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Dec 2019 09:39:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575556741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SE2/Oibuo7F1qgkzUUg3Yt0j+YnQI8OLszDS4VIZKoI=;
        b=grOGzrtiYsGYmlDF8FDhbbDyQ2Def1ojoEMZrrJnD1CMoRQzG0eN4eTpRgi6U+gUxHj6Xk
        /3DAYRbI4vdp61quQ1o7wo4A8v2xLQGP39kW5GzR/aSJ8k1/X+yVCe8FaIanHH4ulsKhxU
        w5d9wXmPT9KBYbArGDdweSDOT9G/FCI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-jm2WV9KUOum-uanrW3eulg-1; Thu, 05 Dec 2019 09:39:00 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F7F3190A2A9;
        Thu,  5 Dec 2019 14:38:59 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B1B773B3;
        Thu,  5 Dec 2019 14:38:58 +0000 (UTC)
Date:   Thu, 5 Dec 2019 09:38:58 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, alex@zadara.com
Subject: Re: [PATCH 6/6] xfs_repair: check plausibility of root dir pointer
 before trashing it
Message-ID: <20191205143858.GF48368@bfoster>
References: <157547906289.974712.8933333382010386076.stgit@magnolia>
 <157547910268.974712.78208912903649937.stgit@magnolia>
MIME-Version: 1.0
In-Reply-To: <157547910268.974712.78208912903649937.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: jm2WV9KUOum-uanrW3eulg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 04, 2019 at 09:05:02AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> If sb_rootino doesn't point to where we think mkfs should have allocated
> the root directory, check to see if the alleged root directory actually
> looks like a root directory.  If so, we'll let it live because someone
> could have changed sunit since formatting time, and that changes the
> root directory inode estimate.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  repair/xfs_repair.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
>=20
>=20
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index abd568c9..b0407f4b 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -426,6 +426,37 @@ _("would reset superblock %s inode pointer to %"PRIu=
64"\n"),
>  =09*ino =3D expected_ino;
>  }
> =20
> +/* Does the root directory inode look like a plausible root directory? *=
/
> +static bool
> +has_plausible_rootdir(
> +=09struct xfs_mount=09*mp)
> +{
> +=09struct xfs_inode=09*ip;
> +=09xfs_ino_t=09=09ino;
> +=09int=09=09=09error;
> +=09bool=09=09=09ret =3D false;
> +
> +=09error =3D -libxfs_iget(mp, NULL, mp->m_sb.sb_rootino, 0, &ip,
> +=09=09=09&xfs_default_ifork_ops);
> +=09if (error)
> +=09=09goto out;
> +=09if (!S_ISDIR(VFS_I(ip)->i_mode))
> +=09=09goto out_rele;
> +
> +=09error =3D -libxfs_dir_lookup(NULL, ip, &xfs_name_dotdot, &ino, NULL);
> +=09if (error)
> +=09=09goto out_rele;
> +
> +=09/* The root directory '..' entry points to the directory. */
> +=09if (ino =3D=3D mp->m_sb.sb_rootino)
> +=09=09ret =3D true;
> +
> +out_rele:
> +=09libxfs_irele(ip);
> +out:
> +=09return ret;
> +}
> +
>  /*
>   * Make sure that the first 3 inodes in the filesystem are the root dire=
ctory,
>   * the realtime bitmap, and the realtime summary, in that order.
> @@ -436,6 +467,20 @@ calc_mkfs(
>  {
>  =09xfs_ino_t=09=09rootino =3D libxfs_ialloc_calc_rootino(mp, -1);
> =20
> +=09/*
> +=09 * If the root inode isn't where we think it is, check its plausibili=
ty
> +=09 * as a root directory.  It's possible that somebody changed sunit
> +=09 * since the filesystem was created, which can change the value of th=
e
> +=09 * above computation.  Don't blow up the root directory if this is th=
e
> +=09 * case.
> +=09 */
> +=09if (mp->m_sb.sb_rootino !=3D rootino && has_plausible_rootdir(mp)) {
> +=09=09do_warn(
> +_("sb root inode value %" PRIu64 " inconsistent with alignment (expected=
 %"PRIu64")\n"),
> +=09=09=09mp->m_sb.sb_rootino, rootino);
> +=09=09rootino =3D mp->m_sb.sb_rootino;
> +=09}
> +

A slightly unfortunate side effect of this is that there's seemingly no
straightforward way for a user to "clear" this state/warning. We've
solved the major problem by allowing repair to handle this condition,
but AFAICT this warning will persist unless the stripe unit is changed
back to its original value.

IOW, what if this problem exists simply because a user made a mistake
and wants to undo it? It's probably easy enough for us to say "use
whatever you did at mkfs time," but what if that's unknown or was set
automatically? I feel like that is the type of thing that in practice
could result in unnecessary bugs or error reports unless the tool can
make a better suggestion to the end user. For example, could we check
the geometry on secondary supers (if they exist) against the current
rootino and use that as a secondary form of verification and/or suggest
the user reset to that geometry (if desired)? OTOH, I guess we'd have to
consider what happens if the filesystem was grown in that scenario too..
:/

(Actually on a quick test, it looks like growfs updates every super,
even preexisting..).

Brian

>  =09ensure_fixed_ino(&mp->m_sb.sb_rootino, rootino,
>  =09=09=09_("root"));
>  =09ensure_fixed_ino(&mp->m_sb.sb_rbmino, rootino + 1,
>=20

