Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF4E4C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:03:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A27264DDB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbhA1GDW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 01:03:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:38064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229804AbhA1GDW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 01:03:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 983DD64DD1;
        Thu, 28 Jan 2021 06:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611813761;
        bh=zcIeRXJpU8rlv7dzSb2+rlWghhHlJHh2AbARBmOZG7A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YEn1uwVPnJYMb6tbQDCpJvw/Apl9Y3v//r8G8V/oRoS/ARuv4IB8gYO0GdB1vf50n
         xrz9bounrtfhV8ZwZ5sBbP6qrSuEPKVGJPcBlLWJ2bVnUfXvZHB+zcS2VlFPX4GlKQ
         wS+WVARLUhKHDtBMDoYC93tNUauV+AzIcjXJqNxH2+Oa6mJxWaVnUOBRFDHELETbRf
         pJXegFuLyxDspn4oXJlRwFDvxMuA2XI++k5OSI/25NmB9BVRic5eXzvNkwk0+AqYLg
         ofS587St+UpPRJLYZBdxv5Q8b+PKYle94BT5tUlYLYsZE0LNpStULgiaqBEGZ/lTYy
         Etl0lAtS3YMiQ==
Subject: [PATCH 03/11] xfs: xfs_inode_free_quota_blocks should scan project
 quota
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Wed, 27 Jan 2021 22:02:37 -0800
Message-ID: <161181375784.1525026.12331319031329123186.stgit@magnolia>
In-Reply-To: <161181374062.1525026.14717838769921652940.stgit@magnolia>
References: <161181374062.1525026.14717838769921652940.stgit@magnolia>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_icache.c |    9 +++++++++
 1 file changed, 9 insertions(+)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 89f9e692fde7..10c1a0dee17d 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1434,6 +1434,15 @@ xfs_inode_free_quota_blocks(
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
 

