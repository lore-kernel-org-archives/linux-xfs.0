Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3954E34EF0D
	for <linux-xfs@vger.kernel.org>; Thu,  7 May 2026 22:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778191904; cv=none; b=kfLmJ1N71M0+NOkuFwLI1wJYcJ4+kROAKo7loxGpCPvmovEuHzRg7PfKKkyA06J96q0eoG8XfQbBkvJQSYnOvn5X+IzniaPl426yy6NI7fsjO8b5T4ukFWJWKl1xSQtPMIr8zEe05pcW5p7XMVdoh9aHTlEjOueynqlIR+hN8/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778191904; c=relaxed/simple;
	bh=DvT9WxiKTzTR6llOOoxH45bF6jalCRZXgPGJSut2dNM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jAiiB1e7GR6e7wKebQKJVi4Q4FIHl4wD9mPU5Y4NXO2HoJCbxwASBxkmE9+4GKI6QhSmG+ewI1yIAepL6nz6CWztfT6l7iAJo951mAszOngHtie7WDMVgFoRGEqMJthXEW+yyUDgwfxDrWj0oihHha5ljeqbB1OsrOgI0H8qo/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rpmgFhHM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rpmgFhHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4748C2BCB8;
	Thu,  7 May 2026 22:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778191903;
	bh=DvT9WxiKTzTR6llOOoxH45bF6jalCRZXgPGJSut2dNM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rpmgFhHMhV6CkdAeN7e4xSTAEazqDJ7lgetzKdAn1RrZX/iY7zWK9c3vF0NnKdvcj
	 2xlS9YGa6DZD4bskpwMlbn2OVLf4Z7JM1NZrPMVCfVYgGuvuViZCRnL+os45Knasf8
	 CWhQ37t7i2e7yaAJY9bzRLnoTYbBlmUChqlV+bYmsgL+OPkPKBI5EUnp41DIjj0w6P
	 k/6yl4EYwnHtdYOaTrP3VldG4W7GeaZEj9EpP5xpeUnk1U3ZI163RLUtT8rfkVyTOI
	 B6t9IHn/tisqiC8DCOtB/PGlrbqi9D3Lc3ebXTWz0F/C3JyErv1LA++LUCASti1rfl
	 f48+mLrnT2RNw==
Date: Thu, 07 May 2026 15:11:43 -0700
Subject: [PATCH 2/3] xfs_scrub_all: remove dead code
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <177819182677.3486034.15107252496396170007.stgit@frogsfrogsfrogs>
In-Reply-To: <177819182629.3486034.5026297034156212262.stgit@frogsfrogsfrogs>
References: <177819182629.3486034.5026297034156212262.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Remove the unused backtick() function.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/xfs_scrub_all.py.in |    6 ------
 1 file changed, 6 deletions(-)


diff --git a/scrub/xfs_scrub_all.py.in b/scrub/xfs_scrub_all.py.in
index dbb6c36e467d3f..3f618587de8b25 100644
--- a/scrub/xfs_scrub_all.py.in
+++ b/scrub/xfs_scrub_all.py.in
@@ -69,12 +69,6 @@ def find_mounts():
 
 	return fs
 
-def backtick(cmd):
-	'''Generator function that yields lines of a program's stdout.'''
-	p = subprocess.Popen(cmd, stdout = subprocess.PIPE)
-	for line in TextIOWrapper(p.stdout, encoding="utf-8"):
-		yield line.strip()
-
 def remove_killfunc(killfuncs, fn):
 	'''Ensure fn is not in killfuncs.'''
 	try:

