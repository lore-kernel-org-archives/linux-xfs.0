Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C859CC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:35:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235739AbiLaAfH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:35:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235435AbiLaAfG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:35:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A5A1DDE4
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:35:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78373B80883
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5D2C433EF;
        Sat, 31 Dec 2022 00:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446903;
        bh=b7ljo0En4q++GnEO7bOXZ/k2e/2L4zIqzdWIpmampXI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=prnzzmCpuqZmTS0uC1QM5JG72ctqXwhrF9cDskGLPDBiSj7WHWbQjcaiE0LMwYctd
         BJnYvJydUcHdwdmyTni/0WJWw1POsVnN9fzuhKIU8XZCbD6aKIRHEvCNKeCIb3V5LK
         QoQe/gbGNduF/4wm+TUqXXb9GJBTBOEDI6BTIkVJNDEZ2R5VVigPZ+ANDJfu6tcArw
         WvQD8rqbkakBghJZlYQnKyG/wx0yCsKcqeZEoTqig17fLds9AtyEEGwJtOMycZArvK
         q6c0oVPmh7LsTjCUk+KI9nvpzJd/OwDZUtVrEdZ/xDtSQnmi5P1gs1uH6mAbZyDlYZ
         YOuk2haTdWj1Q==
Subject: [PATCH 5/8] xfs_scrub_fail: return the failure status of the mailer
 program
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:31 -0800
Message-ID: <167243871164.717702.12178389387628868397.stgit@magnolia>
In-Reply-To: <167243871097.717702.15336500890922415647.stgit@magnolia>
References: <167243871097.717702.15336500890922415647.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

We should return the exit code of the mailer program sending the scrub
failure reports, since that's much more important to anyone watching the
system.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub_fail |    1 +
 1 file changed, 1 insertion(+)


diff --git a/scrub/xfs_scrub_fail b/scrub/xfs_scrub_fail
index 4ec7e48836a..fbe30cbc4c6 100755
--- a/scrub/xfs_scrub_fail
+++ b/scrub/xfs_scrub_fail
@@ -56,3 +56,4 @@ So sorry, the automatic xfs_scrub of ${mntpoint} on ${hostname} failed.
 A log of what happened follows:
 ENDL
 systemctl status --full --lines 4294967295 "xfs_scrub@${mntpoint_esc}") | "${mailer}" -t -i
+exit "${PIPESTATUS[1]}"

