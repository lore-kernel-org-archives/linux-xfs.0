Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DADEC43334
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jun 2022 21:35:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239990AbiF0Vfm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Jun 2022 17:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239964AbiF0Vfl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jun 2022 17:35:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4246A10FF
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jun 2022 14:35:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F14F3B8106E
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jun 2022 21:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4E2C34115;
        Mon, 27 Jun 2022 21:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656365738;
        bh=LmMlJJ941WQSm6rz9w2S5GPZlw6gI1TRQjWjKC0v1os=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SKbcgHI6wH5g9/J4Jl0CMOhOa1mQcJVKL3ZyVl9757CjGdt4c8tIC00mE+Hv1MWHK
         VTEbCizq7d4LYs/lttckAxr2zZBoxQEIIEojjN2sRJsIlXH/lCJsziQLB6X150qMgB
         g+WfArKYoAXFJSDIeOduyMou4akLTYO50Ai/xXILIhurwGkmUs781zCVJ/dzYeFYqD
         FH9tFr+F7tqKMmITHfOEoKaAFRb0po/2rIMyUgwQFH+uRu0TC1jUeV5vJHFZn3kg/1
         0Av5KEDPWIjP40O3ZZMQnG8689uEP+wjcdIp5sCxPiUiwld9aOGHEPfeRaPsPspmAF
         QHhbs+VOpz70g==
Subject: [PATCH 3/3] xfs: dont treat rt extents beyond EOF as eofblocks to be
 cleared
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, allison.henderson@oracle.com
Date:   Mon, 27 Jun 2022 14:35:38 -0700
Message-ID: <165636573821.355536.976591440534807402.stgit@magnolia>
In-Reply-To: <165636572124.355536.216420713221853575.stgit@magnolia>
References: <165636572124.355536.216420713221853575.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

On a system with a realtime volume and a 28k realtime extent,
generic/491 fails because the test opens a file on a frozen filesystem
and closing it causes xfs_release -> xfs_can_free_eofblocks to
mistakenly think that the the blocks of the realtime extent beyond EOF
are posteof blocks to be freed.  Realtime extents cannot be partially
unmapped, so this is pointless.  Worse yet, this triggers posteof
cleanup, which stalls on a transaction allocation, which is why the test
fails.

Teach the predicate to account for realtime extents properly.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 52be58372c63..85e1a26c92e8 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -686,6 +686,8 @@ xfs_can_free_eofblocks(
 	 * forever.
 	 */
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_ISIZE(ip));
+	if (XFS_IS_REALTIME_INODE(ip) && mp->m_sb.sb_rextsize > 1)
+		end_fsb = roundup_64(end_fsb, mp->m_sb.sb_rextsize);
 	last_fsb = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
 	if (last_fsb <= end_fsb)
 		return false;

