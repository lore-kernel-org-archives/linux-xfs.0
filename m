Return-Path: <SRS0=wiGc=ZD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E41BC43331
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 13:22:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CEC820659
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 13:22:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K/GqHMOU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbfKKNWp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Nov 2019 08:22:45 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:20249 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726843AbfKKNWp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Nov 2019 08:22:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573478563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rujun5HjmVJkx6dE55WtQPIYlHeqCVYzXmgVY7+ewdw=;
        b=K/GqHMOUtnm+FOPL3nVdiSCABthrMMgCtN3Nnw2h19YiVQUjrgeBUNfQxpmKp+p0MPfu1H
        yXwJzGkb/1JWXKsPI5YyXP/+z3tUzcuuiNB+85HrjwOXhdHgm6bwLK2fPTeyuWMH07IO4R
        gYcGpOksCNJUafdm8+CJaUJJ5U2drq4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-CTKFXUfSOaK8uVzS1TztwQ-1; Mon, 11 Nov 2019 08:22:40 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E887100550E;
        Mon, 11 Nov 2019 13:22:39 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C12660143;
        Mon, 11 Nov 2019 13:22:38 +0000 (UTC)
Date:   Mon, 11 Nov 2019 08:22:36 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        newtongao@tencent.com, jasperwang@tencent.com
Subject: Re: [PATCH v3] xfs: Fix deadlock between AGI and AGF when target_ip
 exists in xfs_rename()
Message-ID: <20191111132236.GA46312@bfoster>
References: <1573128491-14996-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
In-Reply-To: <1573128491-14996-1-git-send-email-kaixuxia@tencent.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: CTKFXUfSOaK8uVzS1TztwQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 08:08:11PM +0800, kaixuxia wrote:
> When target_ip exists in xfs_rename(), the xfs_dir_replace() call may
> need to hold the AGF lock to allocate more blocks, and then invoking
> the xfs_droplink() call to hold AGI lock to drop target_ip onto the
> unlinked list, so we get the lock order AGF->AGI. This would break the
> ordering constraint on AGI and AGF locking - inode allocation locks
> the AGI, then can allocate a new extent for new inodes, locking the
> AGF after the AGI.
>=20
> In this patch we check whether the replace operation need more
> blocks firstly. If so, acquire the agi lock firstly to preserve
> locking order(AGI/AGF). Actually, the locking order problem only
> occurs when we are locking the AGI/AGF of the same AG. For multiple
> AGs the AGI lock will be released after the transaction committed.
>=20
> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
> ---
> Changes in v3:
>  -Invoke xfs_dir2_sf_replace_needblock() call in xfs_inode.c
>   directly.
>  -Fix the typo.
>=20
>  fs/xfs/libxfs/xfs_dir2.h    |  2 ++
>  fs/xfs/libxfs/xfs_dir2_sf.c | 21 +++++++++++++++++++++
>  fs/xfs/xfs_inode.c          | 15 +++++++++++++++
>  3 files changed, 38 insertions(+)
>=20
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index f542447..d4a2b09 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -124,6 +124,8 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struc=
t xfs_inode *dp,
>  extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp=
,
>  =09=09=09=09struct xfs_name *name, xfs_ino_t ino,
>  =09=09=09=09xfs_extlen_t tot);
> +extern bool xfs_dir2_sf_replace_needblock(struct xfs_inode *dp,
> +=09=09=09=09struct xfs_inode *src_ip);
>  extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
>  =09=09=09=09struct xfs_name *name, xfs_ino_t inum,
>  =09=09=09=09xfs_extlen_t tot);
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index 85f14fc..7098cdd 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -945,6 +945,27 @@ static int xfs_dir2_sf_addname_pick(xfs_da_args_t *a=
rgs, int objchange,
>  }
> =20
>  /*
> + * Check whether the sf dir replace operation need more blocks.
> + */
> +bool
> +xfs_dir2_sf_replace_needblock(
> +=09struct xfs_inode=09*dp,
> +=09struct xfs_inode=09*src_ip)
> +{
> +=09int=09=09=09newsize;
> +=09xfs_dir2_sf_hdr_t=09*sfp;

We shouldn't introduce new typedef usages. Please use struct
xfs_dir2_sf_hdr here and throughout the patch.

> +
> +=09if (dp->i_d.di_format !=3D XFS_DINODE_FMT_LOCAL)
> +=09=09return false;
> +
> +=09sfp =3D (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
> +=09newsize =3D dp->i_df.if_bytes + (sfp->count + 1) * XFS_INO64_DIFF;
> +
> +=09return src_ip->i_ino > XFS_DIR2_MAX_SHORT_INUM &&
> +=09       sfp->i8count =3D=3D 0 && newsize > XFS_IFORK_DSIZE(dp);
> +}
> +

The whole point of this function is to reduce code duplication. There
should be two callers, one down in the dir code that does the format
conversion and the new caller in the higher level code to grab the AGI.

Brian

> +/*
>   * Replace the inode number of an entry in a shortform directory.
>   */
>  int=09=09=09=09=09=09/* error */
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 18f4b26..cb0b93b 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3196,6 +3196,7 @@ struct xfs_iunlink {
>  =09struct xfs_trans=09*tp;
>  =09struct xfs_inode=09*wip =3D NULL;=09=09/* whiteout inode */
>  =09struct xfs_inode=09*inodes[__XFS_SORT_INODES];
> +=09struct xfs_buf=09=09*agibp;
>  =09int=09=09=09num_inodes =3D __XFS_SORT_INODES;
>  =09bool=09=09=09new_parent =3D (src_dp !=3D target_dp);
>  =09bool=09=09=09src_is_directory =3D S_ISDIR(VFS_I(src_ip)->i_mode);
> @@ -3361,6 +3362,20 @@ struct xfs_iunlink {
>  =09=09 * In case there is already an entry with the same
>  =09=09 * name at the destination directory, remove it first.
>  =09=09 */
> +
> +=09=09/*
> +=09=09 * Check whether the replace operation need more blocks.
> +=09=09 * If so, acquire the agi lock firstly to preserve locking
> +=09=09 * order (AGI/AGF). Only convert the shortform directory to
> +=09=09 * block form maybe need more blocks.
> +=09=09 */
> +=09=09if (xfs_dir2_sf_replace_needblock(target_dp, src_ip)) {
> +=09=09=09error =3D xfs_read_agi(mp, tp,
> +=09=09=09=09XFS_INO_TO_AGNO(mp, target_ip->i_ino), &agibp);
> +=09=09=09if (error)
> +=09=09=09=09goto out_trans_cancel;
> +=09=09}
> +
>  =09=09error =3D xfs_dir_replace(tp, target_dp, target_name,
>  =09=09=09=09=09src_ip->i_ino, spaceres);
>  =09=09if (error)
> --=20
> 1.8.3.1
>=20

