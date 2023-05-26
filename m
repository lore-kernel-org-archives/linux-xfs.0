Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEEF4C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:58:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbjEZB6a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjEZB6a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:58:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7AD18D
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:58:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFA9264C47
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:58:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17330C433D2;
        Fri, 26 May 2023 01:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066308;
        bh=2Dod8nIEg0CXA6Kvjaq8A0iq5lxveGHRdRLBlKxOVQ8=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=hvs15pF8rnpY34c6BNxoK11R5udzZ1uwKzK0mwRC+0Yo7bX0dWCfcNYS84lZksrYp
         afVX3WVLik3WYOiPm+IVcopS2pykFmTkWAaHkTTgA9oovwiFLgwJF3vIgkE40BpnKN
         z5OG7sXgxOBmTk6RRkd0ty2o1rI5sDI80KTELUoAdIQUhAGMekCtb0SkdVnHK1bBmA
         v1zWSt5oEoW6NWnhPT/CjCP+y8H2RAdlHnmGwfihZ8VuNmBJxQWGor91xeKEKg5Woe
         NSQIqZDGuy9PC9es5ltXDsXGV4dZm0GEa8vSPJEQco2AkTPCQPl+yS+JQ7uxBXl7Wr
         wz38hmgPLz5og==
Date:   Thu, 25 May 2023 18:58:27 -0700
Subject: [PATCH 3/5] xfs_scrub_all: add CLI option for easier debugging
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506075248.3746473.8652547339120157123.stgit@frogsfrogsfrogs>
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

Add a new CLI argument to make it easier to figure out what exactly the
program is doing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub_all.in |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)


diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index 7c8c0baed34..a2b3350fe87 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -24,6 +24,7 @@ from datetime import timezone
 retcode = 0
 terminate = False
 scrub_media = False
+debug = False
 
 def DEVNULL():
 	'''Return /dev/null in subprocess writable format.'''
@@ -110,6 +111,11 @@ class scrub_subprocess(scrub_control):
 		'''Start xfs_scrub and wait for it to complete.  Returns -1 if
 		the service was not started, 0 if it succeeded, or 1 if it
 		failed.'''
+		global debug
+
+		if debug:
+			print('run ', ' '.join(self.cmdline))
+
 		try:
 			self.proc = subprocess.Popen(self.cmdline)
 			self.proc.wait()
@@ -122,6 +128,10 @@ class scrub_subprocess(scrub_control):
 
 	def stop(self):
 		'''Stop xfs_scrub.'''
+		global debug
+
+		if debug:
+			print('kill ', ' '.join(self.cmdline))
 		if self.proc is not None:
 			self.proc.terminate()
 
@@ -182,8 +192,12 @@ class scrub_service(scrub_control):
 		'''Start the service and wait for it to complete.  Returns -1
 		if the service was not started, 0 if it succeeded, or 1 if it
 		failed.'''
+		global debug
+
 		cmd = ['systemctl', 'start', self.unitname]
 		try:
+			if debug:
+				print(' '.join(cmd))
 			proc = subprocess.Popen(cmd, stdout = DEVNULL())
 			proc.wait()
 			ret = proc.returncode
@@ -201,7 +215,11 @@ class scrub_service(scrub_control):
 
 	def stop(self):
 		'''Stop the service.'''
+		global debug
+
 		cmd = ['systemctl', 'stop', self.unitname]
+		if debug:
+			print(' '.join(cmd))
 		x = subprocess.Popen(cmd)
 		x.wait()
 
@@ -366,10 +384,12 @@ def main():
 		a = (mnt, cond, running_devs, devs, killfuncs)
 		thr = threading.Thread(target = run_scrub, args = a)
 		thr.start()
-	global retcode, terminate, scrub_media
+	global retcode, terminate, scrub_media, debug
 
 	parser = argparse.ArgumentParser( \
 			description = "Scrub all mounted XFS filesystems.")
+	parser.add_argument("--debug", help = "Enabling debugging messages.", \
+			action = "store_true")
 	parser.add_argument("-V", help = "Report version and exit.", \
 			action = "store_true")
 	parser.add_argument("-x", help = "Scrub file data after filesystem metadata.", \
@@ -384,6 +404,9 @@ def main():
 		print("xfs_scrub_all version @pkg_version@")
 		sys.exit(0)
 
+	if args.debug:
+		debug = True
+
 	if args.auto_media_scan_interval is not None:
 		try:
 			scrub_media = enable_automatic_media_scan(args)

