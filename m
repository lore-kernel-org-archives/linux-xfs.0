Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:46272 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751441AbeAZCRc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jan 2018 21:17:32 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0Q2HQav151225
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2018 02:17:31 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2fqu8f01cw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2018 02:17:26 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0Q24n0g014039
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2018 02:04:49 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0Q24nY4025474
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2018 02:04:49 GMT
Subject: [PATCH v2 0/6] xfs: reflink/scrub/quota fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Jan 2018 18:04:48 -0800
Message-ID: <151693228803.7395.12526880865470882359.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This is a rollup of all the remaining patches I've sent in the past 9
days or so.  If all goes well I hope to land this during the 4.16 merge.

Running generic/232 with quotas and reflink demonstrated that there was
something wrong with the way we did quota accounting -- on an otherwise
idle system, fs-wide du block count numbers didn't match the quota
reports.  I started digging into why the quota accounting was wrong, and
the following are the results of my bug hunt.

Patches 1-2 reorganize the copy on write quota updating code to reflect
how the CoW fork works now.  In short, the CoW fork is entirely in
memory, so we can only use the in-memory quota reservation counters for
all CoW blocks; the accounting only becomes permanent if we remap an
extent into the data fork.

Patch 3 creates a separate i_cow_blocks counter to track all the CoW
blocks assigned to a file, which makes changing a file's uid/gid/prjid
easier, makes reporting cow blocks via stat easy, and enables various
cleanups.

Patch 4 fixes a serious corruption problem with the cow extent
allocation -- when we allocate into the CoW fork with the cow extent
size hint set, the allocator enlarges the allocation request to try to
hit alignment goals.  However, if the allocated extent does not actually
fulfill any of the requested range, we send a garbage zero-length extent
back to the iomap code (which also doesn't notice), and the write lands
at the startblock of the garbage extent.  The fix is to detect that we
didn't fill the entire requested range and fix up the returned mapping
so that we always fill the first block of the requested allocation and
for CoW to check the validity returned mappings before blowing things
up.  This also fixes a problem where a direct io overwrite can return
ENOSPC to userspace because of the same fragmentation problem.

The 5th patch fixes a hard to reproduce race between truncate and
buffered CoW writeback.  Writeback doesn't seem to take i_rwsem (aka the
iolock) when it's gathering io requests, so it races with a
truncate-down, which starts by reducing i_size before moving on to
removing the pages from the page cache.  If the writeback was to a
shared block and we "win" the race, we'll return the CoW mapping but
it'll be deemed invalid because it's beyond EOF.  We then blow an assert
when we try to go to the data fork for a valid mapping (because we
should never do that!) though even any data fork mapping will also be
invalidated and we ultimately don't write anything.

The 6th patch fixes a NULL pointer deref because we incorrectly
freed the inode btree cursor if there's an error while counting the
blocks in the inode btree for rmapbt cross-referencing.

Anyway, with this set applied I think we're ready to remove the reflink
EXPERIMENTAL tag during the 4.16 cycle.

--D
