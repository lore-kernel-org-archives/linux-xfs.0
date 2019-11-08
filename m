Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 817F4C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 01:00:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45D442178F
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 01:00:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kNQ/n1Da"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbfKHBAx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 20:00:53 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45446 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfKHBAx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 20:00:53 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80wlAD187200;
        Fri, 8 Nov 2019 01:00:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Tsbyuk1Oa5Vv9yPa1wPU6l2JCYYlSAT73vQ+VyCjD2A=;
 b=kNQ/n1DaTft5hgOnUjoH5nkZnY7CQHG9Q5o0Cv2uXIar3MfpvhZmTYKiJFV6BfPUusYq
 zzhwP/Ag3epcF5dCxRyfr81dt4I/w/zdq6v3Z40fBgV0bcU8M6CJOtErMACgUsRSgtge
 Y2gg8Ibjb8WwUopEJq86RIn00+nA5zyfTD28F5Y4K8OQQcL9RgOkX1kXxNiM/q6U17ss
 edNJBbM0eIcT25ppjods1pzGPBFtxOyClUovxj3gBUFB/jgRxmDwEInWnMa3W8kDS0wq
 YJEV32B3spEM+ee6rXGLfHVxwBL7F0VtDPz2QSM8j44B/ozgdZzRn13ln9Vr+IxSsA/C cQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2w41w19yyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 01:00:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80rrnk163313;
        Fri, 8 Nov 2019 01:00:48 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2w41wjn8kq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 01:00:48 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA810msJ005337;
        Fri, 8 Nov 2019 01:00:48 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 17:00:47 -0800
Date:   Thu, 7 Nov 2019 17:00:47 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 34/46] xfs: cleanup xfs_dir2_data_freescan_int
Message-ID: <20191108010047.GE6219@magnolia>
References: <20191107182410.12660-1-hch@lst.de>
 <20191107182410.12660-35-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107182410.12660-35-hch@lst.de>
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

On Thu, Nov 07, 2019 at 07:23:58PM +0100, Christoph Hellwig wrote:
> Use an offset as the main means for iteration, and only do pointer
> arithmetics to find the data/unused entries.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_dir2_data.c | 48 +++++++++++++++--------------------
>  1 file changed, 20 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index 3ecec8e1c5f6..50e3fa092ff9 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -562,16 +562,15 @@ xfs_dir2_data_freeremove(
>   */
>  void
>  xfs_dir2_data_freescan_int(
> -	struct xfs_da_geometry	*geo,
> -	const struct xfs_dir_ops *ops,
> -	struct xfs_dir2_data_hdr *hdr,
> -	int			*loghead)
> +	struct xfs_da_geometry		*geo,
> +	const struct xfs_dir_ops	*ops,
> +	struct xfs_dir2_data_hdr	*hdr,
> +	int				*loghead)
>  {
> -	xfs_dir2_data_entry_t	*dep;		/* active data entry */
> -	xfs_dir2_data_unused_t	*dup;		/* unused data entry */
> -	struct xfs_dir2_data_free *bf;
> -	char			*endp;		/* end of block's data */
> -	char			*p;		/* current entry pointer */
> +	struct xfs_dir2_data_free	*bf = ops->data_bestfree_p(hdr);
> +	void				*addr = hdr;
> +	unsigned int			offset = ops->data_entry_offset;
> +	unsigned int			end;
>  
>  	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
>  	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
> @@ -581,37 +580,30 @@ xfs_dir2_data_freescan_int(
>  	/*
>  	 * Start by clearing the table.
>  	 */
> -	bf = ops->data_bestfree_p(hdr);
>  	memset(bf, 0, sizeof(*bf) * XFS_DIR2_DATA_FD_COUNT);
>  	*loghead = 1;
> -	/*
> -	 * Set up pointers.
> -	 */
> -	p = (char *)ops->data_entry_p(hdr);
> -	endp = xfs_dir3_data_endp(geo, hdr);
> -	/*
> -	 * Loop over the block's entries.
> -	 */
> -	while (p < endp) {
> -		dup = (xfs_dir2_data_unused_t *)p;
> +
> +	end = xfs_dir3_data_endp(geo, addr) - addr;
> +	while (offset < end) {
> +		struct xfs_dir2_data_unused	*dup = addr + offset;
> +		struct xfs_dir2_data_entry	*dep = addr + offset;
> +
>  		/*
>  		 * If it's a free entry, insert it.
>  		 */
>  		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
> -			ASSERT((char *)dup - (char *)hdr ==
> +			ASSERT(offset ==
>  			       be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)));
>  			xfs_dir2_data_freeinsert(hdr, bf, dup, loghead);
> -			p += be16_to_cpu(dup->length);
> +			offset += be16_to_cpu(dup->length);
> +			continue;
>  		}
> +
>  		/*
>  		 * For active entries, check their tags and skip them.
>  		 */
> -		else {
> -			dep = (xfs_dir2_data_entry_t *)p;
> -			ASSERT((char *)dep - (char *)hdr ==
> -			       be16_to_cpu(*ops->data_entry_tag_p(dep)));
> -			p += ops->data_entsize(dep->namelen);
> -		}
> +		ASSERT(offset == be16_to_cpu(*ops->data_entry_tag_p(dep)));
> +		offset += ops->data_entsize(dep->namelen);
>  	}
>  }
>  
> -- 
> 2.20.1
> 
