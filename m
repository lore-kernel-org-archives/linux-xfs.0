Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C40EE3F0D
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Sep 2023 18:00:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236904AbjILSBA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 14:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236852AbjILSBA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2023 14:01:00 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDF7C1
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 11:00:56 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 41be03b00d2f7-563f8e8a53dso4253214a12.3
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 11:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694541656; x=1695146456; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lJ3nn0TCcamStEoBW6+K+K0rivG07Z+xIZ+MYSx6piU=;
        b=eYiGdcokpPyQc07xWOEYc3jWOdpM88BMxRPRy6F6kgT7UOmL6b95WEZDtskYMTpE/g
         u+6dBJ0+cHGGf7ID+bdzUFPOjXBgaicRS0N211cFvG/pOcfiYFfYi2Aok0fb4xEA27Tb
         fJ453rSTOIHQRgqm850wzWVe44wBk9px6/6gPWqBNhFAHg8NZ5SiXq2ORptucQJR4hLm
         mhz4Ct4Hgb4UOdrO39OsyDB/yTwWxf2reIZ2JA5BWDL8ydhELM5LVlQ4tjFaauJomrW4
         ykJHh1HDOAkhuk/j1gJi8xWO9av+pWIjtreXDQ7naOc6LHhHysJIWjjkmXn7Xe4BU60m
         ErQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694541656; x=1695146456;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lJ3nn0TCcamStEoBW6+K+K0rivG07Z+xIZ+MYSx6piU=;
        b=fR4mz46JxR/W7IOXpXCTunKSQDiEczvluMwehjVyNrYe97RdnNYk8DsZKfjn8cxhBN
         fJk/t2pYhI4yvEB2+TKYzCGHG4nLp/V3g4MmeoTAJ/SZQcjob/cQjiyKhzhFjq3FD4wg
         8G2pWZbtkBYSlSkkj+lqQ4EEHvofkN+r9RVATxlpjtsUSxbCPJklXvTdzQpRku8vYKxX
         1mS6SQCCWCy+WDDNEn2N1jCgc27/yNVjwnawEFCEhScYBhWdX8rUxLKVPNQwQaMDa/Gl
         IOcGvdaRic3EtJAelQCvqXFMBDVqv6Weskmb770dz2p+HrPniv11SB+05Oq6JbR1PNvn
         sFLw==
X-Gm-Message-State: AOJu0YzS1/uKpF7mRfJKtX0R0/FftG0P3R4Kl1zYAvbYEOGyUZx5b9Ea
        tUpRq1SNnOrKP5ZHkrmyZdnhsGouavg1eQ==
X-Google-Smtp-Source: AGHT+IF1e7C6E4ZLaIkeuoGsikIYnwpDjngJq/SOSnyKqx/oLl1KWzYhcqG+bhPltMVzQ2u1H32mKw==
X-Received: by 2002:a05:6a20:918d:b0:14c:910d:972d with SMTP id v13-20020a056a20918d00b0014c910d972dmr186881pzd.12.1694541655923;
        Tue, 12 Sep 2023 11:00:55 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:e951:d95c:9c79:d1b])
        by smtp.gmail.com with ESMTPSA id x12-20020aa784cc000000b0068be7119c70sm3412246pfn.186.2023.09.12.11.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 11:00:55 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 4/6] xfs: check that per-cpu inodegc workers actually run on that cpu
Date:   Tue, 12 Sep 2023 11:00:38 -0700
Message-ID: <20230912180040.3149181-5-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
In-Reply-To: <20230912180040.3149181-1-leah.rumancik@gmail.com>
References: <20230912180040.3149181-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit b37c4c8339cd394ea6b8b415026603320a185651 ]

Now that we've allegedly worked out the problem of the per-cpu inodegc
workers being scheduled on the wrong cpu, let's put in a debugging knob
to let us know if a worker ever gets mis-scheduled again.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_icache.c | 2 ++
 fs/xfs/xfs_mount.h  | 3 +++
 fs/xfs/xfs_super.c  | 3 +++
 3 files changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index ab8181f8d08a..02022164772d 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1856,6 +1856,8 @@ xfs_inodegc_worker(
 	struct llist_node	*node = llist_del_all(&gc->list);
 	struct xfs_inode	*ip, *n;
 
+	ASSERT(gc->cpu == smp_processor_id());
+
 	WRITE_ONCE(gc->items, 0);
 
 	if (!node)
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 3d58938a6f75..29f35169bf9c 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -66,6 +66,9 @@ struct xfs_inodegc {
 	/* approximate count of inodes in the list */
 	unsigned int		items;
 	unsigned int		shrinker_hits;
+#if defined(DEBUG) || defined(XFS_WARN)
+	unsigned int		cpu;
+#endif
 };
 
 /*
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 9b3af7611eaa..569960e4ea3a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1062,6 +1062,9 @@ xfs_inodegc_init_percpu(
 
 	for_each_possible_cpu(cpu) {
 		gc = per_cpu_ptr(mp->m_inodegc, cpu);
+#if defined(DEBUG) || defined(XFS_WARN)
+		gc->cpu = cpu;
+#endif
 		init_llist_head(&gc->list);
 		gc->items = 0;
 		INIT_DELAYED_WORK(&gc->work, xfs_inodegc_worker);
-- 
2.42.0.283.g2d96d420d3-goog

