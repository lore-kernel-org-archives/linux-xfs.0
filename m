Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9241E484
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389830; cv=none; b=DcnhbcnNNdzl9zlqU5f35pkIyeXb4bcgL062+VLc/KMxtXP7tT3CNNu44hKKYaynvw8N01grHuEeoX40q5OrEyk8RDzx5F43puzj7OCkBRNllvfNRMRF/KNoy13XhWSqOkS7vV+nipbFCj5a4rWeINomKOjvvgmpR0EkhNmJOAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389830; c=relaxed/simple;
	bh=/MrXwuoDzDCOVYOWOR+mHR4wIA6GiHTQY87KXDaFgXE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hkZSwSQn0g4j8VB6WNWCvMHcVAmOlHWeQ3ssRHYxTsH60ePcW+orNCsfG++6pCo+W1gagiEs1DSIahqDJ9L2ycGYRQe+Iv8whqsJx/OwMXmthiXfGlhDX6czUChDul2CAD8wFpRTOuQqKoiHK0NnQFQDqRZ/a24B2zTghISegVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kZ++ip0i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kZ++ip0i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA23AC072AA;
	Wed, 17 Apr 2024 21:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389830;
	bh=/MrXwuoDzDCOVYOWOR+mHR4wIA6GiHTQY87KXDaFgXE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kZ++ip0ip4JvPOY4IQUMoi95sVlwlJeVWay0NLJ6/eTtQfVlVWRYtFVbAVxQozomD
	 KYfBfQQump7bmtQfO2e4sBqUB1GlTwRw77eXIwdZjFof2RZMEuhEzvJ6bKPZlchrVe
	 Kt6h2ebYtuxJwqx05fbOLYg07TSzxLbBBvr7JQBPjDq8zQxkMDz66alnRpcGRyQUWA
	 mHOrJvq35/DEx7iqxxHPtCR3kV/BzRcdz3JBLAWyhhISxV2a5amOBMHFQ8skV8q2Kz
	 v+VrhORJIBUy7vwehlykegE+FlCXQecbPg87JPjC9vZwd2PY4kzMfxDlvspga55GoG
	 GuWfFXy4bRaCA==
Date: Wed, 17 Apr 2024 14:37:10 -0700
Subject: [PATCH 59/67] xfs: use xfs_attr_sf_findname in
 xfs_attr_shortform_getvalue
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171338843226.1853449.13831289348811435560.stgit@frogsfrogsfrogs>
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

Source kernel commit: 1fb4b0def7b5a5bf91ad62a112d8d3f6dc76585f

xfs_attr_shortform_getvalue duplicates the logic in xfs_attr_sf_findname.
Use the helper instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_attr_leaf.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)


diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 8f1678d29..9b6dcff34 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -845,23 +845,17 @@ int
 xfs_attr_shortform_getvalue(
 	struct xfs_da_args		*args)
 {
-	struct xfs_attr_shortform	*sf = args->dp->i_af.if_data;
 	struct xfs_attr_sf_entry	*sfe;
-	int				i;
 
 	ASSERT(args->dp->i_af.if_format == XFS_DINODE_FMT_LOCAL);
 
 	trace_xfs_attr_sf_lookup(args);
 
-	sfe = &sf->list[0];
-	for (i = 0; i < sf->hdr.count;
-				sfe = xfs_attr_sf_nextentry(sfe), i++) {
-		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
-				sfe->flags))
-			return xfs_attr_copy_value(args,
-				&sfe->nameval[args->namelen], sfe->valuelen);
-	}
-	return -ENOATTR;
+	sfe = xfs_attr_sf_findname(args);
+	if (!sfe)
+		return -ENOATTR;
+	return xfs_attr_copy_value(args, &sfe->nameval[args->namelen],
+			sfe->valuelen);
 }
 
 /* Convert from using the shortform to the leaf format. */

