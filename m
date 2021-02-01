Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DD54C433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 02:07:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BEEE64E2E
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 02:07:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbhBACHQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 Jan 2021 21:07:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:34354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229765AbhBACGY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 31 Jan 2021 21:06:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0E3F64E32;
        Mon,  1 Feb 2021 02:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612145143;
        bh=zcIeRXJpU8rlv7dzSb2+rlWghhHlJHh2AbARBmOZG7A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=D7FlR3yfIKpOThp1JdFW3drGVJRrEnSTovfueirJRT8A99RnkVbqsJDN8mSxfV/Ng
         Q9gAH/jb0o0zSbOGfFmXZUiqo10awDxyIrfSEQry2hva53p4SoxUjroJh1QSi1bZ4d
         eTKPO7lII46QjMNdN7urp6fc2L2xUuXxVMAhE5ntXrscYqv39ghO6LIld+Tr8ZV+Zi
         ov55AISCpqasJa1KhZMui2wo1ZVl/wzutbTBvOxIqQnXAdGBaIF4A4HvfLtgmdK6lv
         qw/hJAJA+AeOmPTbZZug3casWACXYJoqjvolOkFWvRFdNuv9H2/OJASyq5qhAw0Uzb
         yEyT7E6ISDgIQ==
Subject: [PATCH 03/12] xfs: xfs_inode_free_quota_blocks should scan project
 quota
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Sun, 31 Jan 2021 18:05:43 -0800
Message-ID: <161214514329.140945.12811277568414319413.stgit@magnolia>
In-Reply-To: <161214512641.140945.11651856181122264773.stgit@magnolia>
References: <161214512641.140945.11651856181122264773.stgit@magnolia>
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
 

