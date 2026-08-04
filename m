Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4814399C2;
	Tue,  4 Aug 2026 09:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785836777; cv=none; b=dS5z5TaG/NQyJ/HCNtQm7/Ju1vwnxsK0Dxq4j5JLPy8bGd8mMA+GbF2bCncF7pqDTIzOFA2hHi+2Qd88XXywa8vjk6JEtSi7pBsDQGMMdjuJi8+sBHVd27tkNRZk10qJPDyoP1HGw0h+/+VFkYhD5WZsNzrfGu326fUpatpU+nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785836777; c=relaxed/simple;
	bh=OhW0DxNtB+grJr6h/lSX3eX/QTKGoU6+Emf8/E6bagM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VUQzSxybpPSp2triupJWGDy1fOWG8G+Aj4k4i0aRumj8cAlYjYK7tISg1csu4ZCF9tUbSD0NtZp5rG3uiMziDKhr4+ejOE/AKWh6dPLhDR/4m0ck5t37yFwsJ1pDqIv7TIJnTjeV+6Fti8hYBs94vQdMLb/I8y08C/hdUJNmnhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WjXv4Dsa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WjXv4Dsa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE531F00A3D;
	Tue,  4 Aug 2026 09:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785836776;
	bh=5CT6vz0QecjAwATibGZwj5uPUwM5BOI6sywpA/E+knw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WjXv4DsalGlOxkzfz+aODPbIPwutByVZ/R2maJFquF8qeghgp5+5bxgYsHK5fbCPq
	 CS+oe6e8p3JYXOA0suprbJUWtJ/YTZ4v0NQo0SWBQwgUVqB/oTwGOzh5xeAsYO41/c
	 NblIQXNsAiChljNVvVXrUTpH3pXJGO88h6MPfEN3uM1gUl1ABhCxOGR96Exl/BewLw
	 +YFj4Fgn56zPeX8uWmWCBSGnrH7URN5jhgyM4c9VYJ2y/rTBoYslbpUgo7WVBzh5FA
	 O1QQfIcvanwBaevHzeXEconX5/Pq2mEZJ2tZfv1iaWZmQmqpgacpI2fS3QSBE2FGKq
	 8EjEOwINwK4+w==
From: cem@kernel.org
To: cem@kernel.org
Cc: jack@suse.cz,
	djwong@kernel.org,
	hch@lst.de,
	serge@hallyn.com,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v4 3/5] quota: Don't issue audit messages on quota enforcing
Date: Tue,  4 Aug 2026 11:45:53 +0200
Message-ID: <20260804094602.84766-4-cem@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260804094602.84766-1-cem@kernel.org>
References: <20260804094602.84766-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Calling capable() to determine if we can bypass quota enforcement or not
can trigger spurious audit messages. We don't really require it here so
just use the capable_noaudit() version.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jan Kara <jack@suse.cz>
---
 fs/quota/dquot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 9850de3955d3..dab93422a57b 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1308,7 +1308,7 @@ static int ignore_hardlimit(struct dquot *dquot)
 {
 	struct mem_dqinfo *info = &sb_dqopt(dquot->dq_sb)->info[dquot->dq_id.type];
 
-	return capable(CAP_SYS_RESOURCE) &&
+	return capable_noaudit(CAP_SYS_RESOURCE) &&
 	       (info->dqi_format->qf_fmt_id != QFMT_VFS_OLD ||
 		!(info->dqi_flags & DQF_ROOT_SQUASH));
 }
-- 
2.55.0

