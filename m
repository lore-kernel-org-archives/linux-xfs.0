Return-Path: <SRS0=q11v=YV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E207CA9EC0
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 16:06:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C90F21721
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 16:06:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Pxc4GBvs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390784AbfJ1QGr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 12:06:47 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40296 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730627AbfJ1QGr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 12:06:47 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SFsNoP029455;
        Mon, 28 Oct 2019 16:06:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=w2ujfnExrFbwHCTlvJQG0OfgiXB2LoBaYU1Govb5Pvs=;
 b=Pxc4GBvskSQGzXO6lWi8rnnTAYM6X793vnW8RnoAfiinRGOkr1gF6Pki/Bo2dYiko857
 IwEooacPY53qBWi3XnPbvCKZDoY/rPMpoXTPPpPq1wwmOue8cNTUu2g8lkmFuPEwoVsc
 jFsUIxgfsldn8PvCw20uj93fTpz4bPnny7ZMNk6f5qzTdXVijKP9EBRmKe7BsNsMPoBQ
 m0aldDbC0lXTux8MqxMptFeASYWZHdbX3/mLWEAZy6HxCM6qMG3r/d82ke2m+bv50vQh
 vwP244HTqVDAasmxIhZNfmLDKoHIl5ClP9+4ps4f/+jXaIMs7hKdD5qYQNVacnsub7ZD rw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2vvdju35gx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 16:06:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SFr4No113183;
        Mon, 28 Oct 2019 16:06:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2vvyks4y24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 16:06:43 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9SG6fnt002231;
        Mon, 28 Oct 2019 16:06:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Oct 2019 09:06:41 -0700
Date:   Mon, 28 Oct 2019 09:06:38 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs: remove the extsize argument to xfs_eof_alignment
Message-ID: <20191028160638.GC15222@magnolia>
References: <20191025150336.19411-1-hch@lst.de>
 <20191025150336.19411-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025150336.19411-4-hch@lst.de>
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

On Fri, Oct 25, 2019 at 05:03:31PM +0200, Christoph Hellwig wrote:
> And move the code dependent on it to the one caller that cares
> instead.

Hmm, so if I'm understanding this correctly, now xfs_eof_alignment
rounds alignment up to the stripe width (or dalign) for files on the
data device?  And the alignment number it produces is further rounded up
to the extent hint size which is then used to round up a space
allocation (directio writes) or used to round up the speculative
preallocation window (buffered writes)?

Why does it make more sense to do the inode extsize roundup only for
direct writes and not as an intermediate step of determining the
speculative preallocation size than what the code does now?

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_iomap.c | 28 +++++++++++++---------------
>  1 file changed, 13 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index c803a8efa8ff..e3b11cda447e 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -118,8 +118,7 @@ xfs_iomap_end_fsb(
>  
>  static xfs_extlen_t
>  xfs_eof_alignment(
> -	struct xfs_inode	*ip,
> -	xfs_extlen_t		extsize)
> +	struct xfs_inode	*ip)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	xfs_extlen_t		align = 0;
> @@ -142,17 +141,6 @@ xfs_eof_alignment(
>  			align = 0;
>  	}
>  
> -	/*
> -	 * Always round up the allocation request to an extent boundary
> -	 * (when file on a real-time subvolume or has di_extsize hint).
> -	 */
> -	if (extsize) {
> -		if (align)
> -			align = roundup_64(align, extsize);
> -		else
> -			align = extsize;
> -	}
> -
>  	return align;
>  }
>  
> @@ -167,12 +155,22 @@ xfs_iomap_eof_align_last_fsb(
>  {
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
>  	xfs_extlen_t		extsz = xfs_get_extsz_hint(ip);
> -	xfs_extlen_t		align = xfs_eof_alignment(ip, extsz);
> +	xfs_extlen_t		align = xfs_eof_alignment(ip);
>  	struct xfs_bmbt_irec	irec;
>  	struct xfs_iext_cursor	icur;
>  
>  	ASSERT(ifp->if_flags & XFS_IFEXTENTS);
>  
> +	/*
> +	 * Always round up the allocation request to the extent hint boundary.
> +	 */
> +	if (extsz) {
> +		if (align)
> +			align = roundup_64(align, extsz);
> +		else
> +			align = extsz;
> +	}
> +
>  	if (align) {
>  		xfs_fileoff_t	aligned_end_fsb = roundup_64(end_fsb, align);
>  
> @@ -992,7 +990,7 @@ xfs_buffered_write_iomap_begin(
>  			p_end_fsb = XFS_B_TO_FSBT(mp, end_offset) +
>  					prealloc_blocks;
>  
> -			align = xfs_eof_alignment(ip, 0);
> +			align = xfs_eof_alignment(ip);
>  			if (align)
>  				p_end_fsb = roundup_64(p_end_fsb, align);
>  
> -- 
> 2.20.1
> 
