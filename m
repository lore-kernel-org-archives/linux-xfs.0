Return-Path: <SRS0=0zz6=4T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1743C3F2CD
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 17:44:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6B3F214DB
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 17:44:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jUdSoFQG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbgCBRoM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Mar 2020 12:44:12 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47306 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727209AbgCBRoM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Mar 2020 12:44:12 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 022Hi5Vl074014
        for <linux-xfs@vger.kernel.org>; Mon, 2 Mar 2020 17:44:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=SpfysKvkM2ulrossfNgJaGoe6F4qWdh3qRnHS0XHyY0=;
 b=jUdSoFQGpYsr5AwzO1RMPMdGKxhLcNeNz4AcVjpDP5fuYjpmWbdnKBi7AvID2EJvaz0Z
 feFGAJYhrGWlqjRcrk4YG9GvTDLR0bSUaUqG9K25EC2La58xzwsRtyqT515BjS0pE53i
 4NgPKXngO3MAaTaZzrBUpF99j/oAqka377sFc8RDw6Sn2j8ZWKzL9Z1Mg431iENWxDkq
 YVgsYPR4XDrNmVDfO3ZZwlDSd/hjVsk+oqHqlg1NsKYEqgD9/3hQFQBeX6O+BiJZSQta
 OUXmDSOSTe2qAgQFfvsCmZw8cm4FKT8o1T1DwtpPrJuxGddSNTZDgp20PiCC7oAG1xJK JA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2yffwqh8sh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 02 Mar 2020 17:44:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 022HgO6q184031
        for <linux-xfs@vger.kernel.org>; Mon, 2 Mar 2020 17:44:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2yg1p2a0hb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 02 Mar 2020 17:44:09 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 022Hi8PP013618
        for <linux-xfs@vger.kernel.org>; Mon, 2 Mar 2020 17:44:08 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Mar 2020 09:44:08 -0800
Subject: Re: [PATCH 3/3] xfs: scrub should mark dir corrupt if entry points to
 unallocated inode
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <158294094367.1730101.10848559171120744339.stgit@magnolia>
 <158294096213.1730101.1870315264682758950.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <ef3a904c-b0c0-8bf8-ac90-672dad70a357@oracle.com>
Date:   Mon, 2 Mar 2020 10:44:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <158294096213.1730101.1870315264682758950.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9547 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003020117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9547 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003020117
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/28/20 6:49 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xchk_dir_check_ftype, we should mark the directory corrupt if we try
> to _iget a directory entry's inode pointer and the inode btree says the
> inode is not allocated.  This involves changing the IGET call to force
> the inobt lookup to return EINVAL if the inode isn't allocated; and
> rearranging the code so that we always perform the iget.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Ok, I followed it through, and didn't see any obvious issues
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/scrub/dir.c |   43 ++++++++++++++++++++++++++-----------------
>   1 file changed, 26 insertions(+), 17 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index 54afa75c95d1..a775fbf49a0d 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -39,9 +39,12 @@ struct xchk_dir_ctx {
>   	struct xfs_scrub	*sc;
>   };
>   
> -/* Check that an inode's mode matches a given DT_ type. */
> +/*
> + * Check that a directory entry's inode pointer directs us to an allocated
> + * inode and (if applicable) the inode mode matches the entry's DT_ type.
> + */
>   STATIC int
> -xchk_dir_check_ftype(
> +xchk_dir_check_iptr(
>   	struct xchk_dir_ctx	*sdc,
>   	xfs_fileoff_t		offset,
>   	xfs_ino_t		inum,
> @@ -52,13 +55,6 @@ xchk_dir_check_ftype(
>   	int			ino_dtype;
>   	int			error = 0;
>   
> -	if (!xfs_sb_version_hasftype(&mp->m_sb)) {
> -		if (dtype != DT_UNKNOWN && dtype != DT_DIR)
> -			xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
> -					offset);
> -		goto out;
> -	}
> -
>   	/*
>   	 * Grab the inode pointed to by the dirent.  We release the
>   	 * inode before we cancel the scrub transaction.  Since we're
> @@ -66,17 +62,30 @@ xchk_dir_check_ftype(
>   	 * eofblocks cleanup (which allocates what would be a nested
>   	 * transaction), we can't use DONTCACHE here because DONTCACHE
>   	 * inodes can trigger immediate inactive cleanup of the inode.
> +	 *
> +	 * We use UNTRUSTED here so that iget will return EINVAL if we have an
> +	 * inode pointer that points to an unallocated inode.
>   	 */
> -	error = xfs_iget(mp, sdc->sc->tp, inum, 0, 0, &ip);
> +	error = xfs_iget(mp, sdc->sc->tp, inum, XFS_IGET_UNTRUSTED, 0, &ip);
> +	if (error == -EINVAL) {
> +		xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
> +		return -EFSCORRUPTED;
> +	}
>   	if (!xchk_fblock_xref_process_error(sdc->sc, XFS_DATA_FORK, offset,
>   			&error))
>   		goto out;
>   
> -	/* Convert mode to the DT_* values that dir_emit uses. */
> -	ino_dtype = xfs_dir3_get_dtype(mp,
> -			xfs_mode_to_ftype(VFS_I(ip)->i_mode));
> -	if (ino_dtype != dtype)
> -		xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
> +	if (xfs_sb_version_hasftype(&mp->m_sb)) {
> +		/* Convert mode to the DT_* values that dir_emit uses. */
> +		ino_dtype = xfs_dir3_get_dtype(mp,
> +				xfs_mode_to_ftype(VFS_I(ip)->i_mode));
> +		if (ino_dtype != dtype)
> +			xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
> +	} else {
> +		if (dtype != DT_UNKNOWN && dtype != DT_DIR)
> +			xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
> +					offset);
> +	}
>   	xfs_irele(ip);
>   out:
>   	return error;
> @@ -168,8 +177,8 @@ xchk_dir_actor(
>   		goto out;
>   	}
>   
> -	/* Verify the file type.  This function absorbs error codes. */
> -	error = xchk_dir_check_ftype(sdc, offset, lookup_ino, type);
> +	/* Verify the inode pointer.  This function absorbs error codes. */
> +	error = xchk_dir_check_iptr(sdc, offset, lookup_ino, type);
>   	if (error)
>   		goto out;
>   out:
> 
