Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76DECC433E6
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E74B64DD8
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245612AbhCCDOu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 22:14:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:54676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349853AbhCBRhJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Mar 2021 12:37:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F62164F2C;
        Tue,  2 Mar 2021 17:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614706074;
        bh=WYkSmtrhxsJf6X/yAAO/Ztr7Ujt3SqgqKtRkIfZGKzE=;
        h=Date:From:To:Cc:Subject:From;
        b=mIjAkD1ZbpSilU9qcEX3d8nlk2EeeIlVDrolVEevi/nW3xJGjR1Mgi2ic71xNOsDO
         MZY1oCY5kks7el5rxGKB4NkUomueMBKbH3c82XP/GI1L61KoFJca3Sq4J9w7TARgNn
         MZzylaJEyrJ8SqC2Ed+GHweZFAp5DTrq450lJYB0x7zlPnqgp2ohqhs8wL8XLdPb+F
         cbbFyYf4EA61Z1s71oHUVbjSQi0y3spQiWG76M/am5vkvkTAnBHCD8rbsVL88EepDL
         zL62mSzy98fUtwXQ0MgTcMIntw7JHz4sdOi/PCTf4ZnYXbKTJL7Lb/+/UDaOvJ2A9K
         YsShQs+ffHNzQ==
Date:   Tue, 2 Mar 2021 09:27:53 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Geert Hendrickx <geert@hendrickx.be>
Subject: [PATCH] xfs_admin: don't add '=1' when building repair command line
 for -O
Message-ID: <20210302172753.GO7272@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Geert Hendrickx reported an inconsistency between the xfs_admin manpage
and its behavior -- the documentation says that users must provide the
status explicitly, but the script injects '=1' anyway.  While this seems
to work with the glibc getsubopt, it's a bit ugly and isn't consistent
with the docs.

So, get rid of that extra two bytes.

Reported-by: Geert Hendrickx <geert@hendrickx.be>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/xfs_admin.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
index 7a467dbe..02f34b73 100755
--- a/db/xfs_admin.sh
+++ b/db/xfs_admin.sh
@@ -20,7 +20,7 @@ do
 	j)	DB_OPTS=$DB_OPTS" -c 'version log2'";;
 	l)	DB_OPTS=$DB_OPTS" -r -c label";;
 	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'";;
-	O)	REPAIR_OPTS=$REPAIR_OPTS" -c $OPTARG=1";;
+	O)	REPAIR_OPTS=$REPAIR_OPTS" -c $OPTARG";;
 	p)	DB_OPTS=$DB_OPTS" -c 'version projid32bit'";;
 	r)	REPAIR_DEV_OPTS=" -r '$OPTARG'";;
 	u)	DB_OPTS=$DB_OPTS" -r -c uuid";;
