Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24BECC433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Jan 2022 02:04:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbiADCEW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Jan 2022 21:04:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232160AbiADCEU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jan 2022 21:04:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B216C061761;
        Mon,  3 Jan 2022 18:04:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF24AB81097;
        Tue,  4 Jan 2022 02:04:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F51C36AF0;
        Tue,  4 Jan 2022 02:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641261857;
        bh=M4oQMpSBcdVxpSX/H4SlAyu1Pe03euspvM5jDHQEFjc=;
        h=Date:From:To:Cc:Subject:From;
        b=qt/dLAXmtym6SHfbSUrNXCpUeMYf53Xa3Gmv72LS6+inE93i5Ob8xqte5JsLiruxb
         D8aycCB+5xVORdxRHnpWBBx41P38DuPFR5CZ9oyiHM0/v3V48Dt6lrAXpwIfr6Xve2
         VfHptksTriSgLnnLZJIWioqgYQCSR8yy4rz7YgqwXORwuJA3tr/v7/hXtME8QFUx1m
         SvY7KMlRzWtFtlCB8mQIBaMU8iDUREzHu5huggz67uYNC2k4wiBpTBfXftTIr+WC5i
         YQ3q0l51Y5RkQmGOoyJ6u6ez+hoqjNePOAEzP9x5ntcGkmIJjv/mb+3VYiaIGME7mz
         tAYWi1CKkQwbQ==
Date:   Mon, 3 Jan 2022 18:04:17 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     fstests@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs/014: try a few times to create speculative preallocations
Message-ID: <20220104020417.GB31566@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This test checks that speculative file preallocations are transferred to
threads writing other files when space is low.  Since we have background
threads to clear those preallocations, it's possible that the test
program might not get a speculative preallocation on the first try.

This problem has become more pronounced since the introduction of
background inode inactivation since userspace no longer has direct
control over the timing of file blocks being released from unlinked
files.  As a result, the author has seen an increase in sporadic
warnings from this test about speculative preallocations not appearing.

Therefore, modify the function to try up to five times to create the
speculative preallocation before emitting warnings that then cause
golden output failures.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/014 |   41 +++++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff --git a/tests/xfs/014 b/tests/xfs/014
index a605b359..1f0ebac3 100755
--- a/tests/xfs/014
+++ b/tests/xfs/014
@@ -33,27 +33,36 @@ _cleanup()
 # failure.
 _spec_prealloc_file()
 {
-	file=$1
+	local file=$1
+	local prealloc_size=0
+	local i=0
 
-	rm -f $file
+	# Now that we have background garbage collection processes that can be
+	# triggered by low space/quota conditions, it's possible that we won't
+	# succeed in creating a speculative preallocation on the first try.
+	for ((tries = 0; tries < 5 && prealloc_size == 0; tries++)); do
+		rm -f $file
 
-	# a few file extending open-write-close cycles should be enough to
-	# trigger the fs to retain preallocation. write 256k in 32k intervals to
-	# be sure
-	for i in $(seq 0 32768 262144); do
-		$XFS_IO_PROG -f -c "pwrite $i 32k" $file >> $seqres.full
+		# a few file extending open-write-close cycles should be enough
+		# to trigger the fs to retain preallocation. write 256k in 32k
+		# intervals to be sure
+		for i in $(seq 0 32768 262144); do
+			$XFS_IO_PROG -f -c "pwrite $i 32k" $file >> $seqres.full
+		done
+
+		# write a 4k aligned amount of data to keep the calculations
+		# simple
+		$XFS_IO_PROG -c "pwrite 0 128m" $file >> $seqres.full
+
+		size=`_get_filesize $file`
+		blocks=`stat -c "%b" $file`
+		blocksize=`stat -c "%B" $file`
+
+		prealloc_size=$((blocks * blocksize - size))
 	done
 
-	# write a 4k aligned amount of data to keep the calculations simple
-	$XFS_IO_PROG -c "pwrite 0 128m" $file >> $seqres.full
-
-	size=`_get_filesize $file`
-	blocks=`stat -c "%b" $file`
-	blocksize=`stat -c "%B" $file`
-
-	prealloc_size=$((blocks * blocksize - size))
 	if [ $prealloc_size -eq 0 ]; then
-		echo "Warning: No speculative preallocation for $file." \
+		echo "Warning: No speculative preallocation for $file after $tries iterations." \
 			"Check use of the allocsize= mount option."
 	fi
 
