Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABF6CC433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 22:12:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239834AbiCPWN4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Mar 2022 18:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232357AbiCPWN4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Mar 2022 18:13:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE07FE7;
        Wed, 16 Mar 2022 15:12:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65CE2615C7;
        Wed, 16 Mar 2022 22:12:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD90C340EC;
        Wed, 16 Mar 2022 22:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647468752;
        bh=2kEep88jHjTUvaI3I8B0kb+rbxmj2CH2dOUf5Qlb58s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t+2SfS/mBb14fkAGiMbVu/31NsWCVzNhwpzGZtJ0O9gVlOSANqg9AjiMG8cVgY6ey
         efkMr23RJpmWGCma7rTXKVx3nyRyHOWfuYRWJHU0KjG5+49zwTF5vGuenZfXiCbfK8
         zcHkpIPAtdOLEKGkF9OlyX85cWw1SvmxUz95qmXOjglCkxZ+bptkCKI9NvjJ6SrRv7
         tJ7FX/8JNJRyfDwb5iaaVvVixnWvnz16rGzIpJ1pB7U9JLt1SZ2pNaHRnUYTEnqMJ3
         FRFD3G5nm5u4rtpG7uB/oTSxwDeKp/hyPHlUaWlIBExYyQ2RAewjRTU0sMLRNGGdJ9
         5jBjpbYwn3Zxw==
Date:   Wed, 16 Mar 2022 15:12:32 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: [PATCH 5/4] xfs/076: only create files on the data device
Message-ID: <20220316221232.GE8200@magnolia>
References: <164740140348.3371628.12967562090320741592.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164740140348.3371628.12967562090320741592.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This test checks that filesystems with sparse inode support can continue
to allocate inodes when free space gets fragmented.  Inodes only exist
on the data device, so we need to ensure that realtime is not enabled on
the filesystem so that the rt metadata doesn't mess with the inode usage
percentage and cause a test failure.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/076 |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/tests/xfs/076 b/tests/xfs/076
index eac7410e..8eef1367 100755
--- a/tests/xfs/076
+++ b/tests/xfs/076
@@ -55,12 +55,21 @@ _alloc_inodes()
 
 # real QA test starts here
 
-_require_scratch
+if [ -n "$SCRATCH_RTDEV" ]; then
+	# ./check won't know we unset SCRATCH_RTDEV
+	_require_scratch_nocheck
+else
+	_require_scratch
+fi
 _require_xfs_io_command "falloc"
 _require_xfs_io_command "fpunch"
 _require_xfs_sparse_inodes
 
-_scratch_mkfs "-d size=50m -m crc=1 -i sparse" |
+# Disable the scratch rt device to avoid test failures relating to the rt
+# bitmap consuming all the free space in our small data device.
+unset SCRATCH_RTDEV
+
+_scratch_mkfs "-d size=50m -m crc=1 -i sparse" | tee -a $seqres.full |
 	_filter_mkfs > /dev/null 2> $tmp.mkfs
 . $tmp.mkfs	# for isize
 
