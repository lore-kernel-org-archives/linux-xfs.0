Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33835 "EHLO
        mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752190AbcJKRxe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Oct 2016 13:53:34 -0400
Received: by mail-pa0-f54.google.com with SMTP id rz1so18603003pab.1
        for <linux-xfs@vger.kernel.org>; Tue, 11 Oct 2016 10:52:53 -0700 (PDT)
From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] xfs: add some 'static' annotations
Date: Tue, 11 Oct 2016 10:52:10 -0700
Message-Id: <1476208330-29943-1-git-send-email-ebiggers@google.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: david@fromorbit.com, Eric Biggers <ebiggers@google.com>

sparse reported that several variables and a function were not
forward-declared anywhere and therefore should be 'static'.

Found with sparse by running 'make C=2 CF=-D__CHECK_ENDIAN__ fs/xfs/'

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/xfs/libxfs/xfs_btree.c | 2 +-
 fs/xfs/xfs_sysfs.c        | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index aa1752f..b2190ca 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4822,7 +4822,7 @@ xfs_btree_calc_size(
 	return rval;
 }
 
-int
+static int
 xfs_btree_count_blocks_helper(
 	struct xfs_btree_cur	*cur,
 	int			level,
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 5f8d55d..276d302 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -512,13 +512,13 @@ static struct attribute *xfs_error_attrs[] = {
 };
 
 
-struct kobj_type xfs_error_cfg_ktype = {
+static struct kobj_type xfs_error_cfg_ktype = {
 	.release = xfs_sysfs_release,
 	.sysfs_ops = &xfs_sysfs_ops,
 	.default_attrs = xfs_error_attrs,
 };
 
-struct kobj_type xfs_error_ktype = {
+static struct kobj_type xfs_error_ktype = {
 	.release = xfs_sysfs_release,
 	.sysfs_ops = &xfs_sysfs_ops,
 };
-- 
2.8.0.rc3.226.g39d4020

