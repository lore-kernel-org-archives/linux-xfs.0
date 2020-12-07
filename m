Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 319E3C433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 00:18:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 002F723108
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 00:18:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727393AbgLGAR5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Dec 2020 19:17:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23153 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726046AbgLGAR5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Dec 2020 19:17:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607300190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=NENDvw0JxA1rt741Or+cB19d9O6Fy2czmjuXVdfK9OM=;
        b=CmFj7k6ddo2NY8gSKR9tvo5y6R8hiqKJWeoqIgMLKj+t6xBBg/tyOLkvvuzjms9I3jOfR+
        76MkefgVCfk7lNeZulS5njT+4/PCOskFrG5bP7gPgsfTUsbETGt945ubOrF9Fgjy3Nil6/
        G/YR5ZxBDQnh11PwY9Z+BAgTL8aHWcY=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-pc7cbHIKO5OcY1kGPAVsRQ-1; Sun, 06 Dec 2020 19:16:29 -0500
X-MC-Unique: pc7cbHIKO5OcY1kGPAVsRQ-1
Received: by mail-pf1-f197.google.com with SMTP id t8so7874736pfl.17
        for <linux-xfs@vger.kernel.org>; Sun, 06 Dec 2020 16:16:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NENDvw0JxA1rt741Or+cB19d9O6Fy2czmjuXVdfK9OM=;
        b=S2quD0UbZciNSQL+1+pV/qDPvf2UFAR53lzK+odhHMp0LyKDtQDlW7xOCzjhptsGps
         14+bP07cIlMfYHqxcebsnH9Sx4QZtIZxQW3MIcvz0ZGihgfmgxRqXDcXNCzdoWEw/+oc
         ssFKBSE3kak5GD0B+BC3g6RbP3dP4aFBQlV8qEeFxLDUjkwVPFXyjJXMJFxdT/WFyP3F
         MxbtV5EF8nISi7tUBpv15MeL7zXzMTkBfW6rhmZnI6z6rJlzr6nS+6QZEFz3R8r+1QqW
         J9zIth8+Yo7gChpNPmSkuoJCC6ZMj6NrA7cKpf2uhVKN/5UItUj9KUO+7saUz/ouRznY
         qboQ==
X-Gm-Message-State: AOAM5339qbBIKPgc8dBbgwywgEEKlCEGNoDFNFQR1m0ZR77el1RChurs
        j2iB58dTLppH8INJj5dAyxURdlHwndRlS6apEz9TeZIXyJRHlJV+mzDN7BMd3PAHk06vNeA4+hU
        6iBbqBnilu0mUQTxeuc6zY8ce0ZWfnsg/MFhtJkzpN+GfMXUd9+cBkIWn0NIzGmtYMy1zJNNc4Q
        ==
X-Received: by 2002:a63:1622:: with SMTP id w34mr681132pgl.1.1607300188192;
        Sun, 06 Dec 2020 16:16:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy5dWBoL6+4xfOvvrrg+tqMuNBJkdode+Q+5qrItb1/LBKFUVJqJ1gxGAk5R1IpRkEUQn9s2Q==
X-Received: by 2002:a63:1622:: with SMTP id w34mr681115pgl.1.1607300187936;
        Sun, 06 Dec 2020 16:16:27 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o9sm8218056pjl.11.2020.12.06.16.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 16:16:27 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v3 1/6] xfs: convert noroom, okalloc in xfs_dialloc() to bool
Date:   Mon,  7 Dec 2020 08:15:28 +0800
Message-Id: <20201207001533.2702719-2-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201207001533.2702719-1-hsiangkao@redhat.com>
References: <20201207001533.2702719-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Boolean is preferred for such use.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 974e71bc4a3a..45cf7e55f5ee 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1716,11 +1716,11 @@ xfs_dialloc(
 	xfs_agnumber_t		agno;
 	int			error;
 	int			ialloced;
-	int			noroom = 0;
+	bool			noroom = false;
 	xfs_agnumber_t		start_agno;
 	struct xfs_perag	*pag;
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
-	int			okalloc = 1;
+	bool			okalloc = true;
 
 	if (*IO_agbp) {
 		/*
@@ -1753,8 +1753,8 @@ xfs_dialloc(
 	if (igeo->maxicount &&
 	    percpu_counter_read_positive(&mp->m_icount) + igeo->ialloc_inos
 							> igeo->maxicount) {
-		noroom = 1;
-		okalloc = 0;
+		noroom = true;
+		okalloc = false;
 	}
 
 	/*
-- 
2.18.4

