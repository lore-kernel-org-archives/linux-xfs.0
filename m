Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCEAC127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DzKgpr/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39992C433C7;
	Sun, 31 Dec 2023 23:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064532;
	bh=Cy54tTxG0v4o5HirQfVqBZ5O0+3Y3LPaVajK8+SsnpI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DzKgpr/fOUTdtA+c04Jj5qzJJ/5Ze5q3GwV5X04720VtE7a/43WYN7sVVhLWFZtss
	 J/aodEyyn81r8NVh0TN4TVSXHXfpCxFajb3U/RD3zNZAt6esSPHHn1j4dTlPrkfHaN
	 uOyVT/lOSI4zPjs+XTxXyuBHqfQX2KbqpY970IgmF0ttJZlJ2zXZXOhtehut0dXj4A
	 GzWZHQjGstj4H0e2vXb/G7hqN+GYxdh8m0b9FLsLDgKpuzA9v1uR0pmIT3/iTFwUeV
	 fJdYIUVckYKjM0uFCRlObtm32cAzsmoBAOIOY37XeBPpei/LSSxACMGHqDdRd2HN9n
	 J9LyCvHyjmjWQ==
Date: Sun, 31 Dec 2023 15:15:31 -0800
Subject: [PATCH 08/18] xfs: actually rebuild the parent pointer xattrs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405006969.1805510.10773893656651536282.stgit@frogsfrogsfrogs>
In-Reply-To: <170405006850.1805510.11145262768706358018.stgit@frogsfrogsfrogs>
References: <170405006850.1805510.11145262768706358018.stgit@frogsfrogsfrogs>
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

Once we've assembled all the parent pointers for a file, we need to
commit the new dataset atomically to that file.  Parent pointer records
are embedded in the xattr structure, which means that we must write a
new extended attribute structure, again, atomically.  Therefore, we must
copy the non-parent-pointer attributes from the file being repaired into
the temporary file's extended attributes and then call the atomic extent
swap mechanism to exchange the blocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c |    2 +-
 libxfs/xfs_attr.h |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index cb4c2726fd7..5da0ac9f706 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -933,7 +933,7 @@ xfs_attr_defer_add(
 	trace_xfs_attr_defer_add(new->xattri_dela_state, args->dp);
 }
 
-STATIC int
+int
 xfs_attr_add_fork(
 	struct xfs_inode	*ip,		/* incore inode pointer */
 	int			size,		/* space new attribute needs */
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 0204f62298c..a2cfe9e35fd 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -650,4 +650,6 @@ xfs_attri_can_use_without_log_assistance(
 	return false;
 }
 
+int xfs_attr_add_fork(struct xfs_inode *ip, int size, int rsvd);
+
 #endif	/* __XFS_ATTR_H__ */

