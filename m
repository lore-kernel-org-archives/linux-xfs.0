Return-Path: <SRS0=2mLC=C3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F5B1C43464
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 09:48:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F310721D7B
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 09:48:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p7zDj56S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgIRJsf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Sep 2020 05:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgIRJsf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Sep 2020 05:48:35 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EFE6C06174A
        for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2020 02:48:35 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id u3so2742184pjr.3
        for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2020 02:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=syOqEuploIW5wOLjFtUhHHVglk6+YbYMa9cQ0Bzwmu0=;
        b=p7zDj56SVcC4uZy/lZjX9rHba8sgU74qnfkJrSOarccj0CZezAMBNNg3+M2Cl4fkPT
         nZvfUjz3SZPLUOrSQLLeqit7L9u0PlItBOcLhHL39E/30SwFCF6VbXA7JbXa0SUv+XXx
         27wIAFckbl1IozhZoVXO5JEacUgAfwsAldStNqvJJVbfWrZBi2pGkl/2SIKNZgcI4gut
         Nfml86N17sMz0X0SkfC1rjPXS6CRjwuKwlOnmUBQoE6r2R0KJ6clbWyE2Qfu4zmpzSRg
         NbYxGAONPg/zijANJbXXcv98ENePnZRV38SvaqYvo68klqMFVRSCxaoHPlUpbV2v8wvp
         ekkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=syOqEuploIW5wOLjFtUhHHVglk6+YbYMa9cQ0Bzwmu0=;
        b=PclV5Go8WIHs1nW+3e30Wpkg7PQMP/jw/x67xfm+htXe7PNv2ohdM7I1cWnZTXyYOr
         ORS7T861fMTR4iAjYgvTEttNEcBwy7KHGtYxRCCVEhCQ7jlckOmOut5TV4egCUwF7Hd5
         UJwihc+Kqp/fLXuixF4OQGN/N2QlcodoXLm59OlLoLLzCopQZya+tlAkSLKCAklKofdi
         em7rTImCxLoc29Gm5TXXFCPYJr7ihSWXlhUt0JCZjxh0WME6AVeaiuFbvJvuRDtJyEV+
         uWagH2ErMCigUeeGmgBL1KWVqXqHGP5v/Eodfi9JSOyfUwmz62eiD5J2Da02LgFpIkXv
         qCog==
X-Gm-Message-State: AOAM5305n+1bHt9MszoRHwBeyVYl7zV8q/utsl+GF9cNLuX5TEST3Wfe
        xccMRHM0G046J7+F7dJ4B9WzGZeCx8o=
X-Google-Smtp-Source: ABdhPJzPQXA//i8FkDaPrq59PUM8ip0L5dpAqDFabpYwu5aWM1uB2WCUvw9FIKJ1ubdUh/e4k4jU2A==
X-Received: by 2002:a17:90b:20d1:: with SMTP id ju17mr11510693pjb.134.1600422514679;
        Fri, 18 Sep 2020 02:48:34 -0700 (PDT)
Received: from localhost.localdomain ([122.179.62.164])
        by smtp.gmail.com with ESMTPSA id s24sm2227194pjp.53.2020.09.18.02.48.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 02:48:34 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V4 06/10] xfs: Check for extent overflow when writing to unwritten extent
Date:   Fri, 18 Sep 2020 15:17:55 +0530
Message-Id: <20200918094759.2727564-7-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200918094759.2727564-1-chandanrlinux@gmail.com>
References: <20200918094759.2727564-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A write to a sub-interval of an existing unwritten extent causes
the original extent to be split into 3 extents
i.e. | Unwritten | Real | Unwritten |
Hence extent count can increase by 2.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h | 8 ++++++++
 fs/xfs/xfs_iomap.c             | 5 +++++
 2 files changed, 13 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index fd93fdc67ee4..afb647e1e3fa 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -70,6 +70,14 @@ struct xfs_ifork {
 #define XFS_IEXT_DIR_MANIP_CNT(mp) \
 	((XFS_DA_NODE_MAXDEPTH + 1 + 1) * (mp)->m_dir_geo->fsbcount)
 
+/*
+ * A write to a sub-interval of an existing unwritten extent causes the original
+ * extent to be split into 3 extents
+ * i.e. | Unwritten | Real | Unwritten |
+ * Hence extent count can increase by 2.
+ */
+#define XFS_IEXT_WRITE_UNWRITTEN_CNT	(2)
+
 /*
  * Fork handling.
  */
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index a302a96823b8..2aa788379611 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -566,6 +566,11 @@ xfs_iomap_write_unwritten(
 		if (error)
 			goto error_on_bmapi_transaction;
 
+		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+				XFS_IEXT_WRITE_UNWRITTEN_CNT);
+		if (error)
+			goto error_on_bmapi_transaction;
+
 		/*
 		 * Modify the unwritten extent state of the buffer.
 		 */
-- 
2.28.0

