Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34403 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751699AbdLULsG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Dec 2017 06:48:06 -0500
Date: Thu, 21 Dec 2017 12:48:01 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 19/19] fs: handle inode->i_version more efficiently
Message-ID: <20171221114801.GH31584@quack2.suse.cz>
References: <20171218151156.14565-1-jlayton@kernel.org>
 <20171218151156.14565-20-jlayton@kernel.org>
 <20171218163418.GF30350@quack2.suse.cz>
 <1513617740.3422.30.camel@kernel.org>
 <20171218173651.GB12454@fieldses.org>
 <1513625720.3422.68.camel@kernel.org>
 <20171218220759.GF4094@dastard>
 <1513778586.4513.18.camel@kernel.org>
 <20171220164150.GF31584@quack2.suse.cz>
 <1513855555.3410.3.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1513855555.3410.3.camel@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com, jaltman@auristor.com

On Thu 21-12-17 06:25:55, Jeff Layton wrote:
> Got it, I think. How about this (sorry for the unrelated deltas here):
> 
> [PATCH] SQUASH: add memory barriers around i_version accesses

Yep, this looks good to me.

								Honza
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  include/linux/iversion.h | 60 +++++++++++++++++++++++++++++++-----------------
>  1 file changed, 39 insertions(+), 21 deletions(-)
> 
> diff --git a/include/linux/iversion.h b/include/linux/iversion.h
> index a9fbf99709df..1b3b5ed7c5b8 100644
> --- a/include/linux/iversion.h
> +++ b/include/linux/iversion.h
> @@ -89,6 +89,23 @@ inode_set_iversion_raw(struct inode *inode, const u64 val)
>  	atomic64_set(&inode->i_version, val);
>  }
>  
> +/**
> + * inode_peek_iversion_raw - grab a "raw" iversion value
> + * @inode: inode from which i_version should be read
> + *
> + * Grab a "raw" inode->i_version value and return it. The i_version is not
> + * flagged or converted in any way. This is mostly used to access a self-managed
> + * i_version.
> + *
> + * With those filesystems, we want to treat the i_version as an entirely
> + * opaque value.
> + */
> +static inline u64
> +inode_peek_iversion_raw(const struct inode *inode)
> +{
> +	return atomic64_read(&inode->i_version);
> +}
> +
>  /**
>   * inode_set_iversion - set i_version to a particular value
>   * @inode: inode to set
> @@ -152,7 +169,18 @@ inode_maybe_inc_iversion(struct inode *inode, bool force)
>  {
>  	u64 cur, old, new;
>  
> -	cur = (u64)atomic64_read(&inode->i_version);
> +	/*
> +	 * The i_version field is not strictly ordered with any other inode
> +	 * information, but the legacy inode_inc_iversion code used a spinlock
> +	 * to serialize increments.
> +	 *
> +	 * Here, we add full memory barriers to ensure that any de-facto
> +	 * ordering with other info is preserved.
> +	 *
> +	 * This barrier pairs with the barrier in inode_query_iversion()
> +	 */
> +	smp_mb();
> +	cur = inode_peek_iversion_raw(inode);
>  	for (;;) {
>  		/* If flag is clear then we needn't do anything */
>  		if (!force && !(cur & I_VERSION_QUERIED))
> @@ -183,23 +211,6 @@ inode_inc_iversion(struct inode *inode)
>  	inode_maybe_inc_iversion(inode, true);
>  }
>  
> -/**
> - * inode_peek_iversion_raw - grab a "raw" iversion value
> - * @inode: inode from which i_version should be read
> - *
> - * Grab a "raw" inode->i_version value and return it. The i_version is not
> - * flagged or converted in any way. This is mostly used to access a self-managed
> - * i_version.
> - *
> - * With those filesystems, we want to treat the i_version as an entirely
> - * opaque value.
> - */
> -static inline u64
> -inode_peek_iversion_raw(const struct inode *inode)
> -{
> -	return atomic64_read(&inode->i_version);
> -}
> -
>  /**
>   * inode_iversion_need_inc - is the i_version in need of being incremented?
>   * @inode: inode to check
> @@ -248,15 +259,22 @@ inode_query_iversion(struct inode *inode)
>  {
>  	u64 cur, old, new;
>  
> -	cur = atomic64_read(&inode->i_version);
> +	cur = inode_peek_iversion_raw(inode);
>  	for (;;) {
>  		/* If flag is already set, then no need to swap */
> -		if (cur & I_VERSION_QUERIED)
> +		if (cur & I_VERSION_QUERIED) {
> +			/*
> +			 * This barrier (and the implicit barrier in the
> +			 * cmpxchg below) pairs with the barrier in
> +			 * inode_maybe_inc_iversion().
> +			 */
> +			smp_mb();
>  			break;
> +		}
>  
>  		new = cur | I_VERSION_QUERIED;
>  		old = atomic64_cmpxchg(&inode->i_version, cur, new);
> -		if (old == cur)
> +		if (likely(old == cur))
>  			break;
>  		cur = old;
>  	}
> -- 
> 2.14.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
