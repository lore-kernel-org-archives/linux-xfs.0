Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1543C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:43:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235913AbiLaBn0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:43:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236028AbiLaBnZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:43:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9A2F026
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:43:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73483B81A16
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:43:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1435DC433D2;
        Sat, 31 Dec 2022 01:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451002;
        bh=fisbBsrgK44ty80auP9A+MP7Ecn5UDAoFQ8EQIKvKLk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Iq6ViSstJo5HpCiNS311tVPp3tKcjt7aTkAkEXmz7q4Nvdnvx9xfNajJqh14KgjKM
         rgYkLhvunmO6Q2r0vZRwpH5YsYh2LQk37bYZPFlyMaFPa16H15GKTnM3m+qdJI0POi
         +kp/9c6xFAvfPtxyA8fMpqE/eoy62lrFdLNpAplRl+pQwCka44wGYh6QIOXyPwJ6Pr
         /pUVvT71SeSsLuLHyCs9Kx2pSuIZVGxr5l8hvYe0POACP6uIpEToiBsYsr5R6A6oKN
         w34u0CRCmMKXHddsP1VpqHqtaFKhxJbJpMwQYjvLapgbFWeu1xL718waIhxSKFH7Jr
         7vRR0BYtjl/vg==
Subject: [PATCH 25/38] xfs: fix scrub tracepoints when inode-rooted btrees are
 involved
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:19 -0800
Message-ID: <167243869956.715303.2051988056260451085.stgit@magnolia>
In-Reply-To: <167243869558.715303.13347105677486333748.stgit@magnolia>
References: <167243869558.715303.13347105677486333748.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix a minor mistakes in the scrub tracepoints that can manifest when
inode-rooted btrees are enabled.  The existing code worked fine for bmap
btrees, but we should tighten the code up to be less sloppy.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/trace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index cf1635e00cb0..3ffee717062d 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -477,7 +477,7 @@ TRACE_EVENT(xchk_ifork_btree_op_error,
 	TP_fast_assign(
 		xfs_fsblock_t fsbno = xchk_btree_cur_fsbno(cur, level);
 		__entry->dev = sc->mp->m_super->s_dev;
-		__entry->ino = sc->ip->i_ino;
+		__entry->ino = cur->bc_ino.ip->i_ino;
 		__entry->whichfork = cur->bc_ino.whichfork;
 		__entry->type = sc->sm->sm_type;
 		__entry->btnum = cur->bc_btnum;

