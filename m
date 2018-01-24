Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:46234 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751897AbeAXCSA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jan 2018 21:18:00 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0O27ZSS066447
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 02:17:59 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2fpgyjg1ga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 02:17:59 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0O2HxPd000725
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 02:17:59 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0O2Hw5E020353
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 02:17:58 GMT
Subject: [PATCH 00/11] xfs: reflink/scrub/quota fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 23 Jan 2018 18:17:57 -0800
Message-ID: <151676027743.12349.3845769501491774512.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This is a rollup of all the patches I've sent in the past 9 days or so.
If all goes well I hope to land this during the 4.16 merge.

Running generic/232 with quotas and reflink demonstrated that there was
something wrong with the way we did quota accounting -- on an otherwise
idle system, fs-wide du block count numbers didn't match the quota
reports.  I started digging into why the quota accounting was wrong, and
the following are the results of my bug hunt.

The first patch teaches the reflink code to break layout leases before
commencing the block remapping work.  This time we avoid the "looping
trying to get a lock" that Christoph complained about, in favor of
dropping both locks and retrying if we can't cleanly break the layouts
without waiting.

The second patch changes the source file locking (if src != dest) during
a reflink operation to take the shared locks when possible.  The only
thing changing in the source file is the setting of the reflink iflag,
for which we will still take ILOCK_EXCL.  The net result of this is
less lock contention during fsstress and a 30% lower runtime, not that
anyone cares about fsstress benchmarking. :)

Patch three ensure that we attach dquots to inodes before we start
reflinking their blocks.  This could lead to quota undercharging; an
fstest to check this will be sent separately.

Patch four reorganizes the copy on write quota updating code to reflect
how the CoW fork works now.  In short, the CoW fork is entirely in
memory, so we can only use the in-memory quota reservation counters for
all CoW blocks; the accounting only becomes permanent if we remap an
extent into the data fork.

Patch five creates a separate i_cow_blocks counter to track all the CoW
blocks assigned to a file, which makes changing a file's uid/gid/prjid
easier, makes reporting cow blocks via stat easy, and enables various
cleanups.

Patch six fixes a serious potential corruption problem with the cow
extent allocation -- when we allocate into the CoW fork with the cow
extent size hint set, the allocator enlarges the allocation request to
try to hit alignment goals.  However, if the allocated extent does not
actually fulfill any of the requested range, we send a garbage
zero-length extent back to the iomap code (which also doesn't notice),
and the write lands at the startblock of the garbage extent.  The fix is
to detect that we didn't fill the entire requested range and fix up the
returned mapping so that we always fill the first block of the
requested allocation.

The seventh patch fixes a minor problem where we fail to clear di_flags2
when we're freeing an inode.

The eighth and ninth patches fix inconsistent and incorrect print format
specifer usage in the tracepoints.  In tracepoint land, %p is sufficient
to print a pointer as 0x12345678, so just do that.  %pS and %pF (printk
training wheels) are wrong here.  Also fix inode numbers to always use
0x%llx (we've been lax about printing them as numbers).

The tenth patch creates an xfs_inode_verifier_error helper so that we
can complain about inode corruption problems in a standard way but leave
the format string details to the kernel/xfsprogs.  We really can't have
%pS and other stuff escaping to userspace.

The eleventh patch fixes a NULL pointer deref because we incorrectly
freed the inode btree cursor if there's an error while counting the
blocks in the inode btree for rmapbt cross-referencing.

Anyway, with this set applied I think we're ready to remove the reflink
EXPERIMENTAL tag during the 4.16 cycle.

--D
