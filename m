Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D26C0C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235955AbiLaAtG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:49:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235926AbiLaAtF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:49:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA1621C90A;
        Fri, 30 Dec 2022 16:49:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4610C61D5F;
        Sat, 31 Dec 2022 00:49:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6183C433D2;
        Sat, 31 Dec 2022 00:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447743;
        bh=KzbmAxwxCO5ZCO5hNbka+HNvJXhlESdLL3ljiFmQYUU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Ni4lxEFo68lh6rbBAaW2QLyRXPnDPzRgEdIL21GuGDpcBAXOR3Q0UPdRcvUuX8aVV
         Nv4tJkm899cpc8aoYHQLnX+iPQPC1KrBdlQ8pexFWfEpHACJOIwwz1SZVzHBhb+Tqv
         elcYQ0KyB/t78vyF1tNVTMXls/AtargXJK8WMtAcmZaYkvyoJ86y8xuiJT3bGWGfRG
         AaqtncKXnmr5f2K5io08cBsBSzTDjrk81S0y5Zl3zUrhAQrKEBdGa11DQsLc5qWgQy
         77AG0WKiv2h71rFmlct1VjA0HsjcJlBDzxnWLWL+4Pp+3jUv9UUAVuO/1Q7N7XBmnI
         nyLLzQGC1np9g==
Subject: [PATCH 19/24] common/fuzzy: exercise the filesystem a little harder
 after repairing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:41 -0800
Message-ID: <167243878151.730387.10482590570304640293.stgit@magnolia>
In-Reply-To: <167243877899.730387.9276624623424433346.stgit@magnolia>
References: <167243877899.730387.9276624623424433346.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Use fsstress to exercise the filesystem a little more strenuously after
we've run the fuzzing repair strategy, so that we have a better chance
of tripping over corruption problems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |   36 ++++++++++++------------------------
 1 file changed, 12 insertions(+), 24 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index d841d435eb..3de6f43dc6 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -6,30 +6,18 @@
 
 # Modify various files after a fuzzing operation
 _scratch_fuzz_modify() {
-	nr="$1"
+	echo "+++ stressing filesystem"
+	mkdir -p $SCRATCH_MNT/data
+	_xfs_force_bdev data $SCRATCH_MNT/data
+	$FSSTRESS_PROG -n $((TIME_FACTOR * 10000)) -p $((LOAD_FACTOR * 4)) -d $SCRATCH_MNT/data
 
-	test -z "${nr}" && nr=50000
-	echo "+++ touch ${nr} files"
-	blk_sz=$(stat -f -c '%s' ${SCRATCH_MNT})
-	$XFS_IO_PROG -f -c "pwrite -S 0x63 0 ${blk_sz}" "/tmp/afile" > /dev/null
-	date="$(date)"
-	find "${SCRATCH_MNT}/" -type f 2> /dev/null | head -n "${nr}" | while read f; do
-		# try to remove append, immutable (and even dax) flag if exists
-		$XFS_IO_PROG -rc 'chattr -x -i -a' "$f" > /dev/null 2>&1
-		setfattr -n "user.date" -v "${date}" "$f"
-		cat "/tmp/afile" >> "$f"
-		mv "$f" "$f.longer"
-	done
-	sync
-	rm -rf "/tmp/afile"
-
-	echo "+++ create files"
-	mkdir -p "${SCRATCH_MNT}/test.moo"
-	$XFS_IO_PROG -f -c 'pwrite -S 0x80 0 65536' "${SCRATCH_MNT}/test.moo/urk" > /dev/null
-	sync
-
-	echo "+++ remove files"
-	rm -rf "${SCRATCH_MNT}/test.moo"
+	if _xfs_has_feature "$SCRATCH_MNT" realtime; then
+		mkdir -p $SCRATCH_MNT/rt
+		_xfs_force_bdev realtime $SCRATCH_MNT/rt
+		$FSSTRESS_PROG -n $((TIME_FACTOR * 10000)) -p $((LOAD_FACTOR * 4)) -d $SCRATCH_MNT/rt
+	else
+		echo "+++ xfs realtime not configured"
+	fi
 }
 
 # Try to access files after fuzzing
@@ -429,7 +417,7 @@ _scratch_xfs_fuzz_field_modifyfs() {
 
 	# Try modifying the filesystem again
 	__fuzz_notify "++ Try to write filesystem again"
-	_scratch_fuzz_modify 100 2>&1
+	_scratch_fuzz_modify 2>&1
 
 	# If we didn't repair anything, there's no point in checking further,
 	# the fs is still corrupt.

