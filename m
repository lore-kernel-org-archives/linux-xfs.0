Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 702A5C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjEZB6B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240695AbjEZB6A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:58:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A749199
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:57:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8941E64C47
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:57:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7FBBC433EF;
        Fri, 26 May 2023 01:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066277;
        bh=1lzShRR2ClvkTamexIG1kchquJN3/Q+hEMxrC13lZi0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=HUCRBY6DMT8AUPRrmo8QXAGh4RuAeKDp/dqE0GRby9fVg1i571FjC4anXFrGfRL3/
         D9NzQ6C7FgacsESukAoJhLMmn4mIe5I1rJ3jklqa4xSfMa/HafhfOiOMcXYaS0+WOo
         4wMLFH3zYT9xpRfVmW5j1hWt54L8qyo/+5LubH1ASKnVUPJzX5uojfWzfTvQfkHLeI
         QNjAy+PvtFYZzEToGmhCkPm6oa9XZgw6BcamTkHK/RUOrzfujxMkYydp2AtcSDgcdq
         9rQkSj7DLNLRZK7F58J+mLIYiVMm7f0Qd6dRwfMobk52IDeczLRbNtsCK4L3jpZDd6
         F5iwhqlIfUvbQ==
Date:   Thu, 25 May 2023 18:57:54 -0700
Subject: [PATCH 1/5] xfs_scrub_all: encapsulate all the subprocess code in an
 object
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506075221.3746473.5351794549792116042.stgit@frogsfrogsfrogs>
In-Reply-To: <168506075207.3746473.18041622129638673219.stgit@frogsfrogsfrogs>
References: <168506075207.3746473.18041622129638673219.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move all the xfs_scrub subprocess handling code to an object so that we
can contain all the details in a single place.  This also simplifies the
background state management.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub_all.in |   68 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 54 insertions(+), 14 deletions(-)


diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index ec33bb13e5e..0e71cb9ae17 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -78,15 +78,62 @@ def remove_killfunc(killfuncs, fn):
 	except:
 		pass
 
-def run_killable(cmd, stdout, killfuncs):
+class scrub_control(object):
+	'''Control object for xfs_scrub.'''
+	def __init__(self):
+		pass
+
+	def start(self):
+		'''Start scrub and wait for it to complete.  Returns -1 if the
+		service was not started, 0 if it succeeded, or 1 if it
+		failed.'''
+		assert False
+
+	def stop(self):
+		'''Stop scrub.'''
+		assert False
+
+class scrub_subprocess(scrub_control):
+	'''Control object for xfs_scrub subprocesses.'''
+	def __init__(self, mnt, scrub_media):
+		cmd = ['@sbindir@/xfs_scrub']
+		if 'SERVICE_MODE' in os.environ:
+			cmd += '@scrub_service_args@'.split()
+		cmd += '@scrub_args@'.split()
+		if scrub_media:
+			cmd += '-x'
+		cmd += [mnt]
+		self.cmdline = cmd
+		self.proc = None
+
+	def start(self):
+		'''Start xfs_scrub and wait for it to complete.  Returns -1 if
+		the service was not started, 0 if it succeeded, or 1 if it
+		failed.'''
+		try:
+			self.proc = subprocess.Popen(self.cmdline)
+			self.proc.wait()
+		except:
+			return -1
+
+		proc = self.proc
+		self.proc = None
+		return proc.returncode
+
+	def stop(self):
+		'''Stop xfs_scrub.'''
+		if self.proc is not None:
+			self.proc.terminate()
+
+def run_subprocess(mnt, start_media, killfuncs):
 	'''Run a killable program.  Returns program retcode or -1 if we can't
 	start it.'''
 	try:
-		proc = subprocess.Popen(cmd, stdout = stdout)
-		killfuncs.add(proc.terminate)
-		proc.wait()
-		remove_killfunc(killfuncs, proc.terminate)
-		return proc.returncode
+		p = scrub_subprocess(mnt, scrub_media)
+		killfuncs.add(p.stop)
+		ret = p.start()
+		remove_killfunc(killfuncs, p.stop)
+		return ret
 	except:
 		return -1
 
@@ -188,14 +235,7 @@ def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 		# Invoke xfs_scrub manually if we're running in the foreground.
 		# We also permit this if we're running as a cronjob where
 		# systemd services are unavailable.
-		cmd = ['@sbindir@/xfs_scrub']
-		if 'SERVICE_MODE' in os.environ:
-			cmd += '@scrub_service_args@'.split()
-		cmd += '@scrub_args@'.split()
-		if scrub_media:
-			cmd += '-x'
-		cmd += [mnt]
-		ret = run_killable(cmd, None, killfuncs)
+		ret = run_subprocess(mnt, scrub_media, killfuncs)
 		if ret >= 0:
 			print("Scrubbing %s done, (err=%d)" % (mnt, ret))
 			sys.stdout.flush()

