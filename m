Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8D95C76195
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Mar 2023 11:08:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbjCQLIu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Mar 2023 07:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjCQLIt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2023 07:08:49 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420A3298D8
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 04:08:45 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id r19-20020a05600c459300b003eb3e2a5e7bso3058903wmo.0
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 04:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679051325;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wp5O0Uso/5747JI3g/VP4quGRfaMOOJgNJaJo0zDdP4=;
        b=We2Z2R9SAE7MnJMOOGwadEmORYbQ1viwYD6LS2+LsEwQ/bHNo9WWSK0LD/l3y8IKhT
         lSfJeW1FosUS6TKfzZo+si2py9wbB68SxKiv0E/giKV+05WFiNgDTFBDqJyGKU8CYXha
         WqLhSNPjM9rpY/YFGi0inAe0MaMuthRw1DvYZAErWrsG8lNkSEWAnCSFXJkfvT2hp/Q2
         7FIG9EgjXnoVNkSiGnGjWgW0kT0zGYmeo85qwy1SWhSeuD99zjoTY35IFBXTxNqSbEMp
         SFkTgrhj/HWVqbOu5jfQiXRJGwG6mynHraPTBBdw1SsrAldM8h6PPZQbee30mHpG2crG
         OGEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679051325;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wp5O0Uso/5747JI3g/VP4quGRfaMOOJgNJaJo0zDdP4=;
        b=fAhf+asB2UVfD3n4YhmX6UpzAOoyxO+0GjSmI8cWa1oxV4ATFBSDV+xB/+plg42MCs
         MVjGGPigY23QJ8HEVdcz/zwG+gO57QkjlWebMPKmPR5vs0E1agMKWrHIsIfmCuK6wHoW
         dT7d3LDK9McXCKt8+1AOUKUONb8XhIc6NnvZzlj2skK2ZyOMMtoRUJv17G8xpdOEjeLQ
         inIwjh3WbOR8kBHAPdUFD/WTap8nogyyY+oAm/gA3hcXcrj0LOScB1GoloeghsjBMNXu
         VJAIlmuGi9N+/fxV2MUK2mt7/cxOj78qoH+o3LA8lVZATS+QT+po7ZsZCF3tvBSpbqxS
         QjAA==
X-Gm-Message-State: AO0yUKW3PeHtESGE6KFUPvRf5FZGVZqAICJQl52C3LO0AQItvqt+KtuQ
        w5ewHYKvnmc8yHwMl/bAC+M=
X-Google-Smtp-Source: AK7set9+PvkqN9Oeh5kbkdb8JMtf4zw32rLb8vcZDZkqqiKWzi3PhQCMz89r3kdKX1/h1oPQYGoGkQ==
X-Received: by 2002:a05:600c:1d24:b0:3da:1f6a:7b36 with SMTP id l36-20020a05600c1d2400b003da1f6a7b36mr23745295wms.0.1679051324735;
        Fri, 17 Mar 2023 04:08:44 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id t14-20020a1c770e000000b003daf7721bb3sm7551100wmi.12.2023.03.17.04.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 04:08:44 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-xfs@vger.kernel.org, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5.10 CANDIDATE 15/15] xfs: remove xfs_setattr_time() declaration
Date:   Fri, 17 Mar 2023 13:08:17 +0200
Message-Id: <20230317110817.1226324-16-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230317110817.1226324-1-amir73il@gmail.com>
References: <20230317110817.1226324-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Gaosheng Cui <cuigaosheng1@huawei.com>

commit b0463b9dd7030a766133ad2f1571f97f204d7bdf upstream.

xfs_setattr_time() has been removed since
commit e014f37db1a2 ("xfs: use setattr_copy to set vfs inode
attributes"), so remove it.

Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_iops.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_iops.h b/fs/xfs/xfs_iops.h
index 4d24ff309f59..dd1bd0332f8e 100644
--- a/fs/xfs/xfs_iops.h
+++ b/fs/xfs/xfs_iops.h
@@ -18,7 +18,6 @@ extern ssize_t xfs_vn_listxattr(struct dentry *, char *data, size_t size);
  */
 #define XFS_ATTR_NOACL		0x01	/* Don't call posix_acl_chmod */
 
-extern void xfs_setattr_time(struct xfs_inode *ip, struct iattr *iattr);
 extern int xfs_setattr_nonsize(struct xfs_inode *ip, struct iattr *vap,
 			       int flags);
 extern int xfs_vn_setattr_nonsize(struct dentry *dentry, struct iattr *vap);
-- 
2.34.1

