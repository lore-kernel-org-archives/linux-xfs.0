Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600B83F326A;
	Mon, 12 Oct 2026 15:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791818625; cv=none; b=UgTvbhIY2t9VNuTMMMls7Xc2gxZwHrYx0RotnctZq+DD5ygNdJn1JwDUjIVUMwZNhJTEA7uNYafNU9xpZGHDAja92i7/YJG92DkwohLpfng3Efi+wYORwfyU3hNT0whZLurhBv7Bn6lTfP5vSElecIPEEuzrfh0VIObKKg+PKUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791818625; c=relaxed/simple;
	bh=GAiff/gy9VVn+86aZv4W2D7W8C2gELB3oO/IVajcuBU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lznzxE2xZlE8Byj5FPwMguPLLTOJPuEKldgGK6+80lkuOHpaBdULw3UYqveOopA4DUSVRKnNkFGb4FF+7UWJtbP6dUS7DGd5oOrbUZ7ppCwC4AkveyNl+GQfT8Q38bSXw6/0sNueJr7vGSaFZu3h9DrDGwoSRauzd/KFAUYVDaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=isIiI9l0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="isIiI9l0"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E0FD31F0089D;
	Mon, 12 Oct 2026 15:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791818624;
	bh=1983ktvh6/z1NTrpEceZ1PKR0rKCPieBDURZu04yUQc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=isIiI9l04wfMBqhJEaJZVktTGAnPRLV3Ehf9WQsqWWm8VcGyBqL/fd9w9NM1iVnhg
	 df9lMu8BmLa32sD4U7rGGJwGlPK2aUkoWtNWn+lJ5pvECUiASMsCGPAqFczVJOtf+S
	 5Sgz/AN56P/k69k4JENzt6IsnbIrdDZ8vm1+XAsm7hwKLossMpJLfMXl1akvnD0LlJ
	 /v7R8VXtwjk9L2iozPpu/dzB97ik1seE2C3p1P8RyBpFeFMUc0TsmsZGoQiC25b9MN
	 lJiI7pq/xWpGEm3BGx1+lCs+WcFTXirbs3BsdPynRKoz8q3sN2OPPJ0Y63TJw33qQ2
	 ajrJKXT8YhT2g==
Date: Mon, 12 Oct 2026 08:23:43 -0700
Subject: [PATCH 13/13] xfs: complain loudly when dirtree checker finds broken
 links
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179181839527.1417179.10140588765078921402.stgit@frogsfrogsfrogs>
In-Reply-To: <179181839163.1417179.9019753534701755931.stgit@frogsfrogsfrogs>
References: <179181839163.1417179.9019753534701755931.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/dirtree.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
index 887383d2e94104..11a9dea03d87ea 100644
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
@@ -981,6 +982,7 @@ xchk_dirtree(
 		 * parent pointers are corrupt; this scan cannot be completed
 		 * without full information.
 		 */
+		xchk_set_incomplete(sc);
 		xchk_ip_xref_set_corrupt(sc, sc->ip);
 		error = 0;
 		goto out_scanlock;

