Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7691D5AA8
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jan 2025 21:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737063528; cv=none; b=UL9duoazUfz1xywqjDu2xFc+8o6iAqr8nF/kZ9gDyJW81tFSaLEjtQpkm83aMFBHiHohfnVzSMHN56VSQg0IpuDhDXIRopdz0ascbbktSJYUHOrjhhZv+rQDN33/Yh2SnqMM4sReLC1I9HqyWVwWmfEC6XhCaYVdL7c1rDne0zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737063528; c=relaxed/simple;
	bh=Q8PKJt5gyx6h6/8FjkYbbDi8qxgzKHJi55ZBo6yNwKk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hK6hCp5U7T5s2ClfMmL3wh2sqLgiFfGIKm4aJlRDnOe89WTTeXRo87v2CKB0o5F+mgmVSFz/nl9f16opzQw8ebeptocpbz28gn9Hn+f1MrPFpBQDzQtVDD1rdSTtqus64r8xgxcXFM+CEfTsnCpRmrbZYHFkIiohNwhknUJVl2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CzJz2N/T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CzJz2N/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A87BC4CED6;
	Thu, 16 Jan 2025 21:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737063527;
	bh=Q8PKJt5gyx6h6/8FjkYbbDi8qxgzKHJi55ZBo6yNwKk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CzJz2N/Tt1tXQlaID08v7ECxNa6HDGMsAmbImXXbT61tH7srT6ZhAOBr76Hz5kTxW
	 6+1D2C6yy3BqZkG/KE7omIs0flvkaWohh5FrUm6mhxkFBaNb3WpHQ2AeHsdEF1gZV1
	 6qqnh8PrK2p9nfDsDAS7A3kZfInbhOgxW0xfaTaXALFBdpyR555GQZK2NzofJx18Ys
	 VKL5D5hie/CddAYtictt1hxjkstiDXxb+VXp1KuX5QHXceXzTbeFb6FHuJvRS1HY0u
	 vI3zPlaHffInsbC/6BWiB2L1P+nBiqJ1F8Pdpral4xvkrYeAwUmRM3jEmr1l9U3HFZ
	 6dk7LOz1d5Grw==
Date: Thu, 16 Jan 2025 13:38:46 -0800
Subject: [PATCH 1/8] xfs_db: fix multiple dblock commands
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: tom.samstag@netrise.io, tom.samstag@netrise.io, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <173706332222.1823674.15603891144443245230.stgit@frogsfrogsfrogs>
In-Reply-To: <173706332198.1823674.17512820639050359555.stgit@frogsfrogsfrogs>
References: <173706332198.1823674.17512820639050359555.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Tom Samstag reported that running the following sequence of commands no
longer works quite right:

> inode [inodenum]
> dblock 0
> p
> dblock 1
> p
> dblock 2
> p
> [etc]

Mr. Samstag looked into the source code and discovered that the
dblock_f is incorrectly accessing iocur_top->data outside of the
push_cur -> set_cur_inode -> pop_cur sequence that this function uses to
compute the type of the file data.  In other words, it's using
whatever's on top of the stack at the start of the function.  For the
"dblock 0" case above this is the inode, but for the "dblock 1" case
this is the contents of file data block 0, not an inode.

Fix this by relocating the check to the correct place.

Reported-by: tom.samstag@netrise.io
Tested-by: Tom Samstag <tom.samstag@netrise.io>
Cc: <linux-xfs@vger.kernel.org> # v6.12.0
Fixes: b05a31722f5d4c ("xfs_db: access realtime file blocks")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/block.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/db/block.c b/db/block.c
index 00830a3d57e1df..2f1978c41f3094 100644
--- a/db/block.c
+++ b/db/block.c
@@ -246,6 +246,7 @@ dblock_f(
 	int		nb;
 	xfs_extnum_t	nex;
 	char		*p;
+	bool		isrt;
 	typnm_t		type;
 
 	bno = (xfs_fileoff_t)strtoull(argv[1], &p, 0);
@@ -255,6 +256,7 @@ dblock_f(
 	}
 	push_cur();
 	set_cur_inode(iocur_top->ino);
+	isrt = is_rtfile(iocur_top->data);
 	type = inode_next_type();
 	pop_cur();
 	if (type == TYP_NONE) {
@@ -273,7 +275,7 @@ dblock_f(
 	ASSERT(typtab[type].typnm == type);
 	if (nex > 1)
 		make_bbmap(&bbmap, nex, bmp);
-	if (is_rtfile(iocur_top->data))
+	if (isrt)
 		set_rt_cur(&typtab[type], xfs_rtb_to_daddr(mp, dfsbno),
 				nb * blkbb, DB_RING_ADD,
 				nex > 1 ? &bbmap : NULL);

