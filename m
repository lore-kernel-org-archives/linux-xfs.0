Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07CC5CA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 16:54:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B851720B7C
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 16:54:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VSNudpfP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732910AbfJVQyB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 12:54:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34096 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727885AbfJVQyB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 12:54:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MGrqrX187103;
        Tue, 22 Oct 2019 16:53:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=3mvRHz1EESvZft3VUEIiiEjrUpv/w3iLc5G5I4ZM6Xw=;
 b=VSNudpfPt/nuUE25fV8QsD020t73RR4+p058ToCgws0mOoLeRxisICj8gvu+Aet110xi
 Iyglb6JtQGP204w/IJcYbEDtRFD/OuOMcOHz7byqLfKo8xkmrg14g2KhXfVKhBhL5fXf
 asZghUiOQ1DybJBShwXchROCwKDpEJGHsMMVRIxhMH9S6BehStkPovqElIG4G+CCZB8j
 KDxfiPF1WhmL7hzXihXIGoq6gH3rcxG4Avtb0EqQkhmzCFSlfDNL6GQx7Lq50jGYdl8o
 pCI5D79O28H02GD0FhCCn/MfH8LHeLoWRpQUXLy2hR/hQXFsULzYzqwJvlA0r7qlAn27 PA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2vqu4qqx79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 16:53:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MGmdnc115384;
        Tue, 22 Oct 2019 16:51:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2vsx2r9t2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 16:51:50 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9MGpnc0005498;
        Tue, 22 Oct 2019 16:51:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 09:51:48 -0700
Date:   Tue, 22 Oct 2019 09:51:47 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] xfs: don't set bmapi total block req where
 minleft is sufficient
Message-ID: <20191022165147.GL913374@magnolia>
References: <20191021121322.25659-1-bfoster@redhat.com>
 <20191021121322.25659-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021121322.25659-3-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220141
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 21, 2019 at 08:13:22AM -0400, Brian Foster wrote:
> xfs_bmapi_write() takes a total block requirement parameter that is
> passed down to the block allocation code and is used to specify the
> total block requirement of the associated transaction. This is used
> to try and select an AG that can not only satisfy the requested
> extent allocation, but can also accommodate subsequent allocations
> that might be required to complete the transaction. For example,
> additional bmbt block allocations may be required on insertion of
> the resulting extent to an inode data fork.
> 
> While it's important for callers to calculate and reserve such extra
> blocks in the transaction, it is not necessary to pass the total
> value to xfs_bmapi_write() in all cases. The latter automatically
> sets minleft to ensure that sufficient free blocks remain after the
> allocation attempt to expand the format of the associated inode
> (i.e., such as extent to btree conversion, btree splits, etc).
> Therefore, any callers that pass a total block requirement of the
> bmap mapping length plus worst case bmbt expansion essentially
> specify the additional reservation requirement twice. These callers
> can pass a total of zero to rely on the bmapi minleft policy.
> 
> Beyond being superfluous, the primary motivation for this change is
> that the total reservation logic in the bmbt code is dubious in
> scenarios where minlen < maxlen and a maxlen extent cannot be
> allocated (which is more common for data extent allocations where
> contiguity is not required). The total value is based on maxlen in
> the xfs_bmapi_write() caller. If the bmbt code falls back to an
> allocation between minlen and maxlen, that allocation will not
> succeed until total is reset to minlen, which essentially throws
> away any additional reservation included in total by the caller. In
> addition, the total value is not reset until after alignment is
> dropped, which means that such callers drop alignment far too
> aggressively than necessary.
> 
> Update all callers of xfs_bmapi_write() that pass a total block
> value of the mapping length plus bmbt reservation to instead pass
> zero and rely on xfs_bmapi_minleft() to enforce the bmbt reservation
> requirement. This trades off slightly less conservative AG selection
> for the ability to preserve alignment in more scenarios.
> xfs_bmapi_write() callers that incorporate unrelated or additional
> reservations in total beyond what is already included in minleft
> must continue to use the former.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Hmm, /me wonders about the other xfs_bmapi_write cases (remote attrs,
dir/attr allocations, and symlinks) which pass in a nonzero @total?  I
guess those are metadata so we have no alignment requirements and
over-reserving isn't a huge deal?

I also wonder if the xfs_bmapi_write call in xfs_iomap_write_unwritten
needs the same treatment, but the resblks calculation inexplicably(?)
doubles itself.  Not sure why, since in the "splitting the middle of an
extent" case we hold the ilock across both insertions, and one split
should leave us with two half-full leaves, right?  (Maybe this is its
own investigate-and-fix patch...)

<shrug> In the mean time, this part looks ok.
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 1 -
>  fs/xfs/xfs_bmap_util.c   | 4 ++--
>  fs/xfs/xfs_dquot.c       | 4 ++--
>  fs/xfs/xfs_iomap.c       | 4 ++--
>  fs/xfs/xfs_reflink.c     | 4 ++--
>  fs/xfs/xfs_rtalloc.c     | 3 +--
>  6 files changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index c118577deaa9..65e38bd954d1 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4505,7 +4505,6 @@ xfs_bmapi_convert_delalloc(
>  	bma.wasdel = true;
>  	bma.offset = bma.got.br_startoff;
>  	bma.length = max_t(xfs_filblks_t, bma.got.br_blockcount, MAXEXTLEN);
> -	bma.total = XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK);
>  	bma.minleft = xfs_bmapi_minleft(tp, ip, whichfork);
>  	if (whichfork == XFS_COW_FORK)
>  		bma.flags = XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC;
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 4f443703065e..15547e089565 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -964,8 +964,8 @@ xfs_alloc_file_space(
>  		xfs_trans_ijoin(tp, ip, 0);
>  
>  		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
> -					allocatesize_fsb, alloc_type, resblks,
> -					imapp, &nimaps);
> +					allocatesize_fsb, alloc_type, 0, imapp,
> +					&nimaps);
>  		if (error)
>  			goto error0;
>  
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index aeb95e7391c1..b924dbd63a7d 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -305,8 +305,8 @@ xfs_dquot_disk_alloc(
>  	/* Create the block mapping. */
>  	xfs_trans_ijoin(tp, quotip, XFS_ILOCK_EXCL);
>  	error = xfs_bmapi_write(tp, quotip, dqp->q_fileoffset,
> -			XFS_DQUOT_CLUSTER_SIZE_FSB, XFS_BMAPI_METADATA,
> -			XFS_QM_DQALLOC_SPACE_RES(mp), &map, &nmaps);
> +			XFS_DQUOT_CLUSTER_SIZE_FSB, XFS_BMAPI_METADATA, 0, &map,
> +			&nmaps);
>  	if (error)
>  		return error;
>  	ASSERT(map.br_blockcount == XFS_DQUOT_CLUSTER_SIZE_FSB);
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index f780e223b118..27f2030690e2 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -277,8 +277,8 @@ xfs_iomap_write_direct(
>  	 * caller gave to us.
>  	 */
>  	nimaps = 1;
> -	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
> -				bmapi_flags, resblks, imap, &nimaps);
> +	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb, bmapi_flags, 0,
> +				imap, &nimaps);
>  	if (error)
>  		goto out_res_cancel;
>  
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 0f08153b4994..3aa56cac1a47 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -410,8 +410,8 @@ xfs_reflink_allocate_cow(
>  	/* Allocate the entire reservation as unwritten blocks. */
>  	nimaps = 1;
>  	error = xfs_bmapi_write(tp, ip, imap->br_startoff, imap->br_blockcount,
> -			XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC,
> -			resblks, imap, &nimaps);
> +			XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC, 0, imap,
> +			&nimaps);
>  	if (error)
>  		goto out_unreserve;
>  
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 4a48a8c75b4f..d42b5a2047e0 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -792,8 +792,7 @@ xfs_growfs_rt_alloc(
>  		 */
>  		nmap = 1;
>  		error = xfs_bmapi_write(tp, ip, oblocks, nblocks - oblocks,
> -					XFS_BMAPI_METADATA, resblks, &map,
> -					&nmap);
> +					XFS_BMAPI_METADATA, 0, &map, &nmap);
>  		if (!error && nmap < 1)
>  			error = -ENOSPC;
>  		if (error)
> -- 
> 2.20.1
> 
