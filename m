Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C586BA37;
	Mon,  1 Jan 2024 00:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ux4ELy9D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69364C433C7;
	Mon,  1 Jan 2024 00:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070022;
	bh=M/6Dya24VqVWqWcNd/upkKp9opJZ4q0M0/xVZ8L7TwQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ux4ELy9DX7YlTsrOXyz1swda5S/+9on3caLrKoQ6SFC4nLMD2jGK/La14SoQTp7eH
	 hsobB+yFQ9841YOguO5+vX+ahfCmMTb6lObtRur4B44ZnkJahG7/tZ3AkAOpFDHXly
	 fitU3OTrQhM4lSxiwvW/6zooD8N4DaP3ScfA1SW5m+pezAv8m5i6p00lopdk9xgai6
	 h7MeB3ws6Cb3OPFjcJyqAbkYCTiAT2MRvEO3CLvPP8QffiHOahgZI5Z5FDaVfwxoKy
	 nfsCjLq9t9DAs5ZGj/rQXIRw0ovow8ubsXulRR8AJb1k9Q5mGJlQhajvWWkME4mq8N
	 uGISxifkhIwlg==
Date: Sun, 31 Dec 2023 16:47:01 +9900
Subject: [PATCH 03/11] xfs/122: update for parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, guan@eryu.me, linux-xfs@vger.kernel.org
Message-ID: <170405028467.1824869.2573116104339901331.stgit@frogsfrogsfrogs>
In-Reply-To: <170405028421.1824869.17871351204326094851.stgit@frogsfrogsfrogs>
References: <170405028421.1824869.17871351204326094851.stgit@frogsfrogsfrogs>
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

Update test for parent pointers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122.out |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 89f7b735b0..55138218dd 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -98,6 +98,8 @@ sizeof(struct xfs_fsop_ag_resblks) = 64
 sizeof(struct xfs_fsop_geom) = 256
 sizeof(struct xfs_fsop_geom_v1) = 112
 sizeof(struct xfs_fsop_geom_v4) = 112
+sizeof(struct xfs_getparents) = 96
+sizeof(struct xfs_getparents_rec) = 24
 sizeof(struct xfs_icreate_log) = 28
 sizeof(struct xfs_inode_log_format) = 56
 sizeof(struct xfs_inode_log_format_32) = 52
@@ -107,6 +109,7 @@ sizeof(struct xfs_legacy_timestamp) = 8
 sizeof(struct xfs_log_dinode) = 176
 sizeof(struct xfs_log_legacy_timestamp) = 8
 sizeof(struct xfs_map_extent) = 32
+sizeof(struct xfs_parent_name_rec) = 16
 sizeof(struct xfs_phys_extent) = 16
 sizeof(struct xfs_refcount_key) = 4
 sizeof(struct xfs_refcount_rec) = 12

