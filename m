Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:4617 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726678AbfA1Wya (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Jan 2019 17:54:30 -0500
Date: Tue, 29 Jan 2019 09:54:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC v2 2/3] xfs: distinguish between inobt and finobt
 magic values
Message-ID: <20190128225426.GU4205@dastard>
References: <20190128152034.21080-1-bfoster@redhat.com>
 <20190128152034.21080-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190128152034.21080-3-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jan 28, 2019 at 10:20:33AM -0500, Brian Foster wrote:
> The inode btree verifier code is shared between the inode btree and
> free inode btree because the underlying metadata formats are
> essentially equivalent. A side effect of this is that the verifier
> cannot determine whether a particular btree block should have an
> inobt or finobt magic value.
> 
> This logic allows an unfortunate xfs_repair bug to escape detection
> where certain level > 0 nodes of the finobt are stamped with inobt
> magic by xfs_repair finobt reconstruction. This is fortunately not a
> severe problem since the inode btree magic values do not contribute
> to any changes in kernel behavior, but we do need a means to detect
> and prevent this problem in the future.
> 
> Add a field to xfs_buf_ops to store the v4 and v5 superblock magic
> values expected by a particular verifier. Add a helper to check an
> on-disk magic value against the value expected by the verifier. Call
> the helper from the shared [f]inobt verifier code for magic value
> verification. This ensures that the inode btree blocks each have the
> appropriate magic value based on specific tree type and superblock
> version.

I still really don't like this code :(

> @@ -387,4 +388,22 @@ extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int);
>  
>  int xfs_buf_ensure_ops(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
>  
> +/*
> + * Verify an on-disk magic value against the magic value specified in the
> + * verifier structure.
> + */
> +static inline bool
> +xfs_buf_ops_verify_magic(
> +	struct xfs_buf		*bp,
> +	__be32			dmagic,
> +	bool			crc)
> +{
> +	if (unlikely(WARN_ON(!bp->b_ops || !bp->b_ops->magic[crc])))
> +		return false;
> +	return dmagic == cpu_to_be32(bp->b_ops->magic[crc]);
> +}
> +#define xfs_verify_magic(bp, dmagic)		\
> +	xfs_buf_ops_verify_magic(bp, dmagic,	\
> +			xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb))

That, IMO, is even worse....

Ok, here's a different option. Store all the magic numbers in a pair
of tables - one for v4, one for v5. They can be static const and
in on-disk format.

Then use some simple 1-line wrappers for the verifier definitions to
specify the table index for the magic numbers. e.g:

__be32 xfs_disk_magic(mp, idx)
{
	if (xfs_sb_version_hascrc(&mp->m_sb))
		return xfs_v5_disk_magic[idx];
	return xfs_v4_disk_magic[idx];
}

[.....]

__xfs_inobt_read_verify(bp, magic_idx)
{
	magic = xfs_disk_magic(mp, magic_idx);
	.....
}

__xfs_inobt_write_verify(bp, magic_idx)
{
	magic = xfs_disk_magic(mp, magic_idx);
	.....
}

__xfs_inobt_struct_verify(bp, magic_idx)
{
	magic = xfs_disk_magic(mp, magic_idx);
	.....
}

[ or drive the magic number resolution further inwards to where it
is actually needed. ]

xfs_inobt_read_verify(bp)
{
	return __xfs_inobt_read_verify(bp, INOBT);
}

xfs_inobt_write_verify(bp)
{
	return __xfs_inobt_write_verify(bp, INOBT);
}

xfs_inobt_struct_verify(bp)
{
	return __xfs_inobt_struct_verify(bp, INOBT);
}

xfs_finobt_read_verify(bp)
{
	return __xfs_inobt_read_verify(bp, FINOBT);
}

xfs_finobt_write_verify(bp)
{
	return __xfs_inobt_write_verify(bp, FINOBT);
}

xfs_finobt_struct_verify(bp)
{
	return __xfs_inobt_struct_verify(bp, FINOBT);
}

And this can be extended to all the verifiers - it handles crc and
non CRC variants transparently, and can be used for the cnt/bno free
space btrees, too.

Yes, it's a bit more boiler plate code, but IMO it is easier to
follow and understand than encoding multiple magic numbers into the
verifier and adding a dependency on the buffer having an ops
structure attached to be able to check the magic number...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
