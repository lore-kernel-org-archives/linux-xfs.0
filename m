Return-Path: <SRS0=2WGG=DC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41270C4363D
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Sep 2020 16:50:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA32821D42
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Sep 2020 16:50:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DekvqWto"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728966AbgIYQuM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Sep 2020 12:50:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35586 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727982AbgIYQuM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Sep 2020 12:50:12 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601052610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Nw4l6IK5VFLqM3qIMUC8q4a6ydaEPuf4LxOdOwGOGXw=;
        b=DekvqWtockg07hd1aF05mWMnQf0QueKwFKmY/VDVnmp3Ye95gzuQKaGTvk81jzjTonfMN6
        DKBrS3Z/ssEz+/2ULS4HUcruBpeGXr6cGBYelB+xf8q5+qHwoGzIb2HMxjp8vYXJSeRUR0
        iMwmxpBy6HJkKcrHlR9Wwg1eXrFjqwI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-Vrh2E5J8Oym5Arh6K6ggMA-1; Fri, 25 Sep 2020 12:50:08 -0400
X-MC-Unique: Vrh2E5J8Oym5Arh6K6ggMA-1
Received: by mail-wm1-f70.google.com with SMTP id a25so1041110wmb.2
        for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2020 09:50:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Nw4l6IK5VFLqM3qIMUC8q4a6ydaEPuf4LxOdOwGOGXw=;
        b=N3qpNopKwetEhGvA5KYOi+B12hcheeH6dytZdTY7P8ctzIffyGXkiK9CrOoYpbBdFJ
         6QfldY3x1DeeMrTMd3/tIIBSXNi+/YC75PTBgVW2vxQlWf3jMMOtGJNDfrBppWj7PTz6
         AskM32jaPstAZ1tDJpck+peodsVUtfe/X+EIpbF4CMrQsBxtbO8xc1X36vnOaXPekbAq
         HDdQp/f0qi6G6UR3OaEnPrZ3yYBOoloSJ3YyX7anZjyCIjPSZHwRPBa4tspW0b51Br/v
         RXoO2vcV0wt+ypCgf1WCTonNERd3vmX0pjdjF2lrqo3lcYKHgI3nVlM7IIR88sd0QgUQ
         LfXQ==
X-Gm-Message-State: AOAM5329LjgorIcEX6RRaPd5R+qt3h3U6NJ2kGynXqhsnm7vvXT7NAYC
        CI+PvrJ3z1AmNctbVwJ28CbVEh38lF4Pj9XyNXju3pHxqPS3tw7fi3uRLN8wJqW/6Jx8uyzrF1N
        7pcCg3kw75KRWBuc1uuQ3
X-Received: by 2002:a1c:480a:: with SMTP id v10mr3900423wma.141.1601052607103;
        Fri, 25 Sep 2020 09:50:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyW4Es4yB6eBSPae1HBgxWCRHDWuuQnQYJjdxZ2bXWTRAMeRL5T4FnGvNKPJgb6ISbEy85Pnw==
X-Received: by 2002:a1c:480a:: with SMTP id v10mr3900408wma.141.1601052606865;
        Fri, 25 Sep 2020 09:50:06 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id b64sm3181578wmh.13.2020.09.25.09.50.05
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 09:50:06 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 0/2]
Date:   Fri, 25 Sep 2020 18:50:03 +0200
Message-Id: <20200925165005.48903-1-preichl@redhat.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

 xfs: remove deprecated mount and sysctl options

Hi,

by Eric and Dave's suggestion I prepared a patchset which adds warnings about
using deprecated options. I tried to justify the changes in commit
messages based on the info from Eric and Dave.

If this patchsed should be merged I need to know when the options are
actually eliminated, so documentation can be properly updated.

Thanks.

V2 update:
Added comment to mount options that are being deprecated
Added Sep 2020 to documentation as a planned date of removal

Pavel Reichl (2):
  xfs: remove deprecated mount options
  xfs: remove deprecated sysctl options

 Documentation/admin-guide/xfs.rst |  5 ++++-
 fs/xfs/xfs_super.c                | 31 +++++++++++++++-----------
 fs/xfs/xfs_sysctl.c               | 36 +++++++++++++++++++++++++++++--
 3 files changed, 56 insertions(+), 16 deletions(-)

-- 
2.26.2

