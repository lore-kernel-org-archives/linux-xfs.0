Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E56B22CBC8
	for <linux-xfs@vger.kernel.org>; Fri, 21 Mar 2025 16:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742574692; cv=none; b=VoXh8+diwIw7jTAX7cC6fw9ZdPFP1+KJysiwDKAqvNfdfFszrSxn2QJd4eZ0wYUmB8BJ9vGw2ivoHyKXXaC15f52ybxe/ER3zhlgGgzVI30KUpyNmfGdplVv3fFiBdXeNDr0hvJ5Owo3O9M8N10rmweGO1GauSMrA+1l9I5JoMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742574692; c=relaxed/simple;
	bh=yVWE/76+ZWsgnY5P5u77BzSioGBJ9AQ+7fyBDxcGy/k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p11kD5PKprbVJN7Gkfd5D/wHZUCpxsT7h1+h6TXaR1yfbEq3xPtUGFqZ0N6X8sfilUeMUY5pzpwLVLIMXZnx+4w7grr+ZA2QpYh1ff77K359W7ZM/eEZkBQPQ1qP9FUrnZqpsXYf6Li5PNfhIP1ds01BOQTkjCONK73cCFAJPOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OiVEyKqk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OiVEyKqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793BCC4CEE3;
	Fri, 21 Mar 2025 16:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742574691;
	bh=yVWE/76+ZWsgnY5P5u77BzSioGBJ9AQ+7fyBDxcGy/k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OiVEyKqkQzEBBBHUEqY4cE0hlizDdgBCc4wo/zG5Vtje+2/2rUpxhdI+83jy3JoT1
	 C67YU0WvPQBvWgoCrg/TYwSSAB9BjcHBlGmJ8u8O2BiZ49tjVsEVTzMV54VB5BPRzU
	 I//ktr+2ewOFT2nftxxpyN9kdcAUbSgaME5eqjjk1AglTZT74g9Cr1dVauBEZ+t4PQ
	 4+GrhiN1wgBL6oqsCYcGrqpSU1rne0lQw8cc7q7tfD3UIHxQuuZelDio40TYYh/+SB
	 RYpDSQqcur1zpDQj8eCwCtlGgXpUiBYRaaXHCi4zUseD++K8+L6qduQr59KL94BZQg
	 nsqMDYn/fxHLg==
Date: Fri, 21 Mar 2025 09:31:31 -0700
Subject: [PATCH 1/4] xfs_repair: don't recreate /quota metadir if there are no
 quota inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <174257453614.474645.7529877430708333135.stgit@frogsfrogsfrogs>
In-Reply-To: <174257453579.474645.8898419892158892144.stgit@frogsfrogsfrogs>
References: <174257453579.474645.8898419892158892144.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If repair does not discover even a single quota file, then don't have it
try to create a /quota metadir to hold them.  This avoids pointless
repair failures on quota-less filesystems that are nearly full.

Found via generic/558 on a zoned=1 filesystem.

Cc: <linux-xfs@vger.kernel.org> # v6.13.0
Fixes: b790ab2a303d58 ("xfs_repair: support quota inodes in the metadata directory")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/phase6.c |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/repair/phase6.c b/repair/phase6.c
index 4064a84b24509f..2d526dda484293 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -3538,6 +3538,11 @@ reset_quota_metadir_inodes(
 	struct xfs_inode	*dp = NULL;
 	int			error;
 
+	if (!has_quota_inode(XFS_DQTYPE_USER) &&
+	    !has_quota_inode(XFS_DQTYPE_GROUP) &&
+	    !has_quota_inode(XFS_DQTYPE_PROJ))
+		return;
+
 	error = -libxfs_dqinode_mkdir_parent(mp, &dp);
 	if (error)
 		do_error(_("failed to create quota metadir (%d)\n"),

