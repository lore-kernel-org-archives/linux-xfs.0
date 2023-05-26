Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC025C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:55:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241937AbjEZBzD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234071AbjEZByt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:54:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAEF6E7
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:54:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40E3464C47
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:54:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD6CC433D2;
        Fri, 26 May 2023 01:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066087;
        bh=ditBuLlVzwd6tHJIxbtQFiSYprK5aupkmnK9OTONOZ4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=pDeqLxt8LLuT5Kj4GuejZetZCsklQuOqcmXjj+eSCo8xd7Um5AufFaakPU4wg3Heb
         +3h297rqAZ2d4M59tS37naUIbDu5n/puQgJ8xAtPn1iCvU00EWA695o6bcCgfd5pdw
         84YEkk5e/mgy9KR/XWkXi+pDWLNzI9qm+uoI3oj8isk0osjAxlaR2q9JZTLK3+g4Ah
         FIdRokgP1nrLGXVU5lJZjZgZ0r6iEZNzzvyfgI0TSACf7mfrcb1AQ8WBWh/T3DS9FM
         bpGXz6af0NtqN/TN5z2cxvye4HbEdvdaHZQFujeYw0cmf33IoTC0r6i+nRNkK+Eqxw
         4IqvhSQ0Uclxg==
Date:   Thu, 25 May 2023 18:54:47 -0700
Subject: [PATCH 4/4] xfs_scrub_all: fix termination signal handling
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506074230.3745941.8641878326182644758.stgit@frogsfrogsfrogs>
In-Reply-To: <168506074176.3745941.5054006111815853213.stgit@frogsfrogsfrogs>
References: <168506074176.3745941.5054006111815853213.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Currently, xfs_scrub_all does not handle termination signals well.
SIGTERM and SIGINT are left to their default handlers, which are
immediate termination of the process group in the case of SIGTERM and
raising KeyboardInterrupt in the case of SIGINT.

Terminating the process group is fine when the xfs_scrub processes are
direct children, but this completely doesn't work if we're farming the
work out to systemd services since we don't terminate the child service.
Instead, they keep going.

Raising KeyboardInterrupt doesn't work because once the main thread
calls sys.exit at the bottom of main(), it blocks in the python runtime
waiting for child threads to terminate.  There's no longer any context
to handle an exception, so the signal is ignored and no child processes
are killed.

In other words, if you try to kill a running xfs_scrub_all, chances are
good it won't kill the child xfs_scrub processes.  This is undesirable
and egregious since we actually have the ability to track and kill all
the subprocesses that we create.

Solve the subproblem of getting stuck in the python runtime by calling
it repeatedly until we no longer have subprocesses.  This means that the
main thread loops until all threads have exited.

Solve the subproblem of the signals doing the wrong thing by setting up
our own signal handler that can wake up the main thread and initiate
subprocess shutdown, no matter whether the subprocesses are systemd
services or directly fork/exec'd.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub_all.in |   64 +++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 52 insertions(+), 12 deletions(-)


diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index 0cf67b80d68..11189c3ee10 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -14,6 +14,7 @@ import time
 import sys
 import os
 import argparse
+import signal
 from io import TextIOWrapper
 
 retcode = 0
@@ -196,6 +197,45 @@ def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 		cond.notify()
 		cond.release()
 
+def signal_scrubs(signum, cond):
+	'''Handle termination signals by killing xfs_scrub children.'''
+	global debug, terminate
+
+	if debug:
+		print('Signal handler called with signal', signum)
+		sys.stdout.flush()
+
+	terminate = True
+	cond.acquire()
+	cond.notify()
+	cond.release()
+
+def wait_for_termination(cond, killfuncs):
+	'''Wait for a child thread to terminate.  Returns True if we should
+	abort the program, False otherwise.'''
+	global debug, terminate
+
+	if debug:
+		print('waiting for threads to terminate')
+		sys.stdout.flush()
+
+	cond.acquire()
+	try:
+		cond.wait()
+	except KeyboardInterrupt:
+		terminate = True
+	cond.release()
+
+	if not terminate:
+		return False
+
+	print("Terminating...")
+	sys.stdout.flush()
+	while len(killfuncs) > 0:
+		fn = killfuncs.pop()
+		fn()
+	return True
+
 def main():
 	'''Find mounts, schedule scrub runs.'''
 	def thr(mnt, devs):
@@ -231,6 +271,10 @@ def main():
 	running_devs = set()
 	killfuncs = set()
 	cond = threading.Condition()
+
+	signal.signal(signal.SIGINT, lambda s, f: signal_scrubs(s, cond))
+	signal.signal(signal.SIGTERM, lambda s, f: signal_scrubs(s, cond))
+
 	while len(fs) > 0:
 		if len(running_devs) == 0:
 			mnt, devs = fs.popitem()
@@ -250,18 +294,14 @@ def main():
 				thr(mnt, devs)
 		for p in poppers:
 			fs.pop(p)
-		cond.acquire()
-		try:
-			cond.wait()
-		except KeyboardInterrupt:
-			terminate = True
-			print("Terminating...")
-			sys.stdout.flush()
-			while len(killfuncs) > 0:
-				fn = killfuncs.pop()
-				fn()
-			fs = []
-		cond.release()
+
+		# Wait for one thread to finish
+		if wait_for_termination(cond, killfuncs):
+			break
+
+	# Wait for the rest of the threads to finish
+	while len(killfuncs) > 0:
+		wait_for_termination(cond, killfuncs)
 
 	if journalthread is not None:
 		journalthread.terminate()

