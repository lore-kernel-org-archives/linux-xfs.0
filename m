Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:48035 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966119AbdEOPnq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 May 2017 11:43:46 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/17] md: namespace private helper names
Date: Mon, 15 May 2017 17:43:04 +0200
Message-Id: <20170515154308.26739-14-hch@lst.de>
In-Reply-To: <20170515154308.26739-1-hch@lst.de>
References: <20170515154308.26739-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

The md private helper uuid_equal() collides with a generic helper
of the same name.

Rename the md private helper to md_uuid_equal() and do the same for
md_sb_equal().

Cc: Shaohua Li <shli@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 82f798be964f..65795cc4cb7d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -825,7 +825,7 @@ static int read_disk_sb(struct md_rdev *rdev, int size)
 	return -EINVAL;
 }
 
-static int uuid_equal(mdp_super_t *sb1, mdp_super_t *sb2)
+static int md_uuid_equal(mdp_super_t *sb1, mdp_super_t *sb2)
 {
 	return	sb1->set_uuid0 == sb2->set_uuid0 &&
 		sb1->set_uuid1 == sb2->set_uuid1 &&
@@ -833,7 +833,7 @@ static int uuid_equal(mdp_super_t *sb1, mdp_super_t *sb2)
 		sb1->set_uuid3 == sb2->set_uuid3;
 }
 
-static int sb_equal(mdp_super_t *sb1, mdp_super_t *sb2)
+static int md_sb_equal(mdp_super_t *sb1, mdp_super_t *sb2)
 {
 	int ret;
 	mdp_super_t *tmp1, *tmp2;
@@ -1025,12 +1025,12 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
 	} else {
 		__u64 ev1, ev2;
 		mdp_super_t *refsb = page_address(refdev->sb_page);
-		if (!uuid_equal(refsb, sb)) {
+		if (!md_uuid_equal(refsb, sb)) {
 			pr_warn("md: %s has different UUID to %s\n",
 				b, bdevname(refdev->bdev,b2));
 			goto abort;
 		}
-		if (!sb_equal(refsb, sb)) {
+		if (!md_sb_equal(refsb, sb)) {
 			pr_warn("md: %s has same UUID but different superblock to %s\n",
 				b, bdevname(refdev->bdev, b2));
 			goto abort;
-- 
2.11.0

