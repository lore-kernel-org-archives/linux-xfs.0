Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DA738396
	for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 21:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714168561; cv=none; b=Il18EaD2BLsDgUet5s9d+bQ7wYP5o77NruLd+WjlCIRRk5zDN9fujvpI3JT/mK1t9ffxpyiSOOhepLysuxYBm3VJNVzhwKfqPoHb9SU0VLZ2YbVskfmSrR5wAdBtlVfqMUTWFwIve5PrxIxWsF1VN18TRTbwqwe99UK6Bsd3sK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714168561; c=relaxed/simple;
	bh=88ugbT2+2h1rA4xQ9NmilQ8m7sDInZEAkSGSZP/ec10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfZiRgKYZ7AxzsQQd9t+/T3bzJFotnsxGl5uXlJOq1apAafcR0swpzPz4RbOd6oPmrplz194eKD9ljG/xU0MQnt85d/3CqZOYaM8BtoMcXhYazrmxe4NqnTf834veXa7sQkX/TT3AsAg8EhH6KP4Qdbhrs7DTm6cSp2u/Fk7+/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QozMBnBg; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QozMBnBg"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1e5715a9ebdso22928065ad.2
        for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 14:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714168559; x=1714773359; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5hEYT4tYL+S9lZVDsXBSgwcpHE3A/zFneyiGShU8eKg=;
        b=QozMBnBgYmIfvIrlJUv7tPjzfodkS0LtE8bnVdReVzCKuKgFGW2lhVb8bOco1QBSF/
         cvJfr7CL1UBDtvssd1gGzIFcFSBuKrs2acsECIXKO+B9C12naeUxw0/iuPVLTrC3sbHG
         xaL9mdOTD6T8Uv0FKvyZPLKbvQ257yb8fgANOIxen/WvekUp9mdawfl/upeQ63drDdyB
         a5XvRO0SNUPTDAkYLphIkZRg+AowLAwuK1uFmpemNgwXMoNb8C3MPu9GXRgjTBy8nF7g
         z45KM8z045g6FvSgdqguSPPNRQyyLa8nk1kUR2DNftdSJz0ESJcQdzujVEPO/7/0ij+M
         3yJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714168559; x=1714773359;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5hEYT4tYL+S9lZVDsXBSgwcpHE3A/zFneyiGShU8eKg=;
        b=ML8TETpMOuUWvC2WZgyVM6ptXkHTrczGOTRhp8gGcybKPZ1ZUpJLiXFNp1VlBCSVMq
         0Mdiszl3Gln1nY3LwWIy8+FKhuZLrwWFisf8Ymd8gAxHkPCHmZxU+QHXP6YjM4F9kLLD
         i++uht8O+PAP9VgcV8xb6sjHgN3VNlc+ph2ETa+036S90Abcy3n3tq50sgZzc9PfB16v
         P3YzwMGKIHEohaSCCqm05I7jcyCBJ98DgAcmisbZg9TYRCT9dA3cIY4zOcROq5R6MWu3
         fd9sFRXMeZqlNn7r8ahXbw9Ux/Q0njkMOxZvOB+v8WKNu33bbt95y3W5/9EeITi0nMDY
         0txA==
X-Gm-Message-State: AOJu0Yy0kZvrQeuRU2G6L8NNBNTXE2eoSWuDcKUXFlqGaci4SKSrIsn5
	y72QZGfeHz4y3KgQgv3lrx23br/mNB/nFtVGD6suMzraqOeTLcec4yQXBWUv
X-Google-Smtp-Source: AGHT+IHbYvPM/dAnU7KBKHTKFz3EjdkIiHBksTHcA+p1QSY+bolYVeZw9tE8HNvOhbAh5OgpLHqccQ==
X-Received: by 2002:a17:902:d50a:b0:1e4:436e:801b with SMTP id b10-20020a170902d50a00b001e4436e801bmr1186583plg.67.1714168559105;
        Fri, 26 Apr 2024 14:55:59 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2b3a:c37d:d273:a588])
        by smtp.gmail.com with ESMTPSA id b18-20020a170903229200b001eb2e6b14e0sm855772plh.126.2024.04.26.14.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 14:55:58 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	mngyadam@amazon.com,
	Dave Chinner <dchinner@redhat.com>,
	Pengfei Xu <pengfei.xu@intel.com>,
	Brian Foster <bfoster@redhat.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 10/24] xfs: fix off-by-one-block in xfs_discard_folio()
Date: Fri, 26 Apr 2024 14:54:57 -0700
Message-ID: <20240426215512.2673806-11-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
In-Reply-To: <20240426215512.2673806-1-leah.rumancik@gmail.com>
References: <20240426215512.2673806-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 8ac5b996bf5199f15b7687ceae989f8b2a410dda ]

The recent writeback corruption fixes changed the code in
xfs_discard_folio() to calculate a byte range to for punching
delalloc extents. A mistake was made in using round_up(pos) for the
end offset, because when pos points at the first byte of a block, it
does not get rounded up to point to the end byte of the block. hence
the punch range is short, and this leads to unexpected behaviour in
certain cases in xfs_bmap_punch_delalloc_range.

e.g. pos = 0 means we call xfs_bmap_punch_delalloc_range(0,0), so
there is no previous extent and it rounds up the punch to the end of
the delalloc extent it found at offset 0, not the end of the range
given to xfs_bmap_punch_delalloc_range().

Fix this by handling the zero block offset case correctly.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=217030
Link: https://lore.kernel.org/linux-xfs/Y+vOfaxIWX1c%2Fyy9@bfoster/
Fixes: 7348b322332d ("xfs: xfs_bmap_punch_delalloc_range() should take a byte range")
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Found-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_aops.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index a22d90af40c8..21c241e96d48 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -439,15 +439,17 @@ xfs_prepare_ioend(
 }
 
 /*
- * If the page has delalloc blocks on it, we need to punch them out before we
- * invalidate the page.  If we don't, we leave a stale delalloc mapping on the
- * inode that can trip up a later direct I/O read operation on the same region.
+ * If the folio has delalloc blocks on it, the caller is asking us to punch them
+ * out. If we don't, we can leave a stale delalloc mapping covered by a clean
+ * page that needs to be dirtied again before the delalloc mapping can be
+ * converted. This stale delalloc mapping can trip up a later direct I/O read
+ * operation on the same region.
  *
- * We prevent this by truncating away the delalloc regions on the page.  Because
+ * We prevent this by truncating away the delalloc regions on the folio. Because
  * they are delalloc, we can do this without needing a transaction. Indeed - if
  * we get ENOSPC errors, we have to be able to do this truncation without a
- * transaction as there is no space left for block reservation (typically why we
- * see a ENOSPC in writeback).
+ * transaction as there is no space left for block reservation (typically why
+ * we see a ENOSPC in writeback).
  */
 static void
 xfs_discard_folio(
@@ -465,8 +467,13 @@ xfs_discard_folio(
 		"page discard on page "PTR_FMT", inode 0x%llx, pos %llu.",
 			folio, ip->i_ino, pos);
 
+	/*
+	 * The end of the punch range is always the offset of the the first
+	 * byte of the next folio. Hence the end offset is only dependent on the
+	 * folio itself and not the start offset that is passed in.
+	 */
 	error = xfs_bmap_punch_delalloc_range(ip, pos,
-			round_up(pos, folio_size(folio)));
+				folio_pos(folio) + folio_size(folio));
 
 	if (error && !xfs_is_shutdown(mp))
 		xfs_alert(mp, "page discard unable to remove delalloc mapping.");
-- 
2.44.0.769.g3c40516874-goog

