Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57180C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:56:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbjEZB4j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbjEZB4i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:56:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161E2E7
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:56:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7A2A64C1F
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:56:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D181C433EF;
        Fri, 26 May 2023 01:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066197;
        bh=eL0BbB7DcQvHkCUjbR2Bz6peUqEdb/xBsE7eMUMpbBg=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=qnkaTbYfdl9dmt0fl2l/7Lk8pmt7XZgJhnup4WWp2rhEObaqnjPsczRcKuQkLhtzJ
         Gqu9/CdbapAPKYPSgPPV6uBscPkrAeLO4n8iEzzqp7Af37+vnL6m6mNilXmNVXA/WU
         k0R/XVgVzNqukkGOF5tVxo6jDi08ufy2lvShvOqElLsa6PRZIVP36/4090ApsRhdW5
         4fR2VaszvnJJ9duoe6k8FzqkMa76/kpETOwe1ZR7yS3H+pDZFge0VeKNq49ytRAYSg
         Rp8/fdgH6pVDn61lQFMKna3YgJL1Z/QteufUoAv7PASLSaYJTmJl6z+5UXZWL47wpc
         O5Soyc3v1qTkA==
Date:   Thu, 25 May 2023 18:56:36 -0700
Subject: [PATCH 2/6] xfs_scrub_all: remove journalctl background process
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506074879.3746274.3480175356038202279.stgit@frogsfrogsfrogs>
In-Reply-To: <168506074851.3746274.9049178062160647823.stgit@frogsfrogsfrogs>
References: <168506074851.3746274.9049178062160647823.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we only start systemd services if we're running in service
mode, there's no need for the background journalctl process that only
ran if we had started systemd services in non-service mode.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub_all.in |   14 --------------
 1 file changed, 14 deletions(-)


diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index f2b06fb8f7d..8b3ac332f53 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -261,17 +261,6 @@ def main():
 
 	fs = find_mounts()
 
-	# Tail the journal if we ourselves aren't a service...
-	journalthread = None
-	if 'SERVICE_MODE' not in os.environ:
-		try:
-			cmd=['journalctl', '--no-pager', '-q', '-S', 'now', \
-					'-f', '-u', 'xfs_scrub@*', '-o', \
-					'cat']
-			journalthread = subprocess.Popen(cmd)
-		except:
-			pass
-
 	# Schedule scrub jobs...
 	running_devs = set()
 	killfuncs = set()
@@ -308,9 +297,6 @@ def main():
 	while len(killfuncs) > 0:
 		wait_for_termination(cond, killfuncs)
 
-	if journalthread is not None:
-		journalthread.terminate()
-
 	# See the service mode comments in xfs_scrub.c for why we do this.
 	if 'SERVICE_MODE' in os.environ:
 		time.sleep(2)

