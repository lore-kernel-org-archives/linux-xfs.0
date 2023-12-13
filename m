Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83268183A
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 22:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qNno15MS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC7FC433C8;
	Wed, 13 Dec 2023 22:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702507933;
	bh=BgOLN28fAx0WmH0yJ3uCY99mlWRGRhFvTFAz+n82vww=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qNno15MSBUxRYChlMhEEWOW9g6cjuY2/cPLYNvGwma9jlRnaIAvBGDJOgSvc013WW
	 gdbNG0UITXJe8NDZhUJH/R1v917jnsIXA2LIPlkk1PuJ+09XdXaJ53m0JeReonm/9w
	 wFhNLk6iKGgHyYctP2tHkBXJjEk2xQJcduJikF04rt5+Yopy8SyOJ4DuMh7wNsUZe7
	 bzzaO0omUREClQEhod8Oh5ZuHZE6HPYZaRe5lx1P0gNkImcKgHWWfdNLlUAnNnhwPH
	 JOq+yJSL2eJklPiGHQ05K0TZr41HKQWQhFwD4is37ASMyqJa6O+8/TfRkeWjX7BCpX
	 aSAfQ/jdqkWyw==
Date: Wed, 13 Dec 2023 14:52:13 -0800
Subject: [PATCH 2/6] xfs: set XBF_DONE on newly formatted btree block that are
 ready for writing
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, chandanbabu@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170250783054.1398986.4495796106537845155.stgit@frogsfrogsfrogs>
In-Reply-To: <170250783010.1398986.18110802036723550055.stgit@frogsfrogsfrogs>
References: <170250783010.1398986.18110802036723550055.stgit@frogsfrogsfrogs>
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

The btree bulkloading code calls xfs_buf_delwri_queue_here when it has
finished formatting a new btree block and wants to queue it to be
written to disk.  Once the new btree root has been committed, the blocks
(and hence the buffers) will be accessible to the rest of the
filesystem.  Mark each new buffer as DONE when adding it to the delwri
list so that the next btree traversal can skip reloading the contents
from disk.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree_staging.c |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index 29e3f8ccb185..1c5f9ed70c3e 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -342,6 +342,12 @@ xfs_btree_bload_drop_buf(
 	if (*bpp == NULL)
 		return;
 
+	/*
+	 * Mark this buffer XBF_DONE (i.e. uptodate) so that a subsequent
+	 * xfs_buf_read will not pointlessly reread the contents from the disk.
+	 */
+	(*bpp)->b_flags |= XBF_DONE;
+
 	xfs_buf_delwri_queue_here(*bpp, buffers_list);
 	xfs_buf_relse(*bpp);
 	*bpp = NULL;

