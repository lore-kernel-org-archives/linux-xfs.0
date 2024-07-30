Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39D1442C
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302191; cv=none; b=HYpR+LsqoIR22oxN9/5Ot5eLm+QspB05Ct8hVpHvVMxUi2gW4I6Y/ioHnWHqdnV+wxeKvjwVG6dph1aoPTH6QaVi2JdjPDcGAbCWqKh8tq6Kz0JkZy3LUpr+LuIRpWPT6tWawPG5AfTdnFRsr1joF/Jz5SpqyV5XnvbShsu/fX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302191; c=relaxed/simple;
	bh=egTRFwZF8NBK8I8fU7KpnUUKmbPpjCVrI6RxM+SCekA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ADJotcvgrhbzgPg8mKQDNMePJyo/TygAco7kvKpFzkzY2PeRaz3WDHAjEiIX77XRTA3UbMaHN0oDOkZeLcDkFYk6PKNrd7Oq4NsUv2jgXs5L9C4RX77hKKm5syEdkoIkqi5n7RE4slennmHdnNSINU+5FKKnTMAoHJrs8XHJ0VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K8Kng4wc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K8Kng4wc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C2FC32786;
	Tue, 30 Jul 2024 01:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302190;
	bh=egTRFwZF8NBK8I8fU7KpnUUKmbPpjCVrI6RxM+SCekA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=K8Kng4wcqGSMJOymFRdLs9fD9ObmJ3bHPE641fUDTwIYUiRpHpaXFRziBbYJsSdfd
	 /DWicZZJ8svJRG+HFflCfDOdO2tavgyqLl8rhmbvb9XFfNwzTjj2aLvlbtdAv4GXbs
	 4MHTytIHYiMgMWh4+AvaMjl+EcYu0mfSIMTEQ+BzOdqJYCDwwwmJiBnBHCiyQaOHYf
	 /DWpvRUhO/7ihOn7ATzC4amf23fxYHJM8fmyaviVWD/tOMCQR05+BgBxgdO0fLj9JJ
	 KspssyqVGKFCI+MIzRhlVGIyQntrk201fBXkoX7n5ocTOgpDnWJZl/6jStlzUcfU+N
	 Ja/qfqTKSGJNw==
Date: Mon, 29 Jul 2024 18:16:29 -0700
Subject: [PATCH 2/5] xfs_scrub_all: encapsulate all the systemctl code in an
 object
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229849673.1350420.5830833626781403630.stgit@frogsfrogsfrogs>
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

Move all the systemd service handling code to an object so that we can
contain all the insanity^Wdetails in a single place.  This also makes
the killfuncs handling similar to starting background processes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/xfs_scrub_all.in |  113 ++++++++++++++++++++++++++----------------------
 1 file changed, 61 insertions(+), 52 deletions(-)


diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index 25286f57c..4130a98e9 100644
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
@@ -222,9 +232,8 @@ def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 
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

