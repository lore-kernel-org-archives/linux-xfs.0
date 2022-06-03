Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4FE7CCA473
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jun 2022 18:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348477AbiFCS6H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Jun 2022 14:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240462AbiFCS6F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Jun 2022 14:58:05 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F76329C87
        for <linux-xfs@vger.kernel.org>; Fri,  3 Jun 2022 11:58:04 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id e66so7862556pgc.8
        for <linux-xfs@vger.kernel.org>; Fri, 03 Jun 2022 11:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PsHRqqJvJJwTZL0cEC0vF/PoWt+lLmRyyiZuibH8OEA=;
        b=o3OPFrcsDPJbdRrFEuD+gvTlQyJhLfOSIGib/MmPnk9bw0ZMzhhotamX9zT5nVxuiD
         XM4nSaCv95g/RK6HOvB7estZPwnVOsv0Rtj5y1KIkmM9JF2A+xhxzDhYfWkcSFwFYIZB
         BkGDM3jMP1ohcXayuriOTFx1XpTR7Im8G6kF5InwBiQQrAkDcdjdzZtXYz4Gonyl6lVK
         BRael7DvgQsahhfQkVbeC+wbs4IYoo59ozy3dFM+UTo2Hj743UXTk9TQhVkEHNEEbIG/
         R76vJ4euAEKJdIdh3ML1Bx/YCd6WQyUP5c/EydQlV1kRo4GCgR5PPrcrqgLqkjBnPF6J
         HHrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PsHRqqJvJJwTZL0cEC0vF/PoWt+lLmRyyiZuibH8OEA=;
        b=1U9lgzj9RParz5tff9OFYVcHRthS4sBmFzCpMQGoTRuRajN+swHpJ2l7aJLZVvUrBV
         qJ/PAYTixqxVqQ1NZPh7wtuWAHsnskxSDvjf9KjadQcG8GG6If2gS4uwQJdrJOBsXUP3
         MhGaa+yEnXVngmLlwBv/Hd/LKeXMRSkYIhZklLLmlcraveHJfjD+ZbMm7L5mpsTovF2U
         JylKIyzcWPrhT9vtaqYdiBBiHtOGROQYBvsWgOUmMOUeT3qF0G/qZRiwYhKYfUZKuR8s
         NydOhHNs9+VmOhTYoAfh5LBPZy02f+v1bmBdblzHPW5N5ohkk1S8nvQEYO1HMFGmQgPq
         uzbQ==
X-Gm-Message-State: AOAM532inWNjA2UZaPrBJd7aF9ap7PWA56WSBE6Syg2Q8Kco+E5J7w7a
        n7Oge9MWbV3vIuZsIWtAjcMVPBLgtjlRkQ==
X-Google-Smtp-Source: ABdhPJy359z8/pgjN/6ANzG741aolQ5MsWfLRZkbmTHYZ2sjpEftZED1qUC7RJiIh5rZH8HnwqfWsw==
X-Received: by 2002:a65:63d1:0:b0:3c6:25b2:22ba with SMTP id n17-20020a6563d1000000b003c625b222bamr10100114pgv.360.1654282683969;
        Fri, 03 Jun 2022 11:58:03 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2cd:202:e74e:a023:a0be:b6a8])
        by smtp.gmail.com with ESMTPSA id b14-20020a170902650e00b001621ce92196sm4480969plk.86.2022.06.03.11.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 11:58:03 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org, djwong@kernel.org
Cc:     Dave Chinner <david@fromorbit.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Serge Hallyn <serge@hallyn.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 10/15] xfs: don't generate selinux audit messages for capability testing
Date:   Fri,  3 Jun 2022 11:57:16 -0700
Message-Id: <20220603185721.3121645-10-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220603185721.3121645-1-leah.rumancik@gmail.com>
References: <20220603185721.3121645-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit eba0549bc7d100691c13384b774346b8aa9cf9a9 ]

There are a few places where we test the current process' capability set
to decide if we're going to be more or less generous with resource
acquisition for a system call.  If the process doesn't have the
capability, we can continue the call, albeit in a degraded mode.

These are /not/ the actual security decisions, so it's not proper to use
capable(), which (in certain selinux setups) causes audit messages to
get logged.  Switch them to has_capability_noaudit.

Fixes: 7317a03df703f ("xfs: refactor inode ownership change transaction/inode/quota allocation idiom")
Fixes: ea9a46e1c4925 ("xfs: only return detailed fsmap info if the caller has CAP_SYS_ADMIN")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
Acked-by: Serge Hallyn <serge@hallyn.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_fsmap.c  | 4 ++--
 fs/xfs/xfs_ioctl.c  | 2 +-
 fs/xfs/xfs_iops.c   | 2 +-
 kernel/capability.c | 1 +
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 48287caad28b..10e1cb71439e 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -864,8 +864,8 @@ xfs_getfsmap(
 	    !xfs_getfsmap_is_valid_device(mp, &head->fmh_keys[1]))
 		return -EINVAL;
 
-	use_rmap = capable(CAP_SYS_ADMIN) &&
-		   xfs_has_rmapbt(mp);
+	use_rmap = xfs_has_rmapbt(mp) &&
+		   has_capability_noaudit(current, CAP_SYS_ADMIN);
 	head->fmh_entries = 0;
 
 	/* Set up our device handlers. */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 09269f478df9..4bc1b2f7a303 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1270,7 +1270,7 @@ xfs_ioctl_setattr_get_trans(
 		goto out_error;
 
 	error = xfs_trans_alloc_ichange(ip, NULL, NULL, pdqp,
-			capable(CAP_FOWNER), &tp);
+			has_capability_noaudit(current, CAP_FOWNER), &tp);
 	if (error)
 		goto out_error;
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index a607d6aca5c4..01a8d3d239c2 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -744,7 +744,7 @@ xfs_setattr_nonsize(
 	}
 
 	error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL,
-			capable(CAP_FOWNER), &tp);
+			has_capability_noaudit(current, CAP_FOWNER), &tp);
 	if (error)
 		goto out_dqrele;
 
diff --git a/kernel/capability.c b/kernel/capability.c
index 46a361dde042..765194f5d678 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -360,6 +360,7 @@ bool has_capability_noaudit(struct task_struct *t, int cap)
 {
 	return has_ns_capability_noaudit(t, &init_user_ns, cap);
 }
+EXPORT_SYMBOL(has_capability_noaudit);
 
 static bool ns_capable_common(struct user_namespace *ns,
 			      int cap,
-- 
2.36.1.255.ge46751e96f-goog

