Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69ADD2DD5E2
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 06:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771480859; cv=none; b=hTn/ZZs2ZxXAJ9YQZlBQHAgoGzncFyag28SGZYgBGtaSXNHP9M4MVZFtNAU215H6VNVk8H6Jze3o0UMe4tSfkA2xN265AsUN2S8OnBp27/yXivGGYv3OWoTMWnCcGH+GP68h5QAwSdw4tDG6KA2RLt14SOm8VIzq/x13cFToOvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771480859; c=relaxed/simple;
	bh=5nWq5z8CZd2jANS6ElAxHDpAuDGBXrXyB2XJmuS/WJw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MIQr9SDfNLDthQOXaOGIdP6mqItK+dG/QNZ4udW1tdtVbjxUiYMAbX+VuIerEyjavi88EOKRBwKNKSeoYx6M0LWMWY9fKLeEKu94hEFsSd7uVzuivzhPqg283eItiAsFG2grWLu64+0EEcyW2bx/JHyvkrzJTLMT198TPxpTugk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AnB7pTUX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AnB7pTUX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466E6C4CEF7;
	Thu, 19 Feb 2026 06:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771480859;
	bh=5nWq5z8CZd2jANS6ElAxHDpAuDGBXrXyB2XJmuS/WJw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AnB7pTUXG3Az8uMFcg+VEqfKhmMqKOvFsdvryhQ6tTs/mgrcncziaN6bhRXVCi32X
	 LiRO6Ml6pMigJ19bmDBXw8YiE5/xlm5gY1PEEKk9SpR50asGqdo16GW7rH0y/acLk6
	 jlHK+cX/t8BRO/bAf+saqTCkTI7Fv8DhkGTbgQaJ3sWeGQwvv2dJdrIAb/CTbMCzZ2
	 Dq5lq7SBjrajpET6mHdtF8+Lc43i3ePGPjq6BoCF4diUJ/ukXgxgvFtgXrt43y0nRg
	 TfOJytR8TFqgZm/HEB/XXTqCVGGBTWW4sDn6q2XuEJihcLXIOYgEgcjckZ2B7rtyKN
	 HmN8+nr5Dx+TA==
Date: Wed, 18 Feb 2026 22:00:58 -0800
Subject: [PATCH 1/6] xfs: fix copy-paste error in previous fix
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: clm@meta.com, linux-xfs@vger.kernel.org
Message-ID: <177145925431.401799.6241225612324128085.stgit@frogsfrogsfrogs>
In-Reply-To: <177145925377.401799.10773940743454980308.stgit@frogsfrogsfrogs>
References: <177145925377.401799.10773940743454980308.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Chris Mason noticed that there is a copy-paste error in a recent change
to xrep_dir_teardown that nulls out pointers after freeing the
resources.

Fixes: ba408d299a3bb3c ("xfs: only call xf{array,blob}_destroy if we have a valid pointer")
Link: https://lore.kernel.org/linux-xfs/20260205194211.2307232-1-clm@meta.com/
Reported-by: Chris Mason <clm@meta.com>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/dir_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index f105e49f654bd1..6166d9dee90f13 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -177,7 +177,7 @@ xrep_dir_teardown(
 	rd->dir_names = NULL;
 	if (rd->dir_entries)
 		xfarray_destroy(rd->dir_entries);
-	rd->dir_names = NULL;
+	rd->dir_entries = NULL;
 }
 
 /* Set up for a directory repair. */

