Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:37236 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405989AbeKWEix (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Nov 2018 23:38:53 -0500
Subject: [PATCH v3 00/12] xfstests: add copy/dedupe/clone to fsx/fsstress
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 22 Nov 2018 09:58:22 -0800
Message-ID: <154290950237.1218.9937108728673485814.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Hi all,

This series adds to fsx and fsstress support for FICLONERANGE,
FIDEDUPERANGE, and copy_file_range.

The first three patches fix gcc warnings in fsx and fsstress.

Patch 4 adds an -X option to fsx that causes it to re-read the fsx file
after every operation to compare it to the good buffer.  This made it
easier for me to find corruption problem as soon as they happen, though
it slows down fsx and perturbs in-core state considerably.

Patche 5-6 are a couple of generic reworks to fsx that we need to
support the new clone/dedupe/copy commands.

Patches 7-8 add clone and dedupe to fsx.

Patches 9-10 add copy_file_range support to fsstress and fsx.

Patch 11 fixes the common/dump tests to disable the new commands so that
the dump/restore tests continue to function exactly as they have for
years.

Patch 12 contains long-soak fsx tests designed to draw out corruption
problems by running (1 million * TIME_FACTOR) operations.  These will be
running all weekend during the US Thanksgiving holiday, though I hope
we've sorted out all the problems.

There are known failures in XFS on 4.20-rc3, particularly with
copy_file_range and reflink, all of which hopefully have been fixed by
the patch series that Dave Chinner posted to the xfs list yesterday.
A branch with the fstests patches can be downloaded here[1].

--D

[1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fsstress-clone
