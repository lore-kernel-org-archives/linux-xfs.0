Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5B8148827
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529441; cv=none; b=fJaD68ginwbAhMoDgjC9VMwtlOoEc5nUsZ+S2F4S7rRKU0Qd3/GbRb04ofORDkPpBVTJ7awNXQItetci49T6u+xo/eywjVbkI4idh9imcscVV90RN76aQi/U1vreRi3TvcU4PfLuVtiDjxcrcd+X5298gISzhq72fiInMRORluQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529441; c=relaxed/simple;
	bh=CxJwoKE3HahBeSJoS22ztfSBJsei+Mzqj/xCM3/CsDk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SLZBb6zX0y9EO0/Sao3Rws4ylgjifUqnPYk8zHxEI1CnfWDyJxdtzWXTW48iTYJwiOwnr7HAjdlpyDtWf5GIokd59q45aRHR1MluH3Z3Z89VdUE3IvZ5tpfKxMNCc7sdZtWukyONsfZdWG0hqADXodHUA7YFHRSXFLNgJgHqFgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SSG4dp/S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SSG4dp/S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E96C4CED1;
	Fri,  6 Dec 2024 23:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529441;
	bh=CxJwoKE3HahBeSJoS22ztfSBJsei+Mzqj/xCM3/CsDk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SSG4dp/SMOvYxXjT1vVHZG789tpYukIt1MTFf/bh1In+ShPY+JvRutzlF+fhbExRm
	 SziIz1GpTQ9Uf4ZffcrHOB192fDJ6O0AamcetZ3yPWLiGXSi4CuU7yEd6tyKZYJZH3
	 dAnhLA7M/ich+v08LY77HIYTXK9imAgS6QHciuMx0UidPaNd1o5AddByzzNYtn5rFG
	 OSLvLxCNA47D0xUrTtWbhx56ooYqXT+RFgsm+vwb9n7NrjUJbFZL2dIiIvpo18JEMF
	 EdAq5JDff6tHfT+CJLKaCjltad3rvCspI4sEaxS24szTT33O3zZhG/T8466XEbCKjH
	 ofTo6H0+g24jw==
Date: Fri, 06 Dec 2024 15:57:21 -0800
Subject: [PATCH 23/46] xfs: grow the realtime section when realtime groups are
 enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750347.124560.12524003644141563295.stgit@frogsfrogsfrogs>
In-Reply-To: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
References: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: ee321351487ae00db147d570c8c2a43e10207386

Enable growing the rt section when realtime groups are enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_shared.h |    1 +
 1 file changed, 1 insertion(+)


diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index 9363f918675ac0..e7efdb9ceaf382 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -160,6 +160,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 #define	XFS_TRANS_SB_RBLOCKS		0x00000800
 #define	XFS_TRANS_SB_REXTENTS		0x00001000
 #define	XFS_TRANS_SB_REXTSLOG		0x00002000
+#define XFS_TRANS_SB_RGCOUNT		0x00004000
 
 /*
  * Here we centralize the specification of XFS meta-data buffer reference count

