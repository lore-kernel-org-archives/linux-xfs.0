Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48456 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752877AbeEGWfp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 18:35:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w47MVwBj085061
        for <linux-xfs@vger.kernel.org>; Mon, 7 May 2018 22:35:45 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2hs5936534-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 May 2018 22:35:44 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w47MZiAP010131
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 7 May 2018 22:35:44 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w47MZiQN006047
        for <linux-xfs@vger.kernel.org>; Mon, 7 May 2018 22:35:44 GMT
Date: Mon, 7 May 2018 15:35:42 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 12/21] xfs: define parent pointer xattr format
Message-ID: <20180507223542.GJ11261@magnolia>
References: <1525627494-12873-1-git-send-email-allison.henderson@oracle.com>
 <1525627494-12873-13-git-send-email-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1525627494-12873-13-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sun, May 06, 2018 at 10:24:45AM -0700, Allison Henderson wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We need to define the parent pointer attribute format before we
> start adding support for it into all the code that needs to use it.
> The EA format we will use encodes the following information:
> 
> 	name={parent inode #, parent inode generation, dirent offset}
> 	value={dirent filename}
> 
> The inode/gen gives all the information we need to reliably identify
> the parent without requiring child->parent lock ordering, and allows
> userspace to do pathname component level reconstruction without the
> kernel ever needing to verify the parent itself as part of ioctl
> calls.
> 
> By using the dirent offset in the EA name, we have a method of
> knowing the exact parent pointer EA we need to modify/remove in
> rename/unlink without an unbound EA name search.
> 
> By keeping the dirent name in the value, we have enough information
> to be able to validate and reconstruct damaged directory trees.
> While the diroffset of a filename alone is not unique enough to
> identify the child, the {diroffset,filename,child_inode} tuple is
> sufficient. That is, if the diroffset gets reused and points to a
> different filename, we can detect that from the contents of EA. If a
> link of the same name is created, then we can check whether it
> points at the same inode as the parent EA we current have.
> 
> [achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
> 	   changed p_ino to xfs_ino_t and p_namelen to uint8_t,
> 	   moved to xfs_da_format for xfs_dir2_dataptr_t]
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong<darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_da_format.h | 26 +++++++++++++++++++++++++-
>  1 file changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
> index 9bd2e6b..d1c1221 100644
> --- a/fs/xfs/libxfs/xfs_da_format.h
> +++ b/fs/xfs/libxfs/xfs_da_format.h
> @@ -878,11 +878,35 @@ struct xfs_attr3_rmt_hdr {
>  #define XFS_ATTR3_RMT_BUF_SPACE(mp, bufsize)	\
>  	((bufsize) - (xfs_sb_version_hascrc(&(mp)->m_sb) ? \
>  			sizeof(struct xfs_attr3_rmt_hdr) : 0))
> -

Unrelated/unnecessary whitespace removal?  Otherwise this is still
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D


>  /* Number of bytes in a directory block. */
>  static inline unsigned int xfs_dir2_dirblock_bytes(struct xfs_sb *sbp)
>  {
>  	return 1 << (sbp->sb_blocklog + sbp->sb_dirblklog);
>  }
>  
> +/*
> + * Parent pointer attribute format definition
> + *
> + * EA name encodes the parent inode number, generation and the offset of
> + * the dirent that points to the child inode. The EA value contains the
> + * same name as the dirent in the parent directory.
> + */
> +struct xfs_parent_name_rec {
> +	__be64  p_ino;
> +	__be32  p_gen;
> +	__be32  p_diroffset;
> +};
> +
> +/*
> + * incore version of the above, also contains name pointers so callers
> + * can pass/obtain all the parent pointer information in a single structure
> + */
> +struct xfs_parent_name_irec {
> +	xfs_ino_t		p_ino;
> +	uint32_t		p_gen;
> +	xfs_dir2_dataptr_t	p_diroffset;
> +	const char		*p_name;
> +	uint8_t			p_namelen;
> +};
> +
>  #endif /* __XFS_DA_FORMAT_H__ */
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
