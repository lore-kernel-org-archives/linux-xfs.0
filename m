Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C882DC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 13:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96B012310E
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 13:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391098AbhAZNFS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 08:05:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42142 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392455AbhAZM6q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jan 2021 07:58:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611665840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LKEJBUlECNjHIiM5A8RvrhMd5bGjwoPrgZlmgIxprYE=;
        b=AoB67ULK7LmAOBJgqnc9dGYPAJAHOdHMDxIJcUWl/kq+O5FHoeqYjaf4uzC7fhycWh6eJX
        t7juK0Egl773rckSKTU8wkXty5s1BOQ0poiQJgeRRBwnr+pysB8WmcQJQsee7wSyV3+u5j
        1OX31OjVF2dTX46J0HQMR6bYNAtKF0o=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-1otY0OPXMVi-Mx60Ji5R7w-1; Tue, 26 Jan 2021 07:57:17 -0500
X-MC-Unique: 1otY0OPXMVi-Mx60Ji5R7w-1
Received: by mail-pg1-f200.google.com with SMTP id q13so2553715pgs.6
        for <linux-xfs@vger.kernel.org>; Tue, 26 Jan 2021 04:57:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LKEJBUlECNjHIiM5A8RvrhMd5bGjwoPrgZlmgIxprYE=;
        b=q5TIy5DhUTaQv222Xd3GbtDDL9rzkc8TP4Bv6bEKlRR1tzO7lrBDr80wlymOQNVW71
         feBta9izer5zvyaGwnuXy+hucCLG2DMn0XBmq/9dMlZspoJSKhlEui9Al2UGmRfl0RPU
         SzHsrkMJU54LSuh/qWefv4tcfEeJu7ChzFd6/h4koihrDO4Y3q33a/9avAislYUbIyoO
         nydCIGTb0yEsnS2xuhisJDh1JvAN9Qzz7Jcof6+k07YDiOhe6zIvRtGqSPcku4Go4SOE
         Z+DxXZl2On8ADoA3UrSlG8mcdANDcoDrND4b7tXBHt11tKvs/RularWe7qtR6RK5DiQC
         DPcQ==
X-Gm-Message-State: AOAM532dLA5rkJY2mo6A8teN/hA1EiM8utgrZgWnAEr6JtBRbO/F4gGw
        Cy/Cn+cv1b7Sqa8tM5jW0zIBTQ7478RW3UQbdzGEWq3wvqnhyOkaOF6LecbrQzs+HuaDRnyGz5o
        oZKXnxilJiNU6SQI0FsQB13Odlua/j0KDC72YkmK8WfyQh9/S4bErTUj6TTDdQBhlBCkW6h9DRA
        ==
X-Received: by 2002:a17:90b:8b:: with SMTP id bb11mr6215129pjb.128.1611665836014;
        Tue, 26 Jan 2021 04:57:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy/oZezwDebu1JzrZFRBTrHR8VynkauPtZq/s8KI82dYZ6QnQWxC8aGArxKoOVB1PQc7q1akQ==
X-Received: by 2002:a17:90b:8b:: with SMTP id bb11mr6215103pjb.128.1611665835720;
        Tue, 26 Jan 2021 04:57:15 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b203sm19243174pfb.11.2021.01.26.04.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 04:57:15 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v6 3/7] xfs: update lazy sb counters immediately for resizefs
Date:   Tue, 26 Jan 2021 20:56:17 +0800
Message-Id: <20210126125621.3846735-4-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210126125621.3846735-1-hsiangkao@redhat.com>
References: <20210126125621.3846735-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

sb_fdblocks will be updated lazily if lazysbcount is enabled,
therefore when shrinking the filesystem sb_fdblocks could be
larger than sb_dblocks and xfs_validate_sb_write() would fail.

Even for growfs case, it'd be better to update lazy sb counters
immediately to reflect the real sb counters.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/xfs_fsops.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index a2a407039227..2e490fb75832 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -128,6 +128,14 @@ xfs_growfs_data_private(
 				 nb - mp->m_sb.sb_dblocks);
 	if (id.nfree)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
+
+	/*
+	 * update in-core counters now to reflect the real numbers
+	 * (especially sb_fdblocks)
+	 */
+	if (xfs_sb_version_haslazysbcount(&mp->m_sb))
+		xfs_log_sb(tp);
+
 	xfs_trans_set_sync(tp);
 	error = xfs_trans_commit(tp);
 	if (error)
-- 
2.27.0

