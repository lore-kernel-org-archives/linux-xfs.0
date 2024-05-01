Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4590155330;
	Wed,  1 May 2024 18:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714588888; cv=none; b=qZu/MQ9ZmmGwT7DiB3d5ISWccn1VHbDcZjnZ7ovXv5OtWFVntbtRqq0GqEaos4Q1f19pWHjctVHOqJyNc+6H2obB4v0fHSUXNQypd3BcNOXe+Heod5Ynn5wqMajLREp1hwJNori/miy04i2wre87hSnyOvwWQY1IVXKu6jTP/80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714588888; c=relaxed/simple;
	bh=I4Yp+4XHnPd7PZl9zUVRdylTuYEh3FfWWTiDT5jhk2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gAcBATF3Erel3aS1aFLypjaScccG3kQCaGHzX8UkmXqagUhcXyajRDwuuZDTFxwn46NM0qF051JIea/uaG4fe83CaLSyGJn7FqqE8lZZd3pau/V9JEsjRyeY3y494ShkcRERDO+TbSLOB3R5cEuPK3DWoq9BbCD0FFzUCXhKMS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GT8YZ4Cq; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GT8YZ4Cq"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6ed3cafd766so6413860b3a.0;
        Wed, 01 May 2024 11:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714588886; x=1715193686; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EBLeEVPALfZF73MVv9o2CMuCZBN5rHK7j5udd9TJd+U=;
        b=GT8YZ4Cqst+l+8z/qkZZjVH/CA3yjMz1Hu1gaCf7EYBNFXeqOa1MNM4ehgVTNemjmt
         xop0yDpF/xu3SAnNlOYbtdlr9sjOUsBOOWOGQuVeL0L/b+2DuQq5paO7DOFfIWQD2Ze3
         7nPx6TnyYsDYKmsU2BDzoLvkbyHcpePAo+M36wDDJ29L3eYvYZVF1FV/TH5/xzOsO6YV
         kC94VyDQHxH5+TX4L+bqedceAb7skiZK9rNaRyTs2Joi/a75T2cyDNUUYBb+3bKG6eex
         XNYlVmDvRsVaDLKfig1rYTHDOLLfE2xAEflTLO/Eft+cFfeIpDRlcaer29X5Yn9qx4N7
         mDxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714588886; x=1715193686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EBLeEVPALfZF73MVv9o2CMuCZBN5rHK7j5udd9TJd+U=;
        b=ZglWUeVrZL2FUYx0tS2cNFzQ2ZgrF49wkteYvTDWXZerL6tbf83uAhU5u85PRssZ7W
         639ct1YpZ3uLaFkmIgYGRe9w7fWEB3oD0s4QbqFu7MY4nklxYdoCKsOS6bDJCXmBvdgI
         97bgUwTKe29RY6PL886jWVvYCwC/qS0s9KOW5DwsmPDdd1BwI5oXeibcAKp9bcQ4mAt7
         oLczRkU1z1ncdsxs7Qr89QvfP/rRcf5MFXTIe1LHoTPYDSn8jCUSWNagg7XRTwFT1We2
         AqRWAa6qv3nRU2D1DSWpeY60Olbbhv+M71rcZxbLIcckB82VXDRIIk+5z/06Cvsfm6ro
         ELwQ==
X-Gm-Message-State: AOJu0YxqPVoV3JkxSf1qv5gZwvdBAgMvg9/6C/liHd8JnlodFgNQ1zKj
	nPz33Jwids421k7UrxOu7wYqMDtdlrqTWShVryoOUlpVCiCweYHVqLmYvUe6
X-Google-Smtp-Source: AGHT+IHAS8IY1VKRNVItDxBx911qPgokamiDa0DOmEYPqmOfyV/lqci0PSgnv6S49T+5w0vpQt/zDQ==
X-Received: by 2002:a05:6a00:4b0d:b0:6ed:332:ffbc with SMTP id kq13-20020a056a004b0d00b006ed0332ffbcmr4228437pfb.20.1714588885955;
        Wed, 01 May 2024 11:41:25 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:9dbc:724d:6e88:fb08])
        by smtp.gmail.com with ESMTPSA id j18-20020a62e912000000b006e681769ee0sm23687369pfh.145.2024.05.01.11.41.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 11:41:25 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	Dave Chinner <dchinner@redhat.com>,
	Pengfei Xu <pengfei.xu@intel.com>,
	Brian Foster <bfoster@redhat.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 10/24] xfs: fix off-by-one-block in xfs_discard_folio()
Date: Wed,  1 May 2024 11:40:58 -0700
Message-ID: <20240501184112.3799035-10-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
In-Reply-To: <20240501184112.3799035-1-leah.rumancik@gmail.com>
References: <20240501184112.3799035-1-leah.rumancik@gmail.com>
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
Acked-by: Darrick J. Wong <djwong@kernel.org>
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
2.45.0.rc1.225.g2a3ae87e7f-goog

