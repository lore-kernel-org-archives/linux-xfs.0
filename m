Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:33368 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752182AbeEAPjY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 May 2018 11:39:24 -0400
Subject: [PATCH 0/9] misc. fstests changes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 01 May 2018 08:39:20 -0700
Message-ID: <152518916007.23023.4793255395982876953.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Hi all,

Here are some miscellaneous tests that have been queuing up for a while.
The first patch is a reposting of the attr replace test from a couple
weeks ago, and the second to last patch is a new test that looks for
bashisms in xfsprogs scripts.  In the middle are a bunch of enhancements
to the Unicode support test to reflect new checks that we landed in
xfs_scrub 4.16.  The rest are fixes to existing tests.

--D
