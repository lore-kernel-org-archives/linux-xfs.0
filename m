Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828842DFA4A
	for <linux-xfs@vger.kernel.org>; Sun,  5 Apr 2026 22:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775428196; cv=none; b=fK+FCsAYmlZgKSCpAZVzyeIeMpVLTKsOQQFyWyI0IKH0ZHMreBlKXt1nuRbI+/N1kQUU76WtJ3P78PZjBlWbkH5iag9RvrItBIKeEsa/tOXqTkSrfMFl5idOH7ZwbFMk1a7cmC8K/ZOSiBdH9xXEO81qtJ2EPvzKxPHmmIemLQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775428196; c=relaxed/simple;
	bh=CKJtNDsNRIXX7ozYES2N00LHxy7Jqr/l6VggPef3dds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r3zy/C94KnCS6xXowGScYTnNZt0Y6TeK9Yyq401netLGb2h/YdM/rJ1SMBKHz4HqRzp8WBl6xVZo8LgQ91ugeCRL8MPcBEf/a7pjA1itHtJbzFIJVafw4/khFn0XMlqVc7L+8MU6hbFhZBfckuP4pJ94TBDFw8e0qFdRVgTVfSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VRjVgFqx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VRjVgFqx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1805C116C6;
	Sun,  5 Apr 2026 22:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775428196;
	bh=CKJtNDsNRIXX7ozYES2N00LHxy7Jqr/l6VggPef3dds=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VRjVgFqxkRQJRHVWMHif8rAusbOYA4FuL7h6E2pMjcas7bteAG6yzGqEdXfuCRgLK
	 fze6SOpP9W7Gg9iUXLg0X+vXqSQeqEyiSCGEWfzfAmISYg9Pos0Ga0cWEvq8N1uIZk
	 OKLqjVECAfTACAlTARbkLcBUTF9Ex5jvPVZU3yGQ4BFVA4TiBJeZZtBCLgmTalPSqe
	 XM1gkp6fOkZUDSSkoP0uGdgezc9p7wWuexMbI+qJxY/838nTbK5+7cmGsLs6f8EmMH
	 LqQpFHqQP218MmNDZSxOrvItHTqYhz0/jky9mq0G0BJEDLsWnP8YIMlh8G6wMnvJzD
	 ZKYE+CVMwpfDg==
Date: Mon, 6 Apr 2026 08:29:51 +1000
From: Dave Chinner <dgc@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Hang with xfs/285 on 2026-03-02 kernel
Message-ID: <adLiXxkpvfFhLoYh@dread>
References: <ac_eUsuxqf6IYN7F@casper.infradead.org>
 <adDgYCmgNsA9ff3e@dread>
 <adF3RXLIzlp8SwZO@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adF3RXLIzlp8SwZO@casper.infradead.org>

On Sat, Apr 04, 2026 at 09:40:37PM +0100, Matthew Wilcox wrote:
> On Sat, Apr 04, 2026 at 10:42:59PM +1100, Dave Chinner wrote:
> > On Fri, Apr 03, 2026 at 04:35:46PM +0100, Matthew Wilcox wrote:
> > > This is with commit 5619b098e2fb so after 7.0-rc6
> > > INFO: task fsstress:3762792 blocked on a semaphore likely last held by task fsstress:3762793
> > > task:fsstress        state:D stack:0     pid:3762793 tgid:3762793 ppid:3762783 task_flags:0x440140 flags:0x00080800
> > > Call Trace:
> > >  <TASK>
> > >  __schedule+0x560/0xfc0
> > >  schedule+0x3e/0x140
> > >  schedule_timeout+0x84/0x110
> > >  ? __pfx_process_timeout+0x10/0x10
> > >  io_schedule_timeout+0x5b/0x80
> > >  xfs_buf_alloc+0x793/0x7d0
> > 
> > -ENOMEM.
> > 
> > It'll be looping here:
> > 
> > fallback:
> >         for (;;) {
> >                 bp->b_addr = __vmalloc(size, gfp_mask);
> >                 if (bp->b_addr)
> >                         break;
> >                 if (flags & XBF_READ_AHEAD)
> >                         return -ENOMEM;
> >                 XFS_STATS_INC(bp->b_mount, xb_page_retries);
> >                 memalloc_retry_wait(gfp_mask);
> >         }
> > 
> > If it is looping here long enough to trigger the hang check timer,
> > then the MM subsystem is not making progress reclaiming memory. This
> > is probably a 16kB allocation (it's an inode cluster buffer), and
> > the allocation context is NOFAIL because it is within a transaction
> > (this loop pre-dates __vmalloc() supporting __GFP_NOFAIL)....
> 
> There may be something else going on.  I reproduced it again and ssh'd
> into the VM.
> 
> # free
>                total        used        free      shared  buff/cache   available
> Mem:         3988260     1197132      240080         144     3147496     2791128
> Swap:        2097148      258128     1839020
> 
> There are five instances of fsstress running.  Very slowly, but they are
> accumulating seconds of CPU time:
> 
> root@deadly-kvm:~# ps -aux |grep fsstress
> root     3745227  0.0  0.0   2664  1476 ?        S    06:48   0:00 ./ltp/fsstress -p 4 -d /mnt/scratch -n 2000000
> root     3745236  7.5  1.6 127928 65256 ?        D    06:48  42:54 ./ltp/fsstress -p 4 -d /mnt/scratch -n 2000000
> root     3745237  7.6  1.5 124644 61308 ?        D    06:48  42:55 ./ltp/fsstress -p 4 -d /mnt/scratch -n 2000000
> root     3745238  7.6  1.6 130844 65584 ?        D    06:48  43:01 ./ltp/fsstress -p 4 -d /mnt/scratch -n 2000000
> root     3745239  7.6  1.6 126524 66536 ?        D    06:48  42:58 ./ltp/fsstress -p 4 -d /mnt/scratch -n 2000000
> root@deadly-kvm:~# ps -aux |grep fsstress
> root     3745227  0.0  0.0   2664  1476 ?        S    06:48   0:00 ./ltp/fsstress -p 4 -d /mnt/scratch -n 2000000
> root     3745236  5.5  1.6 133116 66708 ?        R    06:48  45:44 ./ltp/fsstress -p 4 -d /mnt/scratch -n 2000000
> root     3745237  5.5  1.5 130136 62516 ?        R    06:48  45:45 ./ltp/fsstress -p 4 -d /mnt/scratch -n 2000000
> root     3745238  5.5  1.6 136520 65944 ?        R    06:48  45:52 ./ltp/fsstress -p 4 -d /mnt/scratch -n 2000000
> root     3745239  5.5  1.7 131988 67884 ?        R    06:48  45:50 ./ltp/fsstress -p 4 -d /mnt/scratch -n 2000000
> 
> # cat /proc/3745239/stack
> [<0>] xfs_buf_lock+0x4b/0x170
> [<0>] xfs_buf_find_lock+0x69/0x140
> [<0>] xfs_buf_get_map+0x265/0xbd0
> [<0>] xfs_buf_read_map+0x59/0x2e0
> [<0>] xfs_trans_read_buf_map+0x1bb/0x560
> [<0>] xfs_read_agi+0xab/0x1a0
> (...)

It would be helpful to quote the full stack traces...

> # cat /proc/3745238/stack
> [<0>] xfs_buf_alloc+0x793/0x7d0
> [<0>] xfs_buf_get_map+0x651/0xbd0
> [<0>] xfs_buf_readahead_map+0x3b/0x1b0
> [<0>] xfs_iwalk_ichunk_ra+0xe9/0x130
> [<0>] xfs_iwalk_ag+0x185/0x2d0
> (...)

However, how is memory allocation stuck here? That's the readahead
path, which triggers an early exit from the __vmalloc() fallback
loop.  i.e. xfs_buf_alloc() does not loop forever on readahead - it
tries once and then exits.

Yes, this bulkstat path is holding the AGI buffer locked, and the
previous thread is waiting on the AGI buffer lock, but that doesn't
mean the system is deadlocked - it's just lockstepping on the AGI
buffer lock due to the long hold in the bulkstat path....

i.e. these traces do not indicate that there is any sort of memory
allocation problem in the system, just bulkstat slowing down other
operations...

-Dave.
-- 
Dave Chinner
dgc@kernel.org
