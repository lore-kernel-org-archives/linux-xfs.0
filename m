Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792979646;
	b=di8FBnXzbbolkXv0eWM0+U8bK8JQkzwh/gZz5RHJ0Pjus1Lw21U76tZdilDsxGQjK690
	 tsYUygDgeCug/nyVlDxvp1Bj7L0TJBEQaYYqUvvC7XClgtUd1+p0usCX4BSie7VnXyreR
	 YcH3nxf2WLtz8dgPvrq653VMFhX8X5BQTJ4IUh3bXtA0IaTb6EsAgs+nm+ywvLDvxhyhu
	 RZqcrzd9yTOjXp2eNaqRooBhiDyvnDI0Z90iFyz4HuKbSmzf3adBF1uig30AUQoi0gdbM
	 QnU5DYBRJOVOiUu02PkGs58evGj4jiVcYs06u5fC6bbqz+WaY+sl3FWLLFGANfoLPGA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792979646;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=i1Tx8qcEwpxZFCisgTAJsyZfyWhKAw8yYPdhlkU0ob8=;
	b=lplNpBLGtDr51VgoaMRk1kHkSmmnYWqykCj3F9Ia5uCgF4V5qw+ng/bes+quU5uMc+td
	 IAyQawhHpLxMCt7XkECxdRoLN0BaC5lZH7LpK0mnZ4wvhO+8oUoKr25b94DMT96OsjjZ9
	 IPEnoxSVVEPyIX5UgxwuKATBNYdumQMC8pqIUFqWzv6VCH95Psx2yAovCoVbA5wKShUjV
	 PIeuBlEizyVUc8EN7JXyn0475/Dr/sPEODU7PvvjlQmnPBak2fx7TYfVNOVq7FXF9KgZH
	 howZW8gfgpYIiVuQ1iDTh/g929rPldCIrFRFhMdIE4s//W7UGhNO698AP9oIFpoej+w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HKfTFt+1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6103E606A31A;
	Mon, 26 Oct 2026 01:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HKfTFt+1
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792979646;
	b=Sc75ICtV6zfk9NjjTKIpcVGQ7oS8cjfU6tNyIwWJj8WH5mLALnBANjyMrI0p3PFqMrMB
	 bxBiFui/JA4d+HuxSU+fIJFk6dQtUsfGAG9qdPxAVtuFMj/Fvw7NhzwOz1r2L2+LzGM/M
	 GTGanbtZTjuLfSyyIFmipB5hv310r7nr06nYPYK8YyOb7LbOb2x6X51eRGCPeSFbVYeS7
	 GEy1sSGETXUWGBFAGX+uaYr3cJm73sbSW/v5/7tyM1nphKO4/Y2HTbWGMq+6ZoN5hqPGW
	 tESoIN01iRUJQJ/t5xpfTzlv2mJu7KYFl2z1EvR5wCFR0PdzdL4eb3uNCWV+wD4Ntqw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792979646;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=i1Tx8qcEwpxZFCisgTAJsyZfyWhKAw8yYPdhlkU0ob8=;
	b=XzsqI8YteZaEAbAo1ndLUqD5cVAKp5lTV4DHZH9OhFsChRM7l7a6nXveiXIbUBt1XSc6
	 ZFnJYfcCCK0+b2qpti98bu7GgQ0GfCwOFFlr83hD6d3d3nGQ8Rx55dV3MLjvk8G2yvcIf
	 JuaqHjptV23HPf2e/p6MGxR58ZdYnFsMe1ku9GXFIJ+zDsEprOzV9cgaG4hTOYfYs5peB
	 Uu1nVJwtJgAc3AZZwIfhXCjtBMgK/Yxri6ZoQu1T5K1hArBohW3GXTu1DCjf7jkjKSTBa
	 flN6LtrvCKg0N+naYA+i62ThKa2uqGf6lo69zd8KrKijBmv8W719Hi06du3SVZ0s8Ew==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 6966F1F01828;
	Mon, 26 Oct 2026 01:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792979645;
	bh=i1Tx8qcEwpxZFCisgTAJsyZfyWhKAw8yYPdhlkU0ob8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=HKfTFt+1v38Y/198GIvGrHfBE+D9Sd6HN224kzR80O+y1Ewzp2/wEQH0t2WAJq2Hx
	 3A/258KfgfAiBa++luJju2KcjHGjmKt9opY2wkcdZ+CFuZqNFAirmSdU41AfCZj7OE
	 Qyf/95CONzOiYgjHyYxytNAQjPsipBIk3M9eR5hnq7t1UCucXEXc8yiInOZNFbFJVJ
	 Tv5Smhi6Ajk6w1t/BJty3/xUp3/4mjcH3F1zCiNTGu/dku6CMSsRQLM9zRCmGxvW/P
	 UvnrDmFAQDV9Yh4lYjOh9hfS6bHGDNtyIsKX29jOSiBH8BGxt7L0gPQ2ZNSgPrSwP+
	 +K6PHrWyqStQw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id CB9CD44B76;
	Mon, 26 Oct 2026 01:54:04 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Mon, 26 Oct 2026 10:54:05 +0900
Subject: [PATCH 1/2] xfs: don't skip free extents in later batches of a
 whole-AG FITRIM
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261026-xfs-fitrim-skip-v1-1-cddd8414f99c@samsung.com>
References: <20261026-xfs-fitrim-skip-v1-0-cddd8414f99c@samsung.com>
In-Reply-To: <20261026-xfs-fitrim-skip-v1-0-cddd8414f99c@samsung.com>
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <dgc@kernel.org>, 
 Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792979644; l=2664;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=DE365ED791/wL0LS/rT/QAJXNoFtBUJ5xTlLjkGgwvg=;
 b=g/3nDUd4lVQpRloxEOxvQahx9DatIYcS7ZBFC0N1+fRSDlymFNElW9xpALEYpmKvuqI6eYdXg
 91u87HoOC9oD+fBH5cKgcnRbK6vpyUtnVtNh87ZLwhXnWRwwWPD1bfG
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

A whole-device FITRIM walks every AG but the last by length, in
batches. xfs_trim_gather_extents() saves the record to restart from in
tcur->start. But tcur->start is also the start of the range to trim.
Later batches therefore never discard the free extents below that
block.

Save the restart record in a new restart_bno field.

Cc: stable@vger.kernel.org # v6.10
Fixes: b0ffe661fab4 ("xfs: fix performance problems when fstrimming a subset of a fragmented AG")
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
In the first layout of the new fstests case xfs/842, 409 of 512 free
extents that held data were not discarded without this patch, and none
with it.
---
 fs/xfs/xfs_discard.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 906221ffe9..8120f136af 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -155,6 +155,8 @@ struct xfs_trim_cur {
 	xfs_agblock_t	end;
 	xfs_extlen_t	minlen;
 	bool		by_bno;
+	/* restart point (with count) for the by-length walk */
+	xfs_agblock_t	restart_bno;
 };
 
 static int
@@ -198,14 +200,15 @@ xfs_trim_gather_extents(
 		error = xfs_alloc_lookup_le(cur, tcur->start, 0, &i);
 		if (!error && !i)
 			error = xfs_alloc_lookup_ge(cur, tcur->start, 0, &i);
-	} else if (tcur->start == 0) {
+	} else if (tcur->restart_bno == NULLAGBLOCK) {
 		/* first time through a by-len starts with max length */
 		cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
 		error = xfs_alloc_lookup_ge(cur, 0, tcur->count, &i);
 	} else {
 		/* nth time through a by-len starts where we left off */
 		cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
-		error = xfs_alloc_lookup_le(cur, tcur->start, tcur->count, &i);
+		error = xfs_alloc_lookup_le(cur, tcur->restart_bno,
+					    tcur->count, &i);
 	}
 	if (error)
 		goto out_del_cursor;
@@ -235,9 +238,15 @@ xfs_trim_gather_extents(
 		if (--batch <= 0) {
 			/*
 			 * Update the cursor to point at this extent so we
-			 * restart the next batch from this extent.
+			 * restart the next batch from this extent. The
+			 * by-length walk does not visit extents in block
+			 * order, so it must keep the start of the range and
+			 * restart from restart_bno instead.
 			 */
-			tcur->start = fbno;
+			if (tcur->by_bno)
+				tcur->start = fbno;
+			else
+				tcur->restart_bno = fbno;
 			tcur->count = flen;
 			break;
 		}
@@ -340,6 +349,7 @@ xfs_trim_perag_extents(
 		.start		= start,
 		.end		= end,
 		.minlen		= minlen,
+		.restart_bno	= NULLAGBLOCK,
 	};
 	int			error = 0;
 

-- 
2.43.0


