Return-Path: <SRS0=ArDI=ZM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39014C432C0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 14:20:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEF962230E
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 14:20:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gzXLA0Mm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729763AbfKTOUw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Nov 2019 09:20:52 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:47445 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729157AbfKTOUw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 09:20:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574259650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PR/39ZKOkvj6dSQeKrFPNkGT97LHlgS7/EADend5VFs=;
        b=gzXLA0MmOsdBL5gKs++XaFw1BplcrAhyV7rJZ5FEhYfNRCtFWvSbFUiW0eJIB8pbCT+wVW
        sWJX4TOrRhbQuwutb1P1Z56Ut8tNpNBulMZv3wvuU3Fn2kFezBWd0BMRwJ3C8x07ZuNT4N
        bn6zEzBIxgQoVMFtVjbN9syUxxGKEh8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-Y3PRUdvuP7ypkBdiL-wFYg-1; Wed, 20 Nov 2019 09:20:48 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE17580268C;
        Wed, 20 Nov 2019 14:20:47 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 524385F79F;
        Wed, 20 Nov 2019 14:20:47 +0000 (UTC)
Date:   Wed, 20 Nov 2019 09:20:47 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: report ag header corruption errors to the
 health tracking system
Message-ID: <20191120142047.GC15542@bfoster>
References: <157375555426.3692735.1357467392517392169.stgit@magnolia>
 <157375556683.3692735.8136460417251028810.stgit@magnolia>
MIME-Version: 1.0
In-Reply-To: <157375556683.3692735.8136460417251028810.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: Y3PRUdvuP7ypkBdiL-wFYg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 14, 2019 at 10:19:26AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> Whenever we encounter a corrupt AG header, we should report that to the
> health monitoring system for later reporting.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c    |    6 ++++++
>  fs/xfs/libxfs/xfs_health.h   |    6 ++++++
>  fs/xfs/libxfs/xfs_ialloc.c   |    3 +++
>  fs/xfs/libxfs/xfs_refcount.c |    5 ++++-
>  fs/xfs/libxfs/xfs_rmap.c     |    5 ++++-
>  fs/xfs/libxfs/xfs_sb.c       |    2 ++
>  fs/xfs/xfs_health.c          |   17 +++++++++++++++++
>  fs/xfs/xfs_inode.c           |    9 +++++++++
>  8 files changed, 51 insertions(+), 2 deletions(-)
>=20
>=20
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index c284e10af491..e75e3ae6c912 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -26,6 +26,7 @@
>  #include "xfs_log.h"
>  #include "xfs_ag_resv.h"
>  #include "xfs_bmap.h"
> +#include "xfs_health.h"
> =20
>  extern kmem_zone_t=09*xfs_bmap_free_item_zone;
> =20
> @@ -699,6 +700,8 @@ xfs_alloc_read_agfl(
>  =09=09=09mp, tp, mp->m_ddev_targp,
>  =09=09=09XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
>  =09=09=09XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_agfl_buf_ops);
> +=09if (xfs_metadata_is_sick(error))
> +=09=09xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGFL);

Any reason we couldn't do some of these in verifiers? I'm assuming we'd
still need calls in various external corruption checks, but at least we
wouldn't add a requirement to check all future buffer reads, etc.

>  =09if (error)
>  =09=09return error;
>  =09xfs_buf_set_ref(bp, XFS_AGFL_REF);
> @@ -722,6 +725,7 @@ xfs_alloc_update_counters(
>  =09if (unlikely(be32_to_cpu(agf->agf_freeblks) >
>  =09=09     be32_to_cpu(agf->agf_length))) {
>  =09=09xfs_buf_corruption_error(agbp);
> +=09=09xfs_ag_mark_sick(pag, XFS_SICK_AG_AGF);
>  =09=09return -EFSCORRUPTED;
>  =09}
> =20
> @@ -2952,6 +2956,8 @@ xfs_read_agf(
>  =09=09=09mp, tp, mp->m_ddev_targp,
>  =09=09=09XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
>  =09=09=09XFS_FSS_TO_BB(mp, 1), flags, bpp, &xfs_agf_buf_ops);
> +=09if (xfs_metadata_is_sick(error))
> +=09=09xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGF);
>  =09if (error)
>  =09=09return error;
>  =09if (!*bpp)
> diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
> index 3657a9cb8490..ce8954a10c66 100644
> --- a/fs/xfs/libxfs/xfs_health.h
> +++ b/fs/xfs/libxfs/xfs_health.h
> @@ -123,6 +123,8 @@ void xfs_rt_mark_healthy(struct xfs_mount *mp, unsign=
ed int mask);
>  void xfs_rt_measure_sickness(struct xfs_mount *mp, unsigned int *sick,
>  =09=09unsigned int *checked);
> =20
> +void xfs_agno_mark_sick(struct xfs_mount *mp, xfs_agnumber_t agno,
> +=09=09unsigned int mask);
>  void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask);
>  void xfs_ag_mark_checked(struct xfs_perag *pag, unsigned int mask);
>  void xfs_ag_mark_healthy(struct xfs_perag *pag, unsigned int mask);
> @@ -203,4 +205,8 @@ void xfs_fsop_geom_health(struct xfs_mount *mp, struc=
t xfs_fsop_geom *geo);
>  void xfs_ag_geom_health(struct xfs_perag *pag, struct xfs_ag_geometry *a=
geo);
>  void xfs_bulkstat_health(struct xfs_inode *ip, struct xfs_bulkstat *bs);
> =20
> +#define xfs_metadata_is_sick(error) \
> +=09(unlikely((error) =3D=3D -EFSCORRUPTED || (error) =3D=3D -EIO || \
> +=09=09  (error) =3D=3D -EFSBADCRC))

Why is -EIO considered sick? My understanding is that once something is
marked sick, scrub is the only way to clear that state. -EIO can be
transient, so afaict that means we could mark a persistent in-core state
based on a transient/resolved issue.

Along similar lines, what's the expected behavior in the event of any of
these errors for a kernel that might not support
CONFIG_XFS_ONLINE_[SCRUB|REPAIR]? Just set the states that are never
used for anything? If so, that seems Ok I suppose.. but it's a little
awkward if we'd see the tracepoints and such associated with the state
changes.

Brian

> +
>  #endif=09/* __XFS_HEALTH_H__ */
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 988cde7744e6..c401512a4350 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -27,6 +27,7 @@
>  #include "xfs_trace.h"
>  #include "xfs_log.h"
>  #include "xfs_rmap.h"
> +#include "xfs_health.h"
> =20
>  /*
>   * Lookup a record by ino in the btree given by cur.
> @@ -2635,6 +2636,8 @@ xfs_read_agi(
>  =09error =3D xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
>  =09=09=09XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
>  =09=09=09XFS_FSS_TO_BB(mp, 1), 0, bpp, &xfs_agi_buf_ops);
> +=09if (xfs_metadata_is_sick(error))
> +=09=09xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGI);
>  =09if (error)
>  =09=09return error;
>  =09if (tp)
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index d7d702ee4d1a..25c87834e42a 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -22,6 +22,7 @@
>  #include "xfs_bit.h"
>  #include "xfs_refcount.h"
>  #include "xfs_rmap.h"
> +#include "xfs_health.h"
> =20
>  /* Allowable refcount adjustment amounts. */
>  enum xfs_refc_adjust_op {
> @@ -1177,8 +1178,10 @@ xfs_refcount_finish_one(
>  =09=09=09=09XFS_ALLOC_FLAG_FREEING, &agbp);
>  =09=09if (error)
>  =09=09=09return error;
> -=09=09if (XFS_IS_CORRUPT(tp->t_mountp, !agbp))
> +=09=09if (XFS_IS_CORRUPT(tp->t_mountp, !agbp)) {
> +=09=09=09xfs_agno_mark_sick(tp->t_mountp, agno, XFS_SICK_AG_AGF);
>  =09=09=09return -EFSCORRUPTED;
> +=09=09}
> =20
>  =09=09rcur =3D xfs_refcountbt_init_cursor(mp, tp, agbp, agno);
>  =09=09if (!rcur) {
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index ff9412f113c4..a54a3c129cce 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -21,6 +21,7 @@
>  #include "xfs_errortag.h"
>  #include "xfs_error.h"
>  #include "xfs_inode.h"
> +#include "xfs_health.h"
> =20
>  /*
>   * Lookup the first record less than or equal to [bno, len, owner, offse=
t]
> @@ -2400,8 +2401,10 @@ xfs_rmap_finish_one(
>  =09=09error =3D xfs_free_extent_fix_freelist(tp, agno, &agbp);
>  =09=09if (error)
>  =09=09=09return error;
> -=09=09if (XFS_IS_CORRUPT(tp->t_mountp, !agbp))
> +=09=09if (XFS_IS_CORRUPT(tp->t_mountp, !agbp)) {
> +=09=09=09xfs_agno_mark_sick(tp->t_mountp, agno, XFS_SICK_AG_AGF);
>  =09=09=09return -EFSCORRUPTED;
> +=09=09}
> =20
>  =09=09rcur =3D xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
>  =09=09if (!rcur) {
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 0ac69751fe85..4a923545465d 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -1169,6 +1169,8 @@ xfs_sb_read_secondary(
>  =09error =3D xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
>  =09=09=09XFS_AG_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
>  =09=09=09XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_sb_buf_ops);
> +=09if (xfs_metadata_is_sick(error))
> +=09=09xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_SB);
>  =09if (error)
>  =09=09return error;
>  =09xfs_buf_set_ref(bp, XFS_SSB_REF);
> diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> index 860dc70c99e7..36c32b108b39 100644
> --- a/fs/xfs/xfs_health.c
> +++ b/fs/xfs/xfs_health.c
> @@ -200,6 +200,23 @@ xfs_rt_measure_sickness(
>  =09spin_unlock(&mp->m_sb_lock);
>  }
> =20
> +/* Mark unhealthy per-ag metadata given a raw AG number. */
> +void
> +xfs_agno_mark_sick(
> +=09struct xfs_mount=09*mp,
> +=09xfs_agnumber_t=09=09agno,
> +=09unsigned int=09=09mask)
> +{
> +=09struct xfs_perag=09*pag =3D xfs_perag_get(mp, agno);
> +
> +=09/* per-ag structure not set up yet? */
> +=09if (!pag)
> +=09=09return;
> +
> +=09xfs_ag_mark_sick(pag, mask);
> +=09xfs_perag_put(pag);
> +}
> +
>  /* Mark unhealthy per-ag metadata. */
>  void
>  xfs_ag_mark_sick(
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 401da197f012..a2812cea748d 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -35,6 +35,7 @@
>  #include "xfs_log.h"
>  #include "xfs_bmap_btree.h"
>  #include "xfs_reflink.h"
> +#include "xfs_health.h"
> =20
>  kmem_zone_t *xfs_inode_zone;
> =20
> @@ -787,6 +788,8 @@ xfs_ialloc(
>  =09 */
>  =09if ((pip && ino =3D=3D pip->i_ino) || !xfs_verify_dir_ino(mp, ino)) {
>  =09=09xfs_alert(mp, "Allocated a known in-use inode 0x%llx!", ino);
> +=09=09xfs_agno_mark_sick(mp, XFS_INO_TO_AGNO(mp, ino),
> +=09=09=09=09XFS_SICK_AG_INOBT);
>  =09=09return -EFSCORRUPTED;
>  =09}
> =20
> @@ -2137,6 +2140,7 @@ xfs_iunlink_update_bucket(
>  =09 */
>  =09if (old_value =3D=3D new_agino) {
>  =09=09xfs_buf_corruption_error(agibp);
> +=09=09xfs_agno_mark_sick(tp->t_mountp, agno, XFS_SICK_AG_AGI);
>  =09=09return -EFSCORRUPTED;
>  =09}
> =20
> @@ -2203,6 +2207,7 @@ xfs_iunlink_update_inode(
>  =09if (!xfs_verify_agino_or_null(mp, agno, old_value)) {
>  =09=09xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
>  =09=09=09=09sizeof(*dip), __this_address);
> +=09=09xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
>  =09=09error =3D -EFSCORRUPTED;
>  =09=09goto out;
>  =09}
> @@ -2217,6 +2222,7 @@ xfs_iunlink_update_inode(
>  =09=09if (next_agino !=3D NULLAGINO) {
>  =09=09=09xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
>  =09=09=09=09=09dip, sizeof(*dip), __this_address);
> +=09=09=09xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
>  =09=09=09error =3D -EFSCORRUPTED;
>  =09=09}
>  =09=09goto out;
> @@ -2271,6 +2277,7 @@ xfs_iunlink(
>  =09if (next_agino =3D=3D agino ||
>  =09    !xfs_verify_agino_or_null(mp, agno, next_agino)) {
>  =09=09xfs_buf_corruption_error(agibp);
> +=09=09xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGI);
>  =09=09return -EFSCORRUPTED;
>  =09}
> =20
> @@ -2408,6 +2415,7 @@ xfs_iunlink_map_prev(
>  =09=09=09XFS_CORRUPTION_ERROR(__func__,
>  =09=09=09=09=09XFS_ERRLEVEL_LOW, mp,
>  =09=09=09=09=09*dipp, sizeof(**dipp));
> +=09=09=09xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
>  =09=09=09error =3D -EFSCORRUPTED;
>  =09=09=09return error;
>  =09=09}
> @@ -2454,6 +2462,7 @@ xfs_iunlink_remove(
>  =09if (!xfs_verify_agino(mp, agno, head_agino)) {
>  =09=09XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
>  =09=09=09=09agi, sizeof(*agi));
> +=09=09xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGI);
>  =09=09return -EFSCORRUPTED;
>  =09}
> =20
>=20

