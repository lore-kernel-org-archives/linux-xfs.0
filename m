Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ECC5C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jun 2022 07:33:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232920AbiF0Hd0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Jun 2022 03:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232922AbiF0HdY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jun 2022 03:33:24 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E474C5FD5;
        Mon, 27 Jun 2022 00:33:23 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id k22so11694518wrd.6;
        Mon, 27 Jun 2022 00:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=leXUx+xiC8LILxdanH1dyfbyYi+fnX1NdyLFj2WsWtg=;
        b=SSS2P5CweqeMgCAhEH1iYJbJl5DOj7NnLflWpu+UNQVObjoz1eJmW0tUfPBhpTS8Sm
         v8lRjc07LHLqqxczbEWDHmK5P02CvQO17lqo9NMw5oMVviWcDddAJmTqmmfv6lg+GZ8P
         USjDp3DxobLCPKMNvvJu77ITE8xY4zNM6/n5z/5HcRjlFPVyULinzKNdviBkxLYCuKba
         ljWGmbQUTPxpnQwg2EI3dCwdajcF2j2uV4k1WckGTc0P8PE3wcOF6wZotmP7VNbCzoQG
         Xe59TZhqA3JspkQ7dzKZgLt9yurfH/8AOEq/GYAW3EMv66SKQ5n0SqkaxFFxWhsOViaf
         dJfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=leXUx+xiC8LILxdanH1dyfbyYi+fnX1NdyLFj2WsWtg=;
        b=3N29HDTr/kwe+sSia/vy5pFxYcGrhmw7Y6/mQwaEakrFX9DJIOavqp3giBgarMh0IC
         mESKd1AJ5a7NH9A2gy81jmcW5+wJQjtmm5uaGZjc9nahgaaoaU5FtSiqxnCltNubjg0H
         hebmZro3jWOR2+FSBVVPSE+4u4BHv/bxw6jXy2hVCtdVfDfYgNJzreNETsbnKInhxT7I
         2bwqN2F6C0IbHqPOGGYohZcmleNu006Ns/rVXe9QVHirCbudkfxQvMPcnjohk18raNSD
         gxbyLmWP78A41icJyOXqS2Bz1rIF7M7OUFsWCHZHlvIaB6D8hmw24ftU6ana+wv4mUGs
         Mq0w==
X-Gm-Message-State: AJIora8wvyMCU5utjYHtb0Hd4Hh2tQANMKgIgAVcwFzRLJXrodDyGPXC
        wRRQmtDWju7O0ZfpmRvdtU+bsyi5kfhWCg==
X-Google-Smtp-Source: AGRyM1ugr+9eDyri3itM9Ix5FOJZJPC3jW94+HVw33BJRB1VYYks66ypModPEU09HwCLn6Hjbr6Oeg==
X-Received: by 2002:adf:fb08:0:b0:21b:af81:2ffd with SMTP id c8-20020adffb08000000b0021baf812ffdmr10969700wrr.685.1656315202301;
        Mon, 27 Jun 2022 00:33:22 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id j20-20020a05600c2b9400b00397623ff335sm12070070wmc.10.2022.06.27.00.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 00:33:21 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Gao Xiang <hsiangkao@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.10 CANDIDATE v2 4/7] xfs: ensure xfs_errortag_random_default matches XFS_ERRTAG_MAX
Date:   Mon, 27 Jun 2022 10:33:08 +0300
Message-Id: <20220627073311.2800330-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220627073311.2800330-1-amir73il@gmail.com>
References: <20220627073311.2800330-1-amir73il@gmail.com>
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

