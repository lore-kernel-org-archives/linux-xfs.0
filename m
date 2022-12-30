Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAA61C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:50:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236095AbiLaBuY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236079AbiLaBuX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:50:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492A41DDD1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:50:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB6C461CD0
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484C4C433EF;
        Sat, 31 Dec 2022 01:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451422;
        bh=1j548RtOEwsQjE2/4fOsZFv6dRRwWYIP8Kis1UBfTfw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=s1cgw9UBc7n4yjlPWLuFfnSY11VRuM13L/+RGux4dVJhLEcXFGk33dMGrfJ4BBA/j
         IC/b+eHflxsiwQ5TUZ5Ffwr2Jl8USypu9lJpTQ04NnwjfQ2Re2thTphy6HmHIqsuYg
         sZ4+cU2hTkVIC/EV8lfvlb6RGGd3cOiumlQ5/0aaqlkRo53HnY8Po1ZNh/bZ9Gj04i
         fxpjDReqai4Ckrs6U5KOHMSIzgzf02syVk3EWDJZ4VzPdP/mr9RXD9vKcCa+NGu8Ix
         Q3YiaDWCJvbHsqXeFlv6slGgAAzlVBPgz/PPHRB81CihVFJDuVJy//XcMnBLL0bRFD
         Up4eBdQw/vdHQ==
Subject: [PATCH 09/42] xfs: support recovering refcount intent items
 targetting realtime extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:30 -0800
Message-ID: <167243871026.717073.14257109009386052103.stgit@magnolia>
In-Reply-To: <167243870849.717073.203452386730176902.stgit@magnolia>
References: <167243870849.717073.203452386730176902.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we have reflink on the realtime device, refcount intent items
have to support remapping extents on the realtime volume.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_refcount_item.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 7a366b316e79..fc6dbbb17ad7 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -482,6 +482,9 @@ xfs_cui_validate_phys(
 		return false;
 	}
 
+	if (pmap->pe_flags & XFS_REFCOUNT_EXTENT_REALTIME)
+		return xfs_verify_rtbext(mp, pmap->pe_startblock, pmap->pe_len);
+
 	return xfs_verify_fsbext(mp, pmap->pe_startblock, pmap->pe_len);
 }
 

