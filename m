Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E2D2E94105
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Oct 2023 18:56:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233407AbjJFS4E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Oct 2023 14:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233381AbjJFSz1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2023 14:55:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E254121
        for <linux-xfs@vger.kernel.org>; Fri,  6 Oct 2023 11:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696618375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qlegwzOxx57sBL8Xx+R890G6fTt4C0TsMKqp0ENYz8k=;
        b=Ksv2D6ijTF0kQlL/1IllbmNG8JfLxd7MiBx+tRgVNp+iFBlb3qgW5xld7w3b+TuWhCGBTl
        4O8t3s344e/IXtls6iUkVmM0m7c/5puCxepVoPMAtPgTqwtOFqo5KuJWJr9FYHH7C2n+wf
        RK4NrPhTTGffZxG4hKkEnhinG+Dv6BI=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-D5Vui-r1NWCJOhCtwfisPQ-1; Fri, 06 Oct 2023 14:52:38 -0400
X-MC-Unique: D5Vui-r1NWCJOhCtwfisPQ-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-9b97f1b493dso213871366b.3
        for <linux-xfs@vger.kernel.org>; Fri, 06 Oct 2023 11:52:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696618357; x=1697223157;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qlegwzOxx57sBL8Xx+R890G6fTt4C0TsMKqp0ENYz8k=;
        b=CBo1jVynqHzXpB6two9n9B7vQ2LKfpAxNokHxxbiCx8h6lcVx/shDLPBDNF+IdYUoB
         JG1xFL7A3TdCckJs1E7h5mpCZsraBoPCAy0Z99RUEe1COP+KbU0mFV915h/2m5uQ39nw
         BAv37Eqolr2my51LeXH7sElWcqeIaAKfF2BGlPRQhUnFBI6Q+5K50zY72dK9wG6O+I23
         DCH1BfI6pi/I6wU/RHuhSmjqCQmjbit/rcRXti1beXua/vjx0p/8EyC6CrVsJBtsnZui
         Xs5qaA5rtJ3539bojKHJA+Nd4zEuij4+452/LU+/EpZoXTbWRaHc8Ffq//U8pZob9A64
         Uz2Q==
X-Gm-Message-State: AOJu0YwpJ5Qa5UFVwYVzgK2QlDr48/5zk+Gea+F68Az5EjMOHadf8coS
        4Ufu9Lze2mzbQlRm/C35Dyop9BcGwxA6hMCyZCMM2E0SmKud4LuYIWlXaPpsOsLaVg/I1M1xvSj
        htRyFQWXZtz7DcPkcjc/A8gw+TwrrLk3bRtP0St5iDQb4HNxI5wXeQLva3Afle9MdhiDAby/XWL
        793Bw=
X-Received: by 2002:a17:907:6c14:b0:9b6:f0e2:3c00 with SMTP id rl20-20020a1709076c1400b009b6f0e23c00mr6945552ejc.71.1696618357557;
        Fri, 06 Oct 2023 11:52:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFo5vp/wd7qpBKfMbuZSMXz/ISlutAnm5zYJOvUQd8UYNLU/1/w0Jimk88atuRtU9Ktn/yTFQ==
X-Received: by 2002:a17:907:6c14:b0:9b6:f0e2:3c00 with SMTP id rl20-20020a1709076c1400b009b6f0e23c00mr6945540ejc.71.1696618357335;
        Fri, 06 Oct 2023 11:52:37 -0700 (PDT)
Received: from localhost.localdomain ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id os5-20020a170906af6500b009b947f81c4asm3304741ejb.155.2023.10.06.11.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Oct 2023 11:52:36 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev
Cc:     djwong@kernel.org, ebiggers@kernel.org, david@fromorbit.com,
        dchinner@redhat.com, Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v3 20/28] xfs: add fs-verity ro-compat flag
Date:   Fri,  6 Oct 2023 20:49:14 +0200
Message-Id: <20231006184922.252188-21-aalbersh@redhat.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231006184922.252188-1-aalbersh@redhat.com>
References: <20231006184922.252188-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

To mark inodes sealed with fs-verity the new XFS_DIFLAG2_VERITY flag
will be added in further patch. This requires ro-compat flag to let
older kernels know that fs with fs-verity can not be modified.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h | 1 +
 fs/xfs/libxfs/xfs_sb.c     | 2 ++
 fs/xfs/xfs_mount.h         | 2 ++
 3 files changed, 5 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 371dc07233e0..ef617be2839c 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -353,6 +353,7 @@ xfs_sb_has_compat_feature(
 #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
 #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
 #define XFS_SB_FEAT_RO_COMPAT_INOBTCNT (1 << 3)		/* inobt block counts */
+#define XFS_SB_FEAT_RO_COMPAT_VERITY   (1 << 4)		/* fs-verity */
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
 		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 4191da4fb669..236f3b833fa4 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -162,6 +162,8 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_REFLINK;
 	if (sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_INOBTCNT)
 		features |= XFS_FEAT_INOBTCNT;
+	if (sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_VERITY)
+		features |= XFS_FEAT_VERITY;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_FTYPE)
 		features |= XFS_FEAT_FTYPE;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_SPINODES)
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 3d77844b255e..95fba704f60e 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -288,6 +288,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_BIGTIME	(1ULL << 24)	/* large timestamps */
 #define XFS_FEAT_NEEDSREPAIR	(1ULL << 25)	/* needs xfs_repair */
 #define XFS_FEAT_NREXT64	(1ULL << 26)	/* large extent counters */
+#define XFS_FEAT_VERITY		(1ULL << 27)	/* fs-verity */
 
 /* Mount features */
 #define XFS_FEAT_NOATTR2	(1ULL << 48)	/* disable attr2 creation */
@@ -351,6 +352,7 @@ __XFS_HAS_FEAT(inobtcounts, INOBTCNT)
 __XFS_HAS_FEAT(bigtime, BIGTIME)
 __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
 __XFS_HAS_FEAT(large_extent_counts, NREXT64)
+__XFS_HAS_FEAT(verity, VERITY)
 
 /*
  * Mount features
-- 
2.40.1

