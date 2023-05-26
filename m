Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5377C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:53:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjEZBxB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjEZBxA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:53:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96DD3E7
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:52:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3416963B77
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:52:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907C8C433D2;
        Fri, 26 May 2023 01:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065978;
        bh=Md+TWzSEeGGQTEiEVN5f2dIQ2HI7QO9lj9GspKoDH4o=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=f9we/6L9EC5EbVFJgZj+G6JEVAflk3F2WI/t2A8VSU2lpAz1/8cWehDy8ZCgXQ5KO
         dUe8kHus7A/77oEiG4ufXAD1cmPhCxt2XKa1UbXFfDxcjsVKnYN7v+5mqWa8h01z/w
         17zG1Z6o+y4sxt1V/4+vYmdj+c5A68bnimAX85En/Qm1pKhQcF8Um7MSdAN1FoMqd/
         x27BqZpwWGvYh5Uv6ENKwFy/HwmL0qnG9pA2cikjUAAUoP4NBTZe/wdnwowcwMcCK1
         nvZKMseNtD2es8HJ75y7xpDpDBfVXEiMoJcS5HDhKqjClvLbOdCL6ovWs1Xox2ERVS
         M1Qd3VZ6kIchg==
Date:   Thu, 25 May 2023 18:52:58 -0700
Subject: [PATCH 2/5] xfs_scrub_all: escape service names consistently
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506073859.3745766.15701175812728914090.stgit@frogsfrogsfrogs>
In-Reply-To: <168506073832.3745766.10929690168821459226.stgit@frogsfrogsfrogs>
References: <168506073832.3745766.10929690168821459226.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This program is not consistent as to whether or not it escapes the
pathname that is being used as the xfs_scrub service instance name.
Fix it to be consistent, and to fall back to direct invocation if
escaping doesn't work.  The escaping itself is also broken, but we'll
fix that in the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub_all.in |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)


diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index d8264a3cb07..d4cb9bc7bb7 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -93,19 +93,19 @@ def run_killable(cmd, stdout, killfuncs, kill_fn):
 # that log messages from the service units preserve the full path and users can
 # look up log messages using full paths.  However, for "/" the escaping rules
 # do /not/ drop the initial slash, so we have to special-case that here.
-def systemd_escape(path):
+def path_to_service(path):
 	'''Escape a path to avoid mangled systemd mangling.'''
 
 	if path == '/':
-		return '-'
+		return 'xfs_scrub@-'
 	cmd = ['systemd-escape', '--path', path]
 	try:
 		proc = subprocess.Popen(cmd, stdout = subprocess.PIPE)
 		proc.wait()
 		for line in proc.stdout:
-			return '-' + line.decode(sys.stdout.encoding).strip()
+			return 'xfs_scrub@-%s' % line.decode(sys.stdout.encoding).strip()
 	except:
-		return path
+		return None
 
 def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 	'''Run a scrub process.'''
@@ -119,17 +119,19 @@ def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 			return
 
 		# Try it the systemd way
-		cmd=['systemctl', 'start', 'xfs_scrub@%s' % systemd_escape(mnt)]
-		ret = run_killable(cmd, DEVNULL(), killfuncs, \
-				lambda proc: kill_systemd('xfs_scrub@%s' % mnt, proc))
-		if ret == 0 or ret == 1:
-			print("Scrubbing %s done, (err=%d)" % (mnt, ret))
-			sys.stdout.flush()
-			retcode |= ret
-			return
+		svcname = path_to_service(path)
+		if svcname is not None:
+			cmd=['systemctl', 'start', svcname]
+			ret = run_killable(cmd, DEVNULL(), killfuncs, \
+					lambda proc: kill_systemd(svcname, proc))
+			if ret == 0 or ret == 1:
+				print("Scrubbing %s done, (err=%d)" % (mnt, ret))
+				sys.stdout.flush()
+				retcode |= ret
+				return
 
-		if terminate:
-			return
+			if terminate:
+				return
 
 		# Invoke xfs_scrub manually
 		cmd=['@sbindir@/xfs_scrub', '@scrub_args@', mnt]

