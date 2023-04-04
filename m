Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADB04C761A6
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 23:16:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbjDDXQ6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 19:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235754AbjDDXQ5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 19:16:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B0C1BB;
        Tue,  4 Apr 2023 16:16:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 521F56393D;
        Tue,  4 Apr 2023 23:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D38C433D2;
        Tue,  4 Apr 2023 23:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680650215;
        bh=j+qk8nPYdtuWY+Jy6NATbc9nnNe0iOt+89wCDUIWN5U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=vKmMtF/8ZCXgM2Oi1Q2vcvVmjj8xnfsoqELkd8358dg7bpxJSscmi2AHkAW1oSfx8
         FKeiYy3/JpXAhjdHv7MMeBmN/fMAHW8McpCOU+w754TxNd8fKJQygebG61xuZeDz6F
         t9E8+DDCD93Iw3jBfbexsUEzP4ep4+HH6qHXxIdcbQqOxGVi20zSPzM9He0wae65aW
         U3YvZx8Y4mQKt6PFe2fq650f4FdRXkT0ie2HvYtSdydTBNszCW25Djz3fLy8g8uU0l
         Pa3ijW7DFkNdwtx6wC9o2wYghvfIofB8NfsDXDNp3513SXkXGs2UoJLtRUeehV1EZF
         q7SfmWkf3jwPQ==
Subject: [PATCH 1/3] common/populate: fix btree-format xattr creation on xfs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 04 Apr 2023 16:16:55 -0700
Message-ID: <168065021529.494608.15409038797376185356.stgit@frogsfrogsfrogs>
In-Reply-To: <168065020955.494608.9615705289123811403.stgit@frogsfrogsfrogs>
References: <168065020955.494608.9615705289123811403.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Currently, we set a large number of extended attributes when trying to
force the attr fork to be in BTREE format.  This doesn't work reliably
because userspace has no control over where xattr leaf and dabtree
blocks are mapped, and contiguous mappings can prevent the file from
having a btree format attr fork.

However, we /do/ have one small knob for controlling attr fork mappings
in the form of creating remote value xattrs and then deleting them to
leave holes in the mappings.  Create a separate helper function that
exploits this property to try to create a sparse attr fork with enough
mappings to give us the btree attr fork that we want.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate |   53 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)


diff --git a/common/populate b/common/populate
index b6f510f396..144a3f5186 100644
--- a/common/populate
+++ b/common/populate
@@ -155,6 +155,57 @@ __populate_create_attr() {
 	done
 }
 
+# Create an extended attr structure and ensure that the fork is btree format
+__populate_xfs_create_btree_attr() {
+	local name="$1"
+	local isize="$2"
+	local dblksz="$3"
+	local icore_size="$(_xfs_get_inode_core_bytes $SCRATCH_MNT)"
+	# We need enough extents to guarantee that the attr fork is in btree
+	# format.  Cycling the mount to use xfs_db is too slow, so watch for
+	# when the number of holes that we can punch in the attr fork by
+	# deleting remote xattrs exceeds the number of extent mappings that can
+	# fit in the inode core.
+	local max_nextents="$(((isize - icore_size) / 16))"
+	local nr
+	local i
+	local incr
+	local bigval
+
+	# Add about one block's worth of attrs in betweeen creating punchable
+	# remote value blocks.
+	incr=$(( (dblksz / 16) / 100 * 100 ))
+	bigval="$(perl -e "print \"@\" x $dblksz;")"
+
+	touch "${name}"
+
+	# We cannot control the mapping behaviors of the attr fork leaf and
+	# dabtree blocks, but we do know that remote values are stored in a
+	# single extent, and that those mappings are removed if the xattr is
+	# deleted.
+	#
+	# The extended attribute structure tends to grow from offset zero
+	# upwards, so we try to set up a sparse attr fork mapping by
+	# iteratively creating at least one leaf block's worth of local attrs,
+	# and then one remote attr, until the number of remote xattrs exceeds
+	# the number of mappings that fit in the inode core...
+	for ((nr = 0; nr < (incr * max_nextents); nr += incr)); do
+		# Simulate a getfattr dump file so we can bulk-add attrs.
+		(
+			echo "# file: ${name}";
+			seq --format "user.%08g=\"abcdefgh\"" "${nr}" "$((nr + incr + 1))"
+			echo "user.v$(printf "%.08d" "$nr")=\"${bigval}\""
+			echo
+		) | setfattr --restore -
+	done
+
+	# ... and in the second loop we delete all the remote attrs to
+	# fragment the attr fork mappings.
+	for ((i = 0; i < nr; i += incr)); do
+		setfattr -x "user.v$(printf "%.08d" "$i")" "${name}"
+	done
+}
+
 # Fill up some percentage of the remaining free space
 __populate_fill_fs() {
 	dir="$1"
@@ -327,7 +378,7 @@ _scratch_xfs_populate() {
 
 	# BTREE
 	echo "+ btree attr"
-	__populate_create_attr "${SCRATCH_MNT}/ATTR.FMT_BTREE" "$((64 * blksz / 40))" true
+	__populate_xfs_create_btree_attr "${SCRATCH_MNT}/ATTR.FMT_BTREE" "$isize" "$dblksz"
 
 	# trusted namespace
 	touch ${SCRATCH_MNT}/ATTR.TRUSTED

