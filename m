Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF4E524C
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300216; cv=none; b=j/MK1lg83XMdk+gE1ZoFnDhtNUj/Eg3+JQ4R7Aihi5CEBmzjjMNYbDamrJEyUYSnH4asudRAzlv9bstuXg7K3B0f6dLnDVJVwIjhKFT5bHFtfmmb+E6AJXjpgxzxE+usa8eY8LR07IkUFICPgfdF8ZMPpTBhaMqzPqUy+WJiA3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300216; c=relaxed/simple;
	bh=rSuRLugBS0uhnnP0iz31CrhGTnafo25QxAP5LRhS7SQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B5UBZlTdOWIRAwZUQU0JSxvUeQRcCINjJuxz2Ac7fr7vhRBsN7IWr05ZokH6WDCODlULovC2Wt1sR4OET/KG2gNzJnovA90MSz86tqJvMienmS2kyn1gl3O+b3xul5UCzwoPFuGWy6SNKTytSDwILtHzqRRplEA8vwGIlUFa4v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HsvS6JbW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HsvS6JbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D5BC32786;
	Tue, 30 Jul 2024 00:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300216;
	bh=rSuRLugBS0uhnnP0iz31CrhGTnafo25QxAP5LRhS7SQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HsvS6JbW0XKU4Mi69Eb/LGyJGOXs/LVotSYoNvg5Foyq7TZOYMwhgFediIPv4f8y3
	 FizZrKR+YJkoU8RRyOwzUYQIBoqNyMCf/kIQSkSIZlyXnsOK56nvgqUQL6dMZoLQHs
	 yJD284IIW3YTPCtxzg1lRyhzYC4QqJQzNmwrLgY5aZkEFrGGDGvuqaxHhU6fN5Wen+
	 U53egddga6v4EyiMalTHXjLDDLHgSupBrAmsB1+WfSn+sPygYxzTb0NnlWjtJ277xr
	 WH4R1wYsg2kloE+oStb42eK0BEbE29H+1pfwhhf2Ydd/nnbTotA7faC0irBxvqY7An
	 KKdSsgt5GPFOw==
Date: Mon, 29 Jul 2024 17:43:36 -0700
Subject: [PATCH 076/115] xfs: enable parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843515.1338752.3328406806785187710.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: 67ac7091e35bd34b75c0ec77331b53ca052e0cb3

Add parent pointers to the list of supported features.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_format.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index b457e457e..61f51becf 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -382,7 +382,8 @@ xfs_sb_has_ro_compat_feature(
 		 XFS_SB_FEAT_INCOMPAT_BIGTIME | \
 		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR | \
 		 XFS_SB_FEAT_INCOMPAT_NREXT64 | \
-		 XFS_SB_FEAT_INCOMPAT_EXCHRANGE)
+		 XFS_SB_FEAT_INCOMPAT_EXCHRANGE | \
+		 XFS_SB_FEAT_INCOMPAT_PARENT)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool

