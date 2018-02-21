Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f178.google.com ([209.85.128.178]:39269 "EHLO
        mail-wr0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751641AbeBUMJo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Feb 2018 07:09:44 -0500
Received: by mail-wr0-f178.google.com with SMTP id w77so3814247wrc.6
        for <linux-xfs@vger.kernel.org>; Wed, 21 Feb 2018 04:09:43 -0800 (PST)
Date: Wed, 21 Feb 2018 13:09:34 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH V2] Cleanup old XFS_BTREE_* traces
Message-ID: <20180221120934.5jwgv3dis7ipwned@odin.usersys.redhat.com>
References: <20180219071704.15380-1-cmaiolino@redhat.com>
 <20180220164919.GE27629@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180220164919.GE27629@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

> >  /*
> > @@ -1464,15 +1460,12 @@ xfs_btree_log_recs(
> >  	int			first,
> >  	int			last)
> >  {
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> > -	XFS_BTREE_TRACE_ARGBII(cur, bp, first, last);
> >  
> 
> There's a bunch of these where blank lines are left immediately before
> or after the curly brace.  If you have reason to send a v3 please clean
> these up, otherwise I'll just fix them on their way in.
> 

Hi.

Yeah, I tried to be careful by removing unneeded blank lines, but looks like I
missed a few.

I have no reason to send a V3 of this, so if you want to clean it up before
applying, I'm fine with that.

I can send a V3 fixing up these blank lines if you want though, just let me
know.

> Will test,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D
> 
> >  	xfs_trans_buf_set_type(cur->bc_tp, bp, XFS_BLFT_BTREE_BUF);
> >  	xfs_trans_log_buf(cur->bc_tp, bp,
> >  			  xfs_btree_rec_offset(cur, first),
> >  			  xfs_btree_rec_offset(cur, last + 1) - 1);
> >  
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  }
> >  
> >  /*
> > @@ -1485,8 +1478,6 @@ xfs_btree_log_ptrs(
> >  	int			first,	/* index of first pointer to log */
> >  	int			last)	/* index of last pointer to log */
> >  {
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> > -	XFS_BTREE_TRACE_ARGBII(cur, bp, first, last);
> >  
> >  	if (bp) {
> >  		struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
> > @@ -1501,7 +1492,6 @@ xfs_btree_log_ptrs(
> >  			xfs_ilog_fbroot(cur->bc_private.b.whichfork));
> >  	}
> >  
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  }
> >  
> >  /*
> > @@ -1543,9 +1533,6 @@ xfs_btree_log_block(
> >  		XFS_BTREE_LBLOCK_CRC_LEN
> >  	};
> >  
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> > -	XFS_BTREE_TRACE_ARGBI(cur, bp, fields);
> > -
> >  	if (bp) {
> >  		int nbits;
> >  
> > @@ -1573,8 +1560,6 @@ xfs_btree_log_block(
> >  		xfs_trans_log_inode(cur->bc_tp, cur->bc_private.b.ip,
> >  			xfs_ilog_fbroot(cur->bc_private.b.whichfork));
> >  	}
> > -
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  }
> >  
> >  /*
> > @@ -1593,9 +1578,6 @@ xfs_btree_increment(
> >  	int			error;		/* error return value */
> >  	int			lev;
> >  
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> > -	XFS_BTREE_TRACE_ARGI(cur, level);
> > -
> >  	ASSERT(level < cur->bc_nlevels);
> >  
> >  	/* Read-ahead to the right at this level. */
> > @@ -1671,17 +1653,14 @@ xfs_btree_increment(
> >  		cur->bc_ptrs[lev] = 1;
> >  	}
> >  out1:
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  	*stat = 1;
> >  	return 0;
> >  
> >  out0:
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  	*stat = 0;
> >  	return 0;
> >  
> >  error0:
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
> >  	return error;
> >  }
> >  
> > @@ -1701,9 +1680,6 @@ xfs_btree_decrement(
> >  	int			lev;
> >  	union xfs_btree_ptr	ptr;
> >  
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> > -	XFS_BTREE_TRACE_ARGI(cur, level);
> > -
> >  	ASSERT(level < cur->bc_nlevels);
> >  
> >  	/* Read-ahead to the left at this level. */
> > @@ -1769,17 +1745,14 @@ xfs_btree_decrement(
> >  		cur->bc_ptrs[lev] = xfs_btree_get_numrecs(block);
> >  	}
> >  out1:
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  	*stat = 1;
> >  	return 0;
> >  
> >  out0:
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  	*stat = 0;
> >  	return 0;
> >  
> >  error0:
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
> >  	return error;
> >  }
> >  
> > @@ -1881,9 +1854,6 @@ xfs_btree_lookup(
> >  	union xfs_btree_ptr	*pp;	/* ptr to btree block */
> >  	union xfs_btree_ptr	ptr;	/* ptr to btree block */
> >  
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> > -	XFS_BTREE_TRACE_ARGI(cur, dir);
> > -
> >  	XFS_BTREE_STATS_INC(cur, lookup);
> >  
> >  	/* No such thing as a zero-level tree. */
> > @@ -1929,7 +1899,6 @@ xfs_btree_lookup(
> >  				ASSERT(level == 0 && cur->bc_nlevels == 1);
> >  
> >  				cur->bc_ptrs[0] = dir != XFS_LOOKUP_LE;
> > -				XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  				*stat = 0;
> >  				return 0;
> >  			}
> > @@ -2004,7 +1973,6 @@ xfs_btree_lookup(
> >  			if (error)
> >  				goto error0;
> >  			XFS_WANT_CORRUPTED_RETURN(cur->bc_mp, i == 1);
> > -			XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  			*stat = 1;
> >  			return 0;
> >  		}
> > @@ -2019,11 +1987,9 @@ xfs_btree_lookup(
> >  		*stat = 1;
> >  	else
> >  		*stat = 0;
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  	return 0;
> >  
> >  error0:
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
> >  	return error;
> >  }
> >  
> > @@ -2169,10 +2135,8 @@ __xfs_btree_updkeys(
> >  		trace_xfs_btree_updkeys(cur, level, bp);
> >  #ifdef DEBUG
> >  		error = xfs_btree_check_block(cur, block, level, bp);
> > -		if (error) {
> > -			XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
> > +		if (error)
> >  			return error;
> > -		}
> >  #endif
> >  		ptr = cur->bc_ptrs[level];
> >  		nlkey = xfs_btree_key_addr(cur, ptr, block);
> > @@ -2224,9 +2188,6 @@ xfs_btree_update_keys(
> >  	if (cur->bc_flags & XFS_BTREE_OVERLAPPING)
> >  		return __xfs_btree_updkeys(cur, level, block, bp, false);
> >  
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> > -	XFS_BTREE_TRACE_ARGIK(cur, level, keyp);
> > -
> >  	/*
> >  	 * Go up the tree from this level toward the root.
> >  	 * At each level, update the key value to the value input.
> > @@ -2241,10 +2202,8 @@ xfs_btree_update_keys(
> >  		block = xfs_btree_get_block(cur, level, &bp);
> >  #ifdef DEBUG
> >  		error = xfs_btree_check_block(cur, block, level, bp);
> > -		if (error) {
> > -			XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
> > +		if (error)
> >  			return error;
> > -		}
> >  #endif
> >  		ptr = cur->bc_ptrs[level];
> >  		kp = xfs_btree_key_addr(cur, ptr, block);
> > @@ -2252,7 +2211,6 @@ xfs_btree_update_keys(
> >  		xfs_btree_log_keys(cur, bp, ptr, ptr);
> >  	}
> >  
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  	return 0;
> >  }
> >  
> > @@ -2272,9 +2230,6 @@ xfs_btree_update(
> >  	int			ptr;
> >  	union xfs_btree_rec	*rp;
> >  
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> > -	XFS_BTREE_TRACE_ARGR(cur, rec);
> > -
> >  	/* Pick up the current block. */
> >  	block = xfs_btree_get_block(cur, 0, &bp);
> >  
> > @@ -2307,11 +2262,9 @@ xfs_btree_update(
> >  			goto error0;
> >  	}
> >  
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  	return 0;
> >  
> >  error0:
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
> >  	return error;
> >  }
> >  
> > @@ -2339,9 +2292,6 @@ xfs_btree_lshift(
> >  	int			error;		/* error return value */
> >  	int			i;
> >  
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> > -	XFS_BTREE_TRACE_ARGI(cur, level);
> > -
> >  	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
> >  	    level == cur->bc_nlevels - 1)
> >  		goto out0;
> > @@ -2500,21 +2450,17 @@ xfs_btree_lshift(
> >  	/* Slide the cursor value left one. */
> >  	cur->bc_ptrs[level]--;
> >  
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  	*stat = 1;
> >  	return 0;
> >  
> >  out0:
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  	*stat = 0;
> >  	return 0;
> >  
> >  error0:
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
> >  	return error;
> >  
> >  error1:
> > -	XFS_BTREE_TRACE_CURSOR(tcur, XBT_ERROR);
> >  	xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR);
> >  	return error;
> >  }
> > @@ -2541,9 +2487,6 @@ xfs_btree_rshift(
> >  	int			error;		/* error return value */
> >  	int			i;		/* loop counter */
> >  
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> > -	XFS_BTREE_TRACE_ARGI(cur, level);
> > -
> >  	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
> >  	    (level == cur->bc_nlevels - 1))
> >  		goto out0;
> > @@ -2676,21 +2619,17 @@ xfs_btree_rshift(
> >  
> >  	xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
> >  
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  	*stat = 1;
> >  	return 0;
> >  
> >  out0:
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  	*stat = 0;
> >  	return 0;
> >  
> >  error0:
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
> >  	return error;
> >  
> >  error1:
> > -	XFS_BTREE_TRACE_CURSOR(tcur, XBT_ERROR);
> >  	xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR);
> >  	return error;
> >  }
> > @@ -2726,9 +2665,6 @@ __xfs_btree_split(
> >  	int			i;
> >  #endif
> >  
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> > -	XFS_BTREE_TRACE_ARGIPK(cur, level, *ptrp, key);
> > -
> >  	XFS_BTREE_STATS_INC(cur, split);
> >  
> >  	/* Set up left block (current one). */
> > @@ -2878,16 +2814,13 @@ __xfs_btree_split(
> >  		(*curp)->bc_ptrs[level + 1]++;
> >  	}
> >  	*ptrp = rptr;
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  	*stat = 1;
> >  	return 0;
> >  out0:
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  	*stat = 0;
> >  	return 0;
> >  
> >  error0:
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
> >  	return error;
> >  }
> >  
> > @@ -2994,7 +2927,6 @@ xfs_btree_new_iroot(
> >  	int			i;		/* loop counter */
> >  #endif
> >  
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> >  	XFS_BTREE_STATS_INC(cur, newroot);
> >  
> >  	ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
> > @@ -3008,10 +2940,9 @@ xfs_btree_new_iroot(
> >  	error = cur->bc_ops->alloc_block(cur, pp, &nptr, stat);
> >  	if (error)
> >  		goto error0;
> > -	if (*stat == 0) {
> > -		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> > +	if (*stat == 0)
> >  		return 0;
> > -	}
> > +
> >  	XFS_BTREE_STATS_INC(cur, alloc);
> >  
> >  	/* Copy the root into a real block. */
> > @@ -3074,10 +3005,8 @@ xfs_btree_new_iroot(
> >  	*logflags |=
> >  		XFS_ILOG_CORE | xfs_ilog_fbroot(cur->bc_private.b.whichfork);
> >  	*stat = 1;
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  	return 0;
> >  error0:
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
> >  	return error;
> >  }
> >  
> > @@ -3102,7 +3031,6 @@ xfs_btree_new_root(
> >  	union xfs_btree_ptr	rptr;
> >  	union xfs_btree_ptr	lptr;
> >  
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> >  	XFS_BTREE_STATS_INC(cur, newroot);
> >  
> >  	/* initialise our start point from the cursor */
> > @@ -3202,14 +3130,11 @@ xfs_btree_new_root(
> >  	xfs_btree_setbuf(cur, cur->bc_nlevels, nbp);
> >  	cur->bc_ptrs[cur->bc_nlevels] = nptr;
> >  	cur->bc_nlevels++;
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  	*stat = 1;
> >  	return 0;
> >  error0:
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
> >  	return error;
> >  out0:
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  	*stat = 0;
> >  	return 0;
> >  }
> > @@ -3230,7 +3155,7 @@ xfs_btree_make_block_unfull(
> >  
> >  	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
> >  	    level == cur->bc_nlevels - 1) {
> > -	    	struct xfs_inode *ip = cur->bc_private.b.ip;
> > +		struct xfs_inode *ip = cur->bc_private.b.ip;
> >  
> >  		if (numrecs < cur->bc_ops->get_dmaxrecs(cur, level)) {
> >  			/* A root block that can be made bigger. */
> > @@ -3309,9 +3234,6 @@ xfs_btree_insrec(
> >  #endif
> >  	xfs_daddr_t		old_bn;
> >  
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> > -	XFS_BTREE_TRACE_ARGIPR(cur, level, *ptrp, &rec);
> > -
> >  	ncur = NULL;
> >  	lkey = &nkey;
> >  
> > @@ -3324,14 +3246,12 @@ xfs_btree_insrec(
> >  		error = xfs_btree_new_root(cur, stat);
> >  		xfs_btree_set_ptr_null(cur, ptrp);
> >  
> > -		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  		return error;
> >  	}
> >  
> >  	/* If we're off the left edge, return failure. */
> >  	ptr = cur->bc_ptrs[level];
> >  	if (ptr == 0) {
> > -		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  		*stat = 0;
> >  		return 0;
> >  	}
> > @@ -3489,12 +3409,10 @@ xfs_btree_insrec(
> >  		*curp = ncur;
> >  	}
> >  
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  	*stat = 1;
> >  	return 0;
> >  
> >  error0:
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
> >  	return error;
> >  }
> >  
> > @@ -3572,11 +3490,9 @@ xfs_btree_insert(
> >  		}
> >  	} while (!xfs_btree_ptr_is_null(cur, &nptr));
> >  
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  	*stat = i;
> >  	return 0;
> >  error0:
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
> >  	return error;
> >  }
> >  
> > @@ -3611,8 +3527,6 @@ xfs_btree_kill_iroot(
> >  	int			i;
> >  #endif
> >  
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> > -
> >  	ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
> >  	ASSERT(cur->bc_nlevels > 1);
> >  
> > @@ -3670,19 +3584,15 @@ xfs_btree_kill_iroot(
> >  #ifdef DEBUG
> >  	for (i = 0; i < numrecs; i++) {
> >  		error = xfs_btree_check_ptr(cur, cpp, i, level - 1);
> > -		if (error) {
> > -			XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
> > +		if (error)
> >  			return error;
> > -		}
> >  	}
> >  #endif
> >  	xfs_btree_copy_ptrs(cur, pp, cpp, numrecs);
> >  
> >  	error = xfs_btree_free_block(cur, cbp);
> > -	if (error) {
> > -		XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
> > +	if (error)
> >  		return error;
> > -	}
> >  
> >  	cur->bc_bufs[level - 1] = NULL;
> >  	be16_add_cpu(&block->bb_level, -1);
> > @@ -3690,7 +3600,6 @@ xfs_btree_kill_iroot(
> >  		XFS_ILOG_CORE | xfs_ilog_fbroot(cur->bc_private.b.whichfork));
> >  	cur->bc_nlevels--;
> >  out0:
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  	return 0;
> >  }
> >  
> > @@ -3706,7 +3615,6 @@ xfs_btree_kill_root(
> >  {
> >  	int			error;
> >  
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> >  	XFS_BTREE_STATS_INC(cur, killroot);
> >  
> >  	/*
> > @@ -3716,16 +3624,13 @@ xfs_btree_kill_root(
> >  	cur->bc_ops->set_root(cur, newroot, -1);
> >  
> >  	error = xfs_btree_free_block(cur, bp);
> > -	if (error) {
> > -		XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
> > +	if (error)
> >  		return error;
> > -	}
> >  
> >  	cur->bc_bufs[level] = NULL;
> >  	cur->bc_ra[level] = 0;
> >  	cur->bc_nlevels--;
> >  
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  	return 0;
> >  }
> >  
> > @@ -3744,7 +3649,6 @@ xfs_btree_dec_cursor(
> >  			return error;
> >  	}
> >  
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  	*stat = 1;
> >  	return 0;
> >  }
> > @@ -3780,15 +3684,11 @@ xfs_btree_delrec(
> >  	struct xfs_btree_cur	*tcur;		/* temporary btree cursor */
> >  	int			numrecs;	/* temporary numrec count */
> >  
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> > -	XFS_BTREE_TRACE_ARGI(cur, level);
> > -
> >  	tcur = NULL;
> >  
> >  	/* Get the index of the entry being deleted, check for nothing there. */
> >  	ptr = cur->bc_ptrs[level];
> >  	if (ptr == 0) {
> > -		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  		*stat = 0;
> >  		return 0;
> >  	}
> > @@ -3805,7 +3705,6 @@ xfs_btree_delrec(
> >  
> >  	/* Fail if we're off the end of the block. */
> >  	if (ptr > numrecs) {
> > -		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  		*stat = 0;
> >  		return 0;
> >  	}
> > @@ -4080,7 +3979,7 @@ xfs_btree_delrec(
> >  				tcur = NULL;
> >  				if (level == 0)
> >  					cur->bc_ptrs[0]++;
> > -				XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> > +
> >  				*stat = 1;
> >  				return 0;
> >  			}
> > @@ -4250,13 +4149,11 @@ xfs_btree_delrec(
> >  	 * call updkeys directly.
> >  	 */
> >  
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  	/* Return value means the next level up has something to do. */
> >  	*stat = 2;
> >  	return 0;
> >  
> >  error0:
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
> >  	if (tcur)
> >  		xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR);
> >  	return error;
> > @@ -4277,8 +4174,6 @@ xfs_btree_delete(
> >  	int			i;
> >  	bool			joined = false;
> >  
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> > -
> >  	/*
> >  	 * Go up the tree, starting at leaf level.
> >  	 *
> > @@ -4314,11 +4209,9 @@ xfs_btree_delete(
> >  		}
> >  	}
> >  
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  	*stat = i;
> >  	return 0;
> >  error0:
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
> >  	return error;
> >  }
> >  
> > diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> > index 50440b5618e8..58e30c0975c3 100644
> > --- a/fs/xfs/libxfs/xfs_btree.h
> > +++ b/fs/xfs/libxfs/xfs_btree.h
> > @@ -473,25 +473,6 @@ static inline int xfs_btree_get_level(struct xfs_btree_block *block)
> >  #define	XFS_FILBLKS_MIN(a,b)	min_t(xfs_filblks_t, (a), (b))
> >  #define	XFS_FILBLKS_MAX(a,b)	max_t(xfs_filblks_t, (a), (b))
> >  
> > -/*
> > - * Trace hooks.  Currently not implemented as they need to be ported
> > - * over to the generic tracing functionality, which is some effort.
> > - *
> > - * i,j = integer (32 bit)
> > - * b = btree block buffer (xfs_buf_t)
> > - * p = btree ptr
> > - * r = btree record
> > - * k = btree key
> > - */
> > -#define	XFS_BTREE_TRACE_ARGBI(c, b, i)
> > -#define	XFS_BTREE_TRACE_ARGBII(c, b, i, j)
> > -#define	XFS_BTREE_TRACE_ARGI(c, i)
> > -#define	XFS_BTREE_TRACE_ARGIPK(c, i, p, s)
> > -#define	XFS_BTREE_TRACE_ARGIPR(c, i, p, r)
> > -#define	XFS_BTREE_TRACE_ARGIK(c, i, k)
> > -#define XFS_BTREE_TRACE_ARGR(c, r)
> > -#define	XFS_BTREE_TRACE_CURSOR(c, t)
> > -
> >  xfs_failaddr_t xfs_btree_sblock_v5hdr_verify(struct xfs_buf *bp);
> >  xfs_failaddr_t xfs_btree_sblock_verify(struct xfs_buf *bp,
> >  		unsigned int max_recs);
> > diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > index af197a5f3a82..a2dd7f4a2719 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > @@ -93,8 +93,6 @@ __xfs_inobt_alloc_block(
> >  	int			error;		/* error return value */
> >  	xfs_agblock_t		sbno = be32_to_cpu(start->s);
> >  
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> > -
> >  	memset(&args, 0, sizeof(args));
> >  	args.tp = cur->bc_tp;
> >  	args.mp = cur->bc_mp;
> > @@ -107,17 +105,14 @@ __xfs_inobt_alloc_block(
> >  	args.resv = resv;
> >  
> >  	error = xfs_alloc_vextent(&args);
> > -	if (error) {
> > -		XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
> > +	if (error)
> >  		return error;
> > -	}
> > +
> >  	if (args.fsbno == NULLFSBLOCK) {
> > -		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  		*stat = 0;
> >  		return 0;
> >  	}
> >  	ASSERT(args.len == 1);
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  
> >  	new->s = cpu_to_be32(XFS_FSB_TO_AGBNO(args.mp, args.fsbno));
> >  	*stat = 1;
> > diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
> > index 8479769e470d..265fdcefcbae 100644
> > --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> > +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> > @@ -79,8 +79,6 @@ xfs_refcountbt_alloc_block(
> >  	struct xfs_alloc_arg	args;		/* block allocation args */
> >  	int			error;		/* error return value */
> >  
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> > -
> >  	memset(&args, 0, sizeof(args));
> >  	args.tp = cur->bc_tp;
> >  	args.mp = cur->bc_mp;
> > @@ -98,7 +96,6 @@ xfs_refcountbt_alloc_block(
> >  	trace_xfs_refcountbt_alloc_block(cur->bc_mp, cur->bc_private.a.agno,
> >  			args.agbno, 1);
> >  	if (args.fsbno == NULLFSBLOCK) {
> > -		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  		*stat = 0;
> >  		return 0;
> >  	}
> > @@ -109,12 +106,10 @@ xfs_refcountbt_alloc_block(
> >  	be32_add_cpu(&agf->agf_refcount_blocks, 1);
> >  	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_REFCOUNT_BLOCKS);
> >  
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  	*stat = 1;
> >  	return 0;
> >  
> >  out_error:
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
> >  	return error;
> >  }
> >  
> > diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> > index e829c3e489ea..738df3f9b5f2 100644
> > --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> > +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> > @@ -104,20 +104,15 @@ xfs_rmapbt_alloc_block(
> >  	int			error;
> >  	xfs_agblock_t		bno;
> >  
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> > -
> >  	/* Allocate the new block from the freelist. If we can't, give up.  */
> >  	error = xfs_alloc_get_freelist(cur->bc_tp, cur->bc_private.a.agbp,
> >  				       &bno, 1);
> > -	if (error) {
> > -		XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
> > +	if (error)
> >  		return error;
> > -	}
> >  
> >  	trace_xfs_rmapbt_alloc_block(cur->bc_mp, cur->bc_private.a.agno,
> >  			bno, 1);
> >  	if (bno == NULLAGBLOCK) {
> > -		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  		*stat = 0;
> >  		return 0;
> >  	}
> > @@ -130,7 +125,6 @@ xfs_rmapbt_alloc_block(
> >  	be32_add_cpu(&agf->agf_rmap_blocks, 1);
> >  	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_RMAP_BLOCKS);
> >  
> > -	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  	*stat = 1;
> >  	return 0;
> >  }
> > -- 
> > 2.14.3
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
