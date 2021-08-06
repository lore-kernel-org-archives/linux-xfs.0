Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17066C4338F
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F360B60E78
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240201AbhHFVYB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 17:24:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55007 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239884AbhHFVYB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 17:24:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628285024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=//ZwlA7NdQH/3Qxyf2tK689v94I01ftwTMsaImCV8gs=;
        b=J1Yfbg5Ytjp0owgew1zC2aNbYYFpLu7u7NdZU8FisGiv/3lJPxEQHCOP7/cRFlQFvRMNgr
        Eywt9GylI03tZ8r2g+AftXuQX/JAEaagxqr4XMrrhOSWaQSf1TYK1QpSUZcpRk62mwI2gZ
        sMTuatdxtQWqRA3hk9/aLhH1hWAOuAw=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-aeM7YPAoNUGAC-QyHED8Qw-1; Fri, 06 Aug 2021 17:23:43 -0400
X-MC-Unique: aeM7YPAoNUGAC-QyHED8Qw-1
Received: by mail-ej1-f71.google.com with SMTP id r21-20020a1709067055b02904be5f536463so3542859ejj.0
        for <linux-xfs@vger.kernel.org>; Fri, 06 Aug 2021 14:23:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=//ZwlA7NdQH/3Qxyf2tK689v94I01ftwTMsaImCV8gs=;
        b=ArpgKLj7bkJpWwMQPIPTjwd9YEqLda8NMPQLJ40ja/p2GIjtO5EAePlDro7Ll4Aa3E
         Yur06Ddl0CuUJbB2T6ljLbrVz4g+6UIfLK4FehVPZsab3BNnPaR+UkKCYc1XKcHVAWIH
         Q27KEK+WkKJSQ+i/kGDWJJG+Bhok/hPhcEdxJxYNt0RE42isbcS5z6BUyn+oXI4qj/15
         qHoVgY5FZLcG42i0gVPmHoJ+kA0NeC8KnuIifkSEPSfzAH998RH3vhEqkf/IOn5yxgVF
         dYFoHYAXAgsRQBwIJ3XuYev1Bm8PJHwEa0tQxJ8zbaeEPHIOM2IrwRRVON+x2qMKiBU7
         YDAw==
X-Gm-Message-State: AOAM532WLUYlSCKqYElEGyYyu+TIN/7swgM4iLtLf6RQ8hAUvPXjTEOu
        MtG3bOswWuu9hImbWbJztLKIl0q38Ed/Iqt4IiBlh3Jne2aJGhTM4TmNIVPrlBjnek1LJayy46N
        PJy1It+MW3Xu9enJmxinbav6sKEZyU/UTZIpEJMb/oT/npUp5M/ISSIoYFtvmUr8EB8Bg3Zs=
X-Received: by 2002:a05:6402:3128:: with SMTP id dd8mr15948145edb.367.1628285022096;
        Fri, 06 Aug 2021 14:23:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz2NEFoHt3r1CcoCF0ZUcYgRC+1cnNicX3dIZU0JC4qXK9rRLRcXfW9ewYhmmHoDEJWfIPq7g==
X-Received: by 2002:a05:6402:3128:: with SMTP id dd8mr15948134edb.367.1628285021923;
        Fri, 06 Aug 2021 14:23:41 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id og35sm3256741ejc.28.2021.08.06.14.23.40
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 14:23:40 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 16/29] xfsprogs: Stop using platform_mntent_next()
Date:   Fri,  6 Aug 2021 23:23:05 +0200
Message-Id: <20210806212318.440144-17-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806212318.440144-1-preichl@redhat.com>
References: <20210806212318.440144-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

---
 fsr/xfs_fsr.c   | 2 +-
 include/linux.h | 7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 38afafb1..825ec395 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -319,7 +319,7 @@ initallfs(char *mtab)
 		exit(1);
 	}
 
-	while ((mnt = platform_mntent_next(&cursor)) != NULL) {
+	while ((mnt = mntent_next(&cursor)) != NULL) {
 		int rw = 0;
 
 		if (strcmp(mnt->mnt_type, MNTTYPE_XFS ) != 0 ||
diff --git a/include/linux.h b/include/linux.h
index b6249284..07121e2b 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -181,11 +181,16 @@ static inline int platform_mntent_open(struct mntent_cursor * cursor, char *mtab
 	return mntent_open(cursor, mtab);
 }
 
-static inline struct mntent * platform_mntent_next(struct mntent_cursor * cursor)
+static inline struct mntent * mntent_next(struct mntent_cursor * cursor)
 {
 	return getmntent(cursor->mtabp);
 }
 
+static inline struct mntent * platform_mntent_next(struct mntent_cursor * cursor)
+{
+	return mntent_next(cursor);
+}
+
 static inline void platform_mntent_close(struct mntent_cursor * cursor)
 {
 	endmntent(cursor->mtabp);
-- 
2.31.1

