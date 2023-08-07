Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4502CEB64DD
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Aug 2023 04:56:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjHGE4T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Aug 2023 00:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjHGE4S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Aug 2023 00:56:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE0710FA
        for <linux-xfs@vger.kernel.org>; Sun,  6 Aug 2023 21:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691384122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ek4HyecNtF21r8WoqML0fISqBigNNEAEqcPdSPOlaK8=;
        b=giVgra1yeWgnmqouFpz1+/PJ7KVqTL8CS2yhEMpzWbBOSQrvrI/nm3lM+xuhNHHkob65n8
        hsficQycsCZfoILABMeHeQRBnCEN4RV79NYv6FTxBN9n9dXNeOwmbQQ65NiESDiLiHkeBT
        wxpJedGkuKgPQCrqn7DxYq88bShFmsE=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-47-bxy_rBYLOk6_COyP0Nx03Q-1; Mon, 07 Aug 2023 00:55:20 -0400
X-MC-Unique: bxy_rBYLOk6_COyP0Nx03Q-1
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-58960b53007so848917b3.3
        for <linux-xfs@vger.kernel.org>; Sun, 06 Aug 2023 21:55:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691384119; x=1691988919;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ek4HyecNtF21r8WoqML0fISqBigNNEAEqcPdSPOlaK8=;
        b=ZPgUYKTyEgZpZXhZ+0n5dlwC5dSzbvjX0ZYlG/+zimfJ4X8RqE+Ea2ezvk3Qigq/dT
         eSdnLTBI77bZ1wojWWUvvOZvkPXI9d3qBbYWQgvLKODK9XKqOM37Gc+F/kLrqtU+aZA3
         HCzwKJT1GCJSebKdl85FJdE8Xzd25jKt+OJ9Qh++DnySayC6MAsSugdwkoKCMmZhAUiB
         vt682+LstxXTgWjac40QREyjPIKeq6ru9cqRd9MBSQvLDhOs8Y8AHw8Va/UlYUbpI21s
         Vljep97hLY2eTg22aBRyPm+tq23omk8ApdDBUf4pRJxp+mZL4tiZ/T/mvv3QR5GszoH6
         KOGg==
X-Gm-Message-State: AOJu0YzZwcZVMR+cnRcIPsMPp2WsHSSXIPmBvw3HkRt+yGlXYgtxj6zG
        Jc65zNniLG4HWOuZhBFSBk1TLaOGFBJh2TtEwKFUyH+IJbHn4zKhS3mQ8oIn9kqE+2DUASHXyFe
        KHTQZsMXHI1ejd3FOtIKvWh64hbWXojbMzSANH/RKHEgNNo0OcYOfiXRUVAqMBlS+NjdHqXSEmW
        ak3KtJ
X-Received: by 2002:a0d:ff06:0:b0:576:bfc7:1e43 with SMTP id p6-20020a0dff06000000b00576bfc71e43mr8662992ywf.25.1691384119621;
        Sun, 06 Aug 2023 21:55:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGm6JmQvd+wexBoRh2LpK5cb5rW62RcO7c+QDiUGYmwchDWr8+IyjZWI4PyrDzACIxQWnuEGw==
X-Received: by 2002:a0d:ff06:0:b0:576:bfc7:1e43 with SMTP id p6-20020a0dff06000000b00576bfc71e43mr8662981ywf.25.1691384119316;
        Sun, 06 Aug 2023 21:55:19 -0700 (PDT)
Received: from anathem.redhat.com ([2001:8003:4b08:fb00:e45d:9492:62e8:873c])
        by smtp.gmail.com with ESMTPSA id w20-20020a17090a461400b00263dee538b1sm5060610pjg.25.2023.08.06.21.55.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Aug 2023 21:55:18 -0700 (PDT)
From:   Donald Douwsma <ddouwsma@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH v2] xfsrestore: suggest -x rather than assert for false roots
Date:   Mon,  7 Aug 2023 14:53:57 +1000
Message-Id: <20230807045357.360114-1-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.39.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If we're going to have a fix for false root problems its a good idea to
let people know that there's a way to recover, error out with a useful
message that mentions the `-x` option rather than just assert.

Before

  xfsrestore: searching media for directory dump
  xfsrestore: reading directories
  xfsrestore: tree.c:757: tree_begindir: Assertion `ino != persp->p_rootino || hardh == persp->p_rooth' failed.
  Aborted

After

  xfsrestore: ERROR: tree.c:791: tree_begindir: Assertion `ino != persp->p_rootino || hardh == persp->p_rooth` failed.
  xfsrestore: ERROR: False root detected. Recovery may be possible using the `-x` option
  Aborted

Fixes: d7cba7410710 ("xfsrestore: fix rootdir due to xfsdump bulkstat misuse")
Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>

---
Changes for v2
- Use xfsprogs style for conditional
- Remove trailing white-space
- Place printf format all on one line for grepability
- use __func__ instead of gcc specific __FUNCTION__
---
 restore/tree.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/restore/tree.c b/restore/tree.c
index bfa07fe..e959aa1 100644
--- a/restore/tree.c
+++ b/restore/tree.c
@@ -783,8 +783,15 @@ tree_begindir(filehdr_t *fhdrp, dah_t *dahp)
 	/* lookup head of hardlink list
 	 */
 	hardh = link_hardh(ino, gen);
-	if (need_fixrootdir == BOOL_FALSE)
-		assert(ino != persp->p_rootino || hardh == persp->p_rooth);
+	if (need_fixrootdir == BOOL_FALSE &&
+		!(ino != persp->p_rootino || hardh == persp->p_rooth)) {
+		mlog(MLOG_ERROR | MLOG_TREE,
+"%s:%d: %s: Assertion `ino != persp->p_rootino || hardh == persp->p_rooth` failed.\n",
+			__FILE__, __LINE__, __func__);
+		mlog(MLOG_ERROR | MLOG_TREE, _(
+"False root detected. Recovery may be possible using the `-x` option\n"));
+		return NH_NULL;
+	}
 
 	/* already present
 	 */
-- 
2.39.3

