Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C4218BC1C
	for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2024 06:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729838089; cv=none; b=t+jCRvpLb4YFuA7bNkav5AIbNYwCSsXdMSW3d2C0AN7QX7lULVdYnfU3xOlrLsGxuIthRWTkO8rtPjoAab7CsbVQSe7N41KsouVhx0RWDJzyu4wN4Ozbow1qwu/pt6lfiSGHTFTwYb1uXcvmmNDjO5YlKs/MSO9qDSt1+5NAYUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729838089; c=relaxed/simple;
	bh=kKP/2oRyEUxg0nSFFlYpDqEs/i5i9P3MINTQ9KdOlA8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wk72CKu64J1ZQPjg9BZtnd0pJg612PzB1CDtaf7wekfBwOllG9UPNvbLL+/hFQsc3UKk+N1u+z2dyhATSA4eeD7iUy9CQqgHC5aMbJik+n23mWAa3UKIiNkcrszU0bjm31WFJejnwTx/rpnEfrGxFx8tqa4BmfFVtePKf+o0hpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TAS1JThq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TAS1JThq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D07C4CEC3;
	Fri, 25 Oct 2024 06:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729838088;
	bh=kKP/2oRyEUxg0nSFFlYpDqEs/i5i9P3MINTQ9KdOlA8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TAS1JThqTIDvzBNzd6VBUBiQ1R5Rt95hQV47hbl4l3dK8P/GzDsORNDa82ZHI2fZh
	 BkOiKXiJqnk3Yb0QnqtBPKOi7guabftKlt5yub4eT20YSPZEbQWaRmATo3m6eN7HBD
	 S49RJbrPZ6wrPTagKDarBWyV8jjRq5C1o6BFkSJ/Buhb31/YS7Fl4A2OxnkhvsxgX2
	 92FJsB0MCtpkpjJb/4tzvcPNI1m3qXXYM0BP5HYxqm8wJUKI/y0JegLtWbWJ65yEA9
	 AIts8BzI7pQvgw72no708Za9zue6yyYuIj645+hQAK8ZRhRDqVGev1qzakWweQawot
	 P13sxCcYm792w==
Date: Thu, 24 Oct 2024 23:34:48 -0700
Subject: [PATCH 2/8] xfs_db: report the realtime device when associated with
 each io cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172983773759.3041229.6653374398230478526.stgit@frogsfrogsfrogs>
In-Reply-To: <172983773721.3041229.1240437778522879907.stgit@frogsfrogsfrogs>
References: <172983773721.3041229.1240437778522879907.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When db is reporting on an io cursor and the cursor points to the
realtime device, print that fact.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/block.c |    2 ++
 db/io.c    |   11 +++++++++++
 db/io.h    |    1 +
 3 files changed, 14 insertions(+)


diff --git a/db/block.c b/db/block.c
index 22930e5a287e8f..bd25cdbe193f4f 100644
--- a/db/block.c
+++ b/db/block.c
@@ -133,6 +133,8 @@ daddr_f(
 			dbprintf(_("datadev daddr is %lld\n"), daddr);
 		else if (iocur_is_extlogdev(iocur_top))
 			dbprintf(_("logdev daddr is %lld\n"), daddr);
+		else if (iocur_is_rtdev(iocur_top))
+			dbprintf(_("rtdev daddr is %lld\n"), daddr);
 		else
 			dbprintf(_("current daddr is %lld\n"), daddr);
 
diff --git a/db/io.c b/db/io.c
index 26b8e78c2ebda8..3841c0dcb86ead 100644
--- a/db/io.c
+++ b/db/io.c
@@ -159,6 +159,15 @@ iocur_is_extlogdev(const struct iocur *ioc)
 	return bp->b_target == bp->b_mount->m_logdev_targp;
 }
 
+bool
+iocur_is_rtdev(const struct iocur *ioc)
+{
+	if (!ioc->bp)
+		return false;
+
+	return ioc->bp->b_target == ioc->bp->b_mount->m_rtdev_targp;
+}
+
 void
 print_iocur(
 	char	*tag,
@@ -171,6 +180,8 @@ print_iocur(
 		block_unit = "fsbno";
 	else if (iocur_is_extlogdev(ioc))
 		block_unit = "logbno";
+	else if (iocur_is_rtdev(ioc))
+		block_unit = "rtbno";
 
 	dbprintf("%s\n", tag);
 	dbprintf(_("\tbyte offset %lld, length %d\n"), ioc->off, ioc->len);
diff --git a/db/io.h b/db/io.h
index bb5065f06c0d8e..8eab4cd9c9a464 100644
--- a/db/io.h
+++ b/db/io.h
@@ -60,6 +60,7 @@ extern void	xfs_verify_recalc_crc(struct xfs_buf *bp);
 
 bool iocur_is_ddev(const struct iocur *ioc);
 bool iocur_is_extlogdev(const struct iocur *ioc);
+bool iocur_is_rtdev(const struct iocur *ioc);
 
 /*
  * returns -1 for unchecked, 0 for bad and 1 for good

