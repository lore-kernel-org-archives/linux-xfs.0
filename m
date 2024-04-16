Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881D31849
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 00:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713229130; cv=none; b=K+ABZiI7aXzW44NY29PnezUNf/92TmNfFuVKv4HnAjm3Xr9spON9VoESk5YPlo5rqA4XUeEBeEVFwvdE7NlhJ7XreoK3kPNgtCauqxYM4mqdeDWO4WDfXN87K2HUrMXyYTIEubFz+/wF+30OVEK+CtqHW/p1p1tqRvmpCw2z/Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713229130; c=relaxed/simple;
	bh=0UuG4vBXbmEaGS75OK71jjzeajtHGu0L/38i5RTAgnQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=liCzJOPgNmmkCUHKT2SAdHHvNhNzciUK3hIFQ/cc8Q3SKeOzNgiZMOnk04LaqeC2RUV/Kcf1JNebs3B4/W3NNpsOEs5qhgVYLR4NTJEiIlR32LfU1cWgKWS6lpVAttYU5JHTV7s3moZzLJnce2DZlKttUUzr0ljTG7AuqDIQB0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nokl61+N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nokl61+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CFFC2BD11;
	Tue, 16 Apr 2024 00:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713229130;
	bh=0UuG4vBXbmEaGS75OK71jjzeajtHGu0L/38i5RTAgnQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Nokl61+N0L62v0/58dsOwNsfLyhy660ix+9b3YbETBcIEpH2LjaWmEI22VwMRj7YY
	 eAsv3VDcbkubVCR5dytliEQWTy+tm9Q8XirrchsJpqsQEbmRmxW8HEjELw952jNDtM
	 WBWjMvk45gt02SZiHi0V5RLT5bTvlDZ2tDPq4Pt95Q8nA+dKTMjXTAdj5b6ZUtphhf
	 wvkfxspoSSQ1brI+zP+TqD2vW+R6Th3igdiF9Jc5XoSeYrZl+nh6F5Gg23+D1FAZ1J
	 8sMazhGWPwPr1m2MwLyhrCai4aIk+W/QP8n/jTqYWR+/rtfPotQbwX1LDy1a+X9/Br
	 kRNZutS6gc5Pw==
Date: Mon, 15 Apr 2024 17:58:49 -0700
Subject: [PATCH 1/5] xfs_repair: double-check with shortform attr verifiers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 cmaiolino@redhat.com, linux-xfs@vger.kernel.org, hch@infradead.org
Message-ID: <171322881823.210882.3852200551354127842.stgit@frogsfrogsfrogs>
In-Reply-To: <171322881805.210882.5445286603045179895.stgit@frogsfrogsfrogs>
References: <171322881805.210882.5445286603045179895.stgit@frogsfrogsfrogs>
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

Call the shortform attr structure verifier as the last thing we do in
process_shortform_attr to make sure that we don't leave any latent
errors for the kernel to stumble over.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 repair/attr_repair.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)


diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 01e4afb90d5c..f117f9aef9ce 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -212,6 +212,7 @@ process_shortform_attr(
 {
 	struct xfs_attr_sf_hdr		*hdr = XFS_DFORK_APTR(dip);
 	struct xfs_attr_sf_entry	*currententry, *nextentry, *tempentry;
+	xfs_failaddr_t			fa;
 	int				i, junkit;
 	int				currentsize, remainingspace;
 
@@ -373,6 +374,22 @@ process_shortform_attr(
 		}
 	}
 
+	fa = libxfs_attr_shortform_verify(hdr, be16_to_cpu(hdr->totsize));
+	if (fa) {
+		if (no_modify) {
+			do_warn(
+	_("inode %" PRIu64 " shortform attr verifier failure, would have cleared attrs\n"),
+				ino);
+		} else {
+			do_warn(
+	_("inode %" PRIu64 " shortform attr verifier failure, cleared attrs\n"),
+				ino);
+			hdr->count = 0;
+			hdr->totsize = cpu_to_be16(sizeof(struct xfs_attr_sf_hdr));
+			*repair = 1;
+		}
+	}
+
 	return(*repair);
 }
 

