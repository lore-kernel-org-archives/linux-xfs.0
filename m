Return-Path: <SRS0=aCB+=YX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EFEECA9EC5
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 19:31:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7B0420856
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 19:31:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Uvgjpfmn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbfJ3Tb5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Oct 2019 15:31:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33580 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbfJ3Tb5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Oct 2019 15:31:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9UJScVE034765;
        Wed, 30 Oct 2019 19:31:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=3ZOkHqgQiQX3xt4fu4nma1vCS9uiWoL8+wZ9IDPZy6o=;
 b=UvgjpfmnaPSR7O+pOiCp2wp8qbFoK/wILFMYte1wpzC0nN1fwm3u9Zf4pQhVCFXmp7NC
 Hlo0CIa5cnjAwIgH+WDhJ8j7CsWIsmTloF3uz+8d8NNiTYFhP/tpxnBrL2JIH+L4NMbt
 9WFpF3Chu3TXxIERsCDHnwhckKTC35gUhzBRnBOfeBUxeU60WLfVhIFdKKWUP9xTUSwY
 txkpKKr71KC9gYQOYKtFAlVVV9WsxyqYxWjUyrYPi3rNRxZcNk7LKD/FQ+EFva4nUk6c
 vWV1fsqOolGqn4UkA2GsfPA2cXcfsRAFw/d+0Z6TiAs9Qu0NVh3aXVcMOiACbolFgefA oQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2vxwhfph2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Oct 2019 19:31:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9UJSEaD144045;
        Wed, 30 Oct 2019 19:31:52 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2vxwjahrcq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Oct 2019 19:31:52 +0000
Received: from abhmp0021.oracle.com (abhmp0021.oracle.com [141.146.116.27])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9UJVpSY025859;
        Wed, 30 Oct 2019 19:31:51 GMT
Received: from localhost (/10.145.178.60)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 30 Oct 2019 12:31:51 -0700
Date:   Wed, 30 Oct 2019 12:31:50 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: don't log the inode in xfs_fs_map_blocks if it
 wasn't modified
Message-ID: <20191030193150.GS15222@magnolia>
References: <20191030180419.13045-1-hch@lst.de>
 <20191030180419.13045-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191030180419.13045-6-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9426 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910300168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9426 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910300168
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 30, 2019 at 11:04:15AM -0700, Christoph Hellwig wrote:
> Even if we are asked for a write layout there is no point in logging
> the inode unless we actually modified it in some way.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fine...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_pnfs.c | 42 ++++++++++++++++++------------------------
>  1 file changed, 18 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> index 3634ffff3b07..ada46e9f5ff1 100644
> --- a/fs/xfs/xfs_pnfs.c
> +++ b/fs/xfs/xfs_pnfs.c
> @@ -150,30 +150,24 @@ xfs_fs_map_blocks(
>  
>  	ASSERT(!nimaps || imap.br_startblock != DELAYSTARTBLOCK);
>  
> -	if (write) {
> -		enum xfs_prealloc_flags	flags = 0;
> -
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
> +	if (write && (!nimaps || imap.br_startblock == HOLESTARTBLOCK)) {
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
