Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50395 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750797AbdJDUww (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Oct 2017 16:52:52 -0400
Date: Wed, 4 Oct 2017 13:52:48 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 07/25] xfs: scrub btree keys and records
Message-ID: <20171004205248.GV6503@magnolia>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
 <150706329392.19351.7914012941264600843.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150706329392.19351.7914012941264600843.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: david@fromorbit.com

On Tue, Oct 03, 2017 at 01:41:33PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add to the btree scrubber the ability to check that the keys and
> records are in the right order and actually call out to our record
> iterator to do actual checking of the records.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/btree.c |  108 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/scrub/trace.h |   44 ++++++++++++++++++++
>  2 files changed, 152 insertions(+)
> 
> 
> diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> index 899c9b1..ad3518c 100644
> --- a/fs/xfs/scrub/btree.c
> +++ b/fs/xfs/scrub/btree.c
> @@ -92,6 +92,101 @@ xfs_scrub_btree_set_corrupt(
>  				__return_address);
>  }
>  
> +/*
> + * Make sure this record is in order and doesn't stray outside of the parent
> + * keys.
> + */
> +STATIC void
> +xfs_scrub_btree_rec(
> +	struct xfs_scrub_btree	*bs)
> +{
> +	struct xfs_btree_cur	*cur = bs->cur;
> +	union xfs_btree_rec	*rec;
> +	union xfs_btree_key	key;
> +	union xfs_btree_key	hkey;
> +	union xfs_btree_key	*keyp;
> +	struct xfs_btree_block	*block;
> +	struct xfs_btree_block	*keyblock;
> +	struct xfs_buf		*bp;
> +
> +	block = xfs_btree_get_block(cur, 0, &bp);
> +	rec = xfs_btree_rec_addr(cur, cur->bc_ptrs[0], block);
> +
> +	trace_xfs_scrub_btree_rec(bs->sc, cur, 0);
> +
> +	/* If this isn't the first record, are they in order? */
> +	if (!bs->firstrec && !cur->bc_ops->recs_inorder(cur, &bs->lastrec, rec))
> +		xfs_scrub_btree_set_corrupt(bs->sc, cur, 0);
> +	bs->firstrec = false;
> +	memcpy(&bs->lastrec, rec, cur->bc_ops->rec_len);
> +
> +	if (cur->bc_nlevels == 1)
> +		return;
> +
> +	/* Is this at least as large as the parent low key? */
> +	cur->bc_ops->init_key_from_rec(&key, rec);
> +	keyblock = xfs_btree_get_block(cur, 1, &bp);
> +	keyp = xfs_btree_key_addr(cur, cur->bc_ptrs[1], keyblock);
> +	if (cur->bc_ops->diff_two_keys(cur, &key, keyp) < 0)
> +		xfs_scrub_btree_set_corrupt(bs->sc, cur, 1);
> +
> +	if (!(cur->bc_flags & XFS_BTREE_OVERLAPPING))
> +		return;
> +
> +	/* Is this no larger than the parent high key? */
> +	cur->bc_ops->init_high_key_from_rec(&hkey, rec);
> +	keyp = xfs_btree_high_key_addr(cur, cur->bc_ptrs[1], keyblock);
> +	if (cur->bc_ops->diff_two_keys(cur, keyp, &hkey) < 0)
> +		xfs_scrub_btree_set_corrupt(bs->sc, cur, 1);
> +}
> +
> +/*
> + * Make sure this key is in order and doesn't stray outside of the parent
> + * keys.
> + */
> +STATIC void
> +xfs_scrub_btree_key(
> +	struct xfs_scrub_btree	*bs,
> +	int			level)
> +{
> +	struct xfs_btree_cur	*cur = bs->cur;
> +	union xfs_btree_key	*key;
> +	union xfs_btree_key	*keyp;
> +	struct xfs_btree_block	*block;
> +	struct xfs_btree_block	*keyblock;
> +	struct xfs_buf		*bp;
> +
> +	block = xfs_btree_get_block(cur, level, &bp);
> +	key = xfs_btree_key_addr(cur, cur->bc_ptrs[level], block);
> +
> +	trace_xfs_scrub_btree_key(bs->sc, cur, level);
> +
> +	/* If this isn't the first key, are they in order? */
> +	if (!bs->firstkey[level] &&
> +	    !cur->bc_ops->keys_inorder(cur, &bs->lastkey[level], key))
> +		xfs_scrub_btree_set_corrupt(bs->sc, cur, level);
> +	bs->firstkey[level] = false;
> +	memcpy(&bs->lastkey[level], key, cur->bc_ops->key_len);
> +
> +	if (level + 1 >= cur->bc_nlevels)
> +		return;
> +
> +	/* Is this at least as large as the parent low key? */
> +	keyblock = xfs_btree_get_block(cur, level + 1, &bp);
> +	keyp = xfs_btree_key_addr(cur, cur->bc_ptrs[level + 1], keyblock);
> +	if (cur->bc_ops->diff_two_keys(cur, key, keyp) < 0)
> +		xfs_scrub_btree_set_corrupt(bs->sc, cur, level);
> +
> +	if (!(cur->bc_flags & XFS_BTREE_OVERLAPPING))
> +		return;
> +
> +	/* Is this no larger than the parent high key? */
> +	key = xfs_btree_high_key_addr(cur, cur->bc_ptrs[level], block);
> +	keyp = xfs_btree_high_key_addr(cur, cur->bc_ptrs[level + 1], keyblock);
> +	if (cur->bc_ops->diff_two_keys(cur, keyp, key) < 0)
> +		xfs_scrub_btree_set_corrupt(bs->sc, cur, level);
> +}
> +
>  /* Check a btree pointer.  Returns true if it's ok to use this pointer. */
>  static bool
>  xfs_scrub_btree_ptr_ok(
> @@ -256,6 +351,7 @@ xfs_scrub_btree(
>  	struct xfs_scrub_btree		bs = {0};
>  	union xfs_btree_ptr		ptr;
>  	union xfs_btree_ptr		*pp;
> +	union xfs_btree_rec		*recp;
>  	struct xfs_btree_block		*block;
>  	int				level;
>  	struct xfs_buf			*bp;
> @@ -311,6 +407,15 @@ xfs_scrub_btree(
>  				continue;
>  			}
>  
> +			/* Records in order for scrub? */
> +			xfs_scrub_btree_rec(&bs);
> +
> +			/* Call out to the record checker. */
> +			recp = xfs_btree_rec_addr(cur, cur->bc_ptrs[0], block);
> +			error = bs.scrub_rec(&bs, recp);
> +			if (error < 0 ||
> +			    error == XFS_BTREE_QUERY_RANGE_ABORT)
> +				break;
>  			if (xfs_scrub_should_terminate(sc, &error))
>  				break;

Referencing the discussion of a later patch, we could check for
OFLAG_CORRUPT here as a quick way out if we find corruption in the
metadata object.

--D

>  
> @@ -326,6 +431,9 @@ xfs_scrub_btree(
>  			continue;
>  		}
>  
> +		/* Keys in order for scrub? */
> +		xfs_scrub_btree_key(&bs, level);
> +
>  		/* Drill another level deeper. */
>  		pp = xfs_btree_ptr_addr(cur, cur->bc_ptrs[level], block);
>  		if (!xfs_scrub_btree_ptr_ok(&bs, level, pp)) {
> diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> index 78f96b0..a78c8d1 100644
> --- a/fs/xfs/scrub/trace.h
> +++ b/fs/xfs/scrub/trace.h
> @@ -423,6 +423,50 @@ TRACE_EVENT(xfs_scrub_ifork_btree_error,
>  		  __entry->ret_ip)
>  );
>  
> +DECLARE_EVENT_CLASS(xfs_scrub_sbtree_class,
> +	TP_PROTO(struct xfs_scrub_context *sc, struct xfs_btree_cur *cur,
> +		 int level),
> +	TP_ARGS(sc, cur, level),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(int, type)
> +		__field(xfs_btnum_t, btnum)
> +		__field(xfs_agnumber_t, agno)
> +		__field(xfs_agblock_t, bno)
> +		__field(int, level)
> +		__field(int, nlevels)
> +		__field(int, ptr)
> +	),
> +	TP_fast_assign(
> +		xfs_fsblock_t fsbno = xfs_scrub_btree_cur_fsbno(cur, level);
> +		__entry->dev = sc->mp->m_super->s_dev;
> +		__entry->type = sc->sm->sm_type;
> +		__entry->btnum = cur->bc_btnum;
> +		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
> +		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
> +		__entry->level = level;
> +		__entry->nlevels = cur->bc_nlevels;
> +		__entry->ptr = cur->bc_ptrs[level];
> +	),
> +	TP_printk("dev %d:%d type %u btnum %d agno %u agbno %u level %d nlevels %d ptr %d",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->type,
> +		  __entry->btnum,
> +		  __entry->agno,
> +		  __entry->bno,
> +		  __entry->level,
> +		  __entry->nlevels,
> +		  __entry->ptr)
> +)
> +#define DEFINE_SCRUB_SBTREE_EVENT(name) \
> +DEFINE_EVENT(xfs_scrub_sbtree_class, name, \
> +	TP_PROTO(struct xfs_scrub_context *sc, struct xfs_btree_cur *cur, \
> +		 int level), \
> +	TP_ARGS(sc, cur, level))
> +
> +DEFINE_SCRUB_SBTREE_EVENT(xfs_scrub_btree_rec);
> +DEFINE_SCRUB_SBTREE_EVENT(xfs_scrub_btree_key);
> +
>  #endif /* _TRACE_XFS_SCRUB_TRACE_H */
>  
>  #undef TRACE_INCLUDE_PATH
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
