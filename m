Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABAAEC25B06
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Aug 2022 16:29:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239125AbiHDQ3Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 12:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237992AbiHDQ3T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 12:29:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1F36A480;
        Thu,  4 Aug 2022 09:29:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7C00B8264C;
        Thu,  4 Aug 2022 16:29:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C39C433C1;
        Thu,  4 Aug 2022 16:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659630542;
        bh=MZmFy+yL1qce8KzTGM2qNnoDFOQq/XztNHGKqADtvac=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mAvwC498CPXNVBB1UlLiWT3cUeZiWAejcsQPuRDRoprDeKfRrnNnvCdocEw7DtrQA
         1zrBpi0PyMtWChXEjqft0XX5W5HIHHHdLkPGioFJJ+ICUK8Tr5lV1m2CZzDb77sMdF
         Y2KDr1VNsTN9hW67AnmTG1EjO0cpacQhgzpQ3z5O0AUZRDYvPxFOsiDU4FjJKDFtTj
         7b5cF3J4aNsrZJ01Hu65XHGjgfStu6LIR4xe7lFpFQqgeHAyipcMVq+Ub0sVjr9k2w
         s0Aig185NKuDt4zo4yYA8/s9FqfF45KmWccZXFQR3FKIYZcv5sxnozImWC+0PTAEku
         tg+yO3iNVMsHQ==
Date:   Thu, 4 Aug 2022 09:29:01 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        tytso@mit.edu, linux-ext4@vger.kernel.org
Subject: [PATCH v1.3 3/3] common/ext4: provide custom ext4 scratch fs options
Message-ID: <YuvzzdisuzXKVlJK@magnolia>
References: <165950050051.198922.13423077997881086438.stgit@magnolia>
 <165950051745.198922.6487109955066878945.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165950051745.198922.6487109955066878945.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a _scratch_options backend for ext* so that we can inject
pathnames to external log devices into the scratch fs mount options.
This enables common/dm* to install block device filters, e.g. dm-error
for stress testing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
v1.1: bad at counting
v1.2: refactor _scratch_mkfs_ext4 to use _scratch_options too
v1.3: quiet down realpath usage when SCRATCH_LOGDEV is unset
---
 common/ext4 |   35 ++++++++++++++++++++++++++++++++---
 common/rc   |    3 +++
 2 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/common/ext4 b/common/ext4
index 287705af..f2df888c 100644
--- a/common/ext4
+++ b/common/ext4
@@ -63,16 +63,24 @@ _setup_large_ext4_fs()
 	return 0
 }
 
+_scratch_mkfs_ext4_opts()
+{
+	mkfs_opts=$*
+
+	_scratch_options mkfs
+
+	echo "$MKFS_EXT4_PROG $SCRATCH_OPTIONS $mkfs_opts"
+}
+
 _scratch_mkfs_ext4()
 {
-	local mkfs_cmd="$MKFS_EXT4_PROG -F"
+	local mkfs_cmd="`_scratch_mkfs_ext4_opts`"
 	local mkfs_filter="grep -v -e ^Warning: -e \"^mke2fs \" | grep -v \"^$\""
 	local tmp=`mktemp -u`
 	local mkfs_status
 
 	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
-	    $mkfs_cmd -O journal_dev $MKFS_OPTIONS $SCRATCH_LOGDEV && \
-	    mkfs_cmd="$mkfs_cmd -J device=$SCRATCH_LOGDEV"
+	    $MKFS_EXT4_PROG -F -O journal_dev $MKFS_OPTIONS $SCRATCH_LOGDEV
 
 	_scratch_do_mkfs "$mkfs_cmd" "$mkfs_filter" $* 2>$tmp.mkfserr 1>$tmp.mkfsstd
 	mkfs_status=$?
@@ -154,3 +162,24 @@ _require_scratch_richacl_ext4()
 		|| _notrun "kernel doesn't support richacl feature on $FSTYP"
 	_scratch_unmount
 }
+
+_scratch_ext4_options()
+{
+	local type=$1
+	local log_opt=""
+
+	case $type in
+	mkfs)
+		SCRATCH_OPTIONS="$SCRATCH_OPTIONS -F"
+		log_opt="-J device=$SCRATCH_LOGDEV"
+		;;
+	mount)
+		# As of kernel 5.19, the kernel mount option path parser only
+		# accepts direct paths to block devices--the final path
+		# component cannot be a symlink.
+		log_opt="-o journal_path=$(realpath -q "$SCRATCH_LOGDEV")"
+		;;
+	esac
+	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+		SCRATCH_OPTIONS="$SCRATCH_OPTIONS ${log_opt}"
+}
diff --git a/common/rc b/common/rc
index dc1d65c3..b82bb36b 100644
--- a/common/rc
+++ b/common/rc
@@ -178,6 +178,9 @@ _scratch_options()
     "xfs")
 	_scratch_xfs_options "$@"
 	;;
+    ext2|ext3|ext4|ext4dev)
+	_scratch_ext4_options "$@"
+	;;
     esac
 }
 
