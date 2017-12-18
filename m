Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:54826 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S964920AbdLRWIF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Dec 2017 17:08:05 -0500
Date: Tue, 19 Dec 2017 09:07:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 19/19] fs: handle inode->i_version more efficiently
Message-ID: <20171218220759.GF4094@dastard>
References: <20171218151156.14565-1-jlayton@kernel.org>
 <20171218151156.14565-20-jlayton@kernel.org>
 <20171218163418.GF30350@quack2.suse.cz>
 <1513617740.3422.30.camel@kernel.org>
 <20171218173651.GB12454@fieldses.org>
 <1513625720.3422.68.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1513625720.3422.68.camel@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@kernel.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com, jaltman@auristor.com

On Mon, Dec 18, 2017 at 02:35:20PM -0500, Jeff Layton wrote:
> [PATCH] SQUASH: add memory barriers around i_version accesses

Why explicit memory barriers rather than annotating the operations
with the required semantics and getting the barriers the arch
requires automatically?  I suspect this should be using
atomic_read_acquire() and atomic_cmpxchg_release(), because AFAICT
the atomic_cmpxchg needs to have release semantics to match the
acquire semantics needed for the load of the current value.

>From include/linux/atomics.h:

 * For compound atomics performing both a load and a store, ACQUIRE
 * semantics apply only to the load and RELEASE semantics only to the
 * store portion of the operation. Note that a failed cmpxchg_acquire
 * does -not- imply any memory ordering constraints.

Memory barriers hurt my brain. :/

At minimum, shouldn't the atomic op specific barriers be used rather
than full memory barriers? i.e:

> diff --git a/include/linux/iversion.h b/include/linux/iversion.h
> index a9fbf99709df..39ec9aa9e08e 100644
> --- a/include/linux/iversion.h
> +++ b/include/linux/iversion.h
> @@ -87,6 +87,25 @@ static inline void
>  inode_set_iversion_raw(struct inode *inode, const u64 val)
>  {
>  	atomic64_set(&inode->i_version, val);
> +	smp_wmb();

	smp_mb__after_atomic();
.....
> +static inline u64
> +inode_peek_iversion_raw(const struct inode *inode)
> +{
> +	smp_rmb();

	smp_mb__before_atomic();

> +	return atomic64_read(&inode->i_version);
>  }

And, of course, these will require comments explaining what they
match with and what they are ordering.

> @@ -152,7 +171,7 @@ inode_maybe_inc_iversion(struct inode *inode, bool force)
>  {
>  	u64 cur, old, new;
>  
> -	cur = (u64)atomic64_read(&inode->i_version);
> +	cur = inode_peek_iversion_raw(inode);
>  	for (;;) {
>  		/* If flag is clear then we needn't do anything */
>  		if (!force && !(cur & I_VERSION_QUERIED))

cmpxchg in this loop needs a release barrier so everyone will
see the change?

> @@ -183,23 +202,6 @@ inode_inc_iversion(struct inode *inode)
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
> @@ -248,7 +250,7 @@ inode_query_iversion(struct inode *inode)
>  {
>  	u64 cur, old, new;
>  
> -	cur = atomic64_read(&inode->i_version);
> +	cur = inode_peek_iversion_raw(inode);
>  	for (;;) {
>  		/* If flag is already set, then no need to swap */
>  		if (cur & I_VERSION_QUERIED)

cmpxchg in this loop needs a release barrier so everyone will
see the change on load?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
