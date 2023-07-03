Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08B25C30654
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Jul 2023 17:04:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbjGCREF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Jul 2023 13:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbjGCREE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jul 2023 13:04:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED4EE6E;
        Mon,  3 Jul 2023 10:04:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B8F460FED;
        Mon,  3 Jul 2023 17:04:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB16C433C7;
        Mon,  3 Jul 2023 17:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688403841;
        bh=IrK+rwVluqVnFZqxnddEEAKCG/mia1kycmBZhXOzrJU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LFTkX6LZb0CkKZu4O7DmiOwfdf/a51iaSS0qSNBgUZ9xsLK8L9ItN9/fPrWo769Rl
         KoqaR8S5mXIKXhQAghaJEV/zOdVq+BVgvPj8DlkM2IvGAh6FkhG6Odwi44R7eTVqJ5
         ScgO8ISKw4g9TTzeIijUiNepMC1/j+wogto97BoY2oBOv5GAAVDDrHxim4IF1auYyV
         Vuc+YuYL5cPmzs0aiQPGTOeAXixGPc35np3hogmsSALifs43mkpnVZGXrJVVLctfsx
         nKGTOgD7+fD8+LrkhOF6yq51G6q6IRp8qYOylbNSxQi48ov/myqJA4+vyP7D8Dagre
         SXOQLXnPMnSOw==
Subject: [PATCH 5/5] xfs: test growfs of the realtime device
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 03 Jul 2023 10:04:01 -0700
Message-ID: <168840384128.1317961.1554188648447496379.stgit@frogsfrogsfrogs>
In-Reply-To: <168840381298.1317961.1436890061506567407.stgit@frogsfrogsfrogs>
References: <168840381298.1317961.1436890061506567407.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a new test to make sure that growfs on the realtime device works
without corrupting anything.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/934     |   79 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/934.out |   19 +++++++++++++
 2 files changed, 98 insertions(+)
 create mode 100755 tests/xfs/934
 create mode 100644 tests/xfs/934.out


diff --git a/tests/xfs/934 b/tests/xfs/934
new file mode 100755
index 0000000000..f2db4050a7
--- /dev/null
+++ b/tests/xfs/934
@@ -0,0 +1,79 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2000-2002 Silicon Graphics, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 934
+#
+# growfs QA tests - repeatedly fill/grow the rt volume of the filesystem check
+# the filesystem contents after each operation.  This is the rt equivalent of
+# xfs/041.
+#
+. ./common/preamble
+_begin_fstest growfs ioctl auto
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	_scratch_unmount
+	rm -f $tmp.*
+}
+
+# Import common functions.
+. ./common/filter
+
+# real QA test starts here
+_supported_fs xfs
+
+_require_scratch
+_require_realtime
+_require_no_large_scratch_dev
+_scratch_unmount 2>/dev/null
+
+_fill()
+{
+    if [ $# -ne 1 ]; then echo "Usage: _fill \"path\"" 1>&2 ; exit 1; fi
+    _do "Fill filesystem" \
+	"$here/src/fill2fs --verbose --dir=$1 --seed=0 --filesize=65536 --stddev=32768 --list=- >>$tmp.manifest"
+}
+
+_do_die_on_error=message_only
+rtsize=32
+echo -n "Make $rtsize megabyte rt filesystem on SCRATCH_DEV and mount... "
+_scratch_mkfs_xfs -rsize=${rtsize}m | _filter_mkfs 2> "$tmp.mkfs" >> $seqres.full
+test "${PIPESTATUS[0]}" -eq 0 || _fail "mkfs failed"
+
+. $tmp.mkfs
+onemeginblocks=`expr 1048576 / $dbsize`
+_scratch_mount
+
+# We're growing the realtime device, so force new file creation there
+_xfs_force_bdev realtime $SCRATCH_MNT
+
+echo "done"
+
+# full allocation group -> partial; partial -> expand partial + new partial;
+# partial -> expand partial; partial -> full
+# cycle through 33m -> 67m -> 75m -> 96m
+for size in 33 67 75 96
+do
+    grow_size=`expr $size \* $onemeginblocks`
+    _fill $SCRATCH_MNT/fill_$size
+    _do "Grow filesystem to ${size}m" "xfs_growfs -R $grow_size $SCRATCH_MNT"
+    echo -n "Flush filesystem... "
+    _do "_scratch_unmount"
+    _do "_try_scratch_mount"
+    echo "done"
+    echo -n "Check files... "
+    if ! _do "$here/src/fill2fs_check $tmp.manifest"; then
+      echo "fail (see $seqres.full)"
+      _do "cat $tmp.manifest"
+      _do "ls -altrR $SCRATCH_MNT"
+      status=1 ; exit
+    fi
+    echo "done"
+done
+
+# success, all done
+echo "Growfs tests passed."
+status=0 ; exit
diff --git a/tests/xfs/934.out b/tests/xfs/934.out
new file mode 100644
index 0000000000..07da1eb7cb
--- /dev/null
+++ b/tests/xfs/934.out
@@ -0,0 +1,19 @@
+QA output created by 934
+Make 32 megabyte rt filesystem on SCRATCH_DEV and mount... done
+Fill filesystem... done
+Grow filesystem to 33m... done
+Flush filesystem... done
+Check files... done
+Fill filesystem... done
+Grow filesystem to 67m... done
+Flush filesystem... done
+Check files... done
+Fill filesystem... done
+Grow filesystem to 75m... done
+Flush filesystem... done
+Check files... done
+Fill filesystem... done
+Grow filesystem to 96m... done
+Flush filesystem... done
+Check files... done
+Growfs tests passed.

