Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49630 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfDPATg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Apr 2019 20:19:36 -0400
Subject: [PATCH v3 0/5] xfs: scrub/repair update health tracking
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 15 Apr 2019 17:19:31 -0700
Message-ID: <155537397092.27935.16073573221774618735.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

Hi all,

This series enhances the online scrub and repair code to report their
findings to the health tracking subsystem.  For now, only scrub gets to
record corruption problems, though in principle a metadata read
encountering corruption could also set a sick flag.

Online repair will clear the appropriate sick flags when metadata passes
its inspection after a repair attempt.

The first three patches rework the scrub context management code to
remove some clunkiness when we decide that we have to start the scrub
over.

Patch #4 actually teaches scrub to update the health subsystem.

Patch #5 teaches scrub to skip cross-referencing with known corrupt metadata.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-health-tracking
