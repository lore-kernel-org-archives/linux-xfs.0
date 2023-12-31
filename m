Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508C6C140
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IlIHKDk0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE1FC433C7;
	Sun, 31 Dec 2023 22:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063344;
	bh=J0TA7YIL/gvm/xZYXcrJpDm8PpDM7j343nSoKhEVwQY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IlIHKDk0sIINJ30OiVr/5jcqe991MrE+RpILvjEsQ0LEBU4FgSQAsJFMAtYuwJer7
	 25+ra8svJbGxnYWvCoQAI793CpKcVxUR/pKPchum3MRR/gOh0/LBF8oM2EubyyHhcu
	 JG5o+cPZ+llu61TokaLCReYRXUYQWeqN/XXaTQ3AfN2WBqBY/XwhQAN7L3nDTK6PlV
	 ZiiXSua6ZIe/gY7AjkH+3L68H8LWIAuZYhv0yDlYqebzX9WPrmglsN5XPNy2FvxJQ6
	 kRKbVgejw71HO4NGckVEYJ+H0BnPpgP799vzafnbT16nApST59ei8c9mwQQ9iva/1j
	 fyy4sGmdNBEQg==
Date: Sun, 31 Dec 2023 14:55:43 -0800
Subject: [PATCH 4/4] xfs_scrub_all: fix termination signal handling
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170405002308.1801148.15910170825443227332.stgit@frogsfrogsfrogs>
In-Reply-To: <170405002254.1801148.6324602186356936873.stgit@frogsfrogsfrogs>
References: <170405002254.1801148.6324602186356936873.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/xfs_scrub_all.in |   64 +++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 52 insertions(+), 12 deletions(-)


diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index 2c20b91fdbe..d0ab27fd306 100644
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

