Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED1D2905
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302206; cv=none; b=iV0RGtfeiMQoX+QiyOEN3FyWGLCT6BGr7h/I6QRmWXMijKHyW0tKkyC07Xsgm26w/Y5o4CdKUxOwyHcIcsJCk/bcnsmUdS7eJ1bOmEqKS7XSH50pTpWxvu+I/D/84oLhxYo+oCwanYtOZcjXNwLzYc7SDHeJwB7nWCSqWiQ7i7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302206; c=relaxed/simple;
	bh=PO4ftwcXfIvkvCYKG2HDTwX3XiEF+gneYkuq5ZrVvyg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qTSPXo9sJa+SYhuJvDXDaZTf1B7+Ujs+8scUlDU4nJbyh8Fpv13Rw14x8YuW3rYAxjnqJKJdhxv/deWhVTEhJYVfeL5ZRbI3KPIk2vkm4tdJ46Ro2+LNbG1jM2Vcv31Yu0E6xxYn5q3sj48Vd6SpjT1wKviZGaKbD3R6GrifMpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z4/gumw0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z4/gumw0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FDC8C32786;
	Tue, 30 Jul 2024 01:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302206;
	bh=PO4ftwcXfIvkvCYKG2HDTwX3XiEF+gneYkuq5ZrVvyg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Z4/gumw0GudL4oPyO1BD9oFBJHKXXBoqiWG+gubswux6d0v5HZ/9IIvxCuEcwNY6M
	 IpLYXJK46KJpL25P7/eYMBA82oz1nlmmxei9VIeQfo+/SCj0UGYWA70cVKNEbYTCAA
	 MuM9noUOdJTPJ8VfpSduJDowJJsYM29amSe7hNV26TbpJlFyX8KqchxE2Jntn2kdYX
	 cHPsPLb8IhgwnZxTbc+8mJpgGtzxTJvG6lgLG7GyaKri0uRF+WLnP7SW+WgvVWBQP2
	 vfsKtDg4CGhR17E2tdd9aW6Hoe/1HHbJfNYSeEchyop79/xUV8+dCFdmT5YNVefWMS
	 +Y3HqjtuOE4MA==
Date: Mon, 29 Jul 2024 18:16:45 -0700
Subject: [PATCH 3/5] xfs_scrub_all: add CLI option for easier debugging
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229849688.1350420.1760902598558162682.stgit@frogsfrogsfrogs>
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

Add a new CLI argument to make it easier to figure out what exactly the
program is doing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/xfs_scrub_all.in |   30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)


diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index 4130a98e9..8954b4740 100644
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
 
@@ -266,7 +284,8 @@ def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 
 def signal_scrubs(signum, cond):
 	'''Handle termination signals by killing xfs_scrub children.'''
-	global debug, terminate
+	global debug
+	global terminate
 
 	if debug:
 		print('Signal handler called with signal', signum)
@@ -280,7 +299,8 @@ def signal_scrubs(signum, cond):
 def wait_for_termination(cond, killfuncs):
 	'''Wait for a child thread to terminate.  Returns True if we should
 	abort the program, False otherwise.'''
-	global debug, terminate
+	global debug
+	global terminate
 
 	if debug:
 		print('waiting for threads to terminate')
@@ -371,9 +391,12 @@ def main():
 	global retcode
 	global terminate
 	global scrub_media
+	global debug
 
 	parser = argparse.ArgumentParser( \
 			description = "Scrub all mounted XFS filesystems.")
+	parser.add_argument("--debug", help = "Enabling debugging messages.", \
+			action = "store_true")
 	parser.add_argument("-V", help = "Report version and exit.", \
 			action = "store_true")
 	parser.add_argument("-x", help = "Scrub file data after filesystem metadata.", \
@@ -388,6 +411,9 @@ def main():
 		print("xfs_scrub_all version @pkg_version@")
 		sys.exit(0)
 
+	if args.debug:
+		debug = True
+
 	if args.auto_media_scan_interval is not None:
 		try:
 			scrub_media = enable_automatic_media_scan(args)

