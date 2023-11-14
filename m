Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A475C072A2
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Nov 2023 01:54:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbjKNByB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Nov 2023 20:54:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231994AbjKNByA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Nov 2023 20:54:00 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C996CD43
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2023 17:53:57 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1cc53d0030fso39781415ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2023 17:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699926837; x=1700531637; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YtjOAwAJuUbl1czCrCB3hFccBzCToeEvPWckZjUsxlw=;
        b=WRu4weAnZ0BmxqlHt/AOmb6JlYEQReljcK1CKABzqb9TQxtcapVeTC4zTxxPPWOfUR
         kDb5JqyY4pj18rzN+ylD1f1R4DIo1x2GMidOgxaD1bL1kkM4u2C4iSB8cf2Y+AXgG8sV
         pyjXQktPY5hUpHgTb7xvbVkSbteCcW8PCrvKYiutDfXxwIa44kLKqQ5FXwsEzon+WEOk
         I3SdlYusE5k/zgi3zEIxxcW7A+/IhSiLJnjeTIMV6zFaphMtw04fFsUrtBB5QCmFVR2m
         ref0CxBrwa/qa7PynLObU0SDkkle8KnQ7acWOnv8LiqQf0cT0aHOOHCMvadWbxLrVh6J
         2WWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699926837; x=1700531637;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YtjOAwAJuUbl1czCrCB3hFccBzCToeEvPWckZjUsxlw=;
        b=V4uwY2VjIb8y3E/TmJqRhZ/ztWstyV1Y155+PGifrNA/vZ+HvkwauVDn1GAS1UvD1Z
         Jp6jwNDXqL9UlbLKNaktvFZg3WTiKEPsAcOgJmNWLxHjZT29ePc3YpDejrDKrdr+/RLK
         JkVMnbSlQh9MUVbwF6Fadpen8Rslwe9qqKyhah3oY9+o8CgSk8ku6jnIg6DGs1j6CXO9
         s7PzG5gWu0EWBs9gMi0kH7SkUfxP+5c35HI2XqGNBJJwW6+wTAvskBjziAfDYw21qWxE
         cBSaBHrnJidpX9EcFDRi1ikGKlKq9vWYYI3NHKYl+cLmyO/tK/j3EZrdmMCbZ9XjCigK
         AfGg==
X-Gm-Message-State: AOJu0YwDhy0EnbEA+jD3gugdsNO8cYItz9nhy4iH+peiCY0mW3j8JX4t
        y3B/sC7snnqzgdLIwqFI4/hpEH5G8xRnZw==
X-Google-Smtp-Source: AGHT+IHCKf3unWQoQj+Q2EDa2ZaD73wYN5ERs2u2e7HkYFdDU7yWSYf6x6JiyIyxJ/pq6hRdiwTUhw==
X-Received: by 2002:a17:903:22c3:b0:1cc:436f:70c2 with SMTP id y3-20020a17090322c300b001cc436f70c2mr1318893plg.9.1699926837085;
        Mon, 13 Nov 2023 17:53:57 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:d177:a8ad:804f:74f1])
        by smtp.gmail.com with ESMTPSA id a17-20020a170902ecd100b001c9cb2fb8d8sm4668592plh.49.2023.11.13.17.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 17:53:56 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com, fred@cloudflare.com,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 11/17] xfs: add missing cmap->br_state = XFS_EXT_NORM update
Date:   Mon, 13 Nov 2023 17:53:32 -0800
Message-ID: <20231114015339.3922119-12-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231114015339.3922119-1-leah.rumancik@gmail.com>
References: <20231114015339.3922119-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 1a39ae415c1be1e46f5b3f97d438c7c4adc22b63 ]

COW extents are already converted into written real extents after
xfs_reflink_convert_cow_locked(), therefore cmap->br_state should
reflect it.

Otherwise, there is another necessary unwritten convertion
triggered in xfs_dio_write_end_io() for direct I/O cases.

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_reflink.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 36832e4bc803..628ce65d02bb 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -425,7 +425,10 @@ xfs_reflink_allocate_cow(
 	if (!convert_now || cmap->br_state == XFS_EXT_NORM)
 		return 0;
 	trace_xfs_reflink_convert_cow(ip, cmap);
-	return xfs_reflink_convert_cow_locked(ip, offset_fsb, count_fsb);
+	error = xfs_reflink_convert_cow_locked(ip, offset_fsb, count_fsb);
+	if (!error)
+		cmap->br_state = XFS_EXT_NORM;
+	return error;
 
 out_trans_cancel:
 	xfs_trans_cancel(tp);
-- 
2.43.0.rc0.421.g78406f8d94-goog

