Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC1F620
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371971; cv=none; b=f2W/GXlFN6uAme9I6+I/HIc5pbeND13TByCl1neNEIihYmyPGyObWUPFYv0jiefexVgYluaMQaPS/b+ORmkkMSRbP5CHR4ndv4ATbOMt9jkv/9fXey6g8+YASJsf571CM/PbV7bmjm+3434SE+VYG3bopd8SWA6fXRCs0xOB6fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371971; c=relaxed/simple;
	bh=Kuocn5oGUGHBGmQDTTVV1ysD9ZC79ghFLqynAUFXPuA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=grPXFnBdRYMomodP369iZp3lnvNu/aXWFoX8ZT2/XPaRM/ySh58kZs1WW25QjCdgrVHLX65h2FB5+OcKNmEds0vSoreTTgYEOKTC4JACqYQS6CLS2/vMVhukRA8sdzMvVZ1NkLINnPUIAgQIKLuWn6koEhDbXTge2UoEfypXke4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hi+yXbP1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hi+yXbP1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F91C32782;
	Fri, 23 Aug 2024 00:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371970;
	bh=Kuocn5oGUGHBGmQDTTVV1ysD9ZC79ghFLqynAUFXPuA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Hi+yXbP1HUolFfXD2su2zEPfzWfi2WCoN4nR8Gg7mhpTIqxpNpyrFhDuqoCjiRfqQ
	 drM1+jco083Qd0ZfI/pTrabUTjuxvV5XyDYcTGoxPvMY4VoiRpdiwhojt6uN+Cxsdm
	 sDIuyIhNbkomyFlSrLaGW4SjbhQkH9qKFJPmy/3g+Niodn6d56CUZVPbaK0UIUn7Bb
	 uC3CaXWPPFMmmI4/9BAZh+bd3+buOire/1U4QIyAbnvDHx7moQ3IFhyFFMdKLgWimS
	 aS2qjyeHn3KfzSQBB3vYnnHa9QWFXOSyWkrjEEwNxWy6Ep/bRgMjC4cHEqSzhpv/11
	 9nHoCDpGKDg4A==
Date: Thu, 22 Aug 2024 17:12:50 -0700
Subject: [PATCH 03/10] xfs: don't return too-short extents from
 xfs_rtallocate_extent_block
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437086668.59070.5713338461091119042.stgit@frogsfrogsfrogs>
In-Reply-To: <172437086590.59070.9398644715198875909.stgit@frogsfrogsfrogs>
References: <172437086590.59070.9398644715198875909.stgit@frogsfrogsfrogs>
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

If xfs_rtallocate_extent_block is asked for a variable-sized allocation,
it will try to return the best-sized free extent, which is apparently
the largest one that it finds starting in this rtbitmap block.  It will
then trim the size of the extent as needed to align it with prod.

However, it misses one thing -- rounding down the best-fit candidate to
the required alignment could make the extent shorter than minlen.  In
the case where minlen > 1, we'd rather the caller relaxed its alignment
requirements and tried again, as the allocator already supports that.

Returning a too-short extent that causes xfs_bmapi_write to return
ENOSR if there aren't enough nmaps to handle multiple new allocations,
which can then cause filesystem shutdowns.

I haven't seen this happen on any production systems, but then I don't
think it's very common to set a per-file extent size hint on realtime
files.  I tripped it while working on the rtgroups feature and pounding
on the realtime allocator enthusiastically.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index ffa417a3e8a76..3d78dc0940190 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -291,16 +291,9 @@ xfs_rtallocate_extent_block(
 			return error;
 	}
 
-	/*
-	 * Searched the whole thing & didn't find a maxlen free extent.
-	 */
-	if (minlen > maxlen || besti == -1) {
-		/*
-		 * Allocation failed.  Set *nextp to the next block to try.
-		 */
-		*nextp = next;
-		return -ENOSPC;
-	}
+	/* Searched the whole thing & didn't find a maxlen free extent. */
+	if (minlen > maxlen || besti == -1)
+		goto nospace;
 
 	/*
 	 * If size should be a multiple of prod, make that so.
@@ -313,12 +306,20 @@ xfs_rtallocate_extent_block(
 			bestlen -= p;
 	}
 
+	/* Don't return a too-short extent. */
+	if (bestlen < minlen)
+		goto nospace;
+
 	/*
 	 * Pick besti for bestlen & return that.
 	 */
 	*len = bestlen;
 	*rtx = besti;
 	return 0;
+nospace:
+	/* Allocation failed.  Set *nextp to the next block to try. */
+	*nextp = next;
+	return -ENOSPC;
 }
 
 /*

