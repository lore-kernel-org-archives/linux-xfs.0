Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202DBC13D
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jan 2025 23:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735860008; cv=none; b=bsl/tskMjoHbkASPWw4eWQ+9R3YJSVvCHuPmAd0exGHoscFdSMdgpD71/8Id2Sf8uSpW7mcFzuMR6G4QuJPTuA4nSAnp+tl3MuaI2BdU5ZNuDUaPxyB7invXdEugJgUAwfYnOe+bMuTolmiycAuIdDn1TOvavUpkcynEZ183qYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735860008; c=relaxed/simple;
	bh=xr8vy0e9E8OntLWMDANBJnShAfqqLpev+Bwe0Y/N1As=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UmhKLa7D2WE4I6YxAmoPLsaMuuvziRGcwUfyJnz3J9GUX5mS5la5M6t1VmmDNVF1okZ5+lDVeXlgDgtgzkxuqKnM/YBlNKKzkzgTySodAvQL34zrth3PyErGc+PqizRnUQlql6B5urqSE8a0CnOR6CjzCwALXo+3wNRId+j03qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EsvALisk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EsvALisk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97DACC4CED0;
	Thu,  2 Jan 2025 23:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735860007;
	bh=xr8vy0e9E8OntLWMDANBJnShAfqqLpev+Bwe0Y/N1As=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EsvALiskRUPA4iCtuhDv/PxaSXl64rGt33/1NXJuO1gIg/l03SUHuPJtQEUNqJq/6
	 EVitP6YqRenqVS8RxROKbQJj1YQeinkiCEnSG4FKKz4lCt2/gdRAPugS/Mzxw7E+ax
	 wcPL791gxlx9x82gz1/GKA23NRE4iItnCSWmaMMQimqld9Mj0/onEJ8me+B7j5mEY9
	 0esMVWGPIxco9GBs8Qa48V2sJ2fZbrWQnBhq52Dw4+E+PcmqcDviaCVtaHB7Z5vG24
	 ApLK5/Iag8R3iHrc/V5eJrGhMKlMUOSZ+kyPEgynGMG6MNlMRJ4TXwnY7zQL/c5V36
	 v44G0WdcDXCBQ==
Date: Thu, 2 Jan 2025 15:20:07 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Tom Samstag <tom.samstag@netrise.io>
Cc: linux-xfs@vger.kernel.org
Subject: Re: xfs_db bug
Message-ID: <20250102232007.GV6174@frogsfrogsfrogs>
References: <CAE9Ui5nCVmeOGkOwJA4anU4oJ8evy7HqAXmPt+yhvwC_SJ5_uA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9Ui5nCVmeOGkOwJA4anU4oJ8evy7HqAXmPt+yhvwC_SJ5_uA@mail.gmail.com>

On Thu, Jan 02, 2025 at 02:14:45PM -0800, Tom Samstag wrote:
> Hi!
> 
> I'm encountering what I believe to be a bug in xfs_db with some code
> that worked previously for me. I have some code that uses xfs_db to
> copy some specific data out of an XFS disk image based on an inode
> number. Basically, it does similar to:
> 
> inode [inodenum]
> dblock 0
> p
> dblock 1
> p
> dblock 2
> p
> [etc]
> 
> This worked on older versions of xfs_db but is now resulting in
> corrupted output. I believe I've traced the issue to the code
> introduced in https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/commit/?id=b05a31722f5d4c5e071238cbedf491d5b109f278
> to support realtime files.
> 
> Specifically, the use of a `dblock` command when the previous command
> was not an `inode` command looks to lead to the data in
> iocur_top->data to no longer contain inode data as expected in the
> line
> if (is_rtfile(iocur_top->data))
> 
> I don't know the code well enough to submit a fix, but some quick
> experimentation suggested it may be sufficient to move the check for
> an rtfile to inside the push/pop context above after the call to
> set_cur_inode(iocur_top->ino).
> 
> Hopefully this describes the issue sufficiently but please let me know
> if you need anything else from me.

Oh, yeah, that's definitely a bug.  Thank you for isolating the cause!
Does the following patch fix it for you?

--D

From: Darrick J. Wong <djwong@kernel.org>
Subject: [PATCH] xfs_db: fix multiple dblock commands

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
