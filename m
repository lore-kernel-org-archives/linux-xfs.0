Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:45028 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728313AbfAHUgP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Jan 2019 15:36:15 -0500
Subject: [PATCH 0/5] xfs: general scrubber fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 08 Jan 2019 12:36:04 -0800
Message-ID: <154697976479.2839.3584921201780682011.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net

Hi all,

Here's a second series of scrubber fixes that apply elsewhere.

Patch 1 aborts the xattr scrub loop if there are pending fatal signals.

Patch 2 checks that for any directory or attr fork there are no extent
maps that stretch beyond what a xfs_dablk_t can map.

Patch 3 fixes an off-by-one error in a rtbitmap scrub helper.

Patches 4-5 implement name check functions for directory entries and
extended attribute leaves.  For now they're only used by scrub (and used
to clean up xfs_repair) but I suspect it might be more appropriate to
put them in the regular verifiers.

If you're going to start using this mess, you probably ought to just
pull from my git trees.  The kernel patches[1] should apply against
5.0-rc1.

Comments and questions are, as always, welcome.

--D
