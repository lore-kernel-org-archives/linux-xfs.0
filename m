Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E35E7EF;
	Mon,  1 Jan 2024 00:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hJnUg8Ip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BBD6C433C8;
	Mon,  1 Jan 2024 00:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070210;
	bh=o7wUg8ZbmhmP2nqpNrlTslzHWcBmT/O/xkTDfERLaLc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hJnUg8IphpJnvtMbIiKfWRkNkZPlXzsDR+AmV6O/C1kts30+PoyRW8m6alFpcGyKt
	 c+k/b8lc56CYph85pcVlgakr7kRM9nJTDdKnL/FDHkibdXp5xgbvsRl7bO/PfIfVof
	 uIcsenTTOKfYadx3O0S+Cbura8+mZe8QVa7lRBM1KWY7qTHAXUZy+pIS635D7V41Da
	 lv/NodNK+1OO8iToiWTuag9a7vEhYGx/YImjK7i27Ardc6u7Yi/WwT8Vh3Pqi6fiVk
	 dl7WGRcB1/5P3knz5ILcuKIClYYGHFdeG3C9BfpLDS1JmbUaQO+QhNMYV77DX6H3LK
	 nwpxNGBUpSs9A==
Date: Sun, 31 Dec 2023 16:50:09 +9900
Subject: [PATCH 01/11] xfs/122: fix metadirino
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405029862.1826032.9120032235595084513.stgit@frogsfrogsfrogs>
In-Reply-To: <170405029843.1826032.12205800164831698648.stgit@frogsfrogsfrogs>
References: <170405029843.1826032.12205800164831698648.stgit@frogsfrogsfrogs>
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

Fix xfs/122 to work properly with metadirino.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122.out |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 5d14386518..430b805792 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -35,6 +35,7 @@ offsetof(xfs_sb_t, sb_logsunit) = 196
 offsetof(xfs_sb_t, sb_lsn) = 240
 offsetof(xfs_sb_t, sb_magicnum) = 0
 offsetof(xfs_sb_t, sb_meta_uuid) = 248
+offsetof(xfs_sb_t, sb_metadirino) = 264
 offsetof(xfs_sb_t, sb_pquotino) = 232
 offsetof(xfs_sb_t, sb_qflags) = 176
 offsetof(xfs_sb_t, sb_rblocks) = 16

