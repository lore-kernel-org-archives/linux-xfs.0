Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:42630 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfHABnF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jul 2019 21:43:05 -0400
Subject: [PATCH 2/5] xfs/122: mask wonky ioctls
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 31 Jul 2019 18:42:47 -0700
Message-ID: <156462376770.2945299.14876549345616514182.stgit@magnolia>
In-Reply-To: <156462375516.2945299.16564635037236083118.stgit@magnolia>
References: <156462375516.2945299.16564635037236083118.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, fstests@vger.kernel.org

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
