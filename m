Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37A81C6A8
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422264; cv=none; b=irnymJnaQkrzaA8wYL1O602y/m4BhalrduO2NcdKGqYZP0LznlZIxtthk0VyguskqQl4DFhvlR2UXqBb4o2mIarDcw/FMHhq2rI/y8YB80nm8AtxfTzOGj/W7sezPx+Lg/qWvV8nLFus+B3uCWc58GvZMbE/y5Ng7c8bwIRDFKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422264; c=relaxed/simple;
	bh=Zdxz6DDA2lm5PkLUcp+B86QJlLc2DYkzIOW3cxJc9h4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cu5ZL1y5cbcu6e55Tewvfd7nVRZeCYoKL/zg/OyUlLWT4DrAz6yypRCZRt2FYIZZq9t1gg+HVz3p0RN/Cu96qjzwMXLuuG+JT6h7BAh8yU1HriaS2W1JIjeCQZNWxYvV1ATc12morSO7KpILulLYYwvnDg9E9qGN8qv/jVbS/Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YPy9+xc1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YPy9+xc1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A9EC433C7;
	Tue, 26 Mar 2024 03:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422263;
	bh=Zdxz6DDA2lm5PkLUcp+B86QJlLc2DYkzIOW3cxJc9h4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YPy9+xc1BnVEYJQFtiJHE9Qs5n7a7SkrCrOqADJEOzvqto6eMkwoqPfLYOSG/AjKg
	 y+2yqv1nAu3iwJfhhkIqJej/+H/SQ5NDtOfPTm+inUjJgk8v/aOrKp0Nbdb4biImtG
	 kXHwEnPQ+jB16ZJBrpZX4r9kZptGJx7lUbI3dzZ/idznV1J5MeprmWdh1zxbbgDZDh
	 bWrbr+q0ZqIseTwckzFj/jMtU9w9nwe7x3nH2t2I08my7rSMegNtTEjt7jD/ELaRkq
	 I1vvgSNGMlgY3NmAKepExR+NNlD8gOVCigDCWYqjHHqDJcDhUQ/tm+0+pun8+SC/t8
	 a5yIt4fbHQe2A==
Date: Mon, 25 Mar 2024 20:04:23 -0700
Subject: [PATCH 06/67] xfs: hoist ->create_intent boilerplate to its callsite
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142127050.2212320.10677823130647438624.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
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

Source kernel commit: f3fd7f6fce1cc9b8eb59705b27f823330207b7c9

Hoist the dirty flag setting code out of each ->create_intent
implementation up to the callsite to reduce boilerplate further.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_defer.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 6a9ce92419c0..1be9554e1b86 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -235,6 +235,8 @@ xfs_defer_create_intent(
 	if (IS_ERR(lip))
 		return PTR_ERR(lip);
 
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	set_bit(XFS_LI_DIRTY, &lip->li_flags);
 	dfp->dfp_intent = lip;
 	return 1;
 }

