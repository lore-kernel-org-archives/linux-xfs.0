Return-Path: <SRS0=BK4F=CC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AB77C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 08:19:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E8BB20738
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 08:19:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=aol.com header.i=@aol.com header.b="kI4cA7yI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgHXITV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 04:19:21 -0400
Received: from sonic314-21.consmr.mail.gq1.yahoo.com ([98.137.69.84]:42356
        "EHLO sonic314-21.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725780AbgHXITV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Aug 2020 04:19:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1598257160; bh=Sjy98GU2Q6PFEOkqVItxd5AxTXrbKf6hq45plokvQd8=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject; b=kI4cA7yI7S0xY9v74R/weq7Pcw7LryADp9gNMc7AQNwWdRjjL7Jt+CdxMhbYM01hphjfFZXybHyIpHsveBPrtM837vEiChkQAdAhyj18b7RugzOCYphXglKlFE8tlpN4TlGhjteUeAWDulutU2b8aBmlmGAINNMTXZcimzEZAU4wCvdiJYtX5D17VCOXiwlPawcX3Krt+4AV5n3VxOwK5zifwiJHobQO1mqQTq73x0ukVcuBVMF4kNjr9uBDOAjcsIZz3b/n3QxORtFZjcD1TKc1w4nYn4GH81STgvYzP1FqZUrQO9k1O/wtLVlyB/aswq0p8x3o80CEeEb0YyBf0w==
X-YMail-OSG: Qnyp7A8VM1kYtFZ0lTB899k8ew74TatqKrOdycoeDYp5ddUwC4nI8PLutPxovfw
 psXEBXt.f4R4R2avPgIZIMkyrlvOA37l1u.5gpYEwKY5sZ3FmexT92i9pcuJNHZEpt3Ed_siZ3Xh
 UVk.U5DaSI9_p3oc_2XVuFcYC4jnpn_X7iA3mZA1TW8k..uERva2MdNu2EWSRZEeWZdaknWJG1in
 MWJ2i0kAkPVz.wN.yWTr6xpC4OPctbbK6lAAwHTT62T5NZ2jkOEYiK1LEABLbBf5ISySTkTvK26O
 3m0POjKZ4Kg5fXRRbP5OiD1rh2.HaVaIQbqDf.o1OjazKI8Vz.Dl4uCIn4QqVWoxtuFUJizR9BX3
 DLrcYMFEPgKz27MFIJzPHnwwpK9P68NHwLruzCyHPX8lwwIJCRt_COwMxml6UsoUKF8lVZBFI7q0
 K1dS8cwtj0jpB9GnljNNt2C08j8CHnlVWrUth7RLMXANrvND7IaZHT97J.EQluKQwCHSoobX1cAp
 gA7EREzD87AWTwG.AFT9G69i0G5TficdelzitOpZlcQPePcrI9ThTVhLJUddj6WJHRkFYNytC5p8
 YlNoC7G1gM7errT83LqJYDbwnLV5HZVDgbJlRW0.PdBEC1Q.21xsBpnjkREI.A8DRGw2rj9nAzzi
 QDpza929f5CpObbqjqTguCrfw9EvZMva5a.OMxOq3fEp8wJQ1mLy8ed.tacUF.CEZLh7iRVUqKL5
 26tRFEOWA6ZZC3hTs01AdY5GY7fVEQNMxBOle4aM9fnim6WXI1ZdeoWHt6eo1Mqlrg2WMn0ybdtq
 PCmAOvFrRuyTD4OjoHDr.m58sU5Dnv8x7zWX3e56_vQvF6xh0ZABo0wIYMtiCCwGMQHHBRYcGZKx
 mG218olyqkAcRpR8ogatMJ8HtxjfCpjr3yLW1svJ9MCqMgm6Dbad.pJCNLsthq5JUwBkrIb3mBHw
 guKG8_iNzZ3iBRoP9Xe_M4djUcQXyqS905IPih6Kfl7NoIU.Eo5C.N52kQI5OGjhCUwvrDKoKmoE
 rGwLJlK6vf327dMQ6G.7A6Aap2akh_2xAOaPgzYHSDWBbsL0kQCBRQXLueXMRfhlHu0LAm.0WY5_
 sjdOIIBFycfx1TG85QUBZ3yq6RGIq.gwBK3V0PL7x2mNockgC4qeH2SMoEsZvBzVSzszlJWlf0H5
 I5Pg0Ecg1rhObbvivHBDTeHStvFPDby_uSMJeiAi77y_dpuLE0eSEVOaEVYcd_mfdCTrdswsovB2
 8FZtkl4uhgO0Vo1wQjZOdPBNkzDsS5GTmthuSIpoHR.3576gi40amKQoVS5zlqvXrH.qzWjoMrrE
 btDG2SeogW0eh_BL46ObRmW60Sy8V4T5k9a04U.MT9cdoaqI_Fned.EICwceGeha.DoKwS0qKK9S
 1NmyScWb2ehTCKSTD_AfIVwcLop0jBE9HgKNUbtFazLfVRL5DLlw7YYokx03MzMUGo7_jQA7JmnE
 ttLIaq6xqNbwRJSs46oKMjWta.tkwcFXCcMZoqBBRxaVLjCYSkLabLPiHP73nGaLgMbO__EnS3xr
 FeA--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.gq1.yahoo.com with HTTP; Mon, 24 Aug 2020 08:19:20 +0000
Received: by smtp417.mail.ir2.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 567fd072a20955784a094d1769fc3a95;
          Mon, 24 Aug 2020 08:19:18 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [RFC PATCH] xfs: use log_incompat feature instead of speculate matching
Date:   Mon, 24 Aug 2020 16:19:00 +0800
Message-Id: <20200824081900.27573-1-hsiangkao@aol.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200823172421.GA16579@xiangao.remote.csb>
References: <20200823172421.GA16579@xiangao.remote.csb>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

Use a log_incompat feature just to be safe.
If the current mount is in RO state, it will defer
to next RW remount.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---

After some careful thinking, I think it's probably not working for
supported V4 XFS filesystem. So, I think we'd probably insist on the
previous way (correct me if I'm wrong)...

(since xfs_sb_to_disk() refuses to set up any feature bits for non V5
 fses. That is another awkward setting here (doesn't write out/check
 feature bits for V4 even though using V4 sb reserved fields) and
 unless let V4 completely RO since this commit. )

Just send out as a RFC patch. Not fully tested after I thought as above.

 fs/xfs/libxfs/xfs_format.h | 4 +++-
 fs/xfs/xfs_inode.c         | 3 ++-
 fs/xfs/xfs_mount.c         | 9 +++++++++
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 31b7ece985bb..9f6c2766f6a6 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -479,7 +479,9 @@ xfs_sb_has_incompat_feature(
 	return (sbp->sb_features_incompat & feature) != 0;
 }
 
-#define XFS_SB_FEAT_INCOMPAT_LOG_ALL 0
+#define XFS_SB_FEAT_INCOMPAT_LOG_NEW_UNLINK	(1 << 0)
+#define XFS_SB_FEAT_INCOMPAT_LOG_ALL	\
+		(XFS_SB_FEAT_INCOMPAT_LOG_NEW_UNLINK)
 #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
 static inline bool
 xfs_sb_has_incompat_log_feature(
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7ee778bcde06..e8eee1437611 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1952,7 +1952,8 @@ xfs_iunlink_update_bucket(
 	if (!log || log->l_flags & XLOG_RECOVERY_NEEDED) {
 		ASSERT(cur_agino != NULLAGINO);
 
-		if (be32_to_cpu(agi->agi_unlinked[0]) != cur_agino)
+		if (!(mp->m_sb.sb_features_log_incompat &
+		      XFS_SB_FEAT_INCOMPAT_LOG_NEW_UNLINK))
 			bucket_index = cur_agino % XFS_AGI_UNLINKED_BUCKETS;
 	}
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index f28c969af272..91d8b22524c6 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -836,6 +836,15 @@ xfs_mountfs(
 		goto out_fail_wait;
 	}
 
+	if (!(sbp->sb_features_log_incompat &
+	      XFS_SB_FEAT_INCOMPAT_LOG_NEW_UNLINK) &&
+	    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
+		xfs_warn(mp, "will switch to long iunlinked list on r/w");
+		sbp->sb_features_log_incompat |=
+				XFS_SB_FEAT_INCOMPAT_LOG_NEW_UNLINK;
+		mp->m_update_sb = true;
+	}
+
 	/* Make sure the summary counts are ok. */
 	error = xfs_check_summary_counts(mp);
 	if (error)
-- 
2.24.0

