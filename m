Return-Path: <SRS0=zhh1=BQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA492C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Aug 2020 21:17:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98E1020855
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Aug 2020 21:17:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=etsukata-com.20150623.gappssmtp.com header.i=@etsukata-com.20150623.gappssmtp.com header.b="pRk0B1xl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbgHFVRl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Aug 2020 17:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgHFVRl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Aug 2020 17:17:41 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1BDCC061574
        for <linux-xfs@vger.kernel.org>; Thu,  6 Aug 2020 14:17:40 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id p3so27633270pgh.3
        for <linux-xfs@vger.kernel.org>; Thu, 06 Aug 2020 14:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=etsukata-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V1nnod0YcV7H2TUfC8Gd96YGz+LSO9JcTYXXX1K5F8M=;
        b=pRk0B1xlXBqExovJUgyxYgjDo3zEevey/BEQxEyUSF7ywt4Q+4Wii8bQdttCRnAlkO
         FJ16fagk46cq2JlJbIoHBzL8RU/pVuYO4/vP7awxYiOC8jRfKhliGGx9HESUyA4GevnY
         BkT79lxGFgaVW2AabU1/x/Hfdv/yswlEoEg7XzKL7bdjxK4o/iuyUgXTLERCUOLI75Ao
         DE0zJzedOCa3nkNEtZUjwijGxWxRzEXXJl8tnS1M+wN75xOoUN9TAjGD4sKBSOIfePex
         E4W26/qoIpSSAp0e7lCiuPE0WPPhYJ1O6xRvuVINO9SLT2jWZ4XgFt/RX8MiwLFRzb0e
         8w5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V1nnod0YcV7H2TUfC8Gd96YGz+LSO9JcTYXXX1K5F8M=;
        b=LhTCxtEbtOtSguiBWIjmO0ma1wc7NPbv5QM7QcnB3tnjhDwuKbfypLe76qEzGP3R8K
         OuHymGx+PiuYPuzebhwPrueD8z0WFyi1gj9LfPvmkvnoqgxZ0oyjFn8y3EUL+v/2AN0f
         /o9TixbE45YzrqaTD53BmYwx0U501t4njZDq/qa0aHTI4+3NiHxeA6vt+wjLyzksPM9a
         n89gvpBR9kJdwApSjW/AIPUKblhRO3T/s26pspB4k/f9MQMlPHXMS0ME+bwTTxbTSt3k
         wLSMVoMWvdrB+VWSaGGL377LHU4D/tIy1PI0BFVPXdRjN8WkpXF0o02xKXbRrXe2WUF3
         ltSw==
X-Gm-Message-State: AOAM533wgn84HsX94c1MjJtp0SU4BGLt6hC4V6+RiNfAfgARBEMy7uYi
        Rm7ID+Wr+qtZTm21Kuzyr6zkfqIWfj4=
X-Google-Smtp-Source: ABdhPJxGzoZ7fv+PNxE0XqXlb5/aW51s0sDpEFzPpNM4g6jRkzbJorJrkow2TnwcEPQShM/1mdkhzA==
X-Received: by 2002:a63:485f:: with SMTP id x31mr9034813pgk.49.1596748660022;
        Thu, 06 Aug 2020 14:17:40 -0700 (PDT)
Received: from localhost.localdomain (p14232-ipngn10801marunouchi.tokyo.ocn.ne.jp. [122.24.13.232])
        by smtp.gmail.com with ESMTPSA id e29sm973447pfj.92.2020.08.06.14.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 14:17:39 -0700 (PDT)
From:   Eiichi Tsukata <devel@etsukata.com>
To:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Eiichi Tsukata <devel@etsukata.com>
Subject: [PATCH] xfs: Fix UBSAN null-ptr-deref in xfs_sysfs_init
Date:   Fri,  7 Aug 2020 06:17:19 +0900
Message-Id: <20200806211719.2356243-1-devel@etsukata.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If xfs_sysfs_init is called with parent_kobj == NULL, UBSAN
shows the following warning:

  UBSAN: null-ptr-deref in ./fs/xfs/xfs_sysfs.h:37:23
  member access within null pointer of type 'struct xfs_kobj'
  Call Trace:
   dump_stack+0x10e/0x195
   ubsan_type_mismatch_common+0x241/0x280
   __ubsan_handle_type_mismatch_v1+0x32/0x40
   init_xfs_fs+0x12b/0x28f
   do_one_initcall+0xdd/0x1d0
   do_initcall_level+0x151/0x1b6
   do_initcalls+0x50/0x8f
   do_basic_setup+0x29/0x2b
   kernel_init_freeable+0x19f/0x20b
   kernel_init+0x11/0x1e0
   ret_from_fork+0x22/0x30

Fix it by checking parent_kobj before the code accesses its member.

Signed-off-by: Eiichi Tsukata <devel@etsukata.com>
---
 fs/xfs/xfs_sysfs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_sysfs.h b/fs/xfs/xfs_sysfs.h
index e9f810fc6731..aad67dc4ab5b 100644
--- a/fs/xfs/xfs_sysfs.h
+++ b/fs/xfs/xfs_sysfs.h
@@ -32,9 +32,9 @@ xfs_sysfs_init(
 	struct xfs_kobj		*parent_kobj,
 	const char		*name)
 {
+	struct kobject *parent = parent_kobj ? &parent_kobj->kobject : NULL;
 	init_completion(&kobj->complete);
-	return kobject_init_and_add(&kobj->kobject, ktype,
-				    &parent_kobj->kobject, "%s", name);
+	return kobject_init_and_add(&kobj->kobject, ktype, parent, "%s", name);
 }
 
 static inline void
-- 
2.26.2

