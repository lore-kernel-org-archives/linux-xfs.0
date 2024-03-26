Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC4E128814
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423047; cv=none; b=Jf5LVQpHA0kyc80BTGulSiy72u0lxfd3vuPnUCE59pA/I9wcbYyI2MPx8NnWYrYurSKdB5zvm5oXWI9IQtDFB+IxeGkkk1zn+xNN4Iedh4RFG9NELuMcvptpoblVawA7DE9D1yqCQpfX/X66ZtNZXjIngxIzR2ftOI+Jrp2ZDEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423047; c=relaxed/simple;
	bh=X16Apw0/sJ6B9SD0playunjdAzZJFQQy6kea7jUoois=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O9/LnyTj8bV2HjOLhh1+j76I1gLgWVKMoHGkP3JriYm3gfU/cVwub48o78ICm8ms4zQWoEfgGMwNf3CCrLEYpxjErN4H1RO8zopcbTF/y7RDRtpGqEzlTTCEWYPP1+b+v4cGJo4MGdsdYlT5sVWqmgdnMzgrq0tc3XIfoUlaEB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qqgjo1bm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qqgjo1bm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A2BC433F1;
	Tue, 26 Mar 2024 03:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423047;
	bh=X16Apw0/sJ6B9SD0playunjdAzZJFQQy6kea7jUoois=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qqgjo1bm8eSiXwRU8MFhNfb6NaJhmO9teM4nN6c+W1Zi93uWSPtVh5lB3zqL4gPDl
	 M5lJ8yToOz50hGCRyv3fcpqsG9tPCxvU69jq1S6+s49TFplNoZkV4IZ6DlKxl+L42q
	 ADQRjt2LammBTCnP15gWTLvWrka2p7+aRYogmF3Vmq1tH2nFANa1ObG8CvFP2neRI9
	 Ro+kqqS2QLrHhVsfPg7QhCZaAnXWSQMBrnL7GJ895LXKt+DOt41NseZ/7ro98NuN9P
	 UUZHr420TOdtCugvG6q2GSG8hAbAtwTomUq95T3tVUMqeQJE5nOt+KAJwDNRE4Bp8l
	 teae8NFUQKKNA==
Date: Mon, 25 Mar 2024 20:17:26 -0700
Subject: [PATCH 56/67] xfs: move the xfs_attr_sf_lookup tracepoint
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171142127764.2212320.16574066365094578591.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
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
index a21740a87aea..10ed518f30ee 100644
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

