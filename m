Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42B82C5DF60
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 15:54:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FF2720663
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 15:54:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kp2TrgNL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730118AbfKGPyD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 10:54:03 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60374 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729967AbfKGPyC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 10:54:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573142041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J3983HljHvK8v8TIaFNgSJMZ/Zy5XY1rwBeByujx0pY=;
        b=Kp2TrgNLs6uSdnsESvEcKkAYvKPVpioPayYhJ2Dab3lTXzYrGMYeCOXW7KVjcHO7t0392m
        uUUwGYT/kRgCo4Tlu5MVbKyLlPNSL1WVdosq5Ch+9wDrk9bxlISobU1T58yMKhOzyT3KNK
        apvJpAQ+1naxYmd4LEYQPNob34dXLQ4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-152-hx69QlBLPaWB52zwKrHtsA-1; Thu, 07 Nov 2019 10:53:57 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E348477;
        Thu,  7 Nov 2019 15:53:56 +0000 (UTC)
Received: from redhat.com (ovpn-123-234.rdu2.redhat.com [10.10.123.234])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A65F6608B2;
        Thu,  7 Nov 2019 15:53:55 +0000 (UTC)
Date:   Thu, 7 Nov 2019 09:53:53 -0600
From:   Bill O'Donnell <billodo@redhat.com>
To:     Joe Perches <joe@perches.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: Correct comment tyops -> typos
Message-ID: <20191107155353.GB319242@redhat.com>
References: <0ceb6a89da4424a4500789610fae4d05ba45ba86.camel@perches.com>
MIME-Version: 1.0
In-Reply-To: <0ceb6a89da4424a4500789610fae4d05ba45ba86.camel@perches.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: hx69QlBLPaWB52zwKrHtsA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 10:01:15PM -0800, Joe Perches wrote:
> Just fix the typos checkpatch notices...
>=20
> Signed-off-by: Joe Perches <joe@perches.com>

Thanks!
Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  fs/xfs/kmem.c                  | 2 +-
>  fs/xfs/libxfs/xfs_alloc.c      | 2 +-
>  fs/xfs/libxfs/xfs_attr_leaf.c  | 2 +-
>  fs/xfs/libxfs/xfs_da_format.h  | 2 +-
>  fs/xfs/libxfs/xfs_fs.h         | 2 +-
>  fs/xfs/libxfs/xfs_log_format.h | 4 ++--
>  fs/xfs/xfs_buf.c               | 2 +-
>  fs/xfs/xfs_log_cil.c           | 4 ++--
>  fs/xfs/xfs_symlink.h           | 2 +-
>  fs/xfs/xfs_trans_ail.c         | 8 ++++----
>  10 files changed, 15 insertions(+), 15 deletions(-)
>=20
> diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
> index da031b9..1da942 100644
> --- a/fs/xfs/kmem.c
> +++ b/fs/xfs/kmem.c
> @@ -32,7 +32,7 @@ kmem_alloc(size_t size, xfs_km_flags_t flags)
> =20
> =20
>  /*
> - * __vmalloc() will allocate data pages and auxillary structures (e.g.
> + * __vmalloc() will allocate data pages and auxiliary structures (e.g.
>   * pagetables) with GFP_KERNEL, yet we may be under GFP_NOFS context her=
e. Hence
>   * we need to tell memory reclaim that we are in such a context via
>   * PF_MEMALLOC_NOFS to prevent memory reclaim re-entering the filesystem=
 here
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index f7a4b5..b39bd8 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1488,7 +1488,7 @@ xfs_alloc_ag_vextent_near(
>  =09dofirst =3D prandom_u32() & 1;
>  #endif
> =20
> -=09/* handle unitialized agbno range so caller doesn't have to */
> +=09/* handle uninitialized agbno range so caller doesn't have to */
>  =09if (!args->min_agbno && !args->max_agbno)
>  =09=09args->max_agbno =3D args->mp->m_sb.sb_agblocks - 1;
>  =09ASSERT(args->min_agbno <=3D args->max_agbno);
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.=
c
> index dca884..8ba3ae8 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -829,7 +829,7 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
>  }
> =20
>  /*
> - * Retreive the attribute value and length.
> + * Retrieve the attribute value and length.
>   *
>   * If ATTR_KERNOVAL is specified, only the length needs to be returned.
>   * Unlike a lookup, we only return an error if the attribute does not
> diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.=
h
> index ae654e0..6702a08 100644
> --- a/fs/xfs/libxfs/xfs_da_format.h
> +++ b/fs/xfs/libxfs/xfs_da_format.h
> @@ -482,7 +482,7 @@ xfs_dir2_leaf_bests_p(struct xfs_dir2_leaf_tail *ltp)
>  }
> =20
>  /*
> - * Free space block defintions for the node format.
> + * Free space block definitions for the node format.
>   */
> =20
>  /*
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index e9371a..038a16a 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -416,7 +416,7 @@ struct xfs_bulkstat {
> =20
>  /*
>   * Project quota id helpers (previously projid was 16bit only
> - * and using two 16bit values to hold new 32bit projid was choosen
> + * and using two 16bit values to hold new 32bit projid was chosen
>   * to retain compatibility with "old" filesystems).
>   */
>  static inline uint32_t
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_forma=
t.h
> index e5f97c6..8ef31d7 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -432,9 +432,9 @@ static inline uint xfs_log_dinode_size(int version)
>  }
> =20
>  /*
> - * Buffer Log Format defintions
> + * Buffer Log Format definitions
>   *
> - * These are the physical dirty bitmap defintions for the log format str=
ucture.
> + * These are the physical dirty bitmap definitions for the log format st=
ructure.
>   */
>  #define=09XFS_BLF_CHUNK=09=09128
>  #define=09XFS_BLF_SHIFT=09=097
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 1e63dd3..2ed3c65 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -461,7 +461,7 @@ _xfs_buf_map_pages(
>  =09=09unsigned nofs_flag;
> =20
>  =09=09/*
> -=09=09 * vm_map_ram() will allocate auxillary structures (e.g.
> +=09=09 * vm_map_ram() will allocate auxiliary structures (e.g.
>  =09=09 * pagetables) with GFP_KERNEL, yet we are likely to be under
>  =09=09 * GFP_NOFS context here. Hence we need to tell memory reclaim
>  =09=09 * that we are in such a context via PF_MEMALLOC_NOFS to prevent
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index a120442..48435c 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -179,7 +179,7 @@ xlog_cil_alloc_shadow_bufs(
> =20
>  =09=09=09/*
>  =09=09=09 * We free and allocate here as a realloc would copy
> -=09=09=09 * unecessary data. We don't use kmem_zalloc() for the
> +=09=09=09 * unnecessary data. We don't use kmem_zalloc() for the
>  =09=09=09 * same reason - we don't need to zero the data area in
>  =09=09=09 * the buffer, only the log vector header and the iovec
>  =09=09=09 * storage.
> @@ -682,7 +682,7 @@ xlog_cil_push(
>  =09}
> =20
> =20
> -=09/* check for a previously pushed seqeunce */
> +=09/* check for a previously pushed sequence */
>  =09if (push_seq < cil->xc_ctx->sequence) {
>  =09=09spin_unlock(&cil->xc_push_lock);
>  =09=09goto out_skip;
> diff --git a/fs/xfs/xfs_symlink.h b/fs/xfs/xfs_symlink.h
> index 9743d8c..b1fa09 100644
> --- a/fs/xfs/xfs_symlink.h
> +++ b/fs/xfs/xfs_symlink.h
> @@ -5,7 +5,7 @@
>  #ifndef __XFS_SYMLINK_H
>  #define __XFS_SYMLINK_H 1
> =20
> -/* Kernel only symlink defintions */
> +/* Kernel only symlink definitions */
> =20
>  int xfs_symlink(struct xfs_inode *dp, struct xfs_name *link_name,
>  =09=09const char *target_path, umode_t mode, struct xfs_inode **ipp);
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index aea71e..00cc5b 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -427,15 +427,15 @@ xfsaild_push(
> =20
>  =09=09case XFS_ITEM_FLUSHING:
>  =09=09=09/*
> -=09=09=09 * The item or its backing buffer is already beeing
> +=09=09=09 * The item or its backing buffer is already being
>  =09=09=09 * flushed.  The typical reason for that is that an
>  =09=09=09 * inode buffer is locked because we already pushed the
>  =09=09=09 * updates to it as part of inode clustering.
>  =09=09=09 *
>  =09=09=09 * We do not want to to stop flushing just because lots
> -=09=09=09 * of items are already beeing flushed, but we need to
> +=09=09=09 * of items are already being flushed, but we need to
>  =09=09=09 * re-try the flushing relatively soon if most of the
> -=09=09=09 * AIL is beeing flushed.
> +=09=09=09 * AIL is being flushed.
>  =09=09=09 */
>  =09=09=09XFS_STATS_INC(mp, xs_push_ail_flushing);
>  =09=09=09trace_xfs_ail_flushing(lip);
> @@ -612,7 +612,7 @@ xfsaild(
>   * The push is run asynchronously in a workqueue, which means the caller=
 needs
>   * to handle waiting on the async flush for space to become available.
>   * We don't want to interrupt any push that is in progress, hence we onl=
y queue
> - * work if we set the pushing bit approriately.
> + * work if we set the pushing bit appropriately.
>   *
>   * We do this unlocked - we only need to know whether there is anything =
in the
>   * AIL at the time we are called. We don't need to access the contents o=
f
>=20
>=20

