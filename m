Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:46800 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751748AbeFEQmy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 12:42:54 -0400
Subject: [PATCH 0/6] fstests: fixes and new tests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 05 Jun 2018 09:42:50 -0700
Message-ID: <152821697018.24976.12939094615403004592.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Hi all,

The first three patches in this series fix some fstests regressions that
I've observed over the last couple of weeks.

After that are new swapfile tests that check the swapfile activation
code on various weird twists on swapfile format.

The final two tests parameterize xfs_info calls like any other helper
program and make sure that in xfsprogs 4.17, fs geometry printing is
consistent across the xfs utilities.

--D
