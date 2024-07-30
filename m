Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2888928EB
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302175; cv=none; b=nITHZ4tofyiyiFBmD5j5P04ERqWBuP/hu3Tjt7gjqHQEvhlEWTNWzk0duE/hr8X5ltmssBV/802jdGpETOPbybqJbEWeBT3KEZPspg9OvZc6jawtDdFP5PTzIsQQbrtRKKBMvTsg0o77XpvBGRRT1wuyKUH2QUF+5zLfsIRBOZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302175; c=relaxed/simple;
	bh=z9zEh0ewYiSURzD+RYvb6UV2Vh2tVO19xkyd/drxtw4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UJ+vDESv4GKtoNnUZjulREX/CdHJ78EZkj+5u7FRAFojsfIPMAhG2Ke13JoTpgI8WgdV+7fQPtaleCnNvT7WIdZKEbF076W1rXzdgkH0V7iTuw5xl4sw84XYoSgjyuaWrH0Vz/t7eb5Ub5hbMW3ZXc7ooSIWoJQHNkxP+MutWJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CwrrzDuD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CwrrzDuD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF4FC4AF07;
	Tue, 30 Jul 2024 01:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302174;
	bh=z9zEh0ewYiSURzD+RYvb6UV2Vh2tVO19xkyd/drxtw4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CwrrzDuDZGa8mFmC+Y6K84GaBEt/XySmsQqnwBL0ymulyI/z5d1Ea2Mr2OBhIRSuq
	 ASvvG85SRX4uNpKhoxQZ8f1B874hoK8vImC7jV/zk84qyF5NsMzktH0z3xFjCvy04Q
	 /wa53ZvSP/gBiRZifK1C2mEKABxzvuhrqg4BkRbu+NZ2R2Ht6Hv/x1DFwOFlsc6Lg1
	 XGmYPg1P3KnCf7bybtQmvA+7fjxr58HNSHWYAoXGrlLySJZLVOaqF5btb4iSO6lGls
	 u9HAFS+LOjlnKYZ0Gmca8JOEnN7sh64nth/EByAlfmz4H+tPk/e+h4ln1fCA/RKxHw
	 omJnyR6MWnBag==
Date: Mon, 29 Jul 2024 18:16:14 -0700
Subject: [PATCH 1/5] xfs_scrub_all: encapsulate all the subprocess code in an
 object
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229849658.1350420.7261977076960290061.stgit@frogsfrogsfrogs>
In-Reply-To: <172229849638.1350420.756131243612881227.stgit@frogsfrogsfrogs>
References: <172229849638.1350420.756131243612881227.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/xfs_scrub_all.in |   68 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 54 insertions(+), 14 deletions(-)


diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index 9dd6347fb..25286f57c 100644
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
 
@@ -190,14 +237,7 @@ def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
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

