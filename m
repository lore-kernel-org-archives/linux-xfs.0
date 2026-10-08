Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18713BE179;
	Thu,  8 Oct 2026 05:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791439079; cv=none; b=rKQT5bP3wWEQii8yVnqaDmkGmFUWbGF2V8d6H7fg8l0lCpnXKEv8lD7CR+LFzep5gOjnZYheoHIHFJvTy+WImaFgVtTskACLlWzD8Fdkjg9d2F1Qic2roaareqNZqLr1gKyxI6eJDlNVC8tn2n2iA8g3P3SLqXP2GGnobiOKaC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791439079; c=relaxed/simple;
	bh=69ZMOhBnZmI2OUbpYutBFH8c9FYDCdcY+Qt++8ih8Ic=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e09BsSpCwCePBswIDfqK+VfqkxdBN/ksmnqshQNsCN6aL+7xcJimQu3+ewtrzI0tW4ZKZ9O0A0cMSd9ikR7gJ073rXMM0TnXHDhozhDy/2s/3Tt3cn53SI77MkKGY7cpV8djFT3YUNSSty4Jj9bTYoqlfvWijjSoePbLXVvCZMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bI4OlvsZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bI4OlvsZ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 627371F000FF;
	Thu,  8 Oct 2026 05:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791439078;
	bh=pmEu2/8qkzUvICPZDY68npXfqr5QeU5R+4L2EBaIEv8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=bI4OlvsZpp0qia5atpPthEQTLA7uBdJqHx9mDRqODiGSmXDONvimPr0diYExMoLh7
	 7FapNo0CORKu+NcVZJQtOIDJg5MarHKpJ3cwKbnXSAWWzjE4zj4dtyXntzmLVStJ45
	 /8wDhpZxSZzypAaFPtPFfVf0QWjyUge8HgY94ksHyDm5uxCEslLf0EiLLjwMtyAK60
	 2Q42i/c3vbsHG2Rt3RcPnQEkf3i0rd/7JB8JAkgOsPqRHmczGttj34AUjtpF2zt+G9
	 xj41UV1TUQFKqbZhPx9JgBh2E8EePRlmEQ5lcigYOpTMcvf1Gz4/W8DN3vrLsC+2mH
	 VhlFjuvspi8aQ==
Date: Wed, 07 Oct 2026 22:57:57 -0700
Subject: [PATCH 12/12] xfs: complain loudly when dirtree checker finds broken
 links
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179141521516.2728617.8852126870323780870.stgit@frogsfrogsfrogs>
In-Reply-To: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
References: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM observed that the directory tree walk code bails out if it finds
broken parent pointers along the way.  However, it flattens the return
code to zero, which means that we can end up in the repair code having
not completed the scan.  We should never proceed with a repair in this
state, so let's mark the scrub incomplete and exit.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 928b721a11789a ("xfs: teach online scrub to find directory tree structure problems")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/dirtree.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
index 887383d2e94104..5d2fee2138439b 100644
--- a/fs/xfs/scrub/dirtree.c
+++ b/fs/xfs/scrub/dirtree.c
@@ -860,7 +860,8 @@ xchk_dirtree_find_paths_to_root(
 				 * A parent pointer of @sc->ip is bad, don't
 				 * bother continuing.
 				 */
-				break;
+				xchk_set_incomplete(sc);
+				return error;
 			}
 			if (error == -ESTALE) {
 				/* This had better be an invalidation. */

