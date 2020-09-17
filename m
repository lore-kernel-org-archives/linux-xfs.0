Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0AEAC43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 11:41:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BBE3206BE
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 11:41:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gr7Dx154"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgIQLln (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 07:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726859AbgIQLi4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 07:38:56 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 969C5C061788
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 04:38:55 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id l71so1211835pge.4
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 04:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3M8M1GZG79EClznVjdpZihDccBwlRdgGQ8JMk2EzCPY=;
        b=gr7Dx154g9Vn0orvh9PYXyQYSeOBJ8uM4OhiVZ6KogmIQq8xDwPMfnXFLxpeUH5XHH
         qsAX69ASppcEQHSS4G/J7bv/Czf112X984Mg7xRtmsV5wKN1DDJQ1hSx6NJnDTvET34c
         fqkCqU/6qca/pRrs4//ij9i8Jm3TM9q4zMIfWpOupW2Iv7XGjnsBGBo4TDtpblKze9sD
         E84pd8T3QJmW53isKE4YQkronMTERNdQMpk6opnVLyMs1dZoPYCyiJwpAzZKK0c4QvUb
         J+rZILCfvNT9yfCdfJemrd7Tj2qX7gOUvrthfpDFb9MvIn8SgYve4EYiD+7hOBYyjKiM
         7IsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3M8M1GZG79EClznVjdpZihDccBwlRdgGQ8JMk2EzCPY=;
        b=JSa3BuoLe3C264GA1niQK5kuEqKWq1M+npOuoygJ/leSc7dyf2E49vkOxULMT8PQfW
         KBwUXYgUFpzd0dtNmzAQ1oVqsVWAMImzOUjpurpLIz0vT1vcCCQfAVwKU0kOWWv06Za8
         vz+vy2HO1dP6xb41klQY/jb/rDeD+j0YDbkOBiJITpm7dH9ebl/HWfWvMMvmtRjcgS+r
         sVLNK52SVXcRxqeCB6Bf53lH4/JIlDng17fZwZ2JtpytjiD7uMnLHTdq+7nj32+57ucT
         jUUGES4uBMpTb7VgpZtLaTkmrQDkMDtRBAVLB5gHyXAoZHnIwoaZ6FtJvP7grhyXUDwf
         oEMA==
X-Gm-Message-State: AOAM530YT7lyYVok0iWNrLIva6XH/0cEnuVne0xO0J7C+PANaufjsQAH
        YP6tInrHE7SBPsuBXIRDuWyMgb+xfw==
X-Google-Smtp-Source: ABdhPJye0wTQYmk75KmqirZVz9CgZOo+JBQ830Pz+L0z+AVs1mzMZPE17js4kOKQwSeSYbax/9crQg==
X-Received: by 2002:a63:1c4e:: with SMTP id c14mr21631712pgm.98.1600342734870;
        Thu, 17 Sep 2020 04:38:54 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id 64sm18761147pgi.90.2020.09.17.04.38.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2020 04:38:54 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v2 1/7] xfs: remove the unused SYNCHRONIZE macro
Date:   Thu, 17 Sep 2020 19:38:42 +0800
Message-Id: <1600342728-21149-2-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600342728-21149-1-git-send-email-kaixuxia@tencent.com>
References: <1600342728-21149-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

There are no callers of the SYNCHRONIZE() macro, so remove it.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_linux.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index ab737fed7b12..ad1009778d33 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -123,7 +123,6 @@ typedef __u32			xfs_nlink_t;
 #define EFSCORRUPTED	EUCLEAN		/* Filesystem is corrupted */
 #define EFSBADCRC	EBADMSG		/* Bad CRC detected */
 
-#define SYNCHRONIZE()	barrier()
 #define __return_address __builtin_return_address(0)
 
 /*
-- 
2.20.0

