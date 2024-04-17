Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4797C2BAE2
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389580; cv=none; b=ZiNuOvGFs9OnhkpD+FKla1XdYYUbEWqF+eID2kKvXeQlzG/D+w6ZYczN4nf9EvF6V5xVkZUlI51jzpGHGS2NywW5CD0JBjMYVVM29hhQ7RqYilr8Tn1HdxbTdeFkGU/SJAo6U5kU7HIbHswb7ZoGiI8zsmT/pP0WWr3dRvcp+Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389580; c=relaxed/simple;
	bh=QylWLuhja/Mt6DLWH0CCVFZxd8QAvnzmmNhm0nZ4X+U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o9PgBUNIoQxtAR6qK3XLHco/ZCfAJRTNYAJ40SLZ0zXYqRWZg8u9sAJPan/c9hbQa/CCW0I1Koj8ZdkVFXp3XI23Ejl7X02qAGAptN/QfAg8TFeTEgOKm/YdhFqMiEdfS/IvLivP5GBg5fC4ZQwB51lhHfBELSjE0P1hEzsw5cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fjveYWyX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fjveYWyX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2419FC072AA;
	Wed, 17 Apr 2024 21:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389580;
	bh=QylWLuhja/Mt6DLWH0CCVFZxd8QAvnzmmNhm0nZ4X+U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fjveYWyX935Jqd2pCCpi0LqE/RlVkNvB0nD2hBoqVe3MVPTYvOD2Li0ZkPreReoil
	 AhYu3d5QXMRV0ipU+K/ETIJVV5fhglUor0HAMdyGoWvjl4qSzsHK4L4qfXzR7ASGvH
	 tj6go+NnvXGkdzOpODkM6qAmAMoP+ufZ+0vE5XK/eJMgotAI/u64NCH1oIxXc+9g6o
	 9ZolRIyg9qIZKsKztxi3fMcx4j/rcqxt0YFRp5hxT6fx5U+ByQkNU1JEuCHFASmuhi
	 UZq4oH5+7tftqD6W00okBaf/L5jQI2Zb/d7sZS2qcdmXpXpAu66dZtI7G8ZVE99eFK
	 H3n++m2CHNvYA==
Date: Wed, 17 Apr 2024 14:32:59 -0700
Subject: [PATCH 43/67] xfs: improve dquot iteration for scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338842985.1853449.2131997162558912427.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
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

Source kernel commit: 21d7500929c8a0b10e22a6755850c6f9a9280284

Upon a closer inspection of the quota record scrubber, I noticed that
dqiterate wasn't actually walking all possible dquots for the mapped
blocks in the quota file.  This is due to xfs_qm_dqget_next skipping all
XFS_IS_DQUOT_UNINITIALIZED dquots.

For a fsck program, we really want to look at all the dquots, even if
all counters and limits in the dquot record are zero.  Rewrite the
implementation to do this, as well as switching to an iterator paradigm
to reduce the number of indirect calls.

This enables removal of the old broken dqiterate code from xfs_dquot.c.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_format.h |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index f16974126..e6ca188e2 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1272,6 +1272,9 @@ static inline time64_t xfs_dq_bigtime_to_unix(uint32_t ondisk_seconds)
 #define XFS_DQ_GRACE_MIN		((int64_t)0)
 #define XFS_DQ_GRACE_MAX		((int64_t)U32_MAX)
 
+/* Maximum id value for a quota record */
+#define XFS_DQ_ID_MAX			(U32_MAX)
+
 /*
  * This is the main portion of the on-disk representation of quota information
  * for a user.  We pad this with some more expansion room to construct the on

