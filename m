Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26096 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750717AbdDHDDr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Apr 2017 23:03:47 -0400
Subject: [RFC PATCH v1 0/4] xfs_db misc. btree dumping improvements
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 07 Apr 2017 20:03:42 -0700
Message-ID: <149162062276.22901.7801103937404880951.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Here are a bunch of patches improving various aspects of btree dumping
in xfs_db.  The first few patches fix up numerous crashes that occur
when the user navigates to a btree block with an unknown magic number.
Instead of blowing up, now we can display the (corrupt) contents for
further analysis.

The last patch in this patchset adds a 'btdump' command, which dumps
whatever metadata subtree is rooted at the current iocursor location.
(For inodes it will default to the data for bmbt if there is one.)  This
makes it much easier to display all records of any btree for debugging
or forensic analysis, because the user no longer has to navigate the
btree manually.

Questions?  Comments?

--D
