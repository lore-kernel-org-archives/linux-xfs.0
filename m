Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8E66C43334
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jun 2022 18:28:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiFPS2k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jun 2022 14:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377941AbiFPS2e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 14:28:34 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BDCC47570
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 11:28:32 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id r5so1985910pgr.3
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 11:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BwDYu8qCpUgv3klGR2cPWxbyAkTo5NIqM2MooctaADo=;
        b=dV3rjExVyuzQlia6K8+0cm17jZeI98NAL2OP5nP8Bo4mdRb45plddw8pvn1oCatc0p
         GxuxDBx8bJ03EjBJ/P+ZO1JlUupQEEYJRvvAqLLofU1tpQxcJ41AT4ccE/JjEQ0/nWzH
         e0uTgML5JmXigs7LOY24nzxGak6u7LeCk34kUDPI/sOjRFU+zCVxe3QRKQzjnz33/5ad
         8o2pdRnlfLikxYUioUQmcfn88qkq/lRQ/1/EkeYoHN2eRYMN5NG7aK4vyBoo1mWCa+Jf
         i02a+zSbNlNE7waLzxqVBa2/z14UD5wwUS9lNfwoW3GwisQORLPvJGJQZftkT6ogMdUu
         gNcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BwDYu8qCpUgv3klGR2cPWxbyAkTo5NIqM2MooctaADo=;
        b=gEEm8iFjbZVrTo/xZd/3eXLUfdjdT81QkZHpgnF5RG3nh49w56Q2LNQ04TcjfZ53AS
         X62RRJGCYBTAE634hLsongNNoJiSazVZ9ScIpuhtAxq4eRXlD8gaVlDyuz/qQjucncbP
         O/kmJFFRCWRluesyoiDnqTKrg6dOEkls/BSpz40T6o61crvsN7AqcOvtnwxPf3SFF+uZ
         iNn04vcgi+MKznL+4mDW3Vlw8/QbuS0KW8/sYzdbgr6PrK6jzq/IiNxCCPOrzSlMCnHf
         EJHxVn+2Ujh1XkyFznto/UpbPxsOAl/HdEsbwswZJKhSceZCqVoGSXAqfzKfioEXyPa8
         0Qeg==
X-Gm-Message-State: AJIora9K3YE1+Vb/SjSNKL+BpsZKEMNTAIqNXMEQ60NnEc8mO+W4+wLT
        O3KMlReMAjmOW6vepN4vBc9aasxnDXybMQ==
X-Google-Smtp-Source: AGRyM1u/APMDwZZIjyefsm0ALWPlvQhbNt0lxxgOZjm1vBgM6W18KB+kGCLTFmIWOj0xknAqxeGQzQ==
X-Received: by 2002:a63:e903:0:b0:3fd:ac2a:5123 with SMTP id i3-20020a63e903000000b003fdac2a5123mr5592842pgh.297.1655404111852;
        Thu, 16 Jun 2022 11:28:31 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2cd:202:fd57:7edc:385a:c1be])
        by smtp.gmail.com with ESMTPSA id fs20-20020a17090af29400b001ea75a02805sm4131511pjb.52.2022.06.16.11.28.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 11:28:31 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     mcgrof@kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE v2 7/8] xfs: only bother with sync_filesystem during readonly remount
Date:   Thu, 16 Jun 2022 11:27:48 -0700
Message-Id: <20220616182749.1200971-8-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
In-Reply-To: <20220616182749.1200971-1-leah.rumancik@gmail.com>
References: <20220616182749.1200971-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit b97cca3ba9098522e5a1c3388764ead42640c1a5 ]

In commit 02b9984d6408, we pushed a sync_filesystem() call from the VFS
into xfs_fs_remount.  The only time that we ever need to push dirty file
data or metadata to disk for a remount is if we're remounting the
filesystem read only, so this really could be moved to xfs_remount_ro.

Once we've moved the call site, actually check the return value from
sync_filesystem.

Fixes: 02b9984d6408 ("fs: push sync_filesystem() down to the file system's remount_fs()")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_super.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 23673703618a..e8d19916ba99 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1773,6 +1773,11 @@ xfs_remount_ro(
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
@@ -1851,8 +1856,6 @@ xfs_fs_reconfigure(
 	if (error)
 		return error;
 
-	sync_filesystem(mp->m_super);
-
 	/* inode32 -> inode64 */
 	if (xfs_has_small_inums(mp) && !xfs_has_small_inums(new_mp)) {
 		mp->m_features &= ~XFS_FEAT_SMALL_INUMS;
-- 
2.36.1.476.g0c4daa206d-goog

