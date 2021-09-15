Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A18A2C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:42:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85CB7610E8
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:42:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbhIOXoD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:44:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233046AbhIOXoC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:44:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3681D60F25;
        Wed, 15 Sep 2021 23:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631749363;
        bh=akhkseP0HxlKQgboG45vrPGrtJzRdIda17AZwq8T3eo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UCYNwoYxK2wHgZvfm4XuISKD5XFvQNvSqKUWdKNu0yS0+Fs8xcve16BX7p9hlLZMQ
         K93cpceW9SKOH0aSKB7ZowA2j9RLqb3BsRLgE6qQTE/9ECEHy7eFV7ZOC/0WWo34F5
         Eu+3s6BKR4tTDBeyU+8Si2UPkXnJeMsAd+Ka5k2xPKQ08EDflGYleP59QVG14nzha4
         ebh2PfeE7jLV3StyBPGMNHsyG57UTX3yn07JbnmmwEfASoXEn03sgjaVveQF8Vph6S
         j83wju+fzT2jx7NoUEVaWhAkXpA6qW9dSDDP5tQYwD2wyw8tGJthzk/lt4IxNlgiyV
         PaRi6kTAV9gSg==
Subject: [PATCH 1/9] ceph: re-tag copy_file_range as being in the copy_range
 group
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Wed, 15 Sep 2021 16:42:42 -0700
Message-ID: <163174936296.380880.5004927987240020121.stgit@magnolia>
In-Reply-To: <163174935747.380880.7635671692624086987.stgit@magnolia>
References: <163174935747.380880.7635671692624086987.stgit@magnolia>
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

