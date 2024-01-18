Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D771EB37
	for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2024 22:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705618463; cv=none; b=b91FGdzUMsdoMJ6l2MooAn6yXrS73OHuTgJZ4jsHXLP5eCou2qGOPHvYTUJeeNVtERbC1FV5vQjJZZgBRWful5RFNliUcriDPmVt7Nf+XIRRDB692xaamCxHw7/DrPKgjdnRBeTjO6dsXXULoomb1hUcSMToLmzYuGnzJ+mUHuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705618463; c=relaxed/simple;
	bh=NZ2ylypwlmFwRUXo17ci/q275mZa54hdN2RKFmyvEv4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c7SQljAknvTwIMTYqpKOb29RHqWWAgwT5s6Y+//QqiZ+MV34NTqOJ+9GF7K02h0b35g/hQG1GFrGXUut2dJT1ZiuzkvcSffw7vMWYnnbierdzivXTHECemlHWLF612f4aHoQCsmexSSgm0UA4FfJHo9jYnpU+cYihb7mcJkV1lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YkDvaJkr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YkDvaJkr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B47FC433C7;
	Thu, 18 Jan 2024 22:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705618463;
	bh=NZ2ylypwlmFwRUXo17ci/q275mZa54hdN2RKFmyvEv4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YkDvaJkr/apw3VisGaZLIKZHlIpSGUjn+XjLcZNpDeAdrBFteCIKoItpCPWw3OBA8
	 UJZWmYqY2HQ1Bmh8rPLu5VPfIhesgYVmqSDKlf0HG6Qb/5n0cmVKJBg3rgo44FH2VP
	 /iy4CAZgYJM5iRDJrWkiVZCsH0zWdZgwyYhJ3m2IQTExjQKFeNNLoxxyvLKs5M0Qye
	 upbpJSom5Qd616kQXoqx1tjzYrxCG55sVj/yK/HMaY6FHY3C9Bho8BmiTnhszvoAIQ
	 YH+NO9D5JMRwjKBUqZlgSCea1bkW7LEDdsaCm3YhdqHN/KnKbCDYiMtjB9PJbhwouU
	 hQ/EDOllaqW5g==
Date: Thu, 18 Jan 2024 14:54:22 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 05/12] xfs: convert remaining kmem_free() to kfree()
Message-ID: <20240118225422.GH674499@frogsfrogsfrogs>
References: <20240115230113.4080105-1-david@fromorbit.com>
 <20240115230113.4080105-6-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240115230113.4080105-6-david@fromorbit.com>

On Tue, Jan 16, 2024 at 09:59:43AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The remaining callers of kmem_free() are freeing heap memory, so
> we can convert them directly to kfree() and get rid of kmem_free()
> altogether.
> 
> This conversion was done with:
> 
> $ for f in `git grep -l kmem_free fs/xfs`; do
> > sed -i s/kmem_free/kfree/ $f
> > done
> $
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

/me bets this will cause interesting merge conflicts with the online
repair patchset but that's no reason to slow this down.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/kmem.h                     | 23 -----------------------
>  fs/xfs/libxfs/xfs_ag.c            |  6 +++---
>  fs/xfs/libxfs/xfs_attr_leaf.c     |  8 ++++----
>  fs/xfs/libxfs/xfs_btree.c         |  2 +-
>  fs/xfs/libxfs/xfs_btree_staging.c |  4 ++--
>  fs/xfs/libxfs/xfs_da_btree.c      | 10 +++++-----
>  fs/xfs/libxfs/xfs_defer.c         |  4 ++--
>  fs/xfs/libxfs/xfs_dir2.c          | 18 +++++++++---------
>  fs/xfs/libxfs/xfs_dir2_block.c    |  4 ++--
>  fs/xfs/libxfs/xfs_dir2_sf.c       |  8 ++++----
>  fs/xfs/libxfs/xfs_iext_tree.c     |  8 ++++----
>  fs/xfs/libxfs/xfs_inode_fork.c    |  6 +++---
>  fs/xfs/scrub/cow_repair.c         |  2 +-
>  fs/xfs/xfs_attr_item.c            |  2 +-
>  fs/xfs/xfs_attr_list.c            |  4 ++--
>  fs/xfs/xfs_buf.c                  | 12 ++++++------
>  fs/xfs/xfs_buf_item.c             |  2 +-
>  fs/xfs/xfs_buf_item_recover.c     |  6 +++---
>  fs/xfs/xfs_discard.c              |  2 +-
>  fs/xfs/xfs_error.c                |  4 ++--
>  fs/xfs/xfs_extent_busy.c          |  2 +-
>  fs/xfs/xfs_extfree_item.c         |  4 ++--
>  fs/xfs/xfs_filestream.c           |  4 ++--
>  fs/xfs/xfs_inode.c                |  4 ++--
>  fs/xfs/xfs_inode_item_recover.c   |  2 +-
>  fs/xfs/xfs_ioctl.c                |  6 +++---
>  fs/xfs/xfs_iops.c                 |  2 +-
>  fs/xfs/xfs_itable.c               |  4 ++--
>  fs/xfs/xfs_iwalk.c                |  4 ++--
>  fs/xfs/xfs_linux.h                |  3 +--
>  fs/xfs/xfs_log.c                  |  8 ++++----
>  fs/xfs/xfs_log_cil.c              | 14 +++++++-------
>  fs/xfs/xfs_log_recover.c          |  6 +++---
>  fs/xfs/xfs_mount.c                |  2 +-
>  fs/xfs/xfs_mru_cache.c            |  8 ++++----
>  fs/xfs/xfs_qm.c                   |  6 +++---
>  fs/xfs/xfs_refcount_item.c        |  2 +-
>  fs/xfs/xfs_rmap_item.c            |  2 +-
>  fs/xfs/xfs_rtalloc.c              |  2 +-
>  fs/xfs/xfs_super.c                |  2 +-
>  fs/xfs/xfs_trans_ail.c            |  4 ++--
>  41 files changed, 101 insertions(+), 125 deletions(-)
>  delete mode 100644 fs/xfs/kmem.h
> 
> diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> deleted file mode 100644
> index 48e43f29f2a0..000000000000
> --- a/fs/xfs/kmem.h
> +++ /dev/null
> @@ -1,23 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> -/*
> - * Copyright (c) 2000-2005 Silicon Graphics, Inc.
> - * All Rights Reserved.
> - */
> -#ifndef __XFS_SUPPORT_KMEM_H__
> -#define __XFS_SUPPORT_KMEM_H__
> -
> -#include <linux/slab.h>
> -#include <linux/sched.h>
> -#include <linux/mm.h>
> -#include <linux/vmalloc.h>
> -
> -/*
> - * General memory allocation interfaces
> - */
> -
> -static inline void  kmem_free(const void *ptr)
> -{
> -	kvfree(ptr);
> -}
> -
> -#endif /* __XFS_SUPPORT_KMEM_H__ */
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 96a6bfd58931..937ea48d5cc0 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -241,7 +241,7 @@ __xfs_free_perag(
>  	struct xfs_perag *pag = container_of(head, struct xfs_perag, rcu_head);
>  
>  	ASSERT(!delayed_work_pending(&pag->pag_blockgc_work));
> -	kmem_free(pag);
> +	kfree(pag);
>  }
>  
>  /*
> @@ -353,7 +353,7 @@ xfs_free_unused_perag_range(
>  			break;
>  		xfs_buf_hash_destroy(pag);
>  		xfs_defer_drain_free(&pag->pag_intents_drain);
> -		kmem_free(pag);
> +		kfree(pag);
>  	}
>  }
>  
> @@ -453,7 +453,7 @@ xfs_initialize_perag(
>  	radix_tree_delete(&mp->m_perag_tree, index);
>  	spin_unlock(&mp->m_perag_lock);
>  out_free_pag:
> -	kmem_free(pag);
> +	kfree(pag);
>  out_unwind_new_pags:
>  	/* unwind any prior newly initialized pags */
>  	xfs_free_unused_perag_range(mp, first_initialised, agcount);
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 033382cf514d..192d9938a231 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -923,7 +923,7 @@ xfs_attr_shortform_to_leaf(
>  	}
>  	error = 0;
>  out:
> -	kmem_free(tmpbuffer);
> +	kfree(tmpbuffer);
>  	return error;
>  }
>  
> @@ -1124,7 +1124,7 @@ xfs_attr3_leaf_to_shortform(
>  	error = 0;
>  
>  out:
> -	kmem_free(tmpbuffer);
> +	kfree(tmpbuffer);
>  	return error;
>  }
>  
> @@ -1570,7 +1570,7 @@ xfs_attr3_leaf_compact(
>  	 */
>  	xfs_trans_log_buf(trans, bp, 0, args->geo->blksize - 1);
>  
> -	kmem_free(tmpbuffer);
> +	kfree(tmpbuffer);
>  }
>  
>  /*
> @@ -2290,7 +2290,7 @@ xfs_attr3_leaf_unbalance(
>  		}
>  		memcpy(save_leaf, tmp_leaf, state->args->geo->blksize);
>  		savehdr = tmphdr; /* struct copy */
> -		kmem_free(tmp_leaf);
> +		kfree(tmp_leaf);
>  	}
>  
>  	xfs_attr3_leaf_hdr_to_disk(state->args->geo, save_leaf, &savehdr);
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index ea8d3659df20..1adfc35c99c9 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -451,7 +451,7 @@ xfs_btree_del_cursor(
>  	ASSERT(cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_ino.allocated == 0 ||
>  	       xfs_is_shutdown(cur->bc_mp) || error != 0);
>  	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING))
> -		kmem_free(cur->bc_ops);
> +		kfree(cur->bc_ops);
>  	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) && cur->bc_ag.pag)
>  		xfs_perag_put(cur->bc_ag.pag);
>  	kmem_cache_free(cur->bc_cache, cur);
> diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
> index 065e4a00a2f4..961f6b898f4b 100644
> --- a/fs/xfs/libxfs/xfs_btree_staging.c
> +++ b/fs/xfs/libxfs/xfs_btree_staging.c
> @@ -171,7 +171,7 @@ xfs_btree_commit_afakeroot(
>  
>  	trace_xfs_btree_commit_afakeroot(cur);
>  
> -	kmem_free((void *)cur->bc_ops);
> +	kfree((void *)cur->bc_ops);
>  	cur->bc_ag.agbp = agbp;
>  	cur->bc_ops = ops;
>  	cur->bc_flags &= ~XFS_BTREE_STAGING;
> @@ -254,7 +254,7 @@ xfs_btree_commit_ifakeroot(
>  
>  	trace_xfs_btree_commit_ifakeroot(cur);
>  
> -	kmem_free((void *)cur->bc_ops);
> +	kfree((void *)cur->bc_ops);
>  	cur->bc_ino.ifake = NULL;
>  	cur->bc_ino.whichfork = whichfork;
>  	cur->bc_ops = ops;
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 331b9251b185..3383b4525381 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -2220,7 +2220,7 @@ xfs_da_grow_inode_int(
>  
>  out_free_map:
>  	if (mapp != &map)
> -		kmem_free(mapp);
> +		kfree(mapp);
>  	return error;
>  }
>  
> @@ -2559,7 +2559,7 @@ xfs_dabuf_map(
>  	*nmaps = nirecs;
>  out_free_irecs:
>  	if (irecs != &irec)
> -		kmem_free(irecs);
> +		kfree(irecs);
>  	return error;
>  
>  invalid_mapping:
> @@ -2615,7 +2615,7 @@ xfs_da_get_buf(
>  
>  out_free:
>  	if (mapp != &map)
> -		kmem_free(mapp);
> +		kfree(mapp);
>  
>  	return error;
>  }
> @@ -2656,7 +2656,7 @@ xfs_da_read_buf(
>  	*bpp = bp;
>  out_free:
>  	if (mapp != &map)
> -		kmem_free(mapp);
> +		kfree(mapp);
>  
>  	return error;
>  }
> @@ -2687,7 +2687,7 @@ xfs_da_reada_buf(
>  
>  out_free:
>  	if (mapp != &map)
> -		kmem_free(mapp);
> +		kfree(mapp);
>  
>  	return error;
>  }
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 07d318b1f807..75689c151a54 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -1038,7 +1038,7 @@ xfs_defer_ops_capture_abort(
>  	for (i = 0; i < dfc->dfc_held.dr_inos; i++)
>  		xfs_irele(dfc->dfc_held.dr_ip[i]);
>  
> -	kmem_free(dfc);
> +	kfree(dfc);
>  }
>  
>  /*
> @@ -1114,7 +1114,7 @@ xfs_defer_ops_continue(
>  	list_splice_init(&dfc->dfc_dfops, &tp->t_dfops);
>  	tp->t_flags |= dfc->dfc_tpflags;
>  
> -	kmem_free(dfc);
> +	kfree(dfc);
>  }
>  
>  /* Release the resources captured and continued during recovery. */
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 370d67300455..e60aa8f8d0a7 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -109,8 +109,8 @@ xfs_da_mount(
>  	mp->m_attr_geo = kzalloc(sizeof(struct xfs_da_geometry),
>  				GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  	if (!mp->m_dir_geo || !mp->m_attr_geo) {
> -		kmem_free(mp->m_dir_geo);
> -		kmem_free(mp->m_attr_geo);
> +		kfree(mp->m_dir_geo);
> +		kfree(mp->m_attr_geo);
>  		return -ENOMEM;
>  	}
>  
> @@ -178,8 +178,8 @@ void
>  xfs_da_unmount(
>  	struct xfs_mount	*mp)
>  {
> -	kmem_free(mp->m_dir_geo);
> -	kmem_free(mp->m_attr_geo);
> +	kfree(mp->m_dir_geo);
> +	kfree(mp->m_attr_geo);
>  }
>  
>  /*
> @@ -244,7 +244,7 @@ xfs_dir_init(
>  	args->dp = dp;
>  	args->trans = tp;
>  	error = xfs_dir2_sf_create(args, pdp->i_ino);
> -	kmem_free(args);
> +	kfree(args);
>  	return error;
>  }
>  
> @@ -313,7 +313,7 @@ xfs_dir_createname(
>  		rval = xfs_dir2_node_addname(args);
>  
>  out_free:
> -	kmem_free(args);
> +	kfree(args);
>  	return rval;
>  }
>  
> @@ -419,7 +419,7 @@ xfs_dir_lookup(
>  	}
>  out_free:
>  	xfs_iunlock(dp, lock_mode);
> -	kmem_free(args);
> +	kfree(args);
>  	return rval;
>  }
>  
> @@ -477,7 +477,7 @@ xfs_dir_removename(
>  	else
>  		rval = xfs_dir2_node_removename(args);
>  out_free:
> -	kmem_free(args);
> +	kfree(args);
>  	return rval;
>  }
>  
> @@ -538,7 +538,7 @@ xfs_dir_replace(
>  	else
>  		rval = xfs_dir2_node_replace(args);
>  out_free:
> -	kmem_free(args);
> +	kfree(args);
>  	return rval;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 506c65caaec5..fde46081a824 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -1253,7 +1253,7 @@ xfs_dir2_sf_to_block(
>  			sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep);
>  	}
>  	/* Done with the temporary buffer */
> -	kmem_free(sfp);
> +	kfree(sfp);
>  	/*
>  	 * Sort the leaf entries by hash value.
>  	 */
> @@ -1268,6 +1268,6 @@ xfs_dir2_sf_to_block(
>  	xfs_dir3_data_check(dp, bp);
>  	return 0;
>  out_free:
> -	kmem_free(sfp);
> +	kfree(sfp);
>  	return error;
>  }
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index 7b1f41cff9e0..17a20384c8b7 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -350,7 +350,7 @@ xfs_dir2_block_to_sf(
>  	xfs_dir2_sf_check(args);
>  out:
>  	xfs_trans_log_inode(args->trans, dp, logflags);
> -	kmem_free(sfp);
> +	kfree(sfp);
>  	return error;
>  }
>  
> @@ -576,7 +576,7 @@ xfs_dir2_sf_addname_hard(
>  		sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep);
>  		memcpy(sfep, oldsfep, old_isize - nbytes);
>  	}
> -	kmem_free(buf);
> +	kfree(buf);
>  	dp->i_disk_size = new_isize;
>  	xfs_dir2_sf_check(args);
>  }
> @@ -1190,7 +1190,7 @@ xfs_dir2_sf_toino4(
>  	/*
>  	 * Clean up the inode.
>  	 */
> -	kmem_free(buf);
> +	kfree(buf);
>  	dp->i_disk_size = newsize;
>  	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_DDATA);
>  }
> @@ -1262,7 +1262,7 @@ xfs_dir2_sf_toino8(
>  	/*
>  	 * Clean up the inode.
>  	 */
> -	kmem_free(buf);
> +	kfree(buf);
>  	dp->i_disk_size = newsize;
>  	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_DDATA);
>  }
> diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
> index 4522f3c7a23f..16f18b08fe4c 100644
> --- a/fs/xfs/libxfs/xfs_iext_tree.c
> +++ b/fs/xfs/libxfs/xfs_iext_tree.c
> @@ -747,7 +747,7 @@ xfs_iext_remove_node(
>  again:
>  	ASSERT(node->ptrs[pos]);
>  	ASSERT(node->ptrs[pos] == victim);
> -	kmem_free(victim);
> +	kfree(victim);
>  
>  	nr_entries = xfs_iext_node_nr_entries(node, pos) - 1;
>  	offset = node->keys[0];
> @@ -793,7 +793,7 @@ xfs_iext_remove_node(
>  		ASSERT(node == ifp->if_data);
>  		ifp->if_data = node->ptrs[0];
>  		ifp->if_height--;
> -		kmem_free(node);
> +		kfree(node);
>  	}
>  }
>  
> @@ -867,7 +867,7 @@ xfs_iext_free_last_leaf(
>  	struct xfs_ifork	*ifp)
>  {
>  	ifp->if_height--;
> -	kmem_free(ifp->if_data);
> +	kfree(ifp->if_data);
>  	ifp->if_data = NULL;
>  }
>  
> @@ -1048,7 +1048,7 @@ xfs_iext_destroy_node(
>  		}
>  	}
>  
> -	kmem_free(node);
> +	kfree(node);
>  }
>  
>  void
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index f3cf7f933e15..f6d5b86b608d 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -471,7 +471,7 @@ xfs_iroot_realloc(
>  						     (int)new_size);
>  		memcpy(np, op, new_max * (uint)sizeof(xfs_fsblock_t));
>  	}
> -	kmem_free(ifp->if_broot);
> +	kfree(ifp->if_broot);
>  	ifp->if_broot = new_broot;
>  	ifp->if_broot_bytes = (int)new_size;
>  	if (ifp->if_broot)
> @@ -525,13 +525,13 @@ xfs_idestroy_fork(
>  	struct xfs_ifork	*ifp)
>  {
>  	if (ifp->if_broot != NULL) {
> -		kmem_free(ifp->if_broot);
> +		kfree(ifp->if_broot);
>  		ifp->if_broot = NULL;
>  	}
>  
>  	switch (ifp->if_format) {
>  	case XFS_DINODE_FMT_LOCAL:
> -		kmem_free(ifp->if_data);
> +		kfree(ifp->if_data);
>  		ifp->if_data = NULL;
>  		break;
>  	case XFS_DINODE_FMT_EXTENTS:
> diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
> index 1e82c727af8e..4de3f0f40f48 100644
> --- a/fs/xfs/scrub/cow_repair.c
> +++ b/fs/xfs/scrub/cow_repair.c
> @@ -609,6 +609,6 @@ xrep_bmap_cow(
>  out_bitmap:
>  	xfsb_bitmap_destroy(&xc->old_cowfork_fsblocks);
>  	xoff_bitmap_destroy(&xc->bad_fileoffs);
> -	kmem_free(xc);
> +	kfree(xc);
>  	return error;
>  }
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index f7ba80d575d4..2a142cefdc3d 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -386,7 +386,7 @@ xfs_attr_free_item(
>  		xfs_da_state_free(attr->xattri_da_state);
>  	xfs_attri_log_nameval_put(attr->xattri_nameval);
>  	if (attr->xattri_da_args->op_flags & XFS_DA_OP_RECOVERY)
> -		kmem_free(attr);
> +		kfree(attr);
>  	else
>  		kmem_cache_free(xfs_attr_intent_cache, attr);
>  }
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 5f7a44d21cc9..0318d768520a 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -124,7 +124,7 @@ xfs_attr_shortform_list(
>  					     XFS_ERRLEVEL_LOW,
>  					     context->dp->i_mount, sfe,
>  					     sizeof(*sfe));
> -			kmem_free(sbuf);
> +			kfree(sbuf);
>  			return -EFSCORRUPTED;
>  		}
>  
> @@ -188,7 +188,7 @@ xfs_attr_shortform_list(
>  		cursor->offset++;
>  	}
>  out:
> -	kmem_free(sbuf);
> +	kfree(sbuf);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index c348af806616..a09ffbbb0dda 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -204,7 +204,7 @@ xfs_buf_free_maps(
>  	struct xfs_buf	*bp)
>  {
>  	if (bp->b_maps != &bp->__b_map) {
> -		kmem_free(bp->b_maps);
> +		kfree(bp->b_maps);
>  		bp->b_maps = NULL;
>  	}
>  }
> @@ -289,7 +289,7 @@ xfs_buf_free_pages(
>  	mm_account_reclaimed_pages(bp->b_page_count);
>  
>  	if (bp->b_pages != bp->b_page_array)
> -		kmem_free(bp->b_pages);
> +		kfree(bp->b_pages);
>  	bp->b_pages = NULL;
>  	bp->b_flags &= ~_XBF_PAGES;
>  }
> @@ -315,7 +315,7 @@ xfs_buf_free(
>  	if (bp->b_flags & _XBF_PAGES)
>  		xfs_buf_free_pages(bp);
>  	else if (bp->b_flags & _XBF_KMEM)
> -		kmem_free(bp->b_addr);
> +		kfree(bp->b_addr);
>  
>  	call_rcu(&bp->b_rcu, xfs_buf_free_callback);
>  }
> @@ -339,7 +339,7 @@ xfs_buf_alloc_kmem(
>  	if (((unsigned long)(bp->b_addr + size - 1) & PAGE_MASK) !=
>  	    ((unsigned long)bp->b_addr & PAGE_MASK)) {
>  		/* b_addr spans two pages - use alloc_page instead */
> -		kmem_free(bp->b_addr);
> +		kfree(bp->b_addr);
>  		bp->b_addr = NULL;
>  		return -ENOMEM;
>  	}
> @@ -1953,7 +1953,7 @@ xfs_free_buftarg(
>  	if (btp->bt_bdev != btp->bt_mount->m_super->s_bdev)
>  		bdev_release(btp->bt_bdev_handle);
>  
> -	kmem_free(btp);
> +	kfree(btp);
>  }
>  
>  int
> @@ -2045,7 +2045,7 @@ xfs_alloc_buftarg(
>  error_lru:
>  	list_lru_destroy(&btp->bt_lru);
>  error_free:
> -	kmem_free(btp);
> +	kfree(btp);
>  	return NULL;
>  }
>  
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 545040c6ae87..43031842341a 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -814,7 +814,7 @@ xfs_buf_item_free_format(
>  	struct xfs_buf_log_item	*bip)
>  {
>  	if (bip->bli_formats != &bip->__bli_format) {
> -		kmem_free(bip->bli_formats);
> +		kfree(bip->bli_formats);
>  		bip->bli_formats = NULL;
>  	}
>  }
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index 34776f4c05ac..09e893cf563c 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -129,7 +129,7 @@ xlog_put_buffer_cancelled(
>  
>  	if (--bcp->bc_refcount == 0) {
>  		list_del(&bcp->bc_list);
> -		kmem_free(bcp);
> +		kfree(bcp);
>  	}
>  	return true;
>  }
> @@ -1062,10 +1062,10 @@ xlog_free_buf_cancel_table(
>  				&log->l_buf_cancel_table[i],
>  				struct xfs_buf_cancel, bc_list))) {
>  			list_del(&bc->bc_list);
> -			kmem_free(bc);
> +			kfree(bc);
>  		}
>  	}
>  
> -	kmem_free(log->l_buf_cancel_table);
> +	kfree(log->l_buf_cancel_table);
>  	log->l_buf_cancel_table = NULL;
>  }
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index d5787991bb5b..8539f5c9a774 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -79,7 +79,7 @@ xfs_discard_endio_work(
>  		container_of(work, struct xfs_busy_extents, endio_work);
>  
>  	xfs_extent_busy_clear(extents->mount, &extents->extent_list, false);
> -	kmem_free(extents->owner);
> +	kfree(extents->owner);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 456520d60cd0..7ad0e92c6b5b 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -248,7 +248,7 @@ xfs_errortag_init(
>  	ret = xfs_sysfs_init(&mp->m_errortag_kobj, &xfs_errortag_ktype,
>  				&mp->m_kobj, "errortag");
>  	if (ret)
> -		kmem_free(mp->m_errortag);
> +		kfree(mp->m_errortag);
>  	return ret;
>  }
>  
> @@ -257,7 +257,7 @@ xfs_errortag_del(
>  	struct xfs_mount	*mp)
>  {
>  	xfs_sysfs_del(&mp->m_errortag_kobj);
> -	kmem_free(mp->m_errortag);
> +	kfree(mp->m_errortag);
>  }
>  
>  static bool
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index b90c3dd43e03..56cfa1498571 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -531,7 +531,7 @@ xfs_extent_busy_clear_one(
>  	}
>  
>  	list_del_init(&busyp->list);
> -	kmem_free(busyp);
> +	kfree(busyp);
>  }
>  
>  static void
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 6062703a2723..8c382f092332 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -42,7 +42,7 @@ xfs_efi_item_free(
>  {
>  	kvfree(efip->efi_item.li_lv_shadow);
>  	if (efip->efi_format.efi_nextents > XFS_EFI_MAX_FAST_EXTENTS)
> -		kmem_free(efip);
> +		kfree(efip);
>  	else
>  		kmem_cache_free(xfs_efi_cache, efip);
>  }
> @@ -231,7 +231,7 @@ xfs_efd_item_free(struct xfs_efd_log_item *efdp)
>  {
>  	kvfree(efdp->efd_item.li_lv_shadow);
>  	if (efdp->efd_format.efd_nextents > XFS_EFD_MAX_FAST_EXTENTS)
> -		kmem_free(efdp);
> +		kfree(efdp);
>  	else
>  		kmem_cache_free(xfs_efd_cache, efdp);
>  }
> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index e2a3c8d3fe4f..e3aaa0555597 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
> @@ -44,7 +44,7 @@ xfs_fstrm_free_func(
>  	atomic_dec(&pag->pagf_fstrms);
>  	xfs_perag_rele(pag);
>  
> -	kmem_free(item);
> +	kfree(item);
>  }
>  
>  /*
> @@ -326,7 +326,7 @@ xfs_filestream_create_association(
>  
>  out_free_item:
>  	xfs_perag_rele(item->pag);
> -	kmem_free(item);
> +	kfree(item);
>  out_put_fstrms:
>  	atomic_dec(&args->pag->pagf_fstrms);
>  	return 0;
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 1fd94958aa97..37ec247edc13 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -671,7 +671,7 @@ xfs_lookup(
>  
>  out_free_name:
>  	if (ci_name)
> -		kmem_free(ci_name->name);
> +		kfree(ci_name->name);
>  out_unlock:
>  	*ipp = NULL;
>  	return error;
> @@ -2378,7 +2378,7 @@ xfs_ifree(
>  	 * already been freed by xfs_attr_inactive.
>  	 */
>  	if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
> -		kmem_free(ip->i_df.if_data);
> +		kfree(ip->i_df.if_data);
>  		ip->i_df.if_data = NULL;
>  		ip->i_df.if_bytes = 0;
>  	}
> diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> index 5d7b937179a0..dbdab4ce7c44 100644
> --- a/fs/xfs/xfs_inode_item_recover.c
> +++ b/fs/xfs/xfs_inode_item_recover.c
> @@ -554,7 +554,7 @@ xlog_recover_inode_commit_pass2(
>  	xfs_buf_relse(bp);
>  error:
>  	if (need_free)
> -		kmem_free(in_f);
> +		kfree(in_f);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 45fb169bd819..7eeebcb6b925 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -435,7 +435,7 @@ xfs_ioc_attr_list(
>  	    copy_to_user(ucursor, &context.cursor, sizeof(context.cursor)))
>  		error = -EFAULT;
>  out_free:
> -	kmem_free(buffer);
> +	kfree(buffer);
>  	return error;
>  }
>  
> @@ -1506,7 +1506,7 @@ xfs_ioc_getbmap(
>  
>  	error = 0;
>  out_free_buf:
> -	kmem_free(buf);
> +	kfree(buf);
>  	return error;
>  }
>  
> @@ -1636,7 +1636,7 @@ xfs_ioc_getfsmap(
>  	}
>  
>  out_free:
> -	kmem_free(recs);
> +	kfree(recs);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index a0d77f5f512e..be102fd49560 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -346,7 +346,7 @@ xfs_vn_ci_lookup(
>  	dname.name = ci_name.name;
>  	dname.len = ci_name.len;
>  	dentry = d_add_ci(dentry, VFS_I(ip), &dname);
> -	kmem_free(ci_name.name);
> +	kfree(ci_name.name);
>  	return dentry;
>  }
>  
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 14211174267a..95fc31b9f87d 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -214,7 +214,7 @@ xfs_bulkstat_one(
>  			breq->startino, &bc);
>  	xfs_trans_cancel(tp);
>  out:
> -	kmem_free(bc.buf);
> +	kfree(bc.buf);
>  
>  	/*
>  	 * If we reported one inode to userspace then we abort because we hit
> @@ -309,7 +309,7 @@ xfs_bulkstat(
>  			xfs_bulkstat_iwalk, breq->icount, &bc);
>  	xfs_trans_cancel(tp);
>  out:
> -	kmem_free(bc.buf);
> +	kfree(bc.buf);
>  
>  	/*
>  	 * We found some inodes, so clear the error status and return them.
> diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
> index 5dd622aa54c5..6d2eb6364867 100644
> --- a/fs/xfs/xfs_iwalk.c
> +++ b/fs/xfs/xfs_iwalk.c
> @@ -172,7 +172,7 @@ STATIC void
>  xfs_iwalk_free(
>  	struct xfs_iwalk_ag	*iwag)
>  {
> -	kmem_free(iwag->recs);
> +	kfree(iwag->recs);
>  	iwag->recs = NULL;
>  }
>  
> @@ -627,7 +627,7 @@ xfs_iwalk_ag_work(
>  	xfs_iwalk_free(iwag);
>  out:
>  	xfs_perag_put(iwag->pag);
> -	kmem_free(iwag);
> +	kfree(iwag);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index 666618b463c9..caccb7f76690 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -20,8 +20,6 @@ typedef __u32			xfs_dev_t;
>  typedef __u32			xfs_nlink_t;
>  
>  #include "xfs_types.h"
> -
> -#include "kmem.h"
>  #include "mrlock.h"
>  
>  #include <linux/semaphore.h>
> @@ -30,6 +28,7 @@ typedef __u32			xfs_nlink_t;
>  #include <linux/kernel.h>
>  #include <linux/blkdev.h>
>  #include <linux/slab.h>
> +#include <linux/vmalloc.h>
>  #include <linux/crc32c.h>
>  #include <linux/module.h>
>  #include <linux/mutex.h>
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 0009ffbec932..ee39639bb92b 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1663,12 +1663,12 @@ xlog_alloc_log(
>  	for (iclog = log->l_iclog; iclog; iclog = prev_iclog) {
>  		prev_iclog = iclog->ic_next;
>  		kvfree(iclog->ic_data);
> -		kmem_free(iclog);
> +		kfree(iclog);
>  		if (prev_iclog == log->l_iclog)
>  			break;
>  	}
>  out_free_log:
> -	kmem_free(log);
> +	kfree(log);
>  out:
>  	return ERR_PTR(error);
>  }	/* xlog_alloc_log */
> @@ -2120,13 +2120,13 @@ xlog_dealloc_log(
>  	for (i = 0; i < log->l_iclog_bufs; i++) {
>  		next_iclog = iclog->ic_next;
>  		kvfree(iclog->ic_data);
> -		kmem_free(iclog);
> +		kfree(iclog);
>  		iclog = next_iclog;
>  	}
>  
>  	log->l_mp->m_log = NULL;
>  	destroy_workqueue(log->l_ioend_workqueue);
> -	kmem_free(log);
> +	kfree(log);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 2c0512916cc9..815a2181004c 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -703,7 +703,7 @@ xlog_cil_free_logvec(
>  	while (!list_empty(lv_chain)) {
>  		lv = list_first_entry(lv_chain, struct xfs_log_vec, lv_list);
>  		list_del_init(&lv->lv_list);
> -		kmem_free(lv);
> +		kfree(lv);
>  	}
>  }
>  
> @@ -753,7 +753,7 @@ xlog_cil_committed(
>  		return;
>  	}
>  
> -	kmem_free(ctx);
> +	kfree(ctx);
>  }
>  
>  void
> @@ -1339,7 +1339,7 @@ xlog_cil_push_work(
>  out_skip:
>  	up_write(&cil->xc_ctx_lock);
>  	xfs_log_ticket_put(new_ctx->ticket);
> -	kmem_free(new_ctx);
> +	kfree(new_ctx);
>  	return;
>  
>  out_abort_free_ticket:
> @@ -1533,7 +1533,7 @@ xlog_cil_process_intents(
>  		set_bit(XFS_LI_WHITEOUT, &ilip->li_flags);
>  		trace_xfs_cil_whiteout_mark(ilip);
>  		len += ilip->li_lv->lv_bytes;
> -		kmem_free(ilip->li_lv);
> +		kfree(ilip->li_lv);
>  		ilip->li_lv = NULL;
>  
>  		xfs_trans_del_item(lip);
> @@ -1786,7 +1786,7 @@ xlog_cil_init(
>  out_destroy_wq:
>  	destroy_workqueue(cil->xc_push_wq);
>  out_destroy_cil:
> -	kmem_free(cil);
> +	kfree(cil);
>  	return -ENOMEM;
>  }
>  
> @@ -1799,12 +1799,12 @@ xlog_cil_destroy(
>  	if (cil->xc_ctx) {
>  		if (cil->xc_ctx->ticket)
>  			xfs_log_ticket_put(cil->xc_ctx->ticket);
> -		kmem_free(cil->xc_ctx);
> +		kfree(cil->xc_ctx);
>  	}
>  
>  	ASSERT(test_bit(XLOG_CIL_EMPTY, &cil->xc_flags));
>  	free_percpu(cil->xc_pcp);
>  	destroy_workqueue(cil->xc_push_wq);
> -	kmem_free(cil);
> +	kfree(cil);
>  }
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 295306ef6959..e9ed43a833af 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2229,11 +2229,11 @@ xlog_recover_free_trans(
>  		for (i = 0; i < item->ri_cnt; i++)
>  			kvfree(item->ri_buf[i].i_addr);
>  		/* Free the item itself */
> -		kmem_free(item->ri_buf);
> -		kmem_free(item);
> +		kfree(item->ri_buf);
> +		kfree(item);
>  	}
>  	/* Free the transaction recover structure */
> -	kmem_free(trans);
> +	kfree(trans);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index aabb25dc3efa..7328034d42ed 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -45,7 +45,7 @@ xfs_uuid_table_free(void)
>  {
>  	if (xfs_uuid_table_size == 0)
>  		return;
> -	kmem_free(xfs_uuid_table);
> +	kfree(xfs_uuid_table);
>  	xfs_uuid_table = NULL;
>  	xfs_uuid_table_size = 0;
>  }
> diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
> index feae3115617b..ce496704748d 100644
> --- a/fs/xfs/xfs_mru_cache.c
> +++ b/fs/xfs/xfs_mru_cache.c
> @@ -365,9 +365,9 @@ xfs_mru_cache_create(
>  
>  exit:
>  	if (err && mru && mru->lists)
> -		kmem_free(mru->lists);
> +		kfree(mru->lists);
>  	if (err && mru)
> -		kmem_free(mru);
> +		kfree(mru);
>  
>  	return err;
>  }
> @@ -407,8 +407,8 @@ xfs_mru_cache_destroy(
>  
>  	xfs_mru_cache_flush(mru);
>  
> -	kmem_free(mru->lists);
> -	kmem_free(mru);
> +	kfree(mru->lists);
> +	kfree(mru);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index b130bf49013b..46a7fe70e57e 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -701,7 +701,7 @@ xfs_qm_init_quotainfo(
>  out_free_lru:
>  	list_lru_destroy(&qinf->qi_lru);
>  out_free_qinf:
> -	kmem_free(qinf);
> +	kfree(qinf);
>  	mp->m_quotainfo = NULL;
>  	return error;
>  }
> @@ -725,7 +725,7 @@ xfs_qm_destroy_quotainfo(
>  	xfs_qm_destroy_quotainos(qi);
>  	mutex_destroy(&qi->qi_tree_lock);
>  	mutex_destroy(&qi->qi_quotaofflock);
> -	kmem_free(qi);
> +	kfree(qi);
>  	mp->m_quotainfo = NULL;
>  }
>  
> @@ -1060,7 +1060,7 @@ xfs_qm_reset_dqcounts_buf(
>  	} while (nmaps > 0);
>  
>  out:
> -	kmem_free(map);
> +	kfree(map);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index a9b322e23cfb..d850b9685f7f 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -38,7 +38,7 @@ xfs_cui_item_free(
>  {
>  	kvfree(cuip->cui_item.li_lv_shadow);
>  	if (cuip->cui_format.cui_nextents > XFS_CUI_MAX_FAST_EXTENTS)
> -		kmem_free(cuip);
> +		kfree(cuip);
>  	else
>  		kmem_cache_free(xfs_cui_cache, cuip);
>  }
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 489ca8c0e1dc..a40b92ac81e8 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -38,7 +38,7 @@ xfs_rui_item_free(
>  {
>  	kvfree(ruip->rui_item.li_lv_shadow);
>  	if (ruip->rui_format.rui_nextents > XFS_RUI_MAX_FAST_EXTENTS)
> -		kmem_free(ruip);
> +		kfree(ruip);
>  	else
>  		kmem_cache_free(xfs_rui_cache, ruip);
>  }
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 57ed9baaf156..2f85567f3d75 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1050,7 +1050,7 @@ xfs_growfs_rt(
>  	/*
>  	 * Free the fake mp structure.
>  	 */
> -	kmem_free(nmp);
> +	kfree(nmp);
>  
>  	/*
>  	 * If we had to allocate a new rsum_cache, we either need to free the
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 7b1b29814be2..96cb00e94551 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -773,7 +773,7 @@ xfs_mount_free(
>  	debugfs_remove(mp->m_debugfs);
>  	kfree(mp->m_rtname);
>  	kfree(mp->m_logname);
> -	kmem_free(mp);
> +	kfree(mp);
>  }
>  
>  STATIC int
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 5f206cdb40ff..e4c343096f95 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -922,7 +922,7 @@ xfs_trans_ail_init(
>  	return 0;
>  
>  out_free_ailp:
> -	kmem_free(ailp);
> +	kfree(ailp);
>  	return -ENOMEM;
>  }
>  
> @@ -933,5 +933,5 @@ xfs_trans_ail_destroy(
>  	struct xfs_ail	*ailp = mp->m_ail;
>  
>  	kthread_stop(ailp->ail_task);
> -	kmem_free(ailp);
> +	kfree(ailp);
>  }
> -- 
> 2.43.0
> 
> 
