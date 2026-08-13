Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A993A6B70;
	Thu, 13 Aug 2026 05:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786598816; cv=none; b=rsGN1g1Ti2kcdkEb5uiA70uPnqNn8yo4p/uHwNAv+Jgr6Qo3y7GXZGaIuMisY4KjNN3VKrzEDCx+6LvqrJC5HfjEy7QiyUs9/Z/L2u2XqAL2mEcC/F9tJ2aM0g/pq73inqqdk+d0DOFxR/M3Qh8qHNQQ2/uJAam3WrEkEDyPxH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786598816; c=relaxed/simple;
	bh=5LmTAffNiYXjss8cq+hpulesoqXces1l6reCGf2h54U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LaePL6/ZZEIS9dwF5CF0UBnaYp5yGCU4TJaCB+rbAYfSAirk4+eIp+3rgYreNmCM+2vUy4u5ORSrnsHvnZ5tmDd6wT+xYxwj0/H0eHWYhoaER4uJ/W+z53AyRq47dfx1IpSIWAzynewlUnR0U0x7Ubbp+A4F2S6FD01bfh6Jvzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=buAIH7E4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="buAIH7E4"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7FFE51F000E9;
	Thu, 13 Aug 2026 05:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786598803;
	bh=wi2SWB4K61ydLxAf+KfXAC77mfSjKxhX5Eq1VcBQrSs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=buAIH7E4RzOwGHXaDpztCpOvFRC7KfOuc++6ggVyfJDpT3HeUdfXmlzkO8rHzi90V
	 98PLWbL84J0yyDQER4UasrTes4nbWCMXRmPkmxP3YUt4ut4CW/ubnBJgeRS2MxOX1j
	 rMb/T8oiPYGUVTOO8G1YY5tLzB8HxgfkqHoKu95FvN9B3N1nei3opnbXfY0hZ+I7cH
	 oLAIGitofPMiGWflx8PdsBjmEPlBev+ZuaYJ7TvGSg+hc8JeyUypA5mfmmVeHiYeJ7
	 h9fRPwgrZ77C3Zz5QpTBzdmtN8fSn2xJG7svuKWAa1RaUy3F6P3NaddjAWva09Ja1E
	 9zC3XlQvB0hnA==
Date: Wed, 12 Aug 2026 22:26:43 -0700
Subject: [PATCH 5/6] xfs: don't modify file attributes or poke fsnotify for
 dry runs
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178659861983.833922.10991178975977666480.stgit@frogsfrogsfrogs>
In-Reply-To: <178659861838.833922.2269351780488724470.stgit@frogsfrogsfrogs>
References: <178659861838.833922.2269351780488724470.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM points out that a dry run shouldn't poke fsnotify because we don't
actually change the files.  I noticed that we also shouldn't be removing
file privileges when doing a dry run.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 42672471f938cd ("xfs: bind together the front and back ends of the file range exchange code")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/xfs_exchrange.c |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/fs/xfs/xfs_exchrange.c b/fs/xfs/xfs_exchrange.c
index 94965a6c2187ff..56f9a6b47c47b0 100644
--- a/fs/xfs/xfs_exchrange.c
+++ b/fs/xfs/xfs_exchrange.c
@@ -701,6 +701,9 @@ xfs_exchrange_contents(
 	if (error)
 		goto out_unlock;
 
+	if (fxr->flags & XFS_EXCHANGE_RANGE_DRY_RUN)
+		goto out_unlock;
+
 	/*
 	 * Finish the exchange by removing special file privileges like any
 	 * other file write would do.  This may involve turning on support for
@@ -783,6 +786,9 @@ xfs_exchange_range(
 	if (ret)
 		return ret;
 
+	if (fxr->flags & XFS_EXCHANGE_RANGE_DRY_RUN)
+		return 0;
+
 	fsnotify_modify(fxr->file1);
 	if (fxr->file2 != fxr->file1)
 		fsnotify_modify(fxr->file2);

