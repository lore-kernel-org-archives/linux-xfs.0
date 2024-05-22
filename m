Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504B13B2BB
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346283; cv=none; b=hV4iRoCE6gG0hMrswxOZOTXK1+IgVhBvTI1wXT4RCFwijPuc0Bcu+PLeQJzFcvi55wAQHTmN2H7oczMy2QvBeEhwrQfar2bkm9y9X3dpWwXMlcOJ40VGl6mIks8Ic/cs+4y9QJr3J1RmtBPkYU8k0RXPKDD7YzbIIm6ItnsHURE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346283; c=relaxed/simple;
	bh=r4niEDBKfZLRVHukZL+MkGWduSM1vGfutOIzA9mPlMQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I1clFUJpvX6Ly/T+JX7TjGYumcWGKFwdKZ0nRI3mAMJeV9Kwq9VXZ3iki0YHZ3MOY1J7Z0RfkGag2TT7GEY8Oww50zzz67auy3FuM/6/446tt0gmAQmScYUs1rUiEFI420vdf9RqWkkDMyeWQac5Lh/XTNuwdkFyfnoIPRbbS/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tR6/yqf/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tR6/yqf/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C63C2BD11;
	Wed, 22 May 2024 02:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346282;
	bh=r4niEDBKfZLRVHukZL+MkGWduSM1vGfutOIzA9mPlMQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tR6/yqf/liKWNVUq79yVZK9dvCDV0NNtqbrF3UAcbI4rw+8/tOLs2SdSB3pNiRoEF
	 go1c+WwfB0ilTK2JhpzuQRBP0D59yZZV+XJE5Y5cXzaKawJdTT0cQT9gjeYaFOVkzt
	 omRa7jJWZa0oNcAnq28QU+hV4D/69hZ2HwJZsjD8s7J6O4DNVydfCiG4ucwDMaB7cd
	 1U4sQSvweUKonUdOVsg8enF2A5M+WIVwL96VNHrMOPPMzY/g//nwdC7lTL6mxO9uVy
	 ldR0TBxih3Eo1GS+KUySmEhL3XZsxTo20JKv5IKkkKHzjPUkgCRUf5XfpVgxm4rkRM
	 pKJkCYe48kTOg==
Date: Tue, 21 May 2024 19:51:22 -0700
Subject: [PATCH 010/111] xfs: create a predicate to determine if two xfs_names
 are the same
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634531861.2478931.12143791895458554398.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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

Source kernel commit: d9c0775897147bab54410611ac2659a7477c770c

Create a simple predicate to determine if two xfs_names are the same
objects or have the exact same name.  The comparison is always case
sensitive.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_dir2.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)


diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index 7d7cd8d80..8497d041f 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -24,6 +24,18 @@ struct xfs_dir3_icleaf_hdr;
 extern const struct xfs_name	xfs_name_dotdot;
 extern const struct xfs_name	xfs_name_dot;
 
+static inline bool
+xfs_dir2_samename(
+	const struct xfs_name	*n1,
+	const struct xfs_name	*n2)
+{
+	if (n1 == n2)
+		return true;
+	if (n1->len != n2->len)
+		return false;
+	return !memcmp(n1->name, n2->name, n1->len);
+}
+
 /*
  * Convert inode mode to directory entry filetype
  */

