Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70A81B0F30
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jan 2025 21:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737063543; cv=none; b=OYBtmVNjl4+ytJ1xRc5Q5X+y06VXu5UvtXF2fDiAiuSgpixKgK0p/WWEpz7yKR2WCJTSqeCIuIiYTpprhuYekB36UEn6ILYX06GkahntpGKOZhL/sWX4yGnctX7TubWsaVFcyStN/nMzPkoIC6NbT3S3dei4PAG6/jj+4VyirFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737063543; c=relaxed/simple;
	bh=mz61MqxE1RzwA/m4v8O8qX8H3KKZ0Y6kvkaCxAoAY/A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GH6a4Z3Gsdp3lPwFyn14//FPnzSBW5thNH/wWdLvqQhcyP33UtDcxk/7CuSvnOQ/wyYcjDmcftb+J72EXASUkUw7PPs2KZIC4UKsoQdplnQQBNlcjzw6VlMODo1ICh5MzlKD2JhrlY4yvRVpObxdk6tr54EX6QaIQHM7KoRwZVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YwDGR9Ey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YwDGR9Ey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A088C4CED6;
	Thu, 16 Jan 2025 21:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737063543;
	bh=mz61MqxE1RzwA/m4v8O8qX8H3KKZ0Y6kvkaCxAoAY/A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YwDGR9EyKHCfbCTNsjhPUBuCXUu5JGTzIGLQSgyrIVdbIn8IwGfxs5qaOiCNGJsaF
	 9SIwaQoc3qydKc4eMT8CZD51vNZ9sShY3kDTLuqBcd3EpmZZ5+yzbwYReFPuI6WQUN
	 WJDyppbrc8cGfqfqVGnjrQAZevVb1nWVqxvV7kMJPdorOG3YGYCewDgBl/ozA8DmzV
	 TIEgEp7AUylShDTVbJ4/8xbYmTV/zQ37RWRZaeJKTJ2seT4oDoli5dMmaFDtuo0sQA
	 jiV6h1Px/A19xnJWYmG3zEVuojlqMy0ZiUfVsV1E/QQRN2zMtuJcfzyXZox+/4410k
	 rMEcKc4Cr3jCg==
Date: Thu, 16 Jan 2025 13:39:02 -0800
Subject: [PATCH 2/8] xfs_repair: don't obliterate return codes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173706332237.1823674.4750925735232214007.stgit@frogsfrogsfrogs>
In-Reply-To: <173706332198.1823674.17512820639050359555.stgit@frogsfrogsfrogs>
References: <173706332198.1823674.17512820639050359555.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Don't clobber error here, it's err2 that's the temporary variable.

Coverity-id: 1637363
Fixes: b790ab2a303d58 ("xfs_repair: support quota inodes in the metadata directory")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/quotacheck.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/repair/quotacheck.c b/repair/quotacheck.c
index 8c7339b267d8e6..7953144c3f416b 100644
--- a/repair/quotacheck.c
+++ b/repair/quotacheck.c
@@ -691,7 +691,7 @@ discover_quota_inodes(
 	err2 = mark_quota_inode(tp, dp, XFS_DQTYPE_GROUP);
 	if (err2 && !error)
 		error = err2;
-	error = mark_quota_inode(tp, dp, XFS_DQTYPE_PROJ);
+	err2 = mark_quota_inode(tp, dp, XFS_DQTYPE_PROJ);
 	if (err2 && !error)
 		error = err2;
 

