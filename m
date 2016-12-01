Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34738 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758130AbcLAMPq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Dec 2016 07:15:46 -0500
Date: Thu, 1 Dec 2016 07:15:44 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] xfs: set AGI buffer type in
 xlog_recover_clear_agi_bucket
Message-ID: <20161201121543.GB22890@bfoster.bfoster>
References: <203e6e5c-7663-b49b-36af-5885aa1f461a@redhat.com>
 <4a62db7d-d3aa-9ad7-4b28-87964f312e15@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a62db7d-d3aa-9ad7-4b28-87964f312e15@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Nov 30, 2016 at 04:40:18PM -0600, Eric Sandeen wrote:
> xlog_recover_clear_agi_bucket didn't set the
> type to XFS_BLFT_AGI_BUF, so we got a warning during log
> replay (or an ASSERT on a debug build).
> 
>     XFS (md0): Unknown buffer type 0!
>     XFS (md0): _xfs_buf_ioapply: no ops on block 0xaea8802/0x1
> 
> Fix this, as was done in f19b872b for 2 other locations
> with the same problem.
> 
> cc: <stable@vger.kernel.org> # 3.10 to current
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 9b3d7c7..2d91f5a 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -4929,6 +4929,7 @@ static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
>  	agi->agi_unlinked[bucket] = cpu_to_be32(NULLAGINO);
>  	offset = offsetof(xfs_agi_t, agi_unlinked) +
>  		 (sizeof(xfs_agino_t) * bucket);
> +	xfs_trans_buf_set_type(tp, agibp, XFS_BLFT_AGI_BUF);
>  	xfs_trans_log_buf(tp, agibp, offset,
>  			  (offset + sizeof(xfs_agino_t) - 1));
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
