Return-Path: <SRS0=4VMi=2H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A69ADC43603
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Dec 2019 05:59:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CE5B206B7
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Dec 2019 05:59:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K0DA9reS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbfLQF7g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Dec 2019 00:59:36 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:42124 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbfLQF7g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Dec 2019 00:59:36 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBH5st5s028012;
        Tue, 17 Dec 2019 05:59:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=1u8l54WBfBDENNuWRpLuNwD15ENxULbCjOZ35SP/kWQ=;
 b=K0DA9reS1mKi9m7GI+CXXWPD88mpuDuqHye62Z2xeNasBcC+81npwjUwRvup12abHeCF
 i3LOZwyJa1aHUusqowXY51hnahpZGcrs6Q1b2nQSwClDnVnkgVCcQNzGfZlkE0rlJ0ni
 fjqLizVv9budOMx/aghuVkfezvizSsG6RMsJiAxfFX/IZz/QWh25bl58lvrX4oMlD4RH
 lVll0Pa5RSi0T6h2DyVfeOeIZyA0+K79j8GKRvZa3KI4chChvRpygpSZEj01/IjO/BC2
 lmmF1sd2dzavs4z7vUunhzZFnAq+lFFaIErloafoG/CcFQlpJqLhRYozCn/lfMNFPm2v oQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2wvqpq4ed0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Dec 2019 05:59:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBH5x5WQ140962;
        Tue, 17 Dec 2019 05:59:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2wxm4v4fgv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Dec 2019 05:59:32 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBH5xVvF007939;
        Tue, 17 Dec 2019 05:59:31 GMT
Received: from localhost (/10.159.159.234)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Dec 2019 21:59:31 -0800
Date:   Mon, 16 Dec 2019 21:59:27 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: stabilize insert range start boundary to avoid COW
 writeback race
Message-ID: <20191217055927.GB12765@magnolia>
References: <20191210132340.11330-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210132340.11330-1-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9473 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912170053
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9473 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912170053
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 10, 2019 at 08:23:40AM -0500, Brian Foster wrote:
> generic/522 (fsx) occasionally fails with a file corruption due to
> an insert range operation. The primary characteristic of the
> corruption is a misplaced insert range operation that differs from
> the requested target offset. The reason for this behavior is a race
> between the extent shift sequence of an insert range and a COW
> writeback completion that causes a front merge with the first extent
> in the shift.
> 
> The shift preparation function flushes and unmaps from the target
> offset of the operation to the end of the file to ensure no
> modifications can be made and page cache is invalidated before file
> data is shifted. An insert range operation then splits the extent at
> the target offset, if necessary, and begins to shift the start
> offset of each extent starting from the end of the file to the start
> offset. The shift sequence operates at extent level and so depends
> on the preparation sequence to guarantee no changes can be made to
> the target range during the shift. If the block immediately prior to
> the target offset was dirty and shared, however, it can undergo
> writeback and move from the COW fork to the data fork at any point
> during the shift. If the block is contiguous with the block at the
> start offset of the insert range, it can front merge and alter the
> start offset of the extent. Once the shift sequence reaches the
> target offset, it shifts based on the latest start offset and
> silently changes the target offset of the operation and corrupts the
> file.
> 
> To address this problem, update the shift preparation code to
> stabilize the start boundary along with the full range of the
> insert. Also update the existing corruption check to fail if any
> extent is shifted with a start offset behind the target offset of
> the insert range. This prevents insert from racing with COW
> writeback completion and fails loudly in the event of an unexpected
> extent shift.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> This has survived a couple fstests runs (upstream) so far as well as an
> overnight loop test of generic/522 (on RHEL). The RHEL based kernel just
> happened to be where this was originally diagnosed and provides a fairly
> reliable failure rate of within 30 iterations or so. The current test is
> at almost 70 iterations and still running.
> 
> Brian

After a week of testing I declare that 2.5 billion fsxops should be
enough for anyone. :P

This /also/ seems to have fixed the separate corruption problems I was
seeing, so...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
>  fs/xfs/libxfs/xfs_bmap.c |  3 +--
>  fs/xfs/xfs_bmap_util.c   | 12 ++++++++++++
>  2 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index a9ad1f991ba3..4a802b3abe77 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5972,8 +5972,7 @@ xfs_bmap_insert_extents(
>  		goto del_cursor;
>  	}
>  
> -	if (XFS_IS_CORRUPT(mp,
> -			   stop_fsb >= got.br_startoff + got.br_blockcount)) {
> +	if (XFS_IS_CORRUPT(mp, stop_fsb > got.br_startoff)) {
>  		error = -EFSCORRUPTED;
>  		goto del_cursor;
>  	}
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 2efd78a9719e..e62fb5216341 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -992,6 +992,7 @@ xfs_prepare_shift(
>  	struct xfs_inode	*ip,
>  	loff_t			offset)
>  {
> +	struct xfs_mount	*mp = ip->i_mount;
>  	int			error;
>  
>  	/*
> @@ -1004,6 +1005,17 @@ xfs_prepare_shift(
>  			return error;
>  	}
>  
> +	/*
> +	 * Shift operations must stabilize the start block offset boundary along
> +	 * with the full range of the operation. If we don't, a COW writeback
> +	 * completion could race with an insert, front merge with the start
> +	 * extent (after split) during the shift and corrupt the file. Start
> +	 * with the block just prior to the start to stabilize the boundary.
> +	 */
> +	offset = round_down(offset, 1 << mp->m_sb.sb_blocklog);
> +	if (offset)
> +		offset -= (1 << mp->m_sb.sb_blocklog);
> +
>  	/*
>  	 * Writeback and invalidate cache for the remainder of the file as we're
>  	 * about to shift down every extent from offset to EOF.
> -- 
> 2.20.1
> 
