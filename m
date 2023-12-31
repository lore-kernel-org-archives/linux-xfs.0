Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA748C140
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TkF+mOF6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5065AC433C7;
	Sun, 31 Dec 2023 22:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063547;
	bh=4tP+3YkpxHi2KRbeJaJmtbUvGwfCwKN/PA9esTXHFV4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TkF+mOF6rwjZEECqZ/R52LQNMNbknkNhkxxXxVPb2UmtxZS33v9bCFP1V1YbKFXrn
	 xEeX2Pmb+j0K5V2LQNEAxfoXRg4j3QswA+6ee8AehMAVgvfQgIUYJWVI8sQL5YJweb
	 WCxUa+oryD7DcPIzqM6Qk8b+nHqHzxzRLE+/QyQzgRILXG36bHHG33krcjTuK/sDdU
	 r/j+o0gRqndr7pBq70JpYESDKvLDOun2Pl+74OJ73DyLOZdjENG05jh65cHPhO/j3R
	 JWuetbaarKCFRovV+q01YiEwY3g6YzjYS0OaBpYUzvLux8FomLSY5fVeMTF76exCgH
	 xGZ+iC0IrBIUA==
Date: Sun, 31 Dec 2023 14:59:06 -0800
Subject: [PATCH 1/5] xfs_scrub_all: encapsulate all the subprocess code in an
 object
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405003363.1801694.12866688345417241571.stgit@frogsfrogsfrogs>
In-Reply-To: <170405003347.1801694.9862582977773516679.stgit@frogsfrogsfrogs>
References: <170405003347.1801694.9862582977773516679.stgit@frogsfrogsfrogs>
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

Move all the xfs_scrub subprocess handling code to an object so that we
can contain all the details in a single place.  This also simplifies the
background state management.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub_all.in |   68 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 54 insertions(+), 14 deletions(-)


diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index 9d5cbd2a648..001c49a7012 100644
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
+def run_subprocess(mnt, scrub_media, killfuncs):
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

