Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D544C43334
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jun 2022 07:33:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232931AbiF0Hd3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Jun 2022 03:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiF0Hd2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jun 2022 03:33:28 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DCB05592;
        Mon, 27 Jun 2022 00:33:27 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id l2-20020a05600c4f0200b0039c55c50482so6955903wmq.0;
        Mon, 27 Jun 2022 00:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wn1Y0ouYIlg+N/jjxBw0yK9UaqWrXu4rdEIsXBdfBz4=;
        b=jJE0swdPowWhFGEvtt+wvpLEkGqp4l7CJVG6k8MYXhm3ZNGSqE/7+ZI0iNwEtT09Wn
         HrTeoDbFPGPvOQW1/uW6Ay8WVFsxxWgns3lVNeeThbnU2TQ4WlcV3L4wIR8W/ev9CaGY
         7ugtHCJXjTv1SMGzslOEl9kcagONkBDe5g3uXjNC15U4Fl4GZdasxD8TnnPkiXFeQP8g
         J0Vf7/3FXVKGfCFpFgewxPo7x3CXicyAopOwzr9geOSauk5uymasd/dcQqk1pv+QGiH7
         TMonHBI05xojKh1siLtzd/IkHQtnHIaLXWXEP0hWnEvXwPuDISk5jA4bPBpcNXu0YnGY
         pHSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wn1Y0ouYIlg+N/jjxBw0yK9UaqWrXu4rdEIsXBdfBz4=;
        b=fenDaqL4/QUp/0424ehm7GYZzczb5rbxnDAKjTGVdksDBsxLW0sfNyv8QBNwmJy/s2
         cU0dTnjEtKWPZmXpAeXvs3f9ymEKreNkgRn+uTzdfITgqwrDw10M4A6vS5xbXWO9t2Vk
         dxF3FusziSYC/eJZjY7fKXTGe4J0yyFAPS9Ef9TPmGJioV6g+c5im6BZWY/J0c7P4jxL
         TXLtYY2GExGD5NMzDVnEnbemk7617PF70GGzCM9s7qRPH8Ov8WTBO3ghsi8b1XyEKIg+
         vl20ODRjMQ0UZwOw+AI1rnALKxXTNjTZD8uv75viJ9gEhya3GH/MmHm6ITyaJ/4Pa8NI
         LzVA==
X-Gm-Message-State: AJIora9UcJud+qGbd3+1JNXcjsfBqghUgnEUrqWmkL/2adkcfzbYcJyr
        840qTKfpu+bGWGlypm0M3zY=
X-Google-Smtp-Source: AGRyM1uUXox1i7pzrS6eHYRG7Pjzzc+qWUqUX9gc3H47zEC42brLjAyQP2BU/aUOgFtaCqwvuohsgw==
X-Received: by 2002:a05:600c:4f54:b0:3a0:4a5b:2692 with SMTP id m20-20020a05600c4f5400b003a04a5b2692mr4228833wmq.109.1656315205973;
        Mon, 27 Jun 2022 00:33:25 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id j20-20020a05600c2b9400b00397623ff335sm12070070wmc.10.2022.06.27.00.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 00:33:25 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Zorro Lang <zlang@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH 5.10 CANDIDATE v2 6/7] xfs: update superblock counters correctly for !lazysbcount
Date:   Mon, 27 Jun 2022 10:33:10 +0300
Message-Id: <20220627073311.2800330-7-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220627073311.2800330-1-amir73il@gmail.com>
References: <20220627073311.2800330-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit 6543990a168acf366f4b6174d7bd46ba15a8a2a6 upstream.

Keep the mount superblock counters up to date for !lazysbcount
filesystems so that when we log the superblock they do not need
updating in any way because they are already correct.

It's found by what Zorro reported:
1. mkfs.xfs -f -l lazy-count=0 -m crc=0 $dev
2. mount $dev $mnt
3. fsstress -d $mnt -p 100 -n 1000 (maybe need more or less io load)
4. umount $mnt
5. xfs_repair -n $dev
and I've seen no problem with this patch.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reported-by: Zorro Lang <zlang@redhat.com>
Reviewed-by: Gao Xiang <hsiangkao@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/libxfs/xfs_sb.c | 16 +++++++++++++---
 fs/xfs/xfs_trans.c     |  3 +++
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 5aeafa59ed27..66e8353da2f3 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -956,9 +956,19 @@ xfs_log_sb(
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_buf		*bp = xfs_trans_getsb(tp);
 
-	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
-	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
-	mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
+	/*
+	 * Lazy sb counters don't update the in-core superblock so do that now.
+	 * If this is at unmount, the counters will be exactly correct, but at
+	 * any other time they will only be ballpark correct because of
+	 * reservations that have been taken out percpu counters. If we have an
+	 * unclean shutdown, this will be corrected by log recovery rebuilding
+	 * the counters from the AGF block counts.
+	 */
+	if (xfs_sb_version_haslazysbcount(&mp->m_sb)) {
+		mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
+		mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
+		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
+	}
 
 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 2d7deacea2cf..36166bae24a6 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -615,6 +615,9 @@ xfs_trans_unreserve_and_mod_sb(
 
 	/* apply remaining deltas */
 	spin_lock(&mp->m_sb_lock);
+	mp->m_sb.sb_fdblocks += tp->t_fdblocks_delta + tp->t_res_fdblocks_delta;
+	mp->m_sb.sb_icount += idelta;
+	mp->m_sb.sb_ifree += ifreedelta;
 	mp->m_sb.sb_frextents += rtxdelta;
 	mp->m_sb.sb_dblocks += tp->t_dblocks_delta;
 	mp->m_sb.sb_agcount += tp->t_agcount_delta;
-- 
2.25.1

