Return-Path: <SRS0=UJS8=3R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD6C8C2D0DB
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 14:55:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9205E2064C
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 14:55:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GJP93cgD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgA1Ozt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jan 2020 09:55:49 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:57541 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726618AbgA1Ozt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jan 2020 09:55:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580223348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=924Len8/W5q5JiKzQNbNFdE2LXkcOuoFCXP0F2ZAMY0=;
        b=GJP93cgDcBtyvQZ5OniKzTD/46T6/aeVmkyEpmizsmC7/q47k2mvFsVup9e2Ikk4yT040q
        EOq5JjmQmMk+c0wC9o6gGrVnsCJaZZC87CxH5gpqFFbMANyic3V7g4pYcZYZZ7rVNtDT8f
        wcbjIVThGatwIQnSsj2GwyYFA32kIao=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-Fr7IoAxtNGWA_E5NleC3Dw-1; Tue, 28 Jan 2020 09:55:46 -0500
X-MC-Unique: Fr7IoAxtNGWA_E5NleC3Dw-1
Received: by mail-wm1-f70.google.com with SMTP id t16so917027wmt.4
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2020 06:55:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=924Len8/W5q5JiKzQNbNFdE2LXkcOuoFCXP0F2ZAMY0=;
        b=tQq6pVZoxqULbYB2AW7joc8iMAVLH9pL7yOP1on3SVugkCKsRNFRtVXvmjrMVgwQ17
         QczZNb6eWvySH3wjDCNdG7K53ARFCCQfWHLc/s8wuhdh5aXDnPUYUVAA7TivE0h7ajCL
         B00N4eAlyLjNmLqU5NJwgyWikRec/7lxZp5O9+xXhniRTeqrci0/JrHGafbtI99/jTz6
         BkaxovK2HYu3zmDGJ1kL5Dfvkyq8WEf1LgMcRDp75YmaN2o/gC8lPe7hBn2cAc1tWhQS
         q5/FsOLtQdUQnzTQGt9MTFRSzHgYhmSTLRF5iId/LLl7+uY7CSPFBVX1SY2RcKdSaDrD
         SfrQ==
X-Gm-Message-State: APjAAAXfVmvAM0iMLzs6PjRaJTYk5yOh1Sb6zLpdUWMq2Efha0AXfIms
        7wl9SeMaVFQSihRa89jTqa8Ai66Sibm9JQaKGZYC3KvA5dBqBeti/Ke44KueA9UFWa3d2w3UWd/
        xlyQRZdcqdH80pOLVEL36
X-Received: by 2002:a05:6000:160d:: with SMTP id u13mr27903012wrb.22.1580223344454;
        Tue, 28 Jan 2020 06:55:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqzxSjmhSZD2Tttf46tNQLzb7ZsmuEELFVK5DxAR0ObzeGFHjxpYDTzH3jQ764BdW2uugDseSw==
X-Received: by 2002:a05:6000:160d:: with SMTP id u13mr27902999wrb.22.1580223344297;
        Tue, 28 Jan 2020 06:55:44 -0800 (PST)
Received: from localhost.localdomain.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id q130sm3325939wme.19.2020.01.28.06.55.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2020 06:55:40 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>
Subject: [PATCH 2/4] xfs: Remove mr_writer field from mrlock_t
Date:   Tue, 28 Jan 2020 15:55:26 +0100
Message-Id: <20200128145528.2093039-3-preichl@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200128145528.2093039-1-preichl@redhat.com>
References: <20200128145528.2093039-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

mr_writer field is no longer used by any code.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
 fs/xfs/mrlock.h | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/fs/xfs/mrlock.h b/fs/xfs/mrlock.h
index 79155eec341b..1923be92a832 100644
--- a/fs/xfs/mrlock.h
+++ b/fs/xfs/mrlock.h
@@ -10,14 +10,11 @@
 
 typedef struct {
 	struct rw_semaphore	mr_lock;
-#if defined(DEBUG) || defined(XFS_WARN)
-	int			mr_writer;
-#endif
 } mrlock_t;
 
 #if defined(DEBUG) || defined(XFS_WARN)
 #define mrinit(mrp, name)	\
-	do { (mrp)->mr_writer = 0; init_rwsem(&(mrp)->mr_lock); } while (0)
+	do { init_rwsem(&(mrp)->mr_lock); } while (0)
 #else
 #define mrinit(mrp, name)	\
 	do { init_rwsem(&(mrp)->mr_lock); } while (0)
@@ -34,9 +31,6 @@ static inline void mraccess_nested(mrlock_t *mrp, int subclass)
 static inline void mrupdate_nested(mrlock_t *mrp, int subclass)
 {
 	down_write_nested(&mrp->mr_lock, subclass);
-#if defined(DEBUG) || defined(XFS_WARN)
-	mrp->mr_writer = 1;
-#endif
 }
 
 static inline int mrtryaccess(mrlock_t *mrp)
@@ -48,17 +42,11 @@ static inline int mrtryupdate(mrlock_t *mrp)
 {
 	if (!down_write_trylock(&mrp->mr_lock))
 		return 0;
-#if defined(DEBUG) || defined(XFS_WARN)
-	mrp->mr_writer = 1;
-#endif
 	return 1;
 }
 
 static inline void mrunlock_excl(mrlock_t *mrp)
 {
-#if defined(DEBUG) || defined(XFS_WARN)
-	mrp->mr_writer = 0;
-#endif
 	up_write(&mrp->mr_lock);
 }
 
@@ -69,9 +57,6 @@ static inline void mrunlock_shared(mrlock_t *mrp)
 
 static inline void mrdemote(mrlock_t *mrp)
 {
-#if defined(DEBUG) || defined(XFS_WARN)
-	mrp->mr_writer = 0;
-#endif
 	downgrade_write(&mrp->mr_lock);
 }
 
-- 
2.24.1

