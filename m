Return-Path: <SRS0=9CIi=XZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 999E1C32792
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 23:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6825B2086A
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 23:04:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XqNbj2zd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbfI3XEM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Sep 2019 19:04:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47656 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfI3XEL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Sep 2019 19:04:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8UI9x5n085059;
        Mon, 30 Sep 2019 18:25:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=LwSaaUd/kUeXILiND58ytLip+C3aQQ7X4RYaZ3Vc3po=;
 b=XqNbj2zd+3oHVF+Lpvh/Eifb/Kyeotn/QeNY92U0KAPFg0IYN41nmAc7+vHQv7aRx55V
 ht/WLv4bpT1ys2Mbufdp5EYDyZAqVS0V1CluDyUB2MG78a1kMVbUTMyzmxrffiAwAgNP
 EyqUPPaJtWDntYwRFnBcyCOgw9V2lnpnGu6NEv6NR2mPdtF8HH6Xg8QOH9TLGepcmt8T
 nkCFhUAR9WNgei6b3XBBd4YfE44ahjgXBW8Zab91H/Y8yNB86lkg275tOR2/XLo6Mih0
 iUTsPC/OudBfTaP2kw3N6UxXIn/6KWGVNj8ekO+g0EoFDBZN+rpwA/Y+GgiqBQnBjJZL NA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2v9yfq12ye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Sep 2019 18:25:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8UIDUrS083260;
        Mon, 30 Sep 2019 18:25:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2vbnqb4bmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Sep 2019 18:25:17 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8UIPGJN007705;
        Mon, 30 Sep 2019 18:25:16 GMT
Received: from localhost (/67.161.8.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Sep 2019 11:25:15 -0700
Date:   Mon, 30 Sep 2019 11:25:15 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Max Reitz <mreitz@redhat.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: Fix tail rounding in xfs_alloc_file_space()
Message-ID: <20190930182515.GE13108@magnolia>
References: <20190926142238.26973-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926142238.26973-1-mreitz@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909300165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909300165
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
> 
> Signed-off-by: Max Reitz <mreitz@redhat.com>

Looks ok, will test...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

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
