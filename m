Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A291BC5C;
	Tue, 16 Sep 2025 00:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757982917; cv=none; b=fF1w3Fes8TMzv4MWA56nGq/jI4Ex4BZjt5AMq/vsgb73AJvbufmacbJQA+9eIpOf2ndM1aLM7fb5Kxq8QQanMp5k33iDZ2TnDcT2pDZUTNcqXMTIH916V/wc1WF2Yp+VpL3I2nC6bSZoHjT6ytXhWAosjP+w48aK4Rg+6xurVjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757982917; c=relaxed/simple;
	bh=uM4wlKUWhue7CalDOsje1jegAup2AtRHbQa/AdCI/uo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D1sx+M0GWa8CNZB/Udx+qdqQu6DhVlytK3X4RUnH7iBcoQnIRVZGyZ5/UFTrXz0eqruepv5HShPdvdylsssztJcwLSKUmQ5yjQBZCXsguRcxjzQmZehwY9R4/pAQjsyn3Y+IBQvSqklH7UIeCJx6glhWnbVMiJXv4081eQ7MfeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hpnWJoup; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hpnWJoup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA73CC4CEF1;
	Tue, 16 Sep 2025 00:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757982916;
	bh=uM4wlKUWhue7CalDOsje1jegAup2AtRHbQa/AdCI/uo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hpnWJoupRBfj1Yr+BPaD0P7vgtyPFcN8O2yNN9Z8FTVVMKKaJcV1svMkSSYZDz9C0
	 dyyE7BtIQ8bAA4OvMJTlobZMZ/8hKqHFQOGsJFwWqrJ2UmzesyI184PbQun+1arD2p
	 hCB431eSPt3YBy8snsdJLpObnCktQ4SM6k6koZwR3UV08aAv4CD706sQEo9Wow+20x
	 2m7yBhYAzxuInTGGuEl/JUp/maDJkPfYxbSEURnzDf4VSkQWqxQOrPNYnZ1wZ9p2J8
	 OSl3ESoj18ASAb3fBR+gC1PJqJh/KRkZS3nF1ETvQOyJwBYXs8Ma5A4Whw3mk05rce
	 ONsYoLpifCpww==
Date: Mon, 15 Sep 2025 17:35:16 -0700
Subject: [PATCH 28/28] fuse: disable direct reclaim for any fuse server that
 uses iomap
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, miklos@szeredi.hu
Cc: bernd@bsbernd.com, linux-xfs@vger.kernel.org, John@groves.net,
 linux-fsdevel@vger.kernel.org, neal@gompa.dev, joannelkoong@gmail.com
Message-ID: <175798151866.382724.7451646688783955755.stgit@frogsfrogsfrogs>
In-Reply-To: <175798151087.382724.2707973706304359333.stgit@frogsfrogsfrogs>
References: <175798151087.382724.2707973706304359333.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Any fuse server that uses iomap can create a substantial amount of dirty
pages in the pagecache because we don't write dirty stuff until reclaim
or fsync.  Therefore, memory reclaim on any fuse iomap server musn't
ever recurse back into the same filesystem.  We must also never throttle
the fuse server writes to a bdi because that will just slow down
metadata operations.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/fuse/file_iomap.c |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/fs/fuse/file_iomap.c b/fs/fuse/file_iomap.c
index 30db4079ab8a55..524c26e53674f2 100644
--- a/fs/fuse/file_iomap.c
+++ b/fs/fuse/file_iomap.c
@@ -1014,6 +1014,12 @@ static void fuse_iomap_config_reply(struct fuse_mount *fm,
 	fc->iomap_conn.no_end = 0;
 	fc->iomap_conn.no_ioend = 0;
 
+	/*
+	 * We could be on the hook for a substantial amount of writeback, so
+	 * prohibit reclaim from recursing into fuse or the kernel from
+	 * throttling any bdis that the fuse server might write to.
+	 */
+	current->flags |= PF_MEMALLOC_NOFS | PF_LOCAL_THROTTLE;
 done:
 	kfree(ia);
 	fuse_finish_init(fc, ok);

