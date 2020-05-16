Return-Path: <SRS0=gkwD=66=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBE95C433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 17:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A27C4206F4
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 17:41:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="w75lpNNc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbgEPRlE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 May 2020 13:41:04 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37710 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbgEPRlE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 May 2020 13:41:04 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04GHcTbr144970;
        Sat, 16 May 2020 17:41:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ChCFWFSAbbfO+Gc4b8FmWAtHKVUNR4VNu6UoTXNMvTo=;
 b=w75lpNNcBzaMkzybbtBsZS2JATS27TmItEl7A4Idez9LKibxwbhKDarzyoGR9cIMLOc9
 1BmDmwn/kP2XnkvDjmn2idJfAVGvQh1qtQDW+c/k0ODdGQkIqeWaUoe0UGtQ1Jvo2CZg
 b5wbkFxUWdupogfwOcHFy+cogmVB+u1jD4OgQmA432idT4nLsOB94eIL+bfZM8geZ6pf
 GAgCZK31AqcCLbAzHf0WqbyugtCk9Bq0B7mlZLU2xpmwkqoOgi2qgmC22zulmAn1tmdV
 0t4bd5vseB381AiB/cXq51pgidFF5EZ681DWj6Dk5JuUou66NKavlPNqLR02bYdikPs+ hQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31284khdsp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 16 May 2020 17:41:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04GHcnNk189850;
        Sat, 16 May 2020 17:39:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3128019hym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 May 2020 17:39:00 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04GHcxvY005040;
        Sat, 16 May 2020 17:38:59 GMT
Received: from localhost (/10.159.131.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 16 May 2020 10:38:59 -0700
Date:   Sat, 16 May 2020 10:38:58 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/12] xfs: handle unallocated inodes in
 xfs_inode_from_disk
Message-ID: <20200516173858.GT6714@magnolia>
References: <20200508063423.482370-1-hch@lst.de>
 <20200508063423.482370-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508063423.482370-5-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9623 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=5 malwarescore=0 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005160158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9623 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005160158
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 08, 2020 at 08:34:15AM +0200, Christoph Hellwig wrote:
> Handle inodes with a 0 di_mode in xfs_inode_from_disk, instead of partially
> duplicating inode reading in xfs_iread.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_buf.c | 50 ++++++++++-------------------------
>  1 file changed, 14 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index abdecc80579e3..686a026b5f6ed 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -192,6 +192,17 @@ xfs_inode_from_disk(
>  	ASSERT(ip->i_cowfp == NULL);
>  	ASSERT(ip->i_afp == NULL);
>  
> +	/*
> +	 * First get the permanent information that is needed to allocate an
> +	 * inode. If the inode is unused, mode is zero and we shouldn't mess
> +	 * with the unitialized part of it.
> +	 */
> +	to->di_flushiter = be16_to_cpu(from->di_flushiter);
> +	inode->i_generation = be32_to_cpu(from->di_gen);
> +	inode->i_mode = be16_to_cpu(from->di_mode);
> +	if (!inode->i_mode)
> +		return 0;
> +
>  	/*
>  	 * Convert v1 inodes immediately to v2 inode format as this is the
>  	 * minimum inode version format we support in the rest of the code.
> @@ -209,7 +220,6 @@ xfs_inode_from_disk(
>  	to->di_format = from->di_format;
>  	i_uid_write(inode, be32_to_cpu(from->di_uid));
>  	i_gid_write(inode, be32_to_cpu(from->di_gid));
> -	to->di_flushiter = be16_to_cpu(from->di_flushiter);
>  
>  	/*
>  	 * Time is signed, so need to convert to signed 32 bit before
> @@ -223,8 +233,6 @@ xfs_inode_from_disk(
>  	inode->i_mtime.tv_nsec = (int)be32_to_cpu(from->di_mtime.t_nsec);
>  	inode->i_ctime.tv_sec = (int)be32_to_cpu(from->di_ctime.t_sec);
>  	inode->i_ctime.tv_nsec = (int)be32_to_cpu(from->di_ctime.t_nsec);
> -	inode->i_generation = be32_to_cpu(from->di_gen);
> -	inode->i_mode = be16_to_cpu(from->di_mode);
>  
>  	to->di_size = be64_to_cpu(from->di_size);
>  	to->di_nblocks = be64_to_cpu(from->di_nblocks);
> @@ -653,39 +661,9 @@ xfs_iread(
>  		goto out_brelse;
>  	}
>  
> -	/*
> -	 * If the on-disk inode is already linked to a directory
> -	 * entry, copy all of the inode into the in-core inode.
> -	 * xfs_iformat_fork() handles copying in the inode format
> -	 * specific information.
> -	 * Otherwise, just get the truly permanent information.
> -	 */
> -	if (dip->di_mode) {
> -		error = xfs_inode_from_disk(ip, dip);
> -		if (error)  {
> -#ifdef DEBUG
> -			xfs_alert(mp, "%s: xfs_iformat() returned error %d",
> -				__func__, error);
> -#endif /* DEBUG */
> -			goto out_brelse;
> -		}
> -	} else {
> -		/*
> -		 * Partial initialisation of the in-core inode. Just the bits
> -		 * that xfs_ialloc won't overwrite or relies on being correct.
> -		 */
> -		VFS_I(ip)->i_generation = be32_to_cpu(dip->di_gen);
> -		ip->i_d.di_flushiter = be16_to_cpu(dip->di_flushiter);
> -
> -		/*
> -		 * Make sure to pull in the mode here as well in
> -		 * case the inode is released without being used.
> -		 * This ensures that xfs_inactive() will see that
> -		 * the inode is already free and not try to mess
> -		 * with the uninitialized part of it.
> -		 */
> -		VFS_I(ip)->i_mode = 0;
> -	}
> +	error = xfs_inode_from_disk(ip, dip);
> +	if (error)
> +		goto out_brelse;
>  
>  	ip->i_delayed_blks = 0;
>  
> -- 
> 2.26.2
> 
