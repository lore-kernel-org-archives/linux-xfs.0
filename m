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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0C5BC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 08:52:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 599FB64FB1
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 08:52:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbhCKIw1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Mar 2021 03:52:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbhCKIwQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Mar 2021 03:52:16 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B46C061574;
        Thu, 11 Mar 2021 00:52:16 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id lr1-20020a17090b4b81b02900ea0a3f38c1so1377165pjb.0;
        Thu, 11 Mar 2021 00:52:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rn4fZ2iuvfXa7kz/6NW0+kQFMDk6lU68psLEEBOpOBk=;
        b=i/B5HSlasrIKkIRZKladlUB8jeCG8c+LSezarNeivJgWHE570OT4ZowY6JLLKNul3h
         FIB+I1cjcmIijk9Qm2S/bAiKbREU0qEYJ28YqsIWjdcEWfTD2EPBEmjVn3AEx4/op3Xg
         ViY5r8h0rp6cgiluFreCT9ykxIyT5Gh7NxkHSTXvSBkD/SqzGxvx2TDWv5SWFxgaGKji
         RGwMZevRpYrUZQcC0p/EtyD9XRLzmIGnt9RKJWRuP4+iNzvYzTptLJTn3zgJUSe71BjD
         4moXwod9LxeeZ28bfQcXBJCs6A+x4/JTnc4+LtOl7itm9nHQco0PbV20Oop8vWbmXTof
         paRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rn4fZ2iuvfXa7kz/6NW0+kQFMDk6lU68psLEEBOpOBk=;
        b=UzpN2b02sn1in1w23LHkXiABqDESigKfAeGys4tdZYVSL06+yK/6/Lqs/2syOSUuCn
         ok2o7rWCNYICXKyagAciIB8ihYeRo8QlY9Xp3w3MsWfo6RL6m+/4BlS3pEQ9/p9yuLOT
         DT46VQG00QGZYVPLoiR9ysOOM2Uvh6BMT8OVJN8iCgQi9hA7bsaKTHx6odWwIaPDN6hQ
         kgtbjBqn7oYhv1fYZ3Yr3C32ofj+X/wAYOpUVh01Ca+ebuNVxMW8VnuqzMzAbzZoIs97
         lrcRml7tsazNupCImO09nNTznhfrOUoj+jzJzsX3bc1KdVl2K1kHx0sC7Y+tFT0Y0Z0C
         BZ+w==
X-Gm-Message-State: AOAM531H12S4NZZu4owcwXOV9e+m9/GBntEKffHpzXmSj/2W1dQOvB9b
        165iYcosVuS0evoCYL9rZQhjmC0gHvY=
X-Google-Smtp-Source: ABdhPJy2VnGNT5bUsYL28QDH3g9HRenm/ziRSsPRU5j5KoXu1iUhPk8tpeJgkxWugAR5PfoHquKCPA==
X-Received: by 2002:a17:902:7fc8:b029:e4:32af:32da with SMTP id t8-20020a1709027fc8b02900e432af32damr7335877plb.24.1615452735550;
        Thu, 11 Mar 2021 00:52:15 -0800 (PST)
Received: from localhost.localdomain ([122.171.53.181])
        by smtp.gmail.com with ESMTPSA id r184sm1774487pfc.107.2021.03.11.00.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 00:52:15 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, djwong@kernel.org,
        allison.henderson@oracle.com
Subject: [PATCH V6.1] common/xfs: Add helper to obtain fsxattr field value
Date:   Thu, 11 Mar 2021 14:22:05 +0530
Message-Id: <20210311085205.14881-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210309050124.23797-4-chandanrlinux@gmail.com>
References: <20210309050124.23797-4-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds a helper function to obtain the value of a particular field
of an inode's fsxattr fields.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
V6 -> V6.1
1. Pass '-w' flag to grep to limit searches that match whole words.

 common/xfs | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/common/xfs b/common/xfs
index 26ae21b9..aec2cea6 100644
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
+	local value=$($XFS_IO_PROG -c "stat" "$path" | grep -w "$field")
+	echo ${value##fsxattr.${field} = }
+}
+
 # xfs_check script is planned to be deprecated. But, we want to
 # be able to invoke "xfs_check" behavior in xfstests in order to
 # maintain the current verification levels.
-- 
2.29.2

