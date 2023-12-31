Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA54FBA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ksT3HaMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349B6C433C7;
	Sun, 31 Dec 2023 20:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055491;
	bh=gz44cReZRudGuzQOR80zG4zCE7nFmxrvuY4D7uVPt+I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ksT3HaMt/Y9Blv8jnzfrNKtxX9h91ytvI2sWz8lcERqmj09quiihHZIqj4XkuDMsK
	 5bPJoHtGT2A8ILI/Qm9qYu3BGTdgfHIjMbTbxIBcsG/CqvZ0q6vXH0YhtctV2+rkqh
	 jmFyq3wVPrhxhtTYkX5mjP/Y7ac/dlLrjI9J8D+duMFSt8GZf4H3b2r2yJ95kUAl5d
	 71W29otMOvJ67mQhhZDit4SY+UpQKirWcy4gfAJ3xeamwePs2O0TSUxkPNK3r9NeyY
	 b1UtTbM0wcJ99CFI/uONfaPV9Ej05MBw/1aZmM6q7fn7mEDavIJVFd/arTgm3VhXV6
	 c66HdNPqkd9mg==
Date: Sun, 31 Dec 2023 12:44:50 -0800
Subject: [PATCH 7/7] xfs: unlock new repair tempfiles after creation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404840016.1756291.13128379414353037150.stgit@frogsfrogsfrogs>
In-Reply-To: <170404839888.1756291.10910474860265774109.stgit@frogsfrogsfrogs>
References: <170404839888.1756291.10910474860265774109.stgit@frogsfrogsfrogs>
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

After creation, drop the ILOCK on temporary files that have been created
to stage a repair.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/tempfile.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index 93d8a6b68f442..9e0f1d311118b 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -145,6 +145,7 @@ xrep_tempfile_create(
 	xfs_qm_dqrele(pdqp);
 
 	/* Finish setting up the incore / vfs context. */
+	xfs_iunlock(sc->tempip, XFS_ILOCK_EXCL);
 	xfs_setup_iops(sc->tempip);
 	xfs_finish_inode_setup(sc->tempip);
 
@@ -160,6 +161,7 @@ xrep_tempfile_create(
 	 * transactions and deadlocks from xfs_inactive.
 	 */
 	if (sc->tempip) {
+		xfs_iunlock(sc->tempip, XFS_ILOCK_EXCL);
 		xfs_finish_inode_setup(sc->tempip);
 		xchk_irele(sc, sc->tempip);
 	}

