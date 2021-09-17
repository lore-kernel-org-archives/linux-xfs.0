Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28E21C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 00:39:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09920611EE
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 00:39:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241596AbhIQAka (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 20:40:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:34764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234517AbhIQAk3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Sep 2021 20:40:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD7FC611C8;
        Fri, 17 Sep 2021 00:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631839148;
        bh=kOSpyIj4lzjFzcf7WA7rDbUepgCj8tzFjN/ltqZ6ilA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YKYZJwb8gkWHM8Y6TGz5uniYoXyGaSpcxClbjR0ChnWX4ioqG1eCvW7JpnthDiIPl
         K0Laj9Zvq8d7ICvsjAZtiZE2Ct7Vbc7QqLqDeYhDOuUfw+eBWoGim9+9sn5YKtjvDq
         U3lvJd6EwhSjYP7Jzy+Nd5ovgXISjgFg42BVMs4Lve1NMUk4+UyINiADujz3+G4ZcD
         9RoyOAOuSGawRNurJUA1dx/X4Z3FOQbupbk/bsKeVAyjljQKr38Y6/cOpbpPMJAUaR
         c6daJSo6zkeqbxuXaFadNVnO/iVavoGdsOmIBiM1vKTG8FI1/P271ftSAL8iYByYoR
         zb44ltrrmm3MQ==
Subject: [PATCH 1/8] ceph: re-tag copy_file_range as being in the copy_range
 group
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Christoph Hellwig <hch@lst.de>,
        Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Thu, 16 Sep 2021 17:39:08 -0700
Message-ID: <163183914850.952957.5053687136584864418.stgit@magnolia>
In-Reply-To: <163183914290.952957.11558799225344566504.stgit@magnolia>
References: <163183914290.952957.11558799225344566504.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

copy_range is the group name for copy_file_range tests, so reclassify
these tests.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/ceph/001 |    2 +-
 tests/ceph/002 |    2 +-
 tests/ceph/003 |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/tests/ceph/001 b/tests/ceph/001
index aca77168..c00de308 100755
--- a/tests/ceph/001
+++ b/tests/ceph/001
@@ -11,7 +11,7 @@
 # file and 3) the middle of the dst file.
 #
 . ./common/preamble
-_begin_fstest auto quick copy
+_begin_fstest auto quick copy_range
 
 # get standard environment
 . common/filter
diff --git a/tests/ceph/002 b/tests/ceph/002
index 428f23a9..9bc728fd 100755
--- a/tests/ceph/002
+++ b/tests/ceph/002
@@ -20,7 +20,7 @@
 #   linux kernel: 78beb0ff2fec ("ceph: use copy-from2 op in copy_file_range")
 #
 . ./common/preamble
-_begin_fstest auto quick copy
+_begin_fstest auto quick copy_range
 
 # get standard environment
 . common/filter
diff --git a/tests/ceph/003 b/tests/ceph/003
index 9f8c6068..faedb48c 100755
--- a/tests/ceph/003
+++ b/tests/ceph/003
@@ -7,7 +7,7 @@
 # Test copy_file_range with infile = outfile
 #
 . ./common/preamble
-_begin_fstest auto quick copy
+_begin_fstest auto quick copy_range
 
 # get standard environment
 . common/filter

