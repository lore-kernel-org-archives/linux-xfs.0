Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA8C5C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 19:08:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC2BC60F3A
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 19:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbhJLTKY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Oct 2021 15:10:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:33398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231751AbhJLTKY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Oct 2021 15:10:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94BFA601FA;
        Tue, 12 Oct 2021 19:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634065702;
        bh=xOsh0JSmkemRR5j1SF7p4r6ObbaUNKO/TXYXQqJydek=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ifFDF/Zcnh7mo+8rlB+3RqUQs9SXYjw9ODVyRO7Wkx9LlmtfW0bqNgh7vsBhpIQ8m
         arjY4H3UYEj76wxHAhPvFPmqUSEnr2MURVBWk82ShY3SD1+nBLYHJFRTClKReFCK+w
         atpewWtdSwIqlT0/eGWSS6J4Mq2cEN4JdX7U2lM/jAzYiIIN0s6xOFY0kGDJzddDnS
         /8xvRwWdFhruVR3L6VOeOP7Abitg5Oo7+GbP8M45G8zDyuCxRhpfrxYYMVfPZEtEwB
         IE88W0G9KjUhsEI3Q2JgOzFA9uuZXbNAJTfR/gXx2XdcxN5RYYtSXVTLua9uulrnzT
         LtbFI3YBe4AbA==
Date:   Tue, 12 Oct 2021 12:08:22 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 3/4] xfs: terminate perag iteration reliably on agcount
Message-ID: <20211012190822.GN24307@magnolia>
References: <20211012165203.1354826-1-bfoster@redhat.com>
 <20211012165203.1354826-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211012165203.1354826-4-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 12, 2021 at 12:52:02PM -0400, Brian Foster wrote:
> The for_each_perag_from() iteration macro relies on sb_agcount to
> process every perag currently within EOFS from a given starting
> point. It's perfectly valid to have perag structures beyond
> sb_agcount, however, such as if a growfs is in progress. If a perag
> loop happens to race with growfs in this manner, it will actually
> attempt to process the post-EOFS perag where ->pag_agno ==
> sb_agcount. This is reproduced by xfs/104 and manifests as the
> following assert failure in superblock write verifier context:
> 
>  XFS: Assertion failed: agno < mp->m_sb.sb_agcount, file: fs/xfs/libxfs/xfs_types.c, line: 22
> 
> Update the corresponding macro to only process perags that are
> within the current sb_agcount.

Does this need a Fixes: tag?

Also ... should we be checking for agno <= agcount-1 for the initial
xfs_perag_get in the first for loop clause of for_each_perag_range?
I /think/ the answer is that the current users are careful enough to
check that race, but I haven't looked exhaustively.

Welcome back, by the way. :)

--D

> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ag.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index cf8baae2ba18..b8cc5017efba 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -142,7 +142,7 @@ struct xfs_perag *xfs_perag_next(
>  		(pag) = xfs_perag_next((pag), &(agno)))
>  
>  #define for_each_perag_from(mp, agno, pag) \
> -	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount, (pag))
> +	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount - 1, (pag))
>  
>  
>  #define for_each_perag(mp, agno, pag) \
> -- 
> 2.31.1
> 
