Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:33238 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751336AbeAYXsu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jan 2018 18:48:50 -0500
Subject: [PATCH 0/2] xfsprogs: 4.15 rollup pt. 3
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Jan 2018 15:48:45 -0800
Message-ID: <151692412532.32390.5360363880930671862.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Here are two more patches (outside of the xfs_scrub series) to enhance
xfs_db.  The first patch adds a command to print the current transaction
reservation sizes so that we can more easily debug minimum log size
problems.  The second patch changes xfs_db's interpretation of the t_sec
field in inodes to be signed, since the kernel will feed us signed int32
values -- otherwise, you utimensat() a file with a date of 1 Jan 1950
and xfs_db displays that as April 2086.

--D
