Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0D6426D10;
	Fri,  2 Oct 2026 16:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790958421; cv=none; b=Zmx8opYGfHAM+/7+oNRfmKP/fUOAWggiPWkwgI0rGn26nBw7ML8BJ0djRWIFCT20uE3HCERa9I5ltLdKHH5eCJtzZtYXruZKj3NxsYpki1T18b9LftqbX0KXEOLgkqfXEL0Pr83kM/8/M+cvTCVNmsYtrxiQyOO/Qwdgj1gruOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790958421; c=relaxed/simple;
	bh=8Is5bmPuJUXcMdg5fnuna+fD4bsQVE07bDwpE8v0CmE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F/gtf4uqt+AICTMwiJYj6+JiVs2+3ZRRsgsHlnmpw73FCI4YE5ffV0PycKMVoZPM7xoZQZYGOYXLqt824NEffo4V1WZqbJQnnmFVznraPqOdZ4Jsfs2otoMEKp8Xzx8ZQzoHjzbaNf4UbFHuaAtlVZD3gifRVH5OW+luQXcty6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l+Pn2TLq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l+Pn2TLq"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 021911F000FF;
	Fri,  2 Oct 2026 16:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790958420;
	bh=1GX1nooMxTxk2B9jbswzQ9cXGonKFzs2eHJgO57TUPw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=l+Pn2TLqyyMX90OiI7Ro8f/ZnrlY0RJ3nuH077uce5CAU4zGeBz+C7vYYcgsHlUoH
	 qD9eM/EyC1nW8T80Z/WPuoJpm9Q1tNXDoVoW2kCBeRxR7iKUFyB3Uphj2WsQsunqzT
	 eQGx+4+22t3C/GNF9zVtp1soAjj5F6DkLj3x2TAQqXFV93Gj1XJNuAqk84WysVLj27
	 0w/LPXWj6XWL8nOzibbI8pOzyFWUXolbwTPgF2zkrExyUggXmPw1v70oxCBtPXzuig
	 rPf0DACa6DP/Gel6rZV6pQB1Ba4XuFXJCQYrpk4NpPvuGrtPBVUVug71UW26UTWzNF
	 giycEH5Mh1GRw==
Date: Fri, 2 Oct 2026 09:26:59 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Norbert Szetei <norbert@doyensec.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: stop exchanging reflink flags during mapping
 exchanges
Message-ID: <20261002162659.GY2705364@frogsfrogsfrogs>
References: <1E196589-DEBE-40AC-AFEA-D420DAAB067F@doyensec.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1E196589-DEBE-40AC-AFEA-D420DAAB067F@doyensec.com>

On Fri, Oct 02, 2026 at 03:38:22PM +0200, Norbert Szetei wrote:
> When an exchange covers the whole of both files,
> xmi_can_exchange_reflink_flags() moves the reflink inode flag from the
> file that has it to the other one, deciding that from req->blockcount
> against XFS_B_TO_FSB(mp, i_disk_size) on each inode.
> 
> i_disk_size does not bound an inode's mappings, and
> XFS_EXCHMAPS_SET_SIZES creates that state by assigning both i_disk_size
> values from the sizes sampled before the operation without unmapping
> anything above the new size. An exchange over [0, i_disk_size) can
> therefore pass every test in the function while an inode still owns
> shared mappings above EOF, and the post-operation cleanup clears its

How do you end up with shared mappings above EOF?  You write a /lot/ of
sentences here but weirdly none of it explains how this key assumption
is violated.

> reflink flag anyway. Later writes to those mappings take the non-reflink
> write path and update blocks that should still have been protected by
> CoW, which shows up as data corruption between reflink-related files and
> as an rmap overlap that xfs_rmap_convert() rejects.
> 
> Commit a23eca88448e ("xfs: fix exchange-range reflink flag clearing
> issue with INO1_WRITTEN") disabled the flag exchange for
> XFS_EXCHMAPS_INO1_WRITTEN requests. Fix this variant by not exchanging
> the flags at all, which subsumes that guard. Whether an inode still owns
> shared blocks outside the exchanged range is not recorded in the data
> fork, so answering it takes a refcount btree lookup, and
> xfs_exchmaps_init_intent() has no transaction to do that with, cannot
> report an error, and runs with both ILOCKs dropped in recovery. Deciding
> it correctly means doing that lookup in xfs_exchrange_mappings(), which
> holds both ILOCKs and a transaction and can return an error. The
> conservative outcome here is that both inodes keep the reflink flag.

Or you could cross-reference the refcount btree with any mappings you
find beyond i_disk_size.

> XFS_EXCHMAPS_CLEAR_INO{1,2}_REFLINK were only ever set by the decision
> this patch removes, so xfs_exchmaps_clear_reflink() and the code that
> consumed them are unreachable and go too. An intent logged by an older
> kernel does carry the bits, but xfs_xmi_item_recover_intent() has always
> masked them off with XFS_EXCHMAPS_PARAMS, and the clearing only survived
> recovery because init_intent re-derived the decision. Recovering such an
> intent now completes the exchange and leaves both reflink flags set.
> 
> The flag that xfs_exchmaps_ensure_reflink() copies to the peer inode is
> now permanent until a FALLOC_FL_UNSHARE_RANGE, an xfs_scrub run or a
> truncate to empty clears it. Until then that inode keeps the paths
> xfs_is_cow_inode() selects, ILOCK_EXCL for buffered writes and the
> -ENOTBLK bounce for unaligned direct writes, and
> xchk_inode_check_reflink_iflag() preens it on every scrub.
> 
> Fixes: 966ceafc7a43 ("xfs: create deferred log items for file mapping exchanges")
> Cc: stable@vger.kernel.org # v6.10
> Assisted-by: LLM

Oh, this was all slop?  Wonderful.

> Signed-off-by: Norbert Szetei <norbert@doyensec.com>
> ---
> A reproducer is available on request.

POC || GTFO.  I'm not going to play 20 questions here.

--D

>  fs/xfs/libxfs/xfs_exchmaps.c | 86 +++++-------------------------------
>  1 file changed, 10 insertions(+), 76 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
> index 6a66b6075e0a..07288f4163b3 100644
> --- a/fs/xfs/libxfs/xfs_exchmaps.c
> +++ b/fs/xfs/libxfs/xfs_exchmaps.c
> @@ -127,9 +127,7 @@ xmi_has_more_exchange_work(const struct xfs_exchmaps_intent *xmi)
>  static inline bool
>  xmi_has_postop_work(const struct xfs_exchmaps_intent *xmi)
>  {
> -	return xmi->xmi_flags & (XFS_EXCHMAPS_CLEAR_INO1_REFLINK |
> -				 XFS_EXCHMAPS_CLEAR_INO2_REFLINK |
> -				 __XFS_EXCHMAPS_INO2_SHORTFORM);
> +	return xmi->xmi_flags & __XFS_EXCHMAPS_INO2_SHORTFORM;
>  }
>  
>  /* Check all mappings to make sure we can actually exchange them. */
> @@ -525,18 +523,6 @@ xfs_exchmaps_link_to_sf(
>  	return error;
>  }
>  
> -/* Clear the reflink flag after an exchange. */
> -static inline void
> -xfs_exchmaps_clear_reflink(
> -	struct xfs_trans	*tp,
> -	struct xfs_inode	*ip)
> -{
> -	trace_xfs_reflink_unset_inode_flag(ip);
> -
> -	ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
> -	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> -}
> -
>  /* Finish whatever work might come after an exchange operation. */
>  static int
>  xfs_exchmaps_do_postop_work(
> @@ -557,16 +543,6 @@ xfs_exchmaps_do_postop_work(
>  			return error;
>  	}
>  
> -	if (xmi->xmi_flags & XFS_EXCHMAPS_CLEAR_INO1_REFLINK) {
> -		xfs_exchmaps_clear_reflink(tp, xmi->xmi_ip1);
> -		xmi->xmi_flags &= ~XFS_EXCHMAPS_CLEAR_INO1_REFLINK;
> -	}
> -
> -	if (xmi->xmi_flags & XFS_EXCHMAPS_CLEAR_INO2_REFLINK) {
> -		xfs_exchmaps_clear_reflink(tp, xmi->xmi_ip2);
> -		xmi->xmi_flags &= ~XFS_EXCHMAPS_CLEAR_INO2_REFLINK;
> -	}
> -
>  	return 0;
>  }
>  
> @@ -948,46 +924,21 @@ xfs_exchmaps_intent_destroy_cache(void)
>  }
>  
>  /*
> - * Decide if we will exchange the reflink flags between the two files after the
> - * exchange.  The only time we want to do this is if we're exchanging all
> - * mappings under EOF and the inode reflink flags have different states.
> + * Allocate and initialize a new incore intent item from a request.
> + *
> + * Note that this does not decide anything about the two inodes' reflink flags.
> + * Clearing XFS_DIFLAG2_REFLINK off an inode needs to know whether it still owns
> + * shared blocks outside the exchanged range, which is not recorded in the data
> + * fork and takes a refcount btree lookup.  This function has no transaction to
> + * do that with and no way to report a failure, so both flags are left as they
> + * are.  xfs_exchmaps_ensure_reflink() copies the flag to the peer inode when the
> + * exchange runs.
>   */
> -static inline bool
> -xmi_can_exchange_reflink_flags(
> -	const struct xfs_exchmaps_req	*req,
> -	unsigned int			reflink_state)
> -{
> -	struct xfs_mount		*mp = req->ip1->i_mount;
> -
> -	/*
> -	 * The INO1_WRITTEN optimization can skip exchanging hole and
> -	 * unwritten mappings, which means we cannot guarantee that all
> -	 * shared extents actually moved to the other file.  Clearing the
> -	 * reflink flag of an inode that still holds shared extents breaks
> -	 * the CoW write path, so refuse to exchange the flags in that case.
> -	 */
> -	if (req->flags & XFS_EXCHMAPS_INO1_WRITTEN)
> -		return false;
> -
> -	if (hweight32(reflink_state) != 1)
> -		return false;
> -	if (req->startoff1 != 0 || req->startoff2 != 0)
> -		return false;
> -	if (req->blockcount != XFS_B_TO_FSB(mp, req->ip1->i_disk_size))
> -		return false;
> -	if (req->blockcount != XFS_B_TO_FSB(mp, req->ip2->i_disk_size))
> -		return false;
> -	return true;
> -}
> -
> -
> -/* Allocate and initialize a new incore intent item from a request. */
>  struct xfs_exchmaps_intent *
>  xfs_exchmaps_init_intent(
>  	const struct xfs_exchmaps_req	*req)
>  {
>  	struct xfs_exchmaps_intent	*xmi;
> -	unsigned int			rs = 0;
>  
>  	xmi = kmem_cache_zalloc(xfs_exchmaps_intent_cache,
>  			GFP_NOFS | __GFP_NOFAIL);
> @@ -1011,23 +962,6 @@ xfs_exchmaps_init_intent(
>  		xmi->xmi_isize2 = req->ip1->i_disk_size;
>  	}
>  
> -	/* Record the state of each inode's reflink flag before the op. */
> -	if (xfs_is_reflink_inode(req->ip1))
> -		rs |= 1;
> -	if (xfs_is_reflink_inode(req->ip2))
> -		rs |= 2;
> -
> -	/*
> -	 * Figure out if we're clearing the reflink flags (which effectively
> -	 * exchanges them) after the operation.
> -	 */
> -	if (xmi_can_exchange_reflink_flags(req, rs)) {
> -		if (rs & 1)
> -			xmi->xmi_flags |= XFS_EXCHMAPS_CLEAR_INO1_REFLINK;
> -		if (rs & 2)
> -			xmi->xmi_flags |= XFS_EXCHMAPS_CLEAR_INO2_REFLINK;
> -	}
> -
>  	if (S_ISDIR(VFS_I(xmi->xmi_ip2)->i_mode) ||
>  	    S_ISLNK(VFS_I(xmi->xmi_ip2)->i_mode))
>  		xmi->xmi_flags |= __XFS_EXCHMAPS_INO2_SHORTFORM;
> -- 
> 2.55.0
> 
> 
