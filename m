Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF21EC7618B
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Mar 2023 11:08:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbjCQLId (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Mar 2023 07:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjCQLIc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2023 07:08:32 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44FE126C1D
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 04:08:31 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id ay8so3083750wmb.1
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 04:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679051310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KgTIRGgLDwbCat3zch5MMu/wejmfIPRpBTIP2AxcCWU=;
        b=g+zR8siU+smn8fZj5QeFn+aL3pqec0y66jKRBs/+Owf0NS2AkylDjMYTWdnhyRlFk3
         cB9p2w6sy+mAnanHQmUWY1FAfWBKtj/TTxE+gC8iuDvNXs0KB4z3fS6fMwFLOGH2r1Jr
         TWjQIBkzdtdZZbmWVldrVJwxVwW7eWkkQV3asdE7Ummk8QV0ZHUtObvmy0+SOhlCRqrI
         W7QTl+WrlWgrWWdSDJMJs3yONivPxlFWr4HcUbZyzDJL3zOWYL4dra2LBudkPNif97S8
         e9OiEYaopCieHsvKkQ3gffSt6A1qwXh4Zk+/5jc4g6bZBbtt8uo0+2cNHRBu0l6WL7NC
         hi5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679051310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KgTIRGgLDwbCat3zch5MMu/wejmfIPRpBTIP2AxcCWU=;
        b=wURPVrj1dp1TtOxpt8DGTUTI+Z+9IG1QsgiEUE/cVq8cYGn/dZUNn1DqIv3iFP0Mrg
         Fk5M05cenpTfCvjeH3MGlaQ9mOKKXyi3AIKK0lBbArZQecIw7lJO3shJIFfb13mwl3n2
         PX7n7WKNtayRMEuPriWRhJMRxffpvfxoQdGdxmKaxOa8Aq5NodweOZSMDTlq2sSKax3o
         1zZBGu1I+MhFc61P/NUwwks+a2tmRS0VXDr6bIUXzUTEBjZK8OJRtwNBZAGg+IQ7WpCv
         H8wXpsoJEFdwveIw2M7HtiyHBLu9dnYD3KHP4YXjtNDpwfq/jYncEE+azxSvLw3HXeaA
         fekQ==
X-Gm-Message-State: AO0yUKVw0lsyCQY6MipYUhBRraRr36grlrRWgIjI/rrkniJMRXEVrHWZ
        PuCwQR57he5rZW0ePu108eQ=
X-Google-Smtp-Source: AK7set+LwgpLMU2STAx+K5FMnSCS1zErGa57/lFYQQZOXsuBPbY34MdY7y4J2r1sFOqlLI2tJVpj/Q==
X-Received: by 2002:a05:600c:450c:b0:3ea:e7e7:95d9 with SMTP id t12-20020a05600c450c00b003eae7e795d9mr25786006wmo.32.1679051309779;
        Fri, 17 Mar 2023 04:08:29 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id t14-20020a1c770e000000b003daf7721bb3sm7551100wmi.12.2023.03.17.04.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 04:08:29 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 5.10 CANDIDATE 04/15] xfs: remove XFS_PREALLOC_SYNC
Date:   Fri, 17 Mar 2023 13:08:06 +0200
Message-Id: <20230317110817.1226324-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230317110817.1226324-1-amir73il@gmail.com>
References: <20230317110817.1226324-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit 472c6e46f589c26057596dcba160712a5b3e02c5 upstream.

[partial backport for dependency -
 xfs_ioc_space() still uses XFS_PREALLOC_SYNC]

Callers can acheive the same thing by calling xfs_log_force_inode()
after making their modifications. There is no need for
xfs_update_prealloc_flags() to do this.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_file.c | 13 +++++++------
 fs/xfs/xfs_pnfs.c |  6 ++++--
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 4d6bf8d4974f..630525b1da77 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -94,8 +94,6 @@ xfs_update_prealloc_flags(
 		ip->i_d.di_flags &= ~XFS_DIFLAG_PREALLOC;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	if (flags & XFS_PREALLOC_SYNC)
-		xfs_trans_set_sync(tp);
 	return xfs_trans_commit(tp);
 }
 
@@ -1000,9 +998,6 @@ xfs_file_fallocate(
 		}
 	}
 
-	if (file->f_flags & O_DSYNC)
-		flags |= XFS_PREALLOC_SYNC;
-
 	error = xfs_update_prealloc_flags(ip, flags);
 	if (error)
 		goto out_unlock;
@@ -1024,8 +1019,14 @@ xfs_file_fallocate(
 	 * leave shifted extents past EOF and hence losing access to
 	 * the data that is contained within them.
 	 */
-	if (do_file_insert)
+	if (do_file_insert) {
 		error = xfs_insert_file_space(ip, offset, len);
+		if (error)
+			goto out_unlock;
+	}
+
+	if (file->f_flags & O_DSYNC)
+		error = xfs_log_force_inode(ip);
 
 out_unlock:
 	xfs_iunlock(ip, iolock);
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index f3082a957d5e..64ab54f2fe81 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -164,10 +164,12 @@ xfs_fs_map_blocks(
 		 * that the blocks allocated and handed out to the client are
 		 * guaranteed to be present even after a server crash.
 		 */
-		error = xfs_update_prealloc_flags(ip,
-				XFS_PREALLOC_SET | XFS_PREALLOC_SYNC);
+		error = xfs_update_prealloc_flags(ip, XFS_PREALLOC_SET);
+		if (!error)
+			error = xfs_log_force_inode(ip);
 		if (error)
 			goto out_unlock;
+
 	} else {
 		xfs_iunlock(ip, lock_flags);
 	}
-- 
2.34.1

