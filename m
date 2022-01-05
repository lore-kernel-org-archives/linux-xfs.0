Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEF9AC433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jan 2022 19:53:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243736AbiAETx4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Jan 2022 14:53:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243691AbiAETx4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jan 2022 14:53:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91549C061245;
        Wed,  5 Jan 2022 11:53:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57788B81D80;
        Wed,  5 Jan 2022 19:53:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1129C36AE9;
        Wed,  5 Jan 2022 19:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641412433;
        bh=lWr2cB5qglyVtDBeJfrqVb8y8AHtTR8Xt/KNVLh0bK4=;
        h=Date:From:To:Cc:Subject:From;
        b=KpE/iGpPl5H5U5FARXZh0CHz6fOAjmaKu637J/TnFRHcUSnsZlPH9sie7Xi2SJ83o
         TNAL1igOW0dKqE7RzIos90aaWfHzIGbeyPbu9RpSkPLqMucfjlISjm6yRPHefMACuL
         Ua5WSbfyLo4KSspsp2CxqwjxVQORWxDOvuRKfgXcp+No3ogJcRBHKByOaifvHPJZzP
         nF36cvO7JL4pqm8Qb1ow1CP2K6vFdUd5GVYOtOuZ3zUfclvUoBlh/BjpNJcCuRLmEg
         5MT/hQv2ztJ0qDh8c91Hy5jUh1exmSpa1ZZeCz8vcw7V+djC/dXf6FqaOull8g3eat
         X0REYscsV2/1Q==
Date:   Wed, 5 Jan 2022 11:53:52 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "xuyang2018.jy@fujitsu.com" <xuyang2018.jy@fujitsu.com>,
        xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: [PATCH] xfs/220: fix quotarm syscall test
Message-ID: <20220105195352.GM656707@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In commit 6ba125c9, we tried to adjust this fstest to deal with the
removal of the ability to turn off quota accounting via the Q_XQUOTAOFF
system call.

Unfortunately, the changes made to this test make it nonfunctional on
those newer kernels, since the Q_XQUOTARM command returns EINVAL if
quota accounting is turned on, and the changes filter out the EINVAL
error string.

Doing this wasn't /incorrect/, because, very narrowly speaking, the
intent of this test is to guard against Q_XQUOTARM returning ENOSYS when
quota has been enabled.  However, this also means that we no longer test
Q_XQUOTARM's ability to truncate the quota files at all.

So, fix this test to deal with the loss of quotaoff in the same way that
the others do -- if accounting is still enabled after the 'off' command,
cycle the mount so that Q_XQUOTARM actually truncates the files.

While we're at it, enhance the test to check that XQUOTARM actually
truncated the quota files.

Fixes: 6ba125c9 ("xfs/220: avoid failure when disabling quota accounting is not supported")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/220 |   28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/tests/xfs/220 b/tests/xfs/220
index 241a7abd..cfa90d3a 100755
--- a/tests/xfs/220
+++ b/tests/xfs/220
@@ -52,14 +52,28 @@ _scratch_mkfs_xfs >/dev/null 2>&1
 # mount  with quotas enabled
 _scratch_mount -o uquota
 
-# turn off quota and remove space allocated to the quota files
+# turn off quota accounting...
+$XFS_QUOTA_PROG -x -c off $SCRATCH_DEV
+
+# ...but if the kernel doesn't support turning off accounting, remount with
+# noquota option to turn it off...
+if $XFS_QUOTA_PROG -x -c 'state -u' $SCRATCH_DEV | grep -q 'Accounting: ON'; then
+	_scratch_unmount
+	_scratch_mount -o noquota
+fi
+
+before_freesp=$(_get_available_space $SCRATCH_MNT)
+
+# ...and remove space allocated to the quota files
 # (this used to give wrong ENOSYS returns in 2.6.31)
-#
-# The sed expression below replaces a notrun to cater for kernels that have
-# removed the ability to disable quota accounting at runtime.  On those
-# kernel this test is rather useless, and in a few years we can drop it.
-$XFS_QUOTA_PROG -x -c off -c remove $SCRATCH_DEV 2>&1 | \
-	sed -e '/XFS_QUOTARM: Invalid argument/d'
+$XFS_QUOTA_PROG -x -c remove $SCRATCH_DEV
+
+# Make sure we actually freed the space used by dquot 0
+after_freesp=$(_get_available_space $SCRATCH_MNT)
+if [ $before_freesp -ge $after_freesp ]; then
+	echo "before: $before_freesp; after: $after_freesp" >> $seqres.full
+	echo "expected more free space after Q_XQUOTARM"
+fi
 
 # and unmount again
 _scratch_unmount
