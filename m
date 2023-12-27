Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982B0CA57
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wolba3wa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D57C433C8;
	Mon,  1 Jan 2024 00:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067252;
	bh=ziM/RN7F/5cAkNoa7swlxCeV5PccyBuFjRGYh7N10y4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Wolba3walPp2dmJ0wxORJJeqSr2UrbRSvsFmupKi3SD/rmOIT0q5ha6FbWYR0/TBA
	 k/APbXwXSS2UPhv6hKS3M3XuZE2PBpj+7ITLkYaa4cM0E77r+EmSxJuSYjL/ZrYaxr
	 yKVPy3YwCqtkO43c9wmnso5tKv50PekasEmoaoIq3cx97UMvaAOPzfRgeh5uwC75xw
	 Jl/G95Y8SddQE32IrDalzoQyPa1Q9HhbbSmZec+up1eVLTJ1klUuFglYyI0Jc7p4Fd
	 l2eoWhddz61J7n0mZPPn6aLBf8+ZvvK4RsO03tYRlOIk97XBIomEkGFsVSXJz/MzLK
	 FC3caxSHssUhw==
Date: Sun, 31 Dec 2023 16:00:51 +9900
Subject: [PATCH 51/52] mkfs: add headers to realtime summary blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012844.1811243.5518616373565458779.stgit@frogsfrogsfrogs>
In-Reply-To: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
References: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
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

When the rtgroups feature is enabled, format rtsummary blocks with the
appropriate block headers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/proto.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index f5b7859f9a9..b89b114d0d6 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -991,6 +991,14 @@ rtsummary_init(
 	if (error)
 		fail(_("Block allocation of the realtime summary inode failed"),
 				error);
+
+	if (xfs_has_rtgroups(mp)) {
+		error = init_rtblock_headers(mp->m_rsumip,
+				XFS_B_TO_FSB(mp, mp->m_rsumsize),
+				&xfs_rtsummary_buf_ops, XFS_RTSUMMARY_MAGIC);
+		if (error)
+			fail(_("Initialization of rtsummary failed"), error);
+	}
 }
 
 /*

