Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46257 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935123AbcJQWJw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2016 18:09:52 -0400
Subject: [PATCH 1/3] xfs: set the refcount btree cowflag when setting up cow
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 17 Oct 2016 15:09:21 -0700
Message-ID: <147674216165.23842.10926856560868098764.stgit@birch.djwong.org>
In-Reply-To: <147674215521.23842.13841682595738466897.stgit@birch.djwong.org>
References: <147674215521.23842.13841682595738466897.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, hch@infradead.org, Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org

When we're setting up a fake cow extent in the refcountbt to test
cleanup of fake cow extents, set the cowflag in the record field
to reflect our new disk format of storing the staging extents in
the right side of the tree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/307 |    1 +
 tests/xfs/308 |    1 +
 2 files changed, 2 insertions(+)


diff --git a/tests/xfs/307 b/tests/xfs/307
index 869f5cc..2a99459 100755
--- a/tests/xfs/307
+++ b/tests/xfs/307
@@ -145,6 +145,7 @@ _set_agf_data numrecs 1 -c 'addr refcntroot'
 _set_agf_data "recs[1].startblock" $debris_bno -c 'addr refcntroot'
 _set_agf_data "recs[1].blockcount" $debris_len -c 'addr refcntroot'
 _set_agf_data "recs[1].refcount" 1 -c 'addr refcntroot'
+_set_agf_data "recs[1].cowflag" 1 -c 'addr refcntroot'
 
 if [ $is_rmap -gt 0 ]; then
 	rmap_nr=$((rmap_nr + 1))
diff --git a/tests/xfs/308 b/tests/xfs/308
index 8f8f380..5bfa432 100755
--- a/tests/xfs/308
+++ b/tests/xfs/308
@@ -145,6 +145,7 @@ _set_agf_data numrecs 1 -c 'addr refcntroot'
 _set_agf_data "recs[1].startblock" $debris_bno -c 'addr refcntroot'
 _set_agf_data "recs[1].blockcount" $debris_len -c 'addr refcntroot'
 _set_agf_data "recs[1].refcount" 1 -c 'addr refcntroot'
+_set_agf_data "recs[1].cowflag" 1 -c 'addr refcntroot'
 
 if [ $is_rmap -gt 0 ]; then
 	rmap_nr=$((rmap_nr + 1))

