Received: from flow-b2-smtp.messagingengine.com (flow-b2-smtp.messagingengine.com [202.12.124.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146363A9D95;
	Tue, 29 Sep 2026 03:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790653367; cv=none; b=PTOlvgkV/kIw6UEPn8oUMZHV6glhZBwiFFHcigHQ0LRFNMN6By/WMLdP7bX1/8YvrdsnYglh5v9wZj9QVYZRZJ2lUNekeFiXiyF04RLg5iwGzEYpGHyVzIp0282CfV/KtjL+8MPvOnUCfMYCyBDudNfV/z067axGMwdk+yCymM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790653367; c=relaxed/simple;
	bh=YHrMII0EF+C4y/KoYrUqqLPHLV7rF/rb01KG4ozZt2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwKCbELjZYtRbZc5kXQWSSzsufkGNVKMILr1hg6po9U/pY2r0VOvOuHGwPdoHukuUb6kjBCDGf/YGr1erF6utFHBYY0pSYupNoUTHUeQFNypmmOiCld4fE9U1d0hdRzE4MACSPOwX6CtyALjFog/VPyHwkDcufvQVyxI8i+qYrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=LzlYWz/x; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=STfuHBhZ; arc=none smtp.client-ip=202.12.124.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="LzlYWz/x";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="STfuHBhZ"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.stl.internal (Postfix) with ESMTP id B185D130192D;
	Mon, 28 Sep 2026 23:42:44 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 28 Sep 2026 23:42:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1790653364;
	 x=1790660564; bh=EWrP5nNb8I3PjLtNlYNMtYoGZpi6j9B8G1WFvVNpccA=; b=
	LzlYWz/xaQPHRAjmi2sc4x429GQsZ9jl9kghm5nuoZC3ftOXUrYzqMv6b6xSKENw
	9FpQOKBm7+FdakkdECDpmP50KW9Y8RXVXdZx+wMxaDF3rjlTpBHLCLgP4YJqBFBl
	EoZM+bpg/LJ7+dqED9WxZzFWO7fNrvE0BRhPa+zffFRrr/gRpnTzpTwCW30F6rz+
	ZoWmIiWVF0jH1LIrmZndKBKwha8ma/K7HHXjEkqxFhJtEEiy+NXoxuYV1hgC9syW
	AMCm2z4sq0HsOWqv4vgaVwenf+BbwZl/fj+rY9OEC5cpQKXRLworzhoDFEW9wHTp
	KyyoXOOr2qbUPM6hoiTA9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1790653364; x=1790660564; bh=E
	WrP5nNb8I3PjLtNlYNMtYoGZpi6j9B8G1WFvVNpccA=; b=STfuHBhZIx2BJm7GO
	ufMkWZnPLmACNhxBlxxxA75f6CKA6nOuzG3LDX/TRS7CPQQdJfvs1zmNw5uZkrzA
	LMdaL94HgrlBOUIZbwhcVGP5fs9UPS0Ezsn83Mwnq4szOpSku3X4ABYPEeyE6UoF
	c/ea070aNr284RJnL0KAQn5YHS8F8AyYJDbEnEPDHVj82F4+iwUNGtKXPvsdF+FJ
	0TUyKXY5gLpTY3wSUSS3gnmKEvyAyG6w+CsUjpVklXQMx0AU90S1LK1otBptk78X
	XsPNxYT2kyfyL1HBdHRwZ5EXiSf7+NCV1TqHGyKTj6zEHrPzQWAVljMwWuwRs7cR
	gQ4hg==
X-ME-Sender: <xms:tDO7asQA2cQWsRp8ZT3D9HQqbqwlrk_XY7f84goV87Wr39FRRXMrLw>
    <xme:tDO7asuJxoMrZMEwS_r9d1WET4JhwZYCrv4IDpeSr3bOYaqr3wr5bz34NW-jdZZjG
    wjjzGmp0OvOhBp21ZciZZ_eSVpRnpddHiFosKnpyGjmBsmjTgZt>
X-ME-Received: <xmr:tDO7aiBiQelNcjPHqEEPc5kynT_ZlqvpqsovlQTa6GCSHuDgATpelJ_vzQeXO_cb2kjeLZIKVBn1irynuYAJyb2ZDuSjW0U>
X-ME-Proxy-Cause: dmFkZTGoJB+17Zq7ThrEPjmxn4ZGYu519RzWwVi/88aejzKjstMboztaed73ef7D6avpE+
    +4ud1a3y7i3orjwLfnXoctNyz4isc8MlqqkCj9w/LgYTxltRiENCW6GCIqrBIGfd6BoOtn
    3U4T9DnMQq0t334tHmkLT0tBGbfhvTaaBwaOBKtxwtl6WpY46qwankbHLMumQlIvXZxJZX
    MK4M+NdZABlSsm1lFGpu8Zoavf0+po6/QQ3FmqOSdXOPNwreWLw4U6EONlQdAFPuoTNGlS
    rFYPmLdcGE1rV4M0fAMpJKofG+st3+8PfQ+b7I9sMwGW86B3jq8HWH1QNmIbUmtd6GqsXK
    DC+GUtJHnyMmRkH4wFwirqcbuesm1+52cfp5olHBjWV3n8bdv8DMYag9MTP6cVmvbNKQsK
    bZmhQ+ixvel2oXc+5Pg3sPF6La15pWjbBX7y1xmjwy7R1ukYFOszkEG5j0Ke11PX5NOrwt
    v4BghLxi6SSbePPiPRav+EFRd3kGsE35BUZjCtg+fwu4e/KQOU5naQYTqVkpNkEi29Dlxh
    uPtQvGYB/mVqCYLfWgTv8ifIuRqPAI33Ue7gbl6QvWbBOj05uJueTVVCmnK0w6ZMeIfMXt
    nBtLmUS80WEftzMFv1h16932uEklpiV9CtNQaXniLVOLg3xA+FQJa1A55yXQ
X-ME-Proxy: <xmx:tDO7au0reeHtz0UH5rjn6MKQbrIpxtwfGYwZaEPqjAgkYwyBYeggpw>
    <xmx:tDO7akT_Xf9FblU-ZqQamsdNdZgAV6Cv2FbkrZrP3-sbpuNEqD_bUg>
    <xmx:tDO7atvdOfJMqooKYF8pI2Cuzq-jEtq5uSGz8PcNF-CY1v3gMA_whA>
    <xmx:tDO7ak5Vay2Se88fmS8TgJRDVPOdsvQKaGWZ1kAXTPiymvJ-_CrUBw>
    <xmx:tDO7asUzuJ8w5gku2jyQjTmAI5iEuEPWiZtoa6GPsX0a1qYBTXS34xVq>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 23:42:36 -0400 (EDT)
From: NeilBrown <neilb@ownmail.net>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Joel Granados <joel.granados@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Breno Leitao <leitao@debian.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Jan Harkes <jaharkes@cs.cmu.edu>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-um@lists.infradead.org,
	codalist@coda.cs.cmu.edu,
	coda@cs.cmu.edu,
	linux-mm@kvack.org,
	ntfs@lists.linux.dev,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/7] shmem: use d_duplicate()
Date: Tue, 29 Sep 2026 13:36:02 +1000
Message-ID: <20260929034158.1455429-3-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260929034158.1455429-1-neilb@ownmail.net>
References: <20260929034158.1455429-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: NeilBrown <neil@brown.name>

To prepare for d_alloc_parallel() being permitted without a directory
lock, use d_duplicate() when duplicating a dentry in order to create a
whiteout.

Signed-off-by: NeilBrown <neil@brown.name>
---
 mm/shmem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 897fa2b61346..8fbab956466c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3976,11 +3976,12 @@ static int shmem_whiteout(struct mnt_idmap *idmap,
 	struct dentry *whiteout;
 	int error;
 
-	whiteout = d_alloc(old_dentry->d_parent, &old_dentry->d_name);
+	whiteout = d_duplicate(old_dentry);
 	if (!whiteout)
 		return -ENOMEM;
 	error = shmem_mknod(idmap, old_dir, whiteout,
 			    S_IFCHR | WHITEOUT_MODE, WHITEOUT_DEV);
+	d_lookup_done(whiteout);
 	dput(whiteout);
 	return error;
 }
-- 
2.50.0.107.gf914562f5916.dirty

