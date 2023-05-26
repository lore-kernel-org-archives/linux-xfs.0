Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02CB0C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235953AbjEZB6P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232880AbjEZB6O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:58:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6FEE7
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:58:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2379364C45
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:58:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E83C433EF;
        Fri, 26 May 2023 01:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066292;
        bh=8jYfsDnGXzB3HlSyqjB/rifVYtxamFjwZiggKDqlTHY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=FNFYEmqgQDZ8RZIJdyuty5I5xsP2Tf3mSjL824BQYiOLLJqFXcqCYVotHFVz7LVek
         s37dPXoUivgKnTTWqahiQ6jkUEXnB3WvFxkyufaSea5Sz8nkPOazDgOa4zGuP4dgj7
         XsVg/LZtFyBeXv21j8qbTWjahLmLuKA/YNGI/AxankLQgP1box0b8H0ZFuEybumJ8C
         W4bEnnXYpF+n+HsmrKe4/D20ih2kE4LTYTN1qzYvqW6cwJMR4j0eZgiDq7+Wt78ES+
         SYnIH+qaLqpZNyg2SQ0q/4S6Kd25YOZbYgG2BAGwhNkxfjp6qf5f67CVSZLpru4dTU
         tKe9KF9sKjkFQ==
Date:   Thu, 25 May 2023 18:58:12 -0700
Subject: [PATCH 2/5] xfs_scrub_all: encapsulate all the systemctl code in an
 object
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506075234.3746473.4940860665627249144.stgit@frogsfrogsfrogs>
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

Move all the systemd service handling code to an object so that we can
contain all the insanity^Wdetails in a single place.  This also makes
the killfuncs handling similar to starting background processes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub_all.in |  113 ++++++++++++++++++++++++++----------------------
 1 file changed, 61 insertions(+), 52 deletions(-)


diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index 0e71cb9ae17..7c8c0baed34 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -149,63 +149,73 @@ def path_to_serviceunit(path, scrub_media):
 		svcname = '@scrub_svcname@'
 	cmd = ['systemd-escape', '--template', svcname, '--path', path]
 
-	try:
-		proc = subprocess.Popen(cmd, stdout = subprocess.PIPE)
-		proc.wait()
-		for line in proc.stdout:
-			return line.decode(sys.stdout.encoding).strip()
-	except:
-		return None
+	proc = subprocess.Popen(cmd, stdout = subprocess.PIPE)
+	proc.wait()
+	for line in proc.stdout:
+		return line.decode(sys.stdout.encoding).strip()
 
-def systemctl_stop(unitname):
-	'''Stop a systemd unit.'''
-	cmd = ['systemctl', 'stop', unitname]
-	x = subprocess.Popen(cmd)
-	x.wait()
+class scrub_service(scrub_control):
+	'''Control object for xfs_scrub systemd service.'''
+	def __init__(self, mnt, scrub_media):
+		self.unitname = path_to_serviceunit(mnt, scrub_media)
 
-def systemctl_start(unitname, killfuncs):
-	'''Start a systemd unit and wait for it to complete.'''
-	stop_fn = None
-	cmd = ['systemctl', 'start', unitname]
-	try:
-		proc = subprocess.Popen(cmd, stdout = DEVNULL())
-		stop_fn = lambda: systemctl_stop(unitname)
-		killfuncs.add(stop_fn)
-		proc.wait()
-		ret = proc.returncode
-	except:
-		if stop_fn is not None:
-			remove_killfunc(killfuncs, stop_fn)
-		return -1
+	def wait(self, interval = 1):
+		'''Wait until the service finishes.'''
 
-	if ret != 1:
-		remove_killfunc(killfuncs, stop_fn)
-		return ret
+		# As of systemd 249, the is-active command returns any of the
+		# following states: active, reloading, inactive, failed,
+		# activating, deactivating, or maintenance.  Apparently these
+		# strings are not localized.
+		while True:
+			try:
+				for l in backtick(['systemctl', 'is-active', self.unitname]):
+					if l == 'failed':
+						return 1
+					if l == 'inactive':
+						return 0
+			except:
+				return -1
 
-	# If systemctl-start returns 1, it's possible that the service failed
-	# or that dbus/systemd restarted and the client program lost its
-	# connection -- according to the systemctl man page, 1 means "unit not
-	# failed".
-	#
-	# Either way, we switch to polling the service status to try to wait
-	# for the service to end.  As of systemd 249, the is-active command
-	# returns any of the following states: active, reloading, inactive,
-	# failed, activating, deactivating, or maintenance.  Apparently these
-	# strings are not localized.
-	while True:
+			time.sleep(interval)
+
+	def start(self):
+		'''Start the service and wait for it to complete.  Returns -1
+		if the service was not started, 0 if it succeeded, or 1 if it
+		failed.'''
+		cmd = ['systemctl', 'start', self.unitname]
 		try:
-			for l in backtick(['systemctl', 'is-active', unitname]):
-				if l == 'failed':
-					remove_killfunc(killfuncs, stop_fn)
-					return 1
-				if l == 'inactive':
-					remove_killfunc(killfuncs, stop_fn)
-					return 0
+			proc = subprocess.Popen(cmd, stdout = DEVNULL())
+			proc.wait()
+			ret = proc.returncode
 		except:
-			remove_killfunc(killfuncs, stop_fn)
 			return -1
 
-		time.sleep(1)
+		if ret != 1:
+			return ret
+
+		# If systemctl-start returns 1, it's possible that the service
+		# failed or that dbus/systemd restarted and the client program
+		# lost its connection -- according to the systemctl man page, 1
+		# means "unit not failed".
+		return self.wait()
+
+	def stop(self):
+		'''Stop the service.'''
+		cmd = ['systemctl', 'stop', self.unitname]
+		x = subprocess.Popen(cmd)
+		x.wait()
+
+def run_service(mnt, scrub_media, killfuncs):
+	'''Run scrub as a service.'''
+	try:
+		svc = scrub_service(mnt, scrub_media)
+	except:
+		return -1
+
+	killfuncs.add(svc.stop)
+	retcode = svc.start()
+	remove_killfunc(killfuncs, svc.stop)
+	return retcode
 
 def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 	'''Run a scrub process.'''
@@ -220,9 +230,8 @@ def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 
 		# Run per-mount systemd xfs_scrub service only if we ourselves
 		# are running as a systemd service.
-		unitname = path_to_serviceunit(path, scrub_media)
-		if unitname is not None and 'SERVICE_MODE' in os.environ:
-			ret = systemctl_start(unitname, killfuncs)
+		if 'SERVICE_MODE' in os.environ:
+			ret = run_service(mnt, scrub_media, killfuncs)
 			if ret == 0 or ret == 1:
 				print("Scrubbing %s done, (err=%d)" % (mnt, ret))
 				sys.stdout.flush()

