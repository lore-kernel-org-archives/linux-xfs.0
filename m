Return-Path: <SRS0=uuBg=DT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFDC5C433E7
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 09:30:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5193E208B6
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 09:30:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D8X0i/ma"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729412AbgJLJaX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Oct 2020 05:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729379AbgJLJaX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Oct 2020 05:30:23 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE61C0613CE
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2020 02:30:23 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id g29so13705159pgl.2
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2020 02:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ybzMGAH7mRYLjz5sy5yNWonaXyIH8jR0aIDyNXY08k0=;
        b=D8X0i/masmcQIjL5J7VUrpdSEquWkVlFISeV74FAU52Tvj+Gt/PQ9oueydxkWWvzvM
         Rep6aYIybmzBcqBDE3BSZdqAigR5wLdaZY9yQ8zg6kgHN3FJAk9NUerQq11AHq1sQGwL
         wyrvq2Z6dwZ78s7/g4FGujuYlvBBPu/SFk/UBH9ajb0prFXt0F/S8CriFUPQZU3TklB6
         9nAL0bZDTGNfisCdH5sAOpoSEQFdd3WMvyn6BNaw2rFvNKxF8tYu+lIGN5u6LCWgZS7u
         abRh7eDWciJkkKpZgIHfGTlycPdJJdX07hzpxQluCXj+/CM2wt2PMHHZrEMIuS48iGNr
         J/CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ybzMGAH7mRYLjz5sy5yNWonaXyIH8jR0aIDyNXY08k0=;
        b=VwjmTCD04/xVhbj/e/1NCwJFrXl06YcGdbGI1iHrWOKTpQrbgk46DohmKld6IhLDhp
         pgP/Ven8TOtcMDjZzBaLUKVG962wXVjwYSjJF0pogCJup4ZqKhaeP6/7IgWHTLt35VQy
         gHsnigYOebHULk0PlIzdei3Iie2nwwlezKhzEQ/MBS7NyqhYun+A3phoxFAHsXpwVH3t
         2+h+CLd9IZ3iEqzItPRxWQ7ywAg8aqAJ23pZ41qr5iM+J6tpepn3SQejouQfmZfQdlVg
         shYwzR9xU6BPZZqf2AxWAbpKMjG/teyoJQaxu1fsegQ/zDzaW+2sE11dqvHvTN5Z/1gJ
         7wrw==
X-Gm-Message-State: AOAM531KPTnjm4AL69gNDbia2Rm+VUu/ayI/vLl2rYhU6wKMXMpd3x0V
        Sjx/3yiNYRlMA0c8f0XN8PQtIP2PbFk=
X-Google-Smtp-Source: ABdhPJxOfBmegEUx9tSu2gHwjt5T+e+iVtJSp10hy/eN81YYinGe6yjoehppjgPVTikknuN83VoDsw==
X-Received: by 2002:a17:90a:4545:: with SMTP id r5mr18617091pjm.55.1602495022917;
        Mon, 12 Oct 2020 02:30:22 -0700 (PDT)
Received: from localhost.localdomain ([122.172.180.109])
        by smtp.gmail.com with ESMTPSA id z142sm19451985pfc.179.2020.10.12.02.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 02:30:22 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V6 07/11] xfs: Check for extent overflow when moving extent from cow to data fork
Date:   Mon, 12 Oct 2020 14:59:34 +0530
Message-Id: <20201012092938.50946-8-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012092938.50946-1-chandanrlinux@gmail.com>
References: <20201012092938.50946-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Moving an extent to data fork can cause a sub-interval of an existing
extent to be unmapped. This will increase extent count by 1. Mapping in
the new extent can increase the extent count by 1 again i.e.
 | Old extent | New extent | Old extent |
Hence number of extents increases by 2.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h | 9 +++++++++
 fs/xfs/xfs_reflink.c           | 5 +++++
 2 files changed, 14 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index afb647e1e3fa..b99e67e7b59b 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -78,6 +78,15 @@ struct xfs_ifork {
  */
 #define XFS_IEXT_WRITE_UNWRITTEN_CNT	(2)
 
+/*
+ * Moving an extent to data fork can cause a sub-interval of an existing extent
+ * to be unmapped. This will increase extent count by 1. Mapping in the new
+ * extent can increase the extent count by 1 again i.e.
+ * | Old extent | New extent | Old extent |
+ * Hence number of extents increases by 2.
+ */
+#define XFS_IEXT_REFLINK_END_COW_CNT	(2)
+
 /*
  * Fork handling.
  */
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 16098dc42add..4f0198f636ad 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -628,6 +628,11 @@ xfs_reflink_end_cow_extent(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
+	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+			XFS_IEXT_REFLINK_END_COW_CNT);
+	if (error)
+		goto out_cancel;
+
 	/*
 	 * In case of racing, overlapping AIO writes no COW extents might be
 	 * left by the time I/O completes for the loser of the race.  In that
-- 
2.28.0

