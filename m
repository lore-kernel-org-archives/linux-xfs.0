Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980581B040B
	for <linux-xfs@vger.kernel.org>; Thu, 24 Apr 2025 21:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745531635; cv=none; b=PTDThmAJbZM2jhEs8hZf7mBfE8p136RaDXtYPHitCFX+yyDP8yoQud0LAmc+EEF2bGVYuEJ3TgErcDecNcjfAtayJc0NsPUHKhiL+b53XjXX+za+YoPnTU8rjobPKIT83jq0pJWhj68Ft/jtIqUr+tEychCZMUFbv0S8rkAgfIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745531635; c=relaxed/simple;
	bh=OaaDtOLTZktDaPT/0dHkVFQDKN6ahrGLVoHpEAeUoos=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QQEIYpDLyCQyJNo3qPXQH1BRm8yUdGAn7AQn9W4B8jhdP49sI2bWhzoRIlUIeNthtFPluWgHmO/Hpici2p1WMgk6lKdYsFe/F0dE+EgoXh2vnaUJOd9QOHTevasrO1ecmXl7t4UqzXc85kf2nHDflSPStb+Qb0HR1BP570Bj4fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u4QsPQps; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u4QsPQps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F944C4CEE3;
	Thu, 24 Apr 2025 21:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745531635;
	bh=OaaDtOLTZktDaPT/0dHkVFQDKN6ahrGLVoHpEAeUoos=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=u4QsPQps3VQA57zvzbRFbRbe4eYCGEpHsm7V937O8d3gUqKBZUpn+R/Ec1YxxKviR
	 AOFs6Exaorj98mRQUVXjw0njtSPfpRkkNrMEb8oDJCZ9XkE3fq3wJ0TpP7SAWZDhNd
	 qGAULemrfJ7ienvmDi70IB0nXt7lMHgbWG2qIwIWzvn/Kelr6fBY8XNN8PZOPAZjcJ
	 PM1wmSCWVZpQvmWXGFLw3f3DoqPV9//dLVRD2QwXsILxrJTR5FSfzpxGRvjJ1C1dHH
	 XsesQ/cBYnlYkKDSxraRa6fusJBkGyZh6XCA7phnU3XqQO00HX0kpXNonfpBN6xgEW
	 iqidrteKt2O6A==
Date: Thu, 24 Apr 2025 14:53:55 -0700
Subject: [PATCH 5/5] mkfs: fix blkid probe API violations causing weird output
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <174553149411.1175632.10102293135056174880.stgit@frogsfrogsfrogs>
In-Reply-To: <174553149300.1175632.8668620970430396494.stgit@frogsfrogsfrogs>
References: <174553149300.1175632.8668620970430396494.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The blkid_do_fullprobe function in libblkid 2.38.1 will try to read the
last 512 bytes off the end of a block device.  If the block device has a
2k LBA size, that read will fail.  blkid_do_fullprobe passes the -EIO
back to the caller (mkfs) even though the API documentation says it
only returns 1, 0, or -1.

Change the "cannot detect existing fs" logic to look for any negative
number.  Otherwise, you get unhelpful output like this:

$ mkfs.xfs -l size=32m -b size=4096 /dev/loop3
mkfs.xfs: Use the -f option to force overwrite.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/topology.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/topology.c b/libxfs/topology.c
index 8c6affb4c4e436..96ee74b61b30f5 100644
--- a/libxfs/topology.c
+++ b/libxfs/topology.c
@@ -205,7 +205,8 @@ check_overwrite(
 out:
 	if (pr)
 		blkid_free_probe(pr);
-	if (ret == -1)
+	/* libblkid 2.38.1 lies and can return -EIO */
+	if (ret < 0)
 		fprintf(stderr,
 			_("%s: probe of %s failed, cannot detect "
 			  "existing filesystem.\n"), progname, device);

