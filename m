Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9F3ECE79A5
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Sep 2023 21:42:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233401AbjIYVmy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 17:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbjIYVmx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 17:42:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E7DA3;
        Mon, 25 Sep 2023 14:42:47 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B44C433C8;
        Mon, 25 Sep 2023 21:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695678167;
        bh=bzVMU8+HDmw0PlVtAAevseeZxwX/UiZ8h3KqbgA5KXU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jWlwIS8E0CSxLz5Z/fS40SQTZll2sk0clWk4gsF/wNKPCiiOdbPuGPt5SjUDuM0uE
         SeVFECJlHsSsLE3BlRilWlfj++fJ5jZB7Tr70Yg6rD0TY5bInhmLAuDvK+Zn40oEJt
         FknvgnQu95FNGDRtDcRuIbRfMXJoBQtqE6rIhGTIYrlB0yf7JRegDw8mLIuGyf2w4i
         GgF2ktn7twvOTtTmOI5FKLzKgeZaVh2pXNsKF0hC4M0pdclVWy9p3kAdhqIWuAYz92
         BC7gJ9/4+z89R16mh5reGMBWpUuGoudJqdvnN9WEfj+ELUYbmhnd7uNk6PDnaBxgE3
         e//qvVOb0KDTw==
Subject: [PATCH 1/1] xfs/018: make sure that larp mode actually works
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 25 Sep 2023 14:42:46 -0700
Message-ID: <169567816694.2269819.8230834804621611518.stgit@frogsfrogsfrogs>
In-Reply-To: <169567816120.2269819.5620379594030200785.stgit@frogsfrogsfrogs>
References: <169567816120.2269819.5620379594030200785.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Skip this test if larp mode doesn't work.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/018 |   13 +++++++++++++
 1 file changed, 13 insertions(+)


diff --git a/tests/xfs/018 b/tests/xfs/018
index 1ef51a2e61..73040edc92 100755
--- a/tests/xfs/018
+++ b/tests/xfs/018
@@ -71,6 +71,17 @@ create_test_file()
 	done
 }
 
+require_larp()
+{
+	touch $SCRATCH_MNT/a
+
+	# Set attribute, being careful not to include the trailing newline
+	# in the attr value.
+	echo -n "attr_value" | ${ATTR_PROG} -s "attr_name" $SCRATCH_MNT/a 2>&1 | \
+		grep 'Operation not supported' && \
+		_notrun 'LARP not supported on this filesystem'
+}
+
 # real QA test starts here
 _supported_fs xfs
 
@@ -112,6 +123,8 @@ _scratch_mount
 testdir=$SCRATCH_MNT/testdir
 mkdir $testdir
 
+require_larp
+
 # empty, inline
 create_test_file empty_file1 0
 test_attr_replay empty_file1 "attr_name" $attr64 "s" "larp"

