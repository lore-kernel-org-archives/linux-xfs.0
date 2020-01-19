Return-Path: <SRS0=5eVt=3I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10865C33CAF
	for <linux-xfs@archiver.kernel.org>; Sun, 19 Jan 2020 21:49:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD7E420714
	for <linux-xfs@archiver.kernel.org>; Sun, 19 Jan 2020 21:49:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbgASVtJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 19 Jan 2020 16:49:09 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:34276 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727195AbgASVtJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 19 Jan 2020 16:49:09 -0500
Received: from dread.disaster.area (pa49-181-172-170.pa.nsw.optusnet.com.au [49.181.172.170])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id EA6E6820807;
        Mon, 20 Jan 2020 08:49:04 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1itIRL-0007bP-VD; Mon, 20 Jan 2020 08:49:03 +1100
Date:   Mon, 20 Jan 2020 08:49:03 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/11] xfs: make xfs_buf_alloc return an error code
Message-ID: <20200119214903.GD9407@dread.disaster.area>
References: <157924221149.3029431.1461924548648810370.stgit@magnolia>
 <157924221800.3029431.576491686056157423.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157924221800.3029431.576491686056157423.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=IIEU8dkfCNxGYurWsojP/w==:117 a=IIEU8dkfCNxGYurWsojP/w==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=Jdjhy38mL1oA:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=pfA_ihv-jOkS7g5TXS8A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 16, 2020 at 10:23:38PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Convert _xfs_buf_alloc() to return numeric error codes like most
> everywhere else in xfs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
....
> @@ -715,8 +718,8 @@ xfs_buf_get_map(
>  		return NULL;
>  	}
>  
> -	new_bp = _xfs_buf_alloc(target, map, nmaps, flags);
> -	if (unlikely(!new_bp))
> +	error = _xfs_buf_alloc(target, map, nmaps, flags, &new_bp);
> +	if (unlikely(error))
>  		return NULL;

You can kill the unlikely() while you are at it. They are largely
unnecessary as the compiler already considers branches with returns
in them as unlikely and we don't need "unlikely" as code
documentation for error conditions like this...

>  	error = xfs_buf_allocate_memory(new_bp, flags);
> @@ -917,8 +920,8 @@ xfs_buf_get_uncached(
>  	DEFINE_SINGLE_BUF_MAP(map, XFS_BUF_DADDR_NULL, numblks);
>  
>  	/* flags might contain irrelevant bits, pass only what we care about */
> -	bp = _xfs_buf_alloc(target, &map, 1, flags & XBF_NO_IOACCT);
> -	if (unlikely(bp == NULL))
> +	error = _xfs_buf_alloc(target, &map, 1, flags & XBF_NO_IOACCT, &bp);
> +	if (unlikely(error))
>  		goto fail;

here too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
