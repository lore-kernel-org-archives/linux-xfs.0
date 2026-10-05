Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792DB30FC26;
	Mon,  5 Oct 2026 05:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791179844; cv=none; b=ISECIPMmKe9uv0LjYFPdD7Ahu5aQto+yR+kngcr6u16qW7kERGSz3ApI71WgBhAaqZQsJgOefRVD2ti12n2gnQWyyS3vbmdJ8LoQB2z31cxRGJYZUDyPBZz7grSMMh1J0dKqymtJjQTLTb1WmBCsDa1NnHHIugQqO+ODxMKA4FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791179844; c=relaxed/simple;
	bh=5MnEOgrWb/6+JKXPzcdUS6oEqULhQ9PWQXpZv35JgKE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tpe0PlGsm1kiVWMDsceAoXDCHl0JuHbqOKQBQvpE7vfLZeY4wsCwmCzFbThxqwmkudAiiaVnlS9HAnRWrRaXjgRCbVn/N81GQdpAR945idHOeJ7uEhMpJi40sOr3cwPctGPkvtBbOxE2BJjmcpg7CrgvPDQYMu9I12Y/z/sviQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HPs1FyOD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HPs1FyOD"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 115A31F00893;
	Mon,  5 Oct 2026 05:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791179843;
	bh=A2VDZWNGYt/Q7lfqk4pQfzuSIGHv98LP4WcrUS9GEds=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=HPs1FyODtXrWilXJepT+ynnZpp+G68mO0LTPShzh2U2BGPcJy8lpEnNfROO1qsOyp
	 X5hPSV5tEeWnQQ9IMhFS0RzZbgm311Y4PhURF6kMGEONH+myLbdC0wnwyqT3xjf2DJ
	 4agsHMsiHT68TmJaRqKgzhXINHgURDJCJjuPiNRarP7hEyBDwhV74m7g5iurFXahKj
	 SrnsqGD1ePLHJxkc6GCCnxoAlPpNWyuYDhl5Hf9b8me45r4atq5X41YsN8kQ2jvlEm
	 ZKh8CHae9QtEecZyuVltS/KihtrLhZAxVwgd7lbqoyDW59trdEUvsZY8ejUAgZftAv
	 yKtpidwC0XjzA==
Date: Sun, 04 Oct 2026 22:57:22 -0700
Subject: [PATCH 08/12] xfs: don't allow sm_agno for non-group metadir path
 checking
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179117965180.614350.15051352556483286821.stgit@frogsfrogsfrogs>
In-Reply-To: <179117964931.614350.8529263328378685172.stgit@frogsfrogsfrogs>
References: <179117964931.614350.8529263328378685172.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that the metadata directory tree path checker accepts
non-zero values in the sm_agno field for non-group metadata.  Make that
case return -EINVAL.

Cc: <stable@vger.kernel.org> # v6.13
Fixes: a74923333d9c3b ("xfs: scrub metadir paths for rtgroup metadata")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/metapath.c |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
index 4cc0d37b529f97..1488c8bcb52490 100644
--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -129,6 +129,8 @@ static int
 xchk_setup_metapath_rtdir(
 	struct xfs_scrub	*sc)
 {
+	if (sc->sm->sm_agno)
+		return -EINVAL;
 	if (!sc->mp->m_rtdirip)
 		return -ENOENT;
 
@@ -176,6 +178,8 @@ xchk_setup_metapath_quotadir(
 {
 	struct xfs_quotainfo	*qi = sc->mp->m_quotainfo;
 
+	if (sc->sm->sm_agno)
+		return -EINVAL;
 	if (!qi || !qi->qi_dirip)
 		return -ENOENT;
 
@@ -192,6 +196,8 @@ xchk_setup_metapath_dqinode(
 	struct xfs_quotainfo	*qi = sc->mp->m_quotainfo;
 	struct xfs_inode	*ip = NULL;
 
+	if (sc->sm->sm_agno)
+		return -EINVAL;
 	if (!qi)
 		return -ENOENT;
 

