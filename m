Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5AD8C07E95
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Jul 2021 02:58:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC0B761424
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Jul 2021 02:58:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbhGCDAg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Jul 2021 23:00:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:59664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230353AbhGCDAf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Jul 2021 23:00:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC0BA61416;
        Sat,  3 Jul 2021 02:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625281083;
        bh=FzwfnMUDK7HkCCprbTa04LM8HqE3B+LpqR7A2vrJRFM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EIEtZiqE+13qc4vIRadjRwycj4Wrfei61FoRVu7Woq52eaL4ct9GhWXuJ8kT61QQV
         dtzMun52uDh6VtAaovY6IEB2/G2CCK2ZXrJ092rdmlGVaoUc4dryeSdxPfKXZAOcBs
         pyvtA96mxL0ScGSRDVwC813lTCQi9rNaqfgyDyBeonKJq23QWp6XZsjgutkNLHeYsw
         KzKF405VJODxg45Df9HtGV4SGuB6CHMmxUzwt9pya5BbJhPfzNJgRvZ5ey9ES8EUsI
         /AtlzWaQ4PZSfkWinh7Wthn3UVzAZZC+C9YoQcspgO6Lcuq3spCv2mz/Fle3QIuNY1
         fb2M+wNYuGYDg==
Subject: [PATCH 1/2] xfs_io: fix broken funshare_cmd usage
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 02 Jul 2021 19:58:02 -0700
Message-ID: <162528108265.36401.17169382978840037158.stgit@locust>
In-Reply-To: <162528107717.36401.11135745343336506049.stgit@locust>
References: <162528107717.36401.11135745343336506049.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a funshare_cmd and use that to store information about the
xfs_io funshare command instead of overwriting the contents of
fzero_cmd.  This fixes confusing output like:

$ xfs_io -c 'fzero 2 3 --help' /
fzero: invalid option -- '-'
funshare off len -- unshares shared blocks within the range

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/prealloc.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)


diff --git a/io/prealloc.c b/io/prealloc.c
index 382e8119..2ae8afe9 100644
--- a/io/prealloc.c
+++ b/io/prealloc.c
@@ -43,6 +43,7 @@ static cmdinfo_t fpunch_cmd;
 static cmdinfo_t fcollapse_cmd;
 static cmdinfo_t finsert_cmd;
 static cmdinfo_t fzero_cmd;
+static cmdinfo_t funshare_cmd;
 #endif
 
 static int
@@ -467,14 +468,14 @@ prealloc_init(void)
 	_("zeroes space and eliminates holes by preallocating");
 	add_command(&fzero_cmd);
 
-	fzero_cmd.name = "funshare";
-	fzero_cmd.cfunc = funshare_f;
-	fzero_cmd.argmin = 2;
-	fzero_cmd.argmax = 2;
-	fzero_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
-	fzero_cmd.args = _("off len");
-	fzero_cmd.oneline =
+	funshare_cmd.name = "funshare";
+	funshare_cmd.cfunc = funshare_f;
+	funshare_cmd.argmin = 2;
+	funshare_cmd.argmax = 2;
+	funshare_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
+	funshare_cmd.args = _("off len");
+	funshare_cmd.oneline =
 	_("unshares shared blocks within the range");
-	add_command(&fzero_cmd);
+	add_command(&funshare_cmd);
 #endif	/* HAVE_FALLOCATE */
 }

