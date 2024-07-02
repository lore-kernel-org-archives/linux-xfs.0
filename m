Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDBC4436
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882141; cv=none; b=OOF1JAUymfh2VR6IVWTD0IGUgM3UU9zCofO6XrKSodtERidomzhfXeP1s7FZmS/GPl31CZNlT79OfTdrGEg1bjtH9nK76hk9FXKc5K4D5oiI3lXuXcOS44ScLI+4NvqcQp1Ix633sBp/fpTfk42oHXOh6VBy5Q1+xJRzW39egEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882141; c=relaxed/simple;
	bh=xrHmCbNuD+wu+2KGIw6mQnwDWS9+OomNxHBfO/yalAY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nGa4Jyj9bkLaa1KlHOdjWJHomeAbNqMP5+HMsK/WfuCVA0u/+xwxlmEwPA5KUtYlFd6IiBLhN6gGLJ5+SSHSo3ZMpvy7xcrd/VR71hsakC+ICZIaofsx6vh6H/r3guA2rmoVBeP+a6jHqZEBuDB0S3E/Mv3k0n7FMuFyRTF7D8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TyauPU/h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TyauPU/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58713C116B1;
	Tue,  2 Jul 2024 01:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882141;
	bh=xrHmCbNuD+wu+2KGIw6mQnwDWS9+OomNxHBfO/yalAY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TyauPU/hpOnRsAKza3CaWcQEomI7Mif5dwAddZDMh5gQM4B/STcm5wTfN4fvLV+Vy
	 BVq3YdRTwXmYHEScG13TJZzHkNFYh5XCJrTPj+tJ+kHDYRDydd0yzp+Cm9cs/P/cOt
	 8q6/j0iqDPY0WPgVs0OOVBL8dZ6GRqthXJHmEksI1Nfa1sX2UWaWbYbMVba9E8VwQS
	 hdEgDk/Q+3TaSOvoUQC0/cFDak6JeN0PiXZl/oFZnKXRh5GR/oTAIDM2A6ahy1iKSf
	 pOi5dxXRHK848ddbPFw8cet+0dCNBJanQqITAf4arhNIhBUOggaHnQ6Hlu5SQVnxlW
	 iLdkO0rgxE03A==
Date: Mon, 01 Jul 2024 18:02:20 -0700
Subject: [PATCH 6/8] xfs_scrub: don't call FITRIM after runtime errors
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988118222.2007602.19270694956927614.stgit@frogsfrogsfrogs>
In-Reply-To: <171988118118.2007602.12196117098152792537.stgit@frogsfrogsfrogs>
References: <171988118118.2007602.12196117098152792537.stgit@frogsfrogsfrogs>
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

Don't call FITRIM if there have been runtime errors -- we don't want to
touch anything after any kind of unfixable problem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase8.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/scrub/phase8.c b/scrub/phase8.c
index 288800a76cff..75400c968595 100644
--- a/scrub/phase8.c
+++ b/scrub/phase8.c
@@ -39,6 +39,9 @@ fstrim_ok(
 	if (ctx->unfixable_errors != 0)
 		return false;
 
+	if (ctx->runtime_errors != 0)
+		return false;
+
 	return true;
 }
 

