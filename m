Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA9F6C4338F
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82D7760E78
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240209AbhHFVYN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 17:24:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28861 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240393AbhHFVYK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 17:24:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628285034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=04CbzjSMSrMjbDV1k2ePM/U0Y9Ze5uEaNMQfi54gpdc=;
        b=ASlRdayAQhDH/YJ7Uk7F279BRYnm6DrntW5Tadly+rqYsTCu6fZ+oE9Rti7ZxMtrRXYJiE
        N4lqXLw9EbLZ9Aq8qg0SH9w+iiQev8RtS949GJtEWjO3YxS/m0IO797opN91MQZc2ka582
        lsCwX2D3OEbtIrY7i35IbKAciiLkKo0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-pISID1FJP2CYL2FSjyCsKA-1; Fri, 06 Aug 2021 17:23:53 -0400
X-MC-Unique: pISID1FJP2CYL2FSjyCsKA-1
Received: by mail-ed1-f72.google.com with SMTP id y22-20020a0564023596b02903bd9452ad5cso5550488edc.20
        for <linux-xfs@vger.kernel.org>; Fri, 06 Aug 2021 14:23:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=04CbzjSMSrMjbDV1k2ePM/U0Y9Ze5uEaNMQfi54gpdc=;
        b=Or7TvxAMjmJ+OjGH6cSYUuJKKJpMF6WDaz7/Hxt9Ym0zeSKl1rSWO2Z+X1DvdKNgSe
         KR3SA9RY03BFg+zAQpF0VtmyIz3Y4T4MA9p9aCvkAWFh7+dLU+fpBhNmj8qVd76MT32O
         VQiyvTdD0ydMFYnwLNV/MIqRGa88PNKR7pxZzCGCffNctZC8G35s9FenGgv7TTtyenPd
         HSBHYaNZ/yxrIEJfrkIY93TwhkAXKkID8Y90HJu9UHllH9FMaLqo5bMMgiNpUyVFx58G
         o63yHR6EdoZat7zUFfR7Dnx5KvGLJwprvFVFlXqj06+yYMptIgRmp95WXyL3DGm2a3+i
         RHSA==
X-Gm-Message-State: AOAM530ivpBDViAfMLygFhoiSjo9cPxvk3jlZ7V05xIMBE45b98N0izK
        ynpVikIFdQQtG996heRLswuoIK8PTFXdNDM1yicjsgGjLTd3dyPCXGCrqfegsbAsjOozhW0hdDe
        rMdJTK02ViiOne5mdjta3Q5+XkAtIk2GvUmFRqWjqy8Neojgx9sgndkUd8NqFNtHhHneoGL8=
X-Received: by 2002:a05:6402:d4e:: with SMTP id ec14mr15179838edb.277.1628285031653;
        Fri, 06 Aug 2021 14:23:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwZOa4lEFTsSta97CwMIKnAO/Uctfpcblp7WRecKeDQWYAuzhI5KetCJ09ZRwa3vZ0fsVWpbw==
X-Received: by 2002:a05:6402:d4e:: with SMTP id ec14mr15179828edb.277.1628285031472;
        Fri, 06 Aug 2021 14:23:51 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id og35sm3256741ejc.28.2021.08.06.14.23.50
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 14:23:50 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 21/29] xfsprogs: Stop using platform_crash()
Date:   Fri,  6 Aug 2021 23:23:10 +0200
Message-Id: <20210806212318.440144-22-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806212318.440144-1-preichl@redhat.com>
References: <20210806212318.440144-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

---
 include/linux.h     | 8 +++++++-
 libxfs/libxfs_io.h  | 2 +-
 repair/xfs_repair.c | 2 +-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/linux.h b/include/linux.h
index 4ee4288f..591b4b05 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -239,12 +239,18 @@ platform_zero_range(
  * atexit handlers.
  */
 static inline void
-platform_crash(void)
+crash(void)
 {
 	kill(getpid(), SIGKILL);
 	assert(0);
 }
 
+static inline void
+platform_crash(void)
+{
+	return crash();
+}
+
 /*
  * Check whether we have to define FS_IOC_FS[GS]ETXATTR ourselves. These
  * are a copy of the definitions moved to linux/uapi/fs.h in the 4.5 kernel,
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 3cc4f4ee..a81bd659 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -46,7 +46,7 @@ xfs_buftarg_trip_write(
 	pthread_mutex_lock(&btp->lock);
 	btp->writes_left--;
 	if (!btp->writes_left)
-		platform_crash();
+		crash();
 	pthread_mutex_unlock(&btp->lock);
 }
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 38406eea..a5410919 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -882,7 +882,7 @@ phase_end(int phase)
 
 	/* Fail if someone injected an post-phase error. */
 	if (fail_after_phase && phase == fail_after_phase)
-		platform_crash();
+		crash();
 }
 
 int
-- 
2.31.1

