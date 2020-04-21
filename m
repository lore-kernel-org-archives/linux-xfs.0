Return-Path: <SRS0=MzXO=6F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3BE1C54FC9
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Apr 2020 11:37:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC3552064C
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Apr 2020 11:37:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgDULhX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Apr 2020 07:37:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:56562 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728654AbgDULhU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Apr 2020 07:37:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6E009ABEC;
        Tue, 21 Apr 2020 11:37:18 +0000 (UTC)
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs/126: make blocktrash work reliably on attrleaf blocks
Date:   Tue, 21 Apr 2020 13:36:43 +0200
Message-Id: <20200421113643.24224-2-ailiop@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Running xfs/126 sometimes fails due to output mismatch. Due to the
randomized nature of the test, periodically the selected bits are not
relevant to the test, or the selected bits are not flipped. Supply an
offset that is close to the start of the metadata block, so that the
test will reliably corrupt the header.

Suggested-by: Darrick J. Wong <darrick.wong@oracle.com>
Link: https://lore.kernel.org/linux-xfs/20200116160323.GC2149943@magnolia
Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
 tests/xfs/126 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/126 b/tests/xfs/126
index 4f9f8cf9..d01338c9 100755
--- a/tests/xfs/126
+++ b/tests/xfs/126
@@ -72,7 +72,7 @@ echo "+ corrupt xattr"
 loff=1
 while true; do
 	_scratch_xfs_db -x -c "inode ${inode}" -c "ablock ${loff}" -c "stack" | grep -q 'file attr block is unmapped' && break
-	_scratch_xfs_db -x -c "inode ${inode}" -c "ablock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full
+	_scratch_xfs_db -x -c "inode ${inode}" -c "ablock ${loff}" -c "stack" -c "blocktrash -o 4 -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full
 	loff="$((loff + 1))"
 done
 
-- 
2.26.2

