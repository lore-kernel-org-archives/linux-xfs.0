Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E38233723;
	Mon, 27 Jul 2026 05:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785129859; cv=none; b=F37aqZvZng64dmzri3JqxJZz9dByRtiXH1OO4Yv8Oq33FilxN7Iw5sdtBKTV7RxC+ZUyKpafoSsycteHmfoKPh+ZcD5s443ocPH4GL8kwOWq5kYfv6X1L4B+SeOFhUKXaeVrzNkHFjok422yqHIWHZUAV3pZFvut9ElfcI9Vo60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785129859; c=relaxed/simple;
	bh=zWrHmed5+tOU2KTwN6cyM1kFrmoemZbMw1PxyA9xOpo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SL7AsSbXmD1hZAfDd1lD/vOvf+AO8ARIx8vGtqUjRCxtwnN9AYTu//tPgkZTyRb+8CrSQIgXIbj99GFhhs1M0uysKOd7pfhd/pI/oJMbB2oBlg1Wxvb93VxQI6frU9oc3Y49AOszxwjvu7wCnKlCOc92GXYnRRhcaq8nBNEwkT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FVe+Abj8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FVe+Abj8"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 01D481F000E9;
	Mon, 27 Jul 2026 05:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785129858;
	bh=JkClkeEU61ROQ+tHFjtCxXO0ji3p6FNuzj2rTS/XSPs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=FVe+Abj8vgsVX4/wRzpSG6/uuvcSWn8kNUQaQ+Z0gvHp+LrGpnIxB8SNEuFlHspAi
	 egYxEmTXQRb8VzFnttY5064E08HavEzRP4P+cBmh2gbop7NE3JTqQSM+rmq+XIJxSK
	 X2ukB1JbctQsN8Zt6j2IijnfaPqVxaE10bLbuyk7FS8AGiSNZABpjvKwyDjI6lS2DU
	 zwzE+AuCq7dZHhKxHA8J3YLlbqHLOo1y7JKu+k1SZuxnvxXIgf6mPkLj4uyow3ACOt
	 FK+VJ+c5+1ELu3RHXYaF/8HP0rGITWfyUmqmz9k9HJdXjRnDct8acX7GsvEGA/Oou8
	 KB5SVWV6w7qOQ==
Date: Sun, 26 Jul 2026 22:24:17 -0700
Subject: [PATCH 6/6] xfs: avoid UAF on sc->tempip in xrep_tempfile_create
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178512389294.1494795.6386595592750113083.stgit@frogsfrogsfrogs>
In-Reply-To: <178512389129.1494795.16117444961252720216.stgit@frogsfrogsfrogs>
References: <178512389129.1494795.16117444961252720216.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed a potential UAF if the tempfile creation code fails after
it set sc->tempip.  Fix that.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 84c14ee39dd388 ("xfs: create temporary files and directories for online repair")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/tempfile.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index e0c630f888cf6e..98820003b9298f 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -174,6 +174,7 @@ xrep_tempfile_create(
 		xfs_iunlock(sc->tempip, XFS_ILOCK_EXCL);
 		xfs_finish_inode_setup(sc->tempip);
 		xchk_irele(sc, sc->tempip);
+		sc->tempip = NULL;
 	}
 out_release_dquots:
 	xfs_qm_dqrele(udqp);

