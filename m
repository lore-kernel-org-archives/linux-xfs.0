Return-Path: <SRS0=q11v=YV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2EAFCA9EC0
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 18:19:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF0BC214B2
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 18:19:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JXbb/x/j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391123AbfJ1STa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 14:19:30 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:40973 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730690AbfJ1STa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 14:19:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572286769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WT61kzhOs9PIPQhaMLbMXpcQ11M1bV1DztyeIDiUxew=;
        b=JXbb/x/j1oYkJFk2xP1rn4FaxfBTNlNOwUs+1MjN65KDR1I6OzVdJUncxLVf2vVIxxL5DC
        pq/kb5QKeW3ZMaVwDPgOCiFzbJhcYvJCgXDRI78T3t2avMCq86D01aWRaeZpADTY+T6B3A
        cK1ZSV5QSJnWXcioQcoSgaCltcx6kGA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-4EUS0jv0MveltAZoAJRmfA-1; Mon, 28 Oct 2019 14:19:25 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F09BD107AD28;
        Mon, 28 Oct 2019 18:19:24 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B1AB5C1B2;
        Mon, 28 Oct 2019 18:19:24 +0000 (UTC)
Date:   Mon, 28 Oct 2019 14:19:22 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: replace -EIO with -EFSCORRUPTED for corrupt
 metadata
Message-ID: <20191028181922.GE26529@bfoster>
References: <157198048552.2873445.18067788660614948888.stgit@magnolia>
 <157198051168.2873445.9385238357724841029.stgit@magnolia>
MIME-Version: 1.0
In-Reply-To: <157198051168.2873445.9385238357724841029.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: 4EUS0jv0MveltAZoAJRmfA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 24, 2019 at 10:15:11PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> There are a few places where we return -EIO instead of -EFSCORRUPTED
> when we find corrupt metadata.  Fix those places.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c   |    6 +++---
>  fs/xfs/xfs_attr_inactive.c |    6 +++---
>  fs/xfs/xfs_dquot.c         |    2 +-
>  3 files changed, 7 insertions(+), 7 deletions(-)
>=20
>=20
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 02469d59c787..587889585a23 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1374,7 +1374,7 @@ xfs_bmap_last_before(
>  =09case XFS_DINODE_FMT_EXTENTS:
>  =09=09break;
>  =09default:
> -=09=09return -EIO;
> +=09=09return -EFSCORRUPTED;
>  =09}
> =20
>  =09if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> @@ -1475,7 +1475,7 @@ xfs_bmap_last_offset(
> =20
>  =09if (XFS_IFORK_FORMAT(ip, whichfork) !=3D XFS_DINODE_FMT_BTREE &&
>  =09    XFS_IFORK_FORMAT(ip, whichfork) !=3D XFS_DINODE_FMT_EXTENTS)
> -=09       return -EIO;
> +=09=09return -EFSCORRUPTED;
> =20
>  =09error =3D xfs_bmap_last_extent(NULL, ip, whichfork, &rec, &is_empty);
>  =09if (error || is_empty)
> @@ -5864,7 +5864,7 @@ xfs_bmap_insert_extents(
>  =09=09=09=09del_cursor);
> =20
>  =09if (stop_fsb >=3D got.br_startoff + got.br_blockcount) {
> -=09=09error =3D -EIO;
> +=09=09error =3D -EFSCORRUPTED;
>  =09=09goto del_cursor;
>  =09}
> =20
> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> index a640a285cc52..f83f11d929e4 100644
> --- a/fs/xfs/xfs_attr_inactive.c
> +++ b/fs/xfs/xfs_attr_inactive.c
> @@ -209,7 +209,7 @@ xfs_attr3_node_inactive(
>  =09 */
>  =09if (level > XFS_DA_NODE_MAXDEPTH) {
>  =09=09xfs_trans_brelse(*trans, bp);=09/* no locks for later trans */
> -=09=09return -EIO;
> +=09=09return -EFSCORRUPTED;
>  =09}
> =20
>  =09node =3D bp->b_addr;
> @@ -258,7 +258,7 @@ xfs_attr3_node_inactive(
>  =09=09=09error =3D xfs_attr3_leaf_inactive(trans, dp, child_bp);
>  =09=09=09break;
>  =09=09default:
> -=09=09=09error =3D -EIO;
> +=09=09=09error =3D -EFSCORRUPTED;
>  =09=09=09xfs_trans_brelse(*trans, child_bp);
>  =09=09=09break;
>  =09=09}
> @@ -341,7 +341,7 @@ xfs_attr3_root_inactive(
>  =09=09error =3D xfs_attr3_leaf_inactive(trans, dp, bp);
>  =09=09break;
>  =09default:
> -=09=09error =3D -EIO;
> +=09=09error =3D -EFSCORRUPTED;
>  =09=09xfs_trans_brelse(*trans, bp);
>  =09=09break;
>  =09}
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index aeb95e7391c1..2b87c96fb2c0 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1126,7 +1126,7 @@ xfs_qm_dqflush(
>  =09=09xfs_buf_relse(bp);
>  =09=09xfs_dqfunlock(dqp);
>  =09=09xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> -=09=09return -EIO;
> +=09=09return -EFSCORRUPTED;
>  =09}
> =20
>  =09/* This is the only portion of data that needs to persist */
>=20

