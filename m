Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CDC262A3
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713388954; cv=none; b=jjG7+U8dhpOklib478OwHimDNef4t/qFFmDByRAVEV/ubEF0oohzryE5BN6jDsinMOt0691HreHbVt1c4bKuTJY5QsOYdqJbcuiAUsfts0j54Op/iQhknlbhv381IvcpvTe8o6Q9DvUEJHtdFecjzHrN6y3KIdm333IPR1QQ86o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713388954; c=relaxed/simple;
	bh=eR8gSBlLd/e44Z1nmsa30vwiS17w0B/jTbF5rhbCHqc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fnVv/p3VTXN7ZqbUr6AugNbbDGdsjHmbNvqro0zxxU9PtRT75GJcBZvNuUwoIyII9Cgkox7wjubgR5CfWtzmhliFkP0HV2ppfjHQZjVu7NwKzulnYl0rkPYM8AFe1QHmmItcv0kxVii+JmlG5Msi6RSOg8skKmij4GH7UzUwD/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eAqiwfhF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eAqiwfhF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5091C072AA;
	Wed, 17 Apr 2024 21:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713388953;
	bh=eR8gSBlLd/e44Z1nmsa30vwiS17w0B/jTbF5rhbCHqc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eAqiwfhFFR9k56pqMlY/PfRh3HsQWv/V0Pc3F2bYA95rdQtf/pQRb5TGcP9iLghV0
	 YeRFgcwsWr5yRM/DLZgUEK+NhlKa8FUpqkimCL3EARGMnUfwcOUkNCbxw3KcXMuybH
	 6hQxOxJvmI4x5e9n3SuBB9Yb54CakQAd0s+8VFWTiYnomJUQDCeU0CsSyvfjpryDZO
	 Ded9HxIuuNibTRub5EgJYgRMpdXPaJURUK8eqs8uGpV9Io8NG169fgbGErWQBRIW2U
	 9j5XdS8FnTEXpYbdA9xIzcbwOQys1QEBKBUjagvJjRpC4eSLduRQQ7EV7MmXL9wXdp
	 Xpopqu4/iXcBQ==
Date: Wed, 17 Apr 2024 14:22:33 -0700
Subject: [PATCH 03/67] xfs: use xfs_defer_finish_one to finish recovered work
 items
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338842385.1853449.14503762738762910887.stgit@frogsfrogsfrogs>
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

Source kernel commit: e5f1a5146ec35f3ed5d7f5ac7807a10c0062b6b8

Get rid of the open-coded calls to xfs_defer_finish_one.  This also
means that the recovery transaction takes care of cleaning up the dfp,
and we have solved (I hope) all the ownership issues in recovery.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_defer.c |    2 +-
 libxfs/xfs_defer.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 4900a7d62..4ef9867cc 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -479,7 +479,7 @@ xfs_defer_relog(
  * Log an intent-done item for the first pending intent, and finish the work
  * items.
  */
-static int
+int
 xfs_defer_finish_one(
 	struct xfs_trans		*tp,
 	struct xfs_defer_pending	*dfp)
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index bef5823f6..c1a648e99 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -41,6 +41,7 @@ void xfs_defer_add(struct xfs_trans *tp, enum xfs_defer_ops_type type,
 		struct list_head *h);
 int xfs_defer_finish_noroll(struct xfs_trans **tp);
 int xfs_defer_finish(struct xfs_trans **tp);
+int xfs_defer_finish_one(struct xfs_trans *tp, struct xfs_defer_pending *dfp);
 void xfs_defer_cancel(struct xfs_trans *);
 void xfs_defer_move(struct xfs_trans *dtp, struct xfs_trans *stp);
 

