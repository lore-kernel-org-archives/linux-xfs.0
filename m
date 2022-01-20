Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7D5DC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:23:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345193AbiATAXG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:23:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345140AbiATAXF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:23:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D14C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:23:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 705B8B81911
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20CC6C004E1;
        Thu, 20 Jan 2022 00:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638183;
        bh=QgZnbGTEBqGHrvwLn99e0Q/ElJFVSKNRRvAxLp81QZI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NBX7W4FU1uQUbh+VTQ8ezR6dQlZT+peWAPBty9zCNsRJfNo3a6bCdVogW5TLuwzd2
         Pyz7Z0NxeR8A88PUGB+arz3kAMX6i9jf6g5U1T5HDpvHEjkB+jJqjkACVjLqp212Xm
         5Xc3+1DaK24ro6t6fCa6pPkPjQ6qwaeUuymeacPDBByMOZbuj/MZ5P+8d9kIicC4n/
         ilLxJHrC/kL6Bme5+oSBHKBc9wXMDNzz3XraIOLSnUUii/echKHjoSb2NnbSVP8rhn
         9jD7i+gc5fR6H1hUsN5FP/X3SmtpAkxBFvFh5MXhpJBFQkEwi8jPRb8JdIteZGVu56
         FdnsPSpLwWXmA==
Subject: [PATCH 16/17] mkfs: add a config file for x86_64 pmem filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Date:   Wed, 19 Jan 2022 16:23:02 -0800
Message-ID: <164263818283.863810.4750810429299999067.stgit@magnolia>
In-Reply-To: <164263809453.863810.8908193461297738491.stgit@magnolia>
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

We have a handful of users who continually ping the maintainer with
questions about why pmem and dax don't work quite the way they want
(which is to say 2MB extents and PMD mappings) because they copy-pasted
some garbage from Google that's wrong.  Encode the correct defaults into
a mkfs config file and ship that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/Makefile        |    1 +
 mkfs/dax_x86_64.conf |   19 +++++++++++++++++++
 2 files changed, 20 insertions(+)
 create mode 100644 mkfs/dax_x86_64.conf


diff --git a/mkfs/Makefile b/mkfs/Makefile
index 0aaf9d06..55d9362f 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -10,6 +10,7 @@ LTCOMMAND = mkfs.xfs
 HFILES =
 CFILES = proto.c xfs_mkfs.c
 CFGFILES = \
+	dax_x86_64.conf \
 	lts_4.19.conf \
 	lts_5.4.conf \
 	lts_5.10.conf \
diff --git a/mkfs/dax_x86_64.conf b/mkfs/dax_x86_64.conf
new file mode 100644
index 00000000..bc3f3c9a
--- /dev/null
+++ b/mkfs/dax_x86_64.conf
@@ -0,0 +1,19 @@
+# mkfs.xfs configuration file for persistent memory on x86_64.
+# Block size must match page size (4K) and we require V5 for the DAX inode
+# flag.  Set extent size hints and stripe units to encourage the filesystem to
+# allocate PMD sized (2MB) blocks.
+
+[block]
+size=4096
+
+[metadata]
+crc=1
+
+[data]
+sunit=4096
+swidth=4096
+extszinherit=512
+daxinherit=1
+
+[realtime]
+extsize=2097152

