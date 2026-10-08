Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D8A3B841F;
	Thu,  8 Oct 2026 05:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791439001; cv=none; b=pwl+wMf1XtkBDp0PmnvbRPDdQMZgWnVzSoK1dEuL+6DMll0dTyndKarpL4pQFHP9XcqP7MO7pzPcFDoCImqWry/1x2Apb7c+9Bs/RTgjCIjeR9cZY8TKHgBDIFhA1tGVarqgCUzaSTKcSIqNKmA8AC44mTuSnLUf4Cm0vmMU8xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791439001; c=relaxed/simple;
	bh=JyUBjH4+EzTqF/VSdjmK0ce18yQLu5gSOltcwP7MQ0g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pVhAFek7LsYv2Y18yw9JvK5TgNoaDUishYyBao/RobFlp5UaTIVGubTBiMyyqkoNaxYt+HgDehqZp5pLynih6wum6rTFyhp/T3Kx3IRXqbvnpF8Q0s1slymdmcHTg6UH5hseupt6S/eDurkosJVU1cvqlbst6c+1r9iSgJyKSnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DoxcW2r/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DoxcW2r/"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 24BE91F000FF;
	Thu,  8 Oct 2026 05:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791439000;
	bh=HRtbbc5M116uDyIk/DDt1aIpjORg3NvbFVxPs7unrYo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=DoxcW2r/+PNrc/FL6+puF9JXvuwv9fL8gZ2q+/Yvxfbe7KNXksDrpnQujm7cJFs/z
	 q0mW6/1Hzbpfw4ZbMtjYSAh0HnajKNDwwFzRQe2050Nxx/psx4sGFZVem9Z7L8WbLT
	 fcByzGOcBnYX7Cdghoy3NB/hLGOmz0JniMcbRfC0eH2dvPcsuvzHFZBoSOH29P7fWU
	 R+MxFbk59yZajZNFvIsAyjicrGVlKzV4ZdAA3Q2sjDVSsM6z8nEIsNF9Ma0VQsNmra
	 Y551pdFKfIrbUXfGXkfFfWenYs8phOtH4PPmVl27Izei3uAx7+D3WxtckX3ZzsO7Wo
	 LpugpPgqQcznA==
Date: Wed, 07 Oct 2026 22:56:39 -0700
Subject: [PATCH 07/12] xfs: always report inode repair setup failures
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179141521407.2728617.12125568467564794998.stgit@frogsfrogsfrogs>
In-Reply-To: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
References: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that xchk_setup_inode silently discards errors being
returned by xrep_setup_inode.  Fix that, and fix the stub macro so that
it actually "returns" a value.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: 2d295fe65776d1 ("xfs: repair inode records")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/repair.h |    2 +-
 fs/xfs/scrub/inode.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 2bb125c4f9bf2b..1af568651e20a1 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -239,7 +239,7 @@ xrep_setup_nothing(
 #define xrep_setup_rtrmapbt		xrep_setup_nothing
 #define xrep_setup_rtrefcountbt		xrep_setup_nothing
 
-#define xrep_setup_inode(sc, imap)	((void)0)
+#define xrep_setup_inode(sc, imap)	(0)
 
 static inline int xrep_setup_symlink(struct xfs_scrub *sc, unsigned int *x)
 {
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 46e9bf4a43179e..ac42867acbc4c9 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -212,7 +212,7 @@ xchk_setup_inode(
 	 * make repairs to the ondisk inode buffer.
 	 */
 	if (xchk_could_repair(sc))
-		xrep_setup_inode(sc, &imap);
+		return xrep_setup_inode(sc, &imap);
 	return 0;
 
 out_cancel:

