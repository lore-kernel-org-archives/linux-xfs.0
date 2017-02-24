Return-Path: <cmaiolino@redhat.com>
Resent-Message-ID: <20170227145851.cwaxemfgklosf552@eorzea.usersys.redhat.com>
Resent-To: sandeen@sandeen.net
Received: from userp1050.oracle.com ([156.151.31.82]:20589 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751246AbdBXAzr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Feb 2017 19:55:47 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v1O0tNxV003322
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 24 Feb 2017 00:55:23 GMT
Date: Thu, 23 Feb 2017 16:54:18 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/8] xfs: introduce the XFS_IOC_GETFSMAP ioctl
Message-ID: <20170224005418.GJ5846@birch.djwong.org>
References: <148738063792.29384.10681837280402457846.stgit@birch.djwong.org>
 <148738066907.29384.8419135817879528959.stgit@birch.djwong.org>
 <20170222150246.GB53025@bfoster.bfoster>
 <20170222211757.GH5846@birch.djwong.org>
 <20170223144542.GA57349@bfoster.bfoster>
 <20170223204405.GI5846@birch.djwong.org>
 <20170223234301.GA57524@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170223234301.GA57524@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Feb 23, 2017 at 06:43:01PM -0500, Brian Foster wrote:
> On Thu, Feb 23, 2017 at 12:44:05PM -0800, Darrick J. Wong wrote:
> > On Thu, Feb 23, 2017 at 09:45:43AM -0500, Brian Foster wrote:
> > > On Wed, Feb 22, 2017 at 01:17:57PM -0800, Darrick J. Wong wrote:
> > > > On Wed, Feb 22, 2017 at 10:02:47AM -0500, Brian Foster wrote:
> > > > > On Fri, Feb 17, 2017 at 05:17:49PM -0800, Darrick J. Wong wrote:
> > > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > > 
> > > > > > Introduce a new ioctl that uses the reverse mapping btree to return
> > > > > > information about the physical layout of the filesystem.
> > > > > > 
> > > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > > ---
> > > > > 
> ...
> > > So the rmapbt query doesn't incorporate the full getfsmap key in the
> > > search and we thus we have to include finer grained filtering..? If so,
> > > I think this bit could be noted explicitly in the comment..
> > 
> > It's a funny quirk of how queries have to work when record keys contain
> > multiple overlapping ranges interacting with the current design of
> > query_range.
> > 
> > rmap tuple format is still (start, length, owner, offset).
> > 
> > Say you have the rmaps (24, 8, 128, 0) and (30, 10, 128, 8).  The low
> > key of the first rmap is (24, 128, 0) and the high key is (31, 128, 7).
> > That way you can query the rmapbt for start == 27 and it'll return the
> > above rmap.  _btree_query_range was designed to return any record
> > overlapping with any part of the interval, even if the record start or
> > record end themselves are not within the interval.
> > 
> > However, if you want to look for the next tuple after (24, 8, 128, 0)
> > you can't just tell it to search for (31...) because 31 > 30 and it'll
> > miss that second rmap.  You can however tell it to search (24, 128, 8)
> > and ignore any records if any part of the low key is not greater than
> > the low search key.
> > 
> > Theoretically, we could enhance query_range to take an operator so that
> > you could tell it to return any record overlapping with any part of the
> > interval so long as the start of the record is strictly greater than the
> > start of the query interval.
> > 
> > FWIW the comment for _btree_query_range says it returns all records
> > overlapping with the interval passed in.
> > 
> 
> Gotcha, thanks.
> 
> > > Also, I'm kind of wondering why we couldn't have just set next_daddr to
> > > 40 in the first place based on the low key. Is there some other corner
> > > case that breaks..?
> > 
> > Aha, looking through my notes, the original version also used next_daddr
> > (buggily) to decide if a record actually started before the bumped low
> > key so that it could ignore it.  Subsequent revisions created an
> > explicit test function (_getfsmap_rec_before_low_key) so you're right,
> > we can set next_daddr to 40 (fmh_keys[0]->fmr_physical + fmr_length) for
> > the first loop iteration and zero for subsequent iterations.  With that
> > the key_end business also goes away.
> > 
> 
> Oh, Ok. That sounds like a nice cleanup then.
> 
> > > > Assuming _getfsmap_helper is passed the same refcount rmap as before.
> > > > rec_daddr = 64, and when we get to line 318, key_end = 24 + 16.
> > > > 
> > > > The test is now:
> > > > if (devices match && 40 < 40 && 64 >= 40)
> > > > So we leave next_daddr at 40.
> > > > 
> > > > The correct output here is to synthesize an fsmap record for free space
> > > > between 40-64, and then to emit the refcount record at 64.
> > > > 
> > > > Third example: fmh_keys = [(8:0, 24, 16, 128, 0), (-1)] and next_daddr = 24
> > > > as before.  _getfsmap_helper again sees (8:0, 24, 16, 128, 0) and sets
> > > > next_daddr = 40.
> > > > 
> > > > This time, however, _getfsmap_helper is passed (8:0, 32, 8, 129, 0),
> > > > which is 8 sectors of inode 129's data at offset 0.  rec_daddr = 32,
> > > > key_end = 24 + 16 as before.
> > > > 
> > > > The test is now:
> > > > if (devices match && 40 < 40 && 32 >= 40)
> > > > So we again leave next_daddr at 40, then emit the fsmap for inode 129.
> > > > 
> ...
> > > > > 
> > > > > Hmm.. could we combine these into one call that looks like:
> > > > > 
> > > > > 	trace_xfs_getfsmap(mp, &fmh_keys[0], &fmh_keys[1]);
> > > > > 
> > > > > ... and has the trace handler pull the relevant data out of the key
> > > > > structure (same comment for the similar trace_xfs_fsmap*())?
> > > > 
> > > > I'd prefer to leave it as-is, because passing struct xfs_fsmap into a
> > > > tracepoint requires every file that includes xfs_trace.h to also include
> > > > xfs_fsmap.h to get the structure definition.
> > > > 
> > > 
> > > I think you can get around that with a structure declaration in
> > > xfs_trace.h, as the only code that actually requires the full definition
> > > is xfs_trace.c. If that works, that could at least reduce the tracepoint
> > > calls to a couple lines of code, even if we retain the independent
> > > low/high key tp's.
> > 
> > But then we'd have two definitions of the same structure, and anyone
> > touching xfs_fsmap would have to remember to update both.  I think it's
> > fine to pass pointers to core libxfs/*format.h structures directly into
> > tracepoints, but fsmap is on the periphery.
> > 
> 
> No, it's just a declaration (not the full structure definition). I.e.,
> add 'struct xfs_fsmap;' to the list of similarly declared structures at
> the top of xfs_trace.h.
> 
> See the appended diff for what I mean. It only changes one of the
> classes, but compiles clean for me (compile tested only)..

Oh, you're right, that does work.  I forgot that xfs_trace.h is a magic
headerfile on account of CREATE_TRACE_POINTS.  Ok, I'll go fix that too.

--D

> 
> Brian
> 
> --- 8< ---
> 
> diff --git a/fs/xfs/xfs_fsmap.h b/fs/xfs/xfs_fsmap.h
> index 1943047..55f7c85 100644
> --- a/fs/xfs/xfs_fsmap.h
> +++ b/fs/xfs/xfs_fsmap.h
> @@ -20,6 +20,8 @@
>  #ifndef __XFS_FSMAP_H__
>  #define	__XFS_FSMAP_H__
>  
> +struct fsmap;
> +
>  /* internal fsmap representation */
>  struct xfs_fsmap {
>  	dev_t		fmr_device;	/* device id */
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index e1f3fbf..95f4923 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1622,9 +1622,7 @@ xfs_getfsmap_format(struct xfs_fsmap *xfm, void *priv)
>  	struct getfsmap_info	*info = priv;
>  	struct fsmap		fm;
>  
> -	trace_xfs_getfsmap_mapping(info->mp, xfm->fmr_device, xfm->fmr_physical,
> -			xfm->fmr_length, xfm->fmr_owner, xfm->fmr_offset,
> -			xfm->fmr_flags);
> +	trace_xfs_getfsmap_mapping(info->mp, xfm);
>  
>  	info->last_flags = xfm->fmr_flags;
>  	xfs_fsmap_from_internal(&fm, xfm);
> @@ -1664,21 +1662,8 @@ xfs_ioc_getfsmap(
>  	xfs_fsmap_to_internal(&xhead.fmh_keys[0], &head.fmh_keys[0]);
>  	xfs_fsmap_to_internal(&xhead.fmh_keys[1], &head.fmh_keys[1]);
>  
> -	trace_xfs_getfsmap_low_key(ip->i_mount,
> -			xhead.fmh_keys[0].fmr_device,
> -			xhead.fmh_keys[0].fmr_physical,
> -			xhead.fmh_keys[0].fmr_length,
> -			xhead.fmh_keys[0].fmr_owner,
> -			xhead.fmh_keys[0].fmr_offset,
> -			xhead.fmh_keys[0].fmr_flags);
> -
> -	trace_xfs_getfsmap_high_key(ip->i_mount,
> -			xhead.fmh_keys[1].fmr_device,
> -			xhead.fmh_keys[1].fmr_physical,
> -			xhead.fmh_keys[1].fmr_length,
> -			xhead.fmh_keys[1].fmr_owner,
> -			xhead.fmh_keys[1].fmr_offset,
> -			xhead.fmh_keys[1].fmr_flags);
> +	trace_xfs_getfsmap_low_key(ip->i_mount, &xhead.fmh_keys[0]);
> +	trace_xfs_getfsmap_high_key(ip->i_mount, &xhead.fmh_keys[1]);
>  
>  	info.mp = ip->i_mount;
>  	info.data = ((__force struct fsmap_head *)arg)->fmh_recs;
> diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
> index 7f17ae6..5d95fe3 100644
> --- a/fs/xfs/xfs_trace.c
> +++ b/fs/xfs/xfs_trace.c
> @@ -47,6 +47,7 @@
>  #include "xfs_inode_item.h"
>  #include "xfs_bmap_btree.h"
>  #include "xfs_filestream.h"
> +#include "xfs_fsmap.h"
>  
>  /*
>   * We include this last to have the helpers above available for the trace
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index dbfc4db..a8eaf34 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -40,6 +40,7 @@ struct xfs_inode_log_format;
>  struct xfs_bmbt_irec;
>  struct xfs_btree_cur;
>  struct xfs_refcount_irec;
> +struct xfs_fsmap;
>  
>  DECLARE_EVENT_CLASS(xfs_attr_list_class,
>  	TP_PROTO(struct xfs_attr_list_context *ctx),
> @@ -3311,10 +3312,8 @@ DEFINE_FSMAP_EVENT(xfs_fsmap_high_key);
>  DEFINE_FSMAP_EVENT(xfs_fsmap_mapping);
>  
>  DECLARE_EVENT_CLASS(xfs_getfsmap_class,
> -	TP_PROTO(struct xfs_mount *mp, u32 keydev, xfs_daddr_t block,
> -		 xfs_daddr_t len, __uint64_t owner, __uint64_t offset,
> -		 __uint64_t flags),
> -	TP_ARGS(mp, keydev, block, len, owner, offset, flags),
> +	TP_PROTO(struct xfs_mount *mp, struct xfs_fsmap *fsmap),
> +	TP_ARGS(mp, fsmap),
>  	TP_STRUCT__entry(
>  		__field(dev_t, dev)
>  		__field(dev_t, keydev)
> @@ -3326,12 +3325,12 @@ DECLARE_EVENT_CLASS(xfs_getfsmap_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = mp->m_super->s_dev;
> -		__entry->keydev = new_decode_dev(keydev);
> -		__entry->block = block;
> -		__entry->len = len;
> -		__entry->owner = owner;
> -		__entry->offset = offset;
> -		__entry->flags = flags;
> +		__entry->keydev = new_decode_dev(fsmap->fmr_device);
> +		__entry->block = fsmap->fmr_physical;
> +		__entry->len = fsmap->fmr_length;
> +		__entry->owner = fsmap->fmr_owner;
> +		__entry->offset = fsmap->fmr_offset;
> +		__entry->flags = fsmap->fmr_flags;
>  	),
>  	TP_printk("dev %d:%d keydev %d:%d block %llu len %llu owner %lld offset %llu flags 0x%llx\n",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> @@ -3344,10 +3343,8 @@ DECLARE_EVENT_CLASS(xfs_getfsmap_class,
>  )
>  #define DEFINE_GETFSMAP_EVENT(name) \
>  DEFINE_EVENT(xfs_getfsmap_class, name, \
> -	TP_PROTO(struct xfs_mount *mp, u32 keydev, xfs_daddr_t block, \
> -		 xfs_daddr_t len, __uint64_t owner, __uint64_t offset, \
> -		 __uint64_t flags), \
> -	TP_ARGS(mp, keydev, block, len, owner, offset, flags))
> +	TP_PROTO(struct xfs_mount *mp, struct xfs_fsmap *fsmap), \
> +	TP_ARGS(mp, fsmap))
>  DEFINE_GETFSMAP_EVENT(xfs_getfsmap_low_key);
>  DEFINE_GETFSMAP_EVENT(xfs_getfsmap_high_key);
>  DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
