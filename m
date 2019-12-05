Return-Path: <SRS0=6LQP=Z3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BTC_ID,PDS_BTC_MSGID,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F28E6C43603
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Dec 2019 14:36:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA58821835
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Dec 2019 14:36:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BR35VCPx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729402AbfLEOg0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Dec 2019 09:36:26 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24303 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729240AbfLEOg0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Dec 2019 09:36:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575556584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yOnBKe22k34/IM5ykM4Es1FCKN4cc1+MKUWYN70ZEbc=;
        b=BR35VCPxdoqUzprqgWbUTJyZKnswnFqiR+nmFF8Uq/u7ljjn8qLWhR3AITs7wRdkj2zSaC
        AYH4qfLlRSuuFyGUzNaHLClATBz1qvBJvsKUrgKRz5XbPUvufuOXDp0VyrCfIt5aDnNoWt
        dbowVzKRcE7lcnw7M/nRjlucYnhtawI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-ebq4hARdN1KZfaQOreGSpA-1; Thu, 05 Dec 2019 09:36:20 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2C01911E8;
        Thu,  5 Dec 2019 14:36:19 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 225DC194B2;
        Thu,  5 Dec 2019 14:36:19 +0000 (UTC)
Date:   Thu, 5 Dec 2019 09:36:18 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Alex Lyakas <alex@zadara.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: don't commit sunit/swidth updates to disk if that
 would cause repair failures
Message-ID: <20191205143618.GA48368@bfoster>
References: <20191204170340.GR7335@magnolia>
MIME-Version: 1.0
In-Reply-To: <20191204170340.GR7335@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: ebq4hARdN1KZfaQOreGSpA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 04, 2019 at 09:03:40AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> Alex Lyakas reported[1] that mounting an xfs filesystem with new sunit
> and swidth values could cause xfs_repair to fail loudly.  The problem
> here is that repair calculates the where mkfs should have allocated the
> root inode, based on the superblock geometry.  The allocation decisions
> depend on sunit, which means that we really can't go updating sunit if
> it would lead to a subsequent repair failure on an otherwise correct
> filesystem.
>=20
> Port the computation code from xfs_repair and teach mount to avoid the
> ondisk update if it would cause problems for repair.  We allow the mount
> to proceed (and new allocations will reflect this new geometry) because
> we've never screened this kind of thing before.
>=20
> [1] https://lore.kernel.org/linux-xfs/20191125130744.GA44777@bfoster/T/#m=
00f9594b511e076e2fcdd489d78bc30216d72a7d
>=20
> Reported-by: Alex Lyakas <alex@zadara.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: compute the root inode location directly
> ---
>  fs/xfs/libxfs/xfs_ialloc.c |   81 ++++++++++++++++++++++++++++++++++++++=
++++++
>  fs/xfs/libxfs/xfs_ialloc.h |    1 +
>  fs/xfs/xfs_mount.c         |   51 ++++++++++++++++++----------
>  3 files changed, 115 insertions(+), 18 deletions(-)
>=20
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 988cde7744e6..6df9bcc96251 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -2909,3 +2909,84 @@ xfs_ialloc_setup_geometry(
>  =09else
>  =09=09igeo->ialloc_align =3D 0;
>  }
> +
> +/*
> + * Compute the location of the root directory inode that is laid out by =
mkfs.
> + * The @sunit parameter will be copied from the superblock if it is nega=
tive.
> + */
> +xfs_ino_t
> +xfs_ialloc_calc_rootino(
> +=09struct xfs_mount=09*mp,
> +=09int=09=09=09sunit)
> +{
> +=09struct xfs_ino_geometry=09*igeo =3D M_IGEO(mp);
> +=09xfs_agino_t=09=09first_agino;
> +=09xfs_agblock_t=09=09first_bno;
> +
> +=09if (sunit < 0)
> +=09=09sunit =3D mp->m_sb.sb_unit;
> +
> +=09/*
> +=09 * Pre-calculate the geometry of ag 0. We know what it looks like
> +=09 * because we know what mkfs does: 2 allocation btree roots (by block
> +=09 * and by size), the inode allocation btree root, the free inode
> +=09 * allocation btree root (if enabled) and some number of blocks to
> +=09 * prefill the agfl.
> +=09 *
> +=09 * Because the current shape of the btrees may differ from the curren=
t
> +=09 * shape, we open code the mkfs freelist block count here. mkfs creat=
es
> +=09 * single level trees, so the calculation is pretty straight forward =
for
> +=09 * the trees that use the AGFL.
> +=09 */
> +

I know this code is lifted from userspace, but.. "the current shape of
the btrees may differ from the current shape, .." Eh?

> +=09/* free space by block btree root comes after the ag headers */
> +=09first_bno =3D howmany(4 * mp->m_sb.sb_sectsize, mp->m_sb.sb_blocksize=
);
> +
> +=09/* free space by length btree root */
> +=09first_bno +=3D 1;
> +
> +=09/* inode btree root */
> +=09first_bno +=3D 1;
> +
> +=09/* agfl */
> +=09first_bno +=3D (2 * min_t(xfs_agblock_t, 2, mp->m_ag_maxlevels)) + 1;
> +

This is a little subtle from the userspace code. The extra +1 here is
where we go from pointing at metadata blocks (i.e. bnobt root) to the
first free block (i.e., past metadata blocks), right? If so, I wonder if
this should be incorporated either at the beginning or end with a
comment for explanation (i.e. "Start by pointing at the first block
after the AG headers and increment by size of applicable metadata to
locate the first free block ...").

I'm guessing this is a historical artifact of the userspace code as
features were added. The fact that userspace uses different variables
somewhat helps self-document in that context, and we lose that here.

> +=09if (xfs_sb_version_hasfinobt(&mp->m_sb))
> +=09=09first_bno++;
> +
> +=09if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
> +=09=09first_bno++;
> +=09=09/* agfl blocks */
> +=09=09first_bno +=3D min_t(xfs_agblock_t, 2, mp->m_rmap_maxlevels);
> +=09}
> +
> +=09if (xfs_sb_version_hasreflink(&mp->m_sb))
> +=09=09first_bno++;
> +
> +=09/*
> +=09 * If the log is allocated in the first allocation group we need to
> +=09 * add the number of blocks used by the log to the above calculation.
> +=09 *
> +=09 * This can happens with filesystems that only have a single
> +=09 * allocation group, or very odd geometries created by old mkfs
> +=09 * versions on very small filesystems.
> +=09 */
> +=09if (mp->m_sb.sb_logstart &&
> +=09    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) =3D=3D 0)
> +=09=09 first_bno +=3D mp->m_sb.sb_logblocks;
> +
> +=09/*
> +=09 * ditto the location of the first inode chunks in the fs ('/')
> +=09 */
> +=09if (xfs_sb_version_hasdalign(&mp->m_sb) && igeo->ialloc_align > 0) {
> +=09=09first_agino =3D XFS_AGB_TO_AGINO(mp, roundup(first_bno, sunit));
> +=09} else if (xfs_sb_version_hasalign(&mp->m_sb) &&
> +=09=09   mp->m_sb.sb_inoalignmt > 1)  {
> +=09=09first_agino =3D XFS_AGB_TO_AGINO(mp,
> +=09=09=09=09roundup(first_bno, mp->m_sb.sb_inoalignmt));
> +=09} else  {
> +=09=09first_agino =3D XFS_AGB_TO_AGINO(mp, first_bno);
> +=09}
> +
> +=09return XFS_AGINO_TO_INO(mp, 0, first_agino);
> +}
> diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
> index 323592d563d5..72b3468b97b1 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.h
> +++ b/fs/xfs/libxfs/xfs_ialloc.h
> @@ -152,5 +152,6 @@ int xfs_inobt_insert_rec(struct xfs_btree_cur *cur, u=
int16_t holemask,
> =20
>  int xfs_ialloc_cluster_alignment(struct xfs_mount *mp);
>  void xfs_ialloc_setup_geometry(struct xfs_mount *mp);
> +xfs_ino_t xfs_ialloc_calc_rootino(struct xfs_mount *mp, int sunit);
> =20
>  #endif=09/* __XFS_IALLOC_H__ */
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index fca65109cf24..a4eb3ae34a84 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -363,9 +363,10 @@ xfs_readsb(
>   * Update alignment values based on mount options and sb values
>   */
>  STATIC int
> -xfs_update_alignment(xfs_mount_t *mp)
> +xfs_update_alignment(
> +=09struct xfs_mount=09*mp)
>  {
> -=09xfs_sb_t=09*sbp =3D &(mp->m_sb);
> +=09struct xfs_sb=09=09*sbp =3D &mp->m_sb;
> =20
>  =09if (mp->m_dalign) {
>  =09=09/*
> @@ -398,28 +399,42 @@ xfs_update_alignment(xfs_mount_t *mp)
>  =09=09=09}
>  =09=09}
> =20
> -=09=09/*
> -=09=09 * Update superblock with new values
> -=09=09 * and log changes
> -=09=09 */
> -=09=09if (xfs_sb_version_hasdalign(sbp)) {
> -=09=09=09if (sbp->sb_unit !=3D mp->m_dalign) {
> -=09=09=09=09sbp->sb_unit =3D mp->m_dalign;
> -=09=09=09=09mp->m_update_sb =3D true;
> -=09=09=09}
> -=09=09=09if (sbp->sb_width !=3D mp->m_swidth) {
> -=09=09=09=09sbp->sb_width =3D mp->m_swidth;
> -=09=09=09=09mp->m_update_sb =3D true;
> -=09=09=09}
> -=09=09} else {
> +=09=09/* Update superblock with new values and log changes. */
> +=09=09if (!xfs_sb_version_hasdalign(sbp)) {
>  =09=09=09xfs_warn(mp,
>  =09"cannot change alignment: superblock does not support data alignment"=
);
>  =09=09=09return -EINVAL;
>  =09=09}
> +
> +=09=09if (sbp->sb_unit =3D=3D mp->m_dalign &&
> +=09=09    sbp->sb_width =3D=3D mp->m_swidth)
> +=09=09=09return 0;
> +
> +=09=09/*
> +=09=09 * If the sunit/swidth change would move the precomputed root
> +=09=09 * inode value, we must reject the ondisk change because repair
> +=09=09 * will stumble over that.  However, we allow the mount to
> +=09=09 * proceed because we never rejected this combination before.
> +=09=09 */
> +=09=09if (sbp->sb_rootino !=3D
> +=09=09    xfs_ialloc_calc_rootino(mp, mp->m_dalign)) {
> +=09=09=09xfs_warn(mp,
> +=09"cannot change stripe alignment: would require moving root inode");
> +

FWIW, I read this error message as the mount option was ignored. I don't
much care whether we ignore the mount option or simply the on-disk
update, but the error could be a bit more clear in the latter case.
Also, what is the expected behavior for xfs_info in the latter
situation?

Brian

> +=09=09=09/*
> +=09=09=09 * XXX: Next time we add a new incompat feature, this
> +=09=09=09 * should start returning -EINVAL.
> +=09=09=09 */
> +=09=09=09return 0;
> +=09=09}
> +
> +=09=09sbp->sb_unit =3D mp->m_dalign;
> +=09=09sbp->sb_width =3D mp->m_swidth;
> +=09=09mp->m_update_sb =3D true;
>  =09} else if ((mp->m_flags & XFS_MOUNT_NOALIGN) !=3D XFS_MOUNT_NOALIGN &=
&
>  =09=09    xfs_sb_version_hasdalign(&mp->m_sb)) {
> -=09=09=09mp->m_dalign =3D sbp->sb_unit;
> -=09=09=09mp->m_swidth =3D sbp->sb_width;
> +=09=09mp->m_dalign =3D sbp->sb_unit;
> +=09=09mp->m_swidth =3D sbp->sb_width;
>  =09}
> =20
>  =09return 0;
>=20

