Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0203C43460
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 01:04:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD6A3613CE
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 01:04:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348954AbhDNBFE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Apr 2021 21:05:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:37872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345256AbhDNBFD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Apr 2021 21:05:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6AB1613B6;
        Wed, 14 Apr 2021 01:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618362283;
        bh=Q9aUOqxIhO69rVteC88rMmwi+RM/8L0Kplu/0cIU6t0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LMb8A6Enf9nqXID8nn0PfWeV6ccwpcY0a0TXwDhHCsDpviHKpnSKjkv1HWhGTJSS6
         KivCIv3chsHROOADAky4DcyNmdKUhUTvlh7q8GWfPTt8w+gaAs6PzvSctkRcKP3jLB
         qH9tPzEFs+IQkJQT9Nwf1WVbsH57qbHh9+Et0+hGHE76GazWuqKJP8vApS0D5VDCYk
         hDOoQjBSzuIOSKqz87TorCjpyuvR8KjwJQAzcov9JBOAAxNHSlhoHKl7Fco2OgDVwJ
         hs+e7tuEleWrzPA0ebY+1rHVBokxsAoQ+D1FW+6hs4S6wqwvBZClYr6jfixihaHyiE
         kmAUE2TudHd3Q==
Subject: [PATCH 2/9] generic/563: selectively remove the io cgroup controller
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 13 Apr 2021 18:04:42 -0700
Message-ID: <161836228218.2754991.5899063640535008629.stgit@magnolia>
In-Reply-To: <161836227000.2754991.9697150788054520169.stgit@magnolia>
References: <161836227000.2754991.9697150788054520169.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If a system configuration tool such as systemd sets up the io cgroup
controller for its own purposes, it's possible that the last line of
this test will not be able to remove the io controller from the system
configuration.  This causes the test to fail even though the inability
to tear down systemd should not be considered (in this case) a failure.

Change this test to set the "io" component of subtree control back to
whatever it was when the test started.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/563 |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


diff --git a/tests/generic/563 b/tests/generic/563
index b113eacf..fe7394c0 100755
--- a/tests/generic/563
+++ b/tests/generic/563
@@ -103,6 +103,9 @@ sminor=$((0x`stat -L -c %T $LOOP_DEV`))
 _mkfs_dev $LOOP_DEV >> $seqres.full 2>&1
 _mount $LOOP_DEV $SCRATCH_MNT || _fail "mount failed"
 
+drop_io_cgroup=
+grep -q -w io $cgdir/cgroup.subtree_control || drop_io_cgroup=1
+
 echo "+io" > $cgdir/cgroup.subtree_control || _fail "subtree control"
 
 # Read and write from a single group.
@@ -143,7 +146,9 @@ $XFS_IO_PROG -c fsync $SCRATCH_MNT/file
 check_cg $cgdir/$seq-cg $iosize $iosize
 check_cg $cgdir/$seq-cg-2 0 0
 
-echo "-io" > $cgdir/cgroup.subtree_control || _fail "subtree control"
+if [ "$drop_io_cgroup" = 1 ]; then
+	echo "-io" > $cgdir/cgroup.subtree_control || _fail "subtree control"
+fi
 
 # success, all done
 status=0

