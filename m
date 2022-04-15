Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55AA7C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Apr 2022 15:05:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbiDOPHz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Apr 2022 11:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354853AbiDOPHc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Apr 2022 11:07:32 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E2FE96;
        Fri, 15 Apr 2022 08:05:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8A42DCE2F02;
        Fri, 15 Apr 2022 15:05:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD9FC385A6;
        Fri, 15 Apr 2022 15:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650035099;
        bh=AwOoNkYD+52+J9w5NV6uJMgTfYsdXalIqNx6hE/JtVE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LYML4mH8PWSUd9Oz2pDtLzjnlEVHNUwjrASbiktaAYhF2VCpmjTDPF9yU66z1GINN
         fMdExsH+DwxLR+lSgg+P9vYayVaZjdqMhDGiIHLZEM2WKUgXlbXsAeAQdKTJavZnEU
         t+ergMsK3tesV5XsI+HhaRLBL49UrBVQkk4DjPu7rfXzniiTV8aQh27gWl72ycKZBe
         GQeUwb8KkRR9bxt7D/hvsDcS811wd3BNTgVDiVdJsLwlaC4tyLR8M9LSe/CD4yuiAh
         svmR2NVlkzTqEWVxkhtZ/DS86Rn7jYTAbuZt0Ga/w4XlY5rKKGnZ+pGzqnppCJ/ct7
         nQGuH5/GiYdMw==
Date:   Fri, 15 Apr 2022 08:04:58 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: [PATCH v1.1 3/3] xfs/216: handle larger log sizes
Message-ID: <20220415150458.GB17025@magnolia>
References: <164971769710.170109.8985299417765876269.stgit@magnolia>
 <164971771391.170109.16368399851366024102.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164971771391.170109.16368399851366024102.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

mkfs will soon refuse to format a log smaller than 64MB, so update this
test to reflect the new log sizing calculations.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/216             |   19 +++++++++++++++++++
 tests/xfs/216.out.64mblog |   10 ++++++++++
 tests/xfs/216.out.classic |    0 
 3 files changed, 29 insertions(+)
 create mode 100644 tests/xfs/216.out.64mblog
 rename tests/xfs/{216.out => 216.out.classic} (100%)

diff --git a/tests/xfs/216 b/tests/xfs/216
index c3697db7..ebae8979 100755
--- a/tests/xfs/216
+++ b/tests/xfs/216
@@ -29,6 +29,23 @@ $MKFS_XFS_PROG 2>&1 | grep -q rmapbt && \
 $MKFS_XFS_PROG 2>&1 | grep -q reflink && \
 	loop_mkfs_opts="$loop_mkfs_opts -m reflink=0"
 
+# Decide which golden output file we're using.  Starting with mkfs.xfs 5.15,
+# the default minimum log size was raised to 64MB for all cases, so we detect
+# that by test-formatting with a 512M filesystem.  This is a little handwavy,
+# but it's the best we can do.
+choose_golden_output() {
+	local seqfull=$1
+	local file=$2
+
+	if $MKFS_XFS_PROG -f -b size=4096 -l version=2 \
+			-d name=$file,size=512m $loop_mkfs_opts | \
+			grep -q 'log.*blocks=16384'; then
+		ln -f -s $seqfull.out.64mblog $seqfull.out
+	else
+		ln -f -s $seqfull.out.classic $seqfull.out
+	fi
+}
+
 _do_mkfs()
 {
 	for i in $*; do
@@ -43,6 +60,8 @@ _do_mkfs()
 # make large holey file
 $XFS_IO_PROG -f -c "truncate 256g" $LOOP_DEV
 
+choose_golden_output $0 $LOOP_DEV
+
 #make loopback mount dir
 mkdir $LOOP_MNT
 
diff --git a/tests/xfs/216.out.64mblog b/tests/xfs/216.out.64mblog
new file mode 100644
index 00000000..3c12085f
--- /dev/null
+++ b/tests/xfs/216.out.64mblog
@@ -0,0 +1,10 @@
+QA output created by 216
+fssize=1g log      =internal log           bsize=4096   blocks=16384, version=2
+fssize=2g log      =internal log           bsize=4096   blocks=16384, version=2
+fssize=4g log      =internal log           bsize=4096   blocks=16384, version=2
+fssize=8g log      =internal log           bsize=4096   blocks=16384, version=2
+fssize=16g log      =internal log           bsize=4096   blocks=16384, version=2
+fssize=32g log      =internal log           bsize=4096   blocks=16384, version=2
+fssize=64g log      =internal log           bsize=4096   blocks=16384, version=2
+fssize=128g log      =internal log           bsize=4096   blocks=16384, version=2
+fssize=256g log      =internal log           bsize=4096   blocks=32768, version=2
diff --git a/tests/xfs/216.out b/tests/xfs/216.out.classic
similarity index 100%
rename from tests/xfs/216.out
rename to tests/xfs/216.out.classic
