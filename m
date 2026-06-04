Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149B42FC893
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 06:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780553093; cv=none; b=UjC+lnPunDPoIrYtvlal74WxxlLF1MrBD7t/UleL7nUWbMN7uWtOGXB6sjlCbJG7z+CIOrDWUFHxB8tHlwdUaATrRqrrm6risxc3wFMXlndnxg9SFeaQMXwjECBj0TsDJp6AoKjc3HyR70NmtDJCfXjRWspHG5w8MDQUNWtkfHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780553093; c=relaxed/simple;
	bh=V2Gkj2f/M2vzFzcyqFffUothtttBCIpU1V4oUtXp5gQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=opx5LT/LvjvfU2nh+vD7+3x2zHabHQE7Ybpd6An8m6LByHcFfJiLmJXlJ4iCr3al3aBecRrHoowyOdyOogA2oVH1Tgy770InwnO1BhrOGdhg32Z1o18j1u+LF4Nb60iU37YPQPud9mwNftKfaTFlIttDtIX7hQBKjJIuxS81Tj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lg28MvCI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lg28MvCI"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 966E21F00893;
	Thu,  4 Jun 2026 06:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780553092;
	bh=heQKIabe+nyNgVJqNk0aDDHnV/g10PX3AHejb4ui7/k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Lg28MvCIDFofI63x1FOarOr9m898buo9Nwkh2aG/fjQX0MyBNUJFTEdsnSOOm5sgv
	 GyOUjVdcGiWehZRmere3/7L4bw1Yg2Qf4bzPO7IDD4PiAsqK9o+mRmrKsPZ4QvtVlW
	 Igp+jcZc6a/d6bvhHBUovaHHwRnuFTUrJhdBj9Rzpwh+VHFznJq1RrovVWeUZ5g2fp
	 OxoSBDQQgJDKJFnr7HkVYbF3yd/uX+ux3rjOiFLjvPwIijoFd29T35eXapFmIYJAE+
	 pJo/u0YuagyizNz7gh4TNZbNgi2zQV2XoHr4N2lwwEhGleEB7iIT7wvN3MVsPOqFgU
	 HwjVuCMDVFzwg==
Date: Wed, 03 Jun 2026 23:04:52 -0700
Subject: [PATCH 02/21] xfs_scrub_all: fix broken command line string array
 construction
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178055303146.2608728.14242967527737251351.stgit@frogsfrogsfrogs>
In-Reply-To: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

In scrub_subprocess::__init__(), we construct cmd as an array of strings
to be passed (eventually) to exec.  Unfortunately, adding a string to an
array of strings doesn't do what you'd think in Python:

>>> x = ['moo', 'cow']
>>> x += '-x'
>>> x
['moo', 'cow', '-', 'x']

Fix this problem, which Codex has sharp enough eyes to catch.

Cc: <linux-xfs@vger.kernel.org> # v6.10.0
Fixes: a290edcfa0a391 ("xfs_scrub_all: encapsulate all the subprocess code in an object")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/xfs_scrub_all.py.in |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/scrub/xfs_scrub_all.py.in b/scrub/xfs_scrub_all.py.in
index 3f618587de8b25..9afb7993abc06e 100644
--- a/scrub/xfs_scrub_all.py.in
+++ b/scrub/xfs_scrub_all.py.in
@@ -100,7 +100,7 @@ class scrub_subprocess(scrub_control):
 		else:
 			cmd += '@scrub_args@'.split()
 		if scrub_media:
-			cmd += '-x'
+			cmd += ['-x']
 		cmd += [mnt]
 		self.cmdline = cmd
 		self.proc = None

