Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DF38C7EE25
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Jun 2023 09:14:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbjFHJOM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Jun 2023 05:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235231AbjFHJOJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Jun 2023 05:14:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AEDB1BF0
        for <linux-xfs@vger.kernel.org>; Thu,  8 Jun 2023 02:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686215606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6aN0GmGnT+fMX15infTJY8ax5IsUI++ED9xZdCbNSnw=;
        b=ISz6+qPGT20QrgrBk3vEqjYLMA2T1m+BGJKZz+Tg61IVNxs62cLUnzxVulNE0TD88H2Lnt
        kY+JIAOuVQAHw6zSt4N2IglCBVk/PANrXa5gJ+d566+gQKKD1fHsRKpJlm/+3l9mYNIv3h
        foCvKPxP4Ys6b6pKVIjK6V5cmZpi3uw=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-637-KhUludUMOxiU5mitw42yew-1; Thu, 08 Jun 2023 05:13:24 -0400
X-MC-Unique: KhUludUMOxiU5mitw42yew-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-75d42a5097bso43897285a.3
        for <linux-xfs@vger.kernel.org>; Thu, 08 Jun 2023 02:13:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686215603; x=1688807603;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6aN0GmGnT+fMX15infTJY8ax5IsUI++ED9xZdCbNSnw=;
        b=TOnLehcf9Gcf9e5MkvyHjAqfRqBGG5XX4vxN/fVd2ifj1VxRctxMeS9gUl7twoFPVx
         Bb6cjBwQgmFqmeL8Ob+CM/D9AjecliY5cP07xOgb6z1aQgQaoypMmfGJeb+Y/PD7guDv
         Q7iNHagkRv2YSUs+Iy4RbMgpMX2VzL/021b4mCnlmn44Yk1T9AMkMtv6RTGgYvO0JF7f
         2P+qcEXynbnWZYlZoTvCHI7Vq58AT7iQRwrJzxQcYHsnPmaiD/T2NylkHi24iD6vs1nu
         yIheHH/jAOPTWKgN2qVq9jl+jmuziiJnZ1x8FEdS4kcidc24qzKOonBJUXCsWpPrQ2Vg
         W73w==
X-Gm-Message-State: AC+VfDyUxmaj8b6vQGptvzQ361mcPbfIbbT8RvVhYoOSmN4Cxfj+BPIt
        LfIqb2cmDUk5yfVoHAx9Upkf3iRMu9TxMH/4NPJX1M0TIvDsHeQfCYUN/mMHZRUXWtuDGqxNpTt
        5392AEQyWNpQ2Tcy3bDJIsndbpAuwCRsBIL66DngQlyTK9ABH6F9TyQinNipU9+x0UNoV9FdwGZ
        rQ400=
X-Received: by 2002:a05:620a:3e81:b0:75b:23a1:830d with SMTP id tv1-20020a05620a3e8100b0075b23a1830dmr4226954qkn.8.1686215603387;
        Thu, 08 Jun 2023 02:13:23 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4BsWY2UYZ/jUbaTnhjncjkb+jbwOYrYBQ+MBSnqzFHNRF7mrsoi0x8JUPQn4E4wdJUInl95w==
X-Received: by 2002:a05:620a:3e81:b0:75b:23a1:830d with SMTP id tv1-20020a05620a3e8100b0075b23a1830dmr4226940qkn.8.1686215603071;
        Thu, 08 Jun 2023 02:13:23 -0700 (PDT)
Received: from fedora.redhat.com (gw19-pha-stl-mmo-2.avonet.cz. [131.117.213.218])
        by smtp.gmail.com with ESMTPSA id p21-20020a05620a15f500b0075bcc5ab975sm193440qkm.92.2023.06.08.02.13.21
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 02:13:22 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] mkfs: fix man's default value for sparse option
Date:   Thu,  8 Jun 2023 11:13:20 +0200
Message-Id: <20230608091320.113513-1-preichl@redhat.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Fixes: 9cf846b51 ("mkfs: enable sparse inodes by default")
Suggested-by: Lukas Herbolt <lukas@herbolt.com>
Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
 man/man8/mkfs.xfs.8.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index 49e64d47a..48e26ece7 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -631,7 +631,7 @@ Enable sparse inode chunk allocation. The
 .I value
 is either 0 or 1, with 1 signifying that sparse allocation is enabled.
 If the value is omitted, 1 is assumed. Sparse inode allocation is
-disabled by default. This feature is only available for filesystems
+enabled by default. This feature is only available for filesystems
 formatted with
 .B \-m crc=1.
 .IP
-- 
2.40.1

