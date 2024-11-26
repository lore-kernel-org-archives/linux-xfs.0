Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8D0BE46;
	Tue, 26 Nov 2024 01:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584424; cv=none; b=M/6N4zM8M0PK/saZnlUSAiqR/6sKN3EpoCLSDRLkqdb9Da0Rm2ME82D6QaWPem5XEGHnhXKbRzHd/XSZ3IPg9a5qFyIvNSYcIL61R9Nuwt6A+UtO62V8zxhWafUiQIkMemHCBSmdFkXlesEYHB+Rl0Dtg9CCXIBUK7tSZJmuPyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584424; c=relaxed/simple;
	bh=hvtg8CFJW6YkaVNSXT1MmNPelQ5diQxgZ8Yqp7xq4Gw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CE16pWOhufXUfuZIDN37jLCBanGvQpJELYR8qtDmnqwioVucqstFybuDhin7I+gEizVXxMcLZDc0yRS7ULzy3/cYzqemUPgvqZqD8oOq0bpqRpLLa5CSdc+J1gJ/YvcWRXmXrOoFJXZ59/vwUtnXTsZyztDkYI3DMrF2xukZ0Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dy5rNaI6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dy5rNaI6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D08AC4CECE;
	Tue, 26 Nov 2024 01:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584424;
	bh=hvtg8CFJW6YkaVNSXT1MmNPelQ5diQxgZ8Yqp7xq4Gw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dy5rNaI6DuM3ykPUHrnn/CLB780LGj2xnEaKUK7UOMhytegqU9nCibsTlo+D7thTz
	 2B4Py1ORSfELIvsGslDVigxBfWsD9as8ktGD0xZ0lvJx4B6Tn6cyvGxYFG67jAcVNe
	 ySlwUPY2l9XW/BOlRL6ywOODmGIvyEERyYaVmfaCIvYW9wLsOC5QXbESDznSJQI4q7
	 WXDKCqYHbYdD8l5NKywTkdWwwr3dHlCJ34cTzC9P/kXXen+tUqhvBZ9CjaYrw/S00H
	 VSlEnkOcAZ882NRJDqBV2NmXVLC2OomeiGOUDtBfQd2LHMoeIVYmzl0pqT+hl9pSax
	 0MEMg92jgmJsg==
Date: Mon, 25 Nov 2024 17:27:03 -0800
Subject: [PATCH 09/21] xfs: fix null bno_hint handling in xfs_rtallocate_rtg
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: stable@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173258397957.4032920.17159744103545265309.stgit@frogsfrogsfrogs>
In-Reply-To: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

