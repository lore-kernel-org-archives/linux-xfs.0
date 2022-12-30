Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 863F3C3DA7D
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:55:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiL3WzR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:55:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235490AbiL3WzP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:55:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCCD1AA29;
        Fri, 30 Dec 2022 14:55:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 496A361C16;
        Fri, 30 Dec 2022 22:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5EA4C433D2;
        Fri, 30 Dec 2022 22:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440913;
        bh=lCVt8f/wb4II/loLUcHIsKKO0IDq0zjG30nHr32ViIw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=k8jTCSLjcEn/u9CGfH8de8mSHjX3k2kJVXtX/WVONscYKKHuCCZ343HhAxOLPKGk+
         2t+9YMaKw+cJ1vU2b4/iGEGvKKEITLQYQU2CgMEoWL5sJOEc9P0qpXqJqHqCeiwBaz
         qQuSat4tpEtDn3SeXBN8yKB/WwZNh34s7Uws2Pg58GJvUOZTgeXxeWGcmxmrKBVP1C
         6pfQ64TUMpHHwbiVV+bNNhRZhO6/8/tJt/DBJ3nGEoBjTY90ZHWbZ9TRBNd5pYlNhL
         Ih79xouE57Ibff0RpWpjh9orKICAPvvWcjB8t7xf2sVVTW36AnnQThqTn7wqLVcc6p
         mdDm1CYl3p7Qg==
Subject: [PATCH 04/16] fuzzy: clean up scrub stress programs quietly
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:12:53 -0800
Message-ID: <167243837353.694541.4864104518386801319.stgit@magnolia>
In-Reply-To: <167243837296.694541.13203497631389630964.stgit@magnolia>
References: <167243837296.694541.13203497631389630964.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In the cleanup function for online fsck stress test common code, send
SIGINT instead of SIGTERM to the fsstress and xfs_io processes to kill
them.  bash prints 'Terminated' to the golden output when children die
with SIGTERM, which can make a test fail, and we don't want a regular
cleanup function being the thing that prevents the test from passing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/common/fuzzy b/common/fuzzy
index 979fa55515..e52831560d 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -381,7 +381,9 @@ _require_xfs_stress_online_repair() {
 
 # Clean up after the loops in case they didn't do it themselves.
 _scratch_xfs_stress_scrub_cleanup() {
-	$KILLALL_PROG -TERM xfs_io fsstress >> $seqres.full 2>&1
+	# Send SIGINT so that bash won't print a 'Terminated' message that
+	# distorts the golden output.
+	$KILLALL_PROG -INT xfs_io fsstress >> $seqres.full 2>&1
 	$XFS_IO_PROG -x -c 'thaw' $SCRATCH_MNT >> $seqres.full 2>&1
 }
 

