Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2834637179
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706591198; cv=none; b=CDWb5xG7MkghuCTypEQE6nhDSFQA53zibpBZtz+GKXF+MZws5lU3HXfEvCWXLmciuNHpLaIWxWLpzYj2yE0GZiI9ory33v4/i9fXPZca5Y5OiTk/lL4TxGbl1cC6i91S6u14QuVDI5pzaqvMBnOm4u1SI5sOtmtM48ExIft75SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706591198; c=relaxed/simple;
	bh=ewhYhAanhwdp/GC9R8Y6kXfjF/4YqomyU+C/eL7lsD8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WFZBqQl2AwbOdaiqWT1OhTT4SQKqzB2YgJ1z6yfDikmpSQWsGW2CNH93Jj/vsUbPnz4CSXd2gLw8MrUJmQ67ON3N7cI3SB4n5gbMCSJ1sG/XH3bU3G10fKz6zGCDIl+P4t1ZS/ihxmO4hvpRMBEg0SJHEHp90tTW8JCp4mXfXrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r0lGT/oS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r0lGT/oS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8F5C433F1;
	Tue, 30 Jan 2024 05:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706591197;
	bh=ewhYhAanhwdp/GC9R8Y6kXfjF/4YqomyU+C/eL7lsD8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=r0lGT/oS+cbIIapQEtqe4E4Kdi/RaFlCzJEEDgB04FOx5So5nGzr8eWfJBE7hbu2y
	 3QnX5UiUjffp/JpnVp5Y7M/o9eL/KN+OLWmX4nDfJRPwmoC9kPp5TSEXysttOQLwkZ
	 6Y3fMadFbvEe07683jml5TzF3En5BuzVL/8ItV77vLjrle/vQzii60la/a1I4/xh2y
	 qAAN6vvDcc/vRVmpv1BXm9AyjZN7OAaSTYxCox2g0PwxFrju0Oju1Q9hGwqzDMGwYW
	 brLMuebL6bcM27YaT1N5v7t8A/zEbB6fyFQuAHfnhffzN/ipzQEA925vRFgWYiXilx
	 0sCL9XsOn+nPA==
Date: Mon, 29 Jan 2024 21:06:37 -0800
Subject: [PATCH 2/8] xfs: create a xchk_trans_alloc_empty helper for scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659062786.3353369.6856402292254216066.stgit@frogsfrogsfrogs>
In-Reply-To: <170659062732.3353369.13810986670900011827.stgit@frogsfrogsfrogs>
References: <170659062732.3353369.13810986670900011827.stgit@frogsfrogsfrogs>
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

Create a helper to initialize empty transactions on behalf of a scrub
operation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/common.c     |    9 ++++++++-
 fs/xfs/scrub/common.h     |    1 +
 fs/xfs/scrub/fscounters.c |    2 +-
 3 files changed, 10 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 81f2b96bb5a74..47557f2a79950 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -653,6 +653,13 @@ xchk_trans_cancel(
 	sc->tp = NULL;
 }
 
+int
+xchk_trans_alloc_empty(
+	struct xfs_scrub	*sc)
+{
+	return xfs_trans_alloc_empty(sc->mp, &sc->tp);
+}
+
 /*
  * Grab an empty transaction so that we can re-grab locked buffers if
  * one of our btrees turns out to be cyclic.
@@ -672,7 +679,7 @@ xchk_trans_alloc(
 		return xfs_trans_alloc(sc->mp, &M_RES(sc->mp)->tr_itruncate,
 				resblks, 0, 0, &sc->tp);
 
-	return xfs_trans_alloc_empty(sc->mp, &sc->tp);
+	return xchk_trans_alloc_empty(sc);
 }
 
 /* Set us up with a transaction and an empty context. */
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index da09580b454a0..d2ca423b02c7a 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -32,6 +32,7 @@ xchk_should_terminate(
 }
 
 int xchk_trans_alloc(struct xfs_scrub *sc, uint resblks);
+int xchk_trans_alloc_empty(struct xfs_scrub *sc);
 void xchk_trans_cancel(struct xfs_scrub *sc);
 
 bool xchk_process_error(struct xfs_scrub *sc, xfs_agnumber_t agno,
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 5799e9a94f1f6..893c5a6e3ddb0 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -242,7 +242,7 @@ xchk_setup_fscounters(
 			return error;
 	}
 
-	return xfs_trans_alloc_empty(sc->mp, &sc->tp);
+	return xchk_trans_alloc_empty(sc);
 }
 
 /*

