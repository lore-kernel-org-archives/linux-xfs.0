Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3B97C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 04:09:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D46166140B
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 04:09:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbhD1EKG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 00:10:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229437AbhD1EKD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Apr 2021 00:10:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C68D613ED;
        Wed, 28 Apr 2021 04:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619582959;
        bh=R7nCZy89RdQgnqUbWy/r0m10bWwb7qxNH36FxMAD6+U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rusUT98eVi8KcSqYCSq4W7PPbzM1U2p8DLU5mO3uNWFQwGpIJntJEia6OPOcYZt1l
         n4A/7RqH0reiPBKbTo8tEZjQOhTJHulSQyhrZVSHDUjHHF6t0uFl3B+Ivz/FonZI1T
         8YLhVMBiGmQW6RG7l/8Lq+qF3HSex35avFH0FQ2b2CfzaVtNBXhAaGm0GZpfcxLRBM
         iP7Giwe3Yb7o9t/sFSdzq9SKK/SW65LoOb9r4i1FnIZxkbpPidRH7zPBSqcqbmlqdo
         BAC0+JqeD7F99pkqrOdAA7HVr3L+uqpSeGheCaq78Q3tlx+kf8NyBMIIemdSpG/B0H
         QsI7jCcEHf+WQ==
Subject: [PATCH 4/5] xfs/004: don't fail test due to realtime files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 27 Apr 2021 21:09:18 -0700
Message-ID: <161958295873.3452351.8562454394626118217.stgit@magnolia>
In-Reply-To: <161958293466.3452351.14394620932744162301.stgit@magnolia>
References: <161958293466.3452351.14394620932744162301.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This test exercises xfs_db functionality that relates to the free space
btrees on the data device.  Therefore, make sure that the files we
create are not realtime files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/004 |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/tests/xfs/004 b/tests/xfs/004
index 141cf03a..7633071c 100755
--- a/tests/xfs/004
+++ b/tests/xfs/004
@@ -28,6 +28,10 @@ _populate_scratch()
 	_scratch_mkfs_xfs | tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
 	. $tmp.mkfs
 	_scratch_mount
+	# This test looks at specific behaviors of the xfs_db freesp command,
+	# which reports on the contents of the free space btrees for the data
+	# device.  Don't let anything get created on the realtime volume.
+	$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
 	dd if=/dev/zero of=$SCRATCH_MNT/foo count=200 bs=4096 >/dev/null 2>&1 &
 	dd if=/dev/zero of=$SCRATCH_MNT/goo count=400 bs=4096 >/dev/null 2>&1 &
 	dd if=/dev/zero of=$SCRATCH_MNT/moo count=800 bs=4096 >/dev/null 2>&1 &

