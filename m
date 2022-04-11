Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC17C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 22:55:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239964AbiDKW5W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 18:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350074AbiDKW5W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 18:57:22 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491CD1277C;
        Mon, 11 Apr 2022 15:55:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B905CCE17B8;
        Mon, 11 Apr 2022 22:55:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296F5C385A5;
        Mon, 11 Apr 2022 22:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649717703;
        bh=aMCWm7lPVlZJOfEgIzlemW0FHIkrH3POhZ234MoaGS4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LS7pit/z2JhRExsuzYMk9MKE21vUxQqsCpruY9IMSa94holYcvfRPxqkfhANJ944u
         8/F+CQH93YAOnbJAeVG6o4121ZSU3C54n2c1Wkrz23rqpMd4/Og/gepsYk6PEIoUVE
         oJbctJP5iKP6H4o2Y9XULl5iHV/HzfqzH7sMZthZ+8x6zKtPLrn6+xCFx2K+Ae3X0o
         SasTmWFr6ZHCHNmAKjD2lyD0bgFyLYUNpgLpamfwuu95Gh1zXC0EhFOzBrY/cMOWja
         MhC68Lx9isQLJBAoBcsTXC1XbI0BDoSzKYPBxuATha7yA1OZYlhuq9ymVERjw7YNiC
         0Y+PUyTg5apbQ==
Subject: [PATCH 1/3] common/rc: let xfs_scrub tell us about its unicode
 checker
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 11 Apr 2022 15:55:02 -0700
Message-ID: <164971770270.170109.8871111464246200861.stgit@magnolia>
In-Reply-To: <164971769710.170109.8985299417765876269.stgit@magnolia>
References: <164971769710.170109.8985299417765876269.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that xfs_scrub can report whether or not it was built with the
Unicode name checker, rewrite _check_xfs_scrub_does_unicode to take
advantage of that.  This supersedes the old method of trying to observe
dynamic library linkages and grepping the binary, neither of which
worked very well.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc |   12 ++++++++++++
 1 file changed, 12 insertions(+)


diff --git a/common/rc b/common/rc
index 17629801..ec146c4e 100644
--- a/common/rc
+++ b/common/rc
@@ -4800,6 +4800,18 @@ _check_xfs_scrub_does_unicode() {
 
 	_supports_xfs_scrub "${mount}" "${dev}" || return 1
 
+	# Newer versions of xfs_scrub advertise whether or not it supports
+	# Unicode name checks.
+	local xfs_scrub_ver="$("${XFS_SCRUB_PROG}" -VV)"
+
+	if echo "${xfs_scrub_ver}" | grep -q -- '-Unicode'; then
+		return 1
+	fi
+
+	if echo "${xfs_scrub_ver}" | grep -q -- '+Unicode'; then
+		return 0
+	fi
+
 	# If the xfs_scrub binary contains the string "Unicode name.*%s", then
 	# we know that it has the ability to complain about improper Unicode
 	# names.

