Return-Path: <SRS0=MzXO=6F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F1BFC54FC9
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Apr 2020 11:37:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AE3D2075A
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Apr 2020 11:37:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbgDULhH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Apr 2020 07:37:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:56502 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728316AbgDULhG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Apr 2020 07:37:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8D81DABEC;
        Tue, 21 Apr 2020 11:37:04 +0000 (UTC)
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH] common/fuzzy: don't attempt online scrubbing unless supported
Date:   Tue, 21 Apr 2020 13:36:42 +0200
Message-Id: <20200421113643.24224-1-ailiop@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Many xfs metadata fuzzing tests invoke xfs_scrub to detect online errors
even when _scratch_xfs_fuzz_metadata is invoked with "offline". This
causes those tests to fail with output mismatches on kernels that don't
enable CONFIG_XFS_ONLINE_SCRUB. Bypass scrubbing when not supported.

Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
 common/fuzzy | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/common/fuzzy b/common/fuzzy
index 988203b1..83ddc3e8 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -238,7 +238,7 @@ __scratch_xfs_fuzz_field_test() {
 	if [ $res -eq 0 ]; then
 		# Try an online scrub unless we're fuzzing ag 0's sb,
 		# which scrub doesn't know how to fix.
-		if [ "${repair}" != "none" ]; then
+		if _supports_xfs_scrub "${SCRATCH_MNT}" "${SCRATCH_DEV}"; then
 			echo "++ Online scrub"
 			if [ "$1" != "sb 0" ]; then
 				_scratch_scrub -n -e continue 2>&1
-- 
2.26.2

