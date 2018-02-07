Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39224 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932196AbeBGVTX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Feb 2018 16:19:23 -0500
Subject: [PATCH 0/4] misc. fstests changes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 07 Feb 2018 13:19:18 -0800
Message-ID: <151803835881.19313.17455678207236452557.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Hi all,

Here's a pile of tests to go with some of the stuff merged in 4.1[56].  We
start by removing the -y parameter from xfs_scrub since it will be removed in
the final xfsprogs 4.15 release.  Then we remove the automatic xfs_check run
from xfstests (individual tests can still request one) since it's been long
obsolete.  Next are three regression tests to check xfs' handling of xfs
quotas and free space fragmentation problems that were fixed in 4.16.
Finally, we update xfs/348 to reflect improved metadata verification of
corrupt symlinks.

--D
