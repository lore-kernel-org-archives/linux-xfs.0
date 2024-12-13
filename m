Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E801417BA1
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734051980; cv=none; b=emvz7JWQ6olPmal1DQVMlqzJLzVAB+uAJaScHyzULj+H9ZWjBgT+udGXWV4zy8Uxh1po9cn6LlLwMaWFDoEXFKsVKWSdEHs19H4spwIDOc7La6SHfj4zcSI01/m+WFAO2HeGvWEoMfUkLvUfQnPpgOKVByfL+EYxkjy8mAT0Dio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734051980; c=relaxed/simple;
	bh=u8ozKaDkby0EGSEkZSeU0azHy5Dy+AO8Rj5gt3NIrC0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O61NFwsx6H1TZA8CMyK1okWuqhtHKhBUMpsmpWGzQL+V0kM0KYVJWNmLepHPIrElAviy1mfCgC6JsJwicsrQ5VfOrBuIvtzZ+Fcuz2Hn+P72rZ2JaZIOUyov11PbONr+cozquMdI2JGm+IhT8qwgTTOSZdk6USibrXFhue0sLfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aXAqA2Co; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aXAqA2Co"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A558C4CECE;
	Fri, 13 Dec 2024 01:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734051979;
	bh=u8ozKaDkby0EGSEkZSeU0azHy5Dy+AO8Rj5gt3NIrC0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aXAqA2CoTpdrDng0Q5gzLwqnFCogaybE47FdYZyxmXYYrFTflCbqmnQdqaZHdJQNW
	 3lLM76wYEtarNdyLWo65+iIkTO+PHgKE92gqXrQu8XjvVHgu/QBR7KV7edePsA+5fP
	 UW3k4yDkP8mah2DXLF7vM97XMGuzkYontbAL/njWUO43748rb4oKzl1GyVTE6UK8MO
	 wGihmpX3SMbsPGLOCGba8iZ1l7FtS1JJq5cnGznj0iTVsBkOFuGBqcpEJC31nQOc6t
	 Atym2DnbaORqyopRW510RfV3JK98T87/oLIvNgj6n4+AG8JOehzS7SsH0d08dUd2zh
	 ll82Vvepz+92g==
Date: Thu, 12 Dec 2024 17:06:19 -0800
Subject: [PATCH 22/37] xfs: cross-reference realtime bitmap to realtime rmapbt
 scrubber
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405123693.1181370.6852059995633084822.stgit@frogsfrogsfrogs>
In-Reply-To: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When we're checking the realtime rmap btree entries, cross-reference
those entries with the realtime bitmap too.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/rtrmap.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)


diff --git a/fs/xfs/scrub/rtrmap.c b/fs/xfs/scrub/rtrmap.c
index 7b5f932bcd947f..515c2a9b02cdae 100644
--- a/fs/xfs/scrub/rtrmap.c
+++ b/fs/xfs/scrub/rtrmap.c
@@ -142,6 +142,20 @@ xchk_rtrmapbt_check_mergeable(
 	memcpy(&cr->prev_rec, irec, sizeof(struct xfs_rmap_irec));
 }
 
+/* Cross-reference with other metadata. */
+STATIC void
+xchk_rtrmapbt_xref(
+	struct xfs_scrub	*sc,
+	struct xfs_rmap_irec	*irec)
+{
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+
+	xchk_xref_is_used_rt_space(sc,
+			xfs_rgbno_to_rtb(sc->sr.rtg, irec->rm_startblock),
+			irec->rm_blockcount);
+}
+
 /* Scrub a realtime rmapbt record. */
 STATIC int
 xchk_rtrmapbt_rec(
@@ -162,6 +176,7 @@ xchk_rtrmapbt_rec(
 
 	xchk_rtrmapbt_check_mergeable(bs, cr, &irec);
 	xchk_rtrmapbt_check_overlapping(bs, cr, &irec);
+	xchk_rtrmapbt_xref(bs->sc, &irec);
 	return 0;
 }
 

