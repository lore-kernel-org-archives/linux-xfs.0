Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54720C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 04:20:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0488661990
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 04:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbhCWET5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 00:19:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:46048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229464AbhCWETy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Mar 2021 00:19:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D466461990;
        Tue, 23 Mar 2021 04:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616473193;
        bh=5o3PRU4OvnC1W0sNVlX3XyQIhh7K8DWWmcpgWYJ/pvs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=J+5jrkv7RavLHBPGkRNVK6Dh0JsH5L72hJ4+JpHZgydYlPSymjOeq4Nb+bnhUGkcE
         BsaVtm050KqeDXsk3xdu5z9nh91WJQdIUlZWJJHZyN7vTNiObf14Ai6Rk1Mq3o8/XG
         1bnJ7IyNNRA6S1sxuRGktcRQAzNJdHwfPKH5qesLseVZ9/jtEE/tgUb6Vpwt8bjY0n
         Mofd9ihDGGoZyBw+0ouyU1AlOMytKZmDpQLShk7rIjFNKu3FRnmAoQ/ZVgnGCc81xB
         eqgdfHHA2ULRgCpub20yt61kbp17Blc7qaoaPsUxTIZ8oFoGTSjX5Ns0lgT9BeksQd
         gpSJSZK0Ae48g==
Subject: [PATCH 2/3] common/populate: create fifos when pre-populating
 filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 22 Mar 2021 21:19:53 -0700
Message-ID: <161647319358.3429609.6818899550213439595.stgit@magnolia>
In-Reply-To: <161647318241.3429609.1862044070327396092.stgit@magnolia>
References: <161647318241.3429609.1862044070327396092.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create fifos when populating the scratch filesystem for completeness.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/common/populate b/common/populate
index 8f42a528..c01b7e0e 100644
--- a/common/populate
+++ b/common/populate
@@ -231,6 +231,7 @@ _scratch_xfs_populate() {
 	echo "+ special"
 	mknod "${SCRATCH_MNT}/S_IFCHR" c 1 1
 	mknod "${SCRATCH_MNT}/S_IFBLK" b 1 1
+	mknod "${SCRATCH_MNT}/S_IFIFO" p
 
 	# special file with an xattr
 	setfacl -P -m u:nobody:r ${SCRATCH_MNT}/S_IFCHR
@@ -403,6 +404,7 @@ _scratch_ext4_populate() {
 	echo "+ special"
 	mknod "${SCRATCH_MNT}/S_IFCHR" c 1 1
 	mknod "${SCRATCH_MNT}/S_IFBLK" b 1 1
+	mknod "${SCRATCH_MNT}/S_IFIFO" p
 
 	# special file with an xattr
 	setfacl -P -m u:nobody:r ${SCRATCH_MNT}/S_IFCHR
@@ -580,6 +582,7 @@ _scratch_xfs_populate_check() {
 	extents_slink="$(__populate_find_inode "${SCRATCH_MNT}/S_IFLNK.FMT_EXTENTS")"
 	bdev="$(__populate_find_inode "${SCRATCH_MNT}/S_IFBLK")"
 	cdev="$(__populate_find_inode "${SCRATCH_MNT}/S_IFCHR")"
+	fifo="$(__populate_find_inode "${SCRATCH_MNT}/S_IFIFO")"
 	local_attr="$(__populate_find_inode "${SCRATCH_MNT}/ATTR.FMT_LOCAL")"
 	leaf_attr="$(__populate_find_inode "${SCRATCH_MNT}/ATTR.FMT_LEAF")"
 	node_attr="$(__populate_find_inode "${SCRATCH_MNT}/ATTR.FMT_NODE")"
@@ -605,6 +608,7 @@ _scratch_xfs_populate_check() {
 	__populate_check_xfs_dformat "${btree_dir}" "btree"
 	__populate_check_xfs_dformat "${bdev}" "dev"
 	__populate_check_xfs_dformat "${cdev}" "dev"
+	__populate_check_xfs_dformat "${fifo}" "dev"
 	__populate_check_xfs_attr "${local_attr}" "local"
 	__populate_check_xfs_attr "${leaf_attr}" "leaf"
 	__populate_check_xfs_attr "${node_attr}" "node"

