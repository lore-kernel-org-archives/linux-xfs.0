Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDEA3C4321A
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 05:02:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4B47652AB
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 05:02:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbhCIFB6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 00:01:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbhCIFBr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Mar 2021 00:01:47 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06760C06174A;
        Mon,  8 Mar 2021 21:01:47 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id kr3-20020a17090b4903b02900c096fc01deso4489636pjb.4;
        Mon, 08 Mar 2021 21:01:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Uvm2ympaXZGfUsJPluQGSj18lMDG98QiIjgtePSKgW8=;
        b=uNzN2wUUgVkZGV4OeyLB7jwIXju9bXbm6mYDZqGwcofDTnYMzssZjXtEzaKExz9oVt
         SiyMNfmYrMyzC9GsbFISajBRbaaTlD3PfB+hsByReUj0inlmM6abvstGEShDTT7YQpCO
         NltC6cH8inxUT02wFpRt+MCFSXjfJ0Tix5LyhTSNvHTddg/nJuXXXN029WvuQEq/gZlv
         cU5nt+Jhi4/YEDNFd5pLYPFJxHmo6Nebhm46cfXwRkMw1tJjScEvtceYyL2pTP8vdRXv
         fx/BDKPApzSjtEcPMyLk0OUGsTG4crokwvwMcvPc9bYKIeI0OMvW3tcTU43WZyLvONuK
         45iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Uvm2ympaXZGfUsJPluQGSj18lMDG98QiIjgtePSKgW8=;
        b=AhzVzC+bpy8+a/nGm/d0UpCy9dJR/O7Uhmp8FH5EFu+02F21+tXbjeCDIM5VnxizDu
         fY+A0wrTRxh1ro7iZ499YQ9nbKtKAnCrJyh/t6kdj0j/QGE59fd4ewb77hM8wMzGXx+y
         7K/nWG9T6M0QCFFH2a1bk3KqSs5GeTmjH11U8fL40qlu2GuNWrRyCyOs9qIv6/IsV0A3
         VdTPyABlZ1ArloWeCDa2ua/0pQXKvnARYJe5AztXdV1C2DA6oIWtqNm2qpDoTfeKGbLd
         x4sAlKMaV/nIUQ9D8QU7VUpO9fZRwqAYErPdEVI7dBNqsHUA/OTu7YYp8TljMG+zVuSU
         OSZQ==
X-Gm-Message-State: AOAM531p00okz1CdhvXc7jzztXY8RYduQ5gevLwGeDxjwtp+mtlxVB+E
        hZHSk3XWt3LIv7zRu1ARbOjM66UZ+4o=
X-Google-Smtp-Source: ABdhPJw1Im2UUJxxSLZkPMhu7RtuUGsCX8Q+YQ9kNENg47hDGF/iCfvpoMNRG/dpFTYNSFddUGYUBA==
X-Received: by 2002:a17:902:d202:b029:e4:55cd:dde8 with SMTP id t2-20020a170902d202b02900e455cddde8mr2160481ply.51.1615266106517;
        Mon, 08 Mar 2021 21:01:46 -0800 (PST)
Received: from localhost.localdomain ([122.179.125.254])
        by smtp.gmail.com with ESMTPSA id a21sm5849577pfh.31.2021.03.08.21.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 21:01:46 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [PATCH V6 03/13] common/xfs: Add helper to obtain fsxattr field value
Date:   Tue,  9 Mar 2021 10:31:14 +0530
Message-Id: <20210309050124.23797-4-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210309050124.23797-1-chandanrlinux@gmail.com>
References: <20210309050124.23797-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds a helper function to obtain the value of a particular field
of an inode's fsxattr fields.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 common/xfs | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/common/xfs b/common/xfs
index 26ae21b9..130b3232 100644
--- a/common/xfs
+++ b/common/xfs
@@ -194,6 +194,15 @@ _xfs_get_file_block_size()
 	$XFS_INFO_PROG "$path" | grep realtime | sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g'
 }
 
+_xfs_get_fsxattr()
+{
+	local field="$1"
+	local path="$2"
+
+	local value=$($XFS_IO_PROG -c "stat" "$path" | grep "$field")
+	echo ${value##fsxattr.${field} = }
+}
+
 # xfs_check script is planned to be deprecated. But, we want to
 # be able to invoke "xfs_check" behavior in xfstests in order to
 # maintain the current verification levels.
-- 
2.29.2

