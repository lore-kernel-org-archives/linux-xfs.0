Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95371C3A59B
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 15:06:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6568B2341B
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 15:06:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JM7XdoHB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbfH3PG4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 11:06:56 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44554 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727603AbfH3PG4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 11:06:56 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7UF41e2132783;
        Fri, 30 Aug 2019 15:06:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=fejSpbS4zwEVItir4WWWSCTFLCmtenCZMJniFlABPqk=;
 b=JM7XdoHBidtnewwBp4dgT9Ci7wjXkwC3/bmMEMbiwcrA9U/OM8FShJ1VT+FTcdwpZDGJ
 wFXBQ9traodpCm4JsckzITzU5aqdvRBXL37Jk0TWu83rOWZvYw/3MYrlgHkFfcqxkRyQ
 w5Pi1lhyoqBgcCyJ5kc/paCZ+WNm5Eu4zu9cwfeKdyVDWh/vqS5FCfJRaQxXQ4q+N8c0
 nINV0DPVwwiAX2dvnUh1awuvN7gyToHXjqYNpF2y4LsgCl5/daRRHBhGMITo5BuNlk3C
 nUq7+rlE+CBeLfxD2ByYnj56qwR+DCHo8LANRU55a5w8wj0O/Zzyh6JfFWSR4tjtNFT/ OA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2uq5tx84j7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 15:06:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7UF3umc163334;
        Fri, 30 Aug 2019 15:06:52 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2upc8xk4f7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 15:06:52 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7UF6oMg006865;
        Fri, 30 Aug 2019 15:06:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 30 Aug 2019 08:06:50 -0700
Date:   Fri, 30 Aug 2019 08:06:50 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: add a xfs_valid_startblock helper
Message-ID: <20190830150650.GA5354@magnolia>
References: <20190830102411.519-1-hch@lst.de>
 <20190830102411.519-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830102411.519-2-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908300153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908300153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 30, 2019 at 12:24:09PM +0200, Christoph Hellwig wrote:
> Add a helper that validates the startblock is valid.  This checks for a
> non-zero block on the main device, but skips that check for blocks on
> the realtime device.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 2 +-
>  fs/xfs/libxfs/xfs_bmap.h | 3 +++
>  fs/xfs/xfs_iomap.c       | 6 +++---
>  3 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 05aedf4a538c..80b25e21e708 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4519,7 +4519,7 @@ xfs_bmapi_convert_delalloc(
>  	if (WARN_ON_ONCE(bma.blkno == NULLFSBLOCK))
>  		goto out_finish;
>  	error = -EFSCORRUPTED;
> -	if (WARN_ON_ONCE(!bma.got.br_startblock && !XFS_IS_REALTIME_INODE(ip)))
> +	if (WARN_ON_ONCE(!xfs_valid_startblock(ip, bma.got.br_startblock)))
>  		goto out_finish;
>  
>  	XFS_STATS_ADD(mp, xs_xstrat_bytes, XFS_FSB_TO_B(mp, bma.length));
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index c409871a096e..7efa56e8750f 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -171,6 +171,9 @@ static inline bool xfs_bmap_is_real_extent(struct xfs_bmbt_irec *irec)
>  		!isnullstartblock(irec->br_startblock);
>  }
>  
> +#define xfs_valid_startblock(ip, startblock) \
> +	((startblock) != 0 || XFS_IS_REALTIME_INODE(ip))

We have more robust validators for data/rtdev fsblock_t, so why not:

#define xfs_valid_startblock(ip, startblock) \
	(XFS_IS_REALTIME_INODE(ip) ? xfs_verify_rtbno(startblock) : \
				     xfs_verify_fsbno(startblock))

and why not make it a static inline function too?

--D

> +
>  void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
>  		xfs_filblks_t len);
>  int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 3a4310d7cb59..f780e223b118 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -58,7 +58,7 @@ xfs_bmbt_to_iomap(
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  
> -	if (unlikely(!imap->br_startblock && !XFS_IS_REALTIME_INODE(ip)))
> +	if (unlikely(!xfs_valid_startblock(ip, imap->br_startblock)))
>  		return xfs_alert_fsblock_zero(ip, imap);
>  
>  	if (imap->br_startblock == HOLESTARTBLOCK) {
> @@ -297,7 +297,7 @@ xfs_iomap_write_direct(
>  		goto out_unlock;
>  	}
>  
> -	if (!(imap->br_startblock || XFS_IS_REALTIME_INODE(ip)))
> +	if (unlikely(!xfs_valid_startblock(ip, imap->br_startblock)))
>  		error = xfs_alert_fsblock_zero(ip, imap);
>  
>  out_unlock:
> @@ -814,7 +814,7 @@ xfs_iomap_write_unwritten(
>  		if (error)
>  			return error;
>  
> -		if (!(imap.br_startblock || XFS_IS_REALTIME_INODE(ip)))
> +		if (unlikely(!xfs_valid_startblock(ip, imap.br_startblock)))
>  			return xfs_alert_fsblock_zero(ip, &imap);
>  
>  		if ((numblks_fsb = imap.br_blockcount) == 0) {
> -- 
> 2.20.1
> 
