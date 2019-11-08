Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34E9EC43331
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 01:04:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E155C21D79
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 01:04:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RSLnrw0Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbfKHBEZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 20:04:25 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:57538 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbfKHBEZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 20:04:25 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80wslM160912;
        Fri, 8 Nov 2019 01:04:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=n6soRTRAFs84QxebuodJuMHWk5RT2cMai5akgoKHfxI=;
 b=RSLnrw0YD7ZywR5H2GT3DgLofHEYVtHxOXgiwqpZNyB6N95HD0Wk/VJsQE+cyPca/Rb4
 q5XuzN58zukBdbYmxh1IM7mtijmz5i82V+rGLbVNbb001S+dY+ZmUN/IE6a9s7N7Koa7
 b9gZn7u7fnZOeneXyYbjmdDi2edmEMIY7wrUqcx+xGH9K+mkFg/tD2gf7pldPRHuegcD
 pKudQnMDZWuRYiYh6oAUncF6UfAzFsdmHzmRBAFwQeGdHA1vmqQqt5HzVLhsH0hSue2G
 EGVLgXaKuy6BZS2W1aRvSu5U3hViw+wLCFBsbusmfMosKfIb6V+D9HlDdkIrFmAUISQQ kQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2w41w120c6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 01:04:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA814JQt188471;
        Fri, 8 Nov 2019 01:04:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2w41wjnf32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 01:04:19 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA814HmW015349;
        Fri, 8 Nov 2019 01:04:17 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 17:04:17 -0800
Date:   Thu, 7 Nov 2019 17:04:11 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 37/46] xfs: replace xfs_dir3_data_endp with
 xfs_dir3_data_end_offset
Message-ID: <20191108010411.GH6219@magnolia>
References: <20191107182410.12660-1-hch@lst.de>
 <20191107182410.12660-38-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107182410.12660-38-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080007
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 07:24:01PM +0100, Christoph Hellwig wrote:
> All the callers really want an offset into the buffer, so adopt
> the helper to return that instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

/me feels like he's been walked down the dirent^Wgarden path...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_dir2.h      |  2 +-
>  fs/xfs/libxfs/xfs_dir2_data.c | 29 +++++++++++++++--------------
>  fs/xfs/libxfs/xfs_dir2_sf.c   |  2 +-
>  fs/xfs/scrub/dir.c            | 10 +++++-----
>  fs/xfs/xfs_dir2_readdir.c     |  2 +-
>  5 files changed, 23 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index a160f2d4ff37..3a4b98d4973d 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -266,7 +266,7 @@ xfs_dir2_leaf_tail_p(struct xfs_da_geometry *geo, struct xfs_dir2_leaf *lp)
>  #define XFS_READDIR_BUFSIZE	(32768)
>  
>  unsigned char xfs_dir3_get_dtype(struct xfs_mount *mp, uint8_t filetype);
> -void *xfs_dir3_data_endp(struct xfs_da_geometry *geo,
> +unsigned int xfs_dir3_data_end_offset(struct xfs_da_geometry *geo,
>  		struct xfs_dir2_data_hdr *hdr);
>  bool xfs_dir2_namecheck(const void *name, size_t length);
>  
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index 8c729270f9f1..f5fa8b9187b0 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -55,7 +55,6 @@ __xfs_dir3_data_check(
>  	int			count;		/* count of entries found */
>  	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
>  	xfs_dir2_data_free_t	*dfp;		/* bestfree entry */
> -	void			*endp;		/* end of useful data */
>  	int			freeseen;	/* mask of bestfrees seen */
>  	xfs_dahash_t		hash;		/* hash of current name */
>  	int			i;		/* leaf index */
> @@ -102,10 +101,9 @@ __xfs_dir3_data_check(
>  	default:
>  		return __this_address;
>  	}
> -	endp = xfs_dir3_data_endp(geo, hdr);
> -	if (!endp)
> +	end = xfs_dir3_data_end_offset(geo, hdr);
> +	if (!end)
>  		return __this_address;
> -	end = endp - bp->b_addr;
>  
>  	/*
>  	 * Account for zero bestfree entries.
> @@ -590,7 +588,7 @@ xfs_dir2_data_freescan_int(
>  	memset(bf, 0, sizeof(*bf) * XFS_DIR2_DATA_FD_COUNT);
>  	*loghead = 1;
>  
> -	end = xfs_dir3_data_endp(geo, addr) - addr;
> +	end = xfs_dir3_data_end_offset(geo, addr);
>  	while (offset < end) {
>  		struct xfs_dir2_data_unused	*dup = addr + offset;
>  		struct xfs_dir2_data_entry	*dep = addr + offset;
> @@ -784,11 +782,11 @@ xfs_dir2_data_make_free(
>  {
>  	xfs_dir2_data_hdr_t	*hdr;		/* data block pointer */
>  	xfs_dir2_data_free_t	*dfp;		/* bestfree pointer */
> -	char			*endptr;	/* end of data area */
>  	int			needscan;	/* need to regen bestfree */
>  	xfs_dir2_data_unused_t	*newdup;	/* new unused entry */
>  	xfs_dir2_data_unused_t	*postdup;	/* unused entry after us */
>  	xfs_dir2_data_unused_t	*prevdup;	/* unused entry before us */
> +	unsigned int		end;
>  	struct xfs_dir2_data_free *bf;
>  
>  	hdr = bp->b_addr;
> @@ -796,8 +794,8 @@ xfs_dir2_data_make_free(
>  	/*
>  	 * Figure out where the end of the data area is.
>  	 */
> -	endptr = xfs_dir3_data_endp(args->geo, hdr);
> -	ASSERT(endptr != NULL);
> +	end = xfs_dir3_data_end_offset(args->geo, hdr);
> +	ASSERT(end != 0);
>  
>  	/*
>  	 * If this isn't the start of the block, then back up to
> @@ -816,7 +814,7 @@ xfs_dir2_data_make_free(
>  	 * If this isn't the end of the block, see if the entry after
>  	 * us is free.
>  	 */
> -	if ((char *)hdr + offset + len < endptr) {
> +	if (offset + len < end) {
>  		postdup =
>  			(xfs_dir2_data_unused_t *)((char *)hdr + offset + len);
>  		if (be16_to_cpu(postdup->freetag) != XFS_DIR2_DATA_FREE_TAG)
> @@ -1144,19 +1142,22 @@ xfs_dir2_data_use_free(
>  }
>  
>  /* Find the end of the entry data in a data/block format dir block. */
> -void *
> -xfs_dir3_data_endp(
> +unsigned int
> +xfs_dir3_data_end_offset(
>  	struct xfs_da_geometry		*geo,
>  	struct xfs_dir2_data_hdr	*hdr)
>  {
> +	void				*p;
> +
>  	switch (hdr->magic) {
>  	case cpu_to_be32(XFS_DIR3_BLOCK_MAGIC):
>  	case cpu_to_be32(XFS_DIR2_BLOCK_MAGIC):
> -		return xfs_dir2_block_leaf_p(xfs_dir2_block_tail_p(geo, hdr));
> +		p = xfs_dir2_block_leaf_p(xfs_dir2_block_tail_p(geo, hdr));
> +		return p - (void *)hdr;
>  	case cpu_to_be32(XFS_DIR3_DATA_MAGIC):
>  	case cpu_to_be32(XFS_DIR2_DATA_MAGIC):
> -		return (char *)hdr + geo->blksize;
> +		return geo->blksize;
>  	default:
> -		return NULL;
> +		return 0;
>  	}
>  }
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index a1aed589dc8c..bb6491a3c473 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -283,7 +283,7 @@ xfs_dir2_block_to_sf(
>  	 * Loop over the active and unused entries.  Stop when we reach the
>  	 * leaf/tail portion of the block.
>  	 */
> -	end = xfs_dir3_data_endp(args->geo, bp->b_addr) - bp->b_addr;
> +	end = xfs_dir3_data_end_offset(args->geo, bp->b_addr);
>  	sfep = xfs_dir2_sf_firstentry(sfp);
>  	while (offset < end) {
>  		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index 4cef21b9d336..7f03f0fb178a 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -187,7 +187,7 @@ xchk_dir_rec(
>  	struct xfs_dir2_data_entry	*dent;
>  	struct xfs_buf			*bp;
>  	struct xfs_dir2_leaf_entry	*ent;
> -	void				*endp;
> +	unsigned int			end;
>  	unsigned int			offset;
>  	xfs_ino_t			ino;
>  	xfs_dablk_t			rec_bno;
> @@ -242,8 +242,8 @@ xchk_dir_rec(
>  
>  	/* Make sure we got a real directory entry. */
>  	offset = mp->m_dir_inode_ops->data_entry_offset;
> -	endp = xfs_dir3_data_endp(mp->m_dir_geo, bp->b_addr);
> -	if (!endp) {
> +	end = xfs_dir3_data_end_offset(mp->m_dir_geo, bp->b_addr);
> +	if (!end) {
>  		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
>  		goto out_relse;
>  	}
> @@ -251,7 +251,7 @@ xchk_dir_rec(
>  		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
>  		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
>  	
> -		if (offset >= endp - bp->b_addr) {
> +		if (offset >= end) {
>  			xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
>  			goto out_relse;
>  		}
> @@ -390,7 +390,7 @@ xchk_directory_data_bestfree(
>  
>  	/* Make sure the bestfrees are actually the best free spaces. */
>  	offset = d_ops->data_entry_offset;
> -	end = xfs_dir3_data_endp(mp->m_dir_geo, bp->b_addr) - bp->b_addr;
> +	end = xfs_dir3_data_end_offset(mp->m_dir_geo, bp->b_addr);
>  
>  	/* Iterate the entries, stopping when we hit or go past the end. */
>  	while (offset < end) {
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index c4314e9e3dd8..6d229aa93d01 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -175,7 +175,7 @@ xfs_dir2_block_getdents(
>  	 * Each object is a real entry (dep) or an unused one (dup).
>  	 */
>  	offset = dp->d_ops->data_entry_offset;
> -	end = xfs_dir3_data_endp(geo, bp->b_addr) - bp->b_addr;
> +	end = xfs_dir3_data_end_offset(geo, bp->b_addr);
>  	while (offset < end) {
>  		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
>  		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
> -- 
> 2.20.1
> 
