Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72FE6C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 18:34:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiF2Se2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 14:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiF2Se2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 14:34:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A05344FF
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 11:34:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67EEF61F40
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 18:34:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C98C34114;
        Wed, 29 Jun 2022 18:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656527665;
        bh=k4oKJE89mzYkdlDHfQpawaURHnZB1BF0PlZ+xGYAX6Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cyb721Vnt8yDlblDz89V12Tbc5H0f7t0ecAX482Sv1BpwEUAZkImP5JfLHVZq37Zj
         v6JV0BUOyR9RUxlQcmXU4rhammY6617npeaCkvsBHFbvUAw2UdxCqXY5n1JsAMmM3U
         jckiD9QDiGwL3O9Z0B+I0sS/qjlPNI7vrXl5xz8iUrSp3bJNoM3KXjDKyQZnmPpRFq
         eY1FkeEMjNX++2N1WsxNi1h8cjw/jOgDu7giApiGHC+f7JyTFmyEXcHjvPM6Tr30tu
         Qpd12Q//KoHraS8Yj5NFrryox6ZyrKMaY8vJSD8o4t1h2eiVJfQQx9M2e2ewf7caUT
         MPaEVmbPIPaSw==
Date:   Wed, 29 Jun 2022 11:34:25 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 07/17] xfs: define parent pointer xattr format
Message-ID: <YrybMUcB1c/fsWN1@magnolia>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
 <20220611094200.129502-8-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611094200.129502-8-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 11, 2022 at 02:41:50AM -0700, Allison Henderson wrote:
> We need to define the parent pointer attribute format before we start
> adding support for it into all the code that needs to use it. The EA
> format we will use encodes the following information:
> 
>         name={parent inode #, parent inode generation, dirent offset}
>         value={dirent filename}
> 
> The inode/gen gives all the information we need to reliably identify the
> parent without requiring child->parent lock ordering, and allows
> userspace to do pathname component level reconstruction without the
> kernel ever needing to verify the parent itself as part of ioctl calls.
> 
> By using the dirent offset in the EA name, we have a method of knowing
> the exact parent pointer EA we need to modify/remove in rename/unlink
> without an unbound EA name search.
> 
> By keeping the dirent name in the value, we have enough information to
> be able to validate and reconstruct damaged directory trees. While the
> diroffset of a filename alone is not unique enough to identify the
> child, the {diroffset,filename,child_inode} tuple is sufficient. That
> is, if the diroffset gets reused and points to a different filename, we
> can detect that from the contents of EA. If a link of the same name is
> created, then we can check whether it points at the same inode as the
> parent EA we current have.
> 
> [achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
>            changed p_ino to xfs_ino_t and p_namelen to uint8_t,
>            moved to xfs_da_format for xfs_dir2_dataptr_t]
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong<darrick.wong@oracle.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_da_format.h | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
> index 2d771e6429f2..6ac8c8dd4aab 100644
> --- a/fs/xfs/libxfs/xfs_da_format.h
> +++ b/fs/xfs/libxfs/xfs_da_format.h
> @@ -805,4 +805,29 @@ static inline unsigned int xfs_dir2_dirblock_bytes(struct xfs_sb *sbp)
>  xfs_failaddr_t xfs_da3_blkinfo_verify(struct xfs_buf *bp,
>  				      struct xfs_da3_blkinfo *hdr3);
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
> 2.25.1
> 
