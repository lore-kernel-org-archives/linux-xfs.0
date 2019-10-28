Return-Path: <SRS0=q11v=YV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34A97CA9EC0
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 15:55:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF38820830
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 15:55:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DAmkZnz6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390740AbfJ1Pz3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 11:55:29 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56342 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726612AbfJ1Pz2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 11:55:28 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SFsP9K029521;
        Mon, 28 Oct 2019 15:55:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=lcTnRRSJVKHyBWjcUjZfG+wyQPU3w20k0tvPgNYANsM=;
 b=DAmkZnz6pfSGEvF+iP9GcqTnqS+GHYuFF84gnGOHPWrl+MnW0Om4ouwuuVvWDIuo/tFq
 RlZQ4SjkEzF/4eIqi7QxSDHrdu9yr21rLj0zfcaWgl8ll4pA0Gjms2OgxJfRqwfcQXT9
 vyYhzbKZzKEHrWrAiaI1+627wiNU1Yf/mshJruSDXHFyxX5t8CFT6wCdIi6+Yhl270tM
 GK29IeRDmG4/GG0p/FKG5xpRMVOT+IP8zQvrwAiO2JR21asWQXzTaRjMGhdtDmIPVlN8
 nsurneHdJFq3/CRjsBU9nYXsQ3Pg9qXr63cHCkUq6NATQL2G+ncyNsfcbu3BdfXn4HIH 6w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2vvdju32wb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 15:55:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SFsDqV021532;
        Mon, 28 Oct 2019 15:55:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2vw09fyk6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 15:55:18 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9SFtGoQ030162;
        Mon, 28 Oct 2019 15:55:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Oct 2019 08:55:16 -0700
Date:   Mon, 28 Oct 2019 08:55:15 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs: simplify xfs_iomap_eof_align_last_fsb
Message-ID: <20191028155514.GA15222@magnolia>
References: <20191025150336.19411-1-hch@lst.de>
 <20191025150336.19411-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025150336.19411-2-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9423 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910280160
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9423 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910280160
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 25, 2019 at 05:03:29PM +0200, Christoph Hellwig wrote:
> By open coding xfs_bmap_last_extent instead of calling it through a
> double indirection we don't need to handle an error return that
> can't happen given that we are guaranteed to have the extent list in
> memory already.  Also simplify the calling conventions a little and
> move the extent list assert from the only caller into the function.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_bmap_util.c | 23 ---------------------
>  fs/xfs/xfs_bmap_util.h |  2 --
>  fs/xfs/xfs_iomap.c     | 47 ++++++++++++++++++++----------------------
>  3 files changed, 22 insertions(+), 50 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 11658da40640..44d6b6469303 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -179,29 +179,6 @@ xfs_bmap_rtalloc(
>  }
>  #endif /* CONFIG_XFS_RT */
>  
> -/*
> - * Check if the endoff is outside the last extent. If so the caller will grow
> - * the allocation to a stripe unit boundary.  All offsets are considered outside
> - * the end of file for an empty fork, so 1 is returned in *eof in that case.
> - */
> -int
> -xfs_bmap_eof(
> -	struct xfs_inode	*ip,
> -	xfs_fileoff_t		endoff,
> -	int			whichfork,
> -	int			*eof)
> -{
> -	struct xfs_bmbt_irec	rec;
> -	int			error;
> -
> -	error = xfs_bmap_last_extent(NULL, ip, whichfork, &rec, eof);
> -	if (error || *eof)
> -		return error;
> -
> -	*eof = endoff >= rec.br_startoff + rec.br_blockcount;
> -	return 0;
> -}
> -
>  /*
>   * Extent tree block counting routines.
>   */
> diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
> index 3e0fa0d363d1..9f993168b55b 100644
> --- a/fs/xfs/xfs_bmap_util.h
> +++ b/fs/xfs/xfs_bmap_util.h
> @@ -30,8 +30,6 @@ xfs_bmap_rtalloc(struct xfs_bmalloca *ap)
>  }
>  #endif /* CONFIG_XFS_RT */
>  
> -int	xfs_bmap_eof(struct xfs_inode *ip, xfs_fileoff_t endoff,
> -		     int whichfork, int *eof);
>  int	xfs_bmap_punch_delalloc_range(struct xfs_inode *ip,
>  		xfs_fileoff_t start_fsb, xfs_fileoff_t length);
>  
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index c1063507e5fd..49fbc99c18ff 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -156,25 +156,33 @@ xfs_eof_alignment(
>  	return align;
>  }
>  
> -STATIC int
> +/*
> + * Check if last_fsb is outside the last extent, and if so grow it to the next
> + * stripe unit boundary.
> + */
> +static xfs_fileoff_t
>  xfs_iomap_eof_align_last_fsb(
>  	struct xfs_inode	*ip,
> -	xfs_extlen_t		extsize,
> -	xfs_fileoff_t		*last_fsb)
> +	xfs_fileoff_t		end_fsb)
>  {
> -	xfs_extlen_t		align = xfs_eof_alignment(ip, extsize);
> +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> +	xfs_extlen_t		extsz = xfs_get_extsz_hint(ip);
> +	xfs_extlen_t		align = xfs_eof_alignment(ip, extsz);
> +	struct xfs_bmbt_irec	irec;
> +	struct xfs_iext_cursor	icur;
> +
> +	ASSERT(ifp->if_flags & XFS_IFEXTENTS);
>  
>  	if (align) {
> -		xfs_fileoff_t	new_last_fsb = roundup_64(*last_fsb, align);
> -		int		eof, error;
> +		xfs_fileoff_t	aligned_end_fsb = roundup_64(end_fsb, align);
>  
> -		error = xfs_bmap_eof(ip, new_last_fsb, XFS_DATA_FORK, &eof);
> -		if (error)
> -			return error;
> -		if (eof)
> -			*last_fsb = new_last_fsb;
> +		xfs_iext_last(ifp, &icur);
> +		if (!xfs_iext_get_extent(ifp, &icur, &irec) ||
> +		    aligned_end_fsb >= irec.br_startoff + irec.br_blockcount)
> +			return aligned_end_fsb;
>  	}
> -	return 0;
> +
> +	return end_fsb;
>  }
>  
>  int
> @@ -206,19 +214,8 @@ xfs_iomap_write_direct(
>  
>  	ASSERT(xfs_isilocked(ip, lockmode));
>  
> -	if ((offset + count) > XFS_ISIZE(ip)) {
> -		/*
> -		 * Assert that the in-core extent list is present since this can
> -		 * call xfs_iread_extents() and we only have the ilock shared.
> -		 * This should be safe because the lock was held around a bmapi
> -		 * call in the caller and we only need it to access the in-core
> -		 * list.
> -		 */
> -		ASSERT(XFS_IFORK_PTR(ip, XFS_DATA_FORK)->if_flags &
> -								XFS_IFEXTENTS);
> -		error = xfs_iomap_eof_align_last_fsb(ip, extsz, &last_fsb);
> -		if (error)
> -			goto out_unlock;
> +	if (offset + count > XFS_ISIZE(ip)) {
> +		last_fsb = xfs_iomap_eof_align_last_fsb(ip, last_fsb);
>  	} else {
>  		if (nmaps && (imap->br_startblock == HOLESTARTBLOCK))
>  			last_fsb = min(last_fsb, (xfs_fileoff_t)
> -- 
> 2.20.1
> 
