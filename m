Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DE610F9
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jul 2024 02:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719800202; cv=none; b=G4UkEazHYh7TPU6xUTJMuatOb3tMhuKreb1NAoWJi3uiZAWLBxyigodF9Ll/Nce6YTWSMWnzsHI7RYnqZsHKw6Lw2hfIisu2yN5ZizDkK9RIcpZOX3buJMYP1NppxkvsHfTk0h+pDWgWwEye9UfESWViqsnqMrTp21aXsqRmws4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719800202; c=relaxed/simple;
	bh=eN4SwVkC+HH8tl9I7eYcLy/op1Y4krduYnN/jCQxK68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V4IKt9stc8Qu//Cs9rtgwMV6KMl1ky0ZGBCREv5jxIyBzQu6Vrcpod+LJpR1qYzpsxI5p+SVS56DHIME7F5bVdF/A+mmEBU/q935QpN3IrkXWC2ePQaIo1KRk0Tgvx8B5LmmOmqYvpjJKTa/cAtVGCJgaeFPoLlw/HliSImx7GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=npnyuHXW; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="npnyuHXW"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-70aaab1cb72so1145199b3a.0
        for <linux-xfs@vger.kernel.org>; Sun, 30 Jun 2024 19:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1719800200; x=1720405000; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qfaFHaXzlvXE3wxogu+5/GeqGhXV+YMwc1/MfE9ISCo=;
        b=npnyuHXWfYOLVEgf/dy6Kn3y4mhk0HJaSlBhdTF1ciI/XoaAXLB6AtqFIVCh6JVtrb
         9BJHQu96U2CI5mCeWSRF6ch0evMDx4UWUx+SPrCLa06WaWXN4Du+8qbAIZlVLeIXU4CR
         fKosjRYhNH2oz6Q48r9/J0tf511EhNt9VTO5svOf7V1Zpdwjfror8iBHjIJ9x3XLHRc+
         pBZko37IOJaMwGoDOZX7H0MQ+EIpGzOm/tTgyeanYe8ad91wMQ/YLqCeEqub9urVGmze
         e8sTxxjvZVPTdbK7AfyIt5589F+wvAIiFy41/yz6MzBIuX6BeB4bXTL/ZVjxXc0GUY46
         8KqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719800200; x=1720405000;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qfaFHaXzlvXE3wxogu+5/GeqGhXV+YMwc1/MfE9ISCo=;
        b=dPqMe+YL+rxS2tO+BiA3X5BeOa1LRcpGBjGxaDqD/W5+wftNvyE4QoMXKnkt310Bsz
         omepYTQ7ZydNynFy3dj3FVxgkOIaHjYabwya2A0z3KJ/i2msvdUk5C9VLplVwT5wVswl
         AD3ruunHduIt/W6MOKGUds8I0DcIDHQKjZAxnaInlN9TLKQMGscZ36P9PQ3bH+uv1oE7
         V2mz4IvYbXDmvWH6+gCtDljhGxC9Ixcs8K5S4A+nKh119vJohdYscGY75jg6wiDjNU/6
         LCTzDqcOFCMeINq5EiMckzZ7ft6yhokMThxqujNvEJyk94uC2LqIDvw2YybKISKF17mq
         ur8Q==
X-Gm-Message-State: AOJu0Yxj+CsiWfk8DfC4vsOaSMQZTJ8IlA0qmZ0j0ZsTKobMs4MofIqJ
	3NGbFGpe9bW2jyWcIHW0qHxZ+P+CPvKDSrrK/kSTON5uWM/zXw4U4EtdRRiKAzk=
X-Google-Smtp-Source: AGHT+IGvYDXMcr8trWDoUqg4h7SiEHxYSVdLduThcY0Sy9wte7OYDkN0zr1AcWzUNyyWy7zcIrD7Kw==
X-Received: by 2002:a05:6a00:10c7:b0:705:9526:3c0d with SMTP id d2e1a72fcca58-70aaad3ab65mr5713362b3a.12.1719800199502;
        Sun, 30 Jun 2024 19:16:39 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7080246bcacsm5301431b3a.55.2024.06.30.19.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jun 2024 19:16:38 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sO6aq-00HPzn-05;
	Mon, 01 Jul 2024 12:16:36 +1000
Date: Mon, 1 Jul 2024 12:16:36 +1000
From: Dave Chinner <david@fromorbit.com>
To: Junchao Sun <sunjunchao2870@gmail.com>
Cc: linux-xfs@vger.kernel.org, chandan.babu@oracle.com, djwong@kernel.org,
	willy@infradead.org
Subject: Re: [PATCH v2] xfs: reorder xfs_inode structure elements to remove
 unneeded padding.
Message-ID: <ZoIRhNzqutslLAeP@dread.disaster.area>
References: <20240619100637.392329-1-sunjunchao2870@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240619100637.392329-1-sunjunchao2870@gmail.com>

On Wed, Jun 19, 2024 at 06:06:37PM +0800, Junchao Sun wrote:
> By reordering the elements in the xfs_inode structure, we can
> reduce the padding needed on an x86_64 system by 8 bytes.
> 
> Furthermore, it also enables denser packing of xfs_inode
> structures within slab pages. In the Debian 6.8.12-amd64,
> before applying the patch, the size of xfs_inode is 1000 bytes,

Please use pahole to show where the holes are in the current TOT
structure, not reference a distro kernel build that has a largely
unknown config.

> allowing 32 xfs_inode structures to be allocated from an
> order-3 slab. After applying the patch, the size of
> xfs_inode is reduced to 992 bytes, allowing 33 xfs_inode
> structures to be allocated from an order-3 slab.
> 
> This improvement is also observed in the mainline kernel
> with the same config.
> 
> Signed-off-by: Junchao Sun <sunjunchao2870@gmail.com>
> ---
>  fs/xfs/xfs_inode.h | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 292b90b5f2ac..fedac2792a38 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -37,12 +37,6 @@ typedef struct xfs_inode {
>  	struct xfs_ifork	i_df;		/* data fork */
>  	struct xfs_ifork	i_af;		/* attribute fork */
>  
> -	/* Transaction and locking information. */
> -	struct xfs_inode_log_item *i_itemp;	/* logging information */
> -	struct rw_semaphore	i_lock;		/* inode lock */
> -	atomic_t		i_pincount;	/* inode pin count */
> -	struct llist_node	i_gclist;	/* deferred inactivation list */

There's lots of 4 byte holes in the structure due to stuff like
xfs_ifork and xfs_imap being 4 byte aligned structures.

This only addresses a coupel fo them, and in doing so destroys the
attempt at creating locality of access to the inode structure.

> -
>  	/*
>  	 * Bitsets of inode metadata that have been checked and/or are sick.
>  	 * Callers must hold i_flags_lock before accessing this field.
> @@ -88,6 +82,12 @@ typedef struct xfs_inode {
>  	/* VFS inode */
>  	struct inode		i_vnode;	/* embedded VFS inode */
>  
> +	/* Transaction and locking information. */
> +	struct xfs_inode_log_item *i_itemp;	/* logging information */
> +	struct rw_semaphore	i_lock;		/* inode lock */
> +	struct llist_node	i_gclist;	/* deferred inactivation list */
> +	atomic_t		i_pincount;	/* inode pin count */

This separates the items commonly accessed together in the core XFS
code and so should be located near to each other (on the same
cachelines if possible). It places them on the side of the VFS inode
(at least 700 bytes further down the structure) and places them on
the same cacheline as IO completion marshalling structures. These
shouldn't be on the same cacheline as IO completion variables as
they run concurrently and independently and so need to be separated.

really, if we are going to optimise the layout of the xfs_inode,
let's just do it properly the first time. See the patch below, it
reduces the struct xfs_inode to 960 bytes without changing much in
it's layout at all.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: repack the xfs_inode to reduce space.

From: Dave Chinner <dchinner@redhat.com>

pahole reports several 4 byte holes in the xfs_inode with a size of
1000 bytes. We can reduce that by packing holes better without
affecting the data access patterns to the inode structure.

Some of these holes are a result of 4 byte aligned tail structures
being padded out to 16 bytes in the xfs_inode. These structures are
already tightly packed and 8 byte aligned, so if we are careful with
the layout we can add __attribute(packed) to them so their tail
padding gets. This allows us to add a 4 byte variable into the hole
that they would have left with 8 byte alignment padding.

This reduces the struct xfs_inode to 960 bytes, a 4% reduction from
the original 1000 bytes, and it largely doesn't change access
patterns or data cache footprint as the alignment of all the
critical structures is completely unchanged.

pahole output now reports:

struct xfs_inode {
        struct xfs_mount *         i_mount;              /*     0     8 */
        struct xfs_dquot *         i_udquot;             /*     8     8 */
        struct xfs_dquot *         i_gdquot;             /*    16     8 */
        struct xfs_dquot *         i_pdquot;             /*    24     8 */
        xfs_ino_t                  i_ino;                /*    32     8 */
        struct xfs_imap            i_imap;               /*    40    12 */
        spinlock_t                 i_flags_lock;         /*    52     4 */
        unsigned long              i_flags;              /*    56     8 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        struct xfs_ifork *         i_cowfp;              /*    64     8 */
        struct xfs_ifork           i_df;                 /*    72    44 */
        xfs_extlen_t               i_extsize;            /*   116     4 */
        struct xfs_ifork           i_af;                 /*   120    44 */
        /* --- cacheline 2 boundary (128 bytes) was 36 bytes ago --- */
        union {
                xfs_extlen_t       i_cowextsize;         /*   164     4 */
                uint16_t           i_flushiter;          /*   164     2 */
        };                                               /*   164     4 */
        union {
                xfs_extlen_t               i_cowextsize;         /*     0     4 */
                uint16_t                   i_flushiter;          /*     0     2 */
        };

        struct xfs_inode_log_item * i_itemp;             /*   168     8 */
        struct rw_semaphore        i_lock;               /*   176    40 */
        /* --- cacheline 3 boundary (192 bytes) was 24 bytes ago --- */
        struct llist_node          i_gclist;             /*   216     8 */
        atomic_t                   i_pincount;           /*   224     4 */
        uint16_t                   i_checked;            /*   228     2 */
        uint16_t                   i_sick;               /*   230     2 */
        uint64_t                   i_delayed_blks;       /*   232     8 */
        xfs_fsize_t                i_disk_size;          /*   240     8 */
        xfs_rfsblock_t             i_nblocks;            /*   248     8 */
        /* --- cacheline 4 boundary (256 bytes) --- */
        prid_t                     i_projid;             /*   256     4 */
        uint8_t                    i_forkoff;            /*   260     1 */

        /* XXX 1 byte hole, try to pack */

        uint16_t                   i_diflags;            /*   262     2 */
        uint64_t                   i_diflags2;           /*   264     8 */
        struct timespec64          i_crtime;             /*   272    16 */
        xfs_agino_t                i_next_unlinked;      /*   288     4 */
        xfs_agino_t                i_prev_unlinked;      /*   292     4 */
        struct inode               i_vnode;              /*   296   608 */
        /* --- cacheline 14 boundary (896 bytes) was 8 bytes ago --- */
        struct work_struct         i_ioend_work;         /*   904    32 */
        struct list_head           i_ioend_list;         /*   936    16 */
        spinlock_t                 i_ioend_lock;         /*   952     4 */

        /* size: 960, cachelines: 15, members: 33 */
        /* sum members: 955, holes: 1, sum holes: 1 */
        /* padding: 4 */
};

We have a 1 byte hole in the middle, and 4 bytes of tail padding.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_inode_buf.h  |  2 +-
 fs/xfs/libxfs/xfs_inode_fork.h |  2 +-
 fs/xfs/xfs_inode.h             | 21 +++++++++++----------
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 585ed5a110af..28760973d809 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -17,7 +17,7 @@ struct xfs_imap {
 	xfs_daddr_t	im_blkno;	/* starting BB of inode chunk */
 	unsigned short	im_len;		/* length in BBs of inode chunk */
 	unsigned short	im_boffset;	/* inode offset in block in bytes */
-};
+} __attribute__((packed));
 
 int	xfs_imap_to_bp(struct xfs_mount *mp, struct xfs_trans *tp,
 		       struct xfs_imap *imap, struct xfs_buf **bpp);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 2373d12fd474..63780b3542c6 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -23,7 +23,7 @@ struct xfs_ifork {
 	short			if_broot_bytes;	/* bytes allocated for root */
 	int8_t			if_format;	/* format of this fork */
 	uint8_t			if_needextents;	/* extents have not been read */
-};
+} __attribute__((packed));
 
 /*
  * Worst-case increase in the fork extent count when we're adding a single
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 292b90b5f2ac..bbc73fd56fa2 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -32,16 +32,25 @@ typedef struct xfs_inode {
 	xfs_ino_t		i_ino;		/* inode number (agno/agino)*/
 	struct xfs_imap		i_imap;		/* location for xfs_imap() */
 
+	spinlock_t		i_flags_lock;	/* inode i_flags lock */
+	unsigned long		i_flags;	/* see defined flags below */
+
 	/* Extent information. */
 	struct xfs_ifork	*i_cowfp;	/* copy on write extents */
 	struct xfs_ifork	i_df;		/* data fork */
+	xfs_extlen_t		i_extsize;	/* basic/minimum extent size */
 	struct xfs_ifork	i_af;		/* attribute fork */
+	/* cowextsize is only used for v3 inodes, flushiter for v1/2 */
+	union {
+		xfs_extlen_t	i_cowextsize;	/* basic cow extent size */
+		uint16_t	i_flushiter;	/* incremented on flush */
+	};
 
 	/* Transaction and locking information. */
 	struct xfs_inode_log_item *i_itemp;	/* logging information */
 	struct rw_semaphore	i_lock;		/* inode lock */
-	atomic_t		i_pincount;	/* inode pin count */
 	struct llist_node	i_gclist;	/* deferred inactivation list */
+	atomic_t		i_pincount;	/* inode pin count */
 
 	/*
 	 * Bitsets of inode metadata that have been checked and/or are sick.
@@ -50,19 +59,11 @@ typedef struct xfs_inode {
 	uint16_t		i_checked;
 	uint16_t		i_sick;
 
-	spinlock_t		i_flags_lock;	/* inode i_flags lock */
 	/* Miscellaneous state. */
-	unsigned long		i_flags;	/* see defined flags below */
 	uint64_t		i_delayed_blks;	/* count of delay alloc blks */
 	xfs_fsize_t		i_disk_size;	/* number of bytes in file */
 	xfs_rfsblock_t		i_nblocks;	/* # of direct & btree blocks */
 	prid_t			i_projid;	/* owner's project id */
-	xfs_extlen_t		i_extsize;	/* basic/minimum extent size */
-	/* cowextsize is only used for v3 inodes, flushiter for v1/2 */
-	union {
-		xfs_extlen_t	i_cowextsize;	/* basic cow extent size */
-		uint16_t	i_flushiter;	/* incremented on flush */
-	};
 	uint8_t			i_forkoff;	/* attr fork offset >> 3 */
 	uint16_t		i_diflags;	/* XFS_DIFLAG_... */
 	uint64_t		i_diflags2;	/* XFS_DIFLAG2_... */
@@ -89,9 +90,9 @@ typedef struct xfs_inode {
 	struct inode		i_vnode;	/* embedded VFS inode */
 
 	/* pending io completions */
-	spinlock_t		i_ioend_lock;
 	struct work_struct	i_ioend_work;
 	struct list_head	i_ioend_list;
+	spinlock_t		i_ioend_lock;
 } xfs_inode_t;
 
 static inline bool xfs_inode_on_unlinked_list(const struct xfs_inode *ip)
