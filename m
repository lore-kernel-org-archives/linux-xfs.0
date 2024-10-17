Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D921DEFEA
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191405; cv=none; b=SHvz/DOIoJgXCG4PCURDJudSNCu185jr82du8f3+HwV3e5MOZBkQmSCjSVTWgehey1vvdn7evdecF1Z6WdjjGuqSuFv5AQw3rDy/qcp/lpZ3vEMjHY8USQq0dinTN0JC9lZD1LJgZleyHPF1ePw3qhAeSuh1eGivm5Y81HwCyV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191405; c=relaxed/simple;
	bh=i82DjwBy5wpzgDm79r27NZwe37NgTKHcyFQ9oWcOwVw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uYxv99Afbp4AT5sbMAq24ICggofyuVhO12nIAImmvrVCRoLai+wh33MYGYmbsgLE2NDVywb+SbRUNC3HI12BjxRSR4XLct50R4RlnaO4y9ZTxxxTrkwOtmJLGSw1VdBvZnPUHoJYPPBhpvelt3T+5t4su2pKN8IuxsJYrIvyhKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z2goSf3Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z2goSf3Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5FC0C4CEC3;
	Thu, 17 Oct 2024 18:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191405;
	bh=i82DjwBy5wpzgDm79r27NZwe37NgTKHcyFQ9oWcOwVw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Z2goSf3Z4ZBcBvIv1Zool4R93ibshKtcp/SVLogKQPETgbqY96AhhGk/bVOvWjkgQ
	 f0V8m+Ngav4k8EUfwReI4PYbDA0WLYWuJcLJhigXqfsFs7xy4flz73D2r7Ba9L1Q6S
	 YK6lvabOrbqcH9HY7DbFKpCc01XqTndREs8YG3wO6kPTpKgWIoDTqnWl0SEZBXnPeo
	 cxh83GH4ceoBG1peb8AdhZwAWwVANKFy7AUL3EsYHXkIdg+DU4Xo0sTTS+V/m8G7V/
	 GGuGvakjWz3EgY6Lv1C9FbFIz+vK7ghbHHmGL5i7PKukhafJpmmp9n1ox19DHRxFZY
	 bnX97WrNrINyQ==
Date: Thu, 17 Oct 2024 11:56:45 -0700
Subject: [PATCH 12/29] xfs: advertise metadata directory feature
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919069656.3451313.7243337978120122193.stgit@frogsfrogsfrogs>
In-Reply-To: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
References: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Advertise the existence of the metadata directory feature; this will be
used by scrub to decide if it needs to scan the metadir too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_fs.h |    1 +
 fs/xfs/libxfs/xfs_sb.c |    2 ++
 2 files changed, 3 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 860284064c5aa9..a42c1a33691c0f 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -242,6 +242,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* large extent counters */
 #define XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE (1 << 24) /* exchange range */
 #define XFS_FSOP_GEOM_FLAGS_PARENT	(1 << 25) /* linux parent pointers */
+#define XFS_FSOP_GEOM_FLAGS_METADIR	(1 << 26) /* metadata directories */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 19fa999b4032c8..4516824e3b9994 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1295,6 +1295,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_NREXT64;
 	if (xfs_has_exchange_range(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE;
+	if (xfs_has_metadir(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_METADIR;
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 

