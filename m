Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB95153BE4;
	Mon, 18 Nov 2024 23:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731971212; cv=none; b=A+858ZHNjfmw4kM5X+jYoHP2FeNO1Kh7ECcnLt0XpuQcx/olOS8vM1zk3i1FOJrJqKYD4Rsxtj8Jg/63Vf9auarkNxv9xaT8S8RiFrX5yB/lOEdQkgttDJANEufKQudkE/wLms8VLoTYiE1Cl25UFVBTy6bZD3oBJcOoZpaRT3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731971212; c=relaxed/simple;
	bh=eLsu41YeD0HrTyRtmIQlUugqMJ3IXNNewNaUs639yJs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gdPhfypIst8pdtCb6TmvctNVDCSuv1epk5ODLCzOwGafU83cM8O1PE9l8GKQySSYAffJ2FTSJVcegxRsATnDAgVZeoY/hsyDYyJnR9GXYKveVK+TiTJiOSwKkcOvvvlAXdYi3GtfIJsTgHka8cCrwxWe64GC3So4UjN9p3h5yR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D1mlkdsS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D1mlkdsS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1ACC4CECC;
	Mon, 18 Nov 2024 23:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731971212;
	bh=eLsu41YeD0HrTyRtmIQlUugqMJ3IXNNewNaUs639yJs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=D1mlkdsSv5bzrYnReyWvYBEh8U5fhrjq44REhiIDXeSFlqh0xDysvzBdMaLoZJBg9
	 cctREXTyEraDCIWnsvZlYOI+TxXVVXl0Ls52CulTaGhhk9eIS6euP/zaEOTXS9ST9f
	 wZ6pjs/T3Jxzoy7n+xHVlIklENwwe0k+DKCQDGcX4r1oqWZNcsp3W+mQB4FPiO65J7
	 4Sr+UgoN0t/ZM3vPKQ9lsEuwKUL0JFCUIrbuthFlZXZqV/imLg1PCgRNEDmCB50Kz9
	 Qczjb2ztJwA68O8JrGRmxo/hJ+iFI3ZBhoM6O8A+w0BH0BkOcDX7vw5PqHURuJUt6C
	 2rKaU/C0CM/+g==
Date: Mon, 18 Nov 2024 15:06:51 -0800
Subject: [PATCH 09/10] xfs: fix null bno_hint handling in xfs_rtallocate_rtg
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173197084566.911325.17606647892449835782.stgit@frogsfrogsfrogs>
In-Reply-To: <173197084388.911325.10473700839283408918.stgit@frogsfrogsfrogs>
References: <173197084388.911325.10473700839283408918.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

xfs_bmap_rtalloc initializes the bno_hint variable to NULLRTBLOCK (aka
NULLFSBLOCK).  If the allocation request is for a file range that's
adjacent to an existing mapping, it will then change bno_hint to the
blkno hint in the bmalloca structure.

In other words, bno_hint is either a rt block number, or it's all 1s.
Unfortunately, commit ec12f97f1b8a8f didn't take the NULLRTBLOCK state
into account, which means that it tries to translate that into a
realtime extent number.  We then end up with an obnoxiously high rtx
number and pointlessly feed that to the near allocator.  This often
fails and falls back to the by-size allocator.  Seeing as we had no
locality hint anyway, this is a waste of time.

Fix the code to detect a lack of bno_hint correctly.  This was detected
by running xfs/009 with metadir enabled and a 28k rt extent size.

Cc: <stable@vger.kernel.org> # v6.12
Fixes: ec12f97f1b8a8f ("xfs: make the rtalloc start hint a xfs_rtblock_t")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 0cb534d71119a5..fcfa6e0eb3ad2a 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1827,7 +1827,7 @@ xfs_rtallocate_rtg(
 	 * For an allocation to an empty file at offset 0, pick an extent that
 	 * will space things out in the rt area.
 	 */
-	if (bno_hint)
+	if (bno_hint != NULLFSBLOCK)
 		start = xfs_rtb_to_rtx(args.mp, bno_hint);
 	else if (!xfs_has_rtgroups(args.mp) && initial_user_data)
 		start = xfs_rtpick_extent(args.rtg, tp, maxlen);

