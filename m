Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78EDC8BFA
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719883283; cv=none; b=DXIPgYN/4wmv7c38bzsfH0mqPmFQM94PlpeW6b4zbrftl4WOkgE6SzvHxYMwMOdRlvOnK4sxNqfVjSPXvMdIfJCXFvnhwg8U32qHfeir2hwgkF4KDeYa7YoD+KxHX/1BwJawhafv7XuEv8Uk20uoVRlmnEwOojt2a/frwhTz0Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719883283; c=relaxed/simple;
	bh=kWBuzrfN2kzwsXSEL8+0dWlUfQgf9bgCZk0Pug+BcBM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h9jNYovtcd5shmUvvziMlYdQl04cqn42pcIS18glO8bkJZIwh2+W2lYkn9v2KkOafUAY+7wZ5k9fFcgQtNvLBiyvQKHY3JDFEMhwsVKVuoHXeFc+iPmH2OXyhg7XUU9GCiIHIUgH9Tb8H8C3LIBpL7Zq0mYLLc/nXdn7ztY636s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ubM6Tn21; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ubM6Tn21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56BB2C116B1;
	Tue,  2 Jul 2024 01:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719883283;
	bh=kWBuzrfN2kzwsXSEL8+0dWlUfQgf9bgCZk0Pug+BcBM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ubM6Tn21nCcdhx82lmcDTdCb6KwqJso3E2naxoxMaflN/xVSzCJv/Td4UeaN02tWE
	 c+XzvSEcLTHqLfXPaOqA9jSAG59vmiJ1/+7ei868852CzBWPmgpmcH1e354NRw30Iq
	 sOeDiBGITyRy/UrGUd9OtrtRXHRlYVwTz/d6vh5iqxWvdz86T47DF7XpaH4A05/4R4
	 8KvSI3HvVUmahaI/mw05PrTISVYqxIO6VT3ZxmD0KVrheEdQEImmPTMRuftbUnMTnC
	 J7qrRbdMPpfYdpRYewhxCoLX0wTgN1AdbU1poWeyj748cRA3jaUI+yr53DRwYpQ+Tz
	 jjiWBxcenn1Lg==
Date: Mon, 01 Jul 2024 18:21:22 -0700
Subject: [PATCH 3/5] xfs_scrub: fix erroring out of check_inode_names
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988122742.2012320.2358555456931426968.stgit@frogsfrogsfrogs>
In-Reply-To: <171988122691.2012320.13207835630113271818.stgit@frogsfrogsfrogs>
References: <171988122691.2012320.13207835630113271818.stgit@frogsfrogsfrogs>
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

The early exit logic in this function is a bit suboptimal -- we don't
need to close the @fd if we haven't even opened it, and since all errors
are fatal, we don't need to bump the progress counter.  The logic in
this function is about to get more involved due to the addition of the
directory tree structure checker, so clean up these warts.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase5.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)


diff --git a/scrub/phase5.c b/scrub/phase5.c
index 0df8c46e9f5b..b37196277554 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -279,7 +279,7 @@ check_inode_names(
 	if (bstat->bs_xflags & FS_XFLAG_HASATTR) {
 		error = check_xattr_names(ctx, &dsc, handle, bstat);
 		if (error)
-			goto out;
+			goto err;
 	}
 
 	/*
@@ -295,16 +295,16 @@ check_inode_names(
 			if (error == ESTALE)
 				return ESTALE;
 			str_errno(ctx, descr_render(&dsc));
-			goto out;
+			goto err;
 		}
 
 		error = check_dirent_names(ctx, &dsc, &fd, bstat);
 		if (error)
-			goto out;
+			goto err_fd;
 	}
 
-out:
 	progress_add(1);
+err_fd:
 	if (fd >= 0) {
 		err2 = close(fd);
 		if (err2)
@@ -312,7 +312,7 @@ check_inode_names(
 		if (!error && err2)
 			error = err2;
 	}
-
+err:
 	if (error)
 		*aborted = true;
 	if (!error && *aborted)

