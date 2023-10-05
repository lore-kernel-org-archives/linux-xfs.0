Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B438E93710
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Oct 2023 13:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbjJENz4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Oct 2023 09:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244172AbjJENvs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Oct 2023 09:51:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04171261B0
        for <linux-xfs@vger.kernel.org>; Thu,  5 Oct 2023 05:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ol2dTQDO3hTQQBwkXIy1tIrDmTnHO36VMUusSjL1y6s=; b=UFwxaMtxZgz4X2wViuqh07izEU
        udT+VV64rMHShUuYpMmtO8R4gsjtI6sAItJU2owZ3TfX5AzTydMsLpvTc2Nab2NC3OCZJ+z/HqZTO
        sP9NfVvxBhiL71dRc1wd823WbbE4H2BhCgnAW2Vo0VytngcraguEQZd66JQi6SzL2efoH3IerVLZ2
        AvjG7Oi/SZioNEmbYfBWs9FaTgi4Kx9SvHdrRm4tcRJwiqIYBiSInnNlw0sq4TJtx6fSNHq9rcEOu
        c0hmGh4QsIEVoNO+3PFTQGQHxsDclqa7l+A2VfYR3HMwfBOwyZonttlGz2pQJdhrSJ7vrYLkTRwC2
        NHQh55Xw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qoNLr-002k9J-1R;
        Thu, 05 Oct 2023 12:21:11 +0000
Date:   Thu, 5 Oct 2023 05:21:11 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, john.g.garry@oracle.com
Subject: Re: [PATCH 9/9] xfs: return -ENOSPC rather than NULLFSBLOCK from
 allocation functions
Message-ID: <ZR6qN3ZguKiZy7pC@infradead.org>
References: <20231004001943.349265-1-david@fromorbit.com>
 <20231004001943.349265-10-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231004001943.349265-10-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> Make sure we don't have a repeat of this situation by changing the
> API to explicitly return ENOSPC when we fail to allocate. If we fail
> to capture this correctly, it will lead to failures being noticed
> either by ENOSPC escaping to userspace or by causing filesystem
> shutdowns when allocations failure where they really shouldn't.

Yes, the retur 0 on ENOSPC has driven me crazy in the past.

Note that you now also drop the XXX comment on xfs_alloc_vextent_finish
about this.

> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 27c62f303488..13fda27fabcb 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1157,9 +1157,9 @@ xfs_alloc_ag_vextent_small(
>  	 * Can't do the allocation, give up.
>  	 */
>  	if (flen < args->minlen) {
> -		args->agbno = NULLAGBLOCK;
>  		trace_xfs_alloc_small_notenough(args);
> -		flen = 0;
> +		error = -ENOSPC;
> +		goto error;

I suspect a direct return -ENOSPC here might be better, as we already
have the trace_xfs_alloc_small_notenough tracepoint here, and also
hitting trace_xfs_alloc_small_error wouldn't make much sense (and be
a pointles behavior change).

Looking at the callers of xfs_alloc_ag_vextent_small, both seem to
need an update to check for -ENOSPC explicitly, as they first check
for an error and only after that for i == 0 || len == 0 to detect
the no space case.

> @@ -3375,14 +3370,7 @@ xfs_alloc_vextent_finish(
>  	     args->agno > minimum_agno))
>  		args->tp->t_highest_agno = args->agno;
>  
> -	/*
> -	 * If the allocation failed with an error or we had an ENOSPC result,
> -	 * preserve the returned error whilst also marking the allocation result
> -	 * as "no extent allocated". This ensures that callers that fail to
> -	 * capture the error will still treat it as a failed allocation.
> -	 */
> -	if (alloc_error || args->agbno == NULLAGBLOCK) {
> -		args->fsbno = NULLFSBLOCK;
> +	if (alloc_error) {
>  		error = alloc_error;
>  		goto out_drop_perag;
>  	}

Maybe throw in a

	ASSERT(args->agbno != NULLAGBLOCK);

after this conditional to catch backporting errors and the like?

