Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49035 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932650AbdKPBWX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2017 20:22:23 -0500
Subject: [PATCH 0/5] weekly fstests changes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 15 Nov 2017 17:22:19 -0800
Message-ID: <151079533937.25590.1037061486182471724.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Hi,

Here's another pile of fstests changes.  The first patch stabilizes the
'random' field fuzzer for xfs filesystems -- if the random value is the
same as the old value, we'll keep trying until the value changes.
Hopefully this stabilizes the fuzz test output.

The second patch tests filesystems' ability to store emoji in file and
xattr names.

The third patch prevents one of the aiodio regression tests from looping
infinitely in a read thread if the writer thread never actually writes
anything.

The fourth patch teaches fstests to scan dmesg for UBSAN reports from
the kernel.

The fifth patch teaches xfs/122 to ignore the incore extent cursor
that's new in 4.15.

--D
