Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8D17A7F3F
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 05:35:04 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1C4FCAC005
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 03:35:01 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id stMP48kYFgZcz0Re (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 08 Jan 2015 03:34:59 -0800 (PST)
Date: Thu, 8 Jan 2015 12:34:54 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH 0/6] xfs: truncate vs page fault IO exclusion
Message-ID: <20150108113454.GA25807@quack.suse.cz>
References: <1420669543-8093-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1420669543-8093-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, xfs@oss.sgi.com

  Hi,

On Thu 08-01-15 09:25:37, Dave Chinner wrote:
> This patch set is an attempt to address issues with XFS
> truncate and hole-punch code from racing with page faults that enter
> the IO path. This is traditionally deadlock prone due to the
> inversion of filesystem IO path locks and the mmap_sem.
> 
> To avoid this issue, I have introduced a new "i_mmaplock" rwsem into
> the XFS code similar to the IO lock, but this lock is only taken in
> the mmap fault paths on entry into the filesystem (i.e. ->fault and
> ->page_mkwrite).
> 
> The concept is that if we invalidate the page cache over a range
> after taking both the existing i_iolock and the new i_mmaplock, we
> will have prevented any vector for repopulation of the page cache
> over the invalidated range until one of the io and mmap locks has
> been dropped. i.e. we can guarantee that both the syscall IO path
> and page faults won't race with whatever operation the filesystem is
> performing...
> 
> The introduction of a new lock is necessary to avoid deadlocks due
> to mmap_sem entanglement. It has a defined lock order during page
> faults of:
> 
> mmap_sem
> -> i_mmaplock (read)
>    -> page lock
>       -> i_ilock (get blocks)
> 
> This lock is then taken by any extent manipulation code in XFS in
> addition to the IO lock which has the lock ordering of
> 
> i_iolock (write)
> -> i_mmaplock (write)
>    -> page lock (data writeback, page invalidation)
>       -> i_lock (data writeback)
>    -> i_lock (modification transaction)
> 
> Hence we have consistent lock ordering (which has been validated so
> far by testing with lockdep enabled) for page fault IO vs
> truncate, hole punch, extent shifts, etc.
> 
> This patchset passes xfstests and various benchmarks and stress
> workloads, so the real question is now:
> 
> 	What have I missed?
> 
> Comments, thoughts, flames?
  I had a look at the patches and as far as I can tell this should work
fine (at least from the VFS / MM POV).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
