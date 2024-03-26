Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36AE1D53C
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423861; cv=none; b=X+Nl3NI7TXjkjcTrchOBHWNsxRrtVyZ9H0IRXNMyjkVJPlGG1u+qk1CKNNwTyuJ41M1QsR50Ds7VBmUHRDi5ad2thmYl991sp7AKqr3JtQW1d0J2MXWOT4fdBgd4kBAjpd9G549nnXfBwXFTEzAUB9SShaqWFhttblmGA2NwHh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423861; c=relaxed/simple;
	bh=APKZMPtaqgjWnIPbEFUysMNwXiP8SvKUn0YnHWmg4Q4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ek8K3mO5wry0NwIYuAqIhkJJhVhMx8yJCek6+XCUH2EqnA79fh/FA9pTeeWoGuquYqLwGlTfy8LamLm8JnhhXYj3WHjTvuD3/BrNnFlKhsI5rWXaRhx6FluT55+enab2ujGjg9LdLttjdcXzwGp9bif6soVo3hjyJyfbJ3kb65E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XknqauEq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XknqauEq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3EAC43390;
	Tue, 26 Mar 2024 03:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423861;
	bh=APKZMPtaqgjWnIPbEFUysMNwXiP8SvKUn0YnHWmg4Q4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XknqauEq+M6kb2ylqDcR6yHfQZzbdmMq4NaSqP0QEQXj5W8a0Ri5ym9LsemP5tMhM
	 FYAYIqQG8XdKuY2WMSzyDAe/+KMAdbM1Yf54XrcigM4d3vGRhNyKCH/Fj5TjxhkDFr
	 mQRYklO8dWFNfJ+eNNYktAcW3Daf52TBtP20sWPprgdyj1kcgFYgBtgf/XJnrGYkU4
	 5lOF7zNEcqN8YrR50HoGoX8k5dlWuzavMTahdfgHP0zL4zJRogMEMo/0f9I6ymMfFy
	 /HzmDcG0s9n+ksk8zCVsMN6pO73ezuydhpE+NidnkBTqBJM0k0XF0M/BejsXhvlrhG
	 Z3NVUh+TTfJMw==
Date: Mon, 25 Mar 2024 20:31:00 -0700
Subject: [PATCH 010/110] xfs: create a predicate to determine if two xfs_names
 are the same
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142131530.2215168.8977912361884980177.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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
index 7d7cd8d808e4..8497d041f316 100644
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

