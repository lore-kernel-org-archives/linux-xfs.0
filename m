Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CA06D7CA4
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 09:59:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5A537AC003
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 07:59:18 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id fD5dqZRe5A9AdFAE (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Sep 2016 07:59:16 -0700 (PDT)
Date: Tue, 6 Sep 2016 07:59:14 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/71] xfs: introduce refcount btree definitions
Message-ID: <20160906145914.GC24287@infradead.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
	<147216797030.867.2576348201175433862.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <147216797030.867.2576348201175433862.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, Aug 25, 2016 at 04:32:50PM -0700, Darrick J. Wong wrote:
> Add new per-AG refcount btree definitions to the per-AG structures.
> 
> v2: Move the reflink inode flag out of the way of the DAX flag, and
> add the new cowextsize flag.
> 
> v3: Don't allow pNFS to export reflinked files; this will be removed
> some day when the Linux pNFS server supports it.
> 
> [hch: don't allow pNFS export of reflinked files]
> [darrick: fix the feature test in hch's patch]

This was such a tiny check in the grand scheme of things, feel free to drop any mention of it

>  /*
>   * For logging record fields.
> @@ -105,6 +106,7 @@ do {    \
>  	case XFS_BTNUM_INO: __XFS_BTREE_STATS_INC(__mp, ibt, stat); break; \
>  	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_INC(__mp, fibt, stat); break; \
>  	case XFS_BTNUM_RMAP: __XFS_BTREE_STATS_INC(__mp, rmap, stat); break; \
> +	case XFS_BTNUM_REFC: break; \

I'd merge the refcount stats into this patch, it's a fairly tiny
addition to an already small patch.

> +static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
> +{
> +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&

no need for the braces here..

>  {
> -	mp->m_rmap_maxlevels = xfs_btree_compute_maxlevels(mp,
> -			mp->m_rmap_mnr, mp->m_sb.sb_agblocks);
> +	if (xfs_sb_version_hasreflink(&mp->m_sb))
> +		mp->m_rmap_maxlevels = XFS_BTREE_MAXLEVELS;
> +	else

Hmm, any good explanation for the magic XFS_BTREE_MAXLEVELS value
here?  Maybe even one that could go into a comment?

> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index a3c2e2d..6141d68 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -393,6 +393,9 @@ typedef struct xfs_perag {
>  	struct xfs_ag_resv	pag_meta_resv;
>  	/* Blocks reserved for just AGFL-based metadata. */
>  	struct xfs_ag_resv	pag_agfl_resv;
> +
> +	/* reference count */
> +	__uint8_t	pagf_refcount_level;
>  } xfs_perag_t;

The indentation doesn't seem to match the fields above.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
