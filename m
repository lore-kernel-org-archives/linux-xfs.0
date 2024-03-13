Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E2EB66C
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295455; cv=none; b=UXRHyULVBvNcuNyzdV9Qaw1lTeZlfxdWMizYSJIZ9DCrNl3X7xsb4tpM035bfhILR0Uf79VTiSJnRWg9GLfuXq4PuYDV3AnsCUQ+htOACtcXjuNq68fAJaQDmCV0crOf2LJAWTb9ctlKR3UDekkbpcY5chzViXCJf9DJISLwZ34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295455; c=relaxed/simple;
	bh=E1vdI4UORhhJbppasMkCQsrjasLsRUOLEa9F8QOnMy4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YD0Rl+N+R6lCI+8v3o1Ip65dCeKWKqt+otCWK1M6lJHIT0gDWCAQ010Q00DvLsFoO+z/SOiJIFBoLaugzc0u7q1TrDRUtQeJManBFhnfN2UvWMcs4+sdVGunlI+EjP3ayda6QbmcXZVDBGcqfUHOMNuBK30EXkCvKzUxtWFgbho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FwQKGXls; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FwQKGXls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E083C433F1;
	Wed, 13 Mar 2024 02:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295455;
	bh=E1vdI4UORhhJbppasMkCQsrjasLsRUOLEa9F8QOnMy4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FwQKGXlszViS0BxcGaTdyexe3OWllGv1gcGYMx/OSUU8Z4J4f5y7WN/TqNh5NbmFN
	 MERXZjwn9oug4AqLkOuJ1v7kafz5m/d54maSoG+9R8epQYO363Gf0PJtUsxYYftg+9
	 YJ6uQgAPZR1gdyLlg4bTx8Fio2ZHEbuh+7jvs4HbVH1ZTLNS4XvVQI0z/ofSDXa8bb
	 YQDukKxotcK48CNcFwa7YyB8AITsTfzyh+tvhlcaTprlwz5MIdbTYaFA5jrOqHT2Pc
	 e+vJKPi3RN81FTSy5823oSOdAyslMP6SlyXus7VuCVEpD0kzsP54DsL4n5zDni8Px7
	 gDm5DuLXw69KQ==
Date: Tue, 12 Mar 2024 19:04:14 -0700
Subject: [PATCH 43/67] xfs: improve dquot iteration for scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171029431813.2061787.17351964239037898368.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
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
---
 libxfs/xfs_format.h |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index f16974126ff9..e6ca188e2271 100644
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

