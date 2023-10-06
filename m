Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03934E94102
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Oct 2023 18:56:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233467AbjJFS4D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Oct 2023 14:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233407AbjJFSzW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2023 14:55:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C28011B
        for <linux-xfs@vger.kernel.org>; Fri,  6 Oct 2023 11:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696618368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y62cirHyxw1nxIK5GngI9l6eX0UynAIUbjFVCcsuark=;
        b=gEgd4Y8eAXVuUTVx0z9mba4ziKvurDO3mdWmsmZJKXbjKMTeSFIzevBMiSKQyr9cfWrV3l
        Iy4+9JJjEjoxlex2kdAyHMHvDQK0CQ4e9O5d6gV+5msNofjlOzJ03xh5pwhnUiUqnRJ7vV
        H+o3m+76PGZ3usP9AoKRdDmMIAVEE6g=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-157-UFtwsHujNRusNdn-u6GsMA-1; Fri, 06 Oct 2023 14:52:42 -0400
X-MC-Unique: UFtwsHujNRusNdn-u6GsMA-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-9b95fa56bd5so210982666b.0
        for <linux-xfs@vger.kernel.org>; Fri, 06 Oct 2023 11:52:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696618361; x=1697223161;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y62cirHyxw1nxIK5GngI9l6eX0UynAIUbjFVCcsuark=;
        b=h6MzdqVq4W+yqsFcye3NxJRbrf3QNLcWx4CzL4j/1HP5gmu9aL44PUObo4Q9+PGJa3
         cFU6ZFE+yUKEN6nyU1SNwJE5iJTfJeyP0mMrqukh+5X2eP1pMP6MygNHZWC8wnhw+vcq
         970GVjKBd+tP69jpief1SWDO36TmYHAuhIpIRO2tFat3VuBM8igNUYCAwUg2CuA8oKh5
         XTzgvTO9Zx/zRfrCTPiGWadBfGkAfOt5V+C6ZyyaXj+2Sj9yTBaspJDnkyZ2UtQSVdFh
         5q5bY6rhZjchsSg9aadoB7BF9ls+n7UD7mgLMmuD+cU9bbUpu4YL1tuEKzCQvPwj/w16
         sniA==
X-Gm-Message-State: AOJu0Yy3AshCRokWJQaHWdar6T0fneAnCNVydp258MCSdZ9ZKdEUBp3D
        /hikiYmjlFlWv6QGAnw2wTJ7FSZt87XLB6qI+2o9szHTp3Tbf8q++5ncUb6ReoIZUJusdZfhCp9
        tRhKvkB7KP081yQ0y88G9o4rkDeq5ywGt7JaM8XpPjTUajqln4v5N1XjQ+qZhrFWiM+0VZTk6I0
        0Uk0c=
X-Received: by 2002:a17:906:3ca9:b0:9ba:7f5:3602 with SMTP id b9-20020a1709063ca900b009ba07f53602mr583734ejh.60.1696618361094;
        Fri, 06 Oct 2023 11:52:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFVZ+8RYyWx/WXsHj7JKes+e1LLF/dLUz0XxHhOXmY4bfEBU5dLyL1gt2j4iCnrrEatFiiqNw==
X-Received: by 2002:a17:906:3ca9:b0:9ba:7f5:3602 with SMTP id b9-20020a1709063ca900b009ba07f53602mr583721ejh.60.1696618360843;
        Fri, 06 Oct 2023 11:52:40 -0700 (PDT)
Received: from localhost.localdomain ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id os5-20020a170906af6500b009b947f81c4asm3304741ejb.155.2023.10.06.11.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Oct 2023 11:52:40 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev
Cc:     djwong@kernel.org, ebiggers@kernel.org, david@fromorbit.com,
        dchinner@redhat.com, Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v3 24/28] xfs: disable direct read path for fs-verity sealed files
Date:   Fri,  6 Oct 2023 20:49:18 +0200
Message-Id: <20231006184922.252188-25-aalbersh@redhat.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231006184922.252188-1-aalbersh@redhat.com>
References: <20231006184922.252188-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The direct path is not supported on verity files. Attempts to use direct
I/O path on such files should fall back to buffered I/O path.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/xfs_file.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index a92c8197c26a..7363cbdff803 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -244,7 +244,8 @@ xfs_file_dax_read(
 	struct kiocb		*iocb,
 	struct iov_iter		*to)
 {
-	struct xfs_inode	*ip = XFS_I(iocb->ki_filp->f_mapping->host);
+	struct inode		*inode = iocb->ki_filp->f_mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret = 0;
 
 	trace_xfs_file_dax_read(iocb, to);
@@ -297,10 +298,17 @@ xfs_file_read_iter(
 
 	if (IS_DAX(inode))
 		ret = xfs_file_dax_read(iocb, to);
-	else if (iocb->ki_flags & IOCB_DIRECT)
+	else if (iocb->ki_flags & IOCB_DIRECT && !fsverity_active(inode))
 		ret = xfs_file_dio_read(iocb, to);
-	else
+	else {
+		/*
+		 * In case fs-verity is enabled, we also fallback to the
+		 * buffered read from the direct read path. Therefore,
+		 * IOCB_DIRECT is set and need to be cleared
+		 */
+		iocb->ki_flags &= ~IOCB_DIRECT;
 		ret = xfs_file_buffered_read(iocb, to);
+	}
 
 	if (ret > 0)
 		XFS_STATS_ADD(mp, xs_read_bytes, ret);
-- 
2.40.1

