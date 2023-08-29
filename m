Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8EB5C83F1A
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Aug 2023 23:16:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240353AbjH2XQH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 19:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241089AbjH2XQE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 19:16:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CBBDFF;
        Tue, 29 Aug 2023 16:16:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4F0960A66;
        Tue, 29 Aug 2023 23:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C7BC433C8;
        Tue, 29 Aug 2023 23:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693350960;
        bh=nDykhvnUNbg86++3O647MH+yJIDAXbENlCTF6eeim3Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fjvYdk9A23m40dwRkp9DMQYgdjGMdwDNU74NNn4+1OSxZ73w45fN+swYkhQQZJXhw
         3a+6nIEloEoxq9VCGvplr9G0SsjhrCAgyK8GRSEhZeridEW0dYY2DEx4nGPVUDZedN
         WRUQ510qpWi/X+0k2vX1hInORfAVOsBjty+nqtQncYMTJ0yWd5pqGcssS/rbLHSpmE
         wxbOkoB50QKlhcA5LSAt8qyievFTMgrVCDlEo7EHyljd1alelCISJtkmpVo1QFLVwT
         vTF7GfH0KRcx86dOhYv/QiAufLVg6p9vtzC9GjALevVJztUnRjigL1x1o4MLjq9rX+
         LtDkbe6f9D4Vw==
Subject: [PATCH 2/2] generic: only enable io_uring in fsstress explicitly
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 29 Aug 2023 16:15:59 -0700
Message-ID: <169335095953.3534600.16325849760213190849.stgit@frogsfrogsfrogs>
In-Reply-To: <169335094811.3534600.13011878728080983620.stgit@frogsfrogsfrogs>
References: <169335094811.3534600.13011878728080983620.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Don't enable io_uring in fsstress unless someone asks for it explicitly,
just like fsx.  I think both tools should require explicit opt-in to
facilitate A/B testing between the old IO paths and this new one.

While I was playing with fstests+io_uring, I noticed quite a few
regressions in fstests, which fell into two classes:

The first class is umount failing with EBUSY.  Apparently this is due to
the kernel uring code hanging on to file references even after the
userspace program exits.  Tests that run fsstress and immediately
unmount now fail sporadically due to the EBUSY.  Unfortunately, the
metadata update stress tests, the recovery loop tests, the xfs online
fsck functional tests, and the xfs fuzz tests make heavy use of
"fsstress; umount" and they fail all over the place now.

Something's broken, Jens and Christian said it should get fixed, but in
the meantime this is getting in the way of me testing my own code.

The second problem I noticed is that fsstress now lodges complaints
about sporadic heap corruption.  I /think/ this is due to some kind of
memory mishandling bug when uring is active but IO requests fail, but I
haven't had the time to go figure out what's up with that.

Link: https://lore.kernel.org/linux-fsdevel/CAHk-=wj8RuUosugVZk+iqCAq7x6rs=7C-9sUXcO2heu4dCuOVw@mail.gmail.com/
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 ltp/fsstress.c         |   17 ++++++++++++++---
 tests/generic/1220     |   43 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/1220.out |    2 ++
 3 files changed, 59 insertions(+), 3 deletions(-)
 create mode 100755 tests/generic/1220
 create mode 100644 tests/generic/1220.out


diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index abe2874253..f8bb166646 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -339,8 +339,8 @@ struct opdesc	ops[OP_LAST]	= {
 	[OP_TRUNCATE]	   = {"truncate",      truncate_f,	2, 1 },
 	[OP_UNLINK]	   = {"unlink",	       unlink_f,	1, 1 },
 	[OP_UNRESVSP]	   = {"unresvsp",      unresvsp_f,	1, 1 },
-	[OP_URING_READ]	   = {"uring_read",    uring_read_f,	1, 0 },
-	[OP_URING_WRITE]   = {"uring_write",   uring_write_f,	1, 1 },
+	[OP_URING_READ]	   = {"uring_read",    uring_read_f,	-1, 0 },
+	[OP_URING_WRITE]   = {"uring_write",   uring_write_f,	-1, 1 },
 	[OP_WRITE]	   = {"write",	       write_f,		4, 1 },
 	[OP_WRITEV]	   = {"writev",	       writev_f,	4, 1 },
 	[OP_XCHGRANGE]	   = {"xchgrange",     xchgrange_f,	2, 1 },
@@ -507,7 +507,7 @@ int main(int argc, char **argv)
 	xfs_error_injection_t	        err_inj;
 	struct sigaction action;
 	int		loops = 1;
-	const char	*allopts = "cd:e:f:i:l:m:M:n:o:p:rRs:S:vVwx:X:zH";
+	const char	*allopts = "cd:e:f:i:l:m:M:n:o:p:rRs:S:UvVwx:X:zH";
 	long long	duration;
 
 	errrange = errtag = 0;
@@ -603,6 +603,12 @@ int main(int argc, char **argv)
 			printf("\n");
                         nousage=1;
 			break;
+		case 'U':
+			if (ops[OP_URING_READ].freq == -1)
+				ops[OP_URING_READ].freq = 1;
+			if (ops[OP_URING_WRITE].freq == -1)
+				ops[OP_URING_WRITE].freq = 1;
+			break;
 		case 'V':
 			verifiable_log = 1;
 			break;
@@ -640,6 +646,11 @@ int main(int argc, char **argv)
 		}
 	}
 
+	if (ops[OP_URING_READ].freq == -1)
+		ops[OP_URING_READ].freq = 0;
+	if (ops[OP_URING_WRITE].freq == -1)
+		ops[OP_URING_WRITE].freq = 0;
+
         if (!dirname) {
             /* no directory specified */
             if (!nousage) usage();
diff --git a/tests/generic/1220 b/tests/generic/1220
new file mode 100755
index 0000000000..ec8cafba71
--- /dev/null
+++ b/tests/generic/1220
@@ -0,0 +1,43 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2017 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 1220
+#
+# Run an all-writes fsstress run with multiple threads and io_uring to shake
+# out bugs in the write path.
+#
+. ./common/preamble
+_begin_fstest auto rw long_rw stress soak smoketest
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	$KILLALL_PROG -9 fsstress > /dev/null 2>&1
+}
+
+# Import common functions.
+
+# Modify as appropriate.
+_supported_fs generic
+
+_require_scratch
+_require_command "$KILLALL_PROG" "killall"
+
+echo "Silence is golden."
+
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+nr_cpus=$((LOAD_FACTOR * 4))
+nr_ops=$((25000 * nr_cpus * TIME_FACTOR))
+fsstress_args=(-w -d $SCRATCH_MNT -n $nr_ops -p $nr_cpus -U)
+test -n "$SOAK_DURATION" && fsstress_args+=(--duration="$SOAK_DURATION")
+
+$FSSTRESS_PROG $FSSTRESS_AVOID "${fsstress_args[@]}" >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/1220.out b/tests/generic/1220.out
new file mode 100644
index 0000000000..2583a6bf73
--- /dev/null
+++ b/tests/generic/1220.out
@@ -0,0 +1,2 @@
+QA output created by 1220
+Silence is golden.

