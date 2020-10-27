Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6277CC55178
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 00:05:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34E9F20791
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 00:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603757153;
	bh=2j/b6mqE21o2lEqB9iutum6WbvTtnPHA/8iRdy7Fbys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=nU+c1YE3wwCyvyI5C86jO97qgvZP46stbOX1Tz+Uj56edlkCBqQ07RjwuacTAaFRC
	 oMHhNH5/Web1DODKkROPNMXqFAlHT7nC0ZmzPyny+mqLMZTtNnNMcRtM4GUGCFnanX
	 UyQaKWkgjejck0r1KIKRe5dbNK4jXUEy1QZhsa4A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbgJ0AFt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 20:05:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437977AbgJ0AE5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Oct 2020 20:04:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E985F20791;
        Tue, 27 Oct 2020 00:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603757096;
        bh=2j/b6mqE21o2lEqB9iutum6WbvTtnPHA/8iRdy7Fbys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gn0andU8LsaRxb8QtwmyIWq0hNg1GXaaUQrGoCYnIk4PwwZfNcIJBik8H7V/uFqXK
         PI5TKPqwm5HTr/NyWPM77/c3qOz/4C1Mt0tuz5w/QqpCnT20I1sRZ88tJ2yRbwDuYv
         ZP+J/buecfRF6VOKWulimFEI6k77QP20j24eiuFI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 34/60] xfs: don't free rt blocks when we're doing a REMAP bunmapi call
Date:   Mon, 26 Oct 2020 20:03:49 -0400
Message-Id: <20201027000415.1026364-34-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201027000415.1026364-1-sashal@kernel.org>
References: <20201027000415.1026364-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

[ Upstream commit 8df0fa39bdd86ca81a8d706a6ed9d33cc65ca625 ]

When callers pass XFS_BMAPI_REMAP into xfs_bunmapi, they want the extent
to be unmapped from the given file fork without the extent being freed.
We do this for non-rt files, but we forgot to do this for realtime
files.  So far this isn't a big deal since nobody makes a bunmapi call
to a rt file with the REMAP flag set, but don't leave a logic bomb.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index f35e1801f1c90..fc9950a505e62 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4920,20 +4920,25 @@ xfs_bmap_del_extent_real(
 
 	flags = XFS_ILOG_CORE;
 	if (whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip)) {
-		xfs_fsblock_t	bno;
 		xfs_filblks_t	len;
 		xfs_extlen_t	mod;
 
-		bno = div_u64_rem(del->br_startblock, mp->m_sb.sb_rextsize,
-				  &mod);
-		ASSERT(mod == 0);
 		len = div_u64_rem(del->br_blockcount, mp->m_sb.sb_rextsize,
 				  &mod);
 		ASSERT(mod == 0);
 
-		error = xfs_rtfree_extent(tp, bno, (xfs_extlen_t)len);
-		if (error)
-			goto done;
+		if (!(bflags & XFS_BMAPI_REMAP)) {
+			xfs_fsblock_t	bno;
+
+			bno = div_u64_rem(del->br_startblock,
+					mp->m_sb.sb_rextsize, &mod);
+			ASSERT(mod == 0);
+
+			error = xfs_rtfree_extent(tp, bno, (xfs_extlen_t)len);
+			if (error)
+				goto done;
+		}
+
 		do_fx = 0;
 		nblks = len * mp->m_sb.sb_rextsize;
 		qfield = XFS_TRANS_DQ_RTBCOUNT;
-- 
2.25.1

