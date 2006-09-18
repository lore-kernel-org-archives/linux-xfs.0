Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Sep 2006 08:02:54 -0700 (PDT)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8IF2gZd014417
	for <xfs@oss.sgi.com>; Mon, 18 Sep 2006 08:02:46 -0700
Received: from agami.com ([192.168.168.132])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id k8IF212c007503
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 18 Sep 2006 08:02:06 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id k8IF1uUr014151
	for <xfs@oss.sgi.com>; Mon, 18 Sep 2006 08:01:56 -0700
Message-ID: <450EB500.3070000@agami.com>
Date: Mon, 18 Sep 2006 20:32:24 +0530
From: Shailendra Tripathi <stripathi@agami.com>
MIME-Version: 1.0
Subject: Re: File system block reservation mechanism is broken
References: <Pine.LNX.4.64.0609151242110.21194@madrid.max-t.internal>
In-Reply-To: <Pine.LNX.4.64.0609151242110.21194@madrid.max-t.internal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stephane Doyon <sdoyon@max-t.com>
Cc: xfs@oss.sgi.com

Hi Stephane,

 > The code in xfs_reserve_blocks() just locks the superblock and then
 > consults and modifies mp->m_sb.sb_fdblocks. However, if the per-cpu
 > counter is active, the count is spread across the per-cpu counters, and
 > the superblock field does not contain an accurate count, nor does
 > modifying it have any effect.

     This is the fast path. However, there is slow path where it 
actually falls back to the earlier mechanism where global lock 
(spin-lock) is held and then counters are guranteed to be consistent. 
The goal is not to take the global lock unless in extreme cases (when 
performance might  go down anyway due to other reasons).
         I am really not sure about your observations on xfs_io. Can you 
please clarify little more as to why it fails. I can't see the problem.

Regards,
Shailendra

Stephane Doyon wrote:
> [Resending. Seems my previous post did not make it somehow...]
> 
> The mechanism allowing to reserve file system blocks, 
> xfs_reserve_blocks() / XFS_IOC_SET_RESBLKS, appears to have been broken 
> by the patch that introduced per-cpu superblock counters.
> 
> 
> The observed behavior is that xfs_io -xc "resblks <nnn>" <file> has no 
> effect: the resblks does get set and can be retrieved, but the free 
> blocks count does not decrease.
> 
> The XFS_SET_ASIDE_BLOCKS, introduced in the recent full file system 
> deadlock fix, probably also needs to be taken into account.
> 
> I'm not particularly familiar with the code, but AFAICT something along 
> the lines of the following patch should fix it.
> 
> Signed-off-by: Stephane Doyon <sdoyon@max-t.com>
> 
> Index: linux/fs/xfs/xfs_fsops.c
> ===================================================================
> --- linux.orig/fs/xfs/xfs_fsops.c    2006-09-13 11:31:36.000000000 -0400
> +++ linux/fs/xfs/xfs_fsops.c    2006-09-13 11:32:06.782591491 -0400
> @@ -505,6 +505,7 @@
> 
>       request = *inval;
>       s = XFS_SB_LOCK(mp);
> +    xfs_icsb_disable_counter(mp, XFS_SBS_FDBLOCKS);
> 
>       /*
>       * If our previous reservation was larger than the current value,
> @@ -520,14 +521,14 @@
>           mp->m_resblks = request;
>       } else {
>          delta = request - mp->m_resblks;
> -        lcounter = mp->m_sb.sb_fdblocks - delta;
> +        lcounter = mp->m_sb.sb_fdblocks - XFS_SET_ASIDE_BLOCKS(mp) - 
> delta;
>           if (lcounter < 0) {
>              /* We can't satisfy the request, just get what we can */
> -            mp->m_resblks += mp->m_sb.sb_fdblocks;
> -            mp->m_resblks_avail += mp->m_sb.sb_fdblocks;
> -            mp->m_sb.sb_fdblocks = 0;
> +            mp->m_resblks += mp->m_sb.sb_fdblocks - 
> XFS_SET_ASIDE_BLOCKS(mp);
> +            mp->m_resblks_avail += mp->m_sb.sb_fdblocks - 
> XFS_SET_ASIDE_BLOCKS(mp);
> +            mp->m_sb.sb_fdblocks = XFS_SET_ASIDE_BLOCKS(mp);
>          } else {
> -            mp->m_sb.sb_fdblocks = lcounter;
> +            mp->m_sb.sb_fdblocks = lcounter + XFS_SET_ASIDE_BLOCKS(mp);
>               mp->m_resblks = request;
>               mp->m_resblks_avail += delta;
>          }
> Index: linux/fs/xfs/xfs_mount.c
> ===================================================================
> --- linux.orig/fs/xfs/xfs_mount.c    2006-09-13 11:31:36.000000000 -0400
> +++ linux/fs/xfs/xfs_mount.c    2006-09-13 11:32:06.784591724 -0400
> @@ -58,7 +58,6 @@
>                           int, int);
>   STATIC int    xfs_icsb_modify_counters_locked(xfs_mount_t *, 
> xfs_sb_field_t,
>                          int, int);
> -STATIC int    xfs_icsb_disable_counter(xfs_mount_t *, xfs_sb_field_t);
> 
>  #else
> 
> @@ -1254,26 +1253,6 @@
>   }
> 
>  /*
> - * In order to avoid ENOSPC-related deadlock caused by
> - * out-of-order locking of AGF buffer (PV 947395), we place
> - * constraints on the relationship among actual allocations for
> - * data blocks, freelist blocks, and potential file data bmap
> - * btree blocks. However, these restrictions may result in no
> - * actual space allocated for a delayed extent, for example, a data
> - * block in a certain AG is allocated but there is no additional
> - * block for the additional bmap btree block due to a split of the
> - * bmap btree of the file. The result of this may lead to an
> - * infinite loop in xfssyncd when the file gets flushed to disk and
> - * all delayed extents need to be actually allocated. To get around
> - * this, we explicitly set aside a few blocks which will not be
> - * reserved in delayed allocation. Considering the minimum number of
> - * needed freelist blocks is 4 fsbs _per AG_, a potential split of 
> file's bmap
> - * btree requires 1 fsb, so we set the number of set-aside blocks
> - * to 4 + 4*agcount.
> - */
> -#define XFS_SET_ASIDE_BLOCKS(mp)  (4 + ((mp)->m_sb.sb_agcount * 4))
> -
> -/*
>    * xfs_mod_incore_sb_unlocked() is a utility routine common used to apply
>    * a delta to a specified field in the in-core superblock.  Simply
>    * switch on the field indicated and apply the delta to that field.
> @@ -1906,7 +1885,7 @@
>       return test_bit(field, &mp->m_icsb_counters);
>   }
> 
> -STATIC int
> +int
>   xfs_icsb_disable_counter(
>       xfs_mount_t    *mp,
>       xfs_sb_field_t    field)
> Index: linux/fs/xfs/xfs_mount.h
> ===================================================================
> --- linux.orig/fs/xfs/xfs_mount.h    2006-09-13 11:31:36.000000000 -0400
> +++ linux/fs/xfs/xfs_mount.h    2006-09-13 11:33:24.441557999 -0400
> @@ -307,10 +307,14 @@
> 
>   extern int    xfs_icsb_init_counters(struct xfs_mount *);
>   extern void    xfs_icsb_sync_counters_lazy(struct xfs_mount *);
> +/* Can't forward declare typedefs... */
> +struct xfs_mount;
> +extern int xfs_icsb_disable_counter(struct xfs_mount *, xfs_sb_field_t);
> 
>  # else
>  # define xfs_icsb_init_counters(mp)    (0)
>  # define xfs_icsb_sync_counters_lazy(mp)    do { } while (0)
> +#define xfs_icsb_disable_counters(mp, field)    do { } while (0)
>   #endif
> 
>  typedef struct xfs_mount {
> @@ -574,6 +578,27 @@
>  # define    XFS_SB_LOCK(mp)        mutex_spinlock(&(mp)->m_sb_lock)
>  # define    XFS_SB_UNLOCK(mp,s)    mutex_spinunlock(&(mp)->m_sb_lock,(s))
> 
> +
> +/*
> + * In order to avoid ENOSPC-related deadlock caused by
> + * out-of-order locking of AGF buffer (PV 947395), we place
> + * constraints on the relationship among actual allocations for
> + * data blocks, freelist blocks, and potential file data bmap
> + * btree blocks. However, these restrictions may result in no
> + * actual space allocated for a delayed extent, for example, a data
> + * block in a certain AG is allocated but there is no additional
> + * block for the additional bmap btree block due to a split of the
> + * bmap btree of the file. The result of this may lead to an
> + * infinite loop in xfssyncd when the file gets flushed to disk and
> + * all delayed extents need to be actually allocated. To get around
> + * this, we explicitly set aside a few blocks which will not be
> + * reserved in delayed allocation. Considering the minimum number of
> + * needed freelist blocks is 4 fsbs _per AG_, a potential split of 
> file's bmap
> + * btree requires 1 fsb, so we set the number of set-aside blocks
> + * to 4 + 4*agcount.
> + */
> +#define XFS_SET_ASIDE_BLOCKS(mp)  (4 + ((mp)->m_sb.sb_agcount * 4))
> +
>   extern xfs_mount_t *xfs_mount_init(void);
>   extern void    xfs_mod_sb(xfs_trans_t *, __int64_t);
>   extern void    xfs_mount_free(xfs_mount_t *mp, int remove_bhv);
> 
> 
> 
