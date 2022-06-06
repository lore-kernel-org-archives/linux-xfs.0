Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B3EACCA481
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 16:06:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241568AbiFFQGB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 12:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241565AbiFFQF7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 12:05:59 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA06194770;
        Mon,  6 Jun 2022 09:05:58 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id p10so20474473wrg.12;
        Mon, 06 Jun 2022 09:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BztR3xl1wXSqEmt618SWPDGdztRQPzdI6eVz/ObVHhI=;
        b=gpLD0N3QeF/Qj9GN7DolFJyKqcQ5jXrC8MElDu+Ju2EQUJxGT3jP3gg/McJl/EPtkg
         rtb3dUS7iIVN7b/sOh1Vo2ev3Lzv3SSSNXZiDC3vneivaUCsRP1sbTpQy+iVvBvgBs8N
         yR+9rH+FufqAaYlrVOYPp4kBcQJOr3yVwPc0s/vljBk9h0mKukW1h0DfKJNCDmWVj3o+
         F6qrKPYoNe6GpuAVo3CvT7WKBPPyFtSzF2Upg2/jHvlrNAaDvIGXKHihuu3gXudDXGPk
         +TT6MZgSwY/sXDDb4jjEhLdkxQILrob8AoFVsL/TdaS/m+2Vbo+jRAI1gqBr18HSn/s6
         gXig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BztR3xl1wXSqEmt618SWPDGdztRQPzdI6eVz/ObVHhI=;
        b=xajuBcZexGozCsie1U1W4JYWVKCkY7GPEW3TVfp8p/EIgl0qA6uHN5PEy4pWJIZ3go
         w0aRt/9Y50Z2T7UAEB1uZZaP3/iXuO56DXtPAYzLOScGBqPZ4EMx50HGLKMdIkUfcxry
         owsKX3XYjNni0G5X2wAxDgztXrbl7G2REgLugH2h4HGac5f07N0aOjkWTiG67Ws8fNI4
         Ybxswf/vvaMGqFl/fnXLejJB+H9qDXb2Sfqt3sa8vMH9rkcvis4gSPbAV9b51gI5gFjs
         Zrnai+v0+zB3JbSNCLClM/DIgg+owm7VFX/ltE3lUvp3CckKe4AtaBlpveSDg27A/b3n
         YYXg==
X-Gm-Message-State: AOAM532xVKZUlF4Gn/YYs1v/ta/teBQXeKfELYuAhzW0Zu+SFmVrwiP3
        /c8I+shnO7On1oIb8TXVILbmwN6Qg2aFCw==
X-Google-Smtp-Source: ABdhPJzN0KDinDmIQXnmoMwlH/peJQBrEm5/D2ekpmDMszthEgWt7f90u9Dw151evFli8xV52HjxeA==
X-Received: by 2002:a5d:6e03:0:b0:20f:ca43:badc with SMTP id h3-20020a5d6e03000000b0020fca43badcmr22762300wrz.547.1654531556718;
        Mon, 06 Jun 2022 09:05:56 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id n22-20020a05600c3b9600b00397342e3830sm25681327wms.0.2022.06.06.09.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 09:05:56 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Chandan Babu R <chandanrlinux@gmail.com>
Subject: [PATCH 5.10 CANDIDATE 7/7] xfs: fix xfs_reflink_unshare usage of filemap_write_and_wait_range
Date:   Mon,  6 Jun 2022 19:05:37 +0300
Message-Id: <20220606160537.689915-8-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220606160537.689915-1-amir73il@gmail.com>
References: <20220606160537.689915-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit d4f74e162d238ce00a640af5f0611c3f51dad70e upstream.

The final parameter of filemap_write_and_wait_range is the end of the
range to flush, not the length of the range to flush.

Fixes: 46afb0628b86 ("xfs: only flush the unshared range in xfs_reflink_unshare")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_reflink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 6fa05fb78189..aa46b75d75af 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1503,7 +1503,8 @@ xfs_reflink_unshare(
 	if (error)
 		goto out;
 
-	error = filemap_write_and_wait_range(inode->i_mapping, offset, len);
+	error = filemap_write_and_wait_range(inode->i_mapping, offset,
+			offset + len - 1);
 	if (error)
 		goto out;
 
-- 
2.25.1

