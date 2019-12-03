Return-Path: <SRS0=2geO=ZZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7648DC432C3
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 13:03:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C390206EC
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 13:03:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="exWkBOqz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbfLCNDK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Dec 2019 08:03:10 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:20485 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725954AbfLCNDK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Dec 2019 08:03:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575378189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/I10WIW6cAIwQwtNfIjmM2x5OVKJoRKklXQ6mpjIC3E=;
        b=exWkBOqzyY6a20favEHSDXcch7jcxaGHJ8EwI6TEXFF0i3FHUl2EEEftZ9o5dIcqdRW1bk
        gQQm4WM7R8VmBfKdE0pqvT7E+sHwR/1//CTW2BWjflgOqWYEDwsMrR4WRRQlJtaiuNBYLd
        X5IdeZMZIC2aGwJ2uzKtK/WPh2I8hzg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-asEA3fXKNXaAbAQq5hH8IA-1; Tue, 03 Dec 2019 08:03:08 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49302477;
        Tue,  3 Dec 2019 13:03:07 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C0D6D608E2;
        Tue,  3 Dec 2019 13:03:06 +0000 (UTC)
Date:   Tue, 3 Dec 2019 08:03:06 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, alex@zadara.com
Subject: Re: [PATCH 4/4] xfs_repair: check plausiblitiy of root dir pointer
Message-ID: <20191203130306.GB18418@bfoster>
References: <157530815855.126767.7523979488668040754.stgit@magnolia>
 <157530818573.126767.13434243816626977089.stgit@magnolia>
MIME-Version: 1.0
In-Reply-To: <157530818573.126767.13434243816626977089.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: asEA3fXKNXaAbAQq5hH8IA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 02, 2019 at 09:36:25AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> If sb_rootino doesn't point to where we think mkfs was supposed to have
> preallocated an inode chunk, check to see if the alleged root directory
> actually looks like a root directory.  If so, we'll let it go because
> someone could have changed sunit since formatting time.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  repair/xfs_repair.c |   50 +++++++++++++++++++++++++++++++++++++++++++++=
++++-
>  1 file changed, 49 insertions(+), 1 deletion(-)
>=20
>=20
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 6798b88c..f6134cca 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -395,12 +395,60 @@ do_log(char const *msg, ...)
>  =09va_end(args);
>  }
> =20
> +/*
> + * If sb_rootino points to a different inode than we were expecting, try
> + * loading the alleged root inode to see if it's a plausibly a root dire=
ctory.
> + * If so, we'll readjust the computations.

"... readjust the calculated inode chunk range such that the root inode
is the first inode in the chunk."

> + */
> +static void
> +check_misaligned_root(
> +=09struct xfs_mount=09*mp)
> +{
> +=09struct xfs_inode=09*ip;
> +=09xfs_ino_t=09=09ino;
> +=09int=09=09=09error;
> +
> +=09error =3D -libxfs_iget(mp, NULL, mp->m_sb.sb_rootino, 0, &ip,
> +=09=09=09&xfs_default_ifork_ops);
> +=09if (error)
> +=09=09return;
> +=09if (!S_ISDIR(VFS_I(ip)->i_mode))
> +=09=09goto out_rele;
> +
> +=09error =3D -libxfs_dir_lookup(NULL, ip, &xfs_name_dotdot, &ino, NULL);
> +=09if (error)
> +=09=09goto out_rele;
> +
> +=09if (ino =3D=3D mp->m_sb.sb_rootino) {
> +=09=09do_warn(
> +_("sb root inode value %" PRIu64 " inconsistent with calculated value %u=
 but looks like a root directory\n"),

Just a nit, but I think the error would be more informative if it just
said something like:

"sb root inode %" PRIu64 " inconsistent with alignment (expected rootino %u=
)."

> +=09=09=09mp->m_sb.sb_rootino, first_prealloc_ino);
> +=09=09last_prealloc_ino +=3D (int)ino - first_prealloc_ino;
> +=09=09first_prealloc_ino =3D ino;

Why assume ino > first_prealloc_ino? How about we just assign
last_prealloc_ino as done in _find_prealloc()?

Brian

> +=09}
> +
> +out_rele:
> +=09libxfs_irele(ip);
> +}
> +
>  static void
> -calc_mkfs(xfs_mount_t *mp)
> +calc_mkfs(
> +=09struct xfs_mount=09*mp)
>  {
>  =09libxfs_ialloc_find_prealloc(mp, &first_prealloc_ino,
>  =09=09=09&last_prealloc_ino);
> =20
> +=09/*
> +=09 * If the root inode isn't where we think it is, check its plausibili=
ty
> +=09 * as a root directory.  It's possible that somebody changed sunit si=
nce
> +=09 * the filesystem was created, which can change the value of the abov=
e
> +=09 * computation.  Try to avoid blowing up the filesystem if this is th=
e
> +=09 * case.
> +=09 */
> +=09if (mp->m_sb.sb_rootino !=3D NULLFSINO &&
> +=09    mp->m_sb.sb_rootino !=3D first_prealloc_ino)
> +=09=09check_misaligned_root(mp);
> +
>  =09/*
>  =09 * now the first 3 inodes in the system
>  =09 */
>=20

