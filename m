Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42328 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932716AbeB1TIX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Feb 2018 14:08:23 -0500
Date: Wed, 28 Feb 2018 19:08:21 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH] xfs: Correctly invert xfs_buftarg LRU isolation logic
Message-ID: <20180228190821.GA14201@wotan.suse.de>
References: <20180228154951.31714-1-vbendel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180228154951.31714-1-vbendel@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Vratislav Bendel <vbendel@redhat.com>
Cc: linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org

On Wed, Feb 28, 2018 at 04:49:51PM +0100, Vratislav Bendel wrote:
> The function xfs_buftarg_isolate() used by xfs buffer schrinkers 
> to determine whether a buffer should be isolated and disposed 
> from LRU list, has inverted logic.
> 
> Excerpt from xfs_buftarg_isolate():
>         /*
>          * Decrement the b_lru_ref count unless the value is already
>          * zero. If the value is already zero, we need to reclaim the
>          * buffer, otherwise it gets another trip through the LRU.
>          */
>         if (!atomic_add_unless(&bp->b_lru_ref, -1, 0)) {
>                 spin_unlock(&bp->b_lock);
>                 return LRU_ROTATE;
>         }
> 
> However, as per documentation, atomic_add_unless() returns _zero_
> if the atomic value was originally equal to the specified *unsless* value.
> 
> Ultimately causing a xfs_buffer with ->b_lru_ref == 0, to take another 
> trip around LRU, while isolating buffers with non-zero b_lru_ref.
> 
> Signed-off-by: Vratislav Bendel <vbendel@redhat.com>
> CC: Brian Foster <bfoster@redhat.com>

Can you add a respective Fixes: tag?  Also what effects are observed by
the user when this happens on the kernel log?

 Luis
