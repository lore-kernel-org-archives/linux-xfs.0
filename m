Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74515C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:41:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D237610CC
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:41:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236205AbhINCnB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 22:43:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:53450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234374AbhINCnA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 22:43:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F6D6610F9;
        Tue, 14 Sep 2021 02:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631587304;
        bh=TWOw9M4Kcvvpw2DQ+GNR1cnlFYnJX1WF5J3B2SGkXpg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RFlofdo1K3oUIg4t0f5vNfzB8PwL0nYDh6jd9UO9G4+pW8Ca3EpWtYoPqLFZuyC0h
         p6NRtfMtLIbXO6a70d5QEEmdzKjvg3ut3i3FqdOjqPztM0f7mTYEEzZmydISDqvKHG
         L+AlsmEVGLAgKFPChafyRz182Cc1jcoTiBZ9i1fAkXAbOVEbPrhZULiHTnyRwbQqSx
         +n5yCUM5GHcirmbeUJYCvhMOSlVwI5qd7XbPbOqU11MU9a6wSHGi26zNNBz6MZbYHJ
         spIORx/K5mOXkW8XHy8FhVr/mXOfp6LwLAz05dR/65pqHFIHluTSajDBmlY/kYKMJt
         o/vfIFPDkkaoA==
Subject: [PATCH 19/43] xfs: resolve fork names in trace output
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        linux-xfs@vger.kernel.org
Date:   Mon, 13 Sep 2021 19:41:43 -0700
Message-ID: <163158730380.1604118.14813924693730762538.stgit@magnolia>
In-Reply-To: <163158719952.1604118.14415288328687941574.stgit@magnolia>
References: <163158719952.1604118.14415288328687941574.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: f93f85f77aa80f3e4d5bada01248c98da32933c5

Emit whichfork values as text strings in the ftrace output.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_types.h |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index 0870ef6f..b6da06b4 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -87,6 +87,11 @@ typedef void *		xfs_failaddr_t;
 #define	XFS_ATTR_FORK	1
 #define	XFS_COW_FORK	2
 
+#define XFS_WHICHFORK_STRINGS \
+	{ XFS_DATA_FORK, 	"data" }, \
+	{ XFS_ATTR_FORK,	"attr" }, \
+	{ XFS_COW_FORK,		"cow" }
+
 /*
  * Min numbers of data/attr fork btree root pointers.
  */

