Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD6D4C8B
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882235; cv=none; b=nR+Cl7t2F8hc3lnM7VngWbpxt5kVYt5UmrgHnVVdBXMtEorVvtdhEeoV7BJh8oxg/9IeeQtpffHNMatN5pbrjdKNtKlg2jH6t4TqqyQDbuCGYQb28djfsQBcqDJ3gXRMY3QjI4KvaPlmKMI9AYb7PZ7YLWSkReo4XEVDO11UyeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882235; c=relaxed/simple;
	bh=KFwFQklbWd9f5c9uK0Q1C6XnTbnGywE9zS2wzG9jnSU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A4ZL2NNGRCT7dKHDMMgPv1Cs9+Ui8AEgCLLUbxpGsq+npRbZgJEeITVz0PtiI6d3ErzwVfKkzLrsW++10xGByPYuHIZwHoCRxgdjHhOEWb4C5jAzS6bRRaJ9G2b5Xx7pZQpARjp2uGxf6AhfQ5i4FaqyLwFFtv5AJFbN8M+lsJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kkq1Y+pN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kkq1Y+pN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7AAC116B1;
	Tue,  2 Jul 2024 01:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882235;
	bh=KFwFQklbWd9f5c9uK0Q1C6XnTbnGywE9zS2wzG9jnSU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Kkq1Y+pNeakQYYpkHeZ4dJ+vSs/3N5VdalfA+6Ys8r8srbqOEKiwzwl05npmLYeCX
	 u2RhiBoemikn2w+rc1UVh68439FCevpOOD67VNO8L65oQHdmUsqyYc8QznM/yGVgHf
	 4xc5m+WEhQ+bvYtO8i3gsQmnGrzb5zAY0wZW8BMC9bLNriyCVv/b+JKBCIxh+uZeLr
	 ZR+IfDA3t0mG5ujO+duXH4a9OwHXzbpCW5VWALn0B4TwHicrNPwu2M8q/s1gLViHQx
	 kBZaZ889RNpHtdnVUT4sW034fafQNf1+kY9zzoCCHIB+/VIdeV5H4wWEvt2NglJbUi
	 q6vGgwW+PongQ==
Date: Mon, 01 Jul 2024 18:03:54 -0700
Subject: [PATCH 4/7] xfs_scrub: don't close stdout when closing the progress
 bar
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988118640.2007921.1141459290194402070.stgit@frogsfrogsfrogs>
In-Reply-To: <171988118569.2007921.18066484659815583228.stgit@frogsfrogsfrogs>
References: <171988118569.2007921.18066484659815583228.stgit@frogsfrogsfrogs>
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

When we're tearing down the progress bar file stream, check that it's
not an alias of stdout before closing it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index edf58d07bde2..adf9d13e5090 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -878,7 +878,7 @@ main(
 	if (ctx.runtime_errors)
 		ret |= SCRUB_RET_OPERROR;
 	phase_end(&all_pi, 0);
-	if (progress_fp)
+	if (progress_fp && fileno(progress_fp) != 1)
 		fclose(progress_fp);
 out_unicrash:
 	unicrash_unload();

