Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED606C43334
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jun 2022 21:44:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244171AbiFTVoZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jun 2022 17:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343873AbiFTVoU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jun 2022 17:44:20 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8587CC16;
        Mon, 20 Jun 2022 14:44:19 -0700 (PDT)
Received: by sandeen.net (Postfix, from userid 500)
        id 80D094CDD3C; Mon, 20 Jun 2022 16:43:31 -0500 (CDT)
From:   Eric Sandeen <sandeen@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, zlang@kernel.org
Subject: [PATCH] xfs/122: escape %zu in printf with %% not \\%
Date:   Mon, 20 Jun 2022 16:43:31 -0500
Message-Id: <1655761411-11698-1-git-send-email-sandeen@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The standard way to escape % in a printf is with %%; although \\%zu
seems to have worked in awk until recently, an upgrade on Fedora 36
has started failing:

awk: cmd. line:1: (FILENAME=- FNR=1) fatal: not enough arguments to satisfy format string
        'printf("sizeof(%s) = \%zu\n", sizeof(%s));
    '
                                              ^ ran out for this one
Switching the escape to "%%" fixes this for me, and also works
on my very old RHEL7 mcahine.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 tests/xfs/122 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/xfs/122 b/tests/xfs/122
index 5200615..18748e6 100755
--- a/tests/xfs/122
+++ b/tests/xfs/122
@@ -186,7 +186,7 @@ egrep '(} *xfs_.*_t|^struct xfs_[a-z0-9_]*$)' |\
 egrep -v -f $tmp.ignore |\
 sed -e 's/^.*}[[:space:]]*//g' -e 's/;.*$//g' -e 's/_t, /_t\n/g' |\
 sort | uniq |\
-awk '{printf("printf(\"sizeof(%s) = \\%zu\\n\", sizeof(%s));\n", $0, $0);}' |\
+awk '{printf("printf(\"sizeof(%s) = %%zu\\n\", sizeof(%s));\n", $0, $0);}' |\
 cat >> $cprog
 
 #
@@ -199,7 +199,7 @@ awk '
    /typedef struct xfs_sb/ { structon = 1; next }
    structon && $2 ~ /^sb_/ { sub(/[;,]/,"",$2)
                              sub(/XFSLABEL_MAX/,"12",$2)
-                             printf("printf(\"offsetof(xfs_sb_t, %s) = \\%zu\\n\", offsetof(xfs_sb_t, %s));", $2, $2); next}
+                             printf("printf(\"offsetof(xfs_sb_t, %s) = %%zu\\n\", offsetof(xfs_sb_t, %s));", $2, $2); next}
    structon && /}/ { structon = 0; next}
 '>>$cprog
 
-- 
1.8.3.1

