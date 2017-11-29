Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26474 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752453AbdK2Bsx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Nov 2017 20:48:53 -0500
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAT1mqpl001083
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 01:48:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vAT1mqYu032313
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 01:48:52 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vAT1mpxQ025458
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 01:48:52 GMT
Date: Tue, 28 Nov 2017 17:48:44 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfsdocs: clarify log item header structure
Message-ID: <20171129014844.GE21412@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Make it more explicit that each log item has to start with a type code
and size, except for transaction headers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../journaling_log.asciidoc                        |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/design/XFS_Filesystem_Structure/journaling_log.asciidoc b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
index 0aec036..6109458 100644
--- a/design/XFS_Filesystem_Structure/journaling_log.asciidoc
+++ b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
@@ -217,6 +217,18 @@ magic number to distinguish themselves.  Buffer data items only appear after
 | +XFS_LI_BUD+			| 0x1245        | xref:BUD_Log_Item[File Block Mapping Update Done]
 |=====
 
+Note that all log items (except for transaction headers) MUST start with
+the following header structure.  The type and size fields are baked into
+each log item header, but there is not a separately defined header.
+
+[source, c]
+----
+struct xfs_log_item {
+     __uint16_t                magic;
+     __uint16_t                size;
+};
+----
+
 [[Log_Transaction_Headers]]
 === Transaction Headers
 
