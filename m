Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211BA28F4
	for <linux-xfs@vger.kernel.org>; Thu,  9 Jan 2025 00:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736384123; cv=none; b=YWF7UrcX9xMYLFtGrZJzYmh7J0VYv/98gFrLz1Y9ljJCI3g731oFezI/1RY+/ECVtm3lDbP89JHppph5NSCjjrhGfFVL8GZrQYSeWF2zUrPw6+c7CoidlkMLNOrzhnECkxagLG2nvJtw1pUUhZusXBs8SnWK4v3pezje4GSllsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736384123; c=relaxed/simple;
	bh=JpoNJXOEzBCq50PkmR/aJ/lJigNz6JUiIQwDgsST9Rw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=bm7RABp/9oE047dFXO9AaiOoq5DakrmrOE6RtHmltZPbiR0NxVr77PRyuydjLMVSHegeV5SId2ofU0JFK2hQ1PmQAh439kFJf2ag9o3RvzLGxNFnumf/RCyp2YGxoRDIalCM5cjgmC7SvxFnGn5VKHEKxBLY7DMjcR15KdwLpGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RdOw1ShK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RdOw1ShK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E951FC4CED3;
	Thu,  9 Jan 2025 00:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736384123;
	bh=JpoNJXOEzBCq50PkmR/aJ/lJigNz6JUiIQwDgsST9Rw=;
	h=Date:From:To:Cc:Subject:From;
	b=RdOw1ShKUBsajuEKXZbZKdOq8OZHQApvlzEroVboiA/+3cUU26Gamg9IQ/vPg47Ua
	 yUFbGV8Z87I2rbJ31szDQrDtTFlDm870R67iZ6YYzVnJR0mg+AOOZkn8X4qR428yy7
	 QB7WzmPlnfqAlpgvDhH46sAQi+LKxMfUBuC5PMyl4wwkd0/elnfGxGc/54ibgrJIJz
	 k3sVueHqmOxsKxzk1uvG8qewqtPLBc2uZDEPbh1Mk3XaVu+/s4tJ41m8pCMVJaUnfm
	 CIQty4X337wvNeYgfcDYE5cBDwwOxT0Nl4A6cetk9Ae92QPBp9GWi6AH84gB//D7IR
	 R9L4ovej4cp1A==
Date: Wed, 8 Jan 2025 16:55:22 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Tom Samstag <tom.samstag@netrise.io>, xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs_db: fix multiple dblock commands
Message-ID: <20250109005522.GI1387004@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

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
