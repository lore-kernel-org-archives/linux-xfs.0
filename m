Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19CCCC433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 02:04:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDF7864EE4
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 02:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbhBBCEn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Feb 2021 21:04:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:55288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229557AbhBBCEj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Feb 2021 21:04:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA65564EDF;
        Tue,  2 Feb 2021 02:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612231432;
        bh=SsqUqhG6Svj1cde74lLtqYlxr8pBclWG9TNh8/Dn/qo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dRcvuugoDg7Bfj+yBKhkUEFCZ6Wu5p+pBP9GKx+qOghnMAhTupjzo4LnCI/3YXg0N
         T0nHRNt1846OHNtDtekxYTRTsOFixHS/DBZ14kjDlQfr44rs4rVDR22/R3CuWcDNJA
         XTL/RHEJEmTCFpb/vlMsGT3INB7Oh0ODx+wGpLH4F7gYmq/Rj21THuSjsffJetfXFY
         ucAY+d5lCBErAPp0TdRFGBQjWLsdeE11HjqlsdaPc/FnrS7kH2gREb+zuEHTD5H7pL
         LatKtOlNvb3iAb2WS/SMnIhxKhd5VkPiH2UBIxVbUwZ/u5tLB9/wj5HDtITnCKV981
         OsUV9LCZ7ws+A==
Subject: [PATCH 06/16] xfs: fix up build warnings when quotas are disabled
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Mon, 01 Feb 2021 18:03:52 -0800
Message-ID: <161223143226.491593.3267792761771445482.stgit@magnolia>
In-Reply-To: <161223139756.491593.10895138838199018804.stgit@magnolia>
References: <161223139756.491593.10895138838199018804.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix some build warnings on gcc 10.2 when quotas are disabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_quota.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 919c3a924821..03235c184aab 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -130,7 +130,7 @@ xfs_qm_vop_dqalloc(struct xfs_inode *ip, kuid_t kuid, kgid_t kgid,
 }
 #define xfs_trans_dup_dqinfo(tp, tp2)
 #define xfs_trans_free_dqinfo(tp)
-#define xfs_trans_mod_dquot_byino(tp, ip, fields, delta)
+#define xfs_trans_mod_dquot_byino(tp, ip, fields, delta) do { } while (0)
 #define xfs_trans_apply_dquot_deltas(tp)
 #define xfs_trans_unreserve_and_mod_dquots(tp)
 static inline int xfs_trans_reserve_quota_nblks(struct xfs_trans *tp,
@@ -166,8 +166,8 @@ xfs_trans_reserve_quota_icreate(struct xfs_trans *tp, struct xfs_dquot *udqp,
 #define xfs_qm_dqattach(ip)						(0)
 #define xfs_qm_dqattach_locked(ip, fl)					(0)
 #define xfs_qm_dqdetach(ip)
-#define xfs_qm_dqrele(d)
-#define xfs_qm_statvfs(ip, s)
+#define xfs_qm_dqrele(d)			do { (d) = (d); } while(0)
+#define xfs_qm_statvfs(ip, s)			do { } while(0)
 #define xfs_qm_newmount(mp, a, b)					(0)
 #define xfs_qm_mount_quotas(mp)
 #define xfs_qm_unmount(mp)

