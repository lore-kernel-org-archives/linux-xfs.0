Return-Path: <SRS0=ArDI=ZM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D2AC432C0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 14:21:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C84F82230E
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 14:21:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="McGhvN/U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731353AbfKTOVZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Nov 2019 09:21:25 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:48189 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730360AbfKTOVY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 09:21:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574259682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HduobUZplU/WvYrOXDe0tMmG4Jvpxtfk7Fn6/yOjye8=;
        b=McGhvN/ULY3GeLEm/HMUViafhhDFg+2mUbYdOaUGqMcFLaZqD3M9/ZONkf9B65Pn2N+tZD
        2ZNa1smMnoIC0I5hUc/VRAsjGa8W8qkM+eKnfFsU793otAMDk3Err+Zeb0l8HvDqZEI8BW
        fvgMb413Rn6TPp65zdGTmcBpyyhbyd0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-IygTEWfeNa2fqrfqkQShEA-1; Wed, 20 Nov 2019 09:21:20 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B94C801E76;
        Wed, 20 Nov 2019 14:21:19 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0FD0310375C2;
        Wed, 20 Nov 2019 14:21:18 +0000 (UTC)
Date:   Wed, 20 Nov 2019 09:21:19 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: report block map corruption errors to the
 health tracking system
Message-ID: <20191120142119.GD15542@bfoster>
References: <157375555426.3692735.1357467392517392169.stgit@magnolia>
 <157375557349.3692735.15868119551132443897.stgit@magnolia>
MIME-Version: 1.0
In-Reply-To: <157375557349.3692735.15868119551132443897.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: IygTEWfeNa2fqrfqkQShEA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 14, 2019 at 10:19:33AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> Whenever we encounter a corrupt block mapping, we should report that to
> the health monitoring system for later reporting.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c   |   39 +++++++++++++++++++++++++++++++++-----=
-
>  fs/xfs/libxfs/xfs_health.h |    1 +
>  fs/xfs/xfs_health.c        |   26 ++++++++++++++++++++++++++
>  fs/xfs/xfs_iomap.c         |   15 +++++++++++----
>  4 files changed, 71 insertions(+), 10 deletions(-)
>=20
>=20
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 4acc6e37c31d..c4674fb0bfb4 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -35,7 +35,7 @@
>  #include "xfs_refcount.h"
>  #include "xfs_icache.h"
>  #include "xfs_iomap.h"
> -
> +#include "xfs_health.h"
> =20
>  kmem_zone_t=09=09*xfs_bmap_free_item_zone;
> =20
> @@ -732,6 +732,7 @@ xfs_bmap_extents_to_btree(
>  =09xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, 1L);
>  =09abp =3D xfs_btree_get_bufl(mp, tp, args.fsbno);
>  =09if (XFS_IS_CORRUPT(mp, !abp)) {
> +=09=09xfs_bmap_mark_sick(ip, whichfork);
>  =09=09error =3D -EFSCORRUPTED;
>  =09=09goto out_unreserve_dquot;
>  =09}
> @@ -1021,6 +1022,7 @@ xfs_bmap_add_attrfork_local(
> =20
>  =09/* should only be called for types that support local format data */
>  =09ASSERT(0);
> +=09xfs_bmap_mark_sick(ip, XFS_ATTR_FORK);
>  =09return -EFSCORRUPTED;
>  }

Is it really the attr fork that's corrupt if we get here?

> =20
> @@ -1090,6 +1092,7 @@ xfs_bmap_add_attrfork(
>  =09if (XFS_IFORK_Q(ip))
>  =09=09goto trans_cancel;
>  =09if (XFS_IS_CORRUPT(mp, ip->i_d.di_anextents !=3D 0)) {
> +=09=09xfs_bmap_mark_sick(ip, XFS_ATTR_FORK);

Similar question here given we haven't added the fork yet. di_anextents
is at least related I suppose, but it's not clear that
scrubbing/repairing the attr fork is what needs to happen.

>  =09=09error =3D -EFSCORRUPTED;
>  =09=09goto trans_cancel;
>  =09}
...
> @@ -1239,6 +1244,7 @@ xfs_iread_extents(
>  =09if (XFS_IS_CORRUPT(mp,
>  =09=09=09   XFS_IFORK_FORMAT(ip, whichfork) !=3D
>  =09=09=09   XFS_DINODE_FMT_BTREE)) {
> +=09=09xfs_bmap_mark_sick(ip, whichfork);
>  =09=09error =3D -EFSCORRUPTED;
>  =09=09goto out;
>  =09}
> @@ -1254,6 +1260,7 @@ xfs_iread_extents(
> =20
>  =09if (XFS_IS_CORRUPT(mp,
>  =09=09=09   ir.loaded !=3D XFS_IFORK_NEXTENTS(ip, whichfork))) {
> +=09=09xfs_bmap_mark_sick(ip, whichfork);
>  =09=09error =3D -EFSCORRUPTED;
>  =09=09goto out;
>  =09}
> @@ -1262,6 +1269,8 @@ xfs_iread_extents(
>  =09ifp->if_flags |=3D XFS_IFEXTENTS;
>  =09return 0;
>  out:
> +=09if (xfs_metadata_is_sick(error))
> +=09=09xfs_bmap_mark_sick(ip, whichfork);
>  =09xfs_iext_destroy(ifp);
>  =09return error;
>  }

Duplicate calls in xfs_iread_extents()?

Brian

> @@ -1344,6 +1353,7 @@ xfs_bmap_last_before(
>  =09=09break;
>  =09default:
>  =09=09ASSERT(0);
> +=09=09xfs_bmap_mark_sick(ip, whichfork);
>  =09=09return -EFSCORRUPTED;
>  =09}
> =20
> @@ -1443,8 +1453,11 @@ xfs_bmap_last_offset(
>  =09if (XFS_IFORK_FORMAT(ip, whichfork) =3D=3D XFS_DINODE_FMT_LOCAL)
>  =09=09return 0;
> =20
> -=09if (XFS_IS_CORRUPT(ip->i_mount, !xfs_ifork_has_extents(ip, whichfork)=
))
> +=09if (XFS_IS_CORRUPT(ip->i_mount,
> +=09    !xfs_ifork_has_extents(ip, whichfork))) {
> +=09=09xfs_bmap_mark_sick(ip, whichfork);
>  =09=09return -EFSCORRUPTED;
> +=09}
> =20
>  =09error =3D xfs_bmap_last_extent(NULL, ip, whichfork, &rec, &is_empty);
>  =09if (error || is_empty)
> @@ -3905,6 +3918,7 @@ xfs_bmapi_read(
> =20
>  =09if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)) ||
>  =09    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
> +=09=09xfs_bmap_mark_sick(ip, whichfork);
>  =09=09return -EFSCORRUPTED;
>  =09}
> =20
> @@ -3935,6 +3949,7 @@ xfs_bmapi_read(
>  =09=09xfs_alert(mp, "%s: inode %llu missing fork %d",
>  =09=09=09=09__func__, ip->i_ino, whichfork);
>  #endif /* DEBUG */
> +=09=09xfs_bmap_mark_sick(ip, whichfork);
>  =09=09return -EFSCORRUPTED;
>  =09}
> =20
> @@ -4414,6 +4429,7 @@ xfs_bmapi_write(
> =20
>  =09if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)) ||
>  =09    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
> +=09=09xfs_bmap_mark_sick(ip, whichfork);
>  =09=09return -EFSCORRUPTED;
>  =09}
> =20
> @@ -4621,9 +4637,11 @@ xfs_bmapi_convert_delalloc(
>  =09error =3D -ENOSPC;
>  =09if (WARN_ON_ONCE(bma.blkno =3D=3D NULLFSBLOCK))
>  =09=09goto out_finish;
> -=09error =3D -EFSCORRUPTED;
> -=09if (WARN_ON_ONCE(!xfs_valid_startblock(ip, bma.got.br_startblock)))
> +=09if (WARN_ON_ONCE(!xfs_valid_startblock(ip, bma.got.br_startblock))) {
> +=09=09xfs_bmap_mark_sick(ip, whichfork);
> +=09=09error =3D -EFSCORRUPTED;
>  =09=09goto out_finish;
> +=09}
> =20
>  =09XFS_STATS_ADD(mp, xs_xstrat_bytes, XFS_FSB_TO_B(mp, bma.length));
>  =09XFS_STATS_INC(mp, xs_xstrat_quick);
> @@ -4681,6 +4699,7 @@ xfs_bmapi_remap(
> =20
>  =09if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)) ||
>  =09    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
> +=09=09xfs_bmap_mark_sick(ip, whichfork);
>  =09=09return -EFSCORRUPTED;
>  =09}
> =20
> @@ -5319,8 +5338,10 @@ __xfs_bunmapi(
>  =09whichfork =3D xfs_bmapi_whichfork(flags);
>  =09ASSERT(whichfork !=3D XFS_COW_FORK);
>  =09ifp =3D XFS_IFORK_PTR(ip, whichfork);
> -=09if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)))
> +=09if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork))) {
> +=09=09xfs_bmap_mark_sick(ip, whichfork);
>  =09=09return -EFSCORRUPTED;
> +=09}
>  =09if (XFS_FORCED_SHUTDOWN(mp))
>  =09=09return -EIO;
> =20
> @@ -5815,6 +5836,7 @@ xfs_bmap_collapse_extents(
> =20
>  =09if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)) ||
>  =09    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
> +=09=09xfs_bmap_mark_sick(ip, whichfork);
>  =09=09return -EFSCORRUPTED;
>  =09}
> =20
> @@ -5932,6 +5954,7 @@ xfs_bmap_insert_extents(
> =20
>  =09if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)) ||
>  =09    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
> +=09=09xfs_bmap_mark_sick(ip, whichfork);
>  =09=09return -EFSCORRUPTED;
>  =09}
> =20
> @@ -6038,6 +6061,7 @@ xfs_bmap_split_extent_at(
> =20
>  =09if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)) ||
>  =09    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
> +=09=09xfs_bmap_mark_sick(ip, whichfork);
>  =09=09return -EFSCORRUPTED;
>  =09}
> =20
> @@ -6253,8 +6277,10 @@ xfs_bmap_finish_one(
>  =09=09=09XFS_FSB_TO_AGBNO(tp->t_mountp, startblock),
>  =09=09=09ip->i_ino, whichfork, startoff, *blockcount, state);
> =20
> -=09if (WARN_ON_ONCE(whichfork !=3D XFS_DATA_FORK))
> +=09if (WARN_ON_ONCE(whichfork !=3D XFS_DATA_FORK)) {
> +=09=09xfs_bmap_mark_sick(ip, whichfork);
>  =09=09return -EFSCORRUPTED;
> +=09}
> =20
>  =09if (XFS_TEST_ERROR(false, tp->t_mountp,
>  =09=09=09XFS_ERRTAG_BMAP_FINISH_ONE))
> @@ -6272,6 +6298,7 @@ xfs_bmap_finish_one(
>  =09=09break;
>  =09default:
>  =09=09ASSERT(0);
> +=09=09xfs_bmap_mark_sick(ip, whichfork);
>  =09=09error =3D -EFSCORRUPTED;
>  =09}
> =20
> diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
> index ce8954a10c66..25b61180b562 100644
> --- a/fs/xfs/libxfs/xfs_health.h
> +++ b/fs/xfs/libxfs/xfs_health.h
> @@ -138,6 +138,7 @@ void xfs_inode_measure_sickness(struct xfs_inode *ip,=
 unsigned int *sick,
>  =09=09unsigned int *checked);
> =20
>  void xfs_health_unmount(struct xfs_mount *mp);
> +void xfs_bmap_mark_sick(struct xfs_inode *ip, int whichfork);
> =20
>  /* Now some helpers. */
> =20
> diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> index 36c32b108b39..5e5de5338476 100644
> --- a/fs/xfs/xfs_health.c
> +++ b/fs/xfs/xfs_health.c
> @@ -452,3 +452,29 @@ xfs_bulkstat_health(
>  =09=09=09bs->bs_sick |=3D m->ioctl_mask;
>  =09}
>  }
> +
> +/* Mark a block mapping sick. */
> +void
> +xfs_bmap_mark_sick(
> +=09struct xfs_inode=09*ip,
> +=09int=09=09=09whichfork)
> +{
> +=09unsigned int=09=09mask;
> +
> +=09switch (whichfork) {
> +=09case XFS_DATA_FORK:
> +=09=09mask =3D XFS_SICK_INO_BMBTD;
> +=09=09break;
> +=09case XFS_ATTR_FORK:
> +=09=09mask =3D XFS_SICK_INO_BMBTA;
> +=09=09break;
> +=09case XFS_COW_FORK:
> +=09=09mask =3D XFS_SICK_INO_BMBTC;
> +=09=09break;
> +=09default:
> +=09=09ASSERT(0);
> +=09=09return;
> +=09}
> +
> +=09xfs_inode_mark_sick(ip, mask);
> +}
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 28e2d1f37267..c1befb899911 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -27,7 +27,7 @@
>  #include "xfs_dquot_item.h"
>  #include "xfs_dquot.h"
>  #include "xfs_reflink.h"
> -
> +#include "xfs_health.h"
> =20
>  #define XFS_ALLOC_ALIGN(mp, off) \
>  =09(((off) >> mp->m_allocsize_log) << mp->m_allocsize_log)
> @@ -59,8 +59,10 @@ xfs_bmbt_to_iomap(
>  =09struct xfs_mount=09*mp =3D ip->i_mount;
>  =09struct xfs_buftarg=09*target =3D xfs_inode_buftarg(ip);
> =20
> -=09if (unlikely(!xfs_valid_startblock(ip, imap->br_startblock)))
> +=09if (unlikely(!xfs_valid_startblock(ip, imap->br_startblock))) {
> +=09=09xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
>  =09=09return xfs_alert_fsblock_zero(ip, imap);
> +=09}
> =20
>  =09if (imap->br_startblock =3D=3D HOLESTARTBLOCK) {
>  =09=09iomap->addr =3D IOMAP_NULL_ADDR;
> @@ -277,8 +279,10 @@ xfs_iomap_write_direct(
>  =09=09goto out_unlock;
>  =09}
> =20
> -=09if (unlikely(!xfs_valid_startblock(ip, imap->br_startblock)))
> +=09if (unlikely(!xfs_valid_startblock(ip, imap->br_startblock))) {
> +=09=09xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
>  =09=09error =3D xfs_alert_fsblock_zero(ip, imap);
> +=09}
> =20
>  out_unlock:
>  =09xfs_iunlock(ip, XFS_ILOCK_EXCL);
> @@ -598,8 +602,10 @@ xfs_iomap_write_unwritten(
>  =09=09if (error)
>  =09=09=09return error;
> =20
> -=09=09if (unlikely(!xfs_valid_startblock(ip, imap.br_startblock)))
> +=09=09if (unlikely(!xfs_valid_startblock(ip, imap.br_startblock))) {
> +=09=09=09xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
>  =09=09=09return xfs_alert_fsblock_zero(ip, &imap);
> +=09=09}
> =20
>  =09=09if ((numblks_fsb =3D imap.br_blockcount) =3D=3D 0) {
>  =09=09=09/*
> @@ -858,6 +864,7 @@ xfs_buffered_write_iomap_begin(
> =20
>  =09if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, XFS_DATA_FORK)) ||
>  =09    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
> +=09=09xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
>  =09=09error =3D -EFSCORRUPTED;
>  =09=09goto out_unlock;
>  =09}
>=20

