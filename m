Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0550E182
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529927; cv=none; b=rlrM+RzOcZSCk7Bl8nQldJJGT0PQwVhxg6eziGF/L43AZqJ5DJWql84xS6mJQwxMjQC+8Ey8Ow04GIQTk6RQnLU3uWgy1Bn9WIMj3Yg97H+qdrk4uAOppD/WV9zwQbmMfJX28Nmi6jLKZ0eYBybaQYWoahebO7XyH0fPpv/PmAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529927; c=relaxed/simple;
	bh=eVZiFJC+sGekSRAogRHQZ+mwk4usokq8Sjdg/wQuDOQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BNHAUCga/bv2F7wsRfvDLdCJWzib911sn7VD2iNXcFptKaDbRHrVxaO/TVu+1U3wBgVrwm6AQWkWmyiwG5TdSOjBZ+6J656V10GbpUy8L/UEG9oOAbcrMOI0rfgmS4FruQu0nRGY+mTlNg5/828hOgb6g9mbCoS+oXEGa9y+m9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bvUooHbe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bvUooHbe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59BEC4CED1;
	Sat,  7 Dec 2024 00:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529926;
	bh=eVZiFJC+sGekSRAogRHQZ+mwk4usokq8Sjdg/wQuDOQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bvUooHbeBpcn8xBxLsTyDbdY43cBgkFDg9Pv7//UMwIBJzKQRHD2UTvD7C6kb/QUG
	 2iCq/soj/1WqIITcE3iIC+C6L/jY/PEDZ3afDw1cftDWS9fjZ6m/kkyC+VA/of268T
	 jcI682QvfMMdvijJDiXlv1i860NUl78vskNKPgntkPQPEdk/4OvlXfNUEofjTlP/zF
	 HY+0V5kwfJTQY5is44ZREs4yW57LcmWwNKM/QebkSrceI997cRE7jYUOU5WwI4CaKx
	 WDzmNj6p1bxXyqoWahXjiMTsUAkPvK18XUhlfto+FaXOcEjHRNmwfIlWCy2vh4Wwuo
	 O2N0jntPI46RQ==
Date: Fri, 06 Dec 2024 16:05:26 -0800
Subject: [PATCH 02/50] libxfs: adjust xfs_fsb_to_db to handle segmented
 rtblocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352751977.126362.6614323652955366394.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Update this function to handle segmented xfs_rtblock_t, just like we did
for the kernel.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/util.c b/libxfs/util.c
index ed48e2045b484b..4a9dd254083a63 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -433,7 +433,7 @@ static xfs_daddr_t
 xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb)
 {
 	if (XFS_IS_REALTIME_INODE(ip))
-		 return XFS_FSB_TO_BB(ip->i_mount, fsb);
+		 return xfs_rtb_to_daddr(ip->i_mount, fsb);
 	return XFS_FSB_TO_DADDR(ip->i_mount, (fsb));
 }
 

