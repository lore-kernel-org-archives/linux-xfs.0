Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9207D1E484
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389909; cv=none; b=KVBAzWTfyZbzUtKgYXLab6g+/oXQlmD7XOc+Z3RR9Xnad4EwaGRMwNlxvdt3Lp8axEI2jOWXljtS2m5JLArVhSa2S0V0flq/PxE2Yw5I7gqLVLcLG8J1cjJ4sDLp0LsrYQqg42M84Jk/Mp+EV1Mi72qgfSK8UXZ8Xc76biLHmZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389909; c=relaxed/simple;
	bh=prQXTYtG+Bf25DKI5Aze/yI7VzkF8Jo/ej0UQ6xbClU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qRm/sBvhJ0IWXkHKYzDO/z0IJFXQIa8ekNAHIirz7zI88+dD5FDxHJUQKOLicWB1Xh5YAnXu9qUcX8iZ0koC5pSfpuU2I4HAz1bVfA7K41E0yr7nOD6qKGvSq/CflHOmx7fS630MLk/Tb0R+iUX7BB0mVouxke/E22i6sHETY8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gsuK7z3h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gsuK7z3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC4AC072AA;
	Wed, 17 Apr 2024 21:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389909;
	bh=prQXTYtG+Bf25DKI5Aze/yI7VzkF8Jo/ej0UQ6xbClU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gsuK7z3hwpy/5YtYuEpVKpJe1U1zYNPFPDTFK/NRF0W8GbXXB4zd8MRqqAQHoZthe
	 O//Za4spbNhQuE9LwgTjECPvdfwxX2KLIqgoRZKA6OSYwjMcuVK3Oowzy342B/JyP9
	 Kkbm2yvCNwhRLYrGkhPY7c5LKKQ6zIrS+4j9EfGzHmhb6vO8+YlLxTh5rY2InGcdAm
	 EmsLd6dwQGOyKccl4Sa70m3AaJsDS9zDaO1VCcdlHqJrdvD82XIsUIUxDXqtVLWxVW
	 3CP5MyqwgIqtddM8suqGxZQUUbPtl20xRh7UUy4OwXmMbyuMI6X2/2NY7sl9p6QVgo
	 iGrQJnByGCmEA==
Date: Wed, 17 Apr 2024 14:38:28 -0700
Subject: [PATCH 64/67] xfs: use the op name in
 trace_xlog_intent_recovery_failed
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171338843301.1853449.337154345904134359.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: bcdfae6ee520b665385020fa3e47633a8af84f12

Instead of tracing the address of the recovery handler, use the name
in the defer op, similar to other defer ops related tracepoints.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_defer.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 5bdc8f5a2..bf1d1e06a 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -915,8 +915,7 @@ xfs_defer_finish_recovery(
 	/* dfp is freed by recover_work and must not be accessed afterwards */
 	error = ops->recover_work(dfp, capture_list);
 	if (error)
-		trace_xlog_intent_recovery_failed(mp, error,
-				ops->recover_work);
+		trace_xlog_intent_recovery_failed(mp, ops, error);
 	return error;
 }
 

