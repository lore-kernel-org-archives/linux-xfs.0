Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E77C636D7
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Feb 2023 17:52:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbjBHRwt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Feb 2023 12:52:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbjBHRws (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Feb 2023 12:52:48 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A7B8768D
        for <linux-xfs@vger.kernel.org>; Wed,  8 Feb 2023 09:52:48 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id c10-20020a17090a1d0a00b0022e63a94799so3344616pjd.2
        for <linux-xfs@vger.kernel.org>; Wed, 08 Feb 2023 09:52:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p7yWFoqQq2NPWGEKTtGbqsiRmniixxNrgpmfGjs0GqY=;
        b=oSK5zRt5IjL8CDt5zqqjGZhpPYL+07FBFobV7ibT5ywppjoJY7dVSHtBd8ILtJdhhY
         x7KrHl33/A9zb3Iok0Xq0NaN+W5B1REU+pHGOPMpSangYWiUCAP55NPKN2eW/jLkcuKw
         2+WdETKwP5lc29TUYpPvFzPqEbdLwdfqF8H6ObDTxHaQAOwmmmUkSitw6mXJweKnaiT6
         lpGGcRKWJoOMxmjuRC9nXAvd5F3hiMrgdALUcxCTkIUI9cJ1/BYttUcxuDU9BMtnVyZD
         NNNG960O29mwXIx2tXanp2B9N7MwASng72LVVRukg0pCVs/L0ONzIPKDYNGLuH+WiOmh
         s9Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p7yWFoqQq2NPWGEKTtGbqsiRmniixxNrgpmfGjs0GqY=;
        b=Cjau7oI448JtDT8KP9T6GOgWsM7UzQ2DJeeAzz0bn0xmOT6mxsXkJTWMmDXn5gW0kH
         UJs8a6i5w/pssYeZZm24cNxH6Awcssist+8XGa/TWtcMQcyefuAVzIMSVYN+MYPVPB+q
         UPg3i/dwoaPixXhGFAXBzGkfiKnzAieXriG09YXn3nCuMm+2JCdTsEdhWcP3s7PX9Vah
         56ygIzJoagl1vFHawdx516Di/D6+hX5Prnfy8gRm+QDHMRDzWhhTqUhrRwU95SYaE1qD
         fduWeddkBOUzs0+Ojg77lyU6MupqcYDPNdHJzH1cDzvZuDGTy/Sh/6IXjdIefVkbXCPR
         Y5IQ==
X-Gm-Message-State: AO0yUKUwt5ZRoeblqiOMWwrgUJfEvNT8g7Q5u/a6mfD9mXXRaMeFJqg1
        MNfIBSnOW9zux9Gq0cXDr5JgS4doNwgKDQ==
X-Google-Smtp-Source: AK7set+RTbGlV8ZwEoXt74Ck14VNSn+V285gIt0yZycbnm2bzqznZy0OUsX4CdVTWNDBkYyPNrSn+A==
X-Received: by 2002:a17:903:1389:b0:199:3d76:bc22 with SMTP id jx9-20020a170903138900b001993d76bc22mr3492859plb.26.1675878767375;
        Wed, 08 Feb 2023 09:52:47 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:726:5e6d:fcde:4245])
        by smtp.gmail.com with ESMTPSA id y17-20020a170902d65100b00198e397994bsm10911452plh.136.2023.02.08.09.52.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 09:52:46 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 07/10] xfs: don't assert fail on perag references on teardown
Date:   Wed,  8 Feb 2023 09:52:25 -0800
Message-Id: <20230208175228.2226263-8-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
In-Reply-To: <20230208175228.2226263-1-leah.rumancik@gmail.com>
References: <20230208175228.2226263-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 5b55cbc2d72632e874e50d2e36bce608e55aaaea ]

Not fatal, the assert is there to catch developer attention. I'm
seeing this occasionally during recoveryloop testing after a
shutdown, and I don't want this to stop an overnight recoveryloop
run as it is currently doing.

Convert the ASSERT to a XFS_IS_CORRUPT() check so it will dump a
corruption report into the log and cause a test failure that way,
but it won't stop the machine dead.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/libxfs/xfs_ag.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 005abfd9fd34..aff6fb5281f6 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -173,7 +173,6 @@ __xfs_free_perag(
 	struct xfs_perag *pag = container_of(head, struct xfs_perag, rcu_head);
 
 	ASSERT(!delayed_work_pending(&pag->pag_blockgc_work));
-	ASSERT(atomic_read(&pag->pag_ref) == 0);
 	kmem_free(pag);
 }
 
@@ -192,7 +191,7 @@ xfs_free_perag(
 		pag = radix_tree_delete(&mp->m_perag_tree, agno);
 		spin_unlock(&mp->m_perag_lock);
 		ASSERT(pag);
-		ASSERT(atomic_read(&pag->pag_ref) == 0);
+		XFS_IS_CORRUPT(pag->pag_mount, atomic_read(&pag->pag_ref) != 0);
 
 		cancel_delayed_work_sync(&pag->pag_blockgc_work);
 		xfs_iunlink_destroy(pag);
-- 
2.39.1.519.gcb327c4b5f-goog

