Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A9E9C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:34:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235702AbiLaAei (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235715AbiLaAef (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:34:35 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2492F1EAC0
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:34:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 73A7BCE19DF
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:34:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B54A1C433D2;
        Sat, 31 Dec 2022 00:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446871;
        bh=hC8eHGeZ+n4lVRpOHeU/AA1l4ZjE8aISGHaoGAvlLxE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kwn1OLqh2+sEVcvWGLjDnbCTUT5XfkcJ1h/V8OASNRiyucfvGcbof1UxGIGbstEd6
         eTCIrC3LkEeTnK6PmnIqZojDUEl3U5U3/oN/9fd5E+T1c5e5VHjUedSzH/Uen/hmST
         M1iGGwUGnnmP8lKo8p683GXBTnCGLmefIdSHPThp5SZ9YgBC+dz6IGaDGRdN5nRJn4
         438LKkKunU/u6QZlcZwZAEzv7dzZU0mnVOEifVsr9GT7ipE4G4kaCdRMUiuXZ2Fv67
         3e5ZtXsuNymrD8eGnIeNW1NEihDecLkHTzMgSIi+wYjudBQRsKkGHKdJIEFf3dbJ1X
         VkWrquEGUxg9Q==
Subject: [PATCH 3/8] xfs_scrub_fail: fix sendmail detection
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:31 -0800
Message-ID: <167243871137.717702.7724582296047344762.stgit@magnolia>
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

This script emails the results of failed scrub runs to root.  We
shouldn't be hardcoding the path to the mailer program because distros
can change the path according to their whim.  Modify this script to use
command -v to find the program.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub_fail |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/scrub/xfs_scrub_fail b/scrub/xfs_scrub_fail
index 8ada5dbbe06..a46eb34ee29 100755
--- a/scrub/xfs_scrub_fail
+++ b/scrub/xfs_scrub_fail
@@ -7,13 +7,14 @@
 
 # Email logs of failed xfs_scrub unit runs
 
-mailer=/usr/sbin/sendmail
 recipient="$1"
 test -z "${recipient}" && exit 0
 mntpoint="$2"
 test -z "${mntpoint}" && exit 0
 hostname="$(hostname -f 2>/dev/null)"
 test -z "${hostname}" && hostname="${HOSTNAME}"
+
+mailer="$(command -v sendmail)"
 if [ ! -x "${mailer}" ]; then
 	echo "${mailer}: Mailer program not found."
 	exit 1

