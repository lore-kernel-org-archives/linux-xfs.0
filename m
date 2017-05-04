Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34462 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753283AbdEDN01 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 May 2017 09:26:27 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 5/8] md: namespace private helper names
Date: Thu,  4 May 2017 16:26:20 +0300
Message-Id: <1493904383-2187-6-git-send-email-amir73il@gmail.com>
In-Reply-To: <1493904383-2187-1-git-send-email-amir73il@gmail.com>
References: <1493904383-2187-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Miklos Szeredi <miklos@szeredi.hu>, Theodore Tso <tytso@mit.edu>, Richard Weinberger <richard@nod.at>, Mark Fasheh <mfasheh@versity.com>, Dan Williams <dan.j.williams@intel.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

The md private helper uuid_equal() collides with a generic helper
of the same name.

Rename the md private helper to md_uuid_equal() and do the same for
md_sb_equal().

Cc: Shaohua Li <shli@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 drivers/md/md.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 548d1b8..e3a5163 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -821,7 +821,7 @@ static int read_disk_sb(struct md_rdev *rdev, int size)
 	return -EINVAL;
 }
 
-static int uuid_equal(mdp_super_t *sb1, mdp_super_t *sb2)
+static int md_uuid_equal(mdp_super_t *sb1, mdp_super_t *sb2)
 {
 	return	sb1->set_uuid0 == sb2->set_uuid0 &&
 		sb1->set_uuid1 == sb2->set_uuid1 &&
@@ -829,7 +829,7 @@ static int uuid_equal(mdp_super_t *sb1, mdp_super_t *sb2)
 		sb1->set_uuid3 == sb2->set_uuid3;
 }
 
-static int sb_equal(mdp_super_t *sb1, mdp_super_t *sb2)
+static int md_sb_equal(mdp_super_t *sb1, mdp_super_t *sb2)
 {
 	int ret;
 	mdp_super_t *tmp1, *tmp2;
@@ -1021,12 +1021,12 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
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
2.7.4

