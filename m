Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85874C4320A
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:53:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68F036101A
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:53:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236667AbhHQXxp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Aug 2021 19:53:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235369AbhHQXxp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Aug 2021 19:53:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3593761008;
        Tue, 17 Aug 2021 23:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629244391;
        bh=+VJ0GYPjJjDus+y8NedEogF3FF4fQy9vNhDXrFQAbl4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=prUbiS8XufhnuEnW7bC3WWDQQje5boXHJOdRhT1xR9bg29fdjY2eeCTSts2qMbKs+
         NQwNdD6mBQAo3DavPbySk5qtkdM5Jn4z1bekkzaClDQiCsV6sF9C6mQS70BNPgHj0S
         a8IoPY2Y1FvFaiHGpBPnU2WgrMQG605OJFM/2swhNfPD5mWPX/MQ0126N46ULWY4Wm
         QQxdDndGuYJMGMZAn6btW3tUF1mUVum8VR8+n80jlymgTf7LQzUeuaf0YD+QZ/0xvo
         OEBj8V+z0p3TSmcIiy7CXfMoK86aNZkZBU0bC/KorU38H+sgbhCN2me70bGN38hVQH
         grNrt0jycYpqQ==
Subject: [PATCH 2/2] scsi_debug: fix module removal loop
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 17 Aug 2021 16:53:10 -0700
Message-ID: <162924439095.779373.7171773658755331729.stgit@magnolia>
In-Reply-To: <162924437987.779373.1973564511078951065.stgit@magnolia>
References: <162924437987.779373.1973564511078951065.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Luis' recent patch changing the "sleep 1" to a "udevadm settle"
invocation exposed some race conditions in _put_scsi_debug_dev that
caused regressions in generic/108 on my machine.  Looking at tracing
data, it looks like the udisks daemon will try to open the device at
some point after the filesystem unmounts; if this coincides with the
final 'rmmod scsi_debug', the test fails.

Examining the function, it is odd to me that the loop condition is
predicated only on whether or not modprobe /thinks/ it can remove the
module.  Why not actually try (twice) actually to remove the module,
and then complain if a third attempt fails?

Also switch the final removal attempt to modprobe -r, since it returns
zero if the module isn't loaded.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/scsi_debug |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/common/scsi_debug b/common/scsi_debug
index e7988469..abaf6798 100644
--- a/common/scsi_debug
+++ b/common/scsi_debug
@@ -49,9 +49,9 @@ _put_scsi_debug_dev()
 	# use redirection not -q option of modprobe here, because -q of old
 	# modprobe is only quiet when the module is not found, not when the
 	# module is in use.
-	while [ $n -ge 0 ] && ! modprobe -nr scsi_debug >/dev/null 2>&1; do
+	while [ $n -ge 0 ] && ! modprobe -r scsi_debug >/dev/null 2>&1; do
 		$UDEV_SETTLE_PROG
 		n=$((n-1))
 	done
-	rmmod scsi_debug || _fail "Could not remove scsi_debug module"
+	modprobe -r scsi_debug || _fail "Could not remove scsi_debug module"
 }

