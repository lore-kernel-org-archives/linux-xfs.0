Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F07F9C43334
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jun 2022 10:07:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381599AbiFQKHg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jun 2022 06:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381605AbiFQKHW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jun 2022 06:07:22 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99CE96A42C;
        Fri, 17 Jun 2022 03:07:03 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id l2-20020a05600c4f0200b0039c55c50482so4117094wmq.0;
        Fri, 17 Jun 2022 03:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4KLwIj5Vu7AZlMJL3ChxFNmM9rxj5CAzgdTye3eR8PQ=;
        b=WTrBLahFEki5jxOMZWYPRoyceiXgV9iw1qPlrUbx/Mkaxnp8p2f0vzfygdGGwhF4fd
         GIPcRHiYlWWPrHrQwRdkRD28EtNIf6fTO3fz1jyES+edEpaj0gZ5ycUbWBqALzBcp21Y
         hl1m1KIqOVgqo9IIltisvb1S6sq9/ieMkYWbe+pz7FazBOSaQY9975rAENmg0qJcNh7p
         pshYupgu366+jJAsJOzhiq1HcqwofB51JgyoE8JORbZKUBL1aFFClbbKpiKVoo2RrsUg
         y/6KK8AVnuiIEtxIepRmDYSJxDbgygeo4TdeBtIny2342ILwyyvxDC8jnYXIufCbc9Tv
         Tv2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4KLwIj5Vu7AZlMJL3ChxFNmM9rxj5CAzgdTye3eR8PQ=;
        b=qjVBD1dufAOOq7g+H437RRn84O/QiSvtmNZUIwE//3R4jNbuCgpqpbmLvTpHQcFYeN
         u9lJoIc9rwNYUUj3HEMjbtrPZ8/gvQ7T30XBFtyzZzlaf4Ot2G/h/ejrkOs7Yhiqi5ET
         jIqvy2DrtzqYUUw4HwNy3qdK25Do5WABglr1ydIVPZflOBneQlDY+1P3V9gcQXI+ZLab
         gf6W1WrQqmlcxZ9rH6R83rMI59mQYcIZ21fTg90VSrzLMmSIt11T7QiZ4+SSwo5rFURz
         Aiv/v8eL2+jDxl63M+yVMBUR9W5wJ7k4sa6lpN9TA945Iev6Tf/6oGw3DMxBv351YIUz
         ynpA==
X-Gm-Message-State: AOAM5324sxmCBf7ucw0GSEJQiAcnprlWnqPnvtRRCIIiXT8nd7qATbNm
        ULkld2UpmFmfbdhc5uRevVsknsoHdqcO/A==
X-Google-Smtp-Source: ABdhPJwrIaptM1v8O+UzyLACJ6TPhS00hzw3rvxFC9pDVzrS8iaoiFH3JVDsH2jk+cwZtT5FwsPSRA==
X-Received: by 2002:a7b:cc13:0:b0:38e:67e3:db47 with SMTP id f19-20020a7bcc13000000b0038e67e3db47mr20197606wmh.133.1655460422202;
        Fri, 17 Jun 2022 03:07:02 -0700 (PDT)
Received: from localhost.localdomain ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id m42-20020a05600c3b2a00b003973435c517sm5265534wms.0.2022.06.17.03.07.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 03:07:01 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 5.10 CANDIDATE 09/11] xfs: only bother with sync_filesystem during readonly remount
Date:   Fri, 17 Jun 2022 13:06:39 +0300
Message-Id: <20220617100641.1653164-10-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220617100641.1653164-1-amir73il@gmail.com>
References: <20220617100641.1653164-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit b97cca3ba9098522e5a1c3388764ead42640c1a5 upstream.

In commit 02b9984d6408, we pushed a sync_filesystem() call from the VFS
into xfs_fs_remount.  The only time that we ever need to push dirty file
data or metadata to disk for a remount is if we're remounting the
filesystem read only, so this really could be moved to xfs_remount_ro.

Once we've moved the call site, actually check the return value from
sync_filesystem.

Fixes: 02b9984d6408 ("fs: push sync_filesystem() down to the file system's remount_fs()")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_super.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 6323974d6b3e..dd0439ae6732 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1716,6 +1716,11 @@ xfs_remount_ro(
 	};
 	int			error;
 
+	/* Flush all the dirty data to disk. */
+	error = sync_filesystem(mp->m_super);
+	if (error)
+		return error;
+
 	/*
 	 * Cancel background eofb scanning so it cannot race with the final
 	 * log force+buftarg wait and deadlock the remount.
@@ -1786,8 +1791,6 @@ xfs_fc_reconfigure(
 	if (error)
 		return error;
 
-	sync_filesystem(mp->m_super);
-
 	/* inode32 -> inode64 */
 	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) &&
 	    !(new_mp->m_flags & XFS_MOUNT_SMALL_INUMS)) {
-- 
2.25.1

