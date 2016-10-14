Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39932 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752372AbcJNSM4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Oct 2016 14:12:56 -0400
Subject: [PATCH 0/3] xfstests: fix tests for rmap/reflink
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 14 Oct 2016 11:12:49 -0700
Message-ID: <147646876990.19627.5046740854955682441.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Hi all,

Here are some cleanups[1] for the rmap/reflink tests to reflect recent
API changes (the readdition of the unshare fallocate flag and the
removal of the reflink inode flag), a last-minute disk format change
for the XFS reflink implementation, and some cleanups that were left
out of the previous patch submission.

--D

[1] https://github.com/djwong/xfstests/tree/djwong-devel
