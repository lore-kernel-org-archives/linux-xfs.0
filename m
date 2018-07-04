Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48744 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750928AbeGDEu3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Jul 2018 00:50:29 -0400
Subject: [PATCH 0/2] fstests: fixes and new tests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 03 Jul 2018 21:50:24 -0700
Message-ID: <153067982461.28315.11621030236927888645.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Hi all,

The first patch provides a regression test for a condition where mmap
read of a file's EOF page shows nonzero bytes after EOF if the
previous operation was a zero_range all the way to EOF.  This bug only
seems to manifest on XFS, but it uses generic APIs and so is a generic
test.  The patch concerned here is "xfs: ensure post-EOF zeroing happens
after zeroing part of a file".

The second patch adds a variant to the xfs fuzz tests where we fuzz the
metadata fields and immediately try to write to the filesystem.

--D
