Return-Path: <SRS0=gkwD=66=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68A38C433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 17:52:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 411F6206D4
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 17:52:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VDX6pFZk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726280AbgEPRw4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 May 2020 13:52:56 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50706 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbgEPRw4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 May 2020 13:52:56 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04GHgvP2021995;
        Sat, 16 May 2020 17:52:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=cY4NQxkQZPeJKna/yArrkR6GIzkEzz6r95QvREYg6Gw=;
 b=VDX6pFZk+yVu8KBzM176WMSQJ5T7O+SzoM4F2ZvDFP9F3SroBhtpjtCEToqRhhcy6UeU
 rDXfy+06xfrz5CKG++UfXj82nv5LKcj31NLV/1bh2yUYCW5mg6nBVjHg/kNohCpbvx1l
 5xUP4jvPVbXE0Ff32kzhSt9hh1APG+MKH9q3e/2giKqKTcHjVLnpfpSB7J++UY9Vzg+4
 PCs40w+kql/PbzaUI9uRJl60kkPAa5tk3Hd49N5vcjkuoFHfScXITelDYKKlMjkue9Qo
 yD5ierCfAu+59uRILDp6oGorLRt0dqaLV0VBjntNik+lioSymV/zs2dAqT7hJviRNE9+ Eg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3127kqsff6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 16 May 2020 17:52:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04GHqn1l028515;
        Sat, 16 May 2020 17:52:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 312801akyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 May 2020 17:52:52 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04GHqpcA009975;
        Sat, 16 May 2020 17:52:51 GMT
Received: from localhost (/10.159.131.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 16 May 2020 10:52:51 -0700
Date:   Sat, 16 May 2020 10:52:50 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/12] xfs: remove the NULL fork handling in
 xfs_bmapi_read
Message-ID: <20200516175250.GB6714@magnolia>
References: <20200508063423.482370-1-hch@lst.de>
 <20200508063423.482370-13-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508063423.482370-13-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9623 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005160161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9623 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005160159
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 08, 2020 at 08:34:23AM +0200, Christoph Hellwig wrote:
> Now that we fully verify the inode forks before they are added to the
> inode cache, the crash reported in
> 
>   https://bugzilla.kernel.org/show_bug.cgi?id=204031
> 
> can't happen anymore, as we'll never let an inode that has inconsistent
> nextents counts vs the presence of an in-core attr fork leak into the
> inactivate code path.  So remove the work around to try to handle the
> case, and just return an error and warn if the fork is not present.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok, will test...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 22 +++++-----------------
>  1 file changed, 5 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 76be1a18e2442..34518a6dc7376 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3891,7 +3891,8 @@ xfs_bmapi_read(
>  	int			flags)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> -	struct xfs_ifork	*ifp;
> +	int			whichfork = xfs_bmapi_whichfork(flags);
> +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
>  	struct xfs_bmbt_irec	got;
>  	xfs_fileoff_t		obno;
>  	xfs_fileoff_t		end;
> @@ -3899,12 +3900,14 @@ xfs_bmapi_read(
>  	int			error;
>  	bool			eof = false;
>  	int			n = 0;
> -	int			whichfork = xfs_bmapi_whichfork(flags);
>  
>  	ASSERT(*nmap >= 1);
>  	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK | XFS_BMAPI_ENTIRE)));
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED|XFS_ILOCK_EXCL));
>  
> +	if (WARN_ON_ONCE(!ifp))
> +		return -EFSCORRUPTED;
> +
>  	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)) ||
>  	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
>  		return -EFSCORRUPTED;
> @@ -3915,21 +3918,6 @@ xfs_bmapi_read(
>  
>  	XFS_STATS_INC(mp, xs_blk_mapr);
>  
> -	ifp = XFS_IFORK_PTR(ip, whichfork);
> -	if (!ifp) {
> -		/*
> -		 * A missing attr ifork implies that the inode says we're in
> -		 * extents or btree format but failed to pass the inode fork
> -		 * verifier while trying to load it.  Treat that as a file
> -		 * corruption too.
> -		 */
> -#ifdef DEBUG
> -		xfs_alert(mp, "%s: inode %llu missing fork %d",
> -				__func__, ip->i_ino, whichfork);
> -#endif /* DEBUG */
> -		return -EFSCORRUPTED;
> -	}
> -
>  	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
>  		error = xfs_iread_extents(NULL, ip, whichfork);
>  		if (error)
> -- 
> 2.26.2
> 
