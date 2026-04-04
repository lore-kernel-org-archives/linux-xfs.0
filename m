Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7571F03D2
	for <linux-xfs@vger.kernel.org>; Sat,  4 Apr 2026 11:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775302984; cv=none; b=WKz0+uYRNQAM1em9y6gMS9QjazGxmKOp7/NUfCsdKReYlq3tMlSXybXFEnR/gKCTy1PfCKoxea3nWFAm1s1MvYy1Go0WDlWbes9bw5vtKDZo78oYvz7YLxQdSCdHHIr7plxIciM7BaJ3hzgpvAyISdXXggoo67n6qKxJliFPD9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775302984; c=relaxed/simple;
	bh=Sdc6lsfMAqvIc1+DV7eIbKLZnEMQoI+ANeTpAGO2MHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aFPbBwQb5o+9F5XMHr0Bcjgqgkh/xw/KDPYkHgenQ4ZTtp0j0hcj6QIReLAH8C+BjI/2k7xqvNKBlj/HowAFCPdSGnQ7uH9kBFUydoVLyLza7zJcJIt5OVwwsyyx4ynyZ0jjfYcTj9tz5JmvSpHN+z5s0WG1A02UZn00xJWnEDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PumOeD9P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PumOeD9P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E12DC19421;
	Sat,  4 Apr 2026 11:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775302984;
	bh=Sdc6lsfMAqvIc1+DV7eIbKLZnEMQoI+ANeTpAGO2MHc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PumOeD9PrfCj3v4zr0BX/wNZxuf5RFB5qfez52edp4luwHU/CiRNfD3UTaOChEcmX
	 EkdROTqLeZ75OODQ8ldK3PXDxbTgKGsIdf9tN8jTpl/1Q9zHaPtszrOSMH5E9A3CdY
	 GW2/4P/IpwL+KLBfwPsOI5iQZ1wq6s69WIA180Y0KgPXaU9s/eJCHeFJ3MCO0qdjPX
	 aqWvp5ONiewd8C84VKXfPRPp7vr27f8Ddy1GWWPwPXth5sZhFBNhRyNlKFrAtNs4yt
	 6dbH+tSr1WiEHRdDeQflJUFqDWmDp4rtT8sbWQ+qK+jUPjxNg27Q96wZFbxB4idp5n
	 gtovYJI9O7XWg==
Date: Sat, 4 Apr 2026 22:42:59 +1100
From: Dave Chinner <dgc@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Hang with xfs/285 on 2026-03-02 kernel
Message-ID: <adDgYCmgNsA9ff3e@dread>
References: <ac_eUsuxqf6IYN7F@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac_eUsuxqf6IYN7F@casper.infradead.org>

On Fri, Apr 03, 2026 at 04:35:46PM +0100, Matthew Wilcox wrote:
> This is with commit 5619b098e2fb so after 7.0-rc6
> INFO: task fsstress:3762792 blocked on a semaphore likely last held by task fsstress:3762793
> task:fsstress        state:D stack:0     pid:3762793 tgid:3762793 ppid:3762783 task_flags:0x440140 flags:0x00080800
> Call Trace:
>  <TASK>
>  __schedule+0x560/0xfc0
>  schedule+0x3e/0x140
>  schedule_timeout+0x84/0x110
>  ? __pfx_process_timeout+0x10/0x10
>  io_schedule_timeout+0x5b/0x80
>  xfs_buf_alloc+0x793/0x7d0

-ENOMEM.

It'll be looping here:

fallback:
        for (;;) {
                bp->b_addr = __vmalloc(size, gfp_mask);
                if (bp->b_addr)
                        break;
                if (flags & XBF_READ_AHEAD)
                        return -ENOMEM;
                XFS_STATS_INC(bp->b_mount, xb_page_retries);
                memalloc_retry_wait(gfp_mask);
        }

If it is looping here long enough to trigger the hang check timer,
then the MM subsystem is not making progress reclaiming memory. This
is probably a 16kB allocation (it's an inode cluster buffer), and
the allocation context is NOFAIL because it is within a transaction
(this loop pre-dates __vmalloc() supporting __GFP_NOFAIL)....

All the other tasks are backed up on the AGI buffer lock held ...

>  xfs_buf_get_map+0x651/0xbd0
>  ? _raw_spin_unlock+0x26/0x50
>  xfs_trans_get_buf_map+0x141/0x300
>  xfs_ialloc_inode_init+0x130/0x2c0
>  xfs_ialloc_ag_alloc+0x226/0x710
>  xfs_dialloc+0x22d/0x980

... here by the task blocked on memory allocation.

This smells like a persistent ENOMEM/memory reclaim issue and XFS is
just the messenger...

-Dave.
-- 
Dave Chinner
dgc@kernel.org
