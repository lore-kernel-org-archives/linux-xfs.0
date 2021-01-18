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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2281C433E9
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 06:21:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8018F22513
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 06:21:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731743AbhARGVk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 01:21:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730841AbhARGV0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jan 2021 01:21:26 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED54C061574;
        Sun, 17 Jan 2021 22:20:46 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id x12so8060514plr.10;
        Sun, 17 Jan 2021 22:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tuRANglPuvCThAaGoAF4a7CUchGXxnbMIAXQeoen4YY=;
        b=u6KW9T/G74mpydMLG6YddGoO+q5F/lOOeOlCIJYGQSx5Jovp/YUofHU+i6/ITAeWVG
         665MKqBv4J4xYPVVNKmFWgpDGcO6Xe6NIFVQ1ZBPVvZWPeQfD8Aru0TtoxVTh3GE8T+H
         Y8f3LDf602LDvPDc39D3QxpGvrcq16GoxHzCO+AGcaCdgmpYz8vAL/gpo/LnpT7Ja25J
         JV0d5vk0KUYqbgUgLuVPzq+aOrgdmbazGIGMbdLyAwvfsM3o+Gp8MhJVK/6qlBKWb9zC
         PeDferzpw/h9QKKFH8VtzpjmW2co82k8ilsm7SH2ZJ6XB3t6nO4rvvd6hfc34oIkxUrb
         C4aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tuRANglPuvCThAaGoAF4a7CUchGXxnbMIAXQeoen4YY=;
        b=U0tXTLF9TRRfz46lmlZQutY/UaYWLvNuLR0g68R9hrCcI6kcOrzDEvzXJsyhXAgDg0
         odOIRtKy8h0SJjcA72PUe5c4KwjbVDE+yVw77GCk7z++innst2uwXS8xNDnBbT6T2rs2
         3er1cIbOsvRk5LvpENHH6Lxw3fsNeCX58Gtq0sZFTiymxmK2Xz67kUsdSksAxVnEj4HP
         xUyKkHaweDhtSPuY5mzNZKyd990sU/cQ79eV4SJqRWis1kwM2k0B5Wxj4pLuiY7zW4nA
         NNNdhBrb/xN31zo11V88Twk05Bg9GWTpCByEq+7Oujr751+3DZGR9CejtLKok03z1Ri3
         f99w==
X-Gm-Message-State: AOAM533H8LhJ9Rt6twUJTPP/804OjzLLZU/ixPiWgC8RrpTlrpbLB2Fh
        CRQ4gXRixqKUZ7tZwEBsIJu5mjQmsoY=
X-Google-Smtp-Source: ABdhPJyUKfwur8DwFpRj3oRIq/rY7xj9jQqCTGDOtihfCUKm+KwUd14zwpU3nRiWyPG9OZY//Q5dqA==
X-Received: by 2002:a17:90a:8508:: with SMTP id l8mr23676379pjn.131.1610950845962;
        Sun, 17 Jan 2021 22:20:45 -0800 (PST)
Received: from localhost.localdomain ([122.179.96.31])
        by smtp.gmail.com with ESMTPSA id t1sm14608423pfq.154.2021.01.17.22.20.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 22:20:45 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        djwong@kernel.org
Subject: [PATCH V4 01/11] common/xfs: Add a helper to get an inode fork's extent count
Date:   Mon, 18 Jan 2021 11:50:12 +0530
Message-Id: <20210118062022.15069-2-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210118062022.15069-1-chandanrlinux@gmail.com>
References: <20210118062022.15069-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds the helper _scratch_get_iext_count() which returns an
inode fork's extent count.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 common/xfs | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/common/xfs b/common/xfs
index 3f5c14ba..641d6195 100644
--- a/common/xfs
+++ b/common/xfs
@@ -903,6 +903,28 @@ _scratch_get_bmx_prefix() {
 	return 1
 }
 
+_scratch_get_iext_count()
+{
+	ino=$1
+	whichfork=$2
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
+	nextents=$(_scratch_xfs_db  -c "inode $ino" -c "print $field")
+	nextents=${nextents##${field} = }
+
+	echo $nextents
+}
+
 #
 # Ensures that we don't pass any mount options incompatible with XFS v4
 #
-- 
2.29.2

