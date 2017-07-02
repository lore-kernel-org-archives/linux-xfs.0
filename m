Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19960 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750740AbdGBEtG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Jul 2017 00:49:06 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v624n3nS011779
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 2 Jul 2017 04:49:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v624n3wV018027
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 2 Jul 2017 04:49:03 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v624n3AA030247
        for <linux-xfs@vger.kernel.org>; Sun, 2 Jul 2017 04:49:03 GMT
Date: Sat, 1 Jul 2017 21:49:02 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-documentation: master updated to 6f91654
Message-ID: <20170702044902.GY5874@birch.djwong.org>
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

6f91654 docs: add missing sb_qflags values

New Commits:

Darrick J. Wong (4):
      [b304a94] docs: clarify what the ATTRBIT and ATTR2BIT feature flags do
      [fb7cbd8] docs: record the metadump file format
      [ef2375a] docs: fix mailing list
      [6f91654] docs: add missing sb_qflags values


Code Diffstat:

 .../allocation_groups.asciidoc                     | 21 ++++++--
 design/XFS_Filesystem_Structure/docinfo.xml        | 14 +++++
 design/XFS_Filesystem_Structure/magic.asciidoc     |  1 +
 design/XFS_Filesystem_Structure/metadump.asciidoc  | 62 ++++++++++++++++++++++
 .../xfs_filesystem_structure.asciidoc              | 11 +++-
 5 files changed, 103 insertions(+), 6 deletions(-)
 create mode 100644 design/XFS_Filesystem_Structure/metadump.asciidoc
