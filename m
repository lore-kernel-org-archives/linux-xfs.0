Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40E24C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 22:05:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242004AbiEXWFS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 18:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238937AbiEXWFR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 18:05:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9FDF66620D
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 15:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653429915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=8MIGzLwexKojFX3P1mgWXPz8RakhqdPoScOXHuspqFk=;
        b=QYUAM24AO5DW8/p+iEeIp+JWkQwQoELO4bOyePrulM9JE13hOU+DYzm6A3uGZfnjH9BdGM
        KuFb6I7Jvki5jlA9WBMCA2FWnY6JAEUKqUDJmDgaclI2ZywubFFzaj+j4MQNhFlMaDR4A6
        HnSsLC/m25AJycY9UdrM/TimfBwoIeU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-wLqRxSByM4C1Gm99mYGK9A-1; Tue, 24 May 2022 18:05:14 -0400
X-MC-Unique: wLqRxSByM4C1Gm99mYGK9A-1
Received: by mail-wm1-f70.google.com with SMTP id u12-20020a05600c19cc00b0038ec265155fso8784wmq.6
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 15:05:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8MIGzLwexKojFX3P1mgWXPz8RakhqdPoScOXHuspqFk=;
        b=mCSvOJowM+1REGs1CXcdHrScME032dUE3tVnK5RvSaTmTt/SNpl5qiDC6C1gwB0iiG
         I3gYdmQfnFVHtBEZVqXKIHjTbNjOP8M9cywg+SXN5KM1nFeohsgvbSzmTnxXWhufLKLP
         5PtBXgaMHq22Lh+N2uSDPuyH9XC1on0kOkKwgNWYCIF//49deLYI3GLGFXHSjaKYD1JA
         OwZJmD9NeUGZfEEAdGf1HjkpJjktAG6j+DsH7iUUmvRfe1/EevAvDP0R5+V+dG/aJR3Z
         Sb9CBhPuISWinAL6R3/LIt1cT0EfiCPZJPdQ58uqMZHq926ne7mbfCLzT9M5V73N6ZIO
         vfEQ==
X-Gm-Message-State: AOAM533hZhPVBpQ0PcNMnPK82ej6iQ0aIXfdaOD/69tzKKwiVDHRyGah
        BftcA8khRcjbTTgxaEYlPmGuSOLvptqergxctpM5JycDzmyMV7oGRirFXFWHnT/zw68gB+CKWRv
        Wqy12jwtlelGPUuDuumSMwEP2iIwhVIqn8QJNwia4X/Z716lJ+YO7S7cl+9cGISgBvzvWY9A=
X-Received: by 2002:a05:6000:1867:b0:20f:ca21:7813 with SMTP id d7-20020a056000186700b0020fca217813mr15027467wri.100.1653429912732;
        Tue, 24 May 2022 15:05:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwzYGT0BnGUithIa5qUu97vJSjXVEC08eMJs3tS8cUz02I9DW9xZs4lFFuZBvf4Pb7M4B1Atg==
X-Received: by 2002:a05:6000:1867:b0:20f:ca21:7813 with SMTP id d7-20020a056000186700b0020fca217813mr15027450wri.100.1653429912501;
        Tue, 24 May 2022 15:05:12 -0700 (PDT)
Received: from localhost.localdomain.com (gw19-pha-stl-mmo-1.avonet.cz. [131.117.213.203])
        by smtp.gmail.com with ESMTPSA id c4-20020adfc6c4000000b0020e5d2a9d0bsm579885wrh.54.2022.05.24.15.05.11
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 15:05:11 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 0/1] mkfs: Fix memory leark
Date:   Wed, 25 May 2022 00:05:08 +0200
Message-Id: <20220524220509.967287-1-preichl@redhat.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

V2:
- Fixed typo s/strup/strdup/
- Added Reviewed-by tag 

Pavel Reichl (1):
  mkfs: Fix memory leak

 mkfs/xfs_mkfs.c | 1 +
 1 file changed, 1 insertion(+)

-- 
2.36.1

