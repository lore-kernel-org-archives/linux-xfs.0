Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B1ECC27C40
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Aug 2023 02:08:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239236AbjHXCIM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Aug 2023 22:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239242AbjHXCII (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Aug 2023 22:08:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9688E77
        for <linux-xfs@vger.kernel.org>; Wed, 23 Aug 2023 19:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692842838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Q4PQUc9NsE1MHqNTFf/oivcR7M3aHs8G4oAr6UVJeHs=;
        b=Lp2NkRKnPcXiflkwCMZBeMkboRcNjvnBHzIlTYFpl0eclFC++1BWZ8Lj1oxXItpc6b/JLI
        Ozcp/AF7YbcWGylkY4GgprYeoZKx9R6orA9ellgvR5ifHJE6lmPGu1BfF8TuZbVNjkLtsQ
        SfWZ8qYCEBoHxE5v/MQ/UA5UEOPpLOo=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-3Wh5xP9_NqCs8YJHIyG8-A-1; Wed, 23 Aug 2023 22:07:16 -0400
X-MC-Unique: 3Wh5xP9_NqCs8YJHIyG8-A-1
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-3a5a7e981ddso7044385b6e.2
        for <linux-xfs@vger.kernel.org>; Wed, 23 Aug 2023 19:07:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692842835; x=1693447635;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q4PQUc9NsE1MHqNTFf/oivcR7M3aHs8G4oAr6UVJeHs=;
        b=NQF/Jc4c0uv5LJn7M1at8aF667EQusStGbo+0IW98jG9Gv1Q8SEIKGwuN/Vo2uA4iK
         4U1vMM2eOCoMqJ1MeodKIDhqxDYOB4TvYyrwmWhb7bbq0Jo/+OhlciH324debVOKwZvD
         G/PuJkAZu0JaqOkg5GuzdhwYFDikJKz6jcy8R/WwBzNhO93d/t7byRuBhj06lago1etQ
         MQNVDZ+WZ7Y5QsaLudUHNHV0YCyuQrWRKCzh8aMZa7PvtBn0AurppIMkURoRQ3KSha5T
         k3cU9zo2vY3O046q8s/FYlfz4DgVVX1r6Ehp1oQguCdv4CmdV4Dj9J6537QoVVp/T9A3
         E0Ew==
X-Gm-Message-State: AOJu0Yx18f2qfbirYIx/d5cGPIAOphgMYf31aUDylpfXWCc2RvenMzdF
        n8NoSCYnUqOW+WSaSKpWbMQ05vfjqaPIUgCH05wjxrolCOr814WnD3p1UdJ4zmWNS6rew5/BlWE
        eQEIz1x2AxRRw8uCm4A6XbjQ53yIBh4u1JPod50DefpMfoj1+QcFQUD6fm4kx4O0H6vCVIX+76Y
        GO4prH
X-Received: by 2002:a05:6808:3af:b0:3a3:ed22:5a4a with SMTP id n15-20020a05680803af00b003a3ed225a4amr14676910oie.40.1692842835697;
        Wed, 23 Aug 2023 19:07:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEuU60yT5XpJHtt4N3EXqK4xMNCP4ox242CLBHbLa/Dg2DAPLdFCn1TEJ2LiuKNaCW3wzTzoA==
X-Received: by 2002:a05:6808:3af:b0:3a3:ed22:5a4a with SMTP id n15-20020a05680803af00b003a3ed225a4amr14676895oie.40.1692842835409;
        Wed, 23 Aug 2023 19:07:15 -0700 (PDT)
Received: from anathem.redhat.com ([2001:8003:4b08:fb00:e45d:9492:62e8:873c])
        by smtp.gmail.com with ESMTPSA id p15-20020a62ab0f000000b0064378c52398sm6340735pff.25.2023.08.23.19.07.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Aug 2023 19:07:14 -0700 (PDT)
From:   Donald Douwsma <ddouwsma@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH v3] xfsrestore: suggest -x rather than assert for false roots
Date:   Thu, 24 Aug 2023 12:07:04 +1000
Message-Id: <20230824020704.1893521-1-ddouwsma@redhat.com>
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

---
Changes for v2
- Use xfsprogs style for conditional
- Remove trailing white-space
- Place printf format all on one line for grepability
- use __func__ instead of gcc specific __FUNCTION__
Changes for v3
- Fix indentation of if statement
---
 restore/tree.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/restore/tree.c b/restore/tree.c
index bfa07fe..6f3180f 100644
--- a/restore/tree.c
+++ b/restore/tree.c
@@ -783,8 +783,15 @@ tree_begindir(filehdr_t *fhdrp, dah_t *dahp)
 	/* lookup head of hardlink list
 	 */
 	hardh = link_hardh(ino, gen);
-	if (need_fixrootdir == BOOL_FALSE)
-		assert(ino != persp->p_rootino || hardh == persp->p_rooth);
+	if (need_fixrootdir == BOOL_FALSE &&
+	    !(ino != persp->p_rootino || hardh == persp->p_rooth)) {
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

