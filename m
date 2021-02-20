Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C1D3C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Feb 2021 22:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 664F764E38
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Feb 2021 22:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbhBTWRU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 Feb 2021 17:17:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40210 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229675AbhBTWRU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Feb 2021 17:17:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613859354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Fa9mh455BpvRTXtT5bs9qI5kLRr38ZtxN4SDhPrz10Q=;
        b=KoGg3wqaf98TXwyhdwY7qV6EdU5qyawxkWrPuJ75OCKB/kbrAtbtDbEir7pbWFGr3gFwF/
        F1u2y1e2l6UHW8+IyfdVVp5L8a2CxaXbpmlBYprxWilrOSZyiD9IL24UdkJgQrR7Q1wEMD
        Y1TDINvjobxHPFZuHpBeuNL8mrqnrg8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-k8JoR9QBMLyXEg3G9e0U7Q-1; Sat, 20 Feb 2021 17:15:52 -0500
X-MC-Unique: k8JoR9QBMLyXEg3G9e0U7Q-1
Received: by mail-ed1-f72.google.com with SMTP id j10so4897431edv.5
        for <linux-xfs@vger.kernel.org>; Sat, 20 Feb 2021 14:15:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fa9mh455BpvRTXtT5bs9qI5kLRr38ZtxN4SDhPrz10Q=;
        b=sz+BQr6DyzHLNuevd3qOm4t2dxN0yc9Mc19Ac+2g3km5X6p+Nqa9ftbgjQ2xg8PAY/
         +xkNL7QGNhw4DgUueWPqyaJXMBvdLq70KBtEB/4gNs2CNAbRXcE/QcYQSOI6dWtFBben
         gIjUOz0jNE/mtMtGPaHBUXFLcaaLYjdn+1u6XcEITHsimF3ijzfMI3rSPyWZdkya0Vdg
         99PuXo3f6q91URM2GJXKTQQ8AwqDLAVZaOcXTBPXz/OJCFEnCehP0XWIrlDXpxJAoYVV
         YZD1dGcQyyu/PIEauVAvvuzBiFXcqgsSQI9mgNtRZk4lcMKaj45K9hW4XcthyGCM6f6t
         g06Q==
X-Gm-Message-State: AOAM5338dyG3xhgWSVdtEeN8kZply9iUxQcf9UHOddR5JoT6jl+3gJjH
        cH8/iWIubuiH2Fwb5sIX/1/ByQN8vbqmZfc1WGRl0xUqVM1AKk9z5oxdtwSV2UFeZDM3gM9VIrP
        9TlgrUTnYe+jfUDiqbJ6UqJyVWHaV8yEu0CoZj1h7jH168xEZECwtj2lw8OPPLTnOITIPgBk=
X-Received: by 2002:a05:6402:3508:: with SMTP id b8mr15621808edd.341.1613859350771;
        Sat, 20 Feb 2021 14:15:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxfhl2TmuI+xrH4+k3nSHTkgIz72daAssr+kMDf5Fk7/66bFcKcqhN80bnFfAvCyAKAUnMYpw==
X-Received: by 2002:a05:6402:3508:: with SMTP id b8mr15621798edd.341.1613859350531;
        Sat, 20 Feb 2021 14:15:50 -0800 (PST)
Received: from localhost.localdomain.com ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id k6sm7020286ejb.84.2021.02.20.14.15.50
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Feb 2021 14:15:50 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: xfs: Skip repetitive warnings about mount options
Date:   Sat, 20 Feb 2021 23:15:47 +0100
Message-Id: <20210220221549.290538-1-preichl@redhat.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

At least some version of mount will look in /proc/mounts and send in all of the 
options that it finds as part of a remount command. We also /do/ still emit
"attr2" in /proc/mounts (as we probably should), so remount passes that back
in, and we emit a warning, which is not great.

In other words mount passes in "attr2" and the kernel emits a deprecation
warning for attr2, even though the user/admin never explicitly asked for the
option.

So, lets skip the warning if (we are remounting && deprecated option
state is not changing).

I also attached test for xfstests that I used for testing (the test
will be proposed on xfstests-list after/if this patch is merged).


Pavel Reichl (1):
  xfs: Skip repetitive warnings about mount options

 fs/xfs/xfs_super.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

-- 
2.29.2

