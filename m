Return-Path: <SRS0=E2x8=5X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CD94C2BA1A
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 02:05:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EDE42072A
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 02:05:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WmTD/uMQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgDGCFi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 22:05:38 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:40771 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgDGCFi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 22:05:38 -0400
Received: by mail-pj1-f65.google.com with SMTP id kx8so81199pjb.5
        for <linux-xfs@vger.kernel.org>; Mon, 06 Apr 2020 19:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=BvTmX4gppbcdVc3WGZ4gics2CUeJplBhGzoPGdUaOy4=;
        b=WmTD/uMQ82nwMAbs1/ah2I+/8cCDYioS70sY7lFsliV9DA+qmw6BAx7BcusvSz4hDu
         M0i1k65znMYx3BOmF/loeG93oWS2/VAgrm2CwPsRXh8fYZN+v9f+1QN5wXj9q7qaaNb6
         jBHK6XUNRPySIM9u7Gt/xOWv+UnhcuRilU/BVL0jwUIawdBt7WhT3zRAaHvTHdsjA8bY
         Zvd3aqDMFGbIEr5kILg+AhygTmKRVCuAIvbO+3xV+xzLAH7ouvl3W6GnABwlcEmEzKpP
         WwrRrTuYzbLq3dTyOp4vwX1QK2WJhZg5gAlM7CBRPBrZmzFNK7Pa74UNKF4ubLlfSnyW
         l8rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BvTmX4gppbcdVc3WGZ4gics2CUeJplBhGzoPGdUaOy4=;
        b=RDYqmEoeqf360SmaXTVgw3u1uNhrjZKO+UCGjHFeXy/3D7tfPRbZNHe0Oee74oSxh8
         OzKLZMZDH4KsqxuSL9J87M7l9alTJH7t4EbRe74afAogcX2h6jB1dG+uDQmDilAMvANP
         0xJ63kXMuKHqkvGwmRljEOY2pim8GlOQiYYwYakg/eGcncrkcssTW9aPzCSHzO2HTLpr
         ZVsSCizmNhkhAo5ZrTgrxQSck5K6t/3GCU4BT8jMeAFMNHuU3oYbzGIUV774HhfyYpgg
         r421+HFpmNzDeZx0tVdlU1bBz3RgT+qvE+kmRRFmyvg7BboVpi9fYFWqnw0gQ9IZ1B0Q
         OVdw==
X-Gm-Message-State: AGi0PuaXBV10pap8DG6GjlPYyavwkEoP8qBI+1yj8uZ8Wpjl+Cu51IX5
        IphngK1/4F9sfW3ENRtaENH3wssz0g==
X-Google-Smtp-Source: APiQypLy5p71y5XtMB4wEu+R21wfozSMGQHPdPYl3Sw3z/J+pr3+HPOSeddCj/RzGVI5KlRM59bsDA==
X-Received: by 2002:a17:90a:8a17:: with SMTP id w23mr2368083pjn.94.1586225136970;
        Mon, 06 Apr 2020 19:05:36 -0700 (PDT)
Received: from he-cluster.localdomain ([67.216.221.250])
        by smtp.gmail.com with ESMTPSA id a24sm3793809pgd.50.2020.04.06.19.05.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Apr 2020 19:05:36 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v2] xfs: check if reserved free disk blocks is needed
Date:   Tue,  7 Apr 2020 10:05:24 +0800
Message-Id: <1586225124-22430-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

We share an inode between gquota and pquota with the older
superblock that doesn't have separate pquotino, and for the
need_alloc == false case we don't need to call xfs_dir_ialloc()
function, so add the check if reserved free disk blocks is
needed.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
v2:
 - improve the commit log.

 fs/xfs/xfs_qm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 6678baa..b684b04 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -780,7 +780,8 @@ struct xfs_qm_isolate {
 	}
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_create,
-			XFS_QM_QINOCREATE_SPACE_RES(mp), 0, 0, &tp);
+			need_alloc ? XFS_QM_QINOCREATE_SPACE_RES(mp) : 0,
+			0, 0, &tp);
 	if (error)
 		return error;
 
-- 
1.8.3.1

