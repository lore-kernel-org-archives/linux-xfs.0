Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A07AC10F1D
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Dec 2022 17:31:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236300AbiLMRa6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 12:30:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236296AbiLMRai (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 12:30:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBAC822B3E
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 09:29:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670952587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DMVdYEIjGzzgVCYG3YnfAdNBSxBfSOUyway7T/qxVAM=;
        b=RLQARqNKkgbuw0LbqfoQP3qe6kpa9twIKV43StAwJVGvc1Ybuw9cVfVS5+Vzv98UWexq/q
        cpk8wuO/+aNQZZhqz2cBRPDfTNxkWLN1a26XTTP1lV/sQ3VYa5ZEbujhKggjSln3eFe20h
        FuZrJgDdkqKx0VqARtWFR6JlDloDb1c=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-211-4IGDLpM1NIaISE_w-imXEg-1; Tue, 13 Dec 2022 12:29:46 -0500
X-MC-Unique: 4IGDLpM1NIaISE_w-imXEg-1
Received: by mail-ed1-f72.google.com with SMTP id m18-20020a056402511200b0046db14dc1c9so7719492edd.10
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 09:29:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DMVdYEIjGzzgVCYG3YnfAdNBSxBfSOUyway7T/qxVAM=;
        b=S3XkeozkU0HFYVeWmRG5gHN9uVvhdB6ubDTU1NCfKGYdy5SL2Foa+LBEs/tyM6DF8a
         f0lz3BlCMYULzo3ZAeAZIC+Jm2/jkS0PSlr9KwtqLkHxseDYT24pr2xCKEvfWsXFGuXd
         P1a2sR2ZwABgYYwGwM5bQMkIXjytGV0iUayJ/od6/rL0AgwBDJ6AjGiNcEE86GsiVpwS
         NVMb8r/pZBB+gY0MROoZlwK4ZL8kXub2PJgNawDoicvSHp0wKl82CV7O3yFA3dJpmoHx
         QFbrowQ+bD2O5qh/fMmpToGOBkfIrCY+fGD5OYfqGnfQPTKlIMO/+sPKblGuoEJ0TnvP
         SMBQ==
X-Gm-Message-State: ANoB5plWqxVeLskASkl7tasr2BSUJDbyBHAQkY2c7DzwScYfY8GcMf1h
        pcQBP3RGwP1fISTOM+fJc8X5YiHZ4mTONQ+GXUQhCBKLK01FZU6TeNV2ovJ628sKx3hCLiolRXv
        WDc/xyf5JzpZ3nBQ4SkTZ0JAAKm4m/7aV+yKRiFEZTI37VZiIY1g03tCj3L9OXkavzV3XPd4=
X-Received: by 2002:a05:6402:f19:b0:46f:7453:a999 with SMTP id i25-20020a0564020f1900b0046f7453a999mr17902911eda.39.1670952584767;
        Tue, 13 Dec 2022 09:29:44 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5dpb+BtrXOV48EoDvxcYKIw/k9+7UnUHv1T33vANcGszfmmkbpje/gNx4hIvVmQXcwPVhXtQ==
X-Received: by 2002:a05:6402:f19:b0:46f:7453:a999 with SMTP id i25-20020a0564020f1900b0046f7453a999mr17902886eda.39.1670952584513;
        Tue, 13 Dec 2022 09:29:44 -0800 (PST)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id ec14-20020a0564020d4e00b0047025bf942bsm1204187edb.16.2022.12.13.09.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 09:29:43 -0800 (PST)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     Andrey Albershteyn <aalbersh@redhat.com>
Subject: [RFC PATCH 06/11] xfs: initialize fs-verity on file open and cleanup on inode destruction
Date:   Tue, 13 Dec 2022 18:29:30 +0100
Message-Id: <20221213172935.680971-7-aalbersh@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221213172935.680971-1-aalbersh@redhat.com>
References: <20221213172935.680971-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

fs-verity will read and attach metadata (not the tree itself) from
a disk for those inodes which already have fs-verity enabled.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/xfs_file.c  | 8 ++++++++
 fs/xfs/xfs_super.c | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 242165580e682..5eadd9a37c50e 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -32,6 +32,7 @@
 #include <linux/mman.h>
 #include <linux/fadvise.h>
 #include <linux/mount.h>
+#include <linux/fsverity.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -1170,9 +1171,16 @@ xfs_file_open(
 	struct inode	*inode,
 	struct file	*file)
 {
+	int		error = 0;
+
 	if (xfs_is_shutdown(XFS_M(inode->i_sb)))
 		return -EIO;
 	file->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC | FMODE_BUF_WASYNC;
+
+	error = fsverity_file_open(inode, file);
+	if (error)
+		return error;
+
 	return generic_file_open(inode, file);
 }
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 8f1e9b9ed35d9..50c2c819ba940 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -45,6 +45,7 @@
 #include <linux/magic.h>
 #include <linux/fs_context.h>
 #include <linux/fs_parser.h>
+#include <linux/fsverity.h>
 
 static const struct super_operations xfs_super_operations;
 
@@ -647,6 +648,7 @@ xfs_fs_destroy_inode(
 	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
 	XFS_STATS_INC(ip->i_mount, vn_rele);
 	XFS_STATS_INC(ip->i_mount, vn_remove);
+	fsverity_cleanup_inode(inode);
 	xfs_inode_mark_reclaimable(ip);
 }
 
-- 
2.31.1

