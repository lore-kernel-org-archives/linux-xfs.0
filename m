Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65BF7C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 14:47:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44CD9217F5
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 14:47:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731638AbfHZOrS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 10:47:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51978 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729605AbfHZOrR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Aug 2019 10:47:17 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 94262301899A
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 14:47:17 +0000 (UTC)
Received: from pegasus.maiolino.com (ovpn-204-162.brq.redhat.com [10.40.204.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0FAB86092F
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 14:47:16 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RFC] generic 223: Ensure xfs allocator will honor alignment requirements
Date:   Mon, 26 Aug 2019 16:47:12 +0200
Message-Id: <20190826144712.14614-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Mon, 26 Aug 2019 14:47:17 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If the files being allocated during the test do not fit into a single
Allocation Group, XFS allocator may disable alignment requirements
causing the test to fail even though XFS was working as expected.

Fix this by fixing a min AG size, so all files created during the test
will fit into a single AG not disabling XFS alignment requirements.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---

Hi,

I am tagging this patch as a RFC mostly to start a discussion here, regarding
this issue found while running generic/223.

The generic/223 fails when running it with finobt disabled. Specifically, the
last file being fallocated are unaligned.

When the finobt is enabled, the allocator does not try to squeeze partial file
data into small available extents in AG 0, while it does when finobt is
disabled.

Here are the bmap of the same file after generic/223 finishes with and without
finobt:

finobt=0

/mnt/scratch/file-1073745920-falloc:
 EXT: FILE-OFFSET         BLOCK-RANGE      AG AG-OFFSET           TOTAL FLAGS
   0: [0..191]:           320..511          0 (320..511)            192 001011
   1: [192..375]:         64..247           0 (64..247)             184 001111
   2: [376..1287791]:     678400..1965815   0 (678400..1965815) 1287416 000111
   3: [1287792..2097159]: 1966080..2775447  1 (256..809623)      809368 000101


finobt=1

/mnt/scratch/file-1073745920-falloc:
 EXT: FILE-OFFSET         BLOCK-RANGE      AG AG-OFFSET           TOTAL FLAGS
   0: [0..1285831]:       678400..1964231   0 (678400..1964231) 1285832 000111
   1: [1285832..2097159]: 1966080..2777407  1 (256..811583)      811328 000101


I still don't know the details about why the allocator takes different decisions
depending on finobt being used or not, although I believe it's because the extra
space being used in each AG, and the default AG size when running the test, but
I'm still reading the code to try to understand this difference.

Even though I think there might be room for improvement in the XFS allocator
code to avoid this bypass of alignment requirements here, I still think the test
should be fixed to avoid forcing the filesystem to drop alignment constraints
during file allocation which basically invalidate the test, and that's why I
decided to start the discussion with a RFC patch for the test, but sending it to
xfs list instead of fstests.

Comments?

Cheers


 tests/generic/223 | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tests/generic/223 b/tests/generic/223
index dfd8c41b..782651e2 100755
--- a/tests/generic/223
+++ b/tests/generic/223
@@ -34,6 +34,13 @@ _require_xfs_io_command "falloc"
 
 rm -f $seqres.full
 
+# Ensure we won't trick xfs allocator to disable alignment requirements
+if [ "$FSTYP" == "xfs" ]; then
+	mkfs_opts="-d agsize=2g"
+else
+	mkfs_opts=""
+fi
+
 BLOCKSIZE=4096
 
 for SUNIT_K in 8 16 32 64 128; do
@@ -41,7 +48,7 @@ for SUNIT_K in 8 16 32 64 128; do
 	let SUNIT_BLOCKS=$SUNIT_BYTES/$BLOCKSIZE
 
 	echo "=== mkfs with su $SUNIT_BLOCKS blocks x 4 ==="
-	export MKFS_OPTIONS=""
+	export MKFS_OPTIONS=$mkfs_opts
 	_scratch_mkfs_geom $SUNIT_BYTES 4 $BLOCKSIZE >> $seqres.full 2>&1
 	_scratch_mount
 
-- 
2.20.1

