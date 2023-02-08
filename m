Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F3BBC636D3
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Feb 2023 17:52:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbjBHRwn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Feb 2023 12:52:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjBHRwm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Feb 2023 12:52:42 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E19659E2
        for <linux-xfs@vger.kernel.org>; Wed,  8 Feb 2023 09:52:41 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id v23so20205725plo.1
        for <linux-xfs@vger.kernel.org>; Wed, 08 Feb 2023 09:52:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MzEhli+EE9D6xeYPh4OGejU4RxhhphZrw/a50+FrANE=;
        b=JYXC7wgCC9vGOnjABtjwSdQXb6pWKXdDTTOk0I0icftxQGH1dzLfdYxQiiakHvi9Fr
         G5M8xUrFHOkdrk177FumBG/DDU6m4AklgTn4ik3L5Cpz+7hLsrpwvK+lLO95oTKi89k2
         XLTR//dmYuc9U6PK9bcNMrD3pdpTmhwGpj86qb+lZbsIH9oN4ZqU4fDyrWevG9C1QaFe
         RlcC7AQSpZHNe5s4KX+f3tApfLZdjCdx3tdzaCrOX3QEh4a7IXudwIkO7lGo2WHRRdkO
         PkDOBJx+ZOsj79i9OdcGpXl50a3T/BVwwlpARSWXWqVP+AseTG+Qrc7fU0umemEuh2MX
         wB4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MzEhli+EE9D6xeYPh4OGejU4RxhhphZrw/a50+FrANE=;
        b=kyhucbmCIsQZtAoVJMB2j1KGcLTrcgF5M6cICE4gXgiCFTXOgsQJFkYiXM4dNtnqu9
         GDsfyBVCDURCyugMrPI0z2rR4D0EdU2B1X8HVkPhIV2buLLRd7aT4BvpQaTI+EuNrzYH
         HwqgTRGZJKW5MXBppQE/cDCX9XxKGL7R4kjQnGCNgq4wZCij5fqpvNUKgD69lcJNI3j7
         8LeX70DbMNDKT5C3LkSzTKyqov+BgVYYg2PnvEk9eZ/C692tecIDxJcSfEP45b4Dbb9C
         Jlkbroh1Zk1JP1foknOpjJk3dEpQdmAXMhZvqniQBS+bkWlKQwHS85H3QFFabdkR/56C
         LD9w==
X-Gm-Message-State: AO0yUKUkFd/7kn8tE6CSCbxwyG8JkmkErqmPYYUc12XEz5hWqtDLW3ax
        Q9SHztQTl6PWG7H5AjAPogtxyMANFsxyMQ==
X-Google-Smtp-Source: AK7set8uF5C66OccrR+JYFtT3hd3s8g5F1ptT63YkqB2jIwsKaOVeUlh79xpUQ8IioI4Tz3vBf4NSQ==
X-Received: by 2002:a17:903:404c:b0:199:320c:41ab with SMTP id n12-20020a170903404c00b00199320c41abmr5342339pla.56.1675878760404;
        Wed, 08 Feb 2023 09:52:40 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:726:5e6d:fcde:4245])
        by smtp.gmail.com with ESMTPSA id y17-20020a170902d65100b00198e397994bsm10911452plh.136.2023.02.08.09.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 09:52:40 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Allison Henderson <allison.henderson@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 01/10] xfs: zero inode fork buffer at allocation
Date:   Wed,  8 Feb 2023 09:52:19 -0800
Message-Id: <20230208175228.2226263-2-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
In-Reply-To: <20230208175228.2226263-1-leah.rumancik@gmail.com>
References: <20230208175228.2226263-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit cb512c921639613ce03f87e62c5e93ed9fe8c84d ]

When we first allocate or resize an inline inode fork, we round up
the allocation to 4 byte alingment to make journal alignment
constraints. We don't clear the unused bytes, so we can copy up to
three uninitialised bytes into the journal. Zero those bytes so we
only ever copy zeros into the journal.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 1d174909f9bd..20095233d7bc 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -50,8 +50,13 @@ xfs_init_local_fork(
 		mem_size++;
 
 	if (size) {
+		/*
+		 * As we round up the allocation here, we need to ensure the
+		 * bytes we don't copy data into are zeroed because the log
+		 * vectors still copy them into the journal.
+		 */
 		real_size = roundup(mem_size, 4);
-		ifp->if_u1.if_data = kmem_alloc(real_size, KM_NOFS);
+		ifp->if_u1.if_data = kmem_zalloc(real_size, KM_NOFS);
 		memcpy(ifp->if_u1.if_data, data, size);
 		if (zero_terminate)
 			ifp->if_u1.if_data[size] = '\0';
@@ -500,10 +505,11 @@ xfs_idata_realloc(
 	/*
 	 * For inline data, the underlying buffer must be a multiple of 4 bytes
 	 * in size so that it can be logged and stay on word boundaries.
-	 * We enforce that here.
+	 * We enforce that here, and use __GFP_ZERO to ensure that size
+	 * extensions always zero the unused roundup area.
 	 */
 	ifp->if_u1.if_data = krealloc(ifp->if_u1.if_data, roundup(new_size, 4),
-				      GFP_NOFS | __GFP_NOFAIL);
+				      GFP_NOFS | __GFP_NOFAIL | __GFP_ZERO);
 	ifp->if_bytes = new_size;
 }
 
-- 
2.39.1.519.gcb327c4b5f-goog

