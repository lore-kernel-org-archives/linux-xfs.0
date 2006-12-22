Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Dec 2006 16:32:43 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kBM0Waqw004958
	for <xfs@oss.sgi.com>; Thu, 21 Dec 2006 16:32:38 -0800
Date: Fri, 22 Dec 2006 11:31:40 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: xfs_start_page_writeback should use clear_page_dirty_for_io
Message-ID: <20061222003140.GN33919298@melbourne.sgi.com>
References: <20061221235146.GM33919298@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061221235146.GM33919298@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev@sgi.com, xfs@oss.sgi.com

On Fri, Dec 22, 2006 at 10:51:46AM +1100, David Chinner wrote:
> As has been discuss on LKML w.r.t to an ext3 corruption bug
> (http://lkml.org/lkml/2006/12/16/164), we should not use clear_page_dirty()
> as it can result in inconsistent state within the VM and is likely
> to go away very soon. Instead, we should be using clear_page_dirty_for_io()
> which does the right thing. Some references:
> 
> http://lkml.org/lkml/2006/12/20/204
> http://lkml.org/lkml/2006/12/20/295
> http://lkml.org/lkml/2006/12/20/310
> http://lkml.org/lkml/2006/12/20/362
> 
> Linus's patch fixes the corruption seen on ARM, so is likely to be merged
> (potentially as a stable 2.6.19.x fix).

FYI, Linus has already commited his patches and this patch to his git tree.

http://kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=fba2591bf4e418b6c3f9f8794c9dd8fe40ae7bd9
http://kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=921320210bd2ec4f17053d283355b73048ac0e56

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
