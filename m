Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47027 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752335AbdFPPkm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Jun 2017 11:40:42 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v5GFefQs030883
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jun 2017 15:40:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v5GFef0N013111
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jun 2017 15:40:41 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v5GFee9f024619
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jun 2017 15:40:40 GMT
Date: Fri, 16 Jun 2017 08:40:39 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] docs: add missing sb_qflags values
Message-ID: <20170616154039.GC5421@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

We're missing a few of the sb_qflags values, so add them to the docs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../allocation_groups.asciidoc                     |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
index 68f934a..992615d 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -282,6 +282,10 @@ Quota flags. It can be a combination of the following flags:
 | +XFS_OQUOTA_ENFD+		| Other (group/project) quotas are enforced.
 | +XFS_OQUOTA_CHKD+		| Other (group/project) quotas have been checked.
 | +XFS_GQUOTA_ACCT+		| Group quota accounting is enabled.
+| +XFS_GQUOTA_ENFD+		| Group quotas are enforced.
+| +XFS_GQUOTA_CHKD+		| Group quotas have been checked.
+| +XFS_PQUOTA_ENFD+		| Project quotas are enforced.
+| +XFS_PQUOTA_CHKD+		| Project quotas have been checked.
 |=====
 
 *sb_flags*::
