Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB06D387363;
	Fri, 11 Sep 2026 05:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789106100; cv=none; b=JcFwZUMOrV1Qovt1/GHu3sAMylNMt8mNAAbMZMAhZGTrPE5BGg3jtIlOS8KI1N7de5iTBjn3OSEAE75rAlRXcKpqWu1+xP4Ry+ne3vMcGlMYFkOzo0vP4Sg1p5NjUq951IZ0ofngUyH9GyDLP1USw/EedQv0AkGi7tUsNZIHqac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789106100; c=relaxed/simple;
	bh=jJWm3rFk7wFaUx6U+w9lnkGJ8mrWNB6a0Uj6TTRmIEs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qCAq8v4vWTUyRUr/EI+SwwO6zNEFN2ybyWaVFshhzMoZi+4GsBG4F3yVWwGDElNr8iK6R7oJOLam+7U1NBg61PUTaecSJMmK9GDnkcsWlihckVElqcNDFI2Wvt3FkhfiI7NK3MBONB7C6qUJ6RtXWDAabhRHAg8j+9bQtrJeLPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U10Y4L0I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U10Y4L0I"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7856F1F000FF;
	Fri, 11 Sep 2026 05:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789106098;
	bh=eI4dgJXHEigWbKkNTNr1vwu8/TyaB3zrDJzzmTHqP4o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=U10Y4L0IwkTi0wtCXe8aGmU26kjvEISuwdoG54YRXAXzikw7V++ixTR9rYCEVjRFV
	 q22/Qkc6KjC2E4MH7ieHeMHARtdLIRBpzShaJVBeiyFOfcoeOq2Wj35u+9Ym0b8G76
	 r9NQUvKmxmGIzqjxXF2V9jmCtMmN2eu71Wg/+08jz0dRIwumJ3ajf6lFlcm+DF3EtO
	 gkrhikiH7sFekUBaCWCJsmCDz10W/hnoqwcv3gWhiAHC9y4mtmzQEmmhLAG10P+zgX
	 8qe15NwjmC0BI4I+V8PsN53MUGHHfEi0dd6m7apKRzkGEAOOREnAz2X8Y5Xvi9+5fD
	 SrU2ipitgogTw==
Date: Thu, 10 Sep 2026 22:54:58 -0700
Subject: [PATCH 6/6] xfs: check di_forkoff correctly in scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178910162147.174887.15828411239184280666.stgit@frogsfrogsfrogs>
In-Reply-To: <178910161988.174887.8958318922224347752.stgit@frogsfrogsfrogs>
References: <178910161988.174887.8958318922224347752.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The di_forkoff check in xchk_dinode is incorrect, according to LOLLM.
XFS_DFORK_BOFF returns a byte count relative to the start of the literal
area, not the start of the inode.  Therefore, this check won't flag
di_forkoff values that are larger than the literal area but not the
inode size itself.  Fix this check; sadly the old APTR code was correct.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: 6b5d917780219d ("xfs: dont cast to char * for XFS_DFORK_*PTR macros")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 65b13e31191681..46e9bf4a43179e 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -607,7 +607,7 @@ xchk_dinode(
 	}
 
 	/* di_forkoff */
-	if (XFS_DFORK_BOFF(dip) >= mp->m_sb.sb_inodesize)
+	if (dip->di_forkoff >= (XFS_LITINO(mp) >> 3))
 		xchk_ino_set_corrupt(sc, ino);
 	if (naextents != 0 && dip->di_forkoff == 0)
 		xchk_ino_set_corrupt(sc, ino);

