Return-Path: <SRS0=udUw=ZN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 145B7C432C0
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 21:45:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAF9E206DA
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 21:45:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TSAYZoXv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfKUVpA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Nov 2019 16:45:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44226 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726510AbfKUVpA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Nov 2019 16:45:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574372698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Dcled5vv0jbenLXJZ7ZHpvL9X3Op22bgS+CkzU7YVE=;
        b=TSAYZoXvvpBzVVqmdfH0YfSF+B8M30Ndi2e5qfjaaHKkzHBiEdTspCSdWVsmRd2u8s3abM
        Cx5s8QSvrS4Xny+tRMcMubO4imLu2eVfwxFH0/xyOsAoQOgFp0KpTOkZzsRMQLKgbwFxWZ
        LXnPdx22Bo9+4+CQrEEACsHM1XZLNSc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-5ggzTw11PWGax182tD6qWw-1; Thu, 21 Nov 2019 16:44:57 -0500
Received: by mail-wr1-f72.google.com with SMTP id y3so2766942wrm.12
        for <linux-xfs@vger.kernel.org>; Thu, 21 Nov 2019 13:44:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8B4WQ5dIsKQ15jvgefYFrIbVkyTEQI1V2JYjtC54j0M=;
        b=S0aNXZTioFW4EPkothlAb3q+fcyU5jHRqExJlq/C894ch0HFzoU07dMeBh+wQu/O0k
         n5MQyO8eEw9Cf9ScA3TtuGDCPre/BGTcRR/fhbrDFrlFaY3bIRHST83cQQvO2W+JgKtV
         oxIslazlmba7THpqkSW4bTB1b2AQQqkbE7YIKZ/CW1+b0Eo1BeJEAWVlPmtlW3bVo/pX
         U3aCSkq3/8v6tAgBH/objRhfKw24YDIXs1bn+5MZtIcX4QEXr3qJHzKLl1VZO1mzWYaZ
         VdTmDO6I73jp17MCMY0CQ4576GqZ5Cwe+VWuv7ZstOk8zrLw2v1jc8PnJsz0Aw4Yhlu6
         1M/g==
X-Gm-Message-State: APjAAAUm/Q8Teh1R9wVzuu0Sxt8yMTFBKJuMPAfH/GV0uz0V6lZfa21g
        5NqktK6qmFHBphw5Y5gWPOS4+7hn8NnNZG4QgVCMj50mHHTGVsd5aW8kmQGAitL1c8P2FcrPjb+
        Ygc0CzxXHAh6mrehc8lVu
X-Received: by 2002:adf:edc5:: with SMTP id v5mr13692185wro.322.1574372696309;
        Thu, 21 Nov 2019 13:44:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqz36/K6XqBuFKySR0XQXwibyFtZndKqVOuknyqYzcww+QmGQGCI8IEd3G6ehaD2SVufNnaWnA==
X-Received: by 2002:adf:edc5:: with SMTP id v5mr13692166wro.322.1574372696113;
        Thu, 21 Nov 2019 13:44:56 -0800 (PST)
Received: from preichl.redhat.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id d18sm5093617wrm.85.2019.11.21.13.44.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 13:44:55 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>
Subject: [PATCH 2/2] mkfs: Show progress during block discard
Date:   Thu, 21 Nov 2019 22:44:45 +0100
Message-Id: <20191121214445.282160-3-preichl@redhat.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191121214445.282160-1-preichl@redhat.com>
References: <20191121214445.282160-1-preichl@redhat.com>
MIME-Version: 1.0
X-MC-Unique: 5ggzTw11PWGax182tD6qWw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
 mkfs/xfs_mkfs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index a02d6f66..07b8bd78 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1248,6 +1248,7 @@ discard_blocks(dev_t dev, uint64_t nsectors)
 =09const uint64_t=09step=09=09=3D (uint64_t)2<<30;
 =09/* Sector size is 512 bytes */
 =09const uint64_t=09count=09=09=3D nsectors << 9;
+=09uint64_t=09prev_done=09=3D (uint64_t) ~0;
=20
 =09fd =3D libxfs_device_to_fd(dev);
 =09if (fd <=3D 0)
@@ -1255,6 +1256,7 @@ discard_blocks(dev_t dev, uint64_t nsectors)
=20
 =09while (offset < count) {
 =09=09uint64_t=09tmp_step =3D step;
+=09=09uint64_t=09done =3D offset * 100 / count;
=20
 =09=09if ((offset + step) > count)
 =09=09=09tmp_step =3D count - offset;
@@ -1268,7 +1270,13 @@ discard_blocks(dev_t dev, uint64_t nsectors)
 =09=09=09return;
=20
 =09=09offset +=3D tmp_step;
+
+=09=09if (prev_done !=3D done) {
+=09=09=09prev_done =3D done;
+=09=09=09fprintf(stderr, _("Discarding: %2lu%% done\n"), done);
+=09=09}
 =09}
+=09fprintf(stderr, _("Discarding is done.\n"));
 }
=20
 static __attribute__((noreturn)) void
--=20
2.23.0

