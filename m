Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0A38C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 23:52:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92BAE61057
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 23:52:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344217AbhIBXx2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Sep 2021 19:53:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231311AbhIBXx2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Sep 2021 19:53:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F00A86103A;
        Thu,  2 Sep 2021 23:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630626749;
        bh=akhkseP0HxlKQgboG45vrPGrtJzRdIda17AZwq8T3eo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mQ6zsbDhqNfHhpJ17GnHzOqfqoZxzIx7jjkIgChr03pz2MPSqabhe30A3rielM943
         fcZnVNjpAzJ9fuwYqahcYDK32VfPnndYSTeyCAgTRHMnhoYfjWL9qiCn076Z2UDzae
         +effILwCqHyN2TF3Z141bd1zDagEWBrzwiT3IPcbuARd6URVftxJnaK/Kj9ZvCAZ3U
         UxPh97JOX36mYAg1V5ZJR5frpW8Zuw7mnjLK6SMhkne+ZTffztlUWZ7Ll0G16TBjgY
         9lV3BsM8iNufry2xIy8qT6H5J5r68Z9IDpVnscaJ7ZVPCMjM6wkPrwahi5o/2NeGsJ
         0ue5/V6uTQY+g==
Subject: [PATCH 1/8] ceph: re-tag copy_file_range as being in the copy_range
 group
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Thu, 02 Sep 2021 16:52:28 -0700
Message-ID: <163062674871.1579659.6942799812708963072.stgit@magnolia>
In-Reply-To: <163062674313.1579659.11141504872576317846.stgit@magnolia>
References: <163062674313.1579659.11141504872576317846.stgit@magnolia>
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

