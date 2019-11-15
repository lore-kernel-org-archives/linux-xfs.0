Return-Path: <SRS0=3CCN=ZH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE667C432C3
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Nov 2019 14:21:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E17820730
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Nov 2019 14:21:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ejyLM3uY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbfKOOVI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Nov 2019 09:21:08 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29999 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727417AbfKOOVH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Nov 2019 09:21:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573827664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tf1ARW7esjBm/hlAgc6lsnDwli51NDszqkoz1U7SljM=;
        b=ejyLM3uYNw9LXexy5LgKk7cUErfPgE+wISOfQHlRhI21CUiagx9AucjND4m0jA2Aq+cnqo
        58Zzb98mB64QSt+HVUGPJ8IBGES3HOdZ+lbObk2wduFyIirQd3dp8O/mY1jwmzRvgn7nBX
        0d2oJGW3vJ29ilzqWYNcTOTcG+kYC4M=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-mxHTYRQuOYq_-4l8qgzbiw-1; Fri, 15 Nov 2019 09:21:03 -0500
Received: by mail-wm1-f70.google.com with SMTP id t203so6066845wmt.7
        for <linux-xfs@vger.kernel.org>; Fri, 15 Nov 2019 06:21:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=XkUWNKQWKb+9fU9ETFijJ29o4KURV+f73ByE5FprsSc=;
        b=kDR/aGw1wjJbW0ycOYpukezc94AHpnRNN0PeFomUa1ruDK0k0SwukW/iVEidZV/hcH
         vrdCw+eKeV4pMk83Rc+uKzktKK03h+w1nTGG9qZnRkYY39kWrV5FMjY+bAjMFxF39dJM
         Xffav3OPrXDbvyqi7rtjlhqGqjiQ7EPTxfjSEfnsvFjdVUr3dt700ywcyuE9HvuxBEmB
         13cW50bJEmh9K54vtvm4CYZ6RkYVzBsPLCGWFtqzqTe3J39BYoyny8vRxlRKv0dQ7uQV
         tnSL87KwsUiNWnJxh3IeRClHC9Mr/CwgAOLOtjTnd3ifUKczsUWN5Vi4BfxYpPok/deg
         igGw==
X-Gm-Message-State: APjAAAWFzb8BSct1qVwKxxINXcleT2imDAG/tjTVeFPxmnikMZS5dASQ
        TYhejEK4cafQWzAeYvVJVcKACQ4CuZBjovVx7qF+Vnqg/QOGRkTRSa5ILxTrtHoOHNOpGjHhKyn
        fwnwNrZrXqvxr3kYUvhSg
X-Received: by 2002:adf:e387:: with SMTP id e7mr15340941wrm.180.1573827660479;
        Fri, 15 Nov 2019 06:21:00 -0800 (PST)
X-Google-Smtp-Source: APXvYqzsBr1EQiFWfTIWfwhkGxrmUZg3lW0wcazGSq2DqubJx4IE2SOhXDE19dL3K+JGlj3LRhUs+Q==
X-Received: by 2002:adf:e387:: with SMTP id e7mr15340795wrm.180.1573827659095;
        Fri, 15 Nov 2019 06:20:59 -0800 (PST)
Received: from orion (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id g138sm1853499wmg.11.2019.11.15.06.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 06:20:58 -0800 (PST)
Date:   Fri, 15 Nov 2019 15:20:55 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, dchinner@redhat.com
Subject: Re: [PATCH 4/4] xfs: Remove kmem_free()
Message-ID: <20191115142055.asqudktld7eblfea@orion>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, dchinner@redhat.com
References: <20191114200955.1365926-1-cmaiolino@redhat.com>
 <20191114200955.1365926-5-cmaiolino@redhat.com>
 <20191114210000.GL6219@magnolia>
MIME-Version: 1.0
In-Reply-To: <20191114210000.GL6219@magnolia>
X-MC-Unique: mxHTYRQuOYq_-4l8qgzbiw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 14, 2019 at 01:00:00PM -0800, Darrick J. Wong wrote:
> On Thu, Nov 14, 2019 at 09:09:55PM +0100, Carlos Maiolino wrote:
> > This can be replaced by direct calls to kfree() or kvfree() (whenever
> > allocation is done via kmem_alloc_io() or kmem_alloc_large().
> >=20
> > This patch has been partially scripted. I used the following sed to
> > replace all kmem_free() calls by kfree()
> >=20
> >  # find fs/xfs/ -type f -name '*.c' -o -name '*.h' | xargs sed -i \
> >    's/kmem_free/kfree/g'
>=20
> Coccinelle? ;)

/me Doesn't understand the reference but thinks Darrick is talking about
Coccinelle fancy brand :P

/me is adept to conference-wear :D

>=20
> > And manually inspected kmem_alloc_io() and kmem_alloc_large() uses to
> > use kvfree() instead.
>=20
> Why not just use kvfree everywhere?  Is there a significant performance
> penalty for the is_vmalloc_addr() check in kvfree vs. having to keep
> track of kfree vs. kvfree?

I honestly didn't see a big difference between both. Although, I didn't tes=
t
much, other than some perf measurements while exercising some paths like fo=
r
example xfs_dir_lookup().

I can't really say we will have any benefits in segmenting it by using kvfr=
ee()
only where kmem_alloc_{large, io} is used, so I just relied on the comments
above kvfree(), and well, we have an extra function call and a few extra
instructions using kvfree(). So, even though it might be 'slightly' faster,=
 this
might build up on hot paths when handling millions of kfree().

But, at the end, I'd be lying if I say I spotted any significant difference=
.


Btw, Dave mentioned in a not so far future, kmalloc() requests will be
guaranteed to be aligned, so, I wonder if we will be able to replace both
kmem_alloc_large() and kmem_alloc_io() by simple calls to kvmalloc() which =
does
the job of falling back to vmalloc() if kmalloc() fails?!

Not related to this patch itself, but to the whole talks about these helper=
s, I
just thought worth to mention.

>=20
> --D
>=20
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  fs/xfs/kmem.h                  |  5 ----
> >  fs/xfs/libxfs/xfs_attr.c       |  2 +-
> >  fs/xfs/libxfs/xfs_attr_leaf.c  |  8 +++---
> >  fs/xfs/libxfs/xfs_da_btree.c   | 10 +++----
> >  fs/xfs/libxfs/xfs_defer.c      |  4 +--
> >  fs/xfs/libxfs/xfs_dir2.c       | 18 ++++++------
> >  fs/xfs/libxfs/xfs_dir2_block.c |  4 +--
> >  fs/xfs/libxfs/xfs_dir2_sf.c    |  8 +++---
> >  fs/xfs/libxfs/xfs_iext_tree.c  |  8 +++---
> >  fs/xfs/libxfs/xfs_inode_fork.c |  8 +++---
> >  fs/xfs/libxfs/xfs_refcount.c   |  4 +--
> >  fs/xfs/scrub/agheader.c        |  2 +-
> >  fs/xfs/scrub/agheader_repair.c |  2 +-
> >  fs/xfs/scrub/attr.c            |  2 +-
> >  fs/xfs/scrub/bitmap.c          |  4 +--
> >  fs/xfs/scrub/btree.c           |  2 +-
> >  fs/xfs/scrub/refcount.c        |  8 +++---
> >  fs/xfs/scrub/scrub.c           |  2 +-
> >  fs/xfs/xfs_acl.c               |  4 +--
> >  fs/xfs/xfs_attr_inactive.c     |  2 +-
> >  fs/xfs/xfs_attr_list.c         |  4 +--
> >  fs/xfs/xfs_bmap_item.c         |  4 +--
> >  fs/xfs/xfs_buf.c               | 12 ++++----
> >  fs/xfs/xfs_buf_item.c          |  4 +--
> >  fs/xfs/xfs_dquot.c             |  2 +-
> >  fs/xfs/xfs_dquot_item.c        |  8 +++---
> >  fs/xfs/xfs_error.c             |  2 +-
> >  fs/xfs/xfs_extent_busy.c       |  2 +-
> >  fs/xfs/xfs_extfree_item.c      | 14 +++++-----
> >  fs/xfs/xfs_filestream.c        |  4 +--
> >  fs/xfs/xfs_inode.c             | 12 ++++----
> >  fs/xfs/xfs_inode_item.c        |  2 +-
> >  fs/xfs/xfs_ioctl.c             |  6 ++--
> >  fs/xfs/xfs_ioctl32.c           |  2 +-
> >  fs/xfs/xfs_iops.c              |  2 +-
> >  fs/xfs/xfs_itable.c            |  4 +--
> >  fs/xfs/xfs_iwalk.c             |  4 +--
> >  fs/xfs/xfs_log.c               | 12 ++++----
> >  fs/xfs/xfs_log_cil.c           | 16 +++++------
> >  fs/xfs/xfs_log_recover.c       | 50 +++++++++++++++++-----------------
> >  fs/xfs/xfs_mount.c             |  8 +++---
> >  fs/xfs/xfs_mru_cache.c         |  8 +++---
> >  fs/xfs/xfs_qm.c                |  6 ++--
> >  fs/xfs/xfs_refcount_item.c     |  6 ++--
> >  fs/xfs/xfs_rmap_item.c         |  6 ++--
> >  fs/xfs/xfs_rtalloc.c           |  8 +++---
> >  fs/xfs/xfs_super.c             |  2 +-
> >  fs/xfs/xfs_trans_ail.c         |  4 +--
> >  48 files changed, 158 insertions(+), 163 deletions(-)
> >=20
> > diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> > index 6143117770e9..ccdc72519339 100644
> > --- a/fs/xfs/kmem.h
> > +++ b/fs/xfs/kmem.h
> > @@ -56,11 +56,6 @@ extern void *kmem_alloc(size_t, xfs_km_flags_t);
> >  extern void *kmem_alloc_io(size_t size, int align_mask, xfs_km_flags_t=
 flags);
> >  extern void *kmem_alloc_large(size_t size, xfs_km_flags_t);
> >  extern void *kmem_realloc(const void *, size_t, xfs_km_flags_t);
> > -static inline void  kmem_free(const void *ptr)
> > -{
> > -=09kvfree(ptr);
> > -}
> > -
> > =20
> >  static inline void *
> >  kmem_zalloc(size_t size, xfs_km_flags_t flags)
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index 510ca6974604..bc8ca09e71d0 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -174,7 +174,7 @@ xfs_attr_get(
> >  =09/* on error, we have to clean up allocated value buffers */
> >  =09if (error) {
> >  =09=09if (flags & ATTR_ALLOC) {
> > -=09=09=09kmem_free(args.value);
> > +=09=09=09kvfree(args.value);
> >  =09=09=09*value =3D NULL;
> >  =09=09}
> >  =09=09return error;
> > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_lea=
f.c
> > index 85ec5945d29f..795b9b21b64d 100644
> > --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> > +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> > @@ -931,7 +931,7 @@ xfs_attr_shortform_to_leaf(
> >  =09error =3D 0;
> >  =09*leaf_bp =3D bp;
> >  out:
> > -=09kmem_free(tmpbuffer);
> > +=09kfree(tmpbuffer);
> >  =09return error;
> >  }
> > =20
> > @@ -1131,7 +1131,7 @@ xfs_attr3_leaf_to_shortform(
> >  =09error =3D 0;
> > =20
> >  out:
> > -=09kmem_free(tmpbuffer);
> > +=09kfree(tmpbuffer);
> >  =09return error;
> >  }
> > =20
> > @@ -1572,7 +1572,7 @@ xfs_attr3_leaf_compact(
> >  =09 */
> >  =09xfs_trans_log_buf(trans, bp, 0, args->geo->blksize - 1);
> > =20
> > -=09kmem_free(tmpbuffer);
> > +=09kfree(tmpbuffer);
> >  }
> > =20
> >  /*
> > @@ -2293,7 +2293,7 @@ xfs_attr3_leaf_unbalance(
> >  =09=09}
> >  =09=09memcpy(save_leaf, tmp_leaf, state->args->geo->blksize);
> >  =09=09savehdr =3D tmphdr; /* struct copy */
> > -=09=09kmem_free(tmp_leaf);
> > +=09=09kfree(tmp_leaf);
> >  =09}
> > =20
> >  =09xfs_attr3_leaf_hdr_to_disk(state->args->geo, save_leaf, &savehdr);
> > diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.=
c
> > index c5c0b73febae..7ae82d91f776 100644
> > --- a/fs/xfs/libxfs/xfs_da_btree.c
> > +++ b/fs/xfs/libxfs/xfs_da_btree.c
> > @@ -2189,7 +2189,7 @@ xfs_da_grow_inode_int(
> > =20
> >  out_free_map:
> >  =09if (mapp !=3D &map)
> > -=09=09kmem_free(mapp);
> > +=09=09kfree(mapp);
> >  =09return error;
> >  }
> > =20
> > @@ -2639,7 +2639,7 @@ xfs_dabuf_map(
> >  =09error =3D xfs_buf_map_from_irec(mp, map, nmaps, irecs, nirecs);
> >  out:
> >  =09if (irecs !=3D &irec)
> > -=09=09kmem_free(irecs);
> > +=09=09kfree(irecs);
> >  =09return error;
> >  }
> > =20
> > @@ -2686,7 +2686,7 @@ xfs_da_get_buf(
> > =20
> >  out_free:
> >  =09if (mapp !=3D &map)
> > -=09=09kmem_free(mapp);
> > +=09=09kfree(mapp);
> > =20
> >  =09return error;
> >  }
> > @@ -2735,7 +2735,7 @@ xfs_da_read_buf(
> >  =09*bpp =3D bp;
> >  out_free:
> >  =09if (mapp !=3D &map)
> > -=09=09kmem_free(mapp);
> > +=09=09kfree(mapp);
> > =20
> >  =09return error;
> >  }
> > @@ -2772,7 +2772,7 @@ xfs_da_reada_buf(
> > =20
> >  out_free:
> >  =09if (mapp !=3D &map)
> > -=09=09kmem_free(mapp);
> > +=09=09kfree(mapp);
> > =20
> >  =09return error;
> >  }
> > diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> > index 22557527cfdb..27c3d150068a 100644
> > --- a/fs/xfs/libxfs/xfs_defer.c
> > +++ b/fs/xfs/libxfs/xfs_defer.c
> > @@ -341,7 +341,7 @@ xfs_defer_cancel_list(
> >  =09=09=09ops->cancel_item(pwi);
> >  =09=09}
> >  =09=09ASSERT(dfp->dfp_count =3D=3D 0);
> > -=09=09kmem_free(dfp);
> > +=09=09kfree(dfp);
> >  =09}
> >  }
> > =20
> > @@ -433,7 +433,7 @@ xfs_defer_finish_noroll(
> >  =09=09} else {
> >  =09=09=09/* Done with the dfp, free it. */
> >  =09=09=09list_del(&dfp->dfp_list);
> > -=09=09=09kmem_free(dfp);
> > +=09=09=09kfree(dfp);
> >  =09=09}
> > =20
> >  =09=09if (ops->finish_cleanup)
> > diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> > index 624c05e77ab4..efd7cec65259 100644
> > --- a/fs/xfs/libxfs/xfs_dir2.c
> > +++ b/fs/xfs/libxfs/xfs_dir2.c
> > @@ -109,8 +109,8 @@ xfs_da_mount(
> >  =09mp->m_attr_geo =3D kmem_zalloc(sizeof(struct xfs_da_geometry),
> >  =09=09=09=09     KM_MAYFAIL);
> >  =09if (!mp->m_dir_geo || !mp->m_attr_geo) {
> > -=09=09kmem_free(mp->m_dir_geo);
> > -=09=09kmem_free(mp->m_attr_geo);
> > +=09=09kfree(mp->m_dir_geo);
> > +=09=09kfree(mp->m_attr_geo);
> >  =09=09return -ENOMEM;
> >  =09}
> > =20
> > @@ -176,8 +176,8 @@ void
> >  xfs_da_unmount(
> >  =09struct xfs_mount=09*mp)
> >  {
> > -=09kmem_free(mp->m_dir_geo);
> > -=09kmem_free(mp->m_attr_geo);
> > +=09kfree(mp->m_dir_geo);
> > +=09kfree(mp->m_attr_geo);
> >  }
> > =20
> >  /*
> > @@ -242,7 +242,7 @@ xfs_dir_init(
> >  =09args->dp =3D dp;
> >  =09args->trans =3D tp;
> >  =09error =3D xfs_dir2_sf_create(args, pdp->i_ino);
> > -=09kmem_free(args);
> > +=09kfree(args);
> >  =09return error;
> >  }
> > =20
> > @@ -311,7 +311,7 @@ xfs_dir_createname(
> >  =09=09rval =3D xfs_dir2_node_addname(args);
> > =20
> >  out_free:
> > -=09kmem_free(args);
> > +=09kfree(args);
> >  =09return rval;
> >  }
> > =20
> > @@ -417,7 +417,7 @@ xfs_dir_lookup(
> >  =09}
> >  out_free:
> >  =09xfs_iunlock(dp, lock_mode);
> > -=09kmem_free(args);
> > +=09kfree(args);
> >  =09return rval;
> >  }
> > =20
> > @@ -475,7 +475,7 @@ xfs_dir_removename(
> >  =09else
> >  =09=09rval =3D xfs_dir2_node_removename(args);
> >  out_free:
> > -=09kmem_free(args);
> > +=09kfree(args);
> >  =09return rval;
> >  }
> > =20
> > @@ -536,7 +536,7 @@ xfs_dir_replace(
> >  =09else
> >  =09=09rval =3D xfs_dir2_node_replace(args);
> >  out_free:
> > -=09kmem_free(args);
> > +=09kfree(args);
> >  =09return rval;
> >  }
> > =20
> > diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_bl=
ock.c
> > index 358151ddfa75..766f282b706a 100644
> > --- a/fs/xfs/libxfs/xfs_dir2_block.c
> > +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> > @@ -1229,7 +1229,7 @@ xfs_dir2_sf_to_block(
> >  =09=09=09sfep =3D xfs_dir2_sf_nextentry(mp, sfp, sfep);
> >  =09}
> >  =09/* Done with the temporary buffer */
> > -=09kmem_free(sfp);
> > +=09kfree(sfp);
> >  =09/*
> >  =09 * Sort the leaf entries by hash value.
> >  =09 */
> > @@ -1244,6 +1244,6 @@ xfs_dir2_sf_to_block(
> >  =09xfs_dir3_data_check(dp, bp);
> >  =09return 0;
> >  out_free:
> > -=09kmem_free(sfp);
> > +=09kfree(sfp);
> >  =09return error;
> >  }
> > diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> > index db1a82972d9e..f4de4e7b10ef 100644
> > --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> > +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> > @@ -350,7 +350,7 @@ xfs_dir2_block_to_sf(
> >  =09xfs_dir2_sf_check(args);
> >  out:
> >  =09xfs_trans_log_inode(args->trans, dp, logflags);
> > -=09kmem_free(sfp);
> > +=09kfree(sfp);
> >  =09return error;
> >  }
> > =20
> > @@ -585,7 +585,7 @@ xfs_dir2_sf_addname_hard(
> >  =09=09sfep =3D xfs_dir2_sf_nextentry(mp, sfp, sfep);
> >  =09=09memcpy(sfep, oldsfep, old_isize - nbytes);
> >  =09}
> > -=09kmem_free(buf);
> > +=09kfree(buf);
> >  =09dp->i_d.di_size =3D new_isize;
> >  =09xfs_dir2_sf_check(args);
> >  }
> > @@ -1202,7 +1202,7 @@ xfs_dir2_sf_toino4(
> >  =09/*
> >  =09 * Clean up the inode.
> >  =09 */
> > -=09kmem_free(buf);
> > +=09kfree(buf);
> >  =09dp->i_d.di_size =3D newsize;
> >  =09xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_DDATA=
);
> >  }
> > @@ -1275,7 +1275,7 @@ xfs_dir2_sf_toino8(
> >  =09/*
> >  =09 * Clean up the inode.
> >  =09 */
> > -=09kmem_free(buf);
> > +=09kfree(buf);
> >  =09dp->i_d.di_size =3D newsize;
> >  =09xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_DDATA=
);
> >  }
> > diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tre=
e.c
> > index 52451809c478..a7ba30cd81da 100644
> > --- a/fs/xfs/libxfs/xfs_iext_tree.c
> > +++ b/fs/xfs/libxfs/xfs_iext_tree.c
> > @@ -734,7 +734,7 @@ xfs_iext_remove_node(
> >  again:
> >  =09ASSERT(node->ptrs[pos]);
> >  =09ASSERT(node->ptrs[pos] =3D=3D victim);
> > -=09kmem_free(victim);
> > +=09kfree(victim);
> > =20
> >  =09nr_entries =3D xfs_iext_node_nr_entries(node, pos) - 1;
> >  =09offset =3D node->keys[0];
> > @@ -780,7 +780,7 @@ xfs_iext_remove_node(
> >  =09=09ASSERT(node =3D=3D ifp->if_u1.if_root);
> >  =09=09ifp->if_u1.if_root =3D node->ptrs[0];
> >  =09=09ifp->if_height--;
> > -=09=09kmem_free(node);
> > +=09=09kfree(node);
> >  =09}
> >  }
> > =20
> > @@ -854,7 +854,7 @@ xfs_iext_free_last_leaf(
> >  =09struct xfs_ifork=09*ifp)
> >  {
> >  =09ifp->if_height--;
> > -=09kmem_free(ifp->if_u1.if_root);
> > +=09kfree(ifp->if_u1.if_root);
> >  =09ifp->if_u1.if_root =3D NULL;
> >  }
> > =20
> > @@ -1035,7 +1035,7 @@ xfs_iext_destroy_node(
> >  =09=09}
> >  =09}
> > =20
> > -=09kmem_free(node);
> > +=09kfree(node);
> >  }
> > =20
> >  void
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_f=
ork.c
> > index ad2b9c313fd2..296677958212 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.c
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> > @@ -445,7 +445,7 @@ xfs_iroot_realloc(
> >  =09=09=09=09=09=09     (int)new_size);
> >  =09=09memcpy(np, op, new_max * (uint)sizeof(xfs_fsblock_t));
> >  =09}
> > -=09kmem_free(ifp->if_broot);
> > +=09kfree(ifp->if_broot);
> >  =09ifp->if_broot =3D new_broot;
> >  =09ifp->if_broot_bytes =3D (int)new_size;
> >  =09if (ifp->if_broot)
> > @@ -486,7 +486,7 @@ xfs_idata_realloc(
> >  =09=09return;
> > =20
> >  =09if (new_size =3D=3D 0) {
> > -=09=09kmem_free(ifp->if_u1.if_data);
> > +=09=09kfree(ifp->if_u1.if_data);
> >  =09=09ifp->if_u1.if_data =3D NULL;
> >  =09=09ifp->if_bytes =3D 0;
> >  =09=09return;
> > @@ -511,7 +511,7 @@ xfs_idestroy_fork(
> > =20
> >  =09ifp =3D XFS_IFORK_PTR(ip, whichfork);
> >  =09if (ifp->if_broot !=3D NULL) {
> > -=09=09kmem_free(ifp->if_broot);
> > +=09=09kfree(ifp->if_broot);
> >  =09=09ifp->if_broot =3D NULL;
> >  =09}
> > =20
> > @@ -523,7 +523,7 @@ xfs_idestroy_fork(
> >  =09 */
> >  =09if (XFS_IFORK_FORMAT(ip, whichfork) =3D=3D XFS_DINODE_FMT_LOCAL) {
> >  =09=09if (ifp->if_u1.if_data !=3D NULL) {
> > -=09=09=09kmem_free(ifp->if_u1.if_data);
> > +=09=09=09kfree(ifp->if_u1.if_data);
> >  =09=09=09ifp->if_u1.if_data =3D NULL;
> >  =09=09}
> >  =09} else if ((ifp->if_flags & XFS_IFEXTENTS) && ifp->if_height) {
> > diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.=
c
> > index 78236bd6c64f..07894c53e753 100644
> > --- a/fs/xfs/libxfs/xfs_refcount.c
> > +++ b/fs/xfs/libxfs/xfs_refcount.c
> > @@ -1684,7 +1684,7 @@ xfs_refcount_recover_cow_leftovers(
> >  =09=09=09goto out_free;
> > =20
> >  =09=09list_del(&rr->rr_list);
> > -=09=09kmem_free(rr);
> > +=09=09kfree(rr);
> >  =09}
> > =20
> >  =09return error;
> > @@ -1694,7 +1694,7 @@ xfs_refcount_recover_cow_leftovers(
> >  =09/* Free the leftover list */
> >  =09list_for_each_entry_safe(rr, n, &debris, rr_list) {
> >  =09=09list_del(&rr->rr_list);
> > -=09=09kmem_free(rr);
> > +=09=09kfree(rr);
> >  =09}
> >  =09return error;
> >  }
> > diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> > index ba0f747c82e8..6f7126f6d25c 100644
> > --- a/fs/xfs/scrub/agheader.c
> > +++ b/fs/xfs/scrub/agheader.c
> > @@ -753,7 +753,7 @@ xchk_agfl(
> >  =09}
> > =20
> >  out_free:
> > -=09kmem_free(sai.entries);
> > +=09kfree(sai.entries);
> >  out:
> >  =09return error;
> >  }
> > diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_rep=
air.c
> > index 7a1a38b636a9..15fabf020d1b 100644
> > --- a/fs/xfs/scrub/agheader_repair.c
> > +++ b/fs/xfs/scrub/agheader_repair.c
> > @@ -624,7 +624,7 @@ xrep_agfl_init_header(
> >  =09=09if (br->len)
> >  =09=09=09break;
> >  =09=09list_del(&br->list);
> > -=09=09kmem_free(br);
> > +=09=09kfree(br);
> >  =09}
> > =20
> >  =09/* Write new AGFL to disk. */
> > diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> > index d9f0dd444b80..7a2a240febc1 100644
> > --- a/fs/xfs/scrub/attr.c
> > +++ b/fs/xfs/scrub/attr.c
> > @@ -49,7 +49,7 @@ xchk_setup_xattr_buf(
> >  =09if (ab) {
> >  =09=09if (sz <=3D ab->sz)
> >  =09=09=09return 0;
> > -=09=09kmem_free(ab);
> > +=09=09kvfree(ab);
> >  =09=09sc->buf =3D NULL;
> >  =09}
> > =20
> > diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
> > index 18a684e18a69..cabde1c4c235 100644
> > --- a/fs/xfs/scrub/bitmap.c
> > +++ b/fs/xfs/scrub/bitmap.c
> > @@ -47,7 +47,7 @@ xfs_bitmap_destroy(
> > =20
> >  =09for_each_xfs_bitmap_extent(bmr, n, bitmap) {
> >  =09=09list_del(&bmr->list);
> > -=09=09kmem_free(bmr);
> > +=09=09kfree(bmr);
> >  =09}
> >  }
> > =20
> > @@ -174,7 +174,7 @@ xfs_bitmap_disunion(
> >  =09=09=09/* Total overlap, just delete ex. */
> >  =09=09=09lp =3D lp->next;
> >  =09=09=09list_del(&br->list);
> > -=09=09=09kmem_free(br);
> > +=09=09=09kfree(br);
> >  =09=09=09break;
> >  =09=09case 0:
> >  =09=09=09/*
> > diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> > index f52a7b8256f9..bed40b605076 100644
> > --- a/fs/xfs/scrub/btree.c
> > +++ b/fs/xfs/scrub/btree.c
> > @@ -698,7 +698,7 @@ xchk_btree(
> >  =09=09=09error =3D xchk_btree_check_block_owner(&bs,
> >  =09=09=09=09=09co->level, co->daddr);
> >  =09=09list_del(&co->list);
> > -=09=09kmem_free(co);
> > +=09=09kfree(co);
> >  =09}
> > =20
> >  =09return error;
> > diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
> > index 0cab11a5d390..985724e81ebf 100644
> > --- a/fs/xfs/scrub/refcount.c
> > +++ b/fs/xfs/scrub/refcount.c
> > @@ -215,7 +215,7 @@ xchk_refcountbt_process_rmap_fragments(
> >  =09=09=09=09continue;
> >  =09=09=09}
> >  =09=09=09list_del(&frag->list);
> > -=09=09=09kmem_free(frag);
> > +=09=09=09kfree(frag);
> >  =09=09=09nr++;
> >  =09=09}
> > =20
> > @@ -257,11 +257,11 @@ xchk_refcountbt_process_rmap_fragments(
> >  =09/* Delete fragments and work list. */
> >  =09list_for_each_entry_safe(frag, n, &worklist, list) {
> >  =09=09list_del(&frag->list);
> > -=09=09kmem_free(frag);
> > +=09=09kfree(frag);
> >  =09}
> >  =09list_for_each_entry_safe(frag, n, &refchk->fragments, list) {
> >  =09=09list_del(&frag->list);
> > -=09=09kmem_free(frag);
> > +=09=09kfree(frag);
> >  =09}
> >  }
> > =20
> > @@ -308,7 +308,7 @@ xchk_refcountbt_xref_rmap(
> >  out_free:
> >  =09list_for_each_entry_safe(frag, n, &refchk.fragments, list) {
> >  =09=09list_del(&frag->list);
> > -=09=09kmem_free(frag);
> > +=09=09kfree(frag);
> >  =09}
> >  }
> > =20
> > diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> > index f1775bb19313..7c63cdf13946 100644
> > --- a/fs/xfs/scrub/scrub.c
> > +++ b/fs/xfs/scrub/scrub.c
> > @@ -175,7 +175,7 @@ xchk_teardown(
> >  =09=09sc->flags &=3D ~XCHK_HAS_QUOTAOFFLOCK;
> >  =09}
> >  =09if (sc->buf) {
> > -=09=09kmem_free(sc->buf);
> > +=09=09kvfree(sc->buf);
> >  =09=09sc->buf =3D NULL;
> >  =09}
> >  =09return error;
> > diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> > index 91693fce34a8..81b2c989242e 100644
> > --- a/fs/xfs/xfs_acl.c
> > +++ b/fs/xfs/xfs_acl.c
> > @@ -157,7 +157,7 @@ xfs_get_acl(struct inode *inode, int type)
> >  =09} else  {
> >  =09=09acl =3D xfs_acl_from_disk(ip->i_mount, xfs_acl, len,
> >  =09=09=09=09=09XFS_ACL_MAX_ENTRIES(ip->i_mount));
> > -=09=09kmem_free(xfs_acl);
> > +=09=09kvfree(xfs_acl);
> >  =09}
> >  =09return acl;
> >  }
> > @@ -199,7 +199,7 @@ __xfs_set_acl(struct inode *inode, struct posix_acl=
 *acl, int type)
> >  =09=09error =3D xfs_attr_set(ip, ea_name, (unsigned char *)xfs_acl,
> >  =09=09=09=09len, ATTR_ROOT);
> > =20
> > -=09=09kmem_free(xfs_acl);
> > +=09=09kvfree(xfs_acl);
> >  =09} else {
> >  =09=09/*
> >  =09=09 * A NULL ACL argument means we want to remove the ACL.
> > diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> > index a78c501f6fb1..8351b3b611ac 100644
> > --- a/fs/xfs/xfs_attr_inactive.c
> > +++ b/fs/xfs/xfs_attr_inactive.c
> > @@ -181,7 +181,7 @@ xfs_attr3_leaf_inactive(
> >  =09=09=09error =3D tmp;=09/* save only the 1st errno */
> >  =09}
> > =20
> > -=09kmem_free(list);
> > +=09kfree(list);
> >  =09return error;
> >  }
> > =20
> > diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> > index 0ec6606149a2..e1d1c4eb9e69 100644
> > --- a/fs/xfs/xfs_attr_list.c
> > +++ b/fs/xfs/xfs_attr_list.c
> > @@ -131,7 +131,7 @@ xfs_attr_shortform_list(
> >  =09=09=09=09=09     XFS_ERRLEVEL_LOW,
> >  =09=09=09=09=09     context->dp->i_mount, sfe,
> >  =09=09=09=09=09     sizeof(*sfe));
> > -=09=09=09kmem_free(sbuf);
> > +=09=09=09kfree(sbuf);
> >  =09=09=09return -EFSCORRUPTED;
> >  =09=09}
> > =20
> > @@ -195,7 +195,7 @@ xfs_attr_shortform_list(
> >  =09=09cursor->offset++;
> >  =09}
> >  out:
> > -=09kmem_free(sbuf);
> > +=09kfree(sbuf);
> >  =09return error;
> >  }
> > =20
> > diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> > index ee6f4229cebc..a89e10519f05 100644
> > --- a/fs/xfs/xfs_bmap_item.c
> > +++ b/fs/xfs/xfs_bmap_item.c
> > @@ -391,7 +391,7 @@ xfs_bmap_update_finish_item(
> >  =09=09bmap->bi_bmap.br_blockcount =3D count;
> >  =09=09return -EAGAIN;
> >  =09}
> > -=09kmem_free(bmap);
> > +=09kfree(bmap);
> >  =09return error;
> >  }
> > =20
> > @@ -411,7 +411,7 @@ xfs_bmap_update_cancel_item(
> >  =09struct xfs_bmap_intent=09=09*bmap;
> > =20
> >  =09bmap =3D container_of(item, struct xfs_bmap_intent, bi_list);
> > -=09kmem_free(bmap);
> > +=09kfree(bmap);
> >  }
> > =20
> >  const struct xfs_defer_op_type xfs_bmap_update_defer_type =3D {
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index a0229c368e78..80ef2fc8bb77 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -193,7 +193,7 @@ xfs_buf_free_maps(
> >  =09struct xfs_buf=09*bp)
> >  {
> >  =09if (bp->b_maps !=3D &bp->__b_map) {
> > -=09=09kmem_free(bp->b_maps);
> > +=09=09kfree(bp->b_maps);
> >  =09=09bp->b_maps =3D NULL;
> >  =09}
> >  }
> > @@ -292,7 +292,7 @@ _xfs_buf_free_pages(
> >  =09xfs_buf_t=09*bp)
> >  {
> >  =09if (bp->b_pages !=3D bp->b_page_array) {
> > -=09=09kmem_free(bp->b_pages);
> > +=09=09kfree(bp->b_pages);
> >  =09=09bp->b_pages =3D NULL;
> >  =09}
> >  }
> > @@ -325,7 +325,7 @@ xfs_buf_free(
> >  =09=09=09__free_page(page);
> >  =09=09}
> >  =09} else if (bp->b_flags & _XBF_KMEM)
> > -=09=09kmem_free(bp->b_addr);
> > +=09=09kvfree(bp->b_addr);
> >  =09_xfs_buf_free_pages(bp);
> >  =09xfs_buf_free_maps(bp);
> >  =09kmem_cache_free(xfs_buf_zone, bp);
> > @@ -373,7 +373,7 @@ xfs_buf_allocate_memory(
> >  =09=09if (((unsigned long)(bp->b_addr + size - 1) & PAGE_MASK) !=3D
> >  =09=09    ((unsigned long)bp->b_addr & PAGE_MASK)) {
> >  =09=09=09/* b_addr spans two pages - use alloc_page instead */
> > -=09=09=09kmem_free(bp->b_addr);
> > +=09=09=09kvfree(bp->b_addr);
> >  =09=09=09bp->b_addr =3D NULL;
> >  =09=09=09goto use_alloc_page;
> >  =09=09}
> > @@ -1702,7 +1702,7 @@ xfs_free_buftarg(
> > =20
> >  =09xfs_blkdev_issue_flush(btp);
> > =20
> > -=09kmem_free(btp);
> > +=09kfree(btp);
> >  }
> > =20
> >  int
> > @@ -1778,7 +1778,7 @@ xfs_alloc_buftarg(
> >  error_lru:
> >  =09list_lru_destroy(&btp->bt_lru);
> >  error_free:
> > -=09kmem_free(btp);
> > +=09kfree(btp);
> >  =09return NULL;
> >  }
> > =20
> > diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> > index 3458a1264a3f..8dc3330f1797 100644
> > --- a/fs/xfs/xfs_buf_item.c
> > +++ b/fs/xfs/xfs_buf_item.c
> > @@ -713,7 +713,7 @@ xfs_buf_item_free_format(
> >  =09struct xfs_buf_log_item=09*bip)
> >  {
> >  =09if (bip->bli_formats !=3D &bip->__bli_format) {
> > -=09=09kmem_free(bip->bli_formats);
> > +=09=09kfree(bip->bli_formats);
> >  =09=09bip->bli_formats =3D NULL;
> >  =09}
> >  }
> > @@ -938,7 +938,7 @@ xfs_buf_item_free(
> >  =09struct xfs_buf_log_item=09*bip)
> >  {
> >  =09xfs_buf_item_free_format(bip);
> > -=09kmem_free(bip->bli_item.li_lv_shadow);
> > +=09kfree(bip->bli_item.li_lv_shadow);
> >  =09kmem_cache_free(xfs_buf_item_zone, bip);
> >  }
> > =20
> > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > index 153815bf18fc..a073281c3bd7 100644
> > --- a/fs/xfs/xfs_dquot.c
> > +++ b/fs/xfs/xfs_dquot.c
> > @@ -52,7 +52,7 @@ xfs_qm_dqdestroy(
> >  {
> >  =09ASSERT(list_empty(&dqp->q_lru));
> > =20
> > -=09kmem_free(dqp->q_logitem.qli_item.li_lv_shadow);
> > +=09kfree(dqp->q_logitem.qli_item.li_lv_shadow);
> >  =09mutex_destroy(&dqp->q_qlock);
> > =20
> >  =09XFS_STATS_DEC(dqp->q_mount, xs_qm_dquot);
> > diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> > index d60647d7197b..1b5e68ccef60 100644
> > --- a/fs/xfs/xfs_dquot_item.c
> > +++ b/fs/xfs/xfs_dquot_item.c
> > @@ -316,10 +316,10 @@ xfs_qm_qoffend_logitem_committed(
> >  =09spin_lock(&ailp->ail_lock);
> >  =09xfs_trans_ail_delete(ailp, &qfs->qql_item, SHUTDOWN_LOG_IO_ERROR);
> > =20
> > -=09kmem_free(qfs->qql_item.li_lv_shadow);
> > -=09kmem_free(lip->li_lv_shadow);
> > -=09kmem_free(qfs);
> > -=09kmem_free(qfe);
> > +=09kfree(qfs->qql_item.li_lv_shadow);
> > +=09kfree(lip->li_lv_shadow);
> > +=09kfree(qfs);
> > +=09kfree(qfe);
> >  =09return (xfs_lsn_t)-1;
> >  }
> > =20
> > diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> > index 51dd1f43d12f..4c0883380d7c 100644
> > --- a/fs/xfs/xfs_error.c
> > +++ b/fs/xfs/xfs_error.c
> > @@ -226,7 +226,7 @@ xfs_errortag_del(
> >  =09struct xfs_mount=09*mp)
> >  {
> >  =09xfs_sysfs_del(&mp->m_errortag_kobj);
> > -=09kmem_free(mp->m_errortag);
> > +=09kfree(mp->m_errortag);
> >  }
> > =20
> >  bool
> > diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> > index 3991e59cfd18..9f0b99c7b34a 100644
> > --- a/fs/xfs/xfs_extent_busy.c
> > +++ b/fs/xfs/xfs_extent_busy.c
> > @@ -532,7 +532,7 @@ xfs_extent_busy_clear_one(
> >  =09}
> > =20
> >  =09list_del_init(&busyp->list);
> > -=09kmem_free(busyp);
> > +=09kfree(busyp);
> >  }
> > =20
> >  static void
> > diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> > index 6ea847f6e298..29b3a90aee91 100644
> > --- a/fs/xfs/xfs_extfree_item.c
> > +++ b/fs/xfs/xfs_extfree_item.c
> > @@ -35,9 +35,9 @@ void
> >  xfs_efi_item_free(
> >  =09struct xfs_efi_log_item=09*efip)
> >  {
> > -=09kmem_free(efip->efi_item.li_lv_shadow);
> > +=09kfree(efip->efi_item.li_lv_shadow);
> >  =09if (efip->efi_format.efi_nextents > XFS_EFI_MAX_FAST_EXTENTS)
> > -=09=09kmem_free(efip);
> > +=09=09kfree(efip);
> >  =09else
> >  =09=09kmem_cache_free(xfs_efi_zone, efip);
> >  }
> > @@ -240,9 +240,9 @@ static inline struct xfs_efd_log_item *EFD_ITEM(str=
uct xfs_log_item *lip)
> >  STATIC void
> >  xfs_efd_item_free(struct xfs_efd_log_item *efdp)
> >  {
> > -=09kmem_free(efdp->efd_item.li_lv_shadow);
> > +=09kfree(efdp->efd_item.li_lv_shadow);
> >  =09if (efdp->efd_format.efd_nextents > XFS_EFD_MAX_FAST_EXTENTS)
> > -=09=09kmem_free(efdp);
> > +=09=09kfree(efdp);
> >  =09else
> >  =09=09kmem_cache_free(xfs_efd_zone, efdp);
> >  }
> > @@ -488,7 +488,7 @@ xfs_extent_free_finish_item(
> >  =09=09=09free->xefi_startblock,
> >  =09=09=09free->xefi_blockcount,
> >  =09=09=09&free->xefi_oinfo, free->xefi_skip_discard);
> > -=09kmem_free(free);
> > +=09kfree(free);
> >  =09return error;
> >  }
> > =20
> > @@ -508,7 +508,7 @@ xfs_extent_free_cancel_item(
> >  =09struct xfs_extent_free_item=09*free;
> > =20
> >  =09free =3D container_of(item, struct xfs_extent_free_item, xefi_list)=
;
> > -=09kmem_free(free);
> > +=09kfree(free);
> >  }
> > =20
> >  const struct xfs_defer_op_type xfs_extent_free_defer_type =3D {
> > @@ -572,7 +572,7 @@ xfs_agfl_free_finish_item(
> >  =09extp->ext_len =3D free->xefi_blockcount;
> >  =09efdp->efd_next_extent++;
> > =20
> > -=09kmem_free(free);
> > +=09kfree(free);
> >  =09return error;
> >  }
> > =20
> > diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> > index 2ae356775f63..9778e4e69e07 100644
> > --- a/fs/xfs/xfs_filestream.c
> > +++ b/fs/xfs/xfs_filestream.c
> > @@ -118,7 +118,7 @@ xfs_fstrm_free_func(
> >  =09xfs_filestream_put_ag(mp, item->ag);
> >  =09trace_xfs_filestream_free(mp, mru->key, item->ag);
> > =20
> > -=09kmem_free(item);
> > +=09kfree(item);
> >  }
> > =20
> >  /*
> > @@ -263,7 +263,7 @@ xfs_filestream_pick_ag(
> >  =09return 0;
> > =20
> >  out_free_item:
> > -=09kmem_free(item);
> > +=09kfree(item);
> >  out_put_ag:
> >  =09xfs_filestream_put_ag(mp, *agp);
> >  =09return err;
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index a92d4521748d..e1121ed7cbb5 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -708,7 +708,7 @@ xfs_lookup(
> > =20
> >  out_free_name:
> >  =09if (ci_name)
> > -=09=09kmem_free(ci_name->name);
> > +=09=09kfree(ci_name->name);
> >  out_unlock:
> >  =09*ipp =3D NULL;
> >  =09return error;
> > @@ -2001,7 +2001,7 @@ xfs_iunlink_insert_backref(
> >  =09 */
> >  =09if (error) {
> >  =09=09WARN(error !=3D -ENOMEM, "iunlink cache insert error %d", error)=
;
> > -=09=09kmem_free(iu);
> > +=09=09kfree(iu);
> >  =09}
> >  =09/*
> >  =09 * Absorb any runtime errors that aren't a result of corruption bec=
ause
> > @@ -2066,7 +2066,7 @@ xfs_iunlink_change_backref(
> > =20
> >  =09/* If there is no new next entry just free our item and return. */
> >  =09if (next_unlinked =3D=3D NULLAGINO) {
> > -=09=09kmem_free(iu);
> > +=09=09kfree(iu);
> >  =09=09return 0;
> >  =09}
> > =20
> > @@ -2094,7 +2094,7 @@ xfs_iunlink_free_item(
> >  =09bool=09=09=09*freed_anything =3D arg;
> > =20
> >  =09*freed_anything =3D true;
> > -=09kmem_free(iu);
> > +=09kfree(iu);
> >  }
> > =20
> >  void
> > @@ -3598,7 +3598,7 @@ xfs_iflush_cluster(
> > =20
> >  out_free:
> >  =09rcu_read_unlock();
> > -=09kmem_free(cilist);
> > +=09kfree(cilist);
> >  out_put:
> >  =09xfs_perag_put(pag);
> >  =09return 0;
> > @@ -3629,7 +3629,7 @@ xfs_iflush_cluster(
> > =20
> >  =09/* abort the corrupt inode, as it was not attached to the buffer */
> >  =09xfs_iflush_abort(cip, false);
> > -=09kmem_free(cilist);
> > +=09kfree(cilist);
> >  =09xfs_perag_put(pag);
> >  =09return -EFSCORRUPTED;
> >  }
> > diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> > index 3a62976291a1..c8461a5515f1 100644
> > --- a/fs/xfs/xfs_inode_item.c
> > +++ b/fs/xfs/xfs_inode_item.c
> > @@ -666,7 +666,7 @@ void
> >  xfs_inode_item_destroy(
> >  =09xfs_inode_t=09*ip)
> >  {
> > -=09kmem_free(ip->i_itemp->ili_item.li_lv_shadow);
> > +=09kfree(ip->i_itemp->ili_item.li_lv_shadow);
> >  =09kmem_cache_free(xfs_ili_zone, ip->i_itemp);
> >  }
> > =20
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 364961c23cd0..f86dde7c9ea6 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -417,7 +417,7 @@ xfs_attrlist_by_handle(
> >  =09=09error =3D -EFAULT;
> > =20
> >  out_kfree:
> > -=09kmem_free(kbuf);
> > +=09kvfree(kbuf);
> >  out_dput:
> >  =09dput(dentry);
> >  =09return error;
> > @@ -448,7 +448,7 @@ xfs_attrmulti_attr_get(
> >  =09=09error =3D -EFAULT;
> > =20
> >  out_kfree:
> > -=09kmem_free(kbuf);
> > +=09kvfree(kbuf);
> >  =09return error;
> >  }
> > =20
> > @@ -1777,7 +1777,7 @@ xfs_ioc_getbmap(
> > =20
> >  =09error =3D 0;
> >  out_free_buf:
> > -=09kmem_free(buf);
> > +=09kvfree(buf);
> >  =09return error;
> >  }
> > =20
> > diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> > index 3c0d518e1039..de472fcd2f67 100644
> > --- a/fs/xfs/xfs_ioctl32.c
> > +++ b/fs/xfs/xfs_ioctl32.c
> > @@ -400,7 +400,7 @@ xfs_compat_attrlist_by_handle(
> >  =09=09error =3D -EFAULT;
> > =20
> >  out_kfree:
> > -=09kmem_free(kbuf);
> > +=09kvfree(kbuf);
> >  out_dput:
> >  =09dput(dentry);
> >  =09return error;
> > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > index 57e6e44123a9..e532db27d0dc 100644
> > --- a/fs/xfs/xfs_iops.c
> > +++ b/fs/xfs/xfs_iops.c
> > @@ -303,7 +303,7 @@ xfs_vn_ci_lookup(
> >  =09dname.name =3D ci_name.name;
> >  =09dname.len =3D ci_name.len;
> >  =09dentry =3D d_add_ci(dentry, VFS_I(ip), &dname);
> > -=09kmem_free(ci_name.name);
> > +=09kfree(ci_name.name);
> >  =09return dentry;
> >  }
> > =20
> > diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> > index 884950adbd16..36bf47f11117 100644
> > --- a/fs/xfs/xfs_itable.c
> > +++ b/fs/xfs/xfs_itable.c
> > @@ -175,7 +175,7 @@ xfs_bulkstat_one(
> > =20
> >  =09error =3D xfs_bulkstat_one_int(breq->mp, NULL, breq->startino, &bc)=
;
> > =20
> > -=09kmem_free(bc.buf);
> > +=09kfree(bc.buf);
> > =20
> >  =09/*
> >  =09 * If we reported one inode to userspace then we abort because we h=
it
> > @@ -250,7 +250,7 @@ xfs_bulkstat(
> >  =09error =3D xfs_iwalk(breq->mp, NULL, breq->startino, breq->flags,
> >  =09=09=09xfs_bulkstat_iwalk, breq->icount, &bc);
> > =20
> > -=09kmem_free(bc.buf);
> > +=09kfree(bc.buf);
> > =20
> >  =09/*
> >  =09 * We found some inodes, so clear the error status and return them.
> > diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
> > index aa375cf53021..67e98f9023d2 100644
> > --- a/fs/xfs/xfs_iwalk.c
> > +++ b/fs/xfs/xfs_iwalk.c
> > @@ -164,7 +164,7 @@ STATIC void
> >  xfs_iwalk_free(
> >  =09struct xfs_iwalk_ag=09*iwag)
> >  {
> > -=09kmem_free(iwag->recs);
> > +=09kfree(iwag->recs);
> >  =09iwag->recs =3D NULL;
> >  }
> > =20
> > @@ -578,7 +578,7 @@ xfs_iwalk_ag_work(
> >  =09error =3D xfs_iwalk_ag(iwag);
> >  =09xfs_iwalk_free(iwag);
> >  out:
> > -=09kmem_free(iwag);
> > +=09kfree(iwag);
> >  =09return error;
> >  }
> > =20
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index 6a147c63a8a6..e8349b0d7c51 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -1540,11 +1540,11 @@ xlog_alloc_log(
> >  out_free_iclog:
> >  =09for (iclog =3D log->l_iclog; iclog; iclog =3D prev_iclog) {
> >  =09=09prev_iclog =3D iclog->ic_next;
> > -=09=09kmem_free(iclog->ic_data);
> > -=09=09kmem_free(iclog);
> > +=09=09kvfree(iclog->ic_data);
> > +=09=09kfree(iclog);
> >  =09}
> >  out_free_log:
> > -=09kmem_free(log);
> > +=09kfree(log);
> >  out:
> >  =09return ERR_PTR(error);
> >  }=09/* xlog_alloc_log */
> > @@ -2001,14 +2001,14 @@ xlog_dealloc_log(
> >  =09iclog =3D log->l_iclog;
> >  =09for (i =3D 0; i < log->l_iclog_bufs; i++) {
> >  =09=09next_iclog =3D iclog->ic_next;
> > -=09=09kmem_free(iclog->ic_data);
> > -=09=09kmem_free(iclog);
> > +=09=09kvfree(iclog->ic_data);
> > +=09=09kfree(iclog);
> >  =09=09iclog =3D next_iclog;
> >  =09}
> > =20
> >  =09log->l_mp->m_log =3D NULL;
> >  =09destroy_workqueue(log->l_ioend_workqueue);
> > -=09kmem_free(log);
> > +=09kfree(log);
> >  }=09/* xlog_dealloc_log */
> > =20
> >  /*
> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index 48435cf2aa16..23d70836a2b7 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -184,7 +184,7 @@ xlog_cil_alloc_shadow_bufs(
> >  =09=09=09 * the buffer, only the log vector header and the iovec
> >  =09=09=09 * storage.
> >  =09=09=09 */
> > -=09=09=09kmem_free(lip->li_lv_shadow);
> > +=09=09=09kfree(lip->li_lv_shadow);
> > =20
> >  =09=09=09lv =3D kmem_alloc_large(buf_size, KM_NOFS);
> >  =09=09=09memset(lv, 0, xlog_cil_iovec_space(niovecs));
> > @@ -492,7 +492,7 @@ xlog_cil_free_logvec(
> > =20
> >  =09for (lv =3D log_vector; lv; ) {
> >  =09=09struct xfs_log_vec *next =3D lv->lv_next;
> > -=09=09kmem_free(lv);
> > +=09=09kvfree(lv);
> >  =09=09lv =3D next;
> >  =09}
> >  }
> > @@ -506,7 +506,7 @@ xlog_discard_endio_work(
> >  =09struct xfs_mount=09*mp =3D ctx->cil->xc_log->l_mp;
> > =20
> >  =09xfs_extent_busy_clear(mp, &ctx->busy_extents, false);
> > -=09kmem_free(ctx);
> > +=09kfree(ctx);
> >  }
> > =20
> >  /*
> > @@ -608,7 +608,7 @@ xlog_cil_committed(
> >  =09if (!list_empty(&ctx->busy_extents))
> >  =09=09xlog_discard_busy_extents(mp, ctx);
> >  =09else
> > -=09=09kmem_free(ctx);
> > +=09=09kfree(ctx);
> >  }
> > =20
> >  void
> > @@ -872,7 +872,7 @@ xlog_cil_push(
> >  out_skip:
> >  =09up_write(&cil->xc_ctx_lock);
> >  =09xfs_log_ticket_put(new_ctx->ticket);
> > -=09kmem_free(new_ctx);
> > +=09kfree(new_ctx);
> >  =09return 0;
> > =20
> >  out_abort_free_ticket:
> > @@ -1185,7 +1185,7 @@ xlog_cil_init(
> > =20
> >  =09ctx =3D kmem_zalloc(sizeof(*ctx), KM_MAYFAIL);
> >  =09if (!ctx) {
> > -=09=09kmem_free(cil);
> > +=09=09kfree(cil);
> >  =09=09return -ENOMEM;
> >  =09}
> > =20
> > @@ -1216,10 +1216,10 @@ xlog_cil_destroy(
> >  =09if (log->l_cilp->xc_ctx) {
> >  =09=09if (log->l_cilp->xc_ctx->ticket)
> >  =09=09=09xfs_log_ticket_put(log->l_cilp->xc_ctx->ticket);
> > -=09=09kmem_free(log->l_cilp->xc_ctx);
> > +=09=09kfree(log->l_cilp->xc_ctx);
> >  =09}
> > =20
> >  =09ASSERT(list_empty(&log->l_cilp->xc_cil));
> > -=09kmem_free(log->l_cilp);
> > +=09kfree(log->l_cilp);
> >  }
> > =20
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 02f2147952b3..4167e1326f62 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -418,7 +418,7 @@ xlog_find_verify_cycle(
> >  =09*new_blk =3D -1;
> > =20
> >  out:
> > -=09kmem_free(buffer);
> > +=09kvfree(buffer);
> >  =09return error;
> >  }
> > =20
> > @@ -529,7 +529,7 @@ xlog_find_verify_log_record(
> >  =09=09*last_blk =3D i;
> > =20
> >  out:
> > -=09kmem_free(buffer);
> > +=09kvfree(buffer);
> >  =09return error;
> >  }
> > =20
> > @@ -783,7 +783,7 @@ xlog_find_head(
> >  =09=09=09goto out_free_buffer;
> >  =09}
> > =20
> > -=09kmem_free(buffer);
> > +=09kvfree(buffer);
> >  =09if (head_blk =3D=3D log_bbnum)
> >  =09=09*return_head_blk =3D 0;
> >  =09else
> > @@ -797,7 +797,7 @@ xlog_find_head(
> >  =09return 0;
> > =20
> >  out_free_buffer:
> > -=09kmem_free(buffer);
> > +=09kvfree(buffer);
> >  =09if (error)
> >  =09=09xfs_warn(log->l_mp, "failed to find log head");
> >  =09return error;
> > @@ -1051,7 +1051,7 @@ xlog_verify_tail(
> >  =09=09"Tail block (0x%llx) overwrite detected. Updated to 0x%llx",
> >  =09=09=09 orig_tail, *tail_blk);
> >  out:
> > -=09kmem_free(buffer);
> > +=09kvfree(buffer);
> >  =09return error;
> >  }
> > =20
> > @@ -1098,7 +1098,7 @@ xlog_verify_head(
> >  =09error =3D xlog_rseek_logrec_hdr(log, *head_blk, *tail_blk,
> >  =09=09=09=09      XLOG_MAX_ICLOGS, tmp_buffer,
> >  =09=09=09=09      &tmp_rhead_blk, &tmp_rhead, &tmp_wrapped);
> > -=09kmem_free(tmp_buffer);
> > +=09kvfree(tmp_buffer);
> >  =09if (error < 0)
> >  =09=09return error;
> > =20
> > @@ -1431,7 +1431,7 @@ xlog_find_tail(
> >  =09=09error =3D xlog_clear_stale_blocks(log, tail_lsn);
> > =20
> >  done:
> > -=09kmem_free(buffer);
> > +=09kvfree(buffer);
> > =20
> >  =09if (error)
> >  =09=09xfs_warn(log->l_mp, "failed to locate log tail");
> > @@ -1479,7 +1479,7 @@ xlog_find_zeroed(
> >  =09first_cycle =3D xlog_get_cycle(offset);
> >  =09if (first_cycle =3D=3D 0) {=09=09/* completely zeroed log */
> >  =09=09*blk_no =3D 0;
> > -=09=09kmem_free(buffer);
> > +=09=09kvfree(buffer);
> >  =09=09return 1;
> >  =09}
> > =20
> > @@ -1490,7 +1490,7 @@ xlog_find_zeroed(
> > =20
> >  =09last_cycle =3D xlog_get_cycle(offset);
> >  =09if (last_cycle !=3D 0) {=09=09/* log completely written to */
> > -=09=09kmem_free(buffer);
> > +=09=09kvfree(buffer);
> >  =09=09return 0;
> >  =09}
> > =20
> > @@ -1537,7 +1537,7 @@ xlog_find_zeroed(
> > =20
> >  =09*blk_no =3D last_blk;
> >  out_free_buffer:
> > -=09kmem_free(buffer);
> > +=09kvfree(buffer);
> >  =09if (error)
> >  =09=09return error;
> >  =09return 1;
> > @@ -1649,7 +1649,7 @@ xlog_write_log_records(
> >  =09}
> > =20
> >  out_free_buffer:
> > -=09kmem_free(buffer);
> > +=09kvfree(buffer);
> >  =09return error;
> >  }
> > =20
> > @@ -2039,7 +2039,7 @@ xlog_check_buffer_cancelled(
> >  =09if (flags & XFS_BLF_CANCEL) {
> >  =09=09if (--bcp->bc_refcount =3D=3D 0) {
> >  =09=09=09list_del(&bcp->bc_list);
> > -=09=09=09kmem_free(bcp);
> > +=09=09=09kfree(bcp);
> >  =09=09}
> >  =09}
> >  =09return 1;
> > @@ -3188,7 +3188,7 @@ xlog_recover_inode_pass2(
> >  =09xfs_buf_relse(bp);
> >  error:
> >  =09if (need_free)
> > -=09=09kmem_free(in_f);
> > +=09=09kfree(in_f);
> >  =09return error;
> >  }
> > =20
> > @@ -4292,7 +4292,7 @@ xlog_recover_add_to_trans(
> >  =09=09"bad number of regions (%d) in inode log format",
> >  =09=09=09=09  in_f->ilf_size);
> >  =09=09=09ASSERT(0);
> > -=09=09=09kmem_free(ptr);
> > +=09=09=09kfree(ptr);
> >  =09=09=09return -EFSCORRUPTED;
> >  =09=09}
> > =20
> > @@ -4307,7 +4307,7 @@ xlog_recover_add_to_trans(
> >  =09"log item region count (%d) overflowed size (%d)",
> >  =09=09=09=09item->ri_cnt, item->ri_total);
> >  =09=09ASSERT(0);
> > -=09=09kmem_free(ptr);
> > +=09=09kfree(ptr);
> >  =09=09return -EFSCORRUPTED;
> >  =09}
> > =20
> > @@ -4337,13 +4337,13 @@ xlog_recover_free_trans(
> >  =09=09/* Free the regions in the item. */
> >  =09=09list_del(&item->ri_list);
> >  =09=09for (i =3D 0; i < item->ri_cnt; i++)
> > -=09=09=09kmem_free(item->ri_buf[i].i_addr);
> > +=09=09=09kfree(item->ri_buf[i].i_addr);
> >  =09=09/* Free the item itself */
> > -=09=09kmem_free(item->ri_buf);
> > -=09=09kmem_free(item);
> > +=09=09kfree(item->ri_buf);
> > +=09=09kfree(item);
> >  =09}
> >  =09/* Free the transaction recover structure */
> > -=09kmem_free(trans);
> > +=09kfree(trans);
> >  }
> > =20
> >  /*
> > @@ -5327,7 +5327,7 @@ xlog_do_recovery_pass(
> >  =09=09=09hblks =3D h_size / XLOG_HEADER_CYCLE_SIZE;
> >  =09=09=09if (h_size % XLOG_HEADER_CYCLE_SIZE)
> >  =09=09=09=09hblks++;
> > -=09=09=09kmem_free(hbp);
> > +=09=09=09kvfree(hbp);
> >  =09=09=09hbp =3D xlog_alloc_buffer(log, hblks);
> >  =09=09} else {
> >  =09=09=09hblks =3D 1;
> > @@ -5343,7 +5343,7 @@ xlog_do_recovery_pass(
> >  =09=09return -ENOMEM;
> >  =09dbp =3D xlog_alloc_buffer(log, BTOBB(h_size));
> >  =09if (!dbp) {
> > -=09=09kmem_free(hbp);
> > +=09=09kvfree(hbp);
> >  =09=09return -ENOMEM;
> >  =09}
> > =20
> > @@ -5504,9 +5504,9 @@ xlog_do_recovery_pass(
> >  =09}
> > =20
> >   bread_err2:
> > -=09kmem_free(dbp);
> > +=09kvfree(dbp);
> >   bread_err1:
> > -=09kmem_free(hbp);
> > +=09kvfree(hbp);
> > =20
> >  =09/*
> >  =09 * Submit buffers that have been added from the last record process=
ed,
> > @@ -5570,7 +5570,7 @@ xlog_do_log_recovery(
> >  =09error =3D xlog_do_recovery_pass(log, head_blk, tail_blk,
> >  =09=09=09=09      XLOG_RECOVER_PASS1, NULL);
> >  =09if (error !=3D 0) {
> > -=09=09kmem_free(log->l_buf_cancel_table);
> > +=09=09kfree(log->l_buf_cancel_table);
> >  =09=09log->l_buf_cancel_table =3D NULL;
> >  =09=09return error;
> >  =09}
> > @@ -5589,7 +5589,7 @@ xlog_do_log_recovery(
> >  =09}
> >  #endif=09/* DEBUG */
> > =20
> > -=09kmem_free(log->l_buf_cancel_table);
> > +=09kfree(log->l_buf_cancel_table);
> >  =09log->l_buf_cancel_table =3D NULL;
> > =20
> >  =09return error;
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index 5ea95247a37f..53ddb058b11a 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -42,7 +42,7 @@ xfs_uuid_table_free(void)
> >  {
> >  =09if (xfs_uuid_table_size =3D=3D 0)
> >  =09=09return;
> > -=09kmem_free(xfs_uuid_table);
> > +=09kfree(xfs_uuid_table);
> >  =09xfs_uuid_table =3D NULL;
> >  =09xfs_uuid_table_size =3D 0;
> >  }
> > @@ -127,7 +127,7 @@ __xfs_free_perag(
> >  =09struct xfs_perag *pag =3D container_of(head, struct xfs_perag, rcu_=
head);
> > =20
> >  =09ASSERT(atomic_read(&pag->pag_ref) =3D=3D 0);
> > -=09kmem_free(pag);
> > +=09kfree(pag);
> >  }
> > =20
> >  /*
> > @@ -243,7 +243,7 @@ xfs_initialize_perag(
> >  =09xfs_buf_hash_destroy(pag);
> >  out_free_pag:
> >  =09mutex_destroy(&pag->pag_ici_reclaim_lock);
> > -=09kmem_free(pag);
> > +=09kfree(pag);
> >  out_unwind_new_pags:
> >  =09/* unwind any prior newly initialized pags */
> >  =09for (index =3D first_initialised; index < agcount; index++) {
> > @@ -253,7 +253,7 @@ xfs_initialize_perag(
> >  =09=09xfs_buf_hash_destroy(pag);
> >  =09=09xfs_iunlink_destroy(pag);
> >  =09=09mutex_destroy(&pag->pag_ici_reclaim_lock);
> > -=09=09kmem_free(pag);
> > +=09=09kfree(pag);
> >  =09}
> >  =09return error;
> >  }
> > diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
> > index a06661dac5be..6ef0a71d7681 100644
> > --- a/fs/xfs/xfs_mru_cache.c
> > +++ b/fs/xfs/xfs_mru_cache.c
> > @@ -364,9 +364,9 @@ xfs_mru_cache_create(
> > =20
> >  exit:
> >  =09if (err && mru && mru->lists)
> > -=09=09kmem_free(mru->lists);
> > +=09=09kfree(mru->lists);
> >  =09if (err && mru)
> > -=09=09kmem_free(mru);
> > +=09=09kfree(mru);
> > =20
> >  =09return err;
> >  }
> > @@ -406,8 +406,8 @@ xfs_mru_cache_destroy(
> > =20
> >  =09xfs_mru_cache_flush(mru);
> > =20
> > -=09kmem_free(mru->lists);
> > -=09kmem_free(mru);
> > +=09kfree(mru->lists);
> > +=09kfree(mru);
> >  }
> > =20
> >  /*
> > diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> > index 66ea8e4fca86..06c92dc61a03 100644
> > --- a/fs/xfs/xfs_qm.c
> > +++ b/fs/xfs/xfs_qm.c
> > @@ -698,7 +698,7 @@ xfs_qm_init_quotainfo(
> >  out_free_lru:
> >  =09list_lru_destroy(&qinf->qi_lru);
> >  out_free_qinf:
> > -=09kmem_free(qinf);
> > +=09kfree(qinf);
> >  =09mp->m_quotainfo =3D NULL;
> >  =09return error;
> >  }
> > @@ -722,7 +722,7 @@ xfs_qm_destroy_quotainfo(
> >  =09xfs_qm_destroy_quotainos(qi);
> >  =09mutex_destroy(&qi->qi_tree_lock);
> >  =09mutex_destroy(&qi->qi_quotaofflock);
> > -=09kmem_free(qi);
> > +=09kfree(qi);
> >  =09mp->m_quotainfo =3D NULL;
> >  }
> > =20
> > @@ -1049,7 +1049,7 @@ xfs_qm_reset_dqcounts_buf(
> >  =09} while (nmaps > 0);
> > =20
> >  out:
> > -=09kmem_free(map);
> > +=09kfree(map);
> >  =09return error;
> >  }
> > =20
> > diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> > index 8eeed73928cd..0ac598f55339 100644
> > --- a/fs/xfs/xfs_refcount_item.c
> > +++ b/fs/xfs/xfs_refcount_item.c
> > @@ -32,7 +32,7 @@ xfs_cui_item_free(
> >  =09struct xfs_cui_log_item=09*cuip)
> >  {
> >  =09if (cuip->cui_format.cui_nextents > XFS_CUI_MAX_FAST_EXTENTS)
> > -=09=09kmem_free(cuip);
> > +=09=09kfree(cuip);
> >  =09else
> >  =09=09kmem_cache_free(xfs_cui_zone, cuip);
> >  }
> > @@ -392,7 +392,7 @@ xfs_refcount_update_finish_item(
> >  =09=09refc->ri_blockcount =3D new_aglen;
> >  =09=09return -EAGAIN;
> >  =09}
> > -=09kmem_free(refc);
> > +=09kfree(refc);
> >  =09return error;
> >  }
> > =20
> > @@ -424,7 +424,7 @@ xfs_refcount_update_cancel_item(
> >  =09struct xfs_refcount_intent=09*refc;
> > =20
> >  =09refc =3D container_of(item, struct xfs_refcount_intent, ri_list);
> > -=09kmem_free(refc);
> > +=09kfree(refc);
> >  }
> > =20
> >  const struct xfs_defer_op_type xfs_refcount_update_defer_type =3D {
> > diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> > index 4911b68f95dd..a0a02d862ddd 100644
> > --- a/fs/xfs/xfs_rmap_item.c
> > +++ b/fs/xfs/xfs_rmap_item.c
> > @@ -32,7 +32,7 @@ xfs_rui_item_free(
> >  =09struct xfs_rui_log_item=09*ruip)
> >  {
> >  =09if (ruip->rui_format.rui_nextents > XFS_RUI_MAX_FAST_EXTENTS)
> > -=09=09kmem_free(ruip);
> > +=09=09kfree(ruip);
> >  =09else
> >  =09=09kmem_cache_free(xfs_rui_zone, ruip);
> >  }
> > @@ -436,7 +436,7 @@ xfs_rmap_update_finish_item(
> >  =09=09=09rmap->ri_bmap.br_blockcount,
> >  =09=09=09rmap->ri_bmap.br_state,
> >  =09=09=09(struct xfs_btree_cur **)state);
> > -=09kmem_free(rmap);
> > +=09kfree(rmap);
> >  =09return error;
> >  }
> > =20
> > @@ -468,7 +468,7 @@ xfs_rmap_update_cancel_item(
> >  =09struct xfs_rmap_intent=09=09*rmap;
> > =20
> >  =09rmap =3D container_of(item, struct xfs_rmap_intent, ri_list);
> > -=09kmem_free(rmap);
> > +=09kfree(rmap);
> >  }
> > =20
> >  const struct xfs_defer_op_type xfs_rmap_update_defer_type =3D {
> > diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> > index d42b5a2047e0..7f03b4ab3452 100644
> > --- a/fs/xfs/xfs_rtalloc.c
> > +++ b/fs/xfs/xfs_rtalloc.c
> > @@ -1082,7 +1082,7 @@ xfs_growfs_rt(
> >  =09/*
> >  =09 * Free the fake mp structure.
> >  =09 */
> > -=09kmem_free(nmp);
> > +=09kfree(nmp);
> > =20
> >  =09/*
> >  =09 * If we had to allocate a new rsum_cache, we either need to free t=
he
> > @@ -1091,10 +1091,10 @@ xfs_growfs_rt(
> >  =09 */
> >  =09if (rsum_cache !=3D mp->m_rsum_cache) {
> >  =09=09if (error) {
> > -=09=09=09kmem_free(mp->m_rsum_cache);
> > +=09=09=09kvfree(mp->m_rsum_cache);
> >  =09=09=09mp->m_rsum_cache =3D rsum_cache;
> >  =09=09} else {
> > -=09=09=09kmem_free(rsum_cache);
> > +=09=09=09kvfree(rsum_cache);
> >  =09=09}
> >  =09}
> > =20
> > @@ -1253,7 +1253,7 @@ void
> >  xfs_rtunmount_inodes(
> >  =09struct xfs_mount=09*mp)
> >  {
> > -=09kmem_free(mp->m_rsum_cache);
> > +=09kvfree(mp->m_rsum_cache);
> >  =09if (mp->m_rbmip)
> >  =09=09xfs_irele(mp->m_rbmip);
> >  =09if (mp->m_rsumip)
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index d9ae27ddf253..cc1933dc652f 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -725,7 +725,7 @@ xfs_mount_free(
> >  {
> >  =09kfree(mp->m_rtname);
> >  =09kfree(mp->m_logname);
> > -=09kmem_free(mp);
> > +=09kfree(mp);
> >  }
> > =20
> >  STATIC int
> > diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> > index 00cc5b8734be..589918d11041 100644
> > --- a/fs/xfs/xfs_trans_ail.c
> > +++ b/fs/xfs/xfs_trans_ail.c
> > @@ -844,7 +844,7 @@ xfs_trans_ail_init(
> >  =09return 0;
> > =20
> >  out_free_ailp:
> > -=09kmem_free(ailp);
> > +=09kfree(ailp);
> >  =09return -ENOMEM;
> >  }
> > =20
> > @@ -855,5 +855,5 @@ xfs_trans_ail_destroy(
> >  =09struct xfs_ail=09*ailp =3D mp->m_ail;
> > =20
> >  =09kthread_stop(ailp->ail_task);
> > -=09kmem_free(ailp);
> > +=09kfree(ailp);
> >  }
> > --=20
> > 2.23.0
> >=20
>=20

--=20
Carlos

