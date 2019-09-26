Return-Path: <SRS0=9/io=XV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14432C4360C
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 14:37:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2FD321D56
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 14:37:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lidc6vmd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbfIZOhj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Sep 2019 10:37:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56366 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbfIZOhj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Sep 2019 10:37:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8QEY801046697;
        Thu, 26 Sep 2019 14:37:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Tmwprk0lmnBQUvHH6rcVvYGRhpZqa3f3F/w8fDa9Ts8=;
 b=lidc6vmdhRiA2mGaRp9GVXrqJAFJszgZoL+ZlLLe1Hxo6rELzrQ0HyQ53Duc6rXuLApd
 epfILGWVDMuZNrHPGaTmVzFkvWHNMlwJtxnU+HBjNOyzFGF8wYRZ61RTgEtwQCPK+WWJ
 gkIhY401XKGCPIe32P20+V1ZAoIzgVoNjDxRbfgJ5cIl7RCTBPki+sUebhL5tHhq+ciB
 4qmBiHh9jDgFz7Qp7oYTWKwHFdIQyOFCQd9oDM6HEbjEBYmyYs4584V89hMK6Gee0Xn1
 owuMeiC+18w0lZSjMvVci4i0YpIjkSE8QbSKt3lQxaKNpt8pEohYNXxcTdDWQwNDsV4Q 6g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2v5btqc8m7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Sep 2019 14:37:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8QETAA8157716;
        Thu, 26 Sep 2019 14:37:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2v8rvtcjys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Sep 2019 14:37:16 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8QEbGIm006943;
        Thu, 26 Sep 2019 14:37:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Sep 2019 07:37:15 -0700
Date:   Thu, 26 Sep 2019 07:37:14 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Max Reitz <mreitz@redhat.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: Fix tail rounding in xfs_alloc_file_space()
Message-ID: <20190926143704.GA9916@magnolia>
References: <20190926142238.26973-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926142238.26973-1-mreitz@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909260134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909260135
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 26, 2019 at 04:22:38PM +0200, Max Reitz wrote:
> To ensure that all blocks touched by the range [offset, offset + count)
> are allocated, we need to calculate the block count from the difference
> of the range end (rounded up) and the range start (rounded down).
> 
> Before this patch, we just round up the byte count, which may lead to
> unaligned ranges not being fully allocated:
> 
> $ touch test_file
> $ block_size=$(stat -fc '%S' test_file)
> $ fallocate -o $((block_size / 2)) -l $block_size test_file
> $ xfs_bmap test_file
> test_file:
>         0: [0..7]: 1396264..1396271
>         1: [8..15]: hole
> 
> There should not be a hole there.  Instead, the first two blocks should
> be fully allocated.
> 
> With this patch applied, the result is something like this:
> 
> $ touch test_file
> $ block_size=$(stat -fc '%S' test_file)
> $ fallocate -o $((block_size / 2)) -l $block_size test_file
> $ xfs_bmap test_file
> test_file:
>         0: [0..15]: 11024..11039

Code looks ok; by any chance do you have an xfstest we could add to the
regresion test suite?

--D

> Signed-off-by: Max Reitz <mreitz@redhat.com>
> ---
>  fs/xfs/xfs_bmap_util.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 0910cb75b65d..4f443703065e 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -864,6 +864,7 @@ xfs_alloc_file_space(
>  	xfs_filblks_t		allocatesize_fsb;
>  	xfs_extlen_t		extsz, temp;
>  	xfs_fileoff_t		startoffset_fsb;
> +	xfs_fileoff_t		endoffset_fsb;
>  	int			nimaps;
>  	int			quota_flag;
>  	int			rt;
> @@ -891,7 +892,8 @@ xfs_alloc_file_space(
>  	imapp = &imaps[0];
>  	nimaps = 1;
>  	startoffset_fsb	= XFS_B_TO_FSBT(mp, offset);
> -	allocatesize_fsb = XFS_B_TO_FSB(mp, count);
> +	endoffset_fsb = XFS_B_TO_FSB(mp, offset + count);
> +	allocatesize_fsb = endoffset_fsb - startoffset_fsb;
>  
>  	/*
>  	 * Allocate file space until done or until there is an error
> -- 
> 2.23.0
> 
