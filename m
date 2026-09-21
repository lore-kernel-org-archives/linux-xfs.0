Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FBE364940
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 06:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789971269; cv=none; b=I0iehTIK1kxRiOac+eKG0T/iyhU3ENmAumlfM0l1Otnkr6qUvdAD+Ay8SN3QTrPjnTI6wnEbCw1YUsxkjAnzQ+j7uq+3k28atvHyb8gvt0QYL8MTi1OOD98U4fh1IJtfIVqlhtnLfjOq+UwCX+hsS9qEqS1Oc4JucCoIoZZW2t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789971269; c=relaxed/simple;
	bh=bOU7otBhU4XUtM3E75XAwckKDGfeOxPTi2lGtfzyks4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ld/LJsZ17CAblhwq9uBy50sqU92hz+4W2KTE1mYU17sj6pf056rEPNsEoPwqkCi3NUapnCGew0ETqaI5/1INGWiNw71hFezfNLH0Fi7TrlxNqrqGiscpSGC6XqNYOofs8sOHbomm3uKXeSvYoaAgaWhOqmtEpdlkvTf0IkGGyHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T47lNEP8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T47lNEP8"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id F3DA91F000FF;
	Mon, 21 Sep 2026 06:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789971268;
	bh=X+NfsOcxCTrmN2KGVFJZ7JoIoyj2J7j1uW0UG7H/Fno=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=T47lNEP8qZ1tC2HNc2irlM+6JLZobvWayaTId2vILkS6VVg3gQRzAYIAy3jeuWFh8
	 MRYWmrqKqCgfBzQktuLDXEGUc4sVBIF1HmE8lmNmGxsZnIlHReb5AfIHvYaILyMd+5
	 vY2Jy+dapAupsgK9v4BNUvsbdzGlNEtS3cxToqho94+bXMa7sqGs4ivbsD0lwwOage
	 obDD8hnPBhc1JwvJu/7smureHfFtLALYbfO9Ipzj6oJmmk/xwkTnXRMkWQ3OSuZ82N
	 SA8bVuX8CkImdBQAkPZAtE4qC56knKw5kViuJSMcK4yEgKZv0V/aAJ9NkKIA0iQyAd
	 +aHmpcm0KWexw==
Date: Sun, 20 Sep 2026 23:14:27 -0700
Subject: [PATCH 3/3] xfs_quota: fix XFS_GETQSTAT parameter pointer
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178996057694.169604.2071446642858108847.stgit@frogsfrogsfrogs>
In-Reply-To: <178996057628.169604.16261952311237371422.stgit@frogsfrogsfrogs>
References: <178996057628.169604.16261952311237371422.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that XFS_GETQSTAT is supposed to take a pointer to a
struct fs_quota_stat, not a struct fs_quota_statv.  However, quotactl
call throws away all such nuance by accepting any void pointer, so this
got broken by the recent refactoring.  Fix all that.

Cc: <linux-xfs@vger.kernel.org> # v7.2.0
Fixes: 500da05860c792 ("libfrog: try to pass struct fs_path objects to quotactl wrapper")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # Finding stupid bugs
---
 quota/state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/quota/state.c b/quota/state.c
index 3679c247ea6204..239b513125518d 100644
--- a/quota/state.c
+++ b/quota/state.c
@@ -206,7 +206,7 @@ state_quotafile_stat(
 
 	ret = xfrog_quotactl(mount, XFS_GETQSTATV, type, 0, sv);
 	if (ret < 0) {
-		ret = xfrog_quotactl(mount, XFS_GETQSTAT, type, 0, sv);
+		ret = xfrog_quotactl(mount, XFS_GETQSTAT, type, 0, s);
 		if (ret < 0) {
 			if (flags & VERBOSE_FLAG)
 				fprintf(fp,

