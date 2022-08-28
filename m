Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90465C3DA6B
	for <linux-xfs@archiver.kernel.org>; Sun, 28 Aug 2022 12:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiH1Mqe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 Aug 2022 08:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiH1Mqe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Aug 2022 08:46:34 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E816B39BAD;
        Sun, 28 Aug 2022 05:46:32 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id i188-20020a1c3bc5000000b003a7b6ae4eb2so1826134wma.4;
        Sun, 28 Aug 2022 05:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=ClUDeGC9nglyH/ITzPbEnTS1Qj4P8Cu3FgCkPcGFhY4=;
        b=qUna73fEWTQSKBkaCl8BwQUvBR5KhgOfvgm9542tk6J6ZC4W21+dvsiJlFIVW6Qn1b
         UFeP+iGy/fOa/EWiMiIIYngTNpu+yXTeSsIhh0moS53c+BMCGMT8uMGWXRDF8ijalqFG
         PEOvnrp7qG7TudjiIWuknjPhz/TGmFk9ALGxqSSspVzKbkGK8iPVQ9keMN9GTB337uz1
         xky5wyJGR7xj5sfoUelbBSKjj/hfJXWPLZpx6c6eW6yHfM8uU7E1OH8z8enDf8Zuq5Gl
         crI2kVwtw4F8gA/sCETSlkHM/ioKpFMK1TuLyBWyAPjRtq80Vih7le8dXOkmMJmaF4Zu
         Z+3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=ClUDeGC9nglyH/ITzPbEnTS1Qj4P8Cu3FgCkPcGFhY4=;
        b=0+hy1oeqST6zi3QqFxN15irKcni5V/9lPfQjiSeNPgPLGmxUOe8Pxa+vWymnw1ns89
         lOhd7Z0erB0BW7lyfk38WVCHuQw87QVU5Y4VzZfcpWXbGXpVWBeIM8vT0RmTb8kyAJuB
         DefEnIx3SL3FZSM2f3WPuUtaoItZ77cpoEegi1ldQTcqqXSheFTXCNezYSXri6OlqRDH
         iFVhn0AVGmAwVVJujwWadG69o8Co13d+zLNL+IMxnWzeEWj5BT7QWz14VqC1PW455KCM
         oeZWYRYm7u+NwGxCNZRFUEfml4943SwVp6k8UjMPs5xwNLBqBww64q3QWABPzMEQollV
         es4w==
X-Gm-Message-State: ACgBeo0LUfQj4vD5GDaKorQTJaaeFCtoymEzT9idr7xM3D33b7gNA1h+
        MczPbQmYUBl5cHBAliIDbW37ulMyFpI=
X-Google-Smtp-Source: AA6agR6F1Ltj7MAi1+cqpkvCPG0Gxo/f4lyXNCcDs1ISgqUnXX5c1VftKzalV2OyIXzMQYshnBUTNQ==
X-Received: by 2002:a05:600c:a0a:b0:3a6:71e5:fb70 with SMTP id z10-20020a05600c0a0a00b003a671e5fb70mr4359968wmp.141.1661690791351;
        Sun, 28 Aug 2022 05:46:31 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([2a0d:6fc2:4b00:1500:ecf5:e90e:2ba2:1534])
        by smtp.gmail.com with ESMTPSA id k25-20020adfd239000000b0021e43b4edf0sm4443414wrh.20.2022.08.28.05.46.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Aug 2022 05:46:30 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 5.10 CANDIDATE 3/7] xfs: fix overfilling of reserve pool
Date:   Sun, 28 Aug 2022 15:46:10 +0300
Message-Id: <20220828124614.2190592-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220828124614.2190592-1-amir73il@gmail.com>
References: <20220828124614.2190592-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 82be38bcf8a2e056b4c99ce79a3827fa743df6ec upstream.

Due to cycling of m_sb_lock, it's possible for multiple callers of
xfs_reserve_blocks to race at changing the pool size, subtracting blocks
from fdblocks, and actually putting it in the pool.  The result of all
this is that we can overfill the reserve pool to hilarious levels.

xfs_mod_fdblocks, when called with a positive value, already knows how
to take freed blocks and either fill the reserve until it's full, or put
them in fdblocks.  Use that instead of setting m_resblks_avail directly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_fsops.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index dacead0d0934..775f833146e3 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -394,18 +394,17 @@ xfs_reserve_blocks(
 		 * count or we'll get an ENOSPC.  Don't set the reserved flag
 		 * here - we don't want to reserve the extra reserve blocks
 		 * from the reserve.
+		 *
+		 * The desired reserve size can change after we drop the lock.
+		 * Use mod_fdblocks to put the space into the reserve or into
+		 * fdblocks as appropriate.
 		 */
 		fdblks_delta = min(free, delta);
 		spin_unlock(&mp->m_sb_lock);
 		error = xfs_mod_fdblocks(mp, -fdblks_delta, 0);
-		spin_lock(&mp->m_sb_lock);
-
-		/*
-		 * Update the reserve counters if blocks have been successfully
-		 * allocated.
-		 */
 		if (!error)
-			mp->m_resblks_avail += fdblks_delta;
+			xfs_mod_fdblocks(mp, fdblks_delta, 0);
+		spin_lock(&mp->m_sb_lock);
 	}
 out:
 	if (outval) {
-- 
2.25.1

