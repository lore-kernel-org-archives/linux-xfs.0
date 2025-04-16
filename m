Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27AA18D63E
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 01:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744766919; cv=none; b=eo47xM+txj7eH8Lrtxy0pX5IAattdWB0lEWpxZf3y1Qq1YnbMukelWmBNbBeH+PuUyhZ0jPQ9gEwe/Qre9F7D2lkPzbmN8yOvOlLiEuy+dcgKV3qbW99S6naeCOyVZw664GIcXwDb6vYIe1uHpPmKs3Zc0PS6+g97lyT4AFV2aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744766919; c=relaxed/simple;
	bh=g3vH94WfeEBAp/dy4bco680VC95iai3jhqcXYxAlrHY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=RinBw4ZMKb49L9xC0kFXkf8aN1jwOMH673MAFVg397XuZ037tVcXrIOAMHd4d90At0YDs08409EgyxGrnlSfdTmr3EFuUv00CW0SKE8fRiRH4gLN6P0NlflaKahcoSkmj2RS9DepyD1Hqi0mj/rwyJJR0p6X3xsdt5Qopzv7wYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zme7HgrI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zme7HgrI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A693C4CEE7;
	Wed, 16 Apr 2025 01:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744766918;
	bh=g3vH94WfeEBAp/dy4bco680VC95iai3jhqcXYxAlrHY=;
	h=Date:From:To:Cc:Subject:From;
	b=Zme7HgrIunoESBynnmC+LnCy6HGKCpA63ETdirIyq/IYy/NNkI/WKLnqeACBfFUmu
	 6bB2MtgrAr3RGT9ElpK3CbbnfPLxy4z/+uAuyPeix3tbyFkY5KZtuGotEZDtoipSna
	 oRIC0Pi8yhWL3A47xIH1HkYNEYlT3YRPYaSA6VvzVjn4VltBAMezAE09a62ppGoBHP
	 c9OQie4VPL/1rsVHopshYlO/i3TOTTxzFAg8AZqbdaUd1QM7xIlVv+hq9/WXW9zudX
	 5MvrdDllrNYOPxbiBnmweVJBsfB9yqtRp3qJWjhuOGAHVqaqAqNwzABliC0rPbjXv+
	 wSDetS2vvna6Q==
Date: Tue, 15 Apr 2025 18:28:37 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] mkfs: fix blkid probe API violations causing weird output
Message-ID: <20250416012837.GW25675@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

The blkid_do_fullprobe function in libblkid 2.38.1 will try to read the
last 512 bytes off the end of a block device.  If the block device has a
2k LBA size, that read will fail.  blkid_do_fullprobe passes the -EIO
back to the caller (mkfs) even though the API documentation says it
only returns 1, 0, or -1.

Change the "cannot detect existing fs" logic to look for any negative
number.  Otherwise, you get unhelpful output like this:

$ mkfs.xfs -l size=32m -b size=4096 /dev/loop3
mkfs.xfs: Use the -f option to force overwrite.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/topology.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libxfs/topology.c b/libxfs/topology.c
index 8c6affb4c4e436..96ee74b61b30f5 100644
--- a/libxfs/topology.c
+++ b/libxfs/topology.c
@@ -205,7 +205,8 @@ check_overwrite(
 out:
 	if (pr)
 		blkid_free_probe(pr);
-	if (ret == -1)
+	/* libblkid 2.38.1 lies and can return -EIO */
+	if (ret < 0)
 		fprintf(stderr,
 			_("%s: probe of %s failed, cannot detect "
 			  "existing filesystem.\n"), progname, device);
