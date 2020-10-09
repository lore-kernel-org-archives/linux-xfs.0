Return-Path: <SRS0=Vfs/=DQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2717CC433DF
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 05:25:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF7BB21D6C
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 05:25:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MbAh1XTZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731145AbgJIFZK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Oct 2020 01:25:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58565 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730449AbgJIFZJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Oct 2020 01:25:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602221108;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=gLtcLw0YQfOo8g3N3cmSIIFlE0Dos6J+vQK3NlRsrzk=;
        b=MbAh1XTZ/Xia8CPY5GEcqj4EQcbKGCqhgHor+71MKFBuD3cCzCyRHOiQlTyreFySaFn7G4
        FNA0VIaMJFC859zUi5Vohfk9M5uFmslPZx1g//XQNcalvlQxxXJkqk2rId1qkpB0+q12NQ
        ZrUeiaOj3xUcehzneGT/BxHQmCJEiJg=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-fHlcZtNSNxOtE1S_QONGcg-1; Fri, 09 Oct 2020 01:25:04 -0400
X-MC-Unique: fHlcZtNSNxOtE1S_QONGcg-1
Received: by mail-pg1-f199.google.com with SMTP id c26so5733616pgl.9
        for <linux-xfs@vger.kernel.org>; Thu, 08 Oct 2020 22:25:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=gLtcLw0YQfOo8g3N3cmSIIFlE0Dos6J+vQK3NlRsrzk=;
        b=gEtorf/Hd6ULhVBuQgWbBHKOImeDjU6eRYruu5ei1VY/d9D/haVkUUXkHKWJWV6ppI
         0TmbnvR/TcC9LOiqCeE8A+J6R01QywbTHf24DNP4wNkoue7pRybhhJmAaoIfe8495VHc
         zsuZIo37X6vI1aIZk4RXK7fQhB5ZvB8iHlYTvg0GsyUfc4kOWfYXgsko8EY3vyQYhT0E
         RbXHWlZEn2Nw+Q9QZFqu3mVu36gbHWhL0sofWAjPUlxbq3h0Sx52j0QTYyrA0771J5RF
         +FDBQ8ErfGcQipfyM+f+IYPxamGJWByq6lp51uN1KvRmkewYd8/h64zu5f3OvoPcpi/K
         BURA==
X-Gm-Message-State: AOAM533mm1SeA02MJZryMD3uoyEleiP6CAubLmZeTk5px/sgBoKEUTyR
        66Op4xr1x2Sx6IYBYuofoUOlhTFOjMN3YOeYsnb4TPii39STr7ZTTlBg0njFHo+NCeSEvhIgBg3
        h2lcNEMn1ddjWhp6g1DyB
X-Received: by 2002:a63:454f:: with SMTP id u15mr2100914pgk.198.1602221103106;
        Thu, 08 Oct 2020 22:25:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJychGb8ouGg1vkoga3BWIulIQl7f2DAIUQIlW83mumHgLctg5LqMFpRNoUcB5+gdOyX8yoMxw==
X-Received: by 2002:a63:454f:: with SMTP id u15mr2100901pgk.198.1602221102862;
        Thu, 08 Oct 2020 22:25:02 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p12sm9254042pgm.29.2020.10.08.22.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 22:25:02 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v5 0/3] xfsprogs: consolidate stripe validation
Date:   Fri,  9 Oct 2020 13:24:18 +0800
Message-Id: <20201009052421.3328-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

v4: https://lore.kernel.org/r/20201007140402.14295-1-hsiangkao@aol.com

Hi,

This is another approach suggested by Eric in the reply of v3
(if I understand correctly), which also attempts to use
i18n-enabled xfsprogs xfs_notice() to error out sanity check
failure suggested by Dave on IRC.

kernel side of [PATCH 2/3]
https://lore.kernel.org/r/20201009050546.32174-1-hsiangkao@redhat.com

Thanks,
Gao Xiang

Changes since v4:
 - [2/3] stretch columns for commit message (Darrick);
 - [2/3] add a comment to hasdalign check (Darrick);
 - [2/3] break old sunit / swidth != 0 check into two
         seperate checks (Darrick);
 - [2/3] update an error message description (Darrick);
 - [2/3] use bytes for sunit / swidth representation,
         so users can see values in the unique unit.
 - [3/3] introduce a userspace wrapper
         libxfs_validate_stripe_factors (Darrick).

Gao Xiang (3):
  libxfs: allow i18n to xfs printk
  xfs: introduce xfs_validate_stripe_factors()
  mkfs: make use of xfs_validate_stripe_factors()

 libxfs/libxfs_api_defs.h |  1 +
 libxfs/libxfs_priv.h     |  8 ++---
 libxfs/xfs_sb.c          | 65 +++++++++++++++++++++++++++++++++-------
 libxfs/xfs_sb.h          |  3 ++
 mkfs/xfs_mkfs.c          | 23 +++++---------
 5 files changed, 69 insertions(+), 31 deletions(-)

-- 
2.18.1

