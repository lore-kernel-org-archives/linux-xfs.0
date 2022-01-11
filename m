Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B59C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jan 2022 21:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245503AbiAKVu0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jan 2022 16:50:26 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42952 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245501AbiAKVu0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jan 2022 16:50:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7653617B2;
        Tue, 11 Jan 2022 21:50:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39236C36AEF;
        Tue, 11 Jan 2022 21:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641937825;
        bh=tCamxsoT7S/dNyb9ngCk2wIrERFDLkb0PW+Dk9EdQe0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=G7yPGFLV138ka05CKYXDQGTbwynvaEn5f1ZyhViLM7YKoweOO/TorX3CPp7GVWFLM
         O+hZ5TFBrQsI9BDkkM0S7WNEx7M0R394gVqpDDsj3K01+7mhSKaAAHRg5R8Imjfcf+
         iqRgm2StodqyojAbzKPg8dt/9z1dI7SP+WA53i2qLDV5CsitlDUdhLXVas0aRBxEG3
         siVyLYHEBSfDh8hO3K+fCcae6UgNCLJpekAC+NizTJFDCxiDNRBwM3PFLoOsB3pYoc
         F3qHC1XTnOY4AOCVgH45xFCXkvf3f8TBipDwYHx59KKA4oITl22gUQkKTEQR6mP4J9
         g8HAUNAdv7xLQ==
Subject: [PATCH 3/8] xfs/220: fix quotarm syscall test
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     xuyang2018.jy@fujitsu.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 11 Jan 2022 13:50:24 -0800
Message-ID: <164193782492.3008286.10701739517344882323.stgit@magnolia>
In-Reply-To: <164193780808.3008286.598879710489501860.stgit@magnolia>
References: <164193780808.3008286.598879710489501860.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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
Cc: xuyang2018.jy@fujitsu.com
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/220 |   30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)


diff --git a/tests/xfs/220 b/tests/xfs/220
index 241a7abd..88eedf51 100755
--- a/tests/xfs/220
+++ b/tests/xfs/220
@@ -52,14 +52,30 @@ _scratch_mkfs_xfs >/dev/null 2>&1
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
+delta=$((after_freesp - before_freesp))
+
+echo "freesp $before_freesp -> $after_freesp ($delta)" >> $seqres.full
+if [ $before_freesp -ge $after_freesp ]; then
+	echo "expected Q_XQUOTARM to free space"
+fi
 
 # and unmount again
 _scratch_unmount

