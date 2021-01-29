Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70A2DC43331
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jan 2021 02:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3503664E07
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jan 2021 02:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbhA2CSX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 21:18:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:57504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231562AbhA2CST (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 21:18:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E54A064E08;
        Fri, 29 Jan 2021 02:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611886684;
        bh=zcIeRXJpU8rlv7dzSb2+rlWghhHlJHh2AbARBmOZG7A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=c/noblceNQoBBpLt2fMlb6e1Szd1tuvOQZxqTeZj2sOIWavGSi9fXrCEpOKfl2X02
         JAs7IYwAuvLVN1XX7pVUYc6ivbw9N3XLi+WvKh2ujN01NfKArKlsvQ2DngUdiPOsP+
         cKnXSrwSlE8glhjCtXDHJplE+Qtc1JAbFvhjfhgHW/c6ePTA7flbtkD0DxkhashtuF
         EGU05XoNoiNvmENhQC+E6uIm/mi7PeAgyiELP2rHnaDiyRjaKME31BVBvsMA5bfN39
         +CxZrnQB5IgC9DdKJSsGs6fmn9YeI/OHH9M0W43D79OMZIBp+1s9bgtY4C+FhXrUDN
         jR18tMamlVH9g==
Subject: [PATCH 03/12] xfs: xfs_inode_free_quota_blocks should scan project
 quota
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Thu, 28 Jan 2021 18:18:03 -0800
Message-ID: <161188668347.1943978.14528129365746247716.stgit@magnolia>
In-Reply-To: <161188666613.1943978.971196931920996596.stgit@magnolia>
References: <161188666613.1943978.971196931920996596.stgit@magnolia>
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
 

