Return-Path: <SRS0=cWrc=DB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C499C4363D
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 17:07:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5056238A1
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 17:07:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HW4/ouq0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728539AbgIXRHy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 13:07:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22756 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728352AbgIXRHy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Sep 2020 13:07:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600967272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vEpGIKvGSrPd5fmr86kpXsGNXGtPJdUXwPWVZxt6ueU=;
        b=HW4/ouq0k2BdiBn8VMnGNCT8TR8wl2AOPhYhpiCkYaaYEe/1jwOqa8qEU7RR/ekg99W9U7
        BCaMxSAsoLqWIcvtKoEGQo2ZNk2rDxK53+ZLOR3X5M0DEWdKmDCJNuXlfUHi1BSBHFPh8p
        S90RWH3u848VHfA13jvRR6VFh2zQF0c=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-MBcvxCHBNu-Z4FNt7ExZXA-1; Thu, 24 Sep 2020 13:07:50 -0400
X-MC-Unique: MBcvxCHBNu-Z4FNt7ExZXA-1
Received: by mail-wr1-f70.google.com with SMTP id v5so1470159wrs.17
        for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2020 10:07:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vEpGIKvGSrPd5fmr86kpXsGNXGtPJdUXwPWVZxt6ueU=;
        b=nuqj4Rj3Peo5ZSGXpSB6NG09ExrWGRCvPUT+mZuK0WXornt7LxmA4wjxNTRpZJTMko
         m71n1s3yCr/M9zto2+W89nl3ZlvjVCSAW5KJBq2WmuP1sXiVM0cqqThiU5SaJRKlmuUS
         TYCnrwffiVnYstDpZYWOEe9xPH42BwYXFM7G04rioluJrwliHISktKnrL8jv+KltVKSd
         9HQ+1qWeySyYR3k3XtX4I6gJ3tcyVZTQSz/F/SkggUVWSMBD7rDOosZTaCC7d1B4piBW
         5kpfTdMQK1cdTrvIrh0hos4/TBhclkIerKdKR7oC47pmDx1ZP8GwzbSKim16/mmelgBb
         iFbg==
X-Gm-Message-State: AOAM531b+/dx/RNCpMjUae3OTXcdKiYaYyy64+iZX2ON2C43Pp+zP58c
        ia4edLs53heqCjpb5eMQmThz8NnMRPXeYPv5GApwmw/EWEx1FBx+oJkb3+w5Qw3qkUa1NFSv9pq
        IMg7nDcVR/ERnaHcLZsuV
X-Received: by 2002:a1c:a593:: with SMTP id o141mr184157wme.88.1600967268878;
        Thu, 24 Sep 2020 10:07:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwTlemz1F+inEgrbIERwVmOFBcbMP7E7dV6ySggiSokYN8gDSqEsCMhqzN/oHNyiagglLKCPw==
X-Received: by 2002:a1c:a593:: with SMTP id o141mr184140wme.88.1600967268719;
        Thu, 24 Sep 2020 10:07:48 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id k8sm103838wma.16.2020.09.24.10.07.47
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 10:07:48 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/2] xfs: remove deprecated mount and sysctl options
Date:   Thu, 24 Sep 2020 19:07:45 +0200
Message-Id: <20200924170747.65876-1-preichl@redhat.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

by Eric and Dave's suggestion I prepared a patchset which adds warnings about
using deprecated options. I tried to justify the changes in commit
messages based on the info from Eric and Dave.

If this patchsed should be merged I need to know when the options are
actually eliminated, so documentation can be properly updated.

Thanks.

Pavel Reichl (2):
  xfs: remove deprecated mount options
  xfs: remove deprecated sysctl options

 Documentation/admin-guide/xfs.rst |  5 ++++-
 fs/xfs/xfs_super.c                | 30 +++++++++++++++-----------
 fs/xfs/xfs_sysctl.c               | 36 +++++++++++++++++++++++++++++--
 3 files changed, 55 insertions(+), 16 deletions(-)

-- 
2.26.2

