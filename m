Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8A2427FC7
	for <xfs@oss.sgi.com>; Fri,  6 Feb 2015 16:55:20 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E74CEAC009
	for <xfs@oss.sgi.com>; Fri,  6 Feb 2015 14:55:19 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	MaApS1yPtHudyxNm for <xfs@oss.sgi.com>;
	Fri, 06 Feb 2015 14:55:17 -0800 (PST)
Date: Sat, 7 Feb 2015 09:54:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 03/18] xfs: sparse inode chunks feature helpers and
	mount requirements
Message-ID: <20150206225452.GP12722@dastard>
References: <1423252385-3063-1-git-send-email-bfoster@redhat.com>
	<1423252385-3063-4-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1423252385-3063-4-git-send-email-bfoster@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Feb 06, 2015 at 02:52:50PM -0500, Brian Foster wrote:
> The sparse inode chunks feature uses the helper function to enable the
> allocation of sparse inode chunks. The incompatible feature bit is set
> on disk at mkfs time to prevent mount from unsupported kernels.
> 
> Also, enforce the inode alignment requirements required for sparse inode
> chunks at mount time. When enabled, full inode chunks (and all inode
> record) alignment is increased from cluster size to inode chunk size.
> Sparse inode alignment must match the cluster size of the fs. Both
> superblock alignment fields are set as such by mkfs when sparse inode
> support is enabled.
> 
> Finally, warn that sparse inode chunks is an experimental feature until
> further notice.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
....
> @@ -182,6 +182,28 @@ xfs_mount_validate_sb(
>  			return -EFSCORRUPTED;
>  	}
>  
> +	/*
> +	 * Full inode chunks must be aligned to inode chunk size when
> +	 * sparse inodes are enabled to support the sparse chunk
> +	 * allocation algorithm and prevent overlapping inode records.
> +	 */
> +	if (xfs_sb_version_hassparseinodes(sbp)) {
> +		uint32_t	align;
> +
> +		xfs_alert(mp,
> +		"v5 superblock with sparse inode chunk support detected.\n"
> +		"This feature is EXPERIMENTAL. Use at your own risk!");

No need to mention v5 superblocks here - we've already got that in
the initial mount output. Say:

"EXPERIMENTAL sparse inode chunk feature enabled. Use at your own risk!"

> +
> +		align = XFS_INODES_PER_CHUNK * sbp->sb_inodesize
> +				>> sbp->sb_blocklog;
> +		if (sbp->sb_inoalignmt != align) {
> +			xfs_warn(mp, "Invalid inode alignment (%u blks). "
> +		"Must match inode chunk size (%u blks) with sparse inodes.",

"Inode block alignment (%u) must match chunk size (%u) for sparse inodes."

That makes both error messages a single line a easy to grep for.

> @@ -738,6 +738,22 @@ xfs_mountfs(
>  	}
>  
>  	/*
> +	 * If enabled, sparse inode chunk alignment is expected to match the
> +	 * cluster size. Full inode chunk alignment must match the chunk size,
> +	 * but that is checked on sb read verification...
> +	 */
> +	if (xfs_sb_version_hassparseinodes(&mp->m_sb) &&
> +	    mp->m_sb.sb_spinoalignmt !=
> +	    XFS_B_TO_FSBT(mp, mp->m_inode_cluster_size)) {

Indent the second line of the comaprison so it's distinct from the
logic comparison. i.e. at first glance the above looks like three
logic conditions being compared, when in fact it is only two.

	if (xfs_sb_version_hassparseinodes(&mp->m_sb) &&
	    mp->m_sb.sb_spinoalignmt !=
			XFS_B_TO_FSBT(mp, mp->m_inode_cluster_size)) {

This makes it clear at a glance there are only two logic conditions
in the if() statement.

> +		xfs_warn(mp, "Invalid sparse inode chunk alignment (%u blks). "
> +			 "Must match cluster size (%llu blks).",

"Sparse inode chunk block alignment (%u) must match cluster size (%u)."

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
