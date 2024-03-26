Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975F8128814
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423157; cv=none; b=j0sESQSoObMfjsR2u52qLiuq3MAiCqP8HuMwOun5TzZG5yd2olqzVLwXauJ9CEJ+9D9Du6N36rx0tMU+QPxjr2rW/KUYOh1661tperjZM4G/dNni7Bh2TDskO7Z82qEurUGuwYbGF/D/h1CiowNsThlIgl6WxxDf29s5PZCjZnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423157; c=relaxed/simple;
	bh=RvDZUaeymyNafnt98+/UcAIDRvHvpn7M1zHnTopsvzo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XB47a9HbeNDgWkIiBnEELQM+ijAF4QSp4PNH5bS2Rf62gx+CaXpKKKZBWMvMU/Ecdk0173YiDmVnPt0pIotH0h8uUL5WLSj5H0KovqnkGyWPScUGk85MkCgRVMS1aVZ5t2AHIP5QMjSNUzoRfU42wFNZ6c90KFeogC8GOgeapBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AIFO3NzY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AIFO3NzY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B5BC433F1;
	Tue, 26 Mar 2024 03:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423157;
	bh=RvDZUaeymyNafnt98+/UcAIDRvHvpn7M1zHnTopsvzo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AIFO3NzYPwl7iIfz0b236W9bDU/CO1yR8dpnTF6P8vBjOERDRjtJ04stdpoZbW8Nl
	 lQvsIQKivcUwh6P5iiVrEZYdyidD5ZJmsha1fK2+WWZTIG8rrxndomq521qqhhHPE2
	 X+aczdLBiC2p+wdpHCxVHme6TK8IQdWolSzDtLsWA2CzYvmi1pLOQr/57Fg3Q78Va9
	 piFv6SyZbvV4zm96Xh2vZTjVhj9UIdGUSRCeYSAGGGW9ZALsBje5cbTcCBR9T/u7WL
	 bpN1PsRC8ahCgDGlo6iGVDI3iwXvRs4Grr9y9mB+W+gSlyMOaztfkHwEfIKfvaQlCG
	 +WUFzJOsyoORw==
Date: Mon, 25 Mar 2024 20:19:16 -0700
Subject: [PATCH 63/67] xfs: fix a use after free in xfs_defer_finish_recovery
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: kernel test robot <oliver.sang@intel.com>, Christoph Hellwig <hch@lst.de>,
 Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171142127866.2212320.14123433583154328027.stgit@frogsfrogsfrogs>
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

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 4f6ac47b55e3ce6e982807928d6074ec105ab66e

dfp will be freed by ->recover_work and thus the tracepoint in case
of an error can lead to a use after free.

Store the defer ops in a local variable to avoid that.

Fixes: 7f2f7531e0d4 ("xfs: store an ops pointer in struct xfs_defer_pending")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_defer.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 077e99298074..5bdc8f5a258a 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -909,12 +909,14 @@ xfs_defer_finish_recovery(
 	struct xfs_defer_pending	*dfp,
 	struct list_head		*capture_list)
 {
+	const struct xfs_defer_op_type	*ops = dfp->dfp_ops;
 	int				error;
 
-	error = dfp->dfp_ops->recover_work(dfp, capture_list);
+	/* dfp is freed by recover_work and must not be accessed afterwards */
+	error = ops->recover_work(dfp, capture_list);
 	if (error)
 		trace_xlog_intent_recovery_failed(mp, error,
-				dfp->dfp_ops->recover_work);
+				ops->recover_work);
 	return error;
 }
 

