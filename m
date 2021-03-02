Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97CE9C28E85
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Mar 2021 08:12:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7299864D9E
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Mar 2021 08:12:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245590AbhCBGjA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 01:39:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26023 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242529AbhCBCyV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Mar 2021 21:54:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614653575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dZFfZ874yaa8YKtxQkyzrYvtn9qlPDx16b5j7MmxPC0=;
        b=WQimdoK0agPTKrjFNZk05fZvKpEOYvoY5+8z5jLvC7upSFd5rJFsqQ/687CK+POa+a7NAD
        ddKB7j//H2OHOqvPojOfWLfMim78s4WWaDYBfYfYHvANppl1/kWLiYUjamyitVoC4mTV6y
        f6MTa22+jPMBJZ5tz58xvlUEkQk+w0o=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-ozQUfZzHOdmd0rmP27WI8g-1; Mon, 01 Mar 2021 21:49:14 -0500
X-MC-Unique: ozQUfZzHOdmd0rmP27WI8g-1
Received: by mail-pl1-f199.google.com with SMTP id t14so10356659plr.15
        for <linux-xfs@vger.kernel.org>; Mon, 01 Mar 2021 18:49:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dZFfZ874yaa8YKtxQkyzrYvtn9qlPDx16b5j7MmxPC0=;
        b=b3Ea2ex89dxnk/8/8zlR6AMLd7XLiJyGUQNm01NvhlAKet9wHUTrM/Kz0Se/xKMViR
         jWJlWt36ym+1kJvNF9pD1YZjqVuHI6MEgFycoO5i3BTSeafe2pa//dS3bB6jAtFQavqT
         OfZ+vPx1RnFCmrQYhLMc9diW5BCtwB0cITQQqCBsISoMM17AD6cV5Er3nWpipxCp0SD+
         jyUfTvYpIN/oSysfejRpYlAdkwqZjG6/UGI2ew+T5UKP1FGfUwVoNwtXt6nFVUgAD9xh
         NEGHgnz2/2sRIyKQJle6aJHCQqxjYdgwuifNkRt2UWy2+TW1gDlku1IbbN9/7ijJixpV
         o27g==
X-Gm-Message-State: AOAM531c7KCy6S/5CgDhvyXSA2pfV32s3OssJv+vGaNIr0OXesxHldSp
        KTHEgEaLaDNMlNMBJQoFSw5vwjRbz+QJdS0drcSJROin6jkRD6OgasPsIMkOo8bjWaIpca4/8Ks
        BhXIdHZ4fGM2RCF6SINrEU0+noLTJplD4wKSl6wqxbxkWjSJFK3cVmgNmcZECGrr5YKnQGWfaIQ
        ==
X-Received: by 2002:a17:903:22cf:b029:e5:b66c:5903 with SMTP id y15-20020a17090322cfb02900e5b66c5903mr655830plg.68.1614653353174;
        Mon, 01 Mar 2021 18:49:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzyvfcrEJ8soQpoNHGgHOdDTbbLfaI/tJ56A41gYLWVAV+2h0P68B8s2/yHeMRDzqXYnqJ6HA==
X-Received: by 2002:a17:903:22cf:b029:e5:b66c:5903 with SMTP id y15-20020a17090322cfb02900e5b66c5903mr655800plg.68.1614653352904;
        Mon, 01 Mar 2021 18:49:12 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d24sm18451031pfr.139.2021.03.01.18.49.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 18:49:12 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v7 1/5] xfs: update lazy sb counters immediately for resizefs
Date:   Tue,  2 Mar 2021 10:48:12 +0800
Message-Id: <20210302024816.2525095-2-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210302024816.2525095-1-hsiangkao@redhat.com>
References: <20210302024816.2525095-1-hsiangkao@redhat.com>
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
 fs/xfs/xfs_fsops.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index a2a407039227..9f9ba8bd0213 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -128,6 +128,15 @@ xfs_growfs_data_private(
 				 nb - mp->m_sb.sb_dblocks);
 	if (id.nfree)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
+
+	/*
+	 * Sync sb counters now to reflect the updated values. This is
+	 * particularly important for shrink because the write verifier
+	 * will fail if sb_fdblocks is ever larger than sb_dblocks.
+	 */
+	if (xfs_sb_version_haslazysbcount(&mp->m_sb))
+		xfs_log_sb(tp);
+
 	xfs_trans_set_sync(tp);
 	error = xfs_trans_commit(tp);
 	if (error)
-- 
2.27.0

