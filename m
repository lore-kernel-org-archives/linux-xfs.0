Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4C4FC433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 12:55:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233364AbiFKMzM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Jun 2022 08:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233328AbiFKMzL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Jun 2022 08:55:11 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2DA4C783
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 05:55:08 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id t2so1418931pld.4
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 05:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=ydQAd/KUL2HxHcZ6WmBYJjq1p3MkSEob3eJfHRJ1mls=;
        b=aFsWLUYtZM0dsRvnH/nhT9h8WmjnyKqk+pvfqQsHdwObyrDoe9hs+N+hJxxs+wXkgz
         OZ7jUW9Ug+8QF9zNepbqfm+Y0/eR54mhTdiUwRl7eUIbLUxCeRYBPltC5pFvdTsz5y9a
         7+mHeNwnNNIjRya5KF1/EhKXNKmPycAC1ouHoVFAmUujBheRa6G/9rRgFCiIZ2j2513k
         5SSme4wGXBcHGUf+8N05YUlSVcKUodp1gp+2XZ56X3OIlkShwaxWx4dU+3kSqkqEM25w
         E19U04WZzXiffy1gu4CPSSRxfEoP3nfiwW5dcZtxEGjAM2aV0vD+sAd9wsTKuoAT22eS
         kwgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ydQAd/KUL2HxHcZ6WmBYJjq1p3MkSEob3eJfHRJ1mls=;
        b=t/wxWbsedNwGIPp158vxQWOfjt233E0GCsDx7M/J3IlNDYT33jzTkhcysBwsFpquD0
         3Gni9Oo7kgOdTnPvCJrb5EC8oIZ7BxaquqtflvUmR6XFDIZOBhB1FjeHnZJIDJ+qZ8F2
         w9TDvWhQVCbAkRV5BN5OkS55aJq95hS/8brSoCm30b5aLr1LP0guivFnJhf/gpVZrd82
         RD95AYXsBdf9vyx3665KXPHXgqePkzvNTpK+mXk4IYJx65eoKLcr1DntxEIhuFXyHUCn
         BlEJz6uDCb1VrJyPl+F38hnzNAGMSovVFnPiYmFv5C4M1rxTihdbZolo8u7NkDfNh7xr
         pixA==
X-Gm-Message-State: AOAM531kxpCzLL8g4+jS3WlU6CzXtRwXY89AD2xhJM5cLfCfCiac2UyQ
        NEohBCAP9PLy5rTIhOsduvYL6jrCKQ==
X-Google-Smtp-Source: ABdhPJwo/BosLY7rB+AsnjkvHGTG/wYIsY2wZ3nLANV/FlCiRPyiO9axtRgprWGYuJx6Lh67ob9kXg==
X-Received: by 2002:a17:902:e80b:b0:168:b645:849e with SMTP id u11-20020a170902e80b00b00168b645849emr9625988plg.26.1654952108079;
        Sat, 11 Jun 2022 05:55:08 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id b10-20020a170902bd4a00b00168b7d639acsm1440115plx.170.2022.06.11.05.55.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Jun 2022 05:55:07 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, david@fromorbit.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH 0/2] xfs: random fixes for lock flags
Date:   Sat, 11 Jun 2022 20:54:43 +0800
Message-Id: <1654952085-13035-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Hi,

This patchset include some patches to factor out lock flags
and fix the mmap_lock state check.

Kaixu Xia (2):
  xfs: factor out the common lock flags assert
  xfs: use invalidate_lock to check the state of mmap_lock

 fs/xfs/xfs_inode.c | 64 ++++++++++++++++++----------------------------
 1 file changed, 25 insertions(+), 39 deletions(-)

-- 
2.27.0

