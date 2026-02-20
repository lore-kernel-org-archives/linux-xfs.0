Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54111DFF7
	for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 01:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771549231; cv=none; b=Y5FTBSOgIBzXHGsoBeSTxD57yQplhQzyo65LnSzqHcG1iTYJjNkIi4ZnBghK7zeeOvqngPGJtNhFDeNzArbaiuLZIbkzdterFZf1Ew489AyT0fHQ8e5/w7gXbORa0Nr9lTajg21EL/Q0ugobTPluRm5mJpaQSJvYCYIHv+31A3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771549231; c=relaxed/simple;
	bh=yWG/BPaSdrdZ8T62ZosKwpjalTOU+wuXFP5zUlvLjek=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QkW0jN4saZ2/X1O36zOq164qFYg+lWJg4jFLbuuaf/Nkloa0Trx0rc41+CLwNdYgoKzelHnTprUcxuPkTsPkxYGOy2u1MWE4fbAcUjZ5jHvBrD/9rpp687FYYfp9PxM/wzYbUwpLy3J2qP6cITziRlxJqvV8k+JZZadcku27mPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fyFabvkA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fyFabvkA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA371C4CEF7;
	Fri, 20 Feb 2026 01:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771549231;
	bh=yWG/BPaSdrdZ8T62ZosKwpjalTOU+wuXFP5zUlvLjek=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fyFabvkAnbTdVkQyca4zSiDQNXx4Q4uAQG47oTyYxkbIpOGooNlRD5s2q3qRvDus/
	 FU+nTS//HNj0MNsZOr+bUBn5EA11MKTxNzBM8pZ/R8I3MQ4hGQEwkGErma5ejnHvFx
	 cFSjOEQm91diXyRbBbRuSttg6lAcul944aWkZQ+vxHVRe+SSpgTtHHWqgKb2ZJokMk
	 MmW9n2XELrm45/qRO07YYugvqCIE5yZq5+GVWTPM6dWIqwyKfTxm6+qHzbn0ApQ3ZV
	 bbYhidjpukW7J/d1G9GR3CzEmvwui5XhHBhKthlDQIPJNIMrS5YtpIUhkVGxFukJRQ
	 43tgXk7bIvzZw==
Date: Thu, 19 Feb 2026 17:00:31 -0800
Subject: [PATCH 2/6] xfs: fix xfs_group release bug in
 xfs_verify_report_losses
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: clm@meta.com, cmaiolino@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177154903705.1351708.3609536988090688024.stgit@frogsfrogsfrogs>
In-Reply-To: <177154903631.1351708.2643960160835435965.stgit@frogsfrogsfrogs>
References: <177154903631.1351708.2643960160835435965.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Chris Mason reports that his AI tools noticed that we were using
xfs_perag_put and xfs_group_put to release the group reference returned
by xfs_group_next_range.  However, the iterator function returns an
object with an active refcount, which means that we must use the correct
function to release the active refcount, which is _rele.

Fixes: b8accfd65d31f ("xfs: add media verification ioctl")
Reported-by: Chris Mason <clm@meta.com>
Link: https://lore.kernel.org/linux-xfs/20260206030527.2506821-1-clm@meta.com/
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_verify_media.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_verify_media.c b/fs/xfs/xfs_verify_media.c
index 069cd371619dc2..8bbd4ec567f8a1 100644
--- a/fs/xfs/xfs_verify_media.c
+++ b/fs/xfs/xfs_verify_media.c
@@ -122,7 +122,7 @@ xfs_verify_report_losses(
 
 			error = xfs_alloc_read_agf(pag, tp, 0, &agf_bp);
 			if (error) {
-				xfs_perag_put(pag);
+				xfs_perag_rele(pag);
 				break;
 			}
 
@@ -158,7 +158,7 @@ xfs_verify_report_losses(
 		if (rtg)
 			xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
 		if (error) {
-			xfs_group_put(xg);
+			xfs_group_rele(xg);
 			break;
 		}
 	}

