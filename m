Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 671B0C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Dec 2022 17:31:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236311AbiLMRbE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 12:31:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236313AbiLMRaj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 12:30:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4827823385
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 09:29:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670952589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r0lyKZLytTPe2tgsoK8ec8CNBM0ybARfQleJk6OVIIM=;
        b=FTWI/44Yv8CWHo51W0omCQAVQQwlYEzZbbQFYXYdumFcXwA0YsDJOW0ZdkPswuwYtm/WOQ
        i4k/jw1/mvwo/2BJAruohVo6bgxI8PJkeuqvqzejVz369GR16Xo6L2HN6h9C/lT7K8/L9h
        X7L3mD5wUQHia2q1+LKMTSe3vJZA9EU=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-227-kq1tEAbXM9aJ5_NzCS-lOA-1; Tue, 13 Dec 2022 12:29:48 -0500
X-MC-Unique: kq1tEAbXM9aJ5_NzCS-lOA-1
Received: by mail-ej1-f72.google.com with SMTP id sb19-20020a1709076d9300b007c17017bb51so4375476ejc.21
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 09:29:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r0lyKZLytTPe2tgsoK8ec8CNBM0ybARfQleJk6OVIIM=;
        b=ZUj+GJq8T7Cm201jgOp2F4bd/Cjw2/qWsJL0TEG2yM9TI5YRKbMI0Wp1aYHm5bJdBc
         o8bps0MG0XEexd+OWFFT7RfpSHN0TY1UrWopV42DdmS2zNy7qxvh4BXM9KXdfkkhlqpJ
         RHGYgmjWD2mBj/RH0djdwKNrYRb1h9Rms28mPsFVOLH/IkS+IrKIzs0S3pHe7JNEwOSA
         2Y/AF8SmKXlpwLxcjOzYMWU2aSmaO9a6LG66VFgYKeyx+SI9nsr9f7YgbCNPu1NQs9fJ
         xS/o9r9Rsr6wXdjahfDvfO4ptuK8iwL3ZoVrQGqzje2nGiadTfXxV73Bx3fzYluv6HcH
         GJvg==
X-Gm-Message-State: ANoB5plbHs0b8QfB2xJURXOPsqag/6VpsMymOhQqMRgSeGlLPnPm2yVB
        nLBGamcOhqi3ZtqnnbA4jiEClSTSSK5k3FqV3m6MiQFqHk4o4lOYBfDApdrepKW6f5m0V4eXF4Q
        e/8J2yh0H+zTRQhXDRrC1ZuweI1BNwNAILgn9nr7EIkjI+0ijtlKPbjNQDsh42FMlXoMPwtc=
X-Received: by 2002:a05:6402:5389:b0:461:fc07:b9a7 with SMTP id ew9-20020a056402538900b00461fc07b9a7mr22768390edb.2.1670952586915;
        Tue, 13 Dec 2022 09:29:46 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4MMVU2ZSTGshSUNs1Im4i1IYGnQpezMKu2iDzHR1GIoaE/NP6NezsSzt33Apg0fNAeBJPfMA==
X-Received: by 2002:a05:6402:5389:b0:461:fc07:b9a7 with SMTP id ew9-20020a056402538900b00461fc07b9a7mr22768369edb.2.1670952586679;
        Tue, 13 Dec 2022 09:29:46 -0800 (PST)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id ec14-20020a0564020d4e00b0047025bf942bsm1204187edb.16.2022.12.13.09.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 09:29:46 -0800 (PST)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     Andrey Albershteyn <aalbersh@redhat.com>
Subject: [RFC PATCH 08/11] xfs: don't enable large folios on fs-verity sealed inode
Date:   Tue, 13 Dec 2022 18:29:32 +0100
Message-Id: <20221213172935.680971-9-aalbersh@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221213172935.680971-1-aalbersh@redhat.com>
References: <20221213172935.680971-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

fs-verity doesn't work with large folios. Don't enable large folios
on those inode which are already sealed with fs-verity (indicated by
diflag).

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/xfs_iops.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index b229d25c1c3d6..a4c8db588690e 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1294,7 +1294,12 @@ xfs_setup_inode(
 	gfp_mask = mapping_gfp_mask(inode->i_mapping);
 	mapping_set_gfp_mask(inode->i_mapping, (gfp_mask & ~(__GFP_FS)));
 
-	mapping_set_large_folios(inode->i_mapping);
+	/*
+	 * As fs-verity doesn't support folios so far, we won't enable them on
+	 * sealed inodes
+	 */
+	if (!IS_VERITY(inode))
+		mapping_set_large_folios(inode->i_mapping);
 
 	/*
 	 * If there is no attribute fork no ACL can exist on this inode,
-- 
2.31.1

