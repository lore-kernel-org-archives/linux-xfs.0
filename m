Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C753EA66
	for <linux-xfs@vger.kernel.org>; Sat,  4 Apr 2026 16:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775320605; cv=none; b=A7YmMB1RnzTqzlDMVkIKmXGaSEwiQwOrFhw8XjRccNL0ZW/QUuZ0iWHPpNELY2knHOYjgFHdX36wYIRomFCN+JB3AZU6ZcZclibNNae4qJw2T8HDwh9KY9yEzsQZsblezKX+FWPc6n/PAsmJq9ULDoiuaS8vaJYcbwJyQho+3oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775320605; c=relaxed/simple;
	bh=LPq2SyoHbAbZM3auXHDhiGT84P30IELnJGpAQRKvMpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sEqKNp/1Ba2/NOC+u8uTi5f5dz2+OmgB7SUNB8s2KyjNRsgl6oL76I8dE6E6dLQt7OYEfkZjto/8nVO4GjJEeGx3vCJze5NAEHH3Z1bZF9CgW4HeQriCBopH+D9WyZNfVm9LtJQmZpTh37Q990lOWnHOFFqtCq00YbUvCPUVuTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fEHjNuPw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fEHjNuPw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BB6C19421;
	Sat,  4 Apr 2026 16:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775320605;
	bh=LPq2SyoHbAbZM3auXHDhiGT84P30IELnJGpAQRKvMpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fEHjNuPw+eg7G9CnFnJaOvT49wE61dS5zKM76lgsCNSlbvPquNUhaaM4KwS2zu4w+
	 qnvLgC+OEIoFoq1rE0vQi9aSZtXzBdz0RYyyTMS3C7J7/EMAK39d8S6qh2SrK+JWI4
	 XGumcxVynvpyYJjc3yt1vhntYGPvI/8DF05xDjTN7s3UZL1V1kjKCqI2o74dfknGH7
	 Hbkct4LeWb+vz9xhfuVCfJWzAlocqv8ApaDZPSXCWCAZSeZmmsWEvbNirKLcnURadK
	 sGgB4n4Kkra2mCcBeCKywWAauD7FM10XD1L5UNxY7LPeZZRKR7oty02l1Rp6c77I1g
	 Y8bLFqbDd26cQ==
From: Zorro Lang <zlang@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/2] mkfs: fix assertion failure on empty data file
Date: Sun,  5 Apr 2026 00:36:39 +0800
Message-ID: <20260404163640.1013997-2-zlang@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260404163640.1013997-1-zlang@kernel.org>
References: <20260404163640.1013997-1-zlang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mkfs.xfs triggers an assertion failure, when it trys to make a xfs
on an empty file:
  # echo > emptyfile
  # mkfs.xfs emptyfile
  mkfs.xfs: xfs_mkfs.c:3852: validate_datadev: Assertion `cfg->dblocks' failed.
  Aborted                    (core dumped) mkfs.xfs emptyfile

This shouldn't be an assertion, but a warning.

Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 mkfs/xfs_mkfs.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 527a662f..9a93330f 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3848,8 +3848,13 @@ validate_datadev(
 		if (!xi->data.isfile) {
 			fprintf(stderr, _("can't get size of data subvolume\n"));
 			usage();
+		} else {
+			if (!cli->dsize) {
+				fprintf(stderr,
+_("Warning: Empty file needs a data subvolume size by -d size=<value> option\n"));
+				usage();
+			}
 		}
-		ASSERT(cfg->dblocks);
 	} else if (cfg->dblocks) {
 		/* check the size fits into the underlying device */
 		if (cfg->dblocks > DTOBT(xi->data.size, cfg->blocklog)) {
-- 
2.52.0

