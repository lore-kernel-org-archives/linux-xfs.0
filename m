Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDAB4C43460
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 16:00:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A14D1611C2
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 16:00:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239270AbhDPQBN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Apr 2021 12:01:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238672AbhDPQAj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Apr 2021 12:00:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A7C0611C2;
        Fri, 16 Apr 2021 16:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618588814;
        bh=4TbhezQ9iGz85Oxi9DhPwfuQqeQyNbTSAkh8g+JgZo8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JPQvEeTpiuFO78HBwy8AHbtd0Dbkjm6Mqlcc8eiGhDhY+GGQu9A+WLIwX6wEWyV6X
         Fyv+tLZsOo+jmHGM7nVrlttJ9DPye3DUJBdUEZhqTt3WCTHzKJ0rhAeFUJJ1L0AxY3
         CNK+OYlpAqA7ImucchJfXPEO6gIO5n6hjcPj1r42ouy4gM0D65f+EOt6pLRFGARWtm
         eAo+SMxQ82R+6Bkl7HiSRLPg540cHfXthR4JejQK3tyDm55d3m0TcVmKnbjaltFcpT
         rKSXSS+K8x4qMSbGwlt3qTRwp0D/tH15WoDoWSETUuTXn7tNkcLuCID0jpVObxUFt2
         3HjlPuxZjpnKQ==
Date:   Fri, 16 Apr 2021 09:00:13 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] xfs: don't use in-core per-cpu fdblocks for !lazysbcount
Message-ID: <20210416160013.GB3122264@magnolia>
References: <20210416091023.2143162-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210416091023.2143162-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 16, 2021 at 05:10:23PM +0800, Gao Xiang wrote:
> There are many paths which could trigger xfs_log_sb(), e.g.
>   xfs_bmap_add_attrfork()
>     -> xfs_log_sb()
> , which overrided on-disk fdblocks by in-core per-CPU fdblocks.
> 
> However, for !lazysbcount cases, on-disk fdblocks is actually updated
> by xfs_trans_apply_sb_deltas(), and generally it isn't equal to
> in-core fdblocks due to xfs_reserve_block() or whatever, see the
> comment in xfs_unmountfs().
> 
> It could be observed by the following steps reported by Zorro [1]:
> 
> 1. mkfs.xfs -f -l lazy-count=0 -m crc=0 $dev
> 2. mount $dev $mnt
> 3. fsstress -d $mnt -p 100 -n 1000 (maybe need more or less io load)
> 4. umount $mnt
> 5. xfs_repair -n $dev
> 
> yet due to commit f46e5a174655("xfs: fold sbcount quiesce logging
> into log covering"), xfs_sync_sb() will be triggered even !lazysbcount
> but xfs_log_need_covered() case when xfs_unmountfs(), so hard to
> reproduce on kernel 5.12+.

Um, I can't understand this(?), possibly because I can't get to RHBZ and
therefore have very little context to start from. :(

Are you saying that because the f46e commit removed the xfs_sync_sb
calls from unmountfs for !lazysb filesystems, we no longer log the
summary counters at unmount?  Which means that we no longer write the
incore percpu fdblocks count to disk at unmount after we've torn down
all the incore space reservations (when sb_fdblocks == m_fdblocks)?

So that means that for !lazysb fses, the only time we log the sb
counters is during transactions, and when we do log the counters we
actually log the wrong value, since the incore reservations should never
escape to disk?  Hence the fix below?

And then by extension, is the reason that nobody noticed before is that
we always used to log the correct value at unmount, so fses with clean
logs always have the correct value, and fses with dirty logs will
recompute fdblocks after log recovery by summing the AGF free blocks
counts?

(Or possibly nobody uses !lazysb filesystems anymore?)

I /think/ the code change looks ok, but as you might surmise from the
large quantity of questions, I'm not ready to RVB this yet.  The commit
message seems like a good place to answer those questions.

> After this patch, I've seen no strange so far on older kernels
> for the testcase above without lazysbcount.
> 
> [1] https://bugzilla.redhat.com/show_bug.cgi?id=1949515

This strangely <cough> doesn't seem to be accessible to the public at
large, since <cough> someone at RedHat decided to block all Oracle IPs
<cough>.

--D

> 
> Reported-by: Zorro Lang <zlang@redhat.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_sb.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 60e6d255e5e2..423dada3f64c 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -928,7 +928,13 @@ xfs_log_sb(
>  
>  	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
>  	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
> -	mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> +	if (!xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> +		struct xfs_dsb	*dsb = bp->b_addr;
> +
> +		mp->m_sb.sb_fdblocks = be64_to_cpu(dsb->sb_fdblocks);
> +	} else {
> +		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> +	}
>  
>  	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
>  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
> -- 
> 2.27.0
> 
