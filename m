Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFAB531E835;
	Mon,  5 Oct 2026 05:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791179862; cv=none; b=IGo/PMQw3ml0/oWK6jZRgQmVwUtQKupAUwFABTN8uuYcZVlKfGT4h8PLKzhqva3rgAWSPZnXNTZRIFC3jmSF+TtTQNsbA/jHzXLwEojxDW8lI78H808h8ZgkxhiKZgF7qc9cavO/wRCSuiaatHWFIPvYiC6td2RK2nHChKzPwF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791179862; c=relaxed/simple;
	bh=hzIn9Gj+jeqhVg8ptWwdvpwfjd2aqNqo7Voqn9ynPZ0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QfW1Wx6dI4boDUYXRUgzlU342fn0b9rjkiJP8RN34MOiWaQurt91koO9LexGXz9irkWJ9UlFHQkQj56fMZDvm9s99c6hsaC/KowWznX4FX/4kiPgK+feqykO/Gjb0wp57mMwHUO2brPeuGsCaitNF3vCpmAlYDgal3nD0uVgdig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eZlOYgSO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eZlOYgSO"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9EBC31F000FF;
	Mon,  5 Oct 2026 05:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791179858;
	bh=uRgNfJhXvF6UkLyKTYOHsXD90MA39vBW3RLSG2dpBo4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=eZlOYgSOEaaZuoV9w2w19oK2WRq/JD/PHGkCWU04xqokrBYn5ipqAoFQ5Onn+w/wS
	 FGNQO9fYNca/zTL2A59JFaxDqcVzC44tBvEdrrexnkTiW9palP2L0EmJxedZFV+kwr
	 D0uGXwrRBBxsLLk4+rOAriS3eU1turpNaMkXOuA38ztRaroEkcaUTv94WEwAyeWyod
	 kY7uFWbFWJnBfqYov9/Bd64G2m8nE7x4x+htdJyDt8LXOggWxyA3k8sZWv9wxprFaf
	 i28V8tvR39QcriU8/JQlhqhdlw1IZ9EEIGIpN0TRdIQ+rwP0Pit8/OJRVm58xYeS4n
	 a/d0M21bUo4NQ==
Date: Sun, 04 Oct 2026 22:57:38 -0700
Subject: [PATCH 09/12] xfs: init inode number for tracepoint
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179117965202.614350.9924309515501263825.stgit@frogsfrogsfrogs>
In-Reply-To: <179117964931.614350.8529263328378685172.stgit@frogsfrogsfrogs>
References: <179117964931.614350.8529263328378685172.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM complains that if the xchk_dir_lookup call fails, it won't set ino
to anything.  ino is then passed into the tracepoint function, which
means that it reports random stack garbage.  Set it to NULLFSINO instead
so that the circumstance is more obvious.

Cc: <stable@vger.kernel.org> # v6.13
Fixes: 0d2c636e489c11 ("xfs: repair metadata directory file path connectivity")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/metapath.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
index 1488c8bcb52490..eb987f8c994d25 100644
--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -522,7 +522,7 @@ xrep_metapath_try_link(
 	xfs_ino_t		*alleged_child)
 {
 	struct xfs_scrub	*sc = mpath->sc;
-	xfs_ino_t		ino;
+	xfs_ino_t		ino = NULLFSINO;
 	int			error;
 
 	/* Allocate transaction, lock inodes, join to transaction. */
@@ -621,7 +621,7 @@ xrep_metapath_try_unlink(
 {
 	struct xfs_scrub	*sc = mpath->sc;
 	struct xfs_inode	*ip = NULL;
-	xfs_ino_t		ino;
+	xfs_ino_t		ino = NULLFSINO;
 	int			error;
 
 	ASSERT(*alleged_child != I_INO(sc->ip));

