Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8B5R6hg020767 for <xfs@oss.sgi.com>; Tue, 11 Sep 2012 00:27:06 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	yxDwd8szJv4moqnt for <xfs@oss.sgi.com>;
	Mon, 10 Sep 2012 22:28:08 -0700 (PDT)
Date: Tue, 11 Sep 2012 15:27:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 3/8] xfs: create helper to check whether to free
	eofblocks on inode
Message-ID: <20120911052743.GB11511@dastard>
References: <1347302246-52710-1-git-send-email-bfoster@redhat.com>
	<1347302246-52710-4-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1347302246-52710-4-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Sep 10, 2012 at 02:37:21PM -0400, Brian Foster wrote:
> This check is used in multiple places to determine whether we
> should check for (and potentially free) post EOF blocks on an
> inode. Add a helper to consolidate the check.
> 
> Note that when we remove an inode from the cache (xfs_inactive()),
> we are required to trim post-EOF blocks even if the inode is marked
> preallocated or append-only to maintain correct space accounting.
> The 'force' parameter to xfs_can_free_eofblocks() specifies whether
> we should ignore the prealloc/append-only status of the inode.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Just quickly, I'd rewrite this convoluted logic:

> +/*
> + * Test whether it is appropriate to check an inode for and free post EOF
> + * blocks. The 'force' parameter determines whether we should also consider
> + * regular files that are marked preallocated or append-only.
> + */
> +static inline bool
> +xfs_can_free_eofblocks(struct xfs_inode *ip, bool force)
> +{
> +	if (S_ISREG(ip->i_d.di_mode) &&
> +	    (VFS_I(ip)->i_size > 0 ||
> +	     (VN_CACHED(VFS_I(ip)) > 0 || ip->i_delayed_blks > 0)) &&
> +	    (ip->i_df.if_flags & XFS_IFEXTENTS)  &&
> +	    (!(ip->i_d.di_flags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)) ||
> +	     (force && ip->i_delayed_blks != 0)))
> +		return true;
> +
> +	return false;
> +}

in a manner that can means it no longer has to be analysed from first principles
every time it is read. e.g.:

static inline bool
xfs_can_free_eofblocks(struct xfs_inode *ip, bool force)
{
	/* prealloc/delalloc exists only on regular files */
	if (!S_ISREG(ip->i_d.di_mode))
		return false;
	/*
	 * Zero sized files with no cached page or delalloc blocks will not have
	 * any speculative prealloc/delalloc to remove.
	 */
	if (VFS_I(ip)->i_size == 0 &&
	    VFS_I(ip)->i_mapping->nr_pages == 0 &&
	    ip->i_delayed_blks == 0)
		return false;

	/* If we haven't read in the extent list, then don't do it now. */
	if (!(ip->i_df.if_flags & XFS_IFEXTENTS))
		return false;

	/*
	 * Real preallocation or append only files do not get EOF blocks freed
	 * unless there are also delalloc blocks and we are forced to remove
	 * them.
	 */
	if ((ip->i_d.di_flags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)) {
		if (!ip->i_delayed_blks)
			return false;
		if (!force)
			return false;
	}

	return true;
}

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
