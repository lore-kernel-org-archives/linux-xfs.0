Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5B64C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 14:42:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3B336144B
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 14:42:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239976AbhDUOme (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 10:42:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50659 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235292AbhDUOme (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Apr 2021 10:42:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619016120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Q0/s23ZBsgPrAG+ztRgXYmJvWInX/cki5A/AJduggn0=;
        b=OTByqDzxn39foJxh4TyKqSZfskJl2N6KYRuhuqCiCKFQsm/VT1ahI/OsDh4cGWnxypMvWh
        KaC+JdSeGkQOGZg/EXhQ7ntCRcFUP/MpzjusL7rOnNj2y+rv47HA+B1Y+x+kmMulipuIHA
        ZMbBNYzhyQN3rScKBllvLzkJI6tdXBQ=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-VBFuBdopP3qsi6UlClO6Mg-1; Wed, 21 Apr 2021 10:41:59 -0400
X-MC-Unique: VBFuBdopP3qsi6UlClO6Mg-1
Received: by mail-pl1-f197.google.com with SMTP id j13-20020a170902da8db02900eb50257542so12335584plx.7
        for <linux-xfs@vger.kernel.org>; Wed, 21 Apr 2021 07:41:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q0/s23ZBsgPrAG+ztRgXYmJvWInX/cki5A/AJduggn0=;
        b=HD64lwjCfiGJjoocNiF60VMASGvPdURECX6mN4gQyxVAweHe6OdrxuY2zrHFUwkEMe
         a3YrDr6dHYppYdl5v9zkzmCpFMLc4Tu9rQ73YV6XLCFHijcaCVXJp3ikNkcYcUGFAHJH
         afmZ1KYAgPTD5S6nBqbQxPdrQo408vpK0Tp65NedLnEVH5OcCkmIUelhKhyZtx2Tb4Me
         Okr9BOgEQOvAVDuszVd4kxqrG7z6zHZxawm1wy9qYB9YjvBMOnLLriOJYgOJZHa9UDGg
         D857kWUkgxPS4LjW4HnJt+mw0dp2ySU7qtaK9zbPFA6fO3WJCvqCMbKDOzK9hgyGFBx1
         pn+A==
X-Gm-Message-State: AOAM5324GtRjLl3uZlg5mhtHgA+KPEXN9ImLBCowQtnMnnb8XrjQHaiT
        s0Svn/l0wjmjbRFyUKAlT5IDFsNQd71VWdXdvag+pF0ZjRt/gcWVut0YDQMG5eByz+2tCQVRUZE
        JUptP2j9wQ00Q5uvto0o6cliTcOxqMozF8Trury6RZo96z0WCX+KG1NW2kIQW7vw/MZiDXibOqw
        ==
X-Received: by 2002:a17:90a:f2c7:: with SMTP id gt7mr12122561pjb.157.1619016117789;
        Wed, 21 Apr 2021 07:41:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzq6DYKRHUOyYjS46VO5h+w+kfFO2x1BSAyg6/PuIZVgVIXBCyR48QYK8Fb5w2SEviU5OaDxg==
X-Received: by 2002:a17:90a:f2c7:: with SMTP id gt7mr12122535pjb.157.1619016117517;
        Wed, 21 Apr 2021 07:41:57 -0700 (PDT)
Received: from xiangao.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w21sm2441739pjy.21.2021.04.21.07.41.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 07:41:57 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH] repair: fix an uninitialized variable issue
Date:   Wed, 21 Apr 2021 22:41:35 +0800
Message-Id: <20210421144135.3188137-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

An uninitialized variable issue reported by Coverity, it seems
the following for-loop can be exited in advance with isblock == 1,
and bp is still uninitialized.

In case of that, initialize bp as NULL in advance to avoid this.

Fixes: 1f7c7553489c ("repair: don't duplicate names in phase 6")
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 repair/phase6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index 72287b5c..6bddfefa 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2195,7 +2195,7 @@ longform_dir2_entry_check(
 	int			ino_offset,
 	struct dir_hash_tab	*hashtab)
 {
-	struct xfs_buf		*bp;
+	struct xfs_buf		*bp = NULL;
 	xfs_dablk_t		da_bno;
 	freetab_t		*freetab;
 	int			i;
-- 
2.27.0

