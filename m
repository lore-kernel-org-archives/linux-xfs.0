Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 034C9C7619A
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 23:23:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjDKXXt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 19:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjDKXXs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 19:23:48 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E652D73
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 16:23:47 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 41be03b00d2f7-51870e745bfso601590a12.2
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 16:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1681255427;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=74BW2jmA2l2bcdZ/oPhoGMqmDB9/XRTZqnGuuyumK8M=;
        b=ab9/9FtSVT06XBFp3gKHNXfyQjLhL+nIxHj7O2ZmxTRvOuYR3IKX2AN9AU/GGCK709
         K8i5HNGgBLWCWeL4JD+OWSv3vsOeTrmcTeIDa9xMqwClhJmuIeHh5nRtY2Ffn+F/C4+2
         GvqPsBhXjiaXUPKpDjT/AdEJHOEG1V5DO0SoHAEVM4eS3D6PQsj2JZtBu+N6dq43vPmC
         cqiCTm95ytki+MiCqgY6hmAFdTEB+xsMzWzQ2S28nulQCyuTTS4cqLcNz5uJaQM+wD6I
         thBWIn3S5d3RBfTl3gu2hZclbBsjyzd8Kre+W6gzkhqUw87YUvzFnEzXS4554Rxstkfo
         dVzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681255427;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=74BW2jmA2l2bcdZ/oPhoGMqmDB9/XRTZqnGuuyumK8M=;
        b=R4MSuCL9DCpKurjsy2w8522eBvRa01+QA7STs2c6yWYDeaPUL2XU4sg4ioCSk3onoD
         pJlYKbqndjdcoYBNnmxIIHSUGLDTiCOLiNBOfad693pfLz6m3DFleB28F6T7px2OdH68
         HQI20xqA8nHO7N1PIug3iiVBLmM5gmcBr/MEYNt/8r4Gpo0UPnRSAg/sZKYBMX1ypoWw
         fL80Z2SS/zUWC1AXBl6e9aN2bokfmtWmOt2u5tWUQfg20OWNs7NG6vM4nG8l4E6EK0AK
         Z5rV2G+MPK0LGxxZ+7Co+QwAI7TBUbNbyRaPk7KE/3ksRqjV+RBJRCBBTSPwp5VlaoW+
         8yNQ==
X-Gm-Message-State: AAQBX9dA+P+gMDBP4FqPBQK6MDeCKW7W26kQWRBNjSlbU6NO+gYDdBq4
        imouN2hQwAMlxrt5jO1ZK9yGQOdya1fE/fUwshrXcUGp
X-Google-Smtp-Source: AKy350YjFsXFswthkVFZOeuNsfKMKgEa4a6JMzh/1f4Ki7pJO+h2FUqRWbvssZB4h8utYMG8nj9PnA==
X-Received: by 2002:a62:1a4f:0:b0:62d:b4ad:522c with SMTP id a76-20020a621a4f000000b0062db4ad522cmr15616839pfa.24.1681255427196;
        Tue, 11 Apr 2023 16:23:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id k10-20020aa7820a000000b0062db3444281sm10364326pfi.125.2023.04.11.16.23.46
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 16:23:46 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pmNKy-002H7j-As
        for linux-xfs@vger.kernel.org; Wed, 12 Apr 2023 09:23:44 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pmNKy-000ykp-11
        for linux-xfs@vger.kernel.org;
        Wed, 12 Apr 2023 09:23:44 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: remove WARN when dquot cache insertion fails
Date:   Wed, 12 Apr 2023 09:23:41 +1000
Message-Id: <20230411232342.233433-2-david@fromorbit.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230411232342.233433-1-david@fromorbit.com>
References: <20230411232342.233433-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

It just creates unnecessary bot noise these days.

Reported-by: syzbot+6ae213503fb12e87934f@syzkaller.appspotmail.com
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dquot.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 8fb90da89787..7f071757f278 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -798,7 +798,6 @@ xfs_qm_dqget_cache_insert(
 	error = radix_tree_insert(tree, id, dqp);
 	if (unlikely(error)) {
 		/* Duplicate found!  Caller must try again. */
-		WARN_ON(error != -EEXIST);
 		mutex_unlock(&qi->qi_tree_lock);
 		trace_xfs_dqget_dup(dqp);
 		return error;
-- 
2.39.2

