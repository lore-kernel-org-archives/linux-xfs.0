Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B5C469E;
	Mon,  1 Jan 2024 01:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jDHlHLyp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA62EC433C7;
	Mon,  1 Jan 2024 01:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704071212;
	bh=PQOXKqTI0ymqlsfOptI3fL4SJuF8SZiLgL00u+l4ieI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jDHlHLypZ6TOl05HTzosP2jzjuPX74t+Rd7Cs6ats0dsCmF8t4VSjndxncJ9K9cyP
	 Ut5hznwjFTxNzpO9t3RHuD2bhBRgQ3MoCFoecsMx+qVYe6kBslxhABafnnUnwC267l
	 +LjFBHN+f9pxXo5FkApEIOGMzCrsdicJEXhqgUaVWpCC2MI2U+1a4teDWKjTY4TrPl
	 cJNSVy759iEw02skal9Lx/8hzD9XSZ7gEZ3kNqLwz0Yhs06Gin8PlznbX0cFDRbO4w
	 ubtXtR0tOob1xIDdAyNLyYtPIV9tPmorsL+V2052/Hl7fpZUb8y5xMVk2XJ93iwUvG
	 Bb9Xu9kk85qUg==
Date: Sun, 31 Dec 2023 17:06:51 +9900
Subject: [PATCH 1/2] xfs/122: update for XFS_IOC_MAP_FREESP
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405034087.1828773.17904902884694706449.stgit@frogsfrogsfrogs>
In-Reply-To: <170405034074.1828773.1484406890502132195.stgit@frogsfrogsfrogs>
References: <170405034074.1828773.1484406890502132195.stgit@frogsfrogsfrogs>
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

Update this test to include the new free space mapping ioctl.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122.out |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 4d7e6c1eb4..3134cf1619 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -114,6 +114,7 @@ sizeof(struct xfs_legacy_timestamp) = 8
 sizeof(struct xfs_log_dinode) = 176
 sizeof(struct xfs_log_legacy_timestamp) = 8
 sizeof(struct xfs_map_extent) = 32
+sizeof(struct xfs_map_freesp) = 32
 sizeof(struct xfs_parent_name_rec) = 16
 sizeof(struct xfs_phys_extent) = 16
 sizeof(struct xfs_refcount_key) = 4

