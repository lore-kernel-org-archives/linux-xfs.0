Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CEBDC433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jun 2022 10:46:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352439AbiFAKqW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jun 2022 06:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352294AbiFAKqK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jun 2022 06:46:10 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2AA813D5;
        Wed,  1 Jun 2022 03:46:02 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id d26so1740209wrb.13;
        Wed, 01 Jun 2022 03:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1QqcTEPtoODTXKz5bXn/012pkjfLEsGJrtDgaQa4Ijw=;
        b=ge9YS57gzpsq8hhTTsZJ+/HY0QFDlvdxjE6nDvCWNIdMY5aqdJVF3kD4ErsAlWUsO2
         +Pdg+jRpXaXGLarElYQjN1FXUlqyDjsDAJqCqtKyNVVv+oUxzoMXVZE+Gdp67l8XMpeo
         9P47Pngw45r272hQcKUeH85fNNLM6qaVhiOGHJHzmhdisCYKlQyOQzG4Zfreu1OhEttM
         IGOhW94rIY7BSMMjEWRcZOXJydlv24cftWan7dWHbh4Iz1YdNtczJdFPHQaoZZOWDYF+
         eqdDPJHzMxSUhF+K+8goGQmbwrnXODIMWjjBxEosxCL62E13e1ly71xE7SZj15yVznOG
         ouRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1QqcTEPtoODTXKz5bXn/012pkjfLEsGJrtDgaQa4Ijw=;
        b=7611VmRhGcyzTGEM67ZqiQW9387pnMsHXch4t1XvdhhfDxVdSn8ledjjIYQApr0Fy0
         J+b7TvYEV2PG2+MMDYrXucbJsQuBmcx0eGVXQbxg900P8MQA2aJdpfy9wbIuVsVlKKbU
         tqee8/G80z5Cp2rnfr8JXJCZjAQI1qKyT7JKLw8sBMpAsvwwrFGCcXthYUTRJzccSwUT
         M+PMhZSQT8bqu4qTOI9xXizTtV18QGMSsMr5arLKZJUoMk3m+7JEpv4hCJmfDndNfgDr
         g6ody4Q3B6lbmGNrPQQdATVbsXYXZzfI/nI+8KTO52gn9/mruKSsYYmcgncUcCRSuD/K
         Y5/A==
X-Gm-Message-State: AOAM531ho+H0twMKd1D9M7tdV+jXAscVhSdv8z4tWacU6et6CfxGUSRy
        5tcy/Du83aoQlnPEPtRlyWc=
X-Google-Smtp-Source: ABdhPJyOaXPgqgziwE5Wcj2kcDEt0Y8NRW9ObIBSCQA36SprRKUu5Gf2S2d4WNi+er5G7fk4GvXJlg==
X-Received: by 2002:a05:6000:1acd:b0:20f:d7df:a2a8 with SMTP id i13-20020a0560001acd00b0020fd7dfa2a8mr39815822wry.477.1654080361005;
        Wed, 01 Jun 2022 03:46:01 -0700 (PDT)
Received: from localhost.localdomain ([77.137.79.96])
        by smtp.gmail.com with ESMTPSA id h9-20020a5d4309000000b002102af52a2csm1562150wrq.9.2022.06.01.03.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 03:46:00 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, Chandan Babu R <chandanrlinux@gmail.com>
Subject: [PATCH 5.10 CANDIDATE 5/8] xfs: fix incorrect root dquot corruption error when switching group/project quota types
Date:   Wed,  1 Jun 2022 13:45:44 +0300
Message-Id: <20220601104547.260949-6-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220601104547.260949-1-amir73il@gmail.com>
References: <20220601104547.260949-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 45068063efb7dd0a8d115c106aa05d9ab0946257 upstream.

While writing up a regression test for broken behavior when a chprojid
request fails, I noticed that we were logging corruption notices about
the root dquot of the group/project quota file at mount time when
testing V4 filesystems.

In commit afeda6000b0c, I was trying to improve ondisk dquot validation
by making sure that when we load an ondisk dquot into memory on behalf
of an incore dquot, the dquot id and type matches.  Unfortunately, I
forgot that V4 filesystems only have two quota files, and can switch
that file between group and project quota types at mount time.  When we
perform that switch, we'll try to load the default quota limits from the
root dquot prior to running quotacheck and log a corruption error when
the types don't match.

This is inconsequential because quotacheck will reset the second quota
file as part of doing the switch, but we shouldn't leave scary messages
in the kernel log.

Fixes: afeda6000b0c ("xfs: validate ondisk/incore dquot flags")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_dquot.c | 39 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 1d95ed387d66..80c4579d6835 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -500,6 +500,42 @@ xfs_dquot_alloc(
 	return dqp;
 }
 
+/* Check the ondisk dquot's id and type match what the incore dquot expects. */
+static bool
+xfs_dquot_check_type(
+	struct xfs_dquot	*dqp,
+	struct xfs_disk_dquot	*ddqp)
+{
+	uint8_t			ddqp_type;
+	uint8_t			dqp_type;
+
+	ddqp_type = ddqp->d_type & XFS_DQTYPE_REC_MASK;
+	dqp_type = xfs_dquot_type(dqp);
+
+	if (be32_to_cpu(ddqp->d_id) != dqp->q_id)
+		return false;
+
+	/*
+	 * V5 filesystems always expect an exact type match.  V4 filesystems
+	 * expect an exact match for user dquots and for non-root group and
+	 * project dquots.
+	 */
+	if (xfs_sb_version_hascrc(&dqp->q_mount->m_sb) ||
+	    dqp_type == XFS_DQTYPE_USER || dqp->q_id != 0)
+		return ddqp_type == dqp_type;
+
+	/*
+	 * V4 filesystems support either group or project quotas, but not both
+	 * at the same time.  The non-user quota file can be switched between
+	 * group and project quota uses depending on the mount options, which
+	 * means that we can encounter the other type when we try to load quota
+	 * defaults.  Quotacheck will soon reset the the entire quota file
+	 * (including the root dquot) anyway, but don't log scary corruption
+	 * reports to dmesg.
+	 */
+	return ddqp_type == XFS_DQTYPE_GROUP || ddqp_type == XFS_DQTYPE_PROJ;
+}
+
 /* Copy the in-core quota fields in from the on-disk buffer. */
 STATIC int
 xfs_dquot_from_disk(
@@ -512,8 +548,7 @@ xfs_dquot_from_disk(
 	 * Ensure that we got the type and ID we were looking for.
 	 * Everything else was checked by the dquot buffer verifier.
 	 */
-	if ((ddqp->d_type & XFS_DQTYPE_REC_MASK) != xfs_dquot_type(dqp) ||
-	    be32_to_cpu(ddqp->d_id) != dqp->q_id) {
+	if (!xfs_dquot_check_type(dqp, ddqp)) {
 		xfs_alert_tag(bp->b_mount, XFS_PTAG_VERIFIER_ERROR,
 			  "Metadata corruption detected at %pS, quota %u",
 			  __this_address, dqp->q_id);
-- 
2.25.1

