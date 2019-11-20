Return-Path: <SRS0=ArDI=ZM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18B4DC432C0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 14:20:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D595E2230E
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 14:20:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hs0elFAU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729591AbfKTOUm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Nov 2019 09:20:42 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29519 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729157AbfKTOUm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 09:20:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574259639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hsB0cuMfwqJOijCTl+V2/JT1D/QeDMfo4xA5tYZmM+8=;
        b=hs0elFAURZB6iQLe32TmwBSuityE8HJwTfP0LyM3geGeYiQqToiw+UZXmnw+uM/a90iOh8
        UMXiEyZQ8iELYfS5o4aJxOFFoQWwfLMw0djXpMVwQtQ00rO2Hig6Z/qK8OCc+7CdQkKTlE
        YxbC8sCh77+p82OpGe4b8Id1YATqG9U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-RAfW1M3PNeCVYFop3_GN3g-1; Wed, 20 Nov 2019 09:20:36 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B33531883522;
        Wed, 20 Nov 2019 14:20:35 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 490986013A;
        Wed, 20 Nov 2019 14:20:35 +0000 (UTC)
Date:   Wed, 20 Nov 2019 09:20:35 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs: separate the marking of sick and checked
 metadata
Message-ID: <20191120142035.GB15542@bfoster>
References: <157375555426.3692735.1357467392517392169.stgit@magnolia>
 <157375556076.3692735.11924756899356721108.stgit@magnolia>
MIME-Version: 1.0
In-Reply-To: <157375556076.3692735.11924756899356721108.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: RAfW1M3PNeCVYFop3_GN3g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 14, 2019 at 10:19:20AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> Split the setting of the sick and checked masks into separate functions
> as part of preparing to add the ability for regular runtime fs code
> (i.e. not scrub) to mark metadata structures sick when corruptions are
> found.  Improve the documentation of libxfs' requirements for helper
> behavior.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_health.h |   24 ++++++++++++++++++----
>  fs/xfs/scrub/health.c      |   20 +++++++++++-------
>  fs/xfs/xfs_health.c        |   49 ++++++++++++++++++++++++++++++++++++++=
++++++
>  fs/xfs/xfs_mount.c         |    5 ++++
>  4 files changed, 85 insertions(+), 13 deletions(-)
>=20
>=20
> diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
> index 272005ac8c88..3657a9cb8490 100644
> --- a/fs/xfs/libxfs/xfs_health.h
> +++ b/fs/xfs/libxfs/xfs_health.h
> @@ -26,9 +26,11 @@
>   * and the "sick" field tells us if that piece was found to need repairs=
.
>   * Therefore we can conclude that for a given sick flag value:
>   *
> - *  - checked && sick  =3D> metadata needs repair
> - *  - checked && !sick =3D> metadata is ok
> - *  - !checked         =3D> has not been examined since mount
> + *  - checked && sick   =3D> metadata needs repair
> + *  - checked && !sick  =3D> metadata is ok
> + *  - !checked && sick  =3D> errors have been observed during normal ope=
ration,
> + *                         but the metadata has not been checked thoroug=
hly
> + *  - !checked && !sick =3D> has not been examined since mount
>   */
> =20

I don't see this change in the provided repo. Which is the right patch?

>  struct xfs_mount;
> @@ -97,24 +99,38 @@ struct xfs_fsop_geom;
>  =09=09=09=09 XFS_SICK_INO_SYMLINK | \
>  =09=09=09=09 XFS_SICK_INO_PARENT)
> =20
> -/* These functions must be provided by the xfs implementation. */
> +/*
> + * These functions must be provided by the xfs implementation.  Function
> + * behavior with respect to the first argument should be as follows:
> + *
> + * xfs_*_mark_sick:    set the sick flags and do not set checked flags.

Nit: It's probably not necessary to say that we don't set the checked
flags here given the comment/function below.

Brian

> + * xfs_*_mark_checked: set the checked flags.
> + * xfs_*_mark_healthy: clear the sick flags and set the checked flags.
> + *
> + * xfs_*_measure_sickness: return the sick and check status in the provi=
ded
> + * out parameters.
> + */
> =20
>  void xfs_fs_mark_sick(struct xfs_mount *mp, unsigned int mask);
> +void xfs_fs_mark_checked(struct xfs_mount *mp, unsigned int mask);
>  void xfs_fs_mark_healthy(struct xfs_mount *mp, unsigned int mask);
>  void xfs_fs_measure_sickness(struct xfs_mount *mp, unsigned int *sick,
>  =09=09unsigned int *checked);
> =20
>  void xfs_rt_mark_sick(struct xfs_mount *mp, unsigned int mask);
> +void xfs_rt_mark_checked(struct xfs_mount *mp, unsigned int mask);
>  void xfs_rt_mark_healthy(struct xfs_mount *mp, unsigned int mask);
>  void xfs_rt_measure_sickness(struct xfs_mount *mp, unsigned int *sick,
>  =09=09unsigned int *checked);
> =20
>  void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask);
> +void xfs_ag_mark_checked(struct xfs_perag *pag, unsigned int mask);
>  void xfs_ag_mark_healthy(struct xfs_perag *pag, unsigned int mask);
>  void xfs_ag_measure_sickness(struct xfs_perag *pag, unsigned int *sick,
>  =09=09unsigned int *checked);
> =20
>  void xfs_inode_mark_sick(struct xfs_inode *ip, unsigned int mask);
> +void xfs_inode_mark_checked(struct xfs_inode *ip, unsigned int mask);
>  void xfs_inode_mark_healthy(struct xfs_inode *ip, unsigned int mask);
>  void xfs_inode_measure_sickness(struct xfs_inode *ip, unsigned int *sick=
,
>  =09=09unsigned int *checked);
> diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
> index 83d27cdf579b..a402f9026d5f 100644
> --- a/fs/xfs/scrub/health.c
> +++ b/fs/xfs/scrub/health.c
> @@ -137,30 +137,34 @@ xchk_update_health(
>  =09switch (type_to_health_flag[sc->sm->sm_type].group) {
>  =09case XHG_AG:
>  =09=09pag =3D xfs_perag_get(sc->mp, sc->sm->sm_agno);
> -=09=09if (bad)
> +=09=09if (bad) {
>  =09=09=09xfs_ag_mark_sick(pag, sc->sick_mask);
> -=09=09else
> +=09=09=09xfs_ag_mark_checked(pag, sc->sick_mask);
> +=09=09} else
>  =09=09=09xfs_ag_mark_healthy(pag, sc->sick_mask);
>  =09=09xfs_perag_put(pag);
>  =09=09break;
>  =09case XHG_INO:
>  =09=09if (!sc->ip)
>  =09=09=09return;
> -=09=09if (bad)
> +=09=09if (bad) {
>  =09=09=09xfs_inode_mark_sick(sc->ip, sc->sick_mask);
> -=09=09else
> +=09=09=09xfs_inode_mark_checked(sc->ip, sc->sick_mask);
> +=09=09} else
>  =09=09=09xfs_inode_mark_healthy(sc->ip, sc->sick_mask);
>  =09=09break;
>  =09case XHG_FS:
> -=09=09if (bad)
> +=09=09if (bad) {
>  =09=09=09xfs_fs_mark_sick(sc->mp, sc->sick_mask);
> -=09=09else
> +=09=09=09xfs_fs_mark_checked(sc->mp, sc->sick_mask);
> +=09=09} else
>  =09=09=09xfs_fs_mark_healthy(sc->mp, sc->sick_mask);
>  =09=09break;
>  =09case XHG_RT:
> -=09=09if (bad)
> +=09=09if (bad) {
>  =09=09=09xfs_rt_mark_sick(sc->mp, sc->sick_mask);
> -=09=09else
> +=09=09=09xfs_rt_mark_checked(sc->mp, sc->sick_mask);
> +=09=09} else
>  =09=09=09xfs_rt_mark_healthy(sc->mp, sc->sick_mask);
>  =09=09break;
>  =09default:
> diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> index 8e0cb05a7142..860dc70c99e7 100644
> --- a/fs/xfs/xfs_health.c
> +++ b/fs/xfs/xfs_health.c
> @@ -100,6 +100,18 @@ xfs_fs_mark_sick(
> =20
>  =09spin_lock(&mp->m_sb_lock);
>  =09mp->m_fs_sick |=3D mask;
> +=09spin_unlock(&mp->m_sb_lock);
> +}
> +
> +/* Mark per-fs metadata as having been checked. */
> +void
> +xfs_fs_mark_checked(
> +=09struct xfs_mount=09*mp,
> +=09unsigned int=09=09mask)
> +{
> +=09ASSERT(!(mask & ~XFS_SICK_FS_PRIMARY));
> +
> +=09spin_lock(&mp->m_sb_lock);
>  =09mp->m_fs_checked |=3D mask;
>  =09spin_unlock(&mp->m_sb_lock);
>  }
> @@ -143,6 +155,19 @@ xfs_rt_mark_sick(
> =20
>  =09spin_lock(&mp->m_sb_lock);
>  =09mp->m_rt_sick |=3D mask;
> +=09spin_unlock(&mp->m_sb_lock);
> +}
> +
> +/* Mark realtime metadata as having been checked. */
> +void
> +xfs_rt_mark_checked(
> +=09struct xfs_mount=09*mp,
> +=09unsigned int=09=09mask)
> +{
> +=09ASSERT(!(mask & ~XFS_SICK_RT_PRIMARY));
> +=09trace_xfs_rt_mark_sick(mp, mask);
> +
> +=09spin_lock(&mp->m_sb_lock);
>  =09mp->m_rt_checked |=3D mask;
>  =09spin_unlock(&mp->m_sb_lock);
>  }
> @@ -186,6 +211,18 @@ xfs_ag_mark_sick(
> =20
>  =09spin_lock(&pag->pag_state_lock);
>  =09pag->pag_sick |=3D mask;
> +=09spin_unlock(&pag->pag_state_lock);
> +}
> +
> +/* Mark per-ag metadata as having been checked. */
> +void
> +xfs_ag_mark_checked(
> +=09struct xfs_perag=09*pag,
> +=09unsigned int=09=09mask)
> +{
> +=09ASSERT(!(mask & ~XFS_SICK_AG_PRIMARY));
> +
> +=09spin_lock(&pag->pag_state_lock);
>  =09pag->pag_checked |=3D mask;
>  =09spin_unlock(&pag->pag_state_lock);
>  }
> @@ -229,6 +266,18 @@ xfs_inode_mark_sick(
> =20
>  =09spin_lock(&ip->i_flags_lock);
>  =09ip->i_sick |=3D mask;
> +=09spin_unlock(&ip->i_flags_lock);
> +}
> +
> +/* Mark inode metadata as having been checked. */
> +void
> +xfs_inode_mark_checked(
> +=09struct xfs_inode=09*ip,
> +=09unsigned int=09=09mask)
> +{
> +=09ASSERT(!(mask & ~XFS_SICK_INO_PRIMARY));
> +
> +=09spin_lock(&ip->i_flags_lock);
>  =09ip->i_checked |=3D mask;
>  =09spin_unlock(&ip->i_flags_lock);
>  }
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index fca65109cf24..27aa143d524b 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -555,8 +555,10 @@ xfs_check_summary_counts(
>  =09if (XFS_LAST_UNMOUNT_WAS_CLEAN(mp) &&
>  =09    (mp->m_sb.sb_fdblocks > mp->m_sb.sb_dblocks ||
>  =09     !xfs_verify_icount(mp, mp->m_sb.sb_icount) ||
> -=09     mp->m_sb.sb_ifree > mp->m_sb.sb_icount))
> +=09     mp->m_sb.sb_ifree > mp->m_sb.sb_icount)) {
>  =09=09xfs_fs_mark_sick(mp, XFS_SICK_FS_COUNTERS);
> +=09=09xfs_fs_mark_checked(mp, XFS_SICK_FS_COUNTERS);
> +=09}
> =20
>  =09/*
>  =09 * We can safely re-initialise incore superblock counters from the
> @@ -1322,6 +1324,7 @@ xfs_force_summary_recalc(
>  =09=09return;
> =20
>  =09xfs_fs_mark_sick(mp, XFS_SICK_FS_COUNTERS);
> +=09xfs_fs_mark_checked(mp, XFS_SICK_FS_COUNTERS);
>  }
> =20
>  /*
>=20

