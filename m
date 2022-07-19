Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC1DFCCA47F
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jul 2022 21:38:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240148AbiGSViE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jul 2022 17:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240127AbiGSViD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jul 2022 17:38:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DD661710;
        Tue, 19 Jul 2022 14:38:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D6B661A81;
        Tue, 19 Jul 2022 21:38:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A41C341C6;
        Tue, 19 Jul 2022 21:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658266681;
        bh=otszpbkt5MCfHJ2dlo5RCZS4p8Vr8QbdUokqGYpTQXM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BEl++0/yWTV1eq4B2UdkF9Mw9q+PW9/5XfSWFE268CrKJzdnHD+irW4G8H3U3Cy0k
         H+lndpwMVe3b4oGkkDqH40zipZbX0GmxrEjpDKJuWswqI7Tu7pFFjDmX4+eMkKBI4t
         gQxZRzh88XVwAe3WOJFcF4tBqO/4EpKV6tMYZlnGZvOz0aYJrh7sA1qYWs8GMMxRPR
         KOaQikQGvvR6MZ7zkORkj/rXKlghVeacT01j/2g9BLuobu2lElouoo8F8IcApL5WM+
         n/+7ZIMIzac8PFypunSnGH69Qz2nfJJCVF19Ia7W0QNSrVYxHjsFxdNu1sJ+gf/I6k
         3P7KmU/B4MHQw==
Subject: [PATCH 8/8] punch: skip fpunch tests when page size not congruent
 with file allocation unit
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        tytso@mit.edu, leah.rumancik@gmail.com
Date:   Tue, 19 Jul 2022 14:38:01 -0700
Message-ID: <165826668137.3249494.15114805008005901394.stgit@magnolia>
In-Reply-To: <165826663647.3249494.13640199673218669145.stgit@magnolia>
References: <165826663647.3249494.13640199673218669145.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Skip the generic fpunch tests on a file when the file's allocation unit
size is not congruent with the system page size.  This is needed for
testing swapfiles and mmap collisions wiht fallocate.

Assuming this edgecase configuration of an edgecase feature is
vanishingly rare, let's just _notrun the tests instead of rewriting a
ton of tests to do their integrity checking by hand.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/495 |    4 ++++
 tests/generic/503 |    4 ++++
 2 files changed, 8 insertions(+)


diff --git a/tests/generic/495 b/tests/generic/495
index 608f1715..5e03dfee 100755
--- a/tests/generic/495
+++ b/tests/generic/495
@@ -21,6 +21,10 @@ _require_sparse_files
 _scratch_mkfs >> $seqres.full 2>&1
 _scratch_mount
 
+blksize=$(_get_file_block_size $SCRATCH_MNT)
+test $blksize -eq $(getconf PAGE_SIZE) || \
+	_notrun "swap file allocation unit size must match page size"
+
 # We can't use _format_swapfile because we're using our custom mkswap and
 # swapon.
 touch "$SCRATCH_MNT/swap"
diff --git a/tests/generic/503 b/tests/generic/503
index a6971e63..ff3390bf 100755
--- a/tests/generic/503
+++ b/tests/generic/503
@@ -38,6 +38,10 @@ _scratch_mkfs >> $seqres.full 2>&1
 export MOUNT_OPTIONS=""
 _scratch_mount >> $seqres.full 2>&1
 
+blksize=$(_get_file_block_size $SCRATCH_MNT)
+test $blksize -eq $(getconf PAGE_SIZE) || \
+	_notrun "file block size must match page size"
+
 # real QA test starts here
 $here/src/t_mmap_collision $TEST_DIR/testfile $SCRATCH_MNT/testfile
 

