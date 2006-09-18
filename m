Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Sep 2006 13:49:23 -0700 (PDT)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8IKn1Zd007830
	for <xfs@oss.sgi.com>; Mon, 18 Sep 2006 13:49:05 -0700
Received: from agami.com ([192.168.168.132])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id k8IKmB2c011602
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 18 Sep 2006 13:48:21 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id k8IKm5QE020120
	for <xfs@oss.sgi.com>; Mon, 18 Sep 2006 13:48:05 -0700
Message-ID: <450F05F4.1080306@agami.com>
Date: Tue, 19 Sep 2006 02:17:48 +0530
From: Shailendra Tripathi <stripathi@agami.com>
MIME-Version: 1.0
Subject: Re: File system block reservation mechanism is broken
References: <Pine.LNX.4.64.0609151242110.21194@madrid.max-t.internal> <450EB500.3070000@agami.com> <Pine.LNX.4.64.0609181103070.22939@madrid.max-t.internal>
In-Reply-To: <Pine.LNX.4.64.0609181103070.22939@madrid.max-t.internal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stephane Doyon <sdoyon@max-t.com>
Cc: xfs@oss.sgi.com

Stephane Doyon wrote:

> It assumes the superblock counters are current and accurate, and that 
> they are authoritative... it hasn't been converted to use the new fast 
> path, it always uses the slow path.
>
> Most of the time (except when some CPU's counter has drained), the 
> fdblocks count will be in the per-cpu mp->m_sb_cnts array of counters. 
> m_sb.sb_fdblocks only contains the value left in it last time we 
> totaled the counters. Modifying m_sb.sb_fdblocks does nothing because 
> that value is known to be inaccurate and will be recalculated and 
> overwritten next time the slow path to that counter is used.
>
> Does that make it clearer?
>
Yes. I missed that in next resync, the fdblocks will remain summed up as 
the old fdblocks value, however, resblks will up upped. This might make 
the calculations based upon rsvd blocks go wrong.
          However, it can be handled in resync path itself (during 
balance) alternatively. After draining the counters, sum up the 
fdblocks. At this point, compare the mp->sb_fdblocks and the summed up 
blocks. If there is difference, adjust the difference. In current code, 
after xfs_icsb_count, it just overwrites the fields. . However, there is 
possibility that some rsvd blocks might end up being  used without going 
through regular path. For example, lets say, resblks in increased, 
however, it is not updated immediately. Now, total usage would be 
governed by the previous available fdblocks. So, by the time, next 
update takes place, the block might be in rsvd range already.

>> Stephane Doyon wrote:
>>
>>>  [Resending. Seems my previous post did not make it somehow...]
>>>
>>>  The mechanism allowing to reserve file system blocks, 
>>> xfs_reserve_blocks()
>>>  / XFS_IOC_SET_RESBLKS, appears to have been broken by the patch that
>>>  introduced per-cpu superblock counters.
>>>
>>>
>>>  The observed behavior is that xfs_io -xc "resblks <nnn>" <file> has no
>>>  effect: the resblks does get set and can be retrieved, but the free 
>>> blocks
>>>  count does not decrease.
>>>
>>>  The XFS_SET_ASIDE_BLOCKS, introduced in the recent full file system
>>>  deadlock fix, probably also needs to be taken into account.
>>>
>>>  I'm not particularly familiar with the code, but AFAICT something 
>>> along
>>>  the lines of the following patch should fix it.
>>>
>>>  Signed-off-by: Stephane Doyon <sdoyon@max-t.com>
>>>
>>>  Index: linux/fs/xfs/xfs_fsops.c
>>>  ===================================================================
>>>  --- linux.orig/fs/xfs/xfs_fsops.c    2006-09-13 11:31:36.000000000 
>>> -0400
>>>  +++ linux/fs/xfs/xfs_fsops.c    2006-09-13 11:32:06.782591491 -0400
>>>  @@ -505,6 +505,7 @@
>>>
>>>        request = *inval;
>>>        s = XFS_SB_LOCK(mp);
>>>  +    xfs_icsb_disable_counter(mp, XFS_SBS_FDBLOCKS);
>>>
>>>        /*
>>>        * If our previous reservation was larger than the current value,
>>>  @@ -520,14 +521,14 @@
>>>            mp->m_resblks = request;
>>>        } else {
>>>           delta = request - mp->m_resblks;
>>>  -        lcounter = mp->m_sb.sb_fdblocks - delta;
>>>  +        lcounter = mp->m_sb.sb_fdblocks - XFS_SET_ASIDE_BLOCKS(mp) -
>>>  delta;
>>>            if (lcounter < 0) {
>>>               /* We can't satisfy the request, just get what we can */
>>>  -            mp->m_resblks += mp->m_sb.sb_fdblocks;
>>>  -            mp->m_resblks_avail += mp->m_sb.sb_fdblocks;
>>>  -            mp->m_sb.sb_fdblocks = 0;
>>>  +            mp->m_resblks += mp->m_sb.sb_fdblocks -
>>>  XFS_SET_ASIDE_BLOCKS(mp);
>>>  +            mp->m_resblks_avail += mp->m_sb.sb_fdblocks -
>>>  XFS_SET_ASIDE_BLOCKS(mp);
>>>  +            mp->m_sb.sb_fdblocks = XFS_SET_ASIDE_BLOCKS(mp);
>>>           } else {
>>>  -            mp->m_sb.sb_fdblocks = lcounter;
>>>  +            mp->m_sb.sb_fdblocks = lcounter + 
>>> XFS_SET_ASIDE_BLOCKS(mp);
>>>                mp->m_resblks = request;
>>>                mp->m_resblks_avail += delta;
>>>           }
>>>  Index: linux/fs/xfs/xfs_mount.c
>>>  ===================================================================
>>>  --- linux.orig/fs/xfs/xfs_mount.c    2006-09-13 11:31:36.000000000 
>>> -0400
>>>  +++ linux/fs/xfs/xfs_mount.c    2006-09-13 11:32:06.784591724 -0400
>>>  @@ -58,7 +58,6 @@
>>>                            int, int);
>>>    STATIC int    xfs_icsb_modify_counters_locked(xfs_mount_t *,
>>>  xfs_sb_field_t,
>>>                           int, int);
>>>  -STATIC int    xfs_icsb_disable_counter(xfs_mount_t *, 
>>> xfs_sb_field_t);
>>>
>>>   #else
>>>
>>>  @@ -1254,26 +1253,6 @@
>>>    }
>>>
>>>  /*
>>>  - * In order to avoid ENOSPC-related deadlock caused by
>>>  - * out-of-order locking of AGF buffer (PV 947395), we place
>>>  - * constraints on the relationship among actual allocations for
>>>  - * data blocks, freelist blocks, and potential file data bmap
>>>  - * btree blocks. However, these restrictions may result in no
>>>  - * actual space allocated for a delayed extent, for example, a data
>>>  - * block in a certain AG is allocated but there is no additional
>>>  - * block for the additional bmap btree block due to a split of the
>>>  - * bmap btree of the file. The result of this may lead to an
>>>  - * infinite loop in xfssyncd when the file gets flushed to disk and
>>>  - * all delayed extents need to be actually allocated. To get around
>>>  - * this, we explicitly set aside a few blocks which will not be
>>>  - * reserved in delayed allocation. Considering the minimum number of
>>>  - * needed freelist blocks is 4 fsbs _per AG_, a potential split of 
>>> file's
>>>  bmap
>>>  - * btree requires 1 fsb, so we set the number of set-aside blocks
>>>  - * to 4 + 4*agcount.
>>>  - */
>>>  -#define XFS_SET_ASIDE_BLOCKS(mp)  (4 + ((mp)->m_sb.sb_agcount * 4))
>>>  -
>>>  -/*
>>>     * xfs_mod_incore_sb_unlocked() is a utility routine common used to
>>>     apply
>>>     * a delta to a specified field in the in-core superblock.  Simply
>>>     * switch on the field indicated and apply the delta to that field.
>>>  @@ -1906,7 +1885,7 @@
>>>        return test_bit(field, &mp->m_icsb_counters);
>>>    }
>>>
>>>  -STATIC int
>>>  +int
>>>    xfs_icsb_disable_counter(
>>>        xfs_mount_t    *mp,
>>>        xfs_sb_field_t    field)
>>>  Index: linux/fs/xfs/xfs_mount.h
>>>  ===================================================================
>>>  --- linux.orig/fs/xfs/xfs_mount.h    2006-09-13 11:31:36.000000000 
>>> -0400
>>>  +++ linux/fs/xfs/xfs_mount.h    2006-09-13 11:33:24.441557999 -0400
>>>  @@ -307,10 +307,14 @@
>>>
>>>    extern int    xfs_icsb_init_counters(struct xfs_mount *);
>>>    extern void    xfs_icsb_sync_counters_lazy(struct xfs_mount *);
>>>  +/* Can't forward declare typedefs... */
>>>  +struct xfs_mount;
>>>  +extern int xfs_icsb_disable_counter(struct xfs_mount *, 
>>> xfs_sb_field_t);
>>>
>>> #  else
>>> #  define xfs_icsb_init_counters(mp)    (0)
>>> #  define xfs_icsb_sync_counters_lazy(mp)    do { } while (0)
>>>  +#define xfs_icsb_disable_counters(mp, field)    do { } while (0)
>>>    #endif
>>>
>>>   typedef struct xfs_mount {
>>>  @@ -574,6 +578,27 @@
>>> #  define    XFS_SB_LOCK(mp)        mutex_spinlock(&(mp)->m_sb_lock)
>>> #  define    XFS_SB_UNLOCK(mp,s)    
>>> mutex_spinunlock(&(mp)->m_sb_lock,(s))
>>>
>>>  +
>>>  +/*
>>>  + * In order to avoid ENOSPC-related deadlock caused by
>>>  + * out-of-order locking of AGF buffer (PV 947395), we place
>>>  + * constraints on the relationship among actual allocations for
>>>  + * data blocks, freelist blocks, and potential file data bmap
>>>  + * btree blocks. However, these restrictions may result in no
>>>  + * actual space allocated for a delayed extent, for example, a data
>>>  + * block in a certain AG is allocated but there is no additional
>>>  + * block for the additional bmap btree block due to a split of the
>>>  + * bmap btree of the file. The result of this may lead to an
>>>  + * infinite loop in xfssyncd when the file gets flushed to disk and
>>>  + * all delayed extents need to be actually allocated. To get around
>>>  + * this, we explicitly set aside a few blocks which will not be
>>>  + * reserved in delayed allocation. Considering the minimum number of
>>>  + * needed freelist blocks is 4 fsbs _per AG_, a potential split of 
>>> file's
>>>  bmap
>>>  + * btree requires 1 fsb, so we set the number of set-aside blocks
>>>  + * to 4 + 4*agcount.
>>>  + */
>>>  +#define XFS_SET_ASIDE_BLOCKS(mp)  (4 + ((mp)->m_sb.sb_agcount * 4))
>>>  +
>>>    extern xfs_mount_t *xfs_mount_init(void);
>>>    extern void    xfs_mod_sb(xfs_trans_t *, __int64_t);
>>>    extern void    xfs_mount_free(xfs_mount_t *mp, int remove_bhv);
>>>
>>>
>>>
>>
>>
>>
>
