Return-Path: <SRS0=6LQP=Z3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EAF6C2BD09
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Dec 2019 14:38:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF1122464E
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Dec 2019 14:38:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R5vgDyNM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729519AbfLEOiD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Dec 2019 09:38:03 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:26711 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729406AbfLEOiD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Dec 2019 09:38:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575556682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UvFyWjb8Egm7FnfCgjZ12xNjbZpgnKgl2tC8fjV+nD0=;
        b=R5vgDyNMcT+rhMt3C/xrXJbID7W2jsp8ue9PVq/ctaaQiTnhJ0QIswsrqAzn6VEvRmucWz
        4jgGvlC0bI5SagNvxFdrH9pXduxnogL4lvBtbRur/6CisIAKaTSk4Ax+QsPRFgkmPopIme
        n6CL56RaK8lFvteWord7HdtbjFxzzOo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-9vo-SCzxOluy4pwwRn8JJw-1; Thu, 05 Dec 2019 09:38:01 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2CF210866E2;
        Thu,  5 Dec 2019 14:37:59 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6644E6047B;
        Thu,  5 Dec 2019 14:37:59 +0000 (UTC)
Date:   Thu, 5 Dec 2019 09:37:59 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, alex@zadara.com
Subject: Re: [PATCH 5/6] xfs_repair: use libxfs function to calculate root
 inode location
Message-ID: <20191205143759.GE48368@bfoster>
References: <157547906289.974712.8933333382010386076.stgit@magnolia>
 <157547909625.974712.1367837692462388821.stgit@magnolia>
MIME-Version: 1.0
In-Reply-To: <157547909625.974712.1367837692462388821.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: 9vo-SCzxOluy4pwwRn8JJw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 04, 2019 at 09:04:56AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> Use libxfs_ialloc_calc_rootino to compute the location of the root
> inode, and improve the function comments while we're at it.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  repair/globals.c    |    5 ---
>  repair/globals.h    |    5 ---
>  repair/xfs_repair.c |   78 +++++++--------------------------------------=
------
>  3 files changed, 10 insertions(+), 78 deletions(-)
>=20
>=20
> diff --git a/repair/globals.c b/repair/globals.c
> index 8a60e706..299bacd1 100644
> --- a/repair/globals.c
> +++ b/repair/globals.c
> @@ -72,11 +72,6 @@ int=09lost_uquotino;
>  int=09lost_gquotino;
>  int=09lost_pquotino;
> =20
> -xfs_agino_t=09first_prealloc_ino;
> -xfs_agblock_t=09bnobt_root;
> -xfs_agblock_t=09bcntbt_root;
> -xfs_agblock_t=09inobt_root;
> -
>  /* configuration vars -- fs geometry dependent */
> =20
>  int=09=09inodes_per_block;
> diff --git a/repair/globals.h b/repair/globals.h
> index 2ed5c894..953e3dfb 100644
> --- a/repair/globals.h
> +++ b/repair/globals.h
> @@ -113,11 +113,6 @@ extern int=09=09lost_uquotino;
>  extern int=09=09lost_gquotino;
>  extern int=09=09lost_pquotino;
> =20
> -extern xfs_agino_t=09first_prealloc_ino;
> -extern xfs_agblock_t=09bnobt_root;
> -extern xfs_agblock_t=09bcntbt_root;
> -extern xfs_agblock_t=09inobt_root;
> -
>  /* configuration vars -- fs geometry dependent */
> =20
>  extern int=09=09inodes_per_block;
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 94673750..abd568c9 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -426,79 +426,21 @@ _("would reset superblock %s inode pointer to %"PRI=
u64"\n"),
>  =09*ino =3D expected_ino;
>  }
> =20
> +/*
> + * Make sure that the first 3 inodes in the filesystem are the root dire=
ctory,
> + * the realtime bitmap, and the realtime summary, in that order.
> + */
>  static void
> -calc_mkfs(xfs_mount_t *mp)
> +calc_mkfs(
> +=09struct xfs_mount=09*mp)
>  {
> -=09xfs_agblock_t=09fino_bno;
> -=09int=09=09do_inoalign;
> -
> -=09do_inoalign =3D M_IGEO(mp)->ialloc_align;
> -
> -=09/*
> -=09 * Pre-calculate the geometry of ag 0. We know what it looks like
> -=09 * because we know what mkfs does: 2 allocation btree roots (by block
> -=09 * and by size), the inode allocation btree root, the free inode
> -=09 * allocation btree root (if enabled) and some number of blocks to
> -=09 * prefill the agfl.
> -=09 *
> -=09 * Because the current shape of the btrees may differ from the curren=
t
> -=09 * shape, we open code the mkfs freelist block count here. mkfs creat=
es
> -=09 * single level trees, so the calculation is pertty straight forward =
for
> -=09 * the trees that use the AGFL.
> -=09 */
> -=09bnobt_root =3D howmany(4 * mp->m_sb.sb_sectsize, mp->m_sb.sb_blocksiz=
e);
> -=09bcntbt_root =3D bnobt_root + 1;
> -=09inobt_root =3D bnobt_root + 2;
> -=09fino_bno =3D inobt_root + (2 * min(2, mp->m_ag_maxlevels)) + 1;
> -=09if (xfs_sb_version_hasfinobt(&mp->m_sb))
> -=09=09fino_bno++;
> -=09if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
> -=09=09fino_bno +=3D min(2, mp->m_rmap_maxlevels); /* agfl blocks */
> -=09=09fino_bno++;
> -=09}
> -=09if (xfs_sb_version_hasreflink(&mp->m_sb))
> -=09=09fino_bno++;
> -
> -=09/*
> -=09 * If the log is allocated in the first allocation group we need to
> -=09 * add the number of blocks used by the log to the above calculation.
> -=09 *
> -=09 * This can happens with filesystems that only have a single
> -=09 * allocation group, or very odd geometries created by old mkfs
> -=09 * versions on very small filesystems.
> -=09 */
> -=09if (mp->m_sb.sb_logstart &&
> -=09    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) =3D=3D 0) {
> -
> -=09=09/*
> -=09=09 * XXX(hch): verify that sb_logstart makes sense?
> -=09=09 */
> -=09=09 fino_bno +=3D mp->m_sb.sb_logblocks;
> -=09}
> -
> -=09/*
> -=09 * ditto the location of the first inode chunks in the fs ('/')
> -=09 */
> -=09if (xfs_sb_version_hasdalign(&mp->m_sb) && do_inoalign)  {
> -=09=09first_prealloc_ino =3D XFS_AGB_TO_AGINO(mp, roundup(fino_bno,
> -=09=09=09=09=09mp->m_sb.sb_unit));
> -=09} else if (xfs_sb_version_hasalign(&mp->m_sb) &&
> -=09=09=09=09=09mp->m_sb.sb_inoalignmt > 1)  {
> -=09=09first_prealloc_ino =3D XFS_AGB_TO_AGINO(mp,
> -=09=09=09=09=09roundup(fino_bno,
> -=09=09=09=09=09=09mp->m_sb.sb_inoalignmt));
> -=09} else  {
> -=09=09first_prealloc_ino =3D XFS_AGB_TO_AGINO(mp, fino_bno);
> -=09}
> +=09xfs_ino_t=09=09rootino =3D libxfs_ialloc_calc_rootino(mp, -1);
> =20
> -=09/*
> -=09 * now the first 3 inodes in the system
> -=09 */
> -=09ensure_fixed_ino(&mp->m_sb.sb_rootino, first_prealloc_ino,
> +=09ensure_fixed_ino(&mp->m_sb.sb_rootino, rootino,
>  =09=09=09_("root"));
> -=09ensure_fixed_ino(&mp->m_sb.sb_rbmino, first_prealloc_ino + 1,
> +=09ensure_fixed_ino(&mp->m_sb.sb_rbmino, rootino + 1,
>  =09=09=09_("realtime bitmap"));
> -=09ensure_fixed_ino(&mp->m_sb.sb_rsumino, first_prealloc_ino + 2,
> +=09ensure_fixed_ino(&mp->m_sb.sb_rsumino, rootino + 2,
>  =09=09=09_("realtime summary"));
>  }
> =20
>=20

