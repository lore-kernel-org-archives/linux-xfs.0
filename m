Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:53562 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfGXENb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jul 2019 00:13:31 -0400
Subject: [PATCH 2/4] xfs/122: mask wonky ioctls
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 23 Jul 2019 21:13:26 -0700
Message-ID: <156394160665.1850833.14349327556274532970.stgit@magnolia>
In-Reply-To: <156394159426.1850833.16316913520596851191.stgit@magnolia>
References: <156394159426.1850833.16316913520596851191.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't check the structure size of the inogrp/bstat/fsop_bulkreq
structures because they're incorrectly padded.  When we remove the
old typdefs the old filter stops working.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/122 |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/tests/xfs/122 b/tests/xfs/122
index 89a39a23..64b63cb1 100755
--- a/tests/xfs/122
+++ b/tests/xfs/122
@@ -148,12 +148,15 @@ xfs_growfs_data_t
 xfs_growfs_rt_t
 xfs_bstime_t
 xfs_bstat_t
+struct xfs_bstat
 xfs_fsop_bulkreq_t
+struct xfs_fsop_bulkreq
 xfs_icsb_cnts_t
 xfs_icdinode_t
 xfs_ictimestamp_t
 xfs_inobt_rec_incore_t
 xfs_inogrp_t
+struct xfs_inogrp
 xfs_fid2_t
 xfs_fsop_handlereq_t
 xfs_fsop_setdm_handlereq_t
