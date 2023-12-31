Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0005FBA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NfMeMtrc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36CEC433C8;
	Sun, 31 Dec 2023 21:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058667;
	bh=2l5EA8P06w4WwqQGFIT3KULiKQq0oPbFZKhc+MEl+Co=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NfMeMtrcl4UCr36XD66Sr0bnd2WkmkkPig760Pft6h26xDvveAUNPQ50FmFhdA6fq
	 h5m8D1DAv/B3ZSKeQVFHg10dgTSfc0h5qCLAdvXMtJNVW3eFyqbfrcmyoVnFCZoVRE
	 KQVB9zH7hBivd1XJl3qT3mRA1yqrtH4dHc6mV49BN0peUPDFO6PFv1MNVcmy43bGTo
	 i1qteQFXnVCbzhUVe+NfaHxmx1oUcJg+o6JMH46p9mD7nsPQRNXySomWwhirbqAHIz
	 qKQmAfAlZrQ99mv4okcJC5UmyExJju8awWRcUXS3XUmzmYet3EYmOmu9I/OboKsRfa
	 Vil0ahLQgn14w==
Date: Sun, 31 Dec 2023 13:37:47 -0800
Subject: [PATCH 23/39] xfs: fix scrub tracepoints when inode-rooted btrees are
 involved
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850269.1764998.4993791802508458626.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
References: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
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

Fix a minor mistakes in the scrub tracepoints that can manifest when
inode-rooted btrees are enabled.  The existing code worked fine for bmap
btrees, but we should tighten the code up to be less sloppy.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/trace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index bdcd77c839317..822fcdfd89a4b 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -611,7 +611,7 @@ TRACE_EVENT(xchk_ifork_btree_op_error,
 	TP_fast_assign(
 		xfs_fsblock_t fsbno = xchk_btree_cur_fsbno(cur, level);
 		__entry->dev = sc->mp->m_super->s_dev;
-		__entry->ino = sc->ip->i_ino;
+		__entry->ino = cur->bc_ino.ip->i_ino;
 		__entry->whichfork = cur->bc_ino.whichfork;
 		__entry->type = sc->sm->sm_type;
 		__entry->btnum = cur->bc_btnum;

