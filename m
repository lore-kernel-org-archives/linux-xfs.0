Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FDB7C3F6B0
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Aug 2022 18:36:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241429AbiHESgI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Aug 2022 14:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238385AbiHESfy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Aug 2022 14:35:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77369DFE2;
        Fri,  5 Aug 2022 11:35:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28C2EB80D83;
        Fri,  5 Aug 2022 18:35:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5675C433D7;
        Fri,  5 Aug 2022 18:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659724550;
        bh=EQv+UvsRrAxVqCjRTPFq4HNln4t/Rpaq3UXlIzOheYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FC6xPAsfpgcjFytX4DmHj01ESIMdhFh7ovpKkoggYZ9EpfrYbn1X/E2JTI7yulhK/
         4/ULxbe2w2QSI32YMFAKYSFzte0w1qId2bfa4WWSWVBzRVJv3YlIGy62ihTO4cRLgF
         2z3un+siyUbZVmTGCU9+GWfJYBDnaHodnaTDgBcmnlLlslUB7DFB8YDivMsfKB2GG5
         s51GWHlxMxI90kl9c9rZTo2qJmIGYCmWgXkH7DdI4l8ZKauM7cyNAnn+5Ie0TKLR4/
         +hU43YIkqc4ljEG3uuoPtDMLFNwZWO2WFcj0KgJ39ZdxpGzng9RpBIFk2YBT6Yt5TV
         F8YHIVWRPTSag==
From:   Jeff Layton <jlayton@kernel.org>
To:     linux-fsdevel@vger.kernel.org
Cc:     dhowells@redhat.com, lczerner@redhat.com, bxue@redhat.com,
        ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 4/4] ceph: fill in the change attribute in statx requests
Date:   Fri,  5 Aug 2022 14:35:43 -0400
Message-Id: <20220805183543.274352-5-jlayton@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220805183543.274352-1-jlayton@kernel.org>
References: <20220805183543.274352-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When statx requests the change attribute, request the full gamut of caps
(similarly to how ctime is handled). When the change attribute seems to
be valid, return it in the chgattr field.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/inode.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 56c53ab3618e..fb2ed85f9083 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2408,10 +2408,10 @@ static int statx_to_caps(u32 want, umode_t mode)
 {
 	int mask = 0;
 
-	if (want & (STATX_MODE|STATX_UID|STATX_GID|STATX_CTIME|STATX_BTIME))
+	if (want & (STATX_MODE|STATX_UID|STATX_GID|STATX_CTIME|STATX_BTIME|STATX_CHGATTR))
 		mask |= CEPH_CAP_AUTH_SHARED;
 
-	if (want & (STATX_NLINK|STATX_CTIME)) {
+	if (want & (STATX_NLINK|STATX_CTIME|STATX_CHGATTR)) {
 		/*
 		 * The link count for directories depends on inode->i_subdirs,
 		 * and that is only updated when Fs caps are held.
@@ -2422,11 +2422,10 @@ static int statx_to_caps(u32 want, umode_t mode)
 			mask |= CEPH_CAP_LINK_SHARED;
 	}
 
-	if (want & (STATX_ATIME|STATX_MTIME|STATX_CTIME|STATX_SIZE|
-		    STATX_BLOCKS))
+	if (want & (STATX_ATIME|STATX_MTIME|STATX_CTIME|STATX_SIZE| STATX_BLOCKS|STATX_CHGATTR))
 		mask |= CEPH_CAP_FILE_SHARED;
 
-	if (want & (STATX_CTIME))
+	if (want & (STATX_CTIME|STATX_CHGATTR))
 		mask |= CEPH_CAP_XATTR_SHARED;
 
 	return mask;
@@ -2468,6 +2467,11 @@ int ceph_getattr(struct user_namespace *mnt_userns, const struct path *path,
 		valid_mask |= STATX_BTIME;
 	}
 
+	if (request_mask & STATX_CHGATTR) {
+		stat->chgattr = inode_peek_iversion_raw(inode);
+		valid_mask |= STATX_CHGATTR;
+	}
+
 	if (ceph_snap(inode) == CEPH_NOSNAP)
 		stat->dev = inode->i_sb->s_dev;
 	else
-- 
2.37.1

