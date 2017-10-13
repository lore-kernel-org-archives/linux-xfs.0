Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20111 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751441AbdJMQzP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Oct 2017 12:55:15 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9DGtDnL011903
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 13 Oct 2017 16:55:14 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9DGtDXl025701
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 13 Oct 2017 16:55:13 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9DGtCsC004088
        for <linux-xfs@vger.kernel.org>; Fri, 13 Oct 2017 16:55:12 GMT
Date: Fri, 13 Oct 2017 09:55:08 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-documentation: updated to b6b0dbd
Message-ID: <20171013165508.GR7122@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

Hi folks,

The master branch of the xfs-documentation repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-documentation.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the master branch is commit:

b6b0dbd xfs: move dir-attr btree sections to a separate chapter

New Commits:

Darrick J. Wong (1):
      [b6b0dbd] xfs: move dir-attr btree sections to a separate chapter


Code Diffstat:

 design/XFS_Filesystem_Structure/btrees.asciidoc    |   2 +-
 design/XFS_Filesystem_Structure/dabtrees.asciidoc  | 219 +++++++++++++++++++++
 .../XFS_Filesystem_Structure/directories.asciidoc  | 157 +--------------
 .../xfs_filesystem_structure.asciidoc              |   2 +
 4 files changed, 223 insertions(+), 157 deletions(-)
 create mode 100644 design/XFS_Filesystem_Structure/dabtrees.asciidoc
