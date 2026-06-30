Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95CF17B506
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 01:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782781454; cv=none; b=Yt81sgwNhWtnkSj2zRW4dRLGxoBaDxipThIQro+YrN6dQ2uXiLNJjEcTzULzoMrXhNOoHowj/8ll7LsOkSx28UsJ8BcO8sloTVOnBZDEQj9K3NHFehpmaS9ZeCTdZWEO4N5iOEP4hnbePBuXGr60rMQ5+/9pmFJOw2fbP9SCjsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782781454; c=relaxed/simple;
	bh=S+phkKHfBAamAGhPGlutPSOMLM1W7CdQeGTyOVGWm4A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AIwghGVUpLZkjzXHTl5874rESEcJaB9TbEGbN7pRx3rtOtMo30vmkkZvdos6o7AvP35MbDcIo2NHhpNet8hwJJvoUK7mSGDS12dlq8xHYdhki4JIjK2nXCjaIyTvxbI1vWCxY2UG5ub/AoEYMlgXUE9tmRPLrTFsEGvlkvhTy/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dFKvNKwj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dFKvNKwj"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 583601F00A3E;
	Tue, 30 Jun 2026 01:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782781453;
	bh=bib+QUNpoBUfQnH3pAuQQMmIH45i395oZcKzZ2LeW6U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=dFKvNKwj3c6xtoHIIsxBjmBvR5ac7KBOgJq0x7LTHAhh495/ne+G/xaXSSg+uTVX0
	 GyHSPc5VFVjMEVjobkNf3BXS/LBaP90FlvRF+te5am2gTIZOBPBKNkzwR1SBrYb7SF
	 ywqiKiWCXlfubRLZokFtP97Db3+VN4jHNtVCGPBjNfqWjv2L6hn0saHjdQyum6+7Pj
	 CQIJJ6eVmj/ddxHw0rcrXCe+q97xTMpdM0XxRxPdBp1xVHSMwtIA3Y7vtPOVZ5NSD5
	 CkbBpHmKiTQxKRKdAKjchpmnwvYvz3N90vJGNcmuWA1clWmHBusRmq5krGpOwmS80/
	 084KPgesDUgdg==
Date: Mon, 29 Jun 2026 18:04:13 -0700
Subject: [PATCH 6/6] xfs_protofile: make nondirectory arguments actually work
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178278129917.858323.1796085077986094685.stgit@frogsfrogsfrogs>
In-Reply-To: <178278129779.858323.3184159030321473775.stgit@frogsfrogsfrogs>
References: <178278129779.858323.3184159030321473775.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Codex points out that xfs_protofile fails if you pass it paths to
non-directories.  It's supposed to just copy them into the root
directory, but we don't actually do that.

Cc: <linux-xfs@vger.kernel.org> # v6.13.0
Fixes: 6aace700b7b82d ("mkfs: add a utility to generate protofiles")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/xfs_protofile.py.in |   40 +++++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 15 deletions(-)


diff --git a/mkfs/xfs_protofile.py.in b/mkfs/xfs_protofile.py.in
index 40d06ddb44aa30..00010fa7b3b041 100644
--- a/mkfs/xfs_protofile.py.in
+++ b/mkfs/xfs_protofile.py.in
@@ -66,46 +66,56 @@ def max_fname_len(s1):
 	'''Return the length of the longest string in s1.'''
 	ret = 0
 	for s in s1:
+		ss = os.path.basename(s)
 		if len(s) > ret:
 			ret = len(s)
 	return ret
 
+def list_maybe_dir(path, depth):
+	try:
+		for fname in os.listdir(path):
+			yield os.path.join(path, fname)
+	except NotADirectoryError as e:
+		if depth == 1:
+			yield path
+			return
+		raise e
+
 def walk_tree(path, depth):
 	'''Walk the directory tree rooted by path.'''
 	dirs = []
 	files = []
 
-	for fname in os.listdir(path):
-		fullpath = os.path.join(path, fname)
+	for fullpath in list_maybe_dir(path, depth):
 		sb = os.lstat(fullpath)
 
 		if stat.S_ISDIR(sb.st_mode):
-			dirs.append(fname)
+			dirs.append(fullpath)
 			continue
 		elif stat.S_ISSOCK(sb.st_mode):
 			continue
 		else:
-			files.append(fname)
+			files.append(fullpath)
 
-	for fname in files:
-		if ' ' in fname:
+	for fullpath in files:
+		if ' ' in os.path.basename(fullpath):
 			msg = _("Spaces not allowed in file names.")
-			raise ValueError(f'{fname}: {msg}')
-	for fname in dirs:
-		if ' ' in fname:
+			raise ValueError(f'{fullpath}: {msg}')
+	for fullpath in dirs:
+		if ' ' in os.path.basename(fullpath):
 			msg = _("Spaces not allowed in subdirectory names.")
-			raise Exception(f'{fname}: {msg}')
+			raise Exception(f'{fullpath}: {msg}')
 
 	fname_width = max_fname_len(files)
-	for fname in files:
-		fullpath = os.path.join(path, fname)
+	for fullpath in files:
+		fname = os.path.basename(fullpath)
 		sb = os.lstat(fullpath)
 		extra = stat_to_extra(sb, fullpath)
 		print('%*s%-*s %s%s' % (depth, ' ', fname_width, fname, \
 				stat_to_str(sb), extra))
 
-	for fname in dirs:
-		fullpath = os.path.join(path, fname)
+	for fullpath in dirs:
+		fname = os.path.basename(fullpath)
 		sb = os.lstat(fullpath)
 		extra = stat_to_extra(sb, fullpath)
 		print('%*s%s %s' % (depth, ' ', fname, \
@@ -138,7 +148,7 @@ def main():
 		# Copy the first argument's stat to the rootdir
 		statbuf = os.stat(args.paths[0])
 		if not stat.S_ISDIR(statbuf.st_mode):
-			raise NotADirectoryError(path)
+			raise NotADirectoryError(args.paths[0])
 		print(stat_to_str(statbuf))
 
 		# All files under each path go in the root dir, recursively

