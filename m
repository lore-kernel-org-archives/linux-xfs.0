Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FF5FC4332D
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 00:30:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60A0422DFB
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 00:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404036AbhALAZz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 19:25:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:33586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404056AbhAKXXj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Jan 2021 18:23:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B230C22D2B;
        Mon, 11 Jan 2021 23:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610407378;
        bh=ocWFT20PRFHTJd4qoxwTayeDDZMUY+PTIZFP9FevQTQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=iNHnsLetrWpUMqwWp6E0eYFRsKiK5qqzxPvQvw3N3ZT8qfLWWo3ZIhNhxK0P6Eiti
         Hw4WACtdMWJVbxekXSeSrJUnzQge9uUBZPmRwd13Qgppt8Ab5J4jM2tgVmHIVcu1U2
         Ak9Bd7rNNVLzc0ko16tqTIehfz04nuq6W3Y7hxgFEJlq9+cmIpdpyyopTRGl+r3q4n
         BxvZB4lupYZsGNguYnHuQ2ie5aMMc5Hjbr7Pbxrh2S8z8nWYnhM8YKbiRLi2C2Rjp6
         YCiPN0KV1zwVYGNjWJ/eUw/7QB1+vmVIGslUZWyPzUbDXf5XEyu3YLLtCPB3mOUJOS
         1khzZMX3A9dXw==
Subject: [PATCH 4/6] xfs: xfs_inode_free_quota_blocks should scan project
 quota
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 11 Jan 2021 15:22:58 -0800
Message-ID: <161040737875.1582114.10240657258164907570.stgit@magnolia>
In-Reply-To: <161040735389.1582114.15084485390769234805.stgit@magnolia>
References: <161040735389.1582114.15084485390769234805.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Buffered writers who have run out of quota reservation call
xfs_inode_free_quota_blocks to try to free any space reservations that
might reduce the quota usage.  Unfortunately, the buffered write path
treats "out of project quota" the same as "out of overall space" so this
function has never supported scanning for space that might ease an "out
of project quota" condition.

We're about to start using this function for cases where we actually
/can/ tell if we're out of project quota, so add in this functionality.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |    9 +++++++++
 1 file changed, 9 insertions(+)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 4e226827b33d..703d26d04e0f 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1453,6 +1453,15 @@ xfs_inode_free_quota_blocks(
 		}
 	}
 
+	if (XFS_IS_PQUOTA_ENFORCED(ip->i_mount)) {
+		dq = xfs_inode_dquot(ip, XFS_DQTYPE_PROJ);
+		if (dq && xfs_dquot_lowsp(dq)) {
+			eofb.eof_prid = ip->i_d.di_projid;
+			eofb.eof_flags |= XFS_EOF_FLAGS_PRID;
+			do_work = true;
+		}
+	}
+
 	if (!do_work)
 		return false;
 

