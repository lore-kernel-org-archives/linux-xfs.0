Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD67AC6FA8E
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Mar 2023 20:35:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjCBUfc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Mar 2023 15:35:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbjCBUf3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Mar 2023 15:35:29 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53873866E
        for <linux-xfs@vger.kernel.org>; Thu,  2 Mar 2023 12:35:28 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id cp7-20020a17090afb8700b0023756229427so4038259pjb.1
        for <linux-xfs@vger.kernel.org>; Thu, 02 Mar 2023 12:35:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677789328;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BbfeXg3QbNcNSiHK4OP8vmntjHDkmbVWGqEY3WGb1vQ=;
        b=Eo8fmmJJlyVplNBHY0i4ZTDLtLLYPJQYeD9moZOIlxOY2rYUAieCp2k55tseRsS7vE
         ilcAeloHBGMj2Rv9Xi+PdCjk9oyJp40if8JiqhbMLrqCx7tki3+DUkQYz5/U27x/2K6k
         tTmDjLr5vQalNeQag9D+5pPvXLq4fx33ixf805oWL3d9Y0zfBohZPDa+QGebteibYS9R
         v0xfjzSe2FEIH3vzvNaGSAyhINVErJ8ogzoJ11yHCnRKQa+8dSMK4AIREJzqSY22fBSG
         K2npDVW2//bDrxssAKcx688mQHH0pF+pZPb52az0i0otxdvqDqF0MedJ1/eF5KHfl+OE
         qPmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677789328;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BbfeXg3QbNcNSiHK4OP8vmntjHDkmbVWGqEY3WGb1vQ=;
        b=xAcJZ6BDCYv362s6N+UiayfFlGIgLbWQ5U72DD2D0ZtfB6rJAcRFDqOriHcjtD5gAX
         ezb3dP2LzgwBqehQ+NSmmaH/dS8ETFt2eb9TJoGqz4MAxnvQjXad6a+gQOW27uNIyiC3
         6Rt1Mnb0eiCDJindoQhr+MjELG5/bV/qYroiSSdVI7ePRFxQ5bHHy6RQG2XpMf7GJtnD
         H8szO3UDwdkqX7baIhShOTC8EVs0iE/NBdbiwj9A3fbpX6RqApNa5oBl818g97Gdvc07
         cIWAUhRuyxTF3wF3XrM+iVgdQ2OSbJDrwSGAeUGmr4J9ooe1TVtMbyKBYRPLht9C+02S
         KjAQ==
X-Gm-Message-State: AO0yUKU60vGvxQY7HYj+STrHs1KDe7/0gtVmJKDr5mlWTvFBDUsyVWsQ
        +q8JX2Odt3wfgLtFaO8xirvM+3uKN5BsCA==
X-Google-Smtp-Source: AK7set8DN4Pf8gnZqX/2L+rla5NeoOirPwLFIylLx6Jm37YfZnRXFGVWvBqIACRgbuk+eIqtuOPKGQ==
X-Received: by 2002:a05:6a21:338f:b0:cc:d891:b2ad with SMTP id yy15-20020a056a21338f00b000ccd891b2admr12726101pzb.20.1677789328317;
        Thu, 02 Mar 2023 12:35:28 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:637a:4159:6b3f:42eb])
        by smtp.gmail.com with ESMTPSA id b13-20020aa7870d000000b005ac86f7b87fsm113459pfo.77.2023.03.02.12.35.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 12:35:28 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com,
        Christian Brauner <brauner@kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 11/11] fs: use consistent setgid checks in is_sxid()
Date:   Thu,  2 Mar 2023 12:35:04 -0800
Message-Id: <20230302203504.2998773-12-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230302203504.2998773-1-leah.rumancik@gmail.com>
References: <20230302203504.2998773-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christian Brauner <brauner@kernel.org>

commit 8d84e39d76bd83474b26cb44f4b338635676e7e8 upstream.

Now that we made the VFS setgid checking consistent an inode can't be
marked security irrelevant even if the setgid bit is still set. Make
this function consistent with all other helpers.

Note that enforcing consistent setgid stripping checks for file
modification and mode- and ownership changes will cause the setgid bit
to be lost in more cases than useed to be the case. If an unprivileged
user wrote to a non-executable setgid file that they don't have
privilege over the setgid bit will be dropped. This will lead to
temporary failures in some xfstests until they have been updated.

Reported-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Tested-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 include/linux/fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9601c2d774c8..23ecfecdc450 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3571,7 +3571,7 @@ int __init list_bdev_fs_names(char *buf, size_t size);
 
 static inline bool is_sxid(umode_t mode)
 {
-	return (mode & S_ISUID) || ((mode & S_ISGID) && (mode & S_IXGRP));
+	return mode & (S_ISUID | S_ISGID);
 }
 
 static inline int check_sticky(struct user_namespace *mnt_userns,
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

