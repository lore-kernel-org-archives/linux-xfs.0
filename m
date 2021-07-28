Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1128CC4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 20:00:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6E886103C
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 20:00:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbhG1UAW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 16:00:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230125AbhG1UAW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jul 2021 16:00:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E01C61038;
        Wed, 28 Jul 2021 20:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627502420;
        bh=hEMHdCa2sZ3N0F5WKnDb6naLlwS4erOTjOuNqGKDpoE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Kg9UjLVXAjVsvW9WLUhU8H3LS1DBK1dtDJkQwIb6n3Ss6eMoUMxWVW08iHG3pWdDc
         Nv/tRhnZY2cjvbgd5Ltt8zbWDmA4pyPwchv+QHHfZUyoZ5eR5dLb85LJK9lyiP6mqW
         K9/rYlgg1XwAA+esijqYC2oDWbNM69sJAd5uE1hbvzhXj0fb8Kfa9Z8swJr18OEvT/
         Sb9Y6Jw4apJdqrZJWXSXjpyPGqdUJkOuqVcDD5K0rRdbtWUh7IPgfjx1d+wbDW56Gy
         OcOwdf0TPsiwLHj9ugr3SY6F9tMdCJb+AnyrNIlIJEGNOnjbyt31N/oE/ZFQBWsCcK
         4BabOc+yUfvsQ==
Date:   Wed, 28 Jul 2021 13:00:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        chandanrlinux@gmail.com
Subject: [PATCH 5/4] xfs/530: skip test if user MKFS_OPTIONS screw up
 formatting
Message-ID: <20210728200020.GA3601425@magnolia>
References: <162743097757.3427426.8734776553736535870.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162743097757.3427426.8734776553736535870.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Skip this test if the user's MKFS_OPTIONS are not compatible with the
realtime parameters that we're injecting in order to test growfs bugs.
Because this test is trying to trigger a specific kernel bug, we need
mkfs to format a filesystem with very specific geometry parameters.

The first problem stems from the fact that the test performs a default
mkfs, computes a suitable realtime geometry from that filesystem, and
then formats a second time with an explicit blocksize option to mkfs.
If the original MKFS_OPTS contained a blocksize directive, the mkfs will
fail because the option was respecified.  The two blocksize options will
be the same, so we drop the explicit blocksize option.

However, this exposes a second problem: MKFS_OPTIONS might contain
options that are not compatible with any realtime filesystem.  If that
happens, _scratch_do_mkfs will "helpfully" drop MKFS_OPTIONS and try
again with only the options specified by the test.  This gets us a
filesystem with the given rt geometry, but it could be missing critical
parameters from MKFS_OPTIONS (like blocksize).  The test will then fail
to exercise the growfs bugfix, so the second part of the fix is to check
that the filesystem we're going to test actually has the geometry
parameters that we require.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/530 |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/tests/xfs/530 b/tests/xfs/530
index 99a4d33b..0e12422d 100755
--- a/tests/xfs/530
+++ b/tests/xfs/530
@@ -60,10 +60,22 @@ echo "Format and mount rt volume"
 
 export USE_EXTERNAL=yes
 export SCRATCH_RTDEV=$rtdev
-_scratch_mkfs -d size=$((1024 * 1024 * 1024)) -b size=${dbsize} \
+_scratch_mkfs -d size=$((1024 * 1024 * 1024)) \
 	      -r size=${rtextsz},extsize=${rtextsz} >> $seqres.full
 _try_scratch_mount || _notrun "Couldn't mount fs with synthetic rt volume"
 
+# If we didn't get the desired realtime volume and the same blocksize as the
+# first format (which we used to compute a specific rt geometry), skip the
+# test.  This can happen if the MKFS_OPTIONS conflict with the ones we passed
+# to _scratch_mkfs or do not result in a valid rt fs geometry.  In this case,
+# _scratch_mkfs will try to "succeed" at formatting by dropping MKFS_OPTIONS,
+# giving us the wrong geometry.
+formatted_blksz="$(_get_block_size $SCRATCH_MNT)"
+test "$formatted_blksz" -ne "$dbsize" && \
+	_notrun "Tried to format with $dbsize blocksize, got $formatted_blksz."
+$XFS_INFO_PROG $SCRATCH_MNT | egrep -q 'realtime.*blocks=0' && \
+	_notrun "Filesystem should have a realtime volume"
+
 echo "Consume free space"
 fillerdir=$SCRATCH_MNT/fillerdir
 nr_free_blks=$(stat -f -c '%f' $SCRATCH_MNT)
