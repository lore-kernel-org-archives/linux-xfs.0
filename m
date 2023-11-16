Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51983C5AE5C
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Nov 2023 02:28:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344474AbjKPC2p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Nov 2023 21:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344494AbjKPC2p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2023 21:28:45 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB8119D;
        Wed, 15 Nov 2023 18:28:42 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1cc5b705769so3234015ad.0;
        Wed, 15 Nov 2023 18:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700101722; x=1700706522; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1l7c99lO7Kt044APcQ6SeoGOHWP+XyS9KY7YFc7lY/c=;
        b=k2xCixeBhbTntcOoz62VUMyYbKukB8kRfXBEL5vuE3+DFCHOMJoF/CLgvqAtPHghMb
         3FWbA+Ap7+dbbvWU3m+6YNSd7NxfKtnbD9FuRCBj5Jr4s3cLShpMUqpjtzy+KYDJ7MfT
         c/PhdVbL5Mj9P7EVfHX2/qhFPk7ALslUxbr/v0Qzp3qR71P1gs6RF81LCWkeU8vJzht3
         DsW0ErlLUvdPAqYkHpscurS3Ukgks0MQtf3Hv4zlTlnxzLaeHxgE/oGCcY+x23t19ptS
         JJhjk1FIC66gyReJ5Df7aO4uJ2EIRkg3t6a/epYW54O25PZ1s4WKlpyjx+1++ZmUp+t+
         IZXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700101722; x=1700706522;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1l7c99lO7Kt044APcQ6SeoGOHWP+XyS9KY7YFc7lY/c=;
        b=BdN3hlZHZFuvm7mVQuIxzad+a/eLaxQPnqwRm4xcZ+1Jcpj378/mn9boGZL79WEcPa
         5Y/5EOqhOT3pN9DlNcprbL1jtaVYPYSP6drvmerOr3JDnL3o5CwQla32ejriQh5kvDEX
         14r1j2oQZNjIIxK2g0xD9C3Pzqa4LcQ4zGI5k5mkIyNgwsNWwt51in+gpMT5m9xNxD19
         Idz1/f+nyPp5BcEj+s4WnICHgnyrv47OxM4ZIz0IXsviXks6zkUkQ1Osf8OkmPWQrHSH
         0VSf1t4t8Gl5T8qejK1gn8oWtJq5ZYHhl08/6j+j+eoz6f2Ww+DChB4hekOqSAjqftbX
         Ga3w==
X-Gm-Message-State: AOJu0Yy7TL3WBMEsdnngmA5GKe3rOsHZYN3xF1t+27UccJHHvIFvOwpe
        +5nMb+zMnaq+vqCJjF5Xjigiw02Tes+VJA==
X-Google-Smtp-Source: AGHT+IHH5XGnOwIQjM6c4FMzHBjl+Sy6NmLV8CSKNrz9fCFgxscCH0nHd/48WWMwgDACNp7HfSHD1w==
X-Received: by 2002:a17:902:9a92:b0:1cc:4e79:4b38 with SMTP id w18-20020a1709029a9200b001cc4e794b38mr6428914plp.3.1700101721771;
        Wed, 15 Nov 2023 18:28:41 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:25ea:d6bb:623c:d6a0])
        by smtp.gmail.com with ESMTPSA id j9-20020a170903024900b001b8b1f6619asm8087072plh.75.2023.11.15.18.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Nov 2023 18:28:41 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, fred@cloudflare.com,
        Kaixu Xia <kaixuxia@tencent.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 5.15 04/17] xfs: use invalidate_lock to check the state of mmap_lock
Date:   Wed, 15 Nov 2023 18:28:20 -0800
Message-ID: <20231116022833.121551-4-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231116022833.121551-1-leah.rumancik@gmail.com>
References: <20231116022833.121551-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

[ Upstream commit 82af88063961da9425924d9aec3fb67a4ebade3e ]

We should use invalidate_lock and XFS_MMAPLOCK_SHARED to check the state
of mmap_lock rw_semaphore in xfs_isilocked(), rather than i_rwsem and
XFS_IOLOCK_SHARED.

Fixes: 2433480a7e1d ("xfs: Convert to use invalidate_lock")
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/xfs_inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b2ea85318214..df64b902842d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -378,8 +378,8 @@ xfs_isilocked(
 	}
 
 	if (lock_flags & (XFS_MMAPLOCK_EXCL|XFS_MMAPLOCK_SHARED)) {
-		return __xfs_rwsem_islocked(&VFS_I(ip)->i_rwsem,
-				(lock_flags & XFS_IOLOCK_SHARED));
+		return __xfs_rwsem_islocked(&VFS_I(ip)->i_mapping->invalidate_lock,
+				(lock_flags & XFS_MMAPLOCK_SHARED));
 	}
 
 	if (lock_flags & (XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED)) {
-- 
2.43.0.rc0.421.g78406f8d94-goog

