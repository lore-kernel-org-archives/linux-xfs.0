Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B18C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Feb 2022 19:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbiBAT3B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Feb 2022 14:29:01 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38744 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239984AbiBAT3B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Feb 2022 14:29:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E21E61663
        for <linux-xfs@vger.kernel.org>; Tue,  1 Feb 2022 19:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80AECC340EB;
        Tue,  1 Feb 2022 19:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643743740;
        bh=G+njHgTXJFxyA1uwgk0O20lLhlGVrqWHfpOLw0V7zZk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IcipyKxffNzEos9ivBlDqkJQszOYeuW0tn2/mjnjZb7kHaDzAndcw4SVGFfBkf3eh
         HioF0+lhru1Sj4A+B53JoizWnfxuBUsUJmNviockDVqo8yR6HJPEtLHrozAmGfAZq5
         nzWTxfQWMbEgIRSWvwSAsQ57RZvDC9JMDYui7ldGPEjs6DoBe4o+7htFt/zySKrQPY
         yVYr0/cWQajH9a8hgRbOYhZ5BKdIgL14wnlvjPaADHgkRIxDaOoWfqdlf71VNzffsg
         vZuxezx1v64wb9ssATNCCpRc5mIqrm9Mx/FuKRBmolnseHS/iVCXZ2Wxd1LxSFhHqL
         1zDnTpVknGOmw==
Date:   Tue, 1 Feb 2022 11:29:00 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V5 15/20] xfsprogs: Enable bulkstat ioctl to support
 64-bit extent counters
Message-ID: <20220201192900.GM8313@magnolia>
References: <20220121052019.224605-1-chandan.babu@oracle.com>
 <20220121052019.224605-16-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121052019.224605-16-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 21, 2022 at 10:50:14AM +0530, Chandan Babu R wrote:
> This commit adds support to libfrog to enable reporting 64-bit extent counters
> to its users. In order to do so, bulkstat ioctl is now invoked with the newly
> introduced XFS_BULK_IREQ_NREXT64 flag if the underlying filesystem's geometry
> supports 64-bit extent counters.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  fsr/xfs_fsr.c      |  4 ++--
>  io/bulkstat.c      |  1 +
>  libfrog/bulkstat.c | 29 +++++++++++++++++++++++++++--
>  libxfs/xfs_fs.h    | 12 ++++++++----

On second thought: While you're adding comments to the definition of
XFS_BULK_IREQ_NREXT64 in xfs_fs.h, can you please update
man/man2/ioctl_xfs_bulkstat.2 as well?

--D

>  4 files changed, 38 insertions(+), 8 deletions(-)
> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index 6cf8bfb7..ba02506d 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -590,7 +590,7 @@ cmp(const void *s1, const void *s2)
>  		(bs1->bs_version == XFS_BULKSTAT_VERSION_V5 &&
>  		bs2->bs_version == XFS_BULKSTAT_VERSION_V5));
>  
> -	return (bs2->bs_extents - bs1->bs_extents);
> +	return (bs2->bs_extents64 - bs1->bs_extents64);
>  }
>  
>  /*
> @@ -655,7 +655,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
>  		for (p = buf, endp = (buf + buflenout); p < endp ; p++) {
>  			/* Do some obvious checks now */
>  			if (((p->bs_mode & S_IFMT) != S_IFREG) ||
> -			     (p->bs_extents < 2))
> +			     (p->bs_extents64 < 2))
>  				continue;
>  
>  			ret = -xfrog_bulkstat_v5_to_v1(&fsxfd, &bs1, p);
> diff --git a/io/bulkstat.c b/io/bulkstat.c
> index 201470b2..0c9a2b02 100644
> --- a/io/bulkstat.c
> +++ b/io/bulkstat.c
> @@ -57,6 +57,7 @@ dump_bulkstat(
>  	printf("\tbs_sick = 0x%"PRIx16"\n", bstat->bs_sick);
>  	printf("\tbs_checked = 0x%"PRIx16"\n", bstat->bs_checked);
>  	printf("\tbs_mode = 0%"PRIo16"\n", bstat->bs_mode);
> +	printf("\tbs_extents64 = %"PRIu64"\n", bstat->bs_extents64);
>  };
>  
>  static void
> diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
> index 195f6ea0..0a90947f 100644
> --- a/libfrog/bulkstat.c
> +++ b/libfrog/bulkstat.c
> @@ -56,6 +56,9 @@ xfrog_bulkstat_single5(
>  	if (flags & ~(XFS_BULK_IREQ_SPECIAL))
>  		return -EINVAL;
>  
> +	if (xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64)
> +		flags |= XFS_BULK_IREQ_NREXT64;
> +
>  	ret = xfrog_bulkstat_alloc_req(1, ino, &req);
>  	if (ret)
>  		return ret;
> @@ -73,6 +76,12 @@ xfrog_bulkstat_single5(
>  	}
>  
>  	memcpy(bulkstat, req->bulkstat, sizeof(struct xfs_bulkstat));
> +
> +	if (!(xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64)) {
> +		bulkstat->bs_extents64 = bulkstat->bs_extents;
> +		bulkstat->bs_extents = 0;
> +	}
> +
>  free:
>  	free(req);
>  	return ret;
> @@ -129,6 +138,7 @@ xfrog_bulkstat_single(
>  	switch (error) {
>  	case -EOPNOTSUPP:
>  	case -ENOTTY:
> +		assert(!(xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64));
>  		xfd->flags |= XFROG_FLAG_BULKSTAT_FORCE_V1;
>  		break;
>  	}
> @@ -259,10 +269,23 @@ xfrog_bulkstat5(
>  	struct xfs_bulkstat_req	*req)
>  {
>  	int			ret;
> +	int			i;
> +
> +	if (xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64)
> +		req->hdr.flags |= XFS_BULK_IREQ_NREXT64;
>  
>  	ret = ioctl(xfd->fd, XFS_IOC_BULKSTAT, req);
>  	if (ret)
>  		return -errno;
> +
> +	if (!(xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64)) {
> +		for (i = 0; i < req->hdr.ocount; i++) {
> +			req->bulkstat[i].bs_extents64 =
> +				req->bulkstat[i].bs_extents;
> +			req->bulkstat[i].bs_extents = 0;
> +		}
> +	}
> +
>  	return 0;
>  }
>  
> @@ -316,6 +339,7 @@ xfrog_bulkstat(
>  	switch (error) {
>  	case -EOPNOTSUPP:
>  	case -ENOTTY:
> +		assert(!(xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64));
>  		xfd->flags |= XFROG_FLAG_BULKSTAT_FORCE_V1;
>  		break;
>  	}
> @@ -342,6 +366,7 @@ xfrog_bulkstat_v5_to_v1(
>  	const struct xfs_bulkstat	*bs5)
>  {
>  	if (bs5->bs_aextents > UINT16_MAX ||
> +	    bs5->bs_extents64 > INT32_MAX ||
>  	    cvt_off_fsb_to_b(xfd, bs5->bs_extsize_blks) > UINT32_MAX ||
>  	    cvt_off_fsb_to_b(xfd, bs5->bs_cowextsize_blks) > UINT32_MAX ||
>  	    time_too_big(bs5->bs_atime) ||
> @@ -366,7 +391,7 @@ xfrog_bulkstat_v5_to_v1(
>  	bs1->bs_blocks = bs5->bs_blocks;
>  	bs1->bs_xflags = bs5->bs_xflags;
>  	bs1->bs_extsize = cvt_off_fsb_to_b(xfd, bs5->bs_extsize_blks);
> -	bs1->bs_extents = bs5->bs_extents;
> +	bs1->bs_extents = bs5->bs_extents64;
>  	bs1->bs_gen = bs5->bs_gen;
>  	bs1->bs_projid_lo = bs5->bs_projectid & 0xFFFF;
>  	bs1->bs_forkoff = bs5->bs_forkoff;
> @@ -407,7 +432,6 @@ xfrog_bulkstat_v1_to_v5(
>  	bs5->bs_blocks = bs1->bs_blocks;
>  	bs5->bs_xflags = bs1->bs_xflags;
>  	bs5->bs_extsize_blks = cvt_b_to_off_fsbt(xfd, bs1->bs_extsize);
> -	bs5->bs_extents = bs1->bs_extents;
>  	bs5->bs_gen = bs1->bs_gen;
>  	bs5->bs_projectid = bstat_get_projid(bs1);
>  	bs5->bs_forkoff = bs1->bs_forkoff;
> @@ -415,6 +439,7 @@ xfrog_bulkstat_v1_to_v5(
>  	bs5->bs_checked = bs1->bs_checked;
>  	bs5->bs_cowextsize_blks = cvt_b_to_off_fsbt(xfd, bs1->bs_cowextsize);
>  	bs5->bs_aextents = bs1->bs_aextents;
> +	bs5->bs_extents64 = bs1->bs_extents;
>  }
>  
>  /* Allocate a bulkstat request.  Returns zero or a negative error code. */
> diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
> index 42bc3950..f65bf2da 100644
> --- a/libxfs/xfs_fs.h
> +++ b/libxfs/xfs_fs.h
> @@ -393,7 +393,7 @@ struct xfs_bulkstat {
>  	uint32_t	bs_extsize_blks; /* extent size hint, blocks	*/
>  
>  	uint32_t	bs_nlink;	/* number of links		*/
> -	uint32_t	bs_extents;	/* number of extents		*/
> +	uint32_t	bs_extents;	/* 32-bit data fork extent counter */
>  	uint32_t	bs_aextents;	/* attribute number of extents	*/
>  	uint16_t	bs_version;	/* structure version		*/
>  	uint16_t	bs_forkoff;	/* inode fork offset in bytes	*/
> @@ -402,8 +402,9 @@ struct xfs_bulkstat {
>  	uint16_t	bs_checked;	/* checked inode metadata	*/
>  	uint16_t	bs_mode;	/* type and mode		*/
>  	uint16_t	bs_pad2;	/* zeroed			*/
> +	uint64_t	bs_extents64;	/* 64-bit data fork extent counter */
>  
> -	uint64_t	bs_pad[7];	/* zeroed			*/
> +	uint64_t	bs_pad[6];	/* zeroed			*/
>  };
>  
>  #define XFS_BULKSTAT_VERSION_V1	(1)
> @@ -484,8 +485,11 @@ struct xfs_bulk_ireq {
>   */
>  #define XFS_BULK_IREQ_SPECIAL	(1 << 1)
>  
> -#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO | \
> -				 XFS_BULK_IREQ_SPECIAL)
> +#define XFS_BULK_IREQ_NREXT64	(1 << 3)
> +
> +#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO |	 \
> +				 XFS_BULK_IREQ_SPECIAL | \
> +				 XFS_BULK_IREQ_NREXT64)
>  
>  /* Operate on the root directory inode. */
>  #define XFS_BULK_IREQ_SPECIAL_ROOT	(1)
> -- 
> 2.30.2
> 
