Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48509FA3742
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Oct 2022 17:42:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbiJ1Rmt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Oct 2022 13:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbiJ1Rm2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Oct 2022 13:42:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 476EE239228;
        Fri, 28 Oct 2022 10:42:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D929E629E8;
        Fri, 28 Oct 2022 17:42:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48AC9C433D6;
        Fri, 28 Oct 2022 17:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666978931;
        bh=RxTaVkDsCLZzGO/RDFqrWwUqp+ac6c4zJrkEz+Q3fe0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pogLffJIkmSe6hHyAxOeigThZpu+JvrdiUH3NTB71/bt6KuirwHpH+jvoazptrDDO
         oUA8PgfJC2l4Th1ijR2htyv33Ictght5xoj7KnoMmdFnUqe4nZUNU/6ZUgqXNTidu5
         gL8UJ7zsdKPpnvjZL1I+5D2qdPe5u6Pxb2ddqF2zf+3aL7qd307Q5FVvUYZWe0BSVj
         OVXejAbtPea3aFuy1Wcoa44DjzkvZUeTjAluYe+qv7b1qGy/9+dW2YVp9RtA3n4GBl
         NetstZgL8qfgP+jfftdkowRL3n9dJwtNQYO13tZkkrsBf1LkZviL8lJhiD1XfNs49/
         R0YIRK+0R4maQ==
Subject: [PATCH 4/4] common: simplify grep pipe sed interactions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 28 Oct 2022 10:42:10 -0700
Message-ID: <166697893084.4183768.1057318180034267637.stgit@magnolia>
In-Reply-To: <166697890818.4183768.10822596619783607332.stgit@magnolia>
References: <166697890818.4183768.10822596619783607332.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Zorro pointed out that the idiom "program | grep | sed" isn't necessary
for field extraction -- sed is perfectly capable of performing a
substitution and only printing the lines that match that substitution.
Do that for the common helpers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/ext4     |    9 +++++++++
 common/populate |    4 ++--
 common/xfs      |   11 ++++-------
 3 files changed, 15 insertions(+), 9 deletions(-)


diff --git a/common/ext4 b/common/ext4
index f4c3c4139a..4a2eaa157f 100644
--- a/common/ext4
+++ b/common/ext4
@@ -191,3 +191,12 @@ _scratch_ext4_options()
 	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
 		SCRATCH_OPTIONS="$SCRATCH_OPTIONS ${log_opt}"
 }
+
+# Get the inode flags for a particular inode number
+_ext4_get_inum_iflags() {
+	local dev="$1"
+	local inumber="$2"
+
+	debugfs -R "stat <${inumber}>" "${dev}" 2> /dev/null | \
+			sed -n 's/^.*Flags: \([0-9a-fx]*\).*$/\1/p'
+}
diff --git a/common/populate b/common/populate
index d9d4c6c300..6e00499734 100644
--- a/common/populate
+++ b/common/populate
@@ -641,7 +641,7 @@ __populate_check_ext4_dformat() {
 	extents=0
 	etree=0
 	debugfs -R "stat <${inode}>" "${dev}" 2> /dev/null | grep 'ETB[0-9]' -q && etree=1
-	iflags="$(debugfs -R "stat <${inode}>" "${dev}" 2> /dev/null | grep 'Flags:' | sed -e 's/^.*Flags: \([0-9a-fx]*\).*$/\1/g')"
+	iflags="$(_ext4_get_inum_iflags "${dev}" "${inode}")"
 	test "$(echo "${iflags}" | awk '{print and(strtonum($1), 0x80000);}')" -gt 0 && extents=1
 
 	case "${format}" in
@@ -688,7 +688,7 @@ __populate_check_ext4_dir() {
 
 	htree=0
 	inline=0
-	iflags="$(debugfs -R "stat <${inode}>" "${dev}" 2> /dev/null | grep 'Flags:' | sed -e 's/^.*Flags: \([0-9a-fx]*\).*$/\1/g')"
+	iflags="$(_ext4_get_inum_iflags "${dev}" "${inode}")"
 	test "$(echo "${iflags}" | awk '{print and(strtonum($1), 0x1000);}')" -gt 0 && htree=1
 	test "$(echo "${iflags}" | awk '{print and(strtonum($1), 0x10000000);}')" -gt 0 && inline=1
 
diff --git a/common/xfs b/common/xfs
index a995e0b5da..4f2cd46c91 100644
--- a/common/xfs
+++ b/common/xfs
@@ -179,8 +179,7 @@ _xfs_get_rtextents()
 {
 	local path="$1"
 
-	$XFS_INFO_PROG "$path" | grep 'rtextents' | \
-		sed -e 's/^.*rtextents=\([0-9]*\).*$/\1/g'
+	$XFS_INFO_PROG "$path" | sed -n "s/^.*rtextents=\([[:digit:]]*\).*/\1/p"
 }
 
 # Get the realtime extent size of a mounted filesystem.
@@ -188,8 +187,7 @@ _xfs_get_rtextsize()
 {
 	local path="$1"
 
-	$XFS_INFO_PROG "$path" | grep 'realtime.*extsz' | \
-		sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g'
+	$XFS_INFO_PROG "$path" | sed -n "s/^.*realtime.*extsz=\([[:digit:]]*\).*/\1/p"
 }
 
 # Get the size of an allocation unit of a file.  Normally this is just the
@@ -217,8 +215,7 @@ _xfs_get_dir_blocksize()
 {
 	local fs="$1"
 
-	$XFS_INFO_PROG "$fs" | grep 'naming.*bsize' | \
-		sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g'
+	$XFS_INFO_PROG "$fs" | sed -n "s/^naming.*bsize=\([[:digit:]]*\).*/\1/p"
 }
 
 # Set or clear the realtime status of every supplied path.  The first argument
@@ -1267,7 +1264,7 @@ _force_xfsv4_mount_options()
 # Find AG count of mounted filesystem
 _xfs_mount_agcount()
 {
-	$XFS_INFO_PROG "$1" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g'
+	$XFS_INFO_PROG "$1" | sed -n "s/^.*agcount=\([[:digit:]]*\).*/\1/p"
 }
 
 # Wipe the superblock of each XFS AGs

