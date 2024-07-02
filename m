Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998989449
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882501; cv=none; b=Ho3drTvg7hB/889EvPpI+oC+dx++EPMkG6Mk+qnPzdmACbVoyrrlmYdvvUfPvEVX4sT5yhOCEXWHKUPWRGlRyLlGv9HlPibxJo46MbtTFDVj/EW2BFwWvKEaMjvCWegFDfxW0YNqFQfLdo7JhY7GUa1gT4YmxmoTl8Ulc+XdLOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882501; c=relaxed/simple;
	bh=VteR6AAXsaSg/2sn6ntpPDot/EyOk5hjzMM8Iz/MnGg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LsGlDdGFpVxS0v+wxBujJEcU2UV4CCOipAMVYMEg5qmN6gpPCETZw1D1vJkAL2Z+Unbj3RHB+7u9XcWwSJWZc5w4w+omJtuHgmgnkEee5r0Z9oPRXu2lZ74fcGCw8DuVz8sygEahWKVCu9kDSveT58g8uVgIuVB10qgJg/wW23c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nIuTvDE8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nIuTvDE8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27176C116B1;
	Tue,  2 Jul 2024 01:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882501;
	bh=VteR6AAXsaSg/2sn6ntpPDot/EyOk5hjzMM8Iz/MnGg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nIuTvDE8Ep8Gc9k6LQ1nMfxZaVpWhfX93LCVcyOSOa1gZhR1p7xJdJe9rdtar8aAL
	 KeR+mL+P3v1A0GK8aNLE3SiyEcqzKh0UvAgaZryBzFYkSpfP4WCuzOLG5IU+uk+n/m
	 yOIr5cJl5iX8tPuTInklpVVEUeEafHTJpyw6vd9IbWflEK7MjNzN/2tD0vgFDTPv1z
	 7bh1jvjWj8paBDqT4teu5FmImDRh44rF4CgeCRO5AK4DyJuVh4DwCVYl4+/Z+27kWO
	 //1JNm4qcD+TbJF1P4n0gqTrSzJCIlBI36vib3u8LHn38bGcLzUbASKQ06MGCKRt1w
	 JZCVB0AryY0xA==
Date: Mon, 01 Jul 2024 18:08:20 -0700
Subject: [PATCH 2/5] xfs_scrub_all: encapsulate all the systemctl code in an
 object
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988119844.2008718.7103597112377556797.stgit@frogsfrogsfrogs>
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

Move all the systemd service handling code to an object so that we can
contain all the insanity^Wdetails in a single place.  This also makes
the killfuncs handling similar to starting background processes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub_all.in |  113 ++++++++++++++++++++++++++----------------------
 1 file changed, 61 insertions(+), 52 deletions(-)


diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index 001c49a70128..09fedff9d965 100644
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

