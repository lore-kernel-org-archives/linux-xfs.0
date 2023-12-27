Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F3D7ED;
	Mon,  1 Jan 2024 00:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZZ7XkpL+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B33C433C7;
	Mon,  1 Jan 2024 00:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070194;
	bh=7iJji2hl++cTkCdZcVdUaE/HbsAF8ntLD0YJD2dg/5Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZZ7XkpL+AY6mVEBeuGUrx+fqSHm+Oi9zZY+6L2mxdxJ1vWWsEHTkiscJPnjtTKQPM
	 Sy8htfF6QmDYJu+n/8/IhOTalvE7fzSVmW1JCxaNEPGJN7JlRuq7CPyFI9/eZmFIvV
	 k5c1R9reeTsL0rGyNqRawTVcpYa6CEDf2dSAMO1pcH8rkOrT9ixwvt+sKT0B7RIP0G
	 UTcAcCImtqDIvkT6AnH6MpZYYVI3GUkBmzRJT0becKIrPwOXjF8n8grGfhtGgh+9as
	 rsdcOXxwDIsaNRy6uSJvWy8NJVbqubLV23YeOi8f6ceD9bj+/OumaC9HMmtusAafWr
	 qYDOzLyrDLjRA==
Date: Sun, 31 Dec 2023 16:49:54 +9900
Subject: [PATCH 1/1] xfs/122: update for vectored scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, guan@eryu.me, fstests@vger.kernel.org
Message-ID: <170405029254.1825289.9531958913453325876.stgit@frogsfrogsfrogs>
In-Reply-To: <170405029241.1825289.15703936901700637451.stgit@frogsfrogsfrogs>
References: <170405029241.1825289.15703936901700637451.stgit@frogsfrogsfrogs>
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

Add the two new vectored scrub structures.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122.out |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 55138218dd..5d14386518 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -121,6 +121,8 @@ sizeof(struct xfs_rtrmap_root) = 4
 sizeof(struct xfs_rud_log_format) = 16
 sizeof(struct xfs_rui_log_format) = 16
 sizeof(struct xfs_scrub_metadata) = 64
+sizeof(struct xfs_scrub_vec) = 16
+sizeof(struct xfs_scrub_vec_head) = 32
 sizeof(struct xfs_swap_extent) = 64
 sizeof(struct xfs_sxd_log_format) = 16
 sizeof(struct xfs_sxi_log_format) = 80

