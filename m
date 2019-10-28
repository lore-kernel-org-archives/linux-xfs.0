Return-Path: <SRS0=q11v=YV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C944ECA9EC0
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 16:12:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C69721835
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 16:12:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sSf7htgl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390866AbfJ1QMv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 12:12:51 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46976 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390865AbfJ1QMu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 12:12:50 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SG9EnE026177;
        Mon, 28 Oct 2019 16:12:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=ARFfwOzwcOi4DCTiuf10qpLniXhsjvw8MKaEOfNrPug=;
 b=sSf7htgl9WBn3+OfCmUUPUcFdwCBCwoGLIKrWP9xQIr8SaTU4uImrLwE3xCSGw1LK2jN
 iyTMUB77qElYqa28ZsUnqIo/ASlypB3+qnTx0X3a/2ZVmbkMSgwGnpO3aZSmIukWdvno
 1xEI3uH6KMFNWAYa2Syv35/XvefncmZSARMuGEyApG7qi6gJ/nZzRrl3XQjgk4X1wsnx
 VJukNmcssxcUaMROStS4kszlk2zKYHEVyn5yUlPDkuduC2Derp94kxrHlg1wUlMC4M3b
 aFtysQVVDEFgi+Wir2PN9a2qj4ajMq61E+kR7iY69B7aEofJ7V6CmGdlZAL10rnUvxa8 sA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2vve3q327a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 16:12:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SG9FuO038092;
        Mon, 28 Oct 2019 16:12:47 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2vvymyynsb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 16:12:46 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9SGCkc4007630;
        Mon, 28 Oct 2019 16:12:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Oct 2019 09:12:46 -0700
Date:   Mon, 28 Oct 2019 09:12:45 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs: don't log the inode in xfs_fs_map_blocks if it
 wasn't modified
Message-ID: <20191028161245.GD15222@magnolia>
References: <20191025150336.19411-1-hch@lst.de>
 <20191025150336.19411-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025150336.19411-5-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9423 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910280161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9423 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910280161
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 25, 2019 at 05:03:32PM +0200, Christoph Hellwig wrote:
> Even if we are asked for a write layout there is no point in logging
> the inode unless we actually modified it in some way.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_pnfs.c | 43 +++++++++++++++++++------------------------
>  1 file changed, 19 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> index 9c96493be9e0..fa90c6334c7c 100644
> --- a/fs/xfs/xfs_pnfs.c
> +++ b/fs/xfs/xfs_pnfs.c
> @@ -147,32 +147,27 @@ xfs_fs_map_blocks(
>  	if (error)
>  		goto out_unlock;
>  
> -	if (write) {
> -		enum xfs_prealloc_flags	flags = 0;
> -
> +	if (write &&
> +	    (!nimaps || imap.br_startblock == HOLESTARTBLOCK)) {
>  		ASSERT(imap.br_startblock != DELAYSTARTBLOCK);

The change in code flow makes this assert rather useless, I think, since
we only end up in this branch if we have a write and a hole.  If the
condition that it checks is important (and it seems to be?) then it
ought to be hoisted up a level and turned into:

ASSERT(!write || !nimaps || imap.br_startblock != DELAYSTARTBLOCK);

Right?

Otherwise looks ok.

--D

>  
> -		if (!nimaps || imap.br_startblock == HOLESTARTBLOCK) {
> -			/*
> -			 * xfs_iomap_write_direct() expects to take ownership of
> -			 * the shared ilock.
> -			 */
> -			xfs_ilock(ip, XFS_ILOCK_SHARED);
> -			error = xfs_iomap_write_direct(ip, offset, length,
> -						       &imap, nimaps);
> -			if (error)
> -				goto out_unlock;
> -
> -			/*
> -			 * Ensure the next transaction is committed
> -			 * synchronously so that the blocks allocated and
> -			 * handed out to the client are guaranteed to be
> -			 * present even after a server crash.
> -			 */
> -			flags |= XFS_PREALLOC_SET | XFS_PREALLOC_SYNC;
> -		}
> -
> -		error = xfs_update_prealloc_flags(ip, flags);
> +		/*
> +		 * xfs_iomap_write_direct() expects to take ownership of the
> +		 * shared ilock.
> +		 */
> +		xfs_ilock(ip, XFS_ILOCK_SHARED);
> +		error = xfs_iomap_write_direct(ip, offset, length, &imap,
> +					       nimaps);
> +		if (error)
> +			goto out_unlock;
> +
> +		/*
> +		 * Ensure the next transaction is committed synchronously so
> +		 * that the blocks allocated and handed out to the client are
> +		 * guaranteed to be present even after a server crash.
> +		 */
> +		error = xfs_update_prealloc_flags(ip,
> +				XFS_PREALLOC_SET | XFS_PREALLOC_SYNC);
>  		if (error)
>  			goto out_unlock;
>  	}
> -- 
> 2.20.1
> 
