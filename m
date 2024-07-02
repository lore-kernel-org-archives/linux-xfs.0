Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B444D9449
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882485; cv=none; b=IPp90m06zv3noaE6mbR5yKNX54XkJgUZMYjk4Foi61ewNobD0YW8DrvaXIE4aZWrVXfnIOBaTxCVGsvVmCLAPl73xopwVesNk/TKlSdCu05Ln23u0naQ3MyFyhldWgHxcFOsc0mqY/m02jtgEc8wIvoMw22IlT+72KcFRx0OnaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882485; c=relaxed/simple;
	bh=n11NG2CVVQ+P1caIP+uXp/q/qRWmoN6RakwN8CfseUI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HIcftevnkgGrR7qHSPZPej+8o41niiDSu85v5j1cywgRS7rjWgOz52lV0S1uoPfJAa5erMWV12hWBZpAMcU9pjB89L0ctiwWnWwqYwpKOIzHtfskZVdJ3Tqvc3+e5hy0avDFV4DHCcomh6Yr5XGs158uKU0Mf2Ifkk2hww6lyZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qsq42Zh8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qsq42Zh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8541AC116B1;
	Tue,  2 Jul 2024 01:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882485;
	bh=n11NG2CVVQ+P1caIP+uXp/q/qRWmoN6RakwN8CfseUI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qsq42Zh8chH2IhuqxniN39Gmxp1WoMkIt+DXHtIIpSznpU5lSrOI0Zy6jRbzITeX8
	 7cYLG7u2m8+BkjPirriCb/tuTGpanjWseoX2TikUe5lmkxnBsA1o8dMyS5Z/sr4csn
	 UcLBMVwc3XSizWvnu/78/QmYEexlQeXyLiXtlQ1JClzFOXvnAS6/pc/hzuT974AXGX
	 mGd6YQmYYQdAoWgzk6HhpJ/COm2dQwVuB8UUv3EsFwLIH8aUExWKNm0GomNiIIRNhX
	 3aqW33YEFxlKlA0bYwbDt44anY0t0t9GErDNNETfSL2VPMsFpX0pB9Bx0ng+rvu+xD
	 1uiArLkwiaYEA==
Date: Mon, 01 Jul 2024 18:08:05 -0700
Subject: [PATCH 1/5] xfs_scrub_all: encapsulate all the subprocess code in an
 object
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988119829.2008718.8789883453476961638.stgit@frogsfrogsfrogs>
In-Reply-To: <171988119806.2008718.11057954097670233571.stgit@frogsfrogsfrogs>
References: <171988119806.2008718.11057954097670233571.stgit@frogsfrogsfrogs>
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
index 9d5cbd2a6487..001c49a70128 100644
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

