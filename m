Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6819449
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882517; cv=none; b=bFGJK1yNyBlRNuq6pkEqeBd9psXMd86mode3q21YqmIog+4HS+0RyZQ2f/XtnQOQmRPzMqW3/XRNdGHkAU29QfS8wYt9mKplWVS01fU8FmxVCbPtppwvAzugV0Hu6DnE1CKqjNofhj3E7tIcxVacVP/yeMSmlooF0Ov2RbXpJTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882517; c=relaxed/simple;
	bh=XaMRSo9Pz7LYMXTUPvlmu4Q5q5M1jtivMOSW50j5xKI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LJhyVgT9oa0EyOPH5fYaYBifceBIKqooFE1UVFCE4qZ1gfHKt+pNLA1eSptZcn8lEK4UoFCPtKD46L9pgtKyT3wJneXeuL70uTN91mpN3/+lPuJxwzd476Wa8ooTG+5tg/50vMY1D7RLnKydvxvEOy80/BiDJ4HSk6njEidXUqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k7eNk+ze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k7eNk+ze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7264C116B1;
	Tue,  2 Jul 2024 01:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882516;
	bh=XaMRSo9Pz7LYMXTUPvlmu4Q5q5M1jtivMOSW50j5xKI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=k7eNk+zeJroJSTIqZtx/7mR7baaB4szABPma1W/08mlEVwHVLETxvl0CP7desOy8u
	 MqH4kiFIxIHLxSBqjNCQ4qO4531s1jDSQzMnTDWSG/vzUCZEKRsqVMMtNdw48N7aoN
	 6qy5ngPlyW967F4blaBi78dR3ARMH7N8w064guu47A01JrzEfCjcvuUMVFppfBryWd
	 b6OP2m0/B0nfG5R0WaMTe9s33BCB3B845pQyShzHm6iUAJEpVS1Rvt+vrsPCTTxyAO
	 nkyV1qpZoiLvhtyHnlLBaMf1r3Nfwnqu0j1Hs/27dgBweheN11ia7bv3w8OSJR4Rw0
	 +i/dE5sHIzu8w==
Date: Mon, 01 Jul 2024 18:08:36 -0700
Subject: [PATCH 3/5] xfs_scrub_all: add CLI option for easier debugging
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988119860.2008718.3789689429042344225.stgit@frogsfrogsfrogs>
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

Add a new CLI argument to make it easier to figure out what exactly the
program is doing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub_all.in |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)


diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index 09fedff9d965..d5d1d13a2552 100644
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

