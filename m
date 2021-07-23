Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2A80C4320A
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Jul 2021 05:09:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B624660E8E
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Jul 2021 05:09:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbhGWE20 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Jul 2021 00:28:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:59794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229698AbhGWE20 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Jul 2021 00:28:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 458ED60E96;
        Fri, 23 Jul 2021 05:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627016940;
        bh=xfc+sBUAHtcS6Hmn+m6yA2+EFrI2h3nmRnx1uI9oOps=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TMKCgHWMOXP4qXlh58WNpGw6VbtMgZcmDeESYj9iq3DvhnXaDBEodVhfFkCoYVJiv
         tLctSgm6U8bMCpmy1ZcSUU9DfAjZ5xt1bWqYhxRhKbju6bBEN3Mg+xSzSdHXIGQAre
         6C6rkkNgyfvq3LEuR/LIOgnZLKR26LGh1l8ZxE5sk7frS3TXbh6FrWuQfzCH5X/7Wt
         r1DdM3MKVu1Mk0o7EZBmpBLJS9XI+4Lv3L8xQmu8T9Ys/tir7BcmA+G7sFv+9XqPqg
         VwnwyvwUwd48okqOo3+LE2mZM4lSazM8f57aPLWPydAsPpMAvJYvpV/PgVk9lSRfvd
         tbaees/sd2CTw==
Date:   Thu, 22 Jul 2021 22:08:59 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH 8/7] xfs/152: avoid failure when quotaoff is not supported
Message-ID: <20210723050859.GR559212@magnolia>
References: <20210722073832.976547-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722073832.976547-1-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Switch the test that removes the quota files to just disable enforcement
and then unmount the file system as disabling quota accounting is about
to go away.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/152     |   20 +++++++++++++-------
 tests/xfs/152.out |    4 ----
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/tests/xfs/152 b/tests/xfs/152
index de85f48c..129d9c06 100755
--- a/tests/xfs/152
+++ b/tests/xfs/152
@@ -195,8 +195,9 @@ test_enable()
 test_off()
 {
 	echo "checking off command (type=$type)"
-	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
-			-c "off -$type -v" $SCRATCH_MNT | _filter_scratch
+	_scratch_unmount
+	_qmount_option ""
+	_qmount
 }
 
 test_remove()
@@ -257,6 +258,8 @@ qmount_idmapped()
 
 test_xfs_quota()
 {
+	local quota_options="$1"
+
 	# init quota
 	echo "init quota limit and timer, and dump it"
 	if [ "$idmapped" -eq 1 ]; then
@@ -310,7 +313,10 @@ test_xfs_quota()
 	echo ; test_state
 	echo ; test_remove
 	echo ; test_report -N
-	echo "quota remount"; qmount_idmapped
+	echo "quota remount"
+	_qmount_option "$quota_options"
+	_qmount
+	qmount_idmapped
 	echo ; test_report -N
 
 	# restore test
@@ -329,7 +335,7 @@ id=$uqid
 id2=$uqid2
 idmapped=0
 qmount_idmapped
-test_xfs_quota
+test_xfs_quota "uquota,sync"
 
 echo "----------------------- uquota,sync,idmapped ---------------------------"
 wipe_scratch
@@ -339,7 +345,7 @@ id=$uqid
 id2=$uqid2
 idmapped=1
 qmount_idmapped
-test_xfs_quota
+test_xfs_quota "uquota,sync"
 
 echo "----------------------- gquota,sync,unmapped ---------------------------"
 wipe_scratch
@@ -349,7 +355,7 @@ id=$gqid
 id2=$gqid2
 idmapped=0
 qmount_idmapped
-test_xfs_quota
+test_xfs_quota "gquota,sync"
 
 echo "----------------------- gquota,sync,idmapped ---------------------------"
 wipe_scratch
@@ -359,7 +365,7 @@ id=$gqid
 id2=$gqid2
 idmapped=1
 qmount_idmapped
-test_xfs_quota
+test_xfs_quota "gquota,sync"
 
 wipe_mounts
 
diff --git a/tests/xfs/152.out b/tests/xfs/152.out
index 1fc71fb9..b663b096 100644
--- a/tests/xfs/152.out
+++ b/tests/xfs/152.out
@@ -132,7 +132,6 @@ checking quota command (type=u)
 SCRATCH_DEV 1024 102400 102400 00 [--------] 15 100 100 00 [--------] SCRATCH_MNT
 
 checking off command (type=u)
-User quota are not enabled on SCRATCH_DEV
 
 checking state command (type=u)
 
@@ -296,7 +295,6 @@ checking quota command (type=u)
 SCRATCH_DEV 1024 102400 102400 00 [--------] 15 100 100 00 [--------] SCRATCH_MNT
 
 checking off command (type=u)
-User quota are not enabled on SCRATCH_DEV
 
 checking state command (type=u)
 
@@ -460,7 +458,6 @@ checking quota command (type=g)
 SCRATCH_DEV 1024 102400 102400 00 [--------] 15 100 100 00 [--------] SCRATCH_MNT
 
 checking off command (type=g)
-Group quota are not enabled on SCRATCH_DEV
 
 checking state command (type=g)
 
@@ -624,7 +621,6 @@ checking quota command (type=g)
 SCRATCH_DEV 1024 102400 102400 00 [--------] 15 100 100 00 [--------] SCRATCH_MNT
 
 checking off command (type=g)
-Group quota are not enabled on SCRATCH_DEV
 
 checking state command (type=g)
 
