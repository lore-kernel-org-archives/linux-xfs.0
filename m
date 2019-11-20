Return-Path: <SRS0=ArDI=ZM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C366C432C0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 16:11:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42D4C206EC
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 16:11:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WiF9uxo0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728365AbfKTQLz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Nov 2019 11:11:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58481 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728017AbfKTQLz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 11:11:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574266312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+3G92xwtvojn9yorTmIXOdUXaSh+JN0rY/o0o9M/6CY=;
        b=WiF9uxo0+XQLrmGfPsDA54xB+xcwqiDCgrg4DgLOB4IDMgCZWwkRkeaa5ddi6ePeVL+9DO
        KGRM2vweWq7FN4Lv9z26cYNCEicvi43xTmgmOlueLoDjYHRBthiGOifPofCrax6di6wgPY
        9ztsJwl8dXYzwU3shHjzVWKTRZIeYVY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-AuyCi_ozO266SvqT5oye6A-1; Wed, 20 Nov 2019 11:11:49 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 439501005514;
        Wed, 20 Nov 2019 16:11:48 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BB3825E7D8;
        Wed, 20 Nov 2019 16:11:47 +0000 (UTC)
Date:   Wed, 20 Nov 2019 11:11:47 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: report dir/attr block corruption errors to the
 health system
Message-ID: <20191120161147.GE15542@bfoster>
References: <157375555426.3692735.1357467392517392169.stgit@magnolia>
 <157375558620.3692735.5123638007449434510.stgit@magnolia>
MIME-Version: 1.0
In-Reply-To: <157375558620.3692735.5123638007449434510.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: AuyCi_ozO266SvqT5oye6A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 14, 2019 at 10:19:46AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> Whenever we encounter corrupt directory or extended attribute blocks, we
> should report that to the health monitoring system for later reporting.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c   |    5 ++++-
>  fs/xfs/libxfs/xfs_attr_remote.c |   27 ++++++++++++++++-----------
>  fs/xfs/libxfs/xfs_da_btree.c    |   29 ++++++++++++++++++++++++++---
>  fs/xfs/libxfs/xfs_dir2.c        |    5 ++++-
>  fs/xfs/libxfs/xfs_dir2_data.c   |    2 ++
>  fs/xfs/libxfs/xfs_dir2_leaf.c   |    3 +++
>  fs/xfs/libxfs/xfs_dir2_node.c   |    7 +++++++
>  fs/xfs/libxfs/xfs_health.h      |    3 +++
>  fs/xfs/xfs_attr_inactive.c      |    4 ++++
>  fs/xfs/xfs_attr_list.c          |   16 +++++++++++++---
>  fs/xfs/xfs_dir2_readdir.c       |    6 +++++-
>  fs/xfs/xfs_health.c             |   39 +++++++++++++++++++++++++++++++++=
++++++
>  12 files changed, 126 insertions(+), 20 deletions(-)
>=20
>=20
...
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index e424b004e3cb..a17622dadf00 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
...
> @@ -1589,6 +1593,7 @@ xfs_da3_node_lookup_int(
> =20
>  =09=09if (magic !=3D XFS_DA_NODE_MAGIC && magic !=3D XFS_DA3_NODE_MAGIC)=
 {
>  =09=09=09xfs_buf_corruption_error(blk->bp);
> +=09=09=09xfs_da_mark_sick(args);
>  =09=09=09return -EFSCORRUPTED;
>  =09=09}
> =20
> @@ -1604,6 +1609,7 @@ xfs_da3_node_lookup_int(
>  =09=09/* Tree taller than we can handle; bail out! */
>  =09=09if (nodehdr.level >=3D XFS_DA_NODE_MAXDEPTH) {
>  =09=09=09xfs_buf_corruption_error(blk->bp);
> +=09=09=09xfs_da_mark_sick(args);
>  =09=09=09return -EFSCORRUPTED;
>  =09=09}
> =20
> @@ -1612,6 +1618,7 @@ xfs_da3_node_lookup_int(
>  =09=09=09expected_level =3D nodehdr.level - 1;
>  =09=09else if (expected_level !=3D nodehdr.level) {
>  =09=09=09xfs_buf_corruption_error(blk->bp);
> +=09=09=09xfs_da_mark_sick(args);
>  =09=09=09return -EFSCORRUPTED;
>  =09=09} else
>  =09=09=09expected_level--;
> @@ -1663,12 +1670,16 @@ xfs_da3_node_lookup_int(
>  =09=09}
> =20
>  =09=09/* We can't point back to the root. */
> -=09=09if (XFS_IS_CORRUPT(dp->i_mount, blkno =3D=3D args->geo->leafblk))
> +=09=09if (XFS_IS_CORRUPT(dp->i_mount, blkno =3D=3D args->geo->leafblk)) =
{
> +=09=09=09xfs_da_mark_sick(args);
>  =09=09=09return -EFSCORRUPTED;
> +=09=09}
>  =09}
> =20
> -=09if (XFS_IS_CORRUPT(dp->i_mount, expected_level !=3D 0))
> +=09if (XFS_IS_CORRUPT(dp->i_mount, expected_level !=3D 0)) {
> +=09=09xfs_da_mark_sick(args);
>  =09=09return -EFSCORRUPTED;
> +=09}
> =20
>  =09/*
>  =09 * A leaf block that ends in the hashval that we are interested in
> @@ -1686,6 +1697,7 @@ xfs_da3_node_lookup_int(
>  =09=09=09args->blkno =3D blk->blkno;
>  =09=09} else {
>  =09=09=09ASSERT(0);
> +=09=09=09xfs_da_mark_sick(args);
>  =09=09=09return -EFSCORRUPTED;
>  =09=09}

I'm just kind of skimming through the rest for general feedback at this
point given previous comments, but it might be nice to start using exit
labels at some of these places where we're enlarging and duplicating the
error path for particular errors. It's not so much about the code in
these patches, but rather to hopefully ease maintaining these state bits
properly in new code where devs/reviewers might not know much about
scrub state or have it in mind. Short of having some kind of generic
helper to handle corruption state, ISTM that the combination of using
verifiers where possible and common exit labels anywhere else we
generate -EFSCORRUPTED at multiple places within some function could
shrink these patches a bit..

Brian

>  =09=09if (((retval =3D=3D -ENOENT) || (retval =3D=3D -ENOATTR)) &&
> @@ -2250,8 +2262,10 @@ xfs_da3_swap_lastblock(
>  =09error =3D xfs_bmap_last_before(tp, dp, &lastoff, w);
>  =09if (error)
>  =09=09return error;
> -=09if (XFS_IS_CORRUPT(mp, lastoff =3D=3D 0))
> +=09if (XFS_IS_CORRUPT(mp, lastoff =3D=3D 0)) {
> +=09=09xfs_da_mark_sick(args);
>  =09=09return -EFSCORRUPTED;
> +=09}
>  =09/*
>  =09 * Read the last block in the btree space.
>  =09 */
> @@ -2300,6 +2314,7 @@ xfs_da3_swap_lastblock(
>  =09=09if (XFS_IS_CORRUPT(mp,
>  =09=09=09=09   be32_to_cpu(sib_info->forw) !=3D last_blkno ||
>  =09=09=09=09   sib_info->magic !=3D dead_info->magic)) {
> +=09=09=09xfs_da_mark_sick(args);
>  =09=09=09error =3D -EFSCORRUPTED;
>  =09=09=09goto done;
>  =09=09}
> @@ -2320,6 +2335,7 @@ xfs_da3_swap_lastblock(
>  =09=09if (XFS_IS_CORRUPT(mp,
>  =09=09=09=09   be32_to_cpu(sib_info->back) !=3D last_blkno ||
>  =09=09=09=09   sib_info->magic !=3D dead_info->magic)) {
> +=09=09=09xfs_da_mark_sick(args);
>  =09=09=09error =3D -EFSCORRUPTED;
>  =09=09=09goto done;
>  =09=09}
> @@ -2342,6 +2358,7 @@ xfs_da3_swap_lastblock(
>  =09=09xfs_da3_node_hdr_from_disk(dp->i_mount, &par_hdr, par_node);
>  =09=09if (XFS_IS_CORRUPT(mp,
>  =09=09=09=09   level >=3D 0 && level !=3D par_hdr.level + 1)) {
> +=09=09=09xfs_da_mark_sick(args);
>  =09=09=09error =3D -EFSCORRUPTED;
>  =09=09=09goto done;
>  =09=09}
> @@ -2353,6 +2370,7 @@ xfs_da3_swap_lastblock(
>  =09=09     entno++)
>  =09=09=09continue;
>  =09=09if (XFS_IS_CORRUPT(mp, entno =3D=3D par_hdr.count)) {
> +=09=09=09xfs_da_mark_sick(args);
>  =09=09=09error =3D -EFSCORRUPTED;
>  =09=09=09goto done;
>  =09=09}
> @@ -2378,6 +2396,7 @@ xfs_da3_swap_lastblock(
>  =09=09xfs_trans_brelse(tp, par_buf);
>  =09=09par_buf =3D NULL;
>  =09=09if (XFS_IS_CORRUPT(mp, par_blkno =3D=3D 0)) {
> +=09=09=09xfs_da_mark_sick(args);
>  =09=09=09error =3D -EFSCORRUPTED;
>  =09=09=09goto done;
>  =09=09}
> @@ -2387,6 +2406,7 @@ xfs_da3_swap_lastblock(
>  =09=09par_node =3D par_buf->b_addr;
>  =09=09xfs_da3_node_hdr_from_disk(dp->i_mount, &par_hdr, par_node);
>  =09=09if (XFS_IS_CORRUPT(mp, par_hdr.level !=3D level)) {
> +=09=09=09xfs_da_mark_sick(args);
>  =09=09=09error =3D -EFSCORRUPTED;
>  =09=09=09goto done;
>  =09=09}
> @@ -2601,6 +2621,7 @@ xfs_dabuf_map(
>  =09=09=09=09=09irecs[i].br_state);
>  =09=09=09}
>  =09=09}
> +=09=09xfs_dirattr_mark_sick(dp, whichfork);
>  =09=09error =3D -EFSCORRUPTED;
>  =09=09goto out;
>  =09}
> @@ -2693,6 +2714,8 @@ xfs_da_read_buf(
>  =09error =3D xfs_trans_read_buf_map(dp->i_mount, trans,
>  =09=09=09=09=09dp->i_mount->m_ddev_targp,
>  =09=09=09=09=09mapp, nmap, 0, &bp, ops);
> +=09if (xfs_metadata_is_sick(error))
> +=09=09xfs_dirattr_mark_sick(dp, whichfork);
>  =09if (error)
>  =09=09goto out_free;
> =20
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 0aa87cbde49e..e1aa411a1b8b 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -18,6 +18,7 @@
>  #include "xfs_errortag.h"
>  #include "xfs_error.h"
>  #include "xfs_trace.h"
> +#include "xfs_health.h"
> =20
>  struct xfs_name xfs_name_dotdot =3D { (unsigned char *)"..", 2, XFS_DIR3=
_FT_DIR };
> =20
> @@ -608,8 +609,10 @@ xfs_dir2_isblock(
>  =09rval =3D XFS_FSB_TO_B(args->dp->i_mount, last) =3D=3D args->geo->blks=
ize;
>  =09if (XFS_IS_CORRUPT(args->dp->i_mount,
>  =09=09=09   rval !=3D 0 &&
> -=09=09=09   args->dp->i_d.di_size !=3D args->geo->blksize))
> +=09=09=09   args->dp->i_d.di_size !=3D args->geo->blksize)) {
> +=09=09xfs_da_mark_sick(args);
>  =09=09return -EFSCORRUPTED;
> +=09}
>  =09*vp =3D rval;
>  =09return 0;
>  }
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.=
c
> index a6eb71a62b53..80cc9c7ea4e5 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -18,6 +18,7 @@
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_log.h"
> +#include "xfs_health.h"
> =20
>  static xfs_failaddr_t xfs_dir2_data_freefind_verify(
>  =09=09struct xfs_dir2_data_hdr *hdr, struct xfs_dir2_data_free *bf,
> @@ -1170,6 +1171,7 @@ xfs_dir2_data_use_free(
>  corrupt:
>  =09xfs_corruption_error(__func__, XFS_ERRLEVEL_LOW, args->dp->i_mount,
>  =09=09=09hdr, sizeof(*hdr), __FILE__, __LINE__, fa);
> +=09xfs_da_mark_sick(args);
>  =09return -EFSCORRUPTED;
>  }
> =20
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.=
c
> index 73edd96ce0ac..32d17420fff3 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -19,6 +19,7 @@
>  #include "xfs_trace.h"
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
> +#include "xfs_health.h"
> =20
>  /*
>   * Local function declarations.
> @@ -1386,8 +1387,10 @@ xfs_dir2_leaf_removename(
>  =09bestsp =3D xfs_dir2_leaf_bests_p(ltp);
>  =09if (be16_to_cpu(bestsp[db]) !=3D oldbest) {
>  =09=09xfs_buf_corruption_error(lbp);
> +=09=09xfs_da_mark_sick(args);
>  =09=09return -EFSCORRUPTED;
>  =09}
> +
>  =09/*
>  =09 * Mark the former data entry unused.
>  =09 */
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.=
c
> index 3a8b0625a08b..e0f3ab254a1a 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -20,6 +20,7 @@
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_log.h"
> +#include "xfs_health.h"
> =20
>  /*
>   * Function declarations.
> @@ -228,6 +229,7 @@ __xfs_dir3_free_read(
>  =09if (fa) {
>  =09=09xfs_verifier_error(*bpp, -EFSCORRUPTED, fa);
>  =09=09xfs_trans_brelse(tp, *bpp);
> +=09=09xfs_dirattr_mark_sick(dp, XFS_DATA_FORK);
>  =09=09return -EFSCORRUPTED;
>  =09}
> =20
> @@ -440,6 +442,7 @@ xfs_dir2_leaf_to_node(
>  =09if (be32_to_cpu(ltp->bestcount) >
>  =09=09=09=09(uint)dp->i_d.di_size / args->geo->blksize) {
>  =09=09xfs_buf_corruption_error(lbp);
> +=09=09xfs_da_mark_sick(args);
>  =09=09return -EFSCORRUPTED;
>  =09}
> =20
> @@ -514,6 +517,7 @@ xfs_dir2_leafn_add(
>  =09 */
>  =09if (index < 0) {
>  =09=09xfs_buf_corruption_error(bp);
> +=09=09xfs_da_mark_sick(args);
>  =09=09return -EFSCORRUPTED;
>  =09}
> =20
> @@ -733,6 +737,7 @@ xfs_dir2_leafn_lookup_for_addname(
>  =09=09=09=09=09   cpu_to_be16(NULLDATAOFF))) {
>  =09=09=09=09if (curfdb !=3D newfdb)
>  =09=09=09=09=09xfs_trans_brelse(tp, curbp);
> +=09=09=09=09xfs_da_mark_sick(args);
>  =09=09=09=09return -EFSCORRUPTED;
>  =09=09=09}
>  =09=09=09curfdb =3D newfdb;
> @@ -801,6 +806,7 @@ xfs_dir2_leafn_lookup_for_entry(
>  =09xfs_dir3_leaf_check(dp, bp);
>  =09if (leafhdr.count <=3D 0) {
>  =09=09xfs_buf_corruption_error(bp);
> +=09=09xfs_da_mark_sick(args);
>  =09=09return -EFSCORRUPTED;
>  =09}
> =20
> @@ -1737,6 +1743,7 @@ xfs_dir2_node_add_datablk(
>  =09=09=09} else {
>  =09=09=09=09xfs_alert(mp, " ... fblk is NULL");
>  =09=09=09}
> +=09=09=09xfs_da_mark_sick(args);
>  =09=09=09return -EFSCORRUPTED;
>  =09=09}
> =20
> diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
> index 2049419e9555..d9404cd3d09b 100644
> --- a/fs/xfs/libxfs/xfs_health.h
> +++ b/fs/xfs/libxfs/xfs_health.h
> @@ -38,6 +38,7 @@ struct xfs_perag;
>  struct xfs_inode;
>  struct xfs_fsop_geom;
>  struct xfs_btree_cur;
> +struct xfs_da_args;
> =20
>  /* Observable health issues for metadata spanning the entire filesystem.=
 */
>  #define XFS_SICK_FS_COUNTERS=09(1 << 0)  /* summary counters */
> @@ -141,6 +142,8 @@ void xfs_inode_measure_sickness(struct xfs_inode *ip,=
 unsigned int *sick,
>  void xfs_health_unmount(struct xfs_mount *mp);
>  void xfs_bmap_mark_sick(struct xfs_inode *ip, int whichfork);
>  void xfs_btree_mark_sick(struct xfs_btree_cur *cur);
> +void xfs_dirattr_mark_sick(struct xfs_inode *ip, int whichfork);
> +void xfs_da_mark_sick(struct xfs_da_args *args);
> =20
>  /* Now some helpers. */
> =20
> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> index a78c501f6fb1..429a97494ffa 100644
> --- a/fs/xfs/xfs_attr_inactive.c
> +++ b/fs/xfs/xfs_attr_inactive.c
> @@ -23,6 +23,7 @@
>  #include "xfs_quota.h"
>  #include "xfs_dir2.h"
>  #include "xfs_error.h"
> +#include "xfs_health.h"
> =20
>  /*
>   * Look at all the extents for this logical region,
> @@ -209,6 +210,7 @@ xfs_attr3_node_inactive(
>  =09if (level > XFS_DA_NODE_MAXDEPTH) {
>  =09=09xfs_trans_brelse(*trans, bp);=09/* no locks for later trans */
>  =09=09xfs_buf_corruption_error(bp);
> +=09=09xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
>  =09=09return -EFSCORRUPTED;
>  =09}
> =20
> @@ -256,6 +258,7 @@ xfs_attr3_node_inactive(
>  =09=09=09error =3D xfs_attr3_leaf_inactive(trans, dp, child_bp);
>  =09=09=09break;
>  =09=09default:
> +=09=09=09xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
>  =09=09=09xfs_buf_corruption_error(child_bp);
>  =09=09=09xfs_trans_brelse(*trans, child_bp);
>  =09=09=09error =3D -EFSCORRUPTED;
> @@ -342,6 +345,7 @@ xfs_attr3_root_inactive(
>  =09=09error =3D xfs_attr3_leaf_inactive(trans, dp, bp);
>  =09=09break;
>  =09default:
> +=09=09xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
>  =09=09error =3D -EFSCORRUPTED;
>  =09=09xfs_buf_corruption_error(bp);
>  =09=09xfs_trans_brelse(*trans, bp);
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 7a099df88a0c..1a2a3d4ce422 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -21,6 +21,7 @@
>  #include "xfs_error.h"
>  #include "xfs_trace.h"
>  #include "xfs_dir2.h"
> +#include "xfs_health.h"
> =20
>  STATIC int
>  xfs_attr_shortform_compare(const void *a, const void *b)
> @@ -88,8 +89,10 @@ xfs_attr_shortform_list(
>  =09=09for (i =3D 0, sfe =3D &sf->list[0]; i < sf->hdr.count; i++) {
>  =09=09=09if (XFS_IS_CORRUPT(context->dp->i_mount,
>  =09=09=09=09=09   !xfs_attr_namecheck(sfe->nameval,
> -=09=09=09=09=09=09=09       sfe->namelen)))
> +=09=09=09=09=09=09=09       sfe->namelen))) {
> +=09=09=09=09xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
>  =09=09=09=09return -EFSCORRUPTED;
> +=09=09=09}
>  =09=09=09context->put_listent(context,
>  =09=09=09=09=09     sfe->flags,
>  =09=09=09=09=09     sfe->nameval,
> @@ -131,6 +134,7 @@ xfs_attr_shortform_list(
>  =09=09=09=09=09     context->dp->i_mount, sfe,
>  =09=09=09=09=09     sizeof(*sfe));
>  =09=09=09kmem_free(sbuf);
> +=09=09=09xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
>  =09=09=09return -EFSCORRUPTED;
>  =09=09}
> =20
> @@ -181,6 +185,7 @@ xfs_attr_shortform_list(
>  =09=09if (XFS_IS_CORRUPT(context->dp->i_mount,
>  =09=09=09=09   !xfs_attr_namecheck(sbp->name,
>  =09=09=09=09=09=09       sbp->namelen))) {
> +=09=09=09xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
>  =09=09=09error =3D -EFSCORRUPTED;
>  =09=09=09goto out;
>  =09=09}
> @@ -268,8 +273,10 @@ xfs_attr_node_list_lookup(
>  =09=09=09return 0;
> =20
>  =09=09/* We can't point back to the root. */
> -=09=09if (XFS_IS_CORRUPT(mp, cursor->blkno =3D=3D 0))
> +=09=09if (XFS_IS_CORRUPT(mp, cursor->blkno =3D=3D 0)) {
> +=09=09=09xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
>  =09=09=09return -EFSCORRUPTED;
> +=09=09}
>  =09}
> =20
>  =09if (expected_level !=3D 0)
> @@ -281,6 +288,7 @@ xfs_attr_node_list_lookup(
>  out_corruptbuf:
>  =09xfs_buf_corruption_error(bp);
>  =09xfs_trans_brelse(tp, bp);
> +=09xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
>  =09return -EFSCORRUPTED;
>  }
> =20
> @@ -471,8 +479,10 @@ xfs_attr3_leaf_list_int(
>  =09=09}
> =20
>  =09=09if (XFS_IS_CORRUPT(context->dp->i_mount,
> -=09=09=09=09   !xfs_attr_namecheck(name, namelen)))
> +=09=09=09=09   !xfs_attr_namecheck(name, namelen))) {
> +=09=09=09xfs_dirattr_mark_sick(context->dp, XFS_ATTR_FORK);
>  =09=09=09return -EFSCORRUPTED;
> +=09=09}
>  =09=09context->put_listent(context, entry->flags,
>  =09=09=09=09=09      name, namelen, valuelen);
>  =09=09if (context->seen_enough)
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index 95bc9ef8f5f9..715ded503334 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -18,6 +18,7 @@
>  #include "xfs_bmap.h"
>  #include "xfs_trans.h"
>  #include "xfs_error.h"
> +#include "xfs_health.h"
> =20
>  /*
>   * Directory file type support functions
> @@ -119,8 +120,10 @@ xfs_dir2_sf_getdents(
>  =09=09ctx->pos =3D off & 0x7fffffff;
>  =09=09if (XFS_IS_CORRUPT(dp->i_mount,
>  =09=09=09=09   !xfs_dir2_namecheck(sfep->name,
> -=09=09=09=09=09=09       sfep->namelen)))
> +=09=09=09=09=09=09       sfep->namelen))) {
> +=09=09=09xfs_dirattr_mark_sick(dp, XFS_DATA_FORK);
>  =09=09=09return -EFSCORRUPTED;
> +=09=09}
>  =09=09if (!dir_emit(ctx, (char *)sfep->name, sfep->namelen, ino,
>  =09=09=09    xfs_dir3_get_dtype(mp, filetype)))
>  =09=09=09return 0;
> @@ -461,6 +464,7 @@ xfs_dir2_leaf_getdents(
>  =09=09if (XFS_IS_CORRUPT(dp->i_mount,
>  =09=09=09=09   !xfs_dir2_namecheck(dep->name,
>  =09=09=09=09=09=09       dep->namelen))) {
> +=09=09=09xfs_dirattr_mark_sick(dp, XFS_DATA_FORK);
>  =09=09=09error =3D -EFSCORRUPTED;
>  =09=09=09break;
>  =09=09}
> diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> index 1f09027c55ad..c1b6e8fb72ec 100644
> --- a/fs/xfs/xfs_health.c
> +++ b/fs/xfs/xfs_health.c
> @@ -15,6 +15,8 @@
>  #include "xfs_trace.h"
>  #include "xfs_health.h"
>  #include "xfs_btree.h"
> +#include "xfs_da_format.h"
> +#include "xfs_da_btree.h"
> =20
>  /*
>   * Warn about metadata corruption that we detected but haven't fixed, an=
d
> @@ -517,3 +519,40 @@ xfs_btree_mark_sick(
> =20
>  =09xfs_agno_mark_sick(cur->bc_mp, cur->bc_private.a.agno, mask);
>  }
> +
> +/*
> + * Record observations of dir/attr btree corruption with the health trac=
king
> + * system.
> + */
> +void
> +xfs_dirattr_mark_sick(
> +=09struct xfs_inode=09*ip,
> +=09int=09=09=09whichfork)
> +{
> +=09unsigned int=09=09mask;
> +
> +=09switch (whichfork) {
> +=09case XFS_DATA_FORK:
> +=09=09mask =3D XFS_SICK_INO_DIR;
> +=09=09break;
> +=09case XFS_ATTR_FORK:
> +=09=09mask =3D XFS_SICK_INO_XATTR;
> +=09=09break;
> +=09default:
> +=09=09ASSERT(0);
> +=09=09return;
> +=09}
> +
> +=09xfs_inode_mark_sick(ip, mask);
> +}
> +
> +/*
> + * Record observations of dir/attr btree corruption with the health trac=
king
> + * system.
> + */
> +void
> +xfs_da_mark_sick(
> +=09struct xfs_da_args=09*args)
> +{
> +=09xfs_dirattr_mark_sick(args->dp, args->whichfork);
> +}
>=20

