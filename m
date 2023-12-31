Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3FCC140
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZSocd9+V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA31C433C8;
	Sun, 31 Dec 2023 22:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063328;
	bh=GVaXoHC9qDBvzS4qj+NhDzU+Ho4ZTsInEsTYURJa/AE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZSocd9+V+LC4ZckYH836oyhi/noUEpe+w4hWrx5KQ/ssgHoC93vcIzxKZ4/uJ/c5C
	 9OqGT/9pZyyedo396z/5v6YttT3ThaFaeOyGVlAX5T8t2SAHyfUZJ+j1hWjWVArDF6
	 54qU7t1KN0n9w3c8QRsX7qFwkIKJYg2oe6agjONCYsl0gApyMJ8aSU0LdHMkljpsxT
	 OPElopLObWbRkeHSfvs/EyNDAZMh6C/sxiYk7CcFDZH9dKp7hwunuNCWZYjlg0KfmE
	 YoE9P4oboSCbWMtt7YYxfmhuytph99FGNblrV4kVec/L90FjEXPtA3hk9QEXrcaMVs
	 EGVIH2NdwzBwg==
Date: Sun, 31 Dec 2023 14:55:28 -0800
Subject: [PATCH 3/4] xfs_scrub_all: simplify cleanup of run_killable
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170405002295.1801148.14170763288665409996.stgit@frogsfrogsfrogs>
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

Get rid of the nested lambda functions to simplify the code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/xfs_scrub_all.in |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)


diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index ab9b491fb4e..2c20b91fdbe 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -72,14 +72,14 @@ def remove_killfunc(killfuncs, fn):
 	except:
 		pass
 
-def run_killable(cmd, stdout, killfuncs, kill_fn):
-	'''Run a killable program.  Returns program retcode or -1 if we can't start it.'''
+def run_killable(cmd, stdout, killfuncs):
+	'''Run a killable program.  Returns program retcode or -1 if we can't
+	start it.'''
 	try:
 		proc = subprocess.Popen(cmd, stdout = stdout)
-		real_kill_fn = lambda: kill_fn(proc)
-		killfuncs.add(real_kill_fn)
+		killfuncs.add(proc.terminate)
 		proc.wait()
-		remove_killfunc(killfuncs, real_kill_fn)
+		remove_killfunc(killfuncs, proc.terminate)
 		return proc.returncode
 	except:
 		return -1
@@ -178,8 +178,7 @@ def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 		cmd = ['@sbindir@/xfs_scrub']
 		cmd += '@scrub_args@'.split()
 		cmd += [mnt]
-		ret = run_killable(cmd, None, killfuncs, \
-				lambda proc: proc.terminate())
+		ret = run_killable(cmd, None, killfuncs)
 		if ret >= 0:
 			print("Scrubbing %s done, (err=%d)" % (mnt, ret))
 			sys.stdout.flush()

