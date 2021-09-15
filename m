Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FEB4C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:12:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18761610A6
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:12:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbhIOXN1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:13:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232465AbhIOXN1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:13:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 085DD60E05;
        Wed, 15 Sep 2021 23:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747528;
        bh=1r6itSjeaor1NSB0WAu3Ycree7YLU9eAeoDb4D1bBcc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=q+ihFGIHWprK7tOjW+tDm19b1izeuiKPxAjUzrP/ARjbAQCfq9+nVzsMQCWGbmmeL
         ZV6oWNd1opbqKnCNj1wdOCInH8ysaTpV1kUxhtJxFwZRhu8RrFeKEDnx3G/lyWwIi4
         RinEofKqPDJZyXmQFDECb+MtOg1SyJ5Di6pNLzO1Cob8X6r7vI2eWOWXd2Avl6dWIx
         Lbk6B1m8e+xXOFE6VeaQXNYk05vnKDCkn05+257VPwBZT72dJrzJjEu3sxZJbNx1VA
         xSnN3gmd8J1ENey4p6b3aJ4DcZao34QOY92/XLF3MAlGfxuE1aOv+yXKHXXl/1xeSR
         aFtuggbRtA7qQ==
Subject: [PATCH 61/61] mkfs: warn about V4 deprecation when creating new V4
 filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:12:07 -0700
Message-ID: <163174752777.350433.15312061958254066456.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The V4 filesystem format is deprecated in the upstream Linux kernel.  In
September 2025 it will be turned off by default in the kernel and five
years after that, support will be removed entirely.  Warn people
formatting new filesystems with the old format, particularly since V4 is
not the default.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c |    9 +++++++++
 1 file changed, 9 insertions(+)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 53904677..b8c11ce9 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2103,6 +2103,15 @@ _("Directory ftype field always enabled on CRC enabled filesystems\n"));
 		}
 
 	} else {	/* !crcs_enabled */
+		/*
+		 * The V4 filesystem format is deprecated in the upstream Linux
+		 * kernel.  In September 2025 it will be turned off by default
+		 * in the kernel and in September 2030 support will be removed
+		 * entirely.
+		 */
+		fprintf(stdout,
+_("V4 filesystems are deprecated and will not be supported by future versions.\n"));
+
 		/*
 		 * The kernel doesn't support crc=0,finobt=1 filesystems.
 		 * If crcs are not enabled and the user has not explicitly

