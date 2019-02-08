Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:41434 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726915AbfBHRGc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Feb 2019 12:06:32 -0500
Date: Fri, 8 Feb 2019 09:06:26 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: compile time offset checks for common v4/v5 metadata
Message-ID: <20190208170626.GP7991@magnolia>
References: <20190208152442.22862-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190208152442.22862-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Feb 08, 2019 at 10:24:42AM -0500, Brian Foster wrote:
> The v5 superblock format added various metadata fields (such as crc,
> metadata lsn, owner uuid, etc.) to v4 metadata headers or created
> new v5 headers for blocks where no such headers existed on v4. Where
> v4 headers did exist, the v5 structures are careful to place v4
> metadata at the original location. For example, the magic value is
> expected to be at the same location in certain blocks to facilitate
> version detection.
> 
> While failure of this invariant is likely to cause severe and
> obvious problems at runtime, we can detect this condition at compile
> time via the more recently added on-disk format check
> infrastructure. Since there is no runtime cost, add some offset
> checks that start with v5 structure definitions, traverse down to
> the first bit of common metadata with v4 and ensure that common
> metadata is at the expected offset. Note that we don't care about
> blocks which had no v4 header because there is no common metadata in
> those cases. No functional changes.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> Hi all,
> 
> This patch is inspired from debug checks that were initially in the
> verifier magic fixup series. I originally had some assert checks to make
> sure magic values were in the same location across v4 and v5 structures.
> Darrick suggested that these were perhaps better suited as build time
> offset checks. My subsequent attempt to convert the magic offset checks
> resulted in somewhat confusing and convoluted build time checks.
> 
> As a result, I opted to remove this stuff from the verifier series to be
> replaced with an independent patch that attempts to verify v5 structures
> place v4 metadata at the expected location in general. This is not a
> known problem or anything, just something that's easy to check for with
> the on-disk format infrastructure already in place and helps validate
> common code.
> 
> I think this covers all structures handled by the verifier series at
> least (some are "internal" in that they are between the top-level v5
> structs and v4 structs), but I could have missed some. Thoughts?

Looks ok to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

(In my fantasyland we would have comprehensive build-time checks for
every field offset of every on-disk structure, but that's a totally
separate patchset.)

--D

> 
> Brian
> 
>  fs/xfs/xfs_ondisk.h | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> index d3e04d20d8d4..c8ba98fae30a 100644
> --- a/fs/xfs/xfs_ondisk.h
> +++ b/fs/xfs/xfs_ondisk.h
> @@ -125,6 +125,27 @@ xfs_check_ondisk_structs(void)
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format,	56);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,	20);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_trans_header,		16);
> +
> +	/*
> +	 * The v5 superblock format extended several v4 header structures with
> +	 * additional data. While new fields are only accessible on v5
> +	 * superblocks, it's important that the v5 structures place original v4
> +	 * fields/headers in the correct location on-disk. For example, we must
> +	 * be able to find magic values at the same location in certain blocks
> +	 * regardless of superblock version.
> +	 *
> +	 * The following checks ensure that various v5 data structures place the
> +	 * subset of v4 metadata associated with the same type of block at the
> +	 * start of the on-disk block. If there is no data structure definition
> +	 * for certain types of v4 blocks, traverse down to the first field of
> +	 * common metadata (e.g., magic value) and make sure it is at offset
> +	 * zero.
> +	 */
> +	XFS_CHECK_OFFSET(struct xfs_dir3_leaf, hdr.info.hdr,	0);
> +	XFS_CHECK_OFFSET(struct xfs_da3_intnode, hdr.info.hdr,	0);
> +	XFS_CHECK_OFFSET(struct xfs_dir3_data_hdr, hdr.magic,	0);
> +	XFS_CHECK_OFFSET(struct xfs_dir3_free, hdr.hdr.magic,	0);
> +	XFS_CHECK_OFFSET(struct xfs_attr3_leafblock, hdr.info.hdr, 0);
>  }
>  
>  #endif /* __XFS_ONDISK_H */
> -- 
> 2.17.2
> 
