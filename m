Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34644 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750745AbdLMGDS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 01:03:18 -0500
Subject: [PATCH 0/8] weekly fstests changes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 12 Dec 2017 22:03:10 -0800
Message-ID: <151314499003.18893.8687182548758898133.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Hi all,

Here's the usual weekly pile of fstests changes. :)

We start with the same patch as last time that scans kmemleak for leaks
after each test.

Then we move on to a fix in the scrub probe code because upstream
xfsprogs changed xfs_io syntax again.

Third is a patch that adds Unicode linedraw character tests to the two
tests that check that we can store arbitrary byte patterns without
screwing things up.

The fourth patch amends various xfs tests to deal with our slow removal
of zero-alloc transactions, which is causing unexpected fs shutdowns
when free space nears zero.

The fifth patch adds a new test to invoke dm-error on a fsstress run;
this test simulates (for the filesystem) an internal "yank all the disk
cables out" test.

The sixth patch adds FICLONERANGE/FIDEDUPERANGE support to fsstress.
This was helpful in finding a bunch of unhandled corner cases in the xfs
reflink implementation.

Patch seven test write-only fsstress to maximize testing of write paths
where coding mistakes cannot be backed out of so easily.

The final patch in the series fixes the dir/file counts that are
hardcoded in the xfs/068 golden output, since with fsstress doing
reflink now we might get a lot more "files" than we used to.

--D
