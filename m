Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8578C8C1E
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710294658; cv=none; b=mpvRH4fvI5qtS1ydkUN3WP45T4KetR8rHpwwLf8hTfpE+oyjt0ufne8thZSt3u+UibTa9ZfpWEC94Nk5hcOGEdZqD1Ybl3FbWhAmZ6hSGQD8jihc4wYzNA1yLjdGIGuKgcXLVCmZzoBLCqBQRyTKigpbAaUTJ1kQIJbwdgaGQTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710294658; c=relaxed/simple;
	bh=kLouoMSZrdwyHJmnlST4PT1rSMPdvO8Dfrh1zxGQ5vc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PjGzHXDahTGa9abHJf+NagLdWKtUfK1Bq6i6CwpjXhbf1hxPYhNwXsGgGM4allPscBT2BOPW6DyFac8CbGc/CmAutP0aBps6brpY1cPyv+AzdCmIF67gu9mXQaEWEc4C+cVPKNboF4PCYFi3nU0lX0/u2c8FKhmR/6MuLzk12uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mPXhoEfN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mPXhoEfN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA60C433F1;
	Wed, 13 Mar 2024 01:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710294658;
	bh=kLouoMSZrdwyHJmnlST4PT1rSMPdvO8Dfrh1zxGQ5vc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mPXhoEfN67AMvBTWLxUChwppj2sbesBDnYeODCSpKr2t70vMErzah0mGFjv6GPeJ1
	 rXl7DatOKGxWtPCZSN5GYgiux2HFZEigqivEhmqzytKcKRP/3ah41q/yvK+jxwKF0/
	 POXsvH0XjhmiiJ/IZYb4UvJKZE5Uz9k12BldDVhzuUBKDX78zPb5OJXBlsk0YZ02FL
	 qeuiFxkmolUT9U71ZxuXA/AUjIqh2ifKIkufVrGA3SAe77QWiju13qkHC5MQMMp9I1
	 C0rUppHh7oIKb+eETHSJJgTsd7BW2FSFqfzRh6f/wo1a3V+lQVWc/LAOExqMusT+d4
	 8S1Tb7Zccf87w==
Date: Tue, 12 Mar 2024 18:50:57 -0700
Subject: [PATCH 05/13] libxfs: use helpers to convert rt block numbers to rt
 extent numbers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171029430629.2061422.7288266899318934644.stgit@frogsfrogsfrogs>
In-Reply-To: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
References: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
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

Now that we have helpers to do unit conversions of rt block numbers to
rt extent numbers, plug that into libxfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/trans.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/trans.c b/libxfs/trans.c
index a05111bf63c4..bd1186b24e62 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -19,6 +19,7 @@
 #include "xfs_sb.h"
 #include "xfs_defer.h"
 #include "xfs_trace.h"
+#include "xfs_rtbitmap.h"
 
 static void xfs_trans_free_items(struct xfs_trans *tp);
 STATIC struct xfs_trans *xfs_trans_dup(struct xfs_trans *tp);
@@ -1131,7 +1132,7 @@ libxfs_trans_alloc_inode(
 	int			error;
 
 	error = libxfs_trans_alloc(mp, resv, dblocks,
-			rblocks / mp->m_sb.sb_rextsize,
+			xfs_rtb_to_rtx(mp, rblocks),
 			force ? XFS_TRANS_RESERVE : 0, &tp);
 	if (error)
 		return error;

