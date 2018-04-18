Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59812 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753076AbeDRCpm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:45:42 -0400
Subject: [PATCH 0/9] xfsprogs-4.17: geometry refactoring
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:45:24 -0700
Message-ID: <152401952391.13048.15040850425873030425.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This series refactors geometry reporting in xfsprogs.  First we move the
platform support code to libfrog where it belongs.  Next we hoist the
fsgeometry generation function to libxfs, then add some libfrog
functions to print fsgeometry structures.  Next we add a command to
xfs_db to print the geometry information of the loaded filesystem.
Finally, we move online geometry reporting from growfs to spaceman and
refactor xfs_info to call spaceman or db depending on the passed in
command line argument.  This series is largely unchanged from the
previous posting for 4.16.

This probably won't eat your data, and the branch[2] should apply
against for-next.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
