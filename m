Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48320 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbeJAXnB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Oct 2018 19:43:01 -0400
Subject: [PATCH v3 0/8] xfsprogs-4.19: transaction cleanups
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 01 Oct 2018 10:04:12 -0700
Message-ID: <153841345236.27952.5050172703525712660.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Here are seven cleanups to the userspace transaction code that make the
commit and roll code more closely resemble their kernel counterparts,
and fix a number of problems where client code did not check the return
values of the transaction functions.  The eighth patch fixes a bug in
xfs_scrub_all.  The patches should apply to Eric's libxfs-4.19-sync
branch.

--D
