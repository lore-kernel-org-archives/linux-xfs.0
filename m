Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7907012AAC8
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423345; cv=none; b=KPfLiPzvU2soy8KUCmOtRSxRluesV3N87DBpVzQy1E8OkoKpdpT3rf8/nWVVu1zm4fpLmh7wftZe4MbWoXAHkAkDYfOBd9jIQHPthV/aaB75PEt7uxew200oBXk7LMWLMWu65wTjKAl1OhJeDu7XRotpZHwNTwFnErRhWaMGLHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423345; c=relaxed/simple;
	bh=JHcXsgvnwbxCKR5aTmln66NBjkXuHgDaCqKHZcQAwgE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DKmo2w5BpBj3gDrgKW3bZo77ZhMlBsCB96+v5Up6+bKF4MbU3+PmroQTe3244jr0XJDtRWtaU/aR/FeJKDkQQra0qJgYo0asQul9KRCw4b/g1nkAc0ar+ioUVNQonJ8MullzBtLlqkO1jE2MCx+l+9Gua78qelMiaTJLVeoSL/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kH0hZATq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kH0hZATq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB267C433F1;
	Tue, 26 Mar 2024 03:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423345;
	bh=JHcXsgvnwbxCKR5aTmln66NBjkXuHgDaCqKHZcQAwgE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kH0hZATqb4bF4xe/R6LoxKV2ZjcciJQgKLuLHfazxr81cDjaOpvzFVuoY6N9pcZSw
	 +cwBlBjyroMWPnEcOerOkkC8yI5pmyhumsRNJqctaQV7Tin2ug9EyZInE3le4ObweS
	 cQctzjyGQS8fKeOtpR0YO0lepLTUOQzTJ82328bpnt/wT0xi8vt0B9YeD5y+BIGYVZ
	 StO9xUAtE5ouGkgLlbcejhFpwFQfMNzg3ydmBLLkWwBIwI0cgg78E/MM3cKxvmt4FV
	 dzR8DS7WXWNZUKP/yQ34xDLKEWE6wMnjCCNV1eoQUDTJnuBWCWJI+o1FzmNvpczL3W
	 qbDEm8Cn8VH3w==
Date: Mon, 25 Mar 2024 20:22:24 -0700
Subject: [PATCH 1/5] libxfs: remove the unused fs_topology_t typedef
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142128959.2214261.8858100369928167259.stgit@frogsfrogsfrogs>
In-Reply-To: <171142128939.2214261.1337637583612320969.stgit@frogsfrogsfrogs>
References: <171142128939.2214261.1337637583612320969.stgit@frogsfrogsfrogs>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/topology.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/libxfs/topology.h b/libxfs/topology.h
index 1af5b054947d..3a309a4dae05 100644
--- a/libxfs/topology.h
+++ b/libxfs/topology.h
@@ -10,13 +10,13 @@
 /*
  * Device topology information.
  */
-typedef struct fs_topology {
+struct fs_topology {
 	int	dsunit;		/* stripe unit - data subvolume */
 	int	dswidth;	/* stripe width - data subvolume */
 	int	rtswidth;	/* stripe width - rt subvolume */
 	int	lsectorsize;	/* logical sector size &*/
 	int	psectorsize;	/* physical sector size */
-} fs_topology_t;
+};
 
 void
 get_topology(

