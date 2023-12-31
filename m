Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96185C13B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KRqkluKn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D3DC433C8;
	Sun, 31 Dec 2023 22:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063172;
	bh=nh94gu9XwoEkJScPh67zgk6Llz9kW9aZQJkyKIj2za8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KRqkluKn9Flh/BNRoDTH4EzuyRfGdAKzdu/QtX87lTY9ghOj3lNfUdaVNHVwVcktv
	 xZfFqAX17N17CMZIlNc6AhwlqSbpUJqnfIr8BLKliJtEQ1wX1CuSyelphKrP7zg4ie
	 X+gFErTWTKRdUqdN6mogkfHPOcUN88ejDo5WEUh8da1EfOiFjYB2iH7J9xRUKb+R+A
	 DPHxWwQaAZ82rhow6u5ai4g1KyWS7Ot8DGtciHd0WfYyv5oOk8/MB5xeBZEYxa6Ewy
	 1qFm8Q6xKYr1VFmzNQE+uW8yGW/pWUu+nbbs5tbp3F7wBgUe/tDcAzlfn38Bg18iBD
	 jT6nuppLv1wVg==
Date: Sun, 31 Dec 2023 14:52:51 -0800
Subject: [PATCH 2/9] xfs_scrub_all: escape service names consistently
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170405001872.1800712.4585841935852644225.stgit@frogsfrogsfrogs>
In-Reply-To: <170405001841.1800712.6745668619742020884.stgit@frogsfrogsfrogs>
References: <170405001841.1800712.6745668619742020884.stgit@frogsfrogsfrogs>
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

This program is not consistent as to whether or not it escapes the
pathname that is being used as the xfs_scrub service instance name.
Fix it to be consistent, and to fall back to direct invocation if
escaping doesn't work.  The escaping itself is also broken, but we'll
fix that in the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/xfs_scrub_all.in |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)


diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index 5042321a738..85f95f135cc 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -93,19 +93,19 @@ def run_killable(cmd, stdout, killfuncs, kill_fn):
 # that log messages from the service units preserve the full path and users can
 # look up log messages using full paths.  However, for "/" the escaping rules
 # do /not/ drop the initial slash, so we have to special-case that here.
-def systemd_escape(path):
+def path_to_service(path):
 	'''Escape a path to avoid mangled systemd mangling.'''
 
 	if path == '/':
-		return '-'
+		return 'xfs_scrub@-'
 	cmd = ['systemd-escape', '--path', path]
 	try:
 		proc = subprocess.Popen(cmd, stdout = subprocess.PIPE)
 		proc.wait()
 		for line in proc.stdout:
-			return '-' + line.decode(sys.stdout.encoding).strip()
+			return 'xfs_scrub@-%s' % line.decode(sys.stdout.encoding).strip()
 	except:
-		return path
+		return None
 
 def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 	'''Run a scrub process.'''
@@ -119,17 +119,19 @@ def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 			return
 
 		# Try it the systemd way
-		cmd=['systemctl', 'start', 'xfs_scrub@%s' % systemd_escape(mnt)]
-		ret = run_killable(cmd, DEVNULL(), killfuncs, \
-				lambda proc: kill_systemd('xfs_scrub@%s' % mnt, proc))
-		if ret == 0 or ret == 1:
-			print("Scrubbing %s done, (err=%d)" % (mnt, ret))
-			sys.stdout.flush()
-			retcode |= ret
-			return
+		svcname = path_to_service(path)
+		if svcname is not None:
+			cmd=['systemctl', 'start', svcname]
+			ret = run_killable(cmd, DEVNULL(), killfuncs, \
+					lambda proc: kill_systemd(svcname, proc))
+			if ret == 0 or ret == 1:
+				print("Scrubbing %s done, (err=%d)" % (mnt, ret))
+				sys.stdout.flush()
+				retcode |= ret
+				return
 
-		if terminate:
-			return
+			if terminate:
+				return
 
 		# Invoke xfs_scrub manually
 		cmd=['@sbindir@/xfs_scrub', '@scrub_args@', mnt]

