Return-Path: <SRS0=q11v=YV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEE0DCA9EC0
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 16:32:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 964AB21744
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 16:32:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c/8kBSAc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732748AbfJ1Qcs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 12:32:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39934 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731537AbfJ1Qcs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 12:32:48 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SGTGnn043845;
        Mon, 28 Oct 2019 16:32:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=WK5WosaZMnP/56CMwJDdSj6zwjqIEdaltdXIJ36pD2o=;
 b=c/8kBSAcU+fLpyIlHFcCoN3Yp53aVPBDdoIgofgPx0HLoYe/1POVruvyoUeMZqxsWjgw
 X9VAK6uDc++NqU93TxHbnjGbk/PdFcaPO2V8CyWbwTD3JxmgV8qKe74Isz05qzF9j7ZV
 JLfJyPw/6OuQJvjsvBIpYVWLkNX5R0Cy2fSxq1ZHgbHlY9NXjHEEQjyjWJEYqdZmZhwD
 naDIhq5BMVQcQX2OOUare3bBJgrMeB2f/VqAINr5x0McNiiOB1uUCyRO0x2tBdBfWGae
 ZIogY4B3+ExIy/mhJDi5BE3Vc4se1DzH7N8yY0ALIATRGE/Le6NEkmKXc6BwLpjLcgNS SA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2vve3q35um-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 16:32:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SGSEMa024975;
        Mon, 28 Oct 2019 16:32:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2vvyks672a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 16:32:43 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9SGWgMZ021330;
        Mon, 28 Oct 2019 16:32:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Oct 2019 09:32:42 -0700
Date:   Mon, 28 Oct 2019 09:32:41 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] xfs: cleanup use of the XFS_ALLOC_ flags
Message-ID: <20191028163241.GH15222@magnolia>
References: <20191025150336.19411-1-hch@lst.de>
 <20191025150336.19411-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025150336.19411-9-hch@lst.de>
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

On Fri, Oct 25, 2019 at 05:03:36PM +0200, Christoph Hellwig wrote:
> Always set XFS_ALLOC_USERDATA for data fork allocations, and check it
> in xfs_alloc_is_userdata instead of the current obsfucated check.
> Also remove the xfs_alloc_is_userdata and xfs_alloc_allow_busy_reuse
> helpers to make the code a little easier to understand.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c |  8 ++++----
>  fs/xfs/libxfs/xfs_alloc.h | 12 ------------
>  fs/xfs/libxfs/xfs_bmap.c  | 11 +++++------
>  fs/xfs/xfs_extent_busy.c  |  2 +-
>  fs/xfs/xfs_filestream.c   |  2 +-
>  5 files changed, 11 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index ff6454887ff3..4a6d6a1ad9f3 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -331,7 +331,7 @@ xfs_alloc_compute_diff(
>  	xfs_extlen_t	newlen1=0;	/* length with newbno1 */
>  	xfs_extlen_t	newlen2=0;	/* length with newbno2 */
>  	xfs_agblock_t	wantend;	/* end of target extent */
> -	bool		userdata = xfs_alloc_is_userdata(datatype);
> +	bool		userdata = datatype & XFS_ALLOC_USERDATA;
>  
>  	ASSERT(freelen >= wantlen);
>  	freeend = freebno + freelen;
> @@ -1041,9 +1041,9 @@ xfs_alloc_ag_vextent_small(
>  		goto out;
>  
>  	xfs_extent_busy_reuse(args->mp, args->agno, fbno, 1,
> -			      xfs_alloc_allow_busy_reuse(args->datatype));
> +			      (args->datatype & XFS_ALLOC_NOBUSY));
>  
> -	if (xfs_alloc_is_userdata(args->datatype)) {
> +	if (args->datatype & XFS_ALLOC_USERDATA) {
>  		struct xfs_buf	*bp;
>  
>  		bp = xfs_btree_get_bufs(args->mp, args->tp, args->agno, fbno);
> @@ -2380,7 +2380,7 @@ xfs_alloc_fix_freelist(
>  	 * somewhere else if we are not being asked to try harder at this
>  	 * point
>  	 */
> -	if (pag->pagf_metadata && xfs_alloc_is_userdata(args->datatype) &&
> +	if (pag->pagf_metadata && (args->datatype & XFS_ALLOC_USERDATA) &&
>  	    (flags & XFS_ALLOC_FLAG_TRYLOCK)) {
>  		ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
>  		goto out_agbp_relse;
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index 626384d75c9c..7380fbe4a3ff 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -84,18 +84,6 @@ typedef struct xfs_alloc_arg {
>  #define XFS_ALLOC_INITIAL_USER_DATA	(1 << 1)/* special case start of file */
>  #define XFS_ALLOC_NOBUSY		(1 << 2)/* Busy extents not allowed */
>  
> -static inline bool
> -xfs_alloc_is_userdata(int datatype)
> -{
> -	return (datatype & ~XFS_ALLOC_NOBUSY) != 0;
> -}
> -
> -static inline bool
> -xfs_alloc_allow_busy_reuse(int datatype)
> -{
> -	return (datatype & XFS_ALLOC_NOBUSY) == 0;
> -}
> -
>  /* freespace limit calculations */
>  #define XFS_ALLOC_AGFL_RESERVE	4
>  unsigned int xfs_alloc_set_aside(struct xfs_mount *mp);
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 6ec3c48abc1b..f62f66863801 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3059,7 +3059,7 @@ xfs_bmap_adjacent(
>  	mp = ap->ip->i_mount;
>  	nullfb = ap->tp->t_firstblock == NULLFSBLOCK;
>  	rt = XFS_IS_REALTIME_INODE(ap->ip) &&
> -		xfs_alloc_is_userdata(ap->datatype);
> +		(ap->datatype & XFS_ALLOC_USERDATA);
>  	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp,
>  							ap->tp->t_firstblock);
>  	/*
> @@ -3412,7 +3412,7 @@ xfs_bmap_btalloc(
>  
>  	if (ap->flags & XFS_BMAPI_COWFORK)
>  		align = xfs_get_cowextsz_hint(ap->ip);
> -	else if (xfs_alloc_is_userdata(ap->datatype))
> +	else if (ap->datatype & XFS_ALLOC_USERDATA)
>  		align = xfs_get_extsz_hint(ap->ip);
>  	if (align) {
>  		error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
> @@ -3427,7 +3427,7 @@ xfs_bmap_btalloc(
>  	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp,
>  							ap->tp->t_firstblock);
>  	if (nullfb) {
> -		if (xfs_alloc_is_userdata(ap->datatype) &&
> +		if ((ap->datatype & XFS_ALLOC_USERDATA) &&
>  		    xfs_inode_is_filestream(ap->ip)) {
>  			ag = xfs_filestream_lookup_ag(ap->ip);
>  			ag = (ag != NULLAGNUMBER) ? ag : 0;
> @@ -3467,7 +3467,7 @@ xfs_bmap_btalloc(
>  		 * enough for the request.  If one isn't found, then adjust
>  		 * the minimum allocation size to the largest space found.
>  		 */
> -		if (xfs_alloc_is_userdata(ap->datatype) &&
> +		if ((ap->datatype & XFS_ALLOC_USERDATA) &&
>  		    xfs_inode_is_filestream(ap->ip))
>  			error = xfs_bmap_btalloc_filestreams(ap, &args, &blen);
>  		else
> @@ -4010,10 +4010,9 @@ xfs_bmap_alloc_userdata(
>  	 */
>  	bma->datatype = XFS_ALLOC_NOBUSY;
>  	if (whichfork == XFS_DATA_FORK) {
> +		bma->datatype |= XFS_ALLOC_USERDATA;
>  		if (bma->offset == 0)
>  			bma->datatype |= XFS_ALLOC_INITIAL_USER_DATA;
> -		else
> -			bma->datatype |= XFS_ALLOC_USERDATA;
>  
>  		if (mp->m_dalign && bma->length >= mp->m_dalign) {
>  			error = xfs_bmap_isaeof(bma, whichfork);
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index 2183d87be4cf..3991e59cfd18 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -367,7 +367,7 @@ xfs_extent_busy_trim(
>  		 * If this is a metadata allocation, try to reuse the busy
>  		 * extent instead of trimming the allocation.
>  		 */
> -		if (!xfs_alloc_is_userdata(args->datatype) &&
> +		if (!(args->datatype & XFS_ALLOC_USERDATA) &&
>  		    !(busyp->flags & XFS_EXTENT_BUSY_DISCARDED)) {
>  			if (!xfs_extent_busy_update_extent(args->mp, args->pag,
>  							  busyp, fbno, flen,
> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index 574a7a8b4736..2ae356775f63 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
> @@ -374,7 +374,7 @@ xfs_filestream_new_ag(
>  		startag = (item->ag + 1) % mp->m_sb.sb_agcount;
>  	}
>  
> -	if (xfs_alloc_is_userdata(ap->datatype))
> +	if (ap->datatype & XFS_ALLOC_USERDATA)
>  		flags |= XFS_PICK_USERDATA;
>  	if (ap->tp->t_flags & XFS_TRANS_LOWMODE)
>  		flags |= XFS_PICK_LOWSPACE;
> -- 
> 2.20.1
> 
