Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95255C433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E4BD6528D
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbhCIEjg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 23:39:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:60788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229775AbhCIEjX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 23:39:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A36876523B;
        Tue,  9 Mar 2021 04:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615264762;
        bh=ImKUwqcf+R5uzs/wFuEe9XzHY+rIk8zrOXG/BoP6/x0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Y4oWJJZl480FkaRZjy5Vxk0Saff/ACPWhFOHshDPwoMYSlKGplLf9u4dXV77tFuxP
         OjzgiZrS3m+iF+p04qo3KHPJwOK9KfuEeCEPXCAqtJXQlojda1telGzfOaHcJExQPz
         CcK3rwgzFIFe2TazCKkEsCdpvGebcubhJBN759lJ8YcVLuK9k8yGLyuk3YUJG1ZkQn
         +ZfSTwWyoW5+tqGKQLQIfXQJy7Nb0GHFKjVCoWmyjMHRHhW7ZJa6P46CvSkGNe0AQM
         ZL7hjyF7q9LF0F3m1Mh0Mmd0zZ/xbb2i/jBabqvkW7gevK7p58r8EfBUIzFKGlO5/J
         Mb2Wi/c48fy+w==
Subject: [PATCH 3/4] populate: support compressing metadumps
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 08 Mar 2021 20:39:22 -0800
Message-ID: <161526476250.1212855.18197470277954527515.stgit@magnolia>
In-Reply-To: <161526474588.1212855.9208390435676413014.stgit@magnolia>
References: <161526474588.1212855.9208390435676413014.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If the test runner passed in a DUMP_COMPRESSOR program, make it so that
the metadumps we generate are also compressed.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 README          |    5 +++++
 common/populate |   21 +++++++++++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)


diff --git a/README b/README
index b00328ac..3d369438 100644
--- a/README
+++ b/README
@@ -111,6 +111,11 @@ Preparing system for tests:
                the module is the same as FSTYP.
              - Set DUMP_CORRUPT_FS=1 to record metadata dumps of XFS
                filesystems if a filesystem check fails.
+             - Set DUMP_COMPRESSOR to a compression program to compress
+               metadumps of filesystems.  This program must accept '-f' and the
+               name of a file to compress; and it must accept '-d -f -k' and
+               the name of a file to decompress.  In other words, it must
+               emulate gzip.
 
         - or add a case to the switch in common/config assigning
           these variables based on the hostname of your test
diff --git a/common/populate b/common/populate
index 4e5b645f..b897922c 100644
--- a/common/populate
+++ b/common/populate
@@ -824,6 +824,17 @@ _scratch_populate_cache_tag() {
 _scratch_populate_restore_cached() {
 	local metadump="$1"
 
+	# If we're configured for compressed dumps and there isn't already an
+	# uncompressed dump, see if we can use DUMP_COMPRESSOR to decompress
+	# something.
+	if [ -n "$DUMP_COMPRESSOR" ]; then
+		for compr in "$metadump".*; do
+			[ -e "$compr" ] && $DUMP_COMPRESSOR -d -f -k "$compr" && break
+		done
+	fi
+
+	test -r "$metadump" || return 1
+
 	case "${FSTYP}" in
 	"xfs")
 		xfs_mdrestore "${metadump}" "${SCRATCH_DEV}" && return 0
@@ -855,8 +866,7 @@ _scratch_populate_cached() {
 		rm -rf "${POPULATE_METADUMP}"
 
 	# Try to restore from the metadump
-	test -r "${POPULATE_METADUMP}" && \
-		_scratch_populate_restore_cached "${POPULATE_METADUMP}" && \
+	_scratch_populate_restore_cached "${POPULATE_METADUMP}" && \
 		return
 
 	# Oh well, just create one from scratch
@@ -867,6 +877,13 @@ _scratch_populate_cached() {
 		_scratch_xfs_populate $@
 		_scratch_xfs_populate_check
 		_scratch_xfs_metadump "${POPULATE_METADUMP}"
+
+		local logdev=
+		[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+			logdev=$SCRATCH_LOGDEV
+
+		_xfs_metadump "$POPULATE_METADUMP" "$SCRATCH_DEV" "$logdev" \
+			compress
 		;;
 	"ext2"|"ext3"|"ext4")
 		_scratch_ext4_populate $@

