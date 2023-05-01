Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78E65C77B7C
	for <linux-xfs@archiver.kernel.org>; Mon,  1 May 2023 18:27:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbjEAS1N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 May 2023 14:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbjEAS1M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 May 2023 14:27:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CFA713A
        for <linux-xfs@vger.kernel.org>; Mon,  1 May 2023 11:27:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33F6761E86
        for <linux-xfs@vger.kernel.org>; Mon,  1 May 2023 18:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C05CC433EF;
        Mon,  1 May 2023 18:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682965630;
        bh=ePuyMvo5dZ9PSz0ghyDO0slN3x9yNvDoL79X8VTBoHA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=J652q3/0Us55LDUL714sJRd8b+tZMhP9r2NIdrk6MtAxS1WnBNmfxRDVHJl9Np1/f
         y8KVNbQotu77igRTuv4/J5LqRHjpimZZNTLgvSOn34aWl5n5B8/RAboxwooe0SKaXn
         DkQHH8r1zeG8L0hM7nrauWmEuqyxotb9fLXaU2yuV6z0AM8zbI7Pgf2KSQcQMq/N5t
         uopV588XuGD1O7L/9JR8h4Y86C0mhhyUSN2XREpdjYoi3GI+7CkQAesJ6RF5XQ1eIV
         dKMR4G5U1u3OZhaTGhuW0gka99OTVck53PE2CR8aZZotyKxfzM+DtcXgaDAFt8xCtF
         43zWBS2dNCAow==
Subject: [PATCH 3/4] xfs: flush dirty data and drain directios before
 scrubbing cow fork
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     david@fromorbit.com, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Mon, 01 May 2023 11:27:10 -0700
Message-ID: <168296563007.290030.7849076336331509809.stgit@frogsfrogsfrogs>
In-Reply-To: <168296561299.290030.5324305660599413777.stgit@frogsfrogsfrogs>
References: <168296561299.290030.5324305660599413777.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When we're scrubbing the COW fork, we need to take MMAPLOCK_EXCL to
prevent page_mkwrite from modifying any inode state.  The ILOCK should
suffice to avoid confusing online fsck, but let's take the same locks
that we do everywhere else.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/scrub/bmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 87ab9f95a487..69bc89d0fc68 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -42,12 +42,12 @@ xchk_setup_inode_bmap(
 	xfs_ilock(sc->ip, XFS_IOLOCK_EXCL);
 
 	/*
-	 * We don't want any ephemeral data fork updates sitting around
+	 * We don't want any ephemeral data/cow fork updates sitting around
 	 * while we inspect block mappings, so wait for directio to finish
 	 * and flush dirty data if we have delalloc reservations.
 	 */
 	if (S_ISREG(VFS_I(sc->ip)->i_mode) &&
-	    sc->sm->sm_type == XFS_SCRUB_TYPE_BMBTD) {
+	    sc->sm->sm_type != XFS_SCRUB_TYPE_BMBTA) {
 		struct address_space	*mapping = VFS_I(sc->ip)->i_mapping;
 
 		sc->ilock_flags |= XFS_MMAPLOCK_EXCL;

