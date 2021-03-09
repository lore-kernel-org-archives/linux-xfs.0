Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDDA0C433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 05:02:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3AEE652AC
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 05:02:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbhCIFB6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 00:01:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhCIFBp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Mar 2021 00:01:45 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E09C06174A;
        Mon,  8 Mar 2021 21:01:45 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id kk2-20020a17090b4a02b02900c777aa746fso4489900pjb.3;
        Mon, 08 Mar 2021 21:01:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wiUX8hmDRkOSLriQemMNaU5Pv5stJo7j+X9UPcM9A8Y=;
        b=daNfA6hA7U16n/5JORC/z427Q/oezpZ7cYo8P1Dwiq6ZJkt0mTF0xsIMY8MBZDSvRF
         EK5WjRw+H34V0ZMDZ4t6RnwSI7hQ5Xc3y14KX/X9fH5l9ZzRx8cQbkAvjUZHwDoBA08q
         SAVvAhvs1fgLqBkO4Xpl30f6jv+F/174OrJJ6ZbSQOYZ6whxZbyiSiLCQkzUWVmX2ari
         XvtKVGpfopomg/vr7GDdxDgHDgF2/Txy6u7DToPIu1xc9/wyXe12sqpXRIRrQntCphLi
         HjWkIdJMAGf2PbQPXz62pNoYY1b6KnDoQT2JlJbOC0YVZAnPfw3fzphOWj+zHwbJLecp
         3Nbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wiUX8hmDRkOSLriQemMNaU5Pv5stJo7j+X9UPcM9A8Y=;
        b=Q4uRzOCm1bErAEd0qblwzO3xoGYHlAjU0jayeL9UvNVijn7jDDLoyzSC7lkMm6F0eE
         y/FLnu652hZ5MIGdr9U+FqNrEJoQ0W60IkzG5yQXCnGK/SF6eo3mrLGFGZt29APU4Y5v
         M9DGJWOiHdHFQM902vG/5kr1pmczz4omhLchhbU3izNGr1WklSCBB5QIALP0fkl4I2/1
         iJQBBYnliN/Oyw+vGsVQp5kK8+0EfMcuGxFeblFPgLzlckHM8m61yce3yfmdsGiOfu/Z
         bdTVQQzh0iup4HP6SAIELEOU2ew8xWTg2TJJDvQvv5r6Wp/YUU1fFkvcP20RPnEklgv7
         3NcA==
X-Gm-Message-State: AOAM531Xswh3kX2Au2CN/LG0hkjvzlOeO5bH7DEMrTutNgu3zXdRTPf7
        dzNxmx0T8mQp3l0SMDm6KJAndppahYM=
X-Google-Smtp-Source: ABdhPJzKLc04rxCGXcOPS0z00qb7hXidj9VxGgotIP/+kHKwEFKyLBdfR6CVzr4jHX23AkVUD+BrDw==
X-Received: by 2002:a17:90a:8c08:: with SMTP id a8mr2751575pjo.136.1615266104601;
        Mon, 08 Mar 2021 21:01:44 -0800 (PST)
Received: from localhost.localdomain ([122.179.125.254])
        by smtp.gmail.com with ESMTPSA id a21sm5849577pfh.31.2021.03.08.21.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 21:01:44 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [PATCH V6 02/13] common/xfs: Add a helper to get an inode fork's extent count
Date:   Tue,  9 Mar 2021 10:31:13 +0530
Message-Id: <20210309050124.23797-3-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210309050124.23797-1-chandanrlinux@gmail.com>
References: <20210309050124.23797-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds the helper _scratch_get_iext_count() which returns an
inode fork's extent count.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 common/xfs | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/common/xfs b/common/xfs
index 41dd8676..26ae21b9 100644
--- a/common/xfs
+++ b/common/xfs
@@ -924,6 +924,26 @@ _scratch_get_bmx_prefix() {
 	return 1
 }
 
+_scratch_get_iext_count()
+{
+	local ino=$1
+	local whichfork=$2
+	local field=""
+
+	case $whichfork in
+		"attr")
+			field=core.naextents
+			;;
+		"data")
+			field=core.nextents
+			;;
+		*)
+			return 1
+	esac
+
+	_scratch_xfs_get_metadata_field $field "inode $ino"
+}
+
 #
 # Ensures that we don't pass any mount options incompatible with XFS v4
 #
-- 
2.29.2

