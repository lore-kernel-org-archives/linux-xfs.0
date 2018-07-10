Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:60242 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933796AbeGJQGJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Jul 2018 12:06:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6AG4hS9153496
        for <linux-xfs@vger.kernel.org>; Tue, 10 Jul 2018 16:06:08 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2k2p762nyt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 10 Jul 2018 16:06:08 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w6AG67QB017155
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 10 Jul 2018 16:06:07 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w6AG67h1025332
        for <linux-xfs@vger.kernel.org>; Tue, 10 Jul 2018 16:06:07 GMT
Date: Tue, 10 Jul 2018 09:06:06 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-documentation: master updated to af93ba0
Message-ID: <20180710160606.GZ32415@magnolia>
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

d19d47c design: merge both metadata integrity chapters

New Commits:

Darrick J. Wong (4):
      [947b5d7] design: rename disk structures book
      [1a7aece] design: incorporate the delayed logging design doc
      [0d75e28] design: incorporate self-describing metadata design doc
      [d19d47c] design: merge both metadata integrity chapters


Code Diffstat:

 .../delayed_logging.asciidoc}                      |  4 +--
 design/XFS_Filesystem_Structure/docinfo.xml        | 15 +++++++++
 .../metadata_integrity.asciidoc                    | 36 ----------------------
 .../self_describing_metadata.asciidoc}             | 29 +++++++++++++++--
 .../xfs_filesystem_structure.asciidoc              |  8 +++--
 5 files changed, 47 insertions(+), 45 deletions(-)
 rename design/{xfs-delayed-logging-design.asciidoc => XFS_Filesystem_Structure/delayed_logging.asciidoc} (99%)
 delete mode 100644 design/XFS_Filesystem_Structure/metadata_integrity.asciidoc
 rename design/{xfs-self-describing-metadata.asciidoc => XFS_Filesystem_Structure/self_describing_metadata.asciidoc} (91%)
