Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B693C433E6
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 05:34:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD0F364EB1
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 05:34:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbhBMFeV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 13 Feb 2021 00:34:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:56230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230431AbhBMFeS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 13 Feb 2021 00:34:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A828264E8D;
        Sat, 13 Feb 2021 05:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613194417;
        bh=GDWjU4DCIze5DwS4eYYYPuxPlGnlspEYDBe52dhwOH8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lD4XbdPbVEpMXZP9uZdjB2HXKjmIoS7AAMgQM3AwAv+XC5AX5kNpsDWMF2NKtVZ4f
         Ko48CGNMWBMO672CmzBztXODRl4Pi4WLDW+D411wID0RMpk2MXrJXX1qQKCiJfXZks
         JkanEpD966ff1jj0NP3/Sr/uz+TBrtB7Jrnc/rRtbTUeU48U4O022G5iEXA93923f6
         ifTEndcFU6u2J/44gQyMONiUkXjZKrFb8nOf9VGMCWroMwukDMrReqyjbVU3OP+Yw6
         /OH2SQmszDlUHtAAvvsLIVPnbaGaAh2ySSIdhLCc6enRPyGsfc6BqWuCkSD6/bNzJ7
         SU7GXyhkGuOGg==
Subject: [PATCH 1/3] xfs/{010,030}: update repair output to deal with
 inobtcount feature
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Fri, 12 Feb 2021 21:33:37 -0800
Message-ID: <161319441737.403510.17676442588323841952.stgit@magnolia>
In-Reply-To: <161319441183.403510.7352964287278809555.stgit@magnolia>
References: <161319441183.403510.7352964287278809555.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Update both of these tests to filter out the new error messages from
repair when the inode btree counter feature is enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 tests/xfs/010 |    3 ++-
 tests/xfs/030 |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/010 b/tests/xfs/010
index 1f9bcdff..95cc2555 100755
--- a/tests/xfs/010
+++ b/tests/xfs/010
@@ -113,7 +113,8 @@ _check_scratch_fs
 _corrupt_finobt_root $SCRATCH_DEV
 
 filter_finobt_repair() {
-	sed -e '/^agi has bad CRC/d' | \
+	sed -e '/^agi has bad CRC/d' \
+	    -e '/^bad finobt block/d' | \
 		_filter_repair_lostblocks
 }
 
diff --git a/tests/xfs/030 b/tests/xfs/030
index 04440f9c..906d9019 100755
--- a/tests/xfs/030
+++ b/tests/xfs/030
@@ -44,6 +44,8 @@ _check_ag()
 			    -e '/^bad agbno AGBNO for refcntbt/d' \
 			    -e '/^agf has bad CRC/d' \
 			    -e '/^agi has bad CRC/d' \
+			    -e '/^bad inobt block count/d' \
+			    -e '/^bad finobt block count/d' \
 			    -e '/^Missing reverse-mapping record.*/d' \
 			    -e '/^bad levels LEVELS for [a-z]* root.*/d' \
 			    -e '/^unknown block state, ag AGNO, block.*/d'

