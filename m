Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03860C7EE43
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 22:29:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239866AbjFFW3N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 18:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234064AbjFFW3K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 18:29:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF934171B;
        Tue,  6 Jun 2023 15:29:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72A4163890;
        Tue,  6 Jun 2023 22:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC2F5C433D2;
        Tue,  6 Jun 2023 22:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686090548;
        bh=E9ACg0jNW06CfVyM44N7k5FKeCubdMgJO1J/qDNgsa4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qrlD1zqLEeVYfXjwH/i8CmlOL0q4zEOkLZ8de24H2XZ86mbZP5f1mBpgLcRjbGQWi
         zRFR6M8YOspaUfKbaJ4mb4Oyos+d70KcaXzDnh4j3gP2rAO1b7YYYUfHdo6G0KU6Qn
         lAmCXsJprI0laG5mnUleMIty1L1JmxHPT4UVN4wKcGgaSMUjWQl4LYAoWb85zWGLf0
         sgm19Rdl/XyqIzqtENI/t6Kocryyjsd3Nu+eivAKlnS2i8TBSNNK+TKVfGcPqO3j3C
         dxJfnnpdufee+rN1XwMAZQYKQGocU73Wk0416Mi9ELZYqD0OB1SaXhZ/iiPmjBTVbZ
         2gxCC4iO1QgZQ==
Subject: [PATCH 1/3] xfs/108: allow slightly higher block usage
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 06 Jun 2023 15:29:08 -0700
Message-ID: <168609054837.2590724.6227482661383718314.stgit@frogsfrogsfrogs>
In-Reply-To: <168609054262.2590724.13871035450315143622.stgit@frogsfrogsfrogs>
References: <168609054262.2590724.13871035450315143622.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

With pmem and fsdax enabled, I occasionally see this test fail on XFS:

   Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
 Disk quotas for User #1 (1)
 Filesystem Blocks Quota Limit Warn/Time Mounted on
-SCRATCH_DEV 48M 0 0 00 [------] SCRATCH_MNT
+SCRATCH_DEV 48.0M 0 0 00 [------] SCRATCH_MNT
 Disk quotas for User #1 (1)
 Filesystem Files Quota Limit Warn/Time Mounted on
 SCRATCH_DEV 3 0 0 00 [------] SCRATCH_MNT

The cause of this failure is fragmentation in the file mappings that
results in a block mapping structure that no longer fits in the inode.
Hence the block usage is 49160K instead of the 49152K that was written.
Use some fugly sed duct tape to make this test accomodate this
possiblity.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/108 |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)


diff --git a/tests/xfs/108 b/tests/xfs/108
index 4607000544..8593edbdd2 100755
--- a/tests/xfs/108
+++ b/tests/xfs/108
@@ -32,6 +32,14 @@ test_files()
 	done
 }
 
+# Some filesystem configurations fragment the file mapping more than others,
+# which leads to the quota block counts being slightly higher than the 48MB
+# written.
+filter_quota()
+{
+	sed -e 's/48\.[01]M/48M/g' | _filter_quota
+}
+
 test_accounting()
 {
 	echo "### some controlled buffered, direct and mmapd IO (type=$type)"
@@ -49,9 +57,9 @@ test_accounting()
 		$here/src/lstat64 $file | head -3 | _filter_scratch
 	done
 	$XFS_IO_PROG -c syncfs $SCRATCH_MNT
-	$XFS_QUOTA_PROG -c "quota -hnb -$type $id" $QARGS | _filter_quota
-	$XFS_QUOTA_PROG -c "quota -hni -$type $id" $QARGS | _filter_quota
-	$XFS_QUOTA_PROG -c "quota -hnr -$type $id" $QARGS | _filter_quota
+	$XFS_QUOTA_PROG -c "quota -hnb -$type $id" $QARGS | filter_quota
+	$XFS_QUOTA_PROG -c "quota -hni -$type $id" $QARGS | filter_quota
+	$XFS_QUOTA_PROG -c "quota -hnr -$type $id" $QARGS | filter_quota
 }
 
 export MOUNT_OPTIONS="-opquota"

