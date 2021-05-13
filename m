Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EDD3C433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 01:01:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF1C361090
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 01:01:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232965AbhEMBCn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 21:02:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232858AbhEMBCn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 May 2021 21:02:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C79061090;
        Thu, 13 May 2021 01:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620867694;
        bh=/DHcte+PMQ+wnFUF2UTdXzrlmOokzqKLPCu4Cubjq14=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tX7fWXtvM5lZYaWv7kk8VBnhK4/YdfuaVFZWUECyZjbSipHG4pznocyKfAMimovp5
         /yBgnbistAqMV+afMTYW4xak+Ra9sQuovW7hjDz5GGh0VTAQ+PNMhh7RBkUmP2spIT
         vT8SqtMDpEkdyq+NfG/XeePcbHvMqvalFfaYsNEy93/6VjIK154uorK4SR7F/B+z8Q
         Hkh5YkP0IbR6is3RC5BnTTndFzwF0SYVIJycc7XfTvT88lAaphVbYfY1WKsYS692Ab
         bLPOwqDmtLRxGSECz/BnIqsfOsXGgbb0vK2UwmItQ47KZSXPytRrtK6hDIDuvvzfbx
         fiwviH4ZE591w==
Subject: [PATCH 1/2] xfs: fix deadlock retry tracepoint arguments
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 12 May 2021 18:01:34 -0700
Message-ID: <162086769410.3685697.9016566085994934364.stgit@magnolia>
In-Reply-To: <162086768823.3685697.11936501771461638870.stgit@magnolia>
References: <162086768823.3685697.11936501771461638870.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

sc->ip is the inode that's being scrubbed, which means that it's not set
for scrub types that don't involve inodes.  If one of those scrubbers
(e.g. inode btrees) returns EDEADLOCK, we'll trip over the null pointer.
Fix that by reporting either the file being examined or the file that
was used to call scrub.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/common.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index aa874607618a..be38c960da85 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -74,7 +74,9 @@ __xchk_process_error(
 		return true;
 	case -EDEADLOCK:
 		/* Used to restart an op with deadlock avoidance. */
-		trace_xchk_deadlock_retry(sc->ip, sc->sm, *error);
+		trace_xchk_deadlock_retry(
+				sc->ip ? sc->ip : XFS_I(file_inode(sc->file)),
+				sc->sm, *error);
 		break;
 	case -EFSBADCRC:
 	case -EFSCORRUPTED:

