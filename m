Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB86D171A5
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372878; cv=none; b=fJiZqQ2cs+hSj621o0VarqOXGQ3QHVviwzlnTPs3HNg8/wycV4t4PotbNXSfXOTV2LR7P2r4CvpvcqPyuIHYjd0bUJrPPv7O3Q3W9NiREKiYqH6O9re9M63KLzd4OJbzj1n56vILWJYpthzkEqp5GURB5exR1yzvpk8rTJ9NbYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372878; c=relaxed/simple;
	bh=scTZDCFSswLnaqS6gV16unayvsayqsmKXyUwWuNHHaI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KbDCcyTI8MhiDt9neG9tE0rbNgb6N1P/MHIwmdeVWcKq3c1OL69GhRo3p3lRuw0nniOFvPJ0dEkVrK6hoq9/Q/e3oVm5J4qkrWPABgs9xUn4m9YlW4kH8QkKpD5ztWDhbU/7DE8vSrjSO43lvfuPE1gkZ8+C14hToiegxMcxp54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uxLyqH+K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uxLyqH+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797B0C32782;
	Fri, 23 Aug 2024 00:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372877;
	bh=scTZDCFSswLnaqS6gV16unayvsayqsmKXyUwWuNHHaI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uxLyqH+KOAiUc40PZMJg88SvF4sZ5zAaI2EYt0WYqjHs6AIb/iPr+gwSZuOQSZXDB
	 6RuaAr9EPehRI4IeZQGHxg0uqohmHDlRNtrRB72MALMLzAo4rXAmpnfzkTFfVXTVhI
	 hQ0VPaxMEYSaXZIV8NUT9gfsOF8WDKRcrkK9L8h1Fds1zR1JcKNYULElosjeihJ1wF
	 TwWiJ43aRbGhS9KpVhlnu75HElKDJepd9dPRhYB8qc700GoXAXfrNhitIzVz5sI3em
	 SozTy3Me/Xs6lYMcFA6bVtxLHv3QVaqFqwkKOKEinu/d3edATzXxEzqimWE8uycYVI
	 sIE2mQX34KNVA==
Date: Thu, 22 Aug 2024 17:27:56 -0700
Subject: [PATCH 26/26] xfs: mask off the rtbitmap and summary inodes when
 metadir in use
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437088974.60592.14197020803560709058.stgit@frogsfrogsfrogs>
In-Reply-To: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
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

Set the rtbitmap and summary file inumbers to NULLFSINO in the
superblock and make sure they're zeroed whenever we write the superblock
to disk, to mimic mkfs behavior.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_sb.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index f94d081f7d928..3dc6d272519ba 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -656,6 +656,13 @@ xfs_validate_sb_common(
 void
 xfs_sb_quota_from_disk(struct xfs_sb *sbp)
 {
+	if (xfs_sb_version_hasmetadir(sbp)) {
+		sbp->sb_uquotino = NULLFSINO;
+		sbp->sb_gquotino = NULLFSINO;
+		sbp->sb_pquotino = NULLFSINO;
+		return;
+	}
+
 	/*
 	 * older mkfs doesn't initialize quota inodes to NULLFSINO. This
 	 * leads to in-core values having two different values for a quota
@@ -784,6 +791,8 @@ __xfs_sb_from_disk(
 		to->sb_metadirino = be64_to_cpu(from->sb_metadirino);
 		to->sb_rgcount = be32_to_cpu(from->sb_rgcount);
 		to->sb_rgextents = be32_to_cpu(from->sb_rgextents);
+		to->sb_rbmino = NULLFSINO;
+		to->sb_rsumino = NULLFSINO;
 	} else {
 		to->sb_metadirino = NULLFSINO;
 		to->sb_rgcount = 1;
@@ -806,6 +815,13 @@ xfs_sb_quota_to_disk(
 {
 	uint16_t	qflags = from->sb_qflags;
 
+	if (xfs_sb_version_hasmetadir(from)) {
+		to->sb_uquotino = cpu_to_be64(0);
+		to->sb_gquotino = cpu_to_be64(0);
+		to->sb_pquotino = cpu_to_be64(0);
+		return;
+	}
+
 	to->sb_uquotino = cpu_to_be64(from->sb_uquotino);
 
 	/*
@@ -941,6 +957,8 @@ xfs_sb_to_disk(
 		to->sb_metadirino = cpu_to_be64(from->sb_metadirino);
 		to->sb_rgcount = cpu_to_be32(from->sb_rgcount);
 		to->sb_rgextents = cpu_to_be32(from->sb_rgextents);
+		to->sb_rbmino = cpu_to_be64(0);
+		to->sb_rsumino = cpu_to_be64(0);
 	}
 }
 

