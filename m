Return-Path: <SRS0=8N9+=DU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1035BC433E7
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 04:07:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A76FC20838
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 04:07:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fk0tKrO9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgJMEHN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Oct 2020 00:07:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31484 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726400AbgJMEHN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Oct 2020 00:07:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602562032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=Ho6xIGtd8X/MZZQpxl5cjFXDBzr1eIaGRwS6kQUqFE8=;
        b=Fk0tKrO99VWqn41gpk9GdQPMbo3E6FSfNgMj2Uo0RLnKvGFrNSFvuWjDHiIVefwDZOlh8f
        FeQCaVWDcSZhdpgQCSYiCXwsJG/kNd4zyZCVe5Lq61UB+s2SXaU/VxcfU4NGK0tgHp5ciR
        Qn5XR9Dq5e2Y+XvmDV3z1F0kwP7RNic=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-3YMWsm4YND2sOVcQsc_Cbg-1; Tue, 13 Oct 2020 00:07:10 -0400
X-MC-Unique: 3YMWsm4YND2sOVcQsc_Cbg-1
Received: by mail-pf1-f199.google.com with SMTP id a27so14136763pfl.17
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2020 21:07:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Ho6xIGtd8X/MZZQpxl5cjFXDBzr1eIaGRwS6kQUqFE8=;
        b=SVwAb7RpvzPewUzxvdACN5JSpfhDaaIhBLn7a4oiwmXyCjQWwUCzZ+yScTHCj0o4d4
         s/i9hhpzYhqBZIRp94/XmZnSxkE+Jl3WQw3tsQrDJhpqXD42LQI2Ep6T0M1q2NoxcTbw
         vtZfcKWazokTVA9SreuXS/1/k1/azThUiip10ACV89UrpMXy5f4X93UpwlHlW5hPQd+M
         O4SPphltZRWhz+qqMVuwTsF8uwbQ6dwg65QUOGMaz7vIe2hNksOLklUw57k4ZtDU+Hu+
         60so5crUeYtAPpRLoC0PMRhhydvcnwAEu8vRproQaXEdu9h1PUiUTRtwmf63peXzGavf
         ixNA==
X-Gm-Message-State: AOAM532XVtBW4Ct+3/vyH2C54+BfcM1QAcoYkBlLTkkOORJyoAOqf3p4
        R8riU82GpKddzaJZ4iF5W5laXTZ3yR0v8CKyG6CoYhb7H6RSn99r3rFXZEJSYplwfB8hLwT758C
        ngy57aeyzS6KhThjHNwS7
X-Received: by 2002:a17:90b:1218:: with SMTP id gl24mr3826784pjb.5.1602562028977;
        Mon, 12 Oct 2020 21:07:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx4ZfgK5O4tj3F4atKZKtN0lNgpU31At9LQBy5djntqK0mtVYILRIQcxr5iTpn61sMnxWihsA==
X-Received: by 2002:a17:90b:1218:: with SMTP id gl24mr3826768pjb.5.1602562028753;
        Mon, 12 Oct 2020 21:07:08 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e21sm20387615pgi.91.2020.10.12.21.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 21:07:08 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v6 0/3] xfsprogs: consolidate stripe validation
Date:   Tue, 13 Oct 2020 12:06:24 +0800
Message-Id: <20201013040627.13932-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

v5: https://lore.kernel.org/r/20201009052421.3328-1-hsiangkao@redhat.com

Hi,

This is another approach suggested by Eric in the reply of v3
(if I understand correctly), which also attempts to use
i18n-enabled xfsprogs xfs_notice() to error out sanity check
failure suggested by Dave on IRC.

kernel side of [PATCH 2/3]
https://lore.kernel.org/r/20201013034853.28236-1-hsiangkao@redhat.com

Changes since v5:
 - rename the helper to xfs_validate_stripe_geometry() (Brian);
 - drop a new added trailing newline in xfs_sb.c (Brian);
 - add "bool silent" argument to avoid too many error messages (Brian).

Thanks,
Gao Xiang

Gao Xiang (3):
  libxfs: allow i18n to xfs printk
  xfs: introduce xfs_validate_stripe_geometry()
  mkfs: make use of xfs_validate_stripe_geometry()

 libxfs/libxfs_api_defs.h |  1 +
 libxfs/libxfs_priv.h     |  8 ++---
 libxfs/xfs_sb.c          | 70 +++++++++++++++++++++++++++++++++-------
 libxfs/xfs_sb.h          |  3 ++
 mkfs/xfs_mkfs.c          | 23 ++++---------
 5 files changed, 74 insertions(+), 31 deletions(-)

-- 
2.18.1

