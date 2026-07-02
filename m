Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61AE13CF207;
	Thu,  2 Jul 2026 09:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782985037; cv=none; b=s/m4O85zA9eLi/caD7VwgaElmnly6PzFzgLQG0MNnXt1n0UzYUvTXhKQ/vGciQXF82iCvhZHBKnmF2RjfCFXgIyNVoXho9n9/N3tG+bsOPh3kmSL9P4AAD4aJbJtP/30xOu23jOs6yMPjz68/T7j7T+3VgdGawmeGdZFhiPD6+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782985037; c=relaxed/simple;
	bh=Ya8ITAfX1uslKqBo3zioH6B/jdejKA1s8Ub2LtGvb5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+8dFOdyDXeS5+qg5ZjD6MtnOBdn1rloN2V3zaMo4xdJJ97WIRlrLhNkKffinE9QhATQ9xhD821RvQbuw35Lf4vSLm9v8cEdjm6T5MaJaaqIZFgcw6tyEFM3y1d7q+ShkOzm0crUNVtgg08bpSZTlAOJZn84ezzMtTuPGp0pPdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dI2kE0Ek; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dI2kE0Ek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F5A1F000E9;
	Thu,  2 Jul 2026 09:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782985036;
	bh=QElN0AsiAViaCOt2q/t6WBhCgJbVgG/Plez42cO9MxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dI2kE0EklLXgvToE+3lLp2GYbJ9JqwKPQihKx2CgXbOUoUHMRsyl3jpqtArZlP/LA
	 KLZSgSenRS91HQaGkYCtj7pdeYJKwv716V/18l8VCaG6qj83VPKVPh+yaF7JIG+xes
	 aJxwF9cADy9kBgNHiA19u5Kptvdg5TDCG/16IxN65Cdv1x+8kW2YlgyxFhdM0xgOMa
	 6vpqbEvLPH9vBFjClVw34ccqJUelXtfOq5HDe/ZuD8SziXBQqimcjmsHkGAYRihqKL
	 dsTRWHYQw4vxXsGtv0zkPPiZ2+jksj3CqEtHLuolNdVYkLnatlWCbbImT25HGnPiiG
	 Q4ArxhbexF1Ww==
From: cem@kernel.org
To: cem@kernel.org
Cc: Jan Kara <jack@suse.cz>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Dave Chinner <david@fromorbit.com>,
	Eric Sandeen <sandeen@redhat.com>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3 3/5] quota: Don't issue audit messages on quota enforcing
Date: Thu,  2 Jul 2026 11:33:21 +0200
Message-ID: <20260702093324.127450-7-cem@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260702093324.127450-1-cem@kernel.org>
References: <20260702093324.127450-1-cem@kernel.org>
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
Cc: Jan Kara <jack@suse.cz>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
Cc: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
2.54.0

