Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ED0CC43331
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 00:59:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E46CB2178F
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 00:59:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H2hzIHUf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbfKHA7T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 19:59:19 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:52608 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbfKHA7T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 19:59:19 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80wsCa160909;
        Fri, 8 Nov 2019 00:59:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=jED3BrQtOsFVFBtTnzJK/Wt+UV2+NMg67JhmRygy6S0=;
 b=H2hzIHUf8jvlP4GClnBzG/+u+pLyGK38Rc2YwqOsSTHJcdzXHYT5R8RPL50i781H0ZDL
 R7sOMivU+183JVJsUFKFJlSk595rNfbxVuiFL7RpqRXlR8kVmJDS1/YSbddwe4ABFQv8
 8keqSRLjWOVpCu/HXn33U7apjczem6PoZShfRFQBSHTQqcwM8dMsYrm3bGJQs1/9SxNR
 mznSvh6Kcu7+0VKKtPm+VWZ9CihAewkHcTwNEHgxwXydTY9h1xZgfnVxZiAwpdi6mwXy
 IJkJPxtHv2bCrb92GM5w+jNltiszRmEi892k6o5pGtMo3ogpL/i0k2G1OYoS0pOJYWz3 5A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2w41w11yqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 00:59:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80s4Lf035496;
        Fri, 8 Nov 2019 00:59:16 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2w41wb7rb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 00:59:16 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA80xF3T021092;
        Fri, 8 Nov 2019 00:59:15 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 16:59:15 -0800
Date:   Thu, 7 Nov 2019 16:59:15 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 33/46] xfs: cleanup xfs_dir2_block_to_sf
Message-ID: <20191108005915.GD6219@magnolia>
References: <20191107182410.12660-1-hch@lst.de>
 <20191107182410.12660-34-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107182410.12660-34-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080006
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

On Thu, Nov 07, 2019 at 07:23:57PM +0100, Christoph Hellwig wrote:
> Use an offset as the main means for iteration, and only do pointer
> arithmetics to find the data/unused entries.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fairly straightforward...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_dir2_sf.c | 68 ++++++++++++++-----------------------
>  1 file changed, 25 insertions(+), 43 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index 39a537c61b04..a1aed589dc8c 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -255,64 +255,48 @@ xfs_dir2_block_sfsize(
>   */
>  int						/* error */
>  xfs_dir2_block_to_sf(
> -	xfs_da_args_t		*args,		/* operation arguments */
> +	struct xfs_da_args	*args,		/* operation arguments */
>  	struct xfs_buf		*bp,
>  	int			size,		/* shortform directory size */
> -	xfs_dir2_sf_hdr_t	*sfhp)		/* shortform directory hdr */
> +	struct xfs_dir2_sf_hdr	*sfhp)		/* shortform directory hdr */
>  {
> -	xfs_dir2_data_hdr_t	*hdr;		/* block header */
> -	xfs_dir2_data_entry_t	*dep;		/* data entry pointer */
> -	xfs_inode_t		*dp;		/* incore directory inode */
> -	xfs_dir2_data_unused_t	*dup;		/* unused data pointer */
> -	char			*endptr;	/* end of data entries */
> +	struct xfs_inode	*dp = args->dp;
> +	struct xfs_mount	*mp = dp->i_mount;
>  	int			error;		/* error return value */
>  	int			logflags;	/* inode logging flags */
> -	xfs_mount_t		*mp;		/* filesystem mount point */
> -	char			*ptr;		/* current data pointer */
> -	xfs_dir2_sf_entry_t	*sfep;		/* shortform entry */
> -	xfs_dir2_sf_hdr_t	*sfp;		/* shortform directory header */
> -	xfs_dir2_sf_hdr_t	*dst;		/* temporary data buffer */
> +	struct xfs_dir2_sf_entry *sfep;		/* shortform entry */
> +	struct xfs_dir2_sf_hdr	*sfp;		/* shortform directory header */
> +	unsigned int		offset = dp->d_ops->data_entry_offset;
> +	unsigned int		end;
>  
>  	trace_xfs_dir2_block_to_sf(args);
>  
> -	dp = args->dp;
> -	mp = dp->i_mount;
> -
>  	/*
> -	 * allocate a temporary destination buffer the size of the inode
> -	 * to format the data into. Once we have formatted the data, we
> -	 * can free the block and copy the formatted data into the inode literal
> -	 * area.
> +	 * Allocate a temporary destination buffer the size of the inode to
> +	 * format the data into.  Once we have formatted the data, we can free
> +	 * the block and copy the formatted data into the inode literal area.
>  	 */
> -	dst = kmem_alloc(mp->m_sb.sb_inodesize, 0);
> -	hdr = bp->b_addr;
> -
> -	/*
> -	 * Copy the header into the newly allocate local space.
> -	 */
> -	sfp = (xfs_dir2_sf_hdr_t *)dst;
> +	sfp = kmem_alloc(mp->m_sb.sb_inodesize, 0);
>  	memcpy(sfp, sfhp, xfs_dir2_sf_hdr_size(sfhp->i8count));
>  
>  	/*
> -	 * Set up to loop over the block's entries.
> +	 * Loop over the active and unused entries.  Stop when we reach the
> +	 * leaf/tail portion of the block.
>  	 */
> -	ptr = (char *)dp->d_ops->data_entry_p(hdr);
> -	endptr = xfs_dir3_data_endp(args->geo, hdr);
> +	end = xfs_dir3_data_endp(args->geo, bp->b_addr) - bp->b_addr;
>  	sfep = xfs_dir2_sf_firstentry(sfp);
> -	/*
> -	 * Loop over the active and unused entries.
> -	 * Stop when we reach the leaf/tail portion of the block.
> -	 */
> -	while (ptr < endptr) {
> +	while (offset < end) {
> +		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
> +		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
> +
>  		/*
>  		 * If it's unused, just skip over it.
>  		 */
> -		dup = (xfs_dir2_data_unused_t *)ptr;
>  		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
> -			ptr += be16_to_cpu(dup->length);
> +			offset += be16_to_cpu(dup->length);
>  			continue;
>  		}
> -		dep = (xfs_dir2_data_entry_t *)ptr;
> +
>  		/*
>  		 * Skip .
>  		 */
> @@ -330,9 +314,7 @@ xfs_dir2_block_to_sf(
>  		 */
>  		else {
>  			sfep->namelen = dep->namelen;
> -			xfs_dir2_sf_put_offset(sfep,
> -				(xfs_dir2_data_aoff_t)
> -				((char *)dep - (char *)hdr));
> +			xfs_dir2_sf_put_offset(sfep, offset);
>  			memcpy(sfep->name, dep->name, dep->namelen);
>  			xfs_dir2_sf_put_ino(mp, sfp, sfep,
>  					      be64_to_cpu(dep->inumber));
> @@ -341,7 +323,7 @@ xfs_dir2_block_to_sf(
>  
>  			sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep);
>  		}
> -		ptr += dp->d_ops->data_entsize(dep->namelen);
> +		offset += dp->d_ops->data_entsize(dep->namelen);
>  	}
>  	ASSERT((char *)sfep - (char *)sfp == size);
>  
> @@ -360,7 +342,7 @@ xfs_dir2_block_to_sf(
>  	 * Convert the inode to local format and copy the data in.
>  	 */
>  	ASSERT(dp->i_df.if_bytes == 0);
> -	xfs_init_local_fork(dp, XFS_DATA_FORK, dst, size);
> +	xfs_init_local_fork(dp, XFS_DATA_FORK, sfp, size);
>  	dp->i_d.di_format = XFS_DINODE_FMT_LOCAL;
>  	dp->i_d.di_size = size;
>  
> @@ -368,7 +350,7 @@ xfs_dir2_block_to_sf(
>  	xfs_dir2_sf_check(args);
>  out:
>  	xfs_trans_log_inode(args->trans, dp, logflags);
> -	kmem_free(dst);
> +	kmem_free(sfp);
>  	return error;
>  }
>  
> -- 
> 2.20.1
> 
