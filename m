Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97969C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 19:09:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B385610A2
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 19:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232434AbhJLTLp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Oct 2021 15:11:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:33958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231886AbhJLTLp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Oct 2021 15:11:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF5A9601FA;
        Tue, 12 Oct 2021 19:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634065783;
        bh=sjWJZFQjTJLt6ItwmR6cvPgef2fHATjJ0SL6Gk/pwQQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YW27Oaql3OfesKkjAQx0dWfI9q60tr0mffDq7S+ALXSHaWAufS6E2l6xgAfV4Afdx
         GjnuUEstnqqyFfKRK9D8y1imSKB3/hvZ5fWaRDbHsfXtJZ95GfxLgprpwbv/iWoHsO
         1uyUK5AvpM1x/GsWTTx17shlPPnTAdQ8dP1pmWEgCbcpgJEWHm2L8cKysqNppQz/Wz
         zG93D3R8ZRgVMsn56SqoTEXgjEZsqO1Tyczgyj3JXs7brVDeALI9OmQhO/oLfIQ9RH
         ms7Kkqg/I04dTKUKFTcLIqTU7DaivxBRY6a2xPElUrT6mcEoWzNGw/9ia4spMVn8Ya
         MaDw+xVJTID9w==
Date:   Tue, 12 Oct 2021 12:09:42 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 4/4] xfs: fix perag reference leak on iteration race
 with growfs
Message-ID: <20211012190942.GO24307@magnolia>
References: <20211012165203.1354826-1-bfoster@redhat.com>
 <20211012165203.1354826-5-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211012165203.1354826-5-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 12, 2021 at 12:52:03PM -0400, Brian Foster wrote:
> The for_each_perag*() set of macros are hacky in that some (i.e.
> those based on sb_agcount) rely on the assumption that perag
> iteration terminates naturally with a NULL perag at the specified
> end_agno. Others allow for the final AG to have a valid perag and
> require the calling function to clean up any potential leftover
> xfs_perag reference on termination of the loop.
> 
> Aside from providing a subtly inconsistent interface, the former
> variant is racy with growfs because growfs can create discoverable
> post-eofs perags before the final superblock update that completes
> the grow operation and increases sb_agcount. This leads to the
> following assert failure (reproduced by xfs/104) in the perag free
> path during unmount:
> 
>  XFS: Assertion failed: atomic_read(&pag->pag_ref) == 0, file: fs/xfs/libxfs/xfs_ag.c, line: 195
> 
> This occurs because one of the many for_each_perag() loops in the
> code that is expected to terminate with a NULL pag (and thus has no
> post-loop xfs_perag_put() check) raced with a growfs and found a
> non-NULL post-EOFS perag, but terminated naturally based on the
> end_agno check without releasing the post-EOFS perag.
> 
> Rework the iteration logic to lift the agno check from the main for
> loop conditional to the iteration helper function. The for loop now
> purely terminates on a NULL pag and xfs_perag_next() avoids taking a
> reference to any perag beyond end_agno in the first place.

That /definitely/ sounds like it needs a Fixes tag.

With that fixed, I think this is ready to go:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ag.h | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index b8cc5017efba..e20575c898f9 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -116,30 +116,26 @@ void xfs_perag_put(struct xfs_perag *pag);
>  
>  /*
>   * Perag iteration APIs
> - *
> - * XXX: for_each_perag_range() usage really needs an iterator to clean up when
> - * we terminate at end_agno because we may have taken a reference to the perag
> - * beyond end_agno. Right now callers have to be careful to catch and clean that
> - * up themselves. This is not necessary for the callers of for_each_perag() and
> - * for_each_perag_from() because they terminate at sb_agcount where there are
> - * no perag structures in tree beyond end_agno.
>   */
>  static inline
>  struct xfs_perag *xfs_perag_next(
>  	struct xfs_perag	*pag,
> -	xfs_agnumber_t		*agno)
> +	xfs_agnumber_t		*agno,
> +	xfs_agnumber_t		end_agno)
>  {
>  	struct xfs_mount	*mp = pag->pag_mount;
>  
>  	*agno = pag->pag_agno + 1;
>  	xfs_perag_put(pag);
> +	if (*agno > end_agno)
> +		return NULL;
>  	return xfs_perag_get(mp, *agno);
>  }
>  
>  #define for_each_perag_range(mp, agno, end_agno, pag) \
>  	for ((pag) = xfs_perag_get((mp), (agno)); \
> -		(pag) != NULL && (agno) <= (end_agno); \
> -		(pag) = xfs_perag_next((pag), &(agno)))
> +		(pag) != NULL; \
> +		(pag) = xfs_perag_next((pag), &(agno), (end_agno)))
>  
>  #define for_each_perag_from(mp, agno, pag) \
>  	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount - 1, (pag))
> -- 
> 2.31.1
> 
