Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 455BEC4320A
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 20:00:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29F6361040
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 20:00:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhG1UAs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 16:00:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:48048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230125AbhG1UAs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jul 2021 16:00:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BBC761038;
        Wed, 28 Jul 2021 20:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627502446;
        bh=vgthiiJorC0JS1GUWSVhqMCItufbfTh0HlZC9e3yJZQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L5nmZn6FtlHOWqx/5nHvLYCq1P7tvucSw+jxR/cQB/IE0XoLCzds5xJ+pIpMco4Q2
         pAf3Aw2dFHiupslxrKHg/9gQB7yYk7aYyEsFwLWynGUKwsXvRCxrMapUgb/TRZcQ8L
         oIHgrWhypZ8byERlILSoH5eMgd+JBUY3rtKKq8RPzsnwS5S2sdetAXYeJIV88jX7pr
         DcEczoFSt3FKwzkUQlEOlEY9UBunSGpyXAbdQXjlGIt2HrobHg4NvyaKS0PHnh2yRe
         4aHuGQ9gJYcjuqgPX5ILNa4EtneXL3NpiRpsPP3Vok9L3m4VJJlSsZz1M8I7+2kYL1
         bUW/lr3Ag0LLg==
Date:   Wed, 28 Jul 2021 13:00:45 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 6/4] xfs/007: fix regressions on V4 filesystems
Message-ID: <20210728200045.GB3601425@magnolia>
References: <162743097757.3427426.8734776553736535870.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162743097757.3427426.8734776553736535870.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Following commit eae40404, I noticed the following regression when
running a V4 fstests run on an 5.13 kernel:

--- /tmp/fstests/tests/xfs/007.out      2021-05-13 11:47:55.793859995 -0700
+++ /var/tmp/fstests/xfs/007.out.bad    2021-07-28 09:23:42.856000000 -0700
@@ -16,4 +16,4 @@
 *** umount
 *** Usage after quotarm ***
 core.nblocks = 0
-core.nblocks = 0
+core.nblocks = 1

The underlying cause of this problem is the fact that we now remount the
filesystem with no quota options because that will (soon) become the
only means to turn off quota accounting on XFS.  Because V4 filesystems
don't support simultaneous project and group quotas and play weird
remapping games with the incore superblock field, we actually have to
issue a remove command for the group quota file if we're trying to
truncate the project quota file on a V4 filesystem.

Due to stupid limitations in xfs_quota we actually have to issue a
separate 'remove' command.

Fixes: eae40404 ("xfs/007: unmount after disabling quota")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/007 |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/tests/xfs/007 b/tests/xfs/007
index 796db960..6d6d828b 100755
--- a/tests/xfs/007
+++ b/tests/xfs/007
@@ -43,10 +43,27 @@ do_test()
 	_qmount
 	echo "*** turn off $off_opts quotas"
 	$XFS_QUOTA_PROG -x -c "off -$off_opts" $SCRATCH_MNT
+
+	# Remount the filesystem with no quota options to force quotas off.
+	# This takes care of newer kernels where quotaoff clears the superblock
+	# quota enforcement flags but doesn't shut down accounting.
 	_scratch_unmount
 	_qmount_option ""
 	_scratch_mount
-	$XFS_QUOTA_PROG -x -c "remove -$off_opts" $SCRATCH_MNT
+
+	rm_commands=(-x -c "remove -$off_opts")
+
+	# Remounting a V4 fs with no quota options means that the internal
+	# gquotino -> pquotino remapping does not happen.  If we want to
+	# truncate the "project" quota file we must run remove -g.  However,
+	# xfs_quota has a nasty sharp edge wherein passing '-g' and '-p' only
+	# results in a QUOTARM call for the group quota file, so we must make
+	# a separate remove call.
+	[ $_fs_has_crcs == 0 ] && [ "$off_opts" = "up" ] && \
+		rm_commands+=(-c "remove -g")
+
+	$XFS_QUOTA_PROG "${rm_commands[@]}" $SCRATCH_MNT
+
 	echo "*** umount"
 	_scratch_unmount
 
