Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48396 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbeKUI2G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Nov 2018 03:28:06 -0500
Subject: [PATCH v2 00/10] xfstests: add copy/dedupe/clone to fsx/fsstress
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 20 Nov 2018 13:56:41 -0800
Message-ID: <154275100143.8611.10235098565750994724.stgit@magnolia>
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

First, I fix some gcc warnings in fsx.

Then, I teach fsx to read the fsx file after every operation to compare
it to the good buffer.  This made it easier for me to find corruption
problem as soon as they happen, though I'm not sure it really makes
sense to have this enabled by default because of the behavior change
that it makes.

Next come a couple of generic reworks to fsx that we need to support the
new clone/dedupe/copy commands.

Patches 5-6 add clone and dedupe to fsx.

Patches 7-8 add copy_file_range support to fsstress and fsx.

Dave Chinner contributed some cleanups to the fsx patches as the 9th
patch.

The last patch fixes the common/dump tests to disable the new commands
so that the dump/restore tests continue to function exactly as they have
for years.

There are known failures in 4.20-rc3, particularly with copy_file_range,
which hopefully have been fixed by the patch series that Dave Chinner
posted to the xfs list yesterday.  Branch can be downloaded here[1].

--D

[1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fsstress-clone
