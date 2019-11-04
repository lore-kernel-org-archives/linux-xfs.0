Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D92BCA9EB5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 15:44:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2395120848
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 15:44:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B/Z3t+8m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbfKDPon (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 10:44:43 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:59015 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727796AbfKDPon (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 10:44:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572882280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SUcnYPoUkj8Zwirn8g/avepFmqhxOebRCS82Wao8q4E=;
        b=B/Z3t+8mwJTp9dXSD/JYWzH3NiF15gsrfGN8NOlUIa7hKEARdbNzxr4gWvcYSA43b99vsC
        WkUlBr8aGjQow48VcceG/48hmcIOvuQ4bMcfgXJALj5EgjvR9YfY2hTxrE8vrUreQ8pvYT
        LyHz5KPAGT4l0SmwfZxMMiaXefPbQxk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-3788cv5VN9-53bwiMccI_Q-1; Mon, 04 Nov 2019 10:44:38 -0500
Received: by mail-wm1-f71.google.com with SMTP id z5so6272924wma.5
        for <linux-xfs@vger.kernel.org>; Mon, 04 Nov 2019 07:44:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=KI2EGFJ7dtdIwFuBYvcq1v2f2a1iXxOjG1IO7gmWCi8=;
        b=TQqQfzptJY5GhVI5eeW0fL+4UWReWfFaF3QZmCSom5IHAEY5lsBOWxUKuda0fw+rlz
         ckhCcX4mgjvckiysHNMB5H3yn+Tk38VNNI3KadbQSj18U4qZzFrYrNrECDXaYx/JYJd7
         yhLC2YiOHYByxWa+pPU3ltIpJaWDw95GT2/EPYxIJD4EH3cQ1PpvITlHKzIEujDDdRQj
         hNad/bV2r/NYktF03qbjqEmJjKS8CsfZeFEbXGs2nNrJ68/fYPsauxJdBA9pdHrsW4ty
         MVXTXdR+bGyozah5q6K9+dPm+plsvyAApbB3+J6PV2uNNdb/rOzNcBtq3tmjKBIn7sUp
         UWtA==
X-Gm-Message-State: APjAAAWXtpQHopUPA40NH5OCNh+Vwry0irqHrUj4tpXXNV7XpGszjk/I
        d+6AwzB6Qp1sFiyR7F8Yeo7v4Fj9tsbcKZHE6A4nNhJoE1iaRuFE07S0wSjEUUYqMi/rppdfct7
        KE0sFMex4FXuDDBxihPUL
X-Received: by 2002:a5d:574d:: with SMTP id q13mr24018635wrw.263.1572882276894;
        Mon, 04 Nov 2019 07:44:36 -0800 (PST)
X-Google-Smtp-Source: APXvYqw9hACSt6MM518O9OjcnT/aQY8KhOjq9Lt49poWoBD5PngNrA/FnEHYew+Toj4kARD4F4wdNQ==
X-Received: by 2002:a5d:574d:: with SMTP id q13mr24018582wrw.263.1572882276269;
        Mon, 04 Nov 2019 07:44:36 -0800 (PST)
Received: from orion (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id 11sm19691871wmb.34.2019.11.04.07.44.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 07:44:35 -0800 (PST)
Date:   Mon, 4 Nov 2019 16:44:33 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: always log corruption errors
Message-ID: <20191104154433.ndbueoh4khgfghzz@orion>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
References: <157281982341.4150947.10288936972373805803.stgit@magnolia>
 <157281984206.4150947.1055637710223922715.stgit@magnolia>
MIME-Version: 1.0
In-Reply-To: <157281984206.4150947.1055637710223922715.stgit@magnolia>
X-MC-Unique: 3788cv5VN9-53bwiMccI_Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 03, 2019 at 02:24:02PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> Make sure we log something to dmesg whenever we return -EFSCORRUPTED up
> the call stack.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_alloc.c      |    9 +++++++--
>  fs/xfs/libxfs/xfs_attr_leaf.c  |   12 +++++++++---
>  fs/xfs/libxfs/xfs_bmap.c       |    8 +++++++-
>  fs/xfs/libxfs/xfs_btree.c      |    5 ++++-
>  fs/xfs/libxfs/xfs_da_btree.c   |   24 ++++++++++++++++++------
>  fs/xfs/libxfs/xfs_dir2.c       |    4 +++-
>  fs/xfs/libxfs/xfs_dir2_leaf.c  |    4 +++-
>  fs/xfs/libxfs/xfs_dir2_node.c  |   12 +++++++++---
>  fs/xfs/libxfs/xfs_inode_fork.c |    6 ++++++
>  fs/xfs/libxfs/xfs_refcount.c   |    4 +++-
>  fs/xfs/libxfs/xfs_rtbitmap.c   |    6 ++++--
>  fs/xfs/xfs_acl.c               |   15 ++++++++++++---
>  fs/xfs/xfs_attr_inactive.c     |    6 +++++-
>  fs/xfs/xfs_attr_list.c         |    5 ++++-
>  fs/xfs/xfs_bmap_item.c         |    3 ++-
>  fs/xfs/xfs_error.c             |   21 +++++++++++++++++++++
>  fs/xfs/xfs_error.h             |    1 +
>  fs/xfs/xfs_extfree_item.c      |    3 ++-
>  fs/xfs/xfs_inode.c             |   15 ++++++++++++---
>  fs/xfs/xfs_inode_item.c        |    5 ++++-
>  fs/xfs/xfs_iops.c              |   10 +++++++---
>  fs/xfs/xfs_log_recover.c       |   23 ++++++++++++++++++-----
>  fs/xfs/xfs_qm.c                |   13 +++++++++++--
>  fs/xfs/xfs_refcount_item.c     |    3 ++-
>  fs/xfs/xfs_rmap_item.c         |    7 +++++--
>  25 files changed, 179 insertions(+), 45 deletions(-)
>=20
>=20
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index b8d48d5fa6a5..f7a4b54c5bc2 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -702,8 +702,10 @@ xfs_alloc_update_counters(
> =20
>  =09xfs_trans_agblocks_delta(tp, len);
>  =09if (unlikely(be32_to_cpu(agf->agf_freeblks) >
> -=09=09     be32_to_cpu(agf->agf_length)))
> +=09=09     be32_to_cpu(agf->agf_length))) {
> +=09=09xfs_buf_corruption_error(agbp);
>  =09=09return -EFSCORRUPTED;
> +=09}
> =20
>  =09xfs_alloc_log_agf(tp, agbp, XFS_AGF_FREEBLKS);
>  =09return 0;
> @@ -1048,6 +1050,7 @@ xfs_alloc_ag_vextent_small(
> =20
>  =09=09bp =3D xfs_btree_get_bufs(args->mp, args->tp, args->agno, fbno);
>  =09=09if (!bp) {
> +=09=09=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, args->mp);
>  =09=09=09error =3D -EFSCORRUPTED;
>  =09=09=09goto error;
>  =09=09}
> @@ -2215,8 +2218,10 @@ xfs_free_agfl_block(
>  =09=09return error;
> =20
>  =09bp =3D xfs_btree_get_bufs(tp->t_mountp, tp, agno, agbno);
> -=09if (!bp)
> +=09if (!bp) {
> +=09=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, tp->t_mountp);
>  =09=09return -EFSCORRUPTED;
> +=09}
>  =09xfs_trans_binval(tp, bp);
> =20
>  =09return 0;
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.=
c
> index 56e62b3d9bb7..dca8840496ea 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -2346,8 +2346,10 @@ xfs_attr3_leaf_lookup_int(
>  =09leaf =3D bp->b_addr;
>  =09xfs_attr3_leaf_hdr_from_disk(args->geo, &ichdr, leaf);
>  =09entries =3D xfs_attr3_leaf_entryp(leaf);
> -=09if (ichdr.count >=3D args->geo->blksize / 8)
> +=09if (ichdr.count >=3D args->geo->blksize / 8) {
> +=09=09xfs_buf_corruption_error(bp);
>  =09=09return -EFSCORRUPTED;
> +=09}
> =20
>  =09/*
>  =09 * Binary search.  (note: small blocks will skip this loop)
> @@ -2363,10 +2365,14 @@ xfs_attr3_leaf_lookup_int(
>  =09=09else
>  =09=09=09break;
>  =09}
> -=09if (!(probe >=3D 0 && (!ichdr.count || probe < ichdr.count)))
> +=09if (!(probe >=3D 0 && (!ichdr.count || probe < ichdr.count))) {
> +=09=09xfs_buf_corruption_error(bp);
>  =09=09return -EFSCORRUPTED;
> -=09if (!(span <=3D 4 || be32_to_cpu(entry->hashval) =3D=3D hashval))
> +=09}
> +=09if (!(span <=3D 4 || be32_to_cpu(entry->hashval) =3D=3D hashval)) {
> +=09=09xfs_buf_corruption_error(bp);
>  =09=09return -EFSCORRUPTED;
> +=09}
> =20
>  =09/*
>  =09 * Since we may have duplicate hashval's, find the first matching
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index bbabbb41e9d8..64f623d07f82 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -730,6 +730,7 @@ xfs_bmap_extents_to_btree(
>  =09xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, 1L);
>  =09abp =3D xfs_btree_get_bufl(mp, tp, args.fsbno);
>  =09if (!abp) {
> +=09=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
>  =09=09error =3D -EFSCORRUPTED;
>  =09=09goto out_unreserve_dquot;
>  =09}
> @@ -1085,6 +1086,7 @@ xfs_bmap_add_attrfork(
>  =09if (XFS_IFORK_Q(ip))
>  =09=09goto trans_cancel;
>  =09if (ip->i_d.di_anextents !=3D 0) {
> +=09=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
>  =09=09error =3D -EFSCORRUPTED;
>  =09=09goto trans_cancel;
>  =09}
> @@ -1338,6 +1340,7 @@ xfs_bmap_last_before(
>  =09case XFS_DINODE_FMT_EXTENTS:
>  =09=09break;
>  =09default:
> +=09=09ASSERT(0);
>  =09=09return -EFSCORRUPTED;
>  =09}
> =20
> @@ -1438,8 +1441,10 @@ xfs_bmap_last_offset(
>  =09=09return 0;
> =20
>  =09if (XFS_IFORK_FORMAT(ip, whichfork) !=3D XFS_DINODE_FMT_BTREE &&
> -=09    XFS_IFORK_FORMAT(ip, whichfork) !=3D XFS_DINODE_FMT_EXTENTS)
> +=09    XFS_IFORK_FORMAT(ip, whichfork) !=3D XFS_DINODE_FMT_EXTENTS) {
> +=09=09ASSERT(0);
>  =09=09return -EFSCORRUPTED;
> +=09}
> =20
>  =09error =3D xfs_bmap_last_extent(NULL, ip, whichfork, &rec, &is_empty);
>  =09if (error || is_empty)
> @@ -5830,6 +5835,7 @@ xfs_bmap_insert_extents(
>  =09=09=09=09del_cursor);
> =20
>  =09if (stop_fsb >=3D got.br_startoff + got.br_blockcount) {
> +=09=09ASSERT(0);
>  =09=09error =3D -EFSCORRUPTED;
>  =09=09goto del_cursor;
>  =09}
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 4fd89c80c821..98843f1258b8 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -1820,6 +1820,7 @@ xfs_btree_lookup_get_block(
> =20
>  out_bad:
>  =09*blkp =3D NULL;
> +=09xfs_buf_corruption_error(bp);
>  =09xfs_trans_brelse(cur->bc_tp, bp);
>  =09return -EFSCORRUPTED;
>  }
> @@ -1867,8 +1868,10 @@ xfs_btree_lookup(
>  =09XFS_BTREE_STATS_INC(cur, lookup);
> =20
>  =09/* No such thing as a zero-level tree. */
> -=09if (cur->bc_nlevels =3D=3D 0)
> +=09if (cur->bc_nlevels =3D=3D 0) {
> +=09=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, cur->bc_mp);
>  =09=09return -EFSCORRUPTED;
> +=09}
> =20
>  =09block =3D NULL;
>  =09keyno =3D 0;
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 4fd1223c1bd5..1e2dc65adeb8 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -504,6 +504,7 @@ xfs_da3_split(
>  =09node =3D oldblk->bp->b_addr;
>  =09if (node->hdr.info.forw) {
>  =09=09if (be32_to_cpu(node->hdr.info.forw) !=3D addblk->blkno) {
> +=09=09=09xfs_buf_corruption_error(oldblk->bp);
>  =09=09=09error =3D -EFSCORRUPTED;
>  =09=09=09goto out;
>  =09=09}
> @@ -516,6 +517,7 @@ xfs_da3_split(
>  =09node =3D oldblk->bp->b_addr;
>  =09if (node->hdr.info.back) {
>  =09=09if (be32_to_cpu(node->hdr.info.back) !=3D addblk->blkno) {
> +=09=09=09xfs_buf_corruption_error(oldblk->bp);
>  =09=09=09error =3D -EFSCORRUPTED;
>  =09=09=09goto out;
>  =09=09}
> @@ -1541,8 +1543,10 @@ xfs_da3_node_lookup_int(
>  =09=09=09break;
>  =09=09}
> =20
> -=09=09if (magic !=3D XFS_DA_NODE_MAGIC && magic !=3D XFS_DA3_NODE_MAGIC)
> +=09=09if (magic !=3D XFS_DA_NODE_MAGIC && magic !=3D XFS_DA3_NODE_MAGIC)=
 {
> +=09=09=09xfs_buf_corruption_error(blk->bp);
>  =09=09=09return -EFSCORRUPTED;
> +=09=09}
> =20
>  =09=09blk->magic =3D XFS_DA_NODE_MAGIC;
> =20
> @@ -1554,15 +1558,18 @@ xfs_da3_node_lookup_int(
>  =09=09btree =3D dp->d_ops->node_tree_p(node);
> =20
>  =09=09/* Tree taller than we can handle; bail out! */
> -=09=09if (nodehdr.level >=3D XFS_DA_NODE_MAXDEPTH)
> +=09=09if (nodehdr.level >=3D XFS_DA_NODE_MAXDEPTH) {
> +=09=09=09xfs_buf_corruption_error(blk->bp);
>  =09=09=09return -EFSCORRUPTED;
> +=09=09}
> =20
>  =09=09/* Check the level from the root. */
>  =09=09if (blkno =3D=3D args->geo->leafblk)
>  =09=09=09expected_level =3D nodehdr.level - 1;
> -=09=09else if (expected_level !=3D nodehdr.level)
> +=09=09else if (expected_level !=3D nodehdr.level) {
> +=09=09=09xfs_buf_corruption_error(blk->bp);
>  =09=09=09return -EFSCORRUPTED;
> -=09=09else
> +=09=09} else
>  =09=09=09expected_level--;
> =20
>  =09=09max =3D nodehdr.count;
> @@ -1612,12 +1619,17 @@ xfs_da3_node_lookup_int(
>  =09=09}
> =20
>  =09=09/* We can't point back to the root. */
> -=09=09if (blkno =3D=3D args->geo->leafblk)
> +=09=09if (blkno =3D=3D args->geo->leafblk) {
> +=09=09=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> +=09=09=09=09=09dp->i_mount);
>  =09=09=09return -EFSCORRUPTED;
> +=09=09}
>  =09}
> =20
> -=09if (expected_level !=3D 0)
> +=09if (expected_level !=3D 0) {
> +=09=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, dp->i_mount);
>  =09=09return -EFSCORRUPTED;
> +=09}
> =20
>  =09/*
>  =09 * A leaf block that ends in the hashval that we are interested in
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 867c5dee0751..452d04ae10ce 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -600,8 +600,10 @@ xfs_dir2_isblock(
>  =09if ((rval =3D xfs_bmap_last_offset(args->dp, &last, XFS_DATA_FORK)))
>  =09=09return rval;
>  =09rval =3D XFS_FSB_TO_B(args->dp->i_mount, last) =3D=3D args->geo->blks=
ize;
> -=09if (rval !=3D 0 && args->dp->i_d.di_size !=3D args->geo->blksize)
> +=09if (rval !=3D 0 && args->dp->i_d.di_size !=3D args->geo->blksize) {
> +=09=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, args->dp->i_mount);
>  =09=09return -EFSCORRUPTED;
> +=09}
>  =09*vp =3D rval;
>  =09return 0;
>  }
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.=
c
> index a53e4585a2f3..388b5da12228 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -1343,8 +1343,10 @@ xfs_dir2_leaf_removename(
>  =09oldbest =3D be16_to_cpu(bf[0].length);
>  =09ltp =3D xfs_dir2_leaf_tail_p(args->geo, leaf);
>  =09bestsp =3D xfs_dir2_leaf_bests_p(ltp);
> -=09if (be16_to_cpu(bestsp[db]) !=3D oldbest)
> +=09if (be16_to_cpu(bestsp[db]) !=3D oldbest) {
> +=09=09xfs_buf_corruption_error(lbp);
>  =09=09return -EFSCORRUPTED;
> +=09}
>  =09/*
>  =09 * Mark the former data entry unused.
>  =09 */
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.=
c
> index 705c4f562758..72d7ed17eef5 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -373,8 +373,10 @@ xfs_dir2_leaf_to_node(
>  =09leaf =3D lbp->b_addr;
>  =09ltp =3D xfs_dir2_leaf_tail_p(args->geo, leaf);
>  =09if (be32_to_cpu(ltp->bestcount) >
> -=09=09=09=09(uint)dp->i_d.di_size / args->geo->blksize)
> +=09=09=09=09(uint)dp->i_d.di_size / args->geo->blksize) {
> +=09=09xfs_buf_corruption_error(lbp);
>  =09=09return -EFSCORRUPTED;
> +=09}
> =20
>  =09/*
>  =09 * Copy freespace entries from the leaf block to the new block.
> @@ -445,8 +447,10 @@ xfs_dir2_leafn_add(
>  =09 * Quick check just to make sure we are not going to index
>  =09 * into other peoples memory
>  =09 */
> -=09if (index < 0)
> +=09if (index < 0) {
> +=09=09xfs_buf_corruption_error(bp);
>  =09=09return -EFSCORRUPTED;
> +=09}
> =20
>  =09/*
>  =09 * If there are already the maximum number of leaf entries in
> @@ -739,8 +743,10 @@ xfs_dir2_leafn_lookup_for_entry(
>  =09ents =3D dp->d_ops->leaf_ents_p(leaf);
> =20
>  =09xfs_dir3_leaf_check(dp, bp);
> -=09if (leafhdr.count <=3D 0)
> +=09if (leafhdr.count <=3D 0) {
> +=09=09xfs_buf_corruption_error(bp);
>  =09=09return -EFSCORRUPTED;
> +=09}
> =20
>  =09/*
>  =09 * Look up the hash value in the leaf entries.
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_for=
k.c
> index 8fdd0424070e..15d6f947620f 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -75,11 +75,15 @@ xfs_iformat_fork(
>  =09=09=09error =3D xfs_iformat_btree(ip, dip, XFS_DATA_FORK);
>  =09=09=09break;
>  =09=09default:
> +=09=09=09xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
> +=09=09=09=09=09dip, sizeof(*dip), __this_address);
>  =09=09=09return -EFSCORRUPTED;
>  =09=09}
>  =09=09break;
> =20
>  =09default:
> +=09=09xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
> +=09=09=09=09sizeof(*dip), __this_address);
>  =09=09return -EFSCORRUPTED;
>  =09}
>  =09if (error)
> @@ -110,6 +114,8 @@ xfs_iformat_fork(
>  =09=09error =3D xfs_iformat_btree(ip, dip, XFS_ATTR_FORK);
>  =09=09break;
>  =09default:
> +=09=09xfs_inode_verifier_error(ip, error, __func__, dip,
> +=09=09=09=09sizeof(*dip), __this_address);
>  =09=09error =3D -EFSCORRUPTED;
>  =09=09break;
>  =09}
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 9a7fadb1361c..78236bd6c64f 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -1591,8 +1591,10 @@ xfs_refcount_recover_extent(
>  =09struct list_head=09=09*debris =3D priv;
>  =09struct xfs_refcount_recovery=09*rr;
> =20
> -=09if (be32_to_cpu(rec->refc.rc_refcount) !=3D 1)
> +=09if (be32_to_cpu(rec->refc.rc_refcount) !=3D 1) {
> +=09=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, cur->bc_mp);
>  =09=09return -EFSCORRUPTED;
> +=09}
> =20
>  =09rr =3D kmem_alloc(sizeof(struct xfs_refcount_recovery), 0);
>  =09xfs_refcount_btrec_to_irec(rec, &rr->rr_rrec);
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index 8ea1efc97b41..d8aaa1de921c 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -15,7 +15,7 @@
>  #include "xfs_bmap.h"
>  #include "xfs_trans.h"
>  #include "xfs_rtalloc.h"
> -
> +#include "xfs_error.h"
> =20
>  /*
>   * Realtime allocator bitmap functions shared with userspace.
> @@ -70,8 +70,10 @@ xfs_rtbuf_get(
>  =09if (error)
>  =09=09return error;
> =20
> -=09if (nmap =3D=3D 0 || !xfs_bmap_is_real_extent(&map))
> +=09if (nmap =3D=3D 0 || !xfs_bmap_is_real_extent(&map)) {
> +=09=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
>  =09=09return -EFSCORRUPTED;
> +=09}
> =20
>  =09ASSERT(map.br_startblock !=3D NULLFSBLOCK);
>  =09error =3D xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index 96d7071cfa46..3f2292c7835c 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -12,6 +12,7 @@
>  #include "xfs_inode.h"
>  #include "xfs_attr.h"
>  #include "xfs_trace.h"
> +#include "xfs_error.h"
>  #include <linux/posix_acl_xattr.h>
> =20
> =20
> @@ -23,6 +24,7 @@
> =20
>  STATIC struct posix_acl *
>  xfs_acl_from_disk(
> +=09struct xfs_mount=09*mp,
>  =09const struct xfs_acl=09*aclp,
>  =09int=09=09=09len,
>  =09int=09=09=09max_entries)
> @@ -32,11 +34,18 @@ xfs_acl_from_disk(
>  =09const struct xfs_acl_entry *ace;
>  =09unsigned int count, i;
> =20
> -=09if (len < sizeof(*aclp))
> +=09if (len < sizeof(*aclp)) {
> +=09=09XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, aclp,
> +=09=09=09=09len);
>  =09=09return ERR_PTR(-EFSCORRUPTED);
> +=09}
> +
>  =09count =3D be32_to_cpu(aclp->acl_cnt);
> -=09if (count > max_entries || XFS_ACL_SIZE(count) !=3D len)
> +=09if (count > max_entries || XFS_ACL_SIZE(count) !=3D len) {
> +=09=09XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, aclp,
> +=09=09=09=09len);
>  =09=09return ERR_PTR(-EFSCORRUPTED);
> +=09}
> =20
>  =09acl =3D posix_acl_alloc(count, GFP_KERNEL);
>  =09if (!acl)
> @@ -145,7 +154,7 @@ xfs_get_acl(struct inode *inode, int type)
>  =09=09if (error !=3D -ENOATTR)
>  =09=09=09acl =3D ERR_PTR(error);
>  =09} else  {
> -=09=09acl =3D xfs_acl_from_disk(xfs_acl, len,
> +=09=09acl =3D xfs_acl_from_disk(ip->i_mount, xfs_acl, len,
>  =09=09=09=09=09XFS_ACL_MAX_ENTRIES(ip->i_mount));
>  =09=09kmem_free(xfs_acl);
>  =09}
> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> index f83f11d929e4..43ae392992e7 100644
> --- a/fs/xfs/xfs_attr_inactive.c
> +++ b/fs/xfs/xfs_attr_inactive.c
> @@ -22,6 +22,7 @@
>  #include "xfs_attr_leaf.h"
>  #include "xfs_quota.h"
>  #include "xfs_dir2.h"
> +#include "xfs_error.h"
> =20
>  /*
>   * Look at all the extents for this logical region,
> @@ -209,6 +210,7 @@ xfs_attr3_node_inactive(
>  =09 */
>  =09if (level > XFS_DA_NODE_MAXDEPTH) {
>  =09=09xfs_trans_brelse(*trans, bp);=09/* no locks for later trans */
> +=09=09xfs_buf_corruption_error(bp);
>  =09=09return -EFSCORRUPTED;
>  =09}
> =20
> @@ -258,8 +260,9 @@ xfs_attr3_node_inactive(
>  =09=09=09error =3D xfs_attr3_leaf_inactive(trans, dp, child_bp);
>  =09=09=09break;
>  =09=09default:
> -=09=09=09error =3D -EFSCORRUPTED;
> +=09=09=09xfs_buf_corruption_error(child_bp);
>  =09=09=09xfs_trans_brelse(*trans, child_bp);
> +=09=09=09error =3D -EFSCORRUPTED;
>  =09=09=09break;
>  =09=09}
>  =09=09if (error)
> @@ -342,6 +345,7 @@ xfs_attr3_root_inactive(
>  =09=09break;
>  =09default:
>  =09=09error =3D -EFSCORRUPTED;
> +=09=09xfs_buf_corruption_error(bp);
>  =09=09xfs_trans_brelse(*trans, bp);
>  =09=09break;
>  =09}
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index c02f22d50e45..64f6ceba9254 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -269,8 +269,10 @@ xfs_attr_node_list_lookup(
>  =09=09=09return 0;
> =20
>  =09=09/* We can't point back to the root. */
> -=09=09if (cursor->blkno =3D=3D 0)
> +=09=09if (cursor->blkno =3D=3D 0) {
> +=09=09=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
>  =09=09=09return -EFSCORRUPTED;
> +=09=09}
>  =09}
> =20
>  =09if (expected_level !=3D 0)
> @@ -280,6 +282,7 @@ xfs_attr_node_list_lookup(
>  =09return 0;
> =20
>  out_corruptbuf:
> +=09xfs_buf_corruption_error(bp);
>  =09xfs_trans_brelse(tp, bp);
>  =09return -EFSCORRUPTED;
>  }
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 83d24e983d4c..26c87fd9ac9f 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -21,7 +21,7 @@
>  #include "xfs_icache.h"
>  #include "xfs_bmap_btree.h"
>  #include "xfs_trans_space.h"
> -
> +#include "xfs_error.h"
> =20
>  kmem_zone_t=09*xfs_bui_zone;
>  kmem_zone_t=09*xfs_bud_zone;
> @@ -525,6 +525,7 @@ xfs_bui_recover(
>  =09=09type =3D bui_type;
>  =09=09break;
>  =09default:
> +=09=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
>  =09=09error =3D -EFSCORRUPTED;
>  =09=09goto err_inode;
>  =09}
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 0b156cc88108..d8cdb27fe6ed 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -341,6 +341,27 @@ xfs_corruption_error(
>  =09xfs_alert(mp, "Corruption detected. Unmount and run xfs_repair");
>  }
> =20
> +/*
> + * Complain about the kinds of metadata corruption that we can't detect =
from a
> + * verifier, such as incorrect inter-block relationship data.  Does not =
set
> + * bp->b_error.
> + */
> +void
> +xfs_buf_corruption_error(
> +=09struct xfs_buf=09=09*bp)
> +{
> +=09struct xfs_mount=09*mp =3D bp->b_mount;
> +
> +=09xfs_alert_tag(mp, XFS_PTAG_VERIFIER_ERROR,
> +=09=09  "Metadata corruption detected at %pS, %s block 0x%llx",
> +=09=09  __return_address, bp->b_ops->name, bp->b_bn);
> +
> +=09xfs_alert(mp, "Unmount and run xfs_repair");
> +
> +=09if (xfs_error_level >=3D XFS_ERRLEVEL_HIGH)
> +=09=09xfs_stack_trace();
> +}
> +
>  /*
>   * Warnings specifically for verifier errors.  Differentiate CRC vs. inv=
alid
>   * values, and omit the stack trace unless the error level is tuned high=
.
> diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> index e6a22cfb542f..c319379f7d1a 100644
> --- a/fs/xfs/xfs_error.h
> +++ b/fs/xfs/xfs_error.h
> @@ -15,6 +15,7 @@ extern void xfs_corruption_error(const char *tag, int l=
evel,
>  =09=09=09struct xfs_mount *mp, const void *buf, size_t bufsize,
>  =09=09=09const char *filename, int linenum,
>  =09=09=09xfs_failaddr_t failaddr);
> +void xfs_buf_corruption_error(struct xfs_buf *bp);
>  extern void xfs_buf_verifier_error(struct xfs_buf *bp, int error,
>  =09=09=09const char *name, const void *buf, size_t bufsz,
>  =09=09=09xfs_failaddr_t failaddr);
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index e44efc41a041..a6f6acc8fbb7 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -21,7 +21,7 @@
>  #include "xfs_alloc.h"
>  #include "xfs_bmap.h"
>  #include "xfs_trace.h"
> -
> +#include "xfs_error.h"
> =20
>  kmem_zone_t=09*xfs_efi_zone;
>  kmem_zone_t=09*xfs_efd_zone;
> @@ -228,6 +228,7 @@ xfs_efi_copy_format(xfs_log_iovec_t *buf, xfs_efi_log=
_format_t *dst_efi_fmt)
>  =09=09}
>  =09=09return 0;
>  =09}
> +=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
>  =09return -EFSCORRUPTED;
>  }
> =20
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index e9e4f444f8ce..a92d4521748d 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2136,8 +2136,10 @@ xfs_iunlink_update_bucket(
>  =09 * passed in because either we're adding or removing ourselves from t=
he
>  =09 * head of the list.
>  =09 */
> -=09if (old_value =3D=3D new_agino)
> +=09if (old_value =3D=3D new_agino) {
> +=09=09xfs_buf_corruption_error(agibp);
>  =09=09return -EFSCORRUPTED;
> +=09}
> =20
>  =09agi->agi_unlinked[bucket_index] =3D cpu_to_be32(new_agino);
>  =09offset =3D offsetof(struct xfs_agi, agi_unlinked) +
> @@ -2200,6 +2202,8 @@ xfs_iunlink_update_inode(
>  =09/* Make sure the old pointer isn't garbage. */
>  =09old_value =3D be32_to_cpu(dip->di_next_unlinked);
>  =09if (!xfs_verify_agino_or_null(mp, agno, old_value)) {
> +=09=09xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
> +=09=09=09=09sizeof(*dip), __this_address);
>  =09=09error =3D -EFSCORRUPTED;
>  =09=09goto out;
>  =09}
> @@ -2211,8 +2215,11 @@ xfs_iunlink_update_inode(
>  =09 */
>  =09*old_next_agino =3D old_value;
>  =09if (old_value =3D=3D next_agino) {
> -=09=09if (next_agino !=3D NULLAGINO)
> +=09=09if (next_agino !=3D NULLAGINO) {
> +=09=09=09xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
> +=09=09=09=09=09dip, sizeof(*dip), __this_address);
>  =09=09=09error =3D -EFSCORRUPTED;
> +=09=09}
>  =09=09goto out;
>  =09}
> =20
> @@ -2263,8 +2270,10 @@ xfs_iunlink(
>  =09 */
>  =09next_agino =3D be32_to_cpu(agi->agi_unlinked[bucket_index]);
>  =09if (next_agino =3D=3D agino ||
> -=09    !xfs_verify_agino_or_null(mp, agno, next_agino))
> +=09    !xfs_verify_agino_or_null(mp, agno, next_agino)) {
> +=09=09xfs_buf_corruption_error(agibp);
>  =09=09return -EFSCORRUPTED;
> +=09}
> =20
>  =09if (next_agino !=3D NULLAGINO) {
>  =09=09struct xfs_perag=09*pag;
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index bb8f076805b9..726aa3bfd6e8 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -17,6 +17,7 @@
>  #include "xfs_trans_priv.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_log.h"
> +#include "xfs_error.h"
> =20
>  #include <linux/iversion.h>
> =20
> @@ -828,8 +829,10 @@ xfs_inode_item_format_convert(
>  {
>  =09struct xfs_inode_log_format_32=09*in_f32 =3D buf->i_addr;
> =20
> -=09if (buf->i_len !=3D sizeof(*in_f32))
> +=09if (buf->i_len !=3D sizeof(*in_f32)) {
> +=09=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
>  =09=09return -EFSCORRUPTED;
> +=09}
> =20
>  =09in_f->ilf_type =3D in_f32->ilf_type;
>  =09in_f->ilf_size =3D in_f32->ilf_size;
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 18e45e3a3f9f..4c7962ccb0c4 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -20,6 +20,7 @@
>  #include "xfs_symlink.h"
>  #include "xfs_dir2.h"
>  #include "xfs_iomap.h"
> +#include "xfs_error.h"
> =20
>  #include <linux/xattr.h>
>  #include <linux/posix_acl.h>
> @@ -470,17 +471,20 @@ xfs_vn_get_link_inline(
>  =09struct inode=09=09*inode,
>  =09struct delayed_call=09*done)
>  {
> +=09struct xfs_inode=09*ip =3D XFS_I(inode);
>  =09char=09=09=09*link;
> =20
> -=09ASSERT(XFS_I(inode)->i_df.if_flags & XFS_IFINLINE);
> +=09ASSERT(ip->i_df.if_flags & XFS_IFINLINE);
> =20
>  =09/*
>  =09 * The VFS crashes on a NULL pointer, so return -EFSCORRUPTED if
>  =09 * if_data is junk.
>  =09 */
> -=09link =3D XFS_I(inode)->i_df.if_u1.if_data;
> -=09if (!link)
> +=09link =3D ip->i_df.if_u1.if_data;
> +=09if (!link) {
> +=09=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, ip->i_mount);
>  =09=09return ERR_PTR(-EFSCORRUPTED);
> +=09}
>  =09return link;
>  }
> =20
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index c1a514ffff55..648d5ecafd91 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3537,6 +3537,7 @@ xfs_cui_copy_format(
>  =09=09memcpy(dst_cui_fmt, src_cui_fmt, len);
>  =09=09return 0;
>  =09}
> +=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
>  =09return -EFSCORRUPTED;
>  }
> =20
> @@ -3601,8 +3602,10 @@ xlog_recover_cud_pass2(
>  =09struct xfs_ail=09=09=09*ailp =3D log->l_ailp;
> =20
>  =09cud_formatp =3D item->ri_buf[0].i_addr;
> -=09if (item->ri_buf[0].i_len !=3D sizeof(struct xfs_cud_log_format))
> +=09if (item->ri_buf[0].i_len !=3D sizeof(struct xfs_cud_log_format)) {
> +=09=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
>  =09=09return -EFSCORRUPTED;
> +=09}
>  =09cui_id =3D cud_formatp->cud_cui_id;
> =20
>  =09/*
> @@ -3654,6 +3657,7 @@ xfs_bui_copy_format(
>  =09=09memcpy(dst_bui_fmt, src_bui_fmt, len);
>  =09=09return 0;
>  =09}
> +=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
>  =09return -EFSCORRUPTED;
>  }
> =20
> @@ -3677,8 +3681,10 @@ xlog_recover_bui_pass2(
> =20
>  =09bui_formatp =3D item->ri_buf[0].i_addr;
> =20
> -=09if (bui_formatp->bui_nextents !=3D XFS_BUI_MAX_FAST_EXTENTS)
> +=09if (bui_formatp->bui_nextents !=3D XFS_BUI_MAX_FAST_EXTENTS) {
> +=09=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
>  =09=09return -EFSCORRUPTED;
> +=09}
>  =09buip =3D xfs_bui_init(mp);
>  =09error =3D xfs_bui_copy_format(&item->ri_buf[0], &buip->bui_format);
>  =09if (error) {
> @@ -3720,8 +3726,10 @@ xlog_recover_bud_pass2(
>  =09struct xfs_ail=09=09=09*ailp =3D log->l_ailp;
> =20
>  =09bud_formatp =3D item->ri_buf[0].i_addr;
> -=09if (item->ri_buf[0].i_len !=3D sizeof(struct xfs_bud_log_format))
> +=09if (item->ri_buf[0].i_len !=3D sizeof(struct xfs_bud_log_format)) {
> +=09=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
>  =09=09return -EFSCORRUPTED;
> +=09}
>  =09bui_id =3D bud_formatp->bud_bui_id;
> =20
>  =09/*
> @@ -5172,8 +5180,10 @@ xlog_recover_process(
>  =09=09 * If the filesystem is CRC enabled, this mismatch becomes a
>  =09=09 * fatal log corruption failure.
>  =09=09 */
> -=09=09if (xfs_sb_version_hascrc(&log->l_mp->m_sb))
> +=09=09if (xfs_sb_version_hascrc(&log->l_mp->m_sb)) {
> +=09=09=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
>  =09=09=09return -EFSCORRUPTED;
> +=09=09}
>  =09}
> =20
>  =09xlog_unpack_data(rhead, dp, log);
> @@ -5296,8 +5306,11 @@ xlog_do_recovery_pass(
>  =09=09"invalid iclog size (%d bytes), using lsunit (%d bytes)",
>  =09=09=09=09=09 h_size, log->l_mp->m_logbsize);
>  =09=09=09=09h_size =3D log->l_mp->m_logbsize;
> -=09=09=09} else
> +=09=09=09} else {
> +=09=09=09=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> +=09=09=09=09=09=09log->l_mp);
>  =09=09=09=09return -EFSCORRUPTED;
> +=09=09=09}
>  =09=09}
> =20
>  =09=09if ((be32_to_cpu(rhead->h_version) & XLOG_VERSION_2) &&
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index ecd8ce152ab1..66ea8e4fca86 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -22,6 +22,7 @@
>  #include "xfs_qm.h"
>  #include "xfs_trace.h"
>  #include "xfs_icache.h"
> +#include "xfs_error.h"
> =20
>  /*
>   * The global quota manager. There is only one of these for the entire
> @@ -754,11 +755,19 @@ xfs_qm_qino_alloc(
>  =09=09if ((flags & XFS_QMOPT_PQUOTA) &&
>  =09=09=09     (mp->m_sb.sb_gquotino !=3D NULLFSINO)) {
>  =09=09=09ino =3D mp->m_sb.sb_gquotino;
> -=09=09=09ASSERT(mp->m_sb.sb_pquotino =3D=3D NULLFSINO);
> +=09=09=09if (mp->m_sb.sb_pquotino !=3D NULLFSINO) {
> +=09=09=09=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> +=09=09=09=09=09=09mp);
> +=09=09=09=09return -EFSCORRUPTED;
> +=09=09=09}
>  =09=09} else if ((flags & XFS_QMOPT_GQUOTA) &&
>  =09=09=09     (mp->m_sb.sb_pquotino !=3D NULLFSINO)) {
>  =09=09=09ino =3D mp->m_sb.sb_pquotino;
> -=09=09=09ASSERT(mp->m_sb.sb_gquotino =3D=3D NULLFSINO);
> +=09=09=09if (mp->m_sb.sb_gquotino !=3D NULLFSINO) {
> +=09=09=09=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> +=09=09=09=09=09=09mp);
> +=09=09=09=09return -EFSCORRUPTED;
> +=09=09=09}
>  =09=09}
>  =09=09if (ino !=3D NULLFSINO) {
>  =09=09=09error =3D xfs_iget(mp, NULL, ino, 0, 0, ip);
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 2328268e6245..576f59fe370e 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -17,7 +17,7 @@
>  #include "xfs_refcount_item.h"
>  #include "xfs_log.h"
>  #include "xfs_refcount.h"
> -
> +#include "xfs_error.h"
> =20
>  kmem_zone_t=09*xfs_cui_zone;
>  kmem_zone_t=09*xfs_cud_zone;
> @@ -536,6 +536,7 @@ xfs_cui_recover(
>  =09=09=09type =3D refc_type;
>  =09=09=09break;
>  =09=09default:
> +=09=09=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
>  =09=09=09error =3D -EFSCORRUPTED;
>  =09=09=09goto abort_error;
>  =09=09}
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 8939e0ea09cd..1d72e4b3ebf1 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -17,7 +17,7 @@
>  #include "xfs_rmap_item.h"
>  #include "xfs_log.h"
>  #include "xfs_rmap.h"
> -
> +#include "xfs_error.h"
> =20
>  kmem_zone_t=09*xfs_rui_zone;
>  kmem_zone_t=09*xfs_rud_zone;
> @@ -171,8 +171,10 @@ xfs_rui_copy_format(
>  =09src_rui_fmt =3D buf->i_addr;
>  =09len =3D xfs_rui_log_format_sizeof(src_rui_fmt->rui_nextents);
> =20
> -=09if (buf->i_len !=3D len)
> +=09if (buf->i_len !=3D len) {
> +=09=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
>  =09=09return -EFSCORRUPTED;
> +=09}
> =20
>  =09memcpy(dst_rui_fmt, src_rui_fmt, len);
>  =09return 0;
> @@ -581,6 +583,7 @@ xfs_rui_recover(
>  =09=09=09type =3D XFS_RMAP_FREE;
>  =09=09=09break;
>  =09=09default:
> +=09=09=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
>  =09=09=09error =3D -EFSCORRUPTED;
>  =09=09=09goto abort_error;
>  =09=09}
>=20

--=20
Carlos

