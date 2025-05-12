Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB2E2905
	for <linux-xfs@vger.kernel.org>; Mon, 12 May 2025 11:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747049438; cv=none; b=rryEozxU20u4tnZL2HKaRxYW7EeYy63k+UAM/yko+BtUWvrz4/GqeY/UsujSaAcefx7K5dXeF3Wd1K9s1fqfXAE4hScIn20hBc6hdoFNEGlg9L93C17XWRnWoGtnCY0RiBJWRfcyZdmjzld3cpnummUqeA1OrUGWG15nwWzMFiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747049438; c=relaxed/simple;
	bh=wJeKLx/dA9ddNRQMJqOYFgSuqvqjtk3ocWY1EEtdrcs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=PKWrYywmHWionRMhhIqYsthZUZ6Mg2SAjKBuPsFj7iGnzX5a2NaL7BfgCy9U+6YriSD5xUAaezghqEnygJ5tenjk9yn6w3726KJfK8JsLJuxkll+rrEI/nJ1OHnoIJtjMqzt17JiSXF4n+muPDsohKJo2pLG9IINeZTc1N16FQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AFbx0rVE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AFbx0rVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B10C4CEE7
	for <linux-xfs@vger.kernel.org>; Mon, 12 May 2025 11:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747049437;
	bh=wJeKLx/dA9ddNRQMJqOYFgSuqvqjtk3ocWY1EEtdrcs=;
	h=From:To:Subject:Date:From;
	b=AFbx0rVECvAn/VdwrkUHn5OP58AiJW6C0CiviH3+yblM4jTgY7aBKNHX4XaKi0mW4
	 86l3XVXmDTl1zitxoNLYRS0hNzbbsA64FkfqLD+i0rTaRrraRW6k4ryInbywxiNX9M
	 Lp57bm5MycysMOHMQMyrxpsAuqH7p7c1L/sGJ0pP7YWfrUQHD/npyxa0tJd5NH4MwF
	 rUFu9CqJatgqtCvAKVPvX2ZD04ilyODMVupW8lTrvs6nv2bePO/TE8MKap4qw/vbXn
	 FnM2DG0aJnSk/fD/E3kr7Pt3L6wihK1yIwExTXKnNy8bkog7Ke7XECb+gbkjSQNzUO
	 Sdy8FgR8eicOQ==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH V2 0/2] Fix a couple comments
Date: Mon, 12 May 2025 13:30:21 +0200
Message-ID: <20250512113031.658062-1-cem@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Fix a couple comments in xfs ail code

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Carlos Maiolino (2):
  xfs: Fix a comment on xfs_ail_delete
  xfs: Fix comment on xfs_trans_ail_update_bulk()

 fs/xfs/xfs_trans_ail.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

-- 
2.49.0

