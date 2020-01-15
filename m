Return-Path: <SRS0=S7Al=3E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C218AC32771
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 17:12:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98848214AF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 17:12:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lqAhAZWo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728982AbgAORMh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 12:12:37 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:43438 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728909AbgAORMh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jan 2020 12:12:37 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FH98dE020261;
        Wed, 15 Jan 2020 17:12:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=QC6K/sYmzMt93u0Iyu7scAC4FJ+AfoQlpHskLpAGWK4=;
 b=lqAhAZWoMuAVr9lGKzv2xgDXsvED61N3QyptVGk/UMCO2gzYBasndfOOMFGTS40TMUJe
 BUzjAoD7aatQlwofKub9nF28xhxUogzVR6TKYLQBwlW2JqTthqkZRjsaSJFIInYB3T8l
 /mapAc1KXoaOcLkHSggb8s3JmX9ZvkHJ/0esD5qPdHFJ831aKp7ttBnMmpNEj+EjJ91/
 GvWCk6aORXMvqX8B+bF6W/Nby72f1BHOwr6Ze3+Xs/8JKeynY8PlGqylIl/zqBkKgn6T
 mbare9hdcjOxmHxYNMaOu8tN9XfcvXsKZgJrlzH/GC2VptwjH0HfisozGKi2BUa1Q8S0 0Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xf73twd39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 17:12:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FH9NU7106501;
        Wed, 15 Jan 2020 17:12:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2xj1prh4tm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 17:12:32 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00FHCVdE017134;
        Wed, 15 Jan 2020 17:12:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 09:12:31 -0800
Date:   Wed, 15 Jan 2020 09:12:30 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix IOCB_NOWAIT handling in xfs_file_dio_aio_read
Message-ID: <20200115171230.GB8247@magnolia>
References: <20200115134653.433559-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200115134653.433559-1-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=980
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001150130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001150130
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 15, 2020 at 02:46:53PM +0100, Christoph Hellwig wrote:
> Direct I/O reads can also be used with RWF_NOWAIT & co.  Fix the inode
> locking in xfs_file_dio_aio_read to take IOCB_NOWAIT into account.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
> 
> Resending standalone to get a little more attention.
> 
>  fs/xfs/xfs_file.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index c93250108952..b8a4a3f29b36 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -187,7 +187,12 @@ xfs_file_dio_aio_read(
>  
>  	file_accessed(iocb->ki_filp);
>  
> -	xfs_ilock(ip, XFS_IOLOCK_SHARED);
> +	if (iocb->ki_flags & IOCB_NOWAIT) {
> +		if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED))
> +			return -EAGAIN;
> +	} else {
> +		xfs_ilock(ip, XFS_IOLOCK_SHARED);
> +	}

/me really wishes we had a better way to do this than to open-code this
idiom over and over and over again in every fs.  Unfortunately I know of
no way to accomplish that without macros(!) so this will have to do:

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  	ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops, NULL,
>  			is_sync_kiocb(iocb));
>  	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
> -- 
> 2.24.1
> 
