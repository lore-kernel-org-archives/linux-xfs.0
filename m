Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68390C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Apr 2022 08:37:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376776AbiDTIkJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Apr 2022 04:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376768AbiDTIkH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Apr 2022 04:40:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C792029C9B
        for <linux-xfs@vger.kernel.org>; Wed, 20 Apr 2022 01:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650443840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E0ZbzWLWcjCqkijOMrHebJJtfI7mS5vAY5etb8nyWnM=;
        b=IEIRs8aYFrkLpPXw3x9lk/3miTD6JLIi9RsdClMpEdhFIDlZmd0pAqKRpU3lD3WHYxAMyg
        SkigBDfHDj0sVyqjadVKZOGI8KjWxRyUcXSPAI+rDKz6N5jRLaiTK3WHoQZEEcosmyl9Yl
        AI+3M6BcINzjT79mqr83LY/bPvBq6kk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-544-431U5lmxNpiQxkOrAnaDbQ-1; Wed, 20 Apr 2022 04:37:19 -0400
X-MC-Unique: 431U5lmxNpiQxkOrAnaDbQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1355E8038E3;
        Wed, 20 Apr 2022 08:37:19 +0000 (UTC)
Received: from zlang-laptop.redhat.com (ovpn-12-143.pek2.redhat.com [10.72.12.143])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F24740D2969;
        Wed, 20 Apr 2022 08:37:17 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] fstests: avoid dedupe testing blocked on large fs long time
Date:   Wed, 20 Apr 2022 16:36:51 +0800
Message-Id: <20220420083653.1031631-3-zlang@redhat.com>
In-Reply-To: <20220420083653.1031631-1-zlang@redhat.com>
References: <20220420083653.1031631-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When test on large fs (--large-fs), xfstests allocates a large
file in SCRATCH_MNT/ at first. g/559~561 try to dedupe of extents
within the same file, so they'll waste lots of time to deal with
that large file.

So bring in a common function named _duperemove(), which decide if
allow dedupe of extents with in the same file. If specify "same"
or "nosame" in the 1st argument, follow the specified option. Else
use "same" by default except testing on large filesystem.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 common/reflink    | 39 +++++++++++++++++++++++++++++++++++++++
 tests/generic/559 | 10 +++++-----
 tests/generic/560 |  3 +--
 tests/generic/561 |  2 +-
 4 files changed, 46 insertions(+), 8 deletions(-)

diff --git a/common/reflink b/common/reflink
index 76e9cb7d..48136650 100644
--- a/common/reflink
+++ b/common/reflink
@@ -488,3 +488,42 @@ _sweave_reflink_rainbow_delalloc() {
 		_pwrite_byte 0x62 $((blksz * i)) $blksz $dfile.chk
 	done
 }
+
+# Do De-dupe on a directory (or a file). $DUPEREMOVE_PROG is required if you
+# call this function, and -d -r options are recommended.
+#
+# The 1st argument can be used to forcibly decide if dedupe extents with in
+# the same file (better to use "same" if you run on a single file). If it's
+# not set to "same" or "nosame", the function will use "same" by default
+# except testing on large filesystem.
+_duperemove()
+{
+	local dedupe_opt=""
+
+	# Decide if allow dedupe of extents with in the same file. If specify
+	# "same" or "nosame", follow the specified option, else if test on
+	# large filesystem, "nosame" by default.
+	if [ "$1" = "same" ]; then
+		dedupe_opt="same"
+		shift
+	elif [ "$1" = "nosame" ]; then
+		dedupe_opt="nosame"
+		shift
+	elif [ "$LARGE_SCRATCH_DEV" = "yes" ]; then
+		# Don't allow dedupe of extents with in the same file if test
+		# on large filesystem. Due to xfstests pre-alloc a huge size
+		# file to take most fs free space at every test beginning if
+		# --large-fs option is used.
+		dedupe_opt="nosame"
+	fi
+
+	# If above judgements set $dedupe_opt, then use this option, or "same"
+	# by default.
+	if [ -n "$dedupe_opt" ]; then
+		dedupe_opt="--dedupe-options=${dedupe_opt}"
+	else
+		dedupe_opt="--dedupe-options=same"
+	fi
+
+	$DUPEREMOVE_PROG $dedupe_opt "$@"
+}
diff --git a/tests/generic/559 b/tests/generic/559
index 98ab4474..9817013f 100755
--- a/tests/generic/559
+++ b/tests/generic/559
@@ -21,18 +21,18 @@ fssize=$((2 * 1024 * 1024 * 1024))
 _scratch_mkfs_sized $fssize > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 
+testfile="$SCRATCH_MNT/${seq}.file"
 # fill the fs with a big file has same contents
-$XFS_IO_PROG -f -c "pwrite -S 0x55 0 $fssize" $SCRATCH_MNT/${seq}.file \
-	>> $seqres.full 2>&1
-md5sum $SCRATCH_MNT/${seq}.file > ${tmp}.md5sum
+$XFS_IO_PROG -f -c "pwrite -S 0x55 0 $fssize" $testfile >> $seqres.full 2>&1
+md5sum $testfile > ${tmp}.md5sum
 
 echo "= before cycle mount ="
 # Dedupe with 1M blocksize
-$DUPEREMOVE_PROG -dr --dedupe-options=same -b 1048576 $SCRATCH_MNT/ >>$seqres.full 2>&1
+_duperemove -dr -b 1048576 $SCRATCH_MNT/ >>$seqres.full 2>&1
 # Verify integrity
 md5sum -c --quiet ${tmp}.md5sum
 # Dedupe with 64k blocksize
-$DUPEREMOVE_PROG -dr --dedupe-options=same -b 65536 $SCRATCH_MNT/ >>$seqres.full 2>&1
+_duperemove -dr -b 65536 $SCRATCH_MNT/ >>$seqres.full 2>&1
 # Verify integrity again
 md5sum -c --quiet ${tmp}.md5sum
 
diff --git a/tests/generic/560 b/tests/generic/560
index e3f28667..43b32293 100755
--- a/tests/generic/560
+++ b/tests/generic/560
@@ -35,8 +35,7 @@ function iterate_dedup_verify()
 		$FSSTRESS_PROG $fsstress_opts -d $noisedir \
 			       -n 200 -p $((5 * LOAD_FACTOR)) >/dev/null 2>&1
 		# Too many output, so only save error output
-		$DUPEREMOVE_PROG -dr --dedupe-options=same $dupdir \
-			>/dev/null 2>$seqres.full
+		_duperemove same -dr $dupdir >/dev/null 2>$seqres.full
 		md5sum -c --quiet $md5file$index
 		src=$dest
 		dest=$dupdir/$((index + 1))
diff --git a/tests/generic/561 b/tests/generic/561
index 44f07802..1d8109cf 100755
--- a/tests/generic/561
+++ b/tests/generic/561
@@ -67,7 +67,7 @@ for ((i = 0; i < $((2 * LOAD_FACTOR)); i++)); do
 		# dupremove processes in an arbitrary order, which leaves the
 		# memory in an inconsistent state long enough for the assert
 		# to trip.
-		cmd="$DUPEREMOVE_PROG -dr --dedupe-options=same $testdir"
+		cmd="_duperemove -dr $testdir"
 		bash -c "$cmd" >> $seqres.full 2>&1
 	done 2>&1 | sed -e '/Terminated/d' &
 	dedup_pids="$! $dedup_pids"
-- 
2.31.1

