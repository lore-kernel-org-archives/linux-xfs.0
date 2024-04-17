Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F24C47F7C
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389784; cv=none; b=cKz15E/UybF+zn2VkS4LH1qlyZDaM4xLDatjKXMvgHkszkIxvMHI0M7IBSgh0h6PmFcrdhcrGe/NKzeSKvxo5W18vyleGGlXOieuGi8Ws7sELBjAmNPZNXruJd9suuOy1bhdMUeDdq6fKhB/MHAbdDXsH6yln6vs7JjqDF6A+r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389784; c=relaxed/simple;
	bh=3yjaXUSqS9QT5cn08zzHJNOZurgllHiT1YMyuNKTOzQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AJ1aqvFUUyujs6aui5Ge+K+KoK4Nbwn1/e1yo2BG8gZ7kBew8zVV6IkEGTCdu8mq3qwl7bkbOYlegWHfUk7RG4jH9CKETvaha1uKtnDF/2hPTVmG6iweJjdsLxsWmRAHPen7COaOcDh0tTdO9r7lRYL3HW2vLOr/ePPFELmWzJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KWy8VYp2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KWy8VYp2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD1A6C072AA;
	Wed, 17 Apr 2024 21:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389783;
	bh=3yjaXUSqS9QT5cn08zzHJNOZurgllHiT1YMyuNKTOzQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KWy8VYp2OIFrg+NvcbQa4CT4L3YBujyh+LfPUWYqed8/SG1vuwGCI6Qyynx9Gjvly
	 /2ADVRBnyOKfXCKhxCe/LRkF0+55OtUoOy4LdnuyWU+RFJ0lbqXCtC1LLCCHFIZJlo
	 4m7mEwtqxYylwlgWWpC5G9AQjJFRJ73Bv2ZBUI2M1QDI0kYeYbGfsBJqpWFaqcLiOo
	 sR7djWJbVPYB6T94uAnYEozLj6bKBVt5OfHooaCV/M+Vigg6zzQ6MItKMcEk173RMu
	 g8SFm/Dd0ggGnNQSUVGJ7vnypbEYe8Km8X8UX/KPm1zmQLq8Q5kMrI9scIiv0Qiwye
	 vd2e0ynOkrErg==
Date: Wed, 17 Apr 2024 14:36:23 -0700
Subject: [PATCH 56/67] xfs: move the xfs_attr_sf_lookup tracepoint
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171338843181.1853449.12957442507935018436.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
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

Source kernel commit: 14f2e4ab5d0310c2bb231941d9884fa5bae47fab

trace_xfs_attr_sf_lookup is currently only called by
xfs_attr_shortform_lookup, which despit it's name is a simple helper for
xfs_attr_shortform_addname, which has it's own tracing.  Move the
callsite to xfs_attr_shortform_getvalue, which is the closest thing to
a high level lookup we have for the Linux xattr API.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_attr_leaf.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index a21740a87..10ed518f3 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -873,8 +873,6 @@ xfs_attr_shortform_lookup(
 	struct xfs_attr_sf_entry	*sfe;
 	int				i;
 
-	trace_xfs_attr_sf_lookup(args);
-
 	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count;
@@ -902,6 +900,9 @@ xfs_attr_shortform_getvalue(
 	int				i;
 
 	ASSERT(args->dp->i_af.if_format == XFS_DINODE_FMT_LOCAL);
+
+	trace_xfs_attr_sf_lookup(args);
+
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count;
 				sfe = xfs_attr_sf_nextentry(sfe), i++) {

