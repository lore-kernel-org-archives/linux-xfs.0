Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96D32C6FD1D
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Mar 2023 11:08:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbjCQLIs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Mar 2023 07:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjCQLIr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2023 07:08:47 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC6727D5A
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 04:08:43 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id bg16-20020a05600c3c9000b003eb34e21bdfso4886835wmb.0
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 04:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679051323;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fHjSWW/YZEGEGz44nnM9t/++2Yb+yS/AmGPiI8kwmpU=;
        b=m9dFUStes2pivtyqjGcDY1Y4xKAzuBQTECv50g7G9maXYUCl7XN+yPF5gUd6p61n2a
         SGXTnkzRday06GOaZqrLRHHR7XYlnYK/DPo18QkfCa7ZCRQriZ13J+b5NWktvDerAq/q
         AsDiJH2AN7YssByomNCWA8xcVT1g0kwVctuqMNJrZNo3igrxveiIDdvBHxZh7MLB+r1x
         X9NzSMjccIE2bUOsd0xNSXhherZdki3eWs27FB6ZP7D5Gw+deBY51BXuF1F4qHSmJTsx
         ThxKyYyyKQ2HzF4lxFscZp82Ulw+gqrLtc+3kthdWDI9TdBGHXmdi0s7DrEVvTGxgHa+
         aAvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679051323;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fHjSWW/YZEGEGz44nnM9t/++2Yb+yS/AmGPiI8kwmpU=;
        b=DGOMCSEAF0/OA7MOzOQvq77qoZA0F11ukBclZt93Nw5ygTVEAvyJanqTEOAe9IbykB
         9/o+z830z+kzxlYXF74QW6Tb6pl0lK0H/nl8Y+ZP+07DPrsqSV+fE0ieDMpKCyddFC+y
         YYUCZ9/GdjRLN8ChqDZS8Mk8CD0ZEHNKkHM3tKnv+lfimuYvtBM0BRsQMPbct48LZHQd
         qp+KGwabCHjTF59K6RqscLrJIZ7n1v0sBhazDA4xtg9lcoHtGI3zrPAQ10C7LLvnQo1c
         Q1PTx9veOazJuFacWcQUOICvcyJYehvUW+d4VcAvAukinvQHNGc7dbpAvd+npfFUWy9D
         wz8g==
X-Gm-Message-State: AO0yUKWHhVUS5cFD2EEkMCcBAK/HoEr3NZsxR2TKUGQibZA4gVKjJT9s
        BRZDCd75U/keL+1OLd0p7JA=
X-Google-Smtp-Source: AK7set9kPTBEeNkdggl6VE2DZziG69FK0o6oeNpt4ue2F4SQJ6Mtji6r9OEX5l4/LfFsEaTpPTnJ4w==
X-Received: by 2002:a05:600c:1552:b0:3ed:1449:cdca with SMTP id f18-20020a05600c155200b003ed1449cdcamr20762420wmg.2.1679051323243;
        Fri, 17 Mar 2023 04:08:43 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id t14-20020a1c770e000000b003daf7721bb3sm7551100wmi.12.2023.03.17.04.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 04:08:42 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-xfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH 5.10 CANDIDATE 14/15] fs: use consistent setgid checks in is_sxid()
Date:   Fri, 17 Mar 2023 13:08:16 +0200
Message-Id: <20230317110817.1226324-15-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230317110817.1226324-1-amir73il@gmail.com>
References: <20230317110817.1226324-1-amir73il@gmail.com>
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
---
 include/linux/fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 57afa4fa5e7b..8ce9e5c61ede 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3408,7 +3408,7 @@ int __init get_filesystem_list(char *buf);
 
 static inline bool is_sxid(umode_t mode)
 {
-	return (mode & S_ISUID) || ((mode & S_ISGID) && (mode & S_IXGRP));
+	return mode & (S_ISUID | S_ISGID);
 }
 
 static inline int check_sticky(struct inode *dir, struct inode *inode)
-- 
2.34.1

