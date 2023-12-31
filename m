Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43EBC147
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QG/OTRxx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1519C433C8;
	Sun, 31 Dec 2023 22:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063578;
	bh=7d71vqH+7ginikH15F0uIbA9hxZleh+lyq90D1o7mGc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QG/OTRxxjOYYmJOWGBqS6VweTLWouDR+1dwpXGz6AzYwNd0iNLsg/b6G+hmlilJyq
	 3jxXjH77TW3FU3+FHlpmJlDcICswockc5BSDDEsBx9YkriCFa5fACQTplysvcSL2g7
	 YA1uprI+1K1QwzejDsMiQP1aXU0snFTr7+ys8YnKr6wg62kCE+7nSkTJJHrXA7tKpe
	 OMAZdEXqM+QznAquQgM4GZkmhVy/+/0ZVtZ6oQ40f2xwYQXDUjFG9+qPJZzDxCUeBd
	 FmwsNx/oiWOZ5w9Hq/5wZCESqDdhZKzsYz+t1ZGnNiUtxskD01m563BAgqyEZumyft
	 XYkL9EQCe3JEQ==
Date: Sun, 31 Dec 2023 14:59:38 -0800
Subject: [PATCH 3/5] xfs_scrub_all: add CLI option for easier debugging
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405003389.1801694.15095826476422071443.stgit@frogsfrogsfrogs>
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

Add a new CLI argument to make it easier to figure out what exactly the
program is doing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub_all.in |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)


diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index 09fedff9d96..d5d1d13a255 100644
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

