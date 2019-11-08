Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20C3AC43331
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 00:57:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA55E2178F
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 00:57:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Gf1ey5Sa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbfKHA5z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 19:57:55 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35510 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbfKHA5z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 19:57:55 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80sMvm170081;
        Fri, 8 Nov 2019 00:57:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=WIq0UN3tnap2glNUQu860XpHEFjUq3+d8zgX9K6pE1k=;
 b=Gf1ey5Sa9w+fzTEX+zASI70w2v0jX+9hOfNy24mzjh0fy8wxs5ExxSq8JJQ/UjGBhw00
 bxa186708olHcl7d3rn4Ve69NXFWSyoiO6XZMh0kT9cqJJXcCaJRYGteIJkXdwqTnhIY
 OPVePXEdvVGcyd6RVIDI1CIfgnKjbFqZLlo5HXuBfGl7V7U9DVRd/5d1Lg8sDo1SnjIj
 LwjYuU4dW2ZmQWHttUHN5keEXsTm9v61LAY7JdSiZCtrrnYyeIKOHfI7j2hwoIwM+bqq
 m+tc57zNibdtsQ7K8SKaPlZSJe/xhGdXaivLddAqz/uQXur0yIepgq4MSvGtr5M4dQVo Pg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2w41w11xdt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 00:57:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80rsHn163431;
        Fri, 8 Nov 2019 00:57:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2w41wjn21s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 00:57:50 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA80vnYe003330;
        Fri, 8 Nov 2019 00:57:49 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 16:57:49 -0800
Date:   Thu, 7 Nov 2019 16:57:49 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 32/46] xfs: cleanup xchk_directory_data_bestfree
Message-ID: <20191108005749.GC6219@magnolia>
References: <20191107182410.12660-1-hch@lst.de>
 <20191107182410.12660-33-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107182410.12660-33-hch@lst.de>
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
 definitions=main-1911080006
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 07:23:56PM +0100, Christoph Hellwig wrote:
> Use an offset as the main means for iteration, and only do pointer
> arithmetics to find the data/unused entries.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/scrub/dir.c | 31 +++++++++++++++----------------
>  1 file changed, 15 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index 501d60c9b09a..4cef21b9d336 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -327,14 +327,13 @@ xchk_directory_data_bestfree(
>  	struct xfs_dir2_data_free	*bf;
>  	struct xfs_mount		*mp = sc->mp;
>  	const struct xfs_dir_ops	*d_ops;
> -	char				*ptr;
> -	char				*endptr;
>  	u16				tag;
>  	unsigned int			nr_bestfrees = 0;
>  	unsigned int			nr_frees = 0;
>  	unsigned int			smallest_bestfree;
>  	int				newlen;
> -	int				offset;
> +	unsigned int			offset;
> +	unsigned int			end;
>  	int				error;
>  
>  	d_ops = sc->ip->d_ops;
> @@ -368,13 +367,13 @@ xchk_directory_data_bestfree(
>  			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
>  			goto out_buf;
>  		}
> -		dup = (struct xfs_dir2_data_unused *)(bp->b_addr + offset);
> +		dup = bp->b_addr + offset;
>  		tag = be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup));
>  
>  		/* bestfree doesn't match the entry it points at? */
>  		if (dup->freetag != cpu_to_be16(XFS_DIR2_DATA_FREE_TAG) ||
>  		    be16_to_cpu(dup->length) != be16_to_cpu(dfp->length) ||
> -		    tag != ((char *)dup - (char *)bp->b_addr)) {
> +		    tag != offset) {
>  			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
>  			goto out_buf;
>  		}
> @@ -390,30 +389,30 @@ xchk_directory_data_bestfree(
>  	}
>  
>  	/* Make sure the bestfrees are actually the best free spaces. */
> -	ptr = (char *)d_ops->data_entry_p(bp->b_addr);
> -	endptr = xfs_dir3_data_endp(mp->m_dir_geo, bp->b_addr);
> +	offset = d_ops->data_entry_offset;
> +	end = xfs_dir3_data_endp(mp->m_dir_geo, bp->b_addr) - bp->b_addr;
>  
>  	/* Iterate the entries, stopping when we hit or go past the end. */
> -	while (ptr < endptr) {
> -		dup = (struct xfs_dir2_data_unused *)ptr;
> +	while (offset < end) {
> +		dup = bp->b_addr + offset;
> +
>  		/* Skip real entries */
>  		if (dup->freetag != cpu_to_be16(XFS_DIR2_DATA_FREE_TAG)) {
> -			struct xfs_dir2_data_entry	*dep;
> +			struct xfs_dir2_data_entry *dep = bp->b_addr + offset;
>  
> -			dep = (struct xfs_dir2_data_entry *)ptr;
>  			newlen = d_ops->data_entsize(dep->namelen);
>  			if (newlen <= 0) {
>  				xchk_fblock_set_corrupt(sc, XFS_DATA_FORK,
>  						lblk);
>  				goto out_buf;
>  			}
> -			ptr += newlen;
> +			offset += newlen;
>  			continue;
>  		}
>  
>  		/* Spot check this free entry */
>  		tag = be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup));
> -		if (tag != ((char *)dup - (char *)bp->b_addr)) {
> +		if (tag != offset) {
>  			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
>  			goto out_buf;
>  		}
> @@ -432,13 +431,13 @@ xchk_directory_data_bestfree(
>  			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
>  			goto out_buf;
>  		}
> -		ptr += newlen;
> -		if (ptr <= endptr)
> +		offset += newlen;
> +		if (offset <= end)
>  			nr_frees++;
>  	}
>  
>  	/* We're required to fill all the space. */
> -	if (ptr != endptr)
> +	if (offset != end)
>  		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
>  
>  	/* Did we see at least as many free slots as there are bestfrees? */
> -- 
> 2.20.1
> 
