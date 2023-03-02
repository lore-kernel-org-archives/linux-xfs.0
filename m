Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D669C7EE36
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Mar 2023 20:35:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbjCBUfX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Mar 2023 15:35:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbjCBUfU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Mar 2023 15:35:20 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE762303E2
        for <linux-xfs@vger.kernel.org>; Thu,  2 Mar 2023 12:35:19 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id 6-20020a17090a190600b00237c5b6ecd7so4001486pjg.4
        for <linux-xfs@vger.kernel.org>; Thu, 02 Mar 2023 12:35:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677789319;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L6OtFpioQcuNL/EmIHlDW/bfrHDMVOXrKommZPDv0K0=;
        b=XPw3/GrZeZsbumGSNne6nRExE30dSSlOQ42quoiUliJ6lFpZeY1qgat7mUXMdEmhGd
         KqYK6fzrGHkeYof5dWkj4ksuJgk1YzSQkKcMwpOVTLA/zg+3O5uIRO9UAlMX39UI71XE
         im0KCCVUOO7JxEDYlI6D8PWVDid07QlvyhUaCb00gYeo07DtT5qkEjoR+1r0slwoE+RM
         0AMQ9RuOG52Qqu26fH7kS7XXx0opSRKhYX47JhoIUGl88dwlCxksmppf2MjQf+o8Wj0V
         cpQ5mvQYs7zRMONLtl9J5JlwjwZQHXWtS37CVY1d1JBssjiv9MFdc0fSawIUBs8x9f4E
         HwVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677789319;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L6OtFpioQcuNL/EmIHlDW/bfrHDMVOXrKommZPDv0K0=;
        b=qqyupG4IrORbZzJEJEuHUgPPPYnFVYi2FA3NnBcT6tPpFp1ctzwv/5aBwpr2UzMzWQ
         cp6870L4vM0QXn/diSZR2uIl862wUsNlF8RFGQs/V08ennIdEFRJeS5bZyo3qUE1qdv0
         IrRjpy5Psae2YTPawFomZ8hYXnALtNx929QothpKW0mN04R3ehkGXn1k7zrAi5Y7A+Zy
         w/ah5Hq3I/9zLCV52GjyBKsPrigIdoe49Oa0v8+LvnnQuKaOFGZkaCkRRy5EH+4QDVis
         75K+2OZemTeHkEmW2Mv9spP9l68hF6TnQbwr4op2Z6sgvVldbG7E+flk7r9PlE8E7x7u
         hNRQ==
X-Gm-Message-State: AO0yUKUn7LCntF6ZRQ677sEfnGv9HT3yxpgxKkAVZZ23zJj9gFTppxL5
        d2KO6fjuISVkij6oEZQ8UFC21DZGGpfzAA==
X-Google-Smtp-Source: AK7set+KhtVOJ+rSX1u0WEklcPml1xY1db37CeB4KFnoXTMdml2eiIG+LHimDuFZm5iLFb6kzg0GAQ==
X-Received: by 2002:a05:6a21:6da1:b0:cc:c69b:f7e5 with SMTP id wl33-20020a056a216da100b000ccc69bf7e5mr13758600pzb.9.1677789319357;
        Thu, 02 Mar 2023 12:35:19 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:637a:4159:6b3f:42eb])
        by smtp.gmail.com with ESMTPSA id b13-20020aa7870d000000b005ac86f7b87fsm113459pfo.77.2023.03.02.12.35.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 12:35:18 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 03/11] xfs: fallocate() should call file_modified()
Date:   Thu,  2 Mar 2023 12:34:56 -0800
Message-Id: <20230302203504.2998773-4-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230302203504.2998773-1-leah.rumancik@gmail.com>
References: <20230302203504.2998773-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit fbe7e520036583a783b13ff9744e35c2a329d9a4 upsream.

In XFS, we always update the inode change and modification time when
any fallocate() operation succeeds.  Furthermore, as various
fallocate modes can change the file contents (extending EOF,
punching holes, zeroing things, shifting extents), we should drop
file privileges like suid just like we do for a regular write().
There's already a VFS helper that figures all this out for us, so
use that.

The net effect of this is that we no longer drop suid/sgid if the
caller is root, but we also now drop file capabilities.

We also move the xfs_update_prealloc_flags() function so that it now
is only called by the scope that needs to set the the prealloc flag.

Based on a patch from Darrick Wong.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Tested-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_file.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 752b676c92e3..020e0a412287 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -954,6 +954,10 @@ xfs_file_fallocate(
 			goto out_unlock;
 	}
 
+	error = file_modified(file);
+	if (error)
+		goto out_unlock;
+
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
 		error = xfs_free_file_space(ip, offset, len);
 		if (error)
@@ -1055,11 +1059,12 @@ xfs_file_fallocate(
 			if (error)
 				goto out_unlock;
 		}
-	}
 
-	error = xfs_update_prealloc_flags(ip, flags);
-	if (error)
-		goto out_unlock;
+		error = xfs_update_prealloc_flags(ip, XFS_PREALLOC_SET);
+		if (error)
+			goto out_unlock;
+
+	}
 
 	/* Change file size if needed */
 	if (new_size) {
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

