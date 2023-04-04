Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DC50C6FD1D
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 08:48:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234117AbjDDIsH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 04:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234115AbjDDIsG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 04:48:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89E810D3
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 01:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680598035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=St04fATWGfIT10g6i4L0siP3WzQxgjh0uTI5uZltYvQ=;
        b=cU7zg75eMs763VHrY2sozQOKDBK8tDlpeUZ2X3nNmjv56Q4d9dv/ip83iUNDAVJgBzsVKY
        9x3THEtFPGyc733s92DrSgIC3BwPeB4ioCtlci1JK3DGIqD0PRGsQIMT02vXQ67/IkawSh
        AXE7k9yWKUe51qztDlKVGMaj2kKYpbc=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-414-aYaioYCgMrS6Cf1Z3XBajA-1; Tue, 04 Apr 2023 04:47:14 -0400
X-MC-Unique: aYaioYCgMrS6Cf1Z3XBajA-1
Received: by mail-pg1-f197.google.com with SMTP id q196-20020a632acd000000b005140cc9e00aso1022475pgq.22
        for <linux-xfs@vger.kernel.org>; Tue, 04 Apr 2023 01:47:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680598033;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=St04fATWGfIT10g6i4L0siP3WzQxgjh0uTI5uZltYvQ=;
        b=nbpwFfzG+q1xMKTN1LnrtSj65C8RxNl57zXTTHKIUiVXKSOwSLDPRbW/Crw7kgVgek
         hhpkHmKohgdiByCQFhYUntBwvpDH9qDNg7K4HBrotYzGyKEgXI/QzA1J87S9EjmqZGo9
         xT/WCCEgK+vsAwsSjp6ZscDjNK5gGi22/x/gkxyMlHLI8trWIMsDkD1GdLMLfaGkuPVW
         SV5PnKEExJ9QfrJ5JDlaMyQlkXiG4oMB3fBUUiOy7R82p2Ga1RaSxkHSaAArSjpjGDg/
         PxaIXY9FXGfhscSaTfQJQEonl3DuWlf2Z5XVbIUl92wR5HAT0mLO+mpE529Gx+RRRXaC
         N53Q==
X-Gm-Message-State: AAQBX9cDUnAbwfTmsyZqQhok9uf/pajPU19HNIRllWS/W0/vLV0QaOEO
        Voudw2oUu84Mt/z2k1yY6QXYCuoPnqUlXHRxIWkts4dWJ0Oa82dx/7bFXmH0cTkJL/Z9t78YCMZ
        QtOEyzmG9E9AHxUd+3ghZ
X-Received: by 2002:a17:90b:3b48:b0:23d:29c7:916f with SMTP id ot8-20020a17090b3b4800b0023d29c7916fmr1944930pjb.32.1680598033474;
        Tue, 04 Apr 2023 01:47:13 -0700 (PDT)
X-Google-Smtp-Source: AKy350bJxkPLNVMHl66unDdw9/W27jgaZhktSUj9RGv0cbVeSHmAFsbM+C5lpa1lJz5XglkZhaNqRg==
X-Received: by 2002:a17:90b:3b48:b0:23d:29c7:916f with SMTP id ot8-20020a17090b3b4800b0023d29c7916fmr1944909pjb.32.1680598033010;
        Tue, 04 Apr 2023 01:47:13 -0700 (PDT)
Received: from zeus.flets-east.jp ([240b:10:83a2:bd00:6e35:f2f5:2e21:ae3a])
        by smtp.gmail.com with ESMTPSA id e5-20020a17090ada0500b00234e6d2de3dsm7352937pjv.11.2023.04.04.01.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 01:47:12 -0700 (PDT)
From:   Ryosuke Yasuoka <ryasuoka@redhat.com>
To:     djwong@kernel.org
Cc:     Ryosuke Yasuoka <ryasuoka@redhat.com>, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] xfs: Use for_each_perag() to iterate all available AGs
Date:   Tue,  4 Apr 2023 17:47:01 +0900
Message-Id: <20230404084701.2791683-1-ryasuoka@redhat.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

for_each_perag_wrap() doesn't expect 0 as 2nd arg.
To iterate all the available AGs, just use for_each_perag() instead.

Signed-off-by: Ryosuke Yasuoka <ryasuoka@redhat.com>
---
 fs/xfs/xfs_filestream.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 22c13933c8f8..48f43c340c58 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -151,7 +151,7 @@ xfs_filestream_pick_ag(
 		 * grab.
 		 */
 		if (!max_pag) {
-			for_each_perag_wrap(args->mp, 0, start_agno, args->pag)
+			for_each_perag(args->mp, start_agno, args->pag)
 				break;
 			atomic_inc(&args->pag->pagf_fstrms);
 			*longest = 0;
-- 
2.39.2

