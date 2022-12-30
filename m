Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 852E9C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:34:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235715AbiLaAew (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:34:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235435AbiLaAev (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:34:51 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85E41DDE4
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:34:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3D9EFCE19BB
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:34:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77076C433D2;
        Sat, 31 Dec 2022 00:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446887;
        bh=NpOtt+luzMwEzyMdzcmGAxqYzLtP5I0Ek93HIUJWdWk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gNkZebnY0JPFjkONUMwALl0u9NJY1fWt+FhtY0ep4+AtYTga4oEtKMita1H4MxpNZ
         9KvzP+15BmUOgBMD0QfbZrNpWw82ufZ6js32e3ab8Md/muZ9WSUJOXWThOuLOezdPg
         y2Dn1euTA3LFkqQoem7OVs2SnO4smHOc6nfyuOig0hOdCkREWlFevqUEyPx2h9/3FO
         rL+EW8m6joCEl5d0huoEiFTid33Q3IGfod6xQpMk/Ni3nNRMO5WUjgl8DExyb1FGx6
         3e/Jz8NhcFEM4h/ne5FVaDHorzkO7NT1Y6HUyFt5rkmP7c8XgVN6CoKhpwbTOAkjTc
         J12iqGCnMb3Ig==
Subject: [PATCH 4/8] xfs_scrub_fail: escape paths correctly
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:31 -0800
Message-ID: <167243871150.717702.9536987936805993820.stgit@magnolia>
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

Always escape pathnames correctly so that systemd doesn't complain.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub_fail |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)


diff --git a/scrub/xfs_scrub_fail b/scrub/xfs_scrub_fail
index a46eb34ee29..4ec7e48836a 100755
--- a/scrub/xfs_scrub_fail
+++ b/scrub/xfs_scrub_fail
@@ -20,6 +20,32 @@ if [ ! -x "${mailer}" ]; then
 	exit 1
 fi
 
+# systemd doesn't like unit instance names with slashes in them, so it
+# replaces them with dashes when it invokes the service.  However, it's not
+# smart enough to convert the dashes to something else, so when it unescapes
+# the instance name to feed to xfs_scrub, it turns all dashes into slashes.
+# "/moo-cow" becomes "-moo-cow" becomes "/moo/cow", which is wrong.  systemd
+# actually /can/ escape the dashes correctly if it is told that this is a path
+# (and not a unit name), but it didn't do this prior to January 2017, so fix
+# this for them.
+#
+# systemd path escaping also drops the initial slash so we add that back in so
+# that log messages from the service units preserve the full path and users can
+# look up log messages using full paths.  However, for "/" the escaping rules
+# do /not/ drop the initial slash, so we have to special-case that here.
+escape_path() {
+	local arg="$1"
+
+	if [ "${arg}" = "/" ]; then
+		echo "-"
+		exit 0
+	fi
+
+	echo "-$(systemd-escape --path "${mntpoint}")"
+}
+
+mntpoint_esc="$(escape_path "${mntpoint}")"
+
 (cat << ENDL
 To: $1
 From: <xfs_scrub@${hostname}>
@@ -29,4 +55,4 @@ So sorry, the automatic xfs_scrub of ${mntpoint} on ${hostname} failed.
 
 A log of what happened follows:
 ENDL
-systemctl status --full --lines 4294967295 "xfs_scrub@${mntpoint}") | "${mailer}" -t -i
+systemctl status --full --lines 4294967295 "xfs_scrub@${mntpoint_esc}") | "${mailer}" -t -i

