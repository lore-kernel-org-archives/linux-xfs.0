Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 668D1C3DA6F
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Aug 2023 22:03:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238475AbjHWWCi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Aug 2023 18:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236802AbjHWWCc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Aug 2023 18:02:32 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D894198
        for <linux-xfs@vger.kernel.org>; Wed, 23 Aug 2023 15:02:30 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 98e67ed59e1d1-26fc9e49859so345629a91.0
        for <linux-xfs@vger.kernel.org>; Wed, 23 Aug 2023 15:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1692828150; x=1693432950;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Orxzwh2gPoCeF4lHNlyJE70A8w54bo9et+AF5wdSb9E=;
        b=aTHlN3ctOYPcJ2Kks04t/9N5x2RdMLW8R4m+eJ+h2h5pZneJPcc7FoUXS+taqrXu9Y
         M/SALnG3MONoBY9xrcE1T12eo6bWHbbV4rAfSppM+bfjo/439eJ6W3FpVGUtEJ79alq9
         cUOKwnX4Zwb9YlJnXYL7UPBw12ncv69b/eLVBzur5zGHrbtfkjUTdsGlKYAni/ZImIU6
         Rcpagb8J2v7sIxhdTRPssVudXZU9rHCeYdeaV0l3KI7wKa17EsE5QC/l+pedP0A+xVh6
         TWu+OSq2VcplMaC+WXGzpEzGrEW3mnmUu8KMGJbRa6Uv0FXMbJ2ZirInTyJWnwYFWGPc
         dITQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692828150; x=1693432950;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Orxzwh2gPoCeF4lHNlyJE70A8w54bo9et+AF5wdSb9E=;
        b=ElrBvzGLUUWjgvvw7vD0UOdXE24JZOClO9UJeOTzOI815ZIIuqXAkQ8qha1L3KoY7i
         GL+WMyuLoirJZMGKKlF8mg/3cZBYVDH/Vi2kwecc7TMeLW19vL2ZX39peP02u8tQuiBs
         qPm182k2sQL2Ec8O7sBFNorBxeJXD9vkjlaWCRUWhKjSYMeesREKZFTYd4kALchtGT1/
         UHdf1Z7nEWe6iUaKohdr0k+ZYJc4mvjT/UE/YFBlnCbalfL7HZNEEeZ5hLpF0cH0tOy3
         E/3NzTdNkOc9gR2Bnj5fdgQrPp7hG85gGw7pYlhAosJP7Lm57Fm1N3aMveh/m5Y337OY
         CyiQ==
X-Gm-Message-State: AOJu0YwUlE1r6SaFr6/TEL7SaukUJKBdyqEOfTOvsTOLzcl3qT2tcT6Y
        TJXyLbLHTLA32DQWG3jU8DfoZelo9kfsTe6Xgxk=
X-Google-Smtp-Source: AGHT+IEe2seHM+atnOzRqhMzBNABqnLXz0wUvNANjtplcSnOORAdTQfkIqpdnoJCPNS+AL7Unye7uA==
X-Received: by 2002:a17:90a:414c:b0:269:621e:a673 with SMTP id m12-20020a17090a414c00b00269621ea673mr10881262pjg.1.1692828149808;
        Wed, 23 Aug 2023 15:02:29 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id z19-20020a17090a541300b0026b26181ac9sm242370pjh.14.2023.08.23.15.02.28
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Aug 2023 15:02:28 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1qYvvl-005csu-2X
        for linux-xfs@vger.kernel.org;
        Thu, 24 Aug 2023 08:02:25 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1qYvvl-00F4Dk-1E
        for linux-xfs@vger.kernel.org;
        Thu, 24 Aug 2023 08:02:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: read only mounts with fsopen mount API are busted
Date:   Thu, 24 Aug 2023 08:02:25 +1000
Message-Id: <20230823220225.3591135-1-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Recently xfs/513 started failing on my test machines testing "-o
ro,norecovery" mount options. This was being emitted in dmesg:

[ 9906.932724] XFS (pmem0): no-recovery mounts must be read-only.

Turns out, readonly mounts with the fsopen()/fsconfig() mount API
have been busted since day zero. It's only taken 5 years for debian
unstable to start using this "new" mount API, and shortly after this
I noticed xfs/513 had started to fail as per above.

The syscall trace is:

fsopen("xfs", FSOPEN_CLOEXEC)           = 3
mount_setattr(-1, NULL, 0, NULL, 0)     = -1 EINVAL (Invalid argument)
.....
fsconfig(3, FSCONFIG_SET_STRING, "source", "/dev/pmem0", 0) = 0
fsconfig(3, FSCONFIG_SET_FLAG, "ro", NULL, 0) = 0
fsconfig(3, FSCONFIG_SET_FLAG, "norecovery", NULL, 0) = 0
fsconfig(3, FSCONFIG_CMD_CREATE, NULL, NULL, 0) = -1 EINVAL (Invalid argument)
close(3)                                = 0

Showing that the actual mount instantiation (FSCONFIG_CMD_CREATE) is
what threw out the error.

During mount instantiation, we call xfs_fs_validate_params() which
does:

        /* No recovery flag requires a read-only mount */
        if (xfs_has_norecovery(mp) && !xfs_is_readonly(mp)) {
                xfs_warn(mp, "no-recovery mounts must be read-only.");
                return -EINVAL;
        }

and xfs_is_readonly() checks internal mount flags for read only
state. This state is set in xfs_init_fs_context() from the
context superblock flag state:

        /*
         * Copy binary VFS mount flags we are interested in.
         */
        if (fc->sb_flags & SB_RDONLY)
                set_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);

With the old mount API, all of the VFS specific superblock flags
had already been parsed and set before xfs_init_fs_context() is
called, so this all works fine.

However, in the brave new fsopen/fsconfig world,
xfs_init_fs_context() is called from fsopen() context, before any
VFS superblock have been set or parsed. Hence if we use fsopen(),
the internal XFS readonly state is *never set*. Hence anything that
depends on xfs_is_readonly() actually returning true for read only
mounts is broken if fsopen() has been used to mount the filesystem.

Fix this by moving this internal state initialisation to
xfs_fs_fill_super() before we attempt to validate the parameters
that have been set prior to the FSCONFIG_CMD_CREATE call being made.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_super.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 09638e8fb4ee..8ca01510628b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1509,6 +1509,18 @@ xfs_fs_fill_super(
 
 	mp->m_super = sb;
 
+	/*
+	 * Copy VFS mount flags from the context now that all parameter parsing
+	 * is guaranteed to have been completed by either the old mount API or
+	 * the newer fsopen/fsconfig API.
+	 */
+	if (fc->sb_flags & SB_RDONLY)
+		set_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
+	if (fc->sb_flags & SB_DIRSYNC)
+		mp->m_features |= XFS_FEAT_DIRSYNC;
+	if (fc->sb_flags & SB_SYNCHRONOUS)
+		mp->m_features |= XFS_FEAT_WSYNC;
+
 	error = xfs_fs_validate_params(mp);
 	if (error)
 		goto out_free_names;
@@ -1988,6 +2000,11 @@ static const struct fs_context_operations xfs_context_ops = {
 	.free        = xfs_fs_free,
 };
 
+/*
+ * WARNING: do not initialise any parameters in this function that depend on
+ * mount option parsing having already been performed as this can be called from
+ * fsopen() before any parameters have been set.
+ */
 static int xfs_init_fs_context(
 	struct fs_context	*fc)
 {
@@ -2019,16 +2036,6 @@ static int xfs_init_fs_context(
 	mp->m_logbsize = -1;
 	mp->m_allocsize_log = 16; /* 64k */
 
-	/*
-	 * Copy binary VFS mount flags we are interested in.
-	 */
-	if (fc->sb_flags & SB_RDONLY)
-		set_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
-	if (fc->sb_flags & SB_DIRSYNC)
-		mp->m_features |= XFS_FEAT_DIRSYNC;
-	if (fc->sb_flags & SB_SYNCHRONOUS)
-		mp->m_features |= XFS_FEAT_WSYNC;
-
 	fc->s_fs_info = mp;
 	fc->ops = &xfs_context_ops;
 
-- 
2.40.1

