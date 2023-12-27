Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB587EE
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a4HTGfeF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E47C433C8;
	Mon,  1 Jan 2024 00:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068394;
	bh=5i950oXaaUmqt3BAfvUUKn5PRd4nqZDs8fhs+md7tLI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=a4HTGfeF54iD/8T/4LCcp/mg/g3YC9WNIIRmrrNxsSCqJWkdS2LDueVl9w245xxEU
	 tJ1mpXkhyRLQVkaDd5Z3lmu3mmfyDup6hmsO0einpn+ccr0AVO4OGP9qpNDc/o9cOv
	 2z7lxWxY8zNceQQLx8MEhB7cA2EASVQWk/ir7I7+zWtf9DiEN0AwcLEIL3Ic9Mzugd
	 T/VsCJUHHNnn7ogkKaF2MKztsX/ak8BiQ+g9sC2AjRP2avRt1AHSok+RPxlqq36lUp
	 Tz82P6dVB/3MpS/jPECBMaLXuD5Y5Htw5tU/N+IApjbxymdPIsmz3bjhSWlaiIbJuK
	 HJCAPEV942XZw==
Date: Sun, 31 Dec 2023 16:19:53 +9900
Subject: [PATCH 36/47] xfs_repair: collect relatime reverse-mapping data for
 refcount/rmap tree rebuilding
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015794.1815505.11174101375852475362.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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

Collect reverse-mapping data for realtime files so that we can later
check and rebuild the reference count tree and the reverse mapping
tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/repair/dinode.c b/repair/dinode.c
index 41b44e6faad..d88bd80783c 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -350,6 +350,10 @@ _("inode %" PRIu64 " - bad rt extent overflows - start %" PRIu64 ", "
 	 */
 	*tot += irec->br_blockcount;
 
+	/* Record mapping data for the realtime rmap. */
+	if (collect_rmaps && !zap_metadata && !check_dups)
+		rmap_add_rec(mp, ino, XFS_DATA_FORK, irec, true);
+
 	return 0;
 }
 

