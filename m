Return-Path: <SRS0=chL6=C7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C21AC2D0E2
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 09:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E75D1208A9
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 09:04:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kt3uwQHH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgIVJEL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Sep 2020 05:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgIVJEL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Sep 2020 05:04:11 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C095C061755
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 02:04:11 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x22so7022639pfo.12
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 02:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=y18WvJEOlPyfpfV/6wUNCzQGVi+rt2nPZiBys+U4QAg=;
        b=Kt3uwQHHXfjGUzMN7H1z4VR1EIZvUQrII5QuTRWCdU6VnlWHrBQzHmmT+45VmPC5JP
         8Me2gL66IdmY/4+aQ7rwBb4pGXQ0jzz3qeN6/i5VctAo0GNI+HZXgy2fSIOURYWpMg1k
         J1d/+/l6rhcdicDnJ1Ri37WqLMyhdGbz+dyF1KqMHwp/1Gv6LVy5g1hXgp6Vmwrcggu6
         IieO9vy6TLz89Adlri+ATT1IajaX4R/1+DaozKirvcWJTxx6ngPKDacW9Puj+jAkomEF
         Ggh0UZw44ZF4Gce6W/fr4oOE/2lUtj4+L19YbApmqcKRf8JXEy424Sf8HGl3MfKYAwcH
         s0Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=y18WvJEOlPyfpfV/6wUNCzQGVi+rt2nPZiBys+U4QAg=;
        b=Se0eBh0ZM6dM/5WSnNQRsMEfa+RBZ9/JaoYaHsB6Cz0Z+eWld3T4gJ4S+83a2+Cp74
         MJqsUeWMWksI+ZV8WDmWY0xhKj0jLdpXUae1NkYuq06ypi+MOIdZXU7XSS9dczRA6ffs
         fiPFWbXacgDjp42DTVFZsFjgriHvElb/R70lBum7r68fgU9j40Z+0KR7ZtsPXJfo22d3
         VaSWTXShqRRO5/hWFWNVd9A2b1mhteQvb4IhmTKGQnXVB14nKIEOlh8M65eBnIUNbETl
         tvVJPp7gH/3BkS3BsHFCM6sJQkf2PlXT/VOvUztD2ObDIX9OL4Eoq5JdVU2UAHK3WVui
         e1xQ==
X-Gm-Message-State: AOAM533MKwFJNiZFNMcc0rYzMHtTvoqmYqEsYC5wbR5bl9Z4mx+ASg6t
        43iars889q7r2uZvS8kXYJdgvPTzAg==
X-Google-Smtp-Source: ABdhPJw8NvdjiQyxT+o8lqRIfM0TiyJl0WR963AbPyoyr6KO6OsdXpgmhzk0SuEofy8YfAZ7xhOv8w==
X-Received: by 2002:a17:902:e9d1:b029:d2:221f:9970 with SMTP id 17-20020a170902e9d1b02900d2221f9970mr3711881plk.5.1600765450541;
        Tue, 22 Sep 2020 02:04:10 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id h8sm13815653pfk.19.2020.09.22.02.04.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Sep 2020 02:04:09 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH 2/3] xfs: remove the unused parameter id from xfs_qm_dqattach_one
Date:   Tue, 22 Sep 2020 17:04:01 +0800
Message-Id: <1600765442-12146-3-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600765442-12146-1-git-send-email-kaixuxia@tencent.com>
References: <1600765442-12146-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Since we never use the second parameter id, so remove it from
xfs_qm_dqattach_one() function.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/xfs_qm.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 41a459ffd1f2..44509decb4cd 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -249,7 +249,6 @@ xfs_qm_unmount_quotas(
 STATIC int
 xfs_qm_dqattach_one(
 	struct xfs_inode	*ip,
-	xfs_dqid_t		id,
 	xfs_dqtype_t		type,
 	bool			doalloc,
 	struct xfs_dquot	**IO_idqpp)
@@ -330,23 +329,23 @@ xfs_qm_dqattach_locked(
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	if (XFS_IS_UQUOTA_ON(mp) && !ip->i_udquot) {
-		error = xfs_qm_dqattach_one(ip, i_uid_read(VFS_I(ip)),
-				XFS_DQTYPE_USER, doalloc, &ip->i_udquot);
+		error = xfs_qm_dqattach_one(ip, XFS_DQTYPE_USER,
+				doalloc, &ip->i_udquot);
 		if (error)
 			goto done;
 		ASSERT(ip->i_udquot);
 	}
 
 	if (XFS_IS_GQUOTA_ON(mp) && !ip->i_gdquot) {
-		error = xfs_qm_dqattach_one(ip, i_gid_read(VFS_I(ip)),
-				XFS_DQTYPE_GROUP, doalloc, &ip->i_gdquot);
+		error = xfs_qm_dqattach_one(ip, XFS_DQTYPE_GROUP,
+				doalloc, &ip->i_gdquot);
 		if (error)
 			goto done;
 		ASSERT(ip->i_gdquot);
 	}
 
 	if (XFS_IS_PQUOTA_ON(mp) && !ip->i_pdquot) {
-		error = xfs_qm_dqattach_one(ip, ip->i_d.di_projid, XFS_DQTYPE_PROJ,
+		error = xfs_qm_dqattach_one(ip, XFS_DQTYPE_PROJ,
 				doalloc, &ip->i_pdquot);
 		if (error)
 			goto done;
-- 
2.20.0

