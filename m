Return-Path: <SRS0=zhh1=BQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A82F4C433E1
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Aug 2020 17:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08552206C3
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Aug 2020 17:48:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=etsukata-com.20150623.gappssmtp.com header.i=@etsukata-com.20150623.gappssmtp.com header.b="aXV5l1Pn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730531AbgHFRsg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Aug 2020 13:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728854AbgHFQfQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Aug 2020 12:35:16 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE75C0A8938
        for <linux-xfs@vger.kernel.org>; Thu,  6 Aug 2020 08:06:19 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id e4so6837523pjd.0
        for <linux-xfs@vger.kernel.org>; Thu, 06 Aug 2020 08:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=etsukata-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V1nnod0YcV7H2TUfC8Gd96YGz+LSO9JcTYXXX1K5F8M=;
        b=aXV5l1Pn1QTKmNbUkXRGsMcHXqHlCCCmo6nMhuRuM+M+hMzmpEA7IN4avZrsE58fqz
         hb2NT8khNWUYf8HYCdsT0Loc0UFjdYxOgkq99yVEauoRmfiuPj5kEhCAsmTYoJO8S9JM
         6j/ZBj+a/Ml+s+0OtECD9bz0bg9yvvkk7wBfJ4wwo9el6UrBtEvV+m52ffdbiiXOTh4P
         J0WvMpBICzXhxA9Y8PomDt4gDipI7HhX0QgRvCvjJvgffOMLBJGd2rL3qcIuM8kjwCc+
         SkxSWXB8v9UDXLesmLyA+7kvfHgQgYU6/7s7+JkVRVt9YIHnjbwL6tdQZA0eWBhj7/Xc
         DbSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V1nnod0YcV7H2TUfC8Gd96YGz+LSO9JcTYXXX1K5F8M=;
        b=t8YXyz+yL+aQe7nNDJ5Szj1He2jCNsl88+ghll2kqGgb3UgH5ztsCk+EnZBgLYVPz+
         6GVxq1kArv4LOH/yzwO+TWy8B7MbdfscnWz/bWkyFOgzq85EC0XOUs2L21ab74JqzYMX
         ocPV0rKIgBHAEyN0gb4qeq+HLGPRMXjjhmgfP1ixBJE/F9AxRTZzVlBxPGtS7BzVfKXA
         5twxYWfz7kt77PS5JOYih98xaIpMQ3XzcGQcShlnr1aa4srhNZta0k8zfSNQ4WyEV063
         YDW4s8AnC4h66B9XmeM90QyiedviEObSHz08mIT89XeS4bB6YjmXFaGjs2FVUnZhT8S5
         awzA==
X-Gm-Message-State: AOAM530K4+4cdBk38O/ELHM0beyMYAP100cQI+ndgWmBG47WWo3ADQ1y
        rR6okKLUQBoEMs3YguFytUzXdoaFKIo=
X-Google-Smtp-Source: ABdhPJyFr2FVPuqXRM+0YDtULubZidua8t0vykhkDWv3dZfrMQsbp/BhuvxeGYxdzaliUSbU75BZLA==
X-Received: by 2002:a17:902:ed13:: with SMTP id b19mr8099742pld.24.1596726379400;
        Thu, 06 Aug 2020 08:06:19 -0700 (PDT)
Received: from localhost.localdomain (p14232-ipngn10801marunouchi.tokyo.ocn.ne.jp. [122.24.13.232])
        by smtp.gmail.com with ESMTPSA id l17sm9343094pff.126.2020.08.06.08.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 08:06:18 -0700 (PDT)
From:   Eiichi Tsukata <devel@etsukata.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eiichi Tsukata <devel@etsukata.com>
Subject: [PATCH] xfs: Fix UBSAN null-ptr-deref in xfs_sysfs_init
Date:   Fri,  7 Aug 2020 00:05:27 +0900
Message-Id: <20200806150527.2283029-1-devel@etsukata.com>
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

