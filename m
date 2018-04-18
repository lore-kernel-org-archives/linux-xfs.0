Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:46762 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753076AbeDRCqu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:46:50 -0400
Subject: [PATCH 00/11] xfsprogs-4.17: xfs_repair fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:46:29 -0700
Message-ID: <152401958920.13319.10756339531174871801.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This series is a result of me triaging the fuzz xfstests looking for
places where xfs_repair crashed, failed to detect corruption, or didn't
fix problems correctly.  For the most part this means that we check
metadata that we previously missed, and we're more careful not to update
in-core state until we actually validate entire records.  A few ASSERTs
are also removed in favor of handling in-core state properly.

This probably won't eat your data, and the branch[2] should apply
against for-next.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
