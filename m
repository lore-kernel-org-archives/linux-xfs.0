Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA94838F932;
	Thu,  8 Oct 2026 05:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791438938; cv=none; b=FeiVqJyxnOsxglU6Lm7oxcG/Q/bNOltffLc7eANHuN/gTzfJbaNUXpfSU65wMI7HlRpvgx1zyswiez0zAuKPMqqGBuEdLp9H8OiOEjZiMdNRxI2xHnTPDHRsBiMzWuyAV31sdT8wLJqLqURLq6ryadP9SVDhUl5sufM3fx25Z3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791438938; c=relaxed/simple;
	bh=k6sCK0fooLLUtkivvPa/vfMCKq8b58xGSLHjVxTEQM0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bil5OmBtWJHUxrAklpme1HmXPYzGb1AaP0x+aUuGupredJn4d2fxRgjKbvMNFoH5TQLIxF1OpIAyWzHswgYM74AfnfjLkZ7sRoe1OBQmwqKX54J/rBMcMoMDX+jrrUkpdWBzgANddSwNoUywv6ZMDaQY4Ro19tJSXzxJ6iLUqVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VmEtsRoB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VmEtsRoB"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 90FEE1F000FF;
	Thu,  8 Oct 2026 05:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791438937;
	bh=SwdD8nWYbuJK3R/MIa5a6xiyI9xW0KdhFe6HlbrGjEk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=VmEtsRoBDCibwIaQRps4juwA0NnmidhJdsk4oIP/oB9kiUjegduNukdsa8CzMtZxj
	 xOGtwiVDQdTmbmKtWD4roq+Izf1DHCyiaADF7gunEXu50bW1lI2ICnUuGReJrEZlVr
	 UOdPqrWpm4LZX19ZPV3LMjtoBCtb/jXw8qKfiBHTosgxzr47SEf1txuANHa0p/iCdr
	 EmFR3EVvXDP+LlkJ3AG/UpvdYbuCa3vt2GCNwvU/GxpFYQRrZFS35rvCCLWiBsdKUq
	 59R+tQXhCm5EOxTNXn2S1/UeSqBHNRQ466aynsOO2aCN6njTFTJ7Pr07A6M5f/TI/G
	 CakzZEGGteHSw==
Date: Wed, 07 Oct 2026 22:55:37 -0700
Subject: [PATCH 03/12] xfs: abort directory tree repair whenever dl->aborted
 is set
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179141521320.2728617.14446583476479033597.stgit@frogsfrogsfrogs>
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

LOLLM observed that if the live update hooks for the directory tree
repair code ever fail, they'll set dl->aborted, but then the main repair
code path won't check it to exit early.  This can cause incorrect
repairs, so let's check for hook errors and abort the repair.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 3f31406aef493b ("xfs: fix corruptions in the directory tree")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/dirtree_repair.c |    9 +++++++++
 1 file changed, 9 insertions(+)


diff --git a/fs/xfs/scrub/dirtree_repair.c b/fs/xfs/scrub/dirtree_repair.c
index 717ebbe4f91916..1de4d9f1b61657 100644
--- a/fs/xfs/scrub/dirtree_repair.c
+++ b/fs/xfs/scrub/dirtree_repair.c
@@ -575,6 +575,8 @@ xrep_dirtree_delete_path(
 
 	if (!error && dl->stale)
 		error = -ESTALE;
+	if (!error && dl->aborted)
+		error = -EIO;
 	return error;
 }
 
@@ -720,6 +722,11 @@ xrep_dirtree_adopt(
 		error = -ESTALE;
 		goto out_trans;
 	}
+	if (dl->aborted) {
+		mutex_unlock(&dl->lock);
+		error = -EIO;
+		goto out_trans;
+	}
 	error = xrep_dirtree_create_adoption_path(dl);
 	mutex_unlock(&dl->lock);
 	if (error)
@@ -780,6 +787,8 @@ xrep_dirtree_move_to_orphanage(
 
 	if (!error && dl->stale)
 		error = -ESTALE;
+	if (!error && dl->aborted)
+		error = -EIO;
 	return error;
 }
 

