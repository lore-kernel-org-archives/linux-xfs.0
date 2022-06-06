Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88BF3C43334
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 16:06:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238108AbiFFQGA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 12:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241566AbiFFQFz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 12:05:55 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0DD18E449;
        Mon,  6 Jun 2022 09:05:54 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id o37-20020a05600c512500b0039c4ba4c64dso2283183wms.2;
        Mon, 06 Jun 2022 09:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=leXUx+xiC8LILxdanH1dyfbyYi+fnX1NdyLFj2WsWtg=;
        b=kxfJpSgnzSY1qKxIJQW20YkKbKeph4we0ZKVixQjoYxsfs8LLqzPVnBNqQS6L4GV/M
         rnioW50SIggjU8R5ue85EJS0PF9gW2fjWksWra3CPHB7OTqsk7sbOVcRXyOQVYSPA8sy
         UzqQ05gcZ+tREEvUlLpw/CXm3BgCAWCBzYQaqY7jLX2K4AoZFd4Bbey4IalzSL2PLhCN
         THdXaF9fw7AfMnzer66mJg3ns3BsKwrZFeGpblfn+iCazwNfWRSJMwy3ZT2TXCubcqMp
         dO30zJLkQoCAkyyskmKBFTxQg8LQrUV3qpLUAKuymUMQBHhKqrr8Fq/nXvn5qVZSZ5/U
         XUzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=leXUx+xiC8LILxdanH1dyfbyYi+fnX1NdyLFj2WsWtg=;
        b=FY/aXtaEJmL/M19rKi11aKMdNcWLsRno2kOQ/YJbb88sQwES5Hz2IwmBS173U+Wrr5
         aKweHZMml54FkPNHYWTjt9xuMKQommuAA3keshbtuqHd4UxvkldTzpDUZYohViNJjj4S
         oNe7KxaysxSb9fdZ2m9COBR+bDscE+W7GXS15abdcPc7aEhB/5Ce45kV6tOWLDptNzrK
         vmFBh4MECKYFLYrztmFq35Jge1UaH5aDj4/tzNWLgDYo1tGTHdKSmDsDeUU69p11mNy4
         4PqpMYq43oBSPGnbMkQZsjBQpsmqMKRSBDdyE+ZvK+Efrq0gjb2QkSBXRb9Jw1AIOwRj
         vHmA==
X-Gm-Message-State: AOAM531YWJR2ySlXSely+2v0/7mMFNzlff8hxHF7r2H2Ujl6unb4Ln/c
        Kz5aD7IzAil6Sy/k1fpwV84=
X-Google-Smtp-Source: ABdhPJxQzODfrBtKl3V5YaNBG/g6qSV7RJr64EHdUAH+o+QCPEJaysu5oHUH5ccmr9+3MHCwRE5HYQ==
X-Received: by 2002:a05:600c:42c6:b0:39c:4bfd:a4a9 with SMTP id j6-20020a05600c42c600b0039c4bfda4a9mr8953830wme.8.1654531552544;
        Mon, 06 Jun 2022 09:05:52 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id n22-20020a05600c3b9600b00397342e3830sm25681327wms.0.2022.06.06.09.05.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 09:05:52 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH 5.10 CANDIDATE 4/7] xfs: ensure xfs_errortag_random_default matches XFS_ERRTAG_MAX
Date:   Mon,  6 Jun 2022 19:05:34 +0300
Message-Id: <20220606160537.689915-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220606160537.689915-1-amir73il@gmail.com>
References: <20220606160537.689915-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

commit b2c2974b8cdf1eb3ef90ff845eb27b19e2187b7e upstream.

Add the BUILD_BUG_ON to xfs_errortag_add() in order to make sure that
the length of xfs_errortag_random_default matches XFS_ERRTAG_MAX when
building.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_error.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 7f6e20899473..f9e2f606b5b8 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -293,6 +293,8 @@ xfs_errortag_add(
 	struct xfs_mount	*mp,
 	unsigned int		error_tag)
 {
+	BUILD_BUG_ON(ARRAY_SIZE(xfs_errortag_random_default) != XFS_ERRTAG_MAX);
+
 	if (error_tag >= XFS_ERRTAG_MAX)
 		return -EINVAL;
 
-- 
2.25.1

