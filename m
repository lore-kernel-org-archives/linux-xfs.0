Return-Path: <SRS0=dEjd=3X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32350C35247
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Feb 2020 17:59:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C3E421582
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Feb 2020 17:59:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dhGMIBfO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729216AbgBCR7Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Feb 2020 12:59:16 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:32633 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729170AbgBCR7Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Feb 2020 12:59:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580752755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vk6Afv9yzZW8kjnafcJvt8ARcFdxjMpB5HqOy2tLYDI=;
        b=dhGMIBfONEyR+fNtMctkvZiclzRyvruQvnQuCMhudZkHQqZ9JSBtR0U5xMIbM5m0X9UXTh
        33qEe7xzlOQg8LckgF3O7DdoKAGRSCNq7Z2bIy+ZcWmNa1prVBmXTRdmZGmwuFlIDgev7j
        ebe2JKhv2YIFNFGHn7gn9+eOLYACzrI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-tnPFZbnoNSmi1ahpub-uIQ-1; Mon, 03 Feb 2020 12:59:06 -0500
X-MC-Unique: tnPFZbnoNSmi1ahpub-uIQ-1
Received: by mail-wr1-f71.google.com with SMTP id f10so8702871wro.14
        for <linux-xfs@vger.kernel.org>; Mon, 03 Feb 2020 09:59:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vk6Afv9yzZW8kjnafcJvt8ARcFdxjMpB5HqOy2tLYDI=;
        b=isX6p+pwWnnWkreH+ePoDi4Y02UKmslPi6bAwcPPb7IMfAR8BTYhPoGgPv98XgJcIw
         JgghWtlNRg3UeOzmfIOqdExantNP6PzOnQV+VQluP3wryBqlmWuzl+caXrMoj3r9Yl8W
         DZ/UD5sq97aKXE1zYYnNR7zVObtYFvVPaPtiEJmDiNMYb0p8rOLfiGkaV3nEMAgz0z4D
         K8IYBdvBCFEJdHitR+/Kg2Hroz6QtRn9aWCNOwTLatICYJcjwdtIJEa8ZdtIuL7rdyUg
         PS5f1Y7bX3wqi1i5tDjQB5o8oI3EIkGLzDaM7pJ5+hDRO6t3bOSCCoJZqND3oUx27TPm
         Xblw==
X-Gm-Message-State: APjAAAXzkJLgvMfz0AJP3/NvSjzCh5N6WAjaPTrPhvmESgUVcCqEJtgi
        rsXbnXT5Vd0BHTySzsXhaCbaeqGnJkFanEd05ZlD3IgtqFzpYCCEn5EathSumm7kTtR0KMKT+Q5
        Vx6JZdFWpqHG4E17iYmX5
X-Received: by 2002:adf:f7c6:: with SMTP id a6mr16995334wrq.164.1580752744915;
        Mon, 03 Feb 2020 09:59:04 -0800 (PST)
X-Google-Smtp-Source: APXvYqwYoT42YbOkJAH7NDum4bSb5vo/YTPA5RCwx+2gy3+9odcgRNMDl3Vxpo0y64kaM2ianRBoMw==
X-Received: by 2002:adf:f7c6:: with SMTP id a6mr16995325wrq.164.1580752744802;
        Mon, 03 Feb 2020 09:59:04 -0800 (PST)
Received: from localhost.localdomain.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id a132sm212274wme.3.2020.02.03.09.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 09:59:04 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH v2 5/7] xfs: Update checking for mmaplock
Date:   Mon,  3 Feb 2020 18:58:48 +0100
Message-Id: <20200203175850.171689-6-preichl@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200203175850.171689-1-preichl@redhat.com>
References: <20200203175850.171689-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Pavel Reichl <preichl@redhat.com>
Suggested-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 4 ++--
 fs/xfs/xfs_file.c      | 2 +-
 fs/xfs/xfs_iops.c      | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index ae0bccb2288f..377389fadf5a 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1066,7 +1066,7 @@ xfs_collapse_file_space(
 	bool			done = false;
 
 	ASSERT(xfs_is_iolocked(ip, XFS_IOLOCK_EXCL));
-	ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
+	ASSERT(xfs_is_mmaplocked(ip, XFS_MMAPLOCK_EXCL));
 
 	trace_xfs_collapse_file_space(ip);
 
@@ -1134,7 +1134,7 @@ xfs_insert_file_space(
 	bool			done = false;
 
 	ASSERT(xfs_is_iolocked(ip, XFS_IOLOCK_EXCL));
-	ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
+	ASSERT(xfs_is_mmaplocked(ip, XFS_MMAPLOCK_EXCL));
 
 	trace_xfs_insert_file_space(ip);
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 9b3958ca73d9..a4dbd9a6f45a 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -749,7 +749,7 @@ xfs_break_dax_layouts(
 {
 	struct page		*page;
 
-	ASSERT(xfs_isilocked(XFS_I(inode), XFS_MMAPLOCK_EXCL));
+	ASSERT(xfs_is_mmaplocked(XFS_I(inode), XFS_MMAPLOCK_EXCL));
 
 	page = dax_layout_busy_page(inode->i_mapping);
 	if (!page)
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index aad255521514..67a0f940b30e 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -866,7 +866,7 @@ xfs_setattr_size(
 	bool			did_zeroing = false;
 
 	ASSERT(xfs_is_iolocked(ip, XFS_IOLOCK_EXCL));
-	ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
+	ASSERT(xfs_is_mmaplocked(ip, XFS_MMAPLOCK_EXCL));
 	ASSERT(S_ISREG(inode->i_mode));
 	ASSERT((iattr->ia_valid & (ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
 		ATTR_MTIME_SET|ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
-- 
2.24.1

