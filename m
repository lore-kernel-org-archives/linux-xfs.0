Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863FF8BFA
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719900944; cv=none; b=qAXzk/RiPwU77iX08RlRlf+yb+CgY660qgeqlJfKf70rlIftP41CLHFQs4fQBj88CLmFCWj7LCUy+RzCt5zje4YOMtvkv317KkbeHFUEx9tSyUv5YVMbTVz534Nvfa8D7Aa27G6bVl8IKfhg+beAO3mYqwZVAi23+jfHo8uMqlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719900944; c=relaxed/simple;
	bh=JlvRu72DeJXwLSfxVNgCIUToRieGZkm1Nl7gorVRvNk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jJ83Q9XGLv+5s1YsOwrXnt285QtyVTFNICHHZu8a2vGeO0wF07+NjJyeqZ68GILe36itZtCNT54v7WzLXv3M+zxwmM8g6vDp1sT170X3Xrb9krL3loQqbhKnHA0l8LpEbeUSsA6Uy/RnQF3IkLUVbRZGXogupcjIQAv+r9Uc3Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cp30ScGZ; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cp30ScGZ"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-57d106e69a2so1589452a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 01 Jul 2024 23:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719900941; x=1720505741; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t4ychy9oU0CuOPYToe2Yspwjx9cgrP/Ge8Pe+YDhn5U=;
        b=Cp30ScGZHmCwMlASkbI5Q0E6SK/tiL9g/aJ0jQFdTXoCCkmnZa9IU5XlLBUM+AZuYP
         cjBxaBFACBeI1ZYunlE7alW3dN0l5KxxZvkztVexTHdVkOf7BB6O2x5Am6uOCIYx85TQ
         LmIiWl7Z315URM7XOEIBIgq/EAwjFl4IuuyH8YhiuhvtGmyddXznSs0gSQ+XvZMXwHeJ
         Am7JygXA38B8cHo/Z8LScP71eIkilZSHNQMoRlmHxL7vH1y2RzL+g4c1AT4SWw1cssd9
         PbHwHtZl+XF5ItKHWHvXRuAHhh8n0dZbmLcHxe3NFCFV/LVt0XANeGiRppcURfmYfWSS
         ORMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719900941; x=1720505741;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t4ychy9oU0CuOPYToe2Yspwjx9cgrP/Ge8Pe+YDhn5U=;
        b=LdA6dWNP+bqqWDE+2R0AwqOwf8D68iR4RhYbgEXyi5FPCfqCNLLLHY0J/AncwLkzEu
         veWxNrtOsDFVFeuFBjv6NUXfGj+n7LAhirYKFkmaz2iYv+HLt2cb7ikmH6JVsYeXfjje
         Kk/Zprafs0L79pdsgOlDVCNZi6LxzuBGPzao9qCHLvBLcKrOwdACLQTWuY2Iexwaqsks
         MYYt/lw9fNIDw36ifZkRy/f4ga9fcLL8fzJmpmFQooMUCePqNHIWNBImXNPUQ3UU2Koh
         fG9D7BT4VeImcQiS2E69cBZ5YxzDh5zRaF3JqVUBR5AP8YG40D2D90yWui5hnsRD5xTl
         IkJw==
X-Gm-Message-State: AOJu0YwMzg8AVOsjvk/o9MFeGfHiD6HG634Da/+LKMLVxr5za9Jt6boD
	vespXzbV9JEMQBBi8y2q1ZEfPomcCwEorfoKLD1gZSgyB+uCYax1FxFbj0xMnSdvatLMlLmQ08o
	zf9Z/2+ZM4BeRVA9hTWGIS82urECx3czP
X-Google-Smtp-Source: AGHT+IEE1s0xeKu76zg0sbwieyCapUj79mhYzkBvfq//uwuEVMxyqy2xP7T9YHyNdr5N80z5Inli2OQzrKKfApa/bHg=
X-Received: by 2002:a05:6402:3592:b0:57d:6bb:d264 with SMTP id
 4fb4d7f45d1cf-5865b56a1b0mr10063249a12.1.1719900940464; Mon, 01 Jul 2024
 23:15:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240619100637.392329-1-sunjunchao2870@gmail.com> <ZoIRhNzqutslLAeP@dread.disaster.area>
In-Reply-To: <ZoIRhNzqutslLAeP@dread.disaster.area>
From: JunChao Sun <sunjunchao2870@gmail.com>
Date: Tue, 2 Jul 2024 14:15:28 +0800
Message-ID: <CAHB1Nah2tJK42B03cTgHXaPotOeL6kXP9aDfFLn3V3JYh15ShQ@mail.gmail.com>
Subject: Re: [PATCH v2] xfs: reorder xfs_inode structure elements to remove
 unneeded padding.
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, chandan.babu@oracle.com, djwong@kernel.org, 
	willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dave Chinner <david@fromorbit.com> =E4=BA=8E2024=E5=B9=B47=E6=9C=881=E6=97=
=A5=E5=91=A8=E4=B8=80 10:16=E5=86=99=E9=81=93=EF=BC=9A
>
> On Wed, Jun 19, 2024 at 06:06:37PM +0800, Junchao Sun wrote:
> > By reordering the elements in the xfs_inode structure, we can
> > reduce the padding needed on an x86_64 system by 8 bytes.
> >
> > Furthermore, it also enables denser packing of xfs_inode
> > structures within slab pages. In the Debian 6.8.12-amd64,
> > before applying the patch, the size of xfs_inode is 1000 bytes,
>
>
> > Please use pahole to show where the holes are in the current TOT
> > structure, not reference a distro kernel build that has a largely
> > unknown config.

Ok.
>
> > allowing 32 xfs_inode structures to be allocated from an
> > order-3 slab. After applying the patch, the size of
> > xfs_inode is reduced to 992 bytes, allowing 33 xfs_inode
> > structures to be allocated from an order-3 slab.
> >
> > This improvement is also observed in the mainline kernel
> > with the same config.
> >
> > Signed-off-by: Junchao Sun <sunjunchao2870@gmail.com>
> > ---
> >  fs/xfs/xfs_inode.h | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> >
> > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > index 292b90b5f2ac..fedac2792a38 100644
> > --- a/fs/xfs/xfs_inode.h
> > +++ b/fs/xfs/xfs_inode.h
> > @@ -37,12 +37,6 @@ typedef struct xfs_inode {
> >       struct xfs_ifork        i_df;           /* data fork */
> >       struct xfs_ifork        i_af;           /* attribute fork */
> >
> > -     /* Transaction and locking information. */
> > -     struct xfs_inode_log_item *i_itemp;     /* logging information */
> > -     struct rw_semaphore     i_lock;         /* inode lock */
> > -     atomic_t                i_pincount;     /* inode pin count */
> > -     struct llist_node       i_gclist;       /* deferred inactivation =
list */
>
> There's lots of 4 byte holes in the structure due to stuff like
> xfs_ifork and xfs_imap being 4 byte aligned structures.
>
> This only addresses a coupel fo them, and in doing so destroys the
> attempt at creating locality of access to the inode structure.
>
> > -
> >       /*
> >        * Bitsets of inode metadata that have been checked and/or are si=
ck.
> >        * Callers must hold i_flags_lock before accessing this field.
> > @@ -88,6 +82,12 @@ typedef struct xfs_inode {
> >       /* VFS inode */
> >       struct inode            i_vnode;        /* embedded VFS inode */
> >
> > +     /* Transaction and locking information. */
> > +     struct xfs_inode_log_item *i_itemp;     /* logging information */
> > +     struct rw_semaphore     i_lock;         /* inode lock */
> > +     struct llist_node       i_gclist;       /* deferred inactivation =
list */
> > +     atomic_t                i_pincount;     /* inode pin count */
>
>
> > This separates the items commonly accessed together in the core XFS
> > code and so should be located near to each other (on the same
> > cachelines if possible). It places them on the side of the VFS inode
> > (at least 700 bytes further down the structure) and places them on
> > the same cacheline as IO completion marshalling structures. These
> > shouldn't be on the same cacheline as IO completion variables as
> > they run concurrently and independently and so need to be separated.
> >
> > really, if we are going to optimise the layout of the xfs_inode,
> > let's just do it properly the first time. See the patch below, it
> > reduces the struct xfs_inode to 960 bytes without changing much in
> > it's layout at all.

Ok, I see. Really appreciate for your detailed explanation and suggestions!
>
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
> xfs: repack the xfs_inode to reduce space.
>
> From: Dave Chinner <dchinner@redhat.com>
>
> pahole reports several 4 byte holes in the xfs_inode with a size of
> 1000 bytes. We can reduce that by packing holes better without
> affecting the data access patterns to the inode structure.
>
> Some of these holes are a result of 4 byte aligned tail structures
> being padded out to 16 bytes in the xfs_inode. These structures are
> already tightly packed and 8 byte aligned, so if we are careful with
> the layout we can add __attribute(packed) to them so their tail
> padding gets. This allows us to add a 4 byte variable into the hole
> that they would have left with 8 byte alignment padding.
>
> This reduces the struct xfs_inode to 960 bytes, a 4% reduction from
> the original 1000 bytes, and it largely doesn't change access
> patterns or data cache footprint as the alignment of all the
> critical structures is completely unchanged.
>
> pahole output now reports:
>
> struct xfs_inode {
>         struct xfs_mount *         i_mount;              /*     0     8 *=
/
>         struct xfs_dquot *         i_udquot;             /*     8     8 *=
/
>         struct xfs_dquot *         i_gdquot;             /*    16     8 *=
/
>         struct xfs_dquot *         i_pdquot;             /*    24     8 *=
/
>         xfs_ino_t                  i_ino;                /*    32     8 *=
/
>         struct xfs_imap            i_imap;               /*    40    12 *=
/
>         spinlock_t                 i_flags_lock;         /*    52     4 *=
/
>         unsigned long              i_flags;              /*    56     8 *=
/
>         /* --- cacheline 1 boundary (64 bytes) --- */
>         struct xfs_ifork *         i_cowfp;              /*    64     8 *=
/
>         struct xfs_ifork           i_df;                 /*    72    44 *=
/
>         xfs_extlen_t               i_extsize;            /*   116     4 *=
/
>         struct xfs_ifork           i_af;                 /*   120    44 *=
/
>         /* --- cacheline 2 boundary (128 bytes) was 36 bytes ago --- */
>         union {
>                 xfs_extlen_t       i_cowextsize;         /*   164     4 *=
/
>                 uint16_t           i_flushiter;          /*   164     2 *=
/
>         };                                               /*   164     4 *=
/
>         union {
>                 xfs_extlen_t               i_cowextsize;         /*     0=
     4 */
>                 uint16_t                   i_flushiter;          /*     0=
     2 */
>         };
>
>         struct xfs_inode_log_item * i_itemp;             /*   168     8 *=
/
>         struct rw_semaphore        i_lock;               /*   176    40 *=
/
>         /* --- cacheline 3 boundary (192 bytes) was 24 bytes ago --- */
>         struct llist_node          i_gclist;             /*   216     8 *=
/
>         atomic_t                   i_pincount;           /*   224     4 *=
/
>         uint16_t                   i_checked;            /*   228     2 *=
/
>         uint16_t                   i_sick;               /*   230     2 *=
/
>         uint64_t                   i_delayed_blks;       /*   232     8 *=
/
>         xfs_fsize_t                i_disk_size;          /*   240     8 *=
/
>         xfs_rfsblock_t             i_nblocks;            /*   248     8 *=
/
>         /* --- cacheline 4 boundary (256 bytes) --- */
>         prid_t                     i_projid;             /*   256     4 *=
/
>         uint8_t                    i_forkoff;            /*   260     1 *=
/
>
>         /* XXX 1 byte hole, try to pack */
>
>         uint16_t                   i_diflags;            /*   262     2 *=
/
>         uint64_t                   i_diflags2;           /*   264     8 *=
/
>         struct timespec64          i_crtime;             /*   272    16 *=
/
>         xfs_agino_t                i_next_unlinked;      /*   288     4 *=
/
>         xfs_agino_t                i_prev_unlinked;      /*   292     4 *=
/
>         struct inode               i_vnode;              /*   296   608 *=
/
>         /* --- cacheline 14 boundary (896 bytes) was 8 bytes ago --- */
>         struct work_struct         i_ioend_work;         /*   904    32 *=
/
>         struct list_head           i_ioend_list;         /*   936    16 *=
/
>         spinlock_t                 i_ioend_lock;         /*   952     4 *=
/
>
>         /* size: 960, cachelines: 15, members: 33 */
>         /* sum members: 955, holes: 1, sum holes: 1 */
>         /* padding: 4 */
> };
>
> We have a 1 byte hole in the middle, and 4 bytes of tail padding.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.h  |  2 +-
>  fs/xfs/libxfs/xfs_inode_fork.h |  2 +-
>  fs/xfs/xfs_inode.h             | 21 +++++++++++----------
>  3 files changed, 13 insertions(+), 12 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.=
h
> index 585ed5a110af..28760973d809 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -17,7 +17,7 @@ struct xfs_imap {
>         xfs_daddr_t     im_blkno;       /* starting BB of inode chunk */
>         unsigned short  im_len;         /* length in BBs of inode chunk *=
/
>         unsigned short  im_boffset;     /* inode offset in block in bytes=
 */
> -};
> +} __attribute__((packed));
>
>  int    xfs_imap_to_bp(struct xfs_mount *mp, struct xfs_trans *tp,
>                        struct xfs_imap *imap, struct xfs_buf **bpp);
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_for=
k.h
> index 2373d12fd474..63780b3542c6 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -23,7 +23,7 @@ struct xfs_ifork {
>         short                   if_broot_bytes; /* bytes allocated for ro=
ot */
>         int8_t                  if_format;      /* format of this fork */
>         uint8_t                 if_needextents; /* extents have not been =
read */
> -};
> +} __attribute__((packed));
>
>  /*
>   * Worst-case increase in the fork extent count when we're adding a sing=
le
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 292b90b5f2ac..bbc73fd56fa2 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -32,16 +32,25 @@ typedef struct xfs_inode {
>         xfs_ino_t               i_ino;          /* inode number (agno/agi=
no)*/
>         struct xfs_imap         i_imap;         /* location for xfs_imap(=
) */
>
> +       spinlock_t              i_flags_lock;   /* inode i_flags lock */
> +       unsigned long           i_flags;        /* see defined flags belo=
w */
> +
>         /* Extent information. */
>         struct xfs_ifork        *i_cowfp;       /* copy on write extents =
*/
>         struct xfs_ifork        i_df;           /* data fork */
> +       xfs_extlen_t            i_extsize;      /* basic/minimum extent s=
ize */
>         struct xfs_ifork        i_af;           /* attribute fork */
> +       /* cowextsize is only used for v3 inodes, flushiter for v1/2 */
> +       union {
> +               xfs_extlen_t    i_cowextsize;   /* basic cow extent size =
*/
> +               uint16_t        i_flushiter;    /* incremented on flush *=
/
> +       };
>
>         /* Transaction and locking information. */
>         struct xfs_inode_log_item *i_itemp;     /* logging information */
>         struct rw_semaphore     i_lock;         /* inode lock */
> -       atomic_t                i_pincount;     /* inode pin count */
>         struct llist_node       i_gclist;       /* deferred inactivation =
list */
> +       atomic_t                i_pincount;     /* inode pin count */
>
>         /*
>          * Bitsets of inode metadata that have been checked and/or are si=
ck.
> @@ -50,19 +59,11 @@ typedef struct xfs_inode {
>         uint16_t                i_checked;
>         uint16_t                i_sick;
>
> -       spinlock_t              i_flags_lock;   /* inode i_flags lock */
>         /* Miscellaneous state. */
> -       unsigned long           i_flags;        /* see defined flags belo=
w */
>         uint64_t                i_delayed_blks; /* count of delay alloc b=
lks */
>         xfs_fsize_t             i_disk_size;    /* number of bytes in fil=
e */
>         xfs_rfsblock_t          i_nblocks;      /* # of direct & btree bl=
ocks */
>         prid_t                  i_projid;       /* owner's project id */
> -       xfs_extlen_t            i_extsize;      /* basic/minimum extent s=
ize */
> -       /* cowextsize is only used for v3 inodes, flushiter for v1/2 */
> -       union {
> -               xfs_extlen_t    i_cowextsize;   /* basic cow extent size =
*/
> -               uint16_t        i_flushiter;    /* incremented on flush *=
/
> -       };
>         uint8_t                 i_forkoff;      /* attr fork offset >> 3 =
*/
>         uint16_t                i_diflags;      /* XFS_DIFLAG_... */
>         uint64_t                i_diflags2;     /* XFS_DIFLAG2_... */
> @@ -89,9 +90,9 @@ typedef struct xfs_inode {
>         struct inode            i_vnode;        /* embedded VFS inode */
>
>         /* pending io completions */
> -       spinlock_t              i_ioend_lock;
>         struct work_struct      i_ioend_work;
>         struct list_head        i_ioend_list;
> +       spinlock_t              i_ioend_lock;
>  } xfs_inode_t;
>
>  static inline bool xfs_inode_on_unlinked_list(const struct xfs_inode *ip=
)



--=20
Junchao Sun <sunjunchao2870@gmail.com>
