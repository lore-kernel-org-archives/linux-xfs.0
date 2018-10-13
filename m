Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:60568 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbeJMHkc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 13 Oct 2018 03:40:32 -0400
Subject: [PATCH v4 00/25] fs: fixes for serious clone/dedupe problems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 12 Oct 2018 17:05:29 -0700
Message-ID: <153938912912.8361.13446310416406388958.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Hi all,

Dave, Eric, and I have been chasing a stale data exposure bug in the XFS
reflink implementation, and tracked it down to reflink forgetting to do
some of the file-extending activities that must happen for regular
writes.

We then started auditing the clone, dedupe, and copyfile code and
realized that from a file contents perspective, clonerange isn't any
different from a regular file write.  Unfortunately, we also noticed
that *unlike* a regular write, clonerange skips a ton of overflow
checks, such as validating the ranges against s_maxbytes, MAX_NON_LFS,
and RLIMIT_FSIZE.  We also observed that cloning into a file did not
strip security privileges (suid, capabilities) like a regular write
would.  I also noticed that xfs and ocfs2 need to dump the page cache
before remapping blocks, not after.

In fixing the range checking problems I also realized that both dedupe
and copyfile tell userspace how much of the requested operation was
acted upon.  Since the range validation can shorten a clone request (or
we can ENOSPC midway through), we might as well plumb the short
operation reporting back through the VFS indirection code to userspace.

So, here's the whole giant pile of patches[1] that fix all the problems.
This branch is against current upstream (4.19-rc7+).  The patch
"generic: test reflink side effects" recently sent to fstests exercises
the fixes in this series.  Tests are in [2].

--D

[1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel
[2] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/log/?h=djwong-devel
