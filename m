Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Apr 2008 16:05:58 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m33N5lU9011299
	for <xfs@oss.sgi.com>; Thu, 3 Apr 2008 16:05:51 -0700
Date: Thu, 3 Apr 2008 19:06:23 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/7] XFS: Return case-insensitive match for dentry cache
Message-ID: <20080403230623.GC448@infradead.org>
References: <20080402062508.017738664@chook.melbourne.sgi.com> <20080402062708.654277049@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080402062708.654277049@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Wed, Apr 02, 2008 at 04:25:12PM +1000, Barry Naujok wrote:
> It also introduces a new type, xfs_name, which is similar to the
> dentry cache's qstr type. It contains a pointer to a zone allocated
> string (MAXNAMELEN sized) and the length of the actual name. This
> string does not need to be NULL terminated (a counted string).
> 
> xfs_name_t is only used in the lookup path for this patch, but may
> be used in other locations too if desired. It maybe desirable not
> to use xfs_name_t at all in the lookup functions but stick to
> separate parameters (which will mean 7 instead of 5 arguments).

wouldn't it be a lot cleaner to just pass the struct qstr all the way
down instead of inventing an almost the same type?

> To avoid polluting the dcache, we implement a new directory inode
> operations for lookup. xfs_vn_ci_lookup() interacts directly with
> the dcache and the code was derived from ntfs_lookup() in
> fs/ntfs/namei.c. The dentry hash and compare overrides introduced
> in the ASCII-CI patch has been removed.

So maybe we should introduce the method in that patch already?
Especially as the old one is buggy and the new one should be
one ore more helpers in generic code it could easily be a patch of
it's own.

> +		/*
> +		 * Directory without a 'disconnected' dentry; we need to do
> +		 * d_instantiate() by hand because it takes dcache_lock which
> +		 * we already hold.
> +		 */
> +		list_add(&result->d_alias, &inode->i_dentry);
> +		result->d_inode = inode;
> +		spin_unlock(&dcache_lock);
> +		security_d_instantiate(result, inode);

please add a documented __d_instanciated helper in common code that
is used by this and d_instanciate.

> +typedef struct qstr	bhv_vstr_t;

we try to get rid of the bhv_v* names, they're ugly amd their naming is
outdated.  Just use struct qstr until some port comes up with s
conflicting one.

> +	return kmem_zone_zalloc(xfs_da_name_zone, KM_SLEEP);

please don't introduce new KM_SLEEP allocations.

> +	kmem_zone_free(xfs_da_name_zone, (void *)name);

this cast should not be needed.
