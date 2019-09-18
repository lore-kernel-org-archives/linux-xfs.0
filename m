Return-Path: <SRS0=SLm5=XN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1F20C4CEC4
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 21:42:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83AF921924
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 21:42:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DSRc514x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387797AbfIRVmK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 17:42:10 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42146 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387521AbfIRVmJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Sep 2019 17:42:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8ILdnqN045811;
        Wed, 18 Sep 2019 21:41:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=bQtXkfLFRfVlJmK4qqv6sbW0siGsKOG1MasAv6USp2g=;
 b=DSRc514xiAgCOHME1mIlnQmL9gN0QGL0PgcVMkQqeH2bg/ib0gvskC6slk4rRr0HYz4D
 EglSPwrU65QLILSQIMxg3jTnrfcwrOEt1XtDc1BoahEj+AXAJ31JENk8M/L32rL4aBVb
 R1HDMjP8jJ72e0fU41/TkVE3GOFzmOTRk7h2fMZNX+I/Y02ZKB0bk3MJ3H6f289+a/oS
 wNDqV4tbzfqRv0zSKaLp3IndYYw2vhjDNPVtA2VD2SABaNp2otvRWbwPfCMxtQ4SFrZo
 7tXVPXT9KOBcFqMNzDdDD6Bk8+bPXUbOLa+NPcPAPmtpa5jWzpfinVml9nqjqcP90ALM Nw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2v3vb4g31u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 21:41:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8ILdvZg056935;
        Wed, 18 Sep 2019 21:41:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2v3vb41d2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 21:41:43 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8ILfgiI020566;
        Wed, 18 Sep 2019 21:41:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Sep 2019 14:41:42 -0700
Date:   Wed, 18 Sep 2019 14:41:41 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH REPOST 1/2] xfs: drop minlen before tossing alignment on
 bmap allocs
Message-ID: <20190918214141.GG2229799@magnolia>
References: <20190912143223.24194-1-bfoster@redhat.com>
 <20190912143223.24194-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190912143223.24194-2-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909180184
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909180184
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 12, 2019 at 10:32:22AM -0400, Brian Foster wrote:
> The bmap block allocation code issues a sequence of retries to
> perform an optimal allocation, gradually loosening constraints as
> allocations fail. For example, the first attempt might begin at a
> particular bno, with maxlen == minlen and alignment incorporated. As
> allocations fail, the parameters fall back to different modes, drop
> alignment requirements and reduce the minlen and total block
> requirements.
> 
> For large extent allocations with an args.total value that exceeds
> the allocation length (i.e., non-delalloc), the total value tends to
> dominate despite these fallbacks. For example, an aligned extent
> allocation request of tens to hundreds of MB that cannot be
> satisfied from a particular AG will not succeed after dropping
> alignment or minlen because xfs_alloc_space_available() never
> selects an AG that can't satisfy args.total. The retry sequence

"..that can satisfy args.total"?

> eventually reduces total and ultimately succeeds if a minlen extent
> is available somewhere, but the first several retries are
> effectively pointless in this scenario.
> 
> Beyond simply being inefficient, another side effect of this
> behavior is that we drop alignment requirements too aggressively.
> Consider a 1GB fallocate on a 15GB fs with 16 AGs and 128k stripe
> unit:
> 
>  # xfs_io -c "falloc 0 1g" /mnt/file
>  # <xfstests>/src/t_stripealign /mnt/file 32
>  /mnt/file: Start block 347176 not multiple of sunit 32
> 
> Despite the filesystem being completely empty, the fact that the
> allocation request cannot be satisifed from a single AG means the
> allocation doesn't succeed until xfs_bmap_btalloc() drops total from
> the original value based on maxlen. This occurs after we've dropped
> minlen and alignment (unnecessarily).
> 
> As a step towards addressing this problem, insert a new retry in the
> bmap allocation sequence to drop minlen (from maxlen) before tossing
> alignment. This should still result in as large of an extent as
> possible as the block allocator prioritizes extent size in all but
> exact allocation modes. By itself, this does not change the behavior
> of the command above because the preallocation code still specifies
> total based on maxlen. Instead, this facilitates preservation of
> alignment once extra reservation is separated from the extent length
> portion of the total block requirement.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 054b4ce30033..eaa965920a03 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3573,6 +3573,14 @@ xfs_bmap_btalloc(
>  		if ((error = xfs_alloc_vextent(&args)))
>  			return error;
>  	}
> +	if (args.fsbno == NULLFSBLOCK && nullfb &&
> +	    args.minlen > ap->minlen) {

Maybe a comment here to point out that we're retrying the allocation
with the minimum acceptable minlen?  I say this mostly because (some of)
the other clauses have a quick description of the constraints that are
being fed to the allocation request, and it makes it easier to keep
track of what's going on.

> +		args.minlen = ap->minlen;
> +		args.fsbno = ap->blkno;
> +		error = xfs_alloc_vextent(&args);
> +		if (error)
> +			return error;
> +	}
>  	if (isaligned && args.fsbno == NULLFSBLOCK) {
>  		/*
>  		 * allocation failed, so turn off alignment and
> @@ -3584,9 +3592,7 @@ xfs_bmap_btalloc(
>  		if ((error = xfs_alloc_vextent(&args)))
>  			return error;
>  	}
> -	if (args.fsbno == NULLFSBLOCK && nullfb &&
> -	    args.minlen > ap->minlen) {
> -		args.minlen = ap->minlen;
> +	if (args.fsbno == NULLFSBLOCK && nullfb) {
>  		args.type = XFS_ALLOCTYPE_START_BNO;

Particularly when we get here and I have to look pretty closely to
figure out what this retry is now attempting to do.  This one is trying
the allocation again, but now with no alignment and the caller's minlen,
right?

--D

>  		args.fsbno = ap->blkno;
>  		if ((error = xfs_alloc_vextent(&args)))
> -- 
> 2.20.1
> 
