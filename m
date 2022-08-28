Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37ACCECAAD2
	for <linux-xfs@archiver.kernel.org>; Sun, 28 Aug 2022 12:46:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiH1Mqf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 Aug 2022 08:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiH1Mqf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Aug 2022 08:46:35 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F39C39BAD;
        Sun, 28 Aug 2022 05:46:34 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id bu22so6709396wrb.3;
        Sun, 28 Aug 2022 05:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=D9ELr1XH1ys1yFEaZ4pnTV2N0Zl0djkEo0M633+19Mw=;
        b=TJwaxL6/SGUenjObbAWHGfHaX10jjF1QO5ntIm2XUqzJDYKu5f/oMAOdlLMJpk1vw4
         0lEMjoRZZkbMTDq+w9hBs9X+0EVNDaL0V67c2PaaQBliZi9B00PANRwZDGAz4z+Vqbun
         j5ZFUeXlONQ37bmkF3nSIaqqklDaSwLA0oFb3PteKTYJVGErlxg/0tkHe+fCEGEAfXcV
         URoawTWyKBbps95uOuggfkayjtrAI3qYlGQo6EzAxobZHDsWvXXGaq3/g/Xvc6rPpHaV
         65dPnupqAlzoRsQLoe8iYpVC4yK5QNzbrkeXi6Lav3jP3a92xqGeV3brK8pRZh65Oyn7
         PAxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=D9ELr1XH1ys1yFEaZ4pnTV2N0Zl0djkEo0M633+19Mw=;
        b=Jh8kyg8ucHI7KFLyDSVLhv81fiAV8W4xpPG0GgkM/chE52JUn/856XhqIEczIKyHcJ
         8IDJgUfJEFrbc4Em/a3Sz0yps7+oOBgVlFEm9O2gWTsry9xc75IWKbkjUPutesDFzGaU
         3SwWL3qLfUfPsYSXrwCambwCA35WO9miY2tU7EnNbOrgpaONeHhd/VSToxHDcfaT8StF
         aBMzrDc0D9LhzjQUqwnweYVCQSRD290if4yxH1AIddTry1lNDk0ULoMCtKXC/8pAcCtt
         MASqBzHN3SF3V9iOhHyW9EaGV5fCsakz5h/47NPCokatOp+O0RlyTNsbBmgqm+82ShSx
         e3sw==
X-Gm-Message-State: ACgBeo0ZtmXL0M4dPFR8cokqsTakxT1PihRRpuj93Zu+Qfk0cjIC6dl5
        OmQPV3tXlNYt0LSKdBxCK7E=
X-Google-Smtp-Source: AA6agR7peMPIQtkkM5Pqi3GuahJ1o9atlPmEk6xluTupaLaZSHetsNtKflgZVTQh9urZGiKQbIVUlA==
X-Received: by 2002:a5d:4d0b:0:b0:226:d5b3:9830 with SMTP id z11-20020a5d4d0b000000b00226d5b39830mr1827098wrt.261.1661690792936;
        Sun, 28 Aug 2022 05:46:32 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([2a0d:6fc2:4b00:1500:ecf5:e90e:2ba2:1534])
        by smtp.gmail.com with ESMTPSA id k25-20020adfd239000000b0021e43b4edf0sm4443414wrh.20.2022.08.28.05.46.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Aug 2022 05:46:32 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5.10 CANDIDATE 4/7] xfs: fix soft lockup via spinning in filestream ag selection loop
Date:   Sun, 28 Aug 2022 15:46:11 +0300
Message-Id: <20220828124614.2190592-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220828124614.2190592-1-amir73il@gmail.com>
References: <20220828124614.2190592-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit f650df7171b882dca737ddbbeb414100b31f16af upstream.

The filestream AG selection loop uses pagf data to aid in AG
selection, which depends on pagf initialization. If the in-core
structure is not initialized, the caller invokes the AGF read path
to do so and carries on. If another task enters the loop and finds
a pagf init already in progress, the AGF read returns -EAGAIN and
the task continues the loop. This does not increment the current ag
index, however, which means the task spins on the current AGF buffer
until unlocked.

If the AGF read I/O submitted by the initial task happens to be
delayed for whatever reason, this results in soft lockup warnings
via the spinning task. This is reproduced by xfs/170. To avoid this
problem, fix the AGF trylock failure path to properly iterate to the
next AG. If a task iterates all AGs without making progress, the
trylock behavior is dropped in favor of blocking locks and thus a
soft lockup is no longer possible.

Fixes: f48e2df8a877ca1c ("xfs: make xfs_*read_agf return EAGAIN to ALLOC_FLAG_TRYLOCK callers")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_filestream.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index db23e455eb91..bc41ec0c483d 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -128,11 +128,12 @@ xfs_filestream_pick_ag(
 		if (!pag->pagf_init) {
 			err = xfs_alloc_pagf_init(mp, NULL, ag, trylock);
 			if (err) {
-				xfs_perag_put(pag);
-				if (err != -EAGAIN)
+				if (err != -EAGAIN) {
+					xfs_perag_put(pag);
 					return err;
+				}
 				/* Couldn't lock the AGF, skip this AG. */
-				continue;
+				goto next_ag;
 			}
 		}
 
-- 
2.25.1

