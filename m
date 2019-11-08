Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 798EAC43331
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 00:59:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43FA82178F
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 00:59:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LbQ9liya"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfKHA7I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 19:59:08 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43670 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbfKHA7I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 19:59:08 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80wmGw187237;
        Fri, 8 Nov 2019 00:59:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=kYgLSPrMIYwGIWgpVkjXJjj+XRU3pjcF5+yERQNMcC8=;
 b=LbQ9liyaUCZYJSWP7ZFGorNYjeD6oBHKreWiX0ZJe6O04rtDsv7vDtSPE+3WuPfmmqU7
 hqmae1McovgkH5Jrs4GOFMzblG6Q/j5MqLzcM80jDsQQHd8DTFafOUMHEGUdisq6FJEW
 Q0MSrJz++Aw9i/6Oe9W294+Yo99gQxa9y7piSThyAweRvRfiurU7fQM2MkNv21qIbv62
 26HeNcD1wfZ01heym38rlvZXWJyQac7R9BR4JJZmscnJ8Tz0CVi54gXW54ubwuaDk+Fm
 pj1SaBlG+rYbyO2ImuGgGaLZln9mpLrKPuwam9K7xSMJhUw35cS6bsxapn4jJzI/BPMc Wg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2w41w19ysn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 00:59:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80rsJA163353;
        Fri, 8 Nov 2019 00:57:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2w41wjmxwx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 00:57:01 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA80v0Nx010764;
        Fri, 8 Nov 2019 00:57:00 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 16:57:00 -0800
Date:   Thu, 7 Nov 2019 16:57:00 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 31/46] xfs: cleanup xchk_dir_rec
Message-ID: <20191108005700.GB6219@magnolia>
References: <20191107182410.12660-1-hch@lst.de>
 <20191107182410.12660-32-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107182410.12660-32-hch@lst.de>
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

On Thu, Nov 07, 2019 at 07:23:55PM +0100, Christoph Hellwig wrote:
> Use an offset as the main means for iteration, and only do pointer
> arithmetics to find the data/unused entries.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/scrub/dir.c | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index bb08a1cbe523..501d60c9b09a 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -187,7 +187,8 @@ xchk_dir_rec(
>  	struct xfs_dir2_data_entry	*dent;
>  	struct xfs_buf			*bp;
>  	struct xfs_dir2_leaf_entry	*ent;
> -	char				*p, *endp;
> +	void				*endp;
> +	unsigned int			offset;

Can this be named iter_off or something?  There's already an @off variable
which is the offset-within-block that wa calculated from the entry pointer.

>  	xfs_ino_t			ino;
>  	xfs_dablk_t			rec_bno;
>  	xfs_dir2_db_t			db;
> @@ -237,32 +238,31 @@ xchk_dir_rec(
>  	if (ds->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
>  		goto out_relse;
>  
> -	dent = (struct xfs_dir2_data_entry *)(((char *)bp->b_addr) + off);
> +	dent = bp->b_addr + off;
>  
>  	/* Make sure we got a real directory entry. */
> -	p = (char *)mp->m_dir_inode_ops->data_entry_p(bp->b_addr);
> +	offset = mp->m_dir_inode_ops->data_entry_offset;
>  	endp = xfs_dir3_data_endp(mp->m_dir_geo, bp->b_addr);
>  	if (!endp) {
>  		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
>  		goto out_relse;
>  	}
> -	while (p < endp) {
> -		struct xfs_dir2_data_entry	*dep;
> -		struct xfs_dir2_data_unused	*dup;
> +	for (;;) {
> +		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
> +		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
> +	

Extra whitespace.

--D

> +		if (offset >= endp - bp->b_addr) {
> +			xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
> +			goto out_relse;
> +		}
>  
> -		dup = (struct xfs_dir2_data_unused *)p;
>  		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
> -			p += be16_to_cpu(dup->length);
> +			offset += be16_to_cpu(dup->length);
>  			continue;
>  		}
> -		dep = (struct xfs_dir2_data_entry *)p;
>  		if (dep == dent)
>  			break;
> -		p += mp->m_dir_inode_ops->data_entsize(dep->namelen);
> -	}
> -	if (p >= endp) {
> -		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
> -		goto out_relse;
> +		offset += mp->m_dir_inode_ops->data_entsize(dep->namelen);
>  	}
>  
>  	/* Retrieve the entry, sanity check it, and compare hashes. */
> -- 
> 2.20.1
> 
