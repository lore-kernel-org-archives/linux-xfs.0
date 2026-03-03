Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6735E390991
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772497169; cv=none; b=BI8zQljlrBeq0CZZcXt247+C/dJNGz0l2aHTfpwgI3S3UNXQA5JKMTfiQCl5ksqpEZxPhVOIamD5Au3VpLTCHLExs0yO7EFY2zqJk8vdkyAhJkxQsteZagv5ZJ8BmkpflWijehSJ8CyE7Na9vKLxJiQyJiAJiVjqmtmxwBr7908=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772497169; c=relaxed/simple;
	bh=2dE2YuVgQK72DY6DVbv/0Iga+0ko0sKqqaj61UXPqdg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uKphqy1eNdwtLt2v0wc0Cjm1KgQjW9qr80zU47yWcnCR3A23N3Lh3TFvug/iJUUwfB7oNcY58xJnchi1l2JFFhJYxZQKGd17ODDO4y2QRuVirxzPdMA0YdToZ0Qbz0dAeY5q8OygURbR0nEL5c9BiRj/FHcijGBxBI8GSujjX+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=imS10cBX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="imS10cBX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D85CC19423;
	Tue,  3 Mar 2026 00:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772497169;
	bh=2dE2YuVgQK72DY6DVbv/0Iga+0ko0sKqqaj61UXPqdg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=imS10cBXv0lx7bQKylo6ZP2n2JWTw7pKsurDVysuhZraUs2d7lId86UH2aOUBFM8X
	 ORmADqXkXsRMA5ePZVGFfnrWaiQMx1PS72gDkzTBo2dS2VsO8isty07RSnfxkvQAhY
	 V80kVTqmck5Ptulp22VSLjpLpw7frubJ4QC/7x0fnBqa6JbYEAGWJgpS8P3RWinnad
	 wVXzbsQLR3tMGh7fiJnV70fGeTVLfL7C83DzRDkrBmu6FLBJlrhudgmSUaUkanQfBh
	 TvHcVCLeUVOvzjlIpNYD5LTIJXqi39d9ytcaj4Gx738bUGrN27GwS6ErU2+C3TebrK
	 4ZeOhwCWypOAw==
Date: Mon, 02 Mar 2026 16:19:28 -0800
Subject: [PATCH 28/36] xfs: give the defer_relog stat a xs_ prefix
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, dlemoal@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177249638293.457970.8228658779271002294.stgit@frogsfrogsfrogs>
In-Reply-To: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: edf6078212c366459d3c70833290579b200128b1

Make this counter naming consistent with all the others.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_defer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 5bd3cbe4cfa1a3..c0d3aa401cbab5 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -558,7 +558,7 @@ xfs_defer_relog(
 			continue;
 
 		trace_xfs_defer_relog_intent((*tpp)->t_mountp, dfp);
-		XFS_STATS_INC((*tpp)->t_mountp, defer_relog);
+		XFS_STATS_INC((*tpp)->t_mountp, xs_defer_relog);
 
 		xfs_defer_relog_intent(*tpp, dfp);
 	}

