Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39678 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936389AbdLRQeW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Dec 2017 11:34:22 -0500
Date: Mon, 18 Dec 2017 17:34:18 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 19/19] fs: handle inode->i_version more efficiently
Message-ID: <20171218163418.GF30350@quack2.suse.cz>
References: <20171218151156.14565-1-jlayton@kernel.org>
 <20171218151156.14565-20-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171218151156.14565-20-jlayton@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com, jaltman@auristor.com

On Mon 18-12-17 10:11:56, Jeff Layton wrote:
>  static inline bool
>  inode_maybe_inc_iversion(struct inode *inode, bool force)
>  {
> -	atomic64_t *ivp = (atomic64_t *)&inode->i_version;
> +	u64 cur, old, new;
>  
> -	atomic64_inc(ivp);
> +	cur = (u64)atomic64_read(&inode->i_version);
> +	for (;;) {
> +		/* If flag is clear then we needn't do anything */
> +		if (!force && !(cur & I_VERSION_QUERIED))
> +			return false;

The fast path here misses any memory barrier. Thus it seems this query
could be in theory reordered before any store that happened to modify the
inode? Or maybe we could race and miss the fact that in fact this i_version
has already been queried? But maybe there's some higher level locking that
makes sure this is all a non-issue... But in that case it would deserve
some comment I guess.

> +
> +		/* Since lowest bit is flag, add 2 to avoid it */
> +		new = (cur & ~I_VERSION_QUERIED) + I_VERSION_INCREMENT;
> +
> +		old = atomic64_cmpxchg(&inode->i_version, cur, new);
> +		if (likely(old == cur))
> +			break;
> +		cur = old;
> +	}
>  	return true;
>  }
>  

...

>  static inline u64
>  inode_query_iversion(struct inode *inode)
>  {
> -	return inode_peek_iversion(inode);
> +	u64 cur, old, new;
> +
> +	cur = atomic64_read(&inode->i_version);
> +	for (;;) {
> +		/* If flag is already set, then no need to swap */
> +		if (cur & I_VERSION_QUERIED)
> +			break;
> +
> +		new = cur | I_VERSION_QUERIED;
> +		old = atomic64_cmpxchg(&inode->i_version, cur, new);
> +		if (old == cur)
> +			break;
> +		cur = old;
> +	}

Why not just use atomic64_or() here?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
