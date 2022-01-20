Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F213FC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:22:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345158AbiATAWP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:22:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59168 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240471AbiATAWO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:22:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B90F61512
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:22:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0269C004E1;
        Thu, 20 Jan 2022 00:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638133;
        bh=/QcQ2wEhL9r/QvQCsiMfVN5hAXNkW6VfABzsfilWpik=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gg7fa2deKPW0r0MDKbbRUfOmbnZs/SzKHIKe5cG7HaNH7nYFTB6KDN3ZSutTu57IX
         vUYfYp1RjUJ6ouUz78H2nhCUu9eWuAuTcSVBwNl/LRgetEWoWcpC0ZGGuhHYL+VBQ1
         pIjG9JfpaO2UKB6Ofq0U0Xho1APrFHvmk1f5ekcF6vPFDGc3ejRW7lM/9bfC2czDHW
         DsY+pjFYpE56ZteyjJmoS0H+i2kPTDfaGuEQMFq0DSUw3BUvdeY/TfxsGvjUQzGh6x
         TLaJmRq5CUz750YYPXjdSMnZgIwSfNB3PtjvRCYzKtEy8B3OklFjw5mZFsmwMkIETR
         Oxjg28xNg3OzA==
Subject: [PATCH 07/17] xfs_db: fix nbits parameter in fa_ino[48] functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Date:   Wed, 19 Jan 2022 16:22:13 -0800
Message-ID: <164263813341.863810.8110691166064894260.stgit@magnolia>
In-Reply-To: <164263809453.863810.8908193461297738491.stgit@magnolia>
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Use the proper macro to convert ino4 and ino8 field byte sizes to a bit
count in the functions that navigate shortform directories.  This just
happens to work correctly for ino4 entries, but omits the upper 4 bytes
of an ino8 entry.  Note that the entries display correctly; it's just
the command "addr u3.sfdir3.list[X].inumber.i8" that won't.

Found by running smatch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/faddr.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/db/faddr.c b/db/faddr.c
index 81d69c94..0127c5d1 100644
--- a/db/faddr.c
+++ b/db/faddr.c
@@ -353,7 +353,8 @@ fa_ino4(
 	xfs_ino_t	ino;
 
 	ASSERT(next == TYP_INODE);
-	ino = (xfs_ino_t)getbitval(obj, bit, bitsz(XFS_INO32_SIZE), BVUNSIGNED);
+	ino = (xfs_ino_t)getbitval(obj, bit, bitize(XFS_INO32_SIZE),
+			BVUNSIGNED);
 	if (ino == NULLFSINO) {
 		dbprintf(_("null inode number, cannot set new addr\n"));
 		return;
@@ -370,7 +371,8 @@ fa_ino8(
 	xfs_ino_t	ino;
 
 	ASSERT(next == TYP_INODE);
-	ino = (xfs_ino_t)getbitval(obj, bit, bitsz(XFS_INO64_SIZE), BVUNSIGNED);
+	ino = (xfs_ino_t)getbitval(obj, bit, bitize(XFS_INO64_SIZE),
+			BVUNSIGNED);
 	if (ino == NULLFSINO) {
 		dbprintf(_("null inode number, cannot set new addr\n"));
 		return;

