Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2F59D7F8E
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 16:26:12 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BFF6DAC008
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 14:26:11 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	qFfYxo7LVy7OxmhS for <xfs@oss.sgi.com>;
	Wed, 07 Jan 2015 14:26:09 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC PATCH 0/6] xfs: truncate vs page fault IO exclusion
Date: Thu,  8 Jan 2015 09:25:37 +1100
Message-Id: <1420669543-8093-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

Hi folks,

This patch set is an attempt to address issues with XFS
truncate and hole-punch code from racing with page faults that enter
the IO path. This is traditionally deadlock prone due to the
inversion of filesystem IO path locks and the mmap_sem.

To avoid this issue, I have introduced a new "i_mmaplock" rwsem into
the XFS code similar to the IO lock, but this lock is only taken in
the mmap fault paths on entry into the filesystem (i.e. ->fault and
->page_mkwrite).

The concept is that if we invalidate the page cache over a range
after taking both the existing i_iolock and the new i_mmaplock, we
will have prevented any vector for repopulation of the page cache
over the invalidated range until one of the io and mmap locks has
been dropped. i.e. we can guarantee that both the syscall IO path
and page faults won't race with whatever operation the filesystem is
performing...

The introduction of a new lock is necessary to avoid deadlocks due
to mmap_sem entanglement. It has a defined lock order during page
faults of:

mmap_sem
-> i_mmaplock (read)
   -> page lock
      -> i_ilock (get blocks)

This lock is then taken by any extent manipulation code in XFS in
addition to the IO lock which has the lock ordering of

i_iolock (write)
-> i_mmaplock (write)
   -> page lock (data writeback, page invalidation)
      -> i_lock (data writeback)
   -> i_lock (modification transaction)

Hence we have consistent lock ordering (which has been validated so
far by testing with lockdep enabled) for page fault IO vs
truncate, hole punch, extent shifts, etc.

This patchset passes xfstests and various benchmarks and stress
workloads, so the real question is now:

	What have I missed?

Comments, thoughts, flames?

-Dave.

GI: [RFC PATCH 1/6] xfs: introduce mmap/truncate lock

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
