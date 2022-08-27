Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A6AEECAAD2
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Aug 2022 07:02:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233401AbiH0HCI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 27 Aug 2022 03:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232683AbiH0HBf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 27 Aug 2022 03:01:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C13A95E71;
        Sat, 27 Aug 2022 00:01:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFBACB82781;
        Sat, 27 Aug 2022 07:01:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6EEC43140;
        Sat, 27 Aug 2022 07:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661583693;
        bh=BMT1YARSMuQOgngIP7XzOtYpe7cK7QyPx7BNBC00UCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c/hsF2y+yUyZZ/M61vU4PGa6++PqDTysR9MzPXrcrcqMv3SKVWO1Z1vWcVxMEzoRf
         ta102F7VQ25WpDfRCW+TK34h2VKCCsJlD9dF9R0UUHkYP8h6pH5ZLQ3qCSpSuETS9E
         0c950qgPd/aWdgWhrMkf9/+Gz4bM/bolKb1k/u6N9bv6UKG2oxRqS0yrNd+lnWDUCu
         r3gmhFZ3jxjpnhuIoMUuCUHX/lUS6gns2tSpY2CHEug8psJGV27pGtOyWCu3TcEa8W
         oRxUH3b+QEtBV7fCUNB5TVsCCE9gQsUeQEGkw2yEAughA4ZtiAHBXlKfEaKQO7is49
         oVld+TcJhn8yA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fsdevel@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-xfs@vger.kernel.org, linux-api@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, Keith Busch <kbusch@kernel.org>
Subject: [PATCH v5 7/8] f2fs: support STATX_DIOALIGN
Date:   Fri, 26 Aug 2022 23:58:50 -0700
Message-Id: <20220827065851.135710-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220827065851.135710-1-ebiggers@kernel.org>
References: <20220827065851.135710-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add support for STATX_DIOALIGN to f2fs, so that direct I/O alignment
restrictions are exposed to userspace in a generic way.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/f2fs/file.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 8e11311db21060..79177050732803 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -847,6 +847,24 @@ int f2fs_getattr(struct user_namespace *mnt_userns, const struct path *path,
 		stat->btime.tv_nsec = fi->i_crtime.tv_nsec;
 	}
 
+	/*
+	 * Return the DIO alignment restrictions if requested.  We only return
+	 * this information when requested, since on encrypted files it might
+	 * take a fair bit of work to get if the file wasn't opened recently.
+	 *
+	 * f2fs sometimes supports DIO reads but not DIO writes.  STATX_DIOALIGN
+	 * cannot represent that, so in that case we report no DIO support.
+	 */
+	if ((request_mask & STATX_DIOALIGN) && S_ISREG(inode->i_mode)) {
+		unsigned int bsize = i_blocksize(inode);
+
+		stat->result_mask |= STATX_DIOALIGN;
+		if (!f2fs_force_buffered_io(inode, WRITE)) {
+			stat->dio_mem_align = bsize;
+			stat->dio_offset_align = bsize;
+		}
+	}
+
 	flags = fi->i_flags;
 	if (flags & F2FS_COMPR_FL)
 		stat->attributes |= STATX_ATTR_COMPRESSED;
-- 
2.37.2

