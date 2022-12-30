Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CB05C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:35:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235435AbiLaAfj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:35:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235798AbiLaAfi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:35:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9081EAC0
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:35:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E839CB81DC6
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:35:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E20FC433EF;
        Sat, 31 Dec 2022 00:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446934;
        bh=3doS7mPzmxLI5OkHlaRQFbj7TN/gXQiD46AlCPwLjAM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cqbDhf4xdP2fol+ZTo2mNcD1qHpXcOTt1tYtWeHmmFACETapK4YjxUMPnB9SkEf+K
         eovrWfhbkDP16BeJ8w7uMjxFME/ecZy19z/rVu2w9KtF4r4SDHuafMKXg/9r2CX9DM
         D3whOH2HTgNltoMeJmB9YliW+6WKTVO2NSxpsB7wgRnqWrcYVWdc/k2GFvxOqb3ajx
         da75poUtZjbVdaWSGSemJ8TMLNkqBrV5wa6ov0b9ubfh6eXQMA+YZ3hZgN1lhTfU7w
         m8+wQqt3FhR4V1jIS7FOXMzHdWQ9fcfd4UaER3k0EjS1KfBtH/GibPja1BZwF1PtnT
         Bwh2ac1GZaKAA==
Subject: [PATCH 7/8] xfs_scrub_all: escape service names consistently
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:31 -0800
Message-ID: <167243871191.717702.13948258598750867603.stgit@magnolia>
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

In commit 07c6fd59, I fixed this script so that it would escape
pathnames correctly when passing them as unit instance variables to
systemctl start.  Unfortunately, I neglected to do this for systemctl
stop, which leads to warnings if someone hit ^C while the program is
running from a CLI.  Fix that, and name the unit name variable
consistently.

Fixes: 07c6fd59 ("xfs_scrub_all: escape paths being passed to systemd service instances")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub_all.in |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)


diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index 32bcfb15f5a..2bdbccffd9c 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -58,10 +58,10 @@ def find_mounts():
 
 	return fs
 
-def kill_systemd(unit, proc):
+def kill_systemd(unitname, proc):
 	'''Kill systemd unit.'''
 	proc.terminate()
-	cmd=['systemctl', 'stop', unit]
+	cmd = ['systemctl', 'stop', unitname]
 	x = subprocess.Popen(cmd)
 	x.wait()
 
@@ -119,9 +119,10 @@ def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 			return
 
 		# Try it the systemd way
-		cmd=['systemctl', 'start', 'xfs_scrub@%s' % systemd_escape(mnt)]
+		unitname = 'xfs_scrub@%s' % systemd_escape(mnt)
+		cmd = ['systemctl', 'start', unitname]
 		ret = run_killable(cmd, DEVNULL(), killfuncs, \
-				lambda proc: kill_systemd('xfs_scrub@%s' % mnt, proc))
+				lambda proc: kill_systemd(unitname, proc))
 		if ret == 0 or ret == 1:
 			print("Scrubbing %s done, (err=%d)" % (mnt, ret))
 			sys.stdout.flush()

