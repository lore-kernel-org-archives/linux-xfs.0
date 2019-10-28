Return-Path: <SRS0=q11v=YV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E399CCA9EC0
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 16:38:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA19720717
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 16:38:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y+RUKV2g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733186AbfJ1QiJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 12:38:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43454 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733084AbfJ1QiI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 12:38:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SGTF0t061519;
        Mon, 28 Oct 2019 16:38:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=VOi4TWmRV6KDm7RgnEi/gp6BBltCr5p8qM+jTSQvgjo=;
 b=Y+RUKV2g+xXrrQW4wAJ+wLityCSPUAs/vgWO+/eRJMdoG1ZIlvJogaz6bA+cW4PU0Yuu
 b0UME1MJ+p71SXNvseNrJgMYgpTPxhblUEv8pxBhhqQ8q93N7yVTjT7czZCl5HnpjlbK
 BNXSQwMa1ZFDwQblvv8c4/rZoDtwscbqiLDs0bU3oOAcvT5yeHOdqZRbZhuJa7ZV7y78
 ra7ysl5bRPtCI1UfPJlxc1JVOV3Z77O7SRD2XgmbmPoLZYLNLcPck3qQwtuK6kF7EzRo
 U/1t60PQtM8dFoNpoU3j+hQadCvFLy3Gw6XUBtiv0l5+S0T2DorbNXp5mVo8XvW80EPP 6g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2vvdju3bme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 16:38:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SGTH7Y096792;
        Mon, 28 Oct 2019 16:38:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2vvyn012ef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 16:38:04 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9SGc3jm024496;
        Mon, 28 Oct 2019 16:38:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Oct 2019 09:38:03 -0700
Date:   Mon, 28 Oct 2019 09:38:03 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: simplify setting bio flags
Message-ID: <20191028163803.GJ15222@magnolia>
References: <20191025174213.32143-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025174213.32143-1-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910280162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910280162
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 25, 2019 at 07:42:13PM +0200, Christoph Hellwig wrote:
> Stop using the deprecated bio_set_op_attrs helper, and use a single
> argument to xfs_buf_ioapply_map for the operation and flags.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_buf.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 9640e4174552..1e63dd3d1257 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1261,8 +1261,7 @@ xfs_buf_ioapply_map(
>  	int		map,
>  	int		*buf_offset,
>  	int		*count,
> -	int		op,
> -	int		op_flags)
> +	int		op)
>  {
>  	int		page_index;
>  	int		total_nr_pages = bp->b_page_count;
> @@ -1297,7 +1296,7 @@ xfs_buf_ioapply_map(
>  	bio->bi_iter.bi_sector = sector;
>  	bio->bi_end_io = xfs_buf_bio_end_io;
>  	bio->bi_private = bp;
> -	bio_set_op_attrs(bio, op, op_flags);
> +	bio->bi_opf = op;
>  
>  	for (; size && nr_pages; nr_pages--, page_index++) {
>  		int	rbytes, nbytes = PAGE_SIZE - offset;
> @@ -1342,7 +1341,6 @@ _xfs_buf_ioapply(
>  {
>  	struct blk_plug	plug;
>  	int		op;
> -	int		op_flags = 0;
>  	int		offset;
>  	int		size;
>  	int		i;
> @@ -1384,15 +1382,14 @@ _xfs_buf_ioapply(
>  				dump_stack();
>  			}
>  		}
> -	} else if (bp->b_flags & XBF_READ_AHEAD) {
> -		op = REQ_OP_READ;
> -		op_flags = REQ_RAHEAD;
>  	} else {
>  		op = REQ_OP_READ;
> +		if (bp->b_flags & XBF_READ_AHEAD)
> +			op |= REQ_RAHEAD;
>  	}
>  
>  	/* we only use the buffer cache for meta-data */
> -	op_flags |= REQ_META;
> +	op |= REQ_META;
>  
>  	/*
>  	 * Walk all the vectors issuing IO on them. Set up the initial offset
> @@ -1404,7 +1401,7 @@ _xfs_buf_ioapply(
>  	size = BBTOB(bp->b_length);
>  	blk_start_plug(&plug);
>  	for (i = 0; i < bp->b_map_count; i++) {
> -		xfs_buf_ioapply_map(bp, i, &offset, &size, op, op_flags);
> +		xfs_buf_ioapply_map(bp, i, &offset, &size, op);
>  		if (bp->b_error)
>  			break;
>  		if (size <= 0)
> -- 
> 2.20.1
> 
