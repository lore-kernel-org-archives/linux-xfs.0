Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0017F17C201;
	Fri, 26 Jul 2024 16:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722012669; cv=none; b=A7bjEp8q97NrRJGEmkcDP5nrHUvQ78IMcnQhwA53g7iGxMm+zjDPdRZP+C6wiq/FJgFzLvLTh6TPMVGyrG/FUZ88MS6FndFbl2zZYpLivYfG9gqxbcuqGhJXHHYM/U9WCwTr23PJapexikbZktZqee7zGD4KogHgKrg9dw4CnYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722012669; c=relaxed/simple;
	bh=6ZIEPGh0rwzrqHjlR/wnxvxJ0B5rUJNL1NRFkbQhJK0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=oQW0NyhVPX70/Ez335DspD9xHwX3JiKTdikotOK3J9pdgPYpjoXooMkt77+eJ0n9xYslVv4geSJGtmQB2LUHFy0pMk4uJgX/MQO4HV49h40Tugp8lHmRB8oINQGI7dD2ExFHKfzpvF6yfAYB4eVNKwtZbA94wg3p/siTiUlgWpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YGcJjyfo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YGcJjyfo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F65DC4AF0E;
	Fri, 26 Jul 2024 16:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722012668;
	bh=6ZIEPGh0rwzrqHjlR/wnxvxJ0B5rUJNL1NRFkbQhJK0=;
	h=Date:From:To:Cc:Subject:From;
	b=YGcJjyfotprt9MJdKcrkP+5cACPQsZw6sODLj6L82aFLs2ye/uLd28mmh8/QaaA6q
	 5F8CzwDXJJ4JpdtxkmYJrdIlL48OSPF1Jy1LaUkn3XnCeMMhEGndWpfNE2ui2ZUDmd
	 0Ng0xs1+E8q1llQfd55nyqf2i1krYwhsRSsfIyZf87y6Ckc1FTErmlyx3WWqUHHZ7x
	 Lqpu68IrFiirCx9cDYNoIWbcNNbojcuDh2crLAvf1tmTLoh/nyEJKToatvAStUmdIl
	 v1LRO48mCnsvgYiKTHiAirApA4hSpvxJIu3DcHvNv/WaGINaE080FO9DlrVzqvEtCI
	 hNeGVzcu3RQbA==
Date: Fri, 26 Jul 2024 09:51:07 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: Ma Xinjian <maxj.fnst@fujitsu.com>, fstests@vger.kernel.org,
	xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] generic/754: fix _fixed_by tags
Message-ID: <20240726165107.GR103020@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

This test requires an xfs_repair patch, so note that in the test.  Also
update the kernel git hash since we now have one.

Reported-by: maxj.fnst@fujitsu.com
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/754 |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tests/generic/754 b/tests/generic/754
index f73d1ed611..7afda609f5 100755
--- a/tests/generic/754
+++ b/tests/generic/754
@@ -13,9 +13,12 @@ _begin_fstest auto
 
 _require_scratch
 
-test $FSTYP = "xfs" && \
-	_fixed_by_git_commit kernel XXXXXXXXXXXXX \
+if [ $FSTYP = "xfs" ]; then
+	_fixed_by_git_commit kernel 38de567906d95 \
 			"xfs: allow symlinks with short remote targets"
+	_fixed_by_git_commit xfsprogs XXXXXXXXXXXXX \
+			"xfs_repair: small remote symlinks are ok"
+fi
 
 _scratch_mkfs >> $seqres.full
 _scratch_mount >> $seqres.full
