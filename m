Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:46504 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753725AbeFUSbH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jun 2018 14:31:07 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5LITQ4M014268
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jun 2018 18:31:06 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2jmtgx35gf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jun 2018 18:31:06 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w5LIV59N024657
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jun 2018 18:31:06 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w5LIV5aV030688
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jun 2018 18:31:05 GMT
Subject: [PATCH 0/8] xfs-4.18: various fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 21 Jun 2018 11:31:04 -0700
Message-ID: <152960586416.26246.8634761888260524091.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Here's a series of patches to fix some problems I noticed in 4.18.

The first patch fixes a problem where we WARN_ON if someone tries to
create an empty transaction while the fs is frozen.  Since these
transactions can't modify anything, it seems unnecessary to warn about
them.

The second patch fixes per-ag rmapbt reservation accounting problems.
The on-disk fdblocks counter is not decremented for rmapbt blocks, so
the incore reservation should always decrement the incore fdblocks by
the entire reservation regardless of rmapbt use.  This fixes the problem
where b_avail as reported by statfs changes across an unmount/mount
cycle if the rmapbt had grown prior to the unmount, even though the
number of blocks in use has not changed at all.

The third patch fixes the userspace-configurable default reserved
blocks calculation when there are fewer fdblocks than what we set aside
to avoid deadlocks.

The fourth patch fixes a problem Zorro Lang found where on a 512b
block filesystem we can cause an extent at s_maxbytes to be right
shifted to the point that it block offset exceeds the field size of 54
bytes.  generic/485 is the regression test.

The fifth patch fixes a hard to trigger TOCTOU bug in generic/166 where
we take ILOCK_SHARED in preparation for a directio write but by the time
we get the lock a second thread has set the reflink flag on the file and
shared the extent we're trying to write but we proceed into the COW
allocation paths without the required ILOCK_EXCL.

The sixth patch fixes an uninitialized field in the rtbitmap fsmap code.

The seventh pach fixes an off-by-one error in the rtbitmap range query
function (which fortunately only affects the rtbitmap fsmap results).

The eighth patch fixes a bug reported by fsx in generic/127 wherein if
we write a file to a non-page-aligned length, mmap read the EOF page,
truncate the file to a smaller non-page-aligned length, run zero_range
out to EOF, and then mmap read the EOF page a second time, we briefly
see non-zero bytes after EOF.

Comments and questions are, as always, welcome.

--D
