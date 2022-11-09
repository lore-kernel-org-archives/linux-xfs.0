Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E4C7C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 02:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiKICHQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 21:07:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiKICHP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 21:07:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89FF68687
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 18:07:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 960B2B81CF4
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 02:07:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42AF7C433D7;
        Wed,  9 Nov 2022 02:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959632;
        bh=OO1INIrpAEtRSWqjJ4QRES5SjbhvEkOIun18VAa1XKY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XYscSKlqdzy13VNW8JemfcAGOLQVUO5oLgXl6eRgucaCwR2J6zl3FM6fjKmX9PMEO
         /YKPuOEw2fejzXyveJMj+B2I7rMcR2lVr9bXoBK640Cw8rUxPKQbHNaKviB2XKJUJH
         7dYSpMPsbdPfWOJyMBcUKMXEQBtZoeL4psl9txBYDREJpQzYpLj+rwj5FZGhXZmNj/
         NVmzpm2dhIY1XLoc0qalU4YZ+Pv8eCU6Yb+YwO+W90dLKpfXSfmtxt/TZwRDREfJ2w
         +hO1AHnfGKYMEa5rwB+2M6A30bXMJcV97vrb/wvz42yAI2WDOtNfbjtIVaHdRzQd/B
         fWxyzZWXyGhjw==
Subject: [PATCH 16/24] xfs: report refcount domain in tracepoints
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Tue, 08 Nov 2022 18:07:11 -0800
Message-ID: <166795963186.3761583.1303087482752452396.stgit@magnolia>
In-Reply-To: <166795954256.3761583.3551179546135782562.stgit@magnolia>
References: <166795954256.3761583.3551179546135782562.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 440759208b71e1854dfcb332434f9a41e9c8e432

Now that we've broken out the startblock and shared/cow domain in the
incore refcount extent record structure, update the tracepoints to
report the domain.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_types.h |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index eb9a98338b..5ebdda7e10 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -171,6 +171,10 @@ enum xfs_refc_domain {
 	XFS_REFC_DOMAIN_COW,
 };
 
+#define XFS_REFC_DOMAIN_STRINGS \
+	{ XFS_REFC_DOMAIN_SHARED,	"shared" }, \
+	{ XFS_REFC_DOMAIN_COW,		"cow" }
+
 struct xfs_refcount_irec {
 	xfs_agblock_t	rc_startblock;	/* starting block number */
 	xfs_extlen_t	rc_blockcount;	/* count of free blocks */

