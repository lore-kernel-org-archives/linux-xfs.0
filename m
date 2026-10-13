Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3038492187;
	Tue, 13 Oct 2026 06:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871670; cv=none; b=P49xypLzeMQccV9IXhztQslLZXyT0xXkv+HBQAsyNUcLS+scNavAinMHsXW/TgdiJPv8dScAerRdJExboitFRIgoK4bYs7VDY7cVqLCoDFs8rh1CGTxSEWkPARQmlc5TqX1wwLloa5CjglcaeQl9kOftOEfRihdCwM73GbGONEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871670; c=relaxed/simple;
	bh=sZOSYwdHpHqeJkI6/7i2ha6QejnGhCKEZ7mDuCSVJlg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nVu6Xpx2EZE1PlIWJO1xzKrQVFNFx8f5Rv1Ll5pc736Tlb7L4LeiPVxcP4h5QrvMreR527KYIc3O4+YW5XbKL4eyF3KsyffOi3s8aUQon0jWMwEQbqTBmM4cClrqI3Ufy69SXTdcQgj+azHO2egA3JVtSt1HvFGWeS8BHoBVRkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oVyj30To; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oVyj30To"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 640931F000FF;
	Tue, 13 Oct 2026 06:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871669;
	bh=VA55Q3EKGQe783Bexcd5VAhML5/z6G8n4VgabVJlaRk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=oVyj30ToxLDn7cjrtt/hUGmZAdj9BYIPark90qEs7VCmpjJGh7T5LSzKu31AoWM+b
	 +2fvFhXAZnR/hkls5bq2XBkZcZoV/ji4rdPpRUwPQBiA2wpei/TwHuQ9DcvWU2Balp
	 SwF/Yl3cEQqHMW78qCWPdcBGuhxdaU/ajZBhygFuGxijB2JvJfsZNlnfAeGxL3zQfe
	 yvQssuyRXm3J7dDm92+t4OtOTbqzAq6suZjF/9neA2jM2vixftVIBCRFDHXZnnkJ1U
	 RYDEG2Bhx2MKFmAdTlZutDlD9Bt0Y838XkElXIGdt+tKuXSyjtlpfxqfFZwiCFdDGM
	 RkJX0qQz3b5mA==
Date: Mon, 12 Oct 2026 23:07:48 -0700
Subject: [PATCH 10/12] xfs: opportunistically skip btree block checks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179186107354.1898400.14963103476075928588.stgit@frogsfrogsfrogs>
In-Reply-To: <179186107061.1898400.3978552773417541744.stgit@frogsfrogsfrogs>
References: <179186107061.1898400.3978552773417541744.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM notices that both callers of xchk_btree_get_block will return
early if *pblock is NULL after a successful return.  However,
xchk_btree_get_block itself can return 0 after flagging a corruption.
There's no point in continuing after we've found a corruption, so null
the pointer out.

Cc: <stable@vger.kernel.org> # v4.15
Fixes: cc3e0948d2686f ("xfs: scrub the shape of a metadata btree")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/btree.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 786b1e7c4dc37f..17bd8505be0411 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -602,6 +602,14 @@ xchk_btree_get_block(
 	xfs_btree_get_block(bs->cur, level, pbp);
 	if (__xfs_btree_check_block(bs->cur, *pblock, level, *pbp)) {
 		xchk_btree_set_corrupt(bs->sc, bs->cur, level);
+		/*
+		 * The btree block fails basic checks, so we know it's corrupt.
+		 * There's no need to continue looking for corruptions, so we
+		 * null out pblock.  If *pbp is non-null then it's also
+		 * attached to the transaction so we won't leak it despite the
+		 * 0 return code.
+		 */
+		*pblock = NULL;
 		return 0;
 	}
 	if (*pbp)

