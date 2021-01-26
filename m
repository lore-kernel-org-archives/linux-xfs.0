Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4B4DC4332B
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 10:21:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B44F720731
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 10:21:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313957AbhAZXC5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 18:02:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:54600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730497AbhAZFAL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Jan 2021 00:00:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF57222B2C;
        Tue, 26 Jan 2021 04:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611636689;
        bh=H5Bd24pqMbMofDbBIoiTClFy4h+2Zy2uKRkMvNh8H1o=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=Tt4d7urCW102j+6wKVfF7c8tnMR5P2Dq6ytmYwkkOa/H6xassqPfJ8oYDoRcf4pDy
         8ifJ+sIt8ElMZhFWButtZo3TZGzBPf/VrWnNxcabZ71JPOUlSFVa9JnBw/dEkSnYGr
         0GPXQSNtDQdzhSVdlfTjEr57MzyXUlAAuNMhs4Rnvlkj+G292Ry4VIXahUe0MKXyR6
         MW5WjrBUBIN6oMOXCTURmIGSZ5ztBDE5FocnUKCnR8IsrP9cRsOQcmjIrf3c9lv7sI
         XSbWCDFDJ+8+AamJV1kexNXeV47i3vNs0Sp6+duYil3oz5c4x9RCSoh1l4e1uElLUq
         olVuUZuQ+pYLQ==
Date:   Mon, 25 Jan 2021 20:51:28 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Subject: [PATCH 5/4] xfs: fix up build warnings when quotas are disabled
Message-ID: <20210126045128.GL7698@magnolia>
References: <161142789504.2170981.1372317837643770452.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161142789504.2170981.1372317837643770452.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix some build warnings on gcc 10.2 when quotas are disabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_quota.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 16a2e7adf4da..4cafc1c78879 100644
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
@@ -167,8 +167,8 @@ xfs_trans_reserve_quota_icreate(struct xfs_trans *tp, struct xfs_inode *dp,
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
