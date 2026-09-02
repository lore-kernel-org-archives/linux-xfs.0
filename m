Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AB82BDC1C;
	Wed,  2 Sep 2026 05:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788328112; cv=none; b=E6apqrp/fjfGNamLjHepCWHWRk3wrJGBBP9tZWYdcfVucfJWg/rjmkS1JYhg/s1dHrzUib6P2UV/7W95/uJXjRi4gxLFZwZHoJRm3lDRm0Ogj/pd7DiocJblEXmtrZ0IPSwt+OhgLpqpWiLwX3CvWKPGMT9zyKstbRuU0WAZSV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788328112; c=relaxed/simple;
	bh=1XfRKXOOY2RhkniR3LsZTg3ZYQMOxgAvGOCAx8WCqOQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s0hFXSj8nvh+6r+17yH2wXJ7TsUoILp/sBYE+yHWxn8jqhHpIPznTW27UzgP0F/vueB4lj6y8r9/x5MxqqmLa8bqEbKCAYj8f8ujLZqsK1ESDgyruWpwRjE4XiDamcDDk2V0pIEQnhaLuTf6WtfPTnG7OIptQo9QU7DBYEFkokM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=er0Fo3Z9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="er0Fo3Z9"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 818B01F000E9;
	Wed,  2 Sep 2026 05:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788328110;
	bh=YuiXctfKs30xQWzBOJ2EZsz8ZEnvUQPqUGJpp13XHgY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=er0Fo3Z9Rk5qZWdnFK/9iOic+siuD42fZkE/I3HBugfRSXyNYfPaYpJs6texYS4No
	 i7omo6vAEUQt9bll0QHLn50ROXwW7qS6HE2OyvxSP+eEcu/9z1eGlVfGsGOTV3Jjck
	 V1eKXs7/cSsi6V+fAleGcu/5g2dsFe6g6xUrUQrBtSo6obDY3VUVJzfreN3r5sfyKR
	 K1VUDbTvrlSxosmvMcksIaBYh1nLaYMGonxuJF2wmWk9e7dGA3hyZjvQiMXcQai4BM
	 64xq1oFIzu1WyVti0Igas8atC2duue3Ggz3Fi4gVgdOa9YrLuZCc6vTzH6h1frY3qn
	 g3foK31Dk/vyA==
Date: Tue, 01 Sep 2026 22:48:30 -0700
Subject: [PATCH 8/8] xfs: destroy seen inode bitmap when we fail to add a
 dirpath
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178832750436.3507776.1363060390662374864.stgit@frogsfrogsfrogs>
In-Reply-To: <178832750217.3507776.15975397025387963886.stgit@frogsfrogsfrogs>
References: <178832750217.3507776.15975397025387963886.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM observes a memory leak in xchk_dirtree_create_path if we create
the directory path object but appending the name to the path fails.
When this happens, we don't tear down the (empty) seen inode bitmap.
This is a pretty trivial error, but let's not leave logic bombs.

Do the same for a similar bug in xrep_dirtree_create_adoption_path.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 928b721a11789a ("xfs: teach online scrub to find directory tree structure problems")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/dirtree.c        |    1 +
 fs/xfs/scrub/dirtree_repair.c |    1 +
 2 files changed, 2 insertions(+)


diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
index 717cbac2956238..9b0ab23166124e 100644
--- a/fs/xfs/scrub/dirtree.c
+++ b/fs/xfs/scrub/dirtree.c
@@ -259,6 +259,7 @@ xchk_dirtree_create_path(
 	dl->nr_paths++;
 	return 0;
 out_path:
+	xino_bitmap_destroy(&path->seen_inodes);
 	kfree(path);
 	return error;
 }
diff --git a/fs/xfs/scrub/dirtree_repair.c b/fs/xfs/scrub/dirtree_repair.c
index bbf6acf6fd400c..8acd55b8c7696d 100644
--- a/fs/xfs/scrub/dirtree_repair.c
+++ b/fs/xfs/scrub/dirtree_repair.c
@@ -618,6 +618,7 @@ xrep_dirtree_create_adoption_path(
 	return 0;
 
 out_path:
+	xino_bitmap_destroy(&path->seen_inodes);
 	kfree(path);
 	return error;
 }

